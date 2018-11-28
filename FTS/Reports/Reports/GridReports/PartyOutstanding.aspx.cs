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
using DevExpress.Data;
using System.Threading.Tasks;
using DevExpress.XtraPrinting;
using DevExpress.Export;
using System.Drawing;

namespace Reports.Reports.GridReports
{
    public partial class PartyOutstanding : System.Web.UI.Page
    {
        DataTable DTIndustry = new DataTable();
        BusinessLogicLayer.Reports objReport = new BusinessLogicLayer.Reports();
        string data = "";
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        protected void Page_Load(object sender, EventArgs e)
        {
            //rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/Reports/master/LedgerPostingReport.aspx");
            DateTime dtFrom;
            DateTime dtTo;
            if (!IsPostBack)
            {
                Session["SI_ComponentData"] = null;
                Session["SI_ComponentData_Branch"] = null;
                Session["dt_PartyLedgerRpt"] = null;

                dtFrom = DateTime.Now;
                dtTo = DateTime.Now;

                ASPxFromDate.Value = DateTime.Now;
                ASPxToDate.Value = DateTime.Now;
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");

                string BRANCH_ID = "";
                if (hdnSelectedBranches.Value != "")
                {
                    BRANCH_ID = hdnSelectedBranches.Value;
                }

                string GROUP_ID = "";     //Suvankar
                if (hdnSelectedGroups.Value != "")
                {
                    GROUP_ID = hdnSelectedGroups.Value;
                }
                //string CUSTVENDID = "";
                //if (hdnSelectedCustomerVendor.Value != "")
                //{
                //    CUSTVENDID = hdnSelectedCustomerVendor.Value;
                //}
            }
            else
            {
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);
            }
            //BindPartyOutstanding();
        }

