using System;
using System.Data;
using System.Web;
using System.Web.UI;
using DevExpress.Web;
using BusinessLogicLayer;
using System.IO;
using EntityLayer.CommonELS;
using DataAccessLayer;
using BusinessLogicLayer.SalesERP;
using System.Web.Services;


namespace ERP.OMS.Management.Master
{
    public partial class management_master_Employee : ERP.OMS.ViewState_class.VSPage// System.Web.UI.Page
    {
        #region Global Variable
        public string pageAccess;
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        GlobalSettings globalsetting = new GlobalSettings();
        //GenericExcelExport oGenericExcelExport;
        //GenericMethod oGenericMethod;
        BusinessLogicLayer.GenericExcelExport oGenericExcelExport;
        BusinessLogicLayer.GenericMethod oGenericMethod;
        BusinessLogicLayer.Converter OConvert = new BusinessLogicLayer.Converter();
        string WhichCall;
        DataSet Ds_Global;
        AspxHelper oAspxHelper = new AspxHelper();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        #endregion
        //Session Used in This Page : PageSize,FromDOJ,ToDoj,PageNumAfterNav,SerachString,SearchBy,FindOption
        #region Page Properties
        public string P_PageSize
        {
            get { return (string)ViewState["PageSize"]; }
            set { ViewState["PageSize"] = value; }
        }
        public string P_FromDOJ
        {
            get { return (string)Session["FromDOJ"]; }
            set { Session["FromDOJ"] = value; }
        }
        public string P_ToDOJ
        {
            get { return (string)Session["ToDOJ"]; }
            set { Session["ToDOJ"] = value; }
        }
        public string P_PageNumAfterNav
        {
            get { return (string)Session["PageNumAfterNav"]; }
            set { Session["PageNumAfterNav"] = value; }
        }
        public string P_SearchString
        {
            get { return (string)Session["SearchString"]; }
            set { Session["SearchString"] = value; }
        }
        public string P_SearchBy
        {
            get { return (string)Session["SearchBy"]; }
            set { Session["SearchBy"] = value; }
        }
        public string P_FindOption
        {
            get { return (string)Session["FindOption"]; }
            set { Session["FindOption"] = value; }
        }
        public string P_ShowFilter_SearchString
        {
            get { return (string)Session["ShowFilter_SearchString"]; }
            set { Session["ShowFilter_SearchString"] = value; }
        }


        #endregion
        #region User Define Methods
        DataSet Fetch_EmployeeData(string FromDOJ, string ToDOJ, string PageSize, string PageNumber,
            string SearchString, string SearchBy, string FindOption, string ExportType, string DevXFilterOn, string DevXFilterString)
        {
            string[] InputName = new string[10];
            string[] InputType = new string[10];
            string[] InputValue = new string[10];

            InputName[0] = "FromJoinDate";
            InputName[1] = "ToJoinDate";
            InputName[2] = "PageSize";
            InputName[3] = "PageNumber";
            InputName[4] = "SearchString";
            InputName[5] = "SearchBy";
            InputName[6] = "FindOption";
            InputName[7] = "ExportType";
            InputName[8] = "DevXFilterOn";
            InputName[9] = "DevXFilterString";

            InputType[0] = "D";
            InputType[1] = "D";
            InputType[2] = "I";
            InputType[3] = "I";
            InputType[4] = "V";
            InputType[5] = "C";
            InputType[6] = "V";
            InputType[7] = "V";
            InputType[8] = "V";
            InputType[9] = "V";

            InputValue[0] = FromDOJ;
            InputValue[1] = ToDOJ;
            InputValue[2] = PageSize;
            InputValue[3] = PageNumber;
            InputValue[4] = SearchString;
            InputValue[5] = SearchBy;
            InputValue[6] = FindOption;
            InputValue[7] = ExportType;
            InputValue[8] = DevXFilterOn;
            InputValue[9] = DevXFilterString;

            return BusinessLogicLayer.SQLProcedures.SelectProcedureArrDS("HR_Fetch_Employees", InputName, InputType, InputValue);
        }

