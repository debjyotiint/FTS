using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using BusinessLogicLayer;

namespace ERP.OMS.Reports
{
    public partial class Reports_TurnoverReportCM : System.Web.UI.Page, System.Web.UI.ICallbackEventHandler
    {
        PeriodicalReports pr = new PeriodicalReports();
        BusinessLogicLayer.Converter oconverter = new BusinessLogicLayer.Converter();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        DataSet ds = new DataSet();

        ExcelFile objExcel = new ExcelFile();
        DataTable dtExport = new DataTable();
        string data;

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
            if (HttpContext.Current.Session["userid"] == null)
            {
              //  Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
            if (!IsPostBack)
            {

                Page.ClientScript.RegisterStartupScript(GetType(), "JScript", "<script language='javascript'>Page_Load();</script>");
                Date();


            }
            //_____For performing operation without refreshing page___//
            String cbReference = Page.ClientScript.GetCallbackEventReference(this, "arg", "ReceiveServerData", "context");
            String callbackScript = "function CallServer(arg, context){ " + cbReference + ";}";
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "CallServer", callbackScript, true);
            //___________-end here___//

        }
        void Date()
        {
            DtFrom.EditFormatString = oconverter.GetDateFormat("Date");
            DtTo.EditFormatString = oconverter.GetDateFormat("Date");

            DtFrom.Value = Convert.ToDateTime(oDBEngine.GetDate().ToShortDateString());
            DtTo.Value = Convert.ToDateTime(oDBEngine.GetDate().ToShortDateString());

            SegmentnameFetch();

        }
        void SegmentnameFetch()
        {
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "1")
                litSegmentMain.InnerText = "NSE-CM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "4")
                litSegmentMain.InnerText = "BSE-CM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "15")
                litSegmentMain.InnerText = "CSE-CM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "19")
                litSegmentMain.InnerText = "MCXSX-CM";

            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "3")
                litSegmentMain.InnerText = "NSE-CDX";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "6")
                litSegmentMain.InnerText = "BSE-CDX";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "7")
                litSegmentMain.InnerText = "MCX-COMM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "8")
                litSegmentMain.InnerText = "MCXSX-CDX";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "9")
                litSegmentMain.InnerText = "NCDEX-COMM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "10")
                litSegmentMain.InnerText = "DGCX-COMM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "11")
                litSegmentMain.InnerText = "NMCE-COMM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "12")
                litSegmentMain.InnerText = "ICEX-COMM";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "13")
                litSegmentMain.InnerText = "USE-CDX";
            if (HttpContext.Current.Session["ExchangeSegmentID"].ToString().Trim() == "14")
                litSegmentMain.InnerText = "NSEL-SPOT";
        }

        string ICallbackEventHandler.GetCallbackResult()
        {
            return data;
        }
        void ICallbackEventHandler.RaiseCallbackEvent(string eventArgument)
        {
            string id = eventArgument.ToString();
            string[] idlist = id.Split('~');
            string str = "";
            string str1 = "";
            if (idlist[0] == "ComboChange")
            {
                //MainAcID = idlist[1];
            }
            else
            {
                string[] cl = idlist[1].Split(',');
                for (int i = 0; i < cl.Length; i++)
                {
                    if (idlist[0].ToString().Trim() == "Clients" || idlist[0].ToString().Trim() == "Company" || idlist[0].ToString().Trim() == "Broker")
                    {
                        string[] val = cl[i].Split(';');
                        string[] AcVal = val[0].Split('-');
                        if (str == "")
                        {

                            str = "'" + AcVal[0] + "'";
                            str1 = "'" + AcVal[0] + "'" + ";" + val[1];
                        }
                        else
                        {

                            str += ",'" + AcVal[0] + "'";
                            str1 += "," + "'" + AcVal[0] + "'" + ";" + val[1];
                        }
                    }
                    else
                    {
                        string[] val = cl[i].Split(';');
                        if (str == "")
                        {
                            str = val[0];
                            str1 = val[0] + ";" + val[1];
                        }
                        else
                        {
                            str += "," + val[0];
                            str1 += "," + val[0] + ";" + val[1];
                        }
                    }

                }


                if (idlist[0] == "Clients")
                {
                    data = "Clients~" + str;
                }
                else if (idlist[0] == "Broker")
                {
                    data = "Broker~" + str;
                }
                else if (idlist[0] == "Group")
                {
                    data = "Group~" + str;
                }
                else if (idlist[0] == "Branch")
                {
                    data = "Branch~" + str;
                }
                else if (idlist[0] == "BranchGroup")
                {
                    data = "BranchGroup~" + str;
                }
                else if (idlist[0] == "Company")
                {
                    data = "Company~" + str;
                }
                // for new products and scrip fetch end
                if (idlist[0] == "ScripsExchange")
                {
                    data = "ScripsExchange~" + str;
                }
                else if (idlist[0] == "Product")
                {
                    string SeriesIDs = null;
                    DataTable DT = oDBEngine.GetDataTable(@"Master_Equity Where Equity_ProductId in (
                Select Products_ID from Master_Products where (Products_ID=" + str + " or Products_DerivedFromID=" + str + @"))
                and Equity_ExchSegmentID in (1,2,4,5)", "Equity_SeriesID", null);
                    if (DT.Rows.Count > 0)
                    {
                        foreach (DataRow DrSeriesID in DT.Rows)
                        {
                            if (SeriesIDs == null) SeriesIDs = DrSeriesID[0].ToString();
                            else SeriesIDs = SeriesIDs + "," + DrSeriesID[0].ToString();
                        }
                    }
                    data = "Product~" + SeriesIDs;
                }
            }
        }
        public void BindGroup()
        {
            ddlgrouptype.Items.Clear();
            DataTable DtGroup = oDBEngine.GetDataTable("tbl_master_groupmaster", "distinct gpm_Type", null);
            if (DtGroup.Rows.Count > 0)
            {
                ddlgrouptype.DataSource = DtGroup;
                ddlgrouptype.DataTextField = "gpm_Type";
                ddlgrouptype.DataValueField = "gpm_Type";
                ddlgrouptype.DataBind();
                ddlgrouptype.Items.Insert(0, new ListItem("Select GroupType", "0"));
                DtGroup.Dispose();

            }
            else
            {
                ddlgrouptype.Items.Insert(0, new ListItem("Select GroupType", "0"));
            }

        }
        protected void btnhide_Click(object sender, EventArgs e)
        {

            if (ddlGroup.SelectedItem.Value.ToString().Trim() == "1")
            {
                if (HiddenField_Group.Value.ToString().Trim() == "")
                {
                    BindGroup();
                }
            }
        }
        protected void btnScreen_Click(object sender, EventArgs e)
        {
            Procedure();

        }
        void FnGeneRationCall(DataSet ds)
        {

            if (ds.Tables[0].Rows.Count > 0)
            {
                if (ddlGeneration.SelectedItem.Value.ToString() == "1")///Screen
                {
                    FnHtml(ds);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "fnRecord", "fnRecord('2');", true);
                }
                if (ddlGeneration.SelectedItem.Value.ToString() == "2")///Export
                {
                    if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Client" && DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "4")
                    {
                        ExportClientOrderWise(ds);
                    }
                    else
                    {
                        Export(ds);
                    }

                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "fnNoRecord", "fnRecord('1');", true);
            }
        }
        void Procedure()
        {
            //using (SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]))
            //{

            //SqlCommand cmd = new SqlCommand();
            //cmd.Connection = con;

            //if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Client")
            //{
            //    if (DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "11" || DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "12")
            //    {
            //        cmd.CommandText = "[Report_TuroverTotAcrossSegment]";
            //    }
            //    else
            //    {
            //        cmd.CommandText = "[Report_TuroverTotCm]";
            //    }
            //}
            //if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange")
            //{
            //    if (DdlrptViewExchange.SelectedItem.Value.ToString().Trim() == "10")
            //    {
            //        cmd.CommandText = "[Report_TuroverTotAcrossSegment]";
            //    }
            //    else
            //    {
            //        cmd.CommandText = "[Report_TuroverTotCm]";
            //    }
            //}
            //cmd.CommandType = CommandType.StoredProcedure;

            //cmd.Parameters.AddWithValue("@FromDate", DtFrom.Value);
            //cmd.Parameters.AddWithValue("@ToDate", DtTo.Value);

            string CompanyId = "";
            string ChkConsolidate = "";
            string ChkConsolidatedGrpBranch = "";
            string ReportFor = "";
            string ActivePassive = "";
            string ProClientSplit = "";
            string instrument = "";
            string Broker = "";
            string ClientId = "";
            string GrpType = "";
            string GrpId = "";

            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Client")
            {
                if (DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "11" || DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "12")
                {
                    if (RdbAllCompany.Checked)
                    {
                        CompanyId = "ALL";
                    }
                    else if (RdbCurrentCompany.Checked)
                    {
                        CompanyId = "'" + Session["LastCompany"].ToString().Trim() + "'";
                    }
                    else
                    {
                        CompanyId = HiddenField_Company.Value;
                    }
                    if (ChkCOnsolidatedAcrossSegment.Checked)
                    {
                        ChkConsolidate = "Y";
                    }
                    else
                    {
                        ChkConsolidate = "N";
                    }
                }
                else
                {

                    CompanyId = Session["LastCompany"].ToString();
                    if (ChkConsolidated.Checked)
                    {
                        ChkConsolidatedGrpBranch = "Chk";
                    }
                    else
                    {
                        ChkConsolidatedGrpBranch = "UnChk";
                    }
                    ReportFor = DdlRptFor.SelectedItem.Value.ToString().Trim();
                    ActivePassive = ChkActivePassive.Checked.ToString().Trim();
                    ProClientSplit = ChkShowProClientSplit.Checked.ToString().Trim();
                    if (rdbscrips.Checked)
                    {
                        if (rdInstrumentAll.Checked)
                        {
                            instrument = "ALL";
                        }
                        else
                        {
                            instrument = HiddenField_ScripsExchange.Value;
                        }
                    }
                    if (rdbAssets.Checked)
                    {
                        if (rdbunderlyingall.Checked)
                        {
                            instrument = "All";
                        }
                        else
                        {
                            instrument = HiddenField_Product.Value.ToString().Trim();
                        }
                    }
                }
            }
            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange")
            {
                if (DdlrptViewExchange.SelectedItem.Value.ToString().Trim() == "10")
                {
                    if (RdbAllCompany.Checked)
                    {
                        CompanyId = "ALL";
                    }
                    else if (RdbCurrentCompany.Checked)
                    {
                        CompanyId = "'" + Session["LastCompany"].ToString().Trim() + "'";
                    }
                    else
                    {
                        CompanyId = HiddenField_Company.Value;
                    }
                    if (ChkCOnsolidatedAcrossSegment.Checked)
                    {
                        ChkConsolidate = "Y";
                    }
                    else
                    {
                        ChkConsolidate = "N";
                    }
                }
                else
                {
                    CompanyId = Session["LastCompany"].ToString();
                    if (ChkConsolidated.Checked)
                    {
                        ChkConsolidatedGrpBranch = "Chk";
                    }
                    else
                    {
                        ChkConsolidatedGrpBranch = "UnChk";
                    }
                    ReportFor = DdlRptFor.SelectedItem.Value.ToString().Trim();
                    ActivePassive = ChkActivePassive.Checked.ToString().Trim();
                    ProClientSplit = ChkShowProClientSplit.Checked.ToString().Trim();
                    if (rdbscrips.Checked)
                    {
                        if (rdInstrumentAll.Checked)
                        {
                            instrument = "ALL";
                        }
                        else
                        {
                            instrument = HiddenField_ScripsExchange.Value;
                        }
                    }
                    if (rdbAssets.Checked)
                    {
                        if (rdInstrumentAll.Checked)
                        {
                            instrument = "All";
                        }
                        else
                        {
                            instrument = HiddenField_Product.Value.ToString().Trim();
                        }
                    }
                }
            }



            //if (rdbSegmentAll.Checked)
            //{
            //    cmd.Parameters.AddWithValue("@Segmentid", "ALL");

            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Segmentid", Convert.ToInt32(Session["usersegid"].ToString()));

            //}

            if (ddlviewby.SelectedItem.Value == "2")
            {
                Broker = "BO";
                if (rdbbrokerall.Checked)
                {
                    ClientId = "ALL";
                }
                else
                {
                    ClientId = HiddenField_Broker.Value;
                }

            }


            if (ddlviewby.SelectedItem.Value == "1")
            {
                Broker = "NA";
                if (rdbClientALL.Checked)
                {
                    ClientId = "ALL";
                }
                else
                {
                    ClientId = HiddenField_Client.Value;
                }
            }
            if (ddlGroup.SelectedItem.Value.ToString() == "0")
            {
                GrpType = "BRANCH";
                if (rdbranchAll.Checked)
                {
                    GrpId = "ALL";
                }
                else
                {
                    GrpId = HiddenField_Branch.Value;
                }
            }
            else if (ddlGroup.SelectedItem.Value.ToString() == "2")
            {
                GrpType = "BRANCHGROUP";
                if (rdbranchAll.Checked)
                {
                    GrpId = "ALL";
                }
                else
                {
                    GrpId = HiddenField_BranchGroup.Value;
                }
            }
            else
            {
                GrpType = ddlgrouptype.SelectedItem.Text.ToString().Trim();
                if (rdddlgrouptypeAll.Checked)
                {
                    GrpId = "ALL";
                }
                else
                {
                    GrpId = HiddenField_Group.Value;
                }
            }
            //cmd.Parameters.AddWithValue("@BranchHierchy", Session["userbranchHierarchy"].ToString());


            //if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange")
            //{
            //    cmd.Parameters.AddWithValue("@ReportView", DdlrptViewExchange.SelectedItem.Value.ToString().Trim());

            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@ReportView", DdlrptViewClient.SelectedItem.Value.ToString().Trim());

            //}

            //SqlDataAdapter da = new SqlDataAdapter();
            //da.SelectCommand = cmd;
            //cmd.CommandTimeout = 0;
            //ds.Reset();
            //ds.Clear();
            //da.Fill(ds);
            //da.Dispose();

            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Client")
            {
                if (DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "11" || DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "12")
                {
                    ds = pr.Report_TuroverTotAcrossSegment(DtFrom.Value.ToString(), DtTo.Value.ToString(), CompanyId, ChkConsolidate,
                        rdbSegmentAll.Checked ? "ALL" : Session["usersegid"].ToString(), Broker, ClientId, GrpType, GrpId, Session["userbranchHierarchy"].ToString(),
                        DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange" ? DdlrptViewExchange.SelectedItem.Value.ToString().Trim() : DdlrptViewClient.SelectedItem.Value.ToString().Trim());
                    // cmd.CommandText = "[Report_TuroverTotAcrossSegment]";
                }
                else
                {
                    ds = pr.Report_TuroverTotCm(DtFrom.Value.ToString(), DtTo.Value.ToString(), CompanyId, rdbSegmentAll.Checked ? "ALL" : Session["usersegid"].ToString(), Broker,
                        ClientId, GrpType, GrpId, Session["userbranchHierarchy"].ToString(), ChkConsolidatedGrpBranch, DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange" ? DdlrptViewExchange.SelectedItem.Value.ToString().Trim() : DdlrptViewClient.SelectedItem.Value.ToString().Trim(),
                        ReportFor, ActivePassive, ProClientSplit, instrument);
                    // cmd.CommandText = "[Report_TuroverTotCm]";
                }
            }
            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange")
            {
                if (DdlrptViewExchange.SelectedItem.Value.ToString().Trim() == "10")
                {
                    ds = pr.Report_TuroverTotAcrossSegment(DtFrom.Value.ToString(), DtTo.Value.ToString(), CompanyId, ChkConsolidate,
                       rdbSegmentAll.Checked ? "ALL" : Session["usersegid"].ToString(), Broker, ClientId, GrpType, GrpId, Session["userbranchHierarchy"].ToString(),
                       DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange" ? DdlrptViewExchange.SelectedItem.Value.ToString().Trim() : DdlrptViewClient.SelectedItem.Value.ToString().Trim());

                    // cmd.CommandText = "[Report_TuroverTotAcrossSegment]";
                }
                else
                {
                    ds = pr.Report_TuroverTotCm(DtFrom.Value.ToString(), DtTo.Value.ToString(), CompanyId, rdbSegmentAll.Checked ? "ALL" : Session["usersegid"].ToString(), Broker,
                        ClientId, GrpType, GrpId, Session["userbranchHierarchy"].ToString(), ChkConsolidatedGrpBranch, DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange" ? DdlrptViewExchange.SelectedItem.Value.ToString().Trim() : DdlrptViewClient.SelectedItem.Value.ToString().Trim(),
                        ReportFor, ActivePassive, ProClientSplit, instrument);
                    // cmd.CommandText = "[Report_TuroverTotCm]";
                }
            }
            ViewState["dataset"] = ds;
            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Client")
            {
                if (DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "12")
                {
                    if (ChkCOnsolidatedAcrossSegment.Checked)
                    {
                        ds.Tables[0].Columns.Remove("StatusOrder");
                        ds.Tables[0].Columns.Remove("Grp");
                    }

                }

            }
            FnGeneRationCall(ds);

            // }

        }
        void FnHtml(DataSet ds)
        {
            //////////For header
            String strHtmlheader = String.Empty;
            string str = null;
            if (ddlGroup.SelectedItem.Value.ToString() == "1")
            {
                str = "[" + ddlgrouptype.SelectedItem.Text.ToString().Trim() + "]";
            }
            str = ddlGroup.SelectedItem.Text.ToString().Trim() + " Wise " + str + " Period : " + oconverter.ArrangeDate2(DtFrom.Value.ToString()) + " - " + oconverter.ArrangeDate2(DtTo.Value.ToString());
            str = str + " ; Report For : " + DdlRptFor.SelectedItem.Text.ToString().Trim();

            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange")
            {
                str = str + " ; Report View : " + DdlrptViewExchange.SelectedItem.Text.ToString().Trim();
            }
            else
            {
                str = str + " ; Report View : " + DdlrptViewClient.SelectedItem.Text.ToString().Trim();
            }
            strHtmlheader = "<table width=\"100%\" border=" + Convert.ToChar(34) + 1 + Convert.ToChar(34) + " cellpadding=" + 0 + " cellspacing=" + 0 + " class=" + Convert.ToChar(34) + "gridcellleft" + Convert.ToChar(34) + ">";
            strHtmlheader += "<tr><td align=\"left\" colspan=" + ds.Tables[0].Columns.Count + " style=\"color:Blue;\">" + str + "</td></tr></table>";


            ////////Detail Display
            String strHtml = String.Empty;
            strHtml = "<table width=\"100%\" border=" + Convert.ToChar(34) + 1 + Convert.ToChar(34) + " cellpadding=" + 0 + " cellspacing=" + 0 + " class=" + Convert.ToChar(34) + "gridcellleft" + Convert.ToChar(34) + ">";



            //////////////TABLE HEADER BIND
            strHtml += "<tr style=\"background-color: #DBEEF3;\">";
            for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
            {
                strHtml += "<td align=\"center\" style=\"font-size:smaller;\" nowrap=nowrap;><b>" + ds.Tables[0].Columns[i].ColumnName + "</b></td>";
            }
            strHtml += "</tr>";

            int flag = 0;
            foreach (DataRow dr1 in ds.Tables[0].Rows)
            {
                flag = flag + 1;
                strHtml += "<tr id=\"tr_id" + flag + "&" + GetRowColor(flag) + "\" onclick=heightlight(this.id) style=\"background-color: " + GetRowColor(flag) + " ;text-align:center\">";
                for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                {
                    if (dr1[j] != DBNull.Value)
                    {
                        if (dr1[j].ToString().Trim().StartsWith("Total") || dr1[j].ToString().Trim().StartsWith("**") || dr1[j].ToString().Trim().StartsWith("Exchange"))
                        {
                            strHtml += "<td align=\"left\" style=\"font-size:smaller;\"  nowrap=nowrap; title=\"" + ds.Tables[0].Columns[j].ColumnName + "\"><b>" + dr1[j] + "</b></td>";
                        }
                        else if (dr1[j].ToString().Trim().StartsWith("Test"))
                        {
                            strHtml += "<td>&nbsp;</td>";
                        }
                        else
                        {
                            if (IsNumeric(dr1[j].ToString()) == true)
                            {
                                strHtml += "<td align=\"right\" style=\"font-size:smaller;\"  nowrap=nowrap; title=\"" + ds.Tables[0].Columns[j].ColumnName + "\">" + dr1[j] + "</td>";

                            }
                            else
                            {
                                strHtml += "<td align=\"left\" style=\"font-size:smaller;\"  nowrap=nowrap; title=\"" + ds.Tables[0].Columns[j].ColumnName + "\">" + dr1[j] + "</td>";

                            }
                        }
                    }
                    else
                    {
                        strHtml += "<td>&nbsp;</td>";
                    }
                }

                strHtml += "</tr>";
            }
            strHtml += "</table>";
            DivHeader.InnerHtml = strHtmlheader;
            Divdisplay.InnerHtml = strHtml;

        }
        protected string GetRowColor(int i)
        {
            if (i++ % 2 == 0)
                return "#fff0f5";
            else
                return "White";
        }
        public static bool IsNumeric(object value)
        {
            double dbl;
            return double.TryParse(value.ToString(), System.Globalization.NumberStyles.Any, System.Globalization.NumberFormatInfo.InvariantInfo, out dbl);
        }
        protected void btnExcel_Click(object sender, EventArgs e)
        {
            Procedure();
        }
        void Export(DataSet ds)
        {
            DataTable dtExport = ds.Tables[0].Copy();

            string str = null;
            if (ddlGroup.SelectedItem.Value.ToString() == "1")
            {
                str = "[" + ddlgrouptype.SelectedItem.Text.ToString().Trim() + "]";
            }
            str = ddlGroup.SelectedItem.Text.ToString().Trim() + " Wise " + str + " Period : " + oconverter.ArrangeDate2(DtFrom.Value.ToString()) + " - " + oconverter.ArrangeDate2(DtTo.Value.ToString());
            str = str + " ; Report For : " + DdlRptFor.SelectedItem.Text.ToString().Trim();

            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Exchange")
            {
                str = str + " ; Report View : " + DdlrptViewExchange.SelectedItem.Text.ToString().Trim();

            }
            else
            {
                str = str + " ; Report View : " + DdlrptViewClient.SelectedItem.Text.ToString().Trim();

            }


            DataTable dtReportHeader = new DataTable();
            DataTable dtReportFooter = new DataTable();

            DataTable CompanyName = oDBEngine.GetDataTable("tbl_master_company", "cmp_Name", " cmp_internalId='" + Session["LastCompany"].ToString() + "'");
            dtReportHeader.Columns.Add(new DataColumn("Header", typeof(String))); //0
            DataRow HeaderRow = dtReportHeader.NewRow();
            HeaderRow[0] = CompanyName.Rows[0][0].ToString();
            dtReportHeader.Rows.Add(HeaderRow);
            DataRow DrRowR1 = dtReportHeader.NewRow();
            DrRowR1[0] = str.ToString().Trim();
            dtReportHeader.Rows.Add(DrRowR1);


            DataRow HeaderRow1 = dtReportHeader.NewRow();
            dtReportHeader.Rows.Add(HeaderRow1);
            DataRow HeaderRow2 = dtReportHeader.NewRow();
            dtReportHeader.Rows.Add(HeaderRow2);

            dtReportFooter.Columns.Add(new DataColumn("Footer", typeof(String))); //0
            DataRow FooterRow1 = dtReportFooter.NewRow();
            dtReportFooter.Rows.Add(FooterRow1);
            DataRow FooterRow2 = dtReportFooter.NewRow();
            dtReportFooter.Rows.Add(FooterRow2);
            DataRow FooterRow = dtReportFooter.NewRow();
            FooterRow[0] = "* * *  End Of Report * * *   ";
            dtReportFooter.Rows.Add(FooterRow);

            objExcel.ExportToExcelforExcel(dtExport, "Turnover & TOT Reports", "Total:", dtReportHeader, dtReportFooter);

        }
        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            ds = (DataSet)ViewState["dataset"];
            if (DdlRptFor.SelectedItem.Value.ToString().Trim() == "Client" && DdlrptViewClient.SelectedItem.Value.ToString().Trim() == "4")
            {
                ExportClientOrderWise(ds);
            }
            else
            {
                Export(ds);
            }
        }
        void ExportClientOrderWise(DataSet ds)
        {
            //ds.Tables[0].WriteXmlSchema("E:\\RPTXSD\\TotOrderWise.xsd");
            ReportDocument report = new ReportDocument();
            report.PrintOptions.PaperOrientation = CrystalDecisions.Shared.PaperOrientation.Landscape;
            string tmpPdfPath = string.Empty;
            tmpPdfPath = HttpContext.Current.Server.MapPath("..\\Reports\\TotReportOrderWise.rpt");
            report.Load(tmpPdfPath);
            report.SetDataSource(ds.Tables[0]);
            report.Subreports["OrderWiseTot"].SetDataSource(ds.Tables[0]);
            report.VerifyDatabase();
            report.ExportToHttpResponse(CrystalDecisions.Shared.ExportFormatType.Excel, HttpContext.Current.Response, true, "Turnover Report Order Wise");
            report.Dispose();
            GC.Collect();
        }
    }
}