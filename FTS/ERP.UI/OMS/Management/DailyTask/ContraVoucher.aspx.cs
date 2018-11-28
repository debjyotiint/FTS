using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using System.Collections;
using System.Configuration;
using System.Data;
using BusinessLogicLayer;
using DataAccessLayer;
using System.Data.SqlClient;
using System.IO;
using System.Web.Services;
using DevExpress.Web.Data;
using EntityLayer.CommonELS;
using System.Threading.Tasks;
using ERP.Models;
namespace ERP.OMS.Management.DailyTask
{
    public partial class ContraVoucher : ERP.OMS.ViewState_class.VSPage//System.Web.UI.Page
    {
        DataTable DtCurrentSegment;      
        BusinessLogicLayer.GenericLogSystem oGenericLogSystem;
        FinancialAccounting oFinancialAccounting = new FinancialAccounting();
        BusinessLogicLayer.DBEngine oDbEngine;
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        string[] lengthIndex;
        string JVNumStr = string.Empty;
        static string ForJournalDate = null;
        BusinessLogicLayer.Converter objConverter = new BusinessLogicLayer.Converter();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();   
    
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/dailytask/ContraVoucher.aspx");
            oGenericLogSystem = new BusinessLogicLayer.GenericLogSystem();
            if (!IsPostBack)
            {
                Session.Remove("exportval");
                //Session.Remove("ContraListingDetails");
                string[] FinYEnd = Session["FinYearEnd"].ToString().Split(' ');
                string FinYearEnd = FinYEnd[0];
                ViewState["LogID"] = oGenericLogSystem.GetLogID();
                string strdefaultBranch = "";
                if (!String.IsNullOrEmpty(Convert.ToString(Session["userbranchID"])))
                {
                    strdefaultBranch = Convert.ToString(Session["userbranchID"]);
                }
                Task PopulateStockTrialDataTask = new Task(() => BindAllControlDataOnPageLoad(FinYearEnd,strdefaultBranch));
                PopulateStockTrialDataTask.RunSynchronously(); 
            }
           
        }

        #region Others

