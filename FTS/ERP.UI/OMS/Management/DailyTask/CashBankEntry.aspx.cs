using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
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
using System.Threading.Tasks;
using System.Web.UI;
using ERP.Models;

namespace ERP.OMS.Management.DailyTask
{
    public partial class management_DailyTask_CashBankEntry : ERP.OMS.ViewState_class.VSPage//PersistViewStateToFileSystem // System.Web.UI.Page
    {
        #region LocalVariable
        SqlDataSource Obj_Sds;
        BusinessLogicLayer.DBEngine oDbEngine;
        string strCon;
        string CurrentSegment;
        DataTable DtCurrentSegment;
        DataTable dtXML = new DataTable();
        BusinessLogicLayer.GenericLogSystem oGenericLogSystem;
        FinancialAccounting oFinancialAccounting = new FinancialAccounting();
        string CashBankVoucherFile_XMLPATH = null;
        BusinessLogicLayer.Converter objConverter = new BusinessLogicLayer.Converter();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        static string ForJournalDate = null;
        string JVNumStr = string.Empty;
        public EntityLayer.CommonELS.UserRightsForPage rights = new EntityLayer.CommonELS.UserRightsForPage();
        CustomerVendorReceiptPaymentBL objCustomerVendorReceiptPaymentBL = new CustomerVendorReceiptPaymentBL();
        PurchaseOrderBL objPurchaseOrderBL = new PurchaseOrderBL();
        #endregion
        #region Page Property
        //public string PMode
        //{
        //    get { return (string)Session["Mode"]; }
        //    set { Session["Mode"] = value; }
        //}
        //public int PCounter
        //{
        //    get { return (int)ViewState["Counter"]; }
        //    set { ViewState["Counter"] = value; }
        //}
        //public string PCompanyID
        //{
        //    get { return (string)ViewState["CompanyID"]; }
        //    set { ViewState["CompanyID"] = value; }
        //}
        //public string PCurrentSegment
        //{
        //    get { return (string)ViewState["CurrentSegment"]; }
        //    set { ViewState["CurrentSegment"] = value; }
        //}
        //public string PUserID
        //{
        //    get { return (string)ViewState["UserID"]; }
        //    set { ViewState["UserID"] = value; }
        //}
        //public string PFinYear
        //{
        //    get { return (string)ViewState["FinYear"]; }
        //    set { ViewState["FinYear"] = value; }
        //}
        //public string PBranchID
        //{
        //    get { return (string)ViewState["BranchID"]; }
        //    set { ViewState["BranchID"] = value; }
        //}
        //public string PXMLPATH
        //{
        //    get { return (string)Session["CashBankVoucherFile_XMLPATH"]; }
        //    set { Session["CashBankVoucherFile_XMLPATH"] = value; }
        //}
        //public decimal TotalPayment
        //{
        //    get { return (decimal)ViewState["TotalPayment"]; }
        //    set { ViewState["TotalPayment"] = value; }
        //}
        //public decimal TotalRecieve
        //{
        //    get { return (decimal)ViewState["TotalRecieve"]; }
        //    set { ViewState["TotalRecieve"] = value; }
        //}
        public decimal TotalBankBalance
        {
            get { return (decimal)Session["TotalBankBalance"]; }
            set { Session["TotalBankBalance"] = value; }
        }
        //public string ChoosenCurrency
        //{
        //    get { return (string)Session["ChoosenCurrency"]; }
        //    set { Session["ChoosenCurrency"] = value; }
        //}
        //public string ChoosenCurrency
        //{
        //    get { return (string)Session["LocalCurrency"]; }
        //    set { Session["LocalCurrency"] = value; }
        //}
        //This For Log Purpose
        public string LogID
        {
            get { return (string)ViewState["LogID"]; }
            set { ViewState["LogID"] = value; }
        }
        #endregion
        #region PageClass
        //void Bind_Combo(ASPxComboBox Combo, SqlDataSource SDs, string strTextField, string strValueField, int SelectedIndex)
        //{
        //    Combo.DataSource = SDs;
        //    Combo.TextField = strTextField;
        //    Combo.ValueField = strValueField;
        //    Combo.DataBind();
        //    Combo.SelectedIndex = SelectedIndex;

        //}



        //void Bind_Combo(ASPxComboBox Combo, DataSet Ds, string strTextField, string strValueField, int SelectedIndex)
        //{
        //    if (Ds.Tables.Count > 0)
        //    {
        //        if (Ds.Tables[0].Rows.Count > 0)
        //        {
        //            Combo.DataSource = Ds;
        //            Combo.TextField = strTextField;
        //            Combo.ValueField = strValueField;
        //            Combo.DataBind();
        //            Combo.SelectedIndex = SelectedIndex;
        //        }
        //    }

        //}
        //void Bind_Combo_WithSelectedValue(ASPxComboBox Combo, DataSet Ds, string strTextField, string strValueField, object strSelectedValue)
        //{
        //    if (Ds.Tables.Count > 0)
        //    {
        //        if (Ds.Tables[0].Rows.Count > 0)
        //        {
        //            Combo.DataSource = Ds;
        //            Combo.TextField = strTextField;
        //            Combo.ValueField = strValueField;
        //            Combo.DataBind();
        //            if (strSelectedValue.ToString().Trim() != "0")
        //                Combo.Value = strSelectedValue;
        //            else
        //                Combo.SelectedIndex = 0;
        //        }
        //    }

        //}
        //DataSet Bind_Combo(string strcmd)
        //{
        //    DataSet Ds = new DataSet();
        //    using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
        //    {
        //        using (SqlCommand com = new SqlCommand(strcmd, con))
        //        {
        //            using (SqlDataAdapter Da = new SqlDataAdapter(com))
        //            {
        //                Da.Fill(Ds);
        //            }
        //        }
        //    }
        //    return Ds;
        //}
        //DataSet Bind_Combo(string strcmd, string parametername, string parametervalue)
        //{
        //    DataSet Ds = new DataSet();
        //    using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
        //    {
        //        using (SqlCommand com = new SqlCommand(strcmd, con))
        //        {
        //            com.Parameters.AddWithValue(parametername, parametervalue);
        //            using (SqlDataAdapter Da = new SqlDataAdapter(com))
        //            {
        //                Da.Fill(Ds);
        //            }
        //        }
        //    }
        //    return Ds;
        //}
        //void BindGrid(ASPxGridView Grid)
        //{
        //    Grid.DataSource = null;
        //    Grid.DataBind();
        //}
        //void BindGrid(ASPxGridView Grid, DataSet Ds)
        //{
        //    if (Ds.Tables.Count > 0)
        //    {
        //        Grid.DataSource = Ds;
        //        Grid.DataBind();
        //    }
        //    else
        //    {
        //        Grid.DataSource = null;
        //        Grid.DataBind();
        //    }
        //}
        //void BindGrid(ASPxGridView Grid, DataTable Dt)
        //{
        //    if (Dt.Rows.Count > 0)
        //    {
        //        Grid.DataSource = Dt;
        //        Grid.DataBind();
        //    }
        //    else
        //    {
        //        Grid.DataSource = null;
        //        Grid.DataBind();
        //    }
        //}
        //void BindGrid(ASPxGridView Grid, DataSet Ds, String WhichSort)
        //{
        //    DataView TempDV = new DataView(Ds.Tables[0]);
        //    TempDV.Sort = "EntryDateTime " + WhichSort;
        //    Grid.DataSource = TempDV;
        //    Grid.DataBind();
        //}
        //void BindGrid(ASPxGridView Grid, DataTable Dt, String WhichSort)
        //{
        //    DataView TempDV = new DataView(Dt);
        //    TempDV.Sort = "EntryDateTime " + WhichSort;
        //    Grid.DataSource = TempDV;
        //    Grid.DataBind();
        //}
        //DataSet GetDsUsingQuery(string strcmd)
        //{
        //    DataSet Ds = new DataSet();
        //    using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
        //    {
        //        using (SqlCommand com = new SqlCommand(strcmd, con))
        //        {
        //            using (SqlDataAdapter Da = new SqlDataAdapter(com))
        //            {
        //                Da.Fill(Ds);
        //            }
        //        }
        //    }
        //    return Ds;
        //}
        #endregion
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (Request.QueryString.AllKeys.Contains("IsTagged"))
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/PopUp.Master";
                //divcross.Visible = false;
            }
            else
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/ERP.Master";
                //divcross.Visible = true;
            }
            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            //ServerControlIDs OServerControlIDs = new ServerControlIDs();
            //OServerControlIDs.Emit(Page);
        }
        public void Bind_Currency()
        {
            string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
            string basedCurrency = Convert.ToString(LocalCurrency.Split('~')[0]);           
            SqlCurrencyBind.SelectCommand = "select Currency_ID,Currency_AlphaCode from Master_Currency Order By Currency_ID";
            CmbCurrency.DataBind();
        }
        public void Bind_PaymentNumberingScheme()
        {            
            string strCompanyID = Convert.ToString(Session["LastCompany"]);
            string strBranchID = Convert.ToString(Session["userbranchID"]);
            string FinYear = Convert.ToString(Session["LastFinYear"]);
            string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
            //SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
           // DataTable Schemadt = objSlaesActivitiesBL.GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "14", "Y");
            DataTable Schemadt = GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "14", "Y");
            if (Schemadt != null && Schemadt.Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "Id";
                CmbScheme.DataSource = Schemadt;
                CmbScheme.DataBind();
            }
        }
        public DataTable GetNumberingSchema(string strCompanyID, string strBranchID, string strFinYear, string strType, string strIsSplit)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 100, "GetNumberingSchema");
            proc.AddVarcharPara("@CompanyID", 100, strCompanyID);
            //proc.AddVarcharPara("@BranchID", 100, strBranchID);
            proc.AddVarcharPara("@BranchID", 4000, strBranchID);
            proc.AddVarcharPara("@FinYear", 100, strFinYear);
            proc.AddVarcharPara("@Type", 100, strType);
            proc.AddVarcharPara("@IsSplit", 100, strIsSplit);
            ds = proc.GetTable();
            return ds;
        }
        public void Bind_ReceiptNumberingScheme()
        {
            string strCompanyID = Convert.ToString(Session["LastCompany"]);
            string strBranchID = Convert.ToString(Session["userbranchID"]);
            string FinYear = Convert.ToString(Session["LastFinYear"]);
            string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
            //SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
            //DataTable Schemadt = objSlaesActivitiesBL.GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "2", "Y");
            DataTable Schemadt = GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "2", "Y");
            if (Schemadt != null && Schemadt.Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "Id";
                CmbScheme.DataSource = Schemadt;
                CmbScheme.DataBind();
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/dailytask/CashBankEntryList.aspx");
            strCon = ConfigurationManager.AppSettings["DBConnectionDefault"].ToString();
            oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            oGenericLogSystem = new BusinessLogicLayer.GenericLogSystem();
            //CurrentSegment = HttpContext.Current.Session["userlastsegment"].ToString();
            //hdnSegmentid.Value = CurrentSegment;
            if (HttpContext.Current.Session["userid"] == null)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
          
            if (!IsPostBack)
            {
                if (!rights.CanAdd)
                {
                    btnSaveNew.ClientVisible = false;
                }

                Session.Remove("CashBankDetails");
                Session.Remove("exportval");
                Session.Remove("IBRef");
                Session.Remove("CB_FinalTaxRecord");
                Session.Remove("CashBank_ID");               
                hdnEditRfid.Value = "";
                hdn_Mode.Value = "";
                ///rights.CanAdd
                GetFinacialYearBasedQouteDate();
                if (!String.IsNullOrEmpty(Convert.ToString(Session["userbranchID"])))
                {
                    string strdefaultBranch = Convert.ToString(Session["userbranchID"]);
                }
                string[] FinYEnd = Session["FinYearEnd"].ToString().Split(' ');
                string strFinYEnd = FinYEnd[0];
                string LastCompany = HttpContext.Current.Session["LastCompany"].ToString();
                string userid = HttpContext.Current.Session["userid"].ToString();
                string LastFinYear = HttpContext.Current.Session["LastFinYear"].ToString();
                string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);

                Task PopulateStockTrialDataTask = new Task(() => BindAllControlDataOnPageLoad(strFinYEnd, LastCompany, userid, LastFinYear, LocalCurrency));
                PopulateStockTrialDataTask.RunSynchronously();

                if (Request.QueryString["key"] == "ADD")
                {
                    rbtnType.SelectedValue = "P";
                    hdn_Mode.Value = "Entry";
                    hdnPageStatus.Value = "first";
                    gridBatch.DataSource = GetVoucher();
                    gridBatch.DataBind();
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "GridADD()", true);
                    #region To Show By Default Cursor after SAVE AND NEW
                    if (Session["SaveModeCB"] != null)  // it has been removed from coding side of Quotation list 
                    {
                        
                        if (Session["VoucherTypeCB"] != null)
                        {
                            string command =  Convert.ToString(Session["VoucherTypeCB"]);
                            rbtnType.SelectedValue = command;
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
                        if (Session["schemavalueCB"] != null)  // it has been removed from coding side of Quotation list 
                        {
                            CmbScheme.Value = Convert.ToString(Session["schemavalueCB"]);
                            string strSchemaValue = Convert.ToString(Session["schemavalueCB"]);
                            string[] SchemaValueID= strSchemaValue.Split('~');
                            string branchID = SchemaValueID[3];
                            ddlEnterBranch.SelectedValue = branchID;
                            BindCashBankAccount(branchID);
                        }
                        if (Session["SaveNewValues"]!=null)
                        {
                            List<string> SaveNewValues = (Session["SaveNewValues"]) as List<string>;
                            ddlBranch.SelectedValue = SaveNewValues[1];
                            //ddlCashBank.Value = SaveNewValues[0];
                            //string InstrumentType = SaveNewValues[1];
                            //if (InstrumentType=="0")
                            //{
                            //    cmbInstrumentType.Value = "CH";
                            //}
                            //else
                            //{
                            //    cmbInstrumentType.Value = SaveNewValues[1];
                            //}
                           
                            ddl_AmountAre.Value = SaveNewValues[0];
                        }
                        if (Convert.ToString(Session["SaveModeCB"]) == "A")
                        {
                            dtTDate.Focus();
                            txtVoucherNo.Enabled = false;
                            txtVoucherNo.Text = "Auto";
                        }
                        else if (Convert.ToString(Session["SaveModeCB"]) == "M")
                        {
                            txtVoucherNo.Enabled = true;
                            txtVoucherNo.Text = "";
                            txtVoucherNo.Focus();
                        }
                    }
                    else
                    {
                        CmbScheme.Focus();
                    }
                    #endregion To Show By Default Cursor after SAVE AND NEW
                }
                else
                {
                    gridBatch.JSProperties["cpView"] = (Request.QueryString["req"] != null && Request.QueryString["req"] == "V") ? "1" : "0";
                    hdn_Mode.Value = "Edit";
                    lblHeading.Text = "Modify Cash/Bank Voucher";
                    divNumberingScheme.Style.Add("display", "none");
                    divEnterBranch.Style.Add("display", "Block");
                    Session["CashBank_ID"] = Request.QueryString["key"];
                    ViewState["CashBankID"] = Request.QueryString["key"];
                    string CBID = Request.QueryString["key"];
                    FillGrid();
                    hdnPageStatus.Value = "update";
                    hdfIsDelete.Value = "C";
                    hdnEditRfid.Value = Request.QueryString["key"];
                    
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "Gridupdate()", true);
                }
                if (Request.QueryString.AllKeys.Contains("IsTagged"))
                {
                    btncross.Visible = false;
                    hdnPageStatus.Value = "update";
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "Gridupdate()", true);
                    TaggedView(Request.QueryString["key"]);
                   // Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>CashBankTagged(" + Request.QueryString["key"] + ", '" + Request.QueryString["req"] + "');</script>");
                }
                if (Request.QueryString["req"] != null && Request.QueryString["req"] == "V")
                {
                    lblHeading.Text = "View Cash/Bank Voucher";
                    btnSaveNew.Visible = false;
                    btnSaveRecords.Visible = false;                    
                }              
               
            }      
          
        }
        public void TaggedView(string CBID)
        { 
           // gridBatch.JSProperties["cpEdit"] = null;
            Session["CB_FinalTaxRecord"] = null;

            gridBatch.JSProperties["cpNOTEdit"] = null;
            string cask_bankID = CBID.ToString();

            Session["CB_FinalTaxRecord"] = GetCashBankEditedTaxData(CBID);

            DataSet DsOnLoad = new DataSet();
            string VoucherType = "", VoucherNo = "", Date = "", Branch = "", Cash_Bank = "", Currency = "", InstrumentType = "", InstrumentNo = "", InstrumentDate = "",
                Narration = "", InstrumentTypeName = "", BankStatementDate = "", BankValueDate = "", ReceivedFrom = "", PaidTo = "", Tax_Code = "", ContactNo = "",
                ReverseCharge = "0", DraweeBank = "", EnteredBranchID = "", CashBankName = "";
            // strCurrency = "",

            DataTable CashBanktEditdt = GetCashBanktviewDataTagged(CBID);

            if (CashBanktEditdt != null && CashBanktEditdt.Rows.Count > 0)
            {
                VoucherType = Convert.ToString(CashBanktEditdt.Rows[0]["VoucherType"]);//0
                rbtnType.SelectedValue = VoucherType;
                VoucherNo = Convert.ToString(CashBanktEditdt.Rows[0]["OldVoucherNumber"]);//1
                txtVoucherNo.Text = VoucherNo;
                Date = Convert.ToString(CashBanktEditdt.Rows[0]["TransactionDate"]);//2
                dtTDate.Date = Convert.ToDateTime(Date);
                Branch = Convert.ToString(CashBanktEditdt.Rows[0]["BranchID"]);//3 
                ddlBranch.SelectedValue = Branch;
                Cash_Bank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankID"]);//4                
                ddlCashBank.Value = Cash_Bank;
                Currency = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_Currency"]);//5
                CmbCurrency.Value = Currency;
                InstrumentTypeName = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);
                if (InstrumentTypeName == "0")
                {
                    InstrumentType = "CH";
                }
                else
                {
                    InstrumentType = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);//6
                }
                cmbInstrumentType.Value = InstrumentType;
                InstrumentNo = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentNumber"]);//7
                txtInstNobth.Text = InstrumentNo.Trim();
                Narration = Convert.ToString(CashBanktEditdt.Rows[0]["Narration"]);//8
                txtNarration.Text = Narration;
                BankStatementDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankStatementDate"]);
                BankValueDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankValueDate"]);
                ReceivedFrom = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReceivedFrom"]);//12
                txtReceivedFrom.Text = ReceivedFrom;
                PaidTo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_PaidTo"]);//13
                txtPaidTo.Text = PaidTo;
                Tax_Code = Convert.ToString(CashBanktEditdt.Rows[0]["Tax_Code"]);
                ddl_AmountAre.Value = Tax_Code;
                ContactNo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ContactNo"]);
                txtContact.Text = ContactNo;
                ReverseCharge = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReverseCharge"]);
                chk_reversemechenism.Checked = Convert.ToBoolean(ReverseCharge);
                InstrumentDate = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentDate"]);
                InstDate.Date = Convert.ToDateTime(InstrumentDate);
                DraweeBank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_DraweeBank"]);
                txtDraweeBank.Text = DraweeBank;
                EnteredBranchID = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_EnteredBranchID"]);
                ddlEnterBranch.SelectedValue = EnteredBranchID;
                CashBankName = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankName"]);
                BindCashBankAccount(EnteredBranchID);
            }
            

            DataTable Voucherdt = GetCashBanktBatchViewtDataTagged(CBID).Tables[0];

            string Recipt = Convert.ToString(Voucherdt.Compute("Sum(ReceiptAmount)", ""));
            string Payment = Convert.ToString(Voucherdt.Compute("Sum(PaymentAmount)", ""));
            
            //gridBatch.JSProperties["cpEdit"] = VoucherType + "*" + VoucherNo + "*" + Date + "*" + Branch + "*" + Cash_Bank + "*" + Currency + "*" +
            //    InstrumentType + "*" + InstrumentNo + "*" + Narration + "*" + Recipt + "*" + Payment + "*" + cask_bankID + "*" + ReceivedFrom + "*" + PaidTo + "*" +
            //    Tax_Code + "*" + ContactNo + "*" + ReverseCharge + "*" + InstrumentDate + "*" + DraweeBank + "*" + EnteredBranchID + "*" + CashBankName;
           // gridBatch.JSProperties["cpView"] = (command.ToUpper() == "VIEWTAGGED") ? "1" : "0";
          
            Session["CashBankDetails"] = Voucherdt;

            gridBatch.DataSource = Voucherdt;
            gridBatch.DataBind();
            //gridBatch.JSProperties["cpCBEdit"] = VoucherType + "*" + cask_bankID + "*" + Currency + "*" + InstrumentType;
            hdnView.Value=(Request.QueryString["IsTagged"] != null && Request.QueryString["IsTagged"] == "1") ? "1" : "0";
            
        }
        public void BindAllControlDataOnPageLoad(string strFinYEnd, string LastCompany, string userid, string LastFinYear, string strLocalCurrency)
        {
            //rbtnType.SelectedValue = "P";
            CreateDataTaxTable();
            BindBranch();           
            GetAllDropDownDetailForCashBank();            
            InstDate.EditFormatString = objConverter.GetDateFormat("Date");
            string fDate = null;         
            string FinYearEnd = strFinYEnd;
            DateTime date3 = DateTime.ParseExact(FinYearEnd, "M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            ForJournalDate = date3.ToString();
            int month = oDBEngine.GetDate().Month;
            int date = oDBEngine.GetDate().Day;
            int Year = oDBEngine.GetDate().Year;
            if (date3 < oDBEngine.GetDate().Date)
            {
                fDate = Convert.ToDateTime(ForJournalDate).Month.ToString() + "/" + Convert.ToDateTime(ForJournalDate).Day.ToString() + "/" + Convert.ToDateTime(ForJournalDate).Year.ToString();
            }
            else
            {
                fDate = Convert.ToDateTime(oDBEngine.GetDate().Date).Month.ToString() + "/" + Convert.ToDateTime(oDBEngine.GetDate().Date).Day.ToString() + "/" + Convert.ToDateTime(oDBEngine.GetDate().Date).Year.ToString();
            }

            InstDate.Value = DateTime.ParseExact(fDate, @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            //PCompanyID = LastCompany;
           // PUserID = userid;
            //PFinYear = LastFinYear;       
           
            
            //TotalPayment = 0;
           // TotalRecieve = 0;
            TotalBankBalance = 0;
            Obj_Sds = new SqlDataSource();
            Obj_Sds.ConnectionString = strCon;
            ViewState["LogID"] = oGenericLogSystem.GetLogID();
            BindSystemSettings();


            #region ####### Search Grid Filter #############
                      
            string LocalCurrency = strLocalCurrency;
            string basedCurrency = Convert.ToString(LocalCurrency.Split('~')[0]);
            string CurrencyId = Convert.ToString(basedCurrency[0]);
            CmbCurrency.Value = CurrencyId;      


            #endregion

        }
        public void FillGrid()
        {
            //RowIndex = Convert.ToInt32(e.Parameter.Split('~')[1]);
                string CBID = Request.QueryString["key"];
                string cask_bankID;
                //string CBID = GvCBSearch.GetRowValues(RowIndex, "CBID").ToString();
                ViewState["CashBankID"] = CBID;
               // IBRef = GvCBSearch.GetRowValues(RowIndex, "IBRef").ToString();
              //  Session["IBRef"] = IBRef;
                hdnEditRfid.Value = CBID;              
                Session["CB_FinalTaxRecord"] = null;
                gridBatch.JSProperties["cpNOTEdit"] = null;
                cask_bankID = CBID;
                hdnEditCBID.Value = CBID;
                Session["CB_FinalTaxRecord"] = GetCashBankEditedTaxData(CBID);
                DataSet DsOnLoad = new DataSet();
                string VoucherType = "", VoucherNo = "", Date = "", Branch = "", Cash_Bank = "", Currency = "", InstrumentType = "", InstrumentNo = "", InstrumentDate = "",
                    Narration = "", InstrumentTypeName = "", BankStatementDate = "", BankValueDate = "", ReceivedFrom = "", PaidTo = "", Tax_Code = "", ContactNo = "",
                    ReverseCharge = "0", DraweeBank = "", EnteredBranchID = "", CashBankName = "";

                DataTable CashBanktEditdt = GetCashBanktEditData();
                if (CashBanktEditdt != null && CashBanktEditdt.Rows.Count > 0)
                {
                    VoucherType = Convert.ToString(CashBanktEditdt.Rows[0]["VoucherType"]);//0
                    rbtnType.SelectedValue = VoucherType;
                    VoucherNo = Convert.ToString(CashBanktEditdt.Rows[0]["OldVoucherNumber"]);//1
                    txtVoucherNo.Text = VoucherNo;
                    Date = Convert.ToString(CashBanktEditdt.Rows[0]["TransactionDate"]);//2
                    dtTDate.Date = Convert.ToDateTime(Date);
                    Branch = Convert.ToString(CashBanktEditdt.Rows[0]["BranchID"]);//3 
                    ddlBranch.SelectedValue = Branch;                  
                    Cash_Bank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankID"]);//4                
                    ddlCashBank.Value = Cash_Bank;
                    Currency = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_Currency"]);//5
                    CmbCurrency.Value = Currency;
                    InstrumentTypeName = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);
                    if (InstrumentTypeName == "0")
                    {
                        InstrumentType = "CH";
                    }
                    else
                    {
                        InstrumentType = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);//6
                    }
                    cmbInstrumentType.Value = InstrumentType;
                    InstrumentNo = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentNumber"]);//7
                    txtInstNobth.Text = InstrumentNo.Trim();
                    Narration = Convert.ToString(CashBanktEditdt.Rows[0]["Narration"]);//8
                    txtNarration.Text = Narration;
                    BankStatementDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankStatementDate"]);
                    BankValueDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankValueDate"]);
                    ReceivedFrom = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReceivedFrom"]);//12
                    txtReceivedFrom.Text = ReceivedFrom;
                    PaidTo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_PaidTo"]);//13
                    txtPaidTo.Text = PaidTo;
                    Tax_Code = Convert.ToString(CashBanktEditdt.Rows[0]["Tax_Code"]);
                    ddl_AmountAre.Value = Tax_Code;
                    ContactNo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ContactNo"]);
                    txtContact.Text = ContactNo;
                    ReverseCharge = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReverseCharge"]);
                    chk_reversemechenism.Checked = Convert.ToBoolean(ReverseCharge);
                    InstrumentDate = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentDate"]);
                    InstDate.Date = Convert.ToDateTime(InstrumentDate);
                    DraweeBank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_DraweeBank"]);
                    txtDraweeBank.Text = DraweeBank;
                    EnteredBranchID = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_EnteredBranchID"]);
                    ddlEnterBranch.SelectedValue = EnteredBranchID;
                    CashBankName = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankName"]);
                    BindCashBankAccount(EnteredBranchID);
                }
               
                DataTable Voucherdt = GetCashBanktBatchEditData(hdnEditRfid.Value).Tables[0];
                string Recipt = Convert.ToString(Voucherdt.Compute("Sum(ReceiptAmount)", ""));
                string Payment = Convert.ToString(Voucherdt.Compute("Sum(PaymentAmount)", ""));
                txtTotalAmount.Text = Recipt;
                txtTotalPayment.Text = Payment;
               // ASPxCallbackGeneral.JSProperties["cpView"] = (command.ToUpper() == "VIEW") ? "1" : "0";
                Session["CashBankDetails"] = GetCashBanktBatchEditData(hdnEditRfid.Value).Tables[0];
                gridBatch.DataSource = GetVoucher();
                gridBatch.DataBind();
               // gridBatch.JSProperties["cpCBEdit"] = VoucherType + "*" + cask_bankID + "*" + Currency + "*" + InstrumentType;
        }
        public DataSet GetSystemSettings()
        {
            DataSet dt = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 100, "GetSystemSettingValue");
            dt = proc.GetDataSet();
            return dt;
        }
        public void BindSystemSettings()
        {
            DataSet dtSystemSettings = new DataSet();
            dtSystemSettings = GetSystemSettings();
            if (dtSystemSettings.Tables[0] != null && dtSystemSettings.Tables[0].Rows.Count > 0)
            {
                string Variable_Value = Convert.ToString(dtSystemSettings.Tables[0].Rows[0]["Variable_Value"]);
                hdn_CashBankType_InstType.Value = Variable_Value;
            }
            if (dtSystemSettings.Tables[1] != null && dtSystemSettings.Tables[1].Rows.Count > 0)
            {
                string Variable_Value = Convert.ToString(dtSystemSettings.Tables[1].Rows[0]["Variable_Value"]);
                hdnAutoPrint.Value = Variable_Value;
            }

        }
        //public void BindMainGridList()
        //{          
        //    string FromDate = Convert.ToDateTime(FormDate.Value).ToString("yyyy-MM-dd");
        //    string ToDate = Convert.ToDateTime(toDate.Value).ToString("yyyy-MM-dd");
        //    string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
        //    string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
        //    string finyear = Convert.ToString(Session["LastFinYear"]);
        //    string BranchID = Convert.ToString(cmbBranchfilter.Value);

        //    DataTable Ds = CashBankVoucherDetailsList(userbranch, lastCompany, finyear, BranchID, FromDate, ToDate, "false");
        //    if (Ds.Rows.Count > 0)
        //    {
        //        GvCBSearch.DataSource = Ds;
        //        GvCBSearch.DataBind();
        //    }
        //    else
        //    {
        //        GvCBSearch.DataSource = null;
        //        GvCBSearch.DataBind();
        //    }
        //}
        public DataTable CashBankVoucherDetailsList(string userbranchlist, string lastCompany, string Fiyear, string userbranchID, string FromDate, string ToDate, string filter)
        {

            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankVoucherDetailsList");
            proc.AddVarcharPara("@FinYear", 500, Fiyear);
            proc.AddVarcharPara("@CompanyID", 500, lastCompany);
            proc.AddVarcharPara("@userbranchlist", 5000, userbranchlist);
            proc.AddVarcharPara("@BranchID", 3000, userbranchID);        
            proc.AddVarcharPara("@FromDate", 10, FromDate);
            proc.AddVarcharPara("@ToDate", 10, ToDate);
            proc.AddVarcharPara("@filter", 10, filter);
            dt = proc.GetTable();
            return dt;
        }
        public void GetAllDropDownDetailForCashBank()
        {
            DataSet dst = new DataSet();
            dst = AllDropDownDetailForCashBank();
            if (dst.Tables[0] != null && dst.Tables[0].Rows.Count > 0)
            {
                ddlBranch.DataTextField = "BANKBRANCH_NAME";
                ddlBranch.DataValueField = "BANKBRANCH_ID";
                ddlBranch.DataSource = dst.Tables[0];
                ddlBranch.DataBind();
            }
            //if (dst.Tables[1] != null && dst.Tables[1].Rows.Count > 0)
            //{
            //    cmbBranchfilter.ValueField = "branch_id";
            //    cmbBranchfilter.TextField = "branch_description";
            //    cmbBranchfilter.DataSource = dst.Tables[1];
            //    cmbBranchfilter.DataBind();
            //    cmbBranchfilter.SelectedIndex = 0;
            //    cmbBranchfilter.Value = Convert.ToString(Session["userbranchID"]);
            //}
            if (dst.Tables[2] != null && dst.Tables[2].Rows.Count > 0)
            {
                ddl_AmountAre.TextField = "taxGrp_Description";
                ddl_AmountAre.ValueField = "taxGrp_Id";
                ddl_AmountAre.DataSource = dst.Tables[2];
                ddl_AmountAre.DataBind();
            }
            if (dst.Tables[3] != null && dst.Tables[3].Rows.Count > 0)
            {
                CmbCurrency.TextField = "Currency_AlphaCode";
                CmbCurrency.ValueField = "Currency_ID";
                CmbCurrency.DataSource = dst.Tables[3];
                CmbCurrency.DataBind();
            }
            if (dst.Tables[4] != null && dst.Tables[4].Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "ID";
                CmbScheme.DataSource = dst.Tables[4];
                CmbScheme.DataBind();
            }
        }
        public DataSet AllDropDownDetailForCashBank()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 100, "GetAllDropDownData");
            proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
            proc.AddVarcharPara("@CompanyID", 500, Convert.ToString(HttpContext.Current.Session["LastCompany"]));
            proc.AddVarcharPara("@userbranchlist", 5000, Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]));
            ds = proc.GetDataSet();
            return ds;
        }
        public void CreateDataTaxTable()
        {
            DataTable TaxRecord = new DataTable();
            TaxRecord.Columns.Add("SlNo", typeof(System.Int32));           
            TaxRecord.Columns.Add("TaxCode", typeof(System.String));
            TaxRecord.Columns.Add("AltTaxCode", typeof(System.String));
            TaxRecord.Columns.Add("Percentage", typeof(System.Decimal));
            TaxRecord.Columns.Add("Amount", typeof(System.Decimal));
            Session["CB_FinalTaxRecord"] = TaxRecord;
        }
        public void BindBranch()
        {
            dsBranch.SelectCommand = "SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where BRANCH_id in(" + Convert.ToString(Session["userbranchHierarchy"]) + ")";
            ddlEnterBranch.DataBind();
        }
        protected void ddlCashBank_Callback(object sender, CallbackEventArgsBase e)
        {
            string userbranch = e.Parameter.Split('~')[0];
            BindCashBankAccount(userbranch);
        }
        public void BindCashBankAccount(string userbranch)
        {
            DBEngine objEngine = new DBEngine();
            DataTable dtCustomer = new DataTable();
            string CompanyId = Convert.ToString(Session["LastCompany"]);            
            dtCustomer = GetCustomerCashBank(userbranch, CompanyId);
            if (dtCustomer.Rows.Count > 0)
            {
                ddlCashBank.TextField = "IntegrateMainAccount";
                ddlCashBank.ValueField = "MainAccount_AccountCode";
                ddlCashBank.DataSource = dtCustomer;
                ddlCashBank.DataBind();
            }
            else
            {
                ddlCashBank.TextField = "IntegrateMainAccount";
                ddlCashBank.ValueField = "MainAccount_AccountCode";
                ddlCashBank.DataSource = dtCustomer;
                ddlCashBank.DataBind();
            }

        }
        public DataTable GetCustomerCashBank(string @userbranch, string CompanyId)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 100, "GetCashBankData");
            proc.AddVarcharPara("@BranchId", 100, @userbranch);
            proc.AddVarcharPara("@CompanyId", 100, CompanyId);

            ds = proc.GetTable();
            return ds;
        }
        #region  Main Grid Related
