using DataAccessLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ERP.OMS.Management.Activities
{
    public partial class PosSalesinvoiceAdminEdit : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            PaymentDetails.doc_type = "POS";
            if (Request.QueryString["key"] != "ADD")
            {
                PaymentDetails.StorePaymentDetailsToHiddenfield(Convert.ToInt32(Request.QueryString["id"]));
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                btnmanualReceipt.Enabled = false;
                if (Request.QueryString["id"] != null)
                {
                    string ID = Request.QueryString["id"];
                    SetInvoiceDetails(ID);
                    divSelectField.Style.Add("display", "block");
                    divUpdateButton.Style.Add("display", "block");
                }
                else
                {

                }
            }
        }

        protected void SetInvoiceDetails(string invoiceId)
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_posAdminUpdate");
            proc.AddVarcharPara("@action", 50, "GetInvoiceDetails");
            proc.AddVarcharPara("@InvoiceId", 10, invoiceId);
            ds = proc.GetDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow invoiceRow = ds.Tables[0].Rows[0];
                txtInvoiceNumber.Text = invoiceRow["Invoice_Number"].ToString();
                PaymentDetails.Setbranchvalue(invoiceRow["Invoice_BranchId"].ToString());
                txtDownPayment.Text = invoiceRow["Pos_downPayment"].ToString();
                txtEmiCard.Text = invoiceRow["Pos_EmiOther_charges"].ToString();
                txtProcFee.Text = invoiceRow["Pos_ProcFee"].ToString();

                if (invoiceRow["Pos_EntryType"].ToString() != "Fin")
                {
                    txtDownPayment.Enabled = false;
                    txtEmiCard.Enabled = false;
                    txtProcFee.Enabled = false;
                }
                else {
                    txtDownPayment.Enabled = true;
                    txtEmiCard.Enabled = true;
                    txtProcFee.Enabled = true;
                }
            }
            if (ds.Tables[1].Rows.Count > 0) {
                DataRow billingRow = ds.Tables[1].Rows[0];
                txtBillingAddress1.Text =Convert.ToString( billingRow["InvoiceAdd_address1"]);
                txtBillingAddress2.Text = Convert.ToString(billingRow["InvoiceAdd_address2"]);
                txtBillingAddress3.Text = Convert.ToString(billingRow["InvoiceAdd_address3"]);
                txtBillingLandMark.Text = Convert.ToString(billingRow["InvoiceAdd_landMark"]);
                txtBillingPin.Text = Convert.ToString(billingRow["pin_code"]);
            }
            if (ds.Tables[2].Rows.Count > 0)
            {
                DataRow billingRow = ds.Tables[2].Rows[0];
                txtShippingAddress1.Text = Convert.ToString(billingRow["InvoiceAdd_address1"]);
                txtShippingAddress2.Text = Convert.ToString(billingRow["InvoiceAdd_address2"]);
                txtShippingAddress3.Text = Convert.ToString(billingRow["InvoiceAdd_address3"]);
                txtShippingLandmark.Text = Convert.ToString(billingRow["InvoiceAdd_landMark"]);
                txtShippingPin.Text = Convert.ToString(billingRow["pin_code"]);
            }



        }

        protected void btn_Update_Click(object sender, EventArgs e)
        {
            string updateValue = UpdateField.SelectedValue.ToString();
            switch (updateValue)
            {
                case "docNo":
                    UpdateDocumentNumber();
                    break;
                case "PaymnetDetails":
                    UpdatePaymentDetails();
                    break;
                case "BillingShipping":
                    updateBillingShipping();
                    break;
                case "FinanceBlock":
                    UpdateFinancerDetails();
                    break;
                case "repost":
                    RePostBalance();
                    break;
            }
            UpdateField.SelectedIndex = 0;
        }

        protected void RePostBalance()
        {
            ProcedureExecute proc = new ProcedureExecute("prc_updatePosAdmin");
            proc.AddVarcharPara("@action", 50, "RePostbalance");
            proc.AddVarcharPara("@InvoiceId", 10, Request.QueryString["id"]);
            proc.AddIntegerPara("@userId", Convert.ToInt32(Session["userid"]));
            proc.RunActionQuery();

            string OutputMsg = proc.GetParaValue("@output").ToString();
            Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>ShowMsg('" + OutputMsg + "');</script>");
        }
        protected void UpdateFinancerDetails()
        {
            ProcedureExecute proc = new ProcedureExecute("prc_updatePosAdmin");
            proc.AddVarcharPara("@action", 50, "UpdateFinanceDetails");
            proc.AddVarcharPara("@InvoiceId", 10, Request.QueryString["id"]);
            proc.AddIntegerPara("@userId", Convert.ToInt32(Session["userid"]));
            proc.AddDecimalPara("@processeingFee", 2, 18, Convert.ToDecimal(txtProcFee.Text));
            proc.AddDecimalPara("@EmiCardCharges", 2, 18, Convert.ToDecimal(txtEmiCard.Text));
            proc.AddDecimalPara("@DownPayment", 2, 18, Convert.ToDecimal(txtDownPayment.Text));
            proc.AddVarcharPara("@output", 100, "", QueryParameterDirection.Output);
            proc.RunActionQuery();

            string OutputMsg = proc.GetParaValue("@output").ToString();
            Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>ShowMsg('" + OutputMsg + "');</script>");

        }
        protected void updateBillingShipping() 
        {
            ProcedureExecute proc = new ProcedureExecute("prc_updatePosAdmin");
            proc.AddVarcharPara("@action", 50, "UpdateBillingShipping");
            proc.AddVarcharPara("@InvoiceId", 10, Request.QueryString["id"]);
            proc.AddIntegerPara("@userId", Convert.ToInt32(Session["userid"]));
            proc.AddVarcharPara("@BillingPinCode", 6, txtBillingPin.Text.Trim());
            proc.AddVarcharPara("@Billingaddress1", 80, txtBillingAddress1.Text.Trim());
            proc.AddVarcharPara("@Billingaddress2", 80, txtBillingAddress2.Text.Trim());
            proc.AddVarcharPara("@Billingaddress3", 80, txtBillingAddress3.Text.Trim());
            proc.AddVarcharPara("@Billinglandmark", 80, txtBillingLandMark.Text.Trim());

            proc.AddVarcharPara("@ShippingPinCode", 6, txtShippingPin.Text.Trim());
            proc.AddVarcharPara("@Shippingaddress1", 80, txtShippingAddress1.Text.Trim());
            proc.AddVarcharPara("@Shippingaddress2", 80, txtShippingAddress2.Text.Trim());
            proc.AddVarcharPara("@Shippingaddress3", 80, txtShippingAddress3.Text.Trim());
            proc.AddVarcharPara("@Shippinglandmark", 80, txtShippingLandmark.Text.Trim());

            proc.AddVarcharPara("@output", 100, "", QueryParameterDirection.Output);
            proc.RunActionQuery();

            string OutputMsg = proc.GetParaValue("@output").ToString();
            Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>ShowMsg('" + OutputMsg + "');</script>");
        
        }
        protected void UpdatePaymentDetails()
        {

            DataSet dsInst = new DataSet();
            DataTable paymentDetails = PaymentDetails.GetPaymentTable();
            SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            SqlCommand cmd = new SqlCommand("prc_updatePosAdmin", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@action", "UpdatePaymentDetails");
            cmd.Parameters.AddWithValue("@InvoiceId", Request.QueryString["id"]);
            cmd.Parameters.AddWithValue("@userId", Convert.ToInt32(Session["userid"]));
            cmd.Parameters.AddWithValue("@paymentDetails", paymentDetails);
            cmd.Parameters.Add("@output", SqlDbType.VarChar, 100);
            cmd.Parameters["@output"].Direction = ParameterDirection.Output;
            cmd.CommandTimeout = 0;
            SqlDataAdapter Adap = new SqlDataAdapter();
            Adap.SelectCommand = cmd;
            Adap.Fill(dsInst);

            string OutputMsg = cmd.Parameters["@output"].Value.ToString();
            Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>ShowMsg('" + OutputMsg + "');</script>");
            cmd.Dispose();
            con.Dispose();
        }
        protected void UpdateDocumentNumber()
        {
            string InvoiceNumber = txtInvoiceNumber.Text.Trim();

            ProcedureExecute proc = new ProcedureExecute("prc_updatePosAdmin");
            proc.AddVarcharPara("@action", 50, "UpdateDocumentNumber");
            proc.AddVarcharPara("@InvoiceId", 10, Request.QueryString["id"]);
            proc.AddVarcharPara("@InvoiceNumber", 30, InvoiceNumber);
            proc.AddIntegerPara("@userId", Convert.ToInt32(Session["userid"]));
            proc.AddVarcharPara("@output", 100, "", QueryParameterDirection.Output);
            proc.RunActionQuery();

            string OutputMsg = proc.GetParaValue("@output").ToString();
            Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>ShowMsg('" + OutputMsg + "');</script>");
        }

        protected void UpdateManualReceiptNumber()
        {
            string oldReceiptNumber = txtOldReceiptNumber.Text.Trim();
            string newReceiptNUmber = txtNewReceiptNumber.Text.Trim();
            string IbRef = "CPR_" + Session["userid"].ToString() + "_" + Convert.ToString(hdRecPayType.Value) + "_" + newReceiptNUmber.Replace("/", "");
            ProcedureExecute proc = new ProcedureExecute("prc_updatePosAdmin");
            proc.AddVarcharPara("@action", 50, "UpdateManualReceipt");
            proc.AddVarcharPara("@OldNumber", 30, oldReceiptNumber);
            proc.AddVarcharPara("@NewNumber", 30, newReceiptNUmber);
            proc.AddVarcharPara("@IbRef", 30, IbRef);
            proc.AddIntegerPara("@userId", Convert.ToInt32(Session["userid"]));
            proc.AddVarcharPara("@output", 100, "", QueryParameterDirection.Output);
            proc.RunActionQuery();

            string OutputMsg = proc.GetParaValue("@output").ToString();
            lblWrongReceipt.Text = OutputMsg;
            lblWrongReceipt.Visible = true;
            txtNewReceiptNumber.Text = "";
            btnmanualReceipt.Enabled = false;
        }


        [WebMethod]
        public static object GetInvoiceDetails(string invoiceNumber)
        {
            string invoiceId = "";
            ProcedureExecute proc = new ProcedureExecute("prc_updatePosAdmin");
            proc.AddVarcharPara("@action", 50, "GetInvoiceDetails");
            proc.AddVarcharPara("@InvoiceNumber", 30, invoiceNumber);
            DataTable dt = proc.GetTable();
            if (dt.Rows.Count > 0)
            {
                invoiceId = dt.Rows[0]["Invoice_Id"].ToString();
            }
            var returnObject = new { status = "Ok", invoiceId = invoiceId };

            return returnObject;
        }

        protected void ManualReceipt_WindowCallback(object source, DevExpress.Web.PopupWindowCallbackArgs e)
        {
            lblWrongReceipt.Visible = false;
            string callBackPara = e.Parameter;
            if (callBackPara == "validateReceiptNumber")
            {

                string OldCustRecPayNumber = txtOldReceiptNumber.Text.Trim();
                DataTable ds = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_posAdminUpdate");
                proc.AddVarcharPara("@action", 50, "validateCustRecpay");
                proc.AddVarcharPara("@DocumentNumber", 30, OldCustRecPayNumber);
                ds = proc.GetTable();

                if (ds.Rows.Count > 0)
                {
                    txtNewReceiptNumber.Text = OldCustRecPayNumber;
                    btnmanualReceipt.Enabled = true;
                    txtOldReceiptNumber.Enabled = false;
                    hdRecPayType.Value = Convert.ToString(ds.Rows[0]["ReceiptPayment_TransactionType"]).Trim();
                }
                else
                {
                    lblWrongReceipt.Visible = true;
                    hdRecPayType.Value = "";
                }
            }
            else if (callBackPara == "UpdateManualReceipt")
            {
                UpdateManualReceiptNumber();

            }
        }

    }
}