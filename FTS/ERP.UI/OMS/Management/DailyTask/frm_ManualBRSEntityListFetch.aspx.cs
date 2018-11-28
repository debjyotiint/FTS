﻿using BusinessLogicLayer;
using DataAccessLayer;
using DevExpress.Web;
using EntityLayer.CommonELS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using DevExpress.XtraPrinting;
using DevExpress.Export;
using ERP.Models;

namespace ERP.OMS.Management.DailyTask
{
    public partial class frm_ManualBRSEntityListFetch : System.Web.UI.Page
    {
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        CRMSalesOrderDtlBL objCRMSalesOrderDtlBL = new CRMSalesOrderDtlBL();
        SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        string IsFirstTimeLoad = string.Empty;
        string CheckStatus = "";
        FinancialAccounting oFinancialAccounting = new FinancialAccounting();
        protected void Page_Load(object sender, EventArgs e)
        {
            IsFirstTimeLoad = "N";
            DateTime dtFrom;
            //if (RdCleared.Checked == true)
            //{
            //    dt_BankValueDate.Text = "";
            //}

            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/dailytask/frm_ManualBRSEntityListFetch.aspx");
            if (!IsPostBack)
            {

                Session["exportval"] = null;
                //Session["CustomerDeliveryPendingdt"] = null;
                string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                PopulateBranchByHierchy(lastCompany);
                FormDate.Date = DateTime.Now;
                toDate.Date = DateTime.Now;
                //FillGrid();
                //FillGridOnLoad();
                IsFirstTimeLoad = "Y";


                //dtFrom = DateTime.Now;
                //dt_BankValueDate.Text = dtFrom.ToString("dd-MM-yyyy");

                GetFinacialYearBasedQouteDate();

            }

            Page.ClientScript.RegisterStartupScript(GetType(), "PageLoadCalling", "<script language='Javascript'>Page_Laod();</script>");

            //if (IsFirstTimeLoad=="Y")
            //{
            //    FillGrid();
            //    IsFirstTimeLoad = "N";
            //}

            if (Request.QueryString["type"] != null)
            {
                if (Convert.ToString(Request.QueryString["type"]) == "SD")
                {
                    lblHeadertext.Text = "Customer Delivery - SD";
                }

            }
            else
            {
                lblHeadertext.Text = "Manual BRS";
            }
        }


