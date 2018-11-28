using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
//using System.Net.Http;
//using System.Web.Http;
using ShopAPI.Models;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Drawing;
using System.Web.Mvc;
using Newtonsoft.Json.Linq;
using System.Net.Http.Formatting;
using System.Web.UI;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Xml.Linq;
//using System.Web.Http;
//using System.Net.Http;
//using System.Threading.Tasks;

namespace ShopAPI.Controllers
{

    public class ShopRegistrationController : Controller
    {

        [AcceptVerbs("POST")]

        public JsonResult RegisterShop(RegisterShopInputData model)
        {

            RegisterShopOutput omodel = new RegisterShopOutput();
            RegisterShopInput omm = new RegisterShopInput();
            string ImageName = "";

            try
            {
                // RegisterShopInputData model = new RegisterShopInputData();

                //TextWriter tw = new StreamWriter("date.txt");
                //// write a line of text to the file
                //tw.WriteLine(DateTime.Now + model.data);
                //tw.Close();


                // close the stream

                ShopRegister oview = new ShopRegister();
                ImageName = model.shop_image.FileName;
                string UploadFileDirectory = "~/CommonFolder";
                try
                {

                    var details = JObject.Parse(model.data);

                    foreach (var item in details)
                    {
                        string param = item.Key;
                        string value = Convert.ToString(item.Value);
                        switch (param)
                        {
                            case "session_token":
                                {
                                    omm.session_token = value;
                                    break;
                                }

                            case "shop_name":
                                {
                                    omm.shop_name = value;
                                    break;
                                }

                            case "address":
                                {
                                    omm.address = value;
                                    break;
                                }


                            case "pin_code":
                                {
                                    omm.pin_code = value;
                                    break;
                                }

                            case "shop_lat":
                                {
                                    omm.shop_lat = value;
                                    break;
                                }

                            case "shop_long":
                                {
                                    omm.shop_long = value;
                                    break;
                                }

                            case "owner_name":
                                {
                                    omm.owner_name = value;
                                    break;
                                }

                            case "owner_contact_no":
                                {
                                    omm.owner_contact_no = value;
                                    break;
                                }

                            case "owner_email":
                                {
                                    omm.owner_email = value;
                                    break;
                                }

                            case "user_id":
                                {

                                    omm.user_id = value;
                                    break;
                                }

                            case "type":
                                {
                                    omm.type = Int32.Parse(value);
                                    break;
                                }
                            case "added_date":

                                omm.added_date = value;
                                break;


                            case "dob":

                                omm.dob = value;
                                break;

                            case "date_aniversary":

                                omm.date_aniversary = value;
                                break;

                            case "shop_id":

                                omm.shop_id = value;
                                break;


                            case "assigned_to_pp_id":

                                omm.assigned_to_pp_id = value;
                                break;

                            case "assigned_to_dd_id":

                                omm.assigned_to_dd_id = value;
                                break;


                        }

                    }

                }
                catch (Exception msg)
                {

                    omodel.status = "206" + ImageName;
                    omodel.message = msg.Message;

                }





                ImageName = omm.session_token + '_' + omm.user_id + '_' + ImageName;
                string vPath = Path.Combine(Server.MapPath("~/CommonFolder"), ImageName);
                model.shop_image.SaveAs(vPath);

                string sessionId = "";



                DataTable dt = new DataTable();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("Sp_ApiShopRegister", sqlcon);
                sqlcmd.Parameters.Add("@session_token", omm.session_token);
                sqlcmd.Parameters.Add("@shop_name", omm.shop_name);
                sqlcmd.Parameters.Add("@address", omm.address);
                sqlcmd.Parameters.Add("@pin_code", omm.pin_code);
                sqlcmd.Parameters.Add("@shop_lat", omm.shop_lat);
                sqlcmd.Parameters.Add("@shop_long", omm.shop_long);
                sqlcmd.Parameters.Add("@owner_name", omm.owner_name);
                sqlcmd.Parameters.Add("@owner_contact_no", omm.owner_contact_no);
                sqlcmd.Parameters.Add("@owner_email", omm.owner_email);
                sqlcmd.Parameters.Add("@user_id", omm.user_id);
                sqlcmd.Parameters.Add("@shop_image", ImageName);
                sqlcmd.Parameters.Add("@type", omm.type);
                sqlcmd.Parameters.Add("@dob", Convert.ToString(omm.dob) == "" ? null : omm.dob);
                sqlcmd.Parameters.Add("@date_aniversary", Convert.ToString(omm.date_aniversary) == "" ? null : omm.date_aniversary);
                sqlcmd.Parameters.Add("@shop_id", omm.shop_id);
                sqlcmd.Parameters.Add("@added_date", omm.added_date);
                sqlcmd.Parameters.Add("@assigned_to_pp_id", omm.assigned_to_pp_id);
                sqlcmd.Parameters.Add("@assigned_to_dd_id", omm.assigned_to_dd_id);
                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Rows.Count > 0)
                {
                    if (Convert.ToString(dt.Rows[0]["returncode"]) == "203")
                    {
                        omodel.status = "203";
                        omodel.message = "Duplicate shop Id or contact number";

                    }
                    else if (Convert.ToString(dt.Rows[0]["returncode"]) == "202")
                    {


                        omodel.status = "202";
                        omodel.message = "User or session token not matched";
                    }
                    else
                    {
                        oview = APIHelperMethods.ToModel<ShopRegister>(dt);
                        omodel.status = "200";
                        omodel.session_token = sessionId;
                        omodel.data = oview;
                        omodel.message = "Shop added successfully";

                    }
                }
                else
                {

                    omodel.status = "202";
                    omodel.message = "Data not inserted";

                }


            }
            catch (Exception msg)
            {

                omodel.status = "204" + ImageName;
                omodel.message = msg.Message;


            }
            // var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
            return Json(omodel);
        }


