﻿using DevExpress.Web;
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
    public partial class DebtorsDetailsDR : System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        static string globalBranchHierachyIds = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Remove("dt_PartyLedgerRpt");
                DateTime dtTo = DateTime.Now;
                ASPxToDate.Text = dtTo.ToString("dd-MM-yyyy");
                fnBindBranch();
                fnBindCustomer();
                fnBindFinancier();
            }
        }

        protected void Grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

            Session.Remove("dt_PartyLedgerRpt");


            ShowGrid.JSProperties["cpSave"] = null;


            string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

            DateTime dtTo;
            dtTo = Convert.ToDateTime(ASPxToDate.Date);

            string TODATE = dtTo.ToString("yyyy-MM-dd");

            string Branch_ID = string.Empty;
            string Customer_ID = string.Empty;
            string Financier_ID = string.Empty;


            string BranchList = "";
            List<object> QuoList1 = lookup_branch.GridView.GetSelectedFieldValues("branch_id");
            foreach (object Quo in QuoList1)
            {
                BranchList += "," + Quo;
            }
            Branch_ID = BranchList.TrimStart(',');

            string CustomerList = "";
            List<object> QuoList2 = lookup_customer.GridView.GetSelectedFieldValues("ID");
            foreach (object Quo in QuoList2)
            {
                CustomerList += "," + Quo;
            }
            Customer_ID = CustomerList.TrimStart(',');

            string FinancierList = "";
            List<object> QuoList3 = gridfinancerLookup.GridView.GetSelectedFieldValues("ID");
            foreach (object Quo in QuoList3)
            {
                FinancierList += "," + Quo;
            }
            Financier_ID = FinancierList.TrimStart(',');

            Task PopulateStockTrialDataTask = new Task(() => GetDebtorsDebit(TODATE, Branch_ID, Customer_ID, Financier_ID));
            PopulateStockTrialDataTask.RunSynchronously();
        }

        private void GetDebtorsDebit(string TODATE, string BranchId, string CustomerIds, string FinancierIds)
        {
            try
            {

                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;

                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_DebtorsDetails_Report", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                cmd.Parameters.AddWithValue("@BRANCHID", string.IsNullOrEmpty(BranchId) ? string.Empty : BranchId);
                cmd.Parameters.AddWithValue("@P_CODE", string.IsNullOrEmpty(CustomerIds) ? string.Empty : CustomerIds);
                cmd.Parameters.AddWithValue("@FINANCER", string.IsNullOrEmpty(FinancierIds) ? string.Empty : FinancierIds);
                cmd.Parameters.AddWithValue("@ASONDATE", TODATE);
                cmd.Parameters.AddWithValue("@TYPE", "DR");

                cmd.CommandTimeout = 0;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ds);

                cmd.Dispose();
                con.Dispose();

                Session["dt_PartyLedgerRpt"] = ds.Tables[0];

                ShowGrid.DataSource = ds.Tables[0];
                ShowGrid.DataBind();
            }
            catch (Exception ex)
            {
            }
        }

        protected void grid2_DataBinding(object sender, EventArgs e)
        {

            if (Session["dt_PartyLedgerRpt"] != null)
            {
                ShowGrid.DataSource = (DataTable)Session["dt_PartyLedgerRpt"];
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
            string filename = "Debtor Details Debit";
            exporter.FileName = filename;
            string FileHeader = "";

            exporter.FileName = filename;

            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "Debtor Details Debit" + Environment.NewLine + "As on " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");

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

        #region ########## Input Parameters Binding ##########

        private void fnBindBranch()
        {
            DataTable ComponentTable = new DataTable();
            if (Session["userbranchHierarchy"] != null)
            {
                // ComponentTable = oDBEngine.GetDataTable("select branch_id as ID,branch_description,branch_code from tbl_master_branch where branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ") order by branch_description asc");
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
        private void fnBindFinancier(string branchIds = "")
        {
            DataTable ComponentTable = fnGetFinancier(branchIds);

            if (ComponentTable.Rows.Count > 0)
            {
                gridfinancerLookup.DataSource = ComponentTable;
                gridfinancerLookup.DataBind();
            }
            else
            {
                gridfinancerLookup.DataSource = null;
                gridfinancerLookup.DataBind();

            }
        }
        protected void lookup_financer_DataBinding(object sender, EventArgs e)
        {
            DataTable ComponentTable = fnGetFinancier(globalBranchHierachyIds);

            if (ComponentTable.Rows.Count > 0)
            {
                gridfinancerLookup.DataSource = ComponentTable;
            }
            else
            {
                gridfinancerLookup.DataSource = null;
            }

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
        private void fnBindCustomer(string branchIds = "")
        {
            DataTable ComponentTable = fnGetCustomer(branchIds);

            if (ComponentTable.Rows.Count > 0)
            {
                lookup_customer.DataSource = ComponentTable;
                lookup_customer.DataBind();
            }
            else
            {
                lookup_customer.DataSource = null;
                lookup_customer.DataBind();
            }
        }
        protected void lookup_customer_DataBinding(object sender, EventArgs e)
        {
            DataTable ComponentTable = fnGetCustomer(globalBranchHierachyIds);

            if (ComponentTable.Rows.Count > 0)
            {
                lookup_customer.DataSource = ComponentTable;
            }
            else
            {
                lookup_customer.DataSource = null;
            }

        }

        protected void CustomerCallbackPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            var branchIds = Convert.ToString(e.Parameter);
            globalBranchHierachyIds = GetBranchHierachyIds(branchIds);
            fnBindCustomer(globalBranchHierachyIds);
        }
        protected void FinancierCallbackPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            var branchIds = Convert.ToString(e.Parameter);
            globalBranchHierachyIds = GetBranchHierachyIds(branchIds);
            fnBindFinancier(globalBranchHierachyIds);
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
        #endregion

    }
}