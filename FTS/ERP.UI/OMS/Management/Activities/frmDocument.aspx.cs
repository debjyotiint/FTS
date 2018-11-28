using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using DevExpress.Web.ASPxTabControl;
using System.Web.Services;
using System.Collections.Generic;
using BusinessLogicLayer;
using ClsDropDownlistNameSpace;
using ERP.OMS.CustomFunctions;
using System.Text;
using System.Reflection;
using DevExpress.Web;
using EntityLayer.CommonELS;
namespace ERP.OMS.Management.Activities
{
    public partial class management_Activities_frmDocument : ERP.OMS.ViewState_class.VSPage// System.Web.UI.Page
    {
        public string pageAccess = "";
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        BusinessLogicLayer.Others objBL = new BusinessLogicLayer.Others();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        DateTime dtFrom;
        DateTime dtTo;
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["userid"] == null)
            {
                //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
            if (!IsPostBack)
            {
                Session["exportval"] = null;
                SalesDetailsGrid.SettingsCookies.CookiesID = "BreeezeErpGridCookiesSalesDocumentDetailsGrid";
                this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>addCookiesKeyOnStorage('BreeezeErpGridCookiesSalesDocumentDetailsGrid');</script>");
                if (Request.QueryString["frmdate"] != null && Request.QueryString["todate"] != null)
                {
                    ASPxFromDate.Text = Request.QueryString["frmdate"];
                    ASPxToDate.Text = Request.QueryString["todate"];

                    dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                    dtTo = Convert.ToDateTime(ASPxToDate.Date);
                }
                else
                {
                    if (Session["Fromdate_D"] != null && Session["ToDate_D"] != null)
                    {

                        ASPxFromDate.Text = Convert.ToDateTime(Session["Fromdate_D"]).ToString("dd-MM-yyyy");
                        ASPxToDate.Text = Convert.ToDateTime(Session["ToDate_D"]).ToString("dd-MM-yyyy");
                        dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                        dtTo = Convert.ToDateTime(ASPxToDate.Date);
                    }

                    else
                    {
                        dtFrom = DateTime.Now;
                        dtTo = DateTime.Now;
                        ASPxFromDate.Text = dtFrom.ToString("dd-MM-yyyy");
                        ASPxToDate.Text = dtTo.ToString("dd-MM-yyyy");
                    }
                }
            }

            else
            {
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);
            }