        //public HttpResponseMessage RegisterShop()
        //{

        //    string data = Convert.ToString(HttpContext.Current.Request.Form.AllKeys);
        //    var file1 = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files[0] : null;
        //    //string data="";
        //    //if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["data"]))
        //    //{
        //    //    data = HttpContext.Current.Request.Form["data"];
        //    //}
        //    // string data = "";
        //    RegisterShopOutput omodel = new RegisterShopOutput();
        //    RegisterShopInput omm = new RegisterShopInput();
        //    string ImageName = "";

        //    try
        //    {


        //        ShopRegister oview = new ShopRegister();
        //        //   ImageName = model.shop_image.FileName;
        //        string UploadFileDirectory = "~/CommonFolder";
        //        try
        //        {

        //            //   var details = JObject.Parse(data);

        //            var details = JObject.Parse(data);

        //            foreach (var item in details)
        //            {
        //                string param = item.Key;
        //                string value = Convert.ToString(item.Value);
        //                switch (param)
        //                {
        //                    case "session_token":
        //                        {
        //                            omm.session_token = value;
        //                            break;
        //                        }

        //                    case "shop_name":
        //                        {
        //                            omm.shop_name = value;
        //                            break;
        //                        }

        //                    case "address":
        //                        {
        //                            omm.address = value;
        //                            break;
        //                        }


        //                    case "pin_code":
        //                        {
        //                            omm.pin_code = value;
        //                            break;
        //                        }

        //                    case "shop_lat":
        //                        {
        //                            omm.shop_lat = value;
        //                            break;
        //                        }

        //                    case "shop_long":
        //                        {
        //                            omm.shop_long = value;
        //                            break;
        //                        }

        //                    case "owner_name":
        //                        {
        //                            omm.owner_name = value;
        //                            break;
        //                        }

        //                    case "owner_contact_no":
        //                        {
        //                            omm.owner_contact_no = value;
        //                            break;
        //                        }

        //                    case "owner_email":
        //                        {
        //                            omm.owner_email = value;
        //                            break;
        //                        }

        //                    case "user_id":
        //                        {

        //                            omm.user_id = value;
        //                            break;
        //                        }

        //                    case "type":
        //                        {
        //                            omm.type = Int32.Parse(value);
        //                            break;
        //                        }

        //                    case "dob":

        //                        omm.dob = value;
        //                        break;

        //                    case "date_aniversary":

        //                        omm.date_aniversary = value;
        //                        break;

        //                    case "shop_id":

        //                        omm.shop_id = value;
        //                        break;


        //                }

        //            }

        //        }
        //        catch (Exception msg)
        //        {

