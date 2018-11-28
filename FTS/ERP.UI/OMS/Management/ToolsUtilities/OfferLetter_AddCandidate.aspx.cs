using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using CrystalDecisions.CrystalReports.Engine;
using BusinessLogicLayer;
using EntityLayer.CommonELS;

namespace ERP.OMS.Management.ToolsUtilities
{
    public partial class management_utilities_OfferLetter_AddCandidate : System.Web.UI.Page, System.Web.UI.ICallbackEventHandler
    {
        string data = string.Empty;
        public string pageAccess = "";
        //DBEngine oDBEngine = new DBEngine(string.Empty);
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        BusinessLogicLayer.Converter OConvert = new BusinessLogicLayer.Converter();
        BusinessLogicLayer.Converter oconverter = new BusinessLogicLayer.Converter();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();

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
            rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/Management/ToolUtilities/OfferLetter_AddCandidate.aspx");

            txtJD.EditFormatString = OConvert.GetDateFormat("Date");
            if (!IsPostBack)
            {
                dtDate.EditFormatString = oconverter.GetDateFormat("Date");
                dtDate.Value = oDBEngine.GetDate().AddDays((-1 * oDBEngine.GetDate().Day) + 1);
                dtToDate.EditFormatString = oconverter.GetDateFormat("Date");
                dtToDate.Value = oDBEngine.GetDate();
                txtJD.Value = Convert.ToDateTime(DateTime.Today);
                Page.ClientScript.RegisterStartupScript(GetType(), "JScript", "<script language='javascript'>PageLoadFirst();</script>");
                GetDataSource();
            }
            else
            {
                BindGrid();

            }


            //_____For performing operation without refreshing page___//
            String cbReference = Page.ClientScript.GetCallbackEventReference(this, "arg", "ReceiveServerData", "context");
            String callbackScript = "function CallServer(arg, context){ " + cbReference + ";}";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CallServer", callbackScript, true);
            //___________-end here___//

            if (HttpContext.Current.Session["userid"] == null)
            {
               // Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
           // //this.Page.ClientScript.RegisterStartupScript(GetType(), "heightL", "<script>height();</script>");

            // btnGenerate.Visible = false;
        }

        #region for servercall
        void ICallbackEventHandler.RaiseCallbackEvent(string eventArgument)
        {
            // DBEngine oDBEngine = new DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
            string id = eventArgument.ToString();
            string[] FieldWvalue = id.Split('~');
            string IDs = "";
            if (FieldWvalue[0] == "read")
            {
                data = FieldWvalue[1];
                HDNSelection.Value = FieldWvalue[1];
            }

        }
        string ICallbackEventHandler.GetCallbackResult()
        {
            return data;

        }
        #endregion

        protected void GridMessage_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {


            string tranid = e.Parameters.ToString();
            if (tranid.Length != 0)
            {

                string[] mainid = tranid.Split('~');
                if (mainid[0].ToString() == "Delete")
                {
                    oDBEngine.DeleteValue("tbl_trans_RecruitmentDetailTemp", "rde_id ='" + mainid[1].ToString() + "'");
                    this.Page.ClientScript.RegisterStartupScript(GetType(), "script4", "<script>height();</script>");
                    GetDataSource();
                }
                else if (mainid[0].ToString() == "Show")
                {
                    if (mainid[1].ToString() == "s")
                    {
                        GridMessage.Settings.ShowFilterRow = true;
                    }
                    else if (mainid[1].ToString() == "All")
                    {
                        GridMessage.FilterExpression = string.Empty;
                    }
                }


            }
            GetDataSource();
        }



