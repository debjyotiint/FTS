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
    public class ShoplistController : ApiController
    {

        [HttpPost]
        //[RequireHttps]
        public HttpResponseMessage List(ShopslistInput model)
        {
            ShopslistOutput omodel = new ShopslistOutput();
            List<Shopslists> oview = new List<Shopslists>();
            Datalists odata = new Datalists();

            if (!ModelState.IsValid)
            {
                omodel.status = "213";
                omodel.message = "Some input parameters are missing.";
                return Request.CreateResponse(HttpStatusCode.BadRequest, omodel);
            }
            else
            {
                //X509Certificate2 certificate = Request.GetClientCertificate();
                //string user = certificate.Issuer;
                //string sub = certificate.Subject;

                String token = System.Configuration.ConfigurationSettings.AppSettings["AuthToken"];
                String weburl = System.Configuration.ConfigurationSettings.AppSettings["SiteURL"];
                string sessionId = "";

                List<Locationupdate> omedl2 = new List<Locationupdate>();

                DataTable dt = new DataTable();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("SP_API_Getshoplists", sqlcon);
                sqlcmd.Parameters.Add("@session_token", model.session_token);
                sqlcmd.Parameters.Add("@user_id", model.user_id);
                sqlcmd.Parameters.Add("@Uniquecont", model.Uniquecont);
                sqlcmd.Parameters.Add("@Weburl", weburl);


                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Rows.Count > 0)
                {
                    oview = APIHelperMethods.ToModelList<Shopslists>(dt);
                    odata.session_token = model.session_token;
                    odata.shop_list = oview;
                    omodel.status = "200";
                    omodel.message = dt.Rows.Count.ToString()+ " No. of Shop list available";

                    omodel.data = odata;

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
