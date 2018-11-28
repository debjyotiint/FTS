using System;
using System.Data;
using System.Web;
using System.Web.UI;
//using DevExpress.Web.ASPxClasses;
//using DevExpress.Web;
using DevExpress.Web;
using System.Configuration;

namespace ERP.OMS.Management
{
    public partial class management_sales_travelling : System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        public string pageAccess = "";

        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                string sPath = HttpContext.Current.Request.Url.ToString();
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            //------- For Read Only User in SQL Datasource Connection String   Start-----------------

            if (HttpContext.Current.Session["EntryProfileType"] != null)
            {
                if (Convert.ToString(HttpContext.Current.Session["EntryProfileType"]) == "R")
                {
                    SqlConveyence.ConnectionString = ConfigurationSettings.AppSettings["DBReadOnlyConnection"];
                }
                else
                {
                    SqlConveyence.ConnectionString = ConfigurationSettings.AppSettings["DBConnectionDefault"];
                }
            }

            //------- For Read Only User in SQL Datasource Connection String   End-----------------

            if (HttpContext.Current.Session["userid"] == null)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }

        }
        protected void GridConveyence_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            //string[,] interId = oDBEngine.GetFieldValue("tbl_trans_salesExpenditure", "top 1 expnd_internalId", " expnd_empId='" + Session["SalesVisitID"].ToString() + "' and expnd_convenceTravMode is null", 1);
            //if (interId[0, 0] != "n")
            //{
            //    Session["IID"] = interId[0, 0];
            //}
            //else
            //{
            //    Session["IID"] = "0";
            //}
        }
        protected void GridConveyence_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "expnd_TTravArea1")
            {
                if (e.KeyValue != null)
                {
                    object val = GridConveyence.GetRowValuesByKeyValue(e.KeyValue, "expnd_TTravCity1");
                    if (val == DBNull.Value) return;
                    int country = Convert.ToInt32(val);
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    FillStateCombo(combo, country);
                    combo.Callback += new CallbackEventHandlerBase(cmbState_OnCallback);
                }
                else
                {

                    object val = GridConveyence.GetRowValues(0, "expnd_TTravCity1");
                    if (val == DBNull.Value) return;
                    if (val != null)
                    {
                        int country = Convert.ToInt32(val);
                        ASPxComboBox combo = e.Editor as ASPxComboBox;
                        FillStateCombo(combo, country);
                        combo.Callback += new CallbackEventHandlerBase(cmbState_OnCallback);
                    }
                    else
                    {

                        int country = 1;
                        ASPxComboBox combo = e.Editor as ASPxComboBox;
                        FillStateCombo(combo, country);
                        combo.Callback += new CallbackEventHandlerBase(cmbState_OnCallback);
                    }
                }
            }
            if (e.Column.FieldName == "expnd_TTravArea2")
            {
                if (e.KeyValue != null)
                {
                    object val = GridConveyence.GetRowValuesByKeyValue(e.KeyValue, "expnd_TTravCity2");
                    if (val == DBNull.Value) return;
                    int country = Convert.ToInt32(val);
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    FillStateCombo1(combo, country);
                    combo.Callback += new CallbackEventHandlerBase(cmbState1_OnCallback);
                }
                else
                {

                    object val = GridConveyence.GetRowValues(0, "expnd_TTravCity2");
                    if (val == DBNull.Value) return;
                    if (val != null)
                    {
                        int country = Convert.ToInt32(val);
                        ASPxComboBox combo = e.Editor as ASPxComboBox;
                        FillStateCombo1(combo, country);
                        combo.Callback += new CallbackEventHandlerBase(cmbState1_OnCallback);
                    }
                    else
                    {

                        int country = 1;
                        ASPxComboBox combo = e.Editor as ASPxComboBox;
                        FillStateCombo1(combo, country);
                        combo.Callback += new CallbackEventHandlerBase(cmbState1_OnCallback);
                    }
                }
            }
        }
        protected void FillStateCombo(ASPxComboBox cmb, int country)
        {

            string[,] state = GetState(country);
            cmb.Items.Clear();

            for (int i = 0; i < state.GetLength(0); i++)
            {
                cmb.Items.Add(state[i, 1], state[i, 0]);
            }
        }
        string[,] GetState(int country)
        {
            areaSelect.SelectParameters[0].DefaultValue = country.ToString();
            DataView view = (DataView)areaSelect.Select(DataSourceSelectArguments.Empty);
            string[,] DATA = new string[view.Count, 2];
            for (int i = 0; i < view.Count; i++)
            {
                DATA[i, 0] = view[i][0].ToString();
                DATA[i, 1] = view[i][1].ToString();
            }
            return DATA;

        }
        protected void FillStateCombo1(ASPxComboBox cmb, int country)
        {

            string[,] state = GetState1(country);
            cmb.Items.Clear();

            for (int i = 0; i < state.GetLength(0); i++)
            {
                cmb.Items.Add(state[i, 1], state[i, 0]);
            }
        }
        string[,] GetState1(int country)
        {
            areaSelect1.SelectParameters[0].DefaultValue = country.ToString();
            DataView view = (DataView)areaSelect1.Select(DataSourceSelectArguments.Empty);
            string[,] DATA = new string[view.Count, 2];
            for (int i = 0; i < view.Count; i++)
            {
                DATA[i, 0] = view[i][0].ToString();
                DATA[i, 1] = view[i][1].ToString();
            }
            return DATA;

        }

        private void cmbState_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillStateCombo(source as ASPxComboBox, Convert.ToInt32(e.Parameter));
        }
        private void cmbState1_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillStateCombo1(source as ASPxComboBox, Convert.ToInt32(e.Parameter));
        }
    }
}