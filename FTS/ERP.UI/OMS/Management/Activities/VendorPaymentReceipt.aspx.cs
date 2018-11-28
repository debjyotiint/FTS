﻿using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using DevExpress.Web;
using System.Linq;
using BusinessLogicLayer;
using System.Web.Services;
using System.Collections.Generic;
using System.Collections;
using DataAccessLayer;
using DevExpress.Web.Data;
using EntityLayer.CommonELS;
using ERP.OMS.Tax_Details.ClassFile;

namespace ERP.OMS.Management.Activities
{
    public partial class VendorPaymentReceipt : ERP.OMS.ViewState_class.VSPage//System.Web.UI.Page
    {
        BusinessLogicLayer.Converter objConverter = new BusinessLogicLayer.Converter();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        BusinessLogicLayer.RemarkCategoryBL reCat = new BusinessLogicLayer.RemarkCategoryBL();
        BusinessLogicLayer.Contact oContactGeneralBL = new BusinessLogicLayer.Contact();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        PurchaseOrderBL objPurchaseOrderBL = new PurchaseOrderBL();
        CustomerVendorReceiptPaymentBL objCustomerVendorReceiptPaymentBL = new CustomerVendorReceiptPaymentBL();
        GSTtaxDetails _ObjGSTtaxDetails = new GSTtaxDetails();
        BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        static string ForJournalDate = null;
        public string pageAccess = "";
        string JVNumStr = string.Empty;
        protected void Page_PreInit(object sender, EventArgs e) // lead add
        {
            if (Request.QueryString.AllKeys.Contains("IsTagged"))
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/PopUp.Master";
            }
            else
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/ERP.Master";
            }

            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Activities/CustomerReceiptPayment.aspx");
            if (HttpContext.Current.Session["userid"] == null)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
            if (!IsPostBack)
            {
                Session["CustomerDetailForVPR"] = null;
                Session["VendorReceiptPayment_ID"] = null;
                Session["VendorIBRef"] = null;
                Session["VendorPaymentReceiptDetails"] = null;
                Session["VendorPayRecDocumentNo"] = null;
                ComboVoucherType.SelectedValue = "P";
                CustomerComboBox.FilterMinLength = 4;
                BindEnterBranch();
                BindSystemSettings();
                BindBranch();
                Bind_Currency();
                SetFinYearCurrentDate();
                GetFinacialYear();
                if (!String.IsNullOrEmpty(Convert.ToString(Session["userbranchID"])))
                {
                    string strdefaultBranch = Convert.ToString(Session["userbranchID"]);
                    ddlBranch.SelectedValue = strdefaultBranch;
                    BindCashBankAccount(strdefaultBranch);
                }
                if (!String.IsNullOrEmpty(Convert.ToString(Session["LocalCurrency"])))
                {
                    string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
                    string basedCurrency = Convert.ToString(LocalCurrency.Split('~')[0]);
                    string CurrencyId = Convert.ToString(basedCurrency[0]);
                    CmbCurrency.Value = CurrencyId;
                }
                if (Request.QueryString["IsTagged"] == "Y")
                {
                    IsInvoiceTagged.Value = "Y";
                    gridBatch.Settings.VerticalScrollableHeight = 70;
                }
                else
                {
                    IsInvoiceTagged.Value = "N";
                }                
                if (Request.QueryString["key"] == "ADD")
                {
                    ComboVoucherType.Style.Add("display", "none");
                    hdnPageStatus.Value = "first";
                    hdn_Mode.Value = "Entry";
                  //  dtTDate.Date = DateTime.Now;                 
                    #region To Show By Default Cursor after SAVE AND NEW
                    if (Session["SaveModeVPR"] != null)  // it has been removed from coding side of Quotation list 
                    {
                        if (Session["schemavalueVPR"] != null)  // it has been removed from coding side of Quotation list 
                        {
                            CmbScheme.Value = Convert.ToString(Session["schemavalueVPR"]); // it has been removed from coding side of Quotation list 
                        }
                        if (Convert.ToString(Session["SaveModeVPR"]) == "A")
                        {
                            dtTDate.Focus();
                            txtVoucherNo.Enabled = false;
                            //txtVoucherNo.Text = "Auto";
                        }
                        else if (Convert.ToString(Session["SaveModeVPR"]) == "M")
                        {
                            txtVoucherNo.Enabled = true;
                            txtVoucherNo.Text = "";

                            txtVoucherNo.Focus();

                        }
                    }
                    else
                    {
                        ComboVoucherType.Focus();
                    }
                    #endregion To Show By Default Cursor after SAVE AND NEW
                    gridBatch.DataSource = null;
                    gridBatch.DataBind();
                    Keyval_internalId.Value = "Add";
                    CreateDataTaxTable();
                    //lbltaxAmountHeader.Visible = false;
                    //txtTaxAmount.Visible = false;
                }
                else
                {
                    gridBatch.JSProperties["cpView"] = (Request.QueryString["req"] != null && Request.QueryString["req"] == "V") ? "1" : "0";
                    if (Request.QueryString["req"] == "V")
                    {
                        lblHeadTitle.Text = "View Vendor Payment/Receipt";
                    }
                    else
                    {
                        lblHeadTitle.Text = "Modify Vendor Payment/Receipt";
                    }
                   
                    hdnPageStatus.Value = "update";
                    hdn_Mode.Value = "Edit";
                    txtVoucherNo.Enabled = false;
                    ComboVoucherType.Enabled = false;
                    ddlBranch.Enabled = false;
                    // dtTDate.Enabled = false;
                    // lookup_Customer.Enabled = false;
                    divNumberingScheme.Style.Add("display", "none");
                    divEnterBranch.Style.Add("display", "Block");
                    ddlEnterBranch.Enabled = false;
                    Session["VendorReceiptPayment_ID"] = Request.QueryString["key"];
                    FillGrid();
                    productLookUp.DataBind();
                    ProductDetaisByID();
                    Session["VendorPaymentReceiptDetails"] = GetCustomerReceiptPaymentBatchData().Tables[0];
                    gridBatch.DataSource = BindCustomerReceiptPaymentBatch();
                    gridBatch.DataBind();
                    Keyval_internalId.Value = "VenPayRece" + Session["VendorReceiptPayment_ID"];

                    #region Get Tax Details in Edit Mode

                    DataTable TaxTable = GetVRPTaxData().Tables[0];
                    if (TaxTable == null)
                    {
                        CreateDataTaxTable();
                        //lbltaxAmountHeader.Visible = false;
                        //txtTaxAmount.Visible = false;
                    }
                    else
                    {
                        Session["VRP_FinalTaxRecord"] = TaxTable;
                        //lbltaxAmountHeader.Visible = true;
                        //txtTaxAmount.Visible = true;
                        //txtTaxAmount.Text = TaxTable.AsEnumerable().Sum(r => Convert.ToDouble(r.Field<decimal>("Amount"))).ToString();
                    }

                    #endregion Get Tax Details in Edit Mode
                    if (objCustomerVendorReceiptPaymentBL.IsVRPExist(Request.QueryString["key"]))
                    {
                        gridBatch.JSProperties["cpBtnVisible"] = "True";
                    }
                }
                ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "GridCallBack()", true);
            }
            //PopulateVendorDetail();

            Bind_PaymentNumberingScheme();
        }
        public void SetFinYearCurrentDate()
        {
            dtTDate.EditFormatString = objConverter.GetDateFormat("Date");
            string fDate = null;
            string[] FinYEnd = Convert.ToString(Session["FinYearEnd"]).Split(' ');
            string FinYearEnd = FinYEnd[0];
            DateTime date3 = DateTime.ParseExact(FinYearEnd, "M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            ForJournalDate = Convert.ToString(date3);
            if (date3 < oDBEngine.GetDate().Date)
            {
                fDate = Convert.ToString(Convert.ToDateTime(ForJournalDate).Month) + "/" + Convert.ToString(Convert.ToDateTime(ForJournalDate).Day) + "/" + Convert.ToString(Convert.ToDateTime(ForJournalDate).Year);
            }
            else
            {
                fDate = Convert.ToString(Convert.ToDateTime(oDBEngine.GetDate().Date).Month) + "/" + Convert.ToString(Convert.ToDateTime(oDBEngine.GetDate().Date).Day) + "/" + Convert.ToString(Convert.ToDateTime(oDBEngine.GetDate().Date).Year);
            }
            dtTDate.Value = DateTime.ParseExact(fDate, @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
        }
        public void GetFinacialYear()
        {
            string finyear = "";
            DateTime MinDate, MaxDate;

            if (Session["LastFinYear"] != null)
            {
                finyear = Convert.ToString(Session["LastFinYear"]).Trim();
                SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
                DataTable dtFinYear = objSlaesActivitiesBL.GetFinacialYearBasedQouteDate(finyear);
                if (dtFinYear != null && dtFinYear.Rows.Count > 0)
                {
                    Session["FinYearStartDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearStartDate"]);
                    Session["FinYearEndDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearEndDate"]);

                    MinDate = Convert.ToDateTime(dtFinYear.Rows[0]["finYearStartDate"]);
                    MaxDate = Convert.ToDateTime(dtFinYear.Rows[0]["finYearEndDate"]);

                    dtTDate.Value = null;
                    if (Session["FinYearStartDate"] != null)
                    {
                        dtTDate.MinDate = Convert.ToDateTime(Convert.ToString(Session["FinYearStartDate"]));
                        //dtTDate.MinDate = MinDate;
                    }
                    if (Session["FinYearEndDate"] != null)
                    {
                        dtTDate.MaxDate = Convert.ToDateTime(Convert.ToString(Session["FinYearEndDate"]));
                        //dtTDate.MaxDate = MaxDate;
                    }
                    if (DateTime.Now > MaxDate)
                    {
                        dtTDate.Value = MaxDate;
                    }
                    else
                    {
                        dtTDate.Value = DateTime.Now;
                    }
                }
            }
            
        }
        public void BindSystemSettings()
        {
            DataTable dtSystemSettings = new DataTable();
            dtSystemSettings = objCustomerVendorReceiptPaymentBL.GetSystemSettingsVendor();
            if (dtSystemSettings.Rows.Count > 0)
            {
                string Variable_Value = Convert.ToString(dtSystemSettings.Rows[0]["Variable_Value"]);
                hdnSalesInvoice.Value = Variable_Value;
            }
           // hdnSalesInvoice.Value = "Yes";

        }
        public class CRPDetailsLIST
        {
            public string ReceiptDetail_ID { get; set; }
            public string Type { get; set; }
            public string DocumentID { get; set; }
            public string Receipt { get; set; }
            public string Payment { get; set; }
            public string Remarks { get; set; }
            public string DocumentNo { get; set; }
            public string IsOpening { get; set; }
        }
        public class DocumentType
        {
            public string Type { get; set; }
            public string ID { get; set; }
        }
        public void FillGrid()
        {
            DataTable CRPOrderEditdt = GetCustomerReceiptPaymentEditData();
            if (CRPOrderEditdt != null && CRPOrderEditdt.Rows.Count > 0)
            {
                string Type = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_TransactionType"]);//0
                if (Type == "R")
                {
                    //multipleredio.Visible = false;
                    ProductSection.Visible = false;
                    ProductGSTApplicableSection.Visible = false;
                }
                
                
                string VoucherNumber = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_VoucherNumber"]);//1
                string TransactionDate = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_TransactionDate"]);//2
                string BranchID = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_BranchID"]);//3
               // string EnteredBranchID = Convert.ToString(CRPOrderEditdt.Rows[0]["EnteredBranchID"]);//3
                string EnteredBranchID = Convert.ToString(CRPOrderEditdt.Rows[0]["EditEnteredBranchID"]);//3
                string Customer_Id = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_VendorID"]);//5
                string Contact_Person_Id = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_ContactPersonID"]);//6

                string CashBankID = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_CashBankID"]);//7
                string Currency_Id = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_Currency"]);//8
                string Rate = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_Rate"]);//9

                string InstrumentType = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_InstrumentType"]);//10
                string InstrumentNumber = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_InstrumentNumber"]);//11
                string InstrumentDate = Convert.ToString(CRPOrderEditdt.Rows[0]["InstrumentDate"]);//12

                string Narration = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_Narration"]);//13
                string VoucherAmount = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_VoucherAmount"]);//14
                Boolean GSTApplicable = string.IsNullOrEmpty(CRPOrderEditdt.Rows[0]["GSTApplicable"].ToString()) ? false : Convert.ToBoolean(CRPOrderEditdt.Rows[0]["GSTApplicable"]);//15

                Session["VendorIBRef"] = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_IBRef"]);//15

                ComboVoucherType.SelectedValue = Type;
                txtVoucherNo.Text = VoucherNumber;
                dtTDate.Date = Convert.ToDateTime(TransactionDate);
                ddlBranch.SelectedValue = BranchID;

                ddlEnterBranch.SelectedValue = EnteredBranchID;
                if (EnteredBranchID!="0")
                {
                    
                    BindCashBankAccount(EnteredBranchID);
                }
                //else
                //{
                //    BindCashBankAccount(BranchID);
                //}
              

                //lookup_Customer.GridView.Selection.SelectRowByKey(Customer_Id);
                SetCustomerDDbyValue(Customer_Id);
                if (Customer_Id != "")
                {
                    hdfLookupCustomer.Value = Customer_Id;
                }
                pageheaderContent.Attributes.Add("style", "display:block");
                divGSTIN.Attributes.Add("style", "display:block");
                DataTable GSTNTable = objPurchaseOrderBL.GetVendorGSTIN(Customer_Id);
                string strGSTN = Convert.ToString(GSTNTable.Rows[0]["CNT_GSTIN"]).Trim();
                if (strGSTN != "")
                {
                    lblGSTIN.Text = "Yes";
                }
                else
                {
                    lblGSTIN.Text = "No";
                }
                PopulateContactPersonOfCustomer(Customer_Id);
                hdnCustomerId.Value = Customer_Id;
                if (Contact_Person_Id != "0")
                {
                    cmbContactPerson.Value = Contact_Person_Id;
                }
              //  BindCashBankAccount(BranchID);
                ddlCashBank.Value = CashBankID;
                string strCashBank = ddlCashBank.Text;
                string Cash_Bank = Convert.ToString(strCashBank.Split(']')[1]);
                if (Cash_Bank.Trim() != "Bank")
                {
                    divInstrumentNo.Visible = false;
                    tdIDateDiv.Visible = false;
                }
                CmbCurrency.Value = Currency_Id;
                txtRate.Text = Rate.Trim();
                cmbInstrumentType.Value = InstrumentType.Trim();
                txtInstNobth.Text = InstrumentNumber.Trim();
                if (!String.IsNullOrEmpty(InstrumentDate))
                {
                    InstDate.Date = Convert.ToDateTime(InstrumentDate);
                }

                txtNarration.Text = Narration.Trim();
                txtVoucherAmount.Text = VoucherAmount.Trim();
                CB_GSTApplicable.Checked = GSTApplicable;
            }


        }
        public DataTable GetCustomerReceiptPaymentEditData()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
            proc.AddVarcharPara("@Action", 500, "VendorReceiptPaymentEditDetails");
            proc.AddIntegerPara("@ReceiptPayment_ID", Convert.ToInt32(Session["VendorReceiptPayment_ID"]));

            dt = proc.GetTable();
            return dt;
        }
        public IEnumerable BindCustomerReceiptPaymentBatch()
        {
            List<CRPDetailsLIST> CRPDetailsList = new List<CRPDetailsLIST>();
            DataTable CustomerReceiptPaymendt = GetCustomerReceiptPaymentBatchData().Tables[0];

            for (int i = 0; i < CustomerReceiptPaymendt.Rows.Count; i++)
            {
                CRPDetailsLIST CRPDetails = new CRPDetailsLIST();


                CRPDetails.ReceiptDetail_ID = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["ReceiptDetail_ID"]);
                CRPDetails.Type = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Type"]);
                CRPDetails.DocumentID = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["DocumentID"]);
                CRPDetails.Receipt = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Receipt"]);
                CRPDetails.Payment = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Payment"]);
                CRPDetails.Remarks = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Remarks"]);
                CRPDetails.DocumentNo = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["DocumentNo"]);
                CRPDetails.IsOpening = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["IsOpening"]);
                CRPDetailsList.Add(CRPDetails);
            }

            return CRPDetailsList;
        }
        public DataSet GetCustomerReceiptPaymentBatchData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
            proc.AddVarcharPara("@Action", 500, "VPRBatchEditDetails");
            proc.AddIntegerPara("@ReceiptPayment_ID", Convert.ToInt32(Session["VendorReceiptPayment_ID"]));
            //proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
            //proc.AddVarcharPara("@campany_Id", 500, Convert.ToString(Session["LastCompany"]));
            ds = proc.GetDataSet();
            return ds;
        }
        #region Bind Method
        public DataTable GetProductDetaisByID()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
            proc.AddVarcharPara("@Action", 500, "ProductEditDetails");
            proc.AddIntegerPara("@ReceiptPayment_ID", Convert.ToInt32(Session["VendorReceiptPayment_ID"]));

            dt = proc.GetTable();
            return dt;
        }
        public void ProductDetaisByID()
        {
            DataTable Productdt = GetProductDetaisByID();
            string ProductID = string.Empty;

            if (Productdt != null && Productdt.Rows.Count > 0)
            {
                foreach (DataRow dr in Productdt.Rows)
                {

                    productLookUp.GridView.Selection.SelectRowByKey(Convert.ToInt32(dr["Products_ID"]));
                    ProductID = Convert.ToString(Convert.ToString(dr["Products_ID"]));
                }
                hfHSN_CODE.Value = GetHSNByProductID(ProductID);
            }
        }
        public void BindCashBankAccount(string userbranch)
        {
            DataTable dtCustomer = new DataTable();
            string CompanyId = Convert.ToString(Session["LastCompany"]);
            dtCustomer = objCustomerVendorReceiptPaymentBL.GetCustomerCashBank(userbranch, CompanyId);
            if (dtCustomer.Rows.Count > 0)
            {
                ddlCashBank.TextField = "IntegrateMainAccount";
                ddlCashBank.ValueField = "MainAccount_ReferenceID";
                ddlCashBank.DataSource = dtCustomer;
                ddlCashBank.DataBind();
            }
            else
            {
                ddlCashBank.TextField = "IntegrateMainAccount";
                ddlCashBank.ValueField = "MainAccount_ReferenceID";
                ddlCashBank.DataSource = dtCustomer;
                ddlCashBank.DataBind();
            }

        }
        public void BindBranch()
        {
            dsBranch.SelectCommand = "SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where BRANCH_id in(" + Convert.ToString(Session["userbranchHierarchy"]) + ")";
            ddlBranch.DataBind();
        }
        public void BindEnterBranch()
        {
            dsBranch.SelectCommand = "SELECT '0' AS BANKBRANCH_ID,'Select' as BANKBRANCH_NAME FROM TBL_MASTER_BRANCH Union  SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where BRANCH_id in(" + Convert.ToString(Session["userbranchHierarchy"]) + ")";
            ddlEnterBranch.DataBind();
        }
        public void Bind_Currency()
        {
            SqlCurrencyBind.SelectCommand = "select Currency_ID,Currency_AlphaCode from Master_Currency Order By Currency_ID";
            CmbCurrency.DataBind();
        }
        public void Bind_PaymentNumberingScheme()
        {
            //string strCompanyID = Convert.ToString(Session["LastCompany"]);
            //string strBranchID = Convert.ToString(Session["userbranchID"]);
            //string FinYear = Convert.ToString(Session["LastFinYear"]);
            //string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
           
            //SqlSchematype.SelectCommand = "Select * From ((Select '0' as ID,'Select' as SchemaName) Union (Select ID,SchemaName " +
            //" +(Case When (SELECT Isnull(branch_description,'') FROM tbl_master_branch where branch_id=Branch) Is Null Then '' " +
            //" Else ' ('+(SELECT Isnull(branch_description,'') FROM tbl_master_branch where branch_id=Branch)+')' End) From tbl_master_Idschema " +
            //" Where TYPE_ID='24' AND IsActive=1 AND Isnull(Branch,'') in (select s FROM dbo.GetSplit(',','" + userbranchHierarchy + "'))" +
            //" AND financial_year_id=(Select Top 1 FinYear_ID FROM Master_FinYear WHERE FinYear_Code='" + FinYear.Trim() + "')  AND Isnull(comapanyInt,'')='" + strCompanyID + "')) as x Order By ID asc";
            //CmbScheme.DataBind();


            string strCompanyID = Convert.ToString(Session["LastCompany"]);
            string strBranchID = Convert.ToString(Session["userbranchID"]);
            string FinYear = Convert.ToString(Session["LastFinYear"]);
            string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
            string strSelectedBranchID = Convert.ToString(ddlBranch.SelectedValue);
            SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();

            DataTable Schemadt = objSlaesActivitiesBL.GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "24", "Y");

            if (Schemadt != null && Schemadt.Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "Id";
                CmbScheme.DataSource = Schemadt;
                CmbScheme.DataBind();
            }
        }
        public void Bind_ReceiptNumberingScheme()
        {
            //string strCompanyID = Convert.ToString(Session["LastCompany"]);
            //string strBranchID = Convert.ToString(Session["userbranchID"]);
            //string FinYear = Convert.ToString(Session["LastFinYear"]);
            //string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
           
            //SqlSchematype.SelectCommand = "Select * From ((Select '0' as ID,'Select' as SchemaName) Union (Select ID,SchemaName " +
            //" +(Case When (SELECT Isnull(branch_description,'') FROM tbl_master_branch where branch_id=Branch) Is Null Then '' " +
            //" Else ' ('+(SELECT Isnull(branch_description,'') FROM tbl_master_branch where branch_id=Branch)+')' End) From tbl_master_Idschema " +
            //" Where TYPE_ID='23' AND IsActive=1 AND Isnull(Branch,'') in (select s FROM dbo.GetSplit(',','" + userbranchHierarchy + "'))" +
            //" AND financial_year_id=(Select Top 1 FinYear_ID FROM Master_FinYear WHERE FinYear_Code='" + FinYear.Trim() + "')  AND Isnull(comapanyInt,'')='" + strCompanyID + "')) as x Order By ID asc";
            //CmbScheme.DataBind();

            string strCompanyID = Convert.ToString(Session["LastCompany"]);
            string strBranchID = Convert.ToString(Session["userbranchID"]);
            string FinYear = Convert.ToString(Session["LastFinYear"]);
            string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
            string strSelectedBranchID = Convert.ToString(ddlBranch.SelectedValue);
            SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();

            DataTable Schemadt = objSlaesActivitiesBL.GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "23", "Y");

            if (Schemadt != null && Schemadt.Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "Id";
                CmbScheme.DataSource = Schemadt;
                CmbScheme.DataBind();
            }
        }
        protected void CmbScheme_Callback(object sender, CallbackEventArgsBase e)
        {
            string command = e.Parameter;
            if (command == "P")
            {
                Bind_PaymentNumberingScheme();
                CmbScheme.Value = "0";
            }
            else if (command == "R")
            {
                Bind_ReceiptNumberingScheme();
                CmbScheme.Value = "0";
            }
        }

        public void PopulateVendorDetail()
        {
            //if (Session["CustomerDetailForVPR"] == null)
            //{
            //    DataTable dtCustomer = new DataTable();
            //    dtCustomer = objCustomerVendorReceiptPaymentBL.PopulateVendorDetail();

            //    if (dtCustomer != null && dtCustomer.Rows.Count > 0)
            //    {
            //        lookup_Customer.DataSource = dtCustomer;
            //        lookup_Customer.DataBind();

            //        if (!string.IsNullOrEmpty(Request.QueryString["key"]) && !string.IsNullOrEmpty(Request.QueryString["SalId"]))
            //        {
            //            string udfCount = oDBEngine.ExeSclar("select sls_contactlead_id from tbl_trans_sales where sls_id=" + Request.QueryString["SalId"]);
            //            if (!string.IsNullOrEmpty(udfCount))
            //            {
            //                lookup_Customer.GridView.Selection.SelectRowByKey(udfCount);
            //            }
            //        }
            //        Session["CustomerDetailForVPR"] = dtCustomer;
            //    }
            //}
            //else
            //{
            //    lookup_Customer.DataSource = (DataTable)Session["CustomerDetailForVPR"];
            //    lookup_Customer.DataBind();
            //}

        }
        protected void ASPxComboBox_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            if (e.Filter != "")
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;
                DataTable dt = new DataTable();
                string filter = "%" + Convert.ToString(e.Filter) + "%";
                int startindex = Convert.ToInt32(e.BeginIndex + 1);
                int EndIndex = Convert.ToInt32(e.EndIndex + 1);
                //string branchId = ddl_Branch.SelectedItem.Value;

                dt = PopulateVendorOnDemand(filter, startindex, EndIndex);
                comboBox.DataSource = dt;
                comboBox.DataBind();
            }
        }
        protected void CustomerComboBox_Callback(object sender, CallbackEventArgsBase e)
        {
            ASPxComboBox comboBox = (ASPxComboBox)sender;
            if (Convert.ToString(e.Parameter.Split('~')[0]) == "BlankVendor")
            {
                comboBox.DataSource = null;
                comboBox.DataBind();
            }
            


        }
        protected void SetCustomerDDbyValue(string VendorId)
        {
            CustomerComboBox.DataSource = null;
            CustomerComboBox.DataBind();
            DataTable dt = PopulateVendorInEditMode(VendorId);
            CustomerComboBox.DataSource = dt;
            CustomerComboBox.DataBind();
            CustomerComboBox.Value = VendorId;
            //CustomerComboBox.SelectedIndex = CustomerComboBox.Items.FindByValue(customerId).Index;
        }
        public DataTable PopulateVendorInEditMode(string VendorId)
        {

            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseInvoiceDetail");
            proc.AddVarcharPara("@Action", 100, "PopulateVendorInEditMode");
            proc.AddVarcharPara("@VendorID", 50, VendorId);
            dt = proc.GetTable();
            return dt;
        }
        public DataTable PopulateVendorOnDemand(string filter, int startindex, int EndIndex)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_CustomerReceiptPaymentDetails");
            proc.AddVarcharPara("@Action", 100, "PopulateVendorsDetailOnDemand");
            proc.AddVarcharPara("@filter", 20, filter);
            proc.AddIntegerPara("@startindex", startindex);
            proc.AddIntegerPara("@EndIndex", EndIndex);
            dt = proc.GetTable();
            return dt;
        }
        protected void ASPxComboBox_OnItemRequestedByValue_SQL(object source, ListEditItemRequestedByValueEventArgs e)
        {
            long value = 0;
            ASPxComboBox comboBox = (ASPxComboBox)source;
            // if (rdl_PurchaseInvoice.Items.Count > 1)
            //{
            //    if (rdl_PurchaseInvoice.Items[0].Selected || rdl_PurchaseInvoice.Items[1].Selected)
            //    {
            //        //SetCustomerDDbyValue(Convert.ToString(e.Value));
            //        DataTable dt = objPurchaseInvoice.PopulateVendorInEditMode(Convert.ToString(e.Value));
            //        comboBox.DataSource = dt;
            //        comboBox.DataBind();
            //    }

            //}
            //else if (rdl_PurchaseInvoice.Items.Count == 1)
            //{
            //    if (rdl_PurchaseInvoice.Items[0].Selected)
            //    {
            //        ListBoxColumn li=new ListBoxColumn();

            //        DataTable dt = objPurchaseInvoice.PopulateVendorInEditMode(Convert.ToString(e.Value));
            //        comboBox.Value = Convert.ToString(dt.Rows[0][""]);
            //        comboBox.Text = Convert.ToString(dt.Rows[0][""]);
            //        comboBox.DataSource = dt;
            //        comboBox.DataBind();
            //        ListBoxColumn clm = new ListBoxColumn();
            //    clm.FieldName = "cnt_internalid"; 
            //    comboBox.Columns.Add(clm);

            //    ListBoxColumn clm2 = new ListBoxColumn();
            //    clm2.FieldName = "shortname"; 
            //    comboBox.Columns.Add(clm2); 
            //    ListBoxColumn clm3 = new ListBoxColumn();
            //    clm3.FieldName = "Name";
            //    comboBox.Columns.Add(clm3);
            //    ListBoxColumn clm4 = new ListBoxColumn();
            //    clm4.FieldName = "Type"; 
            //    comboBox.Columns.Add(clm4);
            //    comboBox.ValueType = typeof(string);
            //    comboBox.ValueField = "cnt_internalid";
            //    comboBox.DataBind();



            //        //SetCustomerDDbyValue(Convert.ToString(e.Value));
            //    }

            //}
            // else 
            //if (e.Value == null || !Int64.TryParse(e.Value.ToString(), out value))
            //{
            //    return;
            //    //ASPxComboBox comboBox = (ASPxComboBox)source;
            //    VendorDataSource.SelectCommand = @"select cnt_internalid,shortname,Name,Type from(select cnt_internalid ,shortname , Name ,Type   from v_PBVendorDetail  where (cnt_internalid = @ID)";
            //    //CustomerDataSource.SelectCommand = @"SELECT cnt_internalid,uniquename,Name,Billing FROM v_pos_customerDetails WHERE (cnt_internalid = @ID) ";

            //    VendorDataSource.SelectParameters.Clear();
            //    VendorDataSource.SelectParameters.Add("ID", TypeCode.String, e.Value.ToString());
            //    comboBox.DataSource = VendorDataSource;
            //    comboBox.DataBind();
            //}
        } 
        protected void cmbContactPerson_Callback(object sender, CallbackEventArgsBase e)
        {
            string WhichCall = e.Parameter.Split('~')[0];
            if (WhichCall == "BindContactPerson")
            {
                string InternalId = Convert.ToString(Convert.ToString(e.Parameter.Split('~')[1]));
                PopulateContactPersonOfCustomer(InternalId);

                DataTable GSTNTable = objPurchaseOrderBL.GetVendorGSTIN(InternalId);
                string strGSTN = Convert.ToString(GSTNTable.Rows[0]["CNT_GSTIN"]).Trim();
                if (strGSTN != "")
                {
                    cmbContactPerson.JSProperties["cpGSTN"] = "Yes";
                }
                else
                {
                    cmbContactPerson.JSProperties["cpGSTN"] = "No";
                }
            }
        }
        protected void PopulateContactPersonOfCustomer(string InternalId)
        {
            string ContactPerson = "";
            DataTable dtContactPerson = new DataTable();

            dtContactPerson = objCustomerVendorReceiptPaymentBL.PopulateContactPersonOfCustomer(InternalId);
            if (dtContactPerson != null && dtContactPerson.Rows.Count > 0)
            {
                cmbContactPerson.TextField = "contactperson";
                cmbContactPerson.ValueField = "add_id";
                cmbContactPerson.DataSource = dtContactPerson;
                cmbContactPerson.DataBind();
                foreach (DataRow dr in dtContactPerson.Rows)
                {
                    if (Convert.ToString(dr["Isdefault"]) == "True")
                    {
                        ContactPerson = Convert.ToString(dr["add_id"]);
                        break;
                    }
                }
                cmbContactPerson.SelectedItem = cmbContactPerson.Items.FindByValue(ContactPerson);

            }

        }
        #endregion

        #region GetRate ,getSchemeType
        [WebMethod]
        public static String GetRate(string Campany_ID,string Currency_ID,string basedCurrency)
        {

            PurchaseOrderBL objPurchaseOrderBL = new PurchaseOrderBL();
            DataTable dt = objPurchaseOrderBL.GetCurrentConvertedRate(Convert.ToInt16(basedCurrency), Convert.ToInt16(Currency_ID), Campany_ID);
            string SalesRate = "";
            if (dt.Rows.Count > 0)
            {
                SalesRate = Convert.ToString(dt.Rows[0]["PurchaseRate"]);
            }

            return SalesRate;
        }

        [WebMethod]
        public static string getSchemeType(string sel_scheme_id)
        {
            //BusinessLogicLayer.DBEngine oDbEngine1 = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            //string[] scheme = oDbEngine1.GetFieldValue1("tbl_master_Idschema", "schema_type", "Id = " + Convert.ToInt32(sel_scheme_id), 1);
            //return Convert.ToString(scheme[0]);

            string strschematype = "", strschemalength = "", strschemavalue = "", strschemaBranch = "", strVoucherType = "";
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.GetDataTable("tbl_master_Idschema", " schema_type,length,Branch,VoucherType ", " Id = " + Convert.ToInt32(sel_scheme_id));

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                strschematype = Convert.ToString(DT.Rows[i]["schema_type"]);
                strschemalength = Convert.ToString(DT.Rows[i]["length"]);
                strschemaBranch = Convert.ToString(DT.Rows[i]["Branch"]);
                strVoucherType = Convert.ToString(DT.Rows[i]["VoucherType"]);
                strschemavalue = strschematype + "~" + strschemalength + "~" + strschemaBranch + "~" + strVoucherType;
            }
            return Convert.ToString(strschemavalue);
        }
        #endregion

        #region Batch Grid
        protected void ComponentPanel_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string strType = e.Parameter.Split('~')[0];
            if (strType == "DeSelectAll")
            {
                productLookUp.GridView.Selection.UnselectAll();
            }
            else
            {
                String Product_IDS = string.Empty;
                //if (productLookUp.Value != null && !productLookUp.Value.ToString().Equals(""))
                //{
                //    Product_IDS = productLookUp.Value.ToString();
                //}
                List<object> ProductList = productLookUp.GridView.GetSelectedFieldValues("Products_ID");
                foreach (object Pro in ProductList)
                {
                    Product_IDS += "," + Pro;
                }
                Product_IDS = Product_IDS.TrimStart(',');

                BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable DT = objEngine.GetDataTable("Master_sProducts", " distinct case ISNULL(sProducts_HsnCode,'') when '' then convert(varchar(10), sProducts_serviceTax) else  convert(varchar(10), sProducts_HsnCode) end sProducts_HsnCode", " sProducts_ID in (" + Product_IDS + ")");
                //DataTable DT = objEngine.GetDataTable("Master_sProducts", " sProducts_HsnCode ", " sProducts_ID = '" + Product_IDS + "'");

                //if (DT != null && DT.Rows.Count > 0)
                //{
                //    hfHSN_CODE.Value = Convert.ToString(DT.Rows[0]["sProducts_HsnCode"]);
                //}

                if (DT != null && DT.Rows.Count > 1) //different HSN product selected
                {
                    hfHSN_CODE.Value = "";
                    productLookUp.GridView.Selection.UnselectAll();
                }
                else if (DT != null && DT.Rows.Count == 1 && !Convert.ToString(DT.Rows[0]["sProducts_HsnCode"]).Equals(""))
                {
                    hfHSN_CODE.Value = Convert.ToString(DT.Rows[0]["sProducts_HsnCode"]);
                }
                else
                {
                    hfHSN_CODE.Value = "";
                    productLookUp.GridView.Selection.UnselectAll();
                }

                if (Request.QueryString["key"] == "ADD")
                {
                    string Scheme = Convert.ToString(CmbScheme.Value);
                    if (Scheme == "0")
                    {
                        productLookUp.JSProperties["cpScheme"] = "NotSelected";
                        productLookUp.GridView.Selection.UnselectAll();
                    }
                }
            }
            
        }
        protected void CallbackPanelDocumentNo_Callback(object sender, CallbackEventArgsBase e)
        {
            DataTable dtDocument = new DataTable();
            string strType = e.Parameter.Split('~')[1];
            dtDocument = GetDocumentDetails(strType, "", Convert.ToString(dtTDate.Date));
            Session["VendorPayRecDocumentNo"] = dtDocument;
            if (dtDocument != null && dtDocument.Rows.Count > 0)
            {
                documentLookUp.DataSource = dtDocument;
                documentLookUp.DataBind();

            }
            else
            {
                documentLookUp.DataSource = null;
                documentLookUp.DataBind();
            }
        }
        protected void Grid_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void Grid_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void Grid_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            e.Cancel = true;
        }


        protected void gridBatch_DataBinding(object sender, EventArgs e)
        {
            //gridBatch.DataSource = BindCustomerReceiptPaymentBatch();
            if (Session["VendorPaymentReceiptDetails"] != null)
            {
                DataTable RPDdt = (DataTable)Session["VendorPaymentReceiptDetails"];
                DataView dvData = new DataView(RPDdt);
                var CPRLink = BindCustomerReceiptPaymentBatch(dvData.ToTable());
                gridBatch.DataSource = CPRLink;
                gridBatch.JSProperties["cpTotalAmount"] = Total_Receipt_Payment((List<CRPDetailsLIST>)CPRLink);
            }
            else
            {
                gridBatch.DataSource = BindCustomerReceiptPaymentBatch();
            }
        }
        public string Total_Receipt_Payment(List<CRPDetailsLIST> Vouchers)
        {
            decimal total_receipt = 0, total_payment = 0;

            foreach (CRPDetailsLIST obj in Vouchers)
            {
                total_receipt += Convert.ToDecimal(obj.Receipt);
                total_payment += Convert.ToDecimal(obj.Payment);
            }

            return Convert.ToString(total_receipt) + "~" + Convert.ToString(total_payment);
           // return Convert.ToString(total_receipt);

        }
        private void bindType(object source, CallbackEventArgsBase e)
        {
            //FillStateCombo(source as ASPxComboBox, Convert.ToInt32(e.Parameter));
            ASPxComboBox currentCombo = source as ASPxComboBox;
            currentCombo.DataSource = GetDocumentDetails("DocumentType", e.Parameter, Convert.ToString(dtTDate.Date));
            currentCombo.DataBind();
        }
        protected void gridBatch_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "Type")
            {

                ((ASPxComboBox)e.Editor).Callback += new CallbackEventHandlerBase(bindType);
            }
            e.Editor.ReadOnly = false;
            e.Editor.Enabled = true;
        }
        protected void gridBatch_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindGridOnSalesInvoice")
            {
                string command = e.Parameters.ToString();
                string ComponentDetailsIDs = string.Empty;
                string strAction = "";

                for (int i = 0; i < grid_SalesInvoice.GetSelectedFieldValues("DocumentID").Count; i++)
                {
                    ComponentDetailsIDs += "," + Convert.ToString(grid_SalesInvoice.GetSelectedFieldValues("DocumentID")[i]);
                }
                ComponentDetailsIDs = ComponentDetailsIDs.TrimStart(',');

                DataTable dtInvoices = new DataTable();

                if (ComponentDetailsIDs != "")
                {
                    dtInvoices = (DataTable)Session["AllInvoices"];
                    dtInvoices.Columns.Remove("DocDate");
                    dtInvoices.Columns.Remove("branch");
                    var invoice = dtInvoices.Select("DocumentID in (" + ComponentDetailsIDs + ")").CopyToDataTable();
                    if (invoice != null)
                    {
                        Session["VendorPaymentReceiptDetails"] = invoice;
                        gridBatch.DataSource = BindCustomerReceiptPaymentBatch(invoice);
                        gridBatch.DataBind();
                    }
                }
                else
                {
                    gridBatch.DataSource = null;
                    gridBatch.DataBind();
                }

            }
        }
        public IEnumerable BindCustomerReceiptPaymentBatch(DataTable CustomerReceiptPaymendt)
        {
            List<CRPDetailsLIST> CRPDetailsList = new List<CRPDetailsLIST>();
            //DataTable CustomerReceiptPaymendt = GetCustomerReceiptPaymentBatchData().Tables[0];

            for (int i = 0; i < CustomerReceiptPaymendt.Rows.Count; i++)
            {
                CRPDetailsLIST CRPDetails = new CRPDetailsLIST();


                CRPDetails.ReceiptDetail_ID = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["ReceiptDetail_ID"]) == "" ? Convert.ToString(i) : Convert.ToString(CustomerReceiptPaymendt.Rows[i]["ReceiptDetail_ID"]);
                CRPDetails.Type = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Type"]);
                CRPDetails.DocumentID = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["DocumentID"]);
                CRPDetails.Receipt = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Receipt"]);
                CRPDetails.Payment = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Payment"]);
                CRPDetails.Remarks = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["Remarks"]);
                CRPDetails.DocumentNo = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["DocumentNo"]);
                CRPDetails.IsOpening = Convert.ToString(CustomerReceiptPaymendt.Rows[i]["IsOpening"]);
                CRPDetailsList.Add(CRPDetails);
            }

            return CRPDetailsList;
        }
        protected string checkNMakeJVCode(string manual_str, int sel_schema_Id)
        {
            oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable dtSchema = new DataTable();
            DataTable dtC = new DataTable();
            string prefCompCode = string.Empty, sufxCompCode = string.Empty, startNo, paddedStr, sqlQuery = string.Empty;
            int EmpCode, prefLen, sufxLen, paddCounter;

            if (sel_schema_Id > 0)
            {
                dtSchema = oDBEngine.GetDataTable("tbl_master_idschema", "prefix, suffix, digit, startno, schema_type", "id=" + sel_schema_Id);
                int scheme_type = Convert.ToInt32(dtSchema.Rows[0]["schema_type"]);

                if (scheme_type != 0)
                {
                    startNo = dtSchema.Rows[0]["startno"].ToString();
                    paddCounter = Convert.ToInt32(dtSchema.Rows[0]["digit"]);
                    paddedStr = startNo.PadLeft(paddCounter, '0');
                    prefCompCode = dtSchema.Rows[0]["prefix"].ToString();
                    sufxCompCode = dtSchema.Rows[0]["suffix"].ToString();
                    prefLen = Convert.ToInt32(prefCompCode.Length);
                    sufxLen = Convert.ToInt32(sufxCompCode.Length);

                    sqlQuery = "SELECT max(tjv.ReceiptPayment_VoucherNumber) FROM Trans_VendorReceiptPayment tjv WHERE dbo.RegexMatch('";
                    if (prefLen > 0)
                        sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                    else if (scheme_type == 2)
                        sqlQuery += "^";
                    sqlQuery += "[0-9]{" + paddCounter + "}";
                    if (sufxLen > 0)
                        sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                    sqlQuery += "?$', LTRIM(RTRIM(tjv.ReceiptPayment_VoucherNumber))) = 1 and ReceiptPayment_VoucherNumber like '" + prefCompCode + "%'";
                    if (scheme_type == 2)
                        sqlQuery += " AND CONVERT(DATE, ReceiptPayment_CreateDateTime) = CONVERT(DATE, GETDATE())";
                    dtC = oDBEngine.GetDataTable(sqlQuery);

                    if (dtC.Rows[0][0].ToString() == "")
                    {
                        sqlQuery = "SELECT max(tjv.ReceiptPayment_VoucherNumber) FROM Trans_VendorReceiptPayment tjv WHERE dbo.RegexMatch('";
                        if (prefLen > 0)
                            sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                        else if (scheme_type == 2)
                            sqlQuery += "^";
                        sqlQuery += "[0-9]{" + (paddCounter - 1) + "}";
                        if (sufxLen > 0)
                            sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                        sqlQuery += "?$', LTRIM(RTRIM(tjv.ReceiptPayment_VoucherNumber))) = 1 and ReceiptPayment_VoucherNumber like '" + prefCompCode + "%'";
                        if (scheme_type == 2)
                            sqlQuery += " AND CONVERT(DATE, ReceiptPayment_CreateDateTime) = CONVERT(DATE, GETDATE())";
                        dtC = oDBEngine.GetDataTable(sqlQuery);
                    }

                    if (dtC.Rows.Count > 0 && dtC.Rows[0][0].ToString().Trim() != "")
                    {
                        string uccCode = dtC.Rows[0][0].ToString().Trim();
                        int UCCLen = uccCode.Length;
                        int decimalPartLen = UCCLen - (prefCompCode.Length + sufxCompCode.Length);
                        string uccCodeSubstring = uccCode.Substring(prefCompCode.Length, decimalPartLen);
                        EmpCode = Convert.ToInt32(uccCodeSubstring) + 1;
                        // out of range journal scheme
                        if (EmpCode.ToString().Length > paddCounter)
                        {
                            return "outrange";
                        }
                        else
                        {
                            paddedStr = EmpCode.ToString().PadLeft(paddCounter, '0');
                            JVNumStr = prefCompCode + paddedStr + sufxCompCode;
                            return "ok";
                        }
                    }
                    else
                    {
                        JVNumStr = startNo.PadLeft(paddCounter, '0');
                        JVNumStr = prefCompCode + paddedStr + sufxCompCode;
                        return "ok";
                    }
                }
                else
                {
                    sqlQuery = "SELECT ReceiptPayment_VoucherNumber FROM Trans_VendorReceiptPayment WHERE ReceiptPayment_VoucherNumber LIKE '" + manual_str.Trim() + "'";
                    dtC = oDBEngine.GetDataTable(sqlQuery);
                    // duplicate manual entry check
                    if (dtC.Rows.Count > 0 && dtC.Rows[0][0].ToString().Trim() != "")
                    {
                        return "duplicate";
                    }

                    JVNumStr = manual_str.Trim();
                    return "ok";
                }
            }
            else
            {
                return "noid";
            }
        }
        protected void gridBatch_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            gridBatch.JSProperties["cpVouvherNo"] = "";
            gridBatch.JSProperties["cpSaveSuccessOrFail"] = null;
            DataTable CustomerPayRecdt = new DataTable();
            string IsDeleteFrom = Convert.ToString(hdfIsDelete.Value);
            string VoucherType = Convert.ToString(ComboVoucherType.SelectedValue);
            if (Session["VendorPaymentReceiptDetails"] != null)
            {
                CustomerPayRecdt = (DataTable)Session["VendorPaymentReceiptDetails"];
            }
            else
            {
                CustomerPayRecdt.Columns.Add("ReceiptDetail_ID", typeof(string));
                CustomerPayRecdt.Columns.Add("Type", typeof(string));
                CustomerPayRecdt.Columns.Add("DocumentID", typeof(string));
                CustomerPayRecdt.Columns.Add("Payment", typeof(string));
                CustomerPayRecdt.Columns.Add("Receipt", typeof(string));
                CustomerPayRecdt.Columns.Add("Remarks", typeof(string));
                CustomerPayRecdt.Columns.Add("Status", typeof(string));
                CustomerPayRecdt.Columns.Add("DocumentNo", typeof(string));
                CustomerPayRecdt.Columns.Add("IsOpening", typeof(string));

            }
            foreach (var args in e.InsertValues)
            {
                string Type = Convert.ToString(args.NewValues["Type"]);
                string Recieve = Convert.ToString(args.NewValues["Receipt"]);
                string Payment = Convert.ToString(args.NewValues["Payment"]);
                string DocumentNo = Convert.ToString(args.NewValues["DocumentNo"]);
                string IsOpening = Convert.ToString(args.NewValues["IsOpening"]);
                //string strOpening = "";
                //if (IsOpening.Trim()=="OP")
                //{
                //    strOpening = "YES";
                //}
                //else
                //{
                //    strOpening = "NO";
                //}
                //if (MainAccount != "" && MainAccount != "0")
                //{
                //if ((VoucherType=="R" && Recieve != "0.0") ||(VoucherType=="P" &&  Payment != "0.0"))
                //if ((Recieve != "0.0") || (Payment != "0.0"))
                //{
                string DocumentID = Convert.ToString(args.NewValues["DocumentID"]);
                string Remarks = Convert.ToString(args.NewValues["Remarks"]);
                if (Type != "")
                {
                    

                    CustomerPayRecdt.Rows.Add("0", Type, DocumentID, Payment, Recieve, Remarks, "I", DocumentNo, IsOpening);
                }
                //}
            }
            foreach (var args in e.UpdateValues)
            {
                string ReceiptDetail_ID = Convert.ToString(args.Keys["ReceiptDetail_ID"]);
                string Type = Convert.ToString(args.NewValues["Type"]);
                string DocumentID = Convert.ToString(args.NewValues["DocumentID"]);
                string IsOpening = Convert.ToString(args.NewValues["IsOpening"]);
                string DocumentNo = Convert.ToString(args.NewValues["DocumentNo"]);
                //string strOpening = "";
                //if (IsOpening.Trim() == "OP")
                //{
                //    strOpening = "YES";
                //}
                //else
                //{
                //    strOpening = "NO";
                //}
                string Recieve = Convert.ToString(args.NewValues["Receipt"]);
                string Payment = Convert.ToString(args.NewValues["Payment"]);
                string Remarks = Convert.ToString(args.NewValues["Remarks"]);
                bool isDeleted = false;
                foreach (var arg in e.DeleteValues)
                {
                    string DeleteID = Convert.ToString(arg.Keys["ReceiptDetail_ID"]);
                    if (DeleteID == ReceiptDetail_ID)
                    {
                        isDeleted = true;
                        break;
                    }
                }

                if (isDeleted == false)
                {
                    //if (MainAccount != "" && MainAccount != "0")
                    //{
                    // if ((VoucherType == "R" && Recieve != "0.0") || (VoucherType == "P" && Payment != "0.0"))
                    if ((Recieve != "0.0") || (Payment != "0.0"))
                    {
                        DataRow drr = CustomerPayRecdt.Select("ReceiptDetail_ID ='" + ReceiptDetail_ID + "'").FirstOrDefault(); // finds all rows with id==2 and selects first or null if haven't found any
                        if (drr != null)
                        {

                            drr["Type"] = Type;
                            drr["DocumentID"] = DocumentID;
                            drr["Payment"] = Payment;
                            drr["Receipt"] = Recieve;
                            drr["Remarks"] = Remarks;
                            drr["Status"] = "U";
                            drr["DocumentNo"] = DocumentNo;
                            drr["IsOpening"] = IsOpening;
                        }
                    }

                    //}
                }
            }
            foreach (var args in e.DeleteValues)
            {
                string ReceiptDetail_ID = Convert.ToString(args.Keys["ReceiptDetail_ID"]);
                DataRow dr = CustomerPayRecdt.Select("ReceiptDetail_ID ='" + ReceiptDetail_ID + "'").FirstOrDefault(); // finds all rows with id==2 and selects first or null if haven't found any
                if (dr != null)
                {
                    dr["Status"] = "D";
                }
            }
            int j = 1;
            foreach (DataRow dr in CustomerPayRecdt.Rows)
            {
                string Status = Convert.ToString(dr["Status"]);
                dr["ReceiptDetail_ID"] = j.ToString();

                if (Status != "D")
                {
                    if (Status == "I")
                    {
                        string strID = Convert.ToString("Q~" + j);
                        dr["ReceiptDetail_ID"]= strID;
                    }
                    j++;
                }
            }
            CustomerPayRecdt.AcceptChanges();
            Session["VendorPaymentReceiptDetails"] = CustomerPayRecdt;
            string validate = "";
            if (hdn_Mode.Value == "Entry")
            {
                string strSchemeType = Convert.ToString(CmbScheme.Value);
                string[] SchemeList = strSchemeType.Split(new string[] { "~" }, StringSplitOptions.None);
                validate = checkNMakeJVCode(Convert.ToString(txtVoucherNo.Text), Convert.ToInt32(SchemeList[0]));
            }
            var duplicateRecords = CustomerPayRecdt.AsEnumerable()
            .Where(r => r.Field<string>("Type") != "Advance" && r.Field<string>("Type") != "OnAccount")
            .GroupBy(r => r["DocumentID"]) //coloumn name which has the duplicate values
            .Where(gr => gr.Count() > 1)
            .Select(g => g.Key);

            foreach (var d in duplicateRecords)
            {
                validate = "duplicateDocument";
            }
            decimal totalReceipt = 0, totalPayment = 0;
            foreach (DataRow dr in CustomerPayRecdt.Rows)
            {
                string DocumentID = Convert.ToString(dr["DocumentID"]);
                string strType = Convert.ToString(dr["Type"]).Trim();
                string Status = Convert.ToString(dr["Status"]);
                string Recieve = Convert.ToString(dr["Receipt"]);
                string Payment = Convert.ToString(dr["Payment"]);

                if (Status != "D")
                {
                    if (DocumentID == "" && strType != "Advance")
                    {
                        if (strType != "OnAccount" && strType != "OnAccountRec")
                        {
                            validate = "nullQuantity";
                            break;
                        }
                    }
                    if (Convert.ToDecimal(Recieve) == 0 && Convert.ToDecimal(Payment) == 0)
                    {
                        validate = "nullReceiptPayment";
                        break;
                    }
                    totalReceipt += Convert.ToDecimal(dr["Receipt"]);
                    totalPayment += Convert.ToDecimal(dr["Payment"]);
                }
            }
            decimal VoucherAmount = Convert.ToDecimal(txtVoucherAmount.Text.Trim());
            if (totalReceipt != 0)
            {
                if (totalReceipt != VoucherAmount)
                {
                    validate = "NotMatchVoucherAmount";
                }
            }
            if (totalPayment != 0)
            {
                if (totalPayment != VoucherAmount)
                {
                    validate = "NotMatchVoucherAmount";
                }
            }

            //.................Multiple Product Selection.............

            String Product_IDS = "";
            List<object> ProductList = productLookUp.GridView.GetSelectedFieldValues("Products_ID");
            foreach (object Pro in ProductList)
            {
                Product_IDS += "," + Pro;
            }
            Product_IDS = Product_IDS.TrimStart(',');

            //..............Multiple Product Selection end.................

            //..............Single Product Selection start.................
            //String Product_IDS = string.Empty;
            //if (productLookUp.Value != null && !productLookUp.Value.ToString().Equals(""))
            //{
            //    Product_IDS = productLookUp.Value.ToString();
            //}
            //..............Single Product Selection end.................

            #region ##### Added By : Samrat Roy -- to get BillingShipping user control data
            DataTable tempBillAddress = new DataTable();
            tempBillAddress = BillingShippingControl.SaveBillingShippingControlData();
            #endregion
            #region Product Mandatory on GST CheckBox
            if (CB_GSTApplicable.Visible)
            {
                if (CB_GSTApplicable.Checked)
                {
                    foreach (DataRow dr in CustomerPayRecdt.Rows)
                    {
                        string strType = Convert.ToString(dr["Type"]).Trim();
                        if (strType == "Advance")
                        {
                            if (Product_IDS == "")
                            {
                                validate = "ProductMandatory";
                                break;
                            }

                        }
                    }
                }
            }
            #endregion
            #region BS mandatory

            if (Product_IDS != "")
            {
                //if (BillingShippingControl.GetShippingStateCode() == "" || BillingShippingControl.GetShippingStateCode() == "0")
                if (tempBillAddress == null || tempBillAddress.Rows.Count == 0)
                {
                    validate = "BSMandatory";
                }

            }
            #endregion

            if (validate == "outrange" || validate == "duplicate" || validate == "nullQuantity" || validate == "ProductMandatory" || validate == "BSMandatory" || validate == "nullReceiptPayment" || validate == "duplicateDocument" || validate == "NotMatchVoucherAmount")
            {
                gridBatch.JSProperties["cpSaveSuccessOrFail"] = validate;
            }
            else
            {

                string ActionType = "", strIBRef = "";
                if (hdn_Mode.Value == "Entry")
                {
                   
                    ActionType = "ADD";
                    strIBRef = "";
                }
                else
                {
                    ActionType = "Edit";
                    strIBRef = Convert.ToString(Session["VendorIBRef"]);
                }

                string strEditCashBankID = Convert.ToString(Session["VendorReceiptPayment_ID"]);

                string strCustomer = Convert.ToString(hdfLookupCustomer.Value);
                string strContactName = Convert.ToString(cmbContactPerson.Value);
                if (strContactName == "")
                {
                    strContactName = "0";
                }
                string strCashBankBranchID = Convert.ToString(ddlBranch.SelectedValue);

                string strEnterBranchID = Convert.ToString(ddlEnterBranch.SelectedValue);
                string strTransactionDate = Convert.ToString(dtTDate.Date);
                string strCashBankID = Convert.ToString(ddlCashBank.Value);
                string strExchangeSegmentID = "1";
                string strTransactionType = Convert.ToString(ComboVoucherType.SelectedValue);
                string strEntryUserProfile = "F";
                string strNarration = txtNarration.Text;
                string strCurrency = Convert.ToString(CmbCurrency.Value);
                string strInstrumentType = Convert.ToString(cmbInstrumentType.Value);
                string strVoucherAmount = txtVoucherAmount.Text.Trim();
                string strInstrumentNumber = txtInstNobth.Text.Trim();
                string strInstrumentDate = (InstDate.Date.ToString("yyyy-MM-dd") == "0001-01-01") ? " " : InstDate.Date.ToString("yyyy-MM-dd");
                string strrate = txtRate.Text.Trim();
                Boolean GSTApplicable = CB_GSTApplicable.Checked;

                DataTable tempCustomerPayRecdtn = CustomerPayRecdt.Copy();
                foreach (DataRow dr in tempCustomerPayRecdtn.Rows)
                {
                    string Status = Convert.ToString(dr["Status"]);

                    if (Status == "I")
                    {
                        dr["ReceiptDetail_ID"] = "0";
                       
                    }
                    else if (Status == "U" || Status == "")
                    {
                        string ReceiptDetailID = Convert.ToString(dr["ReceiptDetail_ID"]);
                        if (ReceiptDetailID.Contains("~") == true)
                        {
                            dr["ReceiptDetail_ID"] = "0";
                        }
                    }
                }
                tempCustomerPayRecdtn.AcceptChanges();

                DataTable TaxDetailTable = new DataTable();
                if (Session["VRP_FinalTaxRecord"] != null)
                {
                    string ShippingState = Convert.ToString(BillingShippingControl.GetShippingStateCode());
                    CreateDataTaxTable();
                    TaxDetailTable = (DataTable)Session["VRP_FinalTaxRecord"];
                    TaxDetailTable = _ObjGSTtaxDetails.GetGSTTaxDataForVendorRecPay(tempCustomerPayRecdtn, TaxDetailTable, Product_IDS, ComboVoucherType.SelectedValue.ToString().ToUpper(), "P", dtTDate.Date.ToString("yyyy-MM-dd"), ddlBranch.SelectedValue, Convert.ToString(hdfLookupCustomer.Value));//lookup_Customer.Value
                }
                if (Save_Record(ActionType, strEditCashBankID, JVNumStr, strCashBankBranchID, strTransactionDate, strCashBankID, strExchangeSegmentID, strTransactionType,
                    strEntryUserProfile, strVoucherAmount, strCustomer, strContactName,
                     strNarration, strIBRef, strCurrency, strInstrumentType, strInstrumentNumber, strInstrumentDate, strrate, Product_IDS, tempCustomerPayRecdtn,
                     tempBillAddress, TaxDetailTable, GSTApplicable, strEnterBranchID) == true)
                {

                    Session["VendorIBRef"] = null;
                    // hdnEditRfid.Value = "";
                    hdndocumentno.Value = "";
                    hdn_Mode.Value = "";
                    gridBatch.JSProperties["cpSaveSuccessOrFail"] = "successInsert";
                    gridBatch.JSProperties["cpVouvherNo"] = JVNumStr;

                    #region To Show By Default Cursor after SAVE AND NEW
                    if (ActionType == "ADD") // session has been removed from quotation list page working good
                    {
                        //string[] schemaid = new string[] { };
                        string schemavalue = Convert.ToString(CmbScheme.Value);
                        Session["schemavalueVPR"] = schemavalue;        // session has been removed from quotation list page working good
                        //schemaid = ddl_numberingScheme.SelectedValue.Split('~');

                        //string schematype = schemaid[1];
                        if (hdnRefreshType.Value == "N")
                        {
                            string schematype = txtVoucherNo.Text.Trim();
                            if (schematype == "Auto")
                            {
                                Session["SaveModeVPR"] = "A";
                            }
                            else
                            {
                                Session["SaveModeVPR"] = "M";
                            }
                        }
                        else
                        {
                            Session["SaveModeVPR"] = null;
                        }
                    }

                    #endregion
                }
                else
                {
                    gridBatch.JSProperties["cpSaveSuccessOrFail"] = "errorInsert";
                }
            }
        }
     
        public DataTable GetDocumentDetails(string TypeID, String VoucherType,string receiptdate)
        {
            //string ReceiptPayment_ID = Convert.ToString(Session["VendorReceiptPayment_ID"]);

            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
            proc.AddVarcharPara("@DocumentType", 20, TypeID);
            proc.AddVarcharPara("@DiscardIds", 100, hdndocumentno.Value);
            proc.AddVarcharPara("@VoucherType", 20, VoucherType);
            proc.AddVarcharPara("@CustomerID", 100, Convert.ToString(hdfLookupCustomer.Value));
            proc.AddVarcharPara("@BranchId", 100, Convert.ToString(ddlBranch.SelectedValue));
            proc.AddVarcharPara("@Receiptdate", 50, Convert.ToString(receiptdate));
            dt = proc.GetTable();
            return dt;
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Request.QueryString["key"] == "ADD")
            {
                ((GridViewDataComboBoxColumn)gridBatch.Columns["Type"]).PropertiesComboBox.DataSource = GetDocumentType();
            }
            else
            {
                Session["VendorReceiptPayment_ID"] = Request.QueryString["key"];
                 DataTable CRPOrderEditdt = GetCustomerReceiptPaymentEditData();
                 if (CRPOrderEditdt != null && CRPOrderEditdt.Rows.Count > 0)
                 {
                     string Type = Convert.ToString(CRPOrderEditdt.Rows[0]["ReceiptPayment_TransactionType"]);//0
                     ((GridViewDataComboBoxColumn)gridBatch.Columns["Type"]).PropertiesComboBox.DataSource = GetDocumentType(Type);
                 }
            }          
        }
        public IEnumerable GetDocumentType(string VoucherType)
        {
            List<DocumentType> DocumentTypeList = new List<DocumentType>();
            DataTable DT = GetDocumentDetails("DocumentType", Convert.ToString(VoucherType), "");

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                DocumentType DocumentTypes = new DocumentType();
                DocumentTypes.Type = Convert.ToString(DT.Rows[i]["Type"]);
                DocumentTypes.ID = Convert.ToString(DT.Rows[i]["ID"]);
                DocumentTypeList.Add(DocumentTypes);
            }

            return DocumentTypeList;
        }
        public IEnumerable GetDocumentType()
        {
            List<DocumentType> DocumentTypeList = new List<DocumentType>();
            DataTable DT = GetDocumentDetails("DocumentType", Convert.ToString(ComboVoucherType.SelectedValue), "");

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                DocumentType DocumentTypes = new DocumentType();
                DocumentTypes.Type = Convert.ToString(DT.Rows[i]["Type"]);
                DocumentTypes.ID = Convert.ToString(DT.Rows[i]["ID"]);
                DocumentTypeList.Add(DocumentTypes);
            }

            return DocumentTypeList;
        }
        private bool Save_Record(string ActionType, string strEditCashBankID, string strVoucherNumber, string strCashBankBranchID, string strTransactionDate,
            string strCashBankID,
             string strExchangeSegmentID, string strTransactionType, string strEntryUserProfile, string strVoucherAmount, string strCustomer, string strContactName,
            string strNarration, string strIBRef,
          string strCurrency, string strInstrumentType, string strInstrumentNumber, string strInstrumentDate, string strrate, string Product_IDS,
          DataTable strReceiptPaymentdt, DataTable tempBillAddress, DataTable TaxDetailTable, Boolean GSTApplicable,string strEnterBranchID)
        {
            try
            {
                gridBatch.JSProperties["cpExitNew"] = null;

                if (hdn_Mode.Value == "Entry")
                {

                    strIBRef = "CPR_" + Session["userid"].ToString() + "_" + strTransactionType + "_" + JVNumStr.Replace("/", "");

                }
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_VendorPaymentReceiptInsertUpdate", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Action", ActionType);//1
                cmd.Parameters.AddWithValue("@EditReceiptPaymentID", strEditCashBankID);//2
                cmd.Parameters.AddWithValue("@VoucherNumber", strVoucherNumber);//3

                cmd.Parameters.AddWithValue("@CompanyID", Convert.ToString(Session["LastCompany"]));//4
                cmd.Parameters.AddWithValue("@FinYear", Convert.ToString(Session["LastFinYear"]));//5
                cmd.Parameters.AddWithValue("@CreateUser", Convert.ToString(Session["userid"]));//6

                cmd.Parameters.AddWithValue("@ReceiptPaymentBranchID", strCashBankBranchID);//7
                cmd.Parameters.AddWithValue("@TransactionDate", strTransactionDate);//8
                cmd.Parameters.AddWithValue("@ReceiptPaymentCashBankID", strCashBankID);//9

                cmd.Parameters.AddWithValue("@ExchangeSegmentID", strExchangeSegmentID);//10
                cmd.Parameters.AddWithValue("@TransactionType", strTransactionType);//11


                cmd.Parameters.AddWithValue("@Narration", strNarration);//12
                cmd.Parameters.AddWithValue("@IBRef", strIBRef);//13
                cmd.Parameters.AddWithValue("@CurrencyID", strCurrency);//14
                cmd.Parameters.AddWithValue("@rate", strrate);         //15


                cmd.Parameters.AddWithValue("@ReceiptPaymentInstrumentType", strInstrumentType);//16
                cmd.Parameters.AddWithValue("@ReceiptPaymentInstrumentNumber", strInstrumentNumber);//17
                cmd.Parameters.AddWithValue("@ReceiptPaymentInstrumentDate", strInstrumentDate);//18

                cmd.Parameters.AddWithValue("@ReceiptPaymentCustomerID", strCustomer);//19
                cmd.Parameters.AddWithValue("@ReceiptPaymentContactPersonID", strContactName);//20
                cmd.Parameters.AddWithValue("@ReceiptPaymentVoucherAmount", strVoucherAmount);//21

                cmd.Parameters.AddWithValue("@Product_IDS", Product_IDS);//22

                cmd.Parameters.AddWithValue("@ReceiptPaymentDetails", strReceiptPaymentdt);//22
                cmd.Parameters.AddWithValue("@BillAddress", tempBillAddress); //23
                cmd.Parameters.AddWithValue("@TaxDetail", TaxDetailTable);//24
                cmd.Parameters.AddWithValue("@GSTApplicable", GSTApplicable); //25
                cmd.Parameters.AddWithValue("@EnterBranchID", strEnterBranchID); //25
                SqlParameter output = new SqlParameter("@ReturnValue", SqlDbType.Int);
                output.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(output);

                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);
                cmd.Dispose();
                con.Dispose();

                //Udf Add mode
                DataTable udfTable = (DataTable)Session["UdfDataOnAdd"];
                if (udfTable != null)
                {
                    Session["UdfDataOnAdd"] = reCat.insertRemarksCategoryAddMode("VPR", "VenPayRece" + Convert.ToString(output.Value), udfTable, Convert.ToString(Session["userid"]));
                }
                    
                //  gridBatch.JSProperties["cpExitNew"] = "YES";
                return true;

            }
            catch (Exception ex)
            {
                return false;
            }
        }
        #endregion

        protected void grid_SalesInvoice_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "SelectAndDeSelectProducts")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        gv.Selection.SelectRow(i);
                    }
                }
                if (State == "UnSelectAll")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        gv.Selection.UnselectRow(i);
                    }
                }
                if (State == "Revart")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        if (gv.Selection.IsRowSelected(i))
                            gv.Selection.UnselectRow(i);
                        else
                            gv.Selection.SelectRow(i);
                    }
                }
            }
            if (strSplitCommand == "BindSalesInvoiceDetails")
            {
                DataTable dtInvoice = new DataTable();
                string strAmount = e.Parameters.Split('~')[1];
                if (hdfLookupCustomer.Value != "")
                {
                    dtInvoice =GetSalesInvoiceDetails(Convert.ToString(hdfLookupCustomer.Value), strAmount);
                    if (dtInvoice != null && dtInvoice.Rows.Count > 0)
                    {
                        Session["AllInvoices"] = dtInvoice;
                        grid_SalesInvoice.DataSource = dtInvoice;
                        grid_SalesInvoice.DataBind();
                    }
                    else
                    {
                        Session["AllInvoices"] = null;
                        grid_SalesInvoice.DataSource = null;
                        grid_SalesInvoice.DataBind();
                        grid_SalesInvoice.JSProperties["cpOKVisible"] = "False";
                    }
                }
                else
                {
                    grid_SalesInvoice.JSProperties["cpOKVisible"] = "False";
                }
            }


        }
        public DataTable GetSalesInvoiceDetails(string CustomerID, string voucheramount)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
            proc.AddVarcharPara("@Action", 500, "GetPurchaseInvoiceDetails");
            proc.AddVarcharPara("@CustomerID", 500, CustomerID);
            proc.AddVarcharPara("@targetAmount", 500, voucheramount);
            proc.AddVarcharPara("@BranchId", 100, Convert.ToString(ddlBranch.SelectedValue));
            ds = proc.GetTable();
            return ds;
        }
        protected void acbpCrpUdf_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (Request.QueryString["key"] == "ADD")
            {
                if (reCat.isAllMandetoryDone((DataTable)Session["UdfDataOnAdd"], "VPR") == false)
                {
                    acbpCrpUdf.JSProperties["cpUDF"] = "false";

                }
                else
                {
                    acbpCrpUdf.JSProperties["cpUDF"] = "true";
                }
            }
            else
            {
                acbpCrpUdf.JSProperties["cpUDF"] = "true";
            }
        }
        protected void ddlCashBank_Callback(object sender, CallbackEventArgsBase e)
        {
            string userbranch = e.Parameter.Split('~')[0];
            BindCashBankAccount(userbranch);
        }
        public DataTable GetExactAmount(string Type, string documentId, string strIsOpening)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
            proc.AddVarcharPara("@Action", 500, "GetExactAmount");
            proc.AddVarcharPara("@Type", 500, Type);
            proc.AddIntegerPara("@DocumentId", Convert.ToInt32(documentId));         
            proc.AddVarcharPara("@IsOpening", 50, strIsOpening);
            ds = proc.GetTable();
            return ds;
        }
        protected void acpCheckAmount_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            DataTable dtAmount = new DataTable();
            string strType = e.Parameter.Split('~')[0];
            string strDocumentId = e.Parameter.Split('~')[1];
            string strIsOpening = e.Parameter.Split('~')[2];
            if (Request.QueryString["key"] == "ADD")
            {
                dtAmount = GetExactAmount(strType, strDocumentId, strIsOpening);
                string UnPaidAmount = string.Empty;
                if (dtAmount != null && dtAmount.Rows.Count > 0)
                {
                    UnPaidAmount = Convert.ToString(dtAmount.Rows[0]["UnPaidAmount"]);
                    acpCheckAmount.JSProperties["cpUnPaidAmount"] = UnPaidAmount;
                }
            }
            else
            {
                string ReceiptPayment_ID = Request.QueryString["key"];
                dtAmount = objCustomerVendorReceiptPaymentBL.GetExactAmountForVendorEdit(strType, strDocumentId, strIsOpening, ReceiptPayment_ID);
                string UnPaidAmount = string.Empty;
                if (dtAmount != null && dtAmount.Rows.Count > 0)
                {
                    UnPaidAmount = Convert.ToString(dtAmount.Rows[0]["UnPaidAmount"]);
                    acpCheckAmount.JSProperties["cpUnPaidAmount"] = UnPaidAmount;
                }
            }

        }

        #region Vendor TDS
        protected void gridinventory_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {

        }

        protected void PopulateBranchForTDS()
        {
            DataTable branchdt = new DataTable();
            branchdt = objCustomerVendorReceiptPaymentBL.PopulateBranchForTDS();
            ddl_noninventoryBranch.TextField = "BANKBRANCH_NAME";
            ddl_noninventoryBranch.ValueField = "BANKBRANCH_ID";
            ddl_noninventoryBranch.DataSource = branchdt;
            ddl_noninventoryBranch.DataBind();
        }
        
        #endregion

        #region Vendor ReceiptPayment Tax

        public string GetHSNByProductID(string Product_ID)
        {
            //DataTable DT = objEngine.GetDataTable("Master_sProducts", " sProducts_HsnCode ", " sProducts_ID = " + Product_ID + "");
            DataTable DT = objEngine.GetDataTable("Master_sProducts", " case ISNULL(sProducts_HsnCode,'') when '' then convert(varchar(10), sProducts_serviceTax) else  convert(varchar(10), sProducts_HsnCode) end sProducts_HsnCode ", " sProducts_ID = " + Product_ID + "");

            if (DT != null && DT.Rows.Count > 0 && !Convert.ToString(DT.Rows[0][0]).Equals(""))
            {
                return Convert.ToString(DT.Rows[0][0]);
            }
            else
            {
                return "";
            }
        }
        public DataSet GetVRPTaxData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
            proc.AddVarcharPara("@Action", 500, "VRPEditedTaxDetails");
            proc.AddIntegerPara("@ReceiptPayment_Id", Convert.ToInt32(Session["VendorReceiptPayment_ID"]));
            ds = proc.GetDataSet();
            return ds;
        }
        protected void cmbGstCstVat_Callback(object sender, CallbackEventArgsBase e)
        {
            DateTime quoteDate = Convert.ToDateTime(dtTDate.Date.ToString("yyyy-MM-dd"));

            PopulateGSTCSTVATCombo(quoteDate.ToString("yyyy-MM-dd"));
            CreateDataTaxTable();
        }
        public void PopulateGSTCSTVATCombo(string quoteDate)
        {
            string LastCompany = "";
            if (Convert.ToString(Session["LastCompany"]) != null)
            {
                LastCompany = Convert.ToString(Session["LastCompany"]);
            }
            //DataTable dt = new DataTable();
            //dt = objCRMSalesDtlBL.PopulateGSTCSTVATCombo();
            //DataTable DT = oDBEngine.GetDataTable("select cast(td.TaxRates_ID as varchar(5))+'~'+ cast (td.TaxRates_Rate as varchar(25)) 'Taxes_ID',td.TaxRatesSchemeName 'Taxes_Name',th.Taxes_Name as 'TaxCodeName' from Master_Taxes th inner join Config_TaxRates td on th.Taxes_ID=td.TaxRates_TaxCode where (td.TaxRates_Country=0 or td.TaxRates_Country=(select add_country from tbl_master_address where add_cntId ='" + Convert.ToString(Session["LastCompany"]) + "' ))  and th.Taxes_ApplicableFor in ('B','S') and th.TaxTypeCode in('G','V','C')");

            ProcedureExecute proc = new ProcedureExecute("prc_SalesCRM_Details");
            proc.AddVarcharPara("@Action", 500, "LoadGSTCSTVATCombo");
            proc.AddVarcharPara("@S_QuoteAdd_CompanyID", 10, Convert.ToString(LastCompany));
            proc.AddVarcharPara("@S_quoteDate", 10, quoteDate);
            DataTable DT = proc.GetTable();
            cmbGstCstVat.DataSource = DT;
            cmbGstCstVat.TextField = "Taxes_Name";
            cmbGstCstVat.ValueField = "Taxes_ID";
            cmbGstCstVat.DataBind();
        }
        public void CreateDataTaxTable()
        {
            DataTable TaxRecord = new DataTable();

            TaxRecord.Columns.Add("SlNo", typeof(System.Int32));
            TaxRecord.Columns.Add("TaxCode", typeof(System.String));
            TaxRecord.Columns.Add("AltTaxCode", typeof(System.String));
            TaxRecord.Columns.Add("Percentage", typeof(System.Decimal));
            TaxRecord.Columns.Add("Amount", typeof(System.Decimal));
            Session["VRP_FinalTaxRecord"] = TaxRecord;
        }
        protected void taxgrid_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

            int slNo = Convert.ToInt32(HdSerialNo.Value);
            DataTable TaxRecord = (DataTable)Session["VRP_FinalTaxRecord"];
            foreach (var args in e.UpdateValues)
            {

                string TaxCodeDes = Convert.ToString(args.NewValues["Taxes_Name"]);
                decimal Percentage = 0;

                Percentage = Convert.ToDecimal(args.NewValues["TaxField"]);

                decimal Amount = Convert.ToDecimal(args.NewValues["Amount"]);
                string TaxCode = "0";
                if (!Convert.ToString(args.Keys[0]).Contains('~'))
                {
                    TaxCode = Convert.ToString(args.Keys[0]);
                }



                DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='" + TaxCode + "'");
                if (finalRow.Length > 0)
                {
                    finalRow[0]["Percentage"] = Percentage;
                    // finalRow[0]["TaxCode"] = args.NewValues["TaxField"]; 
                    finalRow[0]["Amount"] = Amount;

                    finalRow[0]["TaxCode"] = args.Keys[0];
                    finalRow[0]["AltTaxCode"] = "0";

                }
                else
                {
                    DataRow newRow = TaxRecord.NewRow();
                    newRow["slNo"] = slNo;
                    newRow["Percentage"] = Percentage;
                    newRow["TaxCode"] = TaxCode;
                    newRow["AltTaxCode"] = "0";
                    newRow["Amount"] = Amount;
                    TaxRecord.Rows.Add(newRow);
                }


            }

            //For GST/CST/VAT
            if (cmbGstCstVat.Value != null)
            {

                DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='0'");
                if (finalRow.Length > 0)
                {
                    finalRow[0]["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                    finalRow[0]["Amount"] = txtGstCstVat.Text;
                    finalRow[0]["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];

                }
                else
                {
                    DataRow newRowGST = TaxRecord.NewRow();
                    newRowGST["slNo"] = slNo;
                    newRowGST["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                    newRowGST["TaxCode"] = "0";
                    newRowGST["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];
                    newRowGST["Amount"] = txtGstCstVat.Text;
                    TaxRecord.Rows.Add(newRowGST);
                }
            }
            //End Here


            Session["VRP_FinalTaxRecord"] = TaxRecord;


            #region oldpart


            //DataTable taxdtByProductCode = new DataTable();
            //if (Session["ProdTax" + "_" + Convert.ToString(HdSerialNo.Value)] == null)
            //{

            //    taxdtByProductCode.TableName = "ProdTax"  + "_" + Convert.ToString(HdSerialNo.Value);


            //    taxdtByProductCode.Columns.Add("TaxCode", typeof(System.String));
            //    taxdtByProductCode.Columns.Add("TaxCodeDescription", typeof(System.String));
            //    taxdtByProductCode.Columns.Add("Percentage", typeof(System.Decimal));
            //    taxdtByProductCode.Columns.Add("Amount", typeof(System.Decimal));
            //    DataRow dr;
            //    foreach (var args in e.UpdateValues)
            //    {
            //        dr = taxdtByProductCode.NewRow();
            //        string TaxCodeDes = Convert.ToString(args.NewValues["Taxes_Name"]);
            //        decimal Percentage = 0;
            //        if (TaxCodeDes == "GST/CST/VAT")
            //        {
            //            Percentage = Convert.ToDecimal(Convert.ToString(args.NewValues["TaxField"]).Split('~')[1]);
            //        }
            //        else
            //        {
            //            Percentage = Convert.ToDecimal(args.NewValues["TaxField"]);
            //        }
            //        decimal Amount = Convert.ToDecimal(args.NewValues["Amount"]);

            //        dr["TaxCodeDescription"] = TaxCodeDes;
            //        if (Convert.ToString(args.Keys[0]) == "0")
            //        {
            //            dr["TaxCode"] = "0~" + Convert.ToString(args.NewValues["TaxField"]).Split('~')[0];
            //        }
            //        else
            //        {
            //            dr["TaxCode"] = args.Keys[0];
            //        }
            //        dr["Percentage"] = Percentage;
            //        dr["Amount"] = Amount;

            //        taxdtByProductCode.Rows.Add(dr);
            //    }
            //}
            //else
            //{
            //    taxdtByProductCode = (DataTable)Session["ProdTax"  +"_"+ Convert.ToString(HdSerialNo.Value)];

            //    foreach (var args in e.UpdateValues)
            //    {
            //        DataRow[] filtr ;

            //        if (Convert.ToString(args.Keys[0]) == "0")
            //        {
            //            filtr = taxdtByProductCode.Select("TaxCode like '%0~%'"); ;
            //        }
            //        else
            //        {
            //            filtr = taxdtByProductCode.Select("TaxCode='" + args.Keys[0]+"'");
            //        }

            //        if (filtr.Length > 0)
            //        {
            //            string TaxCodeDes = Convert.ToString(args.NewValues["Taxes_Name"]);
            //        filtr[0]["TaxCodeDescription"] = TaxCodeDes;
            //        if (Convert.ToString(args.Keys[0]) == "0")
            //        {
            //            filtr[0]["TaxCode"] = "0~" + Convert.ToString(args.NewValues["TaxField"]).Split('~')[0];
            //        }
            //        else
            //        {
            //            filtr[0]["TaxCode"] = args.Keys[0];
            //        }

            //        decimal Percentage = 0;
            //        if (TaxCodeDes == "GST/CST/VAT")
            //        {
            //            Percentage = Convert.ToDecimal(Convert.ToString(args.NewValues["TaxField"]).Split('~')[1]);
            //        }
            //        else
            //        {
            //            Percentage = Convert.ToDecimal(args.NewValues["TaxField"]);
            //        }
            //        decimal Amount = Convert.ToDecimal(args.NewValues["Amount"]);
            //        filtr[0]["Percentage"] = Percentage;
            //        filtr[0]["Amount"] = Amount;

            //        }
            //    }


            //}

            #endregion
            //  Session[taxdtByProductCode.TableName] = taxdtByProductCode;

        }
        protected void cgridTax_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string retMsg = "";
            if (e.Parameters.Split('~')[0] == "SaveGST")
            {
                DataTable TaxRecord = (DataTable)Session["VRP_FinalTaxRecord"];
                int slNo = Convert.ToInt32(HdSerialNo.Value);
                //For GST/CST/VAT
                if (cmbGstCstVat.Value != null)
                {

                    DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='0'");
                    if (finalRow.Length > 0)
                    {
                        finalRow[0]["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                        finalRow[0]["Amount"] = txtGstCstVat.Text;
                        finalRow[0]["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];

                    }
                    else
                    {
                        DataRow newRowGST = TaxRecord.NewRow();
                        newRowGST["slNo"] = slNo;
                        newRowGST["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                        newRowGST["TaxCode"] = "0";
                        newRowGST["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];
                        newRowGST["Amount"] = txtGstCstVat.Text;
                        TaxRecord.Rows.Add(newRowGST);
                    }
                }
                //End Here

                aspxGridTax.JSProperties["cpUpdated"] = "";

                Session["VRP_FinalTaxRecord"] = TaxRecord;
            }
            else
            {
                #region fetch All data For Tax

                DataTable taxDetail = new DataTable();
                DataTable MainTaxDataTable = (DataTable)Session["VRP_FinalTaxRecord"];
                DataTable databaseReturnTable = (DataTable)Session["SI_QuotationTaxDetails"];

                //if (Convert.ToInt32(e.Parameters.Split('~')[1]) == 1)
                //    taxDetail = oDBEngine.GetDataTable("select TaxRates_ID as Taxes_ID,TaxRatesSchemeName as Taxes_Name,TaxCalculateMethods,tm.Taxes_Name as taxCodeName,tm.Taxes_ApplicableOn as 'ApplicableOn',isnull((select TaxRatesSchemeName from Config_TaxRates where TaxRates_ID=tm.Taxes_OtherTax),'')  as dependOn from Master_taxes tm inner join Config_TaxRates ct on tm.Taxes_ID=ct.TaxRates_TaxCode where tm.TaxTypeCode not in('G','V','C') and tm.TaxItemlevel='Y'");
                //else if (Convert.ToInt32(e.Parameters.Split('~')[1]) == 2)
                //taxDetail = oDBEngine.GetDataTable("select TaxRates_ID as Taxes_ID,TaxRatesSchemeName as Taxes_Name,TaxCalculateMethods,tm.Taxes_Name as taxCodeName,tm.Taxes_ApplicableOn as 'ApplicableOn',isnull((select TaxRatesSchemeName from Config_TaxRates where TaxRates_ID=tm.Taxes_OtherTax),'')  as dependOn from Master_taxes tm inner join Config_TaxRates ct on tm.Taxes_ID=ct.TaxRates_TaxCode where tm.TaxTypeCode not in('G','V','C') and tm.TaxItemlevel='Y'");

                string amountAre = "2"; // To set value Inclusive by default


                //ProcedureExecute proc = new ProcedureExecute("prc_VendorReceiptPaymentDetails");
                //proc.AddVarcharPara("@Action", 500, "LoadOtherTaxDetails");
                //proc.AddVarcharPara("@ProdhsnCode", 10, Convert.ToString(hfHSN_CODE.Value));
                //proc.AddVarcharPara("@S_quoteDate", 10, dtTDate.Date.ToString("yyyy-MM-dd"));
                //taxDetail = proc.GetTable();

                String Product_IDS = "";
                List<object> ProductList = productLookUp.GridView.GetSelectedFieldValues("Products_ID");
                foreach (object Pro in ProductList)
                {
                    Product_IDS += "," + Pro;
                }
                Product_IDS = Product_IDS.TrimStart(',');


                string[] prodarray = Product_IDS.Split(',');

                ProcedureExecute proc = new ProcedureExecute("prc_GstTaxDetails");
                proc.AddVarcharPara("@Action", 500, "LoadOtherTaxDetails");
                proc.AddVarcharPara("@ProductID", 10, Convert.ToString(prodarray[0]));
                proc.AddVarcharPara("@applicableFor", 5, "P");
                proc.AddVarcharPara("@TransDate", 10, dtTDate.Date.ToString("yyyy-MM-dd"));
                taxDetail = proc.GetTable();

                //Get Company Gstin 09032017
                string CompInternalId = Convert.ToString(Session["LastCompany"]);
                string[] compGstin = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_gstin", "cmp_internalid='" + CompInternalId + "'", 1);


                //Get BranchStateCode
                string BranchStateCode = "", BranchGSTIN = "";
                DataTable BranchTable = oDBEngine.GetDataTable("select StateCode,branch_GSTIN   from tbl_master_branch branch inner join tbl_master_state st on branch.branch_state=st.id where branch_id=" + Convert.ToString(ddlBranch.SelectedValue));
                if (BranchTable != null)
                {
                    BranchStateCode = Convert.ToString(BranchTable.Rows[0][0]);
                    BranchGSTIN = Convert.ToString(BranchTable.Rows[0][1]);
                    if (BranchGSTIN.Trim() != "")
                    {
                        BranchStateCode = BranchGSTIN.Substring(0, 2);
                    }
                }

                

                if (BranchGSTIN.Trim() == "")
                {
                    BranchStateCode = compGstin[0].Substring(0, 2);
                }




                string VendorState = "";


                ProcedureExecute GetVendorGstin = new ProcedureExecute("prc_GstTaxDetails");
                GetVendorGstin.AddVarcharPara("@Action", 500, "GetVendorGSTINByBranch");
                GetVendorGstin.AddVarcharPara("@branchId", 10, Convert.ToString(ddlBranch.SelectedValue));
                GetVendorGstin.AddVarcharPara("@entityId", 10, Convert.ToString(hdfLookupCustomer.Value));//lookup_Customer.Value
                DataTable VendorGstin = GetVendorGstin.GetTable();

                if (VendorGstin.Rows.Count > 0)
                {
                    if (Convert.ToString(VendorGstin.Rows[0][0]).Trim() != "")
                    {
                        VendorState = Convert.ToString(VendorGstin.Rows[0][0]).Substring(0, 2);
                    }

                }




                if (VendorState.Trim() != "" && BranchStateCode != "")
                {

                    if (BranchStateCode != "")
                    {
                        if (BranchStateCode == VendorState)
                        {
                            //Check if the state is in union territories then only UTGST will apply
                            //   Chandigarh     Andaman and Nicobar Islands    DADRA & NAGAR HAVELI    DAMAN & DIU   Lakshadweep              PONDICHERRY
                            if (VendorState == "4" || VendorState == "26" || VendorState == "25" || VendorState == "7" || VendorState == "31" || VendorState == "34")
                            {
                                foreach (DataRow dr in taxDetail.Rows)
                                {
                                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                                    {
                                        dr.Delete();
                                    }
                                }

                            }
                            else
                            {
                                foreach (DataRow dr in taxDetail.Rows)
                                {
                                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                                    {
                                        dr.Delete();
                                    }
                                }
                            }
                            taxDetail.AcceptChanges();
                        }
                        else
                        {
                            foreach (DataRow dr in taxDetail.Rows)
                            {
                                if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                                {
                                    dr.Delete();
                                }
                            }
                            taxDetail.AcceptChanges();

                        }

                    }
                }

                //If Company GSTIN is blank then Delete All CGST,UGST,IGST,CGST
                if ((compGstin[0].Trim() == "" && BranchGSTIN == "") || VendorState == "")
                {
                    foreach (DataRow dr in taxDetail.Rows)
                    {
                        if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST")
                        {
                            dr.Delete();
                        }
                    }
                    taxDetail.AcceptChanges();
                }







                int slNo = Convert.ToInt32(HdSerialNo.Value);

                //Get Gross Amount and Net Amount 
                decimal ProdGrossAmt = Convert.ToDecimal(HdProdGrossAmt.Value);
                decimal ProdNetAmt = Convert.ToDecimal(HdProdNetAmt.Value);

                List<TaxDetails> TaxDetailsDetails = new List<TaxDetails>();

                //Debjyoti 09032017
                decimal totalParcentage = 0;
                foreach (DataRow dr in taxDetail.Rows)
                {
                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                    {
                        totalParcentage += Convert.ToDecimal(dr["TaxRates_Rate"]);
                    }
                }

                if (e.Parameters.Split('~')[0] == "New")
                {
                    foreach (DataRow dr in taxDetail.Rows)
                    {
                        TaxDetails obj = new TaxDetails();
                        obj.Taxes_ID = Convert.ToInt32(dr["Taxes_ID"]);
                        obj.taxCodeName = Convert.ToString(dr["taxCodeName"]);
                        obj.TaxField = Convert.ToString(dr["TaxRates_Rate"]);
                        obj.Amount = 0.0;

                        #region set calculated on
                        //Check Tax Applicable on and set to calculated on
                        if (Convert.ToString(dr["ApplicableOn"]) == "G")
                        {
                            obj.calCulatedOn = ProdGrossAmt;
                        }
                        else if (Convert.ToString(dr["ApplicableOn"]) == "N")
                        {
                            obj.calCulatedOn = ProdNetAmt;
                        }
                        else
                        {
                            obj.calCulatedOn = 0;
                        }
                        //End Here
                        #endregion

                        //Debjyoti 09032017
                        if (amountAre == "2")
                        {

                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                            {
                                decimal finalCalCulatedOn = 0;
                                decimal backProcessRate = (1 + (totalParcentage / 100));
                                finalCalCulatedOn = obj.calCulatedOn / backProcessRate;
                                //obj.calCulatedOn = Math.Round(finalCalCulatedOn);
                                obj.calCulatedOn = Math.Round(finalCalCulatedOn,2);
                            }

                        }

                        if (Convert.ToString(dr["TaxCalculateMethods"]) == "A")
                        {
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(+)";

                        }
                        else
                        {
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(-)";
                        }

                        obj.Amount = Convert.ToDouble(obj.calCulatedOn * (Convert.ToDecimal(obj.TaxField) / 100));


                        if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                            obj.Amount = Math.Round(obj.Amount, 2);


                        if (MainTaxDataTable != null && MainTaxDataTable.Rows.Count > 0)
                        {
                            DataRow[] filtr = MainTaxDataTable.Select("TaxCode ='" + obj.Taxes_ID + "' and slNo=" + Convert.ToString(slNo));
                            if (filtr.Length > 0)
                            {
                                obj.Amount = Convert.ToDouble(filtr[0]["Amount"]);
                                if (obj.Taxes_ID == 0)
                                {
                                    //   obj.TaxField = GetTaxName(Convert.ToInt32(Convert.ToString(filtr[0]["AltTaxCode"])));
                                    aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(filtr[0]["AltTaxCode"]);
                                }
                                else
                                    obj.TaxField = Convert.ToString(filtr[0]["Percentage"]);
                            }
                        }

                        TaxDetailsDetails.Add(obj);
                    }
                }
                else
                {
                    string keyValue = e.Parameters.Split('~')[0];

                    DataTable TaxRecord = (DataTable)Session["VRP_FinalTaxRecord"];


                    foreach (DataRow dr in taxDetail.Rows)
                    {
                        TaxDetails obj = new TaxDetails();
                        obj.Taxes_ID = Convert.ToInt32(dr["Taxes_ID"]);
                        obj.taxCodeName = Convert.ToString(dr["taxCodeName"]);

                        if (Convert.ToString(dr["TaxCalculateMethods"]) == "A")
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(+)";
                        else
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(-)";
                        obj.TaxField = "";
                        obj.Amount = 0.0;

                        #region set calculated on
                        //Check Tax Applicable on and set to calculated on
                        if (Convert.ToString(dr["ApplicableOn"]) == "G")
                        {
                            obj.calCulatedOn = ProdGrossAmt;
                        }
                        else if (Convert.ToString(dr["ApplicableOn"]) == "N")
                        {
                            obj.calCulatedOn = ProdNetAmt;
                        }
                        else
                        {
                            obj.calCulatedOn = 0;
                        }
                        //End Here
                        #endregion

                        //Debjyoti 09032017
                        if (amountAre == "2")
                        {

                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                            {
                                decimal finalCalCulatedOn = 0;
                                decimal backProcessRate = (1 + (totalParcentage / 100));
                                finalCalCulatedOn = obj.calCulatedOn / backProcessRate;
                                obj.calCulatedOn = Math.Round(finalCalCulatedOn,2);
                            }

                        }

                        DataRow[] filtronexsisting1 = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                        if (filtronexsisting1.Length > 0)
                        {
                            if (obj.Taxes_ID == 0)
                            {
                                obj.TaxField = "0";
                            }
                            else
                            {
                                obj.TaxField = Convert.ToString(filtronexsisting1[0]["Percentage"]);
                            }
                            obj.Amount = Convert.ToDouble(filtronexsisting1[0]["Amount"]);
                        }
                        else
                        {
                            #region checkingFordb


                            //DataRow[] filtr = databaseReturnTable.Select("ProductTax_ProductId ='" + keyValue + "' and ProductTax_QuoteId=" +Convert.ToString( Session["SI_InvoiceID"] )+ " and ProductTax_TaxTypeId=" + obj.Taxes_ID);
                            //if (filtr.Length > 0)
                            //{
                            //    obj.Amount = Convert.ToDouble(filtr[0]["ProductTax_Amount"]);
                            //    if (obj.Taxes_ID == 0)
                            //    {
                            //        //obj.TaxField = GetTaxName();
                            //        obj.TaxField = "0";
                            //    }
                            //    else
                            //    {
                            //        obj.TaxField = Convert.ToString(filtr[0]["ProductTax_Percentage"]);
                            //    }


                            //    DataRow[] filtronexsisting = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                            //    if (filtronexsisting.Length > 0)
                            //    {
                            //        filtronexsisting[0]["Amount"] = obj.Amount;
                            //        if (obj.Taxes_ID == 0)
                            //        {
                            //            filtronexsisting[0]["Percentage"] = 0;
                            //        }
                            //        else
                            //        {
                            //            filtronexsisting[0]["Percentage"] = obj.TaxField;
                            //        }

                            //    }
                            //    else
                            //    {

                            //        DataRow taxRecordNewRow = TaxRecord.NewRow();
                            //        taxRecordNewRow["SlNo"] = slNo;
                            //        taxRecordNewRow["TaxCode"] = obj.Taxes_ID;
                            //        taxRecordNewRow["AltTaxCode"] = "0";
                            //        taxRecordNewRow["Percentage"] = obj.TaxField;
                            //        taxRecordNewRow["Amount"] = obj.Amount;

                            //        TaxRecord.Rows.Add(taxRecordNewRow);
                            //    }

                            //}
                            //else
                            //{
                            //    DataRow[] filtronexsisting = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                            //    if (filtronexsisting.Length > 0)
                            //    {
                            //        DataRow taxRecordNewRow = TaxRecord.NewRow();
                            //        taxRecordNewRow["SlNo"] = slNo;
                            //        taxRecordNewRow["TaxCode"] = obj.Taxes_ID;
                            //        taxRecordNewRow["AltTaxCode"] = "0";
                            //        taxRecordNewRow["Percentage"] = 0.0;
                            //        taxRecordNewRow["Amount"] = "0";

                            //        TaxRecord.Rows.Add(taxRecordNewRow);
                            //    }
                            //}




                            #endregion


                            DataRow[] filtronexsisting = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                            if (filtronexsisting.Length > 0)
                            {
                                DataRow taxRecordNewRow = TaxRecord.NewRow();
                                taxRecordNewRow["SlNo"] = slNo;
                                taxRecordNewRow["TaxCode"] = obj.Taxes_ID;
                                taxRecordNewRow["AltTaxCode"] = "0";
                                taxRecordNewRow["Percentage"] = 0.0;
                                taxRecordNewRow["Amount"] = "0";

                                TaxRecord.Rows.Add(taxRecordNewRow);
                            }

                        }
                        TaxDetailsDetails.Add(obj);

                        //      DataRow[] filtrIndex = databaseReturnTable.Select("ProductTax_ProductId ='" + keyValue + "' and ProductTax_QuoteId=" + Session["SI_InvoiceID"] + " and ProductTax_TaxTypeId=0");
                        DataRow[] filtrIndex = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode=0");
                        if (filtrIndex.Length > 0)
                        {
                            aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(filtrIndex[0]["AltTaxCode"]);
                        }
                    }
                    Session["VRP_FinalTaxRecord"] = TaxRecord;

                }
                //New Changes 170217
                //GstCode should fetch everytime
                if (MainTaxDataTable != null && MainTaxDataTable.Rows.Count > 0)
                {
                    DataRow[] finalFiltrIndex = MainTaxDataTable.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode=0");
                    if (finalFiltrIndex.Length > 0)
                    {
                        aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(finalFiltrIndex[0]["AltTaxCode"]);
                    }
                }


                aspxGridTax.JSProperties["cpJsonData"] = createJsonForDetails(taxDetail);

                retMsg = Convert.ToString(GetTotalTaxAmount(TaxDetailsDetails));
                aspxGridTax.JSProperties["cpUpdated"] = "ok~" + retMsg;

                TaxDetailsDetails = setCalculatedOn(TaxDetailsDetails, taxDetail);
                aspxGridTax.DataSource = TaxDetailsDetails;
                aspxGridTax.DataBind();

                #endregion
            }
        }
        protected void aspxGridTax_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {

            if (e.Column.FieldName == "Taxes_Name")
            {
                e.Editor.ReadOnly = true;
            }
            else if (e.Column.FieldName == "taxCodeName")
            {
                e.Editor.ReadOnly = true;
            }
            else if (e.Column.FieldName == "calCulatedOn")
            {
                e.Editor.ReadOnly = true;
            }
            else if (e.Column.FieldName == "TaxField")
            {
                e.Editor.ReadOnly = true;
            }
            else if (e.Column.FieldName == "Amount")
            {
                e.Editor.ReadOnly = true;
            }
            else
            {
                e.Editor.ReadOnly = false;
            }
        }
        protected void aspxGridTax_HtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {

        }
        protected void taxgrid_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void taxgrid_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void taxgrid_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            e.Cancel = true;
        }
        public string createJsonForDetails(DataTable lstTaxDetails)
        {
            List<TaxSetailsJson> jsonList = new List<TaxSetailsJson>();
            TaxSetailsJson jsonObj;
            int visIndex = 0;
            foreach (DataRow taxObj in lstTaxDetails.Rows)
            {
                jsonObj = new TaxSetailsJson();

                jsonObj.SchemeName = Convert.ToString(taxObj["Taxes_Name"]);
                jsonObj.vissibleIndex = visIndex;
                jsonObj.applicableOn = Convert.ToString(taxObj["ApplicableOn"]);
                if (jsonObj.applicableOn == "G" || jsonObj.applicableOn == "N")
                {
                    jsonObj.applicableBy = "None";
                }
                else
                {
                    jsonObj.applicableBy = Convert.ToString(taxObj["dependOn"]);
                }
                visIndex++;
                jsonList.Add(jsonObj);
            }

            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            return oSerializer.Serialize(jsonList);
        }
        public List<TaxDetails> setCalculatedOn(List<TaxDetails> gridSource, DataTable taxDt)
        {
            foreach (TaxDetails taxObj in gridSource)
            {
                DataRow[] dependOn = taxDt.Select("dependOn='" + taxObj.Taxes_Name.Replace("(+)", "").Replace("(-)", "") + "'");
                if (dependOn.Length > 0)
                {
                    foreach (DataRow dr in dependOn)
                    {
                        //  List<TaxDetails> dependObj = gridSource.Where(r => r.Taxes_Name.Replace("(+)", "").Replace("(-)", "") == Convert.ToString(dependOn[0]["Taxes_Name"])).ToList();
                        foreach (var setCalObj in gridSource.Where(r => r.Taxes_Name.Replace("(+)", "").Replace("(-)", "") == Convert.ToString(dependOn[0]["Taxes_Name"])))
                        {
                            setCalObj.calCulatedOn = Convert.ToDecimal(taxObj.Amount);
                        }
                    }

                }

            }
            return gridSource;
        }
        public double GetTotalTaxAmount(List<TaxDetails> tax)
        {
            double sum = 0;
            foreach (TaxDetails td in tax)
            {
                if (td.Taxes_Name.Substring(td.Taxes_Name.Length - 3, 3) == "(+)")
                    sum += td.Amount;
                else
                    sum -= td.Amount;

            }
            return sum;
        }
        public class TaxSetailsJson
        {
            public string SchemeName { get; set; }
            public int vissibleIndex { get; set; }
            public string applicableOn { get; set; }
            public string applicableBy { get; set; }
        }
        public class TaxDetails
        {
            public int Taxes_ID { get; set; }
            public string Taxes_Name { get; set; }

            public double Amount { get; set; }
            public string TaxField { get; set; }

            public string taxCodeName { get; set; }

            public decimal calCulatedOn { get; set; }

        }
        class taxCode
        {
            public string Taxes_ID { get; set; }
            public string Taxes_Name { get; set; }
        }
        #endregion

        

        protected void documentLookUp_DataBinding(object sender, EventArgs e)
        {
            DataTable dsdata = (DataTable)Session["VendorPayRecDocumentNo"];
            documentLookUp.DataSource = dsdata;
        }
    }

}