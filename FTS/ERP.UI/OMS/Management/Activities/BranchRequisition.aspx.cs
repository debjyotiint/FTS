using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Data;
using DevExpress.Web;
using System.Collections;
using System.Web.Services;
using BusinessLogicLayer;
using DataAccessLayer;
using DevExpress.Web.Data;
using ERP.Models;

namespace ERP.OMS.Management.Activities
{
    public partial class BranchRequisition : ERP.OMS.ViewState_class.VSPage //System.Web.UI.Page
    {
        PurchaseIndentBL objPurchaseIndentBL = new PurchaseIndentBL();
        #region Sandip Section For Approval Section Start
        ERPDocPendingApprovalBL objERPDocPendingApproval = new ERPDocPendingApprovalBL();
        BusinessLogicLayer.RemarkCategoryBL reCat = new BusinessLogicLayer.RemarkCategoryBL();
        int KeyValue = 0;
        #endregion Sandip Section For Approval Dtl Section End
        #region LocalVariable
        SqlDataSource Obj_Sds;
        BusinessLogicLayer.DBEngine oDbEngine;
        string strCon;
        string CurrentSegment;
        DataTable DtCurrentSegment;
        DataTable dtXML = new DataTable();
        BusinessLogicLayer.GenericLogSystem oGenericLogSystem;
        // PurchaseIndentCS objPurchaseIndentBL = new PurchaseIndentCS();
        string CashBankVoucherFile_XMLPATH = null;
        BusinessLogicLayer.Converter objConverter = new BusinessLogicLayer.Converter();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        static string ForJournalDate = null;
        string JVNumStr = string.Empty;
        public EntityLayer.CommonELS.UserRightsForPage rights = new EntityLayer.CommonELS.UserRightsForPage();
        #endregion
        protected void Page_PreInit(object sender, EventArgs e) // lead add
        {
            #region Sandip Section For Approval Section to Change Master Page Dyanamically Start
            if (Request.QueryString.AllKeys.Contains("status"))
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/PopUp.Master";
                //divcross.Visible = false;
            }
            else
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/ERP.Master";
                //divcross.Visible = true;
            }
            #endregion Sandip Section For Approval Dtl Section End
            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);


                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Activities/BranchRequisition.aspx");
            if (!IsPostBack)
            {
                string userbranchHierachy = Convert.ToString(Session["userbranchHierarchy"]);
                string FinYear = Convert.ToString(Session["LastFinYear"]);
                PopulateDropDown(userbranchHierachy, FinYear);
                SetFinYearCurrentDate();
                IsUdfpresent.Value = Convert.ToString(getUdfCount());
                //................Cookies..................
                if (this.Page.MasterPageFile == "/OMS/MasterPage/ERP.Master")
                {
                    Grid_PurchaseIndent.SettingsCookies.CookiesID = "BreeezeErpGridCookiesGrid_PurchaseIndentBranchRequisition";
                    this.Page.ClientScript.RegisterStartupScript(GetType(), "setCookieOnStorage", "<script>addCookiesKeyOnStorage('BreeezeErpGridCookiesGrid_PurchaseIndentBranchRequisition');</script>");
                }
                //...........Cookies End............... 
                //tDate.Date = DateTime.Now;
                this.Page.ClientScript.RegisterStartupScript(GetType(), "CS", "<script>PageLoad();</script>");
                BindBranchFrom();
                Session["BranchIndateDetails"] = null;
                if (!String.IsNullOrEmpty(Convert.ToString(Session["userbranchID"])))
                {
                    string strdefaultBranch = Convert.ToString(Session["userbranchID"]);
                    ddlBranch.SelectedValue = strdefaultBranch;
                    //Bind_BranchTo(strdefaultBranch);
                }
                if (!String.IsNullOrEmpty(Convert.ToString(Session["LocalCurrency"])))
                {
                    string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
                    string basedCurrency = Convert.ToString(LocalCurrency.Split('~')[0]);
                    string CurrencyId = Convert.ToString(basedCurrency[0]);
                    CmbCurrency.Value = CurrencyId;
                }
                #region Sandip Section For Approval Section Start
                #region Session Remove Section Start
                Session.Remove("BRPendingApproval");
                Session.Remove("BRUserWiseERPDocCreation");
                #endregion Session Remove Section End
                ConditionWiseShowStatusButton();

                if (Request.QueryString.AllKeys.Contains("status"))
                {
                    string indentid = Convert.ToString(Request.QueryString["key"]);
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "StartingSetupForApproval(" + indentid + ")", true);
                    btncross.Visible = false;
                    btnnew.Visible = false;
                    ApprovalCross.Visible = true;
                    ddlBranch.Enabled = false;
                }
                else
                {
                    btncross.Visible = true;
                    btnnew.Visible = true;
                    ApprovalCross.Visible = false;
                    ddlBranch.Enabled = true;
                }
                #endregion Sandip Section For Approval Dtl Section End

            }
            if (hdn_Mode.Value == "Entry")
            {
                Keyval_internalId.Value = "Add";
            }

            //FillGrid();
            Bind_NumberingScheme();
            #region Sandip Section For Approval Section Start
            if (divPendingWaiting.Visible == true)
            {
                PopulateUserWiseERPDocCreation();
                PopulateApprovalPendingCountByUserLevel();
                PopulateERPDocApprovalPendingListByUserLevel();
                if (Request.QueryString.AllKeys.Contains("status"))
                {
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "StartingSetupForApproval()", true);
                }
            }
            #endregion Sandip Section For Approval Dtl Section End

        }
        public DataSet GetAllDropDownDetail(string branchList, string FinYear)
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("Prc_DownPaymentEntry_Details");
            proc.AddVarcharPara("@Action", 100, "GetAllDropDownDetail");
            proc.AddVarcharPara("@BranchList", 4000, branchList);
            proc.AddVarcharPara("@FinYear", 10, FinYear);
            ds = proc.GetDataSet();
            return ds;
        }

        public void PopulateDropDown(string branchHierchy, string FinYear)
        {
            DataSet dst = GetAllDropDownDetail(branchHierchy, FinYear);

            FormDate.Date = DateTime.Now;
            toDate.Date = DateTime.Now;
            //dtBilldate.Date = DateTime.Now;

            if (dst.Tables[0] != null && dst.Tables[0].Rows.Count > 0)
            {
                cmbBranchfilter.DataSource = dst.Tables[0];
                cmbBranchfilter.ValueField = "branch_id";
                cmbBranchfilter.TextField = "branch_description";
                cmbBranchfilter.DataBind();

                cmbBranchfilter.Value = Convert.ToString(Session["userbranchID"]);
            }

          
        }



        protected int getUdfCount()
        {
            DataTable udfCount = oDBEngine.GetDataTable("select 1 from tbl_master_remarksCategory rc where cat_applicablefor='BI' and ( exists (select * from tbl_master_udfGroup where id=rc.cat_group_id and grp_isVisible=1) or rc.cat_group_id=0)");
            return udfCount.Rows.Count;
        }
        public void Bind_NumberingScheme()
        {
            string strCompanyID = Convert.ToString(Session["LastCompany"]);
            string strBranchID = Convert.ToString(Session["userbranchID"]);
            string FinYear = Convert.ToString(Session["LastFinYear"]);
            string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);

            SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
            DataTable Schemadt = objSlaesActivitiesBL.GetNumberingSchema(strCompanyID, userbranchHierarchy, FinYear, "16", "N");
            if (Schemadt != null && Schemadt.Rows.Count > 0)
            {
                CmbScheme.TextField = "SchemaName";
                CmbScheme.ValueField = "Id";
                CmbScheme.DataSource = Schemadt;
                CmbScheme.DataBind();
            }
        }
        public void BindBranchFrom()
        {
            //dsBranch.SelectCommand = "SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where BRANCH_id in(" + Convert.ToString(Session["userbranchHierarchy"]) + ")";
            dsBranch.SelectCommand = "SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH";
            ddlBranch.DataBind();
        }

        public void Bind_BranchTo(string BRANCH_id_from)
        {
            //dsBranchTo.SelectCommand = "select '0' AS BANKBRANCH_ID,'Select' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH" +
            //" union "+
            //" SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' "+
            //" AS BANKBRANCH_NAME FROM TBL_MASTER_BRANCH where BRANCH_id<>'"+BRANCH_id_from+"'" ;

            //ddlBranchTo.DataBind();

            DataTable dtBRANCH_id_to = new DataTable();
            dtBRANCH_id_to = GetBranchToData(BRANCH_id_from);
            if (dtBRANCH_id_to.Rows.Count > 0)
            {
                ddlBranchTo.TextField = "BANKBRANCH_NAME";
                ddlBranchTo.ValueField = "BANKBRANCH_ID";
                ddlBranchTo.DataSource = dtBRANCH_id_to;
                ddlBranchTo.DataBind();
            }
            else
            {
                ddlBranchTo.TextField = "BANKBRANCH_NAME";
                ddlBranchTo.ValueField = "BANKBRANCH_ID";
                ddlBranchTo.DataSource = dtBRANCH_id_to;
                ddlBranchTo.DataBind();
            }
        }
        public DataTable GetBranchToData(string BRANCH_id_from)
        {

            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseIndentDetailsList");
            proc.AddVarcharPara("@Action", 500, "GetBranchTo");
            proc.AddIntegerPara("@BRANCH_id_from", Convert.ToInt32(BRANCH_id_from));
            dt = proc.GetTable();
            return dt;
        }
        public void bindexport(int Filter)
        {
            //Code  Added and Commented By Priti on 20122016 to use Export Header,date
            //exporter.GridView = Grid_ContraVoucher;

            exporter.GridViewID = "Grid_PurchaseIndent";
            string filename = "BranchRequisition";
            exporter.FileName = filename;

            exporter.PageHeader.Left = "Branch Requisition";
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

        //**Abhisek**//
        protected void EntityServerModeDataSource_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.KeyExpression = "Indent_Id";

            string connectionString = ConfigurationManager.ConnectionStrings["crmConnectionString"].ConnectionString;
            string IsFilter = Convert.ToString(hfIsFilter.Value);
            string strFromDate = Convert.ToString(hfFromDate.Value);
            string strToDate = Convert.ToString(hfToDate.Value);
            string strBranchID = (Convert.ToString(hfBranchID.Value) == "") ? "0" : Convert.ToString(hfBranchID.Value);

            List<int> branchidlist;
            ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
            //var q = from d in dc.V_BranchRequisitionLists
            //        //where d.BranchID == '0'
            //        //orderby d.CheckDate descending
            //        select d;
            //e.QueryableSource = q;

            if (IsFilter == "Y")
            {
                if (strBranchID == "0")
                {
                    string BranchList = Convert.ToString(Session["userbranchHierarchy"]);
                    branchidlist = new List<int>(Array.ConvertAll(BranchList.Split(','), int.Parse));

                    //ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                    var q = from d in dc.V_BranchRequisitionLists
                            where d.Indent_RequisitionDateTimeFormat >= Convert.ToDateTime(strFromDate) && d.Indent_RequisitionDateTimeFormat <= Convert.ToDateTime(strToDate)
                            && branchidlist.Contains(Convert.ToInt32(d.Indent_BranchIdFor)) // Indent_BranchIdTo
                            orderby d.Indent_RequisitionDateTimeFormat descending
                            select d;
                    e.QueryableSource = q;
                }
                else
                {
                    branchidlist = new List<int>(Array.ConvertAll(strBranchID.Split(','), int.Parse));

                    //ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                    var q = from d in dc.V_BranchRequisitionLists
                            where
                            d.Indent_RequisitionDateTimeFormat >= Convert.ToDateTime(strFromDate) && d.Indent_RequisitionDateTimeFormat <= Convert.ToDateTime(strToDate) &&
                            branchidlist.Contains(Convert.ToInt32(d.Indent_BranchIdFor))
                            orderby d.Indent_RequisitionDateTimeFormat descending
                            select d;
                    e.QueryableSource = q;
                }
            }
            else
            {
                //ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
                var q = from d in dc.V_BranchRequisitionLists
                        where d.Indent_BranchIdFor == '0'
                        orderby d.Indent_RequisitionDate descending
                        select d;
                e.QueryableSource = q;
            }
        }
        public void FillGrid()
        {
            //DataTable dtdata = GetGridData();
            DataTable dtdata = GetPurchaseIndentListGridData();


            if (dtdata != null && dtdata.Rows.Count > 0)
            {
                Grid_PurchaseIndent.DataSource = dtdata;
                Grid_PurchaseIndent.DataBind();
            }
            else
            {
                Grid_PurchaseIndent.DataSource = null;
                Grid_PurchaseIndent.DataBind();
            }
        }
        public DataTable GetPurchaseIndentListGridData()
        {

            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseIndentDetailsList");
            proc.AddVarcharPara("@Action", 500, "BranchRequisition");
            proc.AddVarcharPara("@userbranchHierarchy", 500, Convert.ToString(Session["userbranchHierarchy"]));
            proc.AddVarcharPara("@CampanyID", 500, Convert.ToString(Session["LastCompany"]));
            proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
            dt = proc.GetTable();
            return dt;
        }
        public void SetFinYearCurrentDate()
        {
            tDate.EditFormatString = objConverter.GetDateFormat("Date");
            string fDate = null;

            //DateTime dt = DateTime.ParseExact("3/31/2016", "MM/dd/yyy", CultureInfo.InvariantCulture);
            string[] FinYEnd = Convert.ToString(Session["FinYearEnd"]).Split(' ');
            string FinYearEnd = FinYEnd[0];

            DateTime date3 = DateTime.ParseExact(FinYearEnd, "M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);

            ForJournalDate = Convert.ToString(date3);

            //ForJournalDate =Session["FinYearEnd"].ToString();
            int month = oDBEngine.GetDate().Month;
            int date = oDBEngine.GetDate().Day;
            int Year = oDBEngine.GetDate().Year;

            if (date3 < oDBEngine.GetDate().Date)
            {
                fDate = Convert.ToString(Convert.ToDateTime(ForJournalDate).Month) + "/" + Convert.ToString(Convert.ToDateTime(ForJournalDate).Day) + "/" + Convert.ToString(Convert.ToDateTime(ForJournalDate).Year);
            }
            else
            {
                fDate = Convert.ToString(Convert.ToDateTime(oDBEngine.GetDate().Date).Month) + "/" + Convert.ToString(Convert.ToDateTime(oDBEngine.GetDate().Date).Day) + "/" + Convert.ToString(Convert.ToDateTime(oDBEngine.GetDate().Date).Year);
            }

            tDate.Value = DateTime.ParseExact(fDate, @"M/d/yyyy", System.Globalization.CultureInfo.InvariantCulture);
        }
        public class Product
        {
            public string ProductID { get; set; }
            public string ProductName { get; set; }
        }
        public DataSet GetProductData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseIndentDetailsList");
            proc.AddVarcharPara("@Action", 500, "ProductDetails");
            ds = proc.GetDataSet();
            return ds;
        }
        public IEnumerable GetProduct()
        {
            List<Product> ProductList = new List<Product>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = GetProductData().Tables[0];
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                Product Products = new Product();
                Products.ProductID = Convert.ToString(DT.Rows[i]["Products_ID"]);
                Products.ProductName = Convert.ToString(DT.Rows[i]["Products_Name"]);
                ProductList.Add(Products);
            }

            return ProductList;
        }
        //protected void Page_Init(object sender, EventArgs e)
        //{
        //    ((GridViewDataComboBoxColumn)gridBatch.Columns["gvColProduct"]).PropertiesComboBox.DataSource = GetProduct();
        //}
        [WebMethod]
        public static string getSchemeType(string sel_scheme_id)
        {
            //BusinessLogicLayer.DBEngine oDbEngine1 = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            //string[] scheme = oDbEngine1.GetFieldValue1("tbl_master_Idschema", "schema_type", "Id = " + Convert.ToInt32(sel_scheme_id), 1);
            //return Convert.ToString(scheme[0]);

            string strschematype = "", strschemalength = "", strschemavalue = "", strschemaBranch = "";
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.GetDataTable("tbl_master_Idschema", " schema_type,length,Branch", " Id = " + Convert.ToInt32(sel_scheme_id));

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
        public class BratchGridLIST
        {
            public string SrlNo { get; set; }
            public string PurchaseIndentID { get; set; }
            public string gvColProduct { get; set; }
            public string gvColDiscription { get; set; }
            public string gvColAvailableStock { get; set; }
            public string gvColQuantity { get; set; }
            public string gvColUOM { get; set; }
            public string gvColRate { get; set; }
            public string gvColValue { get; set; }
            public string Status { get; set; }
            public DateTime? ExpectedDeliveryDate { get; set; }

            public string ProductName { get; set; }

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
            if (Session["BranchIndateDetails"] != null)
            {
                DataTable dvData = (DataTable)Session["BranchIndateDetails"];
                DataView dvDataView = new DataView(dvData);
                dvDataView.RowFilter = "Status <> 'D'";

                gridBatch.DataSource = GetBranchRequisition(dvDataView.ToTable());
            }
            // gridBatch.DataSource = BindBratchGrid();
        }
        protected void gridBatch_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "SrlNo")
            {
                e.Editor.ReadOnly = true;
            }
            else
                if (e.Column.FieldName == "gvColDiscription")
                {
                    e.Editor.ReadOnly = true;
                }
                else if (e.Column.FieldName == "gvColUOM")
                {
                    e.Editor.ReadOnly = true;
                }
                //else if (e.Column.FieldName == "gvColRate")
                //{
                //    e.Editor.ReadOnly = true;
                //}
                else if (e.Column.FieldName == "gvColAvailableStock")
                {
                    e.Editor.ReadOnly = true;
                }
                else if (e.Column.FieldName == "gvColValue")
                {
                    e.Editor.ReadOnly = true;
                }
                else
                {
                    e.Editor.ReadOnly = false;
                }

        }

        protected void gridBatch_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            DataTable Indentdt = new DataTable();
            string IsDeleteFrom = Convert.ToString(hdfIsDelete.Value);

            if (Session["BranchIndateDetails"] != null)
            {
                Indentdt = (DataTable)Session["BranchIndateDetails"];
            }
            else
            {
                Indentdt.Columns.Add("SrlNo", typeof(string));
                Indentdt.Columns.Add("IndentDetailsId", typeof(string));
                Indentdt.Columns.Add("ProductID", typeof(string));
                Indentdt.Columns.Add("Description", typeof(string));
                Indentdt.Columns.Add("Quantity", typeof(string));
                Indentdt.Columns.Add("UOM", typeof(string));
                Indentdt.Columns.Add("Rate", typeof(string));
                Indentdt.Columns.Add("ValueInBaseCurrency", typeof(string));
                Indentdt.Columns.Add("ExpectedDeliveryDate", typeof(string));
                Indentdt.Columns.Add("Status", typeof(string));
                Indentdt.Columns.Add("AvailableStock", typeof(string));
                Indentdt.Columns.Add("ProductName", typeof(string));
            }

            foreach (var args in e.InsertValues)
            {
                string ProductDetails = Convert.ToString(args.NewValues["gvColProduct"]);

                if (ProductDetails != "" && ProductDetails != "0")
                {
                    string SrlNo = Convert.ToString(args.NewValues["SrlNo"]);

                    string[] ProductDetailsList = ProductDetails.Split(new string[] { "||@||" }, StringSplitOptions.None);
                    string ProductID = ProductDetailsList[0];

                    string Description = Convert.ToString(args.NewValues["gvColDiscription"]);
                    string Quantity = (Convert.ToString(args.NewValues["gvColQuantity"]) != "") ? Convert.ToString(args.NewValues["gvColQuantity"]) : "0";
                    string ProductName = Convert.ToString(args.NewValues["ProductName"]);
                    //string UOM = Convert.ToString(ProductDetailsList[3]);
                    string UOM = Convert.ToString(args.NewValues["gvColUOM"]);

                    string Rate = Convert.ToString(args.NewValues["gvColRate"]);
                    // string StockQuantity = Convert.ToString(args.NewValues["gvColValue"]);
                    //string Rate = Convert.ToString(ProductDetailsList[7]);
                    string Amount = (Convert.ToString(args.NewValues["gvColValue"]) != "") ? Convert.ToString(args.NewValues["gvColValue"]) : "0";
                    string Date = Convert.ToString(args.NewValues["ExpectedDeliveryDate"]);
                    string AvailableStock = (Convert.ToString(args.NewValues["gvColAvailableStock"]) != "") ? Convert.ToString(args.NewValues["gvColAvailableStock"]) : "0";
                    //if (Date == "")
                    //{
                    //    Date = "1900-01-01";
                    //}
                    Indentdt.Rows.Add(SrlNo, "0", ProductDetails, Description, Quantity, UOM, Rate, Amount, Date, "I", AvailableStock, ProductName);
                }
            }
            foreach (var args in e.UpdateValues)
            {
                string SrlNo = Convert.ToString(args.NewValues["SrlNo"]);
                string IndentDetailsId = Convert.ToString(args.Keys["PurchaseIndentID"]);
                string ProductDetails = Convert.ToString(args.NewValues["gvColProduct"]);

                bool isDeleted = false;
                foreach (var arg in e.DeleteValues)
                {
                    string DeleteID = Convert.ToString(arg.Keys["PurchaseIndentID"]);
                    if (DeleteID == IndentDetailsId)
                    {
                        isDeleted = true;
                        break;
                    }
                }

                if (isDeleted == false)
                {
                    if (ProductDetails != "" && ProductDetails != "0")
                    {
                        string[] ProductDetailsList = ProductDetails.Split(new string[] { "||@||" }, StringSplitOptions.None);
                        string ProductID = Convert.ToString(ProductDetailsList[0]);

                        string Description = Convert.ToString(args.NewValues["gvColDiscription"]);
                        string ProductName = Convert.ToString(args.NewValues["ProductName"]);
                        string Quantity = Convert.ToString(args.NewValues["gvColQuantity"]);
                        //string UOM = Convert.ToString(ProductDetailsList[3]);
                        string UOM = Convert.ToString(args.NewValues["gvColUOM"]);
                        string Rate = Convert.ToString(args.NewValues["gvColRate"]);
                        // string StockQuantity = Convert.ToString(args.NewValues["gvColValue"]);
                        //string Rate = Convert.ToString(ProductDetailsList[7]);
                        string Amount = (Convert.ToString(args.NewValues["gvColValue"]) != "") ? Convert.ToString(args.NewValues["gvColValue"]) : "0";
                        string Date = Convert.ToString(args.NewValues["ExpectedDeliveryDate"]);
                        string AvailableStock = (Convert.ToString(args.NewValues["gvColAvailableStock"]) != "") ? Convert.ToString(args.NewValues["gvColAvailableStock"]) : "0";
                        bool Isexists = false;
                        foreach (DataRow drr in Indentdt.Rows)
                        {
                            string OldQuotationID = Convert.ToString(drr["IndentDetailsId"]);

                            if (OldQuotationID == IndentDetailsId)
                            {
                                Isexists = true;
                                //drr["SrlNo"] = SrlNo;
                                //drr["IndentDetailsId"] = OldQuotationID;
                                drr["ProductID"] = ProductDetails;
                                drr["Description"] = Description;
                                drr["Quantity"] = Quantity;
                                drr["UOM"] = UOM;
                                drr["Rate"] = Rate;
                                drr["ValueInBaseCurrency"] = Amount;
                                drr["ExpectedDeliveryDate"] = Date;
                                drr["Status"] = "U";
                                drr["AvailableStock"] = AvailableStock;
                                drr["ProductName"] = ProductName;

                                break;
                            }
                        }

                        if (Isexists == false)
                        {
                            Indentdt.Rows.Add(SrlNo, IndentDetailsId, ProductDetails, Description, Quantity, UOM, Rate, Amount, Date, "U", AvailableStock, ProductName);
                        }
                    }
                }
            }
            foreach (var args in e.DeleteValues)
            {
                string IndentDetailsID = Convert.ToString(args.Keys["PurchaseIndentID"]);

                for (int i = Indentdt.Rows.Count - 1; i >= 0; i--)
                {
                    DataRow dr = Indentdt.Rows[i];
                    string delQuotationID = Convert.ToString(dr["IndentDetailsID"]);

                    if (delQuotationID == IndentDetailsID)
                        dr.Delete();
                }
                Indentdt.AcceptChanges();

                if (IndentDetailsID.Contains("~") != true)
                {
                    Indentdt.Rows.Add(0, IndentDetailsID, 0, "", 0, 0, 0, 0, DateTime.Now, "D", 0, "");
                }
            }

            int j = 1;
            foreach (DataRow dr in Indentdt.Rows)
            {
                string Status = Convert.ToString(dr["Status"]);
                dr["SrlNo"] = j.ToString();

                if (Status != "D")
                {
                    if (Status == "I")
                    {
                        string strID = Convert.ToString("Q~" + j);
                        dr["IndentDetailsID"] = strID;
                    }
                    j++;
                }
            }
            Indentdt.AcceptChanges();

            Session["BranchIndateDetails"] = Indentdt;

            if (IsDeleteFrom != "D")
            {
                string ActionType = "";
                if (hdn_Mode.Value == "Entry")
                {
                    ActionType = "ADD";
                }
                else if (hdn_Mode.Value == "Edit")
                {
                    ActionType = "Edit";
                }

                string strIndentType = "BR";
                string strRequisitionNumber = Convert.ToString(txtVoucherNo.Text.Trim());
                string strIndent_Id = Convert.ToString(hdnEditIndentID.Value);
                string strRequisitionDate = Convert.ToString(tDate.Date);
                string strBranch = Convert.ToString(ddlBranch.SelectedValue);
                string strBranchTo = Convert.ToString(ddlBranchTo.Value);
                string strPurpose = Convert.ToString(txtMemoPurpose.Text);
                string strCurrency = Convert.ToString(CmbCurrency.SelectedItem.Value);
                string strExchangeRate = Convert.ToString(txtRate.Text);
                string currency = Convert.ToString(HttpContext.Current.Session["LocalCurrency"]);
                string[] ActCurrency = currency.Split('~');
                int BaseCurrencyId = Convert.ToInt32(ActCurrency[0]);
                DataTable tempQuotation = Indentdt.Copy();

                foreach (DataRow dr in tempQuotation.Rows)
                {
                    string Status = Convert.ToString(dr["Status"]);

                    if (Status == "I")
                    {
                        dr["IndentDetailsId"] = "0";

                        string[] list = Convert.ToString(dr["ProductID"]).Split(new string[] { "||@||" }, StringSplitOptions.None);
                        dr["ProductID"] = Convert.ToString(list[0]);
                        dr["UOM"] = Convert.ToString(list[3]);
                        string rate = Convert.ToString(dr["Rate"]);
                        dr["Rate"] = Convert.ToString(Math.Round(Convert.ToDecimal(rate), 2));
                        dr["Description"] = "";
                    }
                    else if (Status == "U" || Status == "")
                    {
                        string delQuotationID = Convert.ToString(dr["IndentDetailsID"]);
                        if (delQuotationID.Contains("~") == true)
                        {
                            dr["IndentDetailsId"] = "0";
                            dr["Status"] = "I";
                        }
                        string[] list = Convert.ToString(dr["ProductID"]).Split(new string[] { "||@||" }, StringSplitOptions.None);
                        dr["ProductID"] = Convert.ToString(list[0]);
                        dr["UOM"] = Convert.ToString(list[3]);
                        string rate = Convert.ToString(dr["Rate"]);
                        dr["Rate"] = Convert.ToString(Math.Round(Convert.ToDecimal(rate), 2));
                        dr["Description"] = "";

                    }
                }
                tempQuotation.AcceptChanges();
                #region Sandip Section For Approval Section Start
                string approveStatus = "";
                if (Request.QueryString["status"] != null)
                {
                    approveStatus = Convert.ToString(Request.QueryString["status"]);
                }
                #endregion Sandip Section For Approval Section Start
                string validate = "";
                if (hdn_Mode.Value == "Entry")
                {
                    validate = checkNMakeJVCode(strRequisitionNumber.Trim(), Convert.ToInt32(CmbScheme.Value));
                }

                DataView dvData = new DataView(tempQuotation);
                dvData.RowFilter = "Status<>'D'";
                DataTable dt_tempQuotation = dvData.ToTable();

                var duplicateRecords = dt_tempQuotation.AsEnumerable()
               .GroupBy(r => r["ProductID"]) //coloumn name which has the duplicate values
               .Where(gr => gr.Count() > 1)
                .Select(g => g.Key);

                foreach (var d in duplicateRecords)
                {
                    validate = "duplicateProduct";
                }
                foreach (DataRow dr in tempQuotation.Rows)
                {
                    decimal ProductQuantity = Convert.ToDecimal(dr["Quantity"]);
                    string Status = Convert.ToString(dr["Status"]);

                    if (Status != "D")
                    {
                        if (ProductQuantity == 0)
                        {
                            validate = "nullQuantity";
                            break;
                        }
                    }
                }
                if (validate == "outrange" || validate == "duplicate" || validate == "nullQuantity" || validate == "duplicateProduct")
                {
                    gridBatch.JSProperties["cpSaveSuccessOrFail"] = validate;
                }
                else
                {
                    if (Save_Record(strIndentType, strIndent_Id, JVNumStr, strRequisitionDate, strBranch, strBranchTo, strPurpose, strCurrency, strExchangeRate, BaseCurrencyId, tempQuotation, ActionType, approveStatus) == false)
                    {
                        gridBatch.JSProperties["cpSaveSuccessOrFail"] = "errorInsert";
                    }
                    else
                    {
                        gridBatch.JSProperties["cpVouvherNo"] = JVNumStr;
                    }
                }
                #region Sandip Section For Approval Section Start
                if (approveStatus != "")
                {
                    gridBatch.JSProperties["cpApproverStatus"] = "approve";
                }
                #endregion Sandip Section For Approval Section Start
                e.Handled = true;
            }
            else
            {
                DataView dvData = new DataView(Indentdt);
                dvData.RowFilter = "Status <> 'D'";

                gridBatch.DataSource = GetBranchRequisition(dvData.ToTable());
                gridBatch.DataBind();
            }

        }
        public IEnumerable GetBranchRequisition(DataTable PurchaseIndentdt)
        {
            List<BratchGridLIST> BratchGridLists = new List<BratchGridLIST>();

            for (int i = 0; i < PurchaseIndentdt.Rows.Count; i++)
            {


                BratchGridLIST BratchGrid_LIST = new BratchGridLIST();
                BratchGrid_LIST.SrlNo = Convert.ToString(PurchaseIndentdt.Rows[i]["SrlNo"]);
                BratchGrid_LIST.PurchaseIndentID = Convert.ToString(PurchaseIndentdt.Rows[i]["IndentDetailsId"]);
                BratchGrid_LIST.gvColProduct = Convert.ToString(PurchaseIndentdt.Rows[i]["ProductID"]);
                BratchGrid_LIST.gvColDiscription = Convert.ToString(PurchaseIndentdt.Rows[i]["Description"]);
                BratchGrid_LIST.gvColQuantity = Convert.ToString(PurchaseIndentdt.Rows[i]["Quantity"]);
                BratchGrid_LIST.gvColUOM = Convert.ToString(PurchaseIndentdt.Rows[i]["UOM"]);
                BratchGrid_LIST.gvColRate = Convert.ToString(PurchaseIndentdt.Rows[i]["Rate"]);
                BratchGrid_LIST.gvColValue = Convert.ToString(PurchaseIndentdt.Rows[i]["ValueInBaseCurrency"]);
                string ExpectedDeliveryDate = Convert.ToString(PurchaseIndentdt.Rows[i]["ExpectedDeliveryDate"]);
                if (!String.IsNullOrEmpty(ExpectedDeliveryDate))
                {
                    BratchGrid_LIST.ExpectedDeliveryDate = Convert.ToDateTime(PurchaseIndentdt.Rows[i]["ExpectedDeliveryDate"]);//8
                }
                else
                {
                    BratchGrid_LIST.ExpectedDeliveryDate = null;
                }
                BratchGrid_LIST.Status = Convert.ToString(PurchaseIndentdt.Rows[i]["Status"]);
                BratchGrid_LIST.gvColAvailableStock = Convert.ToString(PurchaseIndentdt.Rows[i]["AvailableStock"]);
                BratchGrid_LIST.ProductName = Convert.ToString(PurchaseIndentdt.Rows[i]["ProductName"]);
                BratchGridLists.Add(BratchGrid_LIST);
            }

            return BratchGridLists;
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

                    sqlQuery = "SELECT max(tjv.Indent_RequisitionNumber) FROM tbl_trans_Indent tjv WHERE dbo.RegexMatch('";
                    if (prefLen > 0)
                        sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                    else if (scheme_type == 2)
                        sqlQuery += "^";
                    sqlQuery += "[0-9]{" + paddCounter + "}";
                    if (sufxLen > 0)
                        sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                    sqlQuery += "?$', LTRIM(RTRIM(tjv.Indent_RequisitionNumber))) = 1 and Indent_RequisitionNumber like '" + prefCompCode + "%'";
                    if (scheme_type == 2)
                        sqlQuery += " AND CONVERT(DATE, Indent_CreatedDate) = CONVERT(DATE, GETDATE())";
                    dtC = oDbEngine.GetDataTable(sqlQuery);

                    if (dtC.Rows[0][0].ToString() == "")
                    {
                        sqlQuery = "SELECT max(tjv.Indent_RequisitionNumber) FROM tbl_trans_Indent tjv WHERE dbo.RegexMatch('";
                        if (prefLen > 0)
                            sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                        else if (scheme_type == 2)
                            sqlQuery += "^";
                        sqlQuery += "[0-9]{" + (paddCounter - 1) + "}";
                        if (sufxLen > 0)
                            sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                        //sqlQuery += "?$', LTRIM(RTRIM(tjv.Indent_RequisitionNumber))) = 1";
                        sqlQuery += "?$', LTRIM(RTRIM(tjv.Indent_RequisitionNumber))) = 1 and Indent_RequisitionNumber like '" + prefCompCode + "%'";
                        if (scheme_type == 2)
                            sqlQuery += " AND CONVERT(DATE, Indent_CreatedDate) = CONVERT(DATE, GETDATE())";
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
                    sqlQuery = "SELECT Indent_RequisitionNumber FROM tbl_trans_Indent WHERE Indent_RequisitionNumber LIKE '" + manual_str.Trim() + "'";
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
        private bool Save_Record(string strIndentType, string strIndent_Id, string strRequisitionNumber, string strRequisitionDate, string strBranch, string strBranchTo,
            string strPurpose, string strCurrency,
            string strExchangeRate, int BaseCurrencyId,
            DataTable Indentdt, string ActionType, string approveStatus)
        {
            try
            {
                gridBatch.JSProperties["cpExitNew"] = null;
                gridBatch.JSProperties["cpVouvherNo"] = null;
                //if (hdn_Mode.Value == "Entry")
                //{

                //    //  Int32 schemaID = Convert.ToInt32(CmbScheme.SelectedItem.Value);
                //    string validate = checkNMakeJVCode(strRequisitionNumber.Trim(), Convert.ToInt32(CmbScheme.Value));
                //    if (validate == "outrange")
                //    {
                //        gridBatch.JSProperties["cpErrerMsg"] = "Can Not Add More Cash/Bank Voucher as Contra Scheme Exausted.<br />Update The Scheme and Try Again";
                //        //Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "alert('Can Not Add More Cash/Bank Voucher as Contra Scheme Exausted.<br />Update The Scheme and Try Again');", true);
                //        // Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('outrange')</script>");
                //        return;
                //    }
                //    else if (validate == "duplicate")
                //    {
                //        Page.ClientScript.RegisterStartupScript(GetType(), "pagecall", "<script>chkValidConta('duplicate')</script>");
                //        return;
                //    }

                //    else
                //    {

                //        strRequisitionNumber = JVNumStr;
                //        gridBatch.JSProperties["cpVouvherNo"] = JVNumStr;
                //    }
                //}
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_PurchaseIndent", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", ActionType);
                cmd.Parameters.AddWithValue("@Indent_EditId", strIndent_Id);
                cmd.Parameters.AddWithValue("@IndentType", strIndentType);
                cmd.Parameters.AddWithValue("@Indent_RequisitionNumber", strRequisitionNumber);
                cmd.Parameters.AddWithValue("@Indent_RequisitionDate", strRequisitionDate);
                cmd.Parameters.AddWithValue("@Indent_BranchIdFor", strBranch);
                cmd.Parameters.AddWithValue("@Indent_BranchIdTo", strBranchTo);
                cmd.Parameters.AddWithValue("@Indent_Purpose", strPurpose);
                cmd.Parameters.AddWithValue("@Indent_baseCurrencyId", BaseCurrencyId);
                cmd.Parameters.AddWithValue("@Indent_CurrencyId", strCurrency);
                cmd.Parameters.AddWithValue("@Indent_ExchangeRtae", strExchangeRate);
                // Code Commented By Sandip on 08032017 dut to not use this filed as it was for different purpose
                //cmd.Parameters.AddWithValue("@Indent_Status", "BR");
                // Code Commented By Sandip on 08032017 dut to not use this filed as it was for different purpose

                cmd.Parameters.AddWithValue("@Indent_Company", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@Indent_FinYear", Convert.ToString(Session["LastFinYear"]));
                cmd.Parameters.AddWithValue("@Indent_CreatedBy", Convert.ToString(Session["userid"]));

                cmd.Parameters.AddWithValue("@PurchaseIndentDetails", Indentdt);

                SqlParameter output = new SqlParameter("@ReturnValueID", SqlDbType.Int);
                output.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(output);
                #region Sandip Section For Approval Section Start
                cmd.Parameters.AddWithValue("@approveStatus", approveStatus);
                #endregion Sandip Section For Approval Section Start

                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);
                cmd.Dispose();
                con.Dispose();
                gridBatch.JSProperties["cpExitNew"] = "YES";

                gridBatch.JSProperties["cpAutoID"] = output.Value;
                //Udf Add mode

                DataTable udfTable = (DataTable)Session["UdfDataOnAdd"];
                if (udfTable != null)
                {
                    Session["UdfDataOnAdd"] = reCat.insertRemarksCategoryAddMode("BI", "BranchRequisition" + Convert.ToString(output.Value), udfTable, Convert.ToString(Session["userid"]));
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
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
                status = objMShortNameCheckingBL.CheckUnique(Convert.ToString(VoucherNo).Trim(), "0", "PurchaseIndent_Check");
            }
            return status;
        }
        protected void gridBatch_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string command = e.Parameters.Split('~')[0];


            if (command == "Edit" || command == "View")
            {
                int RowIndex = Convert.ToInt32(e.Parameters.Split('~')[1]);

                string Indent_Id = Grid_PurchaseIndent.GetRowValues(RowIndex, "Indent_Id").ToString();
                ViewState["Indent_Id"] = Indent_Id;
                Keyval_internalId.Value = "BranchRequisition" + Indent_Id;
                string Indent_BranchIdFor = "";
                DataTable PurchaseIndentEditdt = GetPurchaseIndentEditData();
                if (PurchaseIndentEditdt != null && PurchaseIndentEditdt.Rows.Count > 0)
                {
                    string Indent_RequisitionNumber = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_RequisitionNumber"]);//0
                    string Indent_RequisitionDate = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_RequisitionDate"]);//1
                    Indent_BranchIdFor = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_BranchIdFor"]);//2
                    string Indent_Purpose = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_Purpose"]);//3
                    string Indent_CurrencyId = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_CurrencyId"]);//4
                    string Indent_ExchangeRtae = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_ExchangeRtae"]);//5
                    string Indent_BranchIdTo = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_BranchIdTo"]);//7

                    txtVoucherNo.Text = Indent_RequisitionNumber.Trim();
                    gridBatch.JSProperties["cpEdit"] = Indent_RequisitionNumber + "~" + Indent_RequisitionDate + "~" + Indent_BranchIdFor + "~" + Indent_Purpose + "~" + Indent_CurrencyId
                        + "~" + Indent_ExchangeRtae + "~" + Indent_Id + "~" + Indent_BranchIdTo;
                    gridBatch.JSProperties["cpView"] = (command.ToUpper() == "VIEW") ? "1" : "0";

                }
                gridBatch.DataSource = BindBratchGrid();
                gridBatch.DataBind();
                Session["BranchIndateDetails"] = GetPurchaseIndentData().Tables[0];
                #region Sandip Section For Approval To Show Hide Save Naw and Save Exit Button
                string result = "";
                result = IsExistsDocumentInERPDocApproveStatus(Indent_Id);
                if (result != "")
                {
                    if (result == "A")
                    {
                        gridBatch.JSProperties["cpApproval"] = "A";
                    }
                    else if (result == "R")
                    {
                        gridBatch.JSProperties["cpApproval"] = "R";
                    }
                }
                else
                {
                    gridBatch.JSProperties["cpApproval"] = null;
                }
                #endregion Sandip Section For Approval To Show Hide Save Naw and Save Exit Button

                if (IsBRTransactionExist(Indent_Id))
                {
                    gridBatch.JSProperties["cpBtnVisible"] = "false";
                }
                //if (!String.IsNullOrEmpty(Convert.ToString(Session["userbranchID"])))
                //{
                //    string strdefaultBranch = Convert.ToString(Session["userbranchID"]);
                //   if(Indent_BranchIdFor.Trim()!=strdefaultBranch.Trim())
                //   {
                //       gridBatch.JSProperties["cpModifyOrNot"] = "Cannot Modify";
                //   }

                //}
            }
            #region Sandip Section For Approval Section Start
            if (command == "ApprovalEdit")
            {
                int Indent_Id = Convert.ToInt32(e.Parameters.Split('~')[1]);

                //string Indent_Id = Grid_PurchaseIndent.GetRowValues(RowIndex, "Indent_Id").ToString();
                ViewState["Indent_Id"] = Indent_Id;

                DataTable PurchaseIndentEditdt = GetPurchaseIndentEditData();
                if (PurchaseIndentEditdt != null && PurchaseIndentEditdt.Rows.Count > 0)
                {
                    string Indent_RequisitionNumber = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_RequisitionNumber"]);//0
                    string Indent_RequisitionDate = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_RequisitionDate"]);//1
                    string Indent_BranchIdFor = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_BranchIdFor"]);//2
                    string Indent_Purpose = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_Purpose"]);//3
                    string Indent_CurrencyId = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_CurrencyId"]);//4
                    string Indent_ExchangeRtae = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_ExchangeRtae"]);//5
                    string Indent_BranchIdTo = Convert.ToString(PurchaseIndentEditdt.Rows[0]["Indent_BranchIdTo"]);//7
                    txtVoucherNo.Text = Indent_RequisitionNumber.Trim();
                    gridBatch.JSProperties["cpEdit"] = Indent_RequisitionNumber + "~" + Indent_RequisitionDate + "~" + Indent_BranchIdFor + "~" + Indent_Purpose + "~" + Indent_CurrencyId
                        + "~" + Indent_ExchangeRtae + "~" + Indent_Id + "~" + Indent_BranchIdTo;

                }

                gridBatch.DataSource = BindBratchGrid();
                gridBatch.DataBind();

                Session["PurchaseIndateDetails"] = GetPurchaseIndentData().Tables[0];

                //DataTable Quotationdt = (DataTable)Session["PurchaseIndateDetails"];
                // gridBatch.DataSource = GetPurchaseIndent(Quotationdt);
                // gridBatch.DataBind();
            }


            #endregion Sandip Section For Approval Section Start
            if (command == "Display")
            {
                string IsDeleteFrom = Convert.ToString(hdfIsDelete.Value);
                if (IsDeleteFrom == "D")
                {
                    DataTable Quotationdt = (DataTable)Session["BranchIndateDetails"];
                    gridBatch.DataSource = GetBranchRequisition(Quotationdt);
                    gridBatch.DataBind();

                    gridBatch.JSProperties["cpAddNewRow"] = "AddNewRow";
                }
            }

        }
        private bool IsBRTransactionExist(string BRid)
        {
            bool IsExist = false;
            if (BRid != "" && Convert.ToString(BRid).Trim() != "")
            {
                DataTable dt = new DataTable();
                dt = objPurchaseIndentBL.CheckBRTraanaction(BRid);
                if (dt.Rows.Count > 0 && Convert.ToString(dt.Rows[0]["isexist"]) != "0")
                {
                    IsExist = true;
                }
            }

            return IsExist;
        }
        protected void Grid_PurchaseIndent_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string command = e.Parameters.Split('~')[0];
            string PurIndentID = null;
            if (Convert.ToString(e.Parameters).Contains("~"))
            {
                if (Convert.ToString(e.Parameters).Split('~')[1] != "")
                {
                    int RowIndex = Convert.ToInt32(e.Parameters.Split('~')[1]);
                    PurIndentID = Grid_PurchaseIndent.GetRowValues(RowIndex, "Indent_Id").ToString();
                }
            }
            if (command == "Delete")
            {
                int RowIndex = Convert.ToInt32(e.Parameters.Split('~')[1]);
                string Indent_BranchIdFor = Grid_PurchaseIndent.GetRowValues(RowIndex, "Indent_BranchIdFor").ToString();
                string strBranchID = Convert.ToString(Session["userbranchID"]);
                if (!IsBRTransactionExist(PurIndentID))
                {
                    string Indent_Id = Grid_PurchaseIndent.GetRowValues(RowIndex, "Indent_Id").ToString();
                    ViewState["Indent_Id"] = Indent_Id;
                    int val = GetPurchaseIndentDeleteData();
                    if (val == 1)
                    {
                        Grid_PurchaseIndent.JSProperties["cpDelete"] = "Succesfully Deleted";
                    }
                }
                else
                {
                    Grid_PurchaseIndent.JSProperties["cpDelete"] = "Transaction exist. Cannot Delete.";
                }
            }
            if (command == "Cancel")
            {
                int parCancel = objPurchaseIndentBL.CheckBRTraanactionCancel(PurIndentID);
                if (parCancel==1)
                {
                    string Reason = e.Parameters.Split('~')[2];
                    int val = GetBranchRequisitionIsCancel(PurIndentID, Reason);
                    if (val == 1)
                    {
                        Grid_PurchaseIndent.JSProperties["cpCancel"] = "Succesfully Cancel";
                    }
                }
                else
                {
                    Grid_PurchaseIndent.JSProperties["cpCancel"] = "Transaction exist. Cannot Cancel.";
                }
            }
            //FillGrid();
        }
        //private bool IsBRTransactionCancel(string BRid)
        //{
        //    bool IsExist = false;
        //    if (BRid != "" && Convert.ToString(BRid).Trim() != "")
        //    {
        //        DataTable dt = new DataTable();
        //        dt = objPurchaseIndentBL.CheckBRTraanactionCancel(BRid);
        //        if (dt.Rows.Count > 0 && Convert.ToString(dt.Rows[0]["isexist"]) != "0")
        //        {
        //            IsExist = true;
        //        }
        //    }

        //    return IsExist;
        //}
        public int GetBranchRequisitionIsCancel(string ID, string Reason)
        {
            int rtrnvalue = 0;
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseIndentDetailsList");
            proc.AddVarcharPara("@Action", 500, "BranchRequisitionCalcel");
            proc.AddIntegerPara("@Indent_Id", Convert.ToInt32(ID));
            proc.AddVarcharPara("@Reason", 1000, Reason);
            proc.AddVarcharPara("@ReturnValue", 200, "0", QueryParameterDirection.Output);
            proc.RunActionQuery();
            rtrnvalue = Convert.ToInt32(proc.GetParaValue("@ReturnValue"));
            return rtrnvalue;
        }
        public int GetPurchaseIndentDeleteData()
        {
            int rtrnvalue = 0;
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseIndentDetailsList");
            proc.AddVarcharPara("@Action", 500, "PurchaseIndentDeleteDetails");
            Int32 ID = Convert.ToInt32(ViewState["Indent_Id"]);
            proc.AddIntegerPara("@Indent_Id", ID);
            proc.AddVarcharPara("@ReturnValue", 200, "0", QueryParameterDirection.Output);
            proc.RunActionQuery();
            rtrnvalue = Convert.ToInt32(proc.GetParaValue("@ReturnValue"));
            return rtrnvalue;
        }
        public IEnumerable BindBratchGrid()
        {
            DataSet DsOnLoad = new DataSet();
            DataTable tempdt = new DataTable();
            DBEngine objEngine = new DBEngine();
            List<BratchGridLIST> BratchGridLists = new List<BratchGridLIST>();
            DataTable PurchaseIndentdt = GetPurchaseIndentData().Tables[0];
            for (int i = 0; i < PurchaseIndentdt.Rows.Count; i++)
            {
                BratchGridLIST BratchGrid_LIST = new BratchGridLIST();
                BratchGrid_LIST.SrlNo = Convert.ToString(PurchaseIndentdt.Rows[i]["SrlNo"]);
                BratchGrid_LIST.PurchaseIndentID = Convert.ToString(PurchaseIndentdt.Rows[i]["IndentDetailsId"]);
                BratchGrid_LIST.gvColProduct = Convert.ToString(PurchaseIndentdt.Rows[i]["ProductID"]);
                BratchGrid_LIST.gvColDiscription = Convert.ToString(PurchaseIndentdt.Rows[i]["Description"]);
                BratchGrid_LIST.gvColQuantity = Convert.ToString(PurchaseIndentdt.Rows[i]["Quantity"]);
                BratchGrid_LIST.gvColUOM = Convert.ToString(PurchaseIndentdt.Rows[i]["UOM"]);
                BratchGrid_LIST.gvColRate = Convert.ToString(PurchaseIndentdt.Rows[i]["Rate"]);
                BratchGrid_LIST.gvColValue = Convert.ToString(PurchaseIndentdt.Rows[i]["ValueInBaseCurrency"]);
                string ExpectedDeliveryDate = Convert.ToString(PurchaseIndentdt.Rows[i]["ExpectedDeliveryDate"]);
                if (!String.IsNullOrEmpty(ExpectedDeliveryDate))
                {
                    BratchGrid_LIST.ExpectedDeliveryDate = Convert.ToDateTime(PurchaseIndentdt.Rows[i]["ExpectedDeliveryDate"]);//8
                }
                else
                {
                    BratchGrid_LIST.ExpectedDeliveryDate = null;
                }
                BratchGrid_LIST.Status = Convert.ToString(PurchaseIndentdt.Rows[i]["Status"]);
                BratchGrid_LIST.gvColAvailableStock = Convert.ToString(PurchaseIndentdt.Rows[i]["AvailableStock"]);
                BratchGrid_LIST.ProductName = Convert.ToString(PurchaseIndentdt.Rows[i]["ProductName"]);
                BratchGridLists.Add(BratchGrid_LIST);
            }
            return BratchGridLists;
        }
        public DataSet GetPurchaseIndentData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseIndentDetailsList");
            proc.AddVarcharPara("@Action", 500, "BindBratchGrid");
            proc.AddIntegerPara("@Indent_Id", Convert.ToInt32(ViewState["Indent_Id"]));
            ds = proc.GetDataSet();
            return ds;
        }
        public DataTable GetPurchaseIndentEditData()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_PurchaseIndentDetailsList");
            proc.AddVarcharPara("@Action", 500, "PurchaseIndentEditDetails");
            proc.AddIntegerPara("@Indent_Id", Convert.ToInt32(ViewState["Indent_Id"]));
            //proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
            //proc.AddVarcharPara("@branchId", 500, Convert.ToString(Session["userbranchID"]));
            //proc.AddVarcharPara("@companyId", 500, Convert.ToString(Session["LastCompany"]));
            dt = proc.GetTable();
            return dt;
        }
        [WebMethod]
        public static String getAvilableStock(string ProductID, string LastFinYear, string Campany_ID, string BranchFor)
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            //            string query = @"select  (Stock_Open+Stock_ID)-(ISNULL(Stock_Out,0))as Available_stock,
            //            (select UOM_Name from Master_UOM where UOM_ID=Stock_QuantityUnit)as UOM_Name
            //            from Trans_Stock where Stock_ProductID='" + ProductID + "' and Stock_Company='" + Campany_ID + "' and Stock_FinYear='" + LastFinYear + "'";
            //            DataTable dt = oDBEngine.GetDataTable(query);
            string Available_Stock = "", UOM_Name = "";
            //            if (dt != null && dt.Rows.Count > 0)
            //            {
            //                Available_Stock = Convert.ToString(dt.Rows[0]["Available_stock"]);
            //                UOM_Name = Convert.ToString(dt.Rows[0]["UOM_Name"]);
            //            }
            //            return Available_Stock + " " + UOM_Name;

            DataTable dt2 = oDBEngine.GetDataTable("Select dbo.fn_CheckAvailableQuotation(" + BranchFor + ",'" + Convert.ToString(Campany_ID) + "','" + Convert.ToString(LastFinYear) + "'," + ProductID + ") as branchopenstock");

            if (dt2.Rows.Count > 0)
            {
                Available_Stock = Convert.ToString(Math.Round(Convert.ToDecimal(dt2.Rows[0]["branchopenstock"]), 2));
                return Available_Stock;
            }
            else
            {
                Available_Stock = "0.00";
                return Available_Stock;
            }

        }
        protected void Grid_PurchaseIndent_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {

            if (!rights.CanDelete)
            {
                if (e.ButtonID == "CustomBtnDelete")
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
            if (!rights.CanEdit)
            {
                if (e.ButtonID == "CustomBtnEdit")
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
            if (!rights.CanView)
            {
                if (e.ButtonID == "CustomBtnView")
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
            if (!rights.CanCancel)
            {
                if (e.ButtonID == "CustomBtnCancel")
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
           
        }
        #region Sandip Section For Approval Section Start

        #region Approval Waiting or Pending User Level Wise Section Start

        public void PopulateERPDocApprovalPendingListByUserLevel() // Checked and Modified By Sandip
        {
            DataTable dtdata = new DataTable();
            if (Session["userid"] != null)
            {
                if (Session["userbranchID"] != null)
                {
                    int userid = 0;
                    userid = Convert.ToInt32(Session["userid"]);

                    dtdata = objERPDocPendingApproval.PopulateERPDocApprovalPendingListByUserLevel(userid, "BR");
                    if (dtdata != null && dtdata.Rows.Count > 0)
                    {
                        gridPendingApproval.DataSource = dtdata;
                        gridPendingApproval.DataBind();
                        Session["BRPendingApproval"] = dtdata;  // Commented For Temporary Purpose
                    }
                    else
                    {
                        gridPendingApproval.DataSource = null;
                        gridPendingApproval.DataBind();
                    }
                }
            }
        }

        public void PopulateApprovalPendingCountByUserLevel()  // Checked and Modified By Sandip 
        {
            int userid = 0;
            if (Session["userid"] != null)
            {
                if (Session["userbranchID"] != null)
                {

                    userid = Convert.ToInt32(Session["userid"]);
                }
            }
            DataTable dtdata = new DataTable();
            dtdata = objERPDocPendingApproval.PopulateERPDocApprovalPendingCountByUserLevel(userid, "BR");
            if (dtdata != null && dtdata.Rows.Count > 0)
            {
                lblWaiting.Text = "(" + Convert.ToString(dtdata.Rows[0]["ID"]) + ")";
            }
            else
            {
                lblWaiting.Text = "";
            }
        }


        protected void gridPendingApproval_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e) // Checked and Modified By Sandip
        {
            gridPendingApproval.JSProperties["cpinsert"] = null;
            gridPendingApproval.JSProperties["cpEdit"] = null;
            gridPendingApproval.JSProperties["cpUpdate"] = null;
            gridPendingApproval.JSProperties["cpDelete"] = null;
            gridPendingApproval.JSProperties["cpExists"] = null;
            gridPendingApproval.JSProperties["cpUpdateValid"] = null;
            int userid = 0;
            if (Session["userid"] != null)
            {
                Session.Remove("BRPendingApproval");
                userid = Convert.ToInt32(Session["userid"]);
                PopulateERPDocApprovalPendingListByUserLevel();
                gridPendingApproval.JSProperties["cpEdit"] = "F";
                Session.Remove("BRUserWiseERPDocCreation");
            }
            if (Session["KeyValue"] != null)
            {
                Session.Remove("KeyValue");
            }

        }

        protected void chkapprove_Init(object sender, EventArgs e)  // Checked and Modified By Sandip
        {
            ASPxCheckBox Dcheckbox = (ASPxCheckBox)sender;
            int itemindex = (((ASPxCheckBox)sender).NamingContainer as GridViewDataItemTemplateContainer).ItemIndex;
            KeyValue = Convert.ToInt32((((ASPxCheckBox)sender).NamingContainer as GridViewDataItemTemplateContainer).KeyValue);
            Session["KeyValue"] = KeyValue;
            Dcheckbox.ClientSideEvents.CheckedChanged = String.Format("function(s, e) {{ GetApprovedQuoteId(s, e, {0}) }}", itemindex);

        }


        protected void chkreject_Init(object sender, EventArgs e) // Checked and Modified By Sandip
        {
            ASPxCheckBox Dcheckbox = (ASPxCheckBox)sender;
            int itemindex = (((ASPxCheckBox)sender).NamingContainer as GridViewDataItemTemplateContainer).ItemIndex;
            KeyValue = Convert.ToInt32((((ASPxCheckBox)sender).NamingContainer as GridViewDataItemTemplateContainer).KeyValue);
            Session["KeyValue"] = KeyValue;
            Dcheckbox.ClientSideEvents.CheckedChanged = String.Format("function(s, e) {{ GetRejectedQuoteId(s, e, {0}) }}", itemindex);

        }

        #endregion Approval Waiting or Pending User Level Wise Section End
        #region Created User Wise List Quotation after Clicking on Status Button Section Start  (call in page load)

        protected void gridUserWiseQuotation_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            PopulateUserWiseERPDocCreation();
        }
        public void PopulateUserWiseERPDocCreation()
        {
            int userid = 0;
            if (Session["userid"] != null)
            {
                if (Session["userbranchID"] != null)
                {
                    userid = Convert.ToInt32(Session["userid"]);
                }
            }
            DataTable dtdata = new DataTable();
            if (Session["BRUserWiseERPDocCreation"] == null)
            {

                dtdata = objERPDocPendingApproval.PopulateUserWiseERPDocCreation(userid, "BR");
            }
            else
            {
                dtdata = (DataTable)Session["BRUserWiseERPDocCreation"];
            }
            if (dtdata != null && dtdata.Rows.Count > 0)
            {
                gridUserWiseQuotation.DataSource = dtdata;
                gridUserWiseQuotation.DataBind();
                Session["BRUserWiseERPDocCreation"] = dtdata;
            }
            else
            {
                gridUserWiseQuotation.DataSource = null;
                gridUserWiseQuotation.DataBind();
            }

        }
        #endregion #region Created User Wise List Quotation after Clicking on Status Button Section End


        #region To Show Hide Status and Pending Approval Button Configuration Wise Start
        public void ConditionWiseShowStatusButton()
        {
            int i = 0;
            int j = 0;
            int k = 0;
            int branchid = 0;
            if (Session["userbranchID"] != null)
            {
                branchid = Convert.ToInt32(Session["userbranchID"]);
            }
            //Session["userbranchHierarchy"])

            #region Sam Section For Showing Status and Approval waiting Button on 22052017
            j = objERPDocPendingApproval.ConditionWiseShowApprovalStatusButton(11, Convert.ToString(Session["userbranchHierarchy"]), Convert.ToString(Session["userid"]), "BR");

            if (j == 1)
            {
                spanStatus.Visible = true;
            }
            else
            {
                spanStatus.Visible = false;
            }


            k = objERPDocPendingApproval.ConditionWiseShowApprovalPendingButton(11, Convert.ToString(Session["userbranchHierarchy"]), Convert.ToString(Session["userid"]), "BR");

            if (k == 1)
            {
                divPendingWaiting.Visible = true;
            }
            else
            {
                divPendingWaiting.Visible = false;
            }



            #endregion Sam Section For Showing Status and Approval waiting Button on 22052017
            // Cross Branch Section by Sam on 10052017 Start  
            //i = objERPDocPendingApproval.ConditionWiseShowApprovalDtlStatusButton(8, branchid, Convert.ToString(Session["userid"]), "PB");  // Entity Id 8 For Purchase Invoice
            ////i = objERPDocPendingApproval.ConditionWiseShowApprovalDtlStatusButton(8, branchid, Convert.ToString(Session["userid"]), "PB");  // 7 for Purchase Order Module 
            ////i = objERPDocPendingApproval.ConditionWiseShowStatusButton(8, branchid, Convert.ToString(Session["userid"])); //Entity Id 8 For Purchase Invoice
            //// Cross Branch Section by Sam on 10052017 End 
            //if (i == 1)
            //{
            //    spanStatus.Visible = true;
            //    divPendingWaiting.Visible = true;
            //}
            //else if (i == 2)
            //{
            //    spanStatus.Visible = false;
            //    divPendingWaiting.Visible = true;
            //}
            //else
            //{
            //    spanStatus.Visible = false;
            //    divPendingWaiting.Visible = false;
            //}
        }

        #endregion To Show Hide Status and Pending Approval Button Configuration Wise End
        //#region To Show Hide Status and Pending Approval Button Configuration Wise Start
        ////public void ConditionWiseShowStatusButton()
        ////{
        ////    int i = 0;
        ////    int branchid = 0;
        ////    if (Session["userbranchID"] != null)
        ////    {
        ////        branchid = Convert.ToInt32(Session["userbranchID"]);
        ////    }

        ////    i = objERPDocPendingApproval.ConditionWiseShowStatusButton(6, branchid, Convert.ToString(Session["userid"]));  // 6 for Purchase Indent Module 
        ////    if (i == 1)
        ////    {
        ////        spanStatus.Visible = true;
        ////        divPendingWaiting.Visible = true;
        ////    }
        ////    else
        ////    {
        ////        spanStatus.Visible = false;
        ////        divPendingWaiting.Visible = false;
        ////    }
        ////}
        //public void ConditionWiseShowStatusButton()
        //{
        //    int i = 0;
        //    int branchid = 0;
        //    if (Session["userbranchID"] != null)
        //    {
        //        branchid = Convert.ToInt32(Session["userbranchID"]);
        //    }
        //    i = objERPDocPendingApproval.ConditionWiseShowApprovalDtlStatusButton(6, branchid, Convert.ToString(Session["userid"]), "BR");  // 7 for Purchase Order Module 
        //    //i = objERPDocPendingApproval.ConditionWiseShowStatusButton(6, branchid, Convert.ToString(Session["userid"]));  // 6 for Purchase Indent Module 
        //    if (i == 1)
        //    {
        //        spanStatus.Visible = true;
        //        divPendingWaiting.Visible = true;
        //    }
        //    else if (i == 2)
        //    {
        //        spanStatus.Visible = false;
        //        divPendingWaiting.Visible = true;
        //    }
        //    else
        //    {
        //        spanStatus.Visible = false;
        //        divPendingWaiting.Visible = false;
        //    }
        //}

        //#endregion To Show Hide Status and Pending Approval Button Configuration Wise End

        #region After Approval Or rejected Number to reflect of Pending Approval Section  Start

        [WebMethod]
        public static string GetPendingCase()
        {
            string strPending = "(0)";

            ERPDocPendingApprovalBL objERPDocPendingApproval = new ERPDocPendingApprovalBL();
            int userid = Convert.ToInt32(HttpContext.Current.Session["userid"]);
            //int userlevel = objCRMSalesDtlBL.GetUserLevelByUserID(userid);

            DataTable dtdata = new DataTable();
            dtdata = objERPDocPendingApproval.PopulateERPDocApprovalPendingCountByUserLevel(userid, "BR");
            if (dtdata != null && dtdata.Rows.Count > 0)
            {
                strPending = "(" + Convert.ToString(dtdata.Rows[0]["ID"]) + ")";
            }

            return strPending;
        }

        #endregion After Approval Or rejected Number to reflect of Pending Approval Section  End

        public string IsExistsDocumentInERPDocApproveStatus(string id)
        {
            string result = "";

            string editable = "";
            string status = "";
            DataTable dt = new DataTable();
            int quoteid = Convert.ToInt32(id);
            dt = objERPDocPendingApproval.IsExistsDocumentInERPDocApproveStatus(quoteid, 11);  // 11 For Branch Requisition
            if (dt.Rows.Count > 0)
            {
                editable = Convert.ToString(dt.Rows[0]["editable"]);
                if (editable == "0")
                {

                    lbl_quotestatusmsg.Visible = true;
                    status = Convert.ToString(dt.Rows[0]["Status"]);
                    if (status == "Approved")
                    {
                        result = "A";
                        lbl_quotestatusmsg.Text = "Document already Approved";

                    }
                    if (status == "Rejected")
                    {
                        result = "R";
                        lbl_quotestatusmsg.Text = "Document already Rejected";

                    }
                    btnnew.Visible = false;
                    btnSaveExit.Visible = false;
                }
                else
                {
                    result = "X";
                    lbl_quotestatusmsg.Visible = false;
                    btnnew.Visible = true;
                    btnSaveExit.Visible = true;
                }
                return result;
            }
            else
            {
                return result;
            }
        }

        #endregion Sandip Section For Approval Dtl Section End
        protected void acpAvailableStock_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string performpara = e.Parameter;
            string strProductID = Convert.ToString(performpara.Split('~')[0]);
            string strBranch = Convert.ToString(ddlBranch.SelectedValue);
            string strBranchTo = Convert.ToString(ddlBranchTo.Value);
            acpAvailableStock.JSProperties["cpstock"] = "0.00";

            try
            {
                if (strBranchTo != "0")
                {
                    DataTable dtTo = oDBEngine.GetDataTable("Select dbo.fn_CheckAvailableQuotation(" + strBranchTo + ",'" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]) + "'," + strProductID + ") as branchopenstock");

                    if (dtTo.Rows.Count > 0)
                    {
                        acpAvailableStock.JSProperties["cpstockBranchTo"] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTo.Rows[0]["branchopenstock"]), 2));
                    }
                    else
                    {
                        acpAvailableStock.JSProperties["cpstockBranchTo"] = "0.00";
                    }
                }
                DataTable dt2 = oDBEngine.GetDataTable("Select dbo.fn_CheckAvailableQuotation(" + strBranch + ",'" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]) + "'," + strProductID + ") as branchopenstock");

                if (dt2.Rows.Count > 0)
                {
                    acpAvailableStock.JSProperties["cpstock"] = Convert.ToString(Math.Round(Convert.ToDecimal(dt2.Rows[0]["branchopenstock"]), 2));
                }
                else
                {
                    acpAvailableStock.JSProperties["cpstock"] = "0.00";
                }
            }
            catch (Exception ex)
            {
            }
        }
        protected void acbpCrpUdf_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (hdn_Mode.Value == "Entry")
            {
                if (reCat.isAllMandetoryDone((DataTable)Session["UdfDataOnAdd"], "BI") == false)
                {
                    acbpCrpUdf.JSProperties["cpUDFBI"] = "false";

                }
                else
                {
                    acbpCrpUdf.JSProperties["cpUDFBI"] = "true";
                }
            }
            else
            {
                acbpCrpUdf.JSProperties["cpUDFBI"] = "true";
            }
        }
        protected void ddlBranchTo_Callback(object sender, CallbackEventArgsBase e)
        {
            string branchFrom = e.Parameter.Split('~')[0];

            Bind_BranchTo(branchFrom);
            if (e.Parameter.Split('~').Length > 1)
            {
                string branchTo = e.Parameter.Split('~')[1];
                ddlBranchTo.Value = branchTo;
            }
        }
        protected void Grid_PurchaseIndent_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
          //  if (e.RowType != GridViewRowType.Data) return;
            string strdefaultBranch = Convert.ToString(Session["userbranchID"]);

            if (e.GetValue("Indent_branch") != strdefaultBranch)
            {
                // e.Row.Cells[6].Visible = false;
            }
            string available = Convert.ToString(e.GetValue("IsCancel"));
            if (available.ToUpper() == "TRUE")
            {
                e.Row.ForeColor = System.Drawing.Color.Red;


            }
            else
            {
                e.Row.ForeColor = System.Drawing.Color.Black;
            }
                
        }
        protected void SelectPanel_Callback(object sender, CallbackEventArgsBase e)
        {
            string strSplitCommand = e.Parameter.Split('~')[0];
            if (strSplitCommand == "Bindalldesignes")
            {
                string[] filePaths = new string[] { };
                string DesignPath = "";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\BranchRequisition\DocDesign\Designes";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\BranchRequisition\DocDesign\Designes";
                }
                string fullpath = Server.MapPath("~");
                fullpath = fullpath.Replace("ERP.UI\\", "");
                string DesignFullPath = fullpath + DesignPath;
                filePaths = System.IO.Directory.GetFiles(DesignFullPath, "*.repx");

                foreach (string filename in filePaths)
                {
                    string reportname = Path.GetFileNameWithoutExtension(filename);
                    string name = "";
                    if (reportname.Split('~').Length > 1)
                    {
                        name = reportname.Split('~')[0];
                    }
                    else
                    {
                        name = reportname;
                    }
                    string reportValue = reportname;
                    CmbDesignName.Items.Add(name, reportValue);
                }
                CmbDesignName.SelectedIndex = 0;
            }
            else
            {
                string DesignPath = @"Reports\Reports\REPXReports";
                string fullpath = Server.MapPath("~");
                fullpath = fullpath.Replace("ERP.UI\\", "");
                string filename = @"\RepxReportViewer.aspx";
                string DesignFullPath = fullpath + DesignPath + filename;

                string reportName = Convert.ToString(CmbDesignName.Value);
                SelectPanel.JSProperties["cpSuccess"] = "Success";
            }
        }
        protected void gridPendingApproval_PageIndexChanged(object sender, EventArgs e)
        {
            PopulateERPDocApprovalPendingListByUserLevel();
        }
        protected void gridUserWiseQuotation_PageIndexChanged(object sender, EventArgs e)
        {
            PopulateUserWiseERPDocCreation();
        }

    }

}