        public void BindAllControlDataOnPageLoad(string FinYearEnd, string strdefaultBranch)
        {
            this.Page.ClientScript.RegisterStartupScript(GetType(), "CS", "<script>PageLoad();</script>");

            GetAllDropDownDetailForCashBank();
            FormDate.Date = DateTime.Now;
            toDate.Date = DateTime.Now;
            // Bind_NumberingScheme();  
            oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            // DtCurrentSegment = oDbEngine.GetDataTable("(select exch_internalId, isnull((select top 1 exh_shortName from tbl_master_Exchange where exh_cntId=tbl_master_companyExchange.exch_exchId),exch_membershiptype) as Segment from tbl_master_companyExchange where exch_compid in (select top 1 ls_lastCompany from tbl_trans_Lastsegment where ls_lastSegment=" + Session["userlastsegment"].ToString() + " and ls_userid=" + Session["UserID"].ToString() + ") and exch_compId='" + HttpContext.Current.Session["LastCompany"].ToString() + "') as D", "*", " Segment in(select seg_name from tbl_master_segment where seg_id=" + Session["userlastsegment"].ToString() + ")");

            hdn_CurrentSegment.Value = "1";
            tDate.EditFormatString = objConverter.GetDateFormat("Date");
            InstDate.EditFormatString = objConverter.GetDateFormat("Date");
            string fDate = null;
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
            tDate.Value = DateTime.ParseExact(fDate, @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            InstDate.Value = DateTime.ParseExact(fDate, @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            ddlBranch.SelectedValue = strdefaultBranch;
            // FillContraGrid();
            //BindBranchFrom();
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

                ddlBranchTo.DataTextField = "BANKBRANCH_NAME";
                ddlBranchTo.DataValueField = "BANKBRANCH_ID";
                ddlBranchTo.DataSource = dst.Tables[0];
                ddlBranchTo.DataBind();

                
            }
            if (dst.Tables[1] != null && dst.Tables[1].Rows.Count > 0)
            {
                cmbBranchfilter.ValueField = "branch_id";
                cmbBranchfilter.TextField = "branch_description";
                cmbBranchfilter.DataSource = dst.Tables[1];
                cmbBranchfilter.DataBind();
                cmbBranchfilter.SelectedIndex = 0;
                cmbBranchfilter.Value = Convert.ToString(Session["userbranchID"]);
            }           
            
            if (dst.Tables[3] != null && dst.Tables[3].Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "ID";
                CmbScheme.DataSource = dst.Tables[3];
                CmbScheme.DataBind();
            }


        }
        public DataSet AllDropDownDetailForCashBank()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Prc_Search_ContraVoucher");
            proc.AddVarcharPara("@Action", 100, "GetAllDropDownData");
            proc.AddVarcharPara("@FinYear", 50, Convert.ToString(Session["LastFinYear"]));
            proc.AddVarcharPara("@CompanyID", 50, Convert.ToString(HttpContext.Current.Session["LastCompany"]));
            proc.AddVarcharPara("@BranchList", 4000, Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]));
            ds = proc.GetDataSet();
            return ds;
        }
        private void PopulateBranchByHierchy(string userbranchhierchy)
        {
            DataTable branchtable = getBranchListByHierchy(userbranchhierchy);
            cmbBranchfilter.DataSource = branchtable;
            cmbBranchfilter.ValueField = "branch_id";
            cmbBranchfilter.TextField = "branch_description";
            cmbBranchfilter.DataBind();
            cmbBranchfilter.SelectedIndex = 0;

            cmbBranchfilter.Value = Convert.ToString(Session["userbranchID"]);
        }
        public DataTable getBranchListByHierchy(string userbranchhierchy)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Prc_Search_ContraVoucher");
            proc.AddVarcharPara("@Action", 100, "getBranchListbyHierchy");
            proc.AddVarcharPara("@BranchList", 4000, userbranchhierchy);
            ds = proc.GetTable();
            return ds;
        }
        public void Bind_NumberingScheme()
        {
            string strCompanyID = Convert.ToString(Session["LastCompany"]);
            string strBranchID = Convert.ToString(Session["userbranchID"]);
            string FinYear = Convert.ToString(Session["LastFinYear"]);
            string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
            SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
            DataTable Schemadt = objSlaesActivitiesBL.GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "6", "N");
            if (Schemadt != null && Schemadt.Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "Id";
                CmbScheme.DataSource = Schemadt;
                CmbScheme.DataBind();
            }
        }
        public void FillContraGrid()
        {
            DataSet dsdata = Get_ContraData();
            if (dsdata != null && dsdata.Tables.Count > 0)
            {
                Grid_ContraVoucher.DataSource = dsdata.Tables[0];
                Grid_ContraVoucher.DataBind();               
            }
            else
            {
                Grid_ContraVoucher.DataSource = null;
                Grid_ContraVoucher.DataBind();              
            }
        } 
        public DataSet Get_ContraData()
        {           
            ViewState["WhichSegment"] = "1";
            string BranchID = Convert.ToString(cmbBranchfilter.Value);
            string FromDate = Convert.ToDateTime(FormDate.Value).ToString("yyyy-MM-dd");
            string ToDate =Convert.ToDateTime(toDate.Value).ToString("yyyy-MM-dd");

            string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
            string finyear = Convert.ToString(Session["LastFinYear"]);

            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Prc_Search_ContraVoucher");
            proc.AddVarcharPara("@Action", 100, "ContraVoucherList");
            proc.AddVarcharPara("@FinYear", 500, finyear);
            proc.AddVarcharPara("@CompanyID", 500, lastCompany);         
            proc.AddVarcharPara("@BranchList", 4000,userbranch);
            proc.AddVarcharPara("@BranchID", 4000, BranchID);
            proc.AddVarcharPara("@FromDate",10, FromDate);
            proc.AddVarcharPara("@ToDate",10, ToDate);
            ds = proc.GetDataSet();
            return ds;
        }
        public DataTable Get_ContraData(string userbranchlist, string lastCompany, string finyear, string BranchID, string FromDate, string ToDate)
        {

            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Prc_Search_ContraVoucher");
            proc.AddVarcharPara("@Action", 100, "ContraVoucherList");
            proc.AddVarcharPara("@FinYear", 500, finyear);
            proc.AddVarcharPara("@CompanyID", 500, lastCompany);
            proc.AddVarcharPara("@BranchList", 4000, userbranchlist);
            proc.AddVarcharPara("@BranchID", 4000, BranchID);
            proc.AddVarcharPara("@FromDate",10, FromDate);
            proc.AddVarcharPara("@ToDate",10, ToDate);
            ds = proc.GetTable();
            return ds;
        }
        public void bindexport(int Filter)
        {            
            Grid_ContraVoucher.Columns[8].Visible = false;
            exporter.GridViewID = "Grid_ContraVoucher";
            string filename = "ContraVoucher";
            exporter.FileName = filename;
            exporter.PageHeader.Left = "Contra Voucher";
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";
            switch (Filter)
            {
                case 1:
                    exporter.WritePdfToResponse();
                    break;
                case 2:
                    exporter.WriteXlsToResponse();
                    break;
                case 3:
                    exporter.WriteRtfToResponse();
                    break;
                case 4:
                    exporter.WriteCsvToResponse();
                    break;
            }
        }
        protected void drdExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                if (Session["exportval"] == null)
                {
                    Session["exportval"] = Filter;
                    bindexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    Session["exportval"] = Filter;
                    bindexport(Filter);
                }
            }
        }
        private void BindWithdrawalForm(object source, CallbackEventArgsBase e)
        {
            ASPxComboBox currentCombo = source as ASPxComboBox;
            currentCombo.DataSource = GetMainAccountByBranch(e.Parameter);
            currentCombo.DataBind();
        }
        private void BindDepositInto(object source, CallbackEventArgsBase e)
        {
            ASPxComboBox currentCombo = source as ASPxComboBox;
            currentCombo.DataSource = GetDepositInto(e.Parameter);
            currentCombo.DataBind();
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
                    prefCompCode = dtSchema.Rows[0]["prefix"].ToString();
                    sufxCompCode = dtSchema.Rows[0]["suffix"].ToString();
                    prefLen = Convert.ToInt32(prefCompCode.Length);
                    sufxLen = Convert.ToInt32(sufxCompCode.Length);

                    sqlQuery = "SELECT max(tjv.CashBank_VoucherNumber) FROM Trans_CashBankVouchers tjv WHERE dbo.RegexMatch('";
                    if (prefLen > 0)
                        sqlQuery += "[" + prefCompCode + "]{" + prefLen + "}";
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
                            sqlQuery += "[" + prefCompCode + "]{" + prefLen + "}";
                        else if (scheme_type == 2)
                            sqlQuery += "^";
                        sqlQuery += "[0-9]{" + (paddCounter - 1) + "}";
                        if (sufxLen > 0)
                            sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                       // sqlQuery += "?$', LTRIM(RTRIM(tjv.CashBank_VoucherNumber))) = 1";
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
        protected void btnnew_Click(object sender, EventArgs e)
        {
            if (hdnVoucherNo.Value != null)
            {
                txtVoucherNo.Text = Convert.ToString(hdnVoucherNo.Value).Trim();
            }


            if (hdn_Mode.Value == "EDIT")
            {
                grid.JSProperties["cpModify"] = null;
                Modify();
                grid.JSProperties["cpModify"] = "Modify Successfully";
                setrefreshModify();

                //Response.Redirect("ContraVoucher.aspx");
            }
            else
            {
                string validate = checkNMakeJVCode(Convert.ToString(txtVoucherNo.Text), Convert.ToInt32(CmbScheme.SelectedItem.Value));
                if (validate == "outrange")
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('outrange')</script>");
                    return;
                }
                else if (validate == "duplicate")
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('duplicate')</script>");
                    return;
                }
                else
                {
                    txtVoucherNo.Text = JVNumStr;
                }
                Add();
                SetRefresh();
                hdn_Mode.Value = "";
                hdn_Mode.Value = "";
             
            }


        }
        protected void Add()
        {
            
            string formMode = "Entry";
            string WDrawFrom = hdnWithDrawFrom.Value;           
            string DInto = hdnDepositInto.Value;          
            string Currency = hdnCurrency_ID.Value;            
            if (Currency == "" || Currency == "0")
            {
                string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
                string[] basedCurrency = LocalCurrency.Split('~');
                Currency = basedCurrency[0];
            }
            string rate = hdnRate.Value;
            if (rate == "")
            {
                rate = "0.0";
            }
            string amount = hdnAmount.Value;
            if (amount == "")
            {
                amount = "0.0";
            }
            string AmountInHomeCurrency = hdnAmountInHomeCurrency.Value;
            string Remarks = hdnRemarks.Value;

            string OldIBRef = string.Empty;
            OldIBRef = Session["IBRef"] != null ? Session["IBRef"].ToString() : String.Empty;
            string ExchangeSegmentID = string.Empty;
            ExchangeSegmentID = hdn_CurrentSegment.Value;

            DataSet dsInst = new DataSet();
            SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            SqlCommand cmd = new SqlCommand("prc_ContraVoucher", con);
            cmd.CommandType = CommandType.StoredProcedure;

  
            Int32 Branch;
            if (ddlBranch.SelectedValue != "")
            {
              
                Branch = Convert.ToInt32(hddn_BranchID.Value);
            }
            else
            {
                Branch = 0;
            }           
            cmd.Parameters.AddWithValue("@FormMode", formMode);
            cmd.Parameters.AddWithValue("@VoucherNumber", txtVoucherNo.Text.Trim());
            cmd.Parameters.AddWithValue("@CreateUser", Session["userid"].ToString());
            cmd.Parameters.AddWithValue("@FinYear", Session["LastFinYear"].ToString());
            string com = HttpContext.Current.Session["LastCompany"].ToString();
            cmd.Parameters.AddWithValue("@CompanyID", HttpContext.Current.Session["LastCompany"].ToString());
            cmd.Parameters.AddWithValue("@TransactionDate", tDate.Date);
            cmd.Parameters.AddWithValue("@ExchangeSegmentID", ExchangeSegmentID);
            cmd.Parameters.AddWithValue("@TransactionType", 'C');
            cmd.Parameters.AddWithValue("@EntryUserProfile", Session["EntryProfileType"].ToString());
            cmd.Parameters.AddWithValue("@Narration", txtNarration.Text.Trim());

            cmd.Parameters.AddWithValue("@BranchID", Branch);
            string BranchTo=ddlBranchTo.SelectedValue;
            if (hdnBranchIdTo.Value=="")
            {
                hdnBranchIdTo.Value = BranchTo;
            }
          
            cmd.Parameters.AddWithValue("@BranchIDTo", Convert.ToInt32(hdnBranchIdTo.Value));

            cmd.Parameters.AddWithValue("@WithDrawFrom", WDrawFrom);
            cmd.Parameters.AddWithValue("@DepositInto", DInto);
            cmd.Parameters.AddWithValue("@AmountInHomeCurrency", Convert.ToDecimal(AmountInHomeCurrency));
            cmd.Parameters.AddWithValue("@CurrencyID", Convert.ToInt32(Currency));
            cmd.Parameters.AddWithValue("@InstrumentType", ComboInstType.SelectedItem.Value);
            cmd.Parameters.AddWithValue("@InstrumentNumber", txtInstNo.Text.Trim());
            cmd.Parameters.AddWithValue("@InstrumentDate", InstDate.Date);
            cmd.Parameters.AddWithValue("@Remarks", Remarks);
            //cmd.Parameters.AddWithValue("@CaskBank_NumberingScheme", Convert.ToInt32(CmbScheme.SelectedItem.Value));
            cmd.Parameters.AddWithValue("@CaskBank_NumberingScheme", Convert.ToInt32(CmbScheme.SelectedItem.Value));
            cmd.Parameters.AddWithValue("@CashBankDetail_Rate", Convert.ToDecimal(rate));
            cmd.Parameters.AddWithValue("@CashBankDetail_Amount", Convert.ToDecimal(amount));

            cmd.CommandTimeout = 0;
            SqlDataAdapter Adap = new SqlDataAdapter();
            Adap.SelectCommand = cmd;
            Adap.Fill(dsInst);
            cmd.Dispose();
            con.Dispose();
            grid.JSProperties["cprtnVoucherNo"] = "Voucher No. Generated- " + txtVoucherNo.Text.Trim();
            txtVoucherNo.Text = "";
            txtInstNo.Text = "";
            txtNarration.Text = "";
           
        }
        protected void Modify()
        {
            string formMode = "EDIT";
            string WDrawFrom = hdnWithDrawFrom.Value;
            string DInto = hdnDepositInto.Value;
            string Currency;
        
            if (hdnCurrency_ID.Value != "0")
            {
                Currency = hdnCurrency_ID.Value;
            }
            else
            {
                Currency = hdnDbSaveCurrenct.Value;
            }
            string rate = hdnRate.Value;
            if (rate == "")
            {
                rate = "0.0";
            }
            string amount = hdnAmount.Value;
            if (amount == "")
            {
                amount = "0.0";
            }
            string AmountInHomeCurrency = hdnAmountInHomeCurrency.Value;
            string Remarks = hdnRemarks.Value;

            string OldIBRef = string.Empty;
            OldIBRef = Session["IBRef"] != null ? Session["IBRef"].ToString() : String.Empty;
            string ExchangeSegmentID = string.Empty;
            ExchangeSegmentID = hdn_CurrentSegment.Value;

            DataSet dsInst = new DataSet();
            SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            SqlCommand cmd = new SqlCommand("prc_ContraVoucherModify", con);
            cmd.CommandType = CommandType.StoredProcedure;

            Int32 Branch;
            if (ddlBranch.SelectedValue != "")
            {
               // Branch = Convert.ToInt32(ddlBranch.SelectedValue);
                Branch = Convert.ToInt32(hddn_BranchID.Value);
            }
            else
            {
                Branch = 0;
            }
       
            cmd.Parameters.AddWithValue("@FormMode", formMode);
            cmd.Parameters.AddWithValue("@CashBank_ID", Convert.ToInt32(hdn_CashBankID.Value));
            cmd.Parameters.AddWithValue("@VoucherNumber", txtVoucherNo.Text.Trim());
            cmd.Parameters.AddWithValue("@CreateUser", Session["userid"].ToString());
            cmd.Parameters.AddWithValue("@FinYear", hdnCashBank_FinYear.Value);
            cmd.Parameters.AddWithValue("@CompanyID", hdnCashBank_CompanyID.Value);
            cmd.Parameters.AddWithValue("@TransactionDate", tDate.Date);
            cmd.Parameters.AddWithValue("@ExchangeSegmentID", hdnCashBank_ExchangeSegmentID.Value);
            cmd.Parameters.AddWithValue("@TransactionType", 'C');
            cmd.Parameters.AddWithValue("@EntryUserProfile", Session["EntryProfileType"].ToString());
            cmd.Parameters.AddWithValue("@Narration", txtNarration.Text.Trim());
            cmd.Parameters.AddWithValue("@BranchID", Branch);
            cmd.Parameters.AddWithValue("@BranchIDTo", Convert.ToInt32(hdnBranchIdTo.Value));
            cmd.Parameters.AddWithValue("@WithDrawFrom", WDrawFrom);
            cmd.Parameters.AddWithValue("@DepositInto", DInto);
            cmd.Parameters.AddWithValue("@AmountInHomeCurrency", Convert.ToDecimal(AmountInHomeCurrency));
            cmd.Parameters.AddWithValue("@CurrencyID", Convert.ToInt32(Currency));
            cmd.Parameters.AddWithValue("@InstrumentType", ComboInstType.SelectedItem.Value);
            cmd.Parameters.AddWithValue("@InstrumentNumber", txtInstNo.Text.Trim());
            cmd.Parameters.AddWithValue("@InstrumentDate", InstDate.Date);
            cmd.Parameters.AddWithValue("@Remarks", Remarks);
            // cmd.Parameters.AddWithValue("@CaskBank_NumberingScheme", CmbScheme.SelectedItem.Value);
            cmd.Parameters.AddWithValue("@CashBank_IBRef", hdnCashBank_IBRef.Value);
            cmd.Parameters.AddWithValue("@CashBankDetail_Rate", Convert.ToDecimal(rate));
            cmd.Parameters.AddWithValue("@CashBankDetail_Amount", Convert.ToDecimal(amount));
            cmd.CommandTimeout = 0;
            SqlDataAdapter Adap = new SqlDataAdapter();
            Adap.SelectCommand = cmd;
            Adap.Fill(dsInst);
            cmd.Dispose();
            con.Dispose();
        }
        protected void btnexit_Click(object sender, EventArgs e)
        {
            if (hdn_Mode.Value == "EDIT")
            {
                Modify();
                Response.Redirect("ContraVoucher.aspx");
            }
            else
            {
                string validate = checkNMakeJVCode(Convert.ToString(txtVoucherNo.Text), Convert.ToInt32(CmbScheme.SelectedItem.Value));
                if (validate == "outrange")
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('outrange')</script>");
                    return;
                }
                else if (validate == "duplicate")
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('duplicate')</script>");
                    return;
                }
                else
                {
                    txtVoucherNo.Text = JVNumStr;
                }
                Add();
                Response.Redirect("ContraVoucher.aspx");
                //Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>OnAddButtonClick()</script>");
            }
            hdn_Mode.Value = "";
        }
        public void SetRefresh()
        {
            int scheme_type = 0;

            DataTable dtSchema = oDBEngine.GetDataTable("tbl_master_idschema", "prefix, suffix, digit, startno, schema_type", "id=" + Convert.ToInt32(CmbScheme.SelectedItem.Value));
            scheme_type = Convert.ToInt32(dtSchema.Rows[0]["schema_type"]);


            if (scheme_type == 1)
            {

            }
            else
            {
                CmbScheme.SelectedIndex = 0;
                txtVoucherNo.Text = "";
            }


            ddlBranch.SelectedValue = Convert.ToString(hddn_BranchID.Value);
            ComboInstType.SelectedIndex = 0;
            txtInstNo.Text = "";
            txtNarration.Text = "";

            grid.DataSource = null;
            grid.DataBind();

            Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>AddNewRowGrid()</script>");
        }
        public void setrefreshModify()
        {
            CmbScheme.SelectedIndex = 0;
            txtVoucherNo.Text = "";


            ddlBranch.SelectedIndex = -1;
            ComboInstType.SelectedIndex = -1;
            txtInstNo.Text = "";
            txtNarration.Text = "";

            grid.DataSource = null;
            grid.DataBind();
            Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>AddNewRowGridModify()</script>");

        }
        protected void btnSaveExit_Click(object sender, EventArgs e)
        {
            if (hdnVoucherNo.Value != null)
            {
                txtVoucherNo.Text = Convert.ToString(hdnVoucherNo.Value).Trim();
            }

            if (hdn_Mode.Value == "EDIT")
            {
                Modify();
                Response.Redirect("ContraVoucher.aspx");
            }
            else
            {
                string validate = checkNMakeJVCode(Convert.ToString(txtVoucherNo.Text), Convert.ToInt32(CmbScheme.SelectedItem.Value));
                if (validate == "outrange")
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('outrange')</script>");
                    return;
                }
                else if (validate == "duplicate")
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('duplicate')</script>");
                    return;
                }
                else
                {
                    txtVoucherNo.Text = JVNumStr;
                }
                string finalVNo = txtVoucherNo.Text;
                Add();
                TblSearch.Attributes.Add("style", "display:none");
                divAddNew.Attributes.Add("style", "display:block");
                btncross.Attributes.Add("style", "display:block");
              //  ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "jAlert('Contra Voucher No. " + finalVNo + " generated.');window.location='ContraVoucher.aspx';", true);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "jAlert('Contra Voucher No. " + finalVNo + " generated.', 'Alert Dialog: [ContraVoucher]', function (r) {if (r == true) {  window.location.assign('ContraVoucher.aspx');} });", true);
           
            }           
        }

        #endregion Others

        #region  Main Grid Related

        //protected void Grid_ContraVoucher_DataBinding(object sender, EventArgs e)
        //{            
        //    DataTable dsdata = (DataTable)Session["ContraListingDetails"];
        //    Grid_ContraVoucher.DataSource = dsdata;
        //}
        protected void Grid_ContraVoucher_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            Grid_ContraVoucher.JSProperties["cpCBDelete"] = null;
            string[] command = e.Parameters.ToString().Split('~');
            if (command[0] == "Delete")
            {
                int RowUpdated = 0;
                Int32 RowIndex = Convert.ToInt32(e.Parameters.Split('~')[1]);
                string IBRef = e.Parameters.Split('~')[2];
              
                string strLogID = ViewState["LogID"].ToString();               
                try
                {

                    RowUpdated = oFinancialAccounting.DeleteCB(IBRef);
                    if (RowUpdated > 0)
                    {
                        Grid_ContraVoucher.JSProperties["cpCBDelete"] = "Successfully Deleted";
                        string BranchID = Convert.ToString(cmbBranchfilter.Value);
                        string FromDate = Convert.ToDateTime(FormDate.Value).ToString("yyyy-MM-dd");
                        string ToDate = Convert.ToDateTime(toDate.Value).ToString("yyyy-MM-dd");

                        string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                        string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                        string finyear = Convert.ToString(Session["LastFinYear"]);

                        //DataTable dtdata = new DataTable();
                        //Session["ContraListingDetails"] = Get_ContraData(userbranch, lastCompany, finyear, BranchID, FromDate, ToDate);
                        //Grid_ContraVoucher.DataBind();

                        oGenericLogSystem.CreateLog("Trans_CashBankVouchers", "CashBank_IBRef='" + IBRef + "'", BusinessLogicLayer.GenericLogSystem.LogState.XmlDeleted, Session["UserID"].ToString(), IBRef, "Trans_CashBankVouchers", strLogID, BusinessLogicLayer.GenericLogSystem.LogType.CB);
                        oGenericLogSystem.CreateLog("Trans_CashBankDetail", "CashBankDetail_IBRef='" + IBRef + "'", BusinessLogicLayer.GenericLogSystem.LogState.XmlDeleted, Session["UserID"].ToString(), IBRef, "Trans_CashBankDetail", strLogID, BusinessLogicLayer.GenericLogSystem.LogType.CB);
                    }
                    else
                    {
                        
                    }
                }
                catch
                {   
                    oGenericLogSystem.CreateLog("", "", BusinessLogicLayer.GenericLogSystem.LogState.XmlError, Session["UserID"].ToString(), IBRef, "Trans_CashBankVouchers", strLogID, BusinessLogicLayer.GenericLogSystem.LogType.CB);
                    oGenericLogSystem.CreateLog("", "", BusinessLogicLayer.GenericLogSystem.LogState.XmlError, Session["UserID"].ToString(), IBRef, "Trans_CashBankDetail", strLogID, BusinessLogicLayer.GenericLogSystem.LogType.CB);
                }              
            }
            else if (command[0] == "FilterGridByDate")
            {
                string FromDate = Convert.ToString(e.Parameters.Split('~')[1]);
                string ToDate = Convert.ToString(e.Parameters.Split('~')[2]);
                string BranchID = Convert.ToString(e.Parameters.Split('~')[3]);

                string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                string finyear = Convert.ToString(Session["LastFinYear"]);

                DataTable dtdata = new DataTable();
                Session["ContraListingDetails"] = Get_ContraData(userbranch, lastCompany, finyear, BranchID, FromDate, ToDate);
                Grid_ContraVoucher.DataBind();
               
            }

           
        }
        protected void Grid_ContraVoucher_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e)
        {
            e.Properties["cpHeight"] = "All";
        }

        #endregion

        #region  Batch Grid Related
        protected void grid_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "WithDrawFrom")
            {
                ((ASPxComboBox)e.Editor).Callback += new CallbackEventHandlerBase(BindWithdrawalForm);
            }
            if (e.Column.FieldName == "DepositInto")
            {
                ((ASPxComboBox)e.Editor).Callback += new CallbackEventHandlerBase(BindWithdrawalForm);
            }
            e.Editor.ReadOnly = false;
        }
        protected void grid_InitNewRow(object sender, ASPxDataInitNewRowEventArgs e)
        {
            string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
            string basedCurrency = Convert.ToString(LocalCurrency.Split('~')[0]);
            string CurrencyId = Convert.ToString(basedCurrency[0]);
            e.NewValues["Currency_ID"] = CurrencyId;
           
        }
        protected void grid_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e)
        {
            e.Properties["cpHeight"] = "All";
        }
        public DataTable GetBatchGridEditData(string contraid)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Prc_Search_ContraVoucher");
            proc.AddVarcharPara("@Action", 500, "BatchGridEditList");
            proc.AddIntegerPara("@Contra_ID", Convert.ToInt32(contraid));
            dt = proc.GetTable();
            return dt;
        }
        protected void grid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            grid.JSProperties["cpEdit"] = "";
            string[] CallVal = e.Parameters.ToString().Split('~');
            lengthIndex = e.Parameters.Split('~');
            if (lengthIndex[0].ToString() == "BEFORE_EDIT")
            {
                hdn_Mode.Value = "";
                hdn_Mode.Value = "Edit";
                string contraid = lengthIndex[1].ToString();
                DataTable DT = new DataTable();
                DT.Rows.Clear();
                //string strQuery = "Select Convert(nvarchar(10),CashBank_TransactionDate,120) as CashBank_TransactionDate,CashBank_VoucherNumber,CashBank_Narration," +                  
                //    "(Select IsNull(Sum(CashBankDetail_PaymentAmount),0) from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID)as CashBankDetail_PaymentAmount," +
                //    "(SELECT RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where branch_id=tc.CashBank_BranchID)as CashBank_Name,CashBank_BranchID,CashBank_BranchIDTO," +
                //    "CashBank_Currency,"+
                //    "(Select  CashBankDetail_MainAccountID from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID and CashBankDetail_PaymentAmount>0) as WithDrawFrom," +
                //    "(Select CashBankDetail_MainAccountID from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID and CashBankDetail_ReceiptAmount>0) as DepositInto" +                
                //    ", (select top 1 CashBankDetail_InstrumentType from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID)as CashBankDetail_InstrumentType" +
                //    ",(select top 1 CashBankDetail_InstrumentNumber from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID) as CashBankDetail_InstrumentNumber" +
                //    ",(select top 1 Convert(Date,CashBankDetail_InstrumentDate) from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID)as CashBankDetail_InstrumentDate" +
                //    ",(select top 1 CashBankDetail_Narration from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID)as Remarks,CashBank_IBRef,CashBank_FinYear" +
                //    ",CashBank_CompanyID,CashBank_ExchangeSegmentID" +
                //    ",CaskBank_NumberingScheme,(select top 1 CashBankDetail_Rate from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID) as Rate," +
                //    " (select top 1 CashBankDetail_Amount from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID) as Amount" +
                //    " from Trans_CashBankVouchers tc  where CashBank_ID=" + contraid;                            

                //BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine();
                //DT = oDbEngine.GetDataTable(strQuery);
                DT = GetBatchGridEditData(contraid);
                string CashBank_TransactionDate = Convert.ToString(DT.Rows[0]["CashBank_TransactionDate"]);
                string CashBank_VoucherNumber = Convert.ToString(DT.Rows[0]["CashBank_VoucherNumber"]).Trim();
                string CashBank_Narration = Convert.ToString(DT.Rows[0]["CashBank_Narration"]);
                string CashBankDetail_PaymentAmount = Convert.ToString(DT.Rows[0]["CashBankDetail_PaymentAmount"]);
                string CashBank_BranchID = Convert.ToString(DT.Rows[0]["CashBank_BranchID"]);
                string CashBank_Currency = Convert.ToString(DT.Rows[0]["CashBank_Currency"]);//5
                string CashBankDetail_InstrumentType = Convert.ToString(DT.Rows[0]["CashBankDetail_InstrumentType"]);//6
                string CashBankDetail_InstrumentNumber = Convert.ToString(DT.Rows[0]["CashBankDetail_InstrumentNumber"]);//7
                string CashBankDetail_InstrumentDate = Convert.ToString(DT.Rows[0]["CashBankDetail_InstrumentDate"]);//9                
                string Remarks = Convert.ToString(DT.Rows[0]["Remarks"]);//8

                string CashBank_IBRef = Convert.ToString(DT.Rows[0]["CashBank_IBRef"]);//10
                string CashBank_FinYear = Convert.ToString(DT.Rows[0]["CashBank_FinYear"]);//11
                string CashBank_CompanyID = Convert.ToString(DT.Rows[0]["CashBank_CompanyID"]);//12
                string CashBank_ExchangeSegmentID = Convert.ToString(DT.Rows[0]["CashBank_ExchangeSegmentID"]);//13
                string CaskBank_NumberingScheme = Convert.ToString(DT.Rows[0]["CaskBank_NumberingScheme"]);//14
                string Rate = Convert.ToString(DT.Rows[0]["Rate"]);//15
                string Amount = Convert.ToString(DT.Rows[0]["Amount"]);//16   
                string CashBank_BranchIDTO = Convert.ToString(DT.Rows[0]["CashBank_BranchIDTO"]);//17
                grid.JSProperties["cpEdit"] = CashBank_TransactionDate + "~" + CashBank_VoucherNumber + "~" + CashBank_Narration + "~" +
                  CashBankDetail_PaymentAmount + "~" + CashBank_BranchID + "~" + CashBank_Currency + "~" + CashBankDetail_InstrumentType +
                  "~" + CashBankDetail_InstrumentNumber.Trim() + "~" + Remarks + "~" + CashBankDetail_InstrumentDate + "~" + CashBank_IBRef + "~" + CashBank_FinYear + "~"
                  + CashBank_CompanyID + "~" + CashBank_ExchangeSegmentID + "~" + CaskBank_NumberingScheme + "~" + Rate + "~" + Amount + "~" + CashBank_BranchIDTO;

                string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
                string[] basedCurrency = LocalCurrency.Split('~');
                List<VOUCHERLIST> VoucherList = new List<VOUCHERLIST>();
                hdnDbSaveCurrenct.Value = "";
                foreach (DataRow dr in DT.Rows)
                {
                    VOUCHERLIST Vouchers = new VOUCHERLIST();
                    Vouchers.WithDrawFrom = Convert.ToString(dr["WithDrawFrom"]);
                    Vouchers.DepositInto = Convert.ToString(dr["DepositInto"]);
                    Vouchers.Currency_ID = Convert.ToString(dr["CashBank_Currency"]);                

                    Vouchers.CashBankDetail_PaymentAmount = Convert.ToString(dr["CashBankDetail_PaymentAmount"]);
                    Vouchers.Remarks = Convert.ToString(dr["Remarks"]);
                    Vouchers.Rate = Convert.ToString(dr["Rate"]);
                    Vouchers.Amount = Convert.ToString(dr["Amount"]);
                    VoucherList.Add(Vouchers);
                }
                grid.DataSource = VoucherList;
                grid.DataBind();

            }
        }
        #endregion

        #region Classes & DataSource

        public class VOUCHERLIST
        {
            public string WithDrawFrom { get; set; }
            public string DepositInto { get; set; }
            public string Currency_ID { get; set; }
            public string CashBankDetail_PaymentAmount { get; set; }
            public string Remarks { get; set; }
            public string Rate { get; set; }
            public string Amount { get; set; }

        }
        public class WithDrawFrom
        {
            public string AccountCode { get; set; }
            public string IntegrateMainAccount { get; set; }
        }
        public class Currency
        {
            public string Currency_ID { get; set; }
            public string Currency_AlphaCode { get; set; }
        }
        public IEnumerable GetMainAccount()
        {
            List<WithDrawFrom> MainAccountList = new List<WithDrawFrom>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            //string CombinedQuery = "(Select MainAccount_ReferenceID,MainAccount_AccountCode,MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\'+\' ~ \'+MainAccount_BankCashType as IntegrateMainAccount," +
            string CombinedQuery = "(Select MainAccount_ReferenceID,MainAccount_AccountCode,MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\'+MainAccount_BankCashType as IntegrateMainAccount," +
                                    " cast(MainAccount_ReferenceID as varchar(20))+\'~\'+MainAccount_SubLedgerType+\'~MAINAC~\'+ MainAccount_AccountType+\'~~FROMCALL~\'+MainAccount_AccountCode+\'~\'+MainAccount_BankCashType as AccountCode," +
                                    " MainAccount_Name,MainAccount_BankAcNumber,MainAccount_AccountCode from Master_MainAccount" +
                                    " where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\')" +
                                    " and (MainAccount_BankCompany=\'" + Convert.ToString(Session["LastCompany"]) + "\' OR Isnull(MainAccount_BankCompany,'')='')" +
                                    " and (MainAccount_branchId=\'" + Convert.ToString(Session["userbranchID"]) + "\' Or IsNull(MainAccount_branchId,'')='0') )";

            string[] param = CombinedQuery.Replace("--", "+").Replace("^^", "%").Split('$');
            string strQuery_Table = param[0].Trim() != String.Empty ? param[0] : null;

            DataTable DT = objEngine.GetDataTable(strQuery_Table);
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                WithDrawFrom WithDrawFroms = new WithDrawFrom();
                WithDrawFroms.AccountCode = Convert.ToString(DT.Rows[i]["MainAccount_AccountCode"]);
                WithDrawFroms.IntegrateMainAccount = Convert.ToString(DT.Rows[i]["IntegrateMainAccount"]);
                MainAccountList.Add(WithDrawFroms);
            }

            return MainAccountList;
        }
        public IEnumerable GetDepositInto(string branchId)
        {
            List<WithDrawFrom> MainAccountList = new List<WithDrawFrom>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            //string CombinedQuery = "(Select MainAccount_ReferenceID,MainAccount_AccountCode,MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\'+\' ~ \'+MainAccount_BankCashType as IntegrateMainAccount," +
            string CombinedQuery = "(Select MainAccount_ReferenceID,MainAccount_AccountCode,MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\'+MainAccount_BankCashType as IntegrateMainAccount," +
                                    " cast(MainAccount_ReferenceID as varchar(20))+\'~\'+MainAccount_SubLedgerType+\'~MAINAC~\'+ MainAccount_AccountType+\'~~FROMCALL~\'+MainAccount_AccountCode+\'~\'+MainAccount_BankCashType as AccountCode," +
                                    " MainAccount_Name,MainAccount_BankAcNumber,MainAccount_AccountCode from Master_MainAccount" +
                                    " where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\')" +
                                    " and (MainAccount_BankCompany=\'" + Convert.ToString(Session["LastCompany"]) + "\' OR Isnull(MainAccount_BankCompany,'')='')" +
                                    " and (MainAccount_branchId=\'" + branchId + "\' Or IsNull(MainAccount_branchId,'')='0') )";

            string[] param = CombinedQuery.Replace("--", "+").Replace("^^", "%").Split('$');
            string strQuery_Table = param[0].Trim() != String.Empty ? param[0] : null;

            DataTable DT = objEngine.GetDataTable(strQuery_Table);
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                WithDrawFrom WithDrawFroms = new WithDrawFrom();
                WithDrawFroms.AccountCode = Convert.ToString(DT.Rows[i]["MainAccount_AccountCode"]);
                WithDrawFroms.IntegrateMainAccount = Convert.ToString(DT.Rows[i]["IntegrateMainAccount"]);
                MainAccountList.Add(WithDrawFroms);
            }

            return MainAccountList;
        }
        public IEnumerable GetMainAccountByBranch(string branchId)
        {
            List<WithDrawFrom> MainAccountList = new List<WithDrawFrom>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            //string CombinedQuery = "(Select MainAccount_ReferenceID,MainAccount_AccountCode,MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\'+\' ~ \'+MainAccount_BankCashType as IntegrateMainAccount," +
            //                        " cast(MainAccount_ReferenceID as varchar(20))+\'~\'+MainAccount_SubLedgerType+\'~MAINAC~\'+ MainAccount_AccountType+\'~~FROMCALL~\'+MainAccount_AccountCode+\'~\'+MainAccount_BankCashType as AccountCode," +
            //                        " MainAccount_Name,MainAccount_BankAcNumber,MainAccount_AccountCode from Master_MainAccount" +
            //                         " where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\')" +
            //                        " and (MainAccount_BankCompany=\'" + Convert.ToString(Session["LastCompany"]) + "\' OR Isnull(MainAccount_BankCompany,'')='')" +
            //                        " and (MainAccount_branchId=\'" + branchId + "\' Or IsNull(MainAccount_branchId,'')='0') )";
            string CombinedQuery = "(Select MainAccount_ReferenceID,MainAccount_AccountCode,MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\'+MainAccount_BankCashType as IntegrateMainAccount," +
                                    " cast(MainAccount_ReferenceID as varchar(20))+\'~\'+MainAccount_SubLedgerType+\'~MAINAC~\'+ MainAccount_AccountType+\'~~FROMCALL~\'+MainAccount_AccountCode+\'~\'+MainAccount_BankCashType as AccountCode," +
                                    " MainAccount_Name,MainAccount_BankAcNumber,MainAccount_AccountCode from Master_MainAccount" +
                                     " where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\')" +
                                    " and (MainAccount_BankCompany=\'" + Convert.ToString(Session["LastCompany"]) + "\' OR Isnull(MainAccount_BankCompany,'')='')" +
                                    " and (MainAccount_branchId=\'" + branchId + "\' Or IsNull(MainAccount_branchId,'')='0') )";
            string[] param = CombinedQuery.Replace("--", "+").Replace("^^", "%").Split('$');
            string strQuery_Table = param[0].Trim() != String.Empty ? param[0] : null;

            DataTable DT = objEngine.GetDataTable(strQuery_Table);
            DataTable restrictedDT = objEngine.GetDataTable("select branch_id,MainAccount_id from tbl_master_ledgerBranch_map");

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                DataRow[] restrictedTablerow = restrictedDT.Select("MainAccount_id=" + Convert.ToString(DT.Rows[i]["MainAccount_ReferenceID"]));

                if (restrictedTablerow.Length > 0)
                {
                    DataTable restrictedTable = restrictedTablerow.CopyToDataTable();
                    DataRow[] restrictedRow = restrictedTable.Select("branch_id=" + branchId);
                    if (restrictedRow.Length > 0)
                    {
                        WithDrawFrom WithDrawFroms = new WithDrawFrom();
                        WithDrawFroms.AccountCode = Convert.ToString(DT.Rows[i]["MainAccount_AccountCode"]);
                        WithDrawFroms.IntegrateMainAccount = Convert.ToString(DT.Rows[i]["IntegrateMainAccount"]);
                        MainAccountList.Add(WithDrawFroms);
                    }


                }
                else
                {
                    WithDrawFrom WithDrawFroms = new WithDrawFrom();
                    WithDrawFroms.AccountCode = Convert.ToString(DT.Rows[i]["MainAccount_AccountCode"]);
                    WithDrawFroms.IntegrateMainAccount = Convert.ToString(DT.Rows[i]["IntegrateMainAccount"]);
                    MainAccountList.Add(WithDrawFroms);
                }

            }

            return MainAccountList;
        }

        public IEnumerable GetCurrency()
        {
            string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
            string[] basedCurrency = LocalCurrency.Split('~');
            List<Currency> CurrencyList = new List<Currency>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string CombinedQuery = "select Currency_ID,Currency_AlphaCode from Master_Currency ";

          
            DataTable DT = objEngine.GetDataTable(CombinedQuery);
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                Currency Currencys = new Currency();
                Currencys.Currency_ID = Convert.ToString(DT.Rows[i]["Currency_ID"]);
                Currencys.Currency_AlphaCode = Convert.ToString(DT.Rows[i]["Currency_AlphaCode"]);

                CurrencyList.Add(Currencys);
            }

            return CurrencyList;
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            ((GridViewDataComboBoxColumn)grid.Columns["WithDrawFrom"]).PropertiesComboBox.DataSource = GetMainAccount();
            ((GridViewDataComboBoxColumn)grid.Columns["DepositInto"]).PropertiesComboBox.DataSource = GetMainAccount();
            //   ((GridViewDataComboBoxColumn)grid.Columns["Currency_ID"]).PropertiesComboBox.DataSource = GetCurrency();
            GridViewDataComboBoxColumn combo = ((GridViewDataComboBoxColumn)grid.Columns["Currency_ID"]);
            combo.PropertiesComboBox.DataSource = GetCurrency();

            //if (!IsPostBack)
            //    grid.DataBind();
        }
        public IEnumerable GetVoucher()
        {
            List<VOUCHERLIST> VoucherList = new List<VOUCHERLIST>();
            DataTable DT = new DataTable();
            DT.Rows.Clear();
            //string strQuery = "Select (select Currency_AlphaCode from Master_Currency where Currency_ID=tc.CashBank_Currency)as CashBank_Currency"+
            //"from Trans_CashBankVouchers tc  where CashBank_ID="+;
            return VoucherList;
        }

        #endregion

        #region WebMethod
        [WebMethod]
        public static string getSchemeType(string sel_scheme_id)
        {
            //BusinessLogicLayer.DBEngine oDbEngine1 = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            //string[] scheme = oDbEngine1.GetFieldValue1("tbl_master_Idschema", "schema_type", "Id = " + Convert.ToString(sel_scheme_id), 1);
            //return Convert.ToString(scheme[0]);
            string strschematype = "", strschemalength = "", strschemavalue = "", strschemaBranch="";
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
                status = objMShortNameCheckingBL.CheckUnique(VoucherNo, "0", "ContraVoucher_Check");
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
        public void BindBranchFrom()
        {
            dsBranch.SelectCommand = "select '0' AS BANKBRANCH_ID,'Select'  AS BANKBRANCH_NAME "+
            " Union  SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where BRANCH_id in(" + Convert.ToString(Session["userbranchHierarchy"]) + ")";
            ddlBranch.DataBind();
            ddlBranchTo.DataBind();
        }

        [WebMethod]
        public static string GetCurrentBankBalance(string MainAccountID,string Branch)
        {
            BusinessLogicLayer.Converter oConverter = new BusinessLogicLayer.Converter();
            string MainAccountValID = string.Empty;
            string strColor = string.Empty;
            DataTable DT = new DataTable();
            DBEngine objEngine = new DBEngine();

            DT = objEngine.GetDataTable("Select Sum(AccountsLedger_AmountDr-AccountsLedger_AmountCr) TotalAmount from Trans_AccountsLedger WHERE AccountsLedger_MainAccountID='" + MainAccountID + "' and AccountsLedger_BranchId=" + Branch);
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
        #endregion

        protected void EntityServerModeDataSource_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.KeyExpression = "CashBank_ID";

            string connectionString = ConfigurationManager.ConnectionStrings["crmConnectionString"].ConnectionString;
            string IsFilter = Convert.ToString(hfIsFilter.Value);
            string strFromDate = Convert.ToString(hfFromDate.Value);
            string strToDate = Convert.ToString(hfToDate.Value);
            string strBranchID = (Convert.ToString(hfBranchID.Value) == "") ? "0" : Convert.ToString(hfBranchID.Value);

            List<int> branchidlist;

            if (IsFilter == "Y")
            {
                if (strBranchID == "0")
                {
                    string BranchList = Convert.ToString(Session["userbranchHierarchy"]);
                    branchidlist = new List<int>(Array.ConvertAll(BranchList.Split(','), int.Parse));

                    ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                    var q = from d in dc.v_ContraVoucherLists
                            where d.CashBank_TransactionDate >= Convert.ToDateTime(strFromDate) && d.CashBank_TransactionDate <= Convert.ToDateTime(strToDate)
                            && branchidlist.Contains(Convert.ToInt32(d.CashBank_BranchID))
                            orderby d.CashBank_TransactionDate descending
                            select d;
                    e.QueryableSource = q;
                }
                else
                {
                    branchidlist = new List<int>(Array.ConvertAll(strBranchID.Split(','), int.Parse));

                    ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                    var q = from d in dc.v_ContraVoucherLists
                            where
                            d.CashBank_TransactionDate >= Convert.ToDateTime(strFromDate) && d.CashBank_TransactionDate <= Convert.ToDateTime(strToDate) &&
                            branchidlist.Contains(Convert.ToInt32(d.CashBank_BranchID))
                            orderby d.CashBank_TransactionDate descending
                            select d;
                    e.QueryableSource = q;
                }
            }
            else
            {
                ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                var q = from d in dc.v_ContraVoucherLists
                        where d.CashBank_BranchID == '0'
                        orderby d.CashBank_TransactionDate descending
                        select d;
                e.QueryableSource = q;
            }
        }
    }
}