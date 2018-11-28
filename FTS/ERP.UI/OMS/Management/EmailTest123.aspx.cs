using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using CrystalDecisions.CrystalReports.Engine;
using BusinessLogicLayer;

namespace ERP.OMS.Management
{
    public partial class management_EmailTest : System.Web.UI.Page
    {
        static DataSet ds = new DataSet();
        DBEngine oDBEngine = new DBEngine(string.Empty);
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            // oDBEngine.ActivityMailCreation();
            bind_Print();
        }

        void bind_Print()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
            {
                //string client = null;

                //for (int i = 0; i < dtClients.Rows.Count; i++)
                //{
                //    if (client == null)
                //        client = "'" + dtClients.Rows[i]["ComCustomerTrades_CustomerID"].ToString() + "'";
                //    else
                //        client = client + "," + "'" + dtClients.Rows[i]["ComCustomerTrades_CustomerID"].ToString() + "'";
                //}
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                cmd.CommandText = "[sp_testContact]";

                cmd.CommandType = CommandType.StoredProcedure;
                //cmd.Parameters.AddWithValue("@fromdate", dtFrom.Value);
                //cmd.Parameters.AddWithValue("@todate", dtTo.Value);
                //cmd.Parameters.AddWithValue("@segment", Convert.ToInt32(Session["usersegid"].ToString()));
                //cmd.Parameters.AddWithValue("@Companyid", Session["LastCompany"].ToString());
                //cmd.Parameters.AddWithValue("@MasterSegment", HttpContext.Current.Session["ExchangeSegmentID"].ToString());
                //cmd.Parameters.AddWithValue("@ClientsID", client);


                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = cmd;
                ds.Reset();
                da.Fill(ds);

                ReportDocument report = new ReportDocument();
                //ds.WriteXmlSchema(ConfigurationManager.AppSettings["SaveCSVsql"] + "\\Reports\\Contact.xsd");
                //report.PrintOptions.PaperOrientation = CrystalDecisions.Shared.PaperOrientation.Landscape;



                string tmpPdfPath = string.Empty;
                tmpPdfPath = HttpContext.Current.Server.MapPath("..\\Reports\\tstCrystalReport.rpt");
                report.Load(tmpPdfPath);
                report.SetDataSource(ds.Tables[0]);
                report.ExportToHttpResponse(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, HttpContext.Current.Response, true, "Bill Printing");

                report.Dispose();
                GC.Collect();

            }
        }
    }
}