        //            omodel.status = "206" + ImageName;
        //            omodel.message = msg.Message;
        //            omodel.data.address = omm.address;
        //            omodel.data.type = omm.type;
        //            omodel.data.user_id = omm.user_id;
        //            omodel.data.owner_email = omm.owner_email;
        //            omodel.data.session_token = omm.session_token;
        //            omodel.data.dob = omm.dob;
        //            omodel.data.date_aniversary = omm.date_aniversary;
        //        }





        //        //ImageName = omm.session_token + '_' + omm.user_id + '_' + ImageName;
        //        //string vPath = Path.Combine(Server.MapPath("~/CommonFolder"), ImageName);
        //        //model.shop_image.SaveAs(vPath);

        //        var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files[0] : null;
        //        if (file != null && file.ContentLength > 0)
        //        {
        //            ImageName = omm.session_token + '_' + omm.user_id + '_' + Path.GetFileName(file.FileName);

        //            var path = Path.Combine(
        //                HttpContext.Current.Server.MapPath("~/CommonFolder"),
        //                ImageName
        //            );

        //            file.SaveAs(path);


        //        }


        //        string sessionId = "";

        //        ///sessionId = HttpContext.Current.Session.SessionID;

        //        DataTable dt = new DataTable();
        //        String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
        //        SqlCommand sqlcmd = new SqlCommand();
        //        SqlConnection sqlcon = new SqlConnection(con);
        //        sqlcon.Open();
        //        sqlcmd = new SqlCommand("Sp_ApiShopRegister", sqlcon);
        //        sqlcmd.Parameters.Add("@session_token", omm.session_token);
        //        sqlcmd.Parameters.Add("@shop_name", omm.shop_name);
        //        sqlcmd.Parameters.Add("@address", omm.address);
        //        sqlcmd.Parameters.Add("@pin_code", omm.pin_code);
        //        sqlcmd.Parameters.Add("@shop_lat", omm.shop_lat);
        //        sqlcmd.Parameters.Add("@shop_long", omm.shop_long);
        //        sqlcmd.Parameters.Add("@owner_name", omm.owner_name);
        //        sqlcmd.Parameters.Add("@owner_contact_no", omm.owner_contact_no);
        //        sqlcmd.Parameters.Add("@owner_email", omm.owner_email);
        //        sqlcmd.Parameters.Add("@user_id", omm.user_id);
        //        sqlcmd.Parameters.Add("@shop_image", ImageName);
        //        sqlcmd.Parameters.Add("@type", omm.type);
        //        sqlcmd.Parameters.Add("@dob", Convert.ToString(omm.dob) == "" ? null : omm.dob);
        //        sqlcmd.Parameters.Add("@date_aniversary", Convert.ToString(omm.date_aniversary) == "" ? null : omm.date_aniversary);
        //        sqlcmd.Parameters.Add("@shop_id", omm.shop_id);

        //        sqlcmd.CommandType = CommandType.StoredProcedure;
        //        SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
        //        da.Fill(dt);
        //        sqlcon.Close();
        //        if (dt.Rows.Count > 0)
        //        {
        //            if (Convert.ToString(dt.Rows[0]["returncode"]) == "203")
        //            {
        //                omodel.status = "203";
        //                omodel.message = "Duplicate shop Id or Email";


        //            }
        //            else if (Convert.ToString(dt.Rows[0]["returncode"]) == "202")
        //            {


        //                omodel.status = "202";
        //                omodel.message = "User or session token not matched";
        //            }
        //            else
        //            {
        //                oview = APIHelperMethods.ToModel<ShopRegister>(dt);
        //                omodel.status = "200";
        //                omodel.session_token = sessionId;
        //                omodel.data = oview;
        //                omodel.message = "Shop added successfully";

        //            }
        //        }
        //        else
        //        {

        //            omodel.status = "202";
        //            omodel.message = "Data not inserted";

        //        }


        //    }
        //    catch (Exception msg)
        //    {

        //        omodel.status = "204" + ImageName;
        //        omodel.message = msg.Message;
        //        omodel.data.address = omm.address;
        //        omodel.data.type = omm.type;
        //        omodel.data.user_id = omm.user_id;
        //        omodel.data.owner_email = omm.owner_email;
        //        omodel.data.session_token = omm.session_token;
        //        omodel.data.dob = omm.dob;
        //        omodel.data.date_aniversary = omm.date_aniversary;

