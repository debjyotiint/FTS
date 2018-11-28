﻿using DevExpress.Web;
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

using DataAccessLayer;
using System.Threading.Tasks;
using System.Drawing;
using DevExpress.XtraPrinting;
using DevExpress.Export;


namespace Reports.Reports.GridReports
{

    public partial class Gstr_1Report : System.Web.UI.Page
    {

        ReportData rpt = new ReportData();

        DataTable DTIndustry = new DataTable();
        BusinessLogicLayer.Reports objReport = new BusinessLogicLayer.Reports();
        string data = "";
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();


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
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/Reports/master/GstrReport.aspx");
            DateTime dtFrom;
            DateTime dtTo;
            if (!IsPostBack)
            {


                Session["gridGstR1"] = null;
                Session["dt_GSTRRpt"] = null;
                Session["dt_GSTRRpt_b2cl"] = null;
                Session["dt_GSTRRpt_b2cs"] = null;
                Session["dt_GSTRRpt_cdnr"] = null;
                Session["dt_GSTRRpt_cdnur"] = null;
                Session["dt_GSTRRpt_exp"] = null;
                Session["dt_GSTRRpt_AT"] = null;
                Session["dt_GSTRRpt_adj"] = null;
                Session["dt_GSTRRpt_exemp"] = null;
                Session["dt_GSTRRpt_hsn"] = null;



                dtFrom = DateTime.Now;
                dtTo = DateTime.Now;
                //   BindDropDownList();


                //ASPxFromDate.Text = dtFrom.ToString("dd-MM-yyyy");
                //ASPxToDate.Text = dtTo.ToString("dd-MM-yyyy");
                //Date_finyearwise(Convert.ToString(Session["LastFinYear"]));

                ASPxFromDate.Value = DateTime.Now;
                ASPxToDate.Value = DateTime.Now;

                BranchpopulateGSTN();
             

            }
            else
            {

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








        #region ########  Branch GRN Populate  #######
        protected void BranchpopulateGSTN()
        {
            // DataTable dst = new DataTable();
            string userbranchID = Convert.ToString(Session["userbranchID"]);



            DataSet ds = new DataSet();
            SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            SqlCommand cmd = new SqlCommand("GetGSTNfetch", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Company", Convert.ToString(Session["LastCompany"]));
            cmd.Parameters.AddWithValue("@Branchlist", Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]));
            cmd.CommandTimeout = 0;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            da.Fill(ds);

            cmd.Dispose();
            con.Dispose();


            if (ds.Tables[0].Rows.Count > 0)
            {
                ddlgstn.DataSource = ds.Tables[0];
                ddlgstn.DataTextField = "branch_GSTIN";
                ddlgstn.DataValueField = "branch_GSTIN";
                ddlgstn.DataBind();
                ddlgstn.Items.Insert(0, "");
            }


        }

        #endregion

        protected void Showgrid_Datarepared(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;

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
            }

        }



