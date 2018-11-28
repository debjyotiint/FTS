using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
////using DevExpress.Web.ASPxClasses;
//using DevExpress.Web;
using DevExpress.Web;
using BusinessLogicLayer;
using System.Web;


namespace ERP.OMS.Management
{
    public partial class management_testnn : System.Web.UI.Page
    {
        DBEngine oDBEngine = new DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
        protected void Page_Load(object sender, EventArgs e)
        {

            //------- For Read Only User in SQL Datasource Connection String   Start-----------------

            if (HttpContext.Current.Session["EntryProfileType"] != null)
            {
                if (Convert.ToString(HttpContext.Current.Session["EntryProfileType"]) == "R")
                {
                    dsCashBankReport.ConnectionString = ConfigurationSettings.AppSettings["DBReadOnlyConnection"];
                }
                else
                {
                    dsCashBankReport.ConnectionString = ConfigurationSettings.AppSettings["DBConnectionDefault"];
                }
            }

            //------- For Read Only User in SQL Datasource Connection String   End-----------------

            if (!IsPostBack)
            {
                //dsCashBankReport.SelectCommand = "select a.*, a.CashBank_BranchID as BANKBRANCH_NAME, a.CashBank_MainAccountID as AccountName , a.CashBank_MainAccountID as SubAccountName from dbo.Trans_CashBankVouchers as a ";
                //dsCashBankReport.SelectCommand = "select a.*,a.CashBank_MainAccountID as CashBank_MainAccountID , a.CashBank_SubAccountID as SubAccountID from dbo.Trans_CashBankVouchers as a ";
                grdCashbankReport.AddNewRow();
                //dateEdit.Value = oDBEngine.GetDate();
            }

            //else
            //{
            //    dsCashBankReport.SelectCommand = "select a.*,a.CashBank_MainAccountID as CashBank_MainAccountID , a.CashBank_SubAccountID as SubAccountID from dbo.Trans_CashBankVouchers as a ";
            //    grdCashbankReport.AddNewRow();

            //}
        }

        protected void grdCashbankReport_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {

            if (e.Column.FieldName == "CashBank_InstrumentDate")
            {
                if (e.KeyValue != null)
                {
                    object val = grdCashbankReport.GetRowValuesByKeyValue(e.KeyValue, "CashBank_InstrumentDate");
                    ASPxDateEdit comboDate = e.Editor as ASPxDateEdit;
                    if (val != null)
                    {
                        comboDate.Value = oDBEngine.GetDate();
                    }
                    else
                    {
                        comboDate.Value = oDBEngine.GetDate();

                    }
                    //if (val == DBNull.Value) return;
                    //string Datevalue = (string)val;
                    //comboDate.Value = oDBEngine.GetDate();
                }
                else
                {

                    ASPxDateEdit comboDate = e.Editor as ASPxDateEdit;
                    comboDate.Value = oDBEngine.GetDate();
                }

            }
            if (e.Column.FieldName == "SubAccountID")
            {
                if (e.KeyValue != null)
                {
                    object val = grdCashbankReport.GetRowValuesByKeyValue(e.KeyValue, "CashBank_MainAccountID");
                    if (val == DBNull.Value) return;
                    string AccountID = (string)val;
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    FillSubAccountCombo(combo, AccountID);

                    combo.Callback += new CallbackEventHandlerBase(SubAccount_OnCallback);
                }
                else
                {

                    object val = grdCashbankReport.GetRowValues(0, "CashBank_MainAccountID");
                    if (val != null)
                    {

                        string AccountID = (string)val;
                        ASPxComboBox combo = e.Editor as ASPxComboBox;
                        FillSubAccountCombo(combo, AccountID);

                        combo.Callback += new CallbackEventHandlerBase(SubAccount_OnCallback);
                    }
                    else
                    {

                        string AccountID = "1";
                        ASPxComboBox combo = e.Editor as ASPxComboBox;
                        FillSubAccountCombo(combo, AccountID);

                        combo.Callback += new CallbackEventHandlerBase(SubAccount_OnCallback);
                    }
                }
            }
            ///////////////////
            if (e.Column.FieldName == "CashBank_InstrumentType")
            {
                if (e.KeyValue == null)
                {
                    ASPxComboBox instType = e.Editor as ASPxComboBox;
                    instType.SelectedIndex = 0;
                }
            }
        }
        protected void FillSubAccountCombo(ASPxComboBox cmb, string SubAccountID)
        {

            string[,] SubAccount = GetSubAccount(SubAccountID);
            cmb.Items.Clear();


            for (int i = 0; i < SubAccount.GetLength(0); i++)
            {
                cmb.Items.Add(SubAccount[i, 1], SubAccount[i, 0]);
            }
        }

