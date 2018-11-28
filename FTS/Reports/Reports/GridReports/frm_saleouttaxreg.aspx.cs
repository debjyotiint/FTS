using DataAccessLayer;
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

using System.Threading.Tasks;
using DevExpress.XtraPrinting;
using DevExpress.Export;
using System.Globalization;
using System.Drawing;

namespace Reports.Reports.GridReports
{
    public partial class frm_saleouttaxreg : System.Web.UI.Page
    {
        decimal TotalINVvalue = 0;


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
            #region Button Wise Right Access Section Start
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/reports/gstreturn.aspx");
            #endregion Button Wise Right Access Section End
            DateTime dtFrom;
            DateTime dtTo;

            if (HttpContext.Current.Session["userid"] == null)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }


            if (!IsPostBack) {
                drdExport.SelectedIndex = 0;
                Session["SI_ComponentData_Branch"] = null;
                Session["GSTIN"] = null;
                dtFrom = DateTime.Now;
                dtTo = DateTime.Now;
                ASPxFromDate.Text = dtFrom.ToString("dd-MM-yyyy");
                ASPxToDate.Text = dtTo.ToString("dd-MM-yyyy");

                ////FromDate.Value = dtFrom.ToString("dd-MM-yyyy");
                ////ToDate.Value = dtTo.ToString("dd-MM-yyyy");
                Date_finyearwise(Convert.ToString(Session["LastFinYear"]));
                ASPxFromDate.Value = DateTime.Now;
                ASPxToDate.Value = DateTime.Now;
                BranchpopulateGSTN();
                //==========================================for document Type==================================================

                DataTable dtdoctype = new DataTable();
                dtdoctype.Columns.Add("doctype_code", typeof(string));
                dtdoctype.Columns.Add("doctype_description", typeof(string));

                DataRow dr;
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "SI";
                dr["doctype_description"] = "Sale Invoice";
                dtdoctype.Rows.Add(dr);
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "CUSTP";
                dr["doctype_description"] = "Customer Payment";
                dtdoctype.Rows.Add(dr);
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "CUSTR";
                dr["doctype_description"] = "Customer Receipt";
                dtdoctype.Rows.Add(dr);
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "SRN";
                dr["doctype_description"] = "Sale Return Normal";
                dtdoctype.Rows.Add(dr);
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "SRM";
                dr["doctype_description"] = "Sale Return Manual";
                dtdoctype.Rows.Add(dr);
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "USR";
                dr["doctype_description"] = "Undelivered Sales Return";
                dtdoctype.Rows.Add(dr);
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "CUSTCN";
                dr["doctype_description"] = "Customer Credit Note";
                dtdoctype.Rows.Add(dr);
                dr = dtdoctype.NewRow();
                dr["doctype_code"] = "CUSTDN";
                dr["doctype_description"] = "Customer Debit Note";
                dtdoctype.Rows.Add(dr);

                Session["SI_DocumentType"] = dtdoctype;

                if (Session["SI_DocumentType"] != null)
                {
                    lookup_doctype.DataSource = (DataTable)Session["SI_DocumentType"];
                    lookup_doctype.DataBind();
                }
                //============================================================================================================

                Session.Remove("dt_SaleOutputtaxGstReg");

                OPTREGGrid.JSProperties["cpSave"] = null;

                string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);
             
                //dtFrom = Convert.ToDateTime(DateTime.ParseExact(FromDate.Value, "dd-MM-yyyy", CultureInfo.InvariantCulture));
                //dtTo = Convert.ToDateTime(DateTime.ParseExact(ToDate.Value, "dd-MM-yyyy", CultureInfo.InvariantCulture));

