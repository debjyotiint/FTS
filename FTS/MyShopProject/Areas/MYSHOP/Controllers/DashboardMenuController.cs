using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Models;
using BusinessLogicLayer;
using SalesmanTrack;
using System.Data;
using UtilityLayer;
using System.Web.Script.Serialization;
using MyShop.Models;
using BusinessLogicLayer.SalesmanTrack;
using DevExpress.Web.Mvc;


namespace MyShop.Areas.MYSHOP.Controllers
{
    public class DashboardMenuController : Controller
    {
        Dashboard dashbrd= new Dashboard();
        DataTable dtdashboard = new DataTable();
        public ActionResult Dashboard()
        {
            try
            {
                ActivityInput omodel = new ActivityInput();
                string userid = Session["userid"].ToString();
                dtdashboard = dashbrd.GetFtsDashboardyList(userid);
                DashboardModelC model = new DashboardModelC();
                model = APIHelperMethods.ToModel<DashboardModelC>(dtdashboard);
                TempData["Getdata"] = model;
                return View(model);
            }

            catch
            {
                return RedirectToAction("Logout", "Login", new { Area = "" });
            }
        }
	}
}