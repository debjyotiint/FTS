using System;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using BusinessLogicLayer;
using ClsDropDownlistNameSpace;
using EntityLayer.CommonELS;
using System.Web.Services;
using System.Collections.Generic;
using DataAccessLayer;
using System.Linq;

namespace ERP.OMS.Management.Master
{
    public partial class Customer_general : ERP.OMS.ViewState_class.VSPage//System.Web.UI.Page
    {
        Int32 ID;
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        clsDropDownList oclsDropDownList = new clsDropDownList();
        BusinessLogicLayer.Contact oContactGeneralBL = new BusinessLogicLayer.Contact();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();

        protected override void OnPreInit(EventArgs e)
        {
            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                oDBEngine.Call_CheckPageaccessebility(sPath);
                if (Request.QueryString["id"] == "ADD")
                {
                    //   DisabledTabPage();
                    base.OnPreInit(e);
                }
            }
        }
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            if (txtClentUcc.Text.ToString() != "")
            {
                //string prefx = txtFirstNmae.Text.ToString().Substring(0, 1).ToUpper();
                string prefx = txtClentUcc.Text.ToString();


                /* Tier Structure
                String con = ConfigurationSettings.AppSettings["DBConnectionDefault"];
                SqlConnection lcon = new SqlConnection(con);
                lcon.Open();
                SqlCommand lcmdEmplInsert = new SqlCommand("sp_GenerateContactUCC", lcon);
                lcmdEmplInsert.CommandType = CommandType.StoredProcedure;
                lcmdEmplInsert.Parameters.AddWithValue("@UCC", prefx);
                SqlParameter parameter = new SqlParameter("@result", SqlDbType.VarChar, 10);
                parameter.Direction = ParameterDirection.Output;
                lcmdEmplInsert.Parameters.Add(parameter);
                lcmdEmplInsert.ExecuteNonQuery();
                   string InternalID = parameter.Value.ToString();
                */

                string InternalID = oContactGeneralBL.Get_UCCCode(prefx);



                if (InternalID != "")
                {
                    txtClentUcc.Text = InternalID;
                }
                else
                {
                    lblErr.Text = "</br>No UCC found..Type another UCC.";
                    lblErr.Visible = true;
                }
            }
            else
            {
                //  ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct9", "<script>alert('Please Insert first name');</script>", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct9", "popup();", true);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dtbranch = new DataTable();
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/master/Customer_general.aspx");

             
            cmbContactStatusclient.Visible = false;
            txtContactStatusclient.Visible = false;

           
            this.Title = "Customer/Client";
            pnlCredit.Style.Add("display", "block");
            lblCreditcard.Visible = true;
            ChkCreditcard.Enabled = true;
            lblcreditDays.Visible = true;
            txtcreditDays.Enabled = true;
            lblCreditLimit.Visible = true;
            txtCreditLimit.Enabled = true;
            cmbContactStatusclient.Visible = true;
            txtContactStatusclient.Visible = true;
                
           

            if (!IsPostBack)
            {
                table_others.Visible = true;
                cmbContactStatus.Attributes.Add("onchange", "javascript:ContactStatus()");
                DDLBind();

                //For Udf data
                if (Request.QueryString["InternalId"] != null)
                {
                    BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                    DataTable DT = objEngine.GetDataTable("tbl_master_contact", "*,isnull(cnt_IdType,0) Cust_IdType", "cnt_internalId = '" + Convert.ToString(Request.QueryString["InternalId"]) + "'");
                    if (DT != null && DT.Rows.Count > 0)
                    {
                        KeyVal_InternalID.Value = Convert.ToString(DT.Rows[0]["cnt_internalId"]);
                        hdCustomerName.Value = Convert.ToString(DT.Rows[0]["cnt_firstName"]);
                        cmbLegalStatus.SelectedValue = Convert.ToString(DT.Rows[0]["cnt_legalStatus"]);
                        txtClentUcc.Text = Convert.ToString(DT.Rows[0]["cnt_UCC"]);
                        HdCustUniqueName.Value = Convert.ToString(DT.Rows[0]["cnt_UCC"]);
                        txtClentUcc.Enabled = false;
                        txtFirstNmae.Text = Convert.ToString(DT.Rows[0]["cnt_firstName"]);
                        txtDOB.Value = Convert.ToDateTime(DT.Rows[0]["cnt_dOB"]);
                        ddlnational.SelectedValue = Convert.ToString(DT.Rows[0]["cnt_branchId"]);
                        txtAnniversary.Value = Convert.ToDateTime(DT.Rows[0]["cnt_anniversaryDate"]);
                        cmbGender.SelectedValue = Convert.ToString(DT.Rows[0]["cnt_sex"]);
                        ChkCreditcard.Value = Convert.ToBoolean(DT.Rows[0]["cnt_IsCreditHold"]);
                        txtcreditDays.Text = Convert.ToString(DT.Rows[0]["cnt_CreditDays"]);
                        txtCreditLimit.Text = Convert.ToString(DT.Rows[0]["cnt_CreditLimit"]);
                        cmbMaritalStatus.SelectedValue = Convert.ToString(DT.Rows[0]["cnt_maritalStatus"]);
                        cmbContactStatusclient.Value = Convert.ToString(DT.Rows[0]["Statustype"]);
                        lstTaxRates_MainAccount.SelectedValue = Convert.ToString(DT.Rows[0]["cnt_mainAccount"]);
                        string GSTIN = Convert.ToString(DT.Rows[0]["CNT_GSTIN"]);
                        
                        if (GSTIN != "")
                        {
                            txtGSTIN1.Text = GSTIN.Substring(0, 2);
                            txtGSTIN2.Text = GSTIN.Substring(2, 10);
                            txtGSTIN3.Text = GSTIN.Substring(12, 3);
                        }
                        else
                        {
                            txtGSTIN1.Text = "";
                            txtGSTIN2.Text = "";
                            txtGSTIN3.Text = "";
                        }
                        ddlIdType.SelectedValue = Convert.ToString(DT.Rows[0]["Cust_IdType"]);
                        
                        TabPage page = ASPxPageControl1.TabPages.FindByName("Correspondence");
                        page.Visible = true;
                    }
                    ddlIdType.Enabled = false;
                }
                else
                {
                    KeyVal_InternalID.Value = "";
                    cmbLegalStatus.SelectedIndex.Equals(0);
                    txtClentUcc.Enabled = true;
                    txtClentUcc.Text = "";
                    txtFirstNmae.Text = "";
                    txtMiddleName.Text = "";
                    txtDOB.Value = "";
                    ddlnational.ClearSelection();
                    ddlnational.Items.FindByValue("78").Selected = true;
                    txtAnniversary.Value = "";
                    cmbGender.SelectedIndex.Equals(0);
                    ChkCreditcard.Value = false;
                    txtcreditDays.Text = "";
                    txtCreditLimit.Text = "";
                    cmbMaritalStatus.SelectedIndex.Equals(0);
                    cmbContactStatusclient.SelectedIndex.Equals(0);
                    lstTaxRates_MainAccount.SelectedIndex.Equals(0);
                    txtGSTIN1.Text = "";
                    txtGSTIN2.Text = "";
                    txtGSTIN3.Text = "";
                    TabPage page = ASPxPageControl1.TabPages.FindByName("Correspondence");
                    page.Visible = false;
                }
            }
          //  SetUdfApplicableValue();

        }
        protected void SetUdfApplicableValue()
        {
            hdKeyVal.Value = "Cus";
            //Debjyoti 30-12-2016
            //Reason: UDF count
            IsUdfpresent.Value = Convert.ToString(getUdfCount());
            //End Debjyoti 30-12-2016
        }
        protected int getUdfCount()
        {
            DataTable udfCount = oDBEngine.GetDataTable("select 1 from tbl_master_remarksCategory rc where cat_applicablefor='" + hdKeyVal.Value + "'  and ( exists (select * from tbl_master_udfGroup where id=rc.cat_group_id and grp_isVisible=1) or rc.cat_group_id=0)");
            return udfCount.Rows.Count;
        }
        public void DDLBind()
        {
            DataSet DDDs = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_CustomerPopup");
            proc.AddVarcharPara("@Action", 500, "GetDropDownValue");
            DDDs = proc.GetDataSet();
            
            cmbMaritalStatus.DataSource = DDDs.Tables[0];
            cmbMaritalStatus.DataValueField = "mts_id";
            cmbMaritalStatus.DataTextField = "mts_maritalStatus";

            cmbLegalStatus.DataSource = DDDs.Tables[1];
            cmbLegalStatus.DataValueField = "lgl_id";
            cmbLegalStatus.DataTextField = "lgl_legalStatus";

            ddlnational.DataSource = DDDs.Tables[2];
            ddlnational.DataValueField = "Nationality_id";
            ddlnational.DataTextField = "Nationality_Description";
 
            cmbContactStatus.Items.Add("1");

            cmbMaritalStatus.DataBind();
            cmbLegalStatus.DataBind();
            ddlnational.DataBind();

            cmbLegalStatus.SelectedValue = "1";
            cmbContactStatus.SelectedValue = "0";
            cmbMaritalStatus.Items.Insert(0, new ListItem("--Select--", "0"));

             
           
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string dd = "Customer/Client";
            DateTime dtDob, dtanniversary, dtReg, dtBusiness;
            string country = ddlnational.SelectedValue;
            string GSTIN = "";
            GSTIN = txtGSTIN1.Text.Trim() + txtGSTIN2.Text.Trim() + txtGSTIN3.Text.Trim();

            if (txtDOB.Value != null)
            {
                dtDob = Convert.ToDateTime(txtDOB.Value);
            }
            else
            {
                dtDob = Convert.ToDateTime("01-01-1900");
            }

            if (txtAnniversary.Value != null)
            {
                dtanniversary = Convert.ToDateTime(txtAnniversary.Value);
            }
            else
            {
                dtanniversary = Convert.ToDateTime("01-01-1900");
            }
            Boolean Creditcard;
            if (ChkCreditcard.Checked)
            {
                Creditcard = true;
            }
            else
            {
                Creditcard = false;
            }
            int creditDays = 0;
            if (txtcreditDays.Text.Trim() != "")
            {
                creditDays = Convert.ToInt32(txtcreditDays.Text.Trim());
            }
            decimal CreditLimit = 0;
            if (txtCreditLimit.Text.Trim() != "")
            {
                CreditLimit = Convert.ToDecimal(txtCreditLimit.Text.Trim());
            }

            if (KeyVal_InternalID.Value == "")
            {
                string InternalId = oContactGeneralBL.Insert_ContactGeneral(dd, txtClentUcc.Text.Trim(), "1",
                                                      txtFirstNmae.Text.Trim(), txtMiddleName.Text.Trim(), "",
                                                      "", Convert.ToString(Session["userbranchID"]), cmbGender.SelectedItem.Value,
                                                      cmbMaritalStatus.SelectedItem.Value, dtDob, dtanniversary, cmbLegalStatus.SelectedItem.Value,
                                                      "1", "1", "",
                                                      "0", "0", "0",
                                                      "1", "", "", "CL",
                                                      cmbContactStatus.SelectedItem.Value, DateTime.Now, "1", "",
                                                      "1", "No", "", Convert.ToString(HttpContext.Current.Session["userid"]), "",
                                                      DateTime.Now, "", country, Creditcard, creditDays,
                                                      CreditLimit, Convert.ToString(cmbContactStatusclient.SelectedItem.Value),
                                                      GSTIN, hidAssociatedEmp.Value);
                KeyVal_InternalID.Value = InternalId;
                hdCustomerName.Value = txtFirstNmae.Text.Trim();
                HdCustUniqueName.Value = txtClentUcc.Text.Trim();
                txtClentUcc.Enabled = false;
                oDBEngine.SetFieldValue("tbl_master_contact", "cnt_IdType=" + ddlIdType.SelectedValue , " cnt_internalId='" + InternalId + "'");
                UpdateUniqueId(InternalId, Convert.ToInt32(ddlIdType.SelectedValue), txtClentUcc.Text.Trim());
                ddlIdType.Enabled = false;
                TabPage page = ASPxPageControl1.TabPages.FindByName("Correspondence");
                page.Visible = true;
                Page.ClientScript.RegisterStartupScript(GetType(), "JScript", "<script>jAlert('Saved Succesfully.')</script>");
            }
            else
            {
                txtClentUcc.Enabled = false;
                string value = "Statustype='',cnt_ucc='" + txtClentUcc.Text + "', cnt_salutation=1,  cnt_firstName='" + txtFirstNmae.Text + "', cnt_middleName='" + txtMiddleName.Text + "', cnt_lastName='', cnt_shortName='', cnt_branchId=" + Convert.ToInt32(Session["userbranchID"]) + ", cnt_sex=" + cmbGender.SelectedItem.Value + ", cnt_maritalStatus=" + cmbMaritalStatus.SelectedItem.Value + ", cnt_DOB='" + txtDOB.Value + "', cnt_anniversaryDate='" + txtAnniversary.Value + "', cnt_legalStatus=" + cmbLegalStatus.SelectedItem.Value + ", cnt_education=0, cnt_profession=0, cnt_organization='0', cnt_jobResponsibility=0, cnt_designation=0, cnt_industry=0, cnt_contactSource=0, cnt_referedBy='0', cnt_contactType='CL', cnt_contactStatus=" + cmbContactStatus.SelectedItem.Value + ",cnt_RegistrationDate='" + DateTime.Now.ToShortDateString() + "',cnt_rating='0',cnt_reason='0',cnt_bloodgroup='0',WebLogIn='No',PassWord='', lastModifyDate ='" + DateTime.Now.ToShortDateString() + "',cnt_PlaceOfIncorporation='0',cnt_nationality='" + Convert.ToInt32(Convert.ToString(country)) + "',cnt_BusinessComncDate='" + DateTime.Now.ToShortDateString() + "',cnt_OtherOccupation='',cnt_IsCreditHold='" + Creditcard + "',cnt_CreditDays='" + creditDays + "' ,cnt_CreditLimit='" + CreditLimit + "', lastModifyUser=" + HttpContext.Current.Session["userid"] + ",CNT_GSTIN='" + GSTIN + "',cnt_AssociatedEmp= '" + hidAssociatedEmp.Value + "',cnt_mainAccount='" + hndTaxRates_MainAccount_hidden.Value + "'";
                oDBEngine.SetFieldValue("tbl_master_contact", value, "cnt_internalId = '" + KeyVal_InternalID.Value + "'");
               
                Page.ClientScript.RegisterStartupScript(GetType(), "JScript", "<script>jAlert('Updated Succesfully.')</script>");
            }
        }


