using System;
using System.Configuration;
using System.Web;

namespace ERP.OMS.Management
{

    public partial class management_sales_businessP : System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        protected void Page_Load(object sender, EventArgs e)
        {

            //------- For Read Only User in SQL Datasource Connection String   Start-----------------

            if (HttpContext.Current.Session["EntryProfileType"] != null)
            {
                if (Convert.ToString(HttpContext.Current.Session["EntryProfileType"]) == "R")
                {
                    SqlLodging.ConnectionString = ConfigurationSettings.AppSettings["DBReadOnlyConnection"];
                }
                else
                {
                    SqlLodging.ConnectionString = ConfigurationSettings.AppSettings["DBConnectionDefault"];
                }
            }

            //------- For Read Only User in SQL Datasource Connection String   End-----------------

        }
        protected void gridLodging_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            //string[,] interId = oDBEngine.GetFieldValue("tbl_trans_salesExpenditure", "top 1 expnd_internalId", " expnd_empId='" + Session["SalesVisitID"].ToString() + "' and expnd_BPDescription is null", 1);
            //if (interId[0, 0] != "n")
            //{
            //    Session["IID"] = interId[0, 0];
            //}
            //else
            //{
            //    Session["IID"] = "0";
            //}
        }
    }
}
