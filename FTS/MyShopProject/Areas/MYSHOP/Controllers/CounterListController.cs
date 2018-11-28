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
using System.IO;
using DevExpress.Web.Mvc;
using DevExpress.Web;


namespace MyShop.Areas.MYSHOP.Controllers
{
    public class CounterListController : Controller
    {
        // GET: /ShopList/
        UserList lstuser = new UserList();
        Shop objshop = new Shop();

        DataTable dtuser = new DataTable();
        [HttpGet]
        public ActionResult Index()
        {
            try
            {


                CounterClass omodel = new CounterClass();
                string userid = Session["userid"].ToString();
                dtuser = lstuser.GetUserList(userid);
                // dtuser = lstuser.GetUserList();
                List<GetUsersshops> model = new List<GetUsersshops>();

                model = APIHelperMethods.ToModelList<GetUsersshops>(dtuser);
                //omodel.userlsit = model;
                //omodel.selectedusrid = userid;





                //omodel.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
                //omodel.Todate = DateTime.Now.ToString("dd-MM-yyyy");


                 List<CounterStates> modelstate = new List<CounterStates>();
                 DataTable  dtstate = lstuser.GetStateList();
                 modelstate = APIHelperMethods.ToModelList<CounterStates>(dtstate);
                 omodel.states = modelstate;


                List<shopCounterTypes> modelcounter= new List<shopCounterTypes>();
                DataTable dtshoptypes = lstuser.GetShopTypes();
                modelcounter = APIHelperMethods.ToModelList<shopCounterTypes>(dtshoptypes);
                omodel.Shoptypes = modelcounter;


                if (TempData["Exportcounterist"] != null)
                {
                    //omodel.selectedusrid = TempData["Shopuser"].ToString();
                    TempData.Clear();
                }

                return View(omodel);


            }

            catch
            {
                return RedirectToAction("Logout", "Login", new { Area = "" });
            }
        }
        public ActionResult GetshopIndex(string User)
        {
            TempData["Shopuser"] = User;
            return RedirectToAction("Index");
        }


        public ActionResult GetCounterlist(CounterClass model)
        {
            try
            {
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                List<Shopslists> omel = new List<Shopslists>();

                DataTable dt = new DataTable();
                   string datfrmat = "";
                   string dattoat = "";



                   dt = objshop.GetShopListCounterwise(model.TypeID,  weburl, model.StateId);

                if (dt.Rows.Count > 0)
                {
                    omel = APIHelperMethods.ToModelList<Shopslists>(dt);
                    TempData["Exportcounterist"] = omel;
                    TempData.Keep();
                }
                else
                {
                    TempData["Exportcounterist"] = null;
                    TempData.Keep();

                }

                return PartialView("_PartialCounterList", omel);
                // return PartialView("_PartialShopListgridview", omel);

            }
            catch
            {

                //   return Redirect("~/OMS/Signoff.aspx");

                return RedirectToAction("Logout", "Login", new { Area = "" });
            }
        }

     



        public ActionResult ExportCounterlist(int type)
        {
            List<AttendancerecordModel> model = new List<AttendancerecordModel>();
            if (TempData["Exportcounterist"] != null)
            {

                switch (type)
                {
                    case 1:
                        return GridViewExtension.ExportToPdf(GetEmployeeBatchGridViewSettings(), TempData["ExportShoplist"]);
                    //break;
                    case 2:
                        return GridViewExtension.ExportToXlsx(GetEmployeeBatchGridViewSettings(), TempData["ExportShoplist"]);
                    //break;
                    case 3:
                        return GridViewExtension.ExportToXls(GetEmployeeBatchGridViewSettings(), TempData["ExportShoplist"]);
                    //break;
                    case 4:
                        return GridViewExtension.ExportToRtf(GetEmployeeBatchGridViewSettings(), TempData["ExportShoplist"]);
                    //break;
                    case 5:
                        return GridViewExtension.ExportToCsv(GetEmployeeBatchGridViewSettings(), TempData["ExportShoplist"]);
                    default:
                        break;
                }
            }
            return null;
        }

        private GridViewSettings GetEmployeeBatchGridViewSettings()
        {
            var settings = new GridViewSettings();
            settings.Name = "Counter List";
            // settings.CallbackRouteValues = new { Controller = "Employee", Action = "ExportEmployee" };
            // Export-specific settings
            settings.SettingsExport.ExportedRowType = GridViewExportedRowType.All;
            settings.SettingsExport.FileName = "Counter List Report";


            settings.Columns.Add(column =>
                  {
                      column.Caption = "User";
                      column.FieldName = "UserName";

                  });
            settings.Columns.Add(column =>
                  {
                      column.Caption = "Type";
                      column.FieldName = "Shoptype";

                  });


            settings.Columns.Add(column =>
                  {
                      column.Caption = "Shop Name";
                      column.FieldName = "shop_name";

                  });

            settings.Columns.Add(column =>
                  {
                      column.Caption = "Address";
                      column.FieldName = "address";

                  });

            settings.Columns.Add(column =>
                  {
                      column.Caption = "Pincode";
                      column.FieldName = "pin_code";

                  });


            settings.Columns.Add(column =>
                  {
                      column.Caption = "Owner Name";
                      column.FieldName = "owner_name";

                  });


            settings.Columns.Add(column =>
                  {
                      column.Caption = "Contact";
                      column.FieldName = "owner_contact_no";


                  });



            settings.Columns.Add(column =>
                  {
                      column.Caption = "Email";
                      column.FieldName = "owner_email";


                  });


            settings.Columns.Add(column =>
            {
                column.Caption = "PP";
                column.FieldName = "PP";


            });

            settings.Columns.Add(column =>
            {
                column.Caption = "DD";
                column.FieldName = "DD";


            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Created Date";
                column.FieldName = "Shop_CreateTime";
                column.PropertiesEdit.DisplayFormatString = "dd/MM/yyyy HH:mm:ss";

            });

            settings.Columns.Add(column =>
            {
                column.Caption = "DOB";
                column.FieldName = "dob";
                column.PropertiesEdit.DisplayFormatString = "dd/MM/yyyy";

            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Marriage Anniversary";
                column.FieldName = "date_aniversary";
                column.PropertiesEdit.DisplayFormatString = "dd/MM/yyyy";

            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Shop Visit";
                column.FieldName = "countactivity";

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