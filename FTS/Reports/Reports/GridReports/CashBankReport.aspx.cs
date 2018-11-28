﻿using DataAccessLayer;
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
using System.Collections;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using DevExpress.Data;
using System.Threading.Tasks;
using DevExpress.XtraPrinting;
using DevExpress.Export;
using System.Drawing;

namespace Reports.Reports.GridReports
{
    public partial class CashBankReport : System.Web.UI.Page
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        decimal TotalDebit = 0, TotalCredit = 0;
        decimal _totalDebit = 0, _totalCredit = 0, _totalBalance = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["CashBankReportData"] = null;
                
                //lookupBranch.DataSource = GetBranchList();
                //Rev Debashis && Implement Head Branch
                //lookupBranch.DataBind();
                BranchHoOffice();
                //End of Rev Debashis && Implement Head Branch

                //lookupCashBank.DataSource = GetCashBankList();
                lookupCashBank.DataBind();

                //lookupUser.DataSource = GetUserList();
                //Rev Debashis && Block User parameter
                //lookupUser.DataBind();
                //lookupLedger.DataSource = GetLedgerList();
                //lookupLedger.DataBind();
                //End of Rev Debashis && Block User parameter

                string strSubledgerchk = (chksubledger.Checked) ? "1" : "0";
                if (Convert.ToString(strSubledgerchk) == "0")
                {
                    ShowGrid.Columns[12].Visible = false;
                }
                else
                {
                    ShowGrid.Columns[12].Visible = true;
                }

