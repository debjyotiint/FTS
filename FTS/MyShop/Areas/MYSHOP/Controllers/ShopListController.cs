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
using System.IO;
using DevExpress.Web.Mvc;
using DevExpress.Web;


namespace MyShop.Areas.MYSHOP.Controllers
{
    public class ShopListController : Controller
    {
        //
        // GET: /ShopList/
        UserList lstuser = new UserList();
        Shop objshop = new Shop();

        DataTable dtuser = new DataTable();
        [HttpGet]
        public ActionResult Index()
        {
            try
            {
                

                ShopslistInput omodel = new ShopslistInput();
                string userid = Session["userid"].ToString();
                dtuser = lstuser.GetUserList(userid);
                // dtuser = lstuser.GetUserList();
                List<GetUsersshops> model = new List<GetUsersshops>();

                model = APIHelperMethods.ToModelList<GetUsersshops>(dtuser);
                omodel.userlsit = model;
                omodel.selectedusrid = userid;
                //omodel.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
                //omodel.Todate = DateTime.Now.ToString("dd-MM-yyyy");


                 List<GetUsersStates> modelstate = new List<GetUsersStates>();
                 DataTable  dtstate = lstuser.GetStateList();
                 modelstate = APIHelperMethods.ToModelList<GetUsersStates>(dtstate);



                 omodel.states = modelstate;


                if (TempData["Shopuser"] != null)
                {
                    omodel.selectedusrid = TempData["Shopuser"].ToString();

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


        public ActionResult Getshoplist(ShopslistInput model)
        {
            try
            {
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                List<Shopslists> omel = new List<Shopslists>();

                DataTable dt = new DataTable();
                   string datfrmat = "";
                   string dattoat = "";

                if (model.Fromdate != null)
                {
                    //  model.Fromdate = DateTime.Now.ToString("dd-MM-yyyy");
                    datfrmat = model.Fromdate.Split('-')[2] + '-' + model.Fromdate.Split('-')[1] + '-' + model.Fromdate.Split('-')[0];
                }

                if (model.Todate != null)
                {
                 //  model.Todate = DateTime.Now.ToString("dd-MM-yyyy");
                     dattoat = model.Todate.Split('-')[2] + '-' + model.Todate.Split('-')[1] + '-' + model.Todate.Split('-')[0];
                }


                dt = objshop.GetShopList(model.selectedusrid, datfrmat, dattoat, "", weburl,model.StateId);

                if (dt.Rows.Count > 0)
                {
                    omel = APIHelperMethods.ToModelList<Shopslists>(dt);
                    TempData["ExportShoplist"] = omel;
                    TempData.Keep();
                }

                   return PartialView("_PartialShopList", omel);
                // return PartialView("_PartialShopListgridview", omel);

            }
            catch
            {

                //   return Redirect("~/OMS/Signoff.aspx");

                return RedirectToAction("Logout", "Login", new { Area = "" });
            }
        }

        public ActionResult ShopListModify(string ShopUniqueId)
        {
            DataTable dt = new DataTable();


            dt = objshop.ShopGetDetails(ShopUniqueId);
            Shopslists omel = new Shopslists();
            omel = APIHelperMethods.ToModel<Shopslists>(dt);


            dt = objshop.GetTypesList();
            omel.shptypes = APIHelperMethods.ToModelList<shopTypes>(dt);
            return PartialView("_PartialModifyShop", omel);

        }
        [HttpPost]
        public ActionResult DeleteShopList(string ShopUniqueId)
        {
            int gets = 0;
            gets = objshop.ShopDelete(ShopUniqueId);
            if (gets > 0)
            {
                return Json(true);
            }
            else
            {
                return Json(false);
            }
        }
        [HttpPost]
        public ActionResult ShopSubmit(Shopslists model)
        {
            // return Json("false",JsonRequestBehavior.AllowGet);
            string dattdob = "";
            string datdobanniv = "";

            if (ModelState.IsValid)
            {
                if (model.dobstr != null && model.dobstr != "")
                {
                    dattdob = model.dobstr.Split('-')[2] + '-' + model.dobstr.Split('-')[1] + '-' + model.dobstr.Split('-')[0];
                }
                if (model.date_aniversarystr != null && model.date_aniversarystr != "")
                {
                    datdobanniv = model.date_aniversarystr.Split('-')[2] + '-' + model.date_aniversarystr.Split('-')[1] + '-' + model.date_aniversarystr.Split('-')[0];
                }


                int gets = 0;
                gets = objshop.ShopModify(model.shop_Auto, model.address, model.pin_code, model.shop_name, model.owner_name, model.owner_contact_no, model.owner_email, model.Shoptype, dattdob, datdobanniv);
                if (gets > 0)
                {
                    return Json(true);
                }
                else
                {
                    return Json(false);
                }
            }
            else
            {
                return Json(false);
            }

        }


        [HttpPost, ValidateInput(false)]
        public ActionResult FileFileUploadforShop(string shopimagename)
        {
            if (Request.Files[0].ContentLength > 0)
            {
                string filesplit = Convert.ToString(Request.Files[0].FileName).Replace(" ", "");

                string fileLocation = Path.Combine(HttpContext.Server.MapPath("~/" + System.Configuration.ConfigurationManager.AppSettings["CandidateOfferletter"] + ""), shopimagename);

                if (System.IO.File.Exists(fileLocation))
                {

                    System.IO.File.Delete(fileLocation);

                }


                Request.Files[0].SaveAs(fileLocation);
            }
            return Json("Success");
        }



        public ActionResult ExportShoplist(int type)
        {
            List<AttendancerecordModel> model = new List<AttendancerecordModel>();
            if (TempData["ExportShoplist"] != null)
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
            settings.Name = "Shop List";
            // settings.CallbackRouteValues = new { Controller = "Employee", Action = "ExportEmployee" };
            // Export-specific settings
            settings.SettingsExport.ExportedRowType = GridViewExportedRowType.All;
            settings.SettingsExport.FileName = "Shop List Report";


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