        string[,] GetSubAccount(string SubAccountID)
        {


            SelectSubaccountReport.SelectParameters[0].DefaultValue = SubAccountID.ToString();
            DataView view = (DataView)SelectSubaccountReport.Select(DataSourceSelectArguments.Empty);
            string[,] DATA = new string[view.Count, 2];
            for (int i = 0; i < view.Count; i++)
            {
                DATA[i, 0] = view[i][0].ToString();
                DATA[i, 1] = view[i][1].ToString();
            }
            return DATA;


        }
        private void SubAccount_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillSubAccountCombo(source as ASPxComboBox, Convert.ToString(e.Parameter));
        }
        protected void grdCashbankReport_HtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {

        }
        protected void grdCashbankReport_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {

            SqlConnection lcon = new SqlConnection(ConfigurationSettings.AppSettings["DBConnectionDefault"]);

            lcon.Open();
            SqlCommand lcmd = new SqlCommand("InsertInCashBankVoucher", lcon);
            lcmd.CommandType = CommandType.StoredProcedure;

            //ASPxComboBox MainAccountName = (ASPxComboBox)grdCashbankReport.FindControl("MainAccountName");
            //if (MainAccountName.Value != null)
            //{
            //    e.NewValues["MainAccount_Name"] = MainAccountName.Value.ToString();
            //}

            if (e.NewValues["CashBank_MainAccountID"] != null)
            {
                lcmd.Parameters.Add("@CashBank_MainAccountID", SqlDbType.VarChar).Value = e.NewValues["CashBank_MainAccountID"].ToString();
            }

            if (e.NewValues["SubAccountID"] != null)
            {
                lcmd.Parameters.Add("@SubAccountID", SqlDbType.VarChar).Value = e.NewValues["SubAccountID"].ToString();
            }

            if (e.NewValues["CashBank_InstrumentType"] != null)
            {
                lcmd.Parameters.Add("@CashBank_InstrumentType", SqlDbType.VarChar).Value = e.NewValues["CashBank_InstrumentType"].ToString();
            }


            if (e.NewValues["CashBank_InstrumentDate"] != null)
            {
                lcmd.Parameters.Add("@CashBank_InstrumentDate", SqlDbType.VarChar).Value = e.NewValues["CashBank_InstrumentDate"].ToString();
            }

            if (e.NewValues["CashBank_InstrumentNumber"] != null)
            {
                lcmd.Parameters.Add("@CashBank_InstrumentNumber", SqlDbType.VarChar).Value = e.NewValues["CashBank_InstrumentNumber"].ToString();
            }
            if (e.NewValues["CashBank_PayeeAccountID"] != null)
            {
                lcmd.Parameters.Add("@CashBank_PayeeAccountID", SqlDbType.VarChar).Value = e.NewValues["CashBank_PayeeAccountID"].ToString();
            }
            if (e.NewValues["CashBank_AmountWithdrawl"] != null)
            {
                lcmd.Parameters.Add("@CashBank_AmountWithdrawl", SqlDbType.Decimal).Value = Convert.ToDecimal(e.NewValues["CashBank_AmountWithdrawl"].ToString());
            }
            if (e.NewValues["CashBank_AmountDeposit"] != null)
            {
                lcmd.Parameters.Add("@CashBank_AmountDeposit", SqlDbType.Decimal).Value = Convert.ToDecimal(e.NewValues["CashBank_AmountDeposit"].ToString());
            }
            int NoOfRowEffected = lcmd.ExecuteNonQuery();

            lcmd.Dispose();
            lcon.Close();
            //if (NoOfRowEffected == 1)
            //{
            //    BindData();


            //}
            //lcon.Dispose();













        }
        protected void grdCashbankReport_RowInserted(object sender, DevExpress.Web.Data.ASPxDataInsertedEventArgs e)
        {
            //grdCashbankReport.CancelEdit();
            //grdCashbankReport.UpdateEdit();
            //  BindData();
        }
        protected void grdCashbankReport_BeforeGetCallbackResult(object sender, EventArgs e)
        {
            if (!grdCashbankReport.IsEditing && !grdCashbankReport.IsNewRowEditing)
            {
                grdCashbankReport.AddNewRow();
            }
        }
        protected void grdCashbankReport_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {


            SqlConnection lcon = new SqlConnection(ConfigurationSettings.AppSettings["DBConnectionDefault"]);

            lcon.Open();
            SqlCommand lcmd = new SqlCommand("UpdateInCashBankVoucher", lcon);
            lcmd.CommandType = CommandType.StoredProcedure;


            lcmd.Parameters.Add("@CashBank_ID", SqlDbType.BigInt).Value = e.Keys[0].ToString();

            //ASPxComboBox MainAccountName = (ASPxComboBox)grdCashbankReport.FindControl("MainAccountName");
            //if (MainAccountName.Value != null)
            //{
            //    e.NewValues["MainAccount_Name"] = MainAccountName.Value.ToString();
            //}

            if (e.NewValues["CashBank_MainAccountID"] != null)
            {
                lcmd.Parameters.Add("@CashBank_MainAccountID", SqlDbType.VarChar).Value = e.NewValues["CashBank_MainAccountID"].ToString();
            }

            if (e.NewValues["SubAccountID"] != null)
            {
                lcmd.Parameters.Add("@SubAccountID", SqlDbType.VarChar).Value = e.NewValues["SubAccountID"].ToString();
            }

            if (e.NewValues["CashBank_InstrumentType"] != null)
            {
                lcmd.Parameters.Add("@CashBank_InstrumentType", SqlDbType.VarChar).Value = e.NewValues["CashBank_InstrumentType"].ToString();
            }


            if (e.NewValues["CashBank_InstrumentDate"] != null)
            {
                lcmd.Parameters.Add("@CashBank_InstrumentDate", SqlDbType.VarChar).Value = e.NewValues["CashBank_InstrumentDate"].ToString();
            }

            if (e.NewValues["CashBank_InstrumentNumber"] != null)
            {
                lcmd.Parameters.Add("@CashBank_InstrumentNumber", SqlDbType.VarChar).Value = e.NewValues["CashBank_InstrumentNumber"].ToString();
            }
            if (e.NewValues["CashBank_PayeeAccountID"] != null)
            {
                lcmd.Parameters.Add("@CashBank_PayeeAccountID", SqlDbType.VarChar).Value = e.NewValues["CashBank_PayeeAccountID"].ToString();
            }
            if (e.NewValues["CashBank_AmountWithdrawl"] != null)
            {
                lcmd.Parameters.Add("@CashBank_AmountWithdrawl", SqlDbType.Decimal).Value = Convert.ToDecimal(e.NewValues["CashBank_AmountWithdrawl"].ToString());
            }
            if (e.NewValues["CashBank_AmountDeposit"] != null)
            {
                lcmd.Parameters.Add("@CashBank_AmountDeposit", SqlDbType.Decimal).Value = Convert.ToDecimal(e.NewValues["CashBank_AmountDeposit"].ToString());
            }

            int NoOfRowEffected = lcmd.ExecuteNonQuery();

            lcmd.Dispose();
            lcon.Close();
        }
        //private void BindData()
        //{


        //   // dsCashBankReport.SelectCommand = "select a.*,a.CashBank_MainAccountID as CashBank_MainAccountID , a.CashBank_SubAccountID as SubAccountID from dbo.Trans_CashBankVouchers as a ";
        //   // // grdCashbankReport.DataSource = dsCashBankReport;
        //   //grdCashbankReport.DataBind();


        //   grdCashbankReport.CancelEdit();
        //   grdCashbankReport.AddNewRow();

        //}


        protected void grdCashbankReport_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
        {


        }
        protected void grdCashbankReport_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {

        }
        protected void grdCashbankReport_RowCommand(object sender, ASPxGridViewRowCommandEventArgs e)
        {


        }
    }
}