        void ExportToExcel(DataSet DsExport, string FromDOJ, string ToDOJ, string SearchString, string SearchBy, string FindOption)
        {
            oGenericExcelExport = new BusinessLogicLayer.GenericExcelExport();
            DataTable DtExport = new DataTable();
            string strHeader = String.Empty;
            string[] ReportHeader = new string[1];
            string strSavePath = String.Empty;

            strHeader = "Employee Detail From " + Convert.ToDateTime(P_FromDOJ == "" ? "1900-01-01" : P_FromDOJ).ToString("dd-MMM-yyyy") + " To " +
                Convert.ToDateTime(P_ToDOJ == "" ? "9999-12-31" : P_ToDOJ).ToString("dd-MMM-yyyy");

            strHeader = strHeader + (SearchBy != "" ? (SearchBy == "EC" ? " (Search By : Employee Code " + (FindOption == "0" ? " Like '" : " = '") + SearchString :
                " (Search By : Employee Name " + (FindOption == "0" ? " Like '" : " = '") + SearchString) : "");

            string exlDateTime = oDBEngine.GetDate(113).ToString();
            string exlTime = exlDateTime.Replace(":", "");
            exlTime = exlTime.Replace(" ", "");

            if (DsExport.Tables.Count > 0)
                if (DsExport.Tables[0].Rows.Count > 0)
                {
                    DtExport = DsExport.Tables[0];
                    ReportHeader[0] = strHeader;
                    string FileName = "EmployeeDetail_" + exlTime;
                    strSavePath = "~/Documents/";

                    //SRLNO,Name,FatherName,DOJ,Department,BranchName,CTC,ReportTo,Designation,Company,
                    //Email_Ids,PhoneMobile_Numbers,PanCardNumber,CreatedBy
                    string[] ColumnType = { "V", "V", "V", "V", "V", "V", "V", "V", "V", "V", "V", "V", "V", "V" };
                    string[] ColumnSize = { "10", "150", "150", "50", "50", "100", "100", "100", "100", "150", "150", "150", "150", "150" };
                    string[] ColumnWidthSize = { "5", "30", "30", "12", "22", "23", "15", "25", "23", "25", "25", "25", "20", "20" };

                    oGenericExcelExport.ExportToExcel(ColumnType, ColumnSize, ColumnWidthSize, DtExport, Server.MapPath(strSavePath), "2007", FileName, ReportHeader, null);
                }
        }
        #endregion

        #region Business Logic
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // Code  Added and Commented By Priti on 16122016 to add Convert.ToString instead of ToString()
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                //string sPath = HttpContext.Current.Request.Url.ToString();
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                oDBEngine.Call_CheckPageaccessebility(sPath);

                string[] PageSession = { "PageSize", "FromDOJ", "ToDoj", "PageNumAfterNav", "SerachString", "SearchBy", "FindOption", "ShowFilter_SearchString" };
                oGenericMethod = new BusinessLogicLayer.GenericMethod();
                oGenericMethod.PageInitializer(BusinessLogicLayer.GenericMethod.WhichCall.DistroyUnWantedSession_AllExceptPage, PageSession);
                oGenericMethod.PageInitializer(BusinessLogicLayer.GenericMethod.WhichCall.DistroyUnWantedSession_Page, PageSession);

            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/employee.aspx");