        protected void btnGenerate_Click1(object sender, EventArgs e)
        {
            string dat = HDNSelection.Value;
            DataSet ds = new DataSet();

            using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
            {
                SqlCommand cmd = new SqlCommand();
                if (HDNSelection.Value.ToString().Length > 0)
                {


                    cmd.Connection = con;
                    cmd.CommandText = "select  rde_id,(select sal_name from  tbl_master_salutation where sal_id=rde_Salutation) as Salutation,rde_Name ,rde_ResidenceLocation,(select cmp_name from  tbl_master_Company where cmp_id=rde_Company)as company,(select branch_description from tbl_master_branch where branch_id= rde_Branch)as Branch,(select deg_designation from tbl_master_Designation where deg_id=rde_Designation) as Designation,rde_ApprovedCTC,rde_company  from tbl_trans_RecruitmentDetailTemp where rde_id in (" + HDNSelection.Value + ") and rde_status='Y'";
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    cmd.CommandTimeout = 0;
                    ds.Reset();
                    da.Fill(ds);
                    da.Dispose();

                    byte[] logoinByte;
                    ds.Tables[0].Columns.Add("Image", System.Type.GetType("System.Byte[]"));
                    for (int k = 0; k < ds.Tables[0].Rows.Count; k++)
                    {
                        string filePath = @"..\images\logo_" + ds.Tables[0].Rows[k]["rde_company"].ToString().Trim() + ".bmp";
                        if (oconverter.getLogoImage(HttpContext.Current.Server.MapPath(filePath), out logoinByte) != 1)
                        {

                            if (oconverter.getLogoImage(HttpContext.Current.Server.MapPath(@"..\images\logo.bmp"), out logoinByte) == 1)
                            {
                                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                                {
                                    ds.Tables[0].Rows[i]["Image"] = logoinByte;
                                }


                            }


                        }
                        else
                        {
                            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                            {
                                ds.Tables[0].Rows[i]["Image"] = logoinByte;
                            }

                        }
                    }
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        oDBEngine.SetFieldValue("tbl_trans_RecruitmentDetailTemp", "rde_GenerateDate='" + oDBEngine.GetDate() + "',rde_GenerateUser='" + HttpContext.Current.Session["userid"] + "'", "rde_Id in (select  rde_id from tbl_trans_RecruitmentDetailTemp WHERE rde_id in (" + HDNSelection.Value + ") and rde_status='Y')");

                        ReportDocument report = new ReportDocument();
                        report = Utility_CrystalReport.GetReport(report.GetType());
                        //  ds.Tables[0].WriteXmlSchema("E:\\RPTXSD\\OfferLetter.xsd");



                        string tmpPdfPath = string.Empty;
                        tmpPdfPath = HttpContext.Current.Server.MapPath("..\\management\\OfferLetter.rpt");
                        report.Load(tmpPdfPath);
                        report.SetDataSource(ds.Tables[0]);
                        report.ExportToHttpResponse(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat, HttpContext.Current.Response, true, "OfferLetter");
                        report.Close();
                        report.Dispose();
                        GC.Collect();

                    }
                    else
                    {
                        this.Page.ClientScript.RegisterStartupScript(GetType(), "script441", "<script>HideFilter();</script>");
                        this.Page.ClientScript.RegisterStartupScript(GetType(), "script44", "<script>alert('You can not Generate offer Letter without permission.');</script>");

                    }
                }
                else
                {
                    this.Page.ClientScript.RegisterStartupScript(GetType(), "script451", "<script>HideFilter();</script>");
                    this.Page.ClientScript.RegisterStartupScript(GetType(), "script12", "<script>alert('Please Select Candidate!.');</script>");

                }
            }
        }


        protected void Button1_Click(object sender, EventArgs e)
        {
            GetDataSource();

        }

