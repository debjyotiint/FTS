using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BusinessLogicLayer;
using DevExpress.XtraPrinting;
using DevExpress.Export;
using System.Drawing;

namespace Reports.Reports.GridReports
{
    public partial class CombinedSalePurchaseReport : System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        static string globalBranchHierachyIds = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Remove("dt_CombineSalePurchaseRpt");
                DateTime dtTo = DateTime.Now;
                DateTime dtFrom = DateTime.Now;
                ASPxFromDate.Text = dtFrom.ToString("dd-MM-yyyy");
                ASPxToDate.Text = dtTo.ToString("dd-MM-yyyy");
               // Date_finyearwise(Convert.ToString(Session["LastFinYear"]));
                fnBindBranch();

               // checkcateg(Convert.ToString(ddlCriteria.SelectedValue));
            }
        }

         public void checkcateg(string criteria)
        {
            if (criteria == "Class-Category-Wise")
             {
                 ShowGrid.Columns["Class Name"].VisibleIndex = 2;
                 ShowGrid.Columns["Category Name"].VisibleIndex = 3;
                 ShowGrid.Columns["Purchase Value"].Visible = false;
                 ShowGrid.Columns["Sale Value"].Visible = true;
             }
            else if (criteria == "Category-Class Wise")
            {
                ShowGrid.Columns["Class Name"].VisibleIndex = 3;
                ShowGrid.Columns["Category Name"].VisibleIndex = 2;
                ShowGrid.Columns["Sale Value"].Visible = false;
                ShowGrid.Columns["Purchase Value"].Visible = true;
            }

        }
        public void Date_finyearwise(string Finyear)
        {
            CommonBL bll1 = new CommonBL();
            DataTable stbill = new DataTable();
            stbill = bll1.GetDateFinancila(Finyear);
            if (stbill.Rows.Count > 0)
            {
                ASPxFromDate.Text = Convert.ToDateTime(stbill.Rows[0]["FinYear_StartDate"]).ToString("dd-MM-yyyy");
                ASPxToDate.Text = Convert.ToDateTime(stbill.Rows[0]["FinYear_EndDate"]).ToString("dd-MM-yyyy");
            }

        }
        protected void Grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            ShowGrid.DataSource = null;
            Session.Remove("dt_CombineSalePurchaseRpt");

            ShowGrid.JSProperties["cpSave"] = null;


            string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

            DateTime dtFrom;
            dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
            string FROMDATE = dtFrom.ToString("yyyy-MM-dd");

            DateTime dtTo;
            dtTo = Convert.ToDateTime(ASPxToDate.Date);
            string TODATE = dtTo.ToString("yyyy-MM-dd");

            string Branch_ID = string.Empty;
            string BranchList = "";
            List<object> QuoList1 = lookup_branch.GridView.GetSelectedFieldValues("branch_id");
            foreach (object Quo in QuoList1)
            {
                BranchList += "," + Quo;
            }
            Branch_ID = BranchList.TrimStart(',');

            string TransType = Convert.ToString(ddlisdocument.SelectedValue);
            if (TransType == "Sales")
            {
                TransType = "SALE";
            }
            else
            {
                TransType = "PURCHASE";
            }
            string Criteria = Convert.ToString(ddlCriteria.SelectedValue);
            Task PopulateStockTrialDataTask = new Task(() => GetCombinedSalePurchase(FROMDATE, TODATE, Branch_ID, TransType, Criteria));
            PopulateStockTrialDataTask.RunSynchronously();
         
        }

        private void GetCombinedSalePurchase(string FromDate, string TODATE, string BranchId, string TransType, string Criteria)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                if (Criteria == "Class-Category-Wise")
                {
                                   
                    SqlCommand cmd = new SqlCommand("prc_ClassCategorySalePurchase_Report", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                    cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                    cmd.Parameters.AddWithValue("@BRANCHID", string.IsNullOrEmpty(BranchId) ? string.Empty : BranchId);
                    cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                    cmd.Parameters.AddWithValue("@TODATE", TODATE);
                    cmd.Parameters.AddWithValue("@TRAN_TYPE", TransType);
                   

                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    cmd.Dispose();
                    
                }
                else if (Criteria == "Category-Class Wise")
                {

                    //DataSet ds = new DataSet();
                    //SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                    SqlCommand cmd = new SqlCommand("prc_CategoryClassSalePurchase_Report", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                    cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                    cmd.Parameters.AddWithValue("@BRANCHID", string.IsNullOrEmpty(BranchId) ? string.Empty : BranchId);
                    cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                    cmd.Parameters.AddWithValue("@TODATE", TODATE);
                    cmd.Parameters.AddWithValue("@TRAN_TYPE", TransType);


                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    cmd.Dispose();
                    

                }
                con.Dispose();

                Session["dt_CombineSalePurchaseRpt"] = ds.Tables[0];
                ShowGrid.Columns.Clear();
                ShowGrid.DataSource = ds.Tables[0];
                ShowGrid.DataBind();
               
            }
            catch (Exception ex)
            {
            }
        }

        protected void Showgrid_DataBinding(object sender, EventArgs e)
        {

            if (Session["dt_CombineSalePurchaseRpt"] != null)
            {
                ShowGrid.DataSource = (DataTable)Session["dt_CombineSalePurchaseRpt"];
            }
            else
            {
                ShowGrid.DataSource = null;
            }
        }
        protected void Showgrid_DataBound(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            foreach (GridViewDataColumn c in grid.Columns)
            {
                if ((c.FieldName.ToString()).StartsWith("BrandID"))
                {
                    c.Visible = false;
                }
                if ((c.FieldName.ToString()).StartsWith("ClassID"))
                {
                    c.Visible = false;
                }

                if ((c.FieldName.ToString()).StartsWith("Sl_No"))
                {
                    c.Caption = "Sl.";
                    c.Width = 75;
                }

                if ((c.FieldName.ToString()).StartsWith("Class Name"))
                {
                    c.Width = 350;
                }

                if ((c.FieldName.ToString()).StartsWith("Category Name"))
                {
                    c.Width = 350;
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

                    bindexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    bindexport(Filter);
                }

                drdExport.SelectedValue = "0";
            }

        }

        public void bindexport(int Filter)
        {
            string filename = "Groupwise Sales Purchase Report";
            exporter.FileName = filename;

            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();
            string FileHeader = "";
            FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "Groupwise Sales/Purchase Report" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
            exporter.PageHeader.Left = FileHeader;
            exporter.PageHeader.Font.Size = 10;
            exporter.PageHeader.Font.Name = "Tahoma";

            //exporter.PageFooter.Center = "[Page # of Pages #]";
            //exporter.PageFooter.Right = "[Date Printed]";
            exporter.Landscape = true;
            exporter.MaxColumnWidth = 100;
            exporter.GridViewID = "ShowGrid";
            exporter.RenderBrick += exporter_RenderBrick;
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

        protected void exporter_RenderBrick(object sender, ASPxGridViewExportRenderingEventArgs e)
        {
            e.BrickStyle.BackColor = Color.White;
            e.BrickStyle.ForeColor = Color.Black;
        }

        protected void ShowGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);
        }

        protected void Showgrid_Htmlprepared(object sender, EventArgs e)
        {

        }

       

        private void fnBindBranch()
        {
            DataTable ComponentTable = new DataTable();
            if (Session["userbranchHierarchy"] != null)
            {
                ComponentTable = oDBEngine.GetDataTable("SELECT DISTINCT A.branch_id,A.branch_code,A.branch_description FROM tbl_master_branch A, tbl_master_branch B WHERE A.branch_id=B.branch_parentId ORDER BY A.branch_id asc");
            }
            if (ComponentTable.Rows.Count > 0)
            {
                lookup_branch.DataSource = ComponentTable;
                lookup_branch.DataBind();
            }
            else
            {
                lookup_branch.DataSource = null;
                lookup_branch.DataBind();
            }
        }
        protected void lookup_branch_DataBinding(object sender, EventArgs e)
        {
            DataTable ComponentTable = oDBEngine.GetDataTable("SELECT DISTINCT A.branch_id,A.branch_code,A.branch_description FROM tbl_master_branch A, tbl_master_branch B WHERE A.branch_id=B.branch_parentId ORDER BY A.branch_id asc");

            if (ComponentTable.Rows.Count > 0)
            {
                lookup_branch.DataSource = ComponentTable;
            }
            else
            {
                lookup_branch.DataSource = null;
            }
        }

        private DataTable fnGetFinancier(string branchIds)
        {
            DataTable ComponentTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
            {
                SqlCommand cmd = new SqlCommand("GetCustomerDropdownBind_DebtorsReport", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@BranchIds", branchIds);
                cmd.Parameters.AddWithValue("@Action", "FinancierBind");
                cmd.CommandTimeout = 0;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ComponentTable);

                cmd.Dispose();
                con.Dispose();
            }
            return ComponentTable;
        }
   
        private DataTable fnGetCustomer(string branchIds)
        {
            DataTable ComponentTable = new DataTable();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
            {
                SqlCommand cmd = new SqlCommand("GetCustomerDropdownBind_DebtorsReport", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@BranchIds", branchIds);
                cmd.Parameters.AddWithValue("@Action", "CustomerBind");
                cmd.CommandTimeout = 0;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ComponentTable);

                cmd.Dispose();
                con.Dispose();
            }
            return ComponentTable;
        }
       
    
        private string GetBranchHierachyIds(string branchParam)
        {
            string branchHierarchy = string.Empty;

            var strBranchIds = Convert.ToString(branchParam).Split(',');

            foreach (string data in strBranchIds)
            {
                if (!string.IsNullOrEmpty(data))
                {
                    branchHierarchy = branchHierarchy + ",";
                    branchHierarchy = oDBEngine.getBranch(data, "") + data;
                }
            }

            branchHierarchy = branchHierarchy.TrimStart(',');
            return branchHierarchy;
        }

        protected void ddlCriteria_SelectedIndexChanged(object sender, EventArgs e)
        {
            //checkcateg(Convert.ToString(ddlCriteria.SelectedValue));
        }
    }
}