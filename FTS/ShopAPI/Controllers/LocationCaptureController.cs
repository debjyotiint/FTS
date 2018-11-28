using ShopAPI.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Xml.Linq;

namespace ShopAPI.Controllers
{
    public class LocationCaptureController : ApiController
    {

        [HttpPost]
        public HttpResponseMessage Sendlocation(ModelLocationupdate model)
        {
            LocationupdateOutput omodel = new LocationupdateOutput();
            ShopRegister oview = new ShopRegister();
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


                List<Locationupdate> omedl2 = new List<Locationupdate>();

                foreach (var s2 in model.location_details)
                {

                    if (s2.location_name.ToLower() == "unknown")
                    {
                        s2.location_name = RetrieveFormatedAddress(s2.latitude, s2.longitude);
                    }

                    omedl2.Add(new Locationupdate()
                    {
                        location_name = s2.location_name,
                        latitude = s2.latitude,
                        longitude = s2.longitude,
                        distance_covered = s2.distance_covered,
                        last_update_time = s2.last_update_time,
                        date = s2.date,

                        shops_covered = s2.shops_covered

                    });

                }


                string JsonXML = XmlConversion.ConvertToXml(omedl2, 0);

                DataTable dt = new DataTable();
                String con = System.Configuration.ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlCommand sqlcmd = new SqlCommand();
                SqlConnection sqlcon = new SqlConnection(con);
                sqlcon.Open();
                sqlcmd = new SqlCommand("Sp_ApiLocationupdate", sqlcon);
                sqlcmd.Parameters.Add("@session_token", model.session_token);
                sqlcmd.Parameters.Add("@user_id", model.user_id);
                sqlcmd.Parameters.Add("@JsonXML", JsonXML);

                sqlcmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(sqlcmd);
                da.Fill(dt);
                sqlcon.Close();
                if (dt.Rows.Count > 0)
                {
                    oview = APIHelperMethods.ToModel<ShopRegister>(dt);
                    omodel.status = "200";
                    omodel.message = "Location details successfully updated.";


                }
                else
                {

                    omodel.status = "202";
                    omodel.message = "User id or Session token does not matched";

                }

                var message = Request.CreateResponse(HttpStatusCode.OK, omodel);
                return message;
            }

        }



   

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

        }
    }
}
