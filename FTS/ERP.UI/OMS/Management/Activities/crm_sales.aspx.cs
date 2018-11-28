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
using BusinessLogicLayer;
namespace ERP.OMS.Management.Activities
{
    public partial class management_Activities_crm_sales : ERP.OMS.ViewState_class.VSPage// System.Web.UI.Page
    {
        public string pageAccess = "";
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        BusinessLogicLayer.Others objBL= new BusinessLogicLayer.Others();
        string[] lengthIndex;
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
                string EditPermitValue = string.Empty;
                string cnt_id = Convert.ToString(Session["cntId"]);
              
                    EditPermitValue = EditPermissionShow( cnt_id);
            
                if (EditPermitValue == "1")
                {
                  

                    ASPxPageControl1.TabPages.FindByName("Document Collection").ClientEnabled = false;
                }
                else
                {
                  
                    ASPxPageControl1.TabPages.FindByName("Document Collection").ClientEnabled = true;
                }


                if (Request.QueryString["frmdate"] != null && Request.QueryString["todate"] != null)
                {
                    ASPxFromDate.Text = Request.QueryString["frmdate"];
                    ASPxToDate.Text = Request.QueryString["todate"];

                    dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                    dtTo = Convert.ToDateTime(ASPxToDate.Date);
                }


                else
                {

                    if (Session["Fromdate"] != null && Session["ToDate"] != null)
                    {

                        ASPxFromDate.Text = Convert.ToDateTime(Session["Fromdate"]).ToString("dd-MM-yyyy");
                        ASPxToDate.Text = Convert.ToDateTime(Session["ToDate"]).ToString("dd-MM-yyyy");

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
                Session["exportval"] = null;
                SalesDetailsGrid.SettingsCookies.CookiesID = "BreeezeErpGridCookiesSalesDetailsGrid";
                this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>addCookiesKeyOnStorage('BreeezeErpGridCookiesSalesDetailsGrid');</script>");
            }
            else
            {
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);
            }

            Session["export"] = null;
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Activities/crm_sales.aspx");
           // BindGrid();
            BindSalesActivityGrid(dtFrom, dtTo);
            //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");
        }


        protected void btMyPendingTask_Click(object sender, EventArgs e)
        {
            if (Session["cntId"] != null)
            {
                int salsmanId = Convert.ToInt32(Session["cntId"]);
                Response.Redirect("../Master/PendingTaskReport.aspx?Salsmanid=" + salsmanId + "&returnId=1");
            }
            else
            {

                Response.Redirect("../CRMPhoneCallWithFrame.aspx");
            }
        }
        protected void SalesGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {

            DateTime dtFrom;
            DateTime dtTo;
            dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
            dtTo = Convert.ToDateTime(ASPxToDate.Date);

            Session["Fromdate"]=dtFrom;
            Session["ToDate"] = dtTo;


            BindGrid();

         // BindSalesActivityGrid();
        }


        public string EditPermissionShow(string cntid)
        {


            string EditPermissionval = "0";
            try
            {
                BusinessLogicLayer.Others objOtherBL = new BusinessLogicLayer.Others();

                DataTable PermissionDt = new DataTable();
                PermissionDt = objOtherBL.GetSalesManDeactivateDocomentActivity(cntid);
                if (PermissionDt != null && PermissionDt.Rows.Count > 0)
                {
                    EditPermissionval = Convert.ToString(PermissionDt.Rows[0]["EditPermission"]);

                }


            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Notify", "alert('Server Internal Error.Please try again');", true);
                //return;
            }


            return EditPermissionval;
        }