            Session["export"] = null;
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Activities/crm_sales.aspx");
            BindGrid(dtFrom, dtTo);
            //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");
        }
        void BindGrid(DateTime FromDate, DateTime ToDate)
        {

            string cnt_internalId = Convert.ToString(HttpContext.Current.Session["owninternalid"]);//Session usercontactID
            //int UserId = Convert.ToInt32(HttpContext.Current.Session["userid"]);//Session UserID
            //FutureSalesDataSource.SelectCommand = "Select tbl_trans_Sales.sls_sales_status AS Status,(SELECT cnt_firstName+' '+isnull(cnt_middleName,'')+ ' ' +isnull(cnt_lastName,'') FROM tbl_master_contact WHERE cnt_internalId = tbl_trans_Sales.sls_contactlead_id) AS Name,(SELECT Top 1 ISNULL(add_address1, '') + ' , ' + ISNULL(add_address2, '') + ' , ' + ISNULL(add_address3, '') + ' [ ' + ISNULL(add_landMark, '') + ' ], '  + ISNULL(add_pin, '') FROM tbl_master_address WHERE add_cntId = sls_contactlead_id) AS Address,(SELECT Top 1 phf_phoneNumber FROM tbl_master_phoneFax WHERE phf_cntId = sls_contactlead_id) AS Phone,CASE tbl_trans_Sales.sls_ProductType WHEN 'IPO' THEN 'frmSalesIPO1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Mutual Fund' THEN 'frmSalesMutualFund1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Insurance' THEN 'frmSalesInsurance1.aspx?id=' + cast(sls_id AS varchar) ELSE 'frmSalesCommodity1.aspx?id=' + cast(sls_id AS varchar) END AS ProductTypePath,sls_ProductType as ProductType,tbl_trans_Sales.sls_id AS Id,tbl_trans_Sales.sls_estimated_value AS Amount, CASE isnull(sls_product, '') WHEN '' THEN tbl_trans_Sales.sls_productType ELSE (SELECT prds_description FROM tbl_master_products WHERE prds_internalId = sls_product) END AS Product,sls_contactlead_id as LeadId,case sls_nextvisitdate when '1/1/1900 12:00:00 AM' then ' ' else (convert(varchar(11),sls_nextvisitdate,113) +' '+ LTRIM(SUBSTRING(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 10, 5)+ RIGHT(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 3))) end as NextVisit From  tbl_trans_Sales ,tbl_trans_Activies  Where tbl_trans_Sales.sls_activity_id = tbl_trans_Activies.act_id AND tbl_trans_Activies.act_assignedTo ='" + UserId.ToString() + "' AND sls_sales_status in (3) Order by convert(datetime,sls_nextvisitdate,101)";
            SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
            SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
            SalesDetailsGridDataSource.SelectParameters.Clear();
            SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetails");
            SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
            SalesDetailsGridDataSource.SelectParameters.Add("ActivityTypeId", "1");
            SalesDetailsGridDataSource.SelectParameters.Add("Fromdate", Convert.ToString(FromDate));
            SalesDetailsGridDataSource.SelectParameters.Add("ToDate", Convert.ToString(ToDate));

            SalesDetailsGrid.DataBind();
            //int UserId = Convert.ToInt32(HttpContext.Current.Session["userid"]);//Session UserID
            //DocumentDataSource.SelectCommand = "Select tbl_trans_Sales.sls_sales_status AS Status,isnull((SELECT cnt_firstName+' ' +isnull(cnt_middleName,'')+' ' +isnull(cnt_lastName,'') FROM tbl_master_contact WHERE cnt_internalId = tbl_trans_Sales.sls_contactlead_id),(SELECT cnt_firstName+' ' +isnull(cnt_middleName,'')+' ' +isnull(cnt_lastName,'') FROM tbl_master_Contact WHERE cnt_internalId = tbl_trans_Sales.sls_contactlead_id))  AS Name,(SELECT Top 1 ISNULL(add_address1, '') + ' , ' + ISNULL(add_address2, '') + ' , ' + ISNULL(add_address3, '') + ' [ ' + ISNULL(add_landMark, '') + ' ], ' + ISNULL(add_pin, '') FROM tbl_master_address WHERE add_cntId = sls_contactlead_id) AS Address,(SELECT Top 1 phf_phoneNumber FROM tbl_master_phoneFax WHERE phf_cntId = sls_contactlead_id) AS Phone,CASE tbl_trans_Sales.sls_ProductType  WHEN 'Mutual Fund' THEN 'frmSalesMutualFund1.aspx?id=' + cast(sls_id AS varchar)WHEN 'Insurance-life'  THEN 'frmSalesInsurance1.aspx?id=' + cast(sls_id AS varchar)WHEN 'Insurance-general'  THEN 'frmSalesInsurance1.aspx?id=' + cast(sls_id AS varchar)WHEN 'Sub Broker' THEN 'frmSalesSubBroker.aspx?id='+cast(sls_id AS varchar) ELSE 'frmSalesCommodity1.aspx?id=' + cast(sls_id AS varchar) END AS ProductTypePath,sls_ProductType as ProductType,tbl_trans_Sales.sls_id AS Id,tbl_trans_Sales.sls_estimated_value AS Amount,CASE isnull(sls_product, '')   WHEN '' THEN tbl_trans_Sales.sls_productType ELSE (SELECT prds_description FROM tbl_master_products WHERE prds_internalId = sls_product) END AS Product,sls_contactlead_id as LeadId,case sls_nextvisitdate when '1/1/1900 12:00:00 AM' then ' ' else (convert(varchar(11),sls_nextvisitdate,113) +' '+ LTRIM(SUBSTRING(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 10, 5)+ RIGHT(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 3))) end as NextVisit FROM tbl_trans_Sales,tbl_trans_Activies WHERE tbl_trans_Sales.sls_activity_id = tbl_trans_Activies.act_id and tbl_trans_Activies.act_assignedTo ='" + UserId.ToString() + "' and sls_sales_status in (1) Order by sls_nextvisitdate";

        }
        //protected void DocumentGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        //{
        //    BindGrid();
        //}

        protected void SalesDetailsGrid_HtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            HyperLink hpnPh = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnPh");
            HyperLink hpnSv = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnSv");
            //    HyperLink hpnhis = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnhis");
            // HyperLink hpnOtheractv = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnOtheractv");
            HyperLink hpnOtheractvSms = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnOtheractvSms");
            HyperLink hpnOtheractvMeet = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnOtheractvMeet");
            HyperLink hpnOtheractvEmail = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnOtheractvEmail");
            Label lbkactivty = (Label)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lblactivty");

            Label lblProduct = (Label)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lblProduct");
            LinkButton lnkProduct = (LinkButton)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lnkProduct");


            Label lblProductClass = (Label)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lblProductClass");
            LinkButton lnkProductClass = (LinkButton)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lnkProductClass");


            if (Session["export"] == null)
            {
                string type = Convert.ToString(e.GetValue("act_Type"));
                string ProductName = Convert.ToString(e.GetValue("ProductName"));
                string ProductClassName = Convert.ToString(e.GetValue("ProductClasName"));
                string acttype = Convert.ToString(e.GetValue("act_activityTypes"));
                string priorityType = Convert.ToString(e.GetValue("act_priority"));
                string fl = Convert.ToString(e.GetValue("FLAG"));
                if (fl == "N")
                { e.Row.Cells[5].Attributes.Add("style", "color:Red;font-weight:bold"); }

                if (priorityType == "0")
                { e.Row.Cells[6].Attributes.Add("style", "color:rgb(245, 223, 195);font-weight:bold"); }
                else if (priorityType == "1")
                { e.Row.Cells[6].Attributes.Add("style", "color:rgb(102, 193, 155);font-weight:bold"); }
                else if (priorityType == "2")
                { e.Row.Cells[6].Attributes.Add("style", "color:rgb(53, 214, 103);font-weight:bold"); }
                else if (priorityType == "3")
                { e.Row.Cells[6].Attributes.Add("style", "color:rgb(255, 124, 124);font-weight:bold"); }
                else if (priorityType == "4")
                { e.Row.Cells[6].Attributes.Add("style", "color:rgb(249, 71, 7);font-weight:bold"); }
                //HyperLink hpnhis = (HyperLink)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "hpnhis");
                string salesid = Convert.ToString(e.GetValue("sls_id"));
                string ProductMultipleName = Convert.ToString(e.GetValue("MultipleProduct"));
                string ProductMultipleClassName = Convert.ToString(e.GetValue("MultipleProductClassName"));
                string AssignedById = Convert.ToString(e.GetValue("sls_assignedBy"));

                bool containsPhone = acttype.Contains("1");
                bool containsEmail = acttype.Contains("2");
                bool containsSms = acttype.Contains("3");
                bool containsSalesVisit = acttype.Contains("4");
                bool containsMeeting = acttype.Contains("5");
                bool containsSales = acttype.Contains("6");
                string CusId = Convert.ToString(e.GetValue("cnt_id"));
                if (containsPhone)
                {
                    hpnPh.Visible = true;
                    hpnPh.NavigateUrl = "../CRMPhoneCallWithFrame.aspx?TransSale=" + salesid + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=2";
                }
                else { hpnPh.Visible = false; }
                if (containsSalesVisit)
                {
                    hpnSv.NavigateUrl = "CRMSalesVisitWithIFrame.aspx?TransSale=" + salesid + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=2";
                    hpnSv.Visible = true;
                }
                else { hpnSv.Visible = false; }

                if (containsSms)
                {
                    hpnOtheractvSms.NavigateUrl = "CRMOtherActivities.aspx?TransSale=" + salesid + "&TypId=3" + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=2";
                    hpnOtheractvSms.Visible = true;
                }
                else { hpnOtheractvSms.Visible = false; }
                if (containsEmail)
                {
                    hpnOtheractvEmail.NavigateUrl = "CRMOtherActivities.aspx?TransSale=" + salesid + "&TypId=2" + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=2";
                    hpnOtheractvEmail.Visible = true;
                }
                else { hpnOtheractvEmail.Visible = false; }
                if (containsMeeting)
                {
                    hpnOtheractvMeet.NavigateUrl = "CRMOtherActivities.aspx?TransSale=" + salesid + "&TypId=5" + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=2";
                    hpnOtheractvMeet.Visible = true;
                }
                else { hpnOtheractvMeet.Visible = false; }


                if (type == "2" || type == "3")
                {
                    if (ProductMultipleName.IndexOf(",") > 0)
                    {

                        if (lnkProduct != null)
                        { lnkProduct.Visible = true; }
                        if (lblProduct != null)
                        {
                            lblProduct.Visible = false;
                        }
                    }
                    else
                    {
                        if (lnkProduct != null)
                        { lnkProduct.Visible = false; }
                        if (lblProduct != null)
                        {
                            lblProduct.Visible = true;
                            lblProduct.Text = ProductMultipleName;
                        }
                    }

                    if (ProductMultipleClassName.IndexOf(",") > 0)
                    {
                        if (lnkProductClass != null)
                        {
                            lnkProductClass.Visible = true;
                        }
                        if (lblProductClass != null)
                        {
                            lblProductClass.Visible = false;
                        }

                    }
                    else
                    {
                        if (lnkProductClass != null)
                        {
                            lnkProductClass.Visible = false;
                        }
                        if (lblProductClass != null)
                        {
                            lblProductClass.Visible = true;
                            lblProductClass.Text = ProductMultipleClassName;
                        }
                    }

                }
                else
                {
                    if (lnkProduct != null)
                    {
                        lnkProduct.Visible = false;
                    }
                    if (lblProduct != null)
                    {
                        lblProduct.Visible = true;
                        lblProduct.Text = ProductName;
                    }
                    if (lblProductClass != null)
                    {

                        lnkProductClass.Visible = false;
                        lblProductClass.Visible = true;
                        lblProductClass.Text = ProductClassName;
                    }
                }
                //if (!string.IsNullOrEmpty(Request.QueryString["frmdate"]) && !string.IsNullOrEmpty(Request.QueryString["todate"]))
                //{

                //    hpnhis.NavigateUrl = "../Master/ShowHistory_Phonecall.aspx?id1=" + salesid + "&frmdate=" + Request.QueryString["frmdate"] + "&todate=" + Request.QueryString["todate"];
                //}
                //else
                //{
                //    hpnhis.NavigateUrl = "../Master/ShowHistory_Phonecall.aspx?id1=" + salesid;
                //}
            }
        }

        protected void drdSalesActivityDetails_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["export"] = "1";
            Int32 Filter = int.Parse(Convert.ToString(drdSalesActivityDetails.SelectedItem.Value));
            if (Filter != 0)
            {
                if (Session["exportval"] == null)
                {
                    Session["exportval"] = Filter;
                    bindSalesActivityDetailsexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    Session["exportval"] = Filter;
                    bindSalesActivityDetailsexport(Filter);
                }
            }
        }
        public void bindSalesActivityDetailsexport(int Filter)
        {

            exporter.GridViewID = "SalesDetailsGrid";
            exporter.FileName = "SalesActivity_DocumentDetails";
            exporter.PageHeader.Left = "Sales Activity Document Details";
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";

            //SalesDetailsGrid.Columns[16].Visible = false;
            //SalesDetailsGrid.Columns[17].Visible = false;
            //SalesDetailsGrid.Columns[18].Visible = false;
            //SalesDetailsGrid.Columns[19].Visible = false;
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


        protected void AspxProductGrid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            DataTable DtProduct = new DataTable();
            DtProduct = objBL.GetProductByActivity(Convert.ToString(e.Parameters));


            AspxProductGrid.DataSource = DtProduct;
            AspxProductGrid.DataBind();
        }
        protected void AspxProductclassGrid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            DataTable DtProduct = new DataTable();
            DtProduct = objBL.GetProductCellsByActivity(Convert.ToString(e.Parameters));


            ASPxGridProductClass.DataSource = DtProduct;
            ASPxGridProductClass.DataBind();
        }
        protected void btMyactivities_Click(object sender, EventArgs e)
        {
            if (Session["cntId"] != null)
            {
                int salsmanId = Convert.ToInt32(Session["cntId"]);
                Response.Redirect("../Master/DailySalesReport.aspx?Salsmanid=" + salsmanId + "&returnId=2");
            }
            else
            {

                Response.Redirect("../CRMPhoneCallWithFrame.aspx");
            }
        }



        //protected void btMyPendingTask_Click(object sender, EventArgs e)
        //{
        //    if (Session["cntId"] != null)
        //    {
        //        int salsmanId = Convert.ToInt32(Session["cntId"]);
        //        Response.Redirect("../Master/PendingTaskReport.aspx?Salsmanid=" + salsmanId + "&returnId=2");
        //    }
        //    else
        //    {

        //        Response.Redirect("../CRMPhoneCallWithFrame.aspx");
        //    }
        //}
        protected void SalesDetailsGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            DateTime dtFrom;
            DateTime dtTo;
            dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
            dtTo = Convert.ToDateTime(ASPxToDate.Date);

            Session["Fromdate_D"] = dtFrom;
            Session["ToDate_D"] = dtTo;


            BindGrid(dtFrom, dtTo);

            string[] CallVal = e.Parameters.ToString().Split('~');
            if (CallVal[0].ToString() == "ClosedStatus")
            {
                string Id = Convert.ToString(CallVal[1].ToString());

                string userId = Convert.ToString(HttpContext.Current.Session["userid"]);
                int retValue = objBL.ClosedStatusActivity(userId, Id);
                if (retValue > 0)
                {
                    //  Session["KeyVal"] = "Closed";
                    SalesDetailsGrid.JSProperties["cpDelmsg"] = "Closed Sales";


                    BindGrid(dtFrom, dtTo);

                    // SalesDetailsGrid.DataBinding;
                }

            }
        }

    }
}