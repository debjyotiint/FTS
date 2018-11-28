using BusinessLogicLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.DataAccess.Sql;
using DevExpress.XtraReports.UI;
using DataAccessLayer;
using DevExpress.Web;
using System.Net.Mail;
using System.Drawing;
using DevExpress.XtraPrinting.Drawing;

namespace Reports.Reports.REPXReports
{
    public partial class RepxReportViewer : System.Web.UI.Page
    {
        BusinessLogicLayer.ReportLayout rpLayout = new BusinessLogicLayer.ReportLayout();
        BusinessLogicLayer.ReportData rptData = new BusinessLogicLayer.ReportData();
        public string redirectReportKey = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            string tempFile = HttpContext.Current.Request.QueryString["Previewrpt"];
            StartDate.Value = HttpContext.Current.Request.QueryString["StartDate"];
            EndDate.Value = HttpContext.Current.Request.QueryString["EndDate"];
            string PrintType = HttpContext.Current.Request.QueryString["PrintOption"];
            String RptModuleName = HttpContext.Current.Request.QueryString["reportname"];
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine();
            string rptName = tempFile;
            string filePath = "";
            string ExportFileName = "";
            string ReportType = "";
            //String RptModuleName = Convert.ToString(Session["NewRptModuleName"]);
            if (RptModuleName == "StockTrialSumm")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Stock Trial Summary" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Summary/" + rptName + ".repx");
            }
            else if (RptModuleName == "StockTrialDet")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Stock Trial Details" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Details/" + rptName + ".repx");
            }
            if (RptModuleName == "StockTrialWH")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Stock Trial Warehouse" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Warehouse/" + rptName + ".repx");
            }
            else if (RptModuleName == "Invoice")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Sale Invoice-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "TSInvoice")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Transit Sale Invoice-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Transit/" + rptName + ".repx");
            }
            else if (RptModuleName == "PInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseInvoice/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "TPInvoice")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/TransitPurchaseInvoice/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "Invoice_POS")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Sale Invoice(POS)-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/SPOS/" + rptName + ".repx");
            }
            else if (RptModuleName == "Second_Hand")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Second hand sales-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SecondHandSales/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "POS_Duplicate")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "POS Bill Print-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/POSDUPLICATE/" + rptName + ".repx");
            }
            else if (RptModuleName == "CUSTRECPAY")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Customer Rec/Pay-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/CustomerRecPay/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "VENDRECPAY")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Vendor Rec/Pay-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/VendorRecPay/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "CBVUCHR")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Cash Bank Voucher-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankVoucher/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "ODSDChallan")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Delivery Challan(ODSD) " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/DeliveryChallan/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "RChallan")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Road Challan " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/CDelivery/" + rptName + ".repx");
            }
            else if (RptModuleName == "Sales_Return")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Sales Return " + rptName.Split('~')[0];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesReturn/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "PURCHASE_RET_REQ")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Purchase Return Request-" + rptName.Split('~')[0];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseRetRec/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "OLDUNTRECVD")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Old Unit Received " + rptName.Split('~')[0];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/OldUnitReceived/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "Purchase_Return")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Purchase Return " + rptName.Split('~')[0];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseReturn/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "Install_Coupon")
            {
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/InstCoupon/" + rptName + ".repx");
            }
            else if (RptModuleName == "LedgerPost")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Ledger Posting Details " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/Ledger/" + rptName + ".repx");
            }
            else if (RptModuleName == "BankBook")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Bank Book Details " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankBook/BankBook/" + rptName + ".repx");
            }
            else if (RptModuleName == "CashBook")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Cash Book Details " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/CashBankBook/CashBook/" + rptName + ".repx");
            }
            else if (RptModuleName == "Porder")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Purchase Order " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseOrder/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "Sorder")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Sales Order " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesOrder/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "BranchReq")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Branch Requisition " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/BranchRequisition/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "BranchTranOut")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Branch Transfer Out " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/BranchTransferOut/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "SChallan" || RptModuleName == "PDChallan")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    if (RptModuleName == "SChallan")
                    {
                        Page.Title = "Sales Challan " + rptName.Split('~')[0];
                    }
                    else
                    {
                        Page.Title = "Pending Delivery List " + rptName.Split('~')[0];
                    }
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "PChallan")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Purchase Challan " + rptName.Split('~')[0];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/PurchaseChallan/DocDesign/Normal/" + rptName + ".repx");
            }
            else if (RptModuleName == "CONTRAVOUCHER")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Contra Voucher" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/ContraVoucher/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "JOURNALVOUCHER")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Journal Voucher" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/JournalVoucher/DocDesign/Designes/" + rptName + ".repx");
            }
            else if (RptModuleName == "CUSTDRCRNOTE")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Customer Debit/Credit Note" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/CustDrCrNote/DocDesign/Designes/" + rptName + ".repx");
            }
            if (RptModuleName == "VENDDRCRNOTE")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Vendor Debit/Credit Note" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/VendDrCrNote/DocDesign/Designes/" + rptName + ".repx");
            }
            if (RptModuleName == "PIQuotation")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Proforma Invoice/Quotation" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                filePath = Server.MapPath("/Reports/RepxReportDesign/Proforma/DocDesign/Designes/" + rptName + ".repx");
            }
            //END OF ADDITION
            ExportFileName = Page.Title;
            DevExpress.DataAccess.Sql.SqlDataSource sql = GenerateSqlDataSource(RptModuleName);
            XtraReport newXtraReport = XtraReport.FromFile(filePath, true);
            newXtraReport.LoadLayout(filePath);
            newXtraReport.DataSource = sql;
            //if (RptModuleName == "DChallan")
            //{
            //    newXtraReport.Landscape = true;
            //}
            if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "Second_Hand" || RptModuleName == "PInvoice" || RptModuleName == "RChallan" || RptModuleName == "PChallan" || RptModuleName == "PDChallan" || RptModuleName == "TSInvoice")
            {
                if (PrintType == "1")
                {
                    ReportType = "Original";
                }
                else if (PrintType == "2")
                {
                    ReportType = "Duplicate";
                }
                else if (PrintType == "3")
                {
                    ReportType = "DuplicateFinance";
                }
                else
                {
                    ReportType = "Triplicate";
                }
            }
            if (RptModuleName == "Invoice_POS" || RptModuleName == "Second_Hand" || RptModuleName == "POS_Duplicate")
            {
                if (PrintType == "1")
                {
                    newXtraReport.Watermark.Text = "ORIGINAL";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 109); //145
                }
                else if (PrintType == "2")
                {
                    newXtraReport.Watermark.Text = "TRANSPORTER COPY";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 45); //60
                }
                else if (PrintType == "3")
                {
                    newXtraReport.Watermark.Text = "FINANCER COPY";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 55); //73
                }
                else if (PrintType == "4")
                {
                    newXtraReport.Watermark.Text = "SUPPLIER COPY";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 57); //75
                }
                else
                {
                    newXtraReport.Watermark.Text = "DUPLICATE";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 109); //145
                }
                newXtraReport.Watermark.TextDirection = DirectionMode.ForwardDiagonal;
                newXtraReport.Watermark.ForeColor = Color.LightSlateGray;
                newXtraReport.Watermark.TextTransparency = 180;
                newXtraReport.Watermark.ShowBehind = false;
                newXtraReport.Watermark.PageRange = "1-2";
            }
            newXtraReport.DisplayName = ExportFileName;
            ASPxDocumentViewer1.Report = newXtraReport;
            //newXtraReport.DisplayName = ExportFileName;

            //// Create a new memory stream and export the report into it as PDF.
            //MemoryStream mem = new MemoryStream();
            //newXtraReport.ExportToPdf(mem);

            //// Create a new attachment and put the PDF report into it.
            //mem.Seek(0, System.IO.SeekOrigin.Begin);
            //Attachment att = new Attachment(mem, "aa.pdf", "application/pdf");

            //// Create a new message and attach the PDF report to it.
            //MailMessage mail = new MailMessage();
            //mail.Attachments.Add(att);

            //// Specify sender and recipient options for the e-mail message.
            //mail.From = new MailAddress("debashis.talukder@indusnet.co.in", "Debashis");
            ////mail.To.Add(new MailAddress(newXtraReport.ExportOptions.Email.RecipientAddress,newXtraReport.ExportOptions.Email.RecipientName));
            ////mail.To.Add(new MailAddress(newXtraReport.ExportOptions.Email.AddRecipient, newXtraReport.ExportOptions.Email.AddRecipient));
            //mail.To.Add(new MailAddress("debashis.talukder@indusnet.co.in", "Debashis"));

            //// Specify other e-mail options.
            //mail.Subject = newXtraReport.ExportOptions.Email.Subject;
            //mail.Body = "This is a test e-mail message sent by an application.";

            //// Send the e-mail message via the specified SMTP server.
            //SmtpClient smtp = new SmtpClient("smtp.gmail.com",25);
            //smtp.Send(mail);

            //// Close the memory stream.
            //mem.Close();
            //}

            if (!IsPostBack)
            {
                HDRepornName.Value = Convert.ToString(Request.QueryString["reportname"]);
            }

        }

        private DevExpress.DataAccess.Sql.SqlDataSource GenerateSqlDataSource(String RptModuleName)
        {
            DevExpress.DataAccess.Sql.SqlDataSource result = new DevExpress.DataAccess.Sql.SqlDataSource("crmConnectionString");
            BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string Module_Name = Convert.ToString(Session["Module_Name"]);
            DataTable dtRptTables = new DataTable();
            string query = "";

            query = @"Select Query_Table_name from tbl_trans_ReportSql where Module_name = '" + Module_Name + "' order by Query_ID ";
            dtRptTables = oDbEngine.GetDataTable(query);
            //dtRptTables.TableName = "aaa";
            string CashBankType = "";
            string CustVendType = "";
            string SalesPurchaseType = "";
            string DocumentID = "JV/120920170000001";//"101";
            #region  for logo image
            string[] filePaths = new string[] { };
            string path = System.Web.HttpContext.Current.Server.MapPath("~");
            string path1 = path.Replace("Reports\\", "ERP.UI");
            string fullpath = path1.Replace("\\", "/");
            #endregion

            if (RptModuleName == "BankBook")
            {
                CashBankType = "Bank";
            }
            else if (RptModuleName == "CashBook")
            {
                CashBankType = "Cash";
            }
            else if (RptModuleName == "LedgerPost")
            {
                CashBankType = "";
            }

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
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_MATERIALINOUTREG '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + Convert.ToString(Session["SelectedBranchList"]) + "','" + Convert.ToString(Session["SelectedTagProductList"]) + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "StockTrialDet")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_MATERIALINOUTREGDET_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + Convert.ToString(Session["SelectedBranchList"]) + "','" + Convert.ToString(Session["SelectedTagProductList"]) + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "StockTrialWH")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_MATERIALINOUTREGWH_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + Convert.ToString(Session["SelectedBranchList"]) + "','" + Convert.ToString(Session["SelectedTagProductList"]) + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "Second_Hand" || RptModuleName == "POS_Duplicate" || RptModuleName == "PInvoice")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_TAXINVOICE '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "TSInvoice" || RptModuleName == "TPInvoice")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_TRANSITSALEPURCHASE_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "ODSDChallan")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DELIVERYPENDINGCHALLAN_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "S" + "','" + "2" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "CUSTRECPAY" || RptModuleName == "VENDRECPAY")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CUSTVENDRECPAY '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + CustVendType + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "CBVUCHR")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CASHBANKVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "RChallan")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DELIVERYCHALLAN '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Sales_Return" || RptModuleName == "Purchase_Return")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALERETURN_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "PURCHASE_RET_REQ")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_PURCHASERETURN_REQUEST_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "OLDUNTRECVD")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_OLDUNITRECEIVED_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Install_Coupon")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_INSTALLATIONCOUPON_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + fullpath + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + "86" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "LedgerPost" || RptModuleName == "BankBook" || RptModuleName == "CashBook")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_LEDGERPOSTING '" + Convert.ToString(Session["LastCompany"]) + "','" + StartDate.Value + "','" + EndDate.Value + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + Convert.ToString(Session["SelectedBranchList"]) + "','" + CashBankType + "','" + Convert.ToString(Session["SelectedCashBankList"]) + "','" + Convert.ToString(Session["SelectedUserList"]) + "','" + Convert.ToString(Session["SelectedTagPartyList"]) + "','" + Convert.ToString(Session["SelectedTagLedgerList"]) + "','" + Convert.ToString(Session["SelectedTagEmployeeList"]) + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Sorder" || RptModuleName == "Porder")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASEORDER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "BranchReq")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_BRANCHREQ_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + "21" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "BranchTranOut")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_BRANCHOUT_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "SChallan" || RptModuleName == "PDChallan" || RptModuleName == "PChallan")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASECHALLAN_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "CONTRAVOUCHER")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CONTRAVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "JOURNALVOUCHER")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_JOURNALVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "CUSTDRCRNOTE" || RptModuleName == "VENDDRCRNOTE")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DEBITCREDITNOTE_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + CustVendType + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "PIQuotation")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_PROFORMAINVQUOTATION '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }


            DataTable dtRptRelation = new DataTable();
            string RelationQuery = "";

            RelationQuery = @"Select Parent_Query_name,Child_Query_name, Parent_Column_name,Child_Column_name from tbl_trans_ReportTableRelation where Module_name = '" + Module_Name + "' order by Query_ID ";
            dtRptRelation = oDbEngine.GetDataTable(RelationQuery);
            if (dtRptRelation.Rows.Count > 0)
            {
                foreach (DataRow row in dtRptRelation.Rows)
                {
                    result.Relations.Add(Convert.ToString(row[0]), Convert.ToString(row[1]), Convert.ToString(row[2]), Convert.ToString(row[3]));
                }
            }

            result.RebuildResultSchema();
            return result;
        }
        //protected void btnEmail_Callback(object sender, CallbackEventArgsBase e)
        //{

        //}
    }
}