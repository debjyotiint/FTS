using BusinessLogicLayer;
using DataAccessLayer;
using DevExpress.Web;
using EntityLayer.CommonELS;
using ERP.OMS.Management.Master;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.XtraPrinting;
using DevExpress.Export;
using System.Drawing;

namespace ERP.OMS.Reports.Master
{
    public partial class CustomerOutstanding : System.Web.UI.Page
    {
        BusinessLogicLayer.Reports objReport = new BusinessLogicLayer.Reports();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        static string _ProductID = "";

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
            if (!IsPostBack)
            {
                Session["DtCustomerOutsanding"] = null;
                lookupBranch.DataSource = GetBranchList();
                lookupBranch.DataBind();

                lookupCustomer.DataSource = GetCustomerList();
                lookupCustomer.DataBind();

                lookupSalesman.DataSource = GetSalesmanList();
                lookupSalesman.DataBind();

                string strFinYear = Convert.ToString(Session["LastFinYear"]);
                DataTable dt = oDBEngine.GetDataTable("Select FinYear_Code,FinYear_StartDate,FinYear_EndDate From Master_FinYear Where FinYear_Code='" + strFinYear + "'");
                if (dt != null && dt.Rows.Count > 0)
                {
                    string strStartDate = Convert.ToString(dt.Rows[0]["FinYear_StartDate"]);
                    string strEndDate = Convert.ToString(dt.Rows[0]["FinYear_EndDate"]);
                    DateTime StartDate = Convert.ToDateTime(strStartDate);
                    DateTime EndDate = Convert.ToDateTime(strEndDate);

                    //ASPxFromDate.Value = StartDate;
                    //ASPxToDate.Value = strEndDate;
                    //ASPxAsOnDate.Value = strEndDate;
                    //ASPxFromDate.Value = DateTime.Now;
                    //ASPxToDate.Value = DateTime.Now;
                    ASPxAsOnDate.Value = DateTime.Now;
                }
                else
                {
                    //ASPxFromDate.Value = DateTime.Now;
                    //ASPxToDate.Value = DateTime.Now;
                    ASPxAsOnDate.Value = DateTime.Now;
                }

                //ShowGrid.DataSource = GetCustomerOutstandingHeader();
                //ShowGrid.DataBind();
            }
        }

        #region Lookup Details

        protected void lookupBranch_DataBinding(object sender, EventArgs e)
        {
            lookupBranch.DataSource = GetBranchList();
        }
        protected void lookupCustomer_DataBinding(object sender, EventArgs e)
        {
            lookupCustomer.DataSource = GetCustomerList();
        }
        protected void lookupSalesman_DataBinding(object sender, EventArgs e)
        {
            lookupSalesman.DataSource = GetSalesmanList();
        }

        #endregion

        #region Grid Details

