using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.Services;
//using DevExpress.Web;
using DevExpress.Web;
using BusinessLogicLayer;
using DataAccessLayer;

namespace ERP.OMS.Management.Master
{
    public partial class management_master_AccountGroup : ERP.OMS.ViewState_class.VSPage
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        ProcedureExecute proc = new ProcedureExecute();
        public EntityLayer.CommonELS.UserRightsForPage rights = new EntityLayer.CommonELS.UserRightsForPage();


        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                // .............................Code Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ................

                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                //string sPath = HttpContext.Current.Request.Url.ToString();

                // .............................Code Above Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ..................................... 
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/AccountGroup.aspx");
            //------- For Read Only User in SQL Datasource Connection String   Start-----------------
            //#ag21102016
            //if (!rights.CanView)
            //{
            //    Response.Redirect("ProjectMainPage.aspx", false);
            //}
            //#ag21102016
            if (HttpContext.Current.Session["EntryProfileType"] != null)
            {
                if (Convert.ToString(HttpContext.Current.Session["EntryProfileType"]) == "R")
                {
                    SqlDsAccountGroup.ConnectionString = ConfigurationManager.AppSettings["DBReadOnlyConnection"];
                }
                else
                {
                    SqlDsAccountGroup.ConnectionString = ConfigurationManager.AppSettings["DBConnectionDefault"];
                }
            }
            //------- For Read Only User in SQL Datasource Connection String   End-----------------

            if (HttpContext.Current.Session["userid"] == null)
            {
                //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
            //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");
            AccountGroup.JSProperties["cpDelmsg"] = null;

            if (!IsPostBack)
            {
                Session["exportval"] = null;
            }
        }

        [WebMethod]
        public static bool CheckUniqueCode(string uniqueCode, string uniqueid)
        {
            bool flag = false;
            BusinessLogicLayer.GenericMethod oGenericMethod = new BusinessLogicLayer.GenericMethod();
            try
            {

                DataTable dt = new DataTable();
                if (uniqueid == "0")
                {
                    dt = oGenericMethod.GetDataTable("SELECT AccountGroup_Code FROM [dbo].[Master_AccountGroup] WHERE [AccountGroup_Code] = " + "'" + uniqueCode + "'");
                }
                else
                {
                    dt = oGenericMethod.GetDataTable("SELECT AccountGroup_Code FROM [dbo].[Master_AccountGroup] WHERE [AccountGroup_Code] = " + "'" + uniqueCode + "' and AccountGroup_ReferenceID <>'" + uniqueid + "'");
                }

                int cnt = dt.Rows.Count;
                if (cnt > 0)
                {
                    flag = true;
                }
            }
            catch (Exception ex)
            {

            }
            finally
            {
            }
            return flag;
        }

        [WebMethod]
        public static bool CheckUniqueName(string uniqueName, string uniqueid)
        {
            bool flag = false;
            BusinessLogicLayer.GenericMethod oGenericMethod = new BusinessLogicLayer.GenericMethod();
            try
            {

                DataTable dt = new DataTable();
                if (uniqueid == "0")
                {
                    dt = oGenericMethod.GetDataTable("SELECT AccountGroup_Code FROM [dbo].[Master_AccountGroup] WHERE [AccountGroup_Name] = " + "'" + uniqueName + "'");
                }
                else
                {
                    dt = oGenericMethod.GetDataTable("SELECT AccountGroup_Code FROM [dbo].[Master_AccountGroup] WHERE [AccountGroup_Name] = " + "'" + uniqueName + "' and AccountGroup_ReferenceID <>'" + uniqueid + "'");
                }

                int cnt = dt.Rows.Count;
                if (cnt > 0)
                {
                    flag = true;
                }
            }
            catch (Exception ex)
            {

            }
            finally
            {
            }
            return flag;
        }
        protected void AccountGroup_HtmlEditFormCreated(object sender, ASPxGridViewEditFormEventArgs e)
        {



            if (!AccountGroup.IsNewRowEditing)
            {
                int index = ((ASPxGridView)sender).EditingRowVisibleIndex;
                // .............................Code Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ................
                string AccountGroupName = Convert.ToString(((ASPxGridView)sender).GetRowValues(index, "AccountGroupName")).Trim();
                //string AccountGroupName = ((ASPxGridView)sender).GetRowValues(index, "AccountGroupName").ToString().Trim();

                // .............................Code Above Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). .....................................

                SqlDs1AccountGroupParentID.SelectCommand = "Select 'None' as ParentIDWithName ,'' as AccountGroupParentID,'0' as AccountGroupParentID1 Union All Select AccountGroup_Name  as ParentIDWithName, cast([AccountGroup_ReferenceID]  as varchar(100)) as AccountGroupParentID,cast([AccountGroup_ParentGroupID]  as varchar(100))as AccountGroupParentID1  from Master_AccountGroup Where AccountGroup_Name<>'" + AccountGroupName + "'";

                //GridViewDataTextColumn clCode = (GridViewDataTextColumn)((ASPxGridView)sender).Columns[1];
                //clCode.ReadOnly = true;
            }
            else
                SqlDs1AccountGroupParentID.SelectCommand = "Select 'None' as ParentIDWithName ,'' as AccountGroupParentID,'0' as AccountGroupParentID1 Union All Select AccountGroup_Name  as ParentIDWithName, cast([AccountGroup_ReferenceID]  as varchar(100)) as AccountGroupParentID,cast([AccountGroup_ParentGroupID]  as varchar(100))as AccountGroupParentID1  from Master_AccountGroup";

        }



