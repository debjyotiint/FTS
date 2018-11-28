using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using BusinessLogicLayer;
using ClsDropDownlistNameSpace;
using System.Drawing;
using System.Web.Services;
using System.Collections.Generic;
using UtilityLayer;
using BusinessLogicLayer.SalesERP;
namespace ERP.OMS.Management.Master
{
    public partial class management_master_RootUserDetails : ERP.OMS.ViewState_class.VSPage
    {

        string Id;
        int CreateUser;
        DateTime CreateDate;

        //DBEngine oDBEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);

        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        clsDropDownList oclsDropDownList = new clsDropDownList();
       
        public string pageAccess = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Code  Added and Commented By Priti on 20122016 to use Covert.Tostring() instead of Tostring()
            //txtReportTo.Attributes.Add("onkeyup", "CallList(this,'SearchByEmpCont',event)");
            //txtReportTo.Attributes.Add("onfocus", "CallList(this,'SearchByEmpCont',event)");
            //txtReportTo.Attributes.Add("onkeyup", "CallList(this,'SearchByEmpCont',event)");
            //txtReportTo.Attributes.Add("onfocus", "CallList(this,'SearchByEmp',event)");
            //txtReportTo.Attributes.Add("onclick", "CallList(this,'SearchByEmp',event)");
            if (HttpContext.Current.Session["userid"] == null)
            {
                //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }

            Id = Request.QueryString["id"];
            // Code Added By Sandip on 22032017 to use Query String Value in Web Method for Chosen DropDown
            ActionMode = Request.QueryString["id"];
            // Code  Above Added By Sandip on 22032017 to use Query String Value in Web Method for Chosen DropDown
            CreateUser = Convert.ToInt32(HttpContext.Current.Session["userid"]);//Session UserID
            CreateDate = Convert.ToDateTime(oDBEngine.GetDate().ToShortDateString());
            if (!IsPostBack)
            {
                EntityLayer.CommonELS.UserRightsForPage rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/master/root_user.aspx");
                Session["addedituser"] = "yes";
                // FillComboContact();
                BindUserGroups();
                FillComboBranch();
                Fillgridview();
                if (Id != "Add")
                {
                    //brnChangeUsersPassword.Visible = true;
                    if (!rights.CanEdit)
                    {
                        Response.Redirect("/OMS/Management/master/root_user.aspx");
                    }
                    ShowData(Id);                   
                    txtusername.Enabled = false;
                }
                else
                {
                    //brnChangeUsersPassword.Visible = false;
                    if (!rights.CanAdd)
                    {
                        Response.Redirect("/OMS/Management/master/root_user.aspx");
                    }
                }
              
                //if (HttpContext.Current.Session["superuser"].ToString().Trim() == "Y")
                if (Convert.ToString(HttpContext.Current.Session["superuser"]).Trim() == "Y")
                { 
                    cbSuperUser.Visible = true;
                }
                else
                {
                    cbSuperUser.Visible = false;
                }
                    

            }
            /*--Set Page Accesss--*/
            string pageAccess = oDBEngine.CheckPageAccessebility("root_user.aspx");
            Session["PageAccess"] = pageAccess;
            //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");
        }

        private void BindUserGroups()
        {
            ddlGroups.Items.Clear();

            DataTable dt = new BusinessLogicLayer.UserGroupsBLS.UserGroupBL().FetchAllGroupsDataTable();

            if (dt != null && dt.Rows.Count > 0)
            {
                ddlGroups.DataSource = dt;
                ddlGroups.DataTextField = "grp_name";
                ddlGroups.DataValueField = "grp_id";
                ddlGroups.DataBind();
            }

            ddlGroups.Items.Insert(0, "Select Group");
        }