        void BindGrid()
        {
            int UserId = Convert.ToInt32(HttpContext.Current.Session["userid"]);//Session UserID

           // SalesDataSource.SelectCommand = "Select  tbl_trans_Sales.sls_sales_status AS Status,isnull((SELECT cnt_firstName+' ' +isnull(cnt_middleName,'')+' ' +isnull(cnt_lastName,'')FROM tbl_master_contact WHERE cnt_internalId = tbl_trans_Sales.sls_contactlead_id),(SELECT cnt_firstName+' ' +isnull(cnt_middleName,'')+' ' +isnull(cnt_lastName,'') FROM tbl_master_contact WHERE cnt_internalId = tbl_trans_Sales.sls_contactlead_id))  AS Name,(SELECT Top 1 ISNULL(add_address1, '') + ' , ' + ISNULL(add_address2, '') + ' , ' + ISNULL(add_address3, '') + ' [ ' + ISNULL(add_landMark, '') + ' ], ' + ISNULL(add_pin, '') FROM tbl_master_address WHERE add_cntId = sls_contactlead_id) AS Address,(SELECT Top 1 phf_phoneNumber FROM tbl_master_phoneFax WHERE phf_cntId = sls_contactlead_id) AS Phone,CASE tbl_trans_Sales.sls_ProductType WHEN 'Mutual Fund' THEN 'frmSalesMutualFund1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Insurance-life'  THEN 'frmSalesInsurance1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Insurance-general'  THEN 'frmSalesInsurance1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Sub Broker'	THEN 'frmSalesSubBroker.aspx?id='+cast(sls_id AS varchar) ELSE 'frmSalesCommodity1.aspx?id=' + cast(sls_id AS varchar) END AS ProductTypePath,sls_ProductType as ProductType,tbl_trans_Sales.sls_id AS Id, tbl_trans_Sales.sls_estimated_value AS Amount,CASE isnull(sls_product, '') WHEN ''THEN tbl_trans_Sales.sls_productType ELSE (SELECT prds_description FROM tbl_master_products WHERE prds_internalId = sls_product) END AS Product,sls_contactlead_id as LeadId, case sls_nextvisitdate when '1/1/1900 12:00:00 AM' then ' ' else (convert(varchar(11),sls_nextvisitdate,113) +' '+ LTRIM(SUBSTRING(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 10, 5)+ RIGHT(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 3))) end as NextVisit From  tbl_trans_Sales , tbl_trans_Activies Where tbl_trans_Sales.sls_activity_id = tbl_trans_Activies.act_id AND tbl_trans_Activies.act_assignedTo ='" + UserId.ToString() + "' and sls_sales_status=4 Order by convert(datetime,sls_nextvisitdate,101) ";
           //kaushik 19_12_2016 
          //  SalesDataSource.SelectCommand = "Select  tbl_trans_Sales.sls_sales_status AS Status,isnull((SELECT cnt_firstName+' ' +isnull(cnt_middleName,'')+' ' +isnull(cnt_lastName,'')FROM tbl_master_contact WHERE cnt_internalId = tbl_trans_Sales.sls_contactlead_id),(SELECT cnt_firstName+' ' +isnull(cnt_middleName,'')+' ' +isnull(cnt_lastName,'') FROM tbl_master_contact WHERE cnt_internalId = tbl_trans_Sales.sls_contactlead_id))  AS Name,(SELECT Top 1 ISNULL(add_address1, '') + ' , ' + ISNULL(add_address2, '') + ' , ' + ISNULL(add_address3, '') + ' [ ' + ISNULL(add_landMark, '') + ' ], ' + ISNULL(add_pin, '') FROM tbl_master_address WHERE add_cntId = sls_contactlead_id) AS Address,(SELECT Top 1 phf_phoneNumber FROM tbl_master_phoneFax WHERE phf_cntId = sls_contactlead_id) AS Phone,CASE tbl_trans_Sales.sls_ProductType WHEN 'Mutual Fund' THEN 'frmSalesMutualFund1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Insurance-life'  THEN 'frmSalesInsurance1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Insurance-general'  THEN 'frmSalesInsurance1.aspx?id=' + cast(sls_id AS varchar) WHEN 'Sub Broker'	THEN 'frmSalesSubBroker.aspx?id='+cast(sls_id AS varchar) ELSE 'frmSalesCommodity1.aspx?id=' + cast(sls_id AS varchar) END AS ProductTypePath,sls_ProductType as ProductType,tbl_trans_Sales.sls_id AS Id, tbl_trans_Sales.sls_estimated_value AS Amount,CASE isnull(sls_product, '') WHEN ''THEN tbl_trans_Sales.sls_productType ELSE (SELECT prds_description FROM tbl_master_products WHERE prds_internalId = sls_product) END AS Product,sls_contactlead_id as LeadId, case sls_nextvisitdate when '1/1/1900 12:00:00 AM' then ' ' else (convert(varchar(11),sls_nextvisitdate,113) +' '+ LTRIM(SUBSTRING(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 10, 5)+ RIGHT(CONVERT(VARCHAR(20), sls_nextvisitdate, 22), 3))) end as NextVisit From  tbl_trans_Sales , tbl_trans_Activies Where tbl_trans_Sales.sls_activity_id = tbl_trans_Activies.act_id AND  sls_sales_status=4 Order by convert(datetime,sls_nextvisitdate,101) ";
            SalesDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
            SalesDataSource.SelectCommand = "sp_Sales";
            SalesDataSource.SelectParameters.Clear();
            SalesDataSource.SelectParameters.Add("Mode", "GetSales");

            SaleGrid.DataBind();

        }
        void BindSalesActivityGrid(DateTime FromDate, DateTime ToDate)
        {

            //SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
            //SalesDetailsGridDataSource.SelectCommand = "AddNewProduct";
            //SalesDetailsGridDataSource.SelectParameters.Clear();
            //SalesDetailsGridDataSource.SelectParameters.Add("Module", "GetSalesActivityDetails");

            //SalesDetailsGrid.DataBind();
                string cnt_internalId = Convert.ToString(HttpContext.Current.Session["owninternalid"]);//Session usercontactID
                SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                SalesDetailsGridDataSource.SelectParameters.Clear();
                SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetails");
                SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                SalesDetailsGridDataSource.SelectParameters.Add("ActivityTypeId", "4");
                SalesDetailsGridDataSource.SelectParameters.Add("Fromdate", Convert.ToString(FromDate));
                SalesDetailsGridDataSource.SelectParameters.Add("ToDate", Convert.ToString(ToDate));
        
                SalesDetailsGrid.DataBind();
        
                   
        }


