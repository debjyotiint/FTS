using System;
using System.Configuration;
using BusinessLogicLayer;

namespace ERP.OMS.Management
{
    public partial class management_testlist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            //txtname.Attributes.Add("onkeyup", "ajax_showOptions(txtname,'SearchByUser',event)");

            string dirstr = Server.MapPath("../Documents/") + "\\" + "Asit";
            if (System.IO.Directory.Exists(dirstr))
            {
                Response.Write("No");
            }
            else
            {
                System.IO.Directory.CreateDirectory(Server.MapPath("../Documents/") + "\\" + "Asit");
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            DBEngine oDBEngine = new DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
            string[,] data = oDBEngine.GetFieldValue(" tbl_trans_salesvisit inner join tbl_trans_activies on slv_activityid=act_id ", " slv_id,act_assignedby, act_assignedto ", " slv_salesvisitoutcome = 9 and getdate() between (convert(varchar(10),act_scheduleddate,101) + ' ' + act_scheduledtime) and (convert(varchar(10),act_expecteddate,101) + ' ' + act_expectedtime)and slv_lastdatevisit is null ", 3);
            if (data[0, 0] != "n")
            {
                //lblmessage.Text = oDBEngine.SystemGeneratedMails(data[0, 0].ToString(), "Sales");

            }
        }



    }
}