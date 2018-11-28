using System;


namespace ERP.OMS.Management
{

    public partial class management_ViewFile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                string picPath = Request.QueryString["id"].ToString();
                if (picPath == "")
                {
                    string jscript = "<script language='javascript'>alert('No Image !');window.close();</script>";
                    ClientScript.RegisterStartupScript(GetType(), "JScript", jscript);

                }
                else
                {
                    int pic = picPath.LastIndexOf("~");
                    string pic1 = picPath.Substring(pic + 1);
                    //Response.Redirect("../" + pic1);
                    Response.Redirect("~/OMS/Management/" + pic1);
                }
            }
            if (Request.QueryString["val"] != null)
            {
                Response.Redirect("../" + Request.QueryString["val"].ToString());
            }
            //Response.Redirect(picPath);
        }
    }
}