using ShopAPI.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
//using System.Security.Cryptography.X509Certificates;
using System.Web.Http;



namespace ShopAPI.Controllers
{
    public class ProductListController : ApiController
    {

        [HttpPost]
        //[RequireHttps]
        public HttpResponseMessage List(ProductclassInput model)
        {
            ProductlistOutput omodel = new ProductlistOutput();
            List<Productclass> oview = new List<Productclass>();
          

            if (!ModelState.IsValid)
            {
                omodel.status = "213";
                omodel.message = "Some input parameters are missing.";
                return Request.CreateResponse(HttpStatusCode.BadRequest, omodel);
            }
            else
            {

                String token = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                string sessionId = "";

                List<Locationupdate> omedl2 = new List<Locationupdate>();

                DataSet ds = new DataSet();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("Proc_FTS_Productlist", sqlcon);
                //sqlcmd.Parameters.Add("@session_token", model.session_token);
                sqlcmd.Parameters.Add("@user_id", model.user_id);
                sqlcmd.Parameters.Add("@last_updated_date", model.last_update_date);
           

                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(ds);
                sqlcon.Close();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    oview = APIHelperMethods.ToModelList<Productclass>(ds.Tables[1]);
                  
                    omodel.status = "200";
                    omodel.message = ds.Tables[0].Rows[0][0].ToString() + " No. of Product list available";
                    omodel.product_list = oview;

                }
                else
                {

                    omodel.status = "205";
                    omodel.message = "No data found";

                }

                var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                return message;
            }

        }
    }
}
