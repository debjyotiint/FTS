using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using BusinessLogicLayer;

namespace ERP.OMS.Management
{
    public partial class management_test1 : System.Web.UI.Page
    {
        private bool isEditMode = false;
        DBEngine objEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        Converter ObjConvert = new Converter();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                isEditMode = true;
                BindData();
                //gvUsers.Columns[1].Visible = false;
            }


        }
        private void BindData()
        {
            DataTable a = new DataTable();
            a = objEngine.GetDataTable("Trans_CashBankVouchers", " cashbank_id,cashbank_vouchernumber", null, null);
            gvUsers.DataSource = a;
            gvUsers.DataBind();

        }
        protected void Button1_Click(object sender, EventArgs e)
        {

            isEditMode = true;

            BindData();

        }

        protected bool IsInEditMode
        {

            get { return this.isEditMode; }

            set { this.isEditMode = value; }

        }

        protected void Button2_Click(object sender, EventArgs e)
        {

            isEditMode = false;

            BindData();

        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            //for (int i = 0; i < gvUsers.Rows.Count; i++)
            foreach (GridViewRow row in gvUsers.Rows)
            {
                //TextBox lbl = (TextBox)row.FindControl("gvUsers_ctl01_txtLastName");
                TextBox txt = (TextBox)row.FindControl("txtLastName");
                string b = txt.Text.ToString();
                //objEngine.SetFieldValue("Trans_CashBankVouchers", "cashbank_vouchernumber='" + gvUsers.Rows[i]["cashbank_vouchernumber"].ToString() + "'", "cashbank_id='" + gvUsers.Rows[i]["cashbank_id"].ToString() + "'");
            }
        }
    }
}