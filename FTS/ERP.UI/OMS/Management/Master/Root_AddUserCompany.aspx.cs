using System;
using System.Data;
using System.Web.UI;
using System.Configuration;
using BusinessLogicLayer;
using System.Web.Services;
using System.Collections.Generic;


namespace ERP.OMS.Management.Master
{
    public partial class management_master_Root_AddUserCompany : ERP.OMS.ViewState_class.VSPage
    {
        string[,] AllType;
        //DBEngine oDBEngine = new DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);

        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);

        protected void Page_Load(object sender, EventArgs e)
        {
           // txtContact.Attributes.Add("onkeyup", "showOptions(this,'Company',event)");
            if (!IsPostBack)
            {
                
                BindGrid();
            }
        }
        /*Code  Added  By Priti on 06122016 to use jquery Choosen*/
        [WebMethod]
        public static List<string> ALLContact(string reqStr)
        {               

            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
            DataTable DT = new DataTable();
            DT.Rows.Clear();
            DT = oDBEngine.GetDataTable(" tbl_master_company ", "cmp_internalid,cmp_Name ", "cmp_Name like '" + reqStr + "%' ");
            List<string> obj = new List<string>();
            foreach (DataRow dr in DT.Rows)
            {
                
                obj.Add(Convert.ToString(dr["cmp_Name"]) + "|" + Convert.ToString(dr["cmp_internalid"]));               
                
            }

            return obj;
        }
        //...............code end........
        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (txtContact_hidden.Value != "")
            {
                DataTable dtV = oDBEngine.GetDataTable("Master_UserCompany", "*", "UserCompany_UserID='" + Convert.ToString(Request.QueryString["id"]) + "' and UserCompany_CompanyID='" + txtContact_hidden.Value + "'");
                if (dtV.Rows.Count > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "JScript1454", "jAlert('Already Added..!!');", true);
                    return;
                    //Response.Redirect("/OMS/Management/Master/Root_AddUserCompany.aspx?id=" + Request.QueryString["id"].ToString());
                }
                else
                {
                    oDBEngine.InsurtFieldValue("Master_UserCompany", "UserCompany_UserID,UserCompany_CompanyID,UserCompany_CreateUser,UserCompany_CreateDateTime", "'" + Convert.ToString(Request.QueryString["id"]) + "','" + txtContact_hidden.Value + "','" + Convert.ToString(Session["userid"]) + "','" + DateTime.Now + "'");
                    Response.Redirect("/OMS/Management/Master/Root_AddUserCompany.aspx?id=" + Convert.ToString(Request.QueryString["id"]));
                }
            }
            else
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "JScript1", "jAlert('Please Select Contact!!');", true);
            }




            txtContact_hidden.Value = "";
           // txtContact.Text = "";

            ScriptManager.RegisterStartupScript(this, GetType(), "JScript19", "CallGrid();", true);
            BindGrid();

        }

        public void BindGrid()
        {
            string id = Request.QueryString["id"];
            if (id != null)
            {
                SelectName.SelectCommand = "select UserCompany_ID, (select user_name from tbl_master_user where user_id=UserCompany_UserID) as UserName ,(select cmp_name from tbl_master_company where cmp_internalid=UserCompany_CompanyID) as Company,UserCompany_CompanyID  from  dbo.Master_UserCompany where  UserCompany_UserID=" + id + "";
                GridName.DataBind();

            }
        }

        //protected void BtnCancel_Click(object sender, EventArgs e)
        //{


        //    ScriptManager.RegisterStartupScript(this, GetType(), "JScript41", "parent.editwin.close();", true);

        //}

        protected void GridName_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters != "")
            {
                string tranid = Convert.ToString(e.Parameters);
                oDBEngine.DeleteValue("Master_UserCompany ", "UserCompany_ID ='" + tranid + "'");
                //this.Page.ClientScript.RegisterStartupScript(GetType(), "script4", "<script>height();</script>");

            }
            BindGrid();

        }
    }
}