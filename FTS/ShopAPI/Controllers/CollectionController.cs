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
    public class CollectionController : ApiController
    {


        [HttpPost]
        public HttpResponseMessage AddCollection(Collectionclass_Input model)
        {

      
            Collectionclass_Output odata = new Collectionclass_Output();

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
                sqlcmd = new SqlCommand("proc_FTS_Collection", sqlcon);
      
                sqlcmd.Parameters.Add("@user_id", model.user_id);
                sqlcmd.Parameters.Add("@shop_id", model.shop_id);
                sqlcmd.Parameters.Add("@collection", model.collection);
                sqlcmd.Parameters.Add("@collection_id", model.collection_id);
                sqlcmd.Parameters.Add("@collection_date", model.collection_date);


            
                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Rows.Count > 0)
                {
                    odata = APIHelperMethods.ToModel<Collectionclass_Output>(dt);
                    odata.status = "200";
                    odata.message = "Collection Details Saved Successfully";

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
        public HttpResponseMessage ListCollection(Collectionclass_Input model)
        {

            List<collection_details_list> oview = new List<collection_details_list>();
            CollectionList_Output odata = new CollectionList_Output();

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

                DataSet dt = new DataSet();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("proc_FTS_CollectionList", sqlcon);
                sqlcmd.Parameters.Add("@user_id", model.user_id);
                sqlcmd.Parameters.Add("@shop_id", model.shop_id);
          

                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Tables[0].Rows.Count > 0)
                {
                    oview = APIHelperMethods.ToModelList<collection_details_list>(dt.Tables[1]);
                    odata.collection_details_list = oview;
                    odata.total_orderlist_count = Convert.ToInt32(dt.Tables[0].Rows[0]["countcollection"]);
                    odata.status = "200";
                    odata.message = "Collection List Populated Successfully";

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
