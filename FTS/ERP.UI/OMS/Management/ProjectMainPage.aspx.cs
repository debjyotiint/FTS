﻿using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.IO;
using BusinessLogicLayer;
using ERP.Models;
using BusinessLogicLayer.SalesmanTrack;
using UtilityLayer;
namespace ERP.OMS.Management
{
    public partial class management_ProjectMainPage : System.Web.UI.Page
    {

        Dashboard dashbrd = new Dashboard();
        DataTable dtdashboard = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var page = HttpContext.Current.Handler as Page;
                Response.Redirect(page.GetRouteUrl("DefaultMap",
                    new { Controller = "DashboardMenu", Action = "Dashboard" }), false);

                //string userid = Session["userid"].ToString();
                //dtdashboard = dashbrd.GetFtsDashboardyList(userid);
                //DashboardMyshop model = new DashboardMyshop();
                //model = APIHelperMethods.ToModel<DashboardMyshop>(dtdashboard);
                //lbltotaluser.InnerText = Convert.ToString(model.usercount);
                //lbltotshop.InnerText = Convert.ToString(model.shopcount);
                //lblactive.InnerText = Convert.ToString(model.activeusercount);
                //lblinactive.InnerText = Convert.ToString(model.Nonactiveuser);

            }
            catch
            {

                Response.Redirect("/oms/Login.aspx");
            }
        }
       
    }
}