//        void FillAllSearchGrid(bool filter = false)
//        {
           

//            string strQuery_NextPart = null;
//            string strMainQuery = null;
//            DataSet DsSearch = new DataSet();
//            GvCBSearch.Columns[0].FixedStyle = GridViewColumnFixedStyle.Left;
//            GvCBSearch.Columns[1].FixedStyle = GridViewColumnFixedStyle.Left;
//            GvCBSearch.Columns[2].FixedStyle = GridViewColumnFixedStyle.Left;


//            string BranchID = String.Empty;
//            DateTime TransactionDate = Convert.ToDateTime("0100-01-01");
//            string VoucherNumber = String.Empty, CashBankAc = String.Empty,
//                    MainNarration = String.Empty, MainAc = String.Empty,
//                    SubAc = String.Empty;
//            string InstType = String.Empty;
//            string InstNo = String.Empty;
//            DateTime Instdate = Convert.ToDateTime("0100-01-01");
//            string CustBank = String.Empty, IssueBank = String.Empty,
//                    WithFrom = String.Empty, DepstInto = String.Empty,
//                    AuthLetterRef = String.Empty, PayeeAc = String.Empty,
//                    Payment = String.Empty, Recieve = String.Empty,
//                    LineNarration = String.Empty;
//            GvCBSearch.Columns[2].Visible = true;
//            GvCBSearch.Columns[4].Visible = true;
//            // Case 
//            //When CashBank_TransactionType='P' Then CashBankDetail_PaymentAmount else CashBankDetail_ReceiptAmount
//            //End as Amount,

//            string strCommanQueryPart = @"
//                                        Select CashBank_ID as CBID,
//            CashBank_CashBankID as CashBankID,
//            Case 
//            When CashBank_TransactionType='P' Then 'Payment' else 'Receipt'
//            End as CashBank_TransactionType,
//            Convert(Varchar(10),CashBank_TransactionDate,105) as TransactionDate,
//            CashBank_VoucherNumber as VoucherNumber,
//            (select Currency_AlphaCode from Master_Currency where Currency_ID=CashBank_Currency )as CashBank_Currency,
//            (Select top 1 CashBankDetail_InstrumentNumber from trans_cashbankdetail Where CashBank_ID=CashBankDetail_VoucherID)  as InstrumentNumber,
//            (Select top 1 CashBankDetail_BankValueDate from trans_cashbankdetail Where CashBank_ID=CashBankDetail_VoucherID)as ValueDate,
//             (Select top 1 CashBankDetail_BankStatementDate from trans_cashbankdetail Where CashBank_ID=CashBankDetail_VoucherID)as BankStatementDate,
//            CashBank_Narration as Narration,
//            CashBank_ExchangeSegmentID as ExchangeSegmentID,
//            CashBank_IBRef as IBRef,
//           
//             Case 
//            When CashBank_TransactionType='P' Then Cast(IsNull(CashBankDetail_PaymentAmount,0)AS DECIMAL(18,2)) 
//            else  Cast(IsNull(CashBankDetail_ReceiptAmount,0)AS DECIMAL(18,2)) 
//            End as Amount,
//            (Select Count(*) from Trans_CashBankVouchers,Trans_CashBankDetail
//            where CashBank_ID=CashBankDetail_VoucherID
//            and CashBank_CompanyID='" + Session["LastCompany"].ToString() + @"'
//             and CashBank_FinYear='" + Session["LastFinYear"].ToString() + "'"
//                                               + strQuery_NextPart + @") as TotalRow,
//                                              (Select Max(LockDaysOrDate) From(
//								            Select GlobalSettings_Name,
//            Case
//            When GlobalSettings_Value=1 Then (DATEADD(dd, 0, DATEDIFF(dd, 0, GetDate()-GlobalSettings_LockDays)))
//            Else (DATEADD(dd, 0, DATEDIFF(dd, 0, GlobalSettings_LockDate))) 
//            End as LockDaysOrDate
//            From
//            (Select GlobalSettings_SegmentID,GlobalSettings_Name,GlobalSettings_LockDays,
//            GlobalSettings_LockDate,GlobalSettings_Value from  Config_GlobalSettings
//            Where GlobalSettings_SegmentID=CashBank_ExchangeSegmentID
//            and GlobalSettings_Name='GS_LCKBNK'
//            union
//            Select GlobalSettings_SegmentID,GlobalSettings_Name,GlobalSettings_LockDays,
//            GlobalSettings_LockDate,GlobalSettings_Value from  Config_GlobalSettings
//            Where GlobalSettings_SegmentID=CashBank_ExchangeSegmentID
//            and GlobalSettings_Name='GS_LCKALL') as t1
//            ) as t2) as MaxLockDate,
//
//            (Select user_name from tbl_master_user where user_id=CashBank_CreateUser)as CashBank_CreateUser,
//            (Select user_name from tbl_master_user where user_id=CashBank_ModifyUser)as CashBank_ModifyUser,
//            CONVERT(VARCHAR(10),CashBank_CreateDateTime, 105) + '  ' + CONVERT(VARCHAR(8), CashBank_CreateDateTime, 108) as CashBank_CreateDateTime
//
//            from Trans_CashBankVouchers 
//            Inner Join 
//            (Select CashBankDetail_VoucherID,SUM(CashBankDetail_ReceiptAmount) as CashBankDetail_ReceiptAmount,SUM(CashBankDetail_PaymentAmount)as CashBankDetail_PaymentAmount from trans_cashbankdetail 
//            group by CashBankDetail_VoucherID) as temp_cashbankdetail on 
//            Trans_CashBankVouchers.CashBank_ID=temp_cashbankdetail.CashBankDetail_VoucherID
//            and CashBank_CompanyID='" + Session["LastCompany"].ToString() + @"' 
//            and (CashBank_TransactionType='P' OR CashBank_TransactionType='R')
//          
//            and CashBank_FinYear='" + Session["LastFinYear"].ToString() + "'";

//            if (filter == true)
//            {
//                strCommanQueryPart += " and CashBank_TransactionDate between '" + FormDate.Date.ToString("yyyy-MM-dd") + "' and '" + toDate.Date.ToString("yyyy-MM-dd") + "'";

//                strCommanQueryPart += " and CashBank_BranchID in(" + ((Convert.ToString(cmbBranchfilter.Value)).Trim() == "0" ? Convert.ToString(Session["userbranchHierarchy"]) : Convert.ToString(cmbBranchfilter.Value)) + ")  order by CashBank_ID desc";
//            }
//            else
//            {
//                //strCommanQueryPart += " and CashBank_BranchID in(" + Convert.ToString(Session["userbranchHierarchy"]) + ")  order by CashBank_ID desc";
//                strCommanQueryPart += " and CashBank_BranchID in(" + Convert.ToString(Session["userbranchID"]) + ")  order by CashBank_ID desc";
//            }


//            strMainQuery = strCommanQueryPart;


//            DsSearch = GetDsUsingQuery(strMainQuery);
//            if (DsSearch.Tables.Count > 0)
//            {
//                if (DsSearch.Tables[0].Rows.Count > 0)
//                {
//                    BindGrid(GvCBSearch, DsSearch);

