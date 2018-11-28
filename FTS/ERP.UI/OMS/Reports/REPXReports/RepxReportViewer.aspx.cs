using BusinessLogicLayer;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ERP.OMS.Reports.XtraReports;
using DevExpress.DataAccess.Sql;
using DevExpress.XtraReports.UI;
using DevExpress.XtraPrinting;
using DevExpress.XtraPrinting.Preview;
using System.Net.Mail;
using System.Drawing;
using DevExpress.XtraPrinting.Drawing;

namespace ERP.OMS.Reports.REPXReports
{
    public partial class RepxReportViewer : System.Web.UI.Page
    {
        BusinessLogicLayer.ReportLayout rpLayout = new BusinessLogicLayer.ReportLayout();
        BusinessLogicLayer.ReportData rptData = new BusinessLogicLayer.ReportData();
        string Module_name = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string tempFile = HttpContext.Current.Request.QueryString["Previewrpt"];
            string RptModuleName = HttpContext.Current.Request.QueryString["modulename"]; //Convert.ToString(Session["NewRptModuleName"]);   
            string PrintType = HttpContext.Current.Request.QueryString["PrintOption"];
            string DocumentID = HttpContext.Current.Request.QueryString["id"];
            BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine();
            string rptName = tempFile;
            string filePath = "";
            string filePathtoPDF = "";
            string ReportType = "";
            