        protected void AccountGroup_OnRowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {

            AccountGroup_BL agbl = new AccountGroup_BL();
            #region
            //var k = ((ASPxComboBox)AccountGroup.FindEditFormTemplateControl(AccountGroup.Columns["AccountGroupParentID"] as GridViewDataComboBoxColumn, "AccountGroupParentID")).Value;

            try
            {
                //GridViewDataComboBoxColumn combo = AccountGroup.Columns["AccountGroupParentID"] as GridViewDataComboBoxColumn;
                //var t = combo.PropertiesComboBox.ValueField;
                //var x = combo.PropertiesComboBox.Items.FindByText(e.NewValues["AccountGroupParentID"].ToString().Trim()).Value;
                //var x1 = combo.PropertiesComboBox.Items.FindByValue(e.NewValues["AccountGroupParentID"].ToString().Trim()).Value;


            }
            catch (Exception ex)
            {

            }
            //var t1 = combo.PropertiesComboBox.ValueField;
            //var t2 = combo.PropertiesComboBox.ValueField;
            //ASPxComboBox com=   (ASPxComboBox)AccountGroup.find
            #endregion
            Int64 AccountGroupParentID = 0;

            // .............................Code Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ................

            string AccountGroupParentIDTemp = Convert.ToString(e.NewValues["AccountGroupParentID"]);

            // .............................Code Above Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). .....................................

            int value;
            if (int.TryParse(AccountGroupParentIDTemp, out value))
            {
                AccountGroupParentID = Convert.ToInt64(e.NewValues["AccountGroupParentID"]);
            }
            else
            {
                AccountGroupParentID = agbl.GetAccountGroupParentID(AccountGroupParentIDTemp);
            }

            // .............................Code Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ................
            int NoOfRowEffected = agbl.AccountGroupUpdating(Convert.ToString(e.Keys[0]), Convert.ToString(e.NewValues["AccountGroupType"]), Convert.ToString(e.NewValues["AccountGroupCode"]), Convert.ToString(e.NewValues["AccountGroupName"]), Convert.ToString(AccountGroupParentID), Convert.ToString(HttpContext.Current.Session["userid"]));

            //int NoOfRowEffected = agbl.AccountGroupUpdating(e.Keys[0].ToString(), e.NewValues["AccountGroupType"].ToString(), e.NewValues["AccountGroupCode"].ToString(), e.NewValues["AccountGroupName"].ToString(), AccountGroupParentID.ToString(), HttpContext.Current.Session["userid"].ToString());
            // int NoOfRowEffected = agbl.AccountGroupUpdating(e.Keys[0].ToString(), e.NewValues["AccountGroupType"].ToString(), e.NewValues["AccountGroupCode"].ToString(), e.NewValues["AccountGroupName"].ToString(), e.NewValues["AccountGroupParentID"].ToString(), HttpContext.Current.Session["userid"].ToString());

            // .............................Code Above Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). .....................................

            #region
            //using (SqlConnection lcon = new SqlConnection(ConfigurationSettings.AppSettings["DBConnectionDefault"]))
            //{
            //    lcon.Open();
            //    using (SqlCommand lcmd = new SqlCommand("UpdateAccountGroup", lcon))
            //    {
            //        lcmd.CommandType = CommandType.StoredProcedure;
            //        lcmd.Parameters.Add("AccountGroupID", SqlDbType.Int).Value = e.Keys[0].ToString();
            //        lcmd.Parameters.Add("@AccountGroupType", SqlDbType.Char).Value = e.NewValues["AccountGroupType"].ToString();
            //        lcmd.Parameters.Add("@AccountGroupCode", SqlDbType.Char).Value = e.NewValues["AccountGroupCode"].ToString();
            //        lcmd.Parameters.Add("@AccountGroupName", SqlDbType.VarChar).Value = e.NewValues["AccountGroupName"].ToString();
            //        if (e.NewValues["AccountGroupParentID"] == null)
            //            lcmd.Parameters.Add("@AccountGroupParentID", SqlDbType.Int).Value = 0;
            //        else
            //            lcmd.Parameters.Add("@AccountGroupParentID", SqlDbType.Int).Value = Convert.ToInt32(e.NewValues["AccountGroupParentID"].ToString());

            //        lcmd.Parameters.Add("@CreateUser", SqlDbType.Int).Value = Convert.ToInt32(HttpContext.Current.Session["userid"]);
            //        int NoOfRowEffected = lcmd.ExecuteNonQuery();
            //    }
            //}
            #endregion
            e.Cancel = true;
            AccountGroup.CancelEdit();
            // e.Cancel = true;

        }



