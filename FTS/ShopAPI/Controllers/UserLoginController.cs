using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ShopAPI.Models;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Xml.Linq;
using System.IO;
using System.Text;

namespace ShopAPI.Controllers
{
    public class UserLoginController : ApiController
    {

        [HttpPost]
        public HttpResponseMessage Login(ClassLogin model)
        {
            ClassLoginOutput omodel = new ClassLoginOutput();
            UserClass oview = new UserClass();
            UserClasscounting ocounting = new UserClasscounting();
            try
            {
                if (!ModelState.IsValid)
                {
                    omodel.status = "213";
                    omodel.message = "Some input parameters are missing.";
                    return Request.CreateResponse(HttpStatusCode.BadRequest, omodel);
                }
                else
                {
                    String token = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];
                    String profileImg = System.Configuration.ConfigurationSettings.AppSettings["ProfileImageURL"];
                    Encryption epasswrd = new Encryption();
                    string Encryptpass = epasswrd.Encrypt(model.password);
                    string sessionId = "";


                    sessionId = HttpContext.Current.Session.SessionID;
                    string location_name = "Login";
                    location_name = "Login from  " + RetrieveFormatedAddress(model.latitude, model.longitude);


                    DataSet dt = new DataSet();
                    String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                    SqlCommand sqlcmd = new SqlCommand();

                    SqlConnection sqlcon = new SqlConnection(con);
                    sqlcon.Open();


                    sqlcmd = new SqlCommand("Sp_ApiShopUserLogin", sqlcon);
                    sqlcmd.Parameters.Add("@userName", model.username);
                    sqlcmd.Parameters.Add("@password", Encryptpass);
                    sqlcmd.Parameters.Add("@SessionToken", sessionId);
                    sqlcmd.Parameters.Add("@latitude", model.latitude);
                    sqlcmd.Parameters.Add("@longitude", model.longitude);
                    sqlcmd.Parameters.Add("@login_time", model.login_time);
                    sqlcmd.Parameters.Add("@ImeiNo", model.Imei);
                    sqlcmd.Parameters.Add("@location_name", location_name);
                    sqlcmd.Parameters.Add("@version_name", model.version_name);
                    sqlcmd.Parameters.Add("@Weburl", profileImg);
                    sqlcmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                    da.Fill(dt);
                    sqlcon.Close();



                    if (dt.Tables[1].Rows.Count > 0)
                    {

                        if (Convert.ToString(dt.Tables[1].Rows[0]["success"]) == "200")
                        {
                            oview = APIHelperMethods.ToModel<UserClass>(dt.Tables[1]);
                            ocounting = APIHelperMethods.ToModel<UserClasscounting>(dt.Tables[0]);

                            omodel.status = "200";
                            omodel.session_token = sessionId;
                            omodel.user_details = oview;
                            omodel.user_count = ocounting;
                            omodel.message = "User successfully logged in.";

                        }

                        else if (Convert.ToString(dt.Tables[1].Rows[0]["success"]) == "207")
                        {
                            omodel.status = "207";
                            omodel.message = "Your IMEI is not authorized. Please contact with Administrator";
                        }

                        else if (Convert.ToString(dt.Tables[1].Rows[0]["success"]) == "202")
                        {
                            omodel.status = "202";
                            omodel.message = "Invalid user credential.";
                        }

                    }
                    else
                    {
                        omodel.status = "202";
                        omodel.message = "Invalid user credential.";

                    }

                    var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                    return message;
                }

            }
            catch (Exception ex)
            {


                omodel.status = "209";

                omodel.message = ex.Message;
                var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                return message;
            }

        }


        string baseUri = "http://maps.googleapis.com/maps/api/geocode/xml?latlng={0},{1}&sensor=false";
        string location = string.Empty;



        public string RetrieveFormatedAddress(string lat, string lng)
        {
            string address = "";
            string locationName = "";

            string url = string.Format("http://maps.googleapis.com/maps/api/geocode/xml?latlng={0},{1}&sensor=false", lat, lng);
           
            try
            {
                XElement xml = XElement.Load(url);
                if (xml.Element("status").Value == "OK")
                {
                    locationName = string.Format("{0}",
                    xml.Element("result").Element("formatted_address").Value);
                }
            }
            catch
            {
                locationName = "";
            }
            return locationName;

            // string requestUri = string.Format(baseUri, lat, lng);
            //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
            //using (WebClient wc = new WebClient())
            //{
            //    try
            //    {
            //        string result = wc.DownloadString(requestUri);

            //        var xmlElm = XElement.Parse(result);
            //        var status = (from elm in xmlElm.Descendants()
            //                      where
            //                          elm.Name == "status"
            //                      select elm).FirstOrDefault();
            //        if (status.Value.ToLower() == "ok")
            //        {
            //            var res = (from elm in xmlElm.Descendants()
            //                       where
            //                           elm.Name == "formatted_address"
            //                       select elm).FirstOrDefault();
            //            requestUri = res.Value;
            //        }
            //    }
            //    catch
            //    {
            //        requestUri = "Login";
            //    }
            //}

            //return requestUri;

            // return address;
        }


    }








}
