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
using DevExpress.XtraPrinting;
using DevExpress.Export;
using System.Drawing;

namespace Reports.Reports.GridReports
{
    public partial class CombineStockTrial : System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Remove("dt_CombineStockTrailRpt");
                Session.Remove("dt_CombineStockTrailRptLeve2");
                Session.Remove("dt_CombineStockTrailRptLeve3");
                lookupClass.DataSource = GetClassList();
                lookupClass.DataBind();

                lookupBrand.DataSource = GetBrandList();
                lookupBrand.DataBind();

                string strFinYear = Convert.ToString(Session["LastFinYear"]);
                DataTable dt = oDBEngine.GetDataTable("Select FinYear_Code,FinYear_StartDate,FinYear_EndDate From Master_FinYear Where FinYear_Code='" + strFinYear + "'");
                if (dt != null && dt.Rows.Count > 0)
                {
                    //string strStartDate = Convert.ToString(dt.Rows[0]["FinYear_StartDate"]);
                    //DateTime StartDate = Convert.ToDateTime(strStartDate);
                    //ASPxFromDate.Value = StartDate;

                    //string strEndDate = Convert.ToString(dt.Rows[0]["FinYear_EndDate"]);
                    //DateTime EndDate = Convert.ToDateTime(strEndDate);
                    //ASPxToDate.Value = EndDate;

                    ASPxFromDate.Value = DateTime.Now;
                    ASPxToDate.Value = DateTime.Now;
                }
                else
                {
                    ASPxFromDate.Value = DateTime.Now;
                    ASPxToDate.Value = DateTime.Now;
                }
            }
        }

        #region #### I/P Parameters Binding ####

        private DataTable GetClassList()
        {
            try
            {
                DataTable dt = oDBEngine.GetDataTable("Select ProductClass_ID,ProductClass_Name From Master_ProductClass Order By ProductClass_Name Asc");
                return dt;
            }
            catch
            {
                return null;
            }
        }
        private DataTable GetBrandList()
        {
            try
            {
                DataTable dt = oDBEngine.GetDataTable("Select Brand_Id,Brand_Name From tbl_master_brand Where Brand_IsActive=1 Order By Brand_Name Asc");
                return dt;
            }
            catch
            {
                return null;
            }
        }
        #endregion

        #region Lookup Details

        protected void lookupClass_DataBinding(object sender, EventArgs e)
        {
            lookupClass.DataSource = GetClassList();
        }
        protected void lookupBrand_DataBinding(object sender, EventArgs e)
        {
            lookupBrand.DataSource = GetBrandList();
        }

        #endregion

        #region #### Grid Details #####

        protected void Grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_CombineStockTrailRpt");

            ShowGrid.JSProperties["cpSave"] = null;


            string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

            DateTime dtFrom;
            dtFrom = Convert.ToDateTime(ASPxFromDate.Date);

            string FROMDATE = dtFrom.ToString("yyyy-MM-dd");

            DateTime dtTo;
            dtTo = Convert.ToDateTime(ASPxToDate.Date);

            string TODATE = dtTo.ToString("yyyy-MM-dd");

            string Class_Ids = string.Empty;
            string Brand_Ids = string.Empty;

            string ClassList = "";
            if (hflookupClassAllFlag.Value.ToUpper() != "ALL")
            {
                List<object> QuoList1 = lookupClass.GridView.GetSelectedFieldValues("ProductClass_ID");
                foreach (object Quo in QuoList1)
                {
                    ClassList += "," + Quo;
                }
                Class_Ids = ClassList.TrimStart(',');
            }

            string BrandList = "";
            if (hflookupBrandAllFlag.Value.ToUpper() != "ALL")
            {
                List<object> QuoList2 = lookupBrand.GridView.GetSelectedFieldValues("Brand_Id");
                foreach (object Quo in QuoList2)
                {
                    BrandList += "," + Quo;
                }
                Brand_Ids = BrandList.TrimStart(',');
            }

            string TransType = Convert.ToString(ddlisdocument.SelectedValue);

            Task PopulateStockTrialDataTask = new Task(() => GetCombineStockTrail(FROMDATE, TODATE, Brand_Ids, Class_Ids, TransType));
            PopulateStockTrialDataTask.RunSynchronously();
        }

        protected void Showgrid_DataBound(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            foreach (GridViewDataColumn c in grid.Columns)
            {
                if ((c.FieldName.ToString()).StartsWith("sProducts_ID"))
                {
                    c.Visible = false;
                }
                
                if ((c.FieldName.ToString()).StartsWith("Sl No"))
                {
                    c.Width = 75;
                }

                if ((c.FieldName.ToString()).StartsWith("Class"))
                {
                    c.Width = 200;
                }

                if ((c.FieldName.ToString()).StartsWith("Particulars"))
                {
                    c.Width = 350;
                }
                
                //if ((c.FieldName.ToString()).StartsWith("sProducts_Description"))
                //{
                //    c.Caption = "Product";
                //}
            }
        }

        private void GetCombineStockTrail(string FromDate, string ToDate, string BrandIds, string ClassIds, string TransType)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                if (TransType == "All")
                {
                    SqlCommand cmd = new SqlCommand("PROC_COMBINDSTOCKTRIALBRANDCLASS_REPORT", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                    cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                    cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                    cmd.Parameters.AddWithValue("@TODATE", ToDate);
                    cmd.Parameters.AddWithValue("@BRAND_ID", BrandIds);
                    cmd.Parameters.AddWithValue("@CLASS", ClassIds);

                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);
                    cmd.Dispose();
                }
                else
                {
                    SqlCommand cmd = new SqlCommand("prc_COMBINEDITEMWISESALESPURCHASE_REPORT", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                    cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                    cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                    cmd.Parameters.AddWithValue("@TODATE", ToDate);
                    cmd.Parameters.AddWithValue("@CLASS", ClassIds);
                    cmd.Parameters.AddWithValue("@CATEGORY", BrandIds);
                    cmd.Parameters.AddWithValue("@TRANTYPE", TransType);

                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);
                    cmd.Dispose();
                }
                
                con.Dispose();

                Session["dt_CombineStockTrailRpt"] = ds.Tables[0];
                ShowGrid.Columns.Clear();
                ShowGrid.DataSource = ds.Tables[0];
                ShowGrid.DataBind();
            }
            catch (Exception ex)
            {
            }
        }

        protected void grid2_DataBinding(object sender, EventArgs e)
        {

            if (Session["dt_CombineStockTrailRpt"] != null)
            {
                ShowGrid.DataSource = (DataTable)Session["dt_CombineStockTrailRpt"];
            }
            else
            {
                ShowGrid.DataSource = null;
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
            string filename = "Combined Stock Trial Report";
            string FileHeader = "";

            exporter.FileName = filename;

            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "Combined Stock Trial Report" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");

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

        #endregion

        #region ##### 2nd Level Grid Details #########
        protected void ShowGridDetails2Level_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string _ProductID = Convert.ToString(e.Parameters);

            if (!string.IsNullOrEmpty(_ProductID))
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

                string TransType = Convert.ToString(ddlisdocument.SelectedValue);

              //  ShowGridDetails2Level.DataSource = GetCombineStockTrail2ndLevel(FROMDATE, TODATE, _ProductID, TransType);

                DataTable dt = new DataTable();
                dt = GetCombineStockTrail2ndLevel(FROMDATE, TODATE, _ProductID, TransType);

                Session["dt_CombineStockTrailRptLeve2"] = dt;
                

                if (Session["dt_CombineStockTrailRptLeve2"] != null)
                {
                   // DataTable dt = (DataTable)Session["dt_CombineStockTrailRptLeve2"];
                    if (dt.Rows.Count > 0)
                    {
                        ShowGridDetails2Level.JSProperties["cpProductCode"] = Convert.ToString(dt.Rows[0]["sProducts_Code"]);
                        ShowGridDetails2Level.JSProperties["cpProductDesc"] = Convert.ToString(dt.Rows[0]["Particulars"]);
                        ShowGridDetails2Level.JSProperties["cpFromDate"] = dtFrom.ToString("dd-MM-yyyy");
                        ShowGridDetails2Level.JSProperties["cpToDate"] = dtTo.ToString("dd-MM-yyyy");
                    }
                }

                ShowGridDetails2Level.DataSource = dt;
                ShowGridDetails2Level.DataBind();

            }
        }

        protected void ShowGridDetails2Level_DataBound(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            foreach (GridViewDataColumn c in grid.Columns)
            {
                if ((c.FieldName.ToString()).StartsWith("SL"))
                {                   
                    //c.Visible = false;
                    c.Width = 0;
                }

                if ((c.FieldName.ToString()).StartsWith("sProducts_ID"))
                {
                    //c.Visible = false;
                    c.Width = 0;
                }

                if ((c.FieldName.ToString()).StartsWith("sProducts_Code"))
                {
                    //c.Visible = false;
                    c.Width = 0;
                }

                if ((c.FieldName.ToString()).StartsWith("branch_id"))
                {
                    //c.Visible = false;
                    c.Width = 0;
                }

                //if ((c.FieldName.ToString()).StartsWith("Branch"))
                //{
                //    c.Width = 100;
                //}

                //if ((c.FieldName.ToString()).StartsWith("Particulars"))
                //{
                //    c.Width = 200;
                //}

                //if ((c.FieldName.ToString()).StartsWith("Opening"))
                //{
                //    c.Width = 100;
                //}

                //if ((c.FieldName.ToString()).StartsWith("Received"))
                //{
                //    c.Width = 100;
                //}

                //if ((c.FieldName.ToString()).StartsWith("Issue"))
                //{
                //    c.Width = 100;
                //}

                //if ((c.FieldName.ToString()).StartsWith("Closing"))
                //{
                //    c.Width = 100;
                //}
            }
        }

        private DataTable GetCombineStockTrail2ndLevel(string FromDate, string ToDate, string ProductID, string TransType)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                if (TransType == "All")
                {
                    SqlCommand cmd = new SqlCommand("PROC_BRANCHWISESTOCKTRIAL_REPORT", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                    cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                    cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                    cmd.Parameters.AddWithValue("@TODATE", ToDate);
                    cmd.Parameters.AddWithValue("@PRODUCT_ID", ProductID);

                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    cmd.Dispose();
                    con.Dispose();
                }
                else
                {
                    SqlCommand cmd = new SqlCommand("prc_COMBINEDBRANCHWISESALESPURCHASE_REPORT", con);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                    cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                    cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                    cmd.Parameters.AddWithValue("@TODATE", ToDate);
                    cmd.Parameters.AddWithValue("@PRODUCT_ID", ProductID);
                    cmd.Parameters.AddWithValue("@TRANTYPE", TransType);

                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    cmd.Dispose();
                    con.Dispose();
                }

                //Session["dt_CombineStockTrailRptLeve2"] = ds.Tables[0];
                ShowGridDetails2Level.Columns.Clear();

                //ShowGridDetails2Level.DataSource = ds.Tables[0];
                //ShowGridDetails2Level.DataBind();

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


        protected void ddldetails_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(ddldetails.SelectedItem.Value));
            if (Filter != 0)
            {
                bindexport_Details(Filter);
            }
        }

        public void bindexport_Details(int Filter)
        
        {            
            //if (Convert.ToString(ddlisdocument.SelectedValue) == "All")
            //{
                ShowGridDetails2Level.Columns[0].Visible = false;
                ShowGridDetails2Level.Columns[1].Visible = false;
                ShowGridDetails2Level.Columns[2].Visible = false;
                ShowGridDetails2Level.Columns[3].Visible = false;
      
            //}

        //    ShowGridDetails2Level.DataBind();
            string filename = "Combine Stock Trial 2nd Level Report";
            exporterDetails.FileName = filename;
            exporterDetails.FileName = "Combine Stock Trial 2nd Level Report";

            exporterDetails.PageHeader.Left = "Combine Stock Trial 2nd Level Report";
            exporterDetails.PageFooter.Center = "[Page # of Pages #]";
            exporterDetails.PageFooter.Right = "[Date Printed]";
            exporterDetails.GridViewID = "ShowGridDetails2Level";
            switch (Filter)
            {
                case 1:
                    exporterDetails.WritePdfToResponse();
                    break;
                case 2:
                    exporterDetails.WriteXlsToResponse();
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

        #region ##### 3rd Level Grid Details #########
        protected void ShowGridDetails3Level_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string _ProductID = Convert.ToString(e.Parameters).Split('~')[0];
            string _BranchID = Convert.ToString(e.Parameters).Split('~')[1];

            if (!string.IsNullOrEmpty(_ProductID) && !string.IsNullOrEmpty(_BranchID))
            {
                Session.Remove("dt_CombineStockTrailRptLeve3");
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

                DateTime dtFrom;
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");

                DateTime dtTo;
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string TODATE = dtTo.ToString("yyyy-MM-dd");

                string TransType = Convert.ToString(ddlisdocument.SelectedValue);

                ShowGridDetails3Level.DataSource = GetCombineStockTrail3rdLevel(FROMDATE, TODATE, _ProductID, _BranchID, "F", TransType);
                ShowGridDetails3Level.DataBind();
                

            }
        }

        private DataTable GetCombineStockTrail3rdLevel(string FromDate, string ToDate, string ProductID, string BranchID, string ValType, string TransType)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                //SqlCommand cmd = new SqlCommand("prc_ProductValuationDetail_Report", con);
                SqlCommand cmd = new SqlCommand("prc_StockLedger_Report", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                cmd.Parameters.AddWithValue("@FROMDATE", FromDate);
                cmd.Parameters.AddWithValue("@TODATE", ToDate);
                cmd.Parameters.AddWithValue("@BRANCHID", BranchID);
                cmd.Parameters.AddWithValue("@PRODUCT_ID", ProductID);                
                cmd.Parameters.AddWithValue("@VAL_TYPE", ValType);
                cmd.Parameters.AddWithValue("@TRANTYPE", TransType);

                cmd.CommandTimeout = 0;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ds);

                cmd.Dispose();
                con.Dispose();

                Session["dt_CombineStockTrailRptLeve3"] = ds.Tables[0];

                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        protected void ShowGridDetails3Level_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_CombineStockTrailRptLeve3"] != null)
            {
                ShowGridDetails3Level.DataSource = (DataTable)Session["dt_CombineStockTrailRptLeve3"];
            }
            else
            {
                ShowGridDetails3Level.DataSource = null;
            }
        }

        protected void ShowGridDetails3Level_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
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
            string filename = "Combine Stock Trial 2nd Level Report";
            exporterDetails.FileName = filename;
            exporterDetails.FileName = "Combine Stock Trial 3rd Level Report";

            exporterDetails.PageHeader.Left = "Combine Stock Trial 3rd Level Report";
            exporterDetails.PageFooter.Center = "[Page # of Pages #]";
            exporterDetails.PageFooter.Right = "[Date Printed]";
            exporterDetails.GridViewID = "ShowGridDetails3Level";
            switch (Filter)
            {
                case 1:
                    exporterDetails.WritePdfToResponse();
                    break;
                case 2:
                    exporterDetails.WriteXlsToResponse();
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




    }
}