        public void GetFinacialYearBasedQouteDate()
        {
            String finyear = "";
            if (Session["LastFinYear"] != null)
            {
                finyear = Convert.ToString(Session["LastFinYear"]).Trim();
                DataTable dtFinYear = objSlaesActivitiesBL.GetFinacialYearBasedQouteDate(finyear);
                if (dtFinYear != null && dtFinYear.Rows.Count > 0)
                {
                    Session["FinYearStartDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearStartDate"]);
                    Session["FinYearEndDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearEndDate"]);
                    if (Session["FinYearStartDate"] != null)
                    {
                        dt_BankValueDate.MinDate = Convert.ToDateTime(Convert.ToString(Session["FinYearStartDate"]));
                    }
                    if (Session["FinYearEndDate"] != null)
                    {
                        dt_BankValueDate.MaxDate = Convert.ToDateTime(Convert.ToString(Session["FinYearEndDate"]));
                    }
                }
            }
            //dt_PLQuote.Value = Convert.ToDateTime(oDBEngine.GetDate().ToString());
        }

        private void PopulateBranchByHierchy(string userbranchhierchy)
        {
            PosSalesInvoiceBl posSale = new PosSalesInvoiceBl();
            DataTable branchtable = posSale.getBankForManualBRS(userbranchhierchy);
            cmbBankfilter.DataSource = branchtable;
            cmbBankfilter.ValueField = "MainAccount_AccountCode";
            cmbBankfilter.TextField = "IntegrateMainAccount";
            cmbBankfilter.DataBind();
            cmbBankfilter.SelectedIndex = 0;

            //cmbBankfilter.Value = Convert.ToString(Session["userbranchID"]);
        }

        public void FillGridOnLoadDlvType()
        {
            string DlvType = string.Empty;
            DlvType = Convert.ToString(Request.QueryString["type"]);
            if (!string.IsNullOrEmpty(DlvType))
            {
                hddnTypeIdd.Value = "1";
            }
            else
            {
                hddnTypeIdd.Value = "0";
            }

            DataTable dt = GetConfigSettingForBRS();
            if (dt != null && dt.Rows.Count > 0)
            {
                if (Convert.ToString(dt.Rows[0]["Variable_Value"]).ToUpper() == "YES")
                {
                    hddnBRSConfigSettings.Value = "1";
                }
                else
                {
                    hddnBRSConfigSettings.Value = "0";
                }


            }
        }

        protected void btnShow_Click1(object sender, EventArgs e)
        {
            //BindTable();
            if (grdmanualBRS.VisibleRowCount == 0)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "MessageForBlankRecord", "<script language='JavaScript'>jAlert('No Record Found');</script>");

            }
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "ShowUpdateCancel", "<script language='Javascript'>ShowUpdateCancelButton();</script>");

                //added by sanjib for search if data exist.
                Page.ClientScript.RegisterStartupScript(GetType(), "ForSearchHide1", "<script language='Javascript'>SearchVisible('');</script>");
            }
            //Page.ClientScript.RegisterStartupScript(GetType(), "CallingHeight", "<script language='Javascript'>height();</script>");
            Page.ClientScript.RegisterStartupScript(GetType(), "ForSearchHide1", "<script language='Javascript'>SearchVisible('N');</script>");

        }

        protected DateTime Setstatementdate(object container)
        {
            string FormatedStatementDate = string.Empty;
            GridViewDataItemTemplateContainer c = container as GridViewDataItemTemplateContainer;
            object value = c.Grid.GetRowValues(c.VisibleIndex, "cashbankdetail_bankstatementdate");
            string[] DateFormatStatement = null;
            DateTime dts = new DateTime(); ;
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
            {
                if (Convert.ToString(value).Contains("-"))
                {
                    DateFormatStatement = Convert.ToString(value).Split('-');
                    string MM = DateFormatStatement[1].ToString();
                    string day = DateFormatStatement[0].ToString();
                    string Y = DateFormatStatement[2].ToString();
                    if (DateFormatStatement[0].ToString().Length != 2)
                    {
                        day = "0" + DateFormatStatement[0].ToString();
                    }
                    if (DateFormatStatement[1].ToString().Length != 2)
                    {
                        MM = "0" + DateFormatStatement[1].ToString();
                    }
                    FormatedStatementDate = day.Trim() + "-" + MM.Trim() + "-" + Y.Trim();
                    //string dd = Convert.ToString(value);

                    // DateTime.TryParseExact(dd, "dd/MM/yyyy", enUS, DateTimeStyles.None, out dt);
                    DateTime dt = DateTime.ParseExact(FormatedStatementDate.Trim(), "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture);
                    return dt;
                }
                else if (Convert.ToString(value).Contains("/"))
                {
                    DateFormatStatement = Convert.ToString(value).Split('/');
                    string MM = DateFormatStatement[0].ToString();
                    string day = DateFormatStatement[1].ToString();
                    string Y = DateFormatStatement[2].ToString();
                    if (DateFormatStatement[1].ToString().Length != 2)
                    {
                        day = "0" + DateFormatStatement[1].ToString();
                    }
                    if (DateFormatStatement[0].ToString().Length != 2)
                    {
                        MM = "0" + DateFormatStatement[0].ToString();
                    }
                    FormatedStatementDate = day.Trim() + "-" + MM.Trim() + "-" + Y.Trim().Split(' ')[0];
                    //string dd = Convert.ToString(value);

                    // DateTime.TryParseExact(dd, "dd/MM/yyyy", enUS, DateTimeStyles.None, out dt);
                    DateTime dt = DateTime.ParseExact(FormatedStatementDate.Trim(), "dd-MM-yyyy", System.Globalization.CultureInfo.InvariantCulture);
                    return dt;
                }



            }
            return dts;
        }


        protected DateTime Setbankvaluedate(object container)
        {
            string[] DateFormatStatement;
            string FormatedStatementDate = string.Empty;
            GridViewDataItemTemplateContainer c = container as GridViewDataItemTemplateContainer;
            object value = c.Grid.GetRowValues(c.VisibleIndex, "cashbankdetail_bankvaluedate");
            string[] DateFormatvalue;
            DateTime dts = new DateTime(); ;
            if (value != null && !string.IsNullOrEmpty(Convert.ToString(value)))
            {

                DateFormatStatement = Convert.ToString(value).Split('-');
                string MM = DateFormatStatement[1].ToString();
                string day = DateFormatStatement[0].ToString();
                string Y = DateFormatStatement[2].ToString();
                if (DateFormatStatement[0].ToString().Length != 2)
                {
                    day = "0" + DateFormatStatement[0].ToString();
                }
                if (DateFormatStatement[1].ToString().Length != 2)
                {
                    MM = "0" + DateFormatStatement[1].ToString();
                }
                FormatedStatementDate = day.Trim() + "-" + MM.Trim() + "-" + Y.Trim();
                //string dd = Convert.ToString(value);

                // DateTime.TryParseExact(dd, "dd/MM/yyyy", enUS, DateTimeStyles.None, out dt);
                // DateTime dt = Convert.ToDateTime(FormatedStatementDate.Trim());
                DateTime myDate = DateTime.ParseExact(FormatedStatementDate.Trim(), "dd-MM-yyyy",
                                       System.Globalization.CultureInfo.InvariantCulture);
                return myDate;
            }
            return dts;
        }



        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }




        //[WebMethod]
        //public static string UpdateManualBRS(string VoucherNo)
        //{
        //    CRMSalesOrderDtlBL objCRMSalesOrderDtlBL = new CRMSalesOrderDtlBL();
        //    int CancelBTO = 0;
        //    CancelBTO = objCRMSalesOrderDtlBL.UpdateManualBRS(VoucherNo);


        //    return Convert.ToString(CancelBTO);

        //}


        public void BindTable()
        {
            DataSet DsBind = new DataSet();
            string BankId = Convert.ToString(cmbBankfilter.Value);
            DateTime FromDate = Convert.ToDateTime(Convert.ToDateTime(FormDate.Value).ToString("yyyy-MM-dd"));
            DateTime ToDate = Convert.ToDateTime(Convert.ToDateTime(toDate.Value).ToString("yyyy-MM-dd"));
            if (RdAll.Checked == true)
            {
                CheckStatus = "A";
            }
            else if (RdUnCleared.Checked == true)
            {

                CheckStatus = "U";

            }
            else if (RdCleared.Checked == true)
            {
                CheckStatus = "C";
            }

            //string nn = txtBankName_hidden.Value;
            //string dd = Convert.ToString(DateTo.Value);

            //string def = Convert.ToString(FromDate.Value);


            DsBind = oFinancialAccounting.FetchManualBRSData(ToDate.ToString("yyyy-MM-dd"),
                FromDate.ToString("yyyy-MM-dd"),
                CheckStatus, BankId);

            //comment by sanjib due to grid changed
            //grdDetails.DataSource = DsBind;
            //grdDetails.DataBind();

            grdmanualBRS.DataSource = DsBind;
            grdmanualBRS.DataBind();

            //if (DsBind.Tables[0].Rows.Count > 0)
            //{
            //    trhypertext.Visible = true;
            //    MainContent.Visible = true;
            //    ViewState["TableForThePage"] = DsBind.Tables[0];
            //    btnUpdate.Visible = true;
            //    btnCancel.Visible = true;
            //}

        }





        protected void grdmanualBRS_DataBinding(object sender, EventArgs e)
        {
            DataTable CustgGrd = null;
            string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string DlvType = string.Empty;
            DlvType = Convert.ToString(Request.QueryString["type"]);
            //DataTable dtdata = new DataTable();
            string BankId = Convert.ToString(cmbBankfilter.Value);
            DateTime FromDate = Convert.ToDateTime(Convert.ToDateTime(FormDate.Value).ToString("yyyy-MM-dd"));
            DateTime ToDate = Convert.ToDateTime(Convert.ToDateTime(toDate.Value).ToString("yyyy-MM-dd"));

            if (RdAll.Checked == true)
            {
                CheckStatus = "A";
            }
            else if (RdUnCleared.Checked == true)
            {

                CheckStatus = "U";

            }
            else if (RdCleared.Checked == true)
            {
                CheckStatus = "C";
            }

            DataSet dtdata = new DataSet();

            dtdata = oFinancialAccounting.FetchManualBRSData(ToDate.ToString("yyyy-MM-dd"),
            FromDate.ToString("yyyy-MM-dd"),
            CheckStatus, BankId);

            if (dtdata != null)
            {
                grdmanualBRS.DataSource = dtdata;

            }

        }

        public DataTable GetConfigSettingForBRS()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Proc_SystemsettingBRSForODSD");
            proc.AddVarcharPara("@Option", 500, "BRSMandatory");
            dt = proc.GetTable();
            return dt;
        }
        public DataTable GetGridData()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_SalesOrder_Details");
            proc.AddVarcharPara("@Action", 500, "SalesOrder");
            dt = proc.GetTable();
            return dt;
        }


        [WebMethod]
        public static string GetEditablePermission(string ActiveUser)
        {
            CRMSalesOrderDtlBL objCRMSalesOrderDtlBL = new CRMSalesOrderDtlBL();

            int ispermission = 0;
            ispermission = objCRMSalesOrderDtlBL.SalesOrderEditablePermission(Convert.ToInt32(ActiveUser));

            //}
            return Convert.ToString(ispermission);

        }

        [WebMethod]
        public static string GetCustomerId(string KeyVal)
        {
            CRMSalesOrderDtlBL objCRMSalesOrderDtlBL = new CRMSalesOrderDtlBL();

            string ispermission = string.Empty;
            ispermission = objCRMSalesOrderDtlBL.GetInvoiceCustomerId(Convert.ToInt32(KeyVal));


            return Convert.ToString(ispermission);

        }

        [WebMethod]
        public static string GetChallanIdIsExistInSalesInvoice(string keyValue)
        {
            CRMSalesOrderDtlBL objCRMSalesOrderDtlBL = new CRMSalesOrderDtlBL();

            int ispermission = 0;
            ispermission = objCRMSalesOrderDtlBL.GetIdForCustomerDeliveryPendingExists(keyValue);

            //}
            return Convert.ToString(ispermission);

        }

        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
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

        public void bindexport(int Filter)
        {
            //grdmanualBRS.Columns[5].Visible = false;
            string filename = "ManualBRS";
            exporter.FileName = filename;
            exporter.FileName = "GrdManualBRS";

            string FileHeader = "";

            exporter.FileName = filename;

            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "Manual BRS" + Environment.NewLine + "For the period " + Convert.ToDateTime(FormDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(toDate.Date).ToString("dd-MM-yyyy");

            exporter.PageHeader.Left = FileHeader;
            exporter.PageHeader.Font.Size = 10;
            exporter.PageHeader.Font.Name = "Tahoma";

            exporter.PageFooter.Center = "[Page # of Pages #]";
            //exporter.PageFooter.Right = "[Date Printed]";

            switch (Filter)
            {
                case 1:
                    exporter.WritePdfToResponse();
                    break;
                case 2:
                    exporter.WriteXlsxToResponse(new XlsxExportOptionsEx() { ExportType = ExportType.WYSIWYG });
                    break;
                case 3:
                    exporter.WriteRtfToResponse();
                    break;
                case 4:
                    exporter.WriteCsvToResponse();
                    break;
            }
        }

        protected void grdmanualBRS_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            grdmanualBRS.JSProperties["cpinsert"] = null;
            grdmanualBRS.JSProperties["cpEdit"] = null;
            grdmanualBRS.JSProperties["cpUpdate"] = null;
            grdmanualBRS.JSProperties["cpDelete"] = null;
            grdmanualBRS.JSProperties["cpExists"] = null;
            grdmanualBRS.JSProperties["cpUpdateValid"] = null;
            int insertcount = 0;
            int updtcnt = 0;
            int deletecnt = 0;
            string WhichCall = Convert.ToString(e.Parameters).Split('~')[0];
            string WhichType = null;
            if (Convert.ToString(e.Parameters).Contains("~"))
                if (Convert.ToString(e.Parameters).Split('~')[1] != "")
                    WhichType = Convert.ToString(e.Parameters).Split('~')[1];

            if (WhichCall == "FilterGridByDate")
            {
                DateTime FromDate = Convert.ToDateTime(e.Parameters.Split('~')[1]);
                DateTime ToDate = Convert.ToDateTime(e.Parameters.Split('~')[2]);
                string BankId = Convert.ToString(e.Parameters.Split('~')[3]);

                if (RdAll.Checked == true)
                {
                    CheckStatus = "A";
                }
                else if (RdUnCleared.Checked == true)
                {

                    CheckStatus = "U";

                }
                else if (RdCleared.Checked == true)
                {
                    CheckStatus = "C";
                }


                string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                string finyear = Convert.ToString(Session["LastFinYear"]);

                DataSet dtdata = new DataSet();

                dtdata = oFinancialAccounting.FetchManualBRSData(ToDate.ToString("yyyy-MM-dd"),
                FromDate.ToString("yyyy-MM-dd"),
                CheckStatus, BankId);

                if (dtdata != null && dtdata.Tables[0].Rows.Count > 0)
                {
                    grdmanualBRS.DataSource = dtdata;
                    grdmanualBRS.DataBind();
                }
                else
                {
                    grdmanualBRS.DataSource = null;
                    grdmanualBRS.DataBind();
                }
            }
        }
        [WebMethod]
        public static string getProductType(string Products_ID)
        {
            string Type = "";
            string query = @"Select
                           (Case When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='0' Then ''
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='0' Then 'W'
                           When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='0' Then 'B'
                           When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='1' Then 'S'
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='0' Then 'WB'
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='1' Then 'WS'
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='1' Then 'WBS'
                           When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='1' Then 'BS'
                           END) as Type
                           from Master_sProducts
                           where sProducts_ID='" + Products_ID + "'";

            BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable dt = oDbEngine.GetDataTable(query);
            if (dt != null && dt.Rows.Count > 0)
            {
                Type = Convert.ToString(dt.Rows[0]["Type"]);
            }

            return Convert.ToString(Type);
        }


        [WebMethod]
        public static string UpdateManualBRSList(string VoucherNo, string Type, string ValueDate, string InstrumentNo, string InstrumentDate, string VoucherDate)
        {
            CRMSalesOrderDtlBL objCRMSalesOrderDtlBL = new CRMSalesOrderDtlBL();
            int CancelBTO = 0;
            if (string.IsNullOrEmpty(ValueDate.Trim()))
            {
                ValueDate = "1900-01-01";
            }
            if (string.IsNullOrEmpty(InstrumentDate.Trim()))
            {
                InstrumentDate = "01-01-1900";
            }

            CancelBTO = objCRMSalesOrderDtlBL.UpdateManualBRSList(VoucherNo, Type, ValueDate, InstrumentNo, InstrumentDate, VoucherDate);


            return Convert.ToString(CancelBTO);

        }


        [WebMethod]
        public static string IsBankValueDateValid(string VoucherNo, string BankValueDate, string Type)
        {
            CRMSalesOrderDtlBL objCRMSalesOrderDtlBL = new CRMSalesOrderDtlBL();
            int IsBankValueDateExists = 0;
            IsBankValueDateExists = objCRMSalesOrderDtlBL.IsBankValueDateValid(VoucherNo, BankValueDate, Type);


            return Convert.ToString(IsBankValueDateExists);

        }


        protected void EntityServerModeDataSource_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.KeyExpression = "SlNo";

            string connectionString = ConfigurationManager.ConnectionStrings["crmConnectionString"].ConnectionString;
            string IsFilter = Convert.ToString(hfIsFilter.Value);
            string strFromDate = Convert.ToString(hfFromDate.Value);
            string strToDate = Convert.ToString(hfToDate.Value);
            string strBranchID = (Convert.ToString(hfBranchID.Value) == "") ? "0" : Convert.ToString(hfBranchID.Value);
            string DlvType = Convert.ToString(Request.QueryString["type"]);

            string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);

            List<int> branchidlist;


            //Subhabrata
            if (RdAll.Checked == true)
            {
                CheckStatus = "A";
            }
            else if (RdUnCleared.Checked == true)
            {

                CheckStatus = "U";

            }
            else if (RdCleared.Checked == true)
            {
                CheckStatus = "C";
            }
            //End


            if (CheckStatus == "C")
            {
                if (IsFilter == "Y")
                {
                    if (strBranchID == "0")
                    {
                        string BranchList = Convert.ToString(Session["userbranchHierarchy"]);
                        branchidlist = new List<int>(Array.ConvertAll(BranchList.Split(','), int.Parse));

                        ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                        var q = from d in dc.v_FetchManualBRS_ListCs
                                where d.cashbank_CheckDate >= Convert.ToDateTime(strFromDate) && d.cashbank_CheckDate <= Convert.ToDateTime(strToDate)
                                && branchidlist.Contains(Convert.ToInt32(d.Account_Id))

                                select d;
                        e.QueryableSource = q;
                    }
                    else
                    {
                        //branchidlist = new List<int>(Array.ConvertAll(strBranchID.Split(','), int.Parse));

                        ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                        var q = from d in dc.v_FetchManualBRS_ListCs
                                where
                                d.cashbank_CheckDate >= Convert.ToDateTime(strFromDate) && d.cashbank_CheckDate <= Convert.ToDateTime(strToDate) &&
                                    //branchidlist.Contains(Convert.ToInt32(d.Account_Id))
                                (d.Account_Id == strBranchID)
                                select d;
                        e.QueryableSource = q;
                    }
                }
                else
                {
                    ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                    var q = from d in dc.v_FetchManualBRS_ListCs
                            where d.Account_Id == ""
                            select d;
                    e.QueryableSource = q;
                }
            }
            else if (CheckStatus == "U")
            {
                if (IsFilter == "Y")
                {
                    if (strBranchID == "0")
                    {
                        string BranchList = Convert.ToString(Session["userbranchHierarchy"]);
                        branchidlist = new List<int>(Array.ConvertAll(BranchList.Split(','), int.Parse));

                        ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                        var q = from d in dc.v_FetchManualBRS_ListUs
                                where d.cashbank_CheckDate >= Convert.ToDateTime(strFromDate) && d.cashbank_CheckDate <= Convert.ToDateTime(strToDate)
                                && branchidlist.Contains(Convert.ToInt32(d.Account_Id))
                                orderby d.cashbank_CheckDate descending
                                select d;
                        e.QueryableSource = q;
                    }
                    else
                    {
                        //branchidlist = new List<int>(Array.ConvertAll(strBranchID.Split(','), int.Parse));

                        ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                        var q = from d in dc.v_FetchManualBRS_ListUs
                                where
                                d.cashbank_CheckDate >= Convert.ToDateTime(strFromDate) && d.cashbank_CheckDate <= Convert.ToDateTime(strToDate) &&
                                    //branchidlist.Contains(Convert.ToInt32(d.Account_Id))
                                (d.Account_Id == strBranchID)
                                orderby d.cashbank_CheckDate descending
                                select d;
                        e.QueryableSource = q;
                    }
                }
                else
                {
                    ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                    var q = from d in dc.v_FetchManualBRS_ListUs
                            where d.Account_Id == "-1"
                            select d;
                    e.QueryableSource = q;
                }
            }
            else if (CheckStatus == "A")
            {
                if (IsFilter == "Y")
                {
                    if (strBranchID == "0")
                    {
                        string BranchList = Convert.ToString(Session["userbranchHierarchy"]);
                        branchidlist = new List<int>(Array.ConvertAll(BranchList.Split(','), int.Parse));

                        ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                        var q = from d in dc.v_FetchManualBRS_ListAs
                                where d.cashbank_CheckDate >= Convert.ToDateTime(strFromDate) && d.cashbank_CheckDate <= Convert.ToDateTime(strToDate)
                                && branchidlist.Contains(Convert.ToInt32(d.Account_Id))
                                orderby d.cashbank_CheckDate descending
                                select d;
                        e.QueryableSource = q;
                    }
                    else
                    {
                        //branchidlist = new List<int>(Array.ConvertAll(strBranchID.Split(','), int.Parse));

                        ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                        var q = from d in dc.v_FetchManualBRS_ListAs
                                where
                                d.cashbank_CheckDate >= Convert.ToDateTime(strFromDate) && d.cashbank_CheckDate <= Convert.ToDateTime(strToDate) &&
                                    //branchidlist.Contains(Convert.ToInt32(d.Account_Id))
                                (d.Account_Id == strBranchID)
                                orderby d.cashbank_CheckDate descending
                                select d;
                        e.QueryableSource = q;
                    }
                }
                else
                {
                    ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                    var q = from d in dc.v_FetchManualBRS_ListAs
                            where d.Account_Id == "-1"
                            select d;
                    e.QueryableSource = q;
                }
            }



        }
    }
}