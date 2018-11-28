﻿using System;
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
using DevExpress.Web;


namespace MyShop.Areas.MYSHOP.Controllers
{
    public class GPSStatusController : Controller
    {
        // GET: /MYSHOP/GPSStatus/
        UserList lstuser = new UserList();
        GpsListBL objgps = new GpsListBL();
        DataTable dtuser = new DataTable();
        DataTable dtstate = new DataTable();
        DataTable dtshop = new DataTable();

        public ActionResult List()
        {
            try
            {

                GpsStatusClassInput omodel = new GpsStatusClassInput();
                string userid = Session["userid"].ToString();
                dtuser = lstuser.GetUserList(userid);
                // dtuser = lstuser.GetUserList();
                List<GetUserName> model = new List<GetUserName>();

                model = APIHelperMethods.ToModelList<GetUserName>(dtuser);
                omodel.userlsit = model;
                omodel.selectedusrid = userid;
                omodel.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
                omodel.Todate = DateTime.Now.ToString("dd-MM-yyyy");


                if (TempData["Gpsuser"] != null)
                {
                    omodel.selectedusrid = TempData["Gpsuser"].ToString();

                    TempData.Clear();
                }
                return View(omodel);


            }
            catch
            {
                return RedirectToAction("Logout", "Login", new { Area = "" });
            }

        }


        public ActionResult GetGpsStatusList(GpsStatusClassInput model)
        {
            try
            {
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                List<GpsStatusClasstOutput> omel = new List<GpsStatusClasstOutput>();

                DataTable dt = new DataTable();

                if (model.Fromdate == null)
                {
                    model.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
                }

                if (model.Todate == null)
                {
                    model.Todate = DateTime.Now.ToString("dd-MM-yyyy");
                }

                ViewData["ModelData"] = model;

                string datfrmat = model.Fromdate.Split('-')[2] + '-' + model.Fromdate.Split('-')[1] + '-' + model.Fromdate.Split('-')[0];
                string dattoat = model.Todate.Split('-')[2] + '-' + model.Todate.Split('-')[1] + '-' + model.Todate.Split('-')[0];

                dt = objgps.GetGpsList(datfrmat, dattoat, model.selectedusrid);



                if (dt.Rows.Count > 0)
                {

                    omel = APIHelperMethods.ToModelList<GpsStatusClasstOutput>(dt);
                    TempData["ExporGPS"] = omel;
                    TempData.Keep();

                }
                else
                {
                    return PartialView("_PartialGPSStatusList", omel);

                }
                return PartialView("_PartialGPSStatusList", omel);
            }
            catch
            {
                return RedirectToAction("Logout", "Login", new { Area = "" });

            }
        }

        public ActionResult GetGpsStatusList1()
        {
            try
            {

                GpsStatusClassInput model = new GpsStatusClassInput();
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                List<GpsStatusClasstOutput> omel = new List<GpsStatusClasstOutput>();

                DataTable dt = new DataTable();

                if (model.Fromdate == null)
                {
                    model.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
                }

                if (model.Todate == null)
                {
                    model.Todate = DateTime.Now.ToString("dd-MM-yyyy");
                }

                ViewData["ModelData"] = model;
                ViewData["Fromdate"] = model.Fromdate;
                ViewData["Todate"] = model.Todate;

                string datfrmat = model.Fromdate.Split('-')[2] + '-' + model.Fromdate.Split('-')[1] + '-' + model.Fromdate.Split('-')[0];
                string dattoat = model.Todate.Split('-')[2] + '-' + model.Todate.Split('-')[1] + '-' + model.Todate.Split('-')[0];

                dt = objgps.GetGpsList(datfrmat, dattoat, model.selectedusrid);



                if (dt.Rows.Count > 0)
                {

                    omel = APIHelperMethods.ToModelList<GpsStatusClasstOutput>(dt);
                    TempData["ExporGPS"] = omel;
                    TempData.Keep();

                }
                else
                {
                    return PartialView("_PartialGPSStatusList", omel);

                }
                return PartialView("_PartialGPSStatusList", omel);
            }
            catch
            {
                return RedirectToAction("Logout", "Login", new { Area = "" });

            }
        }