            if (HttpContext.Current.Session["userid"] == null)
            {
                ////Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }



            if (!IsPostBack)
            {
               GetemployeeSupervisor();

                //Page.ClientScript.RegisterStartupScript(GetType(), "PageLD", "<script>Pageload();</script>");
                //Initialize Variable
                P_PageSize = "10";
                DtFrom.Date = oDBEngine.GetDate().AddDays(-30);
                DtTo.Date = oDBEngine.GetDate();
                //code Added By Priti on 21122016 to use Export Header,date
                Session["exportval"] = null;
                //....end...
            }
            BindGrid();
            //else { Page.ClientScript.RegisterStartupScript(GetType(), "PageLD", "<script>Pageload();</script>"); }
            //if (hdn_GridBindOrNotBind.Value != "False")
            //{
            //    if (P_FromDOJ != null && P_FromDOJ.Trim() != String.Empty && P_ToDOJ != null && P_ToDOJ.Trim() != String.Empty &&
            //        P_PageSize != null && P_PageNumAfterNav != null)
            //    {
            //        //When Show Filter Active With SearchString
            //        //Then Grid Bind With SearchString Cretaria
            //        //Otherwise normally as it bind
            //        if (P_ShowFilter_SearchString != null)
            //            if ( Convert.ToString(P_ShowFilter_SearchString) != String.Empty)
            //                oAspxHelper.BindGrid(GrdEmployee, Fetch_EmployeeData(String.IsNullOrEmpty(P_FromDOJ ) ? "1900-01-01" : P_FromDOJ, String.IsNullOrEmpty(P_ToDOJ) ? "9999-12-31" : P_ToDOJ, P_PageSize,
            //                   Convert.ToString(P_PageNumAfterNav), P_SearchString, P_SearchBy, P_FindOption, "S", "Y", P_ShowFilter_SearchString));
            //            else
            //                oAspxHelper.BindGrid(GrdEmployee, Fetch_EmployeeData(String.IsNullOrEmpty(P_FromDOJ) ? "1900-01-01" : P_FromDOJ, String.IsNullOrEmpty(P_ToDOJ) ? "9999-12-31" : P_ToDOJ, P_PageSize,
            //                Convert.ToString(P_PageNumAfterNav), P_SearchString, P_SearchBy, P_FindOption, "S", "N", String.Empty));
            //        else
            //            oAspxHelper.BindGrid(GrdEmployee, Fetch_EmployeeData(String.IsNullOrEmpty(P_FromDOJ ) ? "1900-01-01" : P_FromDOJ, String.IsNullOrEmpty(P_ToDOJ) ? "9999-12-31" : P_ToDOJ, P_PageSize,
            //            Convert.ToString(P_PageNumAfterNav), P_SearchString, P_SearchBy, P_FindOption, "S", "N", String.Empty));
            //    }
            //  }
            // 
        }

        protected void BindGrid()
        {
            string strFromDOJ = String.Empty, strToDOJ = String.Empty, strSearchString = String.Empty,
                strSearchBy = String.Empty, strFindOption = String.Empty;

            Ds_Global = new DataSet();
            Ds_Global = Fetch_EmployeeData(strFromDOJ == "" ? "1900-01-01" : strFromDOJ, strToDOJ == "" ? "9999-12-31" : strToDOJ, P_PageSize,
                "1", strSearchString, strSearchBy, strFindOption, "S", "N", String.Empty);
            if (Ds_Global.Tables.Count > 0)
            {
                //Debjyoti 070217
                //Reason : Filter all employee to current employee 
                string CurrentComp = Convert.ToString(HttpContext.Current.Session["LastCompany"]);

                // Code Commented And Modified By Sam due to Show All child 
                //company employee with parent company if we log in with Parent Company 
                //version 1.0.0.1
                //string[] cmpId = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_id", " cmp_internalid='" + CurrentComp + "'", 1);


                // DataRow[] extraRow= Ds_Global.Tables[0].Select("organizationid <>" + cmpId[0]);
                //foreach (DataRow dr in extraRow)
                //{
                //    Ds_Global.Tables[0].Rows.Remove(dr);
                //} 
                // GrdEmployee.DataSource = Ds_Global.Tables[0];
                // GrdEmployee.DataBind();

                //version 1.0.0.1 End
                Employee_BL objEmploye = new Employee_BL();
                string ListOfCompany = "";
                string[] cmpId = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_id", " cmp_internalid='" + CurrentComp + "'", 1);
                string Companyid = Convert.ToString(cmpId[0]);
                string Allcompany = "";
                string ChildCompanyid = objEmploye.getChildCompany(CurrentComp, ListOfCompany);
                if (ChildCompanyid != "")
                {
                    Allcompany = Companyid + "," + ChildCompanyid;
                    Allcompany = Allcompany.TrimEnd(',');
                }
                else
                {
                    Allcompany = Companyid;
                }
                DataRow[] extraRow = Ds_Global.Tables[0].Select("organizationid not in(" + Allcompany + ")");
                foreach (DataRow dr in extraRow)
                {
                    Ds_Global.Tables[0].Rows.Remove(dr);
                }
                GrdEmployee.DataSource = Ds_Global.Tables[0];
                GrdEmployee.DataBind();


            }

        }