        protected void AccountGroup_OnRowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {

            if (AccountGroup.IsNewRowEditing)
            {
                string strAccountGroupCodevalue = "";
                string strAccountGroupNamevalue = "";
                if (e.NewValues["AccountGroupCode"] != null)
                {
                    // .............................Code Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ................

                    strAccountGroupCodevalue = Convert.ToString(e.NewValues["AccountGroupCode"]);
                    //strAccountGroupCodevalue = e.NewValues["AccountGroupCode"].ToString();

                    // .............................Code Above Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ..................................... 
                }
                if (e.NewValues["AccountGroupName"] != null)
                {
                    // .............................Code Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ................

                    strAccountGroupNamevalue = Convert.ToString(e.NewValues["AccountGroupName"]);
                    //strAccountGroupNamevalue = e.NewValues["AccountGroupName"].ToString();

                    // .............................Code Above Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ..................................... 
                }

                BusinessLogicLayer.DBEngine gg = new BusinessLogicLayer.DBEngine("");
                //....................... Code  Added By Sam on 10112016 to because duplicate account group name already checked on textchanged event of shortname............................


                //SqlDataReader GetReader1 = gg.GetReader("SELECT  AccountGroup_Code as AccountGroupCode FROM Master_AccountGroup where AccountGroup_Code='" + strAccountGroupCodevalue + "'");
                //if (GetReader1.HasRows == true)
                //{

                //    e.RowError = "Short Name should be unique";
                //}
                //gg.CloseConnection();

                //SqlDataReader GetReader2 = gg.GetReader("SELECT AccountGroup_Name as AccountGroupName FROM Master_AccountGroup where  AccountGroup_Name='" + strAccountGroupNamevalue + "'");

                //if (GetReader2.HasRows == true)
                //{
                //    if (e.RowError != "")
                //    {

                //        e.RowError = e.RowError.ToString() + " and Name should be unique.";
                //    }
                //    else
                //        e.RowError = "Account Name should be unique.";
                //}

                //....................... Code above Added By Sam on 10112016 to because duplicate account group name already checked on textchanged event of shortname............................


            }

        }



        protected void AccountGroup_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {
            if (AccountGroup.IsNewRowEditing)
            {

                if (e.Column.FieldName == "AccountGroupType")
                {
                    e.Editor.Value = "Asset";
                }
                if (e.Column.FieldName == "AccountGroupCode")
                {
                    e.Editor.Focus();

                }

            }
            //if (!AccountGroup.IsNewRowEditing)
            //{

            //    if (e.Column.FieldName == "AccountGroupCode")
            //    {
            //        e.Editor.ReadOnly = true;

            //    }
            //}

        }


        protected void AccountGroup_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            //if (e.Parameters == "s")
            //    AccountGroup.Settings.ShowFilterRow = true;

