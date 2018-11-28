using DevExpress.Web;
using DevExpress.Web.Mvc;
using EntityLayer.CommonELS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BusinessLogicLayer;
using System.Collections.Specialized;
using System.Collections;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using DevExpress.Data;
using System.Threading.Tasks;
using DevExpress.XtraPrinting;
using DevExpress.Export;
using System.Drawing;
namespace Reports.Reports.GridReports
{
    public partial class GeneralTrialReport : ERP.OMS.ViewState_class.VSPage
    {
        DataTable DTIndustry = new DataTable();
        BusinessLogicLayer.Reports objReport = new BusinessLogicLayer.Reports();
        string data = "";
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();

        decimal TotalDebit = 0, TotalCredit = 0;
        decimal _totalDebit = 0, _totalCredit = 0, _totalBalance = 0;
        decimal _totalDiffofdbcr = 0;
        protected void Page_PreInit(object sender, EventArgs e) // lead add
        {
            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/master/GeneralTrialReport.aspx");
            DateTime dtFrom;
            DateTime dtTo;
            if (!IsPostBack)
            {
                drdExport.SelectedIndex = 0;
                ddlExport3.SelectedIndex = 0;
                Session["SI_ComponentData"] = null;
                Session["SI_ComponentData_ledger"] = null;
                Session.Remove("dt_CombineStockTrailRptLeve2");
                Session["dtLedger"] = null;
                Session["SI_ComponentData_Branch"] = null;
                dtFrom = DateTime.Now;
                dtTo = DateTime.Now;
                //   BindDropDownList();
                ASPxFromDate.Text = dtFrom.ToString("dd-MM-yyyy");
                ASPxToDate.Text = dtTo.ToString("dd-MM-yyyy");

                lookupCashBank.DataBind();

                Date_finyearwise(Convert.ToString(Session["LastFinYear"]));
                //ASPxFromDate.Value = DateTime.Now;
                //ASPxToDate.Value = DateTime.Now;

                radAsDate.Attributes.Add("OnClick", "DateAll('all')");
                radPeriod.Attributes.Add("OnClick", "DateAll('Selc')");
            }
            else
            {
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);
            }

            if (!IsPostBack)
            {
                Session.Remove("dtLedger");


                ShowGrid.JSProperties["cpSave"] = null;
                //  string[] CallVal = e.Parameters.ToString().Split('~');

                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                string TABLENAME = "Ledger Details";

                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }
                BranchHoOffice();

                string CASHBANKTYPE = "";
                string CASHBANKID = "";
                string UserId = "";
                string CUSTVENDID = "";

