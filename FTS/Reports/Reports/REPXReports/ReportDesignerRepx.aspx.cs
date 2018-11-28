using BusinessLogicLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DevExpress.DataAccess.Sql;
using DevExpress.XtraReports.UI;
using DataAccessLayer;
using System.Data.SqlClient;

namespace Reports.Reports.REPXReports
{
    public partial class ReportDesignerRepx : System.Web.UI.Page
    {
        BusinessLogicLayer.ReportLayout rpLayout = new BusinessLogicLayer.ReportLayout();
        BusinessLogicLayer.ReportData rptData = new BusinessLogicLayer.ReportData();

        protected void Page_Load(object sender, EventArgs e)
        {
            // The name for a file to save a report.
            if (!IsPostBack && !IsCallback)
            {
                StartDate.Value = HttpContext.Current.Request.QueryString["StartDate"];
                EndDate.Value = HttpContext.Current.Request.QueryString["EndDate"];
                if (string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["LoadrptName"]))
                {
                    // Run the Wizard to create a new report.
                    RptName.Value = HttpContext.Current.Request.QueryString["NewReport"];
                    string tempFile = RptName.Value;
                    CreateReport(tempFile);
                }
                else if (!string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["LoadrptName"]))
                {
                    // Load report.
                    RptName.Value = HttpContext.Current.Request.QueryString["LoadrptName"];
                    string tempFile = RptName.Value;
                    LoadReport(tempFile);
                }
            }
        }

        private void CreateReport(string fileName)
        {
            DevExpress.DataAccess.Sql.SqlDataSource sql = GenerateSqlDataSource();
            string RptModuleName = Convert.ToString(Session["NewRptModuleName"]);
            var rpt = new DevExpress.XtraReports.UI.XtraReport();
            string rptName = fileName;
            if (string.IsNullOrEmpty(Page.Title))
            {
                Page.Title = rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
            }
            XtraReport newXtraReport = new XtraReport();
            newXtraReport.DataSource = sql;
            ASPxReportDesigner1.OpenReport(newXtraReport);
        }

        private void LoadReport(string fileName)
        {
            string rptName = fileName;
            string filePath = "";
            string RptModuleName = Convert.ToString(Session["NewRptModuleName"]);
            if (string.IsNullOrEmpty(Page.Title))
            {
                Page.Title = rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
            }
            if (RptModuleName == "StockTrialSumm")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Summary/" + rptName + ".repx");
            }
            else if (RptModuleName == "StockTrialDet")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Details/" + rptName + ".repx");
            }
            if (RptModuleName == "StockTrialWH")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Warehouse/" + rptName + ".repx");
            }
            else if (RptModuleName == "StockTrial1")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial1/" + rptName + ".repx");
            }
            else if (RptModuleName == "Invoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "TSInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Transit/" + rptName + ".repx");
            }
            else if (RptModuleName == "Invoice_POS")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/SPOS/" + rptName + ".repx");
            }
            else if (RptModuleName == "Second_Hand")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SecondHandSales/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "POS_Duplicate")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/POSDUPLICATE/" + rptName + ".repx");
            }
            else if (RptModuleName == "CUSTRECPAY")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CustomerRecPay/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "VENDRECPAY")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/VendorRecPay/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "CBVUCHR")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankVoucher/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "PInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseInvoice/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "TPInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/TransitPurchaseInvoice/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "Sales_Return")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesReturn/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "PURCHASE_RET_REQ")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseRetRec/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "OLDUNTRECVD")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/OldUnitReceived/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "Purchase_Return")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseReturn/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "Install_Coupon")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/InstCoupon/" + rptName + ".repx");
            }
            else if (RptModuleName == "Proforma")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Proforma/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "LedgerPost")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Ledger/" + rptName + ".repx");
            }
            else if (RptModuleName == "BankBook")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankBook/BankBook/" + rptName + ".repx");
            }
            else if (RptModuleName == "CashBook")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankBook/CashBooK/" + rptName + ".repx");
            }
            else if (RptModuleName == "Porder")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseOrder/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "Sorder")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesOrder/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "BranchReq")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/BranchRequisition/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "BranchTranOut")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/BranchTransferOut/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "SChallan" || RptModuleName == "PDChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "PChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseChallan/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "ODSDChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/DeliveryChallan/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "RChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/CDelivery/" + rptName + ".repx");
            }
            else if (RptModuleName == "CONTRAVOUCHER")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/ContraVoucher/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "CUSTDRCRNOTE")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CustDrCrNote/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "VENDDRCRNOTE")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/VendDrCrNote/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "PIQuotation")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Proforma/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "JOURNALVOUCHER")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/JournalVoucher/DocDesign/Designes/" + rptName + ".repx");
            }
            //else if (RptModuleName == "PDChallan")
            //{
            //    filePath = Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/Pending/" + rptName + ".repx");
            //}
            DevExpress.DataAccess.Sql.SqlDataSource sql = GenerateSqlDataSource();
            XtraReport newXtraReport = XtraReport.FromFile(filePath, true);
            newXtraReport.LoadLayout(filePath);
            newXtraReport.DataSource = sql;
            ASPxReportDesigner1.OpenReport(newXtraReport);
        }

        private DevExpress.DataAccess.Sql.SqlDataSource GenerateSqlDataSource()
        {
            DevExpress.DataAccess.Sql.SqlDataSource result = new DevExpress.DataAccess.Sql.SqlDataSource("crmConnectionString");
            BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string RptModuleName = Convert.ToString(Session["NewRptModuleName"]);
            string Module_Name = Convert.ToString(Session["Module_Name"]);
            DataTable dtRptTables = new DataTable();
            string query = "";

            query = @"Select Query_Table_name from tbl_trans_ReportSql where Module_name = '" + Module_Name + "' order by Query_ID ";
            dtRptTables = oDbEngine.GetDataTable(query);
            string CustVendType = "";
            string SalesPurchaseType = "";
            //dtRptTables.TableName = "aaa";
            #region  for logo image
            string[] filePaths = new string[] { };
            string path = System.Web.HttpContext.Current.Server.MapPath("~");
            string path1 = path.Replace("Reports\\", "ERP.UI");
            string fullpath = path1.Replace("\\", "/");
            #endregion

            if (RptModuleName == "CUSTRECPAY" || RptModuleName == "CUSTDRCRNOTE")
            {
                CustVendType = "C";
            }
            if (RptModuleName == "VENDRECPAY" || RptModuleName == "VENDDRCRNOTE")
            {
                CustVendType = "V";
            }

            if (RptModuleName == "SChallan" || RptModuleName == "PDChallan" || RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "Second_Hand"
                || RptModuleName == "POS_Duplicate" || RptModuleName == "TSInvoice" || RptModuleName == "Sales_Return" || RptModuleName == "Sorder")
            {
                SalesPurchaseType = "S";
            }
            if (RptModuleName == "PChallan" || RptModuleName == "PInvoice" || RptModuleName == "TPInvoice" || RptModuleName == "Purchase_Return" || RptModuleName == "PURCHASE_RET_REQ" || RptModuleName == "Porder")
            {
                SalesPurchaseType = "P";
            }

            if (RptModuleName == "StockTrialSumm")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_MATERIALINOUTREG '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "StockTrialDet")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_MATERIALINOUTREGDET_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "StockTrialWH")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_MATERIALINOUTREGWH_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "StockTrial1")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_MATERIALINOUTREG1 '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "Install_Coupon")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_INSTALLATIONCOUPON_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + fullpath + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "POS_Duplicate" || RptModuleName == "Second_Hand" || RptModuleName == "PInvoice")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_TAXINVOICE '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + SalesPurchaseType + "','" + "35" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "TSInvoice" || RptModuleName == "TPInvoice")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_TRANSITSALEPURCHASE_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + SalesPurchaseType + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "ODSDChallan")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DELIVERYPENDINGCHALLAN_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "S" + "','" + "2" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "CUSTRECPAY" || RptModuleName == "VENDRECPAY")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CUSTVENDRECPAY '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + CustVendType + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "CBVUCHR")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CASHBANKVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "RChallan")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DELIVERYCHALLAN '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "Sales_Return" || RptModuleName == "Purchase_Return")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALERETURN_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + SalesPurchaseType + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "PURCHASE_RET_REQ")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_PURCHASERETURN_REQUEST_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + SalesPurchaseType + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "OLDUNTRECVD")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_OLDUNITRECEIVED_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "LedgerPost" || RptModuleName == "BankBook" || RptModuleName == "CashBook")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_LEDGERPOSTING '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "" + "','" + "" + "','" + "" + "','" + "" + "','" + "" + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "Sorder" || RptModuleName == "Porder")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASEORDER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + SalesPurchaseType + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "BranchReq")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_BRANCHREQ_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "BranchTranOut")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_BRANCHOUT_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "47" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "SChallan" || RptModuleName == "PDChallan" || RptModuleName == "PChallan")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASECHALLAN_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + SalesPurchaseType + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "CONTRAVOUCHER")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CONTRAVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "JOURNALVOUCHER")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_JOURNALVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "CUSTDRCRNOTE" || RptModuleName == "VENDDRCRNOTE")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DEBITCREDITNOTE_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + CustVendType + "','" + "L" + "'"));
                }
            }
            else if (RptModuleName == "PIQuotation")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_PROFORMAINVQUOTATION '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "" + "','" + "L" + "'"));
                }
            }

            DataTable dtRptRelation = new DataTable();
            string RelationQuery = "";

            RelationQuery = @"Select Parent_Query_name,Child_Query_name, Parent_Column_name,Child_Column_name from tbl_trans_ReportTableRelation where Module_name = '" + Module_Name + "' order by Query_ID ";
            dtRptRelation = oDbEngine.GetDataTable(RelationQuery);
            foreach (DataRow row in dtRptRelation.Rows)
            {
                result.Relations.Add(Convert.ToString(row[0]), Convert.ToString(row[1]), Convert.ToString(row[2]), Convert.ToString(row[3]));
            }

            result.RebuildResultSchema();
            return result;
        }

        // Save a report to a file.
        protected void ASPxReportDesigner1_SaveReportLayout(object sender, DevExpress.XtraReports.Web.SaveReportLayoutEventArgs e)
        {
            string FileName = "";
            string filePath = "";
            //String ReportModule = Convert.ToString(Session["NewRptModuleName"]);
            string ReportModule = HttpContext.Current.Request.QueryString["reportname"];
            if (!string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["NewReport"]))
            {
                FileName = HttpContext.Current.Request.QueryString["NewReport"] + "~N";
            }
            else if (!string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["LoadrptName"]))
            {
                FileName = HttpContext.Current.Request.QueryString["LoadrptName"];
            }
            XtraReport newXtraReport = new XtraReport();
            if (ReportModule == "StockTrialSumm")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Summary/" + FileName + ".repx");
            }
            else if (ReportModule == "StockTrialDet")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Details/" + FileName + ".repx");
            }
            else if (ReportModule == "StockTrialWH")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Warehouse/" + FileName + ".repx");
            }
            else if (ReportModule == "StockTrial1")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial1/" + FileName + ".repx");
            }
            else if (ReportModule == "Invoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "TSInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Transit/" + FileName + ".repx");
            }
            else if (ReportModule == "Invoice_POS")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/SPOS/" + FileName + ".repx");
            }
            else if (ReportModule == "Second_Hand")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SecondHandSales/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "POS_Duplicate")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/POSDUPLICATE/" + FileName + ".repx");
            }
            else if (ReportModule == "CUSTRECPAY")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CustomerRecPay/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "VENDRECPAY")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/VendorRecPay/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "CBVUCHR")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankVoucher/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "PInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseInvoice/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "TPInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/TransitPurchaseInvoice/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "Install_Coupon")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/InstCoupon/" + FileName + ".repx");
            }
            else if (ReportModule == "Proforma")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Proforma/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "LedgerPost")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Ledger/" + FileName + ".repx");
            }
            else if (ReportModule == "BankBook")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankBook/BankBook/" + FileName + ".repx");
            }
            else if (ReportModule == "CashBook")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankBook/CashBook/" + FileName + ".repx");
            }
            else if (ReportModule == "Porder")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseOrder/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "Sorder")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesOrder/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "BranchReq")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/BranchRequisition/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "BranchTranOut")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/BranchTransferOut/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "Sales_Return")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesReturn/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "PURCHASE_RET_REQ")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseRetRec/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "OLDUNTRECVD")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/OldUnitReceived/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "Purchase_Return")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseReturn/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "SChallan" || ReportModule == "PDChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "PChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseChallan/DocDesign/Normal/" + FileName + ".repx");
            }
            else if (ReportModule == "ODSDChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/DeliveryChallan/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "RChallan")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/CDelivery/" + FileName + ".repx");
            }
            else if (ReportModule == "CONTRAVOUCHER")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/ContraVoucher/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "CUSTDRCRNOTE")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/CustDrCrNote/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "VENDDRCRNOTE")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/VendDrCrNote/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "PIQuotation")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/Proforma/DocDesign/Designes/" + FileName + ".repx");
            }
            else if (ReportModule == "JOURNALVOUCHER")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/JournalVoucher/DocDesign/Designes/" + FileName + ".repx");
            }

            var bytarr = e.ReportLayout;
            Stream stream = new MemoryStream(bytarr);
            newXtraReport.LoadLayout(stream);
            newXtraReport.SaveLayout(filePath);
            ASPxReportDesigner1.JSProperties["cpSaveResult"] = "Design saved successfully.";
        }
    }
}