        public void bindexport(int Filter)
        {
            string FileHeader = "";
            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            if (ASPxPageControl1.ActiveTabIndex == 0)
            {
                string filename = "GSTR-1B2B";
                exporter.FileName = filename;

                exporter.PageHeader.Left = "GSTR-1 B2B Reort";
                exporter.GridViewID = "ShowGrid";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 B2B Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;
            }
            else if (ASPxPageControl1.ActiveTabIndex == 1)
            {
                string filename = "GSTR-1 B2CL";
                exporter.FileName = filename;

                exporter.PageHeader.Left = "GSTR-1 B2CL Reort";
                exporter.GridViewID = "grid_b2cl";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 B2CL Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;

            }

            else if (ASPxPageControl1.ActiveTabIndex == 2)
            {
                string filename = "GSTR-1 B2CS";
                exporter.FileName = filename;

                exporter.PageHeader.Left = "GSTR-1 B2CS Reort";
                exporter.GridViewID = "grid_b2cs";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 B2CS Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;

            }


            else if (ASPxPageControl1.ActiveTabIndex == 3)
            {
                string filename = "GSTR-1 CDNR(9B)";
                exporter.FileName = filename;

                exporter.PageHeader.Left = "GSTR-1 CDNR(9B) Reort";
                exporter.GridViewID = "grid_cdnr";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 CDNR(9B) Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;

            }

            else if (ASPxPageControl1.ActiveTabIndex == 4)
            {
                string filename = "GSTR-1 CDNUR(9B)";
                exporter.FileName = filename;
                exporter.PageHeader.Left = "GSTR-1 CDNUR(9B) Reort";
                exporter.GridViewID = "grid_cdnur";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 CDNUR(9B) Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;

            }

            else if (ASPxPageControl1.ActiveTabIndex == 5)
            {
                string filename = "GSTR-1 EXP";
                exporter.FileName = filename;
                exporter.PageHeader.Left = "GSTR-1 EXP Reort";
                exporter.GridViewID = "grid_exp";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 EXP Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;

            }

            else if (ASPxPageControl1.ActiveTabIndex == 6)
            {

                string filename = "GSTR-1 AT";
                exporter.FileName = filename;
                exporter.PageHeader.Left = "GSTR-1 AT Reort";
                exporter.GridViewID = "grid_at";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 AT Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;

            }


            else if (ASPxPageControl1.ActiveTabIndex == 7)
            {

                string filename = "GSTR-1 Adj";
                exporter.FileName = filename;
                exporter.PageHeader.Left = "GSTR-1 Adj Reort";
                exporter.GridViewID = "grid_adj";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 Adj Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;


            }


            else if (ASPxPageControl1.ActiveTabIndex == 8)
            {

                string filename = "GSTR-1 Exemp";
                exporter.FileName = filename;
                exporter.PageHeader.Left = "GSTR-1 Exemp Reort";
                exporter.GridViewID = "grid_exemp";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 Exemp Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;


            }

            else if (ASPxPageControl1.ActiveTabIndex == 9)
            {

                string filename = "GSTR-1 HSN";
                exporter.FileName = filename;
                exporter.PageHeader.Left = "GSTR-1 HSN Reort";
                exporter.GridViewID = "grid_hsn";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR-1 HSN Reort" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;


            }

            else if (ASPxPageControl1.ActiveTabIndex == 10)
            {

                string filename = "GSTR Document Count";
                exporter.FileName = filename;
                exporter.PageHeader.Left = "GSTR Document Count";
                exporter.GridViewID = "GST_DocumentCount";
                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GSTR Document Count" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.PageHeader.Left = FileHeader;


            }
            exporter.PageHeader.Font.Size = 10;
            exporter.PageHeader.Font.Name = "Tahoma";

            //exporter.PageFooter.Center = "[Page # of Pages #]";
            //exporter.PageFooter.Right = "[Date Printed]";
            exporter.Landscape = true;
            exporter.MaxColumnWidth = 100;
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
        #region  ################## GSTR-1 Summary (B2B) ########################

        protected void Grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }



                Task PopulateStockTrialDataTask = new Task(() => GetGstrReportB2B(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously();


            }
        }

        protected void grid_DataBinding(object sender, EventArgs e)
        {
            if (Session["gridGstR1"] != null)
            {
                ShowGrid.DataSource = (DataTable)Session["gridGstR1"];

            }

        }

        public void GetGstrReportB2B(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");


                dttab = GetGstrReportB2BAll(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "b2b", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["gridGstR1"] = dttab;
                    ShowGrid.DataSource = dttab;
                    ShowGrid.DataBind();
                }
                else
                {
                    Session["gridGstR1"] = null;
                    ShowGrid.DataSource = null;
                    ShowGrid.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetGstrReportB2BAll(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);
            //proc.AddPara("@MONTH", branch);
            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }

        protected void ShowGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            if (e.Item == ShowGrid.TotalSummary["Value"])
            {
                e.Text = string.Format("{0}", e.Value);
            }
            if (e.Item == ShowGrid.TotalSummary["Taxable value"])
            {
                e.Text = string.Format("{0}", e.Value);
            }

            //e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));
            //if (e.Item == ShowGrid.TotalSummary["Value"])
            //{
            //    e.Text = string.Format("{0}", e.Value);

            //}
            //if (e.Item == ShowGrid.TotalSummary["Taxable value"])
            //{
            //    e.Text = string.Format("{0}", e.Value);

            //}

        }


