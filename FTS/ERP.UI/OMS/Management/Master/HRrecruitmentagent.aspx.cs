using System;
using System.Web;
using System.Web.UI;
using DevExpress.Web;
using BusinessLogicLayer;
using EntityLayer.CommonELS;

namespace ERP.OMS.Management.Master
{
    public partial class management_master_HRrecruitmentagent : ERP.OMS.ViewState_class.VSPage //System.Web.UI.Page
    {
        public string pageAccess = "";
        //DBEngine oDBEngine = new DBEngine(string.Empty);
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();

        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //'http://localhost:2957/InfluxCRM/management/testProjectMainPage_employee.aspx'
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);
                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            // rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/HRrecruitmentagent.aspx");
            //if (HttpContext.Current.Session["userid"] == null)
            //{
            //   //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            //}
            //Session["requesttype"] = Request.QueryString["id"].ToString();


            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/HRrecruitmentagent.aspx?requesttype=VendorService");

            if (HttpContext.Current.Session["userid"] != null)
            {
                if (!IsPostBack)
                {


                    EmployeeGrid.SettingsCookies.CookiesID = "BreeezeErpGridCookiesHRrecruitmentagentEmployeeGrid";

                    this.Page.ClientScript.RegisterStartupScript(GetType(), "setCookieOnStorage", "<script>addCookiesKeyOnStorage('BreeezeErpGridCookiesHRrecruitmentagentEmployeeGrid');</script>");
                    Session["exportval"] = null;

                    //---------------------------------------------------------------------------
                    CommonBL cbl = new CommonBL();
                    string ISLigherpage = cbl.GetSystemSettingsResult("LighterVendorEntryPage");
                    if (!String.IsNullOrEmpty(ISLigherpage))
                    {
                        if (ISLigherpage == "Yes")
                        {
                            hidIsLigherContactPage.Value = "1";                            
                        }
                    } 
                    //--------------------------------------------------------------------------



                    //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>"); 
                    //string requesttype = Convert.ToString(Request.QueryString["requesttype"]);
                    //string ContType = "";
                    //switch (requesttype)
                    //{
                    //    case "DataVendor":
                    //        ContType = "Data Vendor";
                    //        rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/HRrecruitmentagent.aspx?requesttype=DataVendor");
                    //        break;
                    //    case "VendorService":
                    //        ContType = "Vendor Service Provider";
                    //        rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Master/HRrecruitmentagent.aspx?requesttype=VendorService");
                    //        break;
                    //}
                    //Session["requesttype"] = ContType;
                }
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
            

            //Comment By sanjib due to validate branchwise 1612017
            //EmployeeDataSource.SelectCommand = "select tbl_master_contact.cnt_id AS cnt_Id,tbl_master_contact.cnt_internalId AS Id, tbl_master_branch.branch_description AS BranchName,ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') AS Name, (select top 1 case when phf_phoneNumber is null then '' else '(O)'+ phf_phoneNumber end from tbl_master_phonefax where phf_cntId=tbl_master_contact.cnt_internalId ) AS phone from tbl_master_contact INNER JOIN tbl_master_branch ON tbl_master_contact.cnt_branchid = tbl_master_branch.branch_id where cnt_internalId like '" + Request.QueryString["id"] + "%'";            
            // rev 1.0.1 discuss with Sandip internal_id which is now not relevent 20-2-2017
            //EmployeeDataSource.SelectCommand = "select tbl_master_contact.cnt_id AS cnt_Id,tbl_master_contact.cnt_internalId AS Id,tbl_master_branch.branch_description AS BranchName,ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') AS Name, (select top 1 case when phf_phoneNumber is null then '' else '(O)'+ phf_phoneNumber end from tbl_master_phonefax where phf_cntId=tbl_master_contact.cnt_internalId ) AS phone  from tbl_master_contact INNER JOIN tbl_master_branch ON tbl_master_contact.cnt_branchid = tbl_master_branch.branch_id where  cnt_contacttype='DV' and cnt_internalId like '" + Request.QueryString["id"] + "%' and cnt_branchid in(" + HttpContext.Current.Session["userbranchHierarchy"] + ")";
            //End--

            //EmployeeDataSource.SelectCommand = "select tbl_master_contact.cnt_id AS cnt_Id,tbl_master_contact.cnt_internalId AS Id,tbl_master_branch.branch_description AS BranchName,ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') AS Name, (select top 1 case when phf_phoneNumber is null then '' else '(O)'+ phf_phoneNumber end from tbl_master_phonefax where phf_cntId=tbl_master_contact.cnt_internalId ) AS phone  from tbl_master_contact INNER JOIN tbl_master_branch ON tbl_master_contact.cnt_branchid = tbl_master_branch.branch_id where  cnt_contacttype='DV' and  cnt_branchid in(" + HttpContext.Current.Session["userbranchHierarchy"] + ")";
            EmployeeDataSource.SelectCommand = "select tbl_master_contact.cnt_id AS cnt_Id,tbl_master_contact.cnt_internalId AS Id,tbl_master_branch.branch_description AS BranchName,ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') AS Name,"+
               //" (select top 1 case when phf_phoneNumber is null then '' else '(O)'+ phf_phoneNumber end from tbl_master_phonefax where phf_cntId=tbl_master_contact.cnt_internalId ) AS phone,"+
              " (SELECT DISTINCT STUFF( (select case when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Residence') then ' (R)'+ phf_phoneNumber + ' '  "+
              " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Office') then ' (O)'+ phf_phoneNumber + ' ' "+
                " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Correspondence') then ' (C)'+ phf_phoneNumber + ' ' "+
                " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Mobile') then ' (M)'+ phf_phoneNumber + ' '"+
                " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Fax') then ' (F)'+ phf_phoneNumber + ' ' else '' end "+
                " from tbl_master_phonefax where phf_cntId=tbl_master_contact.cnt_internalId FOR XML PATH('')),1,1,'') as Numbers FROM tbl_master_phonefax) as phone,"+
               "cnt_shortName as Unique_ID,(Select cntstu_contactStatus from tbl_master_contactstatus where cntstu_id=cnt_contactStatus) as Status,cnt_PrintNameToCheque,CNT_GSTIN gstin,AG.AccountGroup_Name " +
            "from tbl_master_contact left JOIN tbl_master_branch ON tbl_master_contact.cnt_branchid = tbl_master_branch.branch_id left join master_AccountGroup AG on tbl_master_contact.AccountGroupID=AG.AccountGroup_ReferenceID   where  cnt_contacttype='DV'  order by cnt_id desc";

            //Bellow line commented by debjyoti 
            //Reason: On this page id is always null, for this reason request type become blank             
            //     Session["requesttype"] = Convert.ToString(Request.QueryString["id"]);
            Session["requesttype"] = "DV";
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
        public void bindexport(int Filter)
        {
            EmployeeGrid.Columns[3].Visible = false;
            string filename = "Vendors/Service Providers";
            exporter.FileName = filename;

            exporter.PageHeader.Left = "Vendors/Service Providers";
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
        protected void EmployeeGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            EmployeeGrid.ClearSort();
            EmployeeGrid.DataBind();
            if (e.Parameters == "s")
                EmployeeGrid.Settings.ShowFilterRow = true;


            //-----------------------------------
            string WhichCall = Convert.ToString(e.Parameters).Split('~')[0];
            string WhichType = null;
            int deletecnt = 0;
            if (Convert.ToString(e.Parameters).Contains("~"))
            {
                if (Convert.ToString(e.Parameters).Split('~')[1] != "")
                {
                    WhichType = Convert.ToString(e.Parameters).Split('~')[1];

                }
                if (WhichCall == "Delete")
                {
                    MasterDataCheckingBL objMasterDataCheckingBL = new MasterDataCheckingBL();

                    deletecnt = objMasterDataCheckingBL.DeleteLeadOrContact(WhichType);
                    if (deletecnt > 0)
                    {

                        EmployeeGrid.JSProperties["cpDelete"] = "Success";
                        //EmployeeDataSource.SelectCommand = "select tbl_master_contact.cnt_id AS cnt_Id,tbl_master_contact.cnt_internalId AS Id,tbl_master_branch.branch_description AS BranchName,ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') AS Name, (select top 1 case when phf_phoneNumber is null then '' else '(O)'+ phf_phoneNumber end from tbl_master_phonefax where phf_cntId=tbl_master_contact.cnt_internalId ) AS phone  from tbl_master_contact INNER JOIN tbl_master_branch ON tbl_master_contact.cnt_branchid = tbl_master_branch.branch_id where  cnt_contacttype='DV'  order by cnt_id desc";

                        EmployeeDataSource.SelectCommand = "select tbl_master_contact.cnt_id AS cnt_Id,tbl_master_contact.cnt_internalId AS Id,tbl_master_branch.branch_description AS BranchName,ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') AS Name," +                           
                         " (SELECT DISTINCT STUFF( (select case when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Residence') then ' (R)'+ phf_phoneNumber + ' '  " +
                         " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Office') then ' (O)'+ phf_phoneNumber + ' ' " +
                           " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Correspondence') then ' (C)'+ phf_phoneNumber + ' ' " +
                           " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Mobile') then ' (M)'+ phf_phoneNumber + ' '" +
                           " when (ISNULL(phf_phoneNumber,'')!='' And phf_type='Fax') then ' (F)'+ phf_phoneNumber + ' ' else '' end " +
                           " from tbl_master_phonefax where phf_cntId=tbl_master_contact.cnt_internalId FOR XML PATH('')),1,1,'') as Numbers FROM tbl_master_phonefax) as phone," +
                          "cnt_shortName as Unique_ID,(Select cntstu_contactStatus from tbl_master_contactstatus where cntstu_id=cnt_contactStatus) as Status,cnt_PrintNameToCheque,CNT_GSTIN gstin  from tbl_master_contact INNER JOIN tbl_master_branch ON tbl_master_contact.cnt_branchid = tbl_master_branch.branch_id where  cnt_contacttype='DV'  order by cnt_id desc";
                        
                        
                        EmployeeGrid.DataBind();
                    }
                    else
                        EmployeeGrid.JSProperties["cpDelete"] = "Fail";
                }
            }

            //-----------------------------------






            if (e.Parameters == "All")
            {
                EmployeeGrid.FilterExpression = string.Empty;
            }
        }
    }
}