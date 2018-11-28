using OpeningBusinessLogic;
using BusinessLogicLayer.Replacement;
using DevExpress.Web;
using DevExpress.Web.Data;
using EntityLayer.CommonELS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpeningBusinessLogic.Customerconsolidate;

namespace OpeningEntry.ERP
{
    public partial class ConsolidatedCustomer : System.Web.UI.Page
    {

        DataTable dst = new DataTable();
        string strBranchID = "";
        Consolidatecustomer obj = new Consolidatecustomer();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);

        protected void Page_PreInit(object sender, EventArgs e) // lead add
        {

            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);


                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/ERP/ConsolidatedCustomerList.aspx");

            if (!IsPostBack)
            {
                Session["exportval2"] = null;

                Branchpopulate();
                Agentpopulate();
                strBranchID = Convert.ToString(Session["userbranchID"]);
                DataTable dtsale = obj.GetCustomersalesFinancialyear(Convert.ToString(Session["LastFinYear"]));
                if (dtsale.Rows.Count > 0)
                {
                    dt_date.MaxDate = Convert.ToDateTime(Convert.ToString(dtsale.Rows[0]["FinYear_StartDate"])).AddDays(-1);
                    dt_date2.MaxDate = Convert.ToDateTime(Convert.ToString(dtsale.Rows[0]["FinYear_StartDate"])).AddDays(-1);
                }
                if (Request.QueryString["CustomerId"] != null)
                {
                    OpeningGrid.Visible = true;
                    //divgrid.Visible = true;
                    hdncus.Value = "1";
                    hiddnmodid.Value = Request.QueryString["CustomerId"];
                    ddl_Branch.Enabled = false;
                    lookup_Customer.ReadOnly = true;
                    ddltype.Enabled = false;
                    OpeningGrid.DataSource = GetConsolidatedCustomerGridData(Request.QueryString["CustomerId"], Request.QueryString["branch"]);
                    OpeningGrid.DataBind();


                }
                else
                {
                    ///  divgrid.Visible = false;
                    hiddnmodid.Value = "0";
                    hdncus.Value = "0";
                }
            }
        }


        #region ########  Branch Populate  #######
        protected void Branchpopulate()
        {
            // DataTable dst = new DataTable();
            string userbranchID = Convert.ToString(Session["userbranchID"]);
            dst = obj.GetBranch(Convert.ToInt32(HttpContext.Current.Session["userbranchID"]), Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]));

            if (dst.Rows.Count > 0)
            {


                dst.DefaultView.RowFilter = "branch_id <>0";

                ddl_Branch.DataSource = dst.DefaultView;

                //   ddl_Branch.DataSource = dst;
                ddl_Branch.DataTextField = "branch_code";
                ddl_Branch.DataValueField = "branch_id";
                ddl_Branch.DataBind();
                // ddl_Branch.SelectedValue = strBranchID;
                if (Request.QueryString["branch"] != null)
                {
                    ddl_Branch.SelectedValue = Request.QueryString["branch"];

                    Cache["name"] = ddl_Branch.SelectedValue;
                }
                //  ddl_Branch.SelectedValue = strBranchID;
                else if (Session["userbranchID"] != null)
                {
                    ddl_Branch.SelectedValue = userbranchID;
                }
            }
        }

        #endregion

        #region ########  Salesman Agent Populate  #######
        protected void Agentpopulate()
        {

            dst = obj.GetAgents("GetSalesmanAgent", Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]));

            if (dst.Rows.Count > 0)
            {

                cmbContactPerson.DataSource = dst;
                cmbContactPerson.TextField = "Name";
                cmbContactPerson.ValueField = "cnt_internalId";
                cmbContactPerson.DataBind();


            }
        }

        #endregion


        #region #########   Contact Person Bind(Salesman)   #########

        protected void cmbContactPerson_Callback(object sender, CallbackEventArgsBase e)
        {
            string WhichCall = e.Parameter.Split('~')[0];
            if (WhichCall == "BindContactPerson")
            {
                string InternalId = Convert.ToString(Convert.ToString(e.Parameter.Split('~')[1]));
                PopulateContactPersonOfCustomer(InternalId);



                //DataTable dtTotalDues = objSalesInvoiceBL.GetCustomerTotalDues(InternalId);
                //if (dtTotalDues != null && dtTotalDues.Rows.Count > 0)
                //{
                //    string totalDues = Convert.ToString(dtTotalDues.Rows[0]["NetOutstanding"]);
                //    cmbContactPerson.JSProperties["cpTotalDue"] = totalDues;
                //}
                //else
                //{
                //    cmbContactPerson.JSProperties["cpTotalDue"] = "0.00";
                //}
            }
        }
        protected void PopulateContactPersonOfCustomer(string InternalId)
        {
            string ContactPerson = "";
            DataTable dtContactPerson = new DataTable();

            dtContactPerson = obj.PopulateContactPersonOfCustomer(InternalId);
            if (dtContactPerson != null && dtContactPerson.Rows.Count > 0)
            {
                cmbContactPerson.TextField = "contactperson";
                cmbContactPerson.ValueField = "add_id";
                cmbContactPerson.DataSource = dtContactPerson;
                cmbContactPerson.DataBind();
                foreach (DataRow dr in dtContactPerson.Rows)
                {
                    if (Convert.ToString(dr["Isdefault"]) == "True")
                    {
                        ContactPerson = Convert.ToString(dr["add_id"]);
                        break;
                    }
                }
                cmbContactPerson.SelectedItem = cmbContactPerson.Items.FindByValue(ContactPerson);
            }
        }

        #endregion


        #region  ###### Insert  Update  DATA  through Grid Perform Call Back  ##############
        protected void OpeningGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            ASPxGridView grid = lookup_Customer.GridView;
            object cuname = grid.GetRowValues(grid.FocusedRowIndex, new string[] { "Name" });
            List<ConsolidatedCustomerClass> customerconsolidate = new List<ConsolidatedCustomerClass>();
            string returnPara = Convert.ToString(e.Parameters);

            string FinYear = String.Empty;
            string User = String.Empty;
            string Company = String.Empty;


            //if (Session["LastFinYear"] != null)
            //{
            //    FinYear = Convert.ToString(Session["LastFinYear"]).Trim();
            //}
            DataTable dttab;


            string WhichCall = returnPara.Split('~')[0];

            //  string AmountOs = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : txt_docamt2.Text;
            string AmountOs = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : (ddltype.SelectedValue == "CDB" || ddltype.SelectedValue == "CCR") ? txt_vendor_amt.Text : txt_docamt2.Text;


            string Typeget = ddltype.SelectedValue;
            string CustomerID = Convert.ToString(lookup_Customer.Value);


            if (WhichCall == "TemporaryData")
            {
                Cache["name"] = ddl_Branch.SelectedValue;
                DataTable dt = new DataTable();
                string docnumber = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_Docno.Text : txt_Docno2.Text;
                dt = obj.GetDuplicateDoc("DuplicateDoccheck", docnumber, "");
                if (Convert.ToString(dt.Rows[0][0]) == "0" && (ddltype.SelectedValue != "CDB" || ddltype.SelectedValue != "CCR"))
                {
                    if (Session["LastFinYear"] != null)
                    {
                        if (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET")
                        {
                            dttab = obj.GetCustomersalesFinancialyearCode(Convert.ToDateTime(dt_date.Date));
                        }
                        else if (ddltype.SelectedValue == "CDB" || ddltype.SelectedValue == "CCR")
                        {
                            dttab = obj.GetCustomersalesFinancialyearCode(Convert.ToDateTime(dt_vendor.Date));
                        }
                        else
                        {
                            dttab = obj.GetCustomersalesFinancialyearCode(Convert.ToDateTime(dt_date2.Date));
                        }
                        if (dttab.Rows.Count > 0)
                        {
                            FinYear = Convert.ToString(dttab.Rows[0]["FinYear_Code"]);
                        }

                    }
                    if (Session["userid"] != null)
                    {
                        User = Convert.ToString(HttpContext.Current.Session["userid"]).Trim();
                    }

                    if (Session["LastCompany"] != null)
                    {
                        Company = Convert.ToString(Session["LastCompany"]);
                    }


                    //if (Session["GetData"] !=null)
                    //{
                    //    customerconsolidate = (List<ConsolidatedCustomerClass>)Session["GetData"];

                    //}


                    customerconsolidate.Add(new ConsolidatedCustomerClass()
                    {

                        Branch = ddl_Branch.SelectedItem.Text,
                        BranchId = ddl_Branch.SelectedValue,
                        CustomerId = Convert.ToString(lookup_Customer.Value),
                        Customer = cuname.ToString(),
                        Type = ddltype.SelectedItem.Text,
                        TypeId = ddltype.SelectedValue,
                        DocNumber = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_Docno.Text : txt_Docno2.Text,
                        Date = dt_date.Text,
                        // Date_db = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? (String.IsNullOrEmpty(dt_date.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date.Date)) : (String.IsNullOrEmpty(dt_date2.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date2.Date)),
                        Date_db = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? (String.IsNullOrEmpty(dt_date.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date.Date)) : (ddltype.SelectedValue == "CDB" || ddltype.SelectedValue == "CCR") ? (String.IsNullOrEmpty(dt_vendor.Text) ? default(DateTime?) : Convert.ToDateTime(dt_vendor.Date)) : (String.IsNullOrEmpty(dt_date2.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date2.Date)),


                        FullBill = txt_fullbill.Text,
                        DueDate = dtdate_Due.Text,
                        DueDate_db = (String.IsNullOrEmpty(dtdate_Due.Text) ? default(DateTime?) : Convert.ToDateTime(dtdate_Due.Date)),
                        RefDate_db = (String.IsNullOrEmpty(dtdate_Ref.Text) ? default(DateTime?) : Convert.ToDateTime(dtdate_Ref.Date)),
                        //DocAmount = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : txt_docamt2.Text,
                        //DSAmount = txt_disamt.Text,
                        DocAmount = txt_disamt.Text,
                        ///    DSAmount = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : txt_docamt2.Text,
                        DSAmount = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : (ddltype.SelectedValue == "CDB" || ddltype.SelectedValue == "CCR") ? txt_vendor_amt.Text : txt_docamt2.Text,

                        AgentName = cmbContactPerson.Text,
                        AgentId = Convert.ToString(cmbContactPerson.Value),
                        Commpercntag = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_commprcntg.Text : txt_commprcntg2.Text,
                        CommmAmt = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_commAmt.Text : txt_commAmt2.Text,
                        Company = Company,
                        FinYear = FinYear,
                        User = User
                    });


                    string CustomerconsolidateXML = Consolidatecustomer.ConvertToXml(customerconsolidate, 0);

                    int i2 = obj.InsertReplacementDetails(CustomerconsolidateXML, "InserCustomerConsolidate", AmountOs, Typeget, CustomerID, 0);


                    if (i2 > 0)
                    {

                        OpeningGrid.JSProperties["cpSaveSuccessOrFail"] = "Success";
                    }
                    // Session["GetData"] = customerconsolidate;
                }
                else
                {

                    OpeningGrid.JSProperties["cpSaveSuccessOrFail"] = "Duplicate";
                }
            }


            if (WhichCall == "ModifyData")
            {
                Cache["name"] = ddl_Branch.SelectedValue;


                int ModId = Int32.Parse(returnPara.Split('~')[1]);
                DataTable dt = new DataTable();
                string docnumber = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_Docno.Text : txt_Docno2.Text;
                dt = obj.GetDuplicateDoc("DuplicateDoccheck", docnumber, Convert.ToString(ModId));
                if (Convert.ToString(dt.Rows[0][0]) == "0")
                {
                    customerconsolidate.Add(new ConsolidatedCustomerClass()
                    {
                        ModId = ModId,
                        Branch = ddl_Branch.SelectedItem.Text,
                        BranchId = ddl_Branch.SelectedValue,
                        CustomerId = Convert.ToString(lookup_Customer.Value),
                        Customer = Convert.ToString(cuname),
                        Type = ddltype.SelectedItem.Text,
                        TypeId = ddltype.SelectedValue,
                        DocNumber = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_Docno.Text : txt_Docno2.Text,
                        Date = dt_date.Text,
                        // Date_db = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? (String.IsNullOrEmpty(dt_date.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date.Date)) : (String.IsNullOrEmpty(dt_date2.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date2.Date)),

                        Date_db = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? (String.IsNullOrEmpty(dt_date.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date.Date)) : (ddltype.SelectedValue == "CDB" || ddltype.SelectedValue == "CCR") ? (String.IsNullOrEmpty(dt_vendor.Text) ? default(DateTime?) : Convert.ToDateTime(dt_vendor.Date)) : (String.IsNullOrEmpty(dt_date2.Text) ? default(DateTime?) : Convert.ToDateTime(dt_date2.Date)),


                        FullBill = txt_fullbill.Text,
                        DueDate = dtdate_Due.Text,
                        DueDate_db = (String.IsNullOrEmpty(dtdate_Due.Text) ? default(DateTime?) : Convert.ToDateTime(dtdate_Due.Date)),
                        RefDate_db = (String.IsNullOrEmpty(dtdate_Ref.Text) ? default(DateTime?) : Convert.ToDateTime(dtdate_Ref.Date)),
                        //DocAmount = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : txt_docamt2.Text,
                        //DSAmount = txt_disamt.Text,

                        DocAmount = txt_disamt.Text,
                        // DSAmount = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : txt_docamt2.Text,
                        DSAmount = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_docamt.Text : (ddltype.SelectedValue == "CDB" || ddltype.SelectedValue == "CCR") ? txt_vendor_amt.Text : txt_docamt2.Text,
                        AgentName = cmbContactPerson.Text,
                        AgentId = Convert.ToString(cmbContactPerson.Value),
                        Commpercntag = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_commprcntg.Text : txt_commprcntg2.Text,
                        CommmAmt = (ddltype.SelectedValue == "SB" || ddltype.SelectedValue == "RET") ? txt_commAmt.Text : txt_commAmt2.Text,
                        User = User
                    });


                    string Customerconsolidate22XML = Consolidatecustomer.ConvertToXml(customerconsolidate, 0);

                    int i2 = obj.InsertReplacementDetails(Customerconsolidate22XML, "UpdateCustomerConsolidate", AmountOs, Typeget, CustomerID, ModId);


                    if (i2 > 0)
                    {

                        OpeningGrid.JSProperties["cpSaveSuccessOrFail"] = "Success";
                    }

                }
                else
                {

                    OpeningGrid.JSProperties["cpSaveSuccessOrFail"] = "Duplicate";
                }
            }



            else if (WhichCall == "Delete")
            {
                int ModId = Int32.Parse(returnPara.Split('~')[1]);

                int i2 = obj.IDeleteReplacementDetails(ModId, "DeleteCus");

                if (i2 > 0)
                {
                    OpeningGrid.JSProperties["cpSaveSuccessOrFail"] = "Success";
                }

            }


            else if (WhichCall == "Display")
            {
                OpeningGrid.DataSource = GetConsolidatedCustomerGridData(Request.QueryString["CustomerId"], Request.QueryString["branch"]);
                OpeningGrid.DataBind();
            }


            else if (WhichCall == "ClearData")
            {
                txt_Docno.Text = String.Empty;
                dt_date.Text = String.Empty;
                txt_fullbill.Text = String.Empty;
                dtdate_Due.Text = String.Empty;
                txt_docamt.Text = String.Empty;
                dtdate_Ref.Text = String.Empty;

                cmbContactPerson.Text = String.Empty;

                cmbContactPerson.DataSource = null;
                cmbContactPerson.DataBind();

                txt_commAmt.Text = String.Empty;
                txt_commprcntg.Text = String.Empty;
                txt_commAmt.Text = String.Empty;
            }



        }

        protected void grid_DataBinding(object sender, EventArgs e)
        {
            //if (Session["OpeningDatatable"] != null)
            //{
            //    OpeningGrid.DataSource = (DataTable)Session["OpeningDatatable"];
            //}
            OpeningGrid.DataSource = GetConsolidatedCustomerGridData(Request.QueryString["CustomerId"], Request.QueryString["branch"]);

        }

        #endregion


        #region ########## Bind Data Customer wise   #############
        public DataTable GetConsolidatedCustomerGridData(string CustomerId, string branch)
        {
            try
            {

                DataTable dt = obj.GetCustomesconsolidate("CustomerWisebind", CustomerId, Int32.Parse(branch));
                return dt;
            }
            catch
            {
                return null;
            }

        }
        #endregion


        protected void ComponentQuotation_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (e.Parameter.Split('~')[0] == "Fetch")
            {
                string s = e.Parameter.Split('~')[1];
                lookup_Customer.Value = s;

            }
        }

        public void cmbExport2_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(ddldetails.SelectedItem.Value));
            if (Filter != 0)
            {


                if (Session["exportval2"] == null)
                {
                    Session["exportval2"] = Filter;
                    // BindDropDownList();
                    bindexport2(Filter);
                }
                else if (Convert.ToInt32(Session["exportval2"]) != Filter)
                {
                    Session["exportval2"] = Filter;
                    // BindDropDownList();
                    bindexport2(Filter);
                }
            }

        }
        public void bindexport2(int Filter)
        {
            //GrdReplacement.Columns[6].Visible = false;
            string filename = "ConsolidatedCustomerDetails";
            exporter.FileName = filename;
            //    exporter.FileName = "SalesRegiserDetailsReport";

            exporter.PageHeader.Left = "Consolidated Customer Details Report";
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";
            exporter.GridViewID = "OpeningGrid";
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


    }


}