        protected void GrdEmployee_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            GrdEmployee.JSProperties["cpPagerSetting"] = null;
            GrdEmployee.JSProperties["cpExcelExport"] = null;
            GrdEmployee.JSProperties["cpRefreshNavPanel"] = null;
            GrdEmployee.JSProperties["cpCallOtherWhichCallCondition"] = null;

            // Code  Added  By Priti on 16122016 to use for delete employee
            GrdEmployee.JSProperties["cpDelete"] = null;
            WhichCall = e.Parameters.Split('~')[0];
            string strFromDOJ = String.Empty, strToDOJ = String.Empty, strSearchString = String.Empty,
            strSearchBy = String.Empty, strFindOption = String.Empty;
            string WhichType = null;

            if (Convert.ToString(e.Parameters).Contains("~"))
            {
                WhichType = Convert.ToString(e.Parameters).Split('~')[1];
            }
            if (WhichCall == "Delete")
            {

                DataTable dtUser = new DataTable();
                dtUser = oDBEngine.GetDataTable("tbl_master_user", " top 1 * ", "user_contactId='" + WhichType + "'");

                /// Coded By Samrat Roy -- 18/04/2017 
                /// To Delete Contact Type selection on Employee Type (DME/ISD)
                Employee_BL objEmployee_BL = new Employee_BL();
                objEmployee_BL.DeleteContactType(WhichType);

                if (dtUser.Rows.Count > 0)
                {


                    globalsetting.EmployeeDeleteBySelctName(Convert.ToString(WhichType), Convert.ToString(dtUser.Rows[0]["user_id"]));
                    this.Page.ClientScript.RegisterStartupScript(GetType(), "height12", "<script>alert('Employee has been deleted.');</script>");
                    //GrdEmployee.JSProperties["cpDelete"] = "Success";
                    BindGrid();
                }
                else
                {
                    globalsetting.EmployeeDeleteBySelctName(Convert.ToString(WhichType), DBNull.Value.ToString());
                    this.Page.ClientScript.RegisterStartupScript(GetType(), "height15", "<script>alert('Employee has been deleted.');</script>");
                    // GrdEmployee.JSProperties["cpDelete"] = "Success";
                    BindGrid();

                }
            }

            //.............end........................








            //common parameter
            //  strFromDOJ = oDBEngine.GetDate(BusinessLogicLayer.DBEngine.DateConvertFrom.UTCToOnlyDate, e.Parameters.Split('~')[1]);
            //  strToDOJ = oDBEngine.GetDate(BusinessLogicLayer.DBEngine.DateConvertFrom.UTCToOnlyDate, e.Parameters.Split('~')[2]);

            //if (Rb_SearchBy.SelectedItem.Value.ToString() != "N")
            //{
            //    if (Rb_SearchBy.SelectedItem.Value.ToString() == "EN")//Find By Emp Name
            //    {
            //        strSearchString = txtEmpName.Text;
            //        strSearchBy = "EN";
            //        strFindOption = cmbEmpNameFindOption.SelectedItem.Value.ToString();
            //    }
            //    else //Find By Emp Code
            //    {
            //        strSearchString = txtEmpCode.Text;
            //        strSearchBy = "EC";
            //        strFindOption = cmbEmpCodeFindOption.SelectedItem.Value.ToString();
            //    }
            //}
            int TotalItems = 0;
            int TotalPage = 0;
            //if (WhichCall == "Show")
            //{
            //Set Show filter's FilterExpression Empty and For Fresh Record Fetch
            GrdEmployee.FilterExpression = string.Empty;
            P_ShowFilter_SearchString = null;

