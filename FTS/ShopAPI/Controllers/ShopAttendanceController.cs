using ShopAPI.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ShopAPI.Controllers
{
    public class ShopAttendanceController : ApiController
    {

        [HttpPost]

        public HttpResponseMessage AddAttendance(AttendancemanageInput model)
        {
            AttendancemanageOutput omodel = new AttendancemanageOutput();
            UserClass oview = new UserClass();


            try
            {
                string token = string.Empty;
                string versionname = string.Empty;
                System.Net.Http.Headers.HttpRequestHeaders headers = this.Request.Headers;
                String tokenmatch = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];
                //if (headers.Contains("version_name"))
                //{
                //    versionname = headers.GetValues("version_name").First();
                //}
                //if (headers.Contains("token_Number"))
                //{
                //    token = headers.GetValues("token_Number").First();
                //}

                //if (token == tokenmatch)
                //{
                    if (!ModelState.IsValid)
                    {
                        omodel.status = "213";
                        omodel.message = "Some input parameters are missing.";
                        return Request.CreateResponse(HttpStatusCode.BadRequest, omodel);
                    }
                    else
                    {
                        // String token = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];
                        string sessionId = "";




                        List<shopAttendance> omedl2 = new List<shopAttendance>();

                        foreach (var s2 in model.shop_list)
                        {

                            omedl2.Add(new shopAttendance()
                            {

                                route = s2.route,
                                shop_id = s2.shop_id,


                            });

                        }


                        string JsonXML = XmlConversion.ConvertToXml(omedl2, 0);



                        DataTable dt = new DataTable();

                        String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                        //String con = Convert.ToString(System.Web.HttpContext.Current.Session["ErpConnection"]);

                        SqlCommand sqlcmd = new SqlCommand();
                        SqlConnection sqlcon = new SqlConnection(con);
                        sqlcon.Open();

                        sqlcmd = new SqlCommand("Proc_FTS_Attendancesubmit", sqlcon);


                        sqlcmd.Parameters.Add("@user_id", model.user_id);
                        sqlcmd.Parameters.Add("@SessionToken", model.session_token);
                        sqlcmd.Parameters.Add("@wtype", model.work_type);
                        sqlcmd.Parameters.Add("@wdesc", model.work_desc);
                        sqlcmd.Parameters.Add("@wlatitude", model.work_lat);
                        sqlcmd.Parameters.Add("@wlongitude", model.work_long);
                        sqlcmd.Parameters.Add("@Waddress", model.work_address);
                        sqlcmd.Parameters.Add("@Wdatetime", model.work_date_time);
                        sqlcmd.Parameters.Add("@Isonleave", model.is_on_leave);
                        sqlcmd.Parameters.Add("@add_attendence_time", model.add_attendence_time);
                        sqlcmd.Parameters.Add("@RouteID", model.route);
                        sqlcmd.Parameters.Add("@ShopList_List", JsonXML);
                        sqlcmd.Parameters.Add("@leave_from_date", model.leave_from_date);
                        sqlcmd.Parameters.Add("@leave_type", model.leave_type);
                        sqlcmd.Parameters.Add("@leave_to_date", model.leave_to_date);

                        
                        
                        sqlcmd.CommandType = CommandType.StoredProcedure;
                        SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                        da.Fill(dt);
                        sqlcon.Close();
                        if (dt.Rows.Count > 0)
                        {
                            omodel.status = "200";
                            omodel.message = "Attendence successfully submitted.";

                        }
                        else
                        {

                            omodel.status = "202";
                            omodel.message = "Invalid user credential.";

                        }

                        var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                        return message;
                    }
                //}



                //else
                //{
                //    omodel.status = "205";
                //    omodel.message = "Token Id does not matched.";
                //    var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                //    return message;

                //}

            }
            catch (Exception ex)
            {


                omodel.status = "209";

                omodel.message = ex.Message;
                var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                return message;
            }






        }



    }
}
