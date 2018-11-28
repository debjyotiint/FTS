using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using BusinessLogicLayer;
using ClsDropDownlistNameSpace;
using EntityLayer.CommonELS;
using System.Web.Services;
using System.Collections.Generic;
using System.Collections;
using DevExpress.Web.Data;
using DataAccessLayer;
using System.ComponentModel;
using System.IO;
using System.Web.Script.Serialization;
using ERP.Models;
using System.Linq;

namespace ERP.OMS.Management.Activities
{
    public partial class PosSalesInvoiceList : ERP.OMS.ViewState_class.VSPage
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        SalesInvoiceBL objSalesInvoiceBL = new SalesInvoiceBL();
        PosSalesInvoiceBl posSale = new PosSalesInvoiceBl();

        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            //((GridViewDataComboBoxColumn)massBranch.Columns["pos_assignBranch"]).PropertiesComboBox.DataSource = LoadBranch();

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/Management/Activities/PosSalesInvoiceList.aspx");

            if (!IsPostBack)
            {
                if (Session["LastCompany"] != null && Session["LastCompany"] != null)
                {
                    string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    string userbranchHierachy = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                    PopulateBranch(userbranchHierachy, Convert.ToString(Session["userbranchID"]));
                    PopulateBranchByHierchy(userbranchHierachy);
                    SetledgerOutPresentOrNot();
                    #region waitinginvoice
                    DataTable watingInvoice = posSale.GetBasketDetails(userbranchHierachy);
                    waitingInvoiceCount.Value = Convert.ToString(watingInvoice.Rows.Count);
                    lblweatingCount.Text = "(" + Convert.ToString(watingInvoice.Rows.Count) + ")";
                    watingInvoicegrid.DataSource = watingInvoice;
                    watingInvoicegrid.DataBind();

                    FormDate.Date = DateTime.Now;
                    toDate.Date = DateTime.Now;
                    cmbBranchfilter.Value = Convert.ToString(Session["userbranchID"]);
                    //   GetQuotationListGridData(userbranchHierachy, lastCompany);
                    GrdQuotation.SettingsCookies.CookiesID = "BreeezeErpGridCookiesGrdQuotationPosList";

                    this.Page.ClientScript.RegisterStartupScript(GetType(), "setCookieOnStorage", "<script>addCookiesKeyOnStorage('BreeezeErpGridCookiesGrdQuotationPosList');</script>");
                    loadGridDataYesorNO();
                    #endregion
                }
                BindReceiptGrid();
                CustomerReceiptGrid.DataBind();
            }
        }

        private void loadGridDataYesorNO()
        {
            ProcedureExecute proc = new ProcedureExecute("prc_PosSalesInvoice");
            proc.AddVarcharPara("@Action", 500, "ShowGridOnLoad");
            DataTable dt = proc.GetTable();
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    LoadGridData.Value = "ok";
                }
                else
                {
                    LoadGridData.Value = "no";
                }
            }

        }


        private void PopulateBranchByHierchy(string userbranchhierchy)
        {
            PosSalesInvoiceBl posSale = new PosSalesInvoiceBl();
            DataTable branchtable = posSale.getBranchListByHierchy(userbranchhierchy);
            cmbBranchfilter.DataSource = branchtable;
            cmbBranchfilter.ValueField = "branch_id";
            cmbBranchfilter.TextField = "branch_description";
            cmbBranchfilter.DataBind();
            cmbBranchfilter.SelectedIndex = 0;

            DataRow[] name = branchtable.Select("branch_id=" + Convert.ToString(Session["userbranchID"]));
            if (name.Length > 0)
            {
                branchName.Text = Convert.ToString(name[0]["branch_description"]);
            }


        }

        private void PopulateBranch(string userbranchhierchy, string UserBranch)
        {
            PosSalesInvoiceBl posSale = new PosSalesInvoiceBl();

            BranchAssignmentBranch.DataSource = posSale.getBranchListByBranchList(userbranchhierchy, UserBranch);
            BranchAssignmentBranch.ValueField = "branch_id";
            BranchAssignmentBranch.TextField = "branch_description";
            BranchAssignmentBranch.DataBind();
            BranchAssignmentBranch.Value = "0";

            AssignedBranch.DataSource = posSale.getBranchListByBranchList(userbranchhierchy, UserBranch);
            AssignedBranch.ValueField = "branch_id";
            AssignedBranch.TextField = "branch_description";
            AssignedBranch.DataBind();
            AssignedBranch.Value = "0";

           
        }

        #region Export Grid Section Start
        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                bindexport(Filter);
                //if (Session["exportval"] == null)
                //{
                //    Session["exportval"] = Filter;
                //    bindexport(Filter);
                //}
                //else if (Convert.ToInt32(Session["exportval"]) != Filter)
                //{
                //    Session["exportval"] = Filter;
                //    bindexport(Filter);
                //}
            }
        }

       
        public void bindexport(int Filter)
        {
            if (ASPxPageControl1.ActiveTabIndex == 0)
            {
                GrdQuotation.Columns[6].Visible = false;
                string filename = "Sales Invoice";
                exporter.FileName = filename;
                exporter.FileName = "POS";

                exporter.PageHeader.Left = "Sales Invoice";
                exporter.PageFooter.Center = "[Page # of Pages #]";
                exporter.PageFooter.Right = "[Date Printed]";
                exporter.Landscape = true;
            }
            else
            {
                string filename = "Advance Receipt";
                exporter.FileName = filename;
                exporter.FileName = "Receipt";

                exporter.PageHeader.Left = "Advance Receipt";
                exporter.PageFooter.Center = "[Page # of Pages #]";
                exporter.PageFooter.Right = "[Date Printed]";
                exporter.Landscape = true;
                exporter.GridViewID = "CustomerReceiptGrid";
            }
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

        #endregion

        [WebMethod]
        public static string GetEditablePermission(string ActiveUser)
        {
            CRMSalesDtlBL objCRMSalesDtlBL = new CRMSalesDtlBL();
            int ispermission = 0;
            ispermission = objCRMSalesDtlBL.QuotationEditablePermission(Convert.ToInt32(ActiveUser));
            return Convert.ToString(ispermission);
        }


        [WebMethod]
        public static string GetTotalWatingInvoiceCount()
        {
            PosSalesInvoiceBl posSale = new PosSalesInvoiceBl();
            string userbranchHierachy = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
            return Convert.ToString(posSale.GetWaitingCount(userbranchHierachy));
        }


        #region Grid Section Start
        protected void EntityServerModeDataSource_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
       {
            e.KeyExpression = "Invoice_Id";

            string connectionString = ConfigurationManager.ConnectionStrings["crmConnectionString"].ConnectionString;

            string IsFilter = Convert.ToString(hfIsFilter.Value);
            string strFromDate = Convert.ToString(hfFromDate.Value);
            string strToDate = Convert.ToString(hfToDate.Value);
            string strBranchID = (Convert.ToString(hfBranchID.Value) == "") ? "0" : Convert.ToString(hfBranchID.Value);

            List<int> branchidlist;
            ERPDataClassesDataContext dc = new ERPDataClassesDataContext(connectionString);
            if (IsFilter == "Y")
            {
                if (strBranchID == "0")
                {
                    string BranchList = Convert.ToString(Session["userbranchHierarchy"]);
                    branchidlist = new List<int>(Array.ConvertAll(BranchList.Split(','), int.Parse));
                    var q = from d in dc.v_posLists
                            where d.Invoice_DateTimeFormat >= Convert.ToDateTime(strFromDate) &&
                                  d.Invoice_DateTimeFormat <= Convert.ToDateTime(strToDate) &&
                                  d.Invoice_CompanyID == Convert.ToString(Session["LastCompany"]) &&
                                  branchidlist.Contains(Convert.ToInt32(d.Invoice_branchId))
                            orderby d.Invoice_DateTimeFormat descending
                            select d;
                    e.QueryableSource = q;
                }
                else
                {
                    branchidlist = new List<int>(Array.ConvertAll(strBranchID.Split(','), int.Parse));
                    var q = from d in dc.v_posLists
                            where d.Invoice_DateTimeFormat >= Convert.ToDateTime(strFromDate) &&
                                  d.Invoice_DateTimeFormat <= Convert.ToDateTime(strToDate) &&
                                  d.Invoice_CompanyID == Convert.ToString(Session["LastCompany"]) &&
                                  branchidlist.Contains(Convert.ToInt32(d.Invoice_branchId))
                            orderby d.Invoice_DateTimeFormat descending
                            select d;
                    e.QueryableSource = q;
                }
            }
            else
            {
                var q = from d in dc.v_posLists
                        where d.Invoice_branchId == '0' &&
                                d.Invoice_CompanyID == Convert.ToString(Session["LastCompany"]) 
                        orderby d.Invoice_DateTimeFormat descending
                        select d;
                e.QueryableSource = q;
            }
        }
        protected void GrdQuotation_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            CRMSalesDtlBL objCRMSalesDtlBL = new CRMSalesDtlBL();
            GrdQuotation.JSProperties["cpinsert"] = null;
            GrdQuotation.JSProperties["cpEdit"] = null;
            GrdQuotation.JSProperties["cpUpdate"] = null;
            GrdQuotation.JSProperties["cpDelete"] = null;
            GrdQuotation.JSProperties["cpExists"] = null;
            GrdQuotation.JSProperties["cpUpdateValid"] = null;
            int insertcount = 0;

            int updtcnt = 0;
            int deletecnt = 0;
            string WhichCall = Convert.ToString(e.Parameters).Split('~')[0];
            string WhichType = null;
            string QuoteStatus = "";
            string remarks = "";

            if (Convert.ToString(e.Parameters).Contains("~"))
            {
                if (Convert.ToString(e.Parameters).Split('~')[1] != "")
                {
                    WhichType = Convert.ToString(e.Parameters).Split('~')[1];
                }
            }

            if (WhichCall == "Delete")
            {
                deletecnt = posSale.DeleteInvoice(WhichType);
                if (deletecnt == 1)
                {
                    GrdQuotation.JSProperties["cpDelete"] = "Deleted successfully";
                    GetQuotationListGridData(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]));
                }
                else
                {
                    GrdQuotation.JSProperties["cpDelete"] = "Used in other module.can not delete.";
                }

            }
            else if (WhichCall == "FilterGridByDate")
            {
                string fromdate = e.Parameters.Split('~')[1];
                string toDate = e.Parameters.Split('~')[2];
                string branch = e.Parameters.Split('~')[3];
                DataTable dtdata = new DataTable();
                //dtdata = posSale.GetInvoiceListGridDataByDate(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]), fromdate, toDate, branch);
                //if (dtdata != null)
                //{
                //    Session["PosSalesInvoiceList"] = dtdata;
                //    GrdQuotation.DataBind();
                //}
            }
            else if (WhichCall == "RefreshGrid")
            {
                //string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                //string userbranchHierachy = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                //GetQuotationListGridData(userbranchHierachy, lastCompany);
            }
            else if (WhichCall == "CancelAssignment")
            {
                posSale.CancelBranchAssignment(Convert.ToInt32(e.Parameters.Split('~')[1]));
                GrdQuotation.JSProperties["cpCancelAssignMent"] = "yes";
                //string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                //string userbranchHierachy = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                //GetQuotationListGridData(userbranchHierachy, lastCompany);
            }
        }


        protected void IstGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            CRMSalesDtlBL objCRMSalesDtlBL = new CRMSalesDtlBL();
            IstGrid.JSProperties["cpinsert"] = null;
            IstGrid.JSProperties["cpEdit"] = null;
            IstGrid.JSProperties["cpUpdate"] = null;
            IstGrid.JSProperties["cpDelete"] = null;
            IstGrid.JSProperties["cpExists"] = null;
            IstGrid.JSProperties["cpUpdateValid"] = null;
            int insertcount = 0;

            int updtcnt = 0;
            int deletecnt = 0;
            string WhichCall = Convert.ToString(e.Parameters).Split('~')[0];
            string WhichType = null;
            string QuoteStatus = "";
            string remarks = "";

            if (Convert.ToString(e.Parameters).Contains("~"))
            {
                if (Convert.ToString(e.Parameters).Split('~')[1] != "")
                {
                    WhichType = Convert.ToString(e.Parameters).Split('~')[1];
                }
            }

            if (WhichCall == "Delete")
            {
                deletecnt = posSale.DeleteInvoice(WhichType);
                if (deletecnt == 1)
                {
                    IstGrid.JSProperties["cpDelete"] = "Deleted successfully";
                    GetQuotationListGridDataIST(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]));
                }
                else
                {
                    IstGrid.JSProperties["cpDelete"] = "Used in other module.can not delete.";
                }

            }
            else if (WhichCall == "FilterGridByDate")
            {
                string fromdate = e.Parameters.Split('~')[1];
                string toDate = e.Parameters.Split('~')[2];
                string branch = e.Parameters.Split('~')[3];
                DataTable dtdata = new DataTable();
                dtdata = posSale.GetISTInvoiceListGridDataByDate(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]), fromdate, toDate, branch);
                if (dtdata != null)
                {
                    Session["PosSalesInvoiceListIST"] = dtdata;
                    IstGrid.DataBind();
                }
            }
            else if (WhichCall == "RefreshGrid")
            {
                string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string userbranchHierachy = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                GetQuotationListGridDataIST(userbranchHierachy, lastCompany);
            }
            else if (WhichCall == "CancelAssignment")
            {
                posSale.CancelBranchAssignment(Convert.ToInt32(e.Parameters.Split('~')[1]));
                IstGrid.JSProperties["cpCancelAssignMent"] = "yes";
                string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string userbranchHierachy = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                GetQuotationListGridDataIST(userbranchHierachy, lastCompany);
            }
        }


        public void GetQuotationListGridData(string userbranch, string lastCompany)
        {
            //DataTable dtdata = new DataTable();
            //dtdata = posSale.GetInvoiceListGridData(userbranch, lastCompany);
            ////dtdata = objSalesInvoiceBL.GetQuotationListGridData(userbranch, lastCompany);
            //if (dtdata != null && dtdata.Rows.Count > 0)
            //{
            //    //GrdQuotation.DataSource = dtdata;
            //    Session["PosSalesInvoiceList"] = dtdata;
            //    GrdQuotation.DataBind();
            //}
            //else
            //{
            //  //  GrdQuotation.DataSource = null;
            //    Session["PosSalesInvoiceList"] = null;
            //    GrdQuotation.DataBind();
            //}

            /*Abhisek
            DataTable dtdata = posSale.GetInvoiceListGridDataByDate(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]), FormDate.Date.ToString("yyyy-MM-dd"), toDate.Date.ToString("yyyy-MM-dd"), Convert.ToString(cmbBranchfilter.Value));
            if (dtdata != null)
            {
                Session["PosSalesInvoiceList"] = dtdata;
                GrdQuotation.DataBind();
            }
            */
        }


        public void GetQuotationListGridDataIST(string userbranch, string lastCompany)
        {

            DataTable dtdata = posSale.GetISTInvoiceListGridDataByDate(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]), FormDate.Date.ToString("yyyy-MM-dd"), toDate.Date.ToString("yyyy-MM-dd"), Convert.ToString(cmbBranchfilter.Value));
            if (dtdata != null)
            {
                Session["PosSalesInvoiceListIST"] = dtdata;
                IstGrid.DataBind();
            }

        }
        /* Abhisek
        protected void GrdQuotation_DataBinding(object sender, EventArgs e)
        {
            if (Session["PosSalesInvoiceList"] != null)
            {
                GrdQuotation.DataSource = (DataTable)Session["PosSalesInvoiceList"];
            }
            else
            {
                GrdQuotation.DataSource = null;
            }

        }

        */
        protected void IstGrid_DataBinding(object sender, EventArgs e)
        {
            if (Session["PosSalesInvoiceListIST"] != null)
            {
                IstGrid.DataSource = (DataTable)Session["PosSalesInvoiceListIST"];
            }
            else
            {
                IstGrid.DataSource = null;
            }

        }


        #endregion


        protected void watingInvoicegrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string receivedString = e.Parameters;

            if (receivedString.Split('~')[0] == "Remove")
            {
                string key = receivedString.Split('~')[1];
                posSale.DeleteBasketDetailsFromtable(key, Convert.ToInt32(Session["userid"]));
                watingInvoicegrid.JSProperties["cpReturnMsg"] = "Billing Request has been Deleted Successfully.";
                watingInvoicegrid.DataBind();
            }
        }
        protected void watingInvoicegrid_DataBinding(object sender, EventArgs e)
        {
            watingInvoicegrid.DataSource = posSale.GetBasketDetails(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]));
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
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\SPOS";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\SPOS";
                }
                string fullpath = Server.MapPath("~");
                fullpath = fullpath.Replace("ERP.UI\\", "");
                string DesignFullPath = fullpath + DesignPath;
                filePaths = System.IO.Directory.GetFiles(DesignFullPath, "*.repx");
                string invoiceType = Convert.ToString(HdInvoiceType.Value);
                if (invoiceType == "Stock Transfer")
                    invoiceType = "InterstateStockTransfer";

                foreach (string filename in filePaths)
                {
                    string reportname = Path.GetFileNameWithoutExtension(filename);
                    string name = "";

                    if (reportname.Contains(invoiceType))
                    {
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
                }
                CmbDesignName.SelectedIndex = 0;
                SelectPanel.JSProperties["cpChecked"] = "";
            }
            else
            {
                string DesignPath = @"Reports\Reports\REPXReports";
                string fullpath = Server.MapPath("~");
                fullpath = fullpath.Replace("ERP.UI\\", "");
                string filename = @"\RepxReportViewer.aspx";
                string DesignFullPath = fullpath + DesignPath + filename;

                string reportName = Convert.ToString(CmbDesignName.Value);
                string NoofCopy = "";
                if (selectOriginal.Checked == true)
                {
                    NoofCopy += 1 + ",";
                }
                if (selectDuplicate.Checked == true)
                {
                    NoofCopy += 2 + ",";
                }
                if (selectFDuplicate.Checked == true)
                {
                    NoofCopy += 3 + ",";
                }
                if (selectTriplicate.Checked == true)
                {
                    NoofCopy += 4 + ",";
                }
                SelectPanel.JSProperties["cpSuccess"] = NoofCopy;
                SelectPanel.JSProperties["cpChecked"] = "Checked";
            }
        }

        #region Assignment
        protected void AssignmentGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {

            if (e.Parameters.Split('~')[0] == "AssignBranch")
            {
                int assignBranch = Convert.ToInt32(e.Parameters.Split('~')[2]);
                int warehouse = Convert.ToInt32(e.Parameters.Split('~')[3]);
                int invoiceid = Convert.ToInt32(e.Parameters.Split('~')[1]);
                posSale.UpdateAssignBranch(assignBranch, warehouse, invoiceid);
                AssignmentGrid.JSProperties["cpMsg"] = "Updated Successfully.";
            }
            else
            {
                string invoiceId = e.Parameters.Split('~')[0];
                string BranchId = e.Parameters.Split('~')[1];
                DataTable availableStock = posSale.GetBranchAssignmentDetails(Convert.ToInt32(invoiceId), Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), Convert.ToInt32(BranchId));
                Session["BranchAssignmentTableForGrid"] = availableStock;
                AssignmentGrid.DataBind();
            }
        }
        protected void AssignmentGrid_DataBinding(object sender, EventArgs e)
        {
            DataTable availableStock = (DataTable)Session["BranchAssignmentTableForGrid"];
            AssignmentGrid.DataSource = availableStock;
        }

        protected void AssignedWareHouse_Callback(object sender, CallbackEventArgsBase e)
        {

            AssignedWareHouse.DataSource = posSale.getWareHouseByBranch(Convert.ToInt32(e.Parameter));
            AssignedWareHouse.TextField = "bui_Name";
            AssignedWareHouse.ValueField = "bui_id";
            AssignedWareHouse.DataBind();
            AssignedWareHouse.SelectedIndex = 0;
            if (e.Parameter != "0")
                if (AssignedWareHouse.Items.Count > 1)
                {
                    AssignedWareHouse.SelectedIndex = 1;
                }

        }
        protected void BranchRequUpdatePanel_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string InvoiceId = e.Parameter;
            DataTable invoiceDetails = oDBEngine.GetDataTable("select isnull(pos_assignBranch,0)pos_assignBranch,isnull(pos_wareHouse,0)pos_wareHouse   from tbl_trans_SalesInvoice where Invoice_Id =" + InvoiceId);
            if (invoiceDetails.Rows.Count > 0)
            {
                AssignedBranch.Value = Convert.ToString(invoiceDetails.Rows[0]["pos_assignBranch"]);
                AssignedWareHouse.DataSource = posSale.getWareHouseByBranch(Convert.ToInt32(invoiceDetails.Rows[0]["pos_assignBranch"]));
                AssignedWareHouse.TextField = "bui_Name";
                AssignedWareHouse.ValueField = "bui_id";
                AssignedWareHouse.DataBind();
                AssignedWareHouse.Value = Convert.ToString(invoiceDetails.Rows[0]["pos_wareHouse"]);
            }
        }
        #endregion


        

        public DataTable LoadBranch()
        {
            string userbranchHierachy = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);

            return posSale.getBranchListByBranchListForMassBranch(userbranchHierachy, Convert.ToString(Session["userbranchID"]));
        }

        public void BindReceiptGrid()
        {
            //    Session["CustomerReceiptGridInPos"]   = posSale.GetCustomerReceipttable(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]));

            DataTable dtdata = posSale.GetCustomerReceipttableByDateBranch(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]), FormDate.Date.ToString("yyyy-MM-dd"), toDate.Date.ToString("yyyy-MM-dd"), Convert.ToString(cmbBranchfilter.Value));
            if (dtdata != null)
            {
                Session["CustomerReceiptGridInPos"] = dtdata;
                CustomerReceiptGrid.DataBind();
            }
        }

        protected void CustomerReceiptGrid_DataBinding(object sender, EventArgs e)
        {
            DataTable custDt = (DataTable)Session["CustomerReceiptGridInPos"];
            if (custDt != null)
            {
                CustomerReceiptGrid.DataSource = custDt;

            }
        }

        protected void CustomerReceiptGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string WhichCall = Convert.ToString(e.Parameters).Split('~')[0];
            if (WhichCall == "FilterGridByDate")
            {
                string fromdate = e.Parameters.Split('~')[1];
                string toDate = e.Parameters.Split('~')[2];
                string branch = e.Parameters.Split('~')[3];
                DataTable dtdata = new DataTable();
                dtdata = posSale.GetCustomerReceipttableByDateBranch(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Convert.ToString(HttpContext.Current.Session["LastCompany"]), fromdate, toDate, branch);
                if (dtdata != null)
                {
                    Session["CustomerReceiptGridInPos"] = dtdata;
                    CustomerReceiptGrid.DataBind();
                }
            }

        }

        public class MassBranchAssign
        {
            public int BranchId { get; set; }
            public int InvoiceId { get; set; }
        }


        [WebMethod]
        public static string GetCurrentBankBalance(string BranchId, string fromDate, string todate)
        {
            BusinessLogicLayer.Converter oConverter = new BusinessLogicLayer.Converter();
            string MainAccountValID = string.Empty;
            string strColor = string.Empty;
            DataTable DT = new DataTable();
            DBEngine objEngine = new DBEngine();
            if (BranchId.Trim() != "0")
            {
                //+ " and convert(varchar(10),AccountsLedger_TransactionDate,120) >= '" + fromDate + "' and convert(varchar(10),AccountsLedger_TransactionDate,120) <='" + todate + "'"
                DT = objEngine.GetDataTable("Select isnull(Sum(AccountsLedger_AmountDr-AccountsLedger_AmountCr),0) TotalAmount from Trans_AccountsLedger WHERE AccountsLedger_MainAccountID=(select top 1  MainAccount_AccountCode from Master_MainAccount where MainAccount_BankCashType='Cash')  and AccountsLedger_BranchId=" + BranchId);
                if (DT.Rows.Count != 0)
                {

                    if (!String.IsNullOrEmpty(Convert.ToString(DT.Rows[0]["TotalAmount"])))
                    {
                        MainAccountValID = oConverter.getFormattedvaluecheckorginaldecimaltwoorfour(Convert.ToDecimal(DT.Rows[0]["TotalAmount"]));
                        strColor = Convert.ToDecimal(MainAccountValID) > 0 ? "White" : "Red";
                    }
                }
            }
            else
            {
                // and  convert(varchar(10),AccountsLedger_TransactionDate,120) >= '" + fromDate + "' and convert(varchar(10),AccountsLedger_TransactionDate,120) <='" + todate + "'
                DT = objEngine.GetDataTable("Select isnull(Sum(AccountsLedger_AmountDr-AccountsLedger_AmountCr),0) TotalAmount from Trans_AccountsLedger WHERE AccountsLedger_MainAccountID=(select top 1  MainAccount_AccountCode from Master_MainAccount where MainAccount_BankCashType='Cash') and  AccountsLedger_BranchId in( " + Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]) + ")");
                if (DT.Rows.Count != 0)
                {

                    if (!String.IsNullOrEmpty(Convert.ToString(DT.Rows[0]["TotalAmount"])))
                    {
                        MainAccountValID = oConverter.getFormattedvaluecheckorginaldecimaltwoorfour(Convert.ToDecimal(DT.Rows[0]["TotalAmount"]));
                        strColor = Convert.ToDecimal(MainAccountValID) > 0 ? "White" : "Red";
                    }
                }

            }

            return MainAccountValID + "~" + strColor;
        }

        public void SetledgerOutPresentOrNot()
        {

            ProcedureExecute proc = new ProcedureExecute("prc_PosSalesInvoice");
            proc.AddVarcharPara("@Action", 500, "GetOutLedger");
            DataTable dt = proc.GetTable();
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    hdIsStockLedger.Value = "ok";
                }
                else
                {
                    hdIsStockLedger.Value = "no";
                }
            }
        }


        protected void CustRacPayPanel_Callback(object sender, CallbackEventArgsBase e)
        {
            string strSplitCommand = e.Parameter.Split('~')[0];
            if (strSplitCommand == "Bindalldesignes")
            {
                string[] filePaths = new string[] { };
                string DesignPath = "";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\CustomerRecPay\DocDesign\Designes";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\CustomerRecPay\DocDesign\Designes";
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
                    CustCmbDesignName.Items.Add(name, reportValue);
                }
                CustCmbDesignName.SelectedIndex = 1;
                //CustCmbDesignName.Value = "MoneyReceipt~D";
            }
            else
            {
                string DesignPath = @"Reports\Reports\REPXReports";
                string fullpath = Server.MapPath("~");
                fullpath = fullpath.Replace("ERP.UI\\", "");
                string filename = @"\RepxReportViewer.aspx";
                string DesignFullPath = fullpath + DesignPath + filename;
                string reportName = Convert.ToString(CustCmbDesignName.Value);
                CustomerRecpayPanel.JSProperties["cpSuccess"] = "Success";
            }
        }

        protected void ShowGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            e.Text = string.Format("{0}", e.Value);
        }

    }
}