            Ds_Global = new DataSet();
            Ds_Global = Fetch_EmployeeData(strFromDOJ == "" ? "1900-01-01" : strFromDOJ, strToDOJ == "" ? "9999-12-31" : strToDOJ, P_PageSize,
                "1", strSearchString, strSearchBy, strFindOption, "S", "N", String.Empty);
            if (Ds_Global.Tables.Count > 0)
            {
                // Count Employee Grid Data Start

                string CurrentComp = Convert.ToString(HttpContext.Current.Session["LastCompany"]);

                Employee_BL objEmploye = new Employee_BL();
                string ListOfCompany = "";
                string[] cmpId = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_id", " cmp_internalid='" + CurrentComp + "'", 1);
                string Companyid = Convert.ToString(cmpId[0]);
                string Allcompany = "";
                string ChildCompanyid = objEmploye.getChildCompany(CurrentComp, ListOfCompany);
                if (ChildCompanyid != "")
                {
                    Allcompany = Companyid + "," + ChildCompanyid;
                    Allcompany = Allcompany.TrimEnd(',');
                }
                else
                {
                    Allcompany = Companyid;
                }
                DataRow[] extraRow = Ds_Global.Tables[0].Select("organizationid not in(" + Allcompany + ")");
                foreach (DataRow dr in extraRow)
                {
                    Ds_Global.Tables[0].Rows.Remove(dr);
                }

                // Count Employee Grid Data End

                if (Ds_Global.Tables[0].Rows.Count > 0)
                {
                    TotalItems = Convert.ToInt32(Ds_Global.Tables[0].Rows[0]["TotalRecord"].ToString());
                    TotalPage = TotalItems % Convert.ToInt32(P_PageSize) == 0 ? (TotalItems / Convert.ToInt32(P_PageSize)) : (TotalItems / Convert.ToInt32(P_PageSize)) + 1;
                    GrdEmployee.JSProperties["cpRefreshNavPanel"] = "ShowBtnClick~1~" + TotalPage.ToString() + '~' + TotalItems.ToString();
                    oAspxHelper.BindGrid(GrdEmployee, Ds_Global);
                }
                else
                    oAspxHelper.BindGrid(GrdEmployee);
            }
            else
                oAspxHelper.BindGrid(GrdEmployee);

            P_PageNumAfterNav = "1";
            //For All Date
            if (rbDOJ_Specific_All.SelectedItem.Value.ToString() == "A")
            {
                P_FromDOJ = String.Empty;
                P_ToDOJ = String.Empty;
            }
            //}
            //if (WhichCall == "SearchByNavigation")
            //{
            //    //strFromDOJ = oDBEngine.GetDate(BusinessLogicLayer.DBEngine.DateConvertFrom.UTCToOnlyDate, e.Parameters.Split('~')[1]);
            //    //strToDOJ = oDBEngine.GetDate(BusinessLogicLayer.DBEngine.DateConvertFrom.UTCToOnlyDate, e.Parameters.Split('~')[2]);
            //    string strPageNum = String.Empty;
            //    string strNavDirection = String.Empty;
            //    int PageNumAfterNav = 0;
            //    strPageNum = e.Parameters.Split('~')[3];
            //    strNavDirection = e.Parameters.Split('~')[4];

            //    //Set Page Number
            //    if (strNavDirection == "RightNav")
            //        PageNumAfterNav = Convert.ToInt32(strPageNum) + 10;
            //    if (strNavDirection == "LeftNav")
            //        PageNumAfterNav = Convert.ToInt32(strPageNum) - 10;
            //    if (strNavDirection == "PageNav")
            //        PageNumAfterNav = Convert.ToInt32(strPageNum);

            //    Ds_Global = new DataSet();

            //    //When Show Filter Active With SearchString
            //    //Then Grid Bind With SearchString Cretaria
            //    //other normally as it bind
            //    if (P_ShowFilter_SearchString != null)
            //        if (P_ShowFilter_SearchString.ToString() != String.Empty)
            //            Ds_Global = Fetch_EmployeeData(P_FromDOJ == "" ? "1900-01-01" : P_FromDOJ, P_ToDOJ == "" ? "9999-12-31" : P_ToDOJ, P_PageSize,
            //                        PageNumAfterNav.ToString(), "", "", "", "S", "Y", P_ShowFilter_SearchString.ToString());
            //        else
            //            Ds_Global = Fetch_EmployeeData(strFromDOJ == "" ? "1900-01-01" : strFromDOJ, strToDOJ == "" ? "9999-12-31" : strToDOJ, P_PageSize,
            //                        PageNumAfterNav.ToString(), strSearchString, strSearchBy, strFindOption, "S", "N", String.Empty);
            //    else
            //        Ds_Global = Fetch_EmployeeData(strFromDOJ == "" ? "1900-01-01" : strFromDOJ, strToDOJ == "" ? "9999-12-31" : strToDOJ, P_PageSize,
            //                    PageNumAfterNav.ToString(), strSearchString, strSearchBy, strFindOption, "S", "N", String.Empty);