        private int totalCount;
        private int totalCountrecp;

        private List<string> InvoiceNo = new List<string>();

        private List<string> GSTINUIN = new List<string>();

        protected void ASPxGridView1_CustomSummaryCalculate(object sender, DevExpress.Data.CustomSummaryEventArgs e)
        {
            ASPxSummaryItem item = e.Item as ASPxSummaryItem;

            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
            {
                InvoiceNo.Clear();
                GSTINUIN.Clear();
                totalCount = 0;
                totalCountrecp = 0;


            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
            {

                string val = Convert.ToString(e.FieldValue);
                if (!InvoiceNo.Contains(val))
                {
                    totalCount++;
                    InvoiceNo.Add(val);
                }
                if (!GSTINUIN.Contains(val))
                {
                    totalCountrecp++;
                    GSTINUIN.Add(val);
                }

            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
            {

                if (e.Item == ShowGrid.TotalSummary["InvoiceNo"])
                {
                    e.TotalValue = string.Format("No. of Invoices={0}", totalCount);
                }

                if (e.Item == ShowGrid.TotalSummary["GSTINUIN"])
                {
                    e.TotalValue = string.Format("No. of GSTIN={0}", totalCountrecp);

                }

            }



        }




        #endregion



        #region ###############   GSTR-1 Summary (B2CL) ####################
        protected void Grid_b2cl__CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_b2cl");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }



                Task PopulateStockTrialDataTask = new Task(() => GetGstrB2Cldata(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously();


            }
           
        }


        protected void grid_b2cl_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_b2cl"] != null)
            {
                grid_b2cl.DataSource = (DataTable)Session["dt_GSTRRpt_b2cl"];

            }

        }


        public void GetGstrB2Cldata(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();


                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");


                dttab = GetGSTRB2ClDetailsGestn(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "b2cl", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_b2cl"] = dttab;
                    grid_b2cl.DataSource = dttab;
                    grid_b2cl.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_b2cl"] = null;
                    grid_b2cl.DataSource = null;
                    grid_b2cl.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetGSTRB2ClDetailsGestn(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);
            //proc.AddPara("@MONTH", branch);
            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }

        protected void Grid_b2cl_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {

        
            if (e.Item == grid_b2cl.TotalSummary["Value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }
            if (e.Item == grid_b2cl.TotalSummary["Taxable value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }
        }


        //private List<string> InvoiceNo2 = new List<string>();
        //private int totalCount2;
        protected void GridView_b2cl_CustomSummaryCalculate(object sender, DevExpress.Data.CustomSummaryEventArgs e)
        {
            ASPxSummaryItem item = e.Item as ASPxSummaryItem;

            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
            {
                InvoiceNo.Clear();

                totalCount = 0;



            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
            {

                string val = Convert.ToString(e.FieldValue);
                if (!InvoiceNo.Contains(val))
                {
                    totalCount++;
                    InvoiceNo.Add(val);
                }


            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
            {

                if (e.Item == grid_b2cl.TotalSummary["InvoiceNo"])
                {
                    e.TotalValue = string.Format("No. of Invoices={0}", totalCount);
                }



            }



        }

        #endregion



        #region ###############   GSTR-1 Summary (B2CS) ####################


        protected void Grid_b2cs__CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_b2cs");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }








                Task PopulateStockTrialDataTask = new Task(() => GetGstrB2csdata(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously();
            }
           
        }



        protected void grid_b2cs_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_b2cs"] != null)
            {
                grid_b2cs.DataSource = (DataTable)Session["dt_GSTRRpt_b2cs"];

            }

        }

        public void GetGstrB2csdata(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                dttab = GetGstrB2csdatadetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "b2cs", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_b2cs"] = dttab;
                    grid_b2cs.DataSource = dttab;
                    grid_b2cs.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_b2cs"] = null;
                    grid_b2cs.DataSource = null;
                    grid_b2cs.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }


        public void GetGstrDocumentCount(string Gstn)
        {
            try
            {
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                dttab = GetGstrDocumentCountdetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "b2cs", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRDocCount_hsn"] = dttab;
                    GST_DocumentCount.DataSource = dttab;
                    GST_DocumentCount.DataBind();
                }
                else
                {
                    Session["dt_GSTRDocCount_hsn"] = null;
                    GST_DocumentCount.DataSource = null;
                    GST_DocumentCount.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }


        public DataTable GetGstrB2csdatadetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);

            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }

        public DataTable GetGstrDocumentCountdetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("Prc_DocumentNumberCount");
            //proc.AddPara("@COMPANYID", Company);
            //proc.AddPara("@FINYEAR", Finyear);
            //proc.AddPara("@Action", Action);
            proc.AddPara("@Gstin", Gstn);

            proc.AddPara("@Fromdate", FROMDATE);
            proc.AddPara("@ToDate", TODATE);
            ds = proc.GetTable();
            return ds;
        }


        protected void Grid_b2cs_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {

            e.Text = string.Format("{0}", e.Value);

            //if (e.Item == grid_b2cs.TotalSummary["Taxable value"])
            //{
            //    e.Text = string.Format("Total Taxable Value={0}", e.Value);

            //}
        }


        #endregion




        #region  ###############  GSTR-1 Summary (CDNR) ######################


        protected void Grid_cdnr_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_cdnr");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }



                Task PopulateStockTrialDataTask = new Task(() => GetGstrCDNRdata(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously();
            }
        }



        protected void grid_cdnr_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_cdnr"] != null)
            {
                grid_cdnr.DataSource = (DataTable)Session["dt_GSTRRpt_cdnr"];

            }

        }

        public void GetGstrCDNRdata(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");


                dttab = GetGstrCDNRdataDetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "cdnr", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_cdnr"] = dttab;
                    grid_cdnr.DataSource = dttab;
                    grid_cdnr.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_cdnr"] = null;
                    grid_cdnr.DataSource = null;
                    grid_cdnr.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetGstrCDNRdataDetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);
            //proc.AddPara("@MONTH", branch);
            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }



        protected void Grid_cdnr_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {

            ///e.Text = string.Format("{0}", e.Value);

            //  e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));

            if (e.Item == grid_cdnr.TotalSummary["Value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }
            if (e.Item == grid_cdnr.TotalSummary["Taxable value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }
        }

        private List<string> Invoice = new List<string>();

        protected void GridView_cdnr_CustomSummaryCalculate(object sender, DevExpress.Data.CustomSummaryEventArgs e)
        {
            ASPxSummaryItem item = e.Item as ASPxSummaryItem;

            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
            {
                Invoice.Clear();
                GSTINUIN.Clear();
                totalCount = 0;
                totalCountrecp = 0;


            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
            {

                string val = Convert.ToString(e.FieldValue);
                if (!Invoice.Contains(val))
                {
                    totalCount++;
                    Invoice.Add(val);
                }
                if (!GSTINUIN.Contains(val))
                {
                    totalCountrecp++;
                    GSTINUIN.Add(val);
                }

            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
            {

                if (e.Item == grid_cdnr.TotalSummary["Invoice"])
                {
                    e.TotalValue = string.Format("No. of Invoices={0}", totalCount);
                }

                if (e.Item == grid_cdnr.TotalSummary["GSTINUIN"])
                {
                    e.TotalValue = string.Format("No. of Recipients={0}", totalCountrecp);

                }


            }



        }

        #endregion




        #region ################### GSTR-1 Summary (CDNUR) #################################

        protected void Grid_cdnur_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_cdnur");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }


                Task PopulateStockTrialDataTask = new Task(() => GetGSTRcdnurdata(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously(); 
            }
        }


        protected void grid_cdnur_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_cdnur"] != null)
            {
                grid_cdnur.DataSource = (DataTable)Session["dt_GSTRRpt_cdnur"];

            }

        }

        public void GetGSTRcdnurdata(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");


                dttab = GetGSTRcdnurdatadetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "cdnur", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_cdnur"] = dttab;
                    grid_cdnur.DataSource = dttab;
                    grid_cdnur.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_cdnur"] = null;
                    grid_cdnur.DataSource = null;
                    grid_cdnur.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetGSTRcdnurdatadetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);
            //proc.AddPara("@MONTH", branch);
            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }


        protected void Grid_cdnur_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
          


            //  e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));

            if (e.Item == grid_cdnur.TotalSummary["Value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }
            if (e.Item == grid_cdnur.TotalSummary["Taxable value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }
        }

        protected void GridView_cdnur_CustomSummaryCalculate(object sender, DevExpress.Data.CustomSummaryEventArgs e)
        {
            ASPxSummaryItem item = e.Item as ASPxSummaryItem;

            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
            {
                Invoice.Clear();
                GSTINUIN.Clear();
                totalCount = 0;
                totalCountrecp = 0;


            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
            {

                string val = Convert.ToString(e.FieldValue);
                if (!Invoice.Contains(val))
                {
                    totalCount++;
                    Invoice.Add(val);
                }
                if (!GSTINUIN.Contains(val))
                {
                    totalCountrecp++;
                    GSTINUIN.Add(val);
                }

            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
            {

                if (e.Item == grid_cdnur.TotalSummary["Invoice"])
                {
                    e.TotalValue = string.Format("No. of Invoices={0}", totalCount);
                }

                if (e.Item == grid_cdnur.TotalSummary["GSTINUIN"])
                {
                    e.TotalValue = string.Format("No. of Recipients={0}", totalCountrecp);

                }


            }



        }

        #endregion


        #region  ################ GSTR-1 Summary EXP  ####################

        protected void Grid_exp_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            Session.Remove("dt_GSTRRpt_exp");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }



                Task PopulateStockTrialDataTask = new Task(() => GetGSTREXPdata(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously(); 
            }
        }


        protected void grid_exp_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_exp"] != null)
            {
                grid_exp.DataSource = (DataTable)Session["dt_GSTRRpt_exp"];

            }

        }

        public void GetGSTREXPdata(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");


                dttab = GetGSTREXPdataDetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "exp", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_exp"] = dttab;
                    grid_exp.DataSource = dttab;
                    grid_exp.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_exp"] = null;
                    grid_exp.DataSource = null;
                    grid_exp.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetGSTREXPdataDetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);
            //proc.AddPara("@MONTH", branch);
            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }


        protected void Grid_exp_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {

           // e.Text = string.Format("{0}", e.Value);

            if (e.Item == grid_exp.TotalSummary["Value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }
            if (e.Item == grid_exp.TotalSummary["Taxable value"])
            {
                e.Text = string.Format("{0}", e.Value);

            }

        }

        protected void GridView_exp_CustomSummaryCalculate(object sender, DevExpress.Data.CustomSummaryEventArgs e)
        {
            ASPxSummaryItem item = e.Item as ASPxSummaryItem;

            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
            {
                InvoiceNo.Clear();
                GSTINUIN.Clear();
                totalCount = 0;
                totalCountrecp = 0;


            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
            {

                string val = Convert.ToString(e.FieldValue);
                if (!InvoiceNo.Contains(val))
                {
                    totalCount++;
                    InvoiceNo.Add(val);
                }
                if (!GSTINUIN.Contains(val))
                {
                    totalCountrecp++;
                    GSTINUIN.Add(val);
                }

            }
            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
            {

                if (e.Item == grid_exp.TotalSummary["InvoiceNo"])
                {
                    e.TotalValue = string.Format("No. of Invoices={0}", totalCount);
                }

                if (e.Item == grid_exp.TotalSummary["GSTINUIN"])
                {
                    e.TotalValue = string.Format("No. of Recipients={0}", totalCountrecp);

                }

            }

        }

        #endregion


        #region  #######  GSTR-1 Summary AT ###############

        protected void Grid_at_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_AT");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }




                Task PopulateStockTrialDataTask = new Task(() => GetGSTRAT(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously(); 


            
            }
        }



        protected void grid_at_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_AT"] != null)
            {
                grid_at.DataSource = (DataTable)Session["dt_GSTRRpt_AT"];

            }

        }

        public void GetGSTRAT(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                dttab = GetGSTRATDetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "at", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_AT"] = dttab;
                    grid_at.DataSource = dttab;
                    grid_at.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_AT"] = null;
                    grid_at.DataSource = null;
                    grid_at.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetGSTRATDetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);

            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }

        protected void Grid_at_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);

            // e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));
            //if (e.Item == grid_at.TotalSummary["Value"])
            //{
            //    e.Text = string.Format("Gross Advance Received={0}", e.Value);

            //}
        }




        #endregion



        #region  ###########   GSTR-1  Summary Adj #################

        protected void Grid_adj_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_adj");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }



                Task PopulateStockTrialDataTask = new Task(() => GstAdvanceadj(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously(); 
            }
        }



        protected void grid_adj_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_adj"] != null)
            {
                grid_adj.DataSource = (DataTable)Session["dt_GSTRRpt_adj"];

            }

        }

        public void GstAdvanceadj(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                dttab = GstAdvanceadjDetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "atadj", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_adj"] = dttab;
                    grid_adj.DataSource = dttab;
                    grid_adj.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_adj"] = null;
                    grid_adj.DataSource = null;
                    grid_adj.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GstAdvanceadjDetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);

            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }



        protected void Grid_adj_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);

            //if (e.Item == grid_adj.TotalSummary["Value"])
            //{
            //    e.Text = string.Format("Gross Advance Adjusted={0}", e.Value);

            //}
        }
        #endregion


        #region  ############  GSTR-1  Summary Exempted ################


        protected void Grid_exemp_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_exemp");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }




              

                Task PopulateStockTrialDataTask = new Task(() => GstExempted(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously(); 
            }
        }



        protected void grid_exemp_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_exemp"] != null)
            {
                grid_exemp.DataSource = (DataTable)Session["dt_GSTRRpt_exemp"];

            }

        }

        public void GstExempted(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                dttab = GstExemptedDetails(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "exemp", Gstn, FROMDATE, TODATE);


                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_exemp"] = dttab;
                    grid_exemp.DataSource = dttab;
                    grid_exemp.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_exemp"] = null;
                    grid_exemp.DataSource = null;
                    grid_exemp.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GstExemptedDetails(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);

            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }
        protected void Grid_exemp_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);

          //  e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));

        }


        #endregion


        #region  ############  GSTR-1  Summary HSN ################

        protected void Grid_hsn_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRRpt_hsn");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);


                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }




            
                Task PopulateStockTrialDataTask = new Task(() => GetGstrHSNRtaedata(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously(); 
            }
        }



