using DevExpress.Web;
using DevExpress.Web.Mvc;
using EntityLayer.CommonELS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BusinessLogicLayer;
using System.Collections.Specialized;

namespace ERP.OMS.Management.Master
{
    public partial class DailySalesReport : ERP.OMS.ViewState_class.VSPage
    {
        DataTable DTIndustry = new DataTable();
        BusinessLogicLayer.Reports objReport = new BusinessLogicLayer.Reports();
        string data = "";
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Salsmanid"] == null)
            { rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/master/DailySalesReport.aspx"); }
            else { rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/Management/Activities/crm_sales.aspx"); }
          
            
            DateTime dtFrom;
            DateTime dtTo;
            if(!IsPostBack)
            {


              
                if (Request.QueryString["Salsmanid"] != null)
                {
                    if (Request.QueryString["returnId"] != null)
                    {
                        if (Request.QueryString["returnId"] == "1")
                        {
                            dvnfrmsales.Visible = true;
                           
                        }
                        else if (Request.QueryString["returnId"] == "2")
                        {
                            dvdocuments.Visible = true;
                           
                        }
                        else if (Request.QueryString["returnId"] == "3")
                        {
                            dvfutue.Visible = true;
                            
                        }
                        else if (Request.QueryString["returnId"] == "4")
                        {
                            dvclarification.Visible = true;
                           
                        }

                        else if (Request.QueryString["returnId"] == "5")
                        {
                            dvclosed.Visible = true;

                            
                        }
                    }
                    //dvnormal.Visible = false;
                    //dvnfrmsales.Visible = true;

                }
                else
                {
                    dvnormal.Visible = true;
                    dvclosed.Visible = false;
                    dvnfrmsales.Visible = false;
                    dvclarification.Visible = false;
                    dvdocuments.Visible = false;
                    dvfutue.Visible = false;
                }
                dtFrom = DateTime.Now;
                dtTo = DateTime.Now;
             //   BindDropDownList();
                ASPxFromDate.Text = dtFrom.ToString("dd-MM-yyyy");
                ASPxToDate.Text = dtTo.ToString("dd-MM-yyyy");
               // BindIndustryMap(dtFrom, dtTo);
                GridSalesReport.DataBind();
            }
            
            String callbackScript = "function CallServer(arg, context){ " + "" + ";}";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CallServer", callbackScript, true);

        }
        public  void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
               
                //drdExport.SelectedItem.Value = "0";
                //drdExport.DataBind();
                if (Session["exportval"] == null)
                {
                    Session["exportval"] = Filter;
                   // BindDropDownList();
                    bindexport(Filter);
                }
                else if (Convert.ToInt32(Session["exportval"]) != Filter)
                {
                    Session["exportval"] = Filter;
                   // BindDropDownList();
                    bindexport(Filter);
                }
            }
          
        }
        public  void BindDropDownList()
        {
            // Declare a Dictionary to hold all the Options with Value and Text.
            Dictionary<string, string> options = new Dictionary<string, string>();
            options.Add("0", "Export to");
            options.Add("1", "PDF");
            options.Add("2", "XLS");
            options.Add("3", "RTF");
            options.Add("4", "CSV");
            

            // Bind the Dictionary to the DropDownList.
            drdExport.DataSource = options;
            drdExport.DataTextField = "value";
            drdExport.DataValueField = "key";
            drdExport.DataBind();
            drdExport.SelectedValue = "0";
        }
        public void bindexport(int Filter)
        {
          GridSalesReport.Columns[12].Visible = false;
            //MainAccountGrid.Columns[20].Visible = false;
            // MainAccountGrid.Columns[21].Visible = false;
            string filename = Convert.ToString((Session["Contactrequesttype"] ?? "Daily Salesmen"));
            exporter.FileName = filename;

            exporter.PageHeader.Left = Convert.ToString((Session["Contactrequesttype"] ?? "Daily Salesmen Report"));
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";
            exporter.Landscape = true;
            exporter.MaxColumnWidth = 100;
            switch (Filter)
            {
                case 1:
                    exporter.WritePdfToResponse();

                    break;
                case 2:
                    exporter.WriteXlsxToResponse();
                    break;
                case 3:
                    exporter.WriteRtfToResponse();
                    break;
                case 4:
                    exporter.WriteCsvToResponse();
                    break;
            }
         
        }
        protected void BindIndustryMap(DateTime FromDate,DateTime ToDate)
       {
            try
            {

                if (Request.QueryString["Salsmanid"] != null)
                {

                    DTIndustry = objReport.DailySalesReport(FromDate, ToDate, Convert.ToInt32(Request.QueryString["Salsmanid"]));
                }
                else
                {
                    DTIndustry = objReport.DailySalesReport(FromDate, ToDate,0);
                }
                if (DTIndustry != null && DTIndustry.Rows.Count > 0)
                {

                    Session["GrdReport"] = DTIndustry;
                    GridSalesReport.DataSource = DTIndustry;
                    GridSalesReport.DataBind();
                    GridSalesReport.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;

                    

                }
                else { Session["GrdReport"] = null;
                GridSalesReport.DataSource = null;
                GridSalesReport.DataBind();
                
                }
            }
            catch{}
        }
        protected void Grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            int MainSend = 0;
            int ISEmail = 0;
            string cnt_internalId = Convert.ToString(HttpContext.Current.Session["cntId"]);//Session usercontactID
            int i = 0;
            GridSalesReport.JSProperties["cpSave"] = null;
            string[] CallVal = e.Parameters.ToString().Split('~');
            if (CallVal[0].ToString() == "Feedback")
            {
                int Isemail = 0;
                if (chkmailfeedback.Checked)
                {
                    Isemail = 1;
                }

                string Id = Convert.ToString(CallVal[1].ToString());

                string Remarks = Convert.ToString(CallVal[2].ToString());
                string UserId = Convert.ToString(HttpContext.Current.Session["cntId"]);

                string Tid = Convert.ToString(CallVal[3].ToString());
                string Stid = Convert.ToString(CallVal[4].ToString());
                string type = Convert.ToString(CallVal[5].ToString());
                string nxtdate = Convert.ToString(CallVal[6].ToString());
                DateTime dtnxtdt = Convert.ToDateTime(ASPxNxtactivtyDate.Value);
                BusinessLogicLayer.Others obl = new BusinessLogicLayer.Others();
                if (chkchnageDate.Checked == true)
                {
                    i = obl.FeedbackActivity(Id, UserId, Remarks, Tid, Stid, type, dtnxtdt.ToString("yyyy-MM-dd"));
                }
                else
                {
                    i = obl.FeedbackActivity(Id, UserId, Remarks, Tid, Stid, "Feedback", dtnxtdt.ToString("yyyy-MM-dd"));
                }
                if (i > 0)
                {
                    
                    BindIndustryMap(Convert.ToDateTime(ASPxFromDate.Date), Convert.ToDateTime(ASPxToDate.Date));
                    // BindIndustryMap();

                    GridSalesReport.JSProperties["cpFeedSave"] = "Y";

                    #region MailSendFeedback
                    if (Isemail == 1)
                    {
                       string  id1 = hdndaily.Value;
                        string RecvEmail = string.Empty;
                        string ActvName = string.Empty;

                        DataTable dtbl_AssignedTo = new DataTable();
                        DataTable dtbl_AssignedBy = new DataTable();
                        DataTable dtEmail_To = new DataTable();
                      //  DataTable dtEmail_To = new DataTable();
                        DataTable dtActivityName = new DataTable();
                        DataTable dt_EmailConfig = new DataTable();
                        DataTable dt_AssignedUserDetails = new DataTable();

                        Employee_BL objemployeebal = new Employee_BL();

                        dt_AssignedUserDetails = objemployeebal.GetEmailAccountConfigDetails(Stid, 6);
                        if (!string.IsNullOrEmpty(Convert.ToString(dt_AssignedUserDetails.Rows[0].Field<decimal>("sls_assignedTo"))))
                        {
                            dtbl_AssignedTo = objemployeebal.GetEmailAccountConfigDetails(Convert.ToString(dt_AssignedUserDetails.Rows[0].Field<decimal>("sls_assignedTo")), 2);
                        }
                        dtbl_AssignedBy = objemployeebal.GetEmailAccountConfigDetails(UserId, 3);
                        dtEmail_To = objemployeebal.GetEmailAccountSupervisorSalesmanConfigDetails(Convert.ToString(dt_AssignedUserDetails.Rows[0].Field<decimal>("sls_assignedTo")), 13, Stid);
                        dtActivityName = objemployeebal.GetEmailAccountConfigDetails(id1, 5);
                        dt_EmailConfig = objemployeebal.GetEmailAccountConfigDetails(Convert.ToString(dt_AssignedUserDetails.Rows[0].Field<decimal>("sls_assignedTo")), 1);


                        if (dtEmail_To.Rows.Count > 0)
                        {
                            if (!string.IsNullOrEmpty(dtEmail_To.Rows[0].Field<string>("Email")))
                            {
                                RecvEmail = Convert.ToString(dtEmail_To.Rows[0].Field<string>("Email"));
                            }
                            else
                            {
                                RecvEmail = "";
                            }
                        }

                        if (dtActivityName != null && dtActivityName.Rows.Count > 0)
                        {
                            if (!string.IsNullOrEmpty(dtActivityName.Rows[0].Field<string>("act_activityName")))
                            {
                                ActvName = dtActivityName.Rows[0].Field<string>("act_activityName");
                            }
                            else
                            {
                                ActvName = "";
                            }
                        }
                        else
                        {
                            ActvName = "";
                        }

                        ListDictionary replacements = new ListDictionary();
                        if (dtbl_AssignedTo.Rows.Count > 0)
                        {
                            replacements.Add("<%AssigneeTo%>", Convert.ToString(dtbl_AssignedTo.Rows[0].Field<string>("AssigneTo")));
                        }
                        else
                        {
                            replacements.Add("<%AssigneeTo%>", "");
                        }
                        if (dtbl_AssignedBy.Rows.Count > 0)
                        {
                            replacements.Add("<%AssignedBy%>", Convert.ToString(dtbl_AssignedBy.Rows[0].Field<string>("AssignedBy")));
                        }
                        else
                        {
                            replacements.Add("<%AssignedBy%>", "");
                        }
                        replacements.Add("<%TimeOfError%>", Convert.ToString(DateTime.Now));

                        if (!string.IsNullOrEmpty(Remarks))
                        {
                            replacements.Add("<%Feedback%>", Remarks);
                        }
                        else
                        {
                            replacements.Add("<%Feedback%>", "");
                        }

                        replacements.Add("<%ActivityName%>", ActvName);

                        if (!string.IsNullOrEmpty(RecvEmail))
                        {

                          MainSend=  ExceptionLogging.SendMailSupervisorFunctionality(RecvEmail, "", replacements, dt_EmailConfig, Remarks, 6);
                        
                        
                        if(MainSend==1)
                        {
                            GridSalesReport.JSProperties["cpMainSendmsg"] = "Mail send successfully";
                        
                        }
                        else
                        {
                            GridSalesReport.JSProperties["cpMainSendmsg"] = "Failure mail send";
                        
                        }
                        }
                    }


                    #endregion
                }
                else
                {
                    DateTime dtFrom;
                    DateTime dtTo;
                    dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                    dtTo = Convert.ToDateTime(ASPxToDate.Date);
                    BindIndustryMap(dtFrom, dtTo);
                    GridSalesReport.JSProperties["cpFeedSave"] = "N";
                }


                BindIndustryMap(ASPxFromDate.Date, ASPxToDate.Date);

            }
            else
            {

                DateTime dtFrom;
                DateTime dtTo;
                dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
                dtTo = Convert.ToDateTime(ASPxToDate.Date);
                BindIndustryMap(dtFrom, dtTo);
            }


        }
        protected void ShowGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            if (e.Value !=  "")
            {
                e.Text = string.Format("{0}", "Count= " + e.Value);
            }
        }
        protected void GridSalesReport_DataBinding(object sender, EventArgs e)
        {
            //if( Session["GrdReport"] !=null)
            //{
            //DateTime dtFrom;
            //DateTime dtTo;
            //dtFrom = Convert.ToDateTime(ASPxFromDate.Date);
            //dtTo = Convert.ToDateTime(ASPxToDate.Date);
            //BindIndustryMap(dtFrom, dtTo);
                GridSalesReport.DataSource =(DataTable)Session["GrdReport"];
               

            //}
            //else { }

        }
        
    }
}