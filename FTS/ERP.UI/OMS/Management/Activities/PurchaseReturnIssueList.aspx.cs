﻿using System;
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


namespace ERP.OMS.Management.Activities
{
    public partial class PurchaseReturnIssueList : ERP.OMS.ViewState_class.VSPage// System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        PurchaseReturnBL objPurchaseReturnBL = new PurchaseReturnBL();

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
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/Management/Activities/PurchaseReturnIssueList.aspx");

            if (!IsPostBack)
            {
                if (Session["LastCompany"] != null && Session["LastCompany"] != null)
                {
                    string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);
                    GetFinacialYearBasedQouteDate();
                    string FinyearStartDate = Convert.ToString(Session["FinYearStartDate"]);
                    string FinYearEndDate = Convert.ToString(Session["FinYearEndDate"]);
                    GetPurchaseReturnIssueListGridData(userbranch, lastCompany, FinyearStartDate, FinYearEndDate);
                    GrdPurchaseReturnIssue.SettingsCookies.CookiesID = "BreeezeErpGridCookiesSalesPurchaseReturnIssueListDetailsGrid";
                    this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>addCookiesKeyOnStorage('BreeezeErpGridCookiesSalesPurchaseReturnIssueListDetailsGrid');</script>");

                }
            }
        }

        public void GetFinacialYearBasedQouteDate()
        {
            String finyear = "";
            if (Session["LastFinYear"] != null)
            {
                SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
                finyear = Convert.ToString(Session["LastFinYear"]).Trim();
                DataTable dtFinYear = objSlaesActivitiesBL.GetFinacialYearBasedQouteDate(finyear);
                if (dtFinYear != null && dtFinYear.Rows.Count > 0)
                {
                    Session["FinYearStartDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearStartDate"]);
                    Session["FinYearEndDate"] = Convert.ToString(dtFinYear.Rows[0]["finYearEndDate"]);

                }
            }
            //dt_PLQuote.Value = Convert.ToDateTime(oDBEngine.GetDate().ToString());
        }
        #region Export Grid Section Start
        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                if (Session["exportval"] == null)
                {
                    Session["exportval"] = Filter;
                    bindexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    Session["exportval"] = Filter;
                    bindexport(Filter);
                }
            }
        }
        public void bindexport(int Filter)
        {
            GrdPurchaseReturnIssue.Columns[5].Visible = false;
            string filename = "Return Against GRN";
            exporter.FileName = filename;
            exporter.FileName = "Return Against GRN";

            exporter.PageHeader.Left = "Return Against GRN";
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

        #endregion

        [WebMethod]
        public static string GetEditablePermission(string ActiveUser)
        {
            CRMSalesDtlBL objCRMSalesDtlBL = new CRMSalesDtlBL();
            int ispermission = 0;
            ispermission = objCRMSalesDtlBL.QuotationEditablePermission(Convert.ToInt32(ActiveUser));
            return Convert.ToString(ispermission);
        }

        #region Export Grid Section Start

        protected void GrdPurchaseReturnIssue_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string Command = Convert.ToString(e.Parameters).Split('~')[0];
            if (Command == "Delete")
            {
                string PurchaseReturnIssueID = Convert.ToString(e.Parameters).Split('~')[1];
                int deletecnt = 0;
                deletecnt = objPurchaseReturnBL.DeletePurchaseReturn(PurchaseReturnIssueID, Convert.ToString(HttpContext.Current.Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]),  Convert.ToString(Session["userbranchID"]));
                GrdPurchaseReturnIssue.JSProperties["cpDelete"] = "Deleted successfully.";
                //if (deletecnt>0)
                //{ GrdSalesReturn.JSProperties["cpDelete"] = "Deleted successfully."; }
                //else { GrdSalesReturn.JSProperties["cpDelete"] = "Please try again."; }


            }
        }
        public void GetPurchaseReturnIssueListGridData(string userbranch, string lastCompany, string FinyearStartDate, string FinYearEndDate)
        {
            DataTable dtdata = new DataTable();
            dtdata = objPurchaseReturnBL.GetPurchaseReturnIssueListGridData(userbranch, lastCompany, "PC", FinyearStartDate, FinYearEndDate);
            if (dtdata != null && dtdata.Rows.Count > 0)
            {
                GrdPurchaseReturnIssue.DataSource = dtdata;
                GrdPurchaseReturnIssue.DataBind();
            }
            else
            {
                GrdPurchaseReturnIssue.DataSource = null;
                GrdPurchaseReturnIssue.DataBind();
            }
        }

        #endregion

        protected void GrdPurchaseReturnIssue_DataBinding(object sender, EventArgs e)
        {
            string lastCompany = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
            string userbranch = Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]);

            string FinyearStartDate = Convert.ToString(Session["FinYearStartDate"]);
            string FinYearEndDate = Convert.ToString(Session["FinYearEndDate"]);
          
            DataTable dtdata = new DataTable();
            dtdata = objPurchaseReturnBL.GetPurchaseReturnIssueListGridData(userbranch, lastCompany, "PC", FinyearStartDate, FinYearEndDate);
            if (dtdata != null && dtdata.Rows.Count > 0)
            {
                GrdPurchaseReturnIssue.DataSource = dtdata;

            }
            else
            {
                GrdPurchaseReturnIssue.DataSource = null;

            }
        }

    }
}