        protected void grid_hsn_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRRpt_hsn"] != null)
            {
                grid_hsn.DataSource = (DataTable)Session["dt_GSTRRpt_hsn"];
            }
        }

        public void GetGstrHSNRtaedata(string Gstn)
        {
            try
            {
                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;
                DataTable dttab = new DataTable();

                DateTime dtFrom;
                DateTime dtTo;


                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                dttab = GetGstrHSNRtaedata(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "hsn", Gstn, FROMDATE, TODATE);

                if (dttab.Rows.Count > 0)
                {
                    Session["dt_GSTRRpt_hsn"] = dttab;
                    grid_hsn.DataSource = dttab;
                    grid_hsn.DataBind();
                }
                else
                {
                    Session["dt_GSTRRpt_hsn"] = null;
                    grid_hsn.DataSource = null;
                    grid_hsn.DataBind();

                }
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetGstrHSNRtaedata(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        {
            DataTable ds = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
            proc.AddPara("@COMPANYID", Company);
            proc.AddPara("@FINYEAR", Finyear);
            proc.AddPara("@Action", Action);
            proc.AddPara("@GSTIN", Gstn);

            proc.AddPara("@FROMDATE", FROMDATE);
            proc.AddPara("@TODATE", TODATE);
            ds = proc.GetTable();
            return ds;
        }
        protected void Grid_hsn_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);

           // e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));

        }



        #endregion


        #region  ############  GSTR-1  Document Count ################

        protected void Grid_DocumentCount_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_GSTRDocCount_hsn");

            ShowGrid.JSProperties["cpSave"] = null;
            string returnPara = Convert.ToString(e.Parameters);

            string WhichCall = returnPara.Split('~')[0];
            if (WhichCall == "ListData")
            {
                string WhichCall2 = returnPara.Split('~')[1];
                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }








                Task PopulateStockTrialDataTask = new Task(() => GetGstrDocumentCount(WhichCall2));
                PopulateStockTrialDataTask.RunSynchronously();
            }
        }



        protected void grid_DocumentCount_DataBinding(object sender, EventArgs e)
        {
            if (Session["dt_GSTRDocCount_hsn"] != null)
            {
                GST_DocumentCount.DataSource = (DataTable)Session["dt_GSTRDocCount_hsn"];
            }
        }


        protected void Grid_Document_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);

            //  e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));

            //if (e.Item == GST_DocumentCount.TotalSummary["Total_Number"])
            //{
            //    e.Text = string.Format("Total Number ={0}", e.Value);

            //}
        }

        //public void GetGstrHSNRtaedata(string Gstn)
        //{
        //    try
        //    {
        //        string DriverName = string.Empty;
        //        string PhoneNo = string.Empty;
        //        string VehicleNo = string.Empty;
        //        DataTable dttab = new DataTable();

        //        DateTime dtFrom;
        //        DateTime dtTo;


        //        dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
        //        dtTo = Convert.ToDateTime(ASPxToDate.Date);

        //        string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
        //        string TODATE = dtTo.ToString("yyyy-MM-dd");

        //        dttab = GetGstrHSNRtaedata(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]).Trim(), "hsn", Gstn, FROMDATE, TODATE);

        //        if (dttab.Rows.Count > 0)
        //        {
        //            Session["dt_GSTRRpt_hsn"] = dttab;
        //            grid_hsn.DataSource = dttab;
        //            grid_hsn.DataBind();
        //        }
        //        else
        //        {
        //            Session["dt_GSTRRpt_hsn"] = null;
        //            grid_hsn.DataSource = null;
        //            grid_hsn.DataBind();

        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //    }
        //}
        //public DataTable GetGstrHSNRtaedata(string Company, string Finyear, string Action, string Gstn, string FROMDATE, string TODATE)
        //{
        //    DataTable ds = new DataTable();
        //    ProcedureExecute proc = new ProcedureExecute("prc_GSTR_Type_Report");
        //    proc.AddPara("@COMPANYID", Company);
        //    proc.AddPara("@FINYEAR", Finyear);
        //    proc.AddPara("@Action", Action);
        //    proc.AddPara("@GSTIN", Gstn);

        //    proc.AddPara("@FROMDATE", FROMDATE);
        //    proc.AddPara("@TODATE", TODATE);
        //    ds = proc.GetTable();
        //    return ds;
        //}
        //protected void Grid_hsn_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        //{

        //    e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));

        //}

        //protected void Grid_DocumentCount_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        //{

        //    e.Text = string.Format("{0}", Convert.ToDecimal(e.Value));

        //}



        #endregion
    }
}