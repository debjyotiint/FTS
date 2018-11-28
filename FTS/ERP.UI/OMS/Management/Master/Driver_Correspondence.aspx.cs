﻿using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
////using DevExpress.Web.ASPxClasses;
//using DevExpress.Web;
using DevExpress.Web;
using BusinessLogicLayer;

namespace ERP.OMS.Management.Master
{
    public partial class Driver_Correspondence : ERP.OMS.ViewState_class.VSPage
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        BusinessLogicLayer.Company oRootCompaniesGeneralBL = new BusinessLogicLayer.Company();
        public EntityLayer.CommonELS.UserRightsForPage rights = new EntityLayer.CommonELS.UserRightsForPage();
        public string pageAccess = "";
      
        protected void Page_Load(object sender, EventArgs e)
        {
            string intid = Convert.ToString(Session["KeyVal_InternalID"]);
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/frm_drivers_master.aspx");


        }
        protected void AddressGrid_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "State")
            {
                if (e.KeyValue != null)
                {
                    object val = AddressGrid.GetRowValuesByKeyValue(e.KeyValue, "Country");
                    if (val == DBNull.Value) return;
                    int country = (int)val;
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    FillStateCombo(combo, country);
                    combo.Callback += new CallbackEventHandlerBase(cmbState_OnCallback);
                }
                else
                {
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    if (!AddressGrid.IsNewRowEditing)
                    {
                        object val = AddressGrid.GetRowValues(0, "Country");
                        if (val == DBNull.Value) return;
                        if (val != null)
                        {
                            int country = (int)val;

                            FillStateCombo(combo, country);

                        }
                        else
                        {

                            int country = 1;

                            FillStateCombo(combo, country);

                        }
                    }
                    combo.Callback += new CallbackEventHandlerBase(cmbState_OnCallback);
                }
            }
            ///////////////////
            if (e.Column.FieldName == "City")
            {
                if (e.KeyValue != null)
                {
                    object val = AddressGrid.GetRowValuesByKeyValue(e.KeyValue, "State");
                    if (val == DBNull.Value) return;
                    int state = (int)val;
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    FillCityCombo(combo, state);
                    combo.Callback += new CallbackEventHandlerBase(cmbCity_OnCallback);
                }
                else
                {
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    if (!AddressGrid.IsNewRowEditing)
                    {
                        object val = AddressGrid.GetRowValues(0, "State");
                        if (val == DBNull.Value) return;
                        if (val != null)
                        {
                            int state = (int)val;

                            FillCityCombo(combo, state);

                        }
                        else
                        {

                            int state = 1;
                            FillCityCombo(combo, state);

                        }
                    }
                    combo.Callback += new CallbackEventHandlerBase(cmbCity_OnCallback);

                }
            }
            if (e.Column.FieldName == "area")
            {
                if (e.KeyValue != null)
                {
                    object val = AddressGrid.GetRowValuesByKeyValue(e.KeyValue, "City");
                    if (val == DBNull.Value) return;
                    int city = (int)val;
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    FillAreaCombo(combo, city);
                    combo.Callback += new CallbackEventHandlerBase(cmbArea_OnCallback);
                }
                else
                {
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    if (!AddressGrid.IsNewRowEditing)
                    {
                        object val = AddressGrid.GetRowValues(0, "City");
                        if (val == DBNull.Value) return;
                        if (val != null)
                        {
                            int city = (int)val;
                            FillAreaCombo(combo, city);
                        }
                        else
                        {

                            int city = 1;
                            FillAreaCombo(combo, city);
                        }
                    }
                    combo.Callback += new CallbackEventHandlerBase(cmbArea_OnCallback);

                }
            }


            if (e.Column.FieldName == "PinCode")
            {
                if (e.KeyValue != null)
                {
                    object val = AddressGrid.GetRowValuesByKeyValue(e.KeyValue, "City");
                    if (val == DBNull.Value) return;
                    int city = (int)val;
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    FillPinCombo(combo, city);
                    combo.Callback += new CallbackEventHandlerBase(cmbPin_OnCallback);
                }
                else
                {
                    ASPxComboBox combo = e.Editor as ASPxComboBox;
                    if (!AddressGrid.IsNewRowEditing)
                    {
                        object val = AddressGrid.GetRowValues(0, "City");
                        if (val == DBNull.Value) return;
                        if (val != null)
                        {
                            int city = (int)val;
                            FillPinCombo(combo, city);

                        }
                        else
                        {
                            int city = 1;
                            FillPinCombo(combo, city);
                        }
                    }
                    combo.Callback += new CallbackEventHandlerBase(cmbPin_OnCallback);

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
            cmb.Items.Insert(0, new ListEditItem("Select", "0"));
        }

        string[,] GetState(int country)
        {
            StateSelect.SelectParameters[0].DefaultValue = country.ToString();
            DataView view = (DataView)StateSelect.Select(DataSourceSelectArguments.Empty);
            string[,] DATA = new string[view.Count, 2];
            for (int i = 0; i < view.Count; i++)
            {
                DATA[i, 0] = view[i][0].ToString();
                DATA[i, 1] = view[i][1].ToString();
            }
            return DATA;

        }


        protected void FillCityCombo(ASPxComboBox cmb, int state)
        {

            string[,] cities = GetCities(state);
            cmb.Items.Clear();

            for (int i = 0; i < cities.GetLength(0); i++)
            {
                cmb.Items.Add(cities[i, 1], cities[i, 0]);
            }
            cmb.Items.Insert(0, new ListEditItem("Select", "0"));
        }

        string[,] GetCities(int state)
        {


            SelectCity.SelectParameters[0].DefaultValue = state.ToString();
            DataView view = (DataView)SelectCity.Select(DataSourceSelectArguments.Empty);
            string[,] DATA = new string[view.Count, 2];
            for (int i = 0; i < view.Count; i++)
            {
                DATA[i, 0] = view[i][0].ToString();
                DATA[i, 1] = view[i][1].ToString();
            }
            return DATA;

        }
        protected void FillAreaCombo(ASPxComboBox cmb, int city)
        {
            string[,] area = GetArea(city);
            cmb.Items.Clear();

            for (int i = 0; i < area.GetLength(0); i++)
            {
                cmb.Items.Add(area[i, 1], area[i, 0]);
            }
            cmb.Items.Insert(0, new ListEditItem("Select", "0"));
        }
        string[,] GetArea(int city)
        {
            SelectArea.SelectParameters[0].DefaultValue = city.ToString();
            DataView view = (DataView)SelectArea.Select(DataSourceSelectArguments.Empty);
            string[,] DATA = new string[view.Count, 2];
            for (int i = 0; i < view.Count; i++)
            {
                DATA[i, 0] = view[i][0].ToString();
                DATA[i, 1] = view[i][1].ToString();
            }
            return DATA;
        }


        protected void FillPinCombo(ASPxComboBox cmb, int city)
        {
            string[,] pin = GetPin(city);
            cmb.Items.Clear();

            for (int i = 0; i < pin.GetLength(0); i++)
            {
                cmb.Items.Add(pin[i, 1], pin[i, 0]);
            }

        }

        string[,] GetPin(int city)
        {
            SelectPin.SelectParameters[0].DefaultValue = city.ToString();
            DataView view = (DataView)SelectPin.Select(DataSourceSelectArguments.Empty);
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
        private void cmbCity_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillCityCombo(source as ASPxComboBox, Convert.ToInt32(e.Parameter));
        }
        private void cmbArea_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillAreaCombo(source as ASPxComboBox, Convert.ToInt32(e.Parameter));
        }


        private void cmbPin_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillPinCombo(source as ASPxComboBox, Convert.ToInt32(e.Parameter));
        }


        protected void AddressGrid_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            string Address = e.NewValues["Type"].ToString();
            bool Isdefault = false;
            string countryid = "";
            string[,] countryname = null;

            foreach (GridViewColumn column in AddressGrid.Columns)
            {
                GridViewDataColumn dataColumn = column as GridViewDataColumn;
                if (dataColumn == null) continue;
               

                Isdefault = Convert.ToBoolean(e.NewValues["Isdefault"]);

            }



            if (e.IsNewRow)
            {
                DataTable dtadd = oDBEngine.GetDataTable("select add_addressType,Isdefault from tbl_master_address where add_cntid='" + Convert.ToString(HttpContext.Current.Session["KeyVal_InternalID"]) + "' and ISNULL(add_status,'Y')='Y'");


                for (int m = 0; m < dtadd.Rows.Count; m++)
                {
                    if (!Isdefault)
                    {
                        if (!(Address.Trim().Equals("Billing") || Address.Trim().Equals("FactoryWorkBranch")))
                        {
                            if (Convert.ToString(dtadd.Rows[m]["add_addressType"]) == Convert.ToString(Address))
                            {
                                //if (dtphone.Rows[m]["phf_status"].ToString() == status.ToString())
                                //{if (addtype == "Registered" || addtype == "Residence" || addtype == "Office")
                                if (Address == "Registered")
                                {
                                    e.RowError = "[ Registered/Permanent ] Address Type is Already Exist as 'Active'. Select another Address Type to proceed.";
                                }
                                else if (Address == "Residence")
                                {
                                    e.RowError = "[ " + Address + " ]" + " Address Type is Already Exist as 'Active'. Select another Address Type to proceed.";
                                }
                                else if (Address == "Office")
                                {
                                    e.RowError = "[ " + Address + " ]" + " Address Type is Already Exist as 'Active'. Select another Address Type to proceed.";
                                }



                                // .............................Code Commented and Added by Sam on 08122016 to use populate combobox while validation is false. ................


                                ASPxComboBox combostate = new ASPxComboBox();
                                int countryID = Convert.ToInt32(e.NewValues["Country"]);
                                FillStateCombo(combostate, countryID);

                                ASPxComboBox comcity = new ASPxComboBox();
                                int statid = Convert.ToInt32(e.NewValues["State"]);
                                FillCityCombo(comcity, statid);

                                ASPxComboBox compin = new ASPxComboBox();
                                int cityid = Convert.ToInt32(e.NewValues["City"]);
                                FillPinCombo(compin, cityid);

                                ASPxComboBox comarea = new ASPxComboBox();
                                int pinid = Convert.ToInt32(e.NewValues["PinCode"]);
                                FillAreaCombo(comarea, cityid);

                                // .............................Code Above Commented and Added by Sam on 08122016 to use init the combobox while validation false. ..................................... 

                                return;


                                // }
                            }
                        }

                    }
                    else if (!string.IsNullOrEmpty(Convert.ToString(dtadd.Rows[m]["Isdefault"])))
                    {
                        if (Convert.ToString(dtadd.Rows[m]["add_addressType"]) == Convert.ToString(Address) && Convert.ToBoolean(dtadd.Rows[m]["Isdefault"]) == Isdefault)
                        {
                            //if (dtphone.Rows[m]["phf_status"].ToString() == status.ToString())
                            //{if (addtype == "Registered" || addtype == "Residence" || addtype == "Office")
                            if (Address == "Registered")
                            {
                                e.RowError = "[ Registered/Permanent ] Address Type is Already set as 'Default'. Select another Address Type to proceed.";
                            }
                            else if (Address == "Residence")
                            {
                                e.RowError = "[ " + Address + " ]" + " Address Type is Already set as 'Default'. Select another Address Type to proceed.";
                            }
                            else if (Address == "Office")
                            {
                                e.RowError = "[ " + Address + " ]" + " Address Type is Already set as 'Default'. Select another Address Type to proceed.";
                            }
                            else if (Address == "Billing")
                            {
                                e.RowError = "[ " + Address + " ]" + " Address Type is Already set as 'Default'. Select another Address Type to proceed.";
                            }
                            else if (Address == "FactoryWorkBranch")
                            {
                                e.RowError = "[ " + Address + " ]" + " Address Type is Already set as 'Default'. Select another Address Type to proceed.";
                            }
                            else if (Address == "Shipping")
                            {
                                e.RowError = "[ " + Address + " ]" + " Address Type is Already set as 'Default'. Select another Address Type to proceed.";
                            }




                            // .............................Code Commented and Added by Sam on 08122016 to use populate combobox while validation is false. ................


                            ASPxComboBox combostate = new ASPxComboBox();
                            int countryID = Convert.ToInt32(e.NewValues["Country"]);
                            FillStateCombo(combostate, countryID);

                            ASPxComboBox comcity = new ASPxComboBox();
                            int statid = Convert.ToInt32(e.NewValues["State"]);
                            FillCityCombo(comcity, statid);

                            ASPxComboBox compin = new ASPxComboBox();
                            int cityid = Convert.ToInt32(e.NewValues["City"]);
                            FillPinCombo(compin, cityid);

                            ASPxComboBox comarea = new ASPxComboBox();
                            int pinid = Convert.ToInt32(e.NewValues["PinCode"]);
                            FillAreaCombo(comarea, cityid);

                            // .............................Code Above Commented and Added by Sam on 08122016 to use init the combobox while validation false. ..................................... 

                            return;


                            // }
                        }


                    }
                }




                 dtadd = oDBEngine.GetDataTable("select add_addressType from tbl_master_address where add_cntid='" + HttpContext.Current.Session["KeyVal_InternalID"].ToString() + "'");

                for (int m = 0; m < dtadd.Rows.Count; m++)
                {
                    if (dtadd.Rows[m]["add_addressType"].ToString() == Address.ToString())
                    {

                        e.RowError = "[ " + Address + " ]" + "Address Type is Already Exist";

                        ASPxComboBox combostate = new ASPxComboBox();
                        int countryID = Convert.ToInt32(e.NewValues["Country"]);
                        FillStateCombo(combostate, countryID);

                        ASPxComboBox comcity = new ASPxComboBox();
                        int statid = Convert.ToInt32(e.NewValues["State"]);
                        FillCityCombo(comcity, statid);

                        ASPxComboBox compin = new ASPxComboBox();
                        int cityid = Convert.ToInt32(e.NewValues["City"]);
                        FillPinCombo(compin, cityid);

                        ASPxComboBox comarea = new ASPxComboBox();
                        int pinid = Convert.ToInt32(e.NewValues["PinCode"]);
                        FillAreaCombo(comarea, cityid);
                        return;

                    }
                }


            }
            else
            {
                string addressold = e.OldValues["Type"].ToString();
                DataTable dtadd = oDBEngine.GetDataTable("select add_addressType from tbl_master_address where add_cntid='" + HttpContext.Current.Session["KeyVal_InternalID"].ToString() + "'");

                if (addressold != Address)
                {
                    for (int m = 0; m < dtadd.Rows.Count; m++)
                    {
                        if (dtadd.Rows[m]["add_addressType"].ToString() == Address.ToString())
                        {

                            e.RowError = "[ " + Address + " ]" + "Address Type is Already Exist";
                            return;

                        }
                    }
                }

            }
        }

        protected void EmailGrid_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            string emailtype = e.NewValues["eml_type"].ToString();

            string email = "";
            if (e.IsNewRow)
            {
                DataTable dtemail = oDBEngine.GetDataTable("select eml_type from tbl_master_email where eml_cntid='" + HttpContext.Current.Session["KeyVal_InternalID"].ToString() + "'");
                for (int m = 0; m < dtemail.Rows.Count; m++)
                {
                    if (dtemail.Rows[m]["eml_type"].ToString() == emailtype.ToString())
                    {
                        e.RowError = "Type is Already Exist";
                        return;
                    }
                }
            }
            string ccEmail = "";
            if (emailtype != "Web Site")
            {
                email = e.NewValues["eml_email"].ToString();
                try
                {
                    ccEmail = e.NewValues["eml_ccEmail"].ToString();
                }
                catch
                {
                }
            }
            else
                email = e.NewValues["eml_website"].ToString();
            string[,] emailCheck = oDBEngine.GetFieldValue("tbl_master_email", "eml_email", " eml_email='" + email + "'", 1);
            string email1 = "";
            if (emailCheck[0, 0] != "n")
            {
                email1 = emailCheck[0, 0];
            }
            string[,] ccEmailCheck = oDBEngine.GetFieldValue("tbl_master_email", "eml_ccEmail", " eml_ccEmail='" + ccEmail + "'", 1);
            string ccEmail1 = "";
            if (ccEmailCheck[0, 0] != "n")
            {
                ccEmail1 = ccEmailCheck[0, 0];
            }
            if (email1 == "" && ccEmail1 == "")
            {

            }

        }
        protected void AddressGrid_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
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
        protected void PhoneGrid_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
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
        protected void EmailGrid_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
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
        protected void PhoneGrid_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            DataTable dtEditphone = new DataTable();
            bool Isdefault = Convert.ToBoolean(e.NewValues["Isdefault"]);
            string PhoneType = e.NewValues["phf_type"].ToString();
            string phf_id = string.Empty;
            if (e.Keys.Count > 0)
            {
                phf_id = Convert.ToString(e.Keys[0]);
                dtEditphone = oDBEngine.GetDataTable("select phf_type from tbl_master_phonefax where phf_cntid='" + HttpContext.Current.Session["KeyVal_InternalID"].ToString() + "' and phf_id='" + phf_id + "'");
            }

            if (e.IsNewRow)
            {
                DataTable dtphonefax = oDBEngine.GetDataTable("select phf_Type,Isdefault from tbl_master_phonefax where phf_cntid='" + Convert.ToString(HttpContext.Current.Session["KeyVal_InternalID"]) + "' and ISNULL(phf_status,'Y')='Y'");

                for (int m = 0; m < dtphonefax.Rows.Count; m++)
                {
                    if (!Isdefault)
                    {
                        if (Convert.ToString(dtphonefax.Rows[m]["phf_type"]) == Convert.ToString(Address))
                        {
                            e.RowError = "[ " + Address + " ]" + "Phone Type is Already Exist";
                            return;
                        }
                    }
                    else if (!string.IsNullOrEmpty(Convert.ToString(dtphonefax.Rows[m]["Isdefault"])))
                    {

                        if (Convert.ToString(dtphonefax.Rows[m]["phf_type"]) == Convert.ToString(Address) && Convert.ToBoolean(dtphonefax.Rows[m]["Isdefault"]) == Isdefault)
                        {
                            e.RowError = "[ " + Address + " ]" + "Phone Type is Already set as default";
                            return;
                        }


                    }
                }
            }


            DataTable dtphone = oDBEngine.GetDataTable("select phf_type,isnull(phf_status,'Y') as phf_status from tbl_master_phonefax where phf_cntid='" + HttpContext.Current.Session["KeyVal_InternalID"].ToString() + "'");

            if (PhoneType == "Mobile")
            {
                string PhoneNumber = e.NewValues["phf_phoneNumber"].ToString();
                if (PhoneNumber.Length != 10)
                {
                    e.RowError = "Enter Valid Mobile Number";
                    return;
                }
            }
            if (string.IsNullOrEmpty(phf_id))//Add
            {
                for (int m = 0; m < dtphone.Rows.Count; m++)
                {
                    if (dtphone.Rows[m]["phf_type"].ToString() == PhoneType.ToString())
                    {

                        e.RowError = "Type is Already Exist";
                        return;

                    }
                }
            }
            else
            {
                for (int m = 0; m < dtphone.Rows.Count; m++)
                {
                    if (dtEditphone.Rows[0]["phf_type"].ToString() != PhoneType.ToString())
                    {
                        if (dtphone.Rows[m]["phf_type"].ToString() == PhoneType.ToString())
                        {

                            e.RowError = "Type is Already Exist";
                            return;

                        }
                    }
                }

            }
        }
        protected void AddressGrid_StartRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            AddressGrid.SettingsText.PopupEditFormCaption = "Modify Address";
        }
        protected void PhoneGrid_StartRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            PhoneGrid.SettingsText.PopupEditFormCaption = "Modify Phone";
        }
        protected void EmailGrid_StartRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            EmailGrid.SettingsText.PopupEditFormCaption = "Modify Email";
        }
    }
}