        //    }
        //    // var message = Request.CreateResponse(HttpStatusCode.OK, omodel);



        //    var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
        //    return message;


        //    //////////////////----------------------------------Api controller------------------------------

        //    //   RegisterShopInputData model = new RegisterShopInputData();

        //    //RegisterShopOutput omodel = new RegisterShopOutput();
        //    //ShopRegister oview = new ShopRegister();
        //    //if (!ModelState.IsValid)
        //    //{
        //    //    omodel.status = "213";
        //    //    omodel.message = "Some input parameters are missing.";
        //    //    return Request.CreateResponse(HttpStatusCode.BadRequest, omodel);
        //    //}
        //    //else
        //    //{

        //    //    var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files[0] : null;

        //    //    if (file != null && file.ContentLength > 0)
        //    //    {
        //    //        var fileName = Path.GetFileName(file.FileName);

        //    //        var path = Path.Combine(
        //    //            HttpContext.Current.Server.MapPath("~/CommonFolder"),
        //    //            fileName
        //    //        );

        //    //        file.SaveAs(path);


        //    //    }



        //    //    String token = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];

        //    //    string sessionId = "";


        //    //    sessionId = HttpContext.Current.Session.SessionID;


        //    //    DataTable dt = new DataTable();
        //    //    String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
        //    //    SqlCommand sqlcmd = new SqlCommand();
        //    //    SqlConnection sqlcon = new SqlConnection(con);
        //    //    sqlcon.Open();
        //    //    sqlcmd = new SqlCommand("Sp_ApiShopRegister", sqlcon);
        //    //    sqlcmd.Parameters.Add("@session_token", model.data.session_token);
        //    //    sqlcmd.Parameters.Add("@shop_name", model.data.shop_name);
        //    //    sqlcmd.Parameters.Add("@address", model.data.address);
        //    //    sqlcmd.Parameters.Add("@pin_code", model.data.pin_code);
        //    //    sqlcmd.Parameters.Add("@shop_lat", model.data.shop_lat);
        //    //    sqlcmd.Parameters.Add("@shop_long", model.data.shop_long);
        //    //    sqlcmd.Parameters.Add("@owner_name", model.data.owner_name);
        //    //    sqlcmd.Parameters.Add("@owner_contact_no", model.data.owner_contact_no);
        //    //    sqlcmd.Parameters.Add("@owner_email", model.data.owner_email);
        //    //    sqlcmd.Parameters.Add("@user_id", model.data.user_id);
        //    //    //  sqlcmd.Parameters.Add("@shop_image", model.shop_image);
        //    //    sqlcmd.Parameters.Add("@type", model.data.type);
        //    //    sqlcmd.Parameters.Add("@dob", model.data.dob);
        //    //    sqlcmd.Parameters.Add("@date_aniversary", model.data.date_aniversary);


        //    //    sqlcmd.CommandType = CommandType.StoredProcedure;
        //    //    SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
        //    //    da.Fill(dt);
        //    //    sqlcon.Close();
        //    //    if (dt.Rows.Count > 0)
        //    //    {
        //    //        oview = APIHelperMethods.ToModel<ShopRegister>(dt);
        //    //        omodel.status = "200";
        //    //        omodel.session_token = sessionId;
        //    //        omodel.data = oview;
        //    //        omodel.message = "Shop added successfully";


        //    //    }
        //    //    else
        //    //    {

        //    //        omodel.status = "202";
        //    //        omodel.message = "Session token does not matched";

        //    //    }

        //    //    var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
        //    //    return message;
        //}