                string strFinYear = Convert.ToString(Session["LastFinYear"]);
                DataTable dt = oDBEngine.GetDataTable("Select FinYear_Code,FinYear_StartDate,FinYear_EndDate From Master_FinYear Where FinYear_Code='" + strFinYear + "'");
                if (dt != null && dt.Rows.Count > 0)
                {
                    string strStartDate = Convert.ToString(dt.Rows[0]["FinYear_StartDate"]);
                    DateTime StartDate = Convert.ToDateTime(strStartDate);

                    //ASPxFromDate.Value = StartDate;
                    ASPxFromDate.Value = DateTime.Now;
                    ASPxToDate.Value = DateTime.Now;
                }
                else
                {
                    ASPxFromDate.Value = DateTime.Now;
                    ASPxToDate.Value = DateTime.Now;
                }
            }
        }

        #region Database Details

        //Rev Debashis && Implement Head Branch
        public void BranchHoOffice()
        {
            CommonBL bll1 = new CommonBL();
            DataTable stbill = new DataTable();
            stbill = bll1.GetBranchheadoffice("HO");
            if (stbill.Rows.Count > 0)
            {
                ddlbranchHO.DataSource = stbill;
                ddlbranchHO.DataTextField = "Code";
                ddlbranchHO.DataValueField = "branch_id";
                ddlbranchHO.DataBind();
                ddlbranchHO.Items.Insert(0, new ListItem("All", "All"));
            }
        }
        
        //public DataTable GetBranchList()
        //{
        //    try
        //    {
        //        string userbranch = Convert.ToString(Session["userbranchHierarchy"]);
        //        DataTable dt = oDBEngine.GetDataTable("Select branch_id as Branch_Id,branch_description as Branch_Name from tbl_master_branch  where branch_id in (select s FROM dbo.GetSplit(',','" + userbranch + "')) order by branch_code");
        //        return dt;
        //    }
        //    catch
        //    {
        //        return null;
        //    }
        //}
        //End of Rev Debashis && Implement Head Branch
        public DataTable GetCashBankList()
        {
            string query = "", branchList = "";
            string strType = Convert.ToString(ddlType.SelectedValue);

            List<object> BranchList = lookupBranch.GridView.GetSelectedFieldValues("ID");
            foreach (object branchIDs in BranchList)
            {
                branchList += "," + branchIDs;
            }
            branchList = branchList.TrimStart(',');

            if (strType == "Bank")
            {
                lookupCashBank.Columns["Name"].Caption = "Bank Name";
            }
            else if (strType == "Cash")
            {
                lookupCashBank.Columns["Name"].Caption = "Cash Name";
            }

            try
            {
                if (branchList.Trim() != "")
                {
                    if (strType == "Bank")
                    {
                        query = @"Select MainAccount_ReferenceID AS ID, MainAccount_Name as Name
                            from Master_MainAccount WHERE MainAccount_BankCashType='Bank' AND MainAccount_PaymentType<>'Card' AND MainAccount_branchId IN(" + Convert.ToString(branchList) + ")  " +
                               "union ALL " +
                               "Select MainAccount_ReferenceID AS ID, MainAccount_Name as Name " +
                               "from Master_MainAccount WHERE MainAccount_BankCashType='Bank' AND MainAccount_PaymentType<>'Card' AND MainAccount_branchId= 0 and " +
                               "not exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID) " +
                               "union ALL " +
                               "Select MainAccount_ReferenceID AS ID, MainAccount_Name as Name " +
                               "from Master_MainAccount WHERE MainAccount_BankCashType='Bank' AND MainAccount_PaymentType<>'Card' AND MainAccount_branchId= 0 and " +
                               "exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID and branch_id IN (" + Convert.ToString(branchList) + "))";
                    }
                    else if (strType == "Cash")
                    {
                        query = @"Select MainAccount_ReferenceID AS ID, MainAccount_Name as Name 
                                from Master_MainAccount WHERE MainAccount_BankCashType='Cash' AND MainAccount_branchId IN(" + Convert.ToString(branchList) + ")  " +
                                    "union ALL " +
                                    "Select MainAccount_ReferenceID AS ID, MainAccount_Name as Name " +
                                    "from Master_MainAccount WHERE MainAccount_BankCashType='Cash' AND MainAccount_branchId= 0 and " +
                                    "not exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID) " +
                                    "union ALL " +
                                    "Select MainAccount_ReferenceID AS ID, MainAccount_Name as Name " +
                                    "from Master_MainAccount WHERE MainAccount_BankCashType='Cash' AND MainAccount_branchId= 0 and " +
                                    "exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID and branch_id IN(" + Convert.ToString(branchList) + "))";
                    }
                }

                DataTable dt = oDBEngine.GetDataTable(query);
                return dt;
            }
            catch
            {
                return null;
            }
        }

        //Rev Debashis && Implement Head Branch
        //public DataTable GetUserList()
        //{
        //    string query = "", branchList = "";

        //    List<object> BranchList = lookupBranch.GridView.GetSelectedFieldValues("Branch_Id");
        //    foreach (object branchIDs in BranchList)
        //    {
        //        branchList += "," + branchIDs;
        //    }
        //    branchList = branchList.TrimStart(',');

        //    try
        //    {
        //        query = @"Select user_id AS ID, user_name as 'User' from tbl_master_user WHERE user_branchId IN(" + Convert.ToString(branchList) + ") ORDER BY user_name";
        //        DataTable dt = oDBEngine.GetDataTable(query);
        //        return dt;
        //    }
        //    catch
        //    {
        //        return null;
        //    }
        //}
//        public DataTable GetLedgerList()
//        {
//            string query = "", branchList = "";

//            List<object> BranchList = lookupBranch.GridView.GetSelectedFieldValues("Branch_Id");
//            foreach (object branchIDs in BranchList)
//            {
//                branchList += "," + branchIDs;
//            }
//            branchList = branchList.TrimStart(',');

//            try
//            {
//                if (Convert.ToString(branchList).Trim() != "")
//                {
//                    query = @"SELECT * FROM ( 
//                    select A.MainAccount_ReferenceID AS ID,A.MainAccount_AccountCode AS 'Doc_Code',A.MainAccount_Name AS 'Description' 
//                    FROM Master_MainAccount A WHERE A.MainAccount_branchId in(0,'')
//                    UNION ALL 
//                    select A.MainAccount_ReferenceID AS ID,A.MainAccount_AccountCode AS 'Doc Code',A.MainAccount_Name AS 'Description' 
//                    FROM Master_MainAccount A WHERE A.MainAccount_branchId in(" + Convert.ToString(branchList) + ")) AA ORDER BY Description ";
//                }
//                else
//                {
//                    query = @"select A.MainAccount_ReferenceID AS ID,A.MainAccount_AccountCode AS 'Doc_Code',A.MainAccount_Name AS 'Description' 
//                    FROM Master_MainAccount A WHERE A.MainAccount_branchId in(0,'') ORDER BY A.MainAccount_Name ";
//                }

