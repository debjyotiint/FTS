using BusinessLogicLayer;
using DataAccessLayer;
using DevExpress.Web;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace ERP.OMS.Management.Activities.UserControls
{
    public partial class TermsConditionsControl : System.Web.UI.UserControl
    {
        BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    #region Show T&C
                    string Variable_Name = string.Empty;
                    if (Request.QueryString["type"] != null && Convert.ToString(Request.QueryString["type"]) != "")
                    {
                        string Type = Convert.ToString(Request.QueryString["type"]);
                        Variable_Name = "Show_TC_" + Type;
                    }
                    else
                    {
                        try
                        {
                            HiddenField ctl = (HiddenField)this.Parent.FindControl("hfTermsConditionDocType");
                            string DocType = ctl.Value;
                            Variable_Name = "Show_TC_" + DocType;
                        }
                        catch (Exception ex) { Variable_Name = "Show_TC_SO"; }
                    }

                    DataTable DT = objEngine.GetDataTable("Config_SystemSettings", " Variable_Value ", " Variable_Name='" + Variable_Name + "' AND IsActive=1");

                    if (DT != null && DT.Rows.Count > 0)
                    {
                        string IsVisible = Convert.ToString(DT.Rows[0]["Variable_Value"]).Trim();

                        if (IsVisible == "Yes")
                        {
                            this.Visible = true;
                        }
                        else
                        {
                            this.Visible = false;
                        }
                    }
                    #endregion
                    #region Show & Hide purchase module specefic field
                    HiddenField hidden_DocType = (HiddenField)this.Parent.FindControl("hfTermsConditionDocType");
                    string DType = hidden_DocType.Value;
                    if (DType == "PO" || DType == "PC" || DType == "PB")
                    {
                        pnlpurchasemodulefields.Style.Add(HtmlTextWriterStyle.Display, "block");
                    }
                    else
                    {
                        pnlpurchasemodulefields.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }
                    #endregion
                    #region Bind Transporter DropDown
                    DataTable DT_TR = GetTransporterBYLegalStatus(55);
                    if (DT_TR.Rows.Count > 0)
                    {
                        cmbtrnsprtrname.Items.Clear();
                        cmbtrnsprtrname.DataSource = DT_TR;
                        cmbtrnsprtrname.DataBind();
                        cmbtrnsprtrname.Items.Insert(0, new ListEditItem("--Select", 0));
                        cmbtrnsprtrname.SelectedIndex = 0;
                    }
                    #endregion
                    #region Bind Country DropDown
                    DataSet dstDT = GetCountry();
                    if (dstDT.Tables[0] != null && dstDT.Tables[0].Rows.Count > 0)
                    {
                        ddlCountryOfOrigin.TextField = "cou_country";
                        ddlCountryOfOrigin.ValueField = "cou_id";
                        ddlCountryOfOrigin.DataSource = dstDT.Tables[0];
                        ddlCountryOfOrigin.DataBind();
                    }
                    #endregion
                    #region Bind controll
                    if (Request.QueryString["key"] != null && Convert.ToString(Request.QueryString["key"]) != "ADD")
                    {
                        string docid = Convert.ToString(Request.QueryString["key"]);

                        bool flag_Challan = false;
                        bool flag_Invoice = false;
                        bool flag_Approval = false;
                        bool Isvisible = false;

                        if (Request.QueryString["type"] != null && Convert.ToString(Request.QueryString["type"]) != "")
                        {
                            string Type = Convert.ToString(Request.QueryString["type"]);
                            BindTC(docid, Type); //bind existing data

                            switch (Type)
                            {
                                case "SO":
                                    flag_Challan = IsSalesOrderExistsInChallan(docid, "SO") == 1 ? false : true;
                                    flag_Invoice = IsSalesOrderExistsInInvoice(docid, "SO") == 1 ? false : true;
                                    Isvisible = (flag_Challan == false || flag_Invoice == false) ? false : true;
                                    DisableControls(Isvisible);
                                    break;

                                case "PO":
                                    flag_Challan = IsPurchaseOrderExistsInChallan(docid, "PO") == 1 ? false : true;
                                    flag_Invoice = IsPurchaseOrderExistsInInvoice(docid, "PO") == 1 ? false : true;
                                    Isvisible = (flag_Challan == false || flag_Invoice == false) ? false : true;
                                    DisableControls(Isvisible);
                                    break;

                                case "PB":
                                    //flag_Challan = IsPurchaseOrderExistsInChallan(docid, "PB") == 1 ? false : true;
                                    //flag_Invoice = IsPurchaseOrderExistsInInvoice(docid, "PB") == 1 ? false : true;
                                    //Isvisible = (flag_Challan == false || flag_Invoice == false) ? false : true;
                                    //DisableControls(Isvisible);
                                    break;

                                case "SI":
                                    //flag_Challan = IsSalesOrderExistsInChallan(docid, "SI") == 1 ? false : true;
                                    //flag_Invoice = IsSalesOrderExistsInInvoice(docid, "SI") == 1 ? false : true;
                                    //Isvisible = (flag_Challan == false || flag_Invoice == false) ? false : true;
                                    //DisableControls(Isvisible);
                                    break;

                                case "SC":
                                    //flag_Challan = IsSalesOrderExistsInChallan(docid, "SC") == 1 ? false : true;
                                    //flag_Invoice = IsSalesOrderExistsInInvoice(docid, "SC") == 1 ? false : true;
                                    //Isvisible = (flag_Challan == false || flag_Invoice == false) ? false : true;
                                    //DisableControls(Isvisible);
                                    break;

                                case "PC":
                                    //flag_Challan = IsPurchaseOrderExistsInChallan(docid, "PC") == 1 ? false : true;
                                    //flag_Invoice = IsPurchaseOrderExistsInInvoice(docid, "PC") == 1 ? false : true;
                                    //Isvisible = (flag_Challan == false || flag_Invoice == false) ? false : true;
                                    //DisableControls(Isvisible);
                                    break;
                            }
                        }
                        else
                        {
                            DisableControls(true);
                        }
                    }
                    #endregion
                }
                catch (Exception ex) { }
            }
        }
        private void DisableControls(bool Isvisible)
        {
            btnTCsave.Visible = Isvisible;

            dtDeliveryDate.Enabled = Isvisible;
            txtDelremarks.Enabled = Isvisible;
            cmbInsuranceType.Enabled = Isvisible;
            cmbFreightCharges.Enabled = Isvisible;
            txtFreightRemarks.Enabled = Isvisible;
            txtPermitValue.Enabled = Isvisible;
            txtRemarks.Enabled = Isvisible;
            cmbDelDetails.Enabled = Isvisible;
            txtotherlocation.Enabled = Isvisible;
            cmbCertReq.Enabled = Isvisible;
            cmbtrnsprtrname.Enabled = Isvisible;
            cmbDiscntrcv.Enabled = Isvisible;
            txtDiscntrcv.Enabled = Isvisible;
            cmbCommissionRcv.Enabled = Isvisible;
            txtCommissionRcv.Enabled = Isvisible;
        }
        public void BindTC(string docid, string Type)
        {
            try
            {
                DataTable DT = objEngine.GetDataTable("tbl_trans_TermsAndConditions", " * ", " docid='" + docid + "' and doctype = '" + Type + "'");
                if (DT != null && DT.Rows.Count > 0)
                {
                    if (DT.Rows[0]["DeliveryDate"] != null && DT.Rows[0]["DeliveryDate"].ToString() != "")
                    {
                        dtDeliveryDate.Value = Convert.ToDateTime(DT.Rows[0]["DeliveryDate"]);
                    }

                    txtDelremarks.Text = Convert.ToString(DT.Rows[0]["Delremarks"]);

                    if (DT.Rows[0]["insuranceType"] != null && DT.Rows[0]["insuranceType"].ToString() != "")
                    {
                        cmbInsuranceType.SelectedIndex = Convert.ToInt32(DT.Rows[0]["insuranceType"].ToString());
                    }

                    if (DT.Rows[0]["FreightCharges"] != null && DT.Rows[0]["FreightCharges"].ToString() != "")
                    {
                        cmbFreightCharges.SelectedIndex = Convert.ToInt32(DT.Rows[0]["FreightCharges"].ToString());
                    }

                    txtFreightRemarks.Text = Convert.ToString(DT.Rows[0]["FreightRemarks"]);

                    txtPermitValue.Text = Convert.ToString(DT.Rows[0]["PermitValue"]);

                    txtRemarks.Text = Convert.ToString(DT.Rows[0]["Remarks"]);

                    if (DT.Rows[0]["DelDetails"] != null && DT.Rows[0]["DelDetails"].ToString() != "")
                    {
                        cmbDelDetails.SelectedIndex = Convert.ToInt32(DT.Rows[0]["DelDetails"].ToString());
                    }

                    txtotherlocation.Text = Convert.ToString(DT.Rows[0]["otherlocation"]);

                    if (DT.Rows[0]["CertReq"] != null && DT.Rows[0]["CertReq"].ToString() != "")
                    {
                        cmbCertReq.SelectedIndex = Convert.ToInt32(DT.Rows[0]["CertReq"].ToString());
                    }

                    if (DT.Rows[0]["trnsprtrname"] != null && DT.Rows[0]["trnsprtrname"].ToString() != "")
                    {
                        cmbtrnsprtrname.Value = DT.Rows[0]["trnsprtrname"].ToString();
                    }

                    if (DT.Rows[0]["DelDetails"] != null && DT.Rows[0]["DelDetails"].ToString() != "" && Convert.ToInt32(DT.Rows[0]["DelDetails"]) == 3)
                    {
                        pnlotherlocation.Style.Add(HtmlTextWriterStyle.Display, "block");
                    }
                    else
                    {
                        pnlotherlocation.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }

                    if (DT.Rows[0]["trnsprtrname"] != null && DT.Rows[0]["trnsprtrname"].ToString() != "" && DT.Rows[0]["trnsprtrname"].ToString() != "0")
                    {
                        pnlTransporter.Style.Add(HtmlTextWriterStyle.Display, "block");
                    }
                    else
                    {
                        pnlTransporter.Style.Add(HtmlTextWriterStyle.Display, "none");
                    }

                    if (DT.Rows[0]["Discntrcv"] != null && DT.Rows[0]["Discntrcv"].ToString() != "")
                    {
                        cmbDiscntrcv.SelectedIndex = Convert.ToInt32(DT.Rows[0]["Discntrcv"].ToString());
                    }
                    if (DT.Rows[0]["Discntrcv"] != null && DT.Rows[0]["Discntrcv"].ToString() != "" && Convert.ToInt32(DT.Rows[0]["Discntrcv"]) == 0)
                    {
                        pnlDiscntrcv.Style.Add(HtmlTextWriterStyle.Display, "block");
                        txtDiscntrcv.Text = Convert.ToString(DT.Rows[0]["Discntrcvdtls"]);
                    }
                    else
                    {
                        pnlDiscntrcv.Style.Add(HtmlTextWriterStyle.Display, "none");
                        txtDiscntrcv.Text = Convert.ToString(DT.Rows[0]["Discntrcvdtls"]);
                    }

                    if (DT.Rows[0]["CommissionRcv"] != null && DT.Rows[0]["CommissionRcv"].ToString() != "")
                    {
                        cmbCommissionRcv.SelectedIndex = Convert.ToInt32(DT.Rows[0]["CommissionRcv"].ToString());
                    }
                    if (DT.Rows[0]["CommissionRcv"] != null && DT.Rows[0]["CommissionRcv"].ToString() != "" && Convert.ToInt32(DT.Rows[0]["CommissionRcv"]) == 0)
                    {
                        pnlCommissionRcv.Style.Add(HtmlTextWriterStyle.Display, "block");
                        txtCommissionRcv.Text = Convert.ToString(DT.Rows[0]["CommissionRcvdtls"]);
                        txtCommissionRate.Text = Convert.ToString(DT.Rows[0]["CommissionRate"]);
                    }
                    else
                    {
                        pnlCommissionRcv.Style.Add(HtmlTextWriterStyle.Display, "none");
                        txtCommissionRcv.Text = "";
                        txtCommissionRate.Text = "";
                    }

                    //New PO fields
                    if (DT.Rows[0]["TypeOfImport"] != null && DT.Rows[0]["TypeOfImport"].ToString() != "")
                    {
                        ddlTypeOfImport.Value = DT.Rows[0]["TypeOfImport"].ToString();
                    }
                    txtPaymentTrmRemarks.Text = Convert.ToString(DT.Rows[0]["PaymentTrmRemarks"]);
                    if (DT.Rows[0]["IncoDVTerms"] != null && DT.Rows[0]["IncoDVTerms"].ToString() != "")
                    {
                        ddlIncoDVTerms.Value = DT.Rows[0]["IncoDVTerms"].ToString();
                    }
                    txtIncoDVTermsRemarks.Text = Convert.ToString(DT.Rows[0]["IncoDVTermsRemarks"]);
                    txtShippmentSchedule.Text = Convert.ToString(DT.Rows[0]["ShippmentSchedule"]);
                    txtPortOfShippment.Text = Convert.ToString(DT.Rows[0]["PortOfShippment"]);
                    txtPortOfDestination.Text = Convert.ToString(DT.Rows[0]["PortOfDestination"]);
                    if (DT.Rows[0]["PartialShippment"] != null && DT.Rows[0]["PartialShippment"].ToString() != "")
                    {
                        ddlPartialShippment.Value = DT.Rows[0]["PartialShippment"].ToString();
                    }
                    if (DT.Rows[0]["Transshipment"] != null && DT.Rows[0]["Transshipment"].ToString() != "")
                    {
                        ddlTransshipment.Value = DT.Rows[0]["Transshipment"].ToString();
                    }
                    txtPackingSpec.Text = Convert.ToString(DT.Rows[0]["PackingSpec"]);
                    if (DT.Rows[0]["ValidityOfOrderDate"] != null && DT.Rows[0]["ValidityOfOrderDate"].ToString() != "")
                    {
                        dtValidityOfOrder.Value = Convert.ToDateTime(DT.Rows[0]["ValidityOfOrderDate"]);
                    }
                    txtValidityOfOrderRemarks.Text = Convert.ToString(DT.Rows[0]["ValidityOfOrderRemarks"]);
                    if (DT.Rows[0]["CountryOfOrigin"] != null && DT.Rows[0]["CountryOfOrigin"].ToString() != "")
                    {
                        ddlCountryOfOrigin.Value = DT.Rows[0]["CountryOfOrigin"].ToString();
                    }
                    txtFreeDetentionPeriod.Text = Convert.ToString(DT.Rows[0]["FreeDetentionPeriod"]);
                    txtFreeDetentionPeriodRemark.Text = Convert.ToString(DT.Rows[0]["FreeDetentionPeriodRemark"]);

                }
                else
                {
                    dtDeliveryDate.Value = "";
                    txtDelremarks.Text = "";
                    cmbInsuranceType.SelectedIndex = -1;
                    cmbFreightCharges.SelectedIndex = -1;
                    txtFreightRemarks.Text = "";
                    txtPermitValue.Text = "";
                    txtRemarks.Text = "";
                    cmbDelDetails.SelectedIndex = -1;
                    txtotherlocation.Text = "";
                    cmbCertReq.SelectedIndex = -1;
                    cmbtrnsprtrname.SelectedIndex = -1;
                    cmbDiscntrcv.SelectedIndex = -1;
                    txtDiscntrcv.Text = "";
                    cmbCommissionRcv.SelectedIndex = -1;
                    txtCommissionRcv.Text = "";
                    pnlotherlocation.Style.Add(HtmlTextWriterStyle.Display, "none");
                    pnlTransporter.Style.Add(HtmlTextWriterStyle.Display, "none");
                    pnlDiscntrcv.Style.Add(HtmlTextWriterStyle.Display, "none");
                    pnlCommissionRcv.Style.Add(HtmlTextWriterStyle.Display, "none");

                    //New PO fields
                    ddlTypeOfImport.SelectedIndex = -1;
                    txtPaymentTrmRemarks.Text = "";
                    ddlIncoDVTerms.SelectedIndex = -1;
                    txtIncoDVTermsRemarks.Text = "";
                    txtShippmentSchedule.Text = "";
                    txtPortOfShippment.Text = "";
                    txtPortOfDestination.Text = "";
                    ddlPartialShippment.SelectedIndex = -1;
                    ddlTransshipment.SelectedIndex = -1;
                    txtPackingSpec.Text = "";
                    dtValidityOfOrder.Value = "";
                    txtValidityOfOrderRemarks.Text = "";
                    ddlCountryOfOrigin.SelectedIndex = -1;
                    txtFreeDetentionPeriod.Text = "";
                    txtFreeDetentionPeriodRemark.Text = "";
                }
            }
            catch (Exception ex) { }
        }
        public string GetControlValue(string controlID)
        {
            string returnVal = string.Empty;

            switch (controlID)
            {
                case "dtDeliveryDate":
                    returnVal = Convert.ToString(dtDeliveryDate.Value);
                    break;
            }

            return returnVal;

        }
        public bool GetControlVisibility(string controlID)
        {
            bool returnVal = false;

            switch (controlID)
            {
                case "dtDeliveryDate":
                    returnVal = (hfTCspecefiFieldsVisibilityCheck.Value == "1") ? false : true;  //dtDeliveryDate.Visible;
                    break;
            }

            return returnVal;

        }
        public Int32 IsSalesOrderExistsInChallan(string DocId, string DocType)
        {
            DataTable dt = new DataTable();
            int i = 0;
            ProcedureExecute proc = new ProcedureExecute("sp_Tagged_TC");
            proc.AddVarcharPara("@Action", 500, "IsSalesOrderExistsInChallan");
            proc.AddVarcharPara("@DocId", 500, Convert.ToString(DocId));
            proc.AddVarcharPara("@DocType", 500, Convert.ToString(DocType));

            dt = proc.GetTable();
            if (dt != null && dt.Rows.Count > 0)
            {
                if (Convert.ToInt32(dt.Rows[0]["OUTPUT"]) > 0)
                {
                    i = 1;
                }
            }

            return i;
        }
        public Int32 IsSalesOrderExistsInInvoice(string DocId, string DocType)
        {
            DataTable dt = new DataTable();
            int i = 0;
            ProcedureExecute proc = new ProcedureExecute("sp_Tagged_TC");
            proc.AddVarcharPara("@Action", 500, "IsSalesOrderExistsInInvoice");
            proc.AddVarcharPara("@DocId", 500, Convert.ToString(DocId));
            proc.AddVarcharPara("@DocType", 500, Convert.ToString(DocType));

            dt = proc.GetTable();
            if (dt != null && dt.Rows.Count > 0)
            {
                if (Convert.ToInt32(dt.Rows[0]["OUTPUT"]) > 0)
                {
                    i = 1;
                }
            }

            return i;
        }
        public Int32 IsPurchaseOrderExistsInChallan(string DocId, string DocType)
        {
            DataTable dt = new DataTable();
            int i = 0;
            ProcedureExecute proc = new ProcedureExecute("sp_Tagged_TC");
            proc.AddVarcharPara("@Action", 500, "IsPurchaseOrderExistsInChallan");
            proc.AddVarcharPara("@DocId", 500, Convert.ToString(DocId));
            proc.AddVarcharPara("@DocType", 500, Convert.ToString(DocType));

            dt = proc.GetTable();
            if (dt != null && dt.Rows.Count > 0)
            {
                if (Convert.ToInt32(dt.Rows[0]["OUTPUT"]) > 0)
                {
                    i = 1;
                }
            }

            return i;
        }
        public Int32 IsPurchaseOrderExistsInInvoice(string DocId, string DocType)
        {
            DataTable dt = new DataTable();
            int i = 0;
            ProcedureExecute proc = new ProcedureExecute("sp_Tagged_TC");
            proc.AddVarcharPara("@Action", 500, "IsPurchaseOrderExistsInInvoice");
            proc.AddVarcharPara("@DocId", 500, Convert.ToString(DocId));
            proc.AddVarcharPara("@DocType", 500, Convert.ToString(DocType));

            dt = proc.GetTable();
            if (dt != null && dt.Rows.Count > 0)
            {
                if (Convert.ToInt32(dt.Rows[0]["OUTPUT"]) > 0)
                {
                    i = 1;
                }
            }

            return i;
        }
        public Int32 IsDocTypeApproved(string DocId, string DocType)
        {
            DataTable dt = new DataTable();
            int i = 0;
            ProcedureExecute proc = new ProcedureExecute("sp_Tagged_TC");
            proc.AddVarcharPara("@Action", 500, "IsDocTypeApproved");
            proc.AddVarcharPara("@DocId", 500, Convert.ToString(DocId));
            proc.AddVarcharPara("@DocType", 500, Convert.ToString(DocType));

            dt = proc.GetTable();
            if (dt != null && dt.Rows.Count > 0)
            {
                if (Convert.ToInt32(dt.Rows[0]["OUTPUT"]) > 0)
                {
                    i = 1;
                }
            }

            return i;
        }
        private DataTable GetTransporterBYLegalStatus(int lgl_id)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GetTransporterBYLegalStatus");
            proc.AddIntegerPara("@lgl_id", lgl_id);
            dt = proc.GetTable();

            return dt;
        }
        public DataSet GetCountry(string countryID = null)
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_BillingShipping_GetAllCountry");
            proc.AddVarcharPara("@CountryID", 20, countryID);
            ds = proc.GetDataSet();
            return ds;
        }
        public void SaveTC(string TermsConditionData, string DocId, string DocType)
        {
            try
            {
                ProcedureExecute proc = new ProcedureExecute("SP_TC_CRUD");
                proc.AddVarcharPara("@TermsConditionData", 500, TermsConditionData);
                proc.AddVarcharPara("@DocId", 500, DocId);
                proc.AddVarcharPara("@DocType", 500, DocType);
                //DataSet dt = proc.GetDataSet();
                int _Ret = proc.RunActionQuery();
            }
            catch (Exception ex) { }
        }
        public string GetCountryByVendorId(string cntId)
        {
            try
            {
                ProcedureExecute proc = new ProcedureExecute("SP_TC_CRUD");
                proc.AddVarcharPara("@Action", 500, "GetCountryByVendor");
                proc.AddVarcharPara("@cntId", 500, cntId);

                DataTable DT = proc.GetTable();
                if (DT != null && DT.Rows.Count > 0)
                {
                    return Convert.ToString(DT.Rows[0][0]).ToUpper();
                }
                else
                {
                    return "";
                }
            }
            catch (Exception ex) { return ""; }
        }
        protected void callBackuserControlPanelMainTC_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            try
            {
                string[] Data = e.Parameter.Split('~');
                #region TC Tagging Process
                if (Data != null && Data.Length == 3 && Data[0] == "TCtagging") // Tagging Property
                {
                    string DocId = Data[1];
                    string DocType = Data[2];

                    BindTC(DocId, DocType);
                }
                #endregion
                #region Show PO specefic fields
                if (Data != null && Data.Length == 2 && Data[0] == "TCspecefiFields_PO") // Show PO specefic fields
                {
                    if (GetCountryByVendorId(Data[1]) != "" && GetCountryByVendorId(Data[1]) != "INDIA") //
                    {
                        pnl_TCspecefiFields_PO.Style.Add(HtmlTextWriterStyle.Display, "block");
                        pnl_TCspecefiFields_Not_PO.Style.Add(HtmlTextWriterStyle.Display, "none");
                        hfTCspecefiFieldsVisibilityCheck.Value = "1";
                    }
                    else
                    {
                        pnl_TCspecefiFields_PO.Style.Add(HtmlTextWriterStyle.Display, "none");
                        pnl_TCspecefiFields_Not_PO.Style.Add(HtmlTextWriterStyle.Display, "block");
                        hfTCspecefiFieldsVisibilityCheck.Value = "0";
                    }
                }
                #endregion
            }
            catch (Exception ex) { }
        }
    }
}