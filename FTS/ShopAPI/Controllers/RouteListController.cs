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
    public class RouteListController : ApiController
    {

        [HttpPost]
        public HttpResponseMessage List(RoutefetchInput model)
        {


            RouteDetailsOutput odata = new RouteDetailsOutput();

            if (!ModelState.IsValid)
            {
                odata.status = "213";
                odata.message = "Some input parameters are missing.";
                return Request.CreateResponse(HttpStatusCode.BadRequest, odata);
            }
            else
            {

                String token = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];
                string sessionId = "";

                List<Locationupdate> omedl2 = new List<Locationupdate>();

                DataSet ds = new DataSet();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("Proc_FTS_RouteList", sqlcon);
                sqlcmd.Parameters.Add("@User_Id", model.user_id);
                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(ds);
                sqlcon.Close();
                if (ds.Tables[0].Rows.Count > 0)
                {

                    List<RouteDetailsOutputfetch> oview = new List<RouteDetailsOutputfetch>();
                    RouteDetailsOutputfetch orderdetailprd = new RouteDetailsOutputfetch();
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {


                        List<RouteListclass> shoplist = new List<RouteListclass>();
                        for (int j = 0; j < ds.Tables[1].Rows.Count; j++)
                        {


                            int i1 = 0;
                            if (Convert.ToString(ds.Tables[1].Rows[j]["Pincode"]) == Convert.ToString(ds.Tables[0].Rows[0]["Pincode"]))
                            {

                                shoplist.Add(new RouteListclass()
                                {

                                    shop_id = Convert.ToString(ds.Tables[1].Rows[j]["shop_id"]),
                                    shop_address = Convert.ToString(ds.Tables[1].Rows[j]["shop_address"]),
                                    shop_name = Convert.ToString(ds.Tables[1].Rows[j]["shop_name"]),
                                    shop_contact_no = Convert.ToString(ds.Tables[1].Rows[j]["shop_contact_no"])
                                   
                                });

                            }


                        }
                        oview.Add(new RouteDetailsOutputfetch()
                        {
                            shop_details_list = shoplist,
                            id = Convert.ToString(ds.Tables[0].Rows[i]["Pincode"]),
                            route_name = Convert.ToString(ds.Tables[0].Rows[i]["Routename"]),
                       
                        });





                    }

                    odata.route_list = oview;
                    odata.status = "200";
                    odata.message = "Route details  available";



                }
                else
                {

                    odata.status = "205";
                    odata.message = "No data found";

                }

                var message = Request.CreateResponse(HttpStatusCode.OK, odata);
                return message;
            }

        }

    }
}
