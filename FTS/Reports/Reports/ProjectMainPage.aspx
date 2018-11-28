<%@ Page Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master"  AutoEventWireup="true" CodeBehind="ProjectMainPage.aspx.cs" Inherits="Reports.Reports.ProjectMainPage" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <ul>
                     
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=StockTrialSumm">Stock Trial-Summary</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=StockTrialDet">Stock Trial-Details</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=StockTrialWH">Stock Trial-Warehouse</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=StockTrial1">Stock Trial New</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Install_Coupon">Installation Coupons</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Invoice">Sales Invoice(GST)</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=TSInvoice">Transit Sales Invoice</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=PInvoice">Purchase Invoice</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=TPInvoice">Transit Purchase Invoice</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Proforma">Sales Proforma</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=LedgerPost">Ledger Posting</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=CashBook">Cash Book</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=BankBook">Bank Book</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Invoice_POS">Sales invoice(POS)</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=POS_Duplicate">Sales invoice(POS Duplicate)</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Porder">Purchase Order</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Sorder">Sales Order</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=BranchReq">Branch Requisition</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=BranchTranOut">Branch Transfer Out</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Sales_Return">Sales Return</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Purchase_Return">Purchase Return</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=PChallan">Purchase Challan</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=SChallan">Sales Challan</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=ODSDChallan">Delivery Challan(ODSD)</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=RChallan">Road Challan</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=PDChallan">Pending Delivery Challan</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxSetDefaultDesign.aspx?modulename=Design">Select Design</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=CUSTRECPAY">Customer Receipt Payment</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=VENDRECPAY">Vendor Receipt Payment</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=CBVUCHR">Cash/bank Voucher</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=Second_Hand">Second Hand Sales</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=PIQuotation">Proforma Invoice/Quotation</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=CUSTDRCRNOTE">Customer Debit/Credit Note</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=VENDDRCRNOTE">Vendor Debit/Credit Note</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=CONTRAVOUCHER">Contra Voucher</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=OLDUNTRECVD">Old Unit Received</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=CONTRAVOUCHER">Contra Voucher</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=JOURNALVOUCHER">Journal Voucher</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CardBankReport.aspx">Card/Bank Reports</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CashBankReport.aspx">Cash/Bank Reports</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CashBankReport_NEW.aspx">New Cash/Bank Reports</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/DebtorsDetailsDR.aspx">Debtors Details -- Debit</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/DebtorsDetailsCR.aspx">Debtors Details -- Credit</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Creditors-Details.aspx">Creditors Details</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/FinalReport.aspx">Final Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/ExportDetailsReport.aspx">Export Details Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Gstr-1Report.aspx">Gstr-1 Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CombineStockTrial.aspx">Combined Stock Trial Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Consolidated-Stock.aspx">Consolidated Stock Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/REPXReports/RepxReportMain.aspx?reportname=PURCHASE_RET_REQ">Purchase Return Request</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CombinedSalePurchaseReport.aspx">Combined Sale/Purchase Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/SalaryDisbursment.aspx">Salary Disbursement</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Insurance-Register.aspx">Insurance Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Gstr2Report.aspx">Gstr-2 Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/LedgerPostingReport.aspx">Ledger Posting Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/frm_saleouttaxreg.aspx">Output Tax Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/frm_purintaxreg.aspx">Input Tax Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/JsonParse-Gstr1.aspx">Json GSTR1 Reconcilation</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/JsonParse.aspx">Json GSTR2 Reconcilation</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GeneralTrialReport.aspx">General Trial Report</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Customer_Ledger.aspx">Customer Ledger</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Vendor_Ledger.aspx">Vendor Ledger</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CustomerOutstanding.aspx">Customer Outstanding</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/PartyOutstanding.aspx">Party Outstanding</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Demo_Register.aspx">Demo Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/FinanceCNReport.aspx">Finance Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GSTR_Customerpaymentreceipt.aspx">GSTR Customerpaymentreceipt Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GSTR_HSNcodeRate.aspx">GSTR HSNcodeRate Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GSTR_PurchaseRegister.aspx">GSTR Purchase Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GSTR_SaleRegister.aspx">GSTR Sales Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GSTR_Vendorpaymetreceipt.aspx">GSTR Vendorpaymetreceipt Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/PartyLedgerPostingReport.aspx">Consolidated Party Ledger</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/PurchaseRegister.aspx">Purchase Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/SalesRegisterReport.aspx">Sales Register</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/SalesAnalysis.aspx">Sales Analysis</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/SerialwiseDetails.aspx">Serialwise Details</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/Stock_Ageing.aspx">Stock Ageing</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/StockTrialSummary.aspx">StockTrial Summary Grid</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/StockValuation.aspx">Stock Valuation</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GST_RCMStatement.aspx">RCM Statement</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/TDS_Report.aspx">TDS Report</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/BranchWisePartyOutstanding.aspx">Branch Wise Party Outstanding</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/PurchaseRegister_Details.aspx">Purchase Invoice Register Details</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/SalesRegister_Details.aspx">Sales Invoice Register Details</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/SalesReturnRegister_Details.aspx">Sales Return Register Details</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/PurchaseReturnRegister_Details.aspx">Purchase Return Register Details</a></li> 
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/PurchaseOrderRegister_Details.aspx">Purchase Order Register Details</a></li>   
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/SalesOrderRegister_Details.aspx">Sale Order Register Details</a></li>   
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CashBankBookRegister_Details.aspx">Cash Bank Register Details</a></li>   
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GeneralLedgerRegister.aspx">General Ledger Register</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CustomerRecPayRegister.aspx">Customer Receipt/Payment Register Report</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/VendorRecPayRegister.aspx">Vendor Receipt/Payment Register Report</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/PaymentCollection_Details.aspx">Payment Collection Report</a></li>       
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/CashBankBookSummary.aspx">Cash Bank Book Summary</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/DayBook.aspx">Day Book Report</a></li>    
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/JournalRegister_Details.aspx">Journal Register Details</a></li>
    <li style="font:50px"><a style="font-size: small;"" href="/Reports/GridReports/GeneralLedgerPosting.aspx">General Ledger</a></li>
</ul>


</asp:Content>
