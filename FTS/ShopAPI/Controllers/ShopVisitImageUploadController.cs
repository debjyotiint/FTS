using Newtonsoft.Json.Linq;
using ShopAPI.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ShopAPI.Controllers
{
    public class ShopVisitImageUploadController : Controller
    {
        public JsonResult Revisit(ShopvisitImageUpload model)
        {

            ShopvisitImageUploadOutput omodel = new ShopvisitImageUploadOutput();
            ShopvisitImageclass omm = new ShopvisitImageclass();
            string ImageName = "";

            try
            {

                ShopRegister oview = new ShopRegister();
                ImageName = model.shop_image.FileName;
                string UploadFileDirectory = "~/CommonFolder/Shoprevisit";
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

                            case "visit_datetime":
                                {
                                    DateTime value1 = Convert.ToDateTime(item.Value);
                                    omm.visit_datetime = value1;
                                    break;
                                }

                            case "shop_id":
                                {
                                    omm.shop_id = value;
                                    break;
                                }

                            case "user_id":
                                {
                                    omm.user_id = value;
                                    break;
                                }

                        }

                    }

                }
                catch (Exception msg)
                {

                    omodel.status = "206" + ImageName;
                    omodel.message = msg.Message;

                }





                ImageName = omm.session_token + '_' + omm.user_id + '_' + ImageName;
                string vPath = Path.Combine(Server.MapPath("~/CommonFolder/Shoprevisit"), ImageName);
                model.shop_image.SaveAs(vPath);

                string sessionId = "";



                DataTable dt = new DataTable();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("Proc_ApiShopRevisitImageUpload", sqlcon);
   
                sqlcmd.Parameters.Add("@user_id", omm.user_id);
                sqlcmd.Parameters.Add("@shopvisit_image", ImageName);
                sqlcmd.Parameters.Add("@shop_id", omm.shop_id);
                sqlcmd.Parameters.Add("@visit_date", omm.visit_datetime);


                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Rows.Count > 0)
                {
                    
                    
                        omodel.status = "200";
                        omodel.message = "Revisited Shop Successfully";

                    
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