        protected void ShowGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {

            DataTable dtfech = new DataTable();
            dtfech = GetCustomerOutstandingHeader();
             
                Session["DtCustomerOutsanding"] = dtfech;
                ShowGrid.DataSource = dtfech;

                ShowGrid.DataBind();
           
        }
        protected void ShowGrid_DataBinding(object sender, EventArgs e)
        {
            if (Session["DtCustomerOutsanding"] != null)
            {
                ShowGrid.DataSource = (DataTable)Session["DtCustomerOutsanding"];
            }
        }
        protected void ShowGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);
        }

        protected void ShowGridDetails_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);
        }

        #endregion

        #region Export Details

        protected void drdExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                bindexport(Filter);
            }
        }
        public void bindexport(int Filter)
        {
            string filename = "Customer Outstanding Report";
            exporter.FileName = filename;
            string FileHeader = "";

            exporter.FileName = filename;

            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "Customer Outstanding Report" + Environment.NewLine + "As on " + Convert.ToDateTime(ASPxAsOnDate.Date).ToString("dd-MM-yyyy");

            exporter.PageHeader.Left = FileHeader;
            exporter.PageHeader.Font.Size = 10;
            exporter.PageHeader.Font.Name = "Tahoma";

            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";
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

                default:
                    return;
            }
        }

        protected void exporter_RenderBrick(object sender, ASPxGridViewExportRenderingEventArgs e)
        {
            e.BrickStyle.BackColor = Color.White;
            e.BrickStyle.ForeColor = Color.Black;
        }

        #endregion

        #region Database Details

        public DataTable GetBranchList()
        {
            try
            {
                DataTable dt = oDBEngine.GetDataTable("select branch_id AS Branch_ID,branch_description as Branch_description from tbl_master_branch Order By branch_description Asc");
                return dt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable GetCustomerList()
        {
            try
            {
                DataTable dt = oDBEngine.GetDataTable("Select cnt_internalId,ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+' '+ISNULL(cnt_lastName,'') as Customer_Name From tbl_master_contact WHERE cnt_contactType in('CL') Order By ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+' '+ISNULL(cnt_lastName,'') Asc");
                return dt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable GetSalesmanList()
        {
            try
            {
                DataTable dt = oDBEngine.GetDataTable("Select cnt_internalId,isnull(cnt_firstName,'')+isnull(cnt_middleName,'')+isnull(cnt_lastName,'') Salesman_Name from " +
                                                    "tbl_master_contact  where Substring(cnt_internalId,1,2)='AG' "+
                                                    "union all "+
                                                    "select emp_cntId,isnull(cnt_firstName,'')+SPACE(1)+isnull(cnt_middleName,'')+isnull(cnt_lastName,'') Salesman_Name from " +
                                                    "(select row_number() over (partition by emp_cntId order by emp_id desc ) as Row, emp_cntId,emp_id "+
                                                    "from tbl_trans_employeeCTC where emp_type=19) ctc inner join tbl_master_contact cnt on ctc.emp_cntId=cnt.cnt_internalId where ctc.Row=1");
                return dt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable GetCustomerOutstandingHeader()
        {
            string strBranchList = "", strCustomerList = "", strSalesmanList = "";
            string strCompany = Convert.ToString(Session["LastCompany"]);
            string strFinYear = Convert.ToString(Session["LastFinYear"]);
            //string strFromDate = Convert.ToDateTime(ASPxFromDate.Value).ToString("yyyy-MM-dd");
            //string strToDate = Convert.ToDateTime(ASPxToDate.Value).ToString("yyyy-MM-dd");

            if (hflookupClassAllFlag1.Value.ToUpper() != "ALL")
            {
                List<object> BranchList = lookupBranch.GridView.GetSelectedFieldValues("Branch_ID");
                foreach (object Branch in BranchList)
                {
                    strBranchList += "," + Branch;
                }
                strBranchList = strBranchList.TrimStart(',');
            }
            //List<object> BranchList = lookupBranch.GridView.GetSelectedFieldValues("Branch_ID");
            //foreach (object Branch in BranchList)
            //{
            //    strBranchList += "," + Branch;
            //}
            //strBranchList = strBranchList.TrimStart(',');

            if (hflookupClassAllFlag2.Value.ToUpper() != "ALL")
            {
                List<object> SalesmanList = lookupSalesman.GridView.GetSelectedFieldValues("cnt_internalId");
                foreach (object Salesman in SalesmanList)
                {
                    strSalesmanList += "," + Salesman;
                }
                strSalesmanList = strSalesmanList.TrimStart(',');
            }
            //List<object> SalesmanList = lookupSalesman.GridView.GetSelectedFieldValues("cnt_internalId");
            //foreach (object Salesman in SalesmanList)
            //{
            //    strSalesmanList += "," + Salesman;
            //}
            //strSalesmanList = strSalesmanList.TrimStart(',');

            if (hflookupClassAllFlag3.Value.ToUpper() != "ALL")
            {
                List<object> CustomerList = lookupCustomer.GridView.GetSelectedFieldValues("cnt_internalId");
                foreach (object Customer in CustomerList)
                {
                    strCustomerList += "," + Customer;
                }
                strCustomerList = strCustomerList.TrimStart(',');
            }
            //List<object> CustomerList = lookupCustomer.GridView.GetSelectedFieldValues("cnt_internalId");
            //foreach (object Customer in CustomerList)
            //{
            //    strCustomerList += "," + Customer;
            //}
            //strCustomerList = strCustomerList.TrimStart(',');
            string strAsonDate = Convert.ToDateTime(ASPxAsOnDate.Value).ToString("yyyy-MM-dd");

            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_CustomerOutstanding_Report");
                proc.AddPara("@COMPANYID", strCompany);
                proc.AddPara("@FINYEAR", strFinYear);
                //proc.AddPara("@FROMDATE", strFromDate);
                //proc.AddPara("@TODATE", strToDate);
                proc.AddPara("@BRANCHID", strBranchList);
                proc.AddPara("@SALESMAN", strSalesmanList);
                proc.AddPara("@CUSTOMER", strCustomerList);
                proc.AddPara("@ASONDATE", strAsonDate);
                dt = proc.GetTable();
                return dt;
            }
            catch
            {
                return null;
            }
        }

        #endregion
    }
}