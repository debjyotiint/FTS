using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BusinessLogicLayer;
using System.Configuration;
using System.IO;
using DevExpress.Web;

namespace Reports.Reports.REPXReports
{
    public partial class RepxReportMain : ERP.OMS.ViewState_class.VSPage //System.Web.UI.Page
    {
        public DBEngine oDBEngine = new DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        BusinessLogicLayer.ReportLayout rpLayout = new BusinessLogicLayer.ReportLayout();
        BusinessLogicLayer.Converter objConverter = new BusinessLogicLayer.Converter();
        BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
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
                string[] filePaths = new string[] { };
                TxtStartDate.EditFormatString = objConverter.GetDateFormat("Date");
                TxtEndDate.EditFormatString = objConverter.GetDateFormat("Date");
                string fDate = null;
                string tDate = null;
                fDate = Session["FinYearStart"].ToString();
                tDate = Session["FinYearEnd"].ToString();
                TxtStartDate.Value = Convert.ToDateTime(fDate); //oDBEngine.GetDate();
                TxtEndDate.Value = Convert.ToDateTime(tDate); //oDBEngine.GetDate();
                if (ConfigurationManager.AppSettings["IsDevelopedZone"] != null)
                {
                    btnNewDesign.Visible = true;
                    btnLoadDesign.Visible = true;
                }
                else
                {
                    btnNewDesign.Visible = false;
                    btnLoadDesign.Visible = false;
                }

                //String RptModuleName = Convert.ToString(Request.QueryString["reportname"]);
                String RptModuleName = HttpContext.Current.Request.QueryString["reportname"];
                Session["NewRptModuleName"] = RptModuleName;

                string RptModuleType = "";
                string Module_name = "";
                switch (RptModuleName)
                {
                    case "StockTrialSumm":
                        lblReportTitle.Text = "Report Parameters(Stock Trial Summary)";
                        RptModuleType = "StockTrialSumm";
                        Module_name = "STOCKTRIALSUMM";
                        btnBranch.ClientVisible = true;
                        btnProduct.ClientVisible = true;
                        break;
                    case "StockTrialDet":
                        lblReportTitle.Text = "Report Parameters(Stock Trial Details)";
                        RptModuleType = "StockTrialDet";
                        Module_name = "STOCKTRIALDET";
                        btnBranch.ClientVisible = true;
                        btnProduct.ClientVisible = true;
                        break;
                    case "StockTrialWH":
                        lblReportTitle.Text = "Report Parameters(Stock Trial Warehouse Details)";
                        RptModuleType = "StockTrialWH";
                        Module_name = "STOCKTRIALWH";
                        btnBranch.ClientVisible = true;
                        btnProduct.ClientVisible = true;
                        break;
                    case "StockTrial1":
                        lblReportTitle.Text = "Report Parameters(Stock Trial New)";
                        RptModuleType = "STOCKTRIAL1";
                        Module_name = "STOCKTRIAL1";
                        btnBranch.ClientVisible = true;
                        btnProduct.ClientVisible = true;
                        break;
                    case "Invoice":
                        lblReportTitle.Text = "Report Parameters(Sales Invoice)";
                        RptModuleType = "Invoice";
                        Module_name = "SALETAX";
                        break;
                    case "TSInvoice":
                        lblReportTitle.Text = "Report Parameters(Transit Sales Invoice)";
                        RptModuleType = "TSInvoice";
                        Module_name = "SALETAX";
                        break;
                    case "PInvoice":
                        lblReportTitle.Text = "Report Parameters(Purchase Invoice)";
                        RptModuleType = "PInvoice";
                        Module_name = "PURCHASE";
                        break;
                    case "TPInvoice":
                        lblReportTitle.Text = "Report Parameters(Transit Purchase Invoice)";
                        RptModuleType = "TPInvoice";
                        Module_name = "TPURCHASE";
                        break;
                    case "Invoice_POS":
                        lblReportTitle.Text = "Report Parameters(POS)";
                        RptModuleType = "Invoice_POS";
                        Module_name = "SALETAX";
                        break;
                    case "Second_Hand":
                        lblReportTitle.Text = "Report Parameters(POS)";
                        RptModuleType = "Second_Hand";
                        Module_name = "SALETAX";
                        break;
                    case "POS_Duplicate":
                        lblReportTitle.Text = "Report Parameters(POS Duplicate)";
                        RptModuleType = "POS_Duplicate";
                        Module_name = "SALETAX";
                        break;
                    case "CUSTRECPAY":
                        lblReportTitle.Text = "Report Parameters(Customer Receipt/Payment)";
                        RptModuleType = "CUSTRECPAY";
                        Module_name = "CUSTRECPAY";
                        break;
                    case "VENDRECPAY":
                        lblReportTitle.Text = "Report Parameters(Vendor Receipt/Payment)";
                        RptModuleType = "VENDRECPAY";
                        Module_name = "CUSTRECPAY";
                        break;
                    case "CBVUCHR":
                        lblReportTitle.Text = "Report Parameters(Cash Bank Voucher)";
                        RptModuleType = "CBVUCHR";
                        Module_name = "CASHBANK";
                        break;
                    case "JOURNALVOUCHER":
                        lblReportTitle.Text = "Report Parameters(Journal Voucher)";
                        RptModuleType = "JOURNALVOUCHER";
                        Module_name = "JOURNALVOUCHER";
                        break;
                    case "Install_Coupon":
                        lblReportTitle.Text = "Report Parameters(Installation Coupon)";
                        RptModuleType = "Install_Coupon";
                        Module_name = "INSCUPN";
                        break;
                    case "LedgerPost":
                        lblReportTitle.Text = "Report Parameters(Ledger Posting Details)";
                        RptModuleType = "LedgerPost";
                        Module_name = "LEDGERPOST";
                        btnBranch.ClientVisible = true;
                        //btnParty.ClientVisible = true;
                        btnLedger.ClientVisible = true;
                        btnEmployee.ClientVisible = true;
                        break;
                    case "BankBook":
                        lblReportTitle.Text = "Report Parameters(Bank Book)";
                        RptModuleType = "BankBook";
                        Module_name = "LEDGERPOST";
                        btnBranch.ClientVisible = true;
                        btnUser.ClientVisible = true;
                        btnBank.ClientVisible = true;
                        break;
                    case "CashBook":
                        lblReportTitle.Text = "Report Parameters(Cash Book)";
                        RptModuleType = "CashBook";
                        Module_name = "LEDGERPOST";
                        btnBranch.ClientVisible = true;
                        btnUser.ClientVisible = true;
                        btnCash.ClientVisible = true;
                        break;
                    case "Porder":
                        lblReportTitle.Text = "Report Parameters(Purchase Order)";
                        RptModuleType = "Porder";
                        Module_name = "PORDER";
                        break;
                    case "Sorder":
                        lblReportTitle.Text = "Report Parameters(Sales Order)";
                        RptModuleType = "Sorder";
                        Module_name = "SORDER";
                        break;
                    case "BranchReq":
                        lblReportTitle.Text = "Report Parameters(Branch Requisition)";
                        RptModuleType = "BranchReq";
                        Module_name = "BRANCHREQ";
                        break;
                    case "BranchTranOut":
                        lblReportTitle.Text = "Report Parameters(Branch Transfer Out)";
                        RptModuleType = "BranchTranOut";
                        Module_name = "BRANCHTRANOUT";
                        break;
                    case "Sales_Return":
                        lblReportTitle.Text = "Report Parameters(Sales Return)";
                        RptModuleType = "Sales_Return";
                        Module_name = "SALERET";
                        break;
                    case "PURCHASE_RET_REQ":
                        lblReportTitle.Text = "Report Parameters(Purchase Return Request)";
                        RptModuleType = "PURCHASE_RET_REQ";
                        Module_name = "PRETREQ";
                        break;
                    case "OLDUNTRECVD":
                        lblReportTitle.Text = "Report Parameters(Old Unit Received)";
                        RptModuleType = "OLDUNTRECVD";
                        Module_name = "OLDUREC";
                        break;
                    case "Purchase_Return":
                        lblReportTitle.Text = "Report Parameters(Purchase Return)";
                        RptModuleType = "Purchase_Return";
                        Module_name = "PURRET";
                        break;
                    case "SChallan":
                        lblReportTitle.Text = "Report Parameters(Sales Challan)";
                        RptModuleType = "SChallan";
                        Module_name = "SCHALLAN";
                        break;
                    case "PChallan":
                        lblReportTitle.Text = "Report Parameters(Purchase Challan)";
                        RptModuleType = "PChallan";
                        Module_name = "PCHALLAN";
                        break;
                    case "ODSDChallan":
                        lblReportTitle.Text = "Report Parameters(Delivery Challan(ODSD))";
                        RptModuleType = "ODSDChallan";
                        Module_name = "SALETAX";
                        break;
                    case "RChallan":
                        lblReportTitle.Text = "Report Parameters(Road Challan)";
                        RptModuleType = "RChallan";
                        Module_name = "RCHALLAN";
                        break;
                    case "PDChallan":
                        lblReportTitle.Text = "Report Parameters(Pending Delivery List)";
                        RptModuleType = "PDChallan";
                        Module_name = "SCHALLAN";
                        break;
                    case "CONTRAVOUCHER":
                        lblReportTitle.Text = "Report Parameters(Contra Voucher)";
                        RptModuleType = "CONTRAVOUCHER";
                        Module_name = "CONTRAVOUCHER";
                        break;
                    case "CUSTDRCRNOTE":
                        lblReportTitle.Text = "Report Parameters(Customer Debit/Credit Note)";
                        RptModuleType = "CUSTDRCRNOTE";
                        Module_name = "CUSTVENDDRCRNOTE";
                        break;
                    case "VENDDRCRNOTE":
                        lblReportTitle.Text = "Report Parameters(Vendor Debit/Credit Note)";
                        RptModuleType = "VENDDRCRNOTE";
                        Module_name = "CUSTVENDDRCRNOTE";
                        break;
                    case "PIQuotation":
                        lblReportTitle.Text = "Report Parameters(Proforma Invoice/Quotation)";
                        RptModuleType = "PIQuotation";
                        Module_name = "PIQUOTATION";
                        break;
                }