            string[] filePaths = new string[] { };
            string DesignPath = "";
            string PDFFilePath = "";
            string ExportFileName = "";
            if (RptModuleName == "Invoice")
             {
                 if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                 {
                     Page.Title = "Sale Invoice-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                 }
                 Module_name = "SALETAX";
                 if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                 {
                     DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\Normal\";
                     PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                 }
                 else
                 {
                     DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\Normal\";
                     PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                 }
             }
            else if (RptModuleName == "TSInvoice")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Transit Sale Invoice-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "SALETAX";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\Transit\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\Transit\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Invoice_POS")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Sale Invoice(POS)-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "SALETAX";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\SPOS\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\SPOS\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Second_Hand")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Second Hand sales-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "SALETAX";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SecondHandSales\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SecondHandSales\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SecondHandSales\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\SecondHandSales\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "POS_Duplicate")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "POS Bill Print-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "SALETAX";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\POSDUPLICATE\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\POSDUPLICATE\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "CUSTRECPAY")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Customer Rec/Pay-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "CUSTRECPAY";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\CustomerRecPay\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\CustomerRecPay\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\CustomerRecPay\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\CustomerRecPay\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "VENDRECPAY")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Vendor Rec/Pay-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "CUSTRECPAY";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\VendorRecPay\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\VendorRecPay\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\VendorRecPay\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\VendorRecPay\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "CBVUCHR")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Cash Bank Voucher-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "CASHBANK";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\CashBankVoucher\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\CashBankVoucher\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\CashBankVoucher\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\CashBankVoucher\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "CUSTDRCRNOTE")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Customer Debit/Credit Note-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "CUSTVENDDRCRNOTE";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\CustDrCrNote\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\CustDrCrNote\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\CustDrCrNote\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\CustDrCrNote\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "VENDDRCRNOTE")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Vendor Debit/Credit Note-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "CUSTVENDDRCRNOTE";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\VendDrCrNote\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\VendDrCrNote\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\VendDrCrNote\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\VendDrCrNote\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "ODSDChallan")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Sales Challan-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "SALETAX";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\DeliveryChallan\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\DeliveryChallan\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\DeliveryChallan\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\DeliveryChallan\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "RChallan")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Road Challan-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "RCHALLAN";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesChallan\DocDesign\CDelivery\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesChallan\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesChallan\DocDesign\CDelivery\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesChallan\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "SChallan")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Sales Challan-" + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "SCHALLAN";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesChallan\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesChallan\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesChallan\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesChallan\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "PDChallan")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Pending Delivery List-" + rptName.Split('~')[0];
                }
                Module_name = "SCHALLAN";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesChallan\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesChallan\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesChallan\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesChallan\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "PChallan")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Delivery Challan-" + rptName.Split('~')[0];
                }
                Module_name = "PCHALLAN";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\PurchaseChallan\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\PurchaseChallan\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\PurchaseChallan\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\PurchaseChallan\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "PInvoice")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Purchase Invoice-" + rptName.Split('~')[0];
                }
                Module_name = "PURCHASE";

                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\PurchaseInvoice\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\PurchaseInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\PurchaseInvoice\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\PurchaseInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Sales_Return")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Sale Return-" + rptName.Split('~')[0];
                }
                Module_name = "SALERET";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesReturn\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesReturn\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesReturn\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesReturn\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "PURCHASE_RET_REQ")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Purchase Return Request-" + rptName.Split('~')[0];
                }
                Module_name = "PRETREQ";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\PurchaseRetRec\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\PurchaseRetRec\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\PurchaseRetRec\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\PurchaseRetRec\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "OLDUNTRECVD")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Old Unit Received-" + rptName.Split('~')[0];
                }
                Module_name = "OLDUREC";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\OldUnitReceived\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\OldUnitReceived\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\OldUnitReceived\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\OldUnitReceived\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Purchase_Return")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Purchase Return-" + rptName.Split('~')[0];
                }
                Module_name = "PURRET";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\PurchaseReturn\DocDesign\Normal\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\PurchaseReturn\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\PurchaseReturn\DocDesign\Normal\";
                    PDFFilePath = @"Reports\RepxReportDesign\PurchaseReturn\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Install_Coupon")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Installation Coupon-" + rptName.Split('~')[0];
                }
                Module_name = "INSCUPN";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\InstCoupon\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\InstCoupon\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesInvoice\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "PIQuotation")
            {
                if (string.IsNullOrEmpty(Page.Title))
                {
                    Page.Title = "Proforma Invoice/Quotation " + rptName.Split('~')[0]; //RptModuleName;//ConfigurationManager.AppSettings[RptModuleName];
                }
                Module_name = "PIQUOTATION";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\Proforma\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\Proforma\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\Proforma\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\Proforma\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "BranchReq")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Branch Requisition-" + rptName.Split('~')[0];
                }
                Module_name = "BRANCHREQ";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\BranchRequisition\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\BranchRequisition\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\BranchRequisition\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\BranchRequisition\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "BranchTranOut")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Branch Transfer Out-" + rptName.Split('~')[0];
                }
                Module_name = "BRANCHTRANOUT";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\BranchTransferOut\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\BranchTransferOut\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\BranchTransferOut\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\BranchTransferOut\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Porder")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Purchase Order-" + rptName.Split('~')[0];
                }
                Module_name = "PORDER";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\PurchaseOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\PurchaseOrder\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\PurchaseOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\PurchaseOrder\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "Sorder")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Sales Order-" + rptName.Split('~')[0];
                }
                Module_name = "SORDER";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\SalesOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\SalesOrder\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\SalesOrder\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\SalesOrder\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "JOURNALVOUCHER")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Journal Voucher-" + rptName.Split('~')[0];
                }
                Module_name = "JOURNALVOUCHER";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\JournalVoucher\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\JournalVoucher\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\JournalVoucher\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\JournalVoucher\DocDesign\PDFFiles\";
                }
            }
            else if (RptModuleName == "CONTRAVOUCHER")
            {
                if (string.IsNullOrEmpty(Page.Title) && rptName != null)
                {
                    Page.Title = "Contra Voucher-" + rptName.Split('~')[0];
                }
                Module_name = "CONTRAVOUCHER";
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    DesignPath = @"Reports\Reports\RepxReportDesign\ContraVoucher\DocDesign\Designes\";
                    PDFFilePath = @"Reports\Reports\RepxReportDesign\ContraVoucher\DocDesign\PDFFiles\";
                }
                else
                {
                    DesignPath = @"Reports\RepxReportDesign\ContraVoucher\DocDesign\Designes\";
                    PDFFilePath = @"Reports\RepxReportDesign\ContraVoucher\DocDesign\PDFFiles\";
                }
            }
            ExportFileName = Page.Title;
            Session["Module_Name"] = Module_name;
            string fullpath = Server.MapPath("~");
            fullpath = fullpath.Replace("ERP.UI\\", "");
            string DesignFullPath = fullpath + DesignPath;
            string PDFFullPath = fullpath + PDFFilePath;            
            filePath = System.IO.Path.GetDirectoryName(DesignFullPath);
            filePath = filePath + "\\" + rptName + ".repx";
            DevExpress.DataAccess.Sql.SqlDataSource sql = GenerateSqlDataSource(RptModuleName);
            XtraReport newXtraReport = XtraReport.FromFile(filePath, true);
            newXtraReport.LoadLayout(filePath);
            newXtraReport.DataSource = sql;
            filePathtoPDF = filePath;
            filePathtoPDF = filePathtoPDF.Split('~')[0];
            //filePathtoPDF=filePath.Replace(".repx",".pdf");

            newXtraReport.DisplayName = ExportFileName;

            //if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "PInvoice" || RptModuleName == "ODSDChallan" || RptModuleName == "DChallan" || RptModuleName == "SChallan" || RptModuleName == "PChallan" || RptModuleName == "PDChallan")
            if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "Second_Hand" || RptModuleName == "PInvoice" || RptModuleName == "RChallan" || RptModuleName == "PChallan" || RptModuleName == "PDChallan" || RptModuleName == "TSInvoice" || RptModuleName == "CUSTRECPAY" || RptModuleName == "VENDRECPAY")
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
                else if (PrintType == "4")
                {
                    ReportType = "Triplicate";
                }
                else
                {
                    ReportType = "Extra_Office";
                }

                //PDF file generation has been blocked as per requirment.
                //if (RptModuleName == "Invoice" || RptModuleName == "PInvoice" || RptModuleName == "PChallan" || RptModuleName == "PDChallan")
                //{
                //    filePathtoPDF = filePathtoPDF.Replace("Normal", "PDFFiles");
                //}
                //else if (RptModuleName == "TSInvoice")
                //{
                //    filePathtoPDF = filePathtoPDF.Replace("Transit", "PDFFiles");
                //}
                //else if (RptModuleName == "Invoice_POS")
                //{
                //    filePathtoPDF = filePathtoPDF.Replace("SPOS", "PDFFiles");
                //}
                //else if (RptModuleName == "Second_Hand")
                //{
                //    filePathtoPDF = filePathtoPDF.Replace("Normal", "PDFFiles");
                //}
                //else if (RptModuleName == "POS_Duplicate")
                //{
                //    filePathtoPDF = filePathtoPDF.Replace("POSDUPLICATE", "PDFFiles");
                //}
                //else if (RptModuleName == "RChallan")
                //{
                //    filePathtoPDF = filePathtoPDF.Replace("CDelivery", "PDFFiles");
                //}
                //PDF file generation has been blocked as per requirment.
            }
            //PDF file generation has been blocked as per requirment.
            //else if (RptModuleName == "Sales_Return" || RptModuleName == "SChallan" || RptModuleName == "Purchase_Return")
            //{
            //    filePathtoPDF = filePathtoPDF.Replace("Normal", "PDFFiles");
            //}
            //else if (RptModuleName == "PURCHASE_RET_REQ")
            //{
            //    filePathtoPDF = filePathtoPDF.Replace("Normal", "PDFFiles");
            //}
            //else if (RptModuleName == "OLDUNTRECVD")
            //{
            //    filePathtoPDF = filePathtoPDF.Replace("Normal", "PDFFiles");
            //}
         
            //else if (RptModuleName == "Install_Coupon")
            //{
            //    filePathtoPDF = filePathtoPDF.Replace("InstCoupon", "PDFFiles");
            //}
            //else if (RptModuleName == "BranchReq" || RptModuleName == "BranchTranOut" || RptModuleName == "Porder" || RptModuleName == "Sorder" || RptModuleName == "ODSDChallan" ||
            //    RptModuleName == "CBVUCHR" || RptModuleName == "PIQuotation" || RptModuleName == "CUSTDRCRNOTE" || RptModuleName == "VENDDRCRNOTE" || RptModuleName == "JOURNALVOUCHER" ||
            //    RptModuleName == "CONTRAVOUCHER")
            //{
            //    filePathtoPDF = filePathtoPDF.Replace("Designes", "PDFFiles");
            //}
            //PDF file generation has been blocked as per requirment.

            ////else
            ////{
            ////    filePathtoPDF = filePathtoPDF + ".pdf";
            ////}

            //PDF file generation has been blocked as per requirment.
            //if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "Second_Hand" || RptModuleName == "PInvoice" || RptModuleName == "ODSDChallan" || 
            //    RptModuleName == "RChallan" || RptModuleName == "SChallan" || RptModuleName == "PChallan" || RptModuleName == "PDChallan" || RptModuleName == "TSInvoice" || 
            //    RptModuleName == "CUSTRECPAY" || RptModuleName == "VENDRECPAY")
            //{
            //    filePathtoPDF = filePathtoPDF + "-" + ReportType + "-" + DocumentID + ".pdf";
            //}            
            //else
            //{
            //    filePathtoPDF = filePathtoPDF + "-" + DocumentID + ".pdf";
            //}
            //PDF file generation has been blocked as per requirment.

            //newXtraReport.ExportToPdf(filePathtoPDF); -- FOR EXPORT PDF FILE
            //if (RptModuleName == "DChallan")
            //{
            //    newXtraReport.Landscape = true;
            //}
            if (RptModuleName == "Invoice_POS" || RptModuleName == "POS_Duplicate" || RptModuleName == "Second_Hand")
            {
                if (PrintType == "1")
                {
                    newXtraReport.Watermark.Text = "ORIGINAL";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 109); //145
                }
                if (PrintType == "2")
                {
                    newXtraReport.Watermark.Text = "TRANSPORTER COPY";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 45); //60
                }
                if (PrintType == "3")
                {
                    newXtraReport.Watermark.Text = "FINANCER COPY";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 55); //73
                }
                if (PrintType == "4")
                {
                    newXtraReport.Watermark.Text = "SUPPLIER COPY";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 57); //75
                }
                if (PrintType == "5")
                {
                    newXtraReport.Watermark.Text = "DUPLICATE";
                    newXtraReport.Watermark.Font = new Font(newXtraReport.Watermark.Font.FontFamily, 109); //75
                }
                newXtraReport.Watermark.TextDirection = DirectionMode.ForwardDiagonal;
                newXtraReport.Watermark.ForeColor = Color.LightSlateGray;
                newXtraReport.Watermark.TextTransparency = 180;
                newXtraReport.Watermark.ShowBehind = false;
                newXtraReport.Watermark.PageRange = "1-2";
            }
            

            ASPxDocumentViewer1.Report = newXtraReport;

            //PDF file generation has been blocked as per requirment.
            //Reportname = Path.GetFileNameWithoutExtension(filePathtoPDF);
            //PDF file generation has been blocked as per requirment.

            //// Create a new attachment and put the PDF report into it.            
            //Attachment att = new Attachment(filePathtoPDF, "application/pdf");            
            
            //// Create a new message and attach the PDF report to it.
            //MailMessage mail = new MailMessage();
            //mail.Attachments.Add(att);

            //// Specify sender and recipient options for the e-mail message.
            //mail.From = new MailAddress("debashis.talukder@indusnet.co.in", "Debashis");
            //mail.To.Add(new MailAddress("debashis.talukder@indusnet.co.in", "Debashis"));

            //// Specify other e-mail options.
            //mail.Subject = newXtraReport.ExportOptions.Email.Subject;
            //mail.Body = "This is a test e-mail message sent by an application.";

            //// Send the e-mail message via the specified SMTP server.
            //SmtpClient smtp = new SmtpClient("smtp.gmail.com",25);
            //smtp.Send(mail);

            //MemoryStream stream = new MemoryStream();
            ////PdfExportOptions opts = new PdfExportOptions();
            //string fileType = "pdf";
            ////opts.ShowPrintDialogOnOpen = true;
            ////newXtraReport.ExportToPdf(stream,opts);
            //newXtraReport.ExportToPdf(stream);
            //Response.ContentType = "application/" + fileType;
            //Response.BinaryWrite(stream.ToArray());
            //Response.End();

            //using (MemoryStream ms = new MemoryStream())
            //{
            //    XtraReport1 r = new XtraReport1();
            //    r.CreateDocument();
            //    PdfExportOptions opts = new PdfExportOptions();
            //    opts.ShowPrintDialogOnOpen = true;
            //    r.ExportToPdf(ms, opts);
            //    ms.Seek(0, SeekOrigin.Begin);
            //    byte[] report = ms.ToArray();
            //    Page.Response.ContentType = "application/pdf";
            //    Page.Response.Clear();
            //    Page.Response.OutputStream.Write(report, 0, report.Length);
            //    Page.Response.End();
            //}


            //ASPxDocumentViewer1.Report.Print();
            //ASPxDocumentViewer1.Report.PrintDialog();    
            if (!IsPostBack)
            {
                HDRepornName.Value = Convert.ToString(Request.QueryString["reportname"]);
            }
        }

        private DevExpress.DataAccess.Sql.SqlDataSource GenerateSqlDataSource(String RptModuleName)
        {
            DevExpress.DataAccess.Sql.SqlDataSource result = new DevExpress.DataAccess.Sql.SqlDataSource("crmConnectionString");
            BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
           // string Module_Name = Convert.ToString(Session["Module_Name"]);
            DataTable dtRptTables = new DataTable();
            string query = "";

            query = @"Select Query_Table_name from tbl_trans_ReportSql where Module_name = '" + Module_name + "' order by Query_ID ";
            dtRptTables = oDbEngine.GetDataTable(query);
            //dtRptTables.TableName = "aaa";
            string CustVendType = "";
            string SalesPurchaseType = "";
            string[] filePaths = new string[] { };
            string path = System.Web.HttpContext.Current.Server.MapPath("~");
            string path1 = path.Replace("Reports\\", "ERP.UI");
            string fullpath = path1.Replace("\\", "/");
            string DocumentID = HttpContext.Current.Request.QueryString["Id"];

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

            if (RptModuleName == "Invoice" || RptModuleName == "Invoice_POS" || RptModuleName == "Second_Hand" || RptModuleName == "POS_Duplicate" || RptModuleName == "PInvoice")
            {                
                string PrintOption = HttpContext.Current.Request.QueryString["PrintOption"];

                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_TAXINVOICE '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + PrintOption + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "TSInvoice" || RptModuleName == "TPInvoice")
            {
                string PrintOption = HttpContext.Current.Request.QueryString["PrintOption"];

                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_TRANSITSALEPURCHASE_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + PrintOption + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "CUSTDRCRNOTE" || RptModuleName == "VENDDRCRNOTE")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DEBITCREDITNOTE_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + CustVendType + "','" + "P" + "'"));
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
                string PrintOption = HttpContext.Current.Request.QueryString["PrintOption"];

                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CUSTVENDRECPAY '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + CustVendType + "','" + PrintOption + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "CBVUCHR")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CASHBANKVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "" + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "JOURNALVOUCHER")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_JOURNALVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "CONTRAVOUCHER")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_CONTRAVOUCHER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "RChallan")
            {                
                string PrintOption = HttpContext.Current.Request.QueryString["PrintOption"];

                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_DELIVERYCHALLAN '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + PrintOption + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "SChallan" || RptModuleName == "PDChallan" || RptModuleName == "PChallan")
            {
                string PrintOption = HttpContext.Current.Request.QueryString["PrintOption"];

                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASECHALLAN_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + PrintOption + "','" + "P" + "'"));
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
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_INSTALLATIONCOUPON_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + fullpath + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "BranchReq")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_BRANCHREQ_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "BranchTranOut")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_BRANCHOUT_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + "P" + "'"));
                }
            }
            else if (RptModuleName == "Sorder" || RptModuleName == "Porder")
            {
                foreach (DataRow row in dtRptTables.Rows)
                {
                    result.Queries.Add(new CustomSqlQuery(Convert.ToString(row[0]), "EXEC PROC_SALEPURCHASEORDER_REPORT '" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]).Trim() + "','" + fullpath + "','" + Convert.ToString(row[0]) + "','" + DocumentID + "','" + SalesPurchaseType + "','" + "P" + "'"));
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
            RelationQuery = @"Select Parent_Query_name,Child_Query_name, Parent_Column_name,Child_Column_name from tbl_trans_ReportTableRelation where Module_name = '" + Module_name + "' order by Query_ID ";
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
    }
}