        protected static void UpdateUniqueId(string internalId,int contactType,string uniqueID)
        {
            ProcedureExecute proc = new ProcedureExecute("prc_SetCustomerUniqueIdToCorrespondence");
            proc.AddVarcharPara("@cnt_internalId", 10, internalId);
            proc.AddIntegerPara("@cnt_IdType", contactType);
            proc.AddVarcharPara("@uniqueId", 80, uniqueID);
            proc.RunActionQuery();
        
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["formtype"] != null)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "JScript4", "<script>parent.editwin.close();</script>");
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "JScript2", "<script>parent.editwin.close();</script>");
            }
        }
        protected void ASPxPageControl1_ActiveTabChanged(object source, TabControlEventArgs e)
        {
        }
        [WebMethod]
        public static string CheckUniqueName(string clientName, string procode)
        {
            MShortNameCheckingBL mshort = new MShortNameCheckingBL();
            bool IsPresent = false;
            string ContType = "CL";
            string entityName = "";
            if (procode == "0")
            {
                IsPresent = mshort.CheckUniqueWithtypeContactMaster(clientName, procode, "MasterContactType", ContType,ref entityName);
            }
            else
            {
                IsPresent = mshort.CheckUniqueWithtypeContactMaster(clientName, procode, "Mastercustomerclient", ContType,ref entityName);
            }


            return Convert.ToString(IsPresent) + "~" + entityName;
        }
        [WebMethod]
        public static List<string> GetMainAccountList(string reqStr)
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
            DataTable DT = new DataTable();
            DT.Rows.Clear();
            // DT = oDBEngine.GetDataTable("Master_MainAccount", "MainAccount_Name,MainAccount_AccountCode ", " MainAccount_Name like '" + reqStr + "%'");

            // DT = oDBEngine.GetDataTable("Master_MainAccount", "MainAccount_Name, MainAccount_AccountCode ", " MainAccount_AccountCode not like 'SYS%'");
            ProcedureExecute proc = new ProcedureExecute("prc_ProductMaster_bindData");
            proc.AddVarcharPara("@action", 20, "GetMainAccount");
            DT = proc.GetTable();

            List<string> obj = new List<string>();
            foreach (DataRow dr in DT.Rows)
            {

                obj.Add(Convert.ToString(dr["MainAccount_Name"]) + "|" + Convert.ToString(dr["MainAccount_AccountCode"]));
            }
            return obj;
        }
        [WebMethod]
        public static List<string> GetrefBy(string query)
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
            DataTable DT = new DataTable();
            DT.Rows.Clear();
            DT = oDBEngine.GetDataTable(query);
            List<string> obj = new List<string>();
            foreach (DataRow dr in DT.Rows)
            {

                obj.Add(Convert.ToString(dr["cnt_firstName"]) + "|" + Convert.ToString(dr["cnt_internalid"]));
            }
            return obj;

        }



        #region NewCustomer web method



        [WebMethod]
        public static object GetAddressdetails(string pinCode)
        {
            if (pinCode.Trim() != "")
            {

                DataTable fetchTable = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_GetSetCustomerPopup");
                proc.AddVarcharPara("@action", 500, "GETPINDETAILS");
                proc.AddVarcharPara("@pin", 6, pinCode);
                fetchTable = proc.GetTable();


                if (fetchTable.Rows.Count > 0)
                {
                    string country, state, city;
                    country = Convert.ToString(fetchTable.Rows[0]["cou_country"]);
                    state = Convert.ToString(fetchTable.Rows[0]["state"]);
                    city = Convert.ToString(fetchTable.Rows[0]["city_name"]);
                    string rreturnString = country + "||" + state + "||" + city;

                    var storiesObj = new { status = "Ok", Country = country, state = state, city = city };
                    return storiesObj;

                }
            }
            var storiesObj1 = new { status = "Not Found" };
            return storiesObj1;
        }

        [WebMethod]
        public static object GetAddressdetailsForNewBillShipp(string pinCode)
        {
            if (pinCode.Trim() != "")
            {

                DataTable fetchTable = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_GetSetCustomerPopup");
                proc.AddVarcharPara("@action", 500, "GetPinDetailsForBillShipp");
                proc.AddVarcharPara("@pin", 6, pinCode);
                fetchTable = proc.GetTable();


                if (fetchTable.Rows.Count > 0)
                {
                    string country, state, city,country_id,state_Id,city_id;
                    country = Convert.ToString(fetchTable.Rows[0]["cou_country"]);
                    state = Convert.ToString(fetchTable.Rows[0]["state"]);
                    city = Convert.ToString(fetchTable.Rows[0]["city_name"]);
                    country_id = Convert.ToString(fetchTable.Rows[0]["cou_id"]);
                    state_Id = Convert.ToString(fetchTable.Rows[0]["id"]);
                    city_id = Convert.ToString(fetchTable.Rows[0]["city_id"]);
                    string rreturnString = country + "||" + state + "||" + city + "||" + country_id + "||" + state_Id + "||" + city_id;

                    var storiesObj = new { status = "Ok", Country = country, state = state, city = city, Cou_id = country_id, state_id = state_Id, City_Id = city_id };
                    return storiesObj;

                }
            }
            var storiesObj1 = new { status = "Not Found" };
            return storiesObj1;
        }

        [WebMethod]
        public static object CheckuniqueId(string uniqueId)
        {
            MShortNameCheckingBL mshort = new MShortNameCheckingBL();
            bool IsPresent = false;
            string entityName = "";
            IsPresent = mshort.CheckUniqueWithtypeContactMaster(uniqueId, "", "MasterContactType", "CL", ref entityName);
            return new { IsPresent = IsPresent, entityName = entityName };
        }

        [WebMethod]
        public static object SaveCustomer(string UniqueID, string Name, string BillingAddress1, string BillingAddress2, string BillingPin, string shippingAddress1, string shippingAddress2, string shippingPin, string GSTIN, string BillingPhone, string ShippingPhone, string contactperson)
        {
            BusinessLogicLayer.Contact oContactGeneralBL = new BusinessLogicLayer.Contact();
            MShortNameCheckingBL mshort = new MShortNameCheckingBL();
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);


            try
            {
                string entityName = "";
                if (!mshort.CheckUniqueWithtypeContactMaster(UniqueID, "", "MasterContactType", "CL", ref entityName))
                {
                    string InternalId = oContactGeneralBL.Insert_ContactGeneral("Customer/Client", UniqueID, "1",
                                                        Name, "", "",
                                                        "", Convert.ToString(HttpContext.Current.Session["userbranchID"]), "2",
                                                        "0", new DateTime(1900, 1, 1, 0, 0, 0, 0), new DateTime(1900, 1, 1, 0, 0, 0, 0), "1",
                                                        "1", "1", "",
                                                        "0", "0", "0",
                                                        "1", "", "", "CL",
                                                        "1", DateTime.Now, "1", "",
                                                        "1", "No", "", Convert.ToString(HttpContext.Current.Session["userid"]), "",
                                                        DateTime.Now, "", "78", false, 0,
                                                        0, "A",
                                                        "", "");

                    ProcedureExecute proc = new ProcedureExecute("prc_GetSetCustomerPopup");
                    proc.AddVarcharPara("@action", 500, "SaveBillingShipping");
                    proc.AddVarcharPara("@pin", 10, BillingPin);
                    proc.AddVarcharPara("@billingAddress1", 100, BillingAddress1);
                    proc.AddVarcharPara("@billingAddress2", 100, BillingAddress2);
                    proc.AddVarcharPara("@shippingpin", 10, shippingPin);
                    proc.AddVarcharPara("@shippingbillingAddress1", 100, shippingAddress1);
                    proc.AddVarcharPara("@shippingbillingAddress2", 100, shippingAddress2);
                    proc.AddVarcharPara("@customerInternalId", 10, InternalId);
                    proc.AddVarcharPara("@cntUcc", 50, UniqueID);
                    proc.AddVarcharPara("@GSTIN", 20, GSTIN);
                    proc.AddVarcharPara("@BillingPhone", 20, BillingPhone);
                    proc.AddVarcharPara("@ShippingPhone", 20, ShippingPhone);
                    proc.AddVarcharPara("@contactperson", 40, contactperson);

                    proc.AddIntegerNullPara("@BillCountry",QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@BillState",QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@BillCity",QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@Billpin",QueryParameterDirection.Output);
                    
                     proc.AddIntegerNullPara("@ShipCountry",QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@ShipState",QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@ShipCity",QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@Shippin",QueryParameterDirection.Output);


                    proc.RunActionQuery();

                     

                    int billCountry = Convert.ToInt32(proc.GetParaValue("@BillCountry"));
                    int billState = Convert.ToInt32(proc.GetParaValue("@BillState"));
                    int billcity = Convert.ToInt32(proc.GetParaValue("@BillCity"));
                    int billpin = Convert.ToInt32(proc.GetParaValue("@Billpin"));


                    int ShipCountry = Convert.ToInt32(proc.GetParaValue("@ShipCountry"));
                    int ShipState = Convert.ToInt32(proc.GetParaValue("@ShipState"));
                    int  Shipcity = Convert.ToInt32(proc.GetParaValue("@ShipCity"));
                    int Shippin = Convert.ToInt32(proc.GetParaValue("@Shippin"));

                    //Billig Details
                    DataTable AddressDetaildt = new DataTable();

                    AddressDetaildt.Columns.Add("QuoteAdd_QuoteId", typeof(System.Int32));
                    AddressDetaildt.Columns.Add("QuoteAdd_CompanyID", typeof(System.String));
                    AddressDetaildt.Columns.Add("QuoteAdd_BranchId", typeof(System.Int32));
                    AddressDetaildt.Columns.Add("QuoteAdd_FinYear", typeof(System.String));

                    AddressDetaildt.Columns.Add("QuoteAdd_ContactPerson", typeof(System.String));
                    AddressDetaildt.Columns.Add("QuoteAdd_addressType", typeof(System.String));
                    AddressDetaildt.Columns.Add("QuoteAdd_address1", typeof(System.String));
                    AddressDetaildt.Columns.Add("QuoteAdd_address2", typeof(System.String));
                    AddressDetaildt.Columns.Add("QuoteAdd_address3", typeof(System.String));


                    AddressDetaildt.Columns.Add("QuoteAdd_landMark", typeof(System.String));
                    AddressDetaildt.Columns.Add("QuoteAdd_countryId", typeof(System.Int32));
                    AddressDetaildt.Columns.Add("QuoteAdd_stateId", typeof(System.Int32));
                    AddressDetaildt.Columns.Add("QuoteAdd_cityId", typeof(System.Int32));
                    AddressDetaildt.Columns.Add("QuoteAdd_areaId", typeof(System.Int32));


                    AddressDetaildt.Columns.Add("QuoteAdd_pin", typeof(System.String));
                    AddressDetaildt.Columns.Add("QuoteAdd_CreatedDate", typeof(System.DateTime));
                    AddressDetaildt.Columns.Add("QuoteAdd_CreatedUser", typeof(System.Int32));
                    AddressDetaildt.Columns.Add("QuoteAdd_LastModifyDate", typeof(System.DateTime));
                    AddressDetaildt.Columns.Add("QuoteAdd_LastModifyUser", typeof(System.Int32));

                    DataRow addressRow = AddressDetaildt.NewRow();

                    addressRow["QuoteAdd_QuoteId"] = 0;
                    addressRow["QuoteAdd_CompanyID"] =  Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    addressRow["QuoteAdd_BranchId"] = Convert.ToString(HttpContext.Current.Session["userbranchID"]);
                    addressRow["QuoteAdd_FinYear"] = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);
                    addressRow["QuoteAdd_ContactPerson"] = "";
                    addressRow["QuoteAdd_addressType"] = "Billing";
                    addressRow["QuoteAdd_address1"] = BillingAddress1;
                    addressRow["QuoteAdd_address2"] = BillingAddress2;
                    addressRow["QuoteAdd_address3"] = ""; 
                    addressRow["QuoteAdd_landMark"] = "";

                    addressRow["QuoteAdd_countryId"] = billCountry;
                    addressRow["QuoteAdd_stateId"] = billState;
                    addressRow["QuoteAdd_cityId"] = billcity;
                    addressRow["QuoteAdd_areaId"] = 0;
                    addressRow["QuoteAdd_pin"] = billpin;
                    addressRow["QuoteAdd_CreatedDate"] = DateTime.Now;
                    addressRow["QuoteAdd_CreatedUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    addressRow["QuoteAdd_LastModifyDate"] =DateTime.Now;
                    addressRow["QuoteAdd_LastModifyUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    AddressDetaildt.Rows.Add(addressRow);



                    addressRow = AddressDetaildt.NewRow(); 
                    addressRow["QuoteAdd_QuoteId"] = 0;
                    addressRow["QuoteAdd_CompanyID"] = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    addressRow["QuoteAdd_BranchId"] = Convert.ToString(HttpContext.Current.Session["userbranchID"]);
                    addressRow["QuoteAdd_FinYear"] = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);
                    addressRow["QuoteAdd_ContactPerson"] = "";
                    addressRow["QuoteAdd_addressType"] = "Shipping";
                    addressRow["QuoteAdd_address1"] = shippingAddress1;
                    addressRow["QuoteAdd_address2"] = shippingAddress2;
                    addressRow["QuoteAdd_address3"] = "";
                    addressRow["QuoteAdd_landMark"] = "";

                    addressRow["QuoteAdd_countryId"] = ShipCountry;
                    addressRow["QuoteAdd_stateId"] = ShipState;
                    addressRow["QuoteAdd_cityId"] = Shipcity;
                    addressRow["QuoteAdd_areaId"] = 0;
                    addressRow["QuoteAdd_pin"] = Shippin;
                    addressRow["QuoteAdd_CreatedDate"] = DateTime.Now;
                    addressRow["QuoteAdd_CreatedUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    addressRow["QuoteAdd_LastModifyDate"] = DateTime.Now;
                    addressRow["QuoteAdd_LastModifyUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    AddressDetaildt.Rows.Add(addressRow);
                    HttpContext.Current.Session["SI_QuotationAddressDtl"] = AddressDetaildt;

                    DataTable StateDetails = oDBEngine.GetDataTable("select state+' (State Code:'+StateCode+')' stateText,id   from tbl_master_state where id=" + billState + " union all select state+' (State Code:'+StateCode+')' stateText,id   from tbl_master_state where id=" + ShipState);
                    string BillingStateText = "", BillingStateCode = "", ShippingStateText = "", ShippingStateCode = "";
                    if (StateDetails.Rows.Count > 0)
                    {
                        BillingStateText =Convert.ToString( StateDetails.Rows[0]["stateText"]);
                        BillingStateCode = Convert.ToString(StateDetails.Rows[0]["id"]);

                        ShippingStateText = Convert.ToString(StateDetails.Rows[1]["stateText"]);
                        ShippingStateCode = Convert.ToString(StateDetails.Rows[1]["id"]);
                    }


                    return new { status = "Ok", InternalId = InternalId, BillingStateText = BillingStateText, BillingStateCode = BillingStateCode, ShippingStateText = ShippingStateText, ShippingStateCode = ShippingStateCode };
                }
                else {
                    return new { status = "Error", Msg = "Already Exists" };
                }
            }
            catch (Exception ex)
            {
                return new { status = "Error", Msg = ex.Message };
            }
        }

        [WebMethod]
        public static object SaveCustomerMaster(string UniqueID, string Name, string BillingAddress1, string BillingAddress2, string BillingPin, string shippingAddress1, string shippingAddress2, string shippingPin, string GSTIN, string BillingPhone, string ShippingPhone, string contactperson, string IdTypeval)
        {
            BusinessLogicLayer.Contact oContactGeneralBL = new BusinessLogicLayer.Contact();
            MShortNameCheckingBL mshort = new MShortNameCheckingBL();
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);


            try
            {
                string entityName = "";
                if (!mshort.CheckUniqueWithtypeContactMaster(UniqueID, "", "MasterContactType", "CL", ref entityName))
                {
                    string InternalId = oContactGeneralBL.Insert_ContactGeneral("Customer/Client", UniqueID, "1",
                                                        Name, "", "",
                                                        "", Convert.ToString(HttpContext.Current.Session["userbranchID"]), "2",
                                                        "0", new DateTime(1900, 1, 1, 0, 0, 0, 0), new DateTime(1900, 1, 1, 0, 0, 0, 0), "1",
                                                        "1", "1", "",
                                                        "0", "0", "0",
                                                        "1", "", "", "CL",
                                                        "1", DateTime.Now, "1", "",
                                                        "1", "No", "", Convert.ToString(HttpContext.Current.Session["userid"]), "",
                                                        DateTime.Now, "", "78", false, 0,
                                                        0, "A",
                                                        "", "");


                   // oDBEngine.SetFieldValue("tbl_master_contact", "cnt_IdType=" + IdTypeval, " cnt_internalId='" + InternalId + "'");
                  //  UpdateUniqueId(InternalId, Convert.ToInt32(IdTypeval), UniqueID);

                    ProcedureExecute proc = new ProcedureExecute("prc_GetSetCustomerPopup_Lightwet");
                    proc.AddVarcharPara("@action", 500, "SaveBillingShipping");
                    proc.AddVarcharPara("@pin", 10, BillingPin);
                    proc.AddVarcharPara("@billingAddress1", 100, BillingAddress1);
                    proc.AddVarcharPara("@billingAddress2", 100, BillingAddress2);
                    proc.AddVarcharPara("@shippingpin", 10, shippingPin);
                    proc.AddVarcharPara("@shippingbillingAddress1", 100, shippingAddress1);
                    proc.AddVarcharPara("@shippingbillingAddress2", 100, shippingAddress2);
                    proc.AddVarcharPara("@customerInternalId", 10, InternalId);
                    proc.AddVarcharPara("@cntUcc", 50, UniqueID);
                    proc.AddVarcharPara("@GSTIN", 20, GSTIN);
                    proc.AddVarcharPara("@BillingPhone", 20, BillingPhone);
                    proc.AddVarcharPara("@ShippingPhone", 20, ShippingPhone);
                    proc.AddVarcharPara("@contactperson", 40, contactperson);

                     proc.AddIntegerPara("@cnt_IdType", Convert.ToInt32(IdTypeval));

                    proc.AddIntegerNullPara("@BillCountry", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@BillState", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@BillCity", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@Billpin", QueryParameterDirection.Output);

                    proc.AddIntegerNullPara("@ShipCountry", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@ShipState", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@ShipCity", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@Shippin", QueryParameterDirection.Output);


                    proc.RunActionQuery();



                    int billCountry = Convert.ToInt32(proc.GetParaValue("@BillCountry"));
                    int billState = Convert.ToInt32(proc.GetParaValue("@BillState"));
                    int billcity = Convert.ToInt32(proc.GetParaValue("@BillCity"));
                    int billpin = Convert.ToInt32(proc.GetParaValue("@Billpin"));


                    int ShipCountry = Convert.ToInt32(proc.GetParaValue("@ShipCountry"));
                    int ShipState = Convert.ToInt32(proc.GetParaValue("@ShipState"));
                    int Shipcity = Convert.ToInt32(proc.GetParaValue("@ShipCity"));
                    int Shippin = Convert.ToInt32(proc.GetParaValue("@Shippin"));

                    //Billig Details
                    //DataTable AddressDetaildt = new DataTable();

                    //AddressDetaildt.Columns.Add("QuoteAdd_QuoteId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_CompanyID", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_BranchId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_FinYear", typeof(System.String));

                    //AddressDetaildt.Columns.Add("QuoteAdd_ContactPerson", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_addressType", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_address1", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_address2", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_address3", typeof(System.String));


                    //AddressDetaildt.Columns.Add("QuoteAdd_landMark", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_countryId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_stateId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_cityId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_areaId", typeof(System.Int32));


                    //AddressDetaildt.Columns.Add("QuoteAdd_pin", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_CreatedDate", typeof(System.DateTime));
                    //AddressDetaildt.Columns.Add("QuoteAdd_CreatedUser", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_LastModifyDate", typeof(System.DateTime));
                    //AddressDetaildt.Columns.Add("QuoteAdd_LastModifyUser", typeof(System.Int32));

                    //DataRow addressRow = AddressDetaildt.NewRow();

                    //addressRow["QuoteAdd_QuoteId"] = 0;
                    //addressRow["QuoteAdd_CompanyID"] = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    //addressRow["QuoteAdd_BranchId"] = Convert.ToString(HttpContext.Current.Session["userbranchID"]);
                    //addressRow["QuoteAdd_FinYear"] = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);
                    //addressRow["QuoteAdd_ContactPerson"] = "";
                    //addressRow["QuoteAdd_addressType"] = "Billing";
                    //addressRow["QuoteAdd_address1"] = BillingAddress1;
                    //addressRow["QuoteAdd_address2"] = BillingAddress2;
                    //addressRow["QuoteAdd_address3"] = "";
                    //addressRow["QuoteAdd_landMark"] = "";

                    //addressRow["QuoteAdd_countryId"] = billCountry;
                    //addressRow["QuoteAdd_stateId"] = billState;
                    //addressRow["QuoteAdd_cityId"] = billcity;
                    //addressRow["QuoteAdd_areaId"] = 0;
                    //addressRow["QuoteAdd_pin"] = billpin;
                    //addressRow["QuoteAdd_CreatedDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_CreatedUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //addressRow["QuoteAdd_LastModifyDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_LastModifyUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //AddressDetaildt.Rows.Add(addressRow);



                    //addressRow = AddressDetaildt.NewRow();
                    //addressRow["QuoteAdd_QuoteId"] = 0;
                    //addressRow["QuoteAdd_CompanyID"] = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    //addressRow["QuoteAdd_BranchId"] = Convert.ToString(HttpContext.Current.Session["userbranchID"]);
                    //addressRow["QuoteAdd_FinYear"] = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);
                    //addressRow["QuoteAdd_ContactPerson"] = "";
                    //addressRow["QuoteAdd_addressType"] = "Shipping";
                    //addressRow["QuoteAdd_address1"] = shippingAddress1;
                    //addressRow["QuoteAdd_address2"] = shippingAddress2;
                    //addressRow["QuoteAdd_address3"] = "";
                    //addressRow["QuoteAdd_landMark"] = "";

                    //addressRow["QuoteAdd_countryId"] = ShipCountry;
                    //addressRow["QuoteAdd_stateId"] = ShipState;
                    //addressRow["QuoteAdd_cityId"] = Shipcity;
                    //addressRow["QuoteAdd_areaId"] = 0;
                    //addressRow["QuoteAdd_pin"] = Shippin;
                    //addressRow["QuoteAdd_CreatedDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_CreatedUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //addressRow["QuoteAdd_LastModifyDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_LastModifyUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //AddressDetaildt.Rows.Add(addressRow);
                    //HttpContext.Current.Session["SI_QuotationAddressDtl"] = AddressDetaildt;

                    DataTable StateDetails = oDBEngine.GetDataTable("select state+' (State Code:'+StateCode+')' stateText,id   from tbl_master_state where id=" + billState + " union all select state+' (State Code:'+StateCode+')' stateText,id   from tbl_master_state where id=" + ShipState);
                    string BillingStateText = "", BillingStateCode = "", ShippingStateText = "", ShippingStateCode = "";
                    if (StateDetails.Rows.Count > 0)
                    {
                        BillingStateText = Convert.ToString(StateDetails.Rows[0]["stateText"]);
                        BillingStateCode = Convert.ToString(StateDetails.Rows[0]["id"]);

                        ShippingStateText = Convert.ToString(StateDetails.Rows[1]["stateText"]);
                        ShippingStateCode = Convert.ToString(StateDetails.Rows[1]["id"]);
                    }


                    return new { status = "Ok", InternalId = InternalId, BillingStateText = BillingStateText, BillingStateCode = BillingStateCode, ShippingStateText = ShippingStateText, ShippingStateCode = ShippingStateCode };
                }
                else
                {
                    return new { status = "Error", Msg = "Already Exists" };
                }
            }
            catch (Exception ex)
            {
                return new { status = "Error", Msg = ex.Message };
            }
        }

        [WebMethod]
        public static object SaveVendorMaster(string UniqueID, string Name, string BillingAddress1, string BillingAddress2, string BillingPin, string shippingAddress1, string shippingAddress2, string shippingPin, string GSTIN, string BillingPhone, string ShippingPhone, string contactperson, string Vendortype, string addtypeVal, string accountgroupval)
        
        {
            BusinessLogicLayer.Contact oContactGeneralBL = new BusinessLogicLayer.Contact();
            MShortNameCheckingBL mshort = new MShortNameCheckingBL();
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);


            try
            {
                //if(ApplicableDate!="")
                //{
                //    DateTime ddate = Convert.ToDateTime(ApplicableDate);
                //}
                string entityName = "";
                if (!mshort.CheckUniqueWithtypeContactMaster(UniqueID, "", "MasterContactType", "DV", ref entityName))
                {
                    string InternalId = oContactGeneralBL.Insert_ContactGeneral("Vendor", UniqueID, "1",
                                                        Name, "", "",
                                                        UniqueID, "0", "2",
                                                        "0", new DateTime(1900, 1, 1, 0, 0, 0, 0), new DateTime(1900, 1, 1, 0, 0, 0, 0), "1",
                                                        "1", "1", "",
                                                        "0", "0", "0",
                                                        "1", "", "", "DV",
                                                        "1", DateTime.Now, "1", "",
                                                        "1", "No", "", Convert.ToString(HttpContext.Current.Session["userid"]), "",
                                                        DateTime.Now, "", "78", false, 0,
                                                        0, "A",
                                                        "", "");


                    RemarkCategoryBL reCat = new RemarkCategoryBL();
                    int brmap = reCat.insertVendorBranchMap("", InternalId, 0);
                    Int32 rowsEffected = oDBEngine.SetFieldValue("tbl_master_contact", "cnt_EntityType='" + Vendortype + "',AccountGroupID='" + accountgroupval + "'", " cnt_internalId='" + InternalId + "'");


                    ProcedureExecute proc = new ProcedureExecute("prc_GetSetVendorPopup");
                    proc.AddVarcharPara("@action", 500, "SaveBillingShipping");
                    proc.AddVarcharPara("@pin", 10, BillingPin);
                    proc.AddVarcharPara("@billingAddress1", 100, BillingAddress1);
                    proc.AddVarcharPara("@billingAddress2", 100, BillingAddress2);
                    proc.AddVarcharPara("@shippingpin", 10, shippingPin);
                    proc.AddVarcharPara("@shippingbillingAddress1", 100, shippingAddress1);
                    proc.AddVarcharPara("@shippingbillingAddress2", 100, shippingAddress2);
                    proc.AddVarcharPara("@customerInternalId", 10, InternalId);
                    proc.AddVarcharPara("@cntUcc", 50, UniqueID);
                    proc.AddVarcharPara("@GSTIN", 20, GSTIN);
                    proc.AddVarcharPara("@BillingPhone", 20, BillingPhone);
                    proc.AddVarcharPara("@ShippingPhone", 20, ShippingPhone);
                    proc.AddVarcharPara("@contactperson", 40, contactperson);
                    proc.AddVarcharPara("@AddressType", 40, addtypeVal);
                    proc.AddIntegerNullPara("@BillCountry", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@BillState", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@BillCity", QueryParameterDirection.Output);
                    proc.AddIntegerNullPara("@Billpin", QueryParameterDirection.Output);

                    //proc.AddIntegerNullPara("@ShipCountry", QueryParameterDirection.Output);
                    //proc.AddIntegerNullPara("@ShipState", QueryParameterDirection.Output);
                    //proc.AddIntegerNullPara("@ShipCity", QueryParameterDirection.Output);
                    //proc.AddIntegerNullPara("@Shippin", QueryParameterDirection.Output);


                    proc.RunActionQuery();



                    int billCountry = Convert.ToInt32(proc.GetParaValue("@BillCountry"));
                    int billState = Convert.ToInt32(proc.GetParaValue("@BillState"));
                    int billcity = Convert.ToInt32(proc.GetParaValue("@BillCity"));
                    int billpin = Convert.ToInt32(proc.GetParaValue("@Billpin"));


                    //int ShipCountry = Convert.ToInt32(proc.GetParaValue("@ShipCountry"));
                    //int ShipState = Convert.ToInt32(proc.GetParaValue("@ShipState"));
                    //int Shipcity = Convert.ToInt32(proc.GetParaValue("@ShipCity"));
                    //int Shippin = Convert.ToInt32(proc.GetParaValue("@Shippin"));

                    //Billig Details
                    //DataTable AddressDetaildt = new DataTable();

                    //AddressDetaildt.Columns.Add("QuoteAdd_QuoteId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_CompanyID", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_BranchId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_FinYear", typeof(System.String));

                    //AddressDetaildt.Columns.Add("QuoteAdd_ContactPerson", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_addressType", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_address1", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_address2", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_address3", typeof(System.String));


                    //AddressDetaildt.Columns.Add("QuoteAdd_landMark", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_countryId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_stateId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_cityId", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_areaId", typeof(System.Int32));


                    //AddressDetaildt.Columns.Add("QuoteAdd_pin", typeof(System.String));
                    //AddressDetaildt.Columns.Add("QuoteAdd_CreatedDate", typeof(System.DateTime));
                    //AddressDetaildt.Columns.Add("QuoteAdd_CreatedUser", typeof(System.Int32));
                    //AddressDetaildt.Columns.Add("QuoteAdd_LastModifyDate", typeof(System.DateTime));
                    //AddressDetaildt.Columns.Add("QuoteAdd_LastModifyUser", typeof(System.Int32));

                    //DataRow addressRow = AddressDetaildt.NewRow();

                    //addressRow["QuoteAdd_QuoteId"] = 0;
                    //addressRow["QuoteAdd_CompanyID"] = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    //addressRow["QuoteAdd_BranchId"] = Convert.ToString(HttpContext.Current.Session["userbranchID"]);
                    //addressRow["QuoteAdd_FinYear"] = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);
                    //addressRow["QuoteAdd_ContactPerson"] = "";
                    //addressRow["QuoteAdd_addressType"] = addtypeVal;//"Billing";
                    //addressRow["QuoteAdd_address1"] = BillingAddress1;
                    //addressRow["QuoteAdd_address2"] = BillingAddress2;
                    //addressRow["QuoteAdd_address3"] = "";
                    //addressRow["QuoteAdd_landMark"] = "";

                    //addressRow["QuoteAdd_countryId"] = billCountry;
                    //addressRow["QuoteAdd_stateId"] = billState;
                    //addressRow["QuoteAdd_cityId"] = billcity;
                    //addressRow["QuoteAdd_areaId"] = 0;
                    //addressRow["QuoteAdd_pin"] = billpin;
                    //addressRow["QuoteAdd_CreatedDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_CreatedUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //addressRow["QuoteAdd_LastModifyDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_LastModifyUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //AddressDetaildt.Rows.Add(addressRow);



                    //addressRow = AddressDetaildt.NewRow();
                    //addressRow["QuoteAdd_QuoteId"] = 0;
                    //addressRow["QuoteAdd_CompanyID"] = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                    //addressRow["QuoteAdd_BranchId"] = Convert.ToString(HttpContext.Current.Session["userbranchID"]);
                    //addressRow["QuoteAdd_FinYear"] = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);
                    //addressRow["QuoteAdd_ContactPerson"] = "";
                    //addressRow["QuoteAdd_addressType"] = "Shipping";
                    //addressRow["QuoteAdd_address1"] = shippingAddress1;
                    //addressRow["QuoteAdd_address2"] = shippingAddress2;
                    //addressRow["QuoteAdd_address3"] = "";
                    //addressRow["QuoteAdd_landMark"] = "";

                    //addressRow["QuoteAdd_countryId"] = ShipCountry;
                    //addressRow["QuoteAdd_stateId"] = ShipState;
                    //addressRow["QuoteAdd_cityId"] = Shipcity;
                    //addressRow["QuoteAdd_areaId"] = 0;
                    //addressRow["QuoteAdd_pin"] = Shippin;
                    //addressRow["QuoteAdd_CreatedDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_CreatedUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //addressRow["QuoteAdd_LastModifyDate"] = DateTime.Now;
                    //addressRow["QuoteAdd_LastModifyUser"] = Convert.ToInt32(HttpContext.Current.Session["userid"]);
                    //AddressDetaildt.Rows.Add(addressRow);
                    //HttpContext.Current.Session["SI_QuotationAddressDtl"] = AddressDetaildt;

                    DataTable StateDetails = oDBEngine.GetDataTable("select state+' (State Code:'+StateCode+')' stateText,id   from tbl_master_state where id=" + billState );
                    //string BillingStateText = "", BillingStateCode = "", ShippingStateText = "", ShippingStateCode = "";
                    string BillingStateText = "", BillingStateCode = "";
                    if (StateDetails.Rows.Count > 0)
                    {
                        BillingStateText = Convert.ToString(StateDetails.Rows[0]["stateText"]);
                        BillingStateCode = Convert.ToString(StateDetails.Rows[0]["id"]);

                        //ShippingStateText = Convert.ToString(StateDetails.Rows[1]["stateText"]);
                        //ShippingStateCode = Convert.ToString(StateDetails.Rows[1]["id"]);
                    }


                    return new { status = "Ok", InternalId = InternalId, BillingStateText = BillingStateText, BillingStateCode = BillingStateCode, ShippingStateText = "", ShippingStateCode = "" };
                }
                else
                {
                    return new { status = "Error", Msg = "Already Exists" };
                }
            }
            catch (Exception ex)
            {
                return new { status = "Error", Msg = ex.Message };
            }
        }

                
        #endregion

    }
}