            //    if (Ds_Global.Tables.Count > 0)
            //    {
            //        if (Ds_Global.Tables[0].Rows.Count > 0)
            //        {
            //            TotalItems = Convert.ToInt32(Ds_Global.Tables[0].Rows[0]["TotalRecord"].ToString());
            //            TotalPage = TotalItems % Convert.ToInt32(P_PageSize) == 0 ? (TotalItems / Convert.ToInt32(P_PageSize)) : (TotalItems / Convert.ToInt32(P_PageSize)) + 1;
            //            //GrdEmployee.JSProperties["cpPagerSetting"] = strPageNum + "~" + TotalPage + "~" + TotalItems;
            //            oAspxHelper.BindGrid(GrdEmployee, Ds_Global);
            //            GrdEmployee.JSProperties["cpRefreshNavPanel"] = strNavDirection + '~' + strPageNum + '~' + TotalPage.ToString() + '~' + TotalItems.ToString();
            //        }
            //        else
            //            oAspxHelper.BindGrid(GrdEmployee);
            //    }
            //    else
            //        oAspxHelper.BindGrid(GrdEmployee);

            //    P_PageNumAfterNav = PageNumAfterNav.ToString();
            //}
            if (WhichCall == "ExcelExport")
            {
                GrdEmployee.JSProperties["cpExcelExport"] = "T";
            }
            if (WhichCall == "ShowHideFilter")
            {
                if (e.Parameters.Split('~')[3] == "s")
                    GrdEmployee.Settings.ShowFilterRow = true;

                if (e.Parameters.Split('~')[3] == "All")
                {
                    GrdEmployee.FilterExpression = string.Empty;
                    P_ShowFilter_SearchString = null; //Close Search Cretaria When All Record Show filter On
                    GrdEmployee.JSProperties["cpCallOtherWhichCallCondition"] = "Show";//Reset On Starting Position
                }
            }

            //Assing Value in Properties(Contain Session) To Maintain Call Back Value To Be Used On Server Side Events
            P_FromDOJ = strFromDOJ;
            P_ToDOJ = strToDOJ;
            P_SearchString = strSearchString;
            P_FindOption = strFindOption;
            P_SearchBy = strSearchBy;

            //Dispose Object
            if (Ds_Global != null)
                Ds_Global.Dispose();

            // Page.ClientScript.RegisterStartupScript(GetType(), "PageLD", "<script>Pageload();</script>");

        }
        //protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    Ds_Global = new DataSet();
        //    string strSearchString = String.Empty,
        //       strSearchBy = String.Empty, strFindOption = String.Empty;
        //    if (Rb_SearchBy.SelectedItem.Value.ToString() != "N")
        //    {
        //        if (Rb_SearchBy.SelectedItem.Value.ToString() == "EN")
        //        {
        //            strSearchString = txtEmpName.Text;
        //            strSearchBy = "EN";
        //            strFindOption = cmbEmpNameFindOption.SelectedItem.Value.ToString();
        //        }
        //        else
        //        {
        //            strSearchString = txtEmpCode.Text;
        //            strSearchBy = "EC";
        //            strFindOption = cmbEmpCodeFindOption.SelectedItem.Value.ToString();
        //        }
        //    }

        //    if (P_ShowFilter_SearchString != null)
        //        if (P_ShowFilter_SearchString.ToString() != String.Empty)
        //            Ds_Global = Fetch_EmployeeData(P_FromDOJ == "" ? "1900-01-01" : P_FromDOJ, P_ToDOJ == "" ? "9999-12-31" : P_ToDOJ, "0",
        //                        "0", strSearchString, strSearchBy, strFindOption, "E", "Y", P_ShowFilter_SearchString.ToString());
        //        else
        //            Ds_Global = Fetch_EmployeeData(P_FromDOJ == "" ? "1900-01-01" : P_FromDOJ, P_ToDOJ == "" ? "9999-12-31" : P_ToDOJ, "0",
        //                        "0", strSearchString, strSearchBy, strFindOption, "E", "N", String.Empty);
        //    else
        //        Ds_Global = Fetch_EmployeeData(P_FromDOJ == "" ? "1900-01-01" : P_FromDOJ, P_ToDOJ == "" ? "9999-12-31" : P_ToDOJ, "0",
        //                    "0", strSearchString, strSearchBy, strFindOption, "E", "N", String.Empty);
        //    ExportToExcel(Ds_Global, P_FromDOJ, P_ToDOJ, strSearchString, strSearchBy, strFindOption);