//                DataTable dt = oDBEngine.GetDataTable(query);
//                return dt;
//            }
//            catch
//            {
//                return null;
//            }
//        }
        //End of Rev Debashis && Implement Head Branch
        
        protected void Componentbranch_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string FinYear = Convert.ToString(Session["LastFinYear"]);

            if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            {
                DataTable ComponentTable = new DataTable();
                string Hoid = e.Parameter.Split('~')[1];
                if (Hoid != "All")
                {
                    ComponentTable = GetBranch(Convert.ToString(HttpContext.Current.Session["userbranchHierarchy"]), Hoid);

                    if (ComponentTable.Rows.Count > 0)
                    {
                        Session["SI_ComponentData_Branch"] = ComponentTable;
                        lookupBranch.DataSource = ComponentTable;
                        lookupBranch.DataBind();
                    }
                }
                else
                {
                    ComponentTable = oDBEngine.GetDataTable("select * from(select branch_id as ID,branch_description,branch_code from tbl_master_branch a where a.branch_id=1 union all select branch_id as ID,branch_description,branch_code from tbl_master_branch b where b.branch_parentId=1) a order by branch_description");
                    Session["SI_ComponentData_Branch"] = ComponentTable;
                    lookupBranch.DataSource = ComponentTable;
                    lookupBranch.DataBind();
                }
            }
        }

        public DataTable GetBranch(string BRANCH_ID, string Ho)
        {
            DataTable dt = new DataTable();
            SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            SqlCommand cmd = new SqlCommand("GetFinancerBranchfetchhowise", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Branch", BRANCH_ID);
            cmd.Parameters.AddWithValue("@Hoid", Ho);
            cmd.CommandTimeout = 0;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            da.Fill(dt);
            cmd.Dispose();
            con.Dispose();

            return dt;
        }
        //End of Rev Debashis && Implement Head Branch

        public DataTable GetCashBankBook()
        {
            //Rev Debashis && Implement Head Branch
            //string branchList = "", cashbankList = "", userList = "", ledgerList = "";
            string branchList = "", cashbankList = "";
            //End of Rev Debashis && Implement Head Branch
            string strCompany = Convert.ToString(Session["LastCompany"]);
            string strFinYear = Convert.ToString(Session["LastFinYear"]);
            string strFromDate = Convert.ToDateTime(ASPxFromDate.Value).ToString("yyyy-MM-dd");
            string strToDate = Convert.ToDateTime(ASPxToDate.Value).ToString("yyyy-MM-dd");
            string strType = Convert.ToString(ddlType.SelectedValue);
            string strSubledger = (chksubledger.Checked) ? "1" : "0";
            if (Convert.ToString(strSubledger) == "0")
            {
                ShowGrid.Columns[12].Visible = false;
            }
            else
            {
                ShowGrid.Columns[12].Visible = true;
            }

            List<object> BranchList = lookupBranch.GridView.GetSelectedFieldValues("ID");
            foreach (object branchIDs in BranchList)
            {
                branchList += "," + branchIDs;
            }
            branchList = branchList.TrimStart(',');

            List<object> CashBankList = lookupCashBank.GridView.GetSelectedFieldValues("ID");
            foreach (object cashbankIDs in CashBankList)
            {
                cashbankList += "," + cashbankIDs;
            }
            cashbankList = cashbankList.TrimStart(',');

            //Rev Debashis && Block User parameter
            //List<object> UserList = lookupUser.GridView.GetSelectedFieldValues("ID");
            //foreach (object userIDs in UserList)
            //{
            //    userList += "," + userIDs;
            //}
            //userList = userList.TrimStart(',');

            //List<object> LedgerList = lookupLedger.GridView.GetSelectedFieldValues("ID");
            //foreach (object ledgerIDs in LedgerList)
            //{
            //    ledgerList += "," + ledgerIDs;
            //}
            //ledgerList = ledgerList.TrimStart(',');
            //End of Rev Debashis && Block User parameter

            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_CashBankBook_Report");
                proc.AddPara("@COMPANYID", strCompany);
                proc.AddPara("@FROMDATE", strFromDate);
                proc.AddPara("@TODATE", strToDate);
                proc.AddPara("@FINYEAR", strFinYear);
                proc.AddPara("@BRANCH_ID", branchList);
                proc.AddPara("@CASHBANKTYPE", strType);
                proc.AddPara("@CASHBANKID", cashbankList);
                //Rev Debashis && Block User parameter
                //proc.AddPara("@USERID", userList);
                //proc.AddPara("@LEDGERID", ledgerList);
                //End of Rev Debashis && Block User parameter
                proc.AddPara("@MODULE_TYPE", "Cash_Bank");
                proc.AddPara("@ISSUBLEDGER", (chksubledger.Checked) ? "1" : "0");
                dt = proc.GetTable();
                return dt;
            }
            catch
            {
                return null;
            }
        }

        #endregion

        #region Lookup Details

        protected void lookupBranch_DataBinding(object sender, EventArgs e)
        {
            //Rev Debashis && Implement Head Branch
            //lookupBranch.DataSource = GetBranchList();
            if (Session["SI_ComponentData_Branch"] != null)
            {
                lookupBranch.DataSource = (DataTable)Session["SI_ComponentData_Branch"];
            }
            //End of Rev Debashis && Implement Head Branch
        }

        protected void lookupCashBank_DataBinding(object sender, EventArgs e)
        {
            lookupCashBank.DataSource = GetCashBankList();
        }

        //Rev Debashis && Block User parameter
        //protected void lookupUser_DataBinding(object sender, EventArgs e)
        //{
        //    lookupUser.DataSource = GetUserList();
        //}

        //protected void lookupLedger_DataBinding(object sender, EventArgs e)
        //{
        //    lookupLedger.DataSource = GetLedgerList();
        //}
        //End of Rev Debashis && Block User parameter

        #endregion

        #region CallBackPanel Details

        protected void CashBankPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            lookupCashBank.GridView.Selection.CancelSelection();
            lookupCashBank.DataSource = GetCashBankList();
            lookupCashBank.DataBind();
        }

        //protected void UserPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        //{
        //    lookupUser.GridView.Selection.CancelSelection();
        //    lookupUser.DataSource = GetUserList();
        //    lookupUser.DataBind();
        //}

        //protected void LedgerPanel_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        //{
        //    lookupLedger.GridView.Selection.CancelSelection();
        //    lookupLedger.DataSource = GetLedgerList();
        //    lookupLedger.DataBind();
        //}

        #endregion

        #region Export Details

        protected void drdExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                bindexport(Filter);
            }
        }
        public void bindexport(int Filter)
        {
            string filename = "Cash Bank Report";
            exporter.FileName = filename;
            string FileHeader = "";

            exporter.FileName = filename;

            BusinessLogicLayer.Reports RptHeader = new BusinessLogicLayer.Reports();

            FileHeader = RptHeader.CommonReportHeader(Convert.ToString(Session["LastCompany"]), Convert.ToString(Session["LastFinYear"]), true, true, true, true, true) + Environment.NewLine + "Cash/Bank Book Report" + Environment.NewLine + "For the period " + Convert.ToDateTime(ASPxFromDate.Date).ToString("dd-MM-yyyy") + " To " + Convert.ToDateTime(ASPxToDate.Date).ToString("dd-MM-yyyy");
            exporter.RenderBrick += exporter_RenderBrick;
            exporter.PageHeader.Left = FileHeader;
            exporter.PageHeader.Font.Size = 10;
            exporter.PageHeader.Font.Name = "Tahoma";

            //exporter.PageFooter.Center = "[Page # of Pages #]";
            //exporter.PageFooter.Right = "[Date Printed]";
            exporter.GridViewID = "ShowGrid";
            switch (Filter)
            {
                case 1:
                    exporter.WritePdfToResponse();
                    break;
                case 2:
                    exporter.WriteXlsxToResponse(new XlsxExportOptionsEx() { ExportType = ExportType.WYSIWYG });
                    break;
                case 3:
                    exporter.WriteRtfToResponse();
                    break;
                case 4:
                    exporter.WriteCsvToResponse();
                    break;

                default:
                    return;
            }
        }
        protected void exporter_RenderBrick(object sender, ASPxGridViewExportRenderingEventArgs e)
        {
            e.BrickStyle.BackColor = Color.White;
            e.BrickStyle.ForeColor = Color.Black;
        }
        #endregion

        #region Grid Details

        protected void ShowGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            // ShowGrid.DataSource = GetCashBankBook();
            Session["CashBankReportData"] = GetCashBankBook();
            ShowGrid.DataBind();

            //ShowGrid.ExpandRow(0);
            ShowGrid.ExpandAll();
        }
        protected void ShowGrid1_DataBinding(object sender, EventArgs e)
        {
            DataTable cashbakdatarecord = (DataTable)Session["CashBankReportData"];
            if (cashbakdatarecord != null)
            {
                ShowGrid.DataSource = cashbakdatarecord;
            }
        }
        protected void ShowGrid_SummaryDisplayText(object sender, ASPxGridViewSummaryDisplayTextEventArgs e)
        {
            if (e.Item.FieldName == "CREDIT")
            {
                TotalCredit = Convert.ToDecimal(e.Value);
            }
            else if (e.Item.FieldName == "DEBIT")
            {
                TotalDebit = Convert.ToDecimal(e.Value);
            }

            if (e.Item.FieldName == "Closebal_DBCR")
            {
                if ((TotalDebit - TotalCredit) > 0)
                {
                    e.Text = "Dr";
                }
                else if ((TotalDebit - TotalCredit) < 0)
                {
                    e.Text = "Cr";
                }
                else
                {
                    e.Text = "";
                }
            }
            else if (e.Item.FieldName == "Particulars")
            {
                e.Text = "Net Total";
            }
            else if (e.Item.FieldName == "Closing_Balance")
            {
                e.Text = Convert.ToString(Math.Abs((TotalDebit - TotalCredit)));
            }
            else
            {
                e.Text = string.Format("{0}", e.Value);
            }
        }
        protected void ASPxGridView1_CustomSummaryCalculate(object sender, DevExpress.Data.CustomSummaryEventArgs e)
        {
            string summaryTAG = (e.Item as ASPxSummaryItem).Tag;

            if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Start)
            {
                _totalDebit = 0;
                _totalCredit = 0;
                _totalBalance = 0;
            }
            else if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Calculate)
            {
                _totalDebit += Convert.ToDecimal(e.GetValue("DEBIT"));
                _totalCredit += Convert.ToDecimal(e.GetValue("CREDIT"));
                _totalBalance += Convert.ToDecimal(e.GetValue("Closing_Balance"));
            }
            else if (e.SummaryProcess == DevExpress.Data.CustomSummaryProcess.Finalize)
            {
                switch (summaryTAG)
                {
                    case "Item_Debit":
                        e.TotalValue = _totalDebit;
                        break;
                    case "Item_Credit":
                        e.TotalValue = _totalCredit;
                        break;
                    case "Item_Balance":
                        e.TotalValue = Math.Abs((_totalDebit - _totalCredit));
                        break;
                    case "Item_Particulars":
                        e.TotalValue = "Closing Total";
                        break;
                    case "Item_DBCR":
                        if ((_totalDebit - _totalCredit) > 0) e.TotalValue = "Dr";
                        else if ((_totalDebit - _totalCredit) < 0) e.TotalValue = "Cr";
                        else e.TotalValue = "";
                        break;
                }
            }
        }

        #endregion
    }
}