//                }
//                else
//                {
//                    // GvCBSearch.JSProperties["cpIsEmptyDsSearch"] = "NoRecord";
//                    GvCBSearch.DataSource = null;
//                    GvCBSearch.DataBind();
//                    Session["strMainQuery"] = null;
//                    Session["strSearchBy"] = null;
//                    Session["strSearchByMainQuery"] = null;
//                }
//            }
//            else
//            {
//                //GvCBSearch.JSProperties["cpIsEmptyDsSearch"] = "NoRecord";
//                GvCBSearch.DataSource = null;
//                GvCBSearch.DataBind();
//                Session["strMainQuery"] = null;
//                Session["strSearchBy"] = null;
//                Session["strSearchByMainQuery"] = null;
//            }

//        }
        //protected void GvCBSearch_CustomCallback(object sender, ASPxGridViewCustomButtonEventArgs e)
        //{
        //    if (!rights.CanDelete)
        //    {
        //        if (e.ButtonID == "CustomBtnDelete")
        //        {
        //            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        //        }
        //    }


        //    if (!rights.CanEdit)
        //    {
        //        if (e.ButtonID == "CustomBtnEdit")
        //        {
        //            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        //        }
        //    }
        //    if (!rights.CanView)
        //    {
        //        if (e.ButtonID == "CustomBtnView")
        //        {
        //            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        //        }
        //    }
        //}
        //protected void GvCBSearch_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        //{
        //    string command = e.Parameters.Split('~')[0];
        //    GvCBSearch.JSProperties["cpDelete"] = null;
        //    if (command == "Delete")
        //    {
        //        int RowIndex = Convert.ToInt32(e.Parameters.Split('~')[1]);
        //        string IBRef = GvCBSearch.GetRowValues(RowIndex, "IBRef").ToString();
        //        Session["IBRef"] = IBRef;
        //        int val = GetCaskBankDeleteData();
        //        if (val == 1)
        //        {
        //            GvCBSearch.JSProperties["cpDelete"] = "Succesfully Deleted";
        //            string FromDate = Convert.ToDateTime(FormDate.Value).ToString("yyyy-MM-dd");
        //            string ToDate = Convert.ToDateTime(toDate.Value).ToString("yyyy-MM-dd");
        //            string BranchID = Convert.ToString(cmbBranchfilter.Value);
        //            string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
        //            string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
        //            string finyear = Convert.ToString(Session["LastFinYear"]);
        //            Session["CashBankListingDetails"] = CashBankVoucherDetailsList(userbranch, lastCompany, finyear, BranchID, FromDate, ToDate, "true");
        //            GvCBSearch.DataBind();
        //        }
        //        else
        //        {
        //            GvCBSearch.JSProperties["cpDelete"] = "Voucher is Reconciled.Cannot Delete";
        //        }

        //    }
        //    else if (command == "FilterGridByDate")
        //    {

        //        string FromDate = Convert.ToString(e.Parameters.Split('~')[1]);
        //        string ToDate = Convert.ToString(e.Parameters.Split('~')[2]);
        //        string BranchID = Convert.ToString(e.Parameters.Split('~')[3]);

        //        string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
        //        string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
        //        string finyear = Convert.ToString(Session["LastFinYear"]);
        //        Session["CashBankListingDetails"] = CashBankVoucherDetailsList(userbranch, lastCompany, finyear, BranchID, FromDate, ToDate, "true");
        //        GvCBSearch.DataBind();
        //    }
        //}
        //protected void GvCBSearch_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        //{
        //    if (!rights.CanDelete)
        //    {
        //        if (e.ButtonID == "CustomBtnDelete")
        //        {
        //            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        //        }
        //    }
        //    if (!rights.CanEdit)
        //    {
        //        if (e.ButtonID == "CustomBtnEdit")
        //        {
        //            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        //        }
        //    }
        //    if (!rights.CanView)
        //    {
        //        if (e.ButtonID == "CustomBtnView")
        //        {
        //            e.Visible = DevExpress.Utils.DefaultBoolean.False;
        //        }
        //    }
        //}
        //protected void GvCBSearch_DataBinding(object sender, EventArgs e)
        //{
        //    //string BranchID = Convert.ToString(cmbBranchfilter.Value);
        //    //string FromDate = Convert.ToDateTime(FormDate.Value).ToString("yyyy-MM-dd");
        //    //string ToDate = Convert.ToDateTime(toDate.Value).ToString("yyyy-MM-dd");

        //    //string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
        //    //string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
        //    //string finyear = Convert.ToString(Session["LastFinYear"]);

        //    // DataTable dsdata = CashBankVoucherDetailsList(userbranch, lastCompany, finyear, BranchID, FromDate, ToDate, "true");

        //    DataTable dsdata = (DataTable)Session["CashBankListingDetails"];
        //    GvCBSearch.DataSource = dsdata;
        //}
        #endregion
        public int GetCaskBankDeleteData()
        {
            int rtrnvalue = 0;
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankDeleteDetails");

            proc.AddVarcharPara("@IBRef", 200, Convert.ToString(Session["IBRef"]));
            proc.AddVarcharPara("@ReturnValue", 200, "0", QueryParameterDirection.Output);
            proc.RunActionQuery();
            rtrnvalue = Convert.ToInt32(proc.GetParaValue("@ReturnValue"));
            return rtrnvalue;
        }
        #region Export
        //public void bindexport(int Filter)
        //{
        //    exporter.GridViewID = "GvCBSearch";
        //    string filename = "CashBankVoucher";
        //    exporter.FileName = filename;

        //    exporter.PageHeader.Left = "Cash/Bank Voucher";
        //    exporter.PageFooter.Center = "[Page # of Pages #]";
        //    exporter.PageFooter.Right = "[Date Printed]";

        //    switch (Filter)
        //    {
        //        case 1:
        //            exporter.WritePdfToResponse();
        //            break;
        //        case 2:
        //            exporter.WriteXlsToResponse();
        //            break;
        //        case 3:
        //            exporter.WriteRtfToResponse();
        //            break;
        //        case 4:
        //            exporter.WriteCsvToResponse();
        //            break;
        //    }
        //}
        //protected void drdCashBankExport_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    Int32 Filter = int.Parse(drdCashBank.SelectedItem.Value.ToString());
        //    if (Filter != 0)
        //    {
        //        if (Session["exportval"] == null)
        //        {
        //            Session["exportval"] = Filter;
        //            bindexport(Filter);
        //        }
        //        else if (Convert.ToInt32(Session["exportval"]) != Filter)
        //        {
        //            Session["exportval"] = Filter;
        //            bindexport(Filter);
        //        }
        //    }
        //}

        #endregion
        //private void cmbSubAccount_OnCallback(object source, CallbackEventArgsBase e)
        //{
        //    FillSubAccountCombo(source as ASPxComboBox, Convert.ToString(e.Parameter));
        //}
        //protected void FillSubAccountCombo(ASPxComboBox cmb, string MainAccount)
        //{

        //    DataTable DT = GetSubAccount(MainAccount);
        //    cmb.Items.Clear();

        //    if (DT.Rows.Count != 0)
        //    {
        //        foreach (DataRow dr in DT.Rows)
        //        {

        //            cmb.Items.Add(Convert.ToString(dr["Contact_Name"]), Convert.ToString(dr["Column1"]));
        //        }
        //    }
        //}
        //protected DataTable GetSubAccount(string MainAccount)
        //{
        //    DataTable DT = new DataTable();
        //    DBEngine objEngine = new DBEngine();
        //    string MainAccountSelectedValue = MainAccount.Split('|')[0];
        //    string MainAccountSelectedItem = MainAccount.Split('|')[1];
        //    string RequestLetter = "%";

        //    var MainAccountCode = MainAccountSelectedValue;
        //    var SegID = "";
        //    var SegmentName = "";

        //    if (hdn_SegID_SegmentName.Value != "")
        //    {
        //        SegID = hdn_SegID_SegmentName.Value.Split('~')[0];
        //        SegmentName = hdn_SegID_SegmentName.Value.Split('~')[1];
        //    }
        //    var ProcedureName = "SubAccountSelect_New";
        //    var InputName = "CashBank_MainAccountID|clause|branch|exchSegment|SegmentN";
        //    var InputType = "V|V|V|V|V";
        //    var InputValue = MainAccountCode.ToString().Split('~')[0] + "|RequestLetter|" + Session["userbranchHierarchy"] + "|'" + Session["ExchangeSegmentID"] + "'|'" + SegmentName + "'";
        //    var SplitChar = "|";
        //    var CombinedSubQuery = ProcedureName + "$" + InputName + "$" + InputType + "$" + InputValue + "$" + SplitChar;
        //    string[] paramSub = CombinedSubQuery.Split('$');
        //    char SplitSubChar = Convert.ToChar(paramSub[4]);
        //    string ProcedureSubName = Convert.ToString(paramSub[0]);
        //    string[] InputSubName = paramSub[1].Split(SplitSubChar);
        //    string[] InputSubType = paramSub[2].Split(SplitSubChar);
        //    string SetRequestLetter = paramSub[3].Replace("RequestLetter", RequestLetter);
        //    string[] InputSubValue = SetRequestLetter.Split(SplitSubChar);
        //    if (ProcedureSubName.Trim() != String.Empty && (InputSubName.Length == InputSubType.Length) && (InputSubType.Length == InputSubValue.Length))
        //    {
        //        DT = objEngine.SelectProcedureArr(ProcedureSubName, InputSubName, InputSubType, InputSubValue);              

        //    }
        //    return DT;
        //}
        #region WebMethod
        [WebMethod]
        public static string GetCurrentBankBalance(string MainAccountID, string BranchID)
        {
            BusinessLogicLayer.Converter oConverter = new BusinessLogicLayer.Converter();
            string MainAccountValID = string.Empty;
            string strColor = string.Empty;
            DataTable DT = new DataTable();
            DBEngine objEngine = new DBEngine();

            DT = objEngine.GetDataTable("Select Sum(AccountsLedger_AmountDr-AccountsLedger_AmountCr) TotalAmount from Trans_AccountsLedger WHERE AccountsLedger_MainAccountID='" + MainAccountID + "' and AccountsLedger_BranchId=" + BranchID);
            if (DT.Rows.Count != 0)
            {
                if (!String.IsNullOrEmpty(Convert.ToString(DT.Rows[0]["TotalAmount"])))
                {
                    MainAccountValID = oConverter.getFormattedvaluecheckorginaldecimaltwoorfour(Convert.ToDecimal(DT.Rows[0]["TotalAmount"]));
                    strColor = Convert.ToDecimal(MainAccountValID) > 0 ? "White" : "Red";
                }
            }
            return MainAccountValID + "~" + strColor;
        }
        //[WebMethod]
        //public static List<string> GetBranchList()
        //{
        //    List<string> obj = new List<string>();
        //    BusinessLogicLayer.Converter oConverter = new BusinessLogicLayer.Converter();
        //    string MainAccountValID = string.Empty;
        //    string strColor = string.Empty;
        //    DataTable DT = new DataTable();
        //    DBEngine objEngine = new DBEngine();

        //    DT = objEngine.GetDataTable("SELECT BRANCH_id AS BANKBRANCH_ID , BRANCH_DESCRIPTION AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where  BRANCH_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ")");
        //    if (DT.Rows.Count != 0)
        //    {



        //        if (DT.Rows.Count != 0)
        //        {
        //            foreach (DataRow dr in DT.Rows)
        //            {

        //                obj.Add(Convert.ToString(dr["BANKBRANCH_NAME"]) + "|" + Convert.ToString(dr["BANKBRANCH_ID"]));
        //            }
        //        }
        //    }


        //    return obj;
        //}
        //[WebMethod]
        //public static List<string> GetCashBankAccountList(string CombinedQuery, string BranchID)
        //{
        //    List<string> obj = new List<string>();
        //    DataTable DT = new DataTable();
        //    DBEngine objEngine = new DBEngine();
        //    string RequestLetter = "%";
        //    string[] param = CombinedQuery.Replace("--", "+").Replace("^^", "%").Split('$');
        //    string strQuery_Table = param[0].Trim() != String.Empty ? param[0] : null;
        //    string strQuery_FieldName = param[1].Trim() != String.Empty ? param[1] : null;
        //    string strQuery_WhereClause = param[2].Trim() != String.Empty ? param[2] : null;
        //    string strQuery_OrderBy = param[3].Trim() != String.Empty ? param[3] : null;
        //    string strQuery_GroupBy = param[4].Trim() != String.Empty ? param[4] : null;
        //    if (strQuery_Table != null)
        //    {
        //        strQuery_Table = strQuery_Table.Replace("RequestLetter", RequestLetter);
        //    }
        //    if (strQuery_FieldName != null)
        //    {
        //        strQuery_FieldName = strQuery_FieldName.Replace("RequestLetter", RequestLetter);
        //    }
        //    if (strQuery_WhereClause != null)
        //    {
        //        strQuery_WhereClause = strQuery_WhereClause.Replace("RequestLetter", RequestLetter);
        //    }

        //    DT = objEngine.GetDataTable(strQuery_Table, strQuery_FieldName, strQuery_WhereClause, strQuery_OrderBy, strQuery_GroupBy);

        //    DataTable restrictedDT = objEngine.GetDataTable("select branch_id,MainAccount_id from tbl_master_ledgerBranch_map");


        //    if (DT.Rows.Count != 0)
        //    {
        //        foreach (DataRow dr in DT.Rows)
        //        {
        //            if (BranchID.Trim() != "0")
        //            {
        //                DataRow[] restrictedTablerow = restrictedDT.Select("MainAccount_id=" + Convert.ToString(dr["MainAccount_ReferenceID"]));
        //                if (restrictedTablerow.Length > 0)
        //                {
        //                    DataTable restrictedTable = restrictedTablerow.CopyToDataTable();
        //                    DataRow[] restrictedRow = restrictedTable.Select("branch_id=" + BranchID);
        //                    if (restrictedRow.Length > 0)
        //                    {
        //                        obj.Add(Convert.ToString(dr["IntegrateMainAccount"]) + "|" + Convert.ToString(dr["MainAccount_AccountCode"]));
        //                    }
        //                }
        //                else
        //                {
        //                    obj.Add(Convert.ToString(dr["IntegrateMainAccount"]) + "|" + Convert.ToString(dr["MainAccount_AccountCode"]));
        //                }

        //            }
        //            else
        //            {
        //                obj.Add(Convert.ToString(dr["IntegrateMainAccount"]) + "|" + Convert.ToString(dr["MainAccount_AccountCode"]));
        //            }
        //        }



        //    }

        //    return obj;
        //}
        [WebMethod]
        public static string getSchemeType(string sel_scheme_id)
        {
            string strschematype = "", strschemalength = "", strschemavalue = "", strschemaBranch = "";
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.GetDataTable("tbl_master_Idschema", " schema_type,length,Branch ", " Id = " + Convert.ToInt32(sel_scheme_id));

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                strschematype = Convert.ToString(DT.Rows[i]["schema_type"]);
                strschemalength = Convert.ToString(DT.Rows[i]["length"]);
                strschemaBranch = Convert.ToString(DT.Rows[i]["Branch"]);
                strschemavalue = strschematype + "~" + strschemalength + "~" + strschemaBranch;
            }
            return Convert.ToString(strschemavalue);
        }
        [WebMethod]
        public static bool CheckUniqueName(string VoucherNo)
        {
            MShortNameCheckingBL objMShortNameCheckingBL = new MShortNameCheckingBL();
            DataTable dt = new DataTable();
            Boolean status = false;
            BusinessLogicLayer.GenericMethod oGeneric = new BusinessLogicLayer.GenericMethod();

            if (VoucherNo != "" && Convert.ToString(VoucherNo).Trim() != "")
            {
                status = objMShortNameCheckingBL.CheckUnique(Convert.ToString(VoucherNo).Trim(), "0", "CaskBankVoucher_Check");
            }
            return status;
        }
        [WebMethod]
        public static String GetRate(string basedCurrency, string Currency_ID, string Campany_ID)
        {

            SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
            DataTable dt = objSlaesActivitiesBL.GetCurrentConvertedRate(Convert.ToInt16(basedCurrency), Convert.ToInt16(Currency_ID), Campany_ID);
            string SalesRate = "";
            if (dt.Rows.Count > 0)
            {
                SalesRate = Convert.ToString(dt.Rows[0]["SalesRate"]);
            }

            return SalesRate;
        }

        [WebMethod]
        public static String CheckTdsByMainAccountID(string MainAccountID)
        {

            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.GetDataTable("Master_MainAccount", " MainAccount_TDSRate ", " MainAccount_ReferenceID = " + Convert.ToInt32(MainAccountID));
            string TDSRate = "";
            if (DT.Rows.Count > 0)
            {
                TDSRate = Convert.ToString(DT.Rows[0]["MainAccount_TDSRate"]);
                if (Convert.ToString(DT.Rows[0]["MainAccount_TDSRate"]) != "")
                {
                    TDSRate = "YES";
                }
                else
                {
                    TDSRate = "NO";
                }
            }

            return TDSRate;
        }
        #endregion
        private void bindMainAccount(object source, CallbackEventArgsBase e)
        {   
            if(e.Parameter!="")
            {
                ASPxComboBox currentCombo = source as ASPxComboBox;
                currentCombo.DataSource = GetMainAccountForBatchByBranchID(e.Parameter);
                currentCombo.DataBind();
            }
           
        }
        #region GridBatch
        protected void gridBatch_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {         

            if (e.Column.FieldName == "MainAccount")
            {
                e.Editor.ReadOnly = true;
               // ((ASPxComboBox)e.Editor).Callback += new CallbackEventHandlerBase(bindMainAccount);
            }
            else if (e.Column.FieldName == "bthSubAccount") 
            {
                e.Editor.ReadOnly = true;
            }         
            else if (e.Column.FieldName == "NetAmount")
            {
                e.Editor.ReadOnly = true;
            }
            else if (e.Column.FieldName == "SrlNo")
            {
                e.Editor.ReadOnly = true;
            }
            else if (e.Column.FieldName == "TaxAmount")
            {
                e.Editor.ReadOnly = true;
            }
            else
            {
                e.Editor.ReadOnly = false;
            }

        }
        protected void gridBatch_DataBinding(object sender, EventArgs e)
        {
            if (Request.QueryString.AllKeys.Contains("IsTagged"))
            {
                if (Session["CashBankDetails"] != null)
                {
                    DataTable POdt = (DataTable)Session["CashBankDetails"];
                    DataView dvData = new DataView(POdt);
                    dvData.RowFilter = "Status <> 'D'";

                    var CashBankLink = GetVoucherTDS(dvData.ToTable());
                    gridBatch.DataSource = CashBankLink;
                    gridBatch.JSProperties["cpTotalAmount"] = Total_Receipt_Payment((List<VOUCHERLIST>)CashBankLink);
                }
                else
                {
                    gridBatch.DataSource = GetVoucher();
                }
            }
            else
            {

                if (Session["CashBankDetails"] != null)
                {
                    DataTable POdt = (DataTable)Session["CashBankDetails"];
                    DataView dvData = new DataView(POdt);
                    dvData.RowFilter = "Status <> 'D'";
                    var CashBankLink = GetVoucherTDS(dvData.ToTable());
                    gridBatch.DataSource = CashBankLink;
                    gridBatch.JSProperties["cpTotalAmount"] = Total_Receipt_Payment((List<VOUCHERLIST>)CashBankLink);
                }

                else
                {
                    gridBatch.DataSource = GetVoucher();
                }
            }
        }
        public string Total_Receipt_Payment(List<VOUCHERLIST> Vouchers)
        {
            decimal total_receipt = 0, total_payment = 0;

            foreach (VOUCHERLIST obj in Vouchers)
            {
                total_receipt += Convert.ToDecimal(obj.btnRecieve);
                total_payment += Convert.ToDecimal(obj.btnPayment);
            }

            return Convert.ToString(total_receipt) + "~" + Convert.ToString(total_payment);

        }
        protected string checkNMakeJVCode(string manual_str, int sel_schema_Id)
        {
            oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable dtSchema = new DataTable();
            DataTable dtC = new DataTable();
            string prefCompCode = string.Empty, sufxCompCode = string.Empty, startNo, paddedStr, sqlQuery = string.Empty;
            int EmpCode, prefLen, sufxLen, paddCounter;

            if (sel_schema_Id > 0)
            {
                dtSchema = oDbEngine.GetDataTable("tbl_master_idschema", "prefix, suffix, digit, startno, schema_type", "id=" + sel_schema_Id);
                int scheme_type = Convert.ToInt32(dtSchema.Rows[0]["schema_type"]);

                if (scheme_type != 0)
                {
                    startNo = dtSchema.Rows[0]["startno"].ToString();
                    paddCounter = Convert.ToInt32(dtSchema.Rows[0]["digit"]);
                    paddedStr = startNo.PadLeft(paddCounter, '0');                 
                    prefCompCode = (dtSchema.Rows[0]["prefix"].ToString() == "TCURDATE/") ? (dtTDate.Date.ToString("ddMMyyyy") + "/") : (dtSchema.Rows[0]["prefix"].ToString());
                    sufxCompCode = (dtSchema.Rows[0]["suffix"].ToString() == "/TCURDATE") ? ("/" + dtTDate.Date.ToString("ddMMyyyy")) : (dtSchema.Rows[0]["suffix"].ToString());
                    prefLen = Convert.ToInt32(prefCompCode.Length);
                    sufxLen = Convert.ToInt32(sufxCompCode.Length);

                    sqlQuery = "SELECT max(tjv.CashBank_VoucherNumber) FROM Trans_CashBankVouchers tjv WHERE dbo.RegexMatch('";
                    if (prefLen > 0)
                        sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                    else if (scheme_type == 2)
                        sqlQuery += "^";
                    sqlQuery += "[0-9]{" + paddCounter + "}";
                    if (sufxLen > 0)
                        sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                    //sqlQuery += "?$', LTRIM(RTRIM(tjv.CashBank_VoucherNumber))) = 1";
                    sqlQuery += "?$', LTRIM(RTRIM(tjv.CashBank_VoucherNumber))) = 1 and CashBank_VoucherNumber like '" + prefCompCode + "%'";
                    if (scheme_type == 2)
                        sqlQuery += " AND CONVERT(DATE, CashBank_CreateDateTime) = CONVERT(DATE, GETDATE())";
                    dtC = oDbEngine.GetDataTable(sqlQuery);

                    if (dtC.Rows[0][0].ToString() == "")
                    {
                        sqlQuery = "SELECT max(tjv.CashBank_VoucherNumber) FROM Trans_CashBankVouchers tjv WHERE dbo.RegexMatch('";
                        if (prefLen > 0)
                            sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                        else if (scheme_type == 2)
                            sqlQuery += "^";
                        sqlQuery += "[0-9]{" + (paddCounter - 1) + "}";
                        if (sufxLen > 0)
                            sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                        //sqlQuery += "?$', LTRIM(RTRIM(tjv.CashBank_VoucherNumber))) = 1";
                        sqlQuery += "?$', LTRIM(RTRIM(tjv.CashBank_VoucherNumber))) = 1 and CashBank_VoucherNumber like '" + prefCompCode + "%'";
                        if (scheme_type == 2)
                            sqlQuery += " AND CONVERT(DATE, CashBank_CreateDateTime) = CONVERT(DATE, GETDATE())";
                        dtC = oDbEngine.GetDataTable(sqlQuery);
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
                    sqlQuery = "SELECT CashBank_VoucherNumber FROM Trans_CashBankVouchers WHERE CashBank_VoucherNumber LIKE '" + manual_str.Trim() + "'";
                    dtC = oDbEngine.GetDataTable(sqlQuery);
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
        protected void gridBatch_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

            gridBatch.JSProperties["cpVouvherNo"] = "";
            gridBatch.JSProperties["cpSaveSuccessOrFail"] = null;
            DataTable CashBankdt = new DataTable();
            string IsDeleteFrom = Convert.ToString(hdfIsDelete.Value);
            string VoucherType = Convert.ToString(rbtnType.SelectedValue);

            if (Session["CashBankDetails"] != null)
            {
                CashBankdt = (DataTable)Session["CashBankDetails"];
            }
            else
            {
                CashBankdt.Columns.Add("SrlNo", typeof(string));
                CashBankdt.Columns.Add("CashReportID", typeof(string));
                CashBankdt.Columns.Add("MainAccount", typeof(string));
                CashBankdt.Columns.Add("SubAccount", typeof(string));
                CashBankdt.Columns.Add("PaymentAmount", typeof(string));
                CashBankdt.Columns.Add("ReceiptAmount", typeof(string));
                CashBankdt.Columns.Add("Remarks", typeof(string));
                CashBankdt.Columns.Add("Status", typeof(string));
                CashBankdt.Columns.Add("TaxAmount", typeof(string));
                CashBankdt.Columns.Add("NetAmount", typeof(string));
                CashBankdt.Columns.Add("ReverseApplicable", typeof(string));
              
                CashBankdt.Columns.Add("MainAccountID", typeof(string));
                CashBankdt.Columns.Add("SubAccountID", typeof(string));
            }
            foreach (var args in e.InsertValues)
            {
                string SrlNo = Convert.ToString(args.NewValues["SrlNo"]);
                //string MainAccount = Convert.ToString(args.NewValues["MainAccount"]);
                string MainAccount = Convert.ToString(args.NewValues["gvColMainAccount"]);
                string Recieve = Convert.ToString(args.NewValues["btnRecieve"]);
                string Payment = Convert.ToString(args.NewValues["btnPayment"]);

                string TaxAmount = Convert.ToString(args.NewValues["TaxAmount"]);
                string NetAmount = Convert.ToString(args.NewValues["NetAmount"]);
                string ReverseApplicable = Convert.ToString(args.NewValues["ReverseApplicable"]);

                string TDS = Convert.ToString(args.NewValues["TDS"]);

                string MainAccountID = Convert.ToString(args.NewValues["MainAccount"]);
                string SubAccountID = Convert.ToString(args.NewValues["bthSubAccount"]);
                if (MainAccount != "" && MainAccount != "0")
                {
                    if ((Recieve != "0.0") || (Payment != "0.0"))
                    {
                        string SubAccount = Convert.ToString(args.NewValues["gvColSubAccount"]);
                       // string SubAccount = Convert.ToString(args.NewValues["bthSubAccount"]);
                        string LineNarration = Convert.ToString(args.NewValues["btnLineNarration"]);

                        CashBankdt.Rows.Add(SrlNo, "0", MainAccount, SubAccount, Payment, Recieve, LineNarration, "I", TaxAmount, NetAmount, ReverseApplicable, MainAccountID, SubAccountID);


                        //if (TDS == "Y")
                        //{
                        //    DataTable TDSDatadt = GetTDSData(MainAccount, Payment);
                        //    if (TDSDatadt != null && TDSDatadt.Rows.Count > 0)
                        //    {
                        //        MainAccount = Convert.ToString(TDSDatadt.Rows[0]["MainAccount_ReferenceID"]);//0
                        //        Recieve = Convert.ToString(TDSDatadt.Rows[0]["Receipt"]);
                        //        CashBankdt.Rows.Add("0", "0", MainAccount, "", "0.0", Recieve, "", "I");
                        //    }

                        //}
                    }
                }
            }
            foreach (var args in e.UpdateValues)
            {
                string SrlNo = Convert.ToString(args.Keys["SrlNo"]);
                string CashReportID = Convert.ToString(args.Keys["CashBankID"]);

                string MainAccount = Convert.ToString(args.NewValues["gvColMainAccount"]);
                string SubAccount = Convert.ToString(args.NewValues["gvColSubAccount"]);

                //string MainAccount = Convert.ToString(args.NewValues["MainAccount"]);
                //string SubAccount = Convert.ToString(args.NewValues["bthSubAccount"]);
                string MainAccountID = Convert.ToString(args.NewValues["MainAccount"]);
                string SubAccountID = Convert.ToString(args.NewValues["bthSubAccount"]);

                string Recieve = Convert.ToString(args.NewValues["btnRecieve"]);
                string Payment = Convert.ToString(args.NewValues["btnPayment"]);

                string TaxAmount = Convert.ToString(args.NewValues["TaxAmount"]);
                string NetAmount = Convert.ToString(args.NewValues["NetAmount"]);
                string ReverseApplicable = Convert.ToString(args.NewValues["ReverseApplicable"]);

                string LineNarration = Convert.ToString(args.NewValues["btnLineNarration"]);
                bool isDeleted = false;
                foreach (var arg in e.DeleteValues)
                {
                    string DeleteID = Convert.ToString(arg.Keys["CashBankID"]);
                    if (DeleteID == CashReportID)
                    {
                        isDeleted = true;
                        break;
                    }
                }

                if (isDeleted == false)
                {
                    if (MainAccount != "" && MainAccount != "0")
                    {
                        bool Isexists = false;
                        foreach (DataRow drr in CashBankdt.Rows)
                        {
                            string OldCashReportID = Convert.ToString(drr["CashReportID"]);
                            if (OldCashReportID == CashReportID)
                            {
                                Isexists = true;

                                drr["CashReportID"] = OldCashReportID;
                                drr["MainAccount"] = MainAccount;
                                drr["SubAccount"] = SubAccount;
                                drr["PaymentAmount"] = Payment;
                                drr["ReceiptAmount"] = Recieve;
                                drr["Remarks"] = LineNarration;
                                drr["Status"] = "U";
                                drr["TaxAmount"] = TaxAmount;
                                drr["NetAmount"] = NetAmount;
                                drr["ReverseApplicable"] = ReverseApplicable;
                                drr["MainAccountID"]=MainAccountID;
                                drr["SubAccountID"] = SubAccountID;
                                break;
                            }
                        }
                        if (Isexists == false)
                        {
                            CashBankdt.Rows.Add(SrlNo, CashReportID, MainAccount, SubAccount, Payment, Recieve, LineNarration, "U", TaxAmount, NetAmount, ReverseApplicable, MainAccountID, SubAccountID);
                        }

                    }
                }
            }

            foreach (var args in e.DeleteValues)
            {
                string CashReportID = Convert.ToString(args.Keys["CashBankID"]);
                string SrlNo = "";

                for (int i = CashBankdt.Rows.Count - 1; i >= 0; i--)
                {
                    DataRow dr = CashBankdt.Rows[i];
                    string delCashReportID = Convert.ToString(dr["CashReportID"]);

                    if (delCashReportID == CashReportID)
                    {
                        SrlNo = Convert.ToString(dr["SrlNo"]);
                        dr.Delete();
                    }
                }
                CashBankdt.AcceptChanges();

                if (CashReportID.Contains("~") != true)
                {
                    CashBankdt.Rows.Add("0", CashReportID, "", "", "0.00", "0.00", "", "D", "0.00", "0.00", "0.00","","");
                }
            }

            string strDeleteSrlNo = Convert.ToString(hdnDeleteSrlNo.Value);
            if (strDeleteSrlNo != "" && strDeleteSrlNo != "0")
            {
                DeleteTaxDetails(strDeleteSrlNo);

                hdnDeleteSrlNo.Value = "";
            }

            int j = 1;
            foreach (DataRow dr in CashBankdt.Rows)
            {
                string Status = Convert.ToString(dr["Status"]);
                string oldSrlNo = Convert.ToString(dr["SrlNo"]);
                string newSrlNo = j.ToString();

                dr["SrlNo"] = j.ToString();


                UpdateTaxDetails(oldSrlNo, newSrlNo);

                if (Status != "D")
                {
                    if (Status == "I" || Status == "")
                    {
                        string strID = Convert.ToString("Q~" + j);
                        dr["CashReportID"] = strID;
                    }
                    j++;
                }
            }
            CashBankdt.AcceptChanges();
            Session["CashBankDetails"] = CashBankdt;
            if (hdfIsDelete.Value != "D")
            {
                DataTable tempCashBank = CashBankdt.Copy();
                Session["CashBankDetails"] = CashBankdt;

                foreach (DataRow dr in tempCashBank.Rows)
                {
                    string Status = Convert.ToString(dr["Status"]);
                    if (Status == "I")
                    {
                        dr["CashReportID"] = 0;
                    }
                    else if (Status == "D")
                    {
                        dr.Delete();
                    }
                }
                tempCashBank.AcceptChanges();

                DataTable tempTaxDetailsdt = new DataTable();
                tempTaxDetailsdt = tempCashBank.DefaultView.ToTable(false, "SrlNo", "CashReportID", "MainAccount", "SubAccount", "PaymentAmount", "ReceiptAmount", "Remarks", "Status", "TaxAmount", "NetAmount", "ReverseApplicable");
               
                #region For Reverse Correction
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("Fetch_CashBankEntry_DataSet", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Action", "CheckReverse");//1
                //cmd.Parameters.AddWithValue("@CashBankDt", tempCashBank);//2
                cmd.Parameters.AddWithValue("@CashBankDt", tempTaxDetailsdt);//2
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);

                tempTaxDetailsdt = dsInst.Tables[0];
                //tempCashBank = dsInst.Tables[0];
                cmd.Dispose();
                con.Dispose();
                #endregion

                DataTable tempReverse = null;
                try
                {
                    //tempReverse = tempCashBank.AsEnumerable().Where(x => x.Field<string>("ReverseApplicable") == "1").CopyToDataTable();
                    tempReverse = tempTaxDetailsdt.AsEnumerable().Where(x => x.Field<string>("ReverseApplicable") == "1").CopyToDataTable();
                }
                catch (Exception) { }

                DataTable ReverseTaxtable = CreateReverseTaxTable();


                //tempCashBank.AcceptChanges();
                tempTaxDetailsdt.AcceptChanges();
                if (Convert.ToString(ddl_AmountAre.SelectedItem.Value) == "1")  /// RCM applicable only on Exclusive GST
                {
                    string RShippingState = BillingShippingControl.GetShippingStateCode();
                    if (tempReverse != null)
                        ReverseTaxtable = GetReverseTaxTable(tempReverse, "SrlNo", "ProductID", "Amount", "TaxAmount", ReverseTaxtable, "P", dtTDate.Date.ToString("yyyy-MM-dd"), Convert.ToString(ddlBranch.SelectedValue), RShippingState);
                }


                if (hdnTaxGridBind.Value != "YES")
                {
                    if (hdnPayment.Value != "YES")
                    {
                        string validate = "";
                        if (hdn_Mode.Value == "Entry")
                        {
                            string strSchemeType = Convert.ToString(CmbScheme.Value);
                            string[] SchemeList = strSchemeType.Split(new string[] { "~" }, StringSplitOptions.None);

                            validate = checkNMakeJVCode(Convert.ToString(txtVoucherNo.Text), Convert.ToInt32(SchemeList[0]));
                        }

                        Boolean _addressFlag = false;

                        #region ###### Reverse Checking Region ##########
                        int reverseCount = 0, nonReverseCount = 0;

                        if (CashBankdt != null)
                        {
                            nonReverseCount = CashBankdt.AsEnumerable().Count(x => x.Field<string>("ReverseApplicable") == "0" && x.Field<string>("Status") != "D");
                            reverseCount = CashBankdt.AsEnumerable().Count(x => x.Field<string>("ReverseApplicable") == "1" && x.Field<string>("Status") != "D");
                        }
                        if (nonReverseCount > 0 && reverseCount > 0)
                        {
                            if (rbtnType.SelectedValue != "R")
                                validate = "mixedvalue";
                        }

                        #endregion

                        if (ReverseTaxtable != null && ReverseTaxtable.Rows.Count > 0)
                        {
                            foreach (DataRow dr in ReverseTaxtable.Rows)
                            {

                                DataTable dt = new DataTable();
                                ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
                                proc.AddVarcharPara("@Action", 500, "CheckReverseLedger");
                                proc.AddBigIntegerPara("@TaxRatesID", Convert.ToInt64(dr["TaxCode"]));
                                dt = proc.GetTable();
                                if (dt.Rows.Count == 0)
                                {
                                    validate = "reversetaxledgermissing";
                                }
                                break;
                            }
                        }
                        
                        //if (tempCashBank != null && tempCashBank.Rows.Count > 0)
                        if (tempTaxDetailsdt != null && tempTaxDetailsdt.Rows.Count > 0)
                        {
                            //foreach (DataRow dr in tempCashBank.Rows)
                            foreach (DataRow dr in tempTaxDetailsdt.Rows)
                            {
                                if (Convert.ToDecimal(dr["ReceiptAmount"]) == 0 && Convert.ToDecimal(dr["PaymentAmount"]) == 0)
                                {
                                    validate = "zeroAmount";
                                }

                                DataTable dt = new DataTable();
                                ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
                                proc.AddVarcharPara("@Action", 500, "CheckLedgerHSN");
                                proc.AddBigIntegerPara("@MainAccID", Convert.ToInt32(dr["MainAccount"]));
                                proc.AddVarcharPara("@ApplicableFor", 1, (Convert.ToString(rbtnType.SelectedValue)) == "R" ? "S" : "P");
                                dt = proc.GetTable();
                                if (dt.Rows.Count > 0)
                                {
                                    if (Convert.ToString(ddl_AmountAre.SelectedItem.Value) != "3") /// No Tax Checking
                                    {
                                        if (Convert.ToString(rbtnType) == "R")
                                        {
                                            if (Convert.ToDecimal(dr["ReceiptAmount"]) != 0 && Convert.ToDecimal(dr["TaxAmount"]) == 0)
                                            {
                                                validate = "taxREquired";
                                            }
                                        }
                                        else
                                        {
                                            if (Convert.ToDecimal(dr["PaymentAmount"]) != 0 && Convert.ToDecimal(dr["TaxAmount"]) == 0)
                                            {
                                                validate = "taxREquired";
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if (tempTaxDetailsdt != null && tempTaxDetailsdt.Rows.Count > 0)
                        //if (tempCashBank != null && tempCashBank.Rows.Count > 0)
                        {
                            foreach (DataRow dr in tempTaxDetailsdt.Rows)
                            //foreach (DataRow dr in tempCashBank.Rows)
                            {
                                DataTable dt = new DataTable();
                                ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
                                proc.AddVarcharPara("@Action", 500, "CheckLedgerHSN");
                                proc.AddBigIntegerPara("@MainAccID", Convert.ToInt32(dr["MainAccount"]));
                                dt = proc.GetTable();
                                if (dt.Rows.Count > 0)
                                {
                                    if (Convert.ToString(ddl_AmountAre.SelectedItem.Value) != "3") /// No Tax Checking
                                    {
                                        _addressFlag = true;
                                        if (_addressFlag && (BillingShippingControl.GetShippingStateCode() == "" || BillingShippingControl.GetShippingStateCode() == "0"))
                                        {
                                            validate = "addressrequired";
                                        }
                                    }
                                }
                                break;
                            }
                        }

                        if (validate == "outrange" || validate == "duplicate" || validate == "reversetaxledgermissing" || validate == "addressrequired" || validate == "taxREquired" || validate == "zeroAmount" || validate == "mixedvalue")
                        {
                            gridBatch.JSProperties["cpSaveSuccessOrFail"] = validate;
                        }
                        else
                        {
                            string ActionType = "", strIBRef = "", strScheme_ID = "";
                            if (hdn_Mode.Value == "Entry")
                            {
                                string strSchemeType = Convert.ToString(CmbScheme.Value);
                                string[] SchemeList = strSchemeType.Split(new string[] { "~" }, StringSplitOptions.None);

                                strScheme_ID = SchemeList[0];

                                DataTable dtSchema = oDBEngine.GetDataTable("tbl_master_idschema", "prefix, suffix, digit, startno, schema_type", "id=" + Convert.ToInt32(SchemeList[0]));
                                if (dtSchema != null && dtSchema.Rows.Count > 0)
                                {
                                    int scheme_type = Convert.ToInt32(dtSchema.Rows[0]["schema_type"]);
                                    if (scheme_type != 0)
                                    {
                                        gridBatch.JSProperties["cpVouvherNo"] = JVNumStr;
                                    }
                                    ActionType = "ADD";
                                    strIBRef = "";
                                }
                            }
                            else
                            {
                                ActionType = "Edit";
                                strIBRef = Convert.ToString(Session["IBRef"]);
                            }

                            string strEditCashBankID = Convert.ToString(hdnEditCBID.Value);
                            string strCashBankBranchID = Convert.ToString(ddlBranch.SelectedValue);

                            string strEnterBranchID = Convert.ToString(ddlEnterBranch.SelectedValue);

                            string strTransactionDate = Convert.ToString(dtTDate.Date);
                            string strCBankID = Convert.ToString(ddlCashBank.Value);
                            string strCashBankID = strCBankID.Split('~')[0];
                            string strExchangeSegmentID = "1";
                            string strTransactionType = Convert.ToString(rbtnType.SelectedValue);
                            string strEntryUserProfile = "F";
                            string strNarration = txtNarration.Text;
                            string strCurrency = Convert.ToString(CmbCurrency.Value);
                            string strInstrumentType;
                            if (Convert.ToString(cmbInstrumentType.Value) == "CH")
                            {
                                strInstrumentType = Convert.ToString(0);
                            }
                            else
                            {
                                strInstrumentType = Convert.ToString(cmbInstrumentType.Value);
                            }
                            string strInstrumentNumber = txtInstNobth.Text.Trim();
                            string strInstrumentDate = Convert.ToString(InstDate.Date);
                            string strrate = txtRate.Text.Trim();
                            string strReceivedFrom = txtReceivedFrom.Text.Trim();
                            string strPaidTo = txtPaidTo.Text.Trim();
                            string strCashBankName = Convert.ToString(ddlCashBank.Text);
                            string strTaxOption = Convert.ToString(ddl_AmountAre.Value);
                            string strContactNo = Convert.ToString(txtContact.Text.Trim());
                            #region ##### Added By : Samrat Roy -- to get BillingShipping user control data
                            DataTable tempBillAddress = new DataTable();
                            tempBillAddress = BillingShippingControl.SaveBillingShippingControlData();
                            #endregion

                            //if (Save_Record(ActionType, strEditCashBankID, JVNumStr, strCashBankBranchID, strTransactionDate, strCashBankID, strExchangeSegmentID, strTransactionType, strEntryUserProfile
                            //    , strNarration, strIBRef, strCurrency, strInstrumentType, strInstrumentNumber, strInstrumentDate, strCashBankName, strrate,
                            //    tempCashBank, strReceivedFrom, strPaidTo, tempBillAddress, strTaxOption, strContactNo,
                            //    (chk_reversemechenism.Checked == true) ? 1 : 0, ReverseTaxtable, strScheme_ID, txtDraweeBank.Text.Trim(), strEnterBranchID) == true)
                            if (Save_Record(ActionType, strEditCashBankID, JVNumStr, strCashBankBranchID, strTransactionDate, strCashBankID, strExchangeSegmentID, strTransactionType, strEntryUserProfile
                               , strNarration, strIBRef, strCurrency, strInstrumentType, strInstrumentNumber, strInstrumentDate, strCashBankName, strrate,
                               tempTaxDetailsdt, strReceivedFrom, strPaidTo, tempBillAddress, strTaxOption, strContactNo,
                               (chk_reversemechenism.Checked == true) ? 1 : 0, ReverseTaxtable, strScheme_ID, txtDraweeBank.Text.Trim(), strEnterBranchID) == true)
                            {

                                Session["IBRef"] = null;
                                hdnEditRfid.Value = "";
                                hdn_Mode.Value = "";
                                gridBatch.JSProperties["cpSaveSuccessOrFail"] = "successInsert";
                                Session["CashBankDetails"] = null;
                                Session["CB_FinalTaxRecord"] = null;


                                #region To Show By Default Cursor after SAVE AND NEW
                                if (ActionType == "ADD") // session has been removed from quotation list page working good
                                {
                                   
                                    string schemavalue = Convert.ToString(CmbScheme.Value);
                                    Session["schemavalueCB"] = schemavalue;      
                                    Session["VoucherTypeCB"] = strTransactionType;


                                    List<string> myList = new List<string> { strTaxOption, strCashBankBranchID };
                                    //List<string> myList = new List<string>{strCashBankID, strInstrumentType, strTaxOption};
                                    Session["SaveNewValues"] = myList;

                                    string schematype = Convert.ToString(txtVoucherNo.Text);
                                    if (schematype == "Auto")
                                    {
                                        Session["SaveModeCB"] = "A";
                                        hdnSchemaType.Value = Convert.ToString("1");
                                    }
                                    else
                                    {
                                        Session["SaveModeCB"] = "M";
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
                }
            }
            else
            {
                hdnTaxGridBind.Value = "NO";
                DataView dvData = new DataView(CashBankdt);
                gridBatch.DataSource = GetVoucherTDS(dvData.ToTable());
                gridBatch.DataBind();
            }
        }
        private bool Save_Record(string ActionType, string strEditCashBankID, string strVoucherNumber, string strCashBankBranchID, string strTransactionDate,
          string strCashBankID,
           string strExchangeSegmentID, string strTransactionType, string strEntryUserProfile, string strNarration, string strIBRef,
        string strCurrency, string strInstrumentType, string strInstrumentNumber, string strInstrumentDate, string strCashBankName, string strrate,
        DataTable strCashBankdt, string strReceivedFrom, string strPaidTo, DataTable tempBillAddress, string strTaxOption, string strContactNo, int reverseMechanism,
            DataTable reverseTaxTable, string strScheme_ID, string strDraweeBank, string strEnterBranchID)
        {
            try
            {
                gridBatch.JSProperties["cpExitNew"] = null;
                gridBatch.JSProperties["cpType"] = strTransactionType;
                if (hdn_Mode.Value == "Entry")
                {

                    strIBRef = "CB_" + Session["userid"].ToString() + "_" + strTransactionType + "_" + JVNumStr.Replace("/", "");

                }
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_CaskBankInsertUpdate", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Action", ActionType);//1
                cmd.Parameters.AddWithValue("@EditCashBankID", strEditCashBankID);//2
                cmd.Parameters.AddWithValue("@VoucherNumber", strVoucherNumber);//3

                cmd.Parameters.AddWithValue("@CompanyID", Convert.ToString(Session["LastCompany"]));//4
                cmd.Parameters.AddWithValue("@FinYear", Convert.ToString(Session["LastFinYear"]));//5
                cmd.Parameters.AddWithValue("@CreateUser", Convert.ToString(Session["userid"]));//6

                cmd.Parameters.AddWithValue("@CashBankBranchID", strCashBankBranchID);//7
                cmd.Parameters.AddWithValue("@TransactionDate", strTransactionDate);//8
                cmd.Parameters.AddWithValue("@CashBankCashBankID", strCashBankID);//9

                cmd.Parameters.AddWithValue("@ExchangeSegmentID", strExchangeSegmentID);//10
                cmd.Parameters.AddWithValue("@TransactionType", strTransactionType);//11
                cmd.Parameters.AddWithValue("@EntryUserProfile", strEntryUserProfile);//12

                cmd.Parameters.AddWithValue("@Narration", strNarration);//13
                cmd.Parameters.AddWithValue("@IBRef", strIBRef);//14
                cmd.Parameters.AddWithValue("@CurrencyID", strCurrency);//15

                cmd.Parameters.AddWithValue("@CashBankDetailInstrumentType", strInstrumentType);//16
                cmd.Parameters.AddWithValue("@CashBankDetailInstrumentNumber", strInstrumentNumber);//17
                cmd.Parameters.AddWithValue("@CashBankDetailInstrumentDate", strInstrumentDate);//18
                cmd.Parameters.AddWithValue("@AccountsLedgerCashBankName", strCashBankName);//19
                cmd.Parameters.AddWithValue("@rate", strrate);         //20
                cmd.Parameters.AddWithValue("@CashBankVoucherDetails", strCashBankdt);//21
                cmd.Parameters.AddWithValue("@CashBankReceivedFrom", strReceivedFrom);//22
                cmd.Parameters.AddWithValue("@CashBankPaidTo", strPaidTo);//23
                cmd.Parameters.AddWithValue("@BillAddress", tempBillAddress);//24
                cmd.Parameters.AddWithValue("@TaxOption", strTaxOption);//24
                cmd.Parameters.AddWithValue("@ReverseMechanism", reverseMechanism);//24
                cmd.Parameters.AddWithValue("@EnterBranchID", strEnterBranchID); //25

                String ShippingState = Convert.ToString(BillingShippingControl.GetShippingStateCode());
                //  CreateDataTaxTable();
                DataTable TaxRecord = (DataTable)Session["CB_FinalTaxRecord"];

                foreach (DataRow drCB in strCashBankdt.Rows)
                {
                    int sl = Convert.ToInt16(drCB["SrlNo"]);
                    if (TaxRecord != null)
                    {
                        if (Convert.ToDecimal(drCB["TaxAmount"]) == 0)
                        {
                            DataTable POdt = TaxRecord;
                            DataView dvData = new DataView(POdt);
                            dvData.RowFilter = "SLNo <>" + sl;

                            TaxRecord = dvData.ToTable();
                        }
                    }
                }
                if (ShippingState != "")
                {
                    DataTable nonReverse = null;
                    try
                    {
                        nonReverse = strCashBankdt.AsEnumerable().Where(x => x.Field<string>("ReverseApplicable") == "0" && x.Field<string>("Status") != "D").CopyToDataTable();
                    }
                    catch (Exception) { }
                    DataTable dtTax = null;
                    dtTax = TaxRecord;
                    if (nonReverse != null)
                    {
                        dtTax = TaxRecord;//TaxCalculated(nonReverse, TaxRecord, strTransactionType, strTransactionDate, strCashBankBranchID, ShippingState, strTaxOption);
                    }

                    cmd.Parameters.AddWithValue("@TaxDetails", dtTax);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@TaxDetails", TaxRecord);
                }
                cmd.Parameters.AddWithValue("@ReverseTaxDetails", reverseTaxTable);
                cmd.Parameters.AddWithValue("@ContactNo", strContactNo);//24
                cmd.Parameters.AddWithValue("@Scheme_ID", strScheme_ID);//25
                cmd.Parameters.AddWithValue("@DraweeBank", strDraweeBank);//26

                SqlParameter output = new SqlParameter("@ReturnValueID", SqlDbType.Int);
                output.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(output);
                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);
                cmd.Dispose();
                con.Dispose();
                //if (output.Value=="-20")
                //{
                //    gridBatch.JSProperties["cpAutoID"] = output.Value;
                //}
                //else
                //{
                //    gridBatch.JSProperties["cpAutoID"] = output.Value;
                //}
                gridBatch.JSProperties["cpAutoID"] = output.Value;
              
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        protected void gridBatch_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string command = e.Parameters.Split('~')[0];
            int RowIndex;
            string IBRef="";
            string cask_bankID="";

            if (command == "Display")
            {
                string IsTDSFrom = Convert.ToString(hdnPayment.Value);


                string IsDeleteFrom = Convert.ToString(hdfIsDelete.Value);
                if (IsDeleteFrom == "D" || IsDeleteFrom == "C")
                {
                    if (Session["CashBankDetails"] != null)
                    {
                        DataTable Quotationdt = (DataTable)Session["CashBankDetails"];
                        //gridBatch.DataSource = GetQuotation(Quotationdt);
                        gridBatch.DataBind();
                    }
                }


                if (IsTDSFrom == "YES")
                {
                    DataTable Quotationdt = (DataTable)Session["CashBankDetails"];
                    gridBatch.DataSource = GetVoucherTDS(Quotationdt);
                    gridBatch.DataBind();
                }
            }
            //if (command == "Edit" || command == "View")
            //{
            //    RowIndex = Convert.ToInt32(e.Parameters.Split('~')[1]);

            //    string CBID = Request.QueryString["key"];
            //    ViewState["CashBankID"] = CBID;

            //    //IBRef = GvCBSearch.GetRowValues(RowIndex, "IBRef").ToString();
            //    Session["IBRef"] = IBRef;
            //    hdnEditRfid.Value = IBRef;
            //    gridBatch.JSProperties["cpEdit"] = null;
            //    Session["CB_FinalTaxRecord"] = null;



            //    gridBatch.JSProperties["cpNOTEdit"] = null;
            //   // cask_bankID = GvCBSearch.GetRowValues(RowIndex, "CBID").ToString();

            //    Session["CB_FinalTaxRecord"] = GetCashBankEditedTaxData(CBID);


            //    DataSet DsOnLoad = new DataSet();
            //    string VoucherType = "", VoucherNo = "", Date = "", Branch = "", Cash_Bank = "", Currency = "", InstrumentType = "", InstrumentNo = "", InstrumentDate = "",
            //        Narration = "", InstrumentTypeName = "", BankStatementDate = "", BankValueDate = "", ReceivedFrom = "", PaidTo = "", Tax_Code = "", ContactNo = "",
            //        ReverseCharge = "0", DraweeBank = "", EnteredBranchID = "", CashBankName = "";
            //    // strCurrency = "",
            //    DataTable CashBanktEditdt = GetCashBanktEditData();
            //    if (CashBanktEditdt != null && CashBanktEditdt.Rows.Count > 0)
            //    {
            //        VoucherType = Convert.ToString(CashBanktEditdt.Rows[0]["VoucherType"]);//0
            //        VoucherNo = Convert.ToString(CashBanktEditdt.Rows[0]["OldVoucherNumber"]);//1
            //        Date = Convert.ToString(CashBanktEditdt.Rows[0]["TransactionDate"]);//2
            //        Branch = Convert.ToString(CashBanktEditdt.Rows[0]["BranchID"]);//3 

            //        // BindCashBankAccount(Branch);
            //        Cash_Bank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankID"]);//4                

            //        Currency = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_Currency"]);//5
            //        InstrumentTypeName = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);

            //        if (InstrumentTypeName == "0")
            //        {
            //            InstrumentType = "CH";
            //        }
            //        else
            //        {
            //            InstrumentType = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);//6
            //        }

            //        InstrumentNo = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentNumber"]);//7

            //        Narration = Convert.ToString(CashBanktEditdt.Rows[0]["Narration"]);//8
            //        BankStatementDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankStatementDate"]);
            //        BankValueDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankValueDate"]);


            //        ReceivedFrom = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReceivedFrom"]);//12
            //        PaidTo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_PaidTo"]);//13
            //        Tax_Code = Convert.ToString(CashBanktEditdt.Rows[0]["Tax_Code"]);
            //        ContactNo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ContactNo"]);
            //        ReverseCharge = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReverseCharge"]);
            //        // CashBank_ID=Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ID"]);//11
            //        InstrumentDate = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentDate"]);
            //        DraweeBank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_DraweeBank"]);
            //        EnteredBranchID = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_EnteredBranchID"]);
            //        CashBankName = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankName"]);
            //        //BindCashBankAccount(EnteredBranchID);
            //    }
            //    //decimal Recipt = 0, Payment = 0;
            //    DataTable Voucherdt = GetCashBanktBatchEditData(hdnEditRfid.Value).Tables[0];
            //    string Recipt = Convert.ToString(Voucherdt.Compute("Sum(ReceiptAmount)", ""));
            //    string Payment = Convert.ToString(Voucherdt.Compute("Sum(PaymentAmount)", ""));

            //    gridBatch.JSProperties["cpEdit"] = VoucherType + "*" + VoucherNo + "*" + Date + "*" + Branch + "*" + Cash_Bank + "*" + Currency + "*" +
            //        InstrumentType + "*" + InstrumentNo + "*" + Narration + "*" + Recipt + "*" + Payment + "*" + cask_bankID + "*" + ReceivedFrom + "*" + PaidTo + "*" +
            //        Tax_Code + "*" + ContactNo + "*" + ReverseCharge + "*" + InstrumentDate + "*" + DraweeBank + "*" + EnteredBranchID + "*" + CashBankName;
            //    gridBatch.JSProperties["cpView"] = (command.ToUpper() == "VIEW") ? "1" : "0";
            //    Session["CashBankDetails"] = GetCashBanktBatchEditData(hdnEditRfid.Value).Tables[0];
            //    gridBatch.DataSource = GetVoucher();
            //    gridBatch.DataBind();

            //}

            //if (command == "ViewTagged")
            //{
            //    RowIndex = Convert.ToInt32(e.Parameters.Split('~')[1]);

            //    string CBID = RowIndex.ToString();
            //    ViewState["CashBankID"] = CBID;

               
            //    gridBatch.JSProperties["cpEdit"] = null;
            //    Session["CB_FinalTaxRecord"] = null;

            //    gridBatch.JSProperties["cpNOTEdit"] = null;
            //    cask_bankID = CBID.ToString();

            //    Session["CB_FinalTaxRecord"] = GetCashBankEditedTaxData(CBID);

            //    DataSet DsOnLoad = new DataSet();
            //    string VoucherType = "", VoucherNo = "", Date = "", Branch = "", Cash_Bank = "", Currency = "", InstrumentType = "", InstrumentNo = "", InstrumentDate = "",
            //        Narration = "", InstrumentTypeName = "", BankStatementDate = "", BankValueDate = "", ReceivedFrom = "", PaidTo = "", Tax_Code = "", ContactNo = "",
            //        ReverseCharge = "0", DraweeBank = "", EnteredBranchID = "", CashBankName = "";
            //    // strCurrency = "",

            //    DataTable CashBanktEditdt = GetCashBanktviewDataTagged(CBID);

            //    if (CashBanktEditdt != null && CashBanktEditdt.Rows.Count > 0)
            //    {
            //        VoucherType = Convert.ToString(CashBanktEditdt.Rows[0]["VoucherType"]);//0
            //        VoucherNo = Convert.ToString(CashBanktEditdt.Rows[0]["OldVoucherNumber"]);//1
            //        Date = Convert.ToString(CashBanktEditdt.Rows[0]["TransactionDate"]);//2
            //        Branch = Convert.ToString(CashBanktEditdt.Rows[0]["BranchID"]);//3 

            //        // BindCashBankAccount(Branch);
            //        Cash_Bank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankID"]);//4                

            //        Currency = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_Currency"]);//5
            //        InstrumentTypeName = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);

            //        if (InstrumentTypeName == "0")
            //        {
            //            InstrumentType = "CH";
            //        }
            //        else
            //        {
            //            InstrumentType = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);//6
            //        }

            //        InstrumentNo = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentNumber"]);//7

            //        Narration = Convert.ToString(CashBanktEditdt.Rows[0]["Narration"]);//8
            //        BankStatementDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankStatementDate"]);
            //        BankValueDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankValueDate"]);

            //        ReceivedFrom = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReceivedFrom"]);//12
            //        PaidTo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_PaidTo"]);//13
            //        Tax_Code = Convert.ToString(CashBanktEditdt.Rows[0]["Tax_Code"]);
            //        ContactNo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ContactNo"]);
            //        ReverseCharge = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReverseCharge"]);
            //        // CashBank_ID=Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ID"]);//11
            //        InstrumentDate = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentDate"]);
            //        DraweeBank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_DraweeBank"]);
            //        EnteredBranchID = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_EnteredBranchID"]);
            //        CashBankName = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankName"]);
            //        //BindCashBankAccount(EnteredBranchID);
            //    }
            //    //decimal Recipt = 0, Payment = 0;

            //    DataTable Voucherdt = GetCashBanktBatchViewtDataTagged(CBID).Tables[0];

            //    string Recipt = Convert.ToString(Voucherdt.Compute("Sum(ReceiptAmount)", ""));
            //    string Payment = Convert.ToString(Voucherdt.Compute("Sum(PaymentAmount)", ""));

            //    gridBatch.JSProperties["cpEdit"] = VoucherType + "*" + VoucherNo + "*" + Date + "*" + Branch + "*" + Cash_Bank + "*" + Currency + "*" +
            //        InstrumentType + "*" + InstrumentNo + "*" + Narration + "*" + Recipt + "*" + Payment + "*" + cask_bankID + "*" + ReceivedFrom + "*" + PaidTo + "*" +
            //        Tax_Code + "*" + ContactNo + "*" + ReverseCharge + "*" + InstrumentDate + "*" + DraweeBank + "*" + EnteredBranchID + "*" + CashBankName;
            //    gridBatch.JSProperties["cpView"] = (command.ToUpper() == "VIEWTAGGED") ? "1" : "0";

            //    Session["CashBankDetails"] = Voucherdt;

            //    gridBatch.DataSource = Voucherdt;
            //    gridBatch.DataBind();

            //}
        }
        public DataTable GetCashBanktviewDataTagged(string CBID)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankEditHeaderTagged");
            // proc.AddIntegerPara("@CashBankID", Convert.ToInt32(ViewState["CashBankID"]));
            proc.AddVarcharPara("@IBRef", 200, CBID);


            dt = proc.GetTable();
            return dt;
        }
        public DataSet GetCashBanktBatchViewtDataTagged(string CBID)
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankEditBatchDetailsTagged");
            //  proc.AddVarcharPara("@IBRef", 200, Convert.ToString(Session["IBRef"]));
            proc.AddVarcharPara("@IBRef", 200, CBID);
            ds = proc.GetDataSet();
            return ds;
        }

        #endregion
        #region Class
        public class MainAccountBind
        {
            public string AccountCode { get; set; }
            public string IntegrateMainAccount { get; set; }
        }
        public class SubAccountBind
        {
            public string SubAccount_Name { get; set; }
            public string SubAccount_ReferenceID { get; set; }
        }
        public class VOUCHERLIST
        {
            public string SrlNo { get; set; }
            public string CashBankID { get; set; }
            public string MainAccount { get; set; }
            public string bthSubAccount { get; set; }
            public string btnRecieve { get; set; }
            public string btnPayment { get; set; }
            public string btnLineNarration { get; set; }
            public string TDS { get; set; }
            public string TaxAmount { get; set; }
            public string NetAmount { get; set; }
            public string ReverseApplicable { get; set; }
            public string gvColMainAccount { get; set; }
            public string gvColSubAccount { get; set; }
          

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
        #endregion
        #region IEnumerable
        public IEnumerable GetMainAccountForBatch()
        {
            List<MainAccountBind> MainAccountList = new List<MainAccountBind>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string strQuery_Table = "Master_MainAccount";

            // string strQuery_FieldName = "Select MainAccount_Name+\' [ \'+rtrim(ltrim(MainAccount_AccountCode))+\' ]\' as MainAccount_Name1,cast(MainAccount_ReferenceID as varchar)+\'~\'+MainAccount_SubLedgerType+\'~MAINAC~\'+MainAccount_AccountType as MainAccount_ReferenceID from Master_MainAccount where MainAccount_BankCashType Not In ('Bank','Cash') ";
            string strQuery_FieldName = "Select MainAccount_Name+\' [ \'+rtrim(ltrim(MainAccount_AccountCode))+\' ]\' as MainAccount_Name1,MainAccount_ReferenceID from Master_MainAccount where MainAccount_BankCashType Not In ('Bank','Cash') ";

            string strQuery_WhereClause = "";
            string strQuery_OrderBy = "";
            string strQuery_GroupBy = "";
            string CombinedQuery = strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_OrderBy + "$" + strQuery_GroupBy;


            DataTable DT = new DataTable();
            string RequestLetter = "%";
            string[] param = CombinedQuery.Replace("--", "+").Replace("^^", "%").Split('$');
            string strQueryTable = param[0].Trim() != String.Empty ? param[0] : null;
            string strQueryFieldName = param[1].Trim() != String.Empty ? param[1] : null;
            string strQueryWhereClause = param[2].Trim() != String.Empty ? param[2] : null;
            string strQueryOrderBy = param[3].Trim() != String.Empty ? param[3] : null;
            string strQueryGroupBy = param[4].Trim() != String.Empty ? param[4] : null;
            if (strQuery_Table != null)
            {
                strQuery_Table = strQuery_Table.Replace("RequestLetter", RequestLetter);
            }

            if (strQuery_WhereClause != null)
            {
                strQuery_WhereClause = strQuery_WhereClause.Replace("RequestLetter", RequestLetter);
            }
            // DT = objEngine.GetDataTable(strQuery_Table, strQuery_FieldName, strQuery_WhereClause, strQuery_OrderBy, strQuery_GroupBy);
            DT = objEngine.GetDataTable(strQuery_FieldName);

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                MainAccountBind Main_Account = new MainAccountBind();
                Main_Account.AccountCode = Convert.ToString(DT.Rows[i]["MainAccount_ReferenceID"]);
                Main_Account.IntegrateMainAccount = Convert.ToString(DT.Rows[i]["MainAccount_Name1"]);
                MainAccountList.Add(Main_Account);
            }

            return MainAccountList;
        }
        public IEnumerable GetMainAccountForBatchByBranchID(string BranchId)
        {
            string strCompanyID = Convert.ToString(Session["LastCompany"]);
            List<MainAccountBind> MainAccountList = new List<MainAccountBind>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string strQuery_Table = "Master_MainAccount";
            string strQuery_FieldName = "Select MainAccount_Name+\' [ \'+rtrim(ltrim(MainAccount_AccountCode))+\' ]\' as MainAccount_Name1,MainAccount_ReferenceID,MainAccount_branchId from Master_MainAccount where MainAccount_BankCashType Not In ('Bank','Cash') AND MainAccount_branchId in ('" + BranchId + "','0') AND MainAccount_BankCompany in ('" + strCompanyID + "','')";
            //string strQuery_FieldName = "Select MainAccount_Name+\' [ \'+rtrim(ltrim(MainAccount_AccountCode))+\' ]\' as MainAccount_Name1,cast(MainAccount_ReferenceID as varchar)+\'~\'+MainAccount_SubLedgerType+\'~MAINAC~\'+MainAccount_AccountType as MainAccount_ReferenceID from Master_MainAccount where MainAccount_branchId="+BranchId;
            //string strQuery_WhereClause = " (MainAccount_Name like (\'%RequestLetter%\') or MainAccount_AccountCode like (\'%RequestLetter%\')) and isnull(MainAccount_BankCashType,'abc') not in('Cash','Bank')";
            string strQuery_WhereClause = "";
            string strQuery_OrderBy = "";
            string strQuery_GroupBy = "";
            string CombinedQuery = strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_OrderBy + "$" + strQuery_GroupBy;


            DataTable DT = new DataTable();
            string RequestLetter = "%";
            string[] param = CombinedQuery.Replace("--", "+").Replace("^^", "%").Split('$');
            string strQueryTable = param[0].Trim() != String.Empty ? param[0] : null;
            string strQueryFieldName = param[1].Trim() != String.Empty ? param[1] : null;
            string strQueryWhereClause = param[2].Trim() != String.Empty ? param[2] : null;
            string strQueryOrderBy = param[3].Trim() != String.Empty ? param[3] : null;
            string strQueryGroupBy = param[4].Trim() != String.Empty ? param[4] : null;
            if (strQuery_Table != null)
            {
                strQuery_Table = strQuery_Table.Replace("RequestLetter", RequestLetter);
            }

            if (strQuery_WhereClause != null)
            {
                strQuery_WhereClause = strQuery_WhereClause.Replace("RequestLetter", RequestLetter);
            }
            // DT = objEngine.GetDataTable(strQuery_Table, strQuery_FieldName, strQuery_WhereClause, strQuery_OrderBy, strQuery_GroupBy);
            DT = objEngine.GetDataTable(strQuery_FieldName);
            DataTable restrictedDT = oDbEngine.GetDataTable("select branch_id,MainAccount_id from tbl_master_ledgerBranch_map");
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                DataRow[] restrictedTablerow = restrictedDT.Select("MainAccount_id=" + Convert.ToString(DT.Rows[i]["MainAccount_ReferenceID"]));

                if (restrictedTablerow.Length > 0)
                {
                    DataTable restrictedTable = restrictedTablerow.CopyToDataTable();
                    DataRow[] restrictedRow = restrictedTable.Select("branch_id=" + BranchId);
                    if (restrictedRow.Length > 0)
                    {
                        MainAccountBind Main_Account = new MainAccountBind();
                        Main_Account.AccountCode = Convert.ToString(DT.Rows[i]["MainAccount_ReferenceID"]);
                        Main_Account.IntegrateMainAccount = Convert.ToString(DT.Rows[i]["MainAccount_Name1"]);
                        MainAccountList.Add(Main_Account);
                    }
                }
                else
                {
                    MainAccountBind Main_Account = new MainAccountBind();
                    Main_Account.AccountCode = Convert.ToString(DT.Rows[i]["MainAccount_ReferenceID"]);
                    Main_Account.IntegrateMainAccount = Convert.ToString(DT.Rows[i]["MainAccount_Name1"]);
                    MainAccountList.Add(Main_Account);
                }

            }
            return MainAccountList;
        }
        public IEnumerable GetSubAccount(string ProcedureSubName, string[] InputSubName, string[] InputSubType, string[] InputSubValue)
        {
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.SelectProcedureArr(ProcedureSubName, InputSubName, InputSubType, InputSubValue);

            List<SubAccountBind> SubAccountList = new List<SubAccountBind>();

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                SubAccountBind SubAccounts = new SubAccountBind();
                SubAccounts.SubAccount_ReferenceID = Convert.ToString(DT.Rows[i][1]);
                SubAccounts.SubAccount_Name = Convert.ToString(DT.Rows[i][0]);
                SubAccountList.Add(SubAccounts);
            }

            return SubAccountList;
        }
        public IEnumerable GetSubAccount()
        {

            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.GetDataTable("tbl_master_branch", " (ISNULL(ltrim(rtrim(b.cnt_firstname)),'') + ''+ ISNULL(b.cnt_middlename,'')+ '' + ISNULL(b.cnt_lastName,'''')) +' ['+isnull(ltrim(rtrim(b.cnt_UCC)),'')+']' +' ['+(select rtrim(branch_description)  ", " branch_id in (select cnt_branchid from tbl_master_contact where cnt_internalid=b.cnt_internalId))+']' as Contact_Name,b.cnt_internalId+'~NAB~NAB~'+isnull(ltrim(rtrim(cnt_firstName)),'')+''+isnull(cnt_middleName,'')+''+isnull(cnt_lastName,'') as SubAccount_ReferenceID FROM tbl_master_contact as b ");

            List<SubAccountBind> SubAccountList = new List<SubAccountBind>();
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                SubAccountBind SubAccounts = new SubAccountBind();
                SubAccounts.SubAccount_ReferenceID = Convert.ToString(DT.Rows[i][1]);
                SubAccounts.SubAccount_Name = Convert.ToString(DT.Rows[i][0]);
                SubAccountList.Add(SubAccounts);
            }
            return SubAccountList;
        }
        public IEnumerable GetVoucher()
        {
            DataSet DsOnLoad = new DataSet();
            DataTable tempdt = new DataTable();
            DBEngine objEngine = new DBEngine();
            List<VOUCHERLIST> VoucherList = new List<VOUCHERLIST>();

            DataTable Voucherdt = GetCashBanktBatchEditData(hdnEditRfid.Value).Tables[0];
            for (int i = 0; i < Voucherdt.Rows.Count; i++)
            {
                VOUCHERLIST Vouchers = new VOUCHERLIST();
                Vouchers.SrlNo = Convert.ToString(Voucherdt.Rows[i]["srlNo"]);
                Vouchers.CashBankID = Convert.ToString(Voucherdt.Rows[i]["CashReportID"]);
                Vouchers.gvColMainAccount = Convert.ToString(Voucherdt.Rows[i]["MainAccount"]);
                Vouchers.gvColSubAccount = Convert.ToString(Voucherdt.Rows[i]["SubAccount"]);
            
                Vouchers.btnPayment = Convert.ToString(Voucherdt.Rows[i]["PaymentAmount"]);
                Vouchers.btnRecieve = Convert.ToString(Voucherdt.Rows[i]["ReceiptAmount"]);
                Vouchers.btnLineNarration = Convert.ToString(Voucherdt.Rows[i]["Remarks"]);
                Vouchers.TDS = "";
                Vouchers.TaxAmount = Convert.ToString(Voucherdt.Rows[i]["TaxAmount"]);
                Vouchers.NetAmount = Convert.ToString(Voucherdt.Rows[i]["NetAmount"]);
                Vouchers.ReverseApplicable = Convert.ToString(Voucherdt.Rows[i]["ReverseApplicable"]);
                Vouchers.MainAccount = Convert.ToString(Voucherdt.Rows[i]["MainAccountID"]);
                Vouchers.bthSubAccount = Convert.ToString(Voucherdt.Rows[i]["SubAccountID"]);
               
            
                VoucherList.Add(Vouchers);
            }
            return VoucherList;
        }
        #endregion
        #region Init Method
        //protected void SubAccount_Init(object sender, EventArgs e)
        //{
        //    ASPxComboBox SubAccountCombo = sender as ASPxComboBox;
        //    GridViewEditItemTemplateContainer container = SubAccountCombo.NamingContainer as GridViewEditItemTemplateContainer;
        //    string mainAccount = Convert.ToString(container.Grid.GetRowValues(container.Grid.VisibleStartIndex, "MainAccount"));
        //    gridBatch.JSProperties["cplastMainAccountID"] = mainAccount;            
        //    SubAccountCombo.DataSource = GetSubAccountNew(mainAccount.ToString().Split('~')[0], "", Convert.ToString(Session["userbranchHierarchy"]), "", "");
        //}
        protected void Page_Init(object sender, EventArgs e)
        {
            //((GridViewDataComboBoxColumn)gridBatch.Columns["MainAccount"]).PropertiesComboBox.DataSource = GetMainAccountForBatch();
            //((GridViewDataComboBoxColumn)gridBatch.Columns["bthSubAccount"]).PropertiesComboBox.DataSource = GetSubAccountNew("", "", "", "ALL", "");
            if (!IsPostBack)
            {
                gridBatch.DataBind();
            }
        }
        #endregion
        //public void Bind_SubAccountByMainAccount(string StrMain)
        //{
        //    string mainAccount = StrMain;
        //    gridBatch.JSProperties["cplastMainAccountID"] = mainAccount;

        //    string RequestLetter = "%";
        //    var SegID = "";
        //    var SegmentName = "";

        //    if (hdn_SegID_SegmentName.Value != "")
        //    {
        //        SegID = hdnSegmentid.Value;
        //        SegmentName = hdn_SegID_SegmentName.Value;
        //    }


        //    var ProcedureName = "SubAccountSelect_New";
        //    var InputName = "CashBank_MainAccountID|clause|branch|exchSegment|SegmentN";
        //    var InputType = "V|V|V|V|V";
        //    var InputValue = mainAccount.ToString().Split('~')[0] + "|RequestLetter|" + Session["userbranchHierarchy"] + "|'" + Session["ExchangeSegmentID"] + "'|'" + SegmentName + "'";
        //    var SplitChar = "|";
        //    var CombinedSubQuery = ProcedureName + "$" + InputName + "$" + InputType + "$" + InputValue + "$" + SplitChar;


        //    string[] paramSub = CombinedSubQuery.Split('$');


        //    char SplitSubChar = Convert.ToChar(paramSub[4]);
        //    string ProcedureSubName = Convert.ToString(paramSub[0]);
        //    string[] InputSubName = paramSub[1].Split(SplitSubChar);
        //    string[] InputSubType = paramSub[2].Split(SplitSubChar);
        //    string SetRequestLetter = paramSub[3].Replace("RequestLetter", RequestLetter);
        //    string[] InputSubValue = SetRequestLetter.Split(SplitSubChar);

        //    ((GridViewDataComboBoxColumn)gridBatch.Columns["bthSubAccount"]).PropertiesComboBox.DataSource = GetSubAccount(ProcedureSubName, InputSubName, InputSubType, InputSubValue);
        //}
        protected void SubAccount_Callback(object sender, CallbackEventArgsBase e)
        {
            ASPxComboBox c = sender as ASPxComboBox;
            string MainAccount = Convert.ToString(e.Parameter.Split('~')[0]);
            if (Convert.ToString(e.Parameter.Split('~')[0]) != "null" && Convert.ToString(e.Parameter.Split('~')[0]) != "")
            {
                string sunAccount = Convert.ToString(e.Parameter.Split('~')[1]);
                c.DataSource = GetSubAccountNew(MainAccount, "", Convert.ToString(Session["userbranchHierarchy"]), "", sunAccount);
                c.DataBind();
            }
            if (MainAccount != "" && MainAccount != "null")
            {
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("Fetch_CashBankEntry_DataSet", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", "ReverseApplicable");
                cmd.Parameters.AddWithValue("@MainAccID", MainAccount);
                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);
                cmd.Dispose();
                con.Dispose();
                c.JSProperties["cpReverseApplicable"] = (dsInst.Tables[0].Rows.Count > 0) ? (Convert.ToString(dsInst.Tables[0].Rows[0][0])) : "0";
                c.JSProperties["cpIsTaxable"] = (dsInst.Tables[0].Rows.Count > 0) ? (Convert.ToString(dsInst.Tables[0].Rows[0][1])) : "";

            }
        }
        public DataTable TaxCalculated(DataTable strCashBankdt, DataTable taxTable, string Type, string TransactionDate, string BranchId, string ShippingState, string strTaxOption)
        {

            #region VoucharType  Payment
            if (Type == "P")
            {
                foreach (DataRow dtr in strCashBankdt.Rows)
                {
                    string strMainAccount = Convert.ToString(dtr["MainAccount"]);
                    decimal Recieve = Convert.ToDecimal(dtr["ReceiptAmount"]);
                    decimal Payment = Convert.ToDecimal(dtr["PaymentAmount"]);


                    string fromState = "", shippingStateCode = "", TaxType = "", roundOfPlus = "", roundofMinus = "";
                    DataTable fetchedData = oDBEngine.GetDataTable("select StateCode  from tbl_master_branch br inner join tbl_master_state st on br.branch_state=st.id where branch_id=" + BranchId);
                    if (fetchedData != null)
                        fromState = Convert.ToString(fetchedData.Rows[0][0]).Trim();

                    fetchedData = oDBEngine.GetDataTable("select StateCode from tbl_master_state where id=" + ShippingState);
                    if (fetchedData != null)
                        shippingStateCode = Convert.ToString(fetchedData.Rows[0][0]).Trim();

                    fetchedData = oDBEngine.GetDataTable("select TaxRates_ID from Config_TaxRates config inner join Master_Taxes masterTax on config.TaxRates_TaxCode = masterTax.Taxes_ID  where  TaxRates_RoundingOff='R+' and Taxes_ApplicableFor in ('B','" + Type + "')");
                    if (fetchedData.Rows.Count > 0)
                        roundOfPlus = Convert.ToString(fetchedData.Rows[0][0]).Trim();

                    fetchedData = oDBEngine.GetDataTable("select TaxRates_ID from Config_TaxRates config inner join Master_Taxes masterTax on config.TaxRates_TaxCode = masterTax.Taxes_ID  where  TaxRates_RoundingOff='R-' and Taxes_ApplicableFor in ('B','" + Type + "')");
                    if (fetchedData.Rows.Count > 0)
                        roundofMinus = Convert.ToString(fetchedData.Rows[0][0]).Trim();


                    #region setTaxType
                    if (fromState == shippingStateCode)
                    {
                        TaxType = "SGST";
                        if (shippingStateCode == "4" || shippingStateCode == "35" || shippingStateCode == "26" || shippingStateCode == "25" || shippingStateCode == "7" || shippingStateCode == "31" || shippingStateCode == "34")
                        {
                            TaxType = "UTGST";
                        }
                    }
                    else
                    {
                        TaxType = "IGST";
                    }

                    #endregion

                    DataTable taxDetail = new DataTable();
                    ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
                    proc.AddVarcharPara("@Action", 500, "LoadOtherTaxDetails");
                    proc.AddVarcharPara("@MainAccountID", 100, Convert.ToString(strMainAccount));
                    proc.AddVarcharPara("@dtTDate", 10, dtTDate.Date.ToString("yyyy-MM-dd"));
                    proc.AddVarcharPara("@Type", 5, Type);
                    taxDetail = proc.GetTable();

                    #region DeleteExtra GstCode

                    if (TaxType == "UTGST")
                    {
                        foreach (DataRow dr in taxDetail.Rows)
                        {
                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                            {
                                dr.Delete();
                            }
                        }
                    }
                    else if (TaxType == "IGST")
                    {
                        foreach (DataRow dr in taxDetail.Rows)
                        {
                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                            {
                                dr.Delete();
                            }
                        }
                    }
                    else if (TaxType == "SGST")
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
                    #endregion


                    decimal TotalPercentage = 0, InclusiveAmt = 0, TaxAmount = 0, RoundOfAmt = 0;
                    foreach (DataRow taxRow in taxDetail.Rows)
                    {
                        if (Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "UTGST")
                        {
                            TotalPercentage = TotalPercentage + Convert.ToDecimal(taxRow["TaxRates_Rate"]);
                        }
                    }
                    decimal backcalculatePercent = 1 + (TotalPercentage / 100);

                    if (strTaxOption == "1")
                    {
                        InclusiveAmt = Payment;
                    }
                    else if (strTaxOption == "2")
                    {
                        InclusiveAmt = Payment / backcalculatePercent;
                    }
                    foreach (DataRow taxexistingRow in taxDetail.Rows)
                    {
                        TaxAmount = 0;

                        if (Convert.ToString(taxexistingRow["TaxTypeCode"]).Trim() != "O")
                        {
                            DataRow txRecordRow = taxTable.NewRow();
                            txRecordRow["SlNo"] = dtr["SrlNo"];
                            txRecordRow["TaxCode"] = taxexistingRow["Taxes_ID"];
                            txRecordRow["AltTaxCode"] = "0";
                            txRecordRow["Percentage"] = taxexistingRow["TaxRates_Rate"];

                            TaxAmount = InclusiveAmt * (Convert.ToDecimal(taxexistingRow["TaxRates_Rate"]) / 100);

                            txRecordRow["Amount"] = Math.Round(TaxAmount, 2);

                            taxTable.Rows.Add(txRecordRow);

                        }
                    }



                }
            }

            #endregion

            #region VoucharType Receipt
            if (Type == "R")
            {
                foreach (DataRow dtr in strCashBankdt.Rows)
                {
                    string strMainAccount = Convert.ToString(dtr["MainAccount"]);
                    decimal Recieve = Convert.ToDecimal(dtr["ReceiptAmount"]);
                    decimal Payment = Convert.ToDecimal(dtr["PaymentAmount"]);


                    string fromState = "", shippingStateCode = "", TaxType = "", roundOfPlus = "", roundofMinus = "";
                    DataTable fetchedData = oDBEngine.GetDataTable("select StateCode  from tbl_master_branch br inner join tbl_master_state st on br.branch_state=st.id where branch_id=" + BranchId);
                    if (fetchedData != null)
                        fromState = Convert.ToString(fetchedData.Rows[0][0]).Trim();

                    fetchedData = oDBEngine.GetDataTable("select StateCode from tbl_master_state where id=" + ShippingState);
                    if (fetchedData != null)
                        shippingStateCode = Convert.ToString(fetchedData.Rows[0][0]).Trim();

                    fetchedData = oDBEngine.GetDataTable("select TaxRates_ID from Config_TaxRates config inner join Master_Taxes masterTax on config.TaxRates_TaxCode = masterTax.Taxes_ID  where  TaxRates_RoundingOff='R+' and Taxes_ApplicableFor in ('B','" + Type + "')");
                    if (fetchedData.Rows.Count > 0)
                        roundOfPlus = Convert.ToString(fetchedData.Rows[0][0]).Trim();

                    fetchedData = oDBEngine.GetDataTable("select TaxRates_ID from Config_TaxRates config inner join Master_Taxes masterTax on config.TaxRates_TaxCode = masterTax.Taxes_ID  where  TaxRates_RoundingOff='R-' and Taxes_ApplicableFor in ('B','" + Type + "')");
                    if (fetchedData.Rows.Count > 0)
                        roundofMinus = Convert.ToString(fetchedData.Rows[0][0]).Trim();


                    #region setTaxType
                    if (fromState == shippingStateCode)
                    {
                        TaxType = "SGST";
                        if (shippingStateCode == "4" || shippingStateCode == "35" || shippingStateCode == "26" || shippingStateCode == "25" || shippingStateCode == "7" || shippingStateCode == "31" || shippingStateCode == "34")
                        {
                            TaxType = "UTGST";
                        }
                    }
                    else
                    {
                        TaxType = "IGST";
                    }

                    #endregion

                    DataTable taxDetail = new DataTable();
                    ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
                    proc.AddVarcharPara("@Action", 500, "LoadOtherTaxDetails");
                    proc.AddVarcharPara("@MainAccountID", 100, Convert.ToString(strMainAccount));
                    proc.AddVarcharPara("@dtTDate", 10, dtTDate.Date.ToString("yyyy-MM-dd"));
                    proc.AddVarcharPara("@Type", 5, "S");
                    taxDetail = proc.GetTable();

                    #region DeleteExtra GstCode

                    if (TaxType == "UTGST")
                    {
                        foreach (DataRow dr in taxDetail.Rows)
                        {
                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                            {
                                dr.Delete();
                            }
                        }
                    }
                    else if (TaxType == "IGST")
                    {
                        foreach (DataRow dr in taxDetail.Rows)
                        {
                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                            {
                                dr.Delete();
                            }
                        }
                    }
                    else if (TaxType == "SGST")
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
                    #endregion


                    decimal TotalPercentage = 0, InclusiveAmt = 0, TaxAmount = 0, RoundOfAmt = 0;
                    foreach (DataRow taxRow in taxDetail.Rows)
                    {
                        if (Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(taxRow["TaxTypeCode"]).Trim() == "UTGST")
                        {
                            TotalPercentage = TotalPercentage + Convert.ToDecimal(taxRow["TaxRates_Rate"]);
                        }
                    }
                    decimal backcalculatePercent = 1 + (TotalPercentage / 100);

                    if (strTaxOption == "1")
                    {
                        InclusiveAmt = Recieve;
                    }
                    else if (strTaxOption == "2")
                    {
                        InclusiveAmt = Recieve / backcalculatePercent;
                    }
                    foreach (DataRow taxexistingRow in taxDetail.Rows)
                    {
                        TaxAmount = 0;

                        if (Convert.ToString(taxexistingRow["TaxTypeCode"]).Trim() != "O")
                        {
                            DataRow txRecordRow = taxTable.NewRow();
                            txRecordRow["SlNo"] = dtr["SrlNo"];
                            txRecordRow["TaxCode"] = taxexistingRow["Taxes_ID"];
                            txRecordRow["AltTaxCode"] = "0";
                            txRecordRow["Percentage"] = taxexistingRow["TaxRates_Rate"];

                            TaxAmount = InclusiveAmt * (Convert.ToDecimal(taxexistingRow["TaxRates_Rate"]) / 100);


                            txRecordRow["Amount"] = Math.Round(TaxAmount, 2);

                            taxTable.Rows.Add(txRecordRow);

                        }
                    }



                }
            }

            #endregion
            return taxTable;
        }
        public IEnumerable GetVoucherTDS(DataTable Voucherdt)
        {
            DataSet DsOnLoad = new DataSet();
            DataTable tempdt = new DataTable();
            DBEngine objEngine = new DBEngine();
            List<VOUCHERLIST> VoucherList = new List<VOUCHERLIST>();          

            for (int i = 0; i < Voucherdt.Rows.Count; i++)
            {
                VOUCHERLIST Vouchers = new VOUCHERLIST();
                Vouchers.SrlNo = Convert.ToString(Voucherdt.Rows[i]["SrlNo"]);
                Vouchers.CashBankID = Convert.ToString(Voucherdt.Rows[i]["CashReportID"]);
                Vouchers.MainAccount = Convert.ToString(Voucherdt.Rows[i]["MainAccountID"]);
                Vouchers.bthSubAccount = Convert.ToString(Voucherdt.Rows[i]["SubAccountID"]);
                Vouchers.btnPayment = Convert.ToString(Voucherdt.Rows[i]["PaymentAmount"]);
                Vouchers.btnRecieve = Convert.ToString(Voucherdt.Rows[i]["ReceiptAmount"]);
                Vouchers.btnLineNarration = Convert.ToString(Voucherdt.Rows[i]["Remarks"]);
                Vouchers.TDS = "";
                Vouchers.TaxAmount = Convert.ToString(Voucherdt.Rows[i]["TaxAmount"]);
                Vouchers.NetAmount = Convert.ToString(Voucherdt.Rows[i]["NetAmount"]);
                Vouchers.ReverseApplicable = Convert.ToString(Voucherdt.Rows[i]["ReverseApplicable"]);
                Vouchers.gvColMainAccount = Convert.ToString(Voucherdt.Rows[i]["MainAccount"]);
                Vouchers.gvColSubAccount = Convert.ToString(Voucherdt.Rows[i]["SubAccount"]);
                VoucherList.Add(Vouchers);
            }

            return VoucherList;
        }
        public DataTable GetCashBankEditedTaxData(string CashBackId)
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankEditedTaxDetails");
            proc.AddVarcharPara("@CashBankId", 500, Convert.ToString(CashBackId));
            ds = proc.GetDataSet();
            return ds.Tables[0];
        }
        public DataTable GetTDSData(string MainAcc, string payment)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "BindTDS");
            proc.AddVarcharPara("@PaymentAmount", 2000, payment);
            proc.AddIntegerPara("@MainAccID", Convert.ToInt32(MainAcc));
            dt = proc.GetTable();
            return dt;
        }
        public DataTable GetCashBanktEditData()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankEditDetails");           
           // proc.AddVarcharPara("@IBRef", 200, Convert.ToString(Session["IBRef"]));
            proc.AddVarcharPara("@CashBank_ID", 200, Convert.ToString(Session["CashBank_ID"]));
            dt = proc.GetTable();
            return dt;
        }
        public DataSet GetCashBanktBatchEditData(string CashBank_ID)
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankEditBatchDetails");
            //  proc.AddVarcharPara("@IBRef", 200, Convert.ToString(Session["IBRef"]));
            proc.AddVarcharPara("@CashBank_ID", 200, CashBank_ID);
            ds = proc.GetDataSet();
            return ds;
        }
        public void SetReciptPayment(ref decimal Recipt, ref decimal Payment)
        {

            DataSet DsOnLoad = new DataSet();
            DataTable Voucherdt = new DataTable();

            if (File.Exists(Server.MapPath(CashBankVoucherFile_XMLPATH)))
            {
                if (DsOnLoad.Tables.Count > 0) { DsOnLoad.Tables.Remove(DsOnLoad.Tables[0]); DsOnLoad.Clear(); }
                DsOnLoad.ReadXml(Server.MapPath(CashBankVoucherFile_XMLPATH));
            }
            if (DsOnLoad.Tables.Count > 0 && DsOnLoad != null)
            {
                Voucherdt = DsOnLoad.Tables[0];

                for (int i = 0; i < Voucherdt.Rows.Count; i++)
                {
                    Recipt = Recipt + Convert.ToDecimal(Voucherdt.Rows[i]["ReceiptAmount"]);
                    Payment = Payment + Convert.ToDecimal(Voucherdt.Rows[i]["PaymentAmount"]);
                }
            }


        }
        public IEnumerable GetVoucherNull()
        {
            DataSet DsOnLoad = new DataSet();
            DataTable tempdt = new DataTable();
            DBEngine objEngine = new DBEngine();
            List<VOUCHERLIST> VoucherList = new List<VOUCHERLIST>();


            return VoucherList;
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
        public IEnumerable GetSubAccountNew(string strMainAccount, string strClause, string strBranch, string strType, string strSubAccount)
        {
            DataTable DT = GetSubAccountTable(strMainAccount, strClause, strBranch, strType, strSubAccount);

            List<SubAccountBind> SubAccountList = new List<SubAccountBind>();

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                SubAccountBind SubAccounts = new SubAccountBind();
                SubAccounts.SubAccount_ReferenceID = Convert.ToString(DT.Rows[i]["SubAccount_ReferenceID"]);
                SubAccounts.SubAccount_Name = Convert.ToString(DT.Rows[i]["Contact_Name"]);
                SubAccountList.Add(SubAccounts);
            }

            return SubAccountList;
        }
        public DataTable GetSubAccountTable(string strMainAccount, string strClause, string strBranch, string strType, string strSubAccount)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_FethSubAccountCashBankVoucher");
            proc.AddVarcharPara("@CashBank_MainAccountID", 500, strMainAccount);
            proc.AddVarcharPara("@clause", 500, strClause);
            proc.AddVarcharPara("@branch", 500, strBranch);
            proc.AddVarcharPara("@SelectionType", 500, strType);
            proc.AddVarcharPara("@SubAccount", 500, strSubAccount);
            dt = proc.GetTable();
            return dt;
        }
        #region  Tax
        public double GetTotalTaxAmount(List<TaxDetails> tax)
        {
            //decimal sum = 0;
            //foreach (TaxDetails td in tax)
            //{
            //    if (td.Taxes_Name.Substring(td.Taxes_Name.Length - 3, 3) == "(+)")
            //        sum += Convert.ToDecimal(td.Amount);
            //    else
            //        sum -= Convert.ToDecimal(td.Amount);

            //}
            //return Convert.ToDouble(sum);
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

        protected void cgridTax_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {

            string retMsg = "";
            if (e.Parameters.Split('~')[0] == "SaveGST")
            {
                DataTable TaxRecord = (DataTable)Session["CB_FinalTaxRecord"];
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
                Session["SI_FinalTaxRecord"] = TaxRecord;
            }
            else
            {
                #region fetch All data For Tax

                if (Session["CB_FinalTaxRecord"] == null)
                {
                    CreateDataTaxTable();
                }
                DataTable taxDetail = new DataTable();
                DataTable MainTaxDataTable = (DataTable)Session["CB_FinalTaxRecord"];
                DataTable databaseReturnTable = (DataTable)Session["SI_QuotationTaxDetails"];
                string type = "";
                if (Convert.ToString(rbtnType.SelectedValue) == "R")
                {
                    type = "S";
                }
                else
                {
                    type = "P";
                }

                ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
                proc.AddVarcharPara("@Action", 500, "LoadOtherTaxDetails");
                proc.AddVarcharPara("@MainAccountID", 100, Convert.ToString(setCurrentProdCode.Value));
                proc.AddVarcharPara("@dtTDate", 10, dtTDate.Date.ToString("yyyy-MM-dd"));
                proc.AddVarcharPara("@Type", 5, type);
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
                }
                string ShippingState = "";
                #region ##### Added By : Samrat Roy -- For BillingShippingUserControl ######
                string sstateCode = BillingShippingControl.GetShippingStateCode("ADD");
                ShippingState = sstateCode;
                if (ShippingState.Trim() != "")
                {
                    ShippingState = ShippingState.Substring(ShippingState.IndexOf("(State Code:")).Replace("(State Code:", "").Replace(")", "");
                }

                #endregion
                if (ShippingState.Trim() != "" && BranchStateCode != "")
                {
                    if (BranchStateCode == ShippingState)
                    {
                        //Check if the state is in union territories then only UTGST will apply
                        //   Chandigarh     Andaman and Nicobar Islands    DADRA & NAGAR HAVELI    DAMAN & DIU      Lakshadweep              PONDICHERRY
                        if (ShippingState == "4" || ShippingState == "26" || ShippingState == "25" || ShippingState == "35" || ShippingState == "31" || ShippingState == "34")
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
                if (compGstin[0].Trim() == "" && BranchGSTIN == "")
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
                int slNo = Convert.ToInt32(HdSerialNo1.Value);
                //Get Gross Amount and Net Amount 
                decimal ProdGrossAmt = Convert.ToDecimal(HdProdGrossAmt.Value);
                decimal ProdNetAmt = Convert.ToDecimal(HdProdNetAmt.Value);
                List<TaxDetails> TaxDetailsDetails = new List<TaxDetails>();
                //Debjyoti 09032017
                decimal totalParcentage = 0;
                foreach (DataRow dr in taxDetail.Rows)
                {
                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
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
                        if (Convert.ToString(ddl_AmountAre.Value) == "2")
                        {
                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                            {
                                decimal finalCalCulatedOn = 0;
                                decimal backProcessRate = (1 + (totalParcentage / 100));
                                finalCalCulatedOn = obj.calCulatedOn / backProcessRate;
                                obj.calCulatedOn = finalCalCulatedOn;
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

                        TaxDetailsDetails.Add(obj);
                    }
                }
                else
                {
                    string keyValue = e.Parameters.Split('~')[0];
                    DataTable TaxRecord = (DataTable)Session["SI_FinalTaxRecord"];
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
                        if (Convert.ToString(ddl_AmountAre.Value) == "2")
                        {
                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                            {
                                decimal finalCalCulatedOn = 0;
                                decimal backProcessRate = (1 + (totalParcentage / 100));
                                finalCalCulatedOn = obj.calCulatedOn / backProcessRate;
                                obj.calCulatedOn = finalCalCulatedOn;
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
                        DataRow[] filtrIndex = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode=0");
                        if (filtrIndex.Length > 0)
                        {
                            aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(filtrIndex[0]["AltTaxCode"]);
                        }
                    }
                    Session["SI_FinalTaxRecord"] = TaxRecord;

                }
                //New Changes 170217
                //GstCode should fetch everytime
                DataRow[] finalFiltrIndex = MainTaxDataTable.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode=0");
                if (finalFiltrIndex.Length > 0)
                {
                    aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(finalFiltrIndex[0]["AltTaxCode"]);
                }
                aspxGridTax.JSProperties["cpJsonData"] = createJsonForDetails(taxDetail);
                retMsg = Convert.ToString(GetTotalTaxAmount(TaxDetailsDetails));
                aspxGridTax.JSProperties["cpUpdated"] = "ok~" + retMsg;
                
                if (Request.QueryString["key"] != "ADD")
                {
                    if ((Convert.ToDecimal(TaxAmountOngrid.Value) == 0) && TaxDetailsDetails != null && Convert.ToInt64(VisibleIndexForTax.Value)>=0)
                    {
                        foreach (var DrTax in TaxDetailsDetails)
                        {

                            DrTax.Amount = 0; 
                        }

                    }

                }
               // taxDetail.AcceptChanges();
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
            if (e.Column.FieldName == "taxCodeName")
            {
                e.Editor.ReadOnly = true;
            }
            if (e.Column.FieldName == "calCulatedOn")
            {
                e.Editor.ReadOnly = true;
            }
            //else if (e.Column.FieldName == "Amount")
            //{
            //    e.Editor.ReadOnly = true;
            //}
            else
            {
                e.Editor.ReadOnly = false;
            }
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
        protected void taxgrid_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            int slNo = Convert.ToInt32(HdSerialNo1.Value);
            DataTable TaxRecord = (DataTable)Session["CB_FinalTaxRecord"];
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
            Session["CB_FinalTaxRecord"] = TaxRecord;
            #region Samrat Old
            //int slNo = Convert.ToInt32(HdSerialNo.Value);


            //if (Session["CB_FinalTaxRecord"] == null)
            //{
            //    CreateDataTaxTable();
            //}
            //DataTable TaxRecord = ((DataTable)Session["CB_FinalTaxRecord"]);

            //foreach (var args in e.UpdateValues)
            //{

            //    string TaxCodeDes = Convert.ToString(args.NewValues["Taxes_Name"]);
            //    decimal Percentage = 0;

            //    Percentage = Convert.ToDecimal(args.NewValues["TaxField"]);

            //    decimal Amount = Convert.ToDecimal(args.NewValues["Amount"]);
            //    string TaxCode = "0";
            //    if (!Convert.ToString(args.Keys[0]).Contains('~'))
            //    {
            //        TaxCode = Convert.ToString(args.Keys[0]);
            //    }


            //    if (TaxRecord != null)
            //    {
            //        DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='" + TaxCode + "'");
            //        if (finalRow.Length > 0)
            //        {
            //            finalRow[0]["Percentage"] = Percentage;
            //            // finalRow[0]["TaxCode"] = args.NewValues["TaxField"]; 
            //            finalRow[0]["Amount"] = Amount;

            //            finalRow[0]["TaxCode"] = args.Keys[0];
            //            finalRow[0]["AltTaxCode"] = "0";

            //        }
            //        else
            //        {
            //            DataRow newRow = TaxRecord.NewRow();
            //            newRow["slNo"] = slNo;
            //            newRow["Percentage"] = Percentage;
            //            newRow["TaxCode"] = TaxCode;
            //            newRow["AltTaxCode"] = "0";
            //            newRow["Amount"] = Amount;
            //            TaxRecord.Rows.Add(newRow);
            //        }
            //    }
            //    else
            //    {
            //        DataRow newRow = TaxRecord.NewRow();
            //        newRow["slNo"] = slNo;
            //        newRow["Percentage"] = Percentage;
            //        newRow["TaxCode"] = TaxCode;
            //        newRow["AltTaxCode"] = "0";
            //        newRow["Amount"] = Amount;
            //        TaxRecord.Rows.Add(newRow);
            //    }




            //}

            ////For GST/CST/VAT
            //if (cmbGstCstVat.Value != null)
            //{

            //    DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='0'");
            //    if (finalRow.Length > 0)
            //    {
            //        finalRow[0]["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
            //        finalRow[0]["Amount"] = txtGstCstVat.Text;
            //        finalRow[0]["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];

            //    }

            //}
            ////End Here


            //Session["CB_FinalTaxRecord"] = TaxRecord;
            #endregion         
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
        protected void cmbGstCstVat_Callback(object sender, CallbackEventArgsBase e)
        {
            DateTime quoteDate = Convert.ToDateTime(dtTDate.Date.ToString("yyyy-MM-dd"));

            // PopulateGSTCSTVATCombo(quoteDate.ToString("yyyy-MM-dd"));
            // CreateDataTaxTable();

        }
        #endregion
        #region ####### Reverse Charge Posting ##############
        public DataTable GetReverseTaxTable(DataTable productDetails, string SerialColumnName, string ProductColumnName, string AmountColumnName, string chargesColumns, DataTable taxTable, string ApplicableFor, string TransactionDate, string BranchId, string ShippingState)
        {
            string VendorState = "", TaxType = "", roundOfPlus = "", roundofMinus = "";

            DataTable fetchedData = oDBEngine.GetDataTable("select TaxRates_ID from Config_TaxRates config inner join Master_Taxes masterTax on config.TaxRates_TaxCode = masterTax.Taxes_ID  where  TaxRates_RoundingOff='R+' and Taxes_ApplicableFor in ('B','" + ApplicableFor + "')");
            if (fetchedData.Rows.Count > 0)
                roundOfPlus = Convert.ToString(fetchedData.Rows[0][0]).Trim();

            fetchedData = oDBEngine.GetDataTable("select TaxRates_ID from Config_TaxRates config inner join Master_Taxes masterTax on config.TaxRates_TaxCode = masterTax.Taxes_ID  where  TaxRates_RoundingOff='R-' and Taxes_ApplicableFor in ('B','" + ApplicableFor + "')");
            if (fetchedData.Rows.Count > 0)
                roundofMinus = Convert.ToString(fetchedData.Rows[0][0]).Trim();
           
            VendorState = BillingShippingControl.GetShippingStateCode("ADD");
            VendorState = VendorState.Substring(VendorState.IndexOf(':') + 1, (VendorState.Length - (VendorState.IndexOf(':') + 1))).Replace(")", "");
            string CompInternalId = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string[] compGstin = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_gstin", "cmp_internalid='" + CompInternalId + "'", 1);
            string BrancgStateCode = "", BranchGSTIN = "";
            DataTable BranchTable = oDBEngine.GetDataTable("select StateCode,branch_GSTIN   from tbl_master_branch branch inner join tbl_master_state st on branch.branch_state=st.id where branch_id=" + BranchId);
            if (BranchTable != null)
            {
                BrancgStateCode = Convert.ToString(BranchTable.Rows[0][0]);
                BranchGSTIN = Convert.ToString(BranchTable.Rows[0][1]);
                if (BranchGSTIN.Trim() != "")
                {
                    BrancgStateCode = BranchGSTIN.Substring(0, 2);
                }
            }
            if (BranchGSTIN.Trim() == "")
            {
                BrancgStateCode = compGstin[0].Substring(0, 2);
            }
            #region setTaxType
            if (BrancgStateCode == VendorState)
            {
                TaxType = "SGST";
                if (VendorState == "4" || VendorState == "26" || VendorState == "25" || VendorState == "7" || VendorState == "31" || VendorState == "34")
                {
                    TaxType = "UTGST";
                }
            }
            else
            {
                TaxType = "IGST";
            }

            #endregion
            if (!(BrancgStateCode.Trim() == "" || VendorState.Trim() == ""))
            {
                foreach (DataRow productRow in productDetails.Rows)
                {
                    if (taxTable.Select("SlNo=" + productRow[SerialColumnName]).Length == 0)
                    {
                        string type = "";
                        if (Convert.ToString(rbtnType) == "R")
                        {
                            type = "S";
                        }
                        else
                        {
                            type = "P";
                        }
                        DataTable taxDetail = new DataTable();
                        ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
                        proc.AddVarcharPara("@Action", 500, "LoadOtherTaxDetails");
                        proc.AddVarcharPara("@MainAccountID", 100, Convert.ToString(productRow["MainAccount"]));
                        proc.AddVarcharPara("@dtTDate", 10, dtTDate.Date.ToString("yyyy-MM-dd"));
                        proc.AddVarcharPara("@Type", 5, type);
                        taxDetail = proc.GetTable();
                        #region DeleteExtra GstCode

                        if (TaxType == "UTGST")
                        {
                            foreach (DataRow dr in taxDetail.Rows)
                            {
                                if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                                {
                                    dr.Delete();
                                }
                            }
                        }
                        else if (TaxType == "IGST")
                        {
                            foreach (DataRow dr in taxDetail.Rows)
                            {
                                if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                                {
                                    dr.Delete();
                                }
                            }
                        }
                        else if (TaxType == "SGST")
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
                        #endregion
                        foreach (DataRow taxexistingRow in taxDetail.Rows)
                        {
                            if (Convert.ToString(taxexistingRow["TaxTypeCode"]).Trim() != "O")
                            {
                                DataRow txRecordRow = taxTable.NewRow();
                                txRecordRow["SlNo"] = productRow[SerialColumnName];
                                txRecordRow["TaxCode"] = taxexistingRow["Taxes_ID"];
                                txRecordRow["AltTaxCode"] = "0";
                                txRecordRow["Percentage"] = taxexistingRow["TaxRates_Rate"];
                                txRecordRow["Amount"] = Convert.ToDecimal(productRow["PaymentAmount"]) * (Convert.ToDecimal(taxexistingRow["TaxRates_Rate"]) / 100);
                                taxTable.Rows.Add(txRecordRow);

                            }
                        }

                    }
                }
            }
            return taxTable;
        }
        public DataTable CreateReverseTaxTable()
        {
            DataTable TaxRecord = new DataTable();

            TaxRecord.Columns.Add("SlNo", typeof(System.Int32));
            TaxRecord.Columns.Add("TaxCode", typeof(System.String));
            TaxRecord.Columns.Add("AltTaxCode", typeof(System.String));
            TaxRecord.Columns.Add("Percentage", typeof(System.Decimal));
            TaxRecord.Columns.Add("Amount", typeof(System.Decimal));

            return TaxRecord;

        }
        #endregion
        //protected void SelectPanel_Callback(object sender, CallbackEventArgsBase e)
        //{
        //    string strSplitCommand = e.Parameter.Split('~')[0];
        //    if (strSplitCommand == "Bindalldesignes")
        //    {
        //        string[] filePaths = new string[] { };
        //        string DesignPath = "";
        //        if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
        //        {
        //            DesignPath = @"Reports\Reports\RepxReportDesign\CashBankVoucher\DocDesign\Designes";
        //        }
        //        else
        //        {
        //            DesignPath = @"Reports\RepxReportDesign\CashBankVoucher\DocDesign\Designes";
        //        }
        //        string fullpath = Server.MapPath("~");
        //        fullpath = fullpath.Replace("ERP.UI\\", "");
        //        string DesignFullPath = fullpath + DesignPath;
        //        filePaths = System.IO.Directory.GetFiles(DesignFullPath, "*.repx");

        //        foreach (string filename in filePaths)
        //        {
        //            string reportname = Path.GetFileNameWithoutExtension(filename);
        //            string name = "";
        //            if (reportname.Split('~').Length > 1)
        //            {
        //                name = reportname.Split('~')[0];
        //            }
        //            else
        //            {
        //                name = reportname;
        //            }
        //            string reportValue = reportname;
        //            CmbDesignName.Items.Add(name, reportValue);
        //        }
        //        CmbDesignName.SelectedIndex = 0;
        //    }
        //    else
        //    {
        //        string DesignPath = @"Reports\Reports\REPXReports";
        //        string fullpath = Server.MapPath("~");
        //        fullpath = fullpath.Replace("ERP.UI\\", "");
        //        string filename = @"\RepxReportViewer.aspx";
        //        string DesignFullPath = fullpath + DesignPath + filename;
        //        string reportName = Convert.ToString(CmbDesignName.Value);
        //        SelectPanel.JSProperties["cpSuccess"] = "Success";
        //    }
        //}
        public void DeleteTaxDetails(string SrlNo)
        {
            DataTable TaxDetailTable = new DataTable();
            if (Session["CB_FinalTaxRecord"] != null)
            {
                TaxDetailTable = (DataTable)Session["CB_FinalTaxRecord"];

                var rows = TaxDetailTable.Select("SlNo ='" + SrlNo + "'");
                foreach (var row in rows)
                {
                    row.Delete();
                }
                TaxDetailTable.AcceptChanges();

                Session["CB_FinalTaxRecord"] = TaxDetailTable;
            }
        }
        public void UpdateTaxDetails(string oldSrlNo, string newSrlNo)
        {
            DataTable TaxDetailTable = new DataTable();
            if (Session["CB_FinalTaxRecord"] != null)
            {
                TaxDetailTable = (DataTable)Session["CB_FinalTaxRecord"];

                for (int i = 0; i < TaxDetailTable.Rows.Count; i++)
                {
                    DataRow dr = TaxDetailTable.Rows[i];
                    string Product_SrlNo = Convert.ToString(dr["SlNo"]);
                    if (oldSrlNo == Product_SrlNo)
                    {
                        dr["SlNo"] = newSrlNo;
                    }
                }
                TaxDetailTable.AcceptChanges();

                Session["CB_FinalTaxRecord"] = TaxDetailTable;
            }
        }
        public DataTable GetListGridDataByFilter(string userbranchlist, string lastCompany, string Fiyear, string userbranchID, string FromDate, string ToDate)
        {

            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 500, "CashBankGridList");
            proc.AddVarcharPara("@FinYear", 500, Fiyear);
            proc.AddVarcharPara("@CompanyID", 500, lastCompany);
            proc.AddVarcharPara("@BranchList", 5000, userbranchlist);
            proc.AddVarcharPara("@BranchID", 3000, userbranchID);
            proc.AddVarcharPara("@FromDate", 10, FromDate);
            proc.AddVarcharPara("@ToDate", 10, ToDate);
            dt = proc.GetTable();
            return dt;
        }
        protected void acpCrossBtn_Callback(object sender, CallbackEventArgsBase e)
        {
            Session.Remove("CashBankDetails");
        }

        protected void gridBatch_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data)
                return;

            string parentLedgerId = Convert.ToString(e.GetValue("MainAccount"));
            if (parentLedgerId.Trim() !="")
            {
                e.Row.Cells[9].Controls[0].Visible = false;
            }
        }
        //protected void GvCBSearch_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        //{
        //    e.Text = string.Format("{0}", e.Value);
        //}
        //protected void ASPxCallbackGeneral_Callback(object sender, CallbackEventArgsBase e)
        //{
        //    string command = e.Parameter.Split('~')[0];
        //    int RowIndex=0;
        //    string IBRef="";
        //    string cask_bankID="";
            
        //    if (command == "Edit" || command == "View")
        //    {
        //        RowIndex = Convert.ToInt32(e.Parameter.Split('~')[1]);
        //        string CBID = "";
        //        //string CBID = GvCBSearch.GetRowValues(RowIndex, "CBID").ToString();
        //        ViewState["CashBankID"] = CBID;
        //       // IBRef = GvCBSearch.GetRowValues(RowIndex, "IBRef").ToString();
        //        Session["IBRef"] = IBRef;
        //        Session["CashBank_ID"] = CBID;
                
        //        hdnEditRfid.Value = IBRef;              
        //        Session["CB_FinalTaxRecord"] = null;
        //        gridBatch.JSProperties["cpNOTEdit"] = null;
        //       // cask_bankID = GvCBSearch.GetRowValues(RowIndex, "CBID").ToString();
        //        hdnEditCBID.Value = cask_bankID;
        //        Session["CB_FinalTaxRecord"] = GetCashBankEditedTaxData(CBID);
        //        DataSet DsOnLoad = new DataSet();
        //        string VoucherType = "", VoucherNo = "", Date = "", Branch = "", Cash_Bank = "", Currency = "", InstrumentType = "", InstrumentNo = "", InstrumentDate = "",
        //            Narration = "", InstrumentTypeName = "", BankStatementDate = "", BankValueDate = "", ReceivedFrom = "", PaidTo = "", Tax_Code = "", ContactNo = "",
        //            ReverseCharge = "0", DraweeBank = "", EnteredBranchID = "", CashBankName = "";

        //        DataTable CashBanktEditdt = GetCashBanktEditData();
        //        if (CashBanktEditdt != null && CashBanktEditdt.Rows.Count > 0)
        //        {
        //            VoucherType = Convert.ToString(CashBanktEditdt.Rows[0]["VoucherType"]);//0
        //            rbtnType.SelectedValue = VoucherType;
        //            VoucherNo = Convert.ToString(CashBanktEditdt.Rows[0]["OldVoucherNumber"]);//1
        //            txtVoucherNo.Text = VoucherNo;
        //            Date = Convert.ToString(CashBanktEditdt.Rows[0]["TransactionDate"]);//2
        //            dtTDate.Date = Convert.ToDateTime(Date);
        //            Branch = Convert.ToString(CashBanktEditdt.Rows[0]["BranchID"]);//3 
        //            ddlBranch.SelectedValue = Branch;
                  
        //            Cash_Bank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankID"]);//4                
        //            ddlCashBank.Value = Cash_Bank;
        //            Currency = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_Currency"]);//5
        //            CmbCurrency.Value = Currency;
        //            InstrumentTypeName = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);

        //            if (InstrumentTypeName == "0")
        //            {
        //                InstrumentType = "CH";
        //            }
        //            else
        //            {
        //                InstrumentType = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentType"]);//6
        //            }
        //            cmbInstrumentType.Value = InstrumentType;

        //            InstrumentNo = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentNumber"]);//7
        //            txtInstNobth.Text = InstrumentNo;
        //            Narration = Convert.ToString(CashBanktEditdt.Rows[0]["Narration"]);//8
        //            txtNarration.Text = Narration;
        //            BankStatementDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankStatementDate"]);

        //            BankValueDate = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankDetail_BankValueDate"]);


        //            ReceivedFrom = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReceivedFrom"]);//12
        //            txtReceivedFrom.Text = ReceivedFrom;
        //            PaidTo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_PaidTo"]);//13
        //            txtPaidTo.Text = PaidTo;
        //            Tax_Code = Convert.ToString(CashBanktEditdt.Rows[0]["Tax_Code"]);
        //            ddl_AmountAre.Value = Tax_Code;
        //            ContactNo = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ContactNo"]);
        //            txtContact.Text = ContactNo;
        //            ReverseCharge = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_ReverseCharge"]);
        //            chk_reversemechenism.Checked = Convert.ToBoolean(ReverseCharge);
                  
        //            InstrumentDate = Convert.ToString(CashBanktEditdt.Rows[0]["InstrumentDate"]);
        //            InstDate.Date = Convert.ToDateTime(InstrumentDate);
        //            DraweeBank = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_DraweeBank"]);
        //            txtDraweeBank.Text = DraweeBank;
        //            EnteredBranchID = Convert.ToString(CashBanktEditdt.Rows[0]["CashBank_EnteredBranchID"]);
        //            ddlEnterBranch.SelectedValue = EnteredBranchID;
        //            CashBankName = Convert.ToString(CashBanktEditdt.Rows[0]["CashBankName"]);
        //            BindCashBankAccount(EnteredBranchID);
        //        }
        //        ASPxCallbackGeneral.JSProperties["cpCBEdit"] = VoucherType + "*" + cask_bankID + "*" + Currency + "*" +InstrumentType;
        //        DataTable Voucherdt = GetCashBanktBatchEditData(hdnEditRfid.Value).Tables[0];
        //        string Recipt = Convert.ToString(Voucherdt.Compute("Sum(ReceiptAmount)", ""));
        //        string Payment = Convert.ToString(Voucherdt.Compute("Sum(PaymentAmount)", ""));
        //        txtTotalAmount.Text = Recipt;
        //        txtTotalPayment.Text = Payment;
        //        ASPxCallbackGeneral.JSProperties["cpView"] = (command.ToUpper() == "VIEW") ? "1" : "0";
        //        Session["CashBankDetails"] = GetCashBanktBatchEditData(hdnEditRfid.Value).Tables[0];
        //        gridBatch.DataSource = GetVoucher();
        //        gridBatch.DataBind();

        //    }
        //}


        #region  Main Account 
        //protected void EntityServerMainDataSource_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        //{
        //    e.KeyExpression = "MainAccount_ReferenceID";

        //    string connectionString = ConfigurationManager.ConnectionStrings["crmConnectionString"].ConnectionString;
        //    string IsFilter = Convert.ToString(hfIsFilter.Value);
        //    string strBranchID = (Convert.ToString(hdnBranchId.Value) == "") ? "0" : Convert.ToString(hdnBranchId.Value);

        //    string strBranchID1 = strBranchID + "0";

        //    List<int> branchidlist;
        //    ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);

        //    if (IsFilter == "Y")
        //    {

        //        branchidlist = new List<int>(Array.ConvertAll(strBranchID1.Split(','), int.Parse));
        //        var q = from d in dc.v_MainAccountLists
        //                where
        //                branchidlist.Contains(Convert.ToInt32(d.MainAccount_branchId))
        //                orderby d.MainAccount_Name descending
        //                select d;
        //        e.QueryableSource = q;

        //    }
        //    else
        //    {                
        //        var q = from d in dc.v_MainAccountLists                        
        //                orderby d.MainAccount_Name descending
        //                select d;
        //        e.QueryableSource = q;
        //    }

        //}

        protected void ASPxMainAccountComboBox_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            //if (Convert.ToString(e.Filter).Trim() != "" && Convert.ToString(e.Filter).Length>4)
            if (Convert.ToString(e.Filter).Trim() != "")
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;
                DataTable dt = new DataTable();
                string filter = "%" + Convert.ToString(e.Filter) + "%";
                int startindex = Convert.ToInt32(e.BeginIndex + 1);
                int EndIndex = Convert.ToInt32(e.EndIndex + 1);
                string strBranchID = (Convert.ToString(hdnBranchId.Value) == "") ? "0" : Convert.ToString(hdnBranchId.Value);
                string strCompanyID = Convert.ToString(Session["LastCompany"]);
                dt = GetMainAccountTableNew(strBranchID, filter, startindex, EndIndex, strCompanyID);
                comboBox.DataSource = dt;
                comboBox.DataBind();
            }
        }
        protected void ASPxMainComboBox_OnItemRequestedByValue_SQL(object source, ListEditItemRequestedByValueEventArgs e)
        {
            long value = 0;
            if (e.Value == null || !Int64.TryParse(e.Value.ToString(), out value))
                return;
            ASPxComboBox comboBox = (ASPxComboBox)source;
            SqlDataSourceMainAccount.SelectCommand = @"SELECT MainAccount_ReferenceID,MainAccount_Name,MainAccount_SubLedgerType,MainAccount_ReverseApplicable,TAXable FROM v_MainAccountList WHERE (MainAccount_ReferenceID = @ID) ";

            SqlDataSourceMainAccount.SelectParameters.Clear();
            SqlDataSourceMainAccount.SelectParameters.Add("ID", TypeCode.String, e.Value.ToString());
            comboBox.DataSource = SqlDataSourceMainAccount;
            comboBox.DataBind();
        }
        
        public DataTable GetMainAccountTableNew(string strBranchID, string filter, int startindex, int EndIndex, string strCompanyID)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 100, "GetMainAccountList");
            proc.AddVarcharPara("@CompanyID", 500, strCompanyID);
            proc.AddVarcharPara("@filter", 100, filter);
            proc.AddIntegerPara("@startIndex", startindex);
            proc.AddIntegerPara("@endIndex", EndIndex);
            proc.AddVarcharPara("@BranchID", 100, strBranchID);
            dt = proc.GetTable();
            return dt;
        }
        #endregion

        protected void ASPxComboBox_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            if (e.Filter != "")
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;
                DataTable dt = new DataTable();
                string filter = "%" + Convert.ToString(e.Filter) + "%";
                int startindex = Convert.ToInt32(e.BeginIndex + 1);
                int EndIndex = Convert.ToInt32(e.EndIndex + 1);
                string MainAccountID = hdnMainAccountId.Value;

                dt = GetSubAccountTableNew(MainAccountID, filter, startindex, EndIndex);
                comboBox.DataSource = dt;
                comboBox.DataBind();
            }
        }
        public DataTable GetSubAccountTableNew(string strMainAccount, string filter, int startindex, int EndIndex)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Fetch_CashBankEntry_DataSet");
            proc.AddVarcharPara("@Action", 100, "GetSubAccountListBYMainAccount");
            proc.AddVarcharPara("@MainAccountID", 500, strMainAccount);
            proc.AddVarcharPara("@filter", 100, filter);           
            proc.AddIntegerPara("@startIndex", startindex);
            proc.AddIntegerPara("@endIndex", EndIndex);                  
            dt = proc.GetTable();
            return dt;
        }
        protected void ASPxComboBox_OnItemRequestedByValue_SQL(object source, ListEditItemRequestedByValueEventArgs e)
        {
            long value = 0;
            if (e.Value == null || !Int64.TryParse(e.Value.ToString(), out value))
                return;
            ASPxComboBox comboBox = (ASPxComboBox)source;
            SqlDataSourceSubAccount.SelectCommand = @"SELECT SubAccount_ReferenceID,Contact_Name,MainAccount_SubLedgerType,mainaccount_referenceid FROM v_SubAccountList WHERE (SubAccount_ReferenceID = @ID) ";

            SqlDataSourceSubAccount.SelectParameters.Clear();
            SqlDataSourceSubAccount.SelectParameters.Add("ID", TypeCode.String, e.Value.ToString());
            comboBox.DataSource = SqlDataSourceSubAccount;
            comboBox.DataBind();
        }


        public void GetFinacialYearBasedQouteDate()
        {
            String finyear = "";
            string setdate = null;
            if (Session["LastFinYear"] != null)
            {
                SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
                finyear = Convert.ToString(Session["LastFinYear"]).Trim();
                DataTable dtFinYear = objSlaesActivitiesBL.GetFinacialYearBasedQouteDate(finyear);
                if (dtFinYear != null && dtFinYear.Rows.Count > 0)
                {
                    Session["FinYearStartDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearStartDate"]);
                    Session["FinYearEndDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearEndDate"]);
                    if (Session["FinYearStartDate"] != null)
                    {
                        dtTDate.MinDate = Convert.ToDateTime(Convert.ToString(Session["FinYearStartDate"]));
                    }
                    if (Session["FinYearEndDate"] != null)
                    {
                        dtTDate.MaxDate = Convert.ToDateTime(Convert.ToString(Session["FinYearEndDate"]));
                    }
                    if (oDBEngine.GetDate().Date >= Convert.ToDateTime(Convert.ToString(Session["FinYearStartDate"])) && oDBEngine.GetDate().Date <= Convert.ToDateTime(Convert.ToString(Session["FinYearEndDate"])))
                    {
                        dtTDate.Date = DateTime.Now;

                    }
                    else if (oDBEngine.GetDate().Date >= Convert.ToDateTime(Convert.ToString(Session["FinYearStartDate"])) && oDBEngine.GetDate().Date >= Convert.ToDateTime(Convert.ToString(Session["FinYearEndDate"])))
                    {
                        setdate = Convert.ToString(Convert.ToDateTime(Session["FinYearEndDate"]).Month) + "/" + Convert.ToString(Convert.ToDateTime(Session["FinYearEndDate"]).Day) + "/" + Convert.ToString(Convert.ToDateTime(Session["FinYearEndDate"]).Year);
                        dtTDate.Value = DateTime.ParseExact(setdate, @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
                        //dt_PLQuote.Value = DateTime.ParseExact(Convert.ToString(Session["FinYearStartDate"]), @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
                    }
                    else if (oDBEngine.GetDate().Date <= Convert.ToDateTime(Convert.ToString(Session["FinYearStartDate"])) && oDBEngine.GetDate().Date <= Convert.ToDateTime(Convert.ToString(Session["FinYearEndDate"])))
                    {
                        setdate = Convert.ToString(Convert.ToDateTime(Session["FinYearStartDate"]).Month) + "/" + Convert.ToString(Convert.ToDateTime(Session["FinYearStartDate"]).Day) + "/" + Convert.ToString(Convert.ToDateTime(Session["FinYearStartDate"]).Year);
                        dtTDate.Value = DateTime.ParseExact(setdate, @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);

                        //dt_PLQuote.Value = DateTime.ParseExact(Convert.ToString(Session["FinYearEndDate"]), @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
                    }
                }
            }
            //dt_PLQuote.Value = Convert.ToDateTime(oDBEngine.GetDate().ToString());
        }

    }
    
}
