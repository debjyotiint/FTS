using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using BusinessLogicLayer;
using System.Web.Services;
using System.Collections.Generic;

namespace ERP.OMS.Management.DailyTask
{
    public partial class management_DailyTask_frmBankStatement_ : ERP.OMS.ViewState_class.VSPage
    {
        ExcelFile ex = new ExcelFile();
        FileInfo FIICXCSV = null;
        StreamReader strReader;
        StringBuilder strbuilder = new StringBuilder();
        String readline = string.Empty;
        public string[] InputName = new string[20];
        public string[] InputType = new string[20];
        public string[] InputValue = new string[20];
        public string[] InputName1 = new string[20];
        public string[] InputType1 = new string[20];
        public string[] InputValue1 = new string[20];
        DataTable dt1 = new DataTable();
        string FilePath = "";
        DataSet dsdata = new DataSet();
        DataView dvUnmatched = new DataView();
        private static String path, path1, FileName, s, time, cannotParse;

        /* For 3 Tier
        DBEngine oDBEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        */
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        BusinessLogicLayer.Bank objBankStatementBL = new BusinessLogicLayer.Bank();
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

            if (!IsPostBack)
            {
                if ((HttpContext.Current.Session["userid"] == null) || (Convert.ToString(HttpContext.Current.Session["LastCompany"]).Trim() == ""))
                {
                    //Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct", "height();", true);
                Session["exportval"] = null;
            }

            if (dsdata != null)
            {
                if (dsdata.Tables.Count > 0)
                {
                    if (dsdata.Tables[0] != null)
                    {
                        if (dsdata.Tables[0].Rows.Count > 0 && dsdata.Tables[0].TableName == "BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]))
                        {
                            gridMatchedSummary.DataSource = dsdata.Tables["BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])];
                            gridMatchedSummary.DataBind();
                        }
                    }
                }
                if (dsdata.Tables.Count > 1)
                {

                    if (dsdata.Tables[1] != null)
                    {
                        if (dsdata.Tables[1].Rows.Count > 0 && dsdata.Tables[1].TableName == "BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]))
                        {
                            gridUnMatchedSummary.DataSource = dsdata.Tables["BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])];
                            gridUnMatchedSummary.DataBind();
                        }
                    }
                }
            }
        }
        protected void BtnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (OFDBankSelect.FileContent.Length != 0)
                {
                    path = String.Empty;
                    path1 = String.Empty;
                    FileName = String.Empty;
                    s = String.Empty;
                    time = String.Empty;
                    cannotParse = String.Empty;
                    string strmodule = "InsertTradeData";

                    /* For 3 Tier
                    TransctionDescription td = new TransctionDescription();
                    */

                    BusinessLogicLayer.TransctionDescription td = new BusinessLogicLayer.TransctionDescription();

                    FilePath = Path.GetFullPath(OFDBankSelect.PostedFile.FileName);
                    FileName = Path.GetFileName(FilePath);
                    String UploadPath = Server.MapPath((Convert.ToString(ConfigurationManager.AppSettings["SaveCSV"]) + FileName));
                    //String UploadPath = Convert.ToString(System.AppDomain.CurrentDomain.BaseDirectory) + FileName;
                    OFDBankSelect.PostedFile.SaveAs(UploadPath);

                    FileInfo FICSV = new FileInfo(UploadPath);
                    //path = Path.Combine(ConfigurationManager.AppSettings["SaveCSVsql"], FileName);
                    path = (Convert.ToString(System.AppDomain.CurrentDomain.BaseDirectory) + Convert.ToString(ConfigurationManager.AppSettings["SaveFile"]) + FileName);
                    FIICXCSV = new FileInfo(UploadPath);
                    File.Copy(UploadPath, path, true);

                    ClearArray();

                    /* For 3 Tier
                    DBEngine oDBEngine = new DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
                   */

                    BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);

                    if (ddlBankList.SelectedValue == "HDFC BANK")
                    {
                        //using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
                        //{
                        //--------- For tier Structure ---------------
                        // SqlCommand cmd = new SqlCommand();
                        //cmd.Connection = con;
                        //cmd.CommandText = "[SP_INSUP_BANKSTATEMENT1]";
                        //cmd.CommandType = CommandType.StoredProcedure;
                        //cmd.Parameters.AddWithValue("@Module", strmodule);
                        //cmd.Parameters.AddWithValue("@Bank", ddlBankList.SelectedValue.ToString().Trim());
                        //cmd.Parameters.AddWithValue("@ModifyUser", HttpContext.Current.Session["userid"].ToString());
                        //cmd.Parameters.AddWithValue("@ExcSegmt", HttpContext.Current.Session["usersegid"].ToString());
                        //cmd.Parameters.AddWithValue("@FilePath", path);
                        //cmd.Parameters.AddWithValue("@BankCode", txtBank_hidden.Text.ToString());
                        //cmd.Parameters.AddWithValue("@ExchangeTrades_CompanyID", HttpContext.Current.Session["LastCompany"].ToString().Trim());
                        //cmd.CommandTimeout = 0;
                        //SqlDataAdapter da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(dsdata);
                        //--------- For tier Structure ---------------
                        //}

                        dsdata = new DataSet();
                        dsdata = objBankStatementBL.HDFC_BANK(strmodule, Convert.ToString(ddlBankList.SelectedValue).Trim(), Convert.ToString(HttpContext.Current.Session["userid"]), Convert.ToString(HttpContext.Current.Session["usersegid"]), path, Convert.ToString(txtBank_hidden.Text), Convert.ToString(HttpContext.Current.Session["LastCompany"]).Trim());

                        if (dsdata.Tables.Count > 0)
                        {
                            gridMatchedSummary.DataSource = dsdata.Tables[0];
                            gridMatchedSummary.DataBind();
                        }
                        if (dsdata.Tables.Count > 1)
                        {
                            gridUnMatchedSummary.DataSource = dsdata.Tables[1];
                            gridUnMatchedSummary.DataBind();
                            ViewState["BankStatementUnMatched"] = dsdata.Tables[1];
                        }

                        dsdata.Tables[0].TableName = "BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]);
                        dsdata.Tables[1].TableName = "BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct", "height();", true);

                        if (File.Exists(UploadPath))
                        {
                            File.Delete(UploadPath);
                        }
                        if (File.Exists(path))
                        {
                            File.Delete(path);
                        }
                    }
                    else if ((ddlBankList.SelectedValue == "HDFC BANK EASY VIEW") || (ddlBankList.SelectedValue == "Axis Bank CSV"))
                    {
                        string strnewfile = "";
                        using (StreamReader reader = new StreamReader(path))
                        {
                            ReadFile(path);

                            strnewfile = WriteFile(path, FileName);
                        }
                        if (ddlBankList.SelectedValue == "HDFC BANK EASY VIEW")
                            strmodule = "HDFCBANK";
                        else
                            strmodule = "AXISBANK";

                        //using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
                        //{
                        //---- For Tier Structure------------------------
                        //SqlCommand cmd = new SqlCommand();
                        //cmd.Connection = con;
                        //cmd.CommandText = "[SP_INSUP_BANKSTATEMENTEASY]";
                        //cmd.CommandType = CommandType.StoredProcedure;
                        //cmd.Parameters.AddWithValue("@Module", strmodule);
                        //cmd.Parameters.AddWithValue("@Bank", ddlBankList.SelectedValue.ToString().Trim());
                        //cmd.Parameters.AddWithValue("@ModifyUser", HttpContext.Current.Session["userid"].ToString());
                        //cmd.Parameters.AddWithValue("@ExcSegmt", HttpContext.Current.Session["usersegid"].ToString());
                        //cmd.Parameters.AddWithValue("@FilePath", strnewfile);
                        //cmd.Parameters.AddWithValue("@BankCode", txtBank_hidden.Text.ToString());
                        //cmd.Parameters.AddWithValue("@ExchangeTrades_CompanyID", HttpContext.Current.Session["LastCompany"].ToString().Trim());
                        //cmd.CommandTimeout = 0;
                        //SqlDataAdapter da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(dsdata);
                        //------------------------------------------------
                        //}


                        dsdata = new DataSet();
                        dsdata = objBankStatementBL.HDFC_BANK_EasyView(strmodule, Convert.ToString(ddlBankList.SelectedValue).Trim(), Convert.ToString(HttpContext.Current.Session["userid"]), Convert.ToString(HttpContext.Current.Session["usersegid"]), strnewfile, Convert.ToString(txtBank_hidden.Text), Convert.ToString(HttpContext.Current.Session["LastCompany"]).Trim());

                        if (dsdata.Tables.Count > 0)
                        {
                            gridMatchedSummary.DataSource = dsdata.Tables[0];
                            gridMatchedSummary.DataBind();
                        }
                        if (dsdata.Tables.Count > 1)
                        {
                            gridUnMatchedSummary.DataSource = dsdata.Tables[1];
                            gridUnMatchedSummary.DataBind();
                            ViewState["BankStatementUnMatched"] = dsdata.Tables[1];
                        }

                        if (File.Exists(strnewfile))
                        {
                            File.Delete(strnewfile);
                        }
                        if (File.Exists(path))
                        {
                            File.Delete(path);
                        }

                        dsdata.Tables[0].TableName = "BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]);
                        dsdata.Tables[1].TableName = "BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct10", "height();", true);
                    }

                    else if (ddlBankList.SelectedValue == "ICICI")
                    {

                        string strnewfile = "";
                        using (StreamReader reader = new StreamReader(path))
                        {
                            ReadFile(path);

                            strnewfile = WriteFile(path, FileName);
                        }

                        //using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
                        //{
                        //-----------For Tier ------------------------------
                        //SqlCommand cmd = new SqlCommand();
                        //cmd.Connection = con;
                        //cmd.CommandText = "[Import_ICICIBankStatement]";
                        //cmd.CommandType = CommandType.StoredProcedure;
                        //cmd.Parameters.AddWithValue("@ModifyUser", HttpContext.Current.Session["userid"].ToString());
                        //cmd.Parameters.AddWithValue("@ExcSegmt", HttpContext.Current.Session["usersegid"].ToString());
                        //cmd.Parameters.AddWithValue("@FilePath", strnewfile);
                        //cmd.Parameters.AddWithValue("@BankCode", txtBank_hidden.Text.ToString());
                        //cmd.Parameters.AddWithValue("@ExchangeTrades_CompanyID", HttpContext.Current.Session["LastCompany"].ToString().Trim());
                        //cmd.CommandTimeout = 0;
                        //SqlDataAdapter da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(dsdata);
                        //--------------------------------------------------
                        //}


                        dsdata = new DataSet();
                        dsdata = objBankStatementBL.ICICIBankStatement(Convert.ToString(HttpContext.Current.Session["userid"]), Convert.ToString(HttpContext.Current.Session["usersegid"]), strnewfile, Convert.ToString(txtBank_hidden.Text), Convert.ToString(HttpContext.Current.Session["LastCompany"]).Trim());

                        if (dsdata.Tables.Count > 0)
                        {
                            gridMatchedSummary.DataSource = dsdata.Tables[0];
                            gridMatchedSummary.DataBind();
                        }
                        if (dsdata.Tables.Count > 1)
                        {
                            gridUnMatchedSummary.DataSource = dsdata.Tables[1];
                            gridUnMatchedSummary.DataBind();
                            ViewState["BankStatementUnMatched"] = dsdata.Tables[1];
                        }

                        //if (File.Exists(strnewfile))
                        //{
                        //    File.Delete(strnewfile);
                        //}
                        //if (File.Exists(path))
                        //{
                        //    File.Delete(path);
                        //}

                        dsdata.Tables[0].TableName = "BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]);
                        dsdata.Tables[1].TableName = "BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"]);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct10", "height();", true);
                    }
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "PageScript", "<script language='javascript'>jAlert('Not Valid File!');</script>");
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct11", "height();", true);
                    }

                    //if (File.Exists(UploadPath))
                    //{
                    //    File.Delete(UploadPath);
                    //}
                    //if (File.Exists(path))
                    //{
                    //    File.Delete(path);
                    //}

                    Page.ClientScript.RegisterStartupScript(GetType(), "PageScript", "<script language='javascript'>jAlert('Import Successfully!');</script>");
                }
                else
                    Page.ClientScript.RegisterStartupScript(GetType(), "PageScript", "<script language='javascript'>jAlert('Selected File Cannot Be Blank');</script>");

            }
            catch (Exception ex)
            {

            }
            finally
            {

            }
        }
        protected void ReadFile(string txtFilePath)
        {
            String fileInfo;
            int number = 0;
            strReader = File.OpenText(txtFilePath);
            string StrGrand = null;
            try
            {
                using (StreamReader rwOpenTemplate = new StreamReader(txtFilePath))
                {
                    string a = StrGrand;

                    while ((fileInfo = rwOpenTemplate.ReadLine()) != null)
                    {
                        number = number + 1;
                        readline = strReader.ReadLine();
                        if (readline != "")
                        {
                            if (IsNumeric(readline.Substring(0, 1)))
                            {
                                strbuilder.AppendLine(readline);
                            }
                        }
                    }
                    rwOpenTemplate.Dispose();
                    rwOpenTemplate.Close();
                    strReader.Dispose();
                    strReader.Close();
                }
            }
            catch (Exception ex)
            {

            }
        }
        protected string WriteFile(string txtFilePath, string FileName)
        {
            string str = null;
            string[] newname = null;
            newname = FileName.Split('.');
            newname[0] += "_New" + "." + newname[1];
            str = Convert.ToString(newname[0]);
            string NewFilePath = (Convert.ToString(System.AppDomain.CurrentDomain.BaseDirectory) + Convert.ToString(ConfigurationManager.AppSettings["SaveFile"]) + str);

            StreamWriter srw = new StreamWriter(NewFilePath);
            str = Convert.ToString(strbuilder);
            srw.Write(str);
            srw.Close();

            return NewFilePath;
        }
        protected string WriteFile_ICICI(string txtFilePath, string FileName)
        {
            string str = null;
            string[] newname = null;
            newname = FileName.Split('.');
            newname[0] += "_New" + "." + newname[1];
            str = Convert.ToString(newname[0]);
            string NewFilePath = (Convert.ToString(System.AppDomain.CurrentDomain.BaseDirectory) + Convert.ToString(ConfigurationManager.AppSettings["SaveFile"]) + str);

            StreamWriter srw = new StreamWriter(NewFilePath);
            str = Convert.ToString(strbuilder);
            while (str.IndexOf("    ") != -1)
            {
                str = str.Replace("     ", "    ");
            }
            str = str.Replace(" ", "|");
            srw.Write(str);
            srw.Close();

            return NewFilePath;
        }
        public bool IsNumeric(string value)
        {
            try
            {
                Convert.ToDecimal(value.Trim());
                return true;
            }
            catch
            {
                return false;
            }
        }
        public void binddata()
        {
            path = String.Empty;
            path1 = String.Empty;
            FileName = String.Empty;
            s = String.Empty;
            time = String.Empty;
            cannotParse = String.Empty;
            string strmodule = "InsertTradeData";

            /* For 3 Tier 
            TransctionDescription td = new TransctionDescription();
            */
            BusinessLogicLayer.TransctionDescription td = new BusinessLogicLayer.TransctionDescription();

            FilePath = Path.GetFullPath(OFDBankSelect.PostedFile.FileName);
            FileName = Path.GetFileName(FilePath);
            String UploadPath = Server.MapPath((Convert.ToString(ConfigurationManager.AppSettings["SaveCSV"]) + FileName));
            OFDBankSelect.PostedFile.SaveAs(UploadPath);

            FileInfo FICSV = new FileInfo(UploadPath);
            path = (Convert.ToString(System.AppDomain.CurrentDomain.BaseDirectory) + Convert.ToString(ConfigurationManager.AppSettings["SaveFile"]) + FileName);
            FIICXCSV = new FileInfo(UploadPath);
            File.Copy(UploadPath, path, true);

            ClearArray();


            /* For 3 Tier
                   DBEngine oDBEngine = new DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
             */

            //using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
            //{
            //----------- For Tier--------------------------------
            //SqlCommand cmd = new SqlCommand();
            //cmd.Connection = con;
            //cmd.CommandText = "[SP_INSUP_BANKSTATEMENT]";
            //cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@Module", strmodule);
            //cmd.Parameters.AddWithValue("@Bank", ddlBankList.SelectedValue.ToString().Trim());
            //cmd.Parameters.AddWithValue("@ModifyUser", HttpContext.Current.Session["userid"].ToString());
            //cmd.Parameters.AddWithValue("@ExcSegmt", HttpContext.Current.Session["usersegid"].ToString());
            //cmd.Parameters.AddWithValue("@FilePath", path);
            //cmd.Parameters.AddWithValue("@BankCode", txtBank_hidden.Text.ToString());
            //cmd.Parameters.AddWithValue("@ExchangeTrades_CompanyID", HttpContext.Current.Session["LastCompany"].ToString().Trim());
            //cmd.CommandTimeout = 0;
            //SqlDataAdapter da = new SqlDataAdapter();
            //da.SelectCommand = cmd;
            //da.Fill(dsdata);
            //-------------------------------------------
            //}

            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);

            dsdata = new DataSet();
            dsdata = objBankStatementBL.Bind_Data(strmodule, Convert.ToString(ddlBankList.SelectedValue).Trim(), Convert.ToString(HttpContext.Current.Session["userid"]), Convert.ToString(HttpContext.Current.Session["usersegid"]), path, Convert.ToString(txtBank_hidden.Text), Convert.ToString(HttpContext.Current.Session["LastCompany"]).Trim());

            if (dsdata.Tables.Count > 0)
            {
                if (dsdata.Tables[0] != null)
                {
                    gridMatchedSummary.DataSource = dsdata.Tables[0];
                    gridMatchedSummary.DataBind();
                }
            }


            if (dsdata.Tables.Count > 1)
            {
                if (dsdata.Tables[1] != null)
                {
                    gridUnMatchedSummary.DataSource = dsdata.Tables[1];
                    gridUnMatchedSummary.DataBind();

                }
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct", "height();", true);

            if (File.Exists(UploadPath))
            {
                File.Delete(UploadPath);
            }
            if (File.Exists(path))
            {
                File.Delete(path);
            }

            Page.ClientScript.RegisterStartupScript(GetType(), "PageScript", "<script language='javascript'>jAlert('Import Successfully!');</script>");
        }
        public void ClearArray()
        {
            Array.Clear(InputName, 0, InputName.Length - 1);
            Array.Clear(InputType, 0, InputType.Length - 1);
            Array.Clear(InputValue, 0, InputValue.Length - 1);
        }
        protected void grid_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            DataTable dt = new DataTable();
            DataTable dtMat = new DataTable();
            DataView dvMatched = new DataView();

            string[] param = e.Parameters.Split('~');
            if (param[0] == "sum")
            {
                if (param[1] == "s")
                    gridMatchedSummary.Settings.ShowFilterRow = true;
                else if (param[1] == "All")
                    gridMatchedSummary.FilterExpression = string.Empty;
            }

            else if (param[0] == "usum")
            {
                if (param[1] == "s")
                    gridUnMatchedSummary.Settings.ShowFilterRow = true;
                else if (param[1] == "All")
                    gridUnMatchedSummary.FilterExpression = string.Empty;
            }
            else if (Convert.ToString(param[0]) == "")
            {
                if (Session["aa"] != null)
                {
                    dvMatched = dsdata.Tables["BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].DefaultView;
                    dvUnmatched = dsdata.Tables["BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].DefaultView;
                    dvUnmatched.RowFilter = "BANKSTATEMENT_ID=" + Convert.ToString(Session["aa"]);

                    foreach (DataRow dr1 in dsdata.Tables["BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].Rows)
                    {
                        if (Convert.ToString(dr1["BANKSTATEMENT_ID"]) == Convert.ToString(Session["aa"]))
                        {
                            DataRow dr5 = dsdata.Tables["BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].NewRow();
                            dr5["BANKSTATEMENT_ID"] = Convert.ToString(dr1["BANKSTATEMENT_ID"]);
                            dr5["DebitCredit"] = Convert.ToString(dr1["DebitCredit"]);
                            dr5["BANKSTATEMENT_TransactionDate"] = Convert.ToString(dr1["BANKSTATEMENT_TransactionDate"]);
                            dr5["BANKSTATEMENT_ValueDate"] = Convert.ToString(dr1["BANKSTATEMENT_ValueDate"]);
                            dr5["ReferenceNumber"] = Convert.ToString(dr1["ReferenceNumber"]);
                            dr5["BANKSTATEMENT_TransactionAmount"] = Convert.ToString(dr1["BANKSTATEMENT_TransactionAmount"]);
                            dr5["BANKSTATEMENT_TransactionDescription"] = Convert.ToString(dr1["BANKSTATEMENT_TransactionDescription"]);
                            dr5["BANKSTATEMENT_RunningBalance"] = Convert.ToString(dr1["BANKSTATEMENT_RunningBalance"]);
                            dsdata.Tables["BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].Rows.Add(dr5);
                            dsdata.Tables["BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].AcceptChanges();
                            dr1.Delete();
                        }
                    }

                    dsdata.Tables["BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].AcceptChanges();

                    dt = dsdata.Tables["BankStatementUnMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].Copy();
                    gridUnMatchedSummary.DataSource = dt;
                    gridUnMatchedSummary.DataBind();
                    dtMat = dsdata.Tables["BankStatementMatched_" + Convert.ToString(HttpContext.Current.Session["userid"])].Copy();
                    gridMatchedSummary.DataSource = dtMat;
                    gridMatchedSummary.DataBind();
                }
                Session["aa"] = (object)null;
            }
        }
        protected void gridMatchedSummary_PageIndexChanged(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "JSct", "height();", true);
        }
        protected void gridUnMatched_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {

        }
        protected void ddlExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(ddlExport.SelectedItem.Value));
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
            DataTable dtunmatchedsummary = new DataTable();
            DataTable CompanyName = oDBEngine.GetDataTable("tbl_master_company", "cmp_Name", " cmp_internalId='" + Convert.ToString(Session["LastCompany"]) + "'");
            DataTable dtReportHeader = new DataTable();
            dtReportHeader.Columns.Add(new DataColumn("Header", typeof(String))); //0
            DataRow HeaderRow = dtReportHeader.NewRow();
            HeaderRow[0] = Convert.ToString(CompanyName.Rows[0][0]);
            dtReportHeader.Rows.Add(HeaderRow);
            DataRow DrRowR1 = dtReportHeader.NewRow();
            DrRowR1[0] = "Cash/Bank Unmatched Summary";
            dtReportHeader.Rows.Add(DrRowR1);
            DataRow HeaderRow1 = dtReportHeader.NewRow();
            dtReportHeader.Rows.Add(HeaderRow1);
            DataRow HeaderRow2 = dtReportHeader.NewRow();
            dtReportHeader.Rows.Add(HeaderRow2);

            DataTable dtReportFooter = new DataTable();
            dtReportFooter.Columns.Add(new DataColumn("Footer", typeof(String))); //0
            DataRow FooterRow1 = dtReportFooter.NewRow();
            dtReportFooter.Rows.Add(FooterRow1);
            DataRow FooterRow2 = dtReportFooter.NewRow();
            dtReportFooter.Rows.Add(FooterRow2);
            DataRow FooterRow = dtReportFooter.NewRow();
            FooterRow[0] = "* * *  End Of Report * * *   ";
            dtReportFooter.Rows.Add(FooterRow);

            dtunmatchedsummary = (DataTable)ViewState["BankStatementUnMatched"];

            if (dtunmatchedsummary != null && dtunmatchedsummary.Rows.Count > 0)
            {
                if (Filter == 1)
                {
                    ex.ExportToExcelforExcel(dtunmatchedsummary, "Unmatched Summary", "Total", dtReportHeader, dtReportFooter);
                }
                if (Filter == 2)
                {
                    ex.ExportToPDF(dtunmatchedsummary, "Unmatched Summary", "Total", dtReportHeader, dtReportFooter);
                }
            }
        }
        [WebMethod]
        public static List<string> GetBankList(string reqTable, string reqFieldName)
        {
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationSettings.AppSettings["DBConnectionDefault"]);
            DataTable DT = new DataTable();
            DT.Rows.Clear();
            DT = oDBEngine.GetDataTable(reqTable, reqFieldName, null);
            List<string> obj = new List<string>();
            foreach (DataRow dr in DT.Rows)
            {

                obj.Add(Convert.ToString(dr["IntegrateMainAccount"]) + "|" + Convert.ToString(dr["MainAccount_AccountCode"]));
            }
            return obj;
        }

        protected void lnlDownloader_Click(object sender, EventArgs e)
        {
            string strFileName = "BankStatementFormat.csv";
            string strPath = (Convert.ToString(System.AppDomain.CurrentDomain.BaseDirectory) + Convert.ToString(ConfigurationManager.AppSettings["SaveFile"]) + strFileName);

            Response.ContentType = "application/CSV"; ;
            Response.AppendHeader("Content-Disposition", "attachment; filename=FileFormat.csv");
            Response.TransmitFile(strPath);
            Response.End(); 
        }
    }
}