        protected void Page_PreInit(object sender, EventArgs e) // lead add
        {
            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                oDBEngine.Call_CheckPageaccessebility(sPath);
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

        public void BindDropDownList()
        {
            // Declare a Dictionary to hold all the Options with Value and Text.
            Dictionary<string, string> options = new Dictionary<string, string>();
            options.Add("0", "Export to");
            options.Add("1", "PDF");
            options.Add("2", "XLS");
            options.Add("3", "RTF");
            options.Add("4", "CSV");
            // Bind the Dictionary to the DropDownList.
            drdExport.DataSource = options;
            drdExport.DataTextField = "value";
            drdExport.DataValueField = "key";
            drdExport.DataBind();
            drdExport.SelectedValue = "0";
        }

        public void bindexport(int Filter)
        {
            string filename = "PartyOutstanding";
            exporter.FileName = filename;
            string FileHeader = "";

            exporter.FileName = filename;

            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "Party Outstanding Report" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");

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

        protected void ShowGrid_DataBinding(object sender, EventArgs e)
        {
            try
            {
                if (Session["dt_PartyLedgerRpt"] != null)
                {
                    ShowGrid.DataSource = (DataTable)Session["dt_PartyLedgerRpt"];
                    //ShowGrid.DataBind();
                }
            }
            catch { }
        }

        protected void Grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            Session.Remove("dt_PartyLedgerRpt");
            ShowGrid.JSProperties["cpSave"] = null;

            string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

            DateTime dtFrom;
            DateTime dtTo;
            dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
            dtTo = Convert.ToDateTime(ASPxToDate.Date);

            string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
            string TODATE = dtTo.ToString("yyyy-MM-dd");
            string BRANCH_ID = "";
            string Group_ID = "";
            if (lookup_Group.GridView.GetSelectedFieldValues("GroupCode").Count() != GetGroupList().Rows.Count)
            {
                string QuoComponent3 = "";
                List<object> QuoList3 = lookup_Group.GridView.GetSelectedFieldValues("GroupCode");
                foreach (object Quo3 in QuoList3)
                {
                    QuoComponent3 += "," + Quo3;
                }
                Group_ID = QuoComponent3.TrimStart(',');
            }

            string QuoComponent2 = "";
            List<object> QuoList2 = lookup_branch.GridView.GetSelectedFieldValues("ID");
            foreach (object Quo2 in QuoList2)
            {
                QuoComponent2 += "," + Quo2;
            }
            BRANCH_ID = QuoComponent2.TrimStart(',');
            Task PopulateStockTrialDataTask = new Task(() => GetPartyOutstandingdata(FROMDATE, TODATE, BRANCH_ID, Group_ID));
            PopulateStockTrialDataTask.RunSynchronously();
        }

        public DataTable GetGroupList()
        {
            try
            {
                DataTable dt = oDBEngine.GetDataTable("select GroupCode, GroupDescription from ( select AccountGroup_ReferenceID as GroupCode, AccountGroup_Name + ' ('+AccountGroup_Type + ')' as GroupDescription from Master_AccountGroup where AccountGroup_Type = 'Liability' or AccountGroup_Type = 'Asset' ) AcGrp order by GroupDescription");
                return dt;
            }
            catch
            {
                return null;
            }
        }

        public void GetPartyOutstandingdata(string FROMDATE, string TODATE, string BRANCH_ID, string GROUP_ID)
        {
            try
            {

                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;

                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_PartyOutstanding_Report", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                cmd.Parameters.AddWithValue("@CUSTOMER_TYPE", drp_partytype.SelectedValue);
                cmd.Parameters.AddWithValue("@BALANCE_SORT", drp_balancetype.SelectedValue);
                cmd.Parameters.AddWithValue("@FROMDATE", FROMDATE);
                cmd.Parameters.AddWithValue("@TODATE", TODATE);
                cmd.Parameters.AddWithValue("@BRANCHID", BRANCH_ID);
                cmd.Parameters.AddWithValue("@Group_Code", GROUP_ID);
                cmd.Parameters.AddWithValue("@P_INVOICE_DATE", chkparty.Checked == true ? "1" : "0");

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

        public static List<string> GetGroupList(String NoteId)   //Suvankar
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
            StringBuilder filter = new StringBuilder();
            StringBuilder Supervisorfilter = new StringBuilder();
            BusinessLogicLayer.Others objbl = new BusinessLogicLayer.Others();
            DataTable dtbl = new DataTable();
            if (NoteId.Trim() == "")
            {
                dtbl = oDBEngine.GetDataTable("select GroupCode, GroupDescription from ( select AccountGroup_ReferenceID as GroupCode, AccountGroup_Name + ' ('+AccountGroup_Type + ')' as GroupDescription from Master_AccountGroup where AccountGroup_Type = 'Liability' or AccountGroup_Type = 'Asset' ) AcGrp order by GroupDescription");

            }

            List<string> obj = new List<string>();

            foreach (DataRow dr in dtbl.Rows)
            {

                obj.Add(Convert.ToString(dr["GroupDescription"]) + "|" + Convert.ToString(dr["GroupCode"]));
            }
            return obj;
        }

        public void Date_finyearwise(string Finyear)
        {
            CommonBL bll1 = new CommonBL();
            DataTable stbill = new DataTable();
            stbill = bll1.GetDateFinancila(Finyear);
            if (stbill.Rows.Count > 0)
            {
                ASPxFromDate.Text = Convert.ToDateTime(DateTime.Now).ToString("dd-MM-yyyy");
                ASPxToDate.Text = Convert.ToDateTime(DateTime.Now).ToString("dd-MM-yyyy");
            }
        }

        protected void Showgrid_Htmlprepared(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            if (drp_partytype.SelectedValue == "ALL")
            {
                grid.Columns["CustomerVendor"].Caption = "Customer/Vendor";

            }

            else if (drp_partytype.SelectedValue == "CL")
            {
                grid.Columns["CustomerVendor"].Caption = "Customer";

            }

            else if (drp_partytype.SelectedValue == "DV")
            {
                grid.Columns["CustomerVendor"].Caption = "Vendor";

            }
        }

        protected void ComponentGroup_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)  //Suvankar
        {
            string FinYear = Convert.ToString(Session["LastFinYear"]);

            if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            {
                DataTable ComponentTable = new DataTable();
                string Hoid = e.Parameter.Split('~')[1];
                ComponentTable = oDBEngine.GetDataTable("select GroupCode, GroupDescription from (select AccountGroup_ReferenceID as GroupCode, AccountGroup_Name + ' ('+AccountGroup_Type + ')' as GroupDescription from Master_AccountGroup where AccountGroup_Type = 'Liability' or AccountGroup_Type = 'Asset' ) AcGrp order by GroupDescription");
                if (ComponentTable.Rows.Count > 0)
                {
                    Session["SI_ComponentData_Group"] = ComponentTable;
                    lookup_Group.DataSource = ComponentTable;
                    lookup_Group.DataBind();
                }
                else
                {
                    lookup_Group.DataSource = null;
                    lookup_Group.DataBind();

                }
            }
        }

        protected void lookup_Group_DataBinding(object sender, EventArgs e) //Suvankar
        {
            if (Session["SI_ComponentData_Group"] != null)
            {
                lookup_Group.DataSource = (DataTable)Session["SI_ComponentData_Group"];
            }
        }

        protected void Componentbranch_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string FinYear = Convert.ToString(Session["LastFinYear"]);

            if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            {
                DataTable ComponentTable = new DataTable();
                string Hoid = e.Parameter.Split('~')[1];
                if (Session["userbranchHierarchy"] != null)
                {
                    ComponentTable = oDBEngine.GetDataTable("select branch_id as ID,branch_description,branch_code from tbl_master_branch where branch_id in(" + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ") order by branch_description asc");
                }
                if (ComponentTable.Rows.Count > 0)
                {
                    Session["SI_ComponentData_Branch"] = ComponentTable;
                    lookup_branch.DataSource = ComponentTable;
                    lookup_branch.DataBind();
                }
                else
                {
                    lookup_branch.DataSource = null;
                    lookup_branch.DataBind();

                }
            }
        }

        protected void lookup_branch_DataBinding(object sender, EventArgs e)
        {
            if (Session["SI_ComponentData_Branch"] != null)
            {
                lookup_branch.DataSource = (DataTable)Session["SI_ComponentData_Branch"];
            }
        }


    }
}