                Session["Module_Name"] = Module_name;
                if (RptModuleType == "StockTrialSumm")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Summary"), "*.repx");
                }
                else if (RptModuleType == "StockTrialDet")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Details"), "*.repx");
                }
                else if (RptModuleType == "StockTrialWH")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial/Warehouse"), "*.repx");
                }
                else if (RptModuleType == "STOCKTRIAL1")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/Inventory/StockTrial1"), "*.repx");
                }
                else if (RptModuleType == "Invoice")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "TSInvoice")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/Transit"), "*.repx");
                }
                else if (RptModuleType == "PInvoice")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/PurchaseInvoice/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "TPInvoice")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/TransitPurchaseInvoice/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "Invoice_POS")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/SPOS"), "*.repx");
                }
                else if (RptModuleType == "Second_Hand")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SecondHandSales/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "POS_Duplicate")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/POSDUPLICATE"), "*.repx");
                }
                else if (RptModuleType == "CUSTRECPAY")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/CustomerRecPay/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "VENDRECPAY")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/VendorRecPay/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "CBVUCHR")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/CashBankVoucher/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "Sales_Return")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesReturn/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "PURCHASE_RET_REQ")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/PurchaseRetRec/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "OLDUNTRECVD")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/OldUnitReceived/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "Purchase_Return")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/PurchaseReturn/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "Install_Coupon")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesInvoice/DocDesign/InstCoupon"), "*.repx");
                }
                else if (RptModuleType == "Proforma")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/Proforma/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "LedgerPost")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/Ledger"), "*.repx");
                }
                else if (RptModuleType == "BankBook")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/CashBankBook/BankBook"), "*.repx");
                }
                else if (RptModuleType == "CashBook")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/CashBankBook/CashBooK"), "*.repx");
                }
                else if (RptModuleType == "Porder")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/PurchaseOrder/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "Sorder")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesOrder/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "BranchReq")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/BranchRequisition/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "BranchTranOut")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/BranchTransferOut/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "SChallan" || RptModuleType == "PDChallan")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "PChallan")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/PurchaseChallan/DocDesign/Normal"), "*.repx");
                }
                else if (RptModuleType == "ODSDChallan")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/DeliveryChallan/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "RChallan")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/SalesChallan/DocDesign/CDelivery"), "*.repx");
                }
                else if (RptModuleType == "CONTRAVOUCHER")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/ContraVoucher/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "CUSTDRCRNOTE")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/CustDrCrNote/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "VENDDRCRNOTE")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/VendDrCrNote/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "PIQuotation")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/Proforma/DocDesign/Designes"), "*.repx");
                }
                else if (RptModuleType == "JOURNALVOUCHER")
                {
                    filePaths = System.IO.Directory.GetFiles(Server.MapPath("/Reports/RepxReportDesign/JournalVoucher/DocDesign/Designes"), "*.repx");
                }
                //ddReportName.Items.Add("--Select--");
                foreach (string filename in filePaths)
                {
                    string reportname = Path.GetFileNameWithoutExtension(filename);
                    string name = "";
                    if (reportname.Split('~').Length > 1)
                    {
                        name = reportname.Split('~')[0];
                    }
                    else
                    {
                        name = reportname;
                    }
                    string reportValue = reportname;
                    ddReportName.Items.Add(name, reportValue);
                }
                ddReportName.SelectedIndex = 0;

                HDReportModuleName.Value = Convert.ToString(Request.QueryString["reportname"]);
            }
        }

        protected void btnNewDesign_Click(object sender, EventArgs e)
        {
            HttpContext.Current.Response.Redirect("~/Reports/REPXReports/ReportDesignerRepx.aspx");
        }
        protected void btnLoadDesign_Click(object sender, EventArgs e)
        {
            string reportName = Convert.ToString(ddReportName.Value);
            RptName.Value = Convert.ToString(ddReportName.Value);
            string ReportModuleNM = Convert.ToString(Request.QueryString["reportname"]);
            string Module_Name = Convert.ToString(Request.QueryString["Module_Name"]);
            if (reportName == "--Select--")
            {
                return;
            }
            HttpContext.Current.Response.Redirect("~/Reports/REPXReports/ReportDesignerRepx.aspx?LoadrptName=" + reportName + "&&reportname=" + Convert.ToString(Request.QueryString["reportname"]));
        }

        protected void btnPreview_Click(object sender, EventArgs e)
        {
            string StartDate = string.Empty;
            string EndDate = string.Empty;
            string reportName = Convert.ToString(ddReportName.Value);
            string ReportModuleNM = Convert.ToString(Request.QueryString["reportname"]);
            if (reportName == "--Select--")
            {
                return;
            }
            string SelectedBranchList = "";
            string SelectedUserList = "";
            string SelectedPartyList = "";
            //string SelectedBankList = "";
            //string SelectedCashList = "";
            Session["ButtonBranch"] = "Branch";
            Session["ButtonUser"] = "User";
            Session["ButtonBank"] = "Bank";
            Session["ButtonCash"] = "Cash";
            //Session["ButtonParty"] = "Party";
            string ZeroBalProduct = "";
            if (chkZeroBal.Checked == true)
            {
                ZeroBalProduct = "Y";
            }
            else
            {
                ZeroBalProduct = "N";
            }
            Session["chkZeroBalProduct"] = ZeroBalProduct;

            if ((ReportModuleNM == "StockTrialSumm" || ReportModuleNM == "StockTrialDet" || ReportModuleNM == "StockTrialWH" || ReportModuleNM == "StockTrial1" ||
                ReportModuleNM == "LedgerPost" || ReportModuleNM == "BankBook" || ReportModuleNM == "CashBook") && Convert.ToString(Session["ButtonBranch"]) == "Branch")
            {
                List<object> docList = grid_Branch.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedBranchList += "," + Dobj;
                }
                SelectedBranchList = SelectedBranchList.TrimStart(',');
                if (SelectedBranchList.Trim() == "")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), UniqueID, "jAlert('Please Select Some Document(s)')", true);
                    Session["SelectedBranchList"] = Convert.ToString(Session["userbranchHierarchy"]);
                }
                else
                {
                    Session["SelectedBranchList"] = SelectedBranchList;
                }
            }
            if ((ReportModuleNM == "BankBook" || ReportModuleNM == "CashBook") && Convert.ToString(Session["ButtonUser"]) == "User")
            {
                Session["SelectedTagPartyList"] = "";
                Session["SelectedTagLedgerList"] = "";
                Session["SelectedTagEmployeeList"] = "";
                Session["SelectedTagProductList"] = "";
                List<object> docList = grid_User.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedUserList += "," + Dobj;
                }
                SelectedUserList = SelectedUserList.TrimStart(',');
                if (SelectedUserList.Trim() == "")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), UniqueID, "jAlert('Please Select Some Document(s)')", true);
                    Session["SelectedUserList"] = "";
                }
                else
                {
                    Session["SelectedUserList"] = SelectedUserList;
                }
            }
            if (ReportModuleNM == "BankBook" && Convert.ToString(Session["ButtonBank"]) == "Bank")
            {
                Session["SelectedTagPartyList"] = "";
                Session["SelectedTagLedgerList"] = "";
                Session["SelectedTagEmployeeList"] = "";
                Session["SelectedTagProductList"] = "";
                string SelectedCashBankList = "";
                List<object> docList = grid_Bank.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedCashBankList += "," + Dobj;
                }
                SelectedCashBankList = SelectedCashBankList.TrimStart(',');
                if (SelectedCashBankList.Trim() == "")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), UniqueID, "jAlert('Please Select Some Document(s)')", true);
                    Session["SelectedCashBankList"] = "";
                }
                else
                {
                    Session["SelectedCashBankList"] = SelectedCashBankList;
                }
            }
            if (ReportModuleNM == "CashBook" && Convert.ToString(Session["ButtonCash"]) == "Cash")
            {
                Session["SelectedTagPartyList"] = "";
                Session["SelectedTagLedgerList"] = "";
                Session["SelectedTagEmployeeList"] = "";
                Session["SelectedTagProductList"] = "";
                string SelectedCashBankList = "";
                List<object> docList = grid_Cash.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedCashBankList += "," + Dobj;
                }
                SelectedCashBankList = SelectedCashBankList.TrimStart(',');
                if (SelectedCashBankList.Trim() == "")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), UniqueID, "jAlert('Please Select Some Document(s)')", true);
                    Session["SelectedCashBankList"] = "";
                }
                else
                {
                    Session["SelectedCashBankList"] = SelectedCashBankList;
                }
            }
            //if (ReportModuleNM == "LedgerPost" && Convert.ToString(Session["ButtonParty"]) == "Party")
            //{
            //    List<object> docList = grid_Party.GetSelectedFieldValues("ID");
            //    foreach (object Dobj in docList)
            //    {
            //        SelectedPartyList += "," + Dobj;
            //    }
            //    SelectedPartyList = SelectedPartyList.TrimStart(',');
            //    if (SelectedPartyList.Trim() == "")
            //    {
            //        ScriptManager.RegisterStartupScript(this, GetType(), UniqueID, "jAlert('Please Select Some Document(s)')", true);
            //        Session["SelectedPartyList"] = "";
            //    }
            //    else
            //    {
            //        Session["SelectedPartyList"] = SelectedPartyList;
            //        var aa = Session["SelectedTagPartyList"];
            //    }
            //}
            else if (ReportModuleNM == "Proforma1")
            {
                List<object> docList = grid_Documents.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedBranchList += "," + Dobj;
                }
            }
            StartDate = Convert.ToDateTime(TxtStartDate.Value).ToString("yyyy-MM-dd");
            EndDate = Convert.ToDateTime(TxtEndDate.Value).ToString("yyyy-MM-dd");
            HttpContext.Current.Response.Redirect("~/Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + "&&StartDate=" + StartDate + "&&EndDate=" + EndDate + "&&reportname=" + Convert.ToString(Request.QueryString["reportname"]));
        }


        protected void btnNewFileSave_Click(object sender, EventArgs e)
        {
            string reportName = txtFileName.Text;
            //HttpContext.Current.Response.Redirect("~/Reports/REPXReports/ReportDesignerRepx.aspx?NewReport=" + reportName);
            HttpContext.Current.Response.Redirect("~/Reports/REPXReports/ReportDesignerRepx.aspx?NewReport=" + reportName + "&&reportname=" + Convert.ToString(Request.QueryString["reportname"]));
        }

        protected void cgridDocuments_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindDocumentsDetails")
            {
                //DataTable dtdata = GetGridData();
                DataTable dtdata = GetDocumentListGridData();
                if (dtdata != null && dtdata.Rows.Count > 0)
                {
                    //grid_Documents.DataSource = dtdata;
                    Session["ReportMain_DocumentList"] = dtdata;
                    grid_Documents.DataBind();
                }
                else
                {
                    grid_Documents.DataSource = null;
                    grid_Documents.DataBind();
                }
            }
            else if (strSplitCommand == "SelectAndDeSelectDocuments")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.SelectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "UnSelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.UnselectRow(i);
                    //}
                    gv.Selection.UnselectAll();
                }
                if (State == "Revart")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        if (gv.Selection.IsRowSelected(i))
                            //gv.Selection.UnselectRow(i);
                            gv.Selection.UnselectAll();
                        else
                            //gv.Selection.SelectRow(i);
                            gv.Selection.SelectAll();
                    }

                }
            }
            else
            {
                string SelectedDocList = "";

                List<object> docList = grid_Documents.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedDocList += "," + Dobj;
                }
                SelectedDocList = SelectedDocList.TrimStart(',');
                if (SelectedDocList.Trim() == "")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), SelectedDocList, "jAlert('Please Select Some Document(s)')", true);
                }
                else
                {
                    Session["SelectedDocumentList"] = SelectedDocList;
                }
            }
        }

        protected void cgridBranch_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string userbranch = "";
            Session["ButtonName"] = "Branch";
            if (Session["userbranchHierarchy"] != null)
            {
                userbranch = Convert.ToString(Session["userbranchHierarchy"]);
            }
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindDocumentsDetails")
            {
                DataTable dtdata = GetDocumentListGridData();
                if (dtdata != null && dtdata.Rows.Count > 0)
                {
                    //   grid_Branch.DataSource = dtdata;
                    Session["ReportMain_BranchList"] = dtdata;
                    grid_Branch.DataBind();
                }
                else
                {
                    grid_Branch.DataSource = null;
                    grid_Branch.DataBind();
                }
            }
            else if (strSplitCommand == "SelectAndDeSelectDocuments")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.SelectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "UnSelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.UnselectRow(i);
                    //}
                    gv.Selection.UnselectAll();
                }
                if (State == "Revart")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        if (gv.Selection.IsRowSelected(i))
                            //gv.Selection.UnselectRow(i);
                            gv.Selection.UnselectAll();
                        else
                            //gv.Selection.SelectRow(i);
                            gv.Selection.SelectAll();
                    }
                }
            }

            else
            {
                string SelectedTagBranchList = "";

                List<object> docList = grid_Branch.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedTagBranchList += "," + Dobj;
                }
                SelectedTagBranchList = SelectedTagBranchList.TrimStart(',');
                if (SelectedTagBranchList.Trim() == "")
                {
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                }
                else
                {
                    Session["SelectedTagBranchList"] = SelectedTagBranchList;
                }
            }
        }

        protected void cgridUser_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string userbranch = "";
            Session["ButtonName"] = "User";
            if (Session["userbranchHierarchy"] != null)
            {
                userbranch = Convert.ToString(Session["userbranchHierarchy"]);
            }
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindDocumentsDetails")
            {
                DataTable dtdata = GetDocumentListGridData();
                if (dtdata != null && dtdata.Rows.Count > 0)
                {
                    //   grid_Branch.DataSource = dtdata;
                    Session["ReportMain_UserList"] = dtdata;
                    grid_User.DataBind();
                }
                else
                {
                    grid_User.DataSource = null;
                    grid_User.DataBind();
                }
            }
            else if (strSplitCommand == "SelectAndDeSelectDocuments")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.SelectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "UnSelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.UnselectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "Revart")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        if (gv.Selection.IsRowSelected(i))
                            gv.Selection.UnselectRow(i);
                        else
                            gv.Selection.SelectRow(i);
                    }
                }
            }
            else
            {
                string SelectedUserList = "";

                List<object> docList = grid_User.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedUserList += "," + Dobj;
                }
                SelectedUserList = SelectedUserList.TrimStart(',');
                if (SelectedUserList.Trim() == "")
                {
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                }
                else
                {
                    Session["SelectedUserList"] = SelectedUserList;
                }
            }
        }

        protected void cgridBank_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string userbranch = "";
            Session["ButtonName"] = "Bank";
            if (Session["userbranchHierarchy"] != null)
            {
                userbranch = Convert.ToString(Session["userbranchHierarchy"]);
            }
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindDocumentsDetails")
            {
                DataTable dtdata = GetDocumentListGridData();
                if (dtdata != null && dtdata.Rows.Count > 0)
                {
                    //   grid_Branch.DataSource = dtdata;
                    Session["ReportMain_BankList"] = dtdata;
                    grid_Bank.DataBind();
                }
                else
                {
                    grid_Bank.DataSource = null;
                    grid_Bank.DataBind();
                }
            }
            else if (strSplitCommand == "SelectAndDeSelectDocuments")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.SelectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "UnSelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.UnselectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "Revart")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        if (gv.Selection.IsRowSelected(i))
                            gv.Selection.UnselectRow(i);
                        else
                            gv.Selection.SelectRow(i);
                    }
                }
            }
            else
            {
                string SelectedBankList = "";

                List<object> docList = grid_Bank.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedBankList += "," + Dobj;
                }
                SelectedBankList = SelectedBankList.TrimStart(',');
                if (SelectedBankList.Trim() == "")
                {
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                }
                else
                {
                    Session["SelectedBankList"] = SelectedBankList;
                }
            }
        }

        protected void cgridCash_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string userbranch = "";
            Session["ButtonName"] = "Cash";
            if (Session["userbranchHierarchy"] != null)
            {
                userbranch = Convert.ToString(Session["userbranchHierarchy"]);
            }
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindDocumentsDetails")
            {
                DataTable dtdata = GetDocumentListGridData();
                if (dtdata != null && dtdata.Rows.Count > 0)
                {
                    //   grid_Branch.DataSource = dtdata;
                    Session["ReportMain_CashList"] = dtdata;
                    grid_Cash.DataBind();
                }
                else
                {
                    grid_Cash.DataSource = null;
                    grid_Cash.DataBind();
                }
            }
            else if (strSplitCommand == "SelectAndDeSelectDocuments")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.SelectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "UnSelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.UnselectRow(i);
                    //}
                    gv.Selection.SelectAll();
                }
                if (State == "Revart")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        if (gv.Selection.IsRowSelected(i))
                            gv.Selection.UnselectRow(i);
                        else
                            gv.Selection.SelectRow(i);
                    }
                }
            }
            else
            {
                string SelectedCashList = "";

                List<object> docList = grid_Cash.GetSelectedFieldValues("ID");
                foreach (object Dobj in docList)
                {
                    SelectedCashList += "," + Dobj;
                }
                SelectedCashList = SelectedCashList.TrimStart(',');
                if (SelectedCashList.Trim() == "")
                {
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                }
                else
                {
                    Session["SelectedCashList"] = SelectedCashList;
                }
            }
        }

        protected void cgridDocDesc_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string userbranch = "";
            if (Session["userbranchHierarchy"] != null)
            {
                userbranch = Convert.ToString(Session["userbranchHierarchy"]);
            }
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindDocumentsDetails")
            {
                string DocumentType = Convert.ToString(e.Parameters.Split('~')[1]);
                Session["DocumentType"] = DocumentType;
                if (DocumentType == "Party")
                {
                    Session["ButtonName"] = "Party";
                    //grid_DocDesc.Columns[3].Caption = "Party Code";
                    grid_DocDesc.Columns[3].Visible = false;
                    //grid_DocDesc.Columns[4].Caption = "Party Name";
                }
                else if (DocumentType == "Ledger")
                {
                    Session["ButtonName"] = "Ledger";
                    //grid_DocDesc.Columns[3].Caption = "Ledger Code";
                    //grid_DocDesc.Columns[4].Caption = "Description";
                }
                else if (DocumentType == "Employee")
                {
                    Session["ButtonName"] = "Employee";
                    //grid_DocDesc.Columns[3].Caption = "Employee Code";
                    grid_DocDesc.Columns[3].Visible = false;
                    //grid_DocDesc.Columns[4].Caption = "Employee Name";
                }
                else
                {
                    Session["ButtonName"] = "Product";
                    //DataTable dtdata = GetDocumentListGridData();
                    //Session["ReportMain_DocDescList"] = dtdata;
                    //grid_DocDesc.DataSource = dtdata;
                    //grid_DocDesc.DataBind();
                    //grid_DocDesc.Columns[0].Visible = false;
                    //grid_DocDesc.Columns[3].Caption = "Product Code";
                    //grid_DocDesc.Columns[4].Caption = "Description";
                }
                DataTable dtdata = GetDocumentListGridData();
                Session["ReportMain_DocDescList"] = dtdata;
                grid_DocDesc.DataSource = dtdata;
                grid_DocDesc.DataBind();
            }
            else if (strSplitCommand == "SelectAndDeSelectDocuments")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.SelectRow(i);
                    //}
                    gv.Selection.SelectAll();
                    if (Convert.ToString(Session["DocumentType"]) == "Party")
                    {
                        gv.Columns[3].Visible = false;
                        gv.Columns[5].Visible = false;
                        gv.Columns[3].Caption = "Party Code";
                        gv.Columns[4].Caption = "Party Name";
                    }
                    else if (Convert.ToString(Session["DocumentType"]) == "Ledger")
                    {
                        gv.Columns[3].Caption = "Ledger Code";
                        gv.Columns[4].Caption = "Description";
                        gv.Columns[5].Visible = false;
                    }
                    else if (Convert.ToString(Session["DocumentType"]) == "Employee")
                    {
                        //gv.Columns[3].Caption = "Employee Code";
                        gv.Columns[3].Caption = "Code";
                        gv.Columns[3].Visible = false;
                        //gv.Columns[4].Caption = "Employee Name";
                        gv.Columns[4].Caption = "SubLedger";
                        gv.Columns[5].Caption = "Type";
                    }
                    else
                    {
                        gv.Columns[3].Caption = "Product Name";
                        gv.Columns[4].Caption = "Description";
                        gv.Columns[5].Visible = false;
                    }

                }
                if (State == "UnSelectAll")
                {
                    //for (int i = 0; i < gv.VisibleRowCount; i++)
                    //{
                    //    gv.Selection.UnselectRow(i);
                    //}
                    gv.Selection.UnselectAll();
                    if (Convert.ToString(Session["DocumentType"]) == "Party")
                    {
                        gv.Columns[3].Visible = false;
                        gv.Columns[5].Visible = false;
                        gv.Columns[3].Caption = "Party Code";
                        gv.Columns[4].Caption = "Party Name";
                    }
                    else if (Convert.ToString(Session["DocumentType"]) == "Ledger")
                    {
                        gv.Columns[3].Caption = "Ledger Code";
                        gv.Columns[4].Caption = "Description";
                        gv.Columns[5].Visible = false;
                    }
                    else if (Convert.ToString(Session["DocumentType"]) == "Employee")
                    {
                        gv.Columns[3].Caption = "Code";
                        gv.Columns[3].Visible = false;
                        gv.Columns[4].Caption = "SubLedger";
                        gv.Columns[5].Caption = "Type";
                    }
                    else
                    {
                        gv.Columns[3].Caption = "Product Name";
                        gv.Columns[4].Caption = "Description";
                        gv.Columns[5].Visible = false;
                    }
                }
                if (State == "Revart")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        if (gv.Selection.IsRowSelected(i))
                            gv.Selection.UnselectRow(i);
                        else
                            gv.Selection.SelectRow(i);
                    }
                    if (Convert.ToString(Session["DocumentType"]) == "Party")
                    {
                        gv.Columns[3].Visible = false;
                        gv.Columns[5].Visible = false;
                        gv.Columns[3].Caption = "Party Code";
                        gv.Columns[4].Caption = "Party Name";
                    }
                    else if (Convert.ToString(Session["DocumentType"]) == "Ledger")
                    {
                        gv.Columns[3].Caption = "Ledger Code";
                        gv.Columns[4].Caption = "Description";
                        gv.Columns[5].Visible = false;
                    }
                    else if (Convert.ToString(Session["DocumentType"]) == "Employee")
                    {
                        gv.Columns[3].Caption = "Code";
                        gv.Columns[3].Visible = false;
                        gv.Columns[4].Caption = "SubLedger";
                        gv.Columns[5].Caption = "Type";
                    }
                    else
                    {
                        gv.Columns[3].Caption = "Product Name";
                        gv.Columns[4].Caption = "Description";
                        gv.Columns[5].Visible = false;
                    }
                }
            }
            else
            {
                if (Convert.ToString(Session["DocumentType"]) == "Party")
                {
                    string SelectedTagPartyList = "";
                    List<object> docList = grid_DocDesc.GetSelectedFieldValues("Doc Code");
                    foreach (object Dobj in docList)
                    {
                        SelectedTagPartyList += "," + Dobj;
                    }
                    SelectedTagPartyList = SelectedTagPartyList.TrimStart(',');
                    if (SelectedTagPartyList.Trim() == "")
                    {
                        Session["SelectedTagPartyList"] = "";
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    }
                    else
                    {
                        Session["SelectedTagPartyList"] = SelectedTagPartyList;
                    }
                }
                else if (Convert.ToString(Session["DocumentType"]) == "Ledger")
                {
                    string SelectedTagLedgerList = "";
                    List<object> docList = grid_DocDesc.GetSelectedFieldValues("ID");
                    foreach (object Dobj in docList)
                    {
                        SelectedTagLedgerList += "," + Dobj;
                    }
                    SelectedTagLedgerList = SelectedTagLedgerList.TrimStart(',');
                    if (SelectedTagLedgerList.Trim() == "")
                    {
                        Session["SelectedTagLedgerList"] = "";
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    }
                    else
                    {
                        Session["SelectedTagLedgerList"] = SelectedTagLedgerList;
                    }
                }
                else if (Convert.ToString(Session["DocumentType"]) == "Employee")
                {
                    string SelectedTagemployeeList = "";
                    List<object> docList = grid_DocDesc.GetSelectedFieldValues("Doc Code");
                    foreach (object Dobj in docList)
                    {
                        SelectedTagemployeeList += "," + Dobj;
                    }
                    SelectedTagemployeeList = SelectedTagemployeeList.TrimStart(',');
                    if (SelectedTagemployeeList.Trim() == "")
                    {
                        Session["SelectedTagemployeeList"] = "";
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    }
                    else
                    {
                        Session["SelectedTagemployeeList"] = SelectedTagemployeeList;
                    }
                }
                else
                {
                    string SelectedTagProductList = "";
                    List<object> docList = grid_DocDesc.GetSelectedFieldValues("ID");
                    foreach (object Dobj in docList)
                    {
                        SelectedTagProductList += "," + Dobj;
                    }
                    SelectedTagProductList = SelectedTagProductList.TrimStart(',');
                    if (SelectedTagProductList.Trim() == "")
                    {
                        Session["SelectedTagProductList"] = "";
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "Abc", "Alert('Please Select Some Document(s)')", true);
                    }
                    else
                    {
                        Session["SelectedTagProductList"] = SelectedTagProductList;
                    }
                }
            }
        }

        protected void gridDocDesc_DataBound(object sender, EventArgs e)
        {
            if (Session["ReportMain_DocDescList"] != null)
            {
                grid_DocDesc.DataSource = Session["ReportMain_DocDescList"];
                //grid_DocDesc.Columns[0].Visible = false;
                if (Convert.ToString(Session["DocumentType"]) == "Party")
                {
                    grid_DocDesc.Columns[3].Visible = false;
                    grid_DocDesc.Columns[5].Visible = false;
                    grid_DocDesc.Columns[3].Caption = "Party Code";
                    grid_DocDesc.Columns[4].Caption = "Party Name";
                }
                else if (Convert.ToString(Session["DocumentType"]) == "Ledger")
                {
                    grid_DocDesc.Columns[3].Caption = "Ledger Code";
                    grid_DocDesc.Columns[4].Caption = "Description";
                    grid_DocDesc.Columns[5].Visible = false;
                }
                else if (Convert.ToString(Session["DocumentType"]) == "Employee")
                {
                    grid_DocDesc.Columns[3].Caption = "Code";
                    grid_DocDesc.Columns[3].Visible = false;
                    grid_DocDesc.Columns[4].Caption = "SubLedger";
                    grid_DocDesc.Columns[5].Caption = "Type";
                }
                else
                {
                    grid_DocDesc.Columns[3].Caption = "Product Name";
                    grid_DocDesc.Columns[4].Caption = "Description";
                    grid_DocDesc.Columns[5].Visible = false;
                }
            }
        }
        public DataTable GetDocumentListGridData()
        {
            string query = "";
            string ReportModule = string.Empty;
            //string ReturntoMainPg = Convert.ToString(Session["NewRptModuleName"]);
            ReportModule = Convert.ToString(Request.QueryString["reportname"]);
            //ReturnPage.Value = Convert.ToString(Request.QueryString["reportname"]);
            if ((ReportModule == "StockTrialSumm" || ReportModule == "StockTrialDet" || ReportModule == "StockTrialWH" || ReportModule == "StockTrial1" || ReportModule == "LedgerPost" ||
                ReportModule == "BankBook" || ReportModule == "CashBook") && Convert.ToString(Session["ButtonName"]) == "Branch")
            {
                Session.Remove("ButtonName");
                query = @"Select ROW_NUMBER() over(order by branch_id) SrlNo, branch_id AS ID, branch_code as Doc_Code, branch_description as Description from tbl_master_branch WHERE branch_id IN(" + Convert.ToString(Session["userbranchHierarchy"]) + ") ORDER BY branch_description";
            }
            else if ((ReportModule == "BankBook" || ReportModule == "CashBook") && Convert.ToString(Session["ButtonName"]) == "User")
            {
                Session.Remove("ButtonName");
                if (Convert.ToString(Session["SelectedTagBranchList"]).Trim() != "")
                    query = @"Select ROW_NUMBER() over(order by user_id) SrlNo, user_id AS ID, user_name as 'User' from tbl_master_user WHERE user_branchId IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") ORDER BY user_name";
                else
                    query = "select top 0  null as  'SrlNo',0 as 'ID',0 as 'User' ";
            }
            else if (ReportModule == "BankBook" && Convert.ToString(Session["ButtonName"]) == "Bank")
            {
                Session.Remove("ButtonName");
                if (Convert.ToString(Session["SelectedTagBranchList"]).Trim() != "")
                    //query = @"Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Bank Name' from Master_MainAccount WHERE MainAccount_BankCashType='Bank' AND MainAccount_branchId IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") ORDER BY MainAccount_Name";
                    query = @"Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Bank Name' 
                    from Master_MainAccount WHERE MainAccount_BankCashType='Bank' AND MainAccount_branchId IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ")  " +
                    "union ALL " +
                    "Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Bank Name' " +
                    "from Master_MainAccount WHERE MainAccount_BankCashType='Bank' AND MainAccount_branchId= 0 and " +
                    "not exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID) " +
                    "union ALL " +
                    "Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Bank Name' " +
                    "from Master_MainAccount WHERE MainAccount_BankCashType='Bank' AND MainAccount_branchId= 0 and " +
                    "exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID and branch_id IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + "))";
                else
                    query = "select top 0 null as 'SrlNo',0 as 'ID',0 as 'Bank Name' ";
            }
            else if (ReportModule == "CashBook" && Convert.ToString(Session["ButtonName"]) == "Cash")
            {
                Session.Remove("ButtonName");
                if (Convert.ToString(Session["SelectedTagBranchList"]).Trim() != "")
                    //query = @"Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Bank Name' from Master_MainAccount WHERE MainAccount_BankCashType='Cash' AND MainAccount_branchId IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") ORDER BY MainAccount_Name";
                    query = @"Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Cash' 
                    from Master_MainAccount WHERE MainAccount_BankCashType='Cash' AND MainAccount_branchId IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ")  " +
                    "union ALL " +
                    "Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Cash' " +
                    "from Master_MainAccount WHERE MainAccount_BankCashType='Cash' AND MainAccount_branchId= 0 and " +
                    "not exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID) " +
                    "union ALL " +
                    "Select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID, MainAccount_Name as 'Cash' " +
                    "from Master_MainAccount WHERE MainAccount_BankCashType='Cash' AND MainAccount_branchId= 0 and " +
                    "exists(select 1 from tbl_master_ledgerBranch_map where MainAccount_id =MainAccount_ReferenceID and branch_id IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + "))";
                else
                    query = "select top 0 null as 'SrlNo',0 as 'ID',0 as 'Bank Name' ";
            }
            else if (ReportModule == "LedgerPost" && Convert.ToString(Session["ButtonName"]) == "Party")
            {
                Session.Remove("ButtonName");
                if (Convert.ToString(Session["SelectedTagBranchList"]).Trim() != "")
                    query = @"select ROW_NUMBER() over(order by cnt_id) SrlNo, cnt_id AS ID,cnt_internalId as 'Doc Code',ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Description','' AS Type 
                    FROM tbl_master_contact WHERE cnt_contactType in('CL','DV') and cnt_branchid IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") ORDER BY ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+' '+ISNULL(cnt_lastName,'') ";
                else
                    query = "select top 0 null as 'SrlNo',0 as 'ID',null as 'Doc Code',null as 'Description' ";
            }
            else if (ReportModule == "LedgerPost" && Convert.ToString(Session["ButtonName"]) == "Ledger")
            {
                Session.Remove("ButtonName");
                if (Convert.ToString(Session["SelectedTagBranchList"]).Trim() != "")
                {
                    query = @"SELECT * FROM ( 
                    select ROW_NUMBER() over(order by A.MainAccount_ReferenceID) SrlNo, A.MainAccount_ReferenceID AS ID,A.MainAccount_AccountCode AS 'Doc Code',A.MainAccount_Name AS 'Description','' AS Type  
                    FROM Master_MainAccount A WHERE A.MainAccount_branchId in(0,'')
                    UNION ALL 
                    select ROW_NUMBER() over(order by A.MainAccount_ReferenceID) SrlNo, A.MainAccount_ReferenceID AS ID,A.MainAccount_AccountCode AS 'Doc Code',A.MainAccount_Name AS 'Description','' AS Type  
                    FROM Master_MainAccount A WHERE A.MainAccount_branchId in(" + Convert.ToString(Session["SelectedTagBranchList"]) + ")) AA ORDER BY Description ";
                }
                else
                {
                    query = @"select ROW_NUMBER() over(order by A.MainAccount_ReferenceID) SrlNo, A.MainAccount_ReferenceID AS ID,A.MainAccount_AccountCode AS 'Doc Code',A.MainAccount_Name AS 'Description','' AS Type  
                    FROM Master_MainAccount A WHERE A.MainAccount_branchId in(0,'') ORDER BY A.MainAccount_Name ";
                }
            }
            else if (ReportModule == "LedgerPost" && Convert.ToString(Session["ButtonName"]) == "Employee")
            {
                Session.Remove("ButtonName");
                if (Convert.ToString(Session["SelectedTagBranchList"]).Trim() != "")
                    //                    query = @"select ROW_NUMBER() over(order by cnt_id) SrlNo, cnt_id AS ID,cnt_internalId as 'Doc Code',
                    //                    ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Description'
                    //                    FROM tbl_master_contact WHERE cnt_contactType in('EM') and cnt_branchid IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") ORDER BY ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+' '+ISNULL(cnt_lastName,'') ";
                    query = @" select ROW_NUMBER() over(order by cnt_id) SrlNo, cnt_id AS ID,cnt_internalId as 'Doc Code',ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Description','Employee' Type 
                    FROM tbl_master_contact WHERE cnt_contactType ='EM' and cnt_branchid IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") " +
                    "union ALL " +
                    "select ROW_NUMBER() over(order by cnt_id) SrlNo, cnt_id AS ID,cnt_internalId as 'Doc Code',ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Description','Customer' Type " +
                    "FROM tbl_master_contact WHERE cnt_contactType = 'CL' and cnt_branchid IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") " +
                    "union ALL " +
                    "select ROW_NUMBER() over(order by cnt_id) SrlNo, cnt_id AS ID,cnt_internalId as 'Doc Code',ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Description','Vendor' Type " +
                    "FROM tbl_master_contact WHERE cnt_contactType ='DV' and cnt_branchid IN(" + Convert.ToString(Session["SelectedTagBranchList"]) + ") " +
                    "union ALL " +
                    "select ROW_NUMBER() over(order by cnt_id) SrlNo, cnt_id AS ID,cnt_internalId as 'Doc Code',ISNULL(cnt_firstName,'')+' '+ISNULL(cnt_middleName,'')+'  '+ISNULL(cnt_lastName,'') as 'Description','Customer' Type " +
                    "FROM tbl_master_contact WHERE cnt_contactType IN('CL','DV','EM') and cnt_branchid = 0 " +
                    "union ALL " +
                    "select ROW_NUMBER() over(order by MainAccount_ReferenceID) SrlNo, MainAccount_ReferenceID AS ID,MainAccount_AccountCode as 'Doc Code',MainAccount_Name as 'Description','Ledger' Type FROM Master_MainAccount WHERE MainAccount_SubLedgerType ='Custom' ";
                else
                    query = "select top 0 null as 'SrlNo',0 as 'ID',null as 'Doc Code',null as 'Description',NULL AS Type ";
            }
            else if ((ReportModule == "StockTrialSumm" || ReportModule == "StockTrialDet" || ReportModule == "StockTrialWH") && Convert.ToString(Session["ButtonName"]) == "Product")
            {
                Session.Remove("ButtonName");
                query = @"select ROW_NUMBER() over(order by sProducts_ID) SrlNo, sProducts_ID AS ID,sProducts_Code as 'Doc Code',sProducts_Description as 'Description','' AS Type 
                FROM Master_sProducts WHERE sProduct_IsInventory=1 
                AND sProducts_ID IN(SELECT Distinct StockBranchWarehouseDetail_ProductId FROM Trans_StockBranchWarehouseDetails) ORDER BY sProducts_Description ";
                //                query = @"select 0 as IsSelected,sProducts_ID AS ID,sProducts_Code as 'Product Name',sProducts_Description as 'Description' FROM Master_sProducts WHERE sProduct_IsInventory=1 
                //                AND sProducts_ID IN(SELECT Distinct StockBranchWarehouseDetail_ProductId FROM Trans_StockBranchWarehouseDetails) ORDER BY sProducts_Description ";
            }
            else if (ReportModule == "Proforma1")
            {
                query = @"Select ROW_NUMBER() over(order by Quote_Id) SrlNo, Quote_Id AS ID, Quote_Number, CONVERT(VARCHAR(11),Quote_Expiry, 105) as Quote_Date from tbl_trans_Quotation order by Quote_Number ";
            }
            BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable dt = oDbEngine.GetDataTable(query);
            return dt;
        }

        protected void grid_Branch_DataBinding(object sender, EventArgs e)
        {
            if (Session["ReportMain_BranchList"] != null)
            {
                grid_Branch.DataSource = Session["ReportMain_BranchList"];
            }
        }

        protected void grid_User_DataBinding(object sender, EventArgs e)
        {
            if (Session["ReportMain_UserList"] != null)
            {
                grid_User.DataSource = Session["ReportMain_UserList"];
            }
        }

        protected void grid_Bank_DataBinding(object sender, EventArgs e)
        {
            if (Session["ReportMain_BankList"] != null)
            {
                grid_Bank.DataSource = Session["ReportMain_BankList"];
            }
        }

        protected void grid_Cash_DataBinding(object sender, EventArgs e)
        {
            if (Session["ReportMain_CashList"] != null)
            {
                grid_Cash.DataSource = Session["ReportMain_CashList"];
            }
        }

        protected void grid_DocDesc_DataBinding(object sender, EventArgs e)
        {
            if (Session["ReportMain_DocDescList"] != null)
            {
                grid_DocDesc.DataSource = Session["ReportMain_DocDescList"];
                //grid_DocDesc.Columns[0].Visible = false;
            }
        }

        protected void grid_Documents_DataBinding(object sender, EventArgs e)
        {
            if (Session["ReportMain_DocunmentList"] != null)
            {
                grid_Branch.DataSource = Session["ReportMain_DocunmentList"];
            }
        }
    }
}