        /*Code  Added  By Priti on 06122016 to use jquery Choosen*/
        [WebMethod]
        public static List<string> ALLEmployee(string reqStr)
        {
           
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
            DataTable DT = new DataTable();
            DT.Rows.Clear();
            UserBL objUserBL = new UserBL();
            if (ActionMode == "Add")
            {
                //DT = oDBEngine.GetDataTable("tbl_master_employee, tbl_master_contact,tbl_trans_employeeCTC ", "ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') +'['+cnt_shortName+']' AS Name, cnt_internalId as Id    ", " tbl_master_employee.emp_contactId = tbl_trans_employeeCTC.emp_cntId and tbl_trans_employeeCTC.emp_cntId = tbl_master_contact.cnt_internalId    and cnt_contactType='EM' and (emp_dateofLeaving is null or emp_dateofLeaving='1/1/1900 12:00:00 AM' OR emp_dateofLeaving>getdate()) and (cnt_firstName Like '" + reqStr + "%' or cnt_shortName like '" + reqStr + "%')");
                //DT = oDBEngine.GetDataTable("tbl_master_employee, tbl_master_contact,tbl_trans_employeeCTC ", " ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') +'['+cnt_shortName+']' AS Name, cnt_internalId as Id ", " tbl_master_employee.emp_contactId = tbl_trans_employeeCTC.emp_cntId and tbl_trans_employeeCTC.emp_cntId = tbl_master_contact.cnt_internalId  and cnt_contactType='EM' and (emp_dateofLeaving is null or emp_dateofLeaving='1/1/1900 12:00:00 AM' OR emp_dateofLeaving>getdate()) and (cnt_firstName Like '" + reqStr + "%' or cnt_shortName like '" + reqStr + "%') and tbl_master_contact.cnt_internalId not in (select user_contactId from tbl_master_user) group by tbl_trans_employeeCTC.emp_id,ISNULL(cnt_firstName, '') + ' ' + ISNULL(cnt_middleName, '') + ' ' + ISNULL(cnt_lastName, '') +'['+cnt_shortName+']' , cnt_internalId   having  max(tbl_trans_employeeCTC.emp_id) in (select MAX(tbl_trans_employeeCTC.emp_id)from tbl_trans_employeeCTC group by emp_cntId)");
                DT = objUserBL.PopulateAssociatedEmployee(0, "Add");
            }
            else
            {
                DT = objUserBL.PopulateAssociatedEmployee(Convert.ToInt32(ActionMode), "Edit");
            }
            if (DT.Rows.Count > 0)
            {

                List<string> obj = new List<string>();
                foreach (DataRow dr in DT.Rows)
                {

                    obj.Add(Convert.ToString(dr["Name"]) + "|" + Convert.ToString(dr["Id"]));
                }

                return obj;
            }
            else
            {
                return null;
            }

        }
        //...............code end........