        //    //Dispose Object
        //    if (Ds_Global != null)
        //        Ds_Global.Dispose();

        //}

        #endregion

        //protected void GrdEmployee_ProcessColumnAutoFilter(object sender, ASPxGridViewAutoFilterEventArgs e)
        //{
        //    if (P_ShowFilter_SearchString != null)
        //        if (P_ShowFilter_SearchString.ToString().Trim() != String.Empty)
        //            P_ShowFilter_SearchString = null;

        //    Ds_Global = new DataSet();
        //    int TotalItems = 0;
        //    int TotalPage = 0;
        //    //For All Date
        //    if (rbDOJ_Specific_All.SelectedItem.Value.ToString() == "A")
        //    {
        //        P_FromDOJ = String.Empty;
        //        P_ToDOJ = String.Empty;
        //    }
        //    if (P_ShowFilter_SearchString != null)
        //    {
        //        if (P_ShowFilter_SearchString.ToString().Trim() != String.Empty)
        //            P_ShowFilter_SearchString = P_ShowFilter_SearchString.ToString().Trim() + " And " + e.Criteria.ToString().Trim();
        //        else
        //            P_ShowFilter_SearchString = e.Criteria.ToString().Trim();
        //    }
        //    else
        //        P_ShowFilter_SearchString = e.Criteria.ToString().Trim();

        //    Ds_Global = Fetch_EmployeeData(P_FromDOJ == "" ? "1900-01-01" : P_FromDOJ, P_ToDOJ == "" ? "9999-12-31" : P_ToDOJ, P_PageSize,
        //           P_PageNumAfterNav, "", "", "", "S", "Y", P_ShowFilter_SearchString.ToString());

        //    if (Ds_Global.Tables.Count > 0)
        //    {
        //        if (Ds_Global.Tables[0].Rows.Count > 0)
        //        {
        //            TotalItems = Convert.ToInt32(Ds_Global.Tables[0].Rows[0]["TotalRecord"].ToString());
        //            TotalPage = TotalItems % Convert.ToInt32(P_PageSize) == 0 ? (TotalItems / Convert.ToInt32(P_PageSize)) : (TotalItems / Convert.ToInt32(P_PageSize)) + 1;
        //            oAspxHelper.BindGrid(GrdEmployee, Ds_Global);
        //            //Here I Passed ShowBtnClick Parameter Cause It ReInitialize Grid Like Show Button Functionality
        //            GrdEmployee.JSProperties["cpRefreshNavPanel"] = "ShowBtnClick" + '~' + P_PageNumAfterNav + '~' + TotalPage.ToString() + '~' + TotalItems.ToString();
        //        }
        //        else
        //            oAspxHelper.BindGrid(GrdEmployee);
        //    }
        //    else
        //        oAspxHelper.BindGrid(GrdEmployee);

        //    //Dispose Object
        //    if (Ds_Global != null)
        //        Ds_Global.Dispose();