        public void GetDataSource()
        {

            DataTable DT = new DataTable();
            if (RadSRecord.Checked == true)
            {
                string startdate = dtDate.Date.Month.ToString() + "/" + dtDate.Date.Day.ToString() + "/" + dtDate.Date.Year.ToString() + " 00:01 AM";
                string Enddate = dtToDate.Date.Month.ToString() + "/" + dtToDate.Date.Day.ToString() + "/" + dtToDate.Date.Year.ToString() + " 11:59 PM";
                DT = oDBEngine.GetDataTable("tbl_trans_RecruitmentDetailTemp ", " rde_id,(select sal_name from  tbl_master_salutation where sal_id=rde_Salutation) as Salutation,rde_Name ,rde_ResidenceLocation,(select cmp_name from  tbl_master_Company where cmp_id=rde_Company)as company,(select branch_description from tbl_master_branch where branch_id= rde_Branch)as Branch,(select deg_designation from tbl_master_Designation where deg_id=rde_Designation) as Designation,rde_ApprovedCTC ,rde_NoofDepedent,(select user_name from tbl_master_User where user_id=tbl_trans_RecruitmentDetailTemp.CreateUser) as CreateUserName , CONVERT(VARCHAR(20), createDate, 100)  as CreateDate1,case when rde_status='N' then 'Under Process' else 'Generate' end as Status ,(select user_name from tbl_master_User where user_id=tbl_trans_RecruitmentDetailTemp.rde_GenerateUser) as GenerateUserName , CONVERT(VARCHAR(20), rde_GenerateDate, 100)  as GenerateDate,(case when rde_IsConfirmJoin='Y' then 'Joined' else 'Not Join' end) as rde_IsConfirmJoin,CONVERT(VARCHAR(12), rde_ProbableJoinDate, 107) as JoiningDate", " CreateUser= '" + HttpContext.Current.Session["userid"] + "' and rde_IsEmployee <> 'Y' and (CAST(createDate AS datetime) >= CONVERT(varchar,'" + startdate + "', 101)) and (CAST(createDate AS datetime) <= CONVERT(varchar,'" + Enddate + "', 101)) and  rde_IsConfirmJoin!='Y'", " CreateDate desc");
                ViewState["dtBind"] = DT;

            }
            else
            {
                DT = oDBEngine.GetDataTable("tbl_trans_RecruitmentDetailTemp ", " rde_id,(select sal_name from  tbl_master_salutation where sal_id=rde_Salutation) as Salutation,rde_Name ,rde_ResidenceLocation,(select cmp_name from  tbl_master_Company where cmp_id=rde_Company)as company,(select branch_description from tbl_master_branch where branch_id= rde_Branch)as Branch,(select deg_designation from tbl_master_Designation where deg_id=rde_Designation) as Designation,rde_ApprovedCTC ,rde_NoofDepedent,(select user_name from tbl_master_User where user_id=tbl_trans_RecruitmentDetailTemp.CreateUser) as CreateUserName , CONVERT(VARCHAR(20), createDate, 100)  as CreateDate1,case when rde_status='N' then 'Under Process' else 'Generate' end as Status ,(select user_name from tbl_master_User where user_id=tbl_trans_RecruitmentDetailTemp.rde_GenerateUser) as GenerateUserName , CONVERT(VARCHAR(20), rde_GenerateDate, 100)  as GenerateDate,(case when rde_IsConfirmJoin='Y' then 'Joined' else 'Not Join' end) as rde_IsConfirmJoin,CONVERT(VARCHAR(12), rde_ProbableJoinDate, 107) as JoiningDate", " CreateUser= '" + HttpContext.Current.Session["userid"] + "' and rde_IsEmployee <> 'Y' and  rde_IsConfirmJoin!='Y'", " CreateDate desc");
                ViewState["dtBind"] = DT;
            }

            if (DT.Rows.Count > 0)
            {
                ViewState["dtBind"] = DT;
                BindGrid();
            }
            else
            {
                ViewState["dtBind"] = DT;
                BindGrid();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "script74", "alert('No Record Found!.');", true);
            }



        }
        protected void BindGrid()
        {
            if (ViewState["dtBind"] != null)
            {
                DataTable DtNew = (DataTable)ViewState["dtBind"];
                GridMessage.DataSource = DtNew;
                GridMessage.DataBind();


            }

            this.Page.ClientScript.RegisterStartupScript(GetType(), "heighSCR", "<script>height();</script>");
        }

        protected void GridMessage_PageIndexChanged(object sender, EventArgs e)
        {
            BindGrid();
        }

        protected void GridMessage_CustomJSProperties(object sender, DevExpress.Web.ASPxGridViewClientJSPropertiesEventArgs e)
        {
            e.Properties["cpHeight"] = "a";
        }
        protected void BtnJoin_Click(object sender, EventArgs e)
        {
            BusinessLogicLayer.GenericMethod oGenericMethod = new BusinessLogicLayer.GenericMethod();
            string ValidationResult = oGenericMethod.IsProductExpired(Convert.ToDateTime(txtJD.Value));
            if (Convert.ToBoolean(ValidationResult.Split('~')[0]))
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Vscript", "alert('" + ValidationResult.Split('~')[1] + "');", true);
            else
            {
                string dat = HDNSelection.Value;
                if (HDNSelection.Value.ToString().Length > 0)
                {
                    DataTable dtJ = new DataTable();
                    dtJ = oDBEngine.GetDataTable("tbl_trans_RecruitmentDetailTemp ", " * ", " rde_id in (" + HDNSelection.Value + ") and rde_status='Y'");
                    if (dtJ.Rows.Count > 0)
                    {
                        for (int i = 0; i < dtJ.Rows.Count; i++)
                        {
                            DataTable dts = oDBEngine.GetDataTable("tbl_master_user", "user_SuperUser", "user_id=" + HttpContext.Current.Session["userid"] + "");
                            if (dtJ.Rows[i]["rde_IsConfirmJoin"].ToString() != "Y")
                            {

                                oDBEngine.SetFieldValue("tbl_trans_RecruitmentDetailTemp", "rde_ProbableJoinDate='" + txtJD.Value + "',rde_IsConfirmJoin='Y',LastModifyDate= '" + oDBEngine.GetDate() + "' ", "rde_Id=" + dtJ.Rows[i]["rde_Id"] + "");
                                GetDataSource();
                                HDNSelection.Value = "";
                            }
                            else
                            {
                                // this.Page.ClientScript.RegisterStartupScript(GetType(), "script34", "<script>alert('Candidate Already Joined!.');</script>");
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "script14", "alert('Candidate Already Joined!.');", true);
                            }


                        }
                    }
                    else
                    {
                        //this.Page.ClientScript.RegisterStartupScript(GetType(), "script34", "<script>alert('You can not update status without varification!.');</script>");
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "script4s14", "alert('You can not update status without varification!.');", true);
                    }

                }
                else
                {
                    // this.Page.ClientScript.RegisterStartupScript(GetType(), "script33", "<script>alert('Please Select Employee From List!.');</script>");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "scripts14", "alert('Please Select Employee From List!.');", true);

                }
                GetDataSource();
            }
        }

        protected void GridMessage_HtmlDataCellPrepared(object sender, DevExpress.Web.ASPxGridViewTableDataCellEventArgs e)
        {
            string val = "";
            string aa = e.DataColumn.Caption.ToString();
            if (aa == "Status")
            {
                val = e.CellValue.ToString();
                changeColor(val.Trim(), e.Cell);
            }
            else if (aa == "Join Status")
            {
                val = e.CellValue.ToString();
                changeColor(val.Trim(), e.Cell);
            }
        }

        protected void changeColor(string value, System.Web.UI.WebControls.TableCell tc)
        {

            if (value == "Under Process")
            {
                tc.BackColor = System.Drawing.Color.FromName("#99CCFF");
                tc.Text = "Under Process";
                tc.ToolTip = "Candidate not varified!";
            }
            else if (value == "Generate")
            {
                tc.BackColor = System.Drawing.Color.FromName("#66CC99");
                tc.Text = "Generate";
                tc.ToolTip = "Varify Candidate!";
            }
            else if (value == "Not Join")
            {
                tc.BackColor = System.Drawing.Color.FromName("#99CCFF");
                tc.Text = "Not Join";
                tc.ToolTip = "Candidate Still Not Join!";
            }
            else if (value == "Joined")
            {
                tc.BackColor = System.Drawing.Color.FromName("#66CC99");
                tc.Text = "Joined";
                tc.ToolTip = "Candidate has already joined!";
            }
        }


        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(cmbExport.SelectedItem.Value.ToString());
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