        public JsonResult EditShop(RegisterShopInputData model)
        {

            RegisterShopOutput omodel = new RegisterShopOutput();
            RegisterShopInput omm = new RegisterShopInput();
            string ImageName = "";

            try
            {
 

                ShopRegister oview = new ShopRegister();
                ImageName = model.shop_image.FileName;
                string UploadFileDirectory = "~/CommonFolder";
             
                
                try
                {

                    var details = JObject.Parse(model.data);

                    foreach (var item in details)
                    {
                        string param = item.Key;
                        string value = Convert.ToString(item.Value);
                        switch (param)
                        {
                            case "session_token":
                                {
                                    omm.session_token = value;
                                    break;
                                }

                            case "shop_name":
                                {
                                    omm.shop_name = value;
                                    break;
                                }

                            case "address":
                                {
                                    omm.address = value;
                                    break;
                                }


                            case "pin_code":
                                {
                                    omm.pin_code = value;
                                    break;
                                }

                            case "shop_lat":
                                {
                                    omm.shop_lat = value;
                                    break;
                                }

                            case "shop_long":
                                {
                                    omm.shop_long = value;
                                    break;
                                }

                            case "owner_name":
                                {
                                    omm.owner_name = value;
                                    break;
                                }

                            case "owner_contact_no":
                                {
                                    omm.owner_contact_no = value;
                                    break;
                                }

                            case "owner_email":
                                {
                                    omm.owner_email = value;
                                    break;
                                }

                            case "user_id":
                                {

                                    omm.user_id = value;
                                    break;
                                }

                            case "type":
                                {
                                    omm.type = Int32.Parse(value);
                                    break;
                                }
                            case "added_date":

                                omm.added_date = value;
                                break;


                            case "dob":

                                omm.dob = value;
                                break;

                            case "date_aniversary":

                                omm.date_aniversary = value;
                                break;

                            case "shop_id":

                                omm.shop_id = value;
                                break;


                            case "assigned_to_pp_id":

                                omm.assigned_to_pp_id = value;
                                break;

                            case "assigned_to_dd_id":

                                omm.assigned_to_dd_id = value;
                                break;

                        }

                    }

                }



                catch (Exception msg)
                {

                    omodel.status = "206" + ImageName;
                    omodel.message = msg.Message;

                }

                ImageName = omm.session_token + '_' + omm.user_id + '_' + ImageName;
                string vPath = Path.Combine(Server.MapPath("~/CommonFolder"), ImageName);
                model.shop_image.SaveAs(vPath);
                string sessionId = "";


                DataTable dt = new DataTable();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();


                sqlcmd = new SqlCommand("Proc_FTSShopRegister_EDIT", sqlcon);
                sqlcmd.Parameters.Add("@session_token", omm.session_token);
                sqlcmd.Parameters.Add("@shop_name", omm.shop_name);
                sqlcmd.Parameters.Add("@address", omm.address);
                sqlcmd.Parameters.Add("@pin_code", omm.pin_code);
                sqlcmd.Parameters.Add("@shop_lat", omm.shop_lat);
                sqlcmd.Parameters.Add("@shop_long", omm.shop_long);
                sqlcmd.Parameters.Add("@owner_name", omm.owner_name);
                sqlcmd.Parameters.Add("@owner_contact_no", omm.owner_contact_no);
                sqlcmd.Parameters.Add("@owner_email", omm.owner_email);
                sqlcmd.Parameters.Add("@user_id", omm.user_id);
                sqlcmd.Parameters.Add("@shop_image", ImageName);
                sqlcmd.Parameters.Add("@type", omm.type);
                sqlcmd.Parameters.Add("@dob", Convert.ToString(omm.dob) == "" ? null : omm.dob);
                sqlcmd.Parameters.Add("@date_aniversary", Convert.ToString(omm.date_aniversary) == "" ? null : omm.date_aniversary);
                sqlcmd.Parameters.Add("@shop_id", omm.shop_id);
                sqlcmd.Parameters.Add("@added_date", omm.added_date);
                sqlcmd.Parameters.Add("@assigned_to_pp_id", omm.assigned_to_pp_id);
                sqlcmd.Parameters.Add("@assigned_to_dd_id", omm.assigned_to_dd_id);
                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Rows.Count > 0)
                {
                    if (Convert.ToString(dt.Rows[0]["returncode"]) == "202")
                    {


                        omodel.status = "202";
                        omodel.message = "Shop_Id Not exists";
                    }
                    else
                    {
                        oview = APIHelperMethods.ToModel<ShopRegister>(dt);
                        omodel.status = "200";
                        omodel.session_token = sessionId;
                        omodel.data = oview;
                        omodel.message = "Shop Updated successfully";

                    }
                }
                else
                {

                    omodel.status = "202";
                    omodel.message = "Data not inserted";

                }


            }
            catch (Exception msg)
            {

                omodel.status = "204" + ImageName;
                omodel.message = msg.Message;


            }
            // var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
            return Json(omodel);
        }

        
    
    }
}
