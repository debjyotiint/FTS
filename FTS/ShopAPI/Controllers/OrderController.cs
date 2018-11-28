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
    public class OrderController : ApiController
    {

        [HttpPost]

        public HttpResponseMessage AddOrder(OrdermanagementInput model)
        {
            OrderAddoutput omodel = new OrderAddoutput();
            UserClass oview = new UserClass();

            try
            {
                string token = string.Empty;
                string versionname = string.Empty;
                System.Net.Http.Headers.HttpRequestHeaders headers = this.Request.Headers;
                String tokenmatch = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];

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


                    DataTable dt = new DataTable();

                    String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                    //String con = Convert.ToString(System.Web.HttpContext.Current.Session["ErpConnection"]);


                    List<OrderProductlist> omedl2 = new List<OrderProductlist>();

                    foreach (var s2 in model.product_list)
                    {

                        omedl2.Add(new OrderProductlist()
                        {

                            id = s2.id,
                            qty = s2.qty,
                            rate = s2.rate,
                            total_price = s2.total_price

                        });

                    }


                    string JsonXML = XmlConversion.ConvertToXml(omedl2, 0);




                    SqlCommand sqlcmd = new SqlCommand();

                    SqlConnection sqlcon = new SqlConnection(con);
                    sqlcon.Open();

                    sqlcmd = new SqlCommand("Proc_FTS_Order", sqlcon);
                    sqlcmd.Parameters.Add("@user_id", model.user_id);
                    sqlcmd.Parameters.Add("@SessionToken", model.session_token);
                    sqlcmd.Parameters.Add("@order_amount", model.order_amount);
                    sqlcmd.Parameters.Add("@order_id", model.order_id);
                    sqlcmd.Parameters.Add("@Shop_Id", model.shop_id);
                    sqlcmd.Parameters.Add("@description", model.description);
                    sqlcmd.Parameters.Add("@Collection", model.collection);
                    sqlcmd.Parameters.Add("@order_date", model.order_date);
                    sqlcmd.Parameters.Add("@Product_List", JsonXML);
                    sqlcmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                    da.Fill(dt);
                    sqlcon.Close();


                    if (dt.Rows.Count > 0)
                    {
                        omodel = APIHelperMethods.ToModel<OrderAddoutput>(dt);
                        omodel.status = "200";
                        omodel.message = "Order Added Successfully.";
                    }
                    else
                    {
                        omodel.status = "202";
                        omodel.message = "No entry.";
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



        [HttpPost]
        public HttpResponseMessage OrderList(OrderfetchInput model)
        {

            List<Orderfetch> oview = new List<Orderfetch>();
            OrderfetchOutput odata = new OrderfetchOutput();

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

                DataTable dt = new DataTable();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("Proc_FTC_OrderList", sqlcon);
                sqlcmd.Parameters.Add("@date", model.date);
                sqlcmd.Parameters.Add("@user_id", model.user_id);


                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Rows.Count > 0)
                {
                    oview = APIHelperMethods.ToModelList<Orderfetch>(dt);

                    odata.order_list = oview;
                    odata.status = "200";
                    odata.message = "Order details  available";



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


        [HttpPost]
        public HttpResponseMessage OrderDetailsList(OrderDetailsfetchInput model)
        {

         
            OrderDetailsOutput odata = new OrderDetailsOutput();

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
                sqlcmd = new SqlCommand("Proc_FTC_OrderListDetails", sqlcon);
                sqlcmd.Parameters.Add("@shop_id", model.shop_id);
                sqlcmd.Parameters.Add("@user_id", model.user_id);
                sqlcmd.Parameters.Add("@order_id", model.order_id);


                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(ds);
                sqlcon.Close();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    List<OrderProducts> deliverprod = new List<OrderProducts>();
                    odata.total_orderlist_count = Convert.ToString(ds.Tables[0].Rows[0]["total_orderlist_count"]);
                    //odata.order_id = Convert.ToString(ds.Tables[0].Rows[0]["order_id"]);
                    odata.shop_id = Convert.ToString(ds.Tables[1].Rows[0]["shop_id"]);
                 //   oview = APIHelperMethods.ToModelList<OrderfetchdetailsList>(ds.Tables[1]);
                    List<OrderfetchdetailsList> oview = new List<OrderfetchdetailsList>();
                    OrderfetchdetailsList orderdetailprd = new  OrderfetchdetailsList();
                    for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                    {
                      
                     
                        List<OrderProducts> delivermodelproduct = new List<OrderProducts>();
                        for (int j = 0; j < ds.Tables[2].Rows.Count; j++)
                        {
                         
                          
                            int i1 = 0;
                            if (Convert.ToString(ds.Tables[2].Rows[j]["Order_ID"]) == Convert.ToString(ds.Tables[1].Rows[i]["order_id"]))
                            {

                                delivermodelproduct.Add(new OrderProducts()
                                    {

                                        id = Convert.ToInt32(ds.Tables[2].Rows[j]["id"]),
                                        brand_id = Convert.ToInt32(ds.Tables[2].Rows[j]["brand_id"]),
                                        category_id = Convert.ToInt32(ds.Tables[2].Rows[j]["category_id"]),
                                        watt_id = Convert.ToInt32(ds.Tables[2].Rows[j]["watt_id"]),
                                        brand = Convert.ToString(ds.Tables[2].Rows[j]["brand"]),
                                        category = Convert.ToString(ds.Tables[2].Rows[j]["category"]),
                                        watt = Convert.ToString(ds.Tables[2].Rows[j]["watt"]),
                                        qty = Convert.ToInt32(ds.Tables[2].Rows[j]["qty"]),
                                        rate = Convert.ToDecimal(ds.Tables[2].Rows[j]["rate"]),
                                        total_price = Convert.ToDecimal(ds.Tables[2].Rows[j]["total_price"]),
                                        product_name = Convert.ToString(ds.Tables[2].Rows[j]["product_name"])
                                    });

                            }
                        

                        }
                        oview.Add(new OrderfetchdetailsList()
                        {
                            product_list = delivermodelproduct,
                            id = Convert.ToString(ds.Tables[1].Rows[i]["id"]),
                            date = Convert.ToString(ds.Tables[1].Rows[i]["date"]),
                            amount = Convert.ToString(ds.Tables[1].Rows[i]["amount"]),
                            description = Convert.ToString(ds.Tables[1].Rows[i]["description"]),
                            collection = Convert.ToString(ds.Tables[1].Rows[i]["collection"])
                        });
                       
                    

                       
                           
                    }

                    odata.order_details_list = oview;
                    odata.status = "200";
                    odata.message = "Order details  available";



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