        public ActionResult PartialEmployeeListcallback()
        {

            try
            {
                GpsStatusClassInput model = new GpsStatusClassInput();
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                List<GpsStatusClasstOutput> omel = new List<GpsStatusClasstOutput>();

                DataTable dt = new DataTable();

                if (model.Fromdate == null)
                {
                    model.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
                }

                if (model.Todate == null)
                {
                    model.Todate = DateTime.Now.ToString("dd-MM-yyyy");
                }

                ViewData["ModelData"] = model;
                ViewData["Fromdate"] = model.Fromdate;
                ViewData["Todate"] = model.Todate;

                string datfrmat = model.Fromdate.Split('-')[2] + '-' + model.Fromdate.Split('-')[1] + '-' + model.Fromdate.Split('-')[0];
                string dattoat = model.Todate.Split('-')[2] + '-' + model.Todate.Split('-')[1] + '-' + model.Todate.Split('-')[0];

                dt = objgps.GetGpsList(datfrmat, dattoat, model.selectedusrid);



                if (dt.Rows.Count > 0)
                {
                    if (DevExpressHelper.IsCallback)
                    {
                        omel = APIHelperMethods.ToModelList<GpsStatusClasstOutput>(dt);
                        TempData["ExporGPS"] = omel;
                        TempData.Keep();
                    }

                }
                else
                {
                    return PartialView("_PartialGPSStatusList", omel);

                }
                return PartialView("_PartialGPSStatusList", omel);
            }
            catch
            {
                return RedirectToAction("Logout", "Login", new { Area = "" });

            }

        }
        public ActionResult ShopListActivity(GpsStatusClassInput model)
        {
            DataTable dt = new DataTable();

            List<GpsStatusActivityshopClasstOutput> omel = new List<GpsStatusActivityshopClasstOutput>();



            if (model.Fromdate == null)
            {
                model.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
            }

            if (model.Todate == null)
            {
                model.Todate = DateTime.Now.ToString("dd-MM-yyyy");
            }


            string datfrmat = model.Fromdate.Split('-')[2] + '-' + model.Fromdate.Split('-')[1] + '-' + model.Fromdate.Split('-')[0];
            string dattoat = model.Todate.Split('-')[2] + '-' + model.Todate.Split('-')[1] + '-' + model.Todate.Split('-')[0];

            dt = objgps.GetGpsListShop(datfrmat, dattoat, model.selectedusrid);



            if (dt.Rows.Count > 0)
            {
                omel = APIHelperMethods.ToModelList<GpsStatusActivityshopClasstOutput>(dt);
                TempData["ExporGPS"] = omel;
                TempData.Keep();
            }
            else
            {
                return PartialView("_PartialGpsShopActivityList", omel);
            }
            return PartialView("_PartialGpsShopActivityList", omel);
        }


        public ActionResult ExportGpsStatusList(int type)
        {
            List<AttendancerecordModel> model = new List<AttendancerecordModel>();
            if (TempData["ExporGPS"] != null)
            {

                switch (type)
                {
                    case 1:
                        return GridViewExtension.ExportToPdf(GetGPSGridViewSettings(), TempData["ExporGPS"]);
                    //break;
                    case 2:
                        return GridViewExtension.ExportToXlsx(GetGPSGridViewSettings(), TempData["ExporGPS"]);
                    //break;
                    case 3:
                        return GridViewExtension.ExportToXls(GetGPSGridViewSettings(), TempData["ExporGPS"]);
                    //break;
                    case 4:
                        return GridViewExtension.ExportToRtf(GetGPSGridViewSettings(), TempData["ExporGPS"]);
                    //break;
                    case 5:
                        return GridViewExtension.ExportToCsv(GetGPSGridViewSettings(), TempData["ExporGPS"]);
                    default:
                        break;
                }
            }
            return null;
        }

        private GridViewSettings GetGPSGridViewSettings()
        {
            var settings = new GridViewSettings();
            settings.Name = "Gps Status List";
            settings.SettingsExport.ExportedRowType = GridViewExportedRowType.All;
            settings.SettingsExport.FileName = "GPS Status List";

            settings.Columns.Add(column =>
            {
                column.Caption = "User";
                column.FieldName = "UserName";

            });


            settings.Columns.Add(column =>
            {
                column.Caption = "No. Of Shops Visited";
                column.FieldName = "total_shop_visited";

            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Total Working Duration";
                column.FieldName = "total_time_spent_at_shop";


            });
            settings.Columns.Add(column =>
            {
                column.Caption = "GPS Inactive Duration";
                column.FieldName = "gps";


            });

            settings.SettingsExport.PaperKind = System.Drawing.Printing.PaperKind.A4;
            settings.SettingsExport.LeftMargin = 20;
            settings.SettingsExport.RightMargin = 20;
            settings.SettingsExport.TopMargin = 20;
            settings.SettingsExport.BottomMargin = 20;

            return settings;
        }


    }
}