                string EMPVENDID = "";
                string EMPVENDTYPE = "";
                string LEDGERID = "";
                string ISCREATEORPREVIEW = "P";

            }


        }

        public void BranchHoOffice()
        {
            CommonBL bll1 = new CommonBL();
            DataTable stbill = new DataTable();
            stbill = bll1.GetBranchheadoffice("HO");
            if (stbill.Rows.Count > 0)
            {
                ddlbranchHO.DataSource = stbill;
                ddlbranchHO.DataTextField = "Code";
                ddlbranchHO.DataValueField = "branch_id";
                ddlbranchHO.DataBind();

                ddlbranchHO.Items.Insert(0, new ListItem("All", "All"));
            }
        }

        public void Date_finyearwise(string Finyear)
        {
            CommonBL bll1 = new CommonBL();
            DataTable stbill = new DataTable();
            DateTime MinDate, MaxDate;

            stbill = bll1.GetDateFinancila(Finyear);
            if (stbill.Rows.Count > 0)
            {
                ////ASPxFromDate.Text = Convert.ToDateTime(stbill.Rows[0]["FinYear_StartDate"]).ToString("dd-MM-yyyy");
                ////ASPxToDate.Text = Convert.ToDateTime(stbill.Rows[0]["FinYear_EndDate"]).ToString("dd-MM-yyyy");
                //FromDate.Value = Convert.ToDateTime(stbill.Rows[0]["FinYear_StartDate"]).ToString("dd-MM-yyyy");
                //ToDate.Value = Convert.ToDateTime(stbill.Rows[0]["FinYear_EndDate"]).ToString("dd-MM-yyyy");

                ASPxFromDate.MaxDate = Convert.ToDateTime((stbill.Rows[0]["FinYear_EndDate"]));
                ASPxFromDate.MinDate = Convert.ToDateTime((stbill.Rows[0]["FinYear_StartDate"]));

                ASPxToDate.MaxDate = Convert.ToDateTime((stbill.Rows[0]["FinYear_EndDate"]));
                ASPxToDate.MinDate = Convert.ToDateTime((stbill.Rows[0]["FinYear_StartDate"]));

                DateTime MaximumDate = Convert.ToDateTime((stbill.Rows[0]["FinYear_EndDate"]));
                DateTime MinimumDate = Convert.ToDateTime((stbill.Rows[0]["FinYear_StartDate"]));

                DateTime TodayDate = Convert.ToDateTime(DateTime.Now);
                DateTime FinYearEndDate = MaximumDate;

                if (TodayDate > FinYearEndDate)
                {
                    ASPxToDate.Date = FinYearEndDate;
                    ASPxFromDate.Date = MinimumDate;
                }
                else
                {
                    ASPxToDate.Date = TodayDate;
                    ASPxFromDate.Date = MinimumDate;
                }

            }

        }
       
        public void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {


                if (Session["exportval"] == null)
                {
                    // Session["exportval"] = Filter;
                    // BindDropDownList();
                    bindexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    //  Session["exportval"] = Filter;
                    // BindDropDownList();
                    bindexport(Filter);
                }
                drdExport.SelectedValue = "0";
            }

        }       

        public void BindDropDownList()
        {
            // Declare a Dictionary to hold all the Options with Value and Text.
            Dictionary<string, string> options = new Dictionary<string, string>();
            options.Add("0", "Export to");
            options.Add("1", "PDF");
            options.Add("2", "XLSX");
            options.Add("3", "RTF");
            options.Add("4", "CSV");


            // Bind the Dictionary to the DropDownList.
            drdExport.DataSource = options;
            drdExport.DataTextField = "value";
            drdExport.DataValueField = "key";
            drdExport.DataBind();
            drdExport.SelectedValue = "0";
        }

        protected void exporter_RenderBrick(object sender, ASPxGridViewExportRenderingEventArgs e)
        {
            e.BrickStyle.BackColor = Color.White;
            e.BrickStyle.ForeColor = Color.Black;
        }
        
        public void bindexport(int Filter)
        {
            string filename = Convert.ToString((Session["Contactrequesttype"] ?? "General Trial Summary Report"));
            exporter.FileName = filename;
            string FileHeader = "";
            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            if (radAsDate.Checked == true)
            {
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "General Trial Summary Report" + Environment.NewLine + "As on " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy");
            }
            else
            {
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "General Trial Summary Report" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
            }

            exporter.RenderBrick += exporter_RenderBrick;
            //exporter.PageHeader.Left = Convert.ToString((Session["Contactrequesttype"] ?? "General Trial Summary Report"));
            exporter.PageHeader.Left = FileHeader;
            exporter.PageHeader.Font.Size = 10;
            exporter.PageHeader.Font.Name = "Tahoma";
            //exporter.PageFooter.Center = "[Page # of Pages #]";
            //exporter.PageFooter.Right = "[Date Printed]";
            exporter.Landscape = true;
            exporter.MaxColumnWidth = 100;
            exporter.GridViewID = "ShowGrid";
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
        #region main grid details
        protected void Grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            string branchid = Convert.ToString(e.Parameters.Split('~')[2]);
            bool is_asondate = false;
            Session.Remove("dtLedger");
            
            ShowGrid.JSProperties["cpSave"] = null;
            string[] CallVal = e.Parameters.ToString().Split('~');
            is_asondate = Convert.ToBoolean(CallVal[1]);
            //string type = CallVal[1];
            //string code = CallVal[2];
            //if (CallVal[1]== "null")
            //{
            //    type = "";
            //}
            //if (CallVal[2]== "null")
            //{
            //    code = "";
            //}
            string asondate = "";
         if (is_asondate==false)
         {
             asondate = "N";
         }
         else
         {
             asondate = "Y";
         }
           
            string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

            DateTime dtFrom;
            DateTime dtTo;
            dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
            dtTo = Convert.ToDateTime(ASPxToDate.Date);


            CommonBL bll1 = new CommonBL();
            DataTable stbill = new DataTable();
            stbill = bll1.GetDateFinancila(Finyear);

            if ((ASPxFromDate.Date <= Convert.ToDateTime((stbill.Rows[0]["FinYear_EndDate"])) && ASPxFromDate.Date >= Convert.ToDateTime((stbill.Rows[0]["FinYear_StartDate"]))) || (ASPxToDate.Date <= Convert.ToDateTime((stbill.Rows[0]["FinYear_EndDate"])) && ASPxToDate.Date >= Convert.ToDateTime((stbill.Rows[0]["FinYear_StartDate"]))))
            {
                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                string TABLENAME = "Ledger Details";

                string BRANCH_ID = "";

                string QuoComponent = "";
                List<object> QuoList = lookup_branch.GridView.GetSelectedFieldValues("ID");
                foreach (object Quo in QuoList)
                {
                    QuoComponent += "," + Quo;
                }
                BRANCH_ID = QuoComponent.TrimStart(',');

                string cashbankList = "";
                List<object> CashBankList = lookupCashBank.GridView.GetSelectedFieldValues("ID");
                foreach (object cashbankIDs in CashBankList)
                {
                    cashbankList += "," + cashbankIDs;
                }
                cashbankList = cashbankList.TrimStart(',');


                string ISCREATEORPREVIEW = "P";

                int checkshowzerobal = 0;
                if (chkZero.Checked == true)
                {
                    checkshowzerobal = 1;
                }
                else if (chkZero.Checked == false)
                {
                    checkshowzerobal = 0;
                }

                int checkBSPL = 0;
                if (chkPL.Checked == true)
                {
                    checkBSPL = 1;
                }
                else if (chkPL.Checked == false)
                {
                    checkBSPL = 0;
                }

                int checkPARTY = 0;
                if (chkparty.Checked == true)
                {
                    checkPARTY = 1;
                }
                else if (chkparty.Checked == false)
                {
                    checkPARTY = 0;
                }

                //string HeadBranch = branchid;

                Task PopulateStockTrialDataTask = new Task(() => GetLedgerdata(FROMDATE, TODATE, TABLENAME, BRANCH_ID, ISCREATEORPREVIEW, asondate, checkshowzerobal, branchid, cashbankList, checkBSPL, checkPARTY));
                PopulateStockTrialDataTask.RunSynchronously();
                ShowGrid.ExpandAll();
               // lbldiffcalculationText.Text = "Mismatch Defeated";
                //lbldiffcalculation.Text = Convert.ToString(_totalDiffofdbcr);
                ShowGrid.JSProperties["cpMismatch"] = _totalDiffofdbcr;

            }
            else
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Notify", "jAlert('Date Range should be within Financial Year');", true);
                ShowGrid.JSProperties["cpErrorFinancial"] = "ErrorFinancial";
            }

        
        }

        public void GetLedgerdata(string FROMDATE, string TODATE, string TABLENAME, string BRANCH_ID, string ISCREATEORPREVIEW, string asondate, int checkshowzerobal, string HeadBranch, string GroupID, int checkBSPL, int checkPARTY)
       {
            try
            {
                
                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("PRC_GENERAL_TRIAL_REPORT", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]));
                cmd.Parameters.AddWithValue("@FROMDATE", FROMDATE);
                cmd.Parameters.AddWithValue("@TODATE", TODATE);
                cmd.Parameters.AddWithValue("@BRANCH_ID", BRANCH_ID);
                cmd.Parameters.AddWithValue("@AsonDate", asondate);
                cmd.Parameters.AddWithValue("@SHOWZEROBAL", checkshowzerobal);
                cmd.Parameters.AddWithValue("@HO", HeadBranch);
                cmd.Parameters.AddWithValue("@GroupID", GroupID);
                cmd.Parameters.AddWithValue("@SHOWBSPL", checkBSPL);
                cmd.Parameters.AddWithValue("@P_INVOICE_DATE", checkPARTY);
               

                cmd.CommandTimeout = 0;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ds);

                cmd.Dispose();
                con.Dispose();

                Session["dtLedger"] = ds.Tables[0];

                ShowGrid.DataSource = ds.Tables[0];
                ShowGrid.DataBind();
                ShowGrid.JSProperties["cpSummary"] = (Convert.ToDecimal(ShowGrid.GetTotalSummaryValue(ShowGrid.TotalSummary["Close_Dr"])) - Convert.ToDecimal(ShowGrid.GetTotalSummaryValue(ShowGrid.TotalSummary["Close_Cr"])));

            }
            catch (Exception ex)
            {
            }
        }

     protected void ShowGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
     {

         //if (e.Item.FieldName == "CREDIT")
         //{
         //    TotalCredit = Convert.ToDecimal(e.Value);
         //}
         //else if (e.Item.FieldName == "DEBIT")
         //{
         //    TotalDebit = Convert.ToDecimal(e.Value);
         //}

         if (e.Item.FieldName == "Ledger")
         {
             e.Text = "Net Total";
         }
         //else if (e.Item.FieldName == "Close_Dr")
         //{
         //    TotalDebit = Convert.ToDecimal(e.Value);
         //}
         //else if (e.Item.FieldName == "Close_Cr")
         //{
         //    TotalCredit = Convert.ToDecimal(e.Value);
         //}

         //if (e.Item.FieldName == "Close_Dr")
         //{
         //    e.Text = Convert.ToString(TotalDebit);
         //}
         //else if (e.Item.FieldName == "Close_Cr")
         //{
         //    e.Text = Convert.ToString(TotalCredit);
         //}
         else
         {
             e.Text = string.Format("{0}", Math.Abs(Convert.ToDecimal(e.Value)));
         }
     }

     protected void ShowGrid_CustomSummaryCalculate(object sender, CustomSummaryEventArgs e)
     {
        
         //if (e.Item == ShowGrid.TotalSummary["Close_Dr"])
         //{
         //    if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
         //    {
         //        Decimal gmv = Convert.ToDecimal(ShowGrid.GetTotalSummaryValue(ShowGrid.TotalSummary["DEBIT"]));
         //        Decimal equity = Convert.ToDecimal(ShowGrid.GetTotalSummaryValue(ShowGrid.TotalSummary["CREDIT"]));

         //        e.TotalValue = gmv - equity;
         //        e.TotalValueReady = true;
         //    }
         //}
        // lbldiffcalculation.Text = "";
         string summaryTAG = (e.Item as ASPxSummaryItem).Tag;

         if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
         {
             _totalDebit = 0;
             _totalCredit = 0;
             _totalBalance = 0;
             _totalDiffofdbcr = 0;
         }
         else if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
         {
             _totalDebit += Convert.ToDecimal(e.GetValue("Close_Dr"));
             _totalCredit += Convert.ToDecimal(e.GetValue("Close_Cr"));

         }
         else if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
         {
             switch (summaryTAG)
             {
                 case "Close_Dr":
                     e.TotalValue = _totalDebit;
                     break;
                 case "Close_Cr":
                     e.TotalValue = _totalCredit;
                     break;
                     
             }
         }
     }
     protected void ShowGrid_DataBinding(object sender, EventArgs e)
     {
         if (Session["dtLedger"] != null)
         {
             ShowGrid.DataSource = (DataTable)Session["dtLedger"];
             //  ShowGrid.DataBind();
         }

     }

     protected void ShowGrid_DataBound(object sender, EventArgs e)
     {
         ASPxGridView gridView = sender as ASPxGridView;
         gridView.JSProperties["cpSummary"] = gridView.GetTotalSummaryValue(gridView.TotalSummary["Close_Dr"]);
         //hfmismatchvalue.Value = Convert.ToString(gridView.GetTotalSummaryValue(gridView.TotalSummary["Close_Dr"]));
     }


        #endregion

        [WebMethod]
        public static List<string> GetBranchesList(String NoteId)
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
            StringBuilder filter = new StringBuilder();
            StringBuilder Supervisorfilter = new StringBuilder();
            BusinessLogicLayer.Others objbl = new BusinessLogicLayer.Others();
            DataTable dtbl = new DataTable();
            if (NoteId.Trim() == "")
            {
                dtbl = oDBEngine.GetDataTable("select branch_id,branch_description from tbl_master_branch where branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ")  order by branch_description asc");

            }

            List<string> obj = new List<string>();

            foreach (DataRow dr in dtbl.Rows)
            {

                obj.Add(Convert.ToString(dr["branch_description"]) + "|" + Convert.ToString(dr["branch_id"]));
            }
            return obj;
        }

        [WebMethod]
        public static List<string> BindLedgerType(String Ids)
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);

            DataTable dtbl = new DataTable();


            //if (Ids.Trim() != "")
            //{
            //    dtbl = oDBEngine.GetDataTable("select A.MainAccount_ReferenceID AS ID,A.MainAccount_Name as 'AccountName' FROM Master_MainAccount A WHERE A.MainAccount_AccountCode IN(SELECT RTRIM(B.AccountsLedger_MainAccountID) FROM Trans_AccountsLedger B WHERE B.AccountsLedger_BranchId in(" + Ids + ")) ORDER BY A.MainAccount_Name ");

            //}         
            if (Ids == "null")
            {

                Ids = "0";
            }
            List<string> obj = new List<string>();

            obj = GetLedgerBind(Ids.Trim());

            //foreach (DataRow dr in dtbl.Rows)
            //{

            //    obj.Add(Convert.ToString(dr["AccountName"]) + "|" + Convert.ToString(dr["Id"]));
            //}
            return obj;
        }

        [WebMethod]
        public static List<string> BindCustomerVendor()
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);

            DataTable dtbl = new DataTable();

            //dtbl = oDBEngine.GetDataTable("select cnt_id AS ID,ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Name'  FROM tbl_master_contact WHERE cnt_contactType in('CL','DV') AND cnt_branchid IN("+ Ids +") ORDER BY ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+' '+ISNULL(cnt_lastName,'') ");
            dtbl = oDBEngine.GetDataTable("select cnt_id AS ID,ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Name'  FROM tbl_master_contact WHERE cnt_contactType in('CL','DV') ORDER BY ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+' '+ISNULL(cnt_lastName,'') ");



            List<string> obj = new List<string>();

            foreach (DataRow dr in dtbl.Rows)
            {

                obj.Add(Convert.ToString(dr["Name"]) + "|" + Convert.ToString(dr["Id"]));
            }
            return obj;
        }

        public static List<string> GetLedgerBind(string branch)
        {
            CommonBL bll1 = new CommonBL();
            DataTable stbill = new DataTable();
            stbill = bll1.GetLedgerBind(branch);
            List<string> obj = new List<string>();
            if (stbill.Rows.Count > 0)
            {
                foreach (DataRow dr in stbill.Rows)
                {

                    obj.Add(Convert.ToString(dr["AccountName"]) + "|" + Convert.ToString(dr["Id"]));
                }
            }

            return obj;

        }

        #region Branch Populate

        protected void Componentbranch_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            //string FinYear = Convert.ToString(Session["LastFinYear"]);
            //if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            //{
            //    DataTable ComponentTable = new DataTable();
            //    string Hoid = e.Parameter.Split('~')[1];
            //    if (Session["userbranchHierarchy"] != null)
            //    {
            //        ComponentTable = oDBEngine.GetDataTable("select branch_id as ID,branch_description,branch_code from tbl_master_branch   where branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ")   order by branch_description asc");
            //    }
            //    if (ComponentTable.Rows.Count > 0)
            //    {
            //        Session["SI_ComponentData_Branch"] = ComponentTable;
            //        lookup_branch.DataSource = ComponentTable;
            //        lookup_branch.DataBind();
            //    }
            //    else
            //    {
            //        lookup_branch.DataSource = null;
            //        lookup_branch.DataBind();
            //    }
            //}

            //string FinYear = Convert.ToString(Session["LastFinYear"]);
            //if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            //{
            //    DataTable ComponentTable = new DataTable();
            //    string Hoid = e.Parameter.Split('~')[1];
            //    ComponentTable = oDBEngine.GetDataTable("select branch_id as ID,branch_description,branch_code from tbl_master_branch where branch_parentId='" + Hoid + "' and branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ") order by branch_description asc");
            //    //if (Session["userbranchHierarchy"] != null)
            //    //{
            //    //    ComponentTable = oDBEngine.GetDataTable("select branch_id as ID,branch_description,branch_code from tbl_master_branch where branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ") order by branch_description asc");
            //    //}
            //    if (ComponentTable.Rows.Count > 0)
            //    {
            //        Session["SI_ComponentData_Branch"] = ComponentTable;
            //        lookup_branch.DataSource = ComponentTable;
            //        lookup_branch.DataBind();
            //    }
            //    else
            //    {
            //        Session["SI_ComponentData_Branch"] = null;
            //        lookup_branch.DataSource = null;
            //        lookup_branch.DataBind();

            //    }
            //}

            string FinYear = Convert.ToString(Session["LastFinYear"]);

            if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            {
                DataTable ComponentTable = new DataTable();
                string Hoid = e.Parameter.Split('~')[1];
                if (Hoid != "All")
                {
                    //if (Session["userbranchHierarchy"] != null)
                    //{
                    //    ComponentTable = oDBEngine.GetDataTable("select branch_id as ID,branch_description,branch_code from tbl_master_branch   where branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ")   order by branch_description asc");
                    //}
                    ///  ComponentTable = oDBEngine.GetDataTable("select branch_id as ID,branch_description,branch_code from tbl_master_branch where branch_parentId='" + Hoid + "' and  branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ")  order by branch_description asc");

                    ComponentTable = GetBranch(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Hoid);
                    
                    if (ComponentTable.Rows.Count > 0)
                    {
                        Session["SI_ComponentData_Branch"] = ComponentTable;
                        lookup_branch.DataSource = ComponentTable;
                        lookup_branch.DataBind();
                    }
                }
                else
                {
                    //Rev Debashis && Implement All parent branch.
                    //Session["SI_ComponentData_Branch"] = null;
                    //lookup_branch.DataSource = null;
                    //lookup_branch.DataBind();
                    ComponentTable = oDBEngine.GetDataTable("select * from(select branch_id as ID,branch_description,branch_code from tbl_master_branch a where a.branch_id=1 union all select branch_id as ID,branch_description,branch_code from tbl_master_branch b where b.branch_parentId=1) a order by branch_description");
                    Session["SI_ComponentData_Branch"] = ComponentTable;
                    lookup_branch.DataSource = ComponentTable;
                    lookup_branch.DataBind();
                }
            }
        }
        public DataTable GetBranch(string BRANCH_ID, string Ho)
        {
            DataTable dt = new DataTable();
            SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            SqlCommand cmd = new SqlCommand("GetFinancerBranchfetchhowise", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Branch", BRANCH_ID);
            cmd.Parameters.AddWithValue("@Hoid", Ho);
            cmd.CommandTimeout = 0;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            da.Fill(dt);
            cmd.Dispose();
            con.Dispose();

            return dt;
        }
        protected void lookup_branch_DataBinding(object sender, EventArgs e)
        {
            if (Session["SI_ComponentData_Branch"] != null)
            {
                //    DataTable ComponentTable = oDBEngine.GetDataTable("select branch_id,branch_description,branch_code from tbl_master_branch where branch_parentId='" + Hoid + "' order by branch_description asc");
                lookup_branch.DataSource = (DataTable)Session["SI_ComponentData_Branch"];
            }
        }

        #endregion

        #region ##### 2nd Level Grid Details #########
        protected void ShowGridDetails2Level_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string ledger;
            string asondatewise;
            string ledgerDesc;
            string[] CallVal2ndlevel= e.Parameters.ToString().Split('~');
            ledger = CallVal2ndlevel[0];
            asondatewise = Convert.ToString(CallVal2ndlevel[1]);

            DataTable dtledgdesc = null;
            ledgerDesc = "";

            if (ledger != "null" && ledger != "0") 
            {
                dtledgdesc = oDBEngine.GetDataTable("Select MainAccount_Name from Master_MainAccount Where MainAccount_ReferenceID='" + ledger + "'");
                ledgerDesc = dtledgdesc.Rows[0][0].ToString();
            }
            else
            {
                dtledgdesc = null;
                ledgerDesc = null;
            }


            if (!string.IsNullOrEmpty(ledger) && ledger != "0")
            {
                Session.Remove("dt_CombineStockTrailRptLeve2");
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

                DateTime dtFrom;
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");

                DateTime dtTo;
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string TODATE = dtTo.ToString("yyyy-MM-dd");

                string BRANCH_ID = "";

                string QuoComponent = "";
                List<object> QuoList = lookup_branch.GridView.GetSelectedFieldValues("ID");
                foreach (object Quo in QuoList)
                {
                    QuoComponent += "," + Quo;
                }
                BRANCH_ID = QuoComponent.TrimStart(',');

                string branchid = Convert.ToString(e.Parameters.Split('~')[2]);

                int checkPARTY = 0;
                if (chkparty.Checked == true)
                {
                    checkPARTY = 1;
                }
                else if (chkparty.Checked == false)
                {
                    checkPARTY = 0;
                }

                DataTable dt = new DataTable();
                dt = GetGeneralLedger2ndLevel(FROMDATE, TODATE, ledger, asondatewise, BRANCH_ID, branchid, checkPARTY);

                Session["dt_CombineStockTrailRptLeve2"] = dt;
                if (Session["dt_CombineStockTrailRptLeve2"] != null)
                {
                    // DataTable dt = (DataTable)Session["dt_CombineStockTrailRptLeve2"];
                    if (dt.Rows.Count > 0)
                    {
                        ShowGridDetails2Level.JSProperties["cpLedger"] = Convert.ToString(ledgerDesc);
                        ShowGridDetails2Level.JSProperties["cpFromDate"] = dtFrom.ToString("dd-MM-yyyy");
                        ShowGridDetails2Level.JSProperties["cpToDate"] = dtTo.ToString("dd-MM-yyyy");
                    }
                }

                ShowGridDetails2Level.DataSource = dt;
                ShowGridDetails2Level.DataBind();
            }
            else
            {
                Session["dt_CombineStockTrailRptLeve2"] = null;
                ShowGridDetails2Level.DataSource = null;
                ShowGridDetails2Level.DataBind();
            }
        }

        protected void ShowGridDetails2Level_DataBound(object sender, EventArgs e)
        {
            //ASPxGridView grid = (ASPxGridView)sender;
            //foreach (GridViewDataColumn c in grid.Columns)
            //{
            //    if ((c.FieldName.ToString()).StartsWith("ledgr"))
            //    {
            //        //c.Visible = false;
            //        c.Width = 10;
            //    }

                //if ((c.FieldName.ToString()).StartsWith("sProducts_ID"))
                //{
                //    //c.Visible = false;
                //    c.Width = 0;
                //}

                //if ((c.FieldName.ToString()).StartsWith("sProducts_Code"))
                //{
                //    //c.Visible = false;
                //    c.Width = 0;
                //}

                //if ((c.FieldName.ToString()).StartsWith("branch_id"))
                //{
                //    //c.Visible = false;
                //    c.Width = 0;
                //}

            //}
        }

        private DataTable GetGeneralLedger2ndLevel(string FromDate, string ToDate, string ledger, string asondatewise, string BRANCH_ID, string HeadBranch, int checkPARTY)
        {
            
            try
            {
                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("PRC_GENERAL_TRIAL_DETAIL_REPORT", con);
             
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]));
                cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                cmd.Parameters.AddWithValue("@TODATE", ToDate);
                cmd.Parameters.AddWithValue("@BRANCH_ID", BRANCH_ID);
                cmd.Parameters.AddWithValue("@AsonDate", asondatewise);
                cmd.Parameters.AddWithValue("@MainAcc_Ledger", ledger);
                cmd.Parameters.AddWithValue("@HO", HeadBranch);
                cmd.Parameters.AddWithValue("@P_INVOICE_DATE", checkPARTY);
                  
                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;

                    da.Fill(ds);

                    cmd.Dispose();
                    con.Dispose();
             
                //ShowGridDetails2Level.Columns.Clear();


                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        protected void ShowGridDetails2Level_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_CombineStockTrailRptLeve2"] != null)
            {
                ShowGridDetails2Level.DataSource = (DataTable)Session["dt_CombineStockTrailRptLeve2"];
            }
            else
            {
                ShowGridDetails2Level.DataSource = null;
            }
        }

        protected void ShowGridDetails2Level_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);
        }



        protected void ddlExport3_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(ddlExport3.SelectedItem.Value));
            if (Filter != 0)
            {
                bindexport_Details3(Filter);
            }
        }

        public void bindexport_Details3(int Filter)
        {
            string filename = "General Trial Details Report";
            exporterDetails.FileName = filename;
            exporterDetails.FileName = "General Trial Details Report";

            string FileHeader = "";
            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            if (radAsDate.Checked == true)
            {
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "General Trial Details Report" + Environment.NewLine + "As on " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy");
            }
            else
            {
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "General Trial Details Report" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
            }
            
            exporterDetails.RenderBrick += exporter_RenderBrick;

            //exporterDetails.PageHeader.Left = "General Trial Details Report";
            exporterDetails.PageHeader.Left = FileHeader;
            exporterDetails.PageHeader.Font.Size = 10;
            exporterDetails.PageHeader.Font.Name = "Tahoma";
            exporterDetails.PageFooter.Center = "[Page # of Pages #]";
            exporterDetails.PageFooter.Right = "[Date Printed]";
            exporterDetails.GridViewID = "ShowGridDetails2Level";
            switch (Filter)
            {
                case 1:
                    exporterDetails.WritePdfToResponse();
                    break;
                case 2:
                    exporterDetails.WriteXlsxToResponse(new XlsxExportOptionsEx() { ExportType = ExportType.WYSIWYG });
                    break;
                case 3:
                    exporterDetails.WriteRtfToResponse();
                    break;
                case 4:
                    exporterDetails.WriteCsvToResponse();
                    break;

                default:
                    return;
            }
        }






        #endregion

        protected void lookupCashBank_DataBinding(object sender, EventArgs e)
        {
            lookupCashBank.DataSource = GetCashBankList();
        }

        public DataTable GetCashBankList()
        {
            string query = "";

            try
            {
                query = @"SELECT AccountGroup_ReferenceID ID, AccountGroup_Name Name FROM Master_AccountGroup order by AccountGroup_Name";
                  
                DataTable dt = oDBEngine.GetDataTable(query);
                return dt;
            }
            catch
            {
                return null;
            }
        }

        protected void CashBankPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            lookupCashBank.GridView.Selection.CancelSelection();
            lookupCashBank.DataSource = GetCashBankList();
            lookupCashBank.DataBind();
        }

    }
}