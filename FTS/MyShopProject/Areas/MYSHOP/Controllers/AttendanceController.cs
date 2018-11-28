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
using DevExpress.Web;


namespace MyShop.Areas.MYSHOP.Controllers
{
    public class AttendanceController : Controller
    {
      
        UserList lstuser = new UserList();
        Attendanceclass objshop = new Attendanceclass();

        DataTable dtuser = new DataTable();
        public ActionResult List()
        {
            try
            {
             
                AttendanceModelInput omodel = new AttendanceModelInput();
                string userid = Session["userid"].ToString();
                dtuser = lstuser.GetUserList(userid);
                // dtuser = lstuser.GetUserList();
                List<GetUsersshopsforattendance> model = new List<GetUsersshopsforattendance>();

                model = APIHelperMethods.ToModelList<GetUsersshopsforattendance>(dtuser);
                omodel.userlsit = model;
                if (TempData["Attendanceuser"] != null)
                {
                    omodel.selectedusrid = TempData["Attendanceuser"].ToString();
                    TempData.Clear();
                }
                return View(omodel);

            }
            catch
            {

                return RedirectToAction("Logout", "Login", new { Area = "" });
            }
        }

        public ActionResult GetAttendanceIndex(string User)
        {
            TempData["Attendanceuser"] = User;
            return RedirectToAction("List");
        }


        public ActionResult GetAttendanceList(AttendanceModelInput model)
        {
            try
            {
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                List<AttendancerecordModel> omel = new List<AttendancerecordModel>();

                DataTable dt = new DataTable();

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

                dt = objshop.GetAttendanceist(model.selectedusrid,datfrmat,dattoat);

                if (dt.Rows.Count > 0)
                {
                    omel = APIHelperMethods.ToModelList<AttendancerecordModel>(dt);
                    TempData["Exportattendance"] = omel;
                    TempData.Keep();
                }
                else
                {
                    return PartialView("_PartialAttendance", omel);

                }
                return PartialView("_PartialAttendance", omel);
            }
            catch
            {

                //return Redirect("/OMS/Signoff.aspx", new {are});

                return RedirectToAction("Logout", "Login", new { Area = "" });
            }
        }


        public ActionResult ExportAttendance(int type)
        {
            List<AttendancerecordModel> model = new List<AttendancerecordModel>();
            if (TempData["Exportattendance"] != null)
            {

                switch (type)
                {
                    case 1:
                        return GridViewExtension.ExportToPdf(GetEmployeeBatchGridViewSettings(), TempData["Exportattendance"]);
                    //break;
                    case 2:
                        return GridViewExtension.ExportToXlsx(GetEmployeeBatchGridViewSettings(), TempData["Exportattendance"]);
                    //break;
                    case 3:
                        return GridViewExtension.ExportToXls(GetEmployeeBatchGridViewSettings(), TempData["Exportattendance"]);
                    //break;
                    case 4:
                        return GridViewExtension.ExportToRtf(GetEmployeeBatchGridViewSettings(), TempData["Exportattendance"]);
                    //break;
                    case 5:
                        return GridViewExtension.ExportToCsv(GetEmployeeBatchGridViewSettings(), TempData["Exportattendance"]);
                    default:
                        break;
                }
            }
            return null;
        }

        private GridViewSettings GetEmployeeBatchGridViewSettings()
        {
            var settings = new GridViewSettings();
            settings.Name = "Attendance";
           // settings.CallbackRouteValues = new { Controller = "Employee", Action = "ExportEmployee" };
            // Export-specific settings
            settings.SettingsExport.ExportedRowType = GridViewExportedRowType.All;
            settings.SettingsExport.FileName = "Attendance Report";

            settings.Columns.Add(column =>
            {
                column.Caption = "Login Date";
                column.FieldName = "login_date";
                column.PropertiesEdit.DisplayFormatString = "dd/MM/yyyy";

            });
           
            settings.Columns.Add(column =>
            {
                column.Caption = "Login Time";
                column.FieldName = "login_time";
                column.PropertiesEdit.DisplayFormatString = "dd/MM/yyyy HH:mm:ss";
              
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Logout Time";
                column.FieldName = "logout_time";
                column.PropertiesEdit.DisplayFormatString = "dd/MM/yyyy HH:mm:ss";

            }); 
            settings.Columns.Add(column =>
            {
                column.Caption = "Duration";
                column.FieldName = "duration";
              
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