            if (e.Parameters == "All")
            {
                AccountGroup.FilterExpression = string.Empty;
            }
        }
        protected void AccountGroup_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e)
        {
            e.Properties["cpEND"] = "2";
        }
        protected void AccountGroup_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            if (Convert.ToString(e.Values["AccountGroupCode"]) != "")
            {
                string strAccGroupCode = Convert.ToString(e.Values["AccountGroupCode"]);
                #region
                //string[,] acccode = oDBEngine.GetFieldValue("master_MainAccount",
                //  "MainAccount_ReferenceID", "MainAccount_AccountCode='" + strAccGroupCode + "'", 1);
                #endregion
                ////string[,] acccode = oDBEngine.GetFieldValue("master_MainAccount,Master_AccountGroup",
                ////  "MainAccount_ReferenceID", "AccountGroup_ReferenceID=MainAccount_AccountGroup and MainAccount_AccountCode='" + strAccGroupCode + "'", 1);
                ////////string[,] acccode = oDBEngine.GetFieldValue("Master_AccountGroup",
                ////////"AccountGroup_ReferenceID", "AccountGroup_ParentGroupID=(select AccountGroup_ReferenceID from Master_AccountGroup where AccountGroup_Code='" + strAccGroupCode + "')", 1);
                // if (acccode[0, 0] != "n")
                //DataTable dt = oDBEngine.GetDataTable("select MainAccount_Name,* from Master_MainAccount where MainAccount_Name='" + strAccGroupCode+"' union all ");
                DataTable dt = oDBEngine.GetDataTable("select a.AccountGroup_ReferenceID as 'AccountGroup' from Master_AccountGroup a inner join Master_AccountGroup b on a.AccountGroup_ReferenceID=b.AccountGroup_ParentGroupID where a.AccountGroup_Code='" + strAccGroupCode + "' union all select MainAccount_AccountGroup as 'AccountGroup' from Master_MainAccount where MainAccount_AccountGroup=(select AccountGroup_ReferenceID from Master_AccountGroup where AccountGroup_Code='" + strAccGroupCode + "')");
                if (dt.Rows.Count > 0)
                {
                    AccountGroup.JSProperties["cpDelmsg"] = "Used in other modules. Cannot Delete.";
                    e.Cancel = true;

                }
                else
                {
                    //AccountGroup.JSProperties["cpDelmsg"] = "Cannot Delete. This AccountGroup Code Is In Use";
                    AccountGroup.JSProperties["cpDelmsg"] = "Succesfully Deleted";

                }

            }
        }

        protected void AccountGroup_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
        {
            if (!rights.CanDelete)
            {
                if (e.ButtonType == ColumnCommandButtonType.Delete)
                {
                    e.Visible = false;
                }
            }


            if (!rights.CanEdit)
            {
                if (e.ButtonType == ColumnCommandButtonType.Edit)
                {
                    e.Visible = false;
                }
            }
        }


        protected void AccountGroup_StartRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            AccountGroup.SettingsText.PopupEditFormCaption = "Modify Account Group";
            // .............................Code Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ................
            int id = Convert.ToInt32(Convert.ToString(e.EditingKeyValue));
            //int id = Convert.ToInt32(e.EditingKeyValue.ToString());
            // .............................Code Above Commented and Added by Sam on 06122016 to use Convert.tostring instead of tostring(). ..................................... 
            Session["id"] = id;

        }

        protected void AccountGroup_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            AccountGroup.SettingsText.PopupEditFormCaption = "Add Account Group";
        }

        public void bindexport(int Filter)
        {
            AccountGroup.Columns[4].Visible = false;
            //SchemaGrid.Columns[11].Visible = false;
            //SchemaGrid.Columns[12].Visible = false;
            string filename = "Account Group";
            exporter.FileName = filename;

            exporter.PageHeader.Left = "Account Group";
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";

            switch (Filter)
            {
                case 1:
                    exporter.WritePdfToResponse();
                    break;
                case 2:
                    exporter.WriteXlsToResponse();
                    break;
                case 3:
                    exporter.WriteRtfToResponse();
                    break;
                case 4:
                    exporter.WriteCsvToResponse();
                    break;
            }
        }
        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                if (Session["exportval"] == null)
                {
                    Session["exportval"] = Filter;
                    bindexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    Session["exportval"] = Filter;
                    bindexport(Filter);
                }
            }
        }
    }
}