        //protected void FillComboContact()
        //{
        //    //DBEngine objEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        //    string[,] Data = oDBEngine.GetFieldValue("tbl_master_contact", "cnt_internalId AS Id, cnt_firstName + ' ' + ISNULL(cnt_lastName,'') + '[' + ISNULL(cnt_shortName,'') + ']'  AS Name", "cnt_contacttype='EM'", 2, " cnt_FirstName ");
        //    oDBEngine.AddDataToDropDownList(Data, drpContact);
        //}
        protected void FillComboBranch()
        {
            //DBEngine objEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string[,] DataBranch = oDBEngine.GetFieldValue("tbl_master_branch", "branch_id, branch_description", null, 2);
            //oDBEngine.AddDataToDropDownList(DataBranch, dropdownlistbranch);
            oclsDropDownList.AddDataToDropDownList(DataBranch, dropdownlistbranch);
        }
        protected void Fillgridview()
        {
            //DBEngine objEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataSet dsDocument = new DataSet();
            dsDocument = oDBEngine.PopulateData("seg_id as Id, seg_name as SegmentName", "tbl_master_segment", null);
            if (dsDocument.Tables["TableName"].Rows.Count > 0)
            {
                grdUserAccess.DataSource = dsDocument.Tables["TableName"];
                grdUserAccess.DataBind();
            }

        }
        protected void grdUserAccess_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //DBEngine objEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DropDownList drpUserGroup = (DropDownList)e.Row.FindControl("drpUserGroup");
                Label lbl = (Label)e.Row.FindControl("lblId");
                string[,] DatadropDown = oDBEngine.GetFieldValue("tbl_master_userGroup", "grp_id, grp_name", "grp_segmentId='" + lbl.Text + "'", 2, "grp_name");
                string checkId1 = DatadropDown[0, 0];
                if (checkId1 != "n")
                {
                    //oDBEngine.AddDataToDropDownList(DatadropDown, drpUserGroup);
                    oclsDropDownList.AddDataToDropDownList(DatadropDown, drpUserGroup);
                }
            }
        }
        protected void ShowData(string Id)
        {
            // Code  Added and Commented By Priti on 20122016 to use Covert.Tostring() instead of Tostring()
            //DBEngine objEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            user_password.Visible = false;
            Int16 userId = Convert.ToInt16(Id);
            DataSet dsUserDetail = new DataSet();
            dsUserDetail = oDBEngine.PopulateData("u.user_name as user1 , u.user_loginId as Login,u.user_branchId as Branchid,u.user_group as usergroup,u.user_AllowAccessIP,u.user_contactId as ContactId, c.cnt_firstName + ' ' +c.cnt_lastName+'['+c.cnt_shortName+']' AS Name,c.cnt_internalId,c.cnt_id,u.user_id,u.user_superUser ,u.user_inactive,u.user_maclock,u.user_EntryProfile", "tbl_master_user u,tbl_master_contact c", "u.user_id='" + userId + "' AND u.user_contactId=c.cnt_internalId");
            if (dsUserDetail.Tables["TableName"].Rows.Count > 0)
            {
                //txtusername.Text = dsUserDetail.Tables["TableName"].Rows[0]["user1"].ToString();
                txtusername.Text = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["user1"]);
                //txtloginid.Text = dsUserDetail.Tables["TableName"].Rows[0]["Login"].ToString();
                txtuserid.Text = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["Login"]);

                //txtReportTo.Text = dsUserDetail.Tables["TableName"].Rows[0]["Name"].ToString();
                //txtReportTo_hidden.Value = dsUserDetail.Tables["TableName"].Rows[0]["cnt_internalId"].ToString();
                txtReportTo_hidden.Value = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["cnt_internalId"]);

                //dropdownlistbranch.SelectedValue = dsUserDetail.Tables["TableName"].Rows[0]["Branchid"].ToString();
                dropdownlistbranch.SelectedValue = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["Branchid"]);
                //string usergroup = dsUserDetail.Tables["TableName"].Rows[0]["usergroup"].ToString();
                string usergroup = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["usergroup"]);
                try
                {
                    ddlGroups.SelectedValue = usergroup.Trim();
                }
                catch
                {
                    ddlGroups.SelectedIndex = 0;
                }
                // hdncontactId.Value = dsUserDetail.Tables["TableName"].Rows[0]["ContactId"].ToString();
                //txtReportTo_hidden.Value = dsUserDetail.Tables["TableName"].Rows[0]["ContactId"].ToString();
                txtReportTo_hidden.Value = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["ContactId"]);
                //ddDataEntry.SelectedValue = dsUserDetail.Tables["TableName"].Rows[0]["user_EntryProfile"].ToString();
                ddDataEntry.SelectedValue = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["user_EntryProfile"]);
                selectedValue(usergroup);
                //if (dsUserDetail.Tables["TableName"].Rows[0]["user_superUser"].ToString().Trim() == "Y")
                if (Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["user_superUser"]).Trim() == "Y")
                { 
                    cbSuperUser.Checked = true;
                }
                else
                {
                    cbSuperUser.Checked = false;
                }
                    

                //if (dsUserDetail.Tables["TableName"].Rows[0]["user_inactive"].ToString().Trim() == "Y")
                if (Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["user_inactive"]).Trim() == "Y")
                {
                    chkIsActive.Checked = true;
                }   
                else
                {
                    chkIsActive.Checked = false;
                }

                if (Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["user_maclock"]).Trim() == "Y")
                {
                    chkmac.Checked = true;
                }
                else
                {
                    chkmac.Checked = false;
                }


                if (Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["user_AllowAccessIP"]) != "")
                {
                    string IP = Convert.ToString(dsUserDetail.Tables["TableName"].Rows[0]["user_AllowAccessIP"]);
                    string[] IParray = IP.Split('.');
                    if (IParray.Length == 4)
                    {
                        txtIp1.Text = IParray[0];
                        txtIp2.Text = IParray[1];
                        txtIp3.Text = IParray[2];
                        txtIp4.Text = IParray[3];
                    }
                    if (IParray.Length == 3)
                    {
                        txtIp1.Text = IParray[0];
                        txtIp2.Text = IParray[1];
                        txtIp3.Text = IParray[2];
                    }
                    if (IParray.Length == 2)
                    {
                        txtIp1.Text = IParray[0];
                        txtIp2.Text = IParray[1];
                    }
                    if (IParray.Length == 1)
                    {
                        txtIp1.Text = IParray[0];
                    }
                }
            }

        }
        protected void selectedValue(string str)
        {
            for (int i = 0; i <= grdUserAccess.Rows.Count - 1; i++)
            {
                DropDownList drp = (DropDownList)grdUserAccess.Rows[i].FindControl("drpUserGroup");
                for (int j = 0; j <= drp.Items.Count - 1; j++)
                {
                    string[] s = str.Split(',');
                    for (int k = 0; k < s.Length; k++)
                    {
                        if (s[k].ToString() == drp.Items[j].Value)
                        {
                            CheckBox chk = (CheckBox)grdUserAccess.Rows[i].FindControl("chkSegmentId");
                            chk.Checked = true;
                            drp.SelectedValue = Convert.ToString(drp.Items.FindByValue(s[k].ToString()).Value);
                        }
                    }
                }
            }
        }

        protected void lnkChangePassword_Click(object sender, EventArgs e)
        {
            try
            {
                string ChangePassOfUserId = Convert.ToString(Request.QueryString["id"]);
                Session["ChangePassOfUserid"] = ChangePassOfUserId;
                Response.Redirect("../ToolsUtilities/frmchangeuserspassword.aspx");
            }
            catch { }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string contact;


            //-------------Allow Ip Adress---
            string IP1 = txtIp1.Text.Trim();
            string IP2 = txtIp2.Text.Trim();
            string IP3 = txtIp3.Text.Trim();
            string IP4 = txtIp4.Text.Trim();
            string IPAddress = string.Empty;
             if (IP1 != "")
            {
                IPAddress = IP1;
                if (IP2 != "")
                {
                    IPAddress = IPAddress + "." + IP2;
                    if (IP3 != "")
                    {
                        IPAddress = IPAddress + "." + IP3;
                        if (IP4 != "")
                        {
                            IPAddress = IPAddress + "." + IP4;
                        }
                    }
                }
            }
            //------------------------------



            //if (drpContact.SelectedValue.ToString() != "")
            //{
            //    contact = drpContact.SelectedValue;
            //}
            //else
            //{
            //    contact = hdncontactId.Value.ToString();
            //}

            //if (txtReportTo_hidden.Value.ToString() != "")
             if (txtReportTo_hidden.Value.ToString() != "")
            {
                contact = txtReportTo_hidden.Value;
            }
            else
            {
                contact = txtReportTo_hidden.Value;
            }


            string usergroup = getuserGroup();
            //string[,] grpsegment = oDBEngine.GetFieldValue("tbl_master_userGroup", "top 1 grp_segmentid,grp_name", "grp_id in (" + usergroup.ToString() + ")", 2);
            string[,] grpsegment = oDBEngine.GetFieldValue("tbl_master_userGroup", "top 1 grp_segmentid", "grp_id in (" + usergroup.ToString() + ")", 1);
            string[,] segname = oDBEngine.GetFieldValue("tbl_master_segment", "seg_name", "seg_id='" + grpsegment[0, 0] + "'", 1);
            // string[,] BranchId = oDBEngine.GetFieldValue("tbl_master_contact", "cnt_branchid", " cnt_internalId='" + drpContact.SelectedValue.ToString() + "'", 1);
            string[,] BranchId = oDBEngine.GetFieldValue("tbl_master_contact", "top 1 cnt_branchid", " cnt_internalId='" + txtReportTo_hidden.Value.ToString() + "'", 1);
            string b_id = BranchId[0, 0];
            if (b_id == "n")
            {
                b_id = "1";
            }
            string superuser = "";
            if (cbSuperUser.Checked == true)
                superuser = "Y";
            else
                superuser = "N";

            string isactive = "";
               string isactivemac = "";
            if (chkIsActive.Checked == true)
                isactive = "Y";
            else
                isactive = "N";

              if (chkmac.Checked == true)
                isactivemac = "Y";
            else
                isactivemac = "N";


            if (Id == "Add")
            {
                string[,] checkUser = oDBEngine.GetFieldValue("tbl_master_user", "user_loginId", " user_loginId='" + txtuserid.Text.ToString().Trim() + "'", 1);
                string check = checkUser[0, 0];
                if (check != "n")
                {
                //    txtuserid.Text = "Login Id All Ready Exist !! ";
                //    txtuserid.ForeColor = Color.Red;
                    SalesPersontracking ob = new SalesPersontracking();
                    DataTable dtfromtosumervisor = ob.MobileUserloginIDRellocation(txtuserid.Text.ToString().Trim());


                }

                    if (Convert.ToString(Session["PageAccess"]).Trim() == "All" || Convert.ToString(Session["PageAccess"]).Trim() == "Add" || Convert.ToString(Session["PageAccess"]).Trim() == "DelAdd")
                    {

                      

                        //// Encrypt  the Password
                        Encryption epasswrd = new Encryption();
                        string Encryptpass = epasswrd.Encrypt(txtpassword.Text.Trim());

                        oDBEngine.InsertDataFromAnotherTable(" tbl_master_user ", " user_name,user_branchId,user_loginId,user_password,user_contactId,user_group,CreateDate,CreateUser,user_lastsegement,user_TimeForTickerRefrsh,user_superuser,user_EntryProfile,user_AllowAccessIP,user_inactive,user_maclock", null, "'" + txtusername.Text.Trim() + "','" + b_id + "','" + txtuserid.Text.Trim() + "','" + Encryptpass + "','" + contact + "','" + usergroup + "','" + CreateDate.ToString() + "','" + CreateUser + "',( select top 1 grp_segmentId from tbl_master_userGroup where grp_id in(" + usergroup + ")),86400,'" + superuser + "','" + ddDataEntry.SelectedItem.Value + "','" + IPAddress.Trim() + "','" + isactive + "','" + isactivemac + "'", null);
                        string[,] userid = oDBEngine.GetFieldValue("tbl_master_user", "max(user_id)", null, 1);
                     
                        
                        //oDBEngine.InsertDataFromAnotherTable(" tbl_master_user ", " user_name,user_branchId,user_loginId,user_password,user_contactId,user_group,CreateDate,CreateUser,user_lastsegement,user_TimeForTickerRefrsh,user_superuser,user_EntryProfile,user_AllowAccessIP,user_inactive", null, "'" + txtusername.Text.Trim() + "','" + b_id + "','" + txtloginid.Text.Trim() + "','" + txtpassword.Text.Trim() + "','" + contact + "','" + usergroup + "','" + CreateDate.ToString() + "','" + CreateUser + "',( select top 1 grp_segmentId from tbl_master_userGroup where grp_id in(" + usergroup + ")),86400,'" + superuser + "','" + ddDataEntry.SelectedItem.Value + "','" + IPAddress.Trim() + "','" + isactive + "'", null);
                        //string[,] userid = oDBEngine.GetFieldValue("tbl_master_user", "max(user_id)", null, 1);


                      
                            
                                string splitsegname = segname[0, 0].Split('-')[0].ToString().Trim();
                             // string splitsegname1 = segname[0, 0].Split('-')[1].ToString().Trim(); 
                            
                                string[,] exchsegid = oDBEngine.GetFieldValue("Master_Exchange", "top 1 Exchange_Id", "Exchange_ShortName='" + splitsegname + "'",1);
                                
                        // Jitendra- Need to work in Financial year validation, this time removed it temporarly
                        //string[,] finyr = oDBEngine.GetFieldValue("Master_FinYear", "top 1 FinYear_Code", "Getdate() between FinYear_StartDate and FinYear_EndDate", 1);
                               // string[,] finyr = oDBEngine.GetFieldValue("Master_FinYear", "top 1 FinYear_Code", null, 1);

                                string FinancialYear = GetFinancialYear();



                        string[,] exhCntID = oDBEngine.GetFieldValue("Tbl_Master_Exchange", "top 1 exh_CntID", "Exh_ShortName= '" + splitsegname.ToString().Trim() + "'", 1);
                                //  string[,] exchmaster = oDBEngine.GetFieldValue("Master_ExchangeSegments", "top 1 exchangesegment_id", "Exchangesegment_code='" + splitsegname1 + "'", 1);
                                //  string[,] settno = oDBEngine.GetFieldValue("Master_Settlements", "top 1 Settlements_Number", "Settlements_ExchangeSegmentID='" + exchmaster[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "'   and Settlements_StartDateTime=(Select Max(Settlements_StartDateTime) from Master_Settlements Where Settlements_ExchangeSegmentID='" + exchmaster[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "'  ) ", 1);                                
                                //string[,] settno1 = oDBEngine.GetFieldValue("Master_Settlements", "top 1 Settlements_Number", "Settlements_ExchangeSegmentID='" + exchsegid[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "' and Settlements_TypeSuffix='W'  and Settlements_StartDateTime=(Select Max(Settlements_StartDateTime) from Master_Settlements Where Settlements_ExchangeSegmentID='" + exchsegid[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "' and Settlements_TypeSuffix='W' ) ", 1);
                                //string[,] settno2 = oDBEngine.GetFieldValue("Master_Settlements", "top 1 Settlements_Number", "Settlements_ExchangeSegmentID='" + exchsegid[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "' and Settlements_TypeSuffix='F'  and Settlements_StartDateTime=(Select Max(Settlements_StartDateTime) from Master_Settlements Where Settlements_ExchangeSegmentID='" + exchsegid[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "' and Settlements_TypeSuffix='F' ) ", 1);
                                // string[,] settno = oDBEngine.GetFieldValue("Master_Settlements", "top 1 Settlements_Number", "Settlements_ExchangeSegmentID='" + exchsegid[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "' and (case when '" + splitsegname1 + "==CM" + "' and '" + exchsegid[0, 0] + "==1" + "' then Settlements_TypeSuffix='N' when '" + splitsegname1 + "==CM" + "' and '" + exchsegid[0, 0] + "==2" + "'  then Settlements_TypeSuffix='W' else Settlements_TypeSuffix='F' end) and Settlements_StartDateTime=(Select Max(Settlements_StartDateTime) from Master_Settlements Where Settlements_ExchangeSegmentID='" + exchsegid[0, 0] + "' and Settlements_FinYear='" + finyr[0, 0] + "' and (case when '" + splitsegname1 + "==CM" + "' and '" + exchsegid[0, 0] + "==1" + "' then Settlements_TypeSuffix='N' when '" + splitsegname1 + "==CM" + "' and '" + exchsegid[0, 0] + "==2" + "' then Settlements_TypeSuffix='W' else Settlements_TypeSuffix='F' end)) ", 1);

                               // string[,] companymain = oDBEngine.GetFieldValue("Tbl_Master_companyExchange", "top 1 Exch_InternalID,Exch_CompID", "Exch_ExchID='" + exhCntID[0, 0].ToString().Trim() + "' and exch_segmentId='1'", 2);
                               // oDBEngine.InsurtFieldValue("tbl_trans_LastSegment", "ls_cntid,ls_lastsegment,ls_userid,ls_lastdpcoid,ls_lastCompany,ls_lastFinYear,ls_lastSettlementNo,ls_lastSettlementType", "'" + contact + "','" + grpsegment[0, 0] + "','" + userid[0, 0] + "','" + companymain[0, 0] + "','" + companymain[0, 1].ToString() + "','" + finyr[0, 0].ToString().Trim() + "','','N'");
                               

                        //Added New code to add eefault company in the tbl_master_user
                                string[,] userInternalId = oDBEngine.GetFieldValue("tbl_master_user", "user_Contactid", "user_id=" + userid[0, 0] +"", 1);
                                //DataTable dtcmp = oDBEngine.GetDataTable(" tbl_master_company  ", "*", "cmp_id=(select emp_organization from tbl_trans_employeectc where emp_cntId='" + userInternalId[0,0] + "')");
                                DataTable dtcmp = oDBEngine.GetDataTable(" tbl_master_company  ", "*", "cmp_id=(select top 1 emp_organization  from tbl_trans_employeectc where emp_cntId='" + userInternalId[0, 0] + "' and emp_id=(select MAX(emp_id) from tbl_trans_employeectc e where e.emp_cntId='" + userInternalId[0, 0] + "'))");

                                if (dtcmp.Rows.Count > 0)
                                {
                                    string SegmentId = "1";
                                    oDBEngine.InsurtFieldValue("Master_UserCompany", "UserCompany_UserID,UserCompany_CompanyID,UserCompany_CreateUser,UserCompany_CreateDateTime", "'" + userid[0, 0] + "','" + Convert.ToString(dtcmp.Rows[0]["cmp_internalid"]) + "','" + Convert.ToString(Session["userid"]) + "','" + DateTime.Now + "'");
                                    //oDBEngine.InsurtFieldValue("tbl_trans_LastSegment", "ls_cntid,ls_lastsegment,ls_userid,ls_lastdpcoid,ls_lastCompany,ls_lastFinYear,ls_lastSettlementNo,ls_lastSettlementType", "'" + contact + "','" + grpsegment[0, 0] + "','" + userid[0, 0] + "','" + SegmentId + "','" + Convert.ToString(dtcmp.Rows[0]["cmp_internalid"]) + "','" + finyr[0, 0].ToString().Trim() + "','','N'");
                                    oDBEngine.InsurtFieldValue("tbl_trans_LastSegment", "ls_cntid,ls_lastsegment,ls_userid,ls_lastdpcoid,ls_lastCompany,ls_lastFinYear,ls_lastSettlementNo,ls_lastSettlementType", "'" + contact + "','" + grpsegment[0, 0] + "','" + userid[0, 0] + "','" + SegmentId + "','" + Convert.ToString(dtcmp.Rows[0]["cmp_internalid"]) + "','" + FinancialYear.Trim() + "','','N'");
                                    
                                }
                                else
                                {
                                    string[,] companymain = oDBEngine.GetFieldValue("Tbl_Master_companyExchange", "top 1 Exch_InternalID,Exch_CompID", "Exch_ExchID='" + exhCntID[0, 0].ToString().Trim() + "' and exch_segmentId='1'", 2);
                                    //oDBEngine.InsurtFieldValue("tbl_trans_LastSegment", "ls_cntid,ls_lastsegment,ls_userid,ls_lastdpcoid,ls_lastCompany,ls_lastFinYear,ls_lastSettlementNo,ls_lastSettlementType", "'" + contact + "','" + grpsegment[0, 0] + "','" + userid[0, 0] + "','" + companymain[0, 0] + "','" + companymain[0, 1].ToString() + "','" + finyr[0, 0].ToString().Trim() + "','','N'");
                                    oDBEngine.InsurtFieldValue("tbl_trans_LastSegment", "ls_cntid,ls_lastsegment,ls_userid,ls_lastdpcoid,ls_lastCompany,ls_lastFinYear,ls_lastSettlementNo,ls_lastSettlementType", "'" + contact + "','" + grpsegment[0, 0] + "','" + userid[0, 0] + "','" + companymain[0, 0] + "','" + companymain[0, 1].ToString() + "','" + FinancialYear.Trim() + "','','N'");
                                }
                        //--------------------------------
                                Response.Redirect("/OMS/Management/Master/root_user.aspx");
                    }
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "OnClick", "<script language='javascript'> alert('Not Authorised To Add Records!') </script>");
                    }

               
            }
            else
            {
                Int16 userId = Convert.ToInt16(Id);
                SalesPersontracking ob = new SalesPersontracking();
                DataTable dtfromtosumervisor = ob.MobileUserloginIDRellocation(txtuserid.Text.ToString().Trim());

                if (dtfromtosumervisor.Rows.Count > 0 && Convert.ToString(dtfromtosumervisor.Rows[0][0]) == "0")
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "OnClick", "<script language='javascript'> alert('Already user exist with this Login Id.!') </script>");

                }
                else
                {
                    //if (Session["PageAccess"].ToString().Trim() == "Add" || Session["PageAccess"].ToString().Trim() == "Edit" || Session["PageAccess"].ToString().Trim() == "All")
                    if (Convert.ToString(Session["PageAccess"]).Trim() == "Add" || Convert.ToString(Session["PageAccess"]).Trim() == "Edit" || Convert.ToString(Session["PageAccess"]).Trim() == "All")
                    {

                        oDBEngine.SetFieldValue("tbl_master_user", "user_name='" + txtusername.Text + "',user_branchId=" + b_id + ",user_group='" + usergroup + "',user_loginId='" + txtuserid.Text + "',user_inactive='" + isactive + "',user_maclock='" + isactivemac + "',user_contactid='" + contact + "',LastModifyDate='" + CreateDate.ToString() + "',LastModifyUser='" + CreateUser + "',user_superuser ='" + superuser + "',user_EntryProfile='" + ddDataEntry.SelectedItem.Value + "',user_AllowAccessIP='" + IPAddress.Trim() + "'", " user_id ='" + userId + "'");
                        Fillgridview();
                        //Page.ClientScript.RegisterStartupScript(GetType(), "OnC", "<script language='javascript'> Close(); </script>");
                        Response.Redirect("/OMS/Management/Master/root_user.aspx");
                    }
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "OnClick", "<script language='javascript'> alert('Not Authorised To Modify Records!') </script>");
                    }
                }
            }

        }

        public static string GetFinancialYear()
        {
            string finyear = "";
            DateTime dt = Convert.ToDateTime(System.DateTime.Now);
            int m = dt.Month;
            int y = dt.Year;
            if (m > 3)
            {
                finyear = y.ToString() + "-" + Convert.ToString((y + 1));
                //get last  two digits (eg: 10 from 2010);
            }
            else
            {
                finyear = Convert.ToString((y - 1)) + "-" + y.ToString();
            }
            return finyear;
        }
        
        protected string getuserGroup()
        {
            //string str = "";
            //bool flag = true;
            //for (int i = 0; i <= grdUserAccess.Rows.Count - 1; i++)
            //{
            //    CheckBox chk = (CheckBox)grdUserAccess.Rows[i].FindControl("chkSegmentId");
            //    if (chk.Checked == true)
            //    {
            //        DropDownList drp = (DropDownList)grdUserAccess.Rows[i].FindControl("drpUserGroup");
            //        if (flag == true)
            //        {
            //            str += drp.SelectedValue;
            //            flag = false;
            //        }
            //        else
            //        {
            //            str += "," + drp.SelectedValue;
            //        }
            //    }
            //}
            //return str;
            return ddlGroups.SelectedValue.ToString();
        }
        //protected void Page_Unload(object sender, EventArgs e)
        //{
        //    this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>alert('height');height();</script>");
        //}



        // Code Added By Sandip on 22032017 to use Query String Value in Web Method for Chosen DropDown

        public static string ActionMode { get; set; }

    }
}