        protected void btMyPendingActivity_Click(object sender, EventArgs e)
        {
            if (Session["cntId"] != null)
            {
                int salsmanId = Convert.ToInt32(Session["cntId"]);




                string frmdate = Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy");
                string todate = Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
                Response.Redirect("TodayTask.aspx?Id=4&frmdate=" + frmdate + "&todate=" + todate);
            }
            else
            {

                Response.Redirect("~/OMS/Management/ProjectMainPage.aspx");
            }
        }
        protected void SGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                string[] CallVal = e.Parameters.ToString().Split('~');
                lengthIndex = e.Parameters.Split('~');

                if (CallVal[0].ToString() == "Delete")
                {
                    string Id = Convert.ToString(CallVal[1].ToString());
                    int retValue = objBL.DeleteSalesActivity(Convert.ToInt32(Id));
                    if (retValue > 0)
                    {
                        Session["KeyVal"] = "Succesfully Deleted";
                        SaleGrid.JSProperties["cpDelmsg"] = "Succesfully Deleted";
                      
                        BindGrid();
                    }
                    else
                    {
                        Session["KeyVal"] = " Cannot Delete.";
                        SaleGrid.JSProperties["cpDelmsg"] = "Used in other modules. Cannot Delete.";
                      //  SGrid.DataBind();

                    }
                }
              

              
            }
            catch { }
        }


        protected void SalesDetailsGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            int i=0;
            SalesDetailsGrid.JSProperties["cpSave"] = null;
          
            //try
            //{
            //    string[] CallVal = e.Parameters.ToString().Split('~');
            //    lengthIndex = e.Parameters.Split('~');

            //    if (CallVal[0].ToString() == "Details")               
            //    {
            //         string Id = Convert.ToString(CallVal[1].ToString());
            //         string AssignedId = Convert.ToString(CallVal[2].ToString());
            //         SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
            //         SalesDetailsGridDataSource.SelectCommand = "AddNewProduct";
            //         SalesDetailsGridDataSource.SelectParameters.Clear();
            //         SalesDetailsGridDataSource.SelectParameters.Add("Module", "GetSalesDetails");
            //         SalesDetailsGridDataSource.SelectParameters.Add("SalesActivityID", Id);
            //         SalesDetailsGrid.DataBind();
            //         Session["AssignedTaskId"] = AssignedId;
            //         Session["act_id"] = Id;
            //    }
            //}
            //catch { }

            try
            {
                DateTime dtFrom;
                DateTime dtTo;
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);




                Session["Fromdate"] = dtFrom;
                Session["ToDate"] = dtTo;


                string[] CallVal = e.Parameters.ToString().Split('~');
                lengthIndex = e.Parameters.Split('~');

                BindSalesActivityGrid(dtFrom, dtTo);


                if (CallVal[0].ToString() == "ClosedStatus")
                {
                    string Id = Convert.ToString(CallVal[1].ToString());

                    string userId = Convert.ToString(HttpContext.Current.Session["userid"]);
                    int retValue = objBL.ClosedStatusActivity(userId, Id);
                    if (retValue > 0)
                    {
                        //  Session["KeyVal"] = "Closed";
                        SalesDetailsGrid.JSProperties["cpDelmsg"] = "Closed Sales";
                      

                        BindSalesActivityGrid(dtFrom, dtTo);

                        // SalesDetailsGrid.DataBinding;
                    }

                }
                if (CallVal[0].ToString() == "CreateActivity")
                {
                    string LeadId = Convert.ToString(CallVal[1].ToString());
                    string sls_id = Convert.ToString(CallVal[2].ToString());

                    string sls_activity_id = Convert.ToString(CallVal[3].ToString());
                    string act_assignedTo = Convert.ToString(CallVal[4].ToString());
                    string act_activityNo = Convert.ToString(CallVal[5].ToString());
                    string act_assign_task = Convert.ToString(CallVal[6].ToString());
                    Session["AssignedActivity"] = LeadId;
                    Session["AssignedSalesId"] = sls_id;

                    Session["AssignedTaskId"] = act_assignedTo;
                    Session["act_id"] = sls_activity_id;
                    Session["act_activityNo"] = act_activityNo;
                    Session["act_assign_task"] = act_assign_task;
                    Session["CrmPhoneCallActivityUrl"] = "../Activities/crm_Sales.aspx";
                    SalesDetailsGrid.JSProperties["cpredirect"] = "../ActivityManagement/CrmPhoneCallActivityWithIFrame.aspx";

                    //Response.Redirect("../ActivityManagement/CrmPhoneCallActivityWithIFrame.aspx");
                }
                if (CallVal[0].ToString() == "Disposition")
                {
                    string Id = Convert.ToString(CallVal[1].ToString());
                    string cnt_internalId = Convert.ToString(HttpContext.Current.Session["owninternalid"]);//Session usercontactID
                    BusinessLogicLayer.Others obl = new BusinessLogicLayer.Others();
                    Session["disposeId"] = Id;
                    Session["SalesVisitCallId"] = "";
                    if(Id=="1")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsByNewCallDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }

                    else if (Id == "2")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsByCallBackDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "3")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsNonContractableDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "4")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsNonUsableDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "5")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsWonConfirmDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "6")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailLostNonInterestedDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "7")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsByPipeLineSalesDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "8")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsByNoResponseDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "9")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsByNotReachableDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "10")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsByNumberNotExistDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "11")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsByTempOutServiceDisposition");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else
                    {
                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetails");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                   
                   

                }


                if (CallVal[0].ToString() == "SalesVisit")
                {
                    string Id = Convert.ToString(CallVal[1].ToString());
                    string cnt_internalId = Convert.ToString(HttpContext.Current.Session["owninternalid"]);//Session usercontactID
                    BusinessLogicLayer.Others obl = new BusinessLogicLayer.Others();
                    Session["SalesVisitCallId"] = Id;
                    Session["disposeId"] = "";
                 
                    if (Id == "1")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsBySalesVisitPending");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }

                    else if (Id == "2")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsBySalesVisitOpen");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "3")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsBySalesVisitClosed");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else if (Id == "4")
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetailsBySalesVisitConfirm");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                    else 
                    {

                        SalesDetailsGridDataSource.SelectCommandType = System.Web.UI.WebControls.SqlDataSourceCommandType.StoredProcedure;
                        SalesDetailsGridDataSource.SelectCommand = "sp_Sales";
                        SalesDetailsGridDataSource.SelectParameters.Clear();
                        SalesDetailsGridDataSource.SelectParameters.Add("Mode", "GetSalesActivityDetails");
                        SalesDetailsGridDataSource.SelectParameters.Add("cnt_internalId", cnt_internalId);
                        SalesDetailsGrid.DataBind();
                    }
                }
                
            }
            catch { }
        }



        //protected void drdSalesActivity_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    Int32 Filter = int.Parse(drdSalesActivity.SelectedItem.Value.ToString());
        //    exporter.GridViewID = "GvAddRecordDisplay";
        //    exporter.FileName = "SaleGrid";
        //    switch (Filter)
        //    {
        //        case 1:
        //            exporter.WritePdfToResponse();
        //            break;
        //        case 2:
        //            exporter.WriteXlsToResponse();
        //            break;
        //        case 3:
        //            exporter.WriteRtfToResponse();
        //            break;
        //        case 4:
        //            exporter.WriteCsvToResponse();
        //            break;
        //    }
        //}

        //protected void drdSalesActivityDetails_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    Int32 Filter = int.Parse(drdSalesActivityDetails.SelectedItem.Value.ToString());
        //    exporter.GridViewID = "SalesDetailsGrid";
        //    exporter.FileName = "SalesActivityDetails";
        //    switch (Filter)
        //    {
        //        case 1:
        //            exporter.WritePdfToResponse();
        //            break;
        //        case 2:
        //            exporter.WriteXlsToResponse();
        //            break;
        //        case 3:
        //            exporter.WriteRtfToResponse();
        //            break;
        //        case 4:
        //            exporter.WriteCsvToResponse();
        //            break;
        //    }
        //}

        protected void drdSalesActivity_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdSalesActivity.SelectedItem.Value));
            if (Filter != 0)
            {
                if (Session["exportval"] == null)
                {
                    Session["exportval"] = Filter;
                    bindSalesActivityexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    Session["exportval"] = Filter;
                    bindSalesActivityexport(Filter);
                }
            }
        }
        public void bindSalesActivityexport(int Filter)
        {

            exporter.GridViewID = "GvAddRecordDisplay";
            exporter.FileName = "SaleActivity";
            exporter.PageHeader.Left = "SaleActivity";
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
            exporter.FileName = "SalesActivityDetails";
            exporter.PageHeader.Left = "Sales Activity Details";
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";
            //SalesDetailsGrid.Columns[12].Visible = false;
            //SalesDetailsGrid.Columns[13].Visible = false;
           // SalesDetailsGrid.Columns[16].Visible = false;
           // SalesDetailsGrid.Columns[17].Visible = false;
            //SalesDetailsGrid.Columns[18].Visible = false;
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
        protected void btnActivity_Click(object sender, EventArgs e)
        {
            string temp = string.Empty;
            string tempSales = string.Empty;
            string tempact_id = string.Empty;
            string tempAssignedTaskId = string.Empty;
            DataTable dt = new DataTable();
            for (int i = 0; i < SalesDetailsGrid.VisibleRowCount; i++)
            {

                GridViewDataColumn col1 = SalesDetailsGrid.Columns[0] as GridViewDataColumn;
                ASPxCheckBox chkIsVal = SalesDetailsGrid.FindRowCellTemplateControl(i, col1, "chkDetail") as ASPxCheckBox;

                if (chkIsVal != null)
                {
                    //if (chkDetail.Checked == true)
                    if (chkIsVal.Checked == true)
                    {

                        ASPxTextBox lbls = SalesDetailsGrid.FindRowCellTemplateControl(i, col1, "lblActNo") as ASPxTextBox;

                        ASPxTextBox lblSalesId = SalesDetailsGrid.FindRowCellTemplateControl(i, col1, "lblSalesId") as ASPxTextBox;


                        ASPxTextBox lblact_id = SalesDetailsGrid.FindRowCellTemplateControl(i, col1, "lblact_id") as ASPxTextBox;

                        ASPxTextBox lblAssignedTaskId = SalesDetailsGrid.FindRowCellTemplateControl(i, col1, "lblAssignedTaskId") as ASPxTextBox;
                        string lbl = Convert.ToString(lbls.Text);
                        string lblSales = Convert.ToString(lblSalesId.Text);
                        string lblact = Convert.ToString(lblact_id.Text);
                        string lblassign = Convert.ToString(lblAssignedTaskId.Text);
                        if (lbl != string.Empty)
                        {

                          
                            temp += lbl;

                            //  break;
                        }

                        if (lblSales != string.Empty)
                        {

                         
                            tempSales += lblSales;

                            //  break;
                        }

                        if (lbl != string.Empty)
                        {


                            tempact_id += lblact;

                            //  break;
                        }

                        if (lblSales != string.Empty)
                        {


                            tempAssignedTaskId += lblassign;

                            //  break;
                        }
                    }
                }
            }

            Session["AssignedActivity"] = temp;
            Session["AssignedSalesId"] = tempSales;

            Session["AssignedTaskId"] = tempAssignedTaskId;
            Session["act_id"] = tempact_id;
          
            Response.Redirect("../ActivityManagement/CrmPhoneCallActivityWithIFrame.aspx");
        }
        protected void btnPhone_Click(object sender, EventArgs e)
        {

            Response.Redirect("../CRMPhoneCallWithFrame.aspx");
        }

        protected void btMyactivities_Click(object sender, EventArgs e)
        {
            if (Session["cntId"] != null)
            {
                int salsmanId = Convert.ToInt32(Session["cntId"]);
                Response.Redirect("../Master/DailySalesReport.aspx?Salsmanid=" + salsmanId+"&returnId=1");
            }
            else
            {

                Response.Redirect("../CRMPhoneCallWithFrame.aspx");
            }
        }



        [WebMethod]
        public static List<string> GetAllUserListBeforeSelect()
        {
            StringBuilder filter = new StringBuilder();
            Employee_BL objemployeebal = new Employee_BL();
            string owninterid = Convert.ToString(HttpContext.Current.Session["owninternalid"]);
            DataTable dtbl = new DataTable();

            dtbl = objemployeebal.GetAssignedEmployeeDetailByReportingTo(owninterid);


            List<string> obj = new List<string>();

            foreach (DataRow dr in dtbl.Rows)
            {

                obj.Add(Convert.ToString(dr["name"]) + "|" + Convert.ToString(dr["cnt_id"]));
            }



            return obj;
        }

    

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
            Label lblCustomerName = (Label)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lblCustomerName");



            Label lblProduct = (Label)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lblProduct");
            Label lblProductClass = (Label)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lblProductClass");

            LinkButton lnkProduct = (LinkButton)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lnkProduct");
            LinkButton lnkProductClass = (LinkButton)SalesDetailsGrid.FindRowCellTemplateControl(e.VisibleIndex, null, "lnkProductClass");

            if (Session["export"] == null)
            {
                string acttype = Convert.ToString(e.GetValue("act_activityTypes"));
                string priorityType = Convert.ToString(e.GetValue("act_priority"));
                string nextactivitystatus = Convert.ToString(e.GetValue("nextactivitystatus"));
                string fl =Convert.ToString(e.GetValue("FLAG"));
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

                string type = Convert.ToString(e.GetValue("act_Type"));
                string ProductName = Convert.ToString(e.GetValue("ProductName"));
                string ProductClassName = Convert.ToString(e.GetValue("ProductClasName"));


                 string ProductMultipleName = Convert.ToString(e.GetValue("MultipleProduct"));
                string ProductMultipleClassName = Convert.ToString(e.GetValue("MultipleProductClassName"));
                string salesid = Convert.ToString(e.GetValue("sls_id"));
                bool containsPhone = acttype.Contains("1");
                bool containsEmail = acttype.Contains("2");
                bool containsSms = acttype.Contains("3");
                bool containsSalesVisit = acttype.Contains("4");
                bool containsMeeting = acttype.Contains("5");
                bool containsSales = acttype.Contains("6");
                string CusName = Convert.ToString(e.GetValue("Name"));
                string CusId = Convert.ToString(e.GetValue("cnt_id"));
                string AssignedById = Convert.ToString(e.GetValue("sls_assignedBy"));


                if (nextactivitystatus == "2")
                {
                    hpnPh.Visible = true;
                    hpnPh.NavigateUrl = "../CRMPhoneCallWithFrame.aspx?TransSale=" + salesid + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=1";
                    hpnSv.Visible = false;
                    hpnOtheractvSms.Visible = false;
                    hpnOtheractvEmail.Visible = false;
                    hpnOtheractvMeet.Visible = false; 
                }
                else
                {

                    if (containsPhone)
                    {
                        hpnPh.Visible = true;
                        hpnPh.NavigateUrl = "../CRMPhoneCallWithFrame.aspx?TransSale=" + salesid + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=1";
                       

                    }
                    else { hpnPh.Visible = false; }
                    if (containsSalesVisit)
                    {
                        if (string.IsNullOrEmpty(lblCustomerName.Text))
                        {

                            Session["CustomerLabel"] = lblCustomerName.Text;
                        }
                        hpnSv.NavigateUrl = "CRMSalesVisitWithIFrame.aspx?TransSale=" + salesid + "&Name=" + CusName + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=1";
                        hpnSv.Visible = true;
                    }
                    else { hpnSv.Visible = false; }

                    if (containsSms)
                    {
                        hpnOtheractvSms.NavigateUrl = "CRMOtherActivities.aspx?TransSale=" + salesid + "&TypId=3" + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=1";
                        hpnOtheractvSms.Visible = true;
                    }
                    else { hpnOtheractvSms.Visible = false; }
                    if (containsEmail)
                    {
                        hpnOtheractvEmail.NavigateUrl = "CRMOtherActivities.aspx?TransSale=" + salesid + "&TypId=2" + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=1";
                        hpnOtheractvEmail.Visible = true;
                    }
                    else { hpnOtheractvEmail.Visible = false; }
                    if (containsMeeting)
                    {
                        hpnOtheractvMeet.NavigateUrl = "CRMOtherActivities.aspx?TransSale=" + salesid + "&TypId=5" + "&Assigned=" + AssignedById + "&type=" + type + "&Cid=" + CusId + "&Pid=1";
                        hpnOtheractvMeet.Visible = true;
                    }
                    else { hpnOtheractvMeet.Visible = false; }
                }

                if (type == "2" || type == "3")
                {
                    if(ProductMultipleName.IndexOf(",")>0)
                    {

                        if (lnkProduct!=null)
                        { lnkProduct.Visible = true; }
                        if (lblProduct != null)
                        {
                            lblProduct.Visible = false;
                        }
                    }
                    else {
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
                //if (containsEmail || containsSms || containsMeeting || containsSales)
                //{
                //    hpnOtheractv.NavigateUrl = "CRMOtherActivities.aspx?TransSale=" + salesid;
                //    hpnOtheractv.Visible = false;
                //}
                //else { hpnOtheractv.Visible = false; }

            //    hpnhis.NavigateUrl = "../Master/ShowHistory_Phonecall.aspx?id1=" + salesid;
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
    }
}