        //}
        public void bindexport(int Filter)
        {
            //Code  Added and Commented By Priti on 21122016 to use Export Header,date
            GrdEmployee.Columns[10].Visible = false;
            string filename = "Employees";
            exporter.FileName = filename;

            exporter.PageHeader.Left = "Employees";
            exporter.MaxColumnWidth = 70;
            // exporter.LeftMargin = 0;
            // exporter.Styles.Cell.Font.Size = 8;
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
            //bindUserGroups();           
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            //Code  Added and Commented By Priti on 21122016 to use Export Header,date
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
        protected void WriteToResponse(string fileName, bool saveAsFile, string fileFormat, MemoryStream stream)
        {
            if (Page == null || Page.Response == null) return;
            string disposition = saveAsFile ? "attachment" : "inline";
            Page.Response.Clear();
            Page.Response.Buffer = false;
            Page.Response.AppendHeader("Content-Type", string.Format("application/{0}", fileFormat));
            Page.Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Page.Response.AppendHeader("Content-Disposition", string.Format("{0}; filename={1}.{2}", disposition, HttpUtility.UrlEncode(fileName).Replace("+", "%20"), fileFormat));
            if (stream.Length > 0)
                Page.Response.BinaryWrite(stream.ToArray());
            //Page.Response.End();
        }
        protected void SelectPanel_Callback(object sender, CallbackEventArgsBase e)
        {
            //string a = "";


            string strSplitCommand = e.Parameter.Split('~')[0];
            string strEmpId = e.Parameter.Split('~')[1];
            hdnContactId.Value = strEmpId;
            if (strSplitCommand == "Bindalldesignes")
            {

                SelectPanel.JSProperties["cpResult"] = "";
                DataSet ds = new DataSet();
                ProcedureExecute proc = new ProcedureExecute("Fetch_Employee_DataSet");
                proc.AddVarcharPara("@Action", 500, "FetchEmployeeData");
                //  proc.AddVarcharPara("@IBRef", 200, Convert.ToString(Session["IBRef"]));
                proc.AddVarcharPara("@EmpCode", 200, strEmpId);
                ds = proc.GetDataSet();


                if (ds.Tables[0].Rows.Count > 0)
                {
                    CmbDesignName.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0]["emp_IsDeActive"]);
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        TxtReason.Text = Convert.ToString(ds.Tables[1].Rows[0]["emp_ReasonOfDeactivate"]);
                    }
                    else
                    {
                        TxtReason.Text = "";
                    }

                }
                else
                {
                    CmbDesignName.Checked = false;
                }

            }
            else if (strSplitCommand == "SaveDetails")
            {

                string strReason = "";
                bool strActivation = Convert.ToBoolean(CmbDesignName.Value);
                if (strActivation)
                {
                    strReason = Convert.ToString(TxtReason.Text);
                }
                string strUser = Convert.ToString(HttpContext.Current.Session["userid"]);
                DataSet ds = new DataSet();
                ProcedureExecute proc = new ProcedureExecute("Fetch_Employee_DataSet");
                proc.AddVarcharPara("@Action", 500, "SaveEmployeeData");
                proc.AddVarcharPara("@UserId", 200, strUser);
                proc.AddVarcharPara("@EmpCode", 200, strEmpId);
                proc.AddBooleanPara("@IsActive", strActivation);
                proc.AddVarcharPara("@Reason", 200, strReason);
                ds = proc.GetDataSet();


                if (Convert.ToString(ds.Tables[0].Rows[0]["Result"]) == "Success")
                {
                    SelectPanel.JSProperties["cpResult"] = "Success";
                }
                else if (Convert.ToString(ds.Tables[0].Rows[0]["Result"]) == "Problem")
                {
                    SelectPanel.JSProperties["cpResult"] = "Problem";
                }
            }

        }



        SalesPersontracking ob = new SalesPersontracking();

        public void GetemployeeSupervisor()
        {
            try
            {

                DataTable dtfromtosumervisor = ob.FetchEmployeeFTS("Past");

                fromsuper.DataSource = dtfromtosumervisor;
                fromsuper.DataTextField = "Name";
                fromsuper.DataValueField = "Id";
                fromsuper.DataBind();

                DataTable dtfromtosumervisornew = ob.FetchEmployeeFTS("New");
                tosupervisor.DataSource = dtfromtosumervisornew;
                tosupervisor.DataTextField = "Name";
                tosupervisor.DataValueField = "Id";
                tosupervisor.DataBind();
            }
            catch(Exception ex)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "PageLD", ex.Message);

            }
        }


        [WebMethod]
        public  static string Submitsupervisor(string fromsuper,string tosuper)
        {
    
            DataTable dtfromtosumervisor = SalesPersontracking.SubmitSupervisorEmployeeFTS(fromsuper, tosuper, Convert.ToString(HttpContext.Current.Session["userid"]));
            
            return fromsuper;
        }
        
    }

}


