using System;
using System.Web;
using System.Web.UI;
using System.Configuration;

namespace ERP.OMS.Management.Master
{
    public partial class management_master_Lead_FamilyMembers : ERP.OMS.ViewState_class.VSPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //------- For Read Only User in SQL Datasource Connection String   Start-----------------

            if (HttpContext.Current.Session["EntryProfileType"] != null)
            {
                if (Convert.ToString(HttpContext.Current.Session["EntryProfileType"]) == "R")
                {
                    FamilyMemberData.ConnectionString = ConfigurationSettings.AppSettings["DBReadOnlyConnection"];
                }
                else
                {
                    FamilyMemberData.ConnectionString = ConfigurationSettings.AppSettings["DBConnectionDefault"];
                }
            }

            //------- For Read Only User in SQL Datasource Connection String   End-----------------
            //if (HttpContext.Current.Session["userid"] == null)
            //{
            //   //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            //}
            ////this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");

        }

    }
}