                string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
                string TODATE = dtTo.ToString("yyyy-MM-dd");
            }
            else
            {
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);

               

                //dtFrom = Convert.ToDateTime(DateTime.ParseExact(FromDate.Value, "dd-MM-yyyy", CultureInfo.InvariantCulture));
                //dtTo = Convert.ToDateTime(DateTime.ParseExact(ToDate.Value, "dd-MM-yyyy", CultureInfo.InvariantCulture));
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

                //FromDate.Value = Convert.ToDateTime(stbill.Rows[0]["FinYear_StartDate"]).ToString("dd-MM-yyyy");
                //ToDate.Value = Convert.ToDateTime(stbill.Rows[0]["FinYear_EndDate"]).ToString("dd-MM-yyyy");
                
            }

        }

        #region ########  Branch GSTN Populate  #######
        protected void BranchpopulateGSTN()
        {
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

        protected void OPTREGGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            Session.Remove("dt_SaleOutputtaxGstReg");
            OPTREGGrid.JSProperties["cpSave"] = null;

            string COMPANYID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string Finyear = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

            DateTime dtFrom;
            DateTime dtTo;

            dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
            dtTo = Convert.ToDateTime(ASPxToDate.Date);
         
            //dtFrom = Convert.ToDateTime(DateTime.ParseExact(FromDate.Value, "dd-MM-yyyy", CultureInfo.InvariantCulture));
            //dtTo = Convert.ToDateTime(DateTime.ParseExact(ToDate.Value, "dd-MM-yyyy", CultureInfo.InvariantCulture));

            string FROMDATE = dtFrom.ToString("yyyy-MM-dd");
            string TODATE = dtTo.ToString("yyyy-MM-dd");

            string BRANCH_ID = "";

            string BranchComponent = "";
            if (Session["SI_ComponentData_Branch"] != null)
            {
                if (lookup_branch.GridView.GetSelectedFieldValues("branch_id").Count() != ((DataTable)Session["SI_ComponentData_Branch"]).Rows.Count)
                {
                    List<object> BranchList = lookup_branch.GridView.GetSelectedFieldValues("branch_id");
                    foreach (object Branch in BranchList)
                    {
                        BranchComponent += "," + Branch;
                    }
                    BRANCH_ID = BranchComponent.TrimStart(',');
                }

                string DoctypeComponent = "";
                string DOCTYPE_ID = "";
                List<object> DoctypeList = lookup_doctype.GridView.GetSelectedFieldValues("doctype_code");
                foreach (object DocType in DoctypeList)
                {
                    DoctypeComponent += "," + DocType;
                }
                DOCTYPE_ID = DoctypeComponent.TrimStart(',');
                string GSTINID = e.Parameters.Split('~')[1];
                Session["GSTIN"] = GSTINID;
                string custinternlid = Convert.ToString(CustomerComboBox.Value);

                Task PopulateStockTrialDataTask = new Task(() => GetOPTREGdata(FROMDATE, TODATE, BRANCH_ID, DOCTYPE_ID, GSTINID, custinternlid));
                PopulateStockTrialDataTask.RunSynchronously(); 
            }
          
        }

        protected void Componentbranch_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string FinYear = Convert.ToString(Session["LastFinYear"]);

            if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            {
                DataTable ComponentTable = new DataTable();
                string Hoid = e.Parameter.Split('~')[1];

                if (Hoid != "0")
                {
                    DataSet ds = new DataSet();
                    SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                    SqlCommand cmd = new SqlCommand("Getbranchlist_Gsitnwise", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@GstinId", Hoid);
                    cmd.CommandTimeout = 0;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    cmd.Dispose();
                    con.Dispose();
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        Session["SI_ComponentData_Branch"] = ds.Tables[0];
                        lookup_branch.DataSource = ds.Tables[0];
                        lookup_branch.DataBind();
                    }
                    else
                    {
                        lookup_branch.DataSource = null;
                        lookup_branch.DataBind();
                    }
                }
                else
                {
                    Session["SI_ComponentData_Branch"] = null;
                    lookup_branch.DataSource = null;
                    lookup_branch.DataBind();
                }
            }
        }
        public void GetOPTREGdata(string FROMDATE, string TODATE, string BRANCH_ID, string DOCTYPE_ID, string GSTINID, string custinternlid)
        {
            try
            {

                string DriverName = string.Empty;
                string PhoneNo = string.Empty;
                string VehicleNo = string.Empty;

                DataSet ds = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("PRC_SALE_GST_OTPTAXREG_REPORT", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@COMPANYID", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@FINYEAR", Convert.ToString(Session["LastFinYear"]).Trim());
                cmd.Parameters.AddWithValue("@GSTIN", GSTINID);
                cmd.Parameters.AddWithValue("@FROMDATE", FROMDATE);
                cmd.Parameters.AddWithValue("@TODATE", TODATE);
                cmd.Parameters.AddWithValue("@BRANCH_ID", BRANCH_ID);
                cmd.Parameters.AddWithValue("@DOCTYPE", DOCTYPE_ID);
                cmd.Parameters.AddWithValue("@CUSTOMERID", custinternlid);
               
                cmd.CommandTimeout = 0;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                da.Fill(ds);

                cmd.Dispose();
                con.Dispose();

                Session["dt_SaleOutputtaxGstReg"] = ds.Tables[0];

                OPTREGGrid.DataSource = ds.Tables[0];
                OPTREGGrid.DataBind();
                OPTREGGrid.ExpandAll();

            }
            catch (Exception ex)
            {

            }
        }
        protected void OPTREGGrid_DataBinding(object sender, EventArgs e)
        {
            OPTREGGrid.DataSource = (DataTable)Session["dt_SaleOutputtaxGstReg"];
        }

        protected void lookup_branch_DataBinding(object sender, EventArgs e)
        {
            if (Session["SI_ComponentData_Branch"] != null)
            {
                lookup_branch.DataSource = (DataTable)Session["SI_ComponentData_Branch"];
            }
        }

      
        public void bindexport(int Filter)
        {
            if (OPTREGGrid.VisibleRowCount > 0)
            {
                string filename = "GST Output Tax Register";
                exporter.FileName = filename;
                string FileHeader = "";

                exporter.FileName = filename;

                BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

                FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "GST Output Tax Register" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                exporter.RenderBrick += exporter_RenderBrick;
                exporter.PageHeader.Left = FileHeader;
                exporter.PageHeader.Font.Size = 10;
                exporter.PageHeader.Font.Name = "Tahoma";

                //exporter.PageFooter.Center = "[Page # of Pages #]";
                //exporter.PageFooter.Right = "[Date Printed]";
                exporter.GridViewID = "OPTREGGrid";
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

                    default:
                        return;
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Notify", "jAlert('There is no record to export.');", true);
                // return;
                BranchpopulateGSTN();
            }
        }
        protected void exporter_RenderBrick(object sender, ASPxGridViewExportRenderingEventArgs e)
        {
            e.BrickStyle.BackColor = Color.White;
            e.BrickStyle.ForeColor = Color.Black;
        }

        private int totalCount;
        private int totalCountrecp;

        private List<string> Number = new List<string>();


        protected void OPTREGGrid_CustomSummaryCalculate(object sender, DevExpress.Data.CustomSummaryEventArgs e)
        {
            //ASPxSummaryItem item = e.Item as ASPxSummaryItem;

            //if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
            //{
            //    Number.Clear();
            //    totalCount = 0;
            //    totalCountrecp = 0;
            //}
            //if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
            //{

            //    string val = Convert.ToString(e.FieldValue);
            //    if (!Number.Contains(val))
            //    {
            //        totalCount++;
            //        Number.Add(val);
            //    }
            //}
            //if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
            //{
            //    if (e.Item == OPTREGGrid.TotalSummary["Document No"])
            //    {
            //        e.TotalValue = string.Format("Doc Count={0}", totalCount);
            //    }

            //}
        }

        protected void lookup_doctype_DataBinding(object sender, EventArgs e)
        {
               if (Session["SI_DocumentType"] != null)
            {
                lookup_doctype.DataSource = (DataTable)Session["SI_DocumentType"];
            }
        }
        #region predictive Customer
        protected void ASPxComboBox_OnItemsRequestedByFilterCondition_SQL(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            if (e.Filter != "")
            {
                ASPxComboBox comboBox = (ASPxComboBox)source;
                CustomerDataSource.SelectCommand =
                       @"select cnt_internalid,uniquename,Name,Billing from (SELECT cnt_internalid,uniquename,Name,Billing, row_number()over(order by t.[Name]) as [rn]  from v_pos_customerDetails  as t where (([uniquename] + ' ' + [Name] ) LIKE @filter)) as st where st.[rn] between @startIndex and @endIndex";

                CustomerDataSource.SelectParameters.Clear();
                CustomerDataSource.SelectParameters.Add("filter", TypeCode.String, string.Format("%{0}%", e.Filter));
                CustomerDataSource.SelectParameters.Add("startIndex", TypeCode.Int64, (e.BeginIndex + 1).ToString());
                CustomerDataSource.SelectParameters.Add("endIndex", TypeCode.Int64, (e.EndIndex + 1).ToString());
                comboBox.DataSource = CustomerDataSource;
                comboBox.DataBind();
            }
        }


        protected void ASPxComboBox_OnItemRequestedByValue_SQL(object source, ListEditItemRequestedByValueEventArgs e)
        {
            long value = 0;
            if (e.Value == null || !Int64.TryParse(e.Value.ToString(), out value))
                return;
            ASPxComboBox comboBox = (ASPxComboBox)source;
            CustomerDataSource.SelectCommand = @"SELECT cnt_internalid,uniquename,Name,Billing FROM v_pos_customerDetails WHERE (cnt_internalid = @ID) ";

            CustomerDataSource.SelectParameters.Clear();
            CustomerDataSource.SelectParameters.Add("ID", TypeCode.String, e.Value.ToString());
            comboBox.DataSource = CustomerDataSource;
            comboBox.DataBind();
        }

        protected void SetCustomerDDbyValue(string customerId)
        {

            CustomerDataSource.SelectCommand = @"SELECT cnt_internalid,uniquename,Name,Billing FROM v_pos_customerDetails WHERE (cnt_internalid = @ID) ";

            CustomerDataSource.SelectParameters.Clear();
            CustomerDataSource.SelectParameters.Add("ID", TypeCode.String, customerId);
            CustomerComboBox.DataSource = CustomerDataSource;
            CustomerComboBox.DataBind();
            CustomerComboBox.Value = customerId;

        }
        protected void OPTREGGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);
        }

        #endregion

        protected void drdExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                bindexport(Filter);
            }
        }

     

      

       
    }
}