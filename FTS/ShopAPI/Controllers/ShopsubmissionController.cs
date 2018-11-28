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
    public class ShopsubmissionController : ApiController
    {

        [HttpPost]
        public HttpResponseMessage ShopVisited(ShopsubmissionInput model)
        {
            ShopsubmissionOutput omodel = new ShopsubmissionOutput();
            try
            {
              
                List<DatalistsSumission> oview = new List<DatalistsSumission>();
                if (!ModelState.IsValid)
                {

                    omodel.status = "213";
                    omodel.message = "Some input parameters are missing.";
                    return Request.CreateResponse(HttpStatusCode.BadRequest, omodel);

                }

                else
                {

                    String token = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];
                    string sessionId = "";
                    List<ShopsubmissionModel> omedl2 = new List<ShopsubmissionModel>();
                    foreach (var s2 in model.shop_list)
                    {
                        omedl2.Add(new ShopsubmissionModel()
                        {
                            shop_id = s2.shop_id,
                            spent_duration = s2.spent_duration,
                            visited_date = s2.visited_date,
                            visited_time = s2.visited_time,
                            total_visit_count = s2.total_visit_count
                        });
                    }

                    string JsonXML = XmlConversion.ConvertToXml(omedl2, 0);
                    DataTable dt = new DataTable();
                    String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                    SqlCommand sqlcmd = new SqlCommand();
                    SqlConnection sqlcon = new SqlConnection(con);
                    sqlcmd.CommandTimeout = 60;
                    sqlcon.Open();
                    sqlcmd = new SqlCommand("Sp_ApiShop_Activitysubmit", sqlcon);
                    sqlcmd.Parameters.Add("@session_token", model.session_token);
                    sqlcmd.Parameters.Add("@user_id", model.user_id);
                    sqlcmd.Parameters.Add("@JsonXML", JsonXML);
                    sqlcmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                    da.Fill(dt);
                    sqlcon.Close();


                    if (dt.Rows.Count > 0)
                    {
                        oview = APIHelperMethods.ToModelList<DatalistsSumission>(dt);
                        omodel.status = "200";
                        omodel.message = "Shop details successfully updated.";
                        omodel.shop_list = oview;
                    }

                    else
                    {
                        omodel.status = "202";
                        omodel.message = "Records not updated.";
                    }

                    var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                    return message;

                }

            }
            catch(Exception ex)
            {

                omodel.status = "204";
                omodel.message = ex.Message;
                var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                return message;
            
            }

        }
    }
}
