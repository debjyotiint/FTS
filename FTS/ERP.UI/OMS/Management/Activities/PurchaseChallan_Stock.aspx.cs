﻿using BusinessLogicLayer;
using BusinessLogicLayer.EmailDetails;
using DataAccessLayer;
using DevExpress.Web;
using DevExpress.Web.Data;
using EntityLayer.CommonELS;
using EntityLayer.MailingSystem;
using ERP.OMS.Reports;
using ERP.OMS.Tax_Details.ClassFile;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using UtilityLayer;

namespace ERP.OMS.Management.Activities
{
    public partial class PurchaseChallan_Stock : ERP.OMS.ViewState_class.VSPage
    {
        BusinessLogicLayer.Converter objConverter = new BusinessLogicLayer.Converter();
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        clsDropDownList oclsDropDownList = new clsDropDownList();
        BusinessLogicLayer.Contact oContactGeneralBL = new BusinessLogicLayer.Contact();
        public EntityLayer.CommonELS.UserRightsForPage rights = new UserRightsForPage();
        string UniquePurchaseNumber = string.Empty;
        SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
        PurchaseChallanBL objPurchaseChallanBL = new PurchaseChallanBL();
        GSTtaxDetails gstTaxDetails = new GSTtaxDetails();
        BusinessLogicLayer.RemarkCategoryBL reCat = new BusinessLogicLayer.RemarkCategoryBL();
        SalesInvoiceBL objSalesInvoiceBL = new SalesInvoiceBL();
        string barnchid = string.Empty;
        public string pageAccess = "";

        #region Sandip Section For Approval Section Start
        ERPDocPendingApprovalBL objERPDocPendingApproval = new ERPDocPendingApprovalBL();
        #endregion Sandip Section For Approval Dtl Section End

        #region Sandip Section For Approval Section Start
        public void IsExistsDocumentInERPDocApproveStatus(string orderId)
        {
            string editable = "";
            string status = "";
            DataTable dt = new DataTable();
            int Id = Convert.ToInt32(orderId);
            dt = objERPDocPendingApproval.IsExistsDocumentInERPDocApproveStatus(Id, 10); // 2 for Purchase Challan Invoice
            if (dt.Rows.Count > 0)
            {
                editable = Convert.ToString(dt.Rows[0]["editable"]);
                if (editable == "0")
                {
                    lbl_quotestatusmsg.Visible = true;
                    status = Convert.ToString(dt.Rows[0]["Status"]);
                    if (status == "Approved")
                    {
                        lbl_quotestatusmsg.Text = "Document already Approved";
                    }
                    if (status == "Rejected")
                    {
                        lbl_quotestatusmsg.Text = "Document already Rejected";
                    }
                    btn_SaveRecords.Visible = false;
                    ASPxButton1.Visible = false;
                }
                else
                {
                    lbl_quotestatusmsg.Visible = false;
                    btn_SaveRecords.Visible = true;
                    ASPxButton1.Visible = true;
                }
            }
        }

        #endregion Sandip Section For Approval Dtl Section End
        protected void Page_PreInit(object sender, EventArgs e) // lead add
        {

            #region Sandip Section For Approval Section Start
            if (Request.QueryString.AllKeys.Contains("status"))
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/PopUp.Master";
                //divcross.Visible = false;
            }
            else
            {
                this.Page.MasterPageFile = "~/OMS/MasterPage/ERP.Master";
                //divcross.Visible = true;
            }
            #endregion Sandip Section For Approval Dtl Section End
            if (!IsPostBack)
            {
                string sPath = Convert.ToString(HttpContext.Current.Request.Url);


                oDBEngine.Call_CheckPageaccessebility(sPath);
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            this.Session["LastCompany1"] = Session["LastCompany"];
            this.Session["LastFinYear1"] = Session["LastFinYear"];
            this.Session["userbranch"] = Session["userbranchID"];
            hiddenOnGridBind.Value = "";
            //rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/Activities/SalesQuotation.aspx");
            if (HttpContext.Current.Session["userid"] == null)
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
            if (!IsPostBack)
            {
                #region NewTaxblock

                string ItemLevelTaxDetails = string.Empty; string HSNCodewisetaxSchemid = string.Empty; string BranchWiseStateTax = string.Empty; string StateCodeWiseStateIDTax = string.Empty;
                gstTaxDetails.GetTaxData(ref ItemLevelTaxDetails, ref HSNCodewisetaxSchemid, ref BranchWiseStateTax, ref StateCodeWiseStateIDTax, "P");
                HDItemLevelTaxDetails.Value = ItemLevelTaxDetails;
                HDHSNCodewisetaxSchemid.Value = HSNCodewisetaxSchemid;
                HDBranchWiseStateTax.Value = BranchWiseStateTax;
                HDStateCodeWiseStateIDTax.Value = StateCodeWiseStateIDTax;

                #endregion

                // Cross Branch Section by Sam on 10052017 Start
                string branchid = "";
                string branch = "";


                if (Request.QueryString.AllKeys.Contains("status"))
                {
                    DataTable dt = objPurchaseChallanBL.GetBranchIdByPCID(Convert.ToString(Request.QueryString["key"]));
                    branchid = Convert.ToString(dt.Rows[0]["br"]);
                    branch = oDBEngine.getBranch(branchid, "") + branchid;

                    HttpContext.Current.Session["userbranchHierarchy"] = branch;
                    Session["LastCompany"] = Convert.ToString(dt.Rows[0]["comp"]);
                    Session["LastFinYear"] = Convert.ToString(dt.Rows[0]["finyear"]);


                }
                else
                {
                    branchid = Convert.ToString(Session["userbranchID"]);
                    branch = oDBEngine.getBranch(branchid, "") + branchid;
                }
                #region Sandip Section For Checking User Level for Allow Edit to logging User or Not
                //GetEditablePermission();
                if (Request.QueryString.AllKeys.Contains("status"))
                {


                    divcross.Visible = false;
                    btn_SaveRecords.Visible = false;
                    ApprovalCross.Visible = true;
                    ddl_Branch.Enabled = false;
                }
                else
                {
                    divcross.Visible = true;
                    btn_SaveRecords.Visible = true;
                    ApprovalCross.Visible = false;
                    ddl_Branch.Enabled = false;
                }
                #endregion Sandip Section
                Session["PCTaxDetails"] = null;
                BindBranch();
                //ddl_numberingScheme.Focus();
                ddlInventory.Focus();

                //PopulateCustomerDetail();
                GetAllDropDownDetailForPurchaseChallan();

                GetFinacialYear();
                //dt_PLQuote.Value = Convert.ToDateTime(oDBEngine.GetDate().ToString());
                //txtDateIndentRequis.Value = Convert.ToDateTime(oDBEngine.GetDate().ToString());  

                string finyear = Convert.ToString(Session["LastFinYear"]);


                Session["PCCustomerDetail"] = null;
                Session["PurchaseChallan_Id"] = null;
                Session["PCProductOrderDetails"] = null;
                Session["PcwarehousedetailstempCheckUpdate"] = null;

                Session["Pcwarehousedetailstemp"] = null;
                Session["PcwarehousedetailstempUpdate"] = null;
                Session["PcwarehousedetailstempDelete"] = null;
                Session["PurchaseChallanAddressDtl"] = null;
                Session["PCVendorsDetail"] = null;
                Session["PC_LoopWarehouse"] = "1";
                Session["PC_WarehouseData"] = null;
                Session["PORequiData"] = null;

                #region Session Null Initialization Start
                //Session["QuotationAddressDtl"] = null;
                Session["PCBillingAddressLookup"] = null;
                Session["PCShippingAddressLookup"] = null;
                #endregion Session Null Initialization End


                PopulateGSTCSTVATCombo(DateTime.Now.ToString("yyyy-MM-dd"));
                PopulateChargeGSTCSTVATCombo(DateTime.Now.ToString("yyyy-MM-dd"));

                if (Request.QueryString["key"] == "ADD")
                {
                    #region NO TAX IN GRN - Checking

                    BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                    DataTable DT = objEngine.GetDataTable("Config_SystemSettings", " Variable_Value ", " Variable_Name='NoTax_GRN' AND IsActive=1");
                    if (DT != null && DT.Rows.Count > 0)
                    {
                        string IsMandatory = Convert.ToString(DT.Rows[0]["Variable_Value"]).Trim();

                        if (IsMandatory == "Yes")
                        {
                            ddl_AmountAre.Value = "3";
                            ddl_AmountAre.ClientEnabled = false;
                        }
                    }

                    #endregion

                    Keyval_internalId.Value = "Add";
                    Session["PC_LoopWarehouse"] = "1";

                    ViewState["ActionType"] = "Add";
                    if (!String.IsNullOrEmpty(Convert.ToString(Session["userbranchID"])))
                    {
                        string strdefaultBranch = Convert.ToString(Session["userbranchID"]);
                        ddl_Branch.SelectedValue = strdefaultBranch;
                    }
                    if (!String.IsNullOrEmpty(Convert.ToString(Session["LocalCurrency"])))
                    {
                        string CompID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                        string LocalCurrency = Convert.ToString(Session["LocalCurrency"]);
                        string basedCurrency = Convert.ToString(LocalCurrency.Split('~')[0]);
                        string CurrencyId = Convert.ToString(basedCurrency[0]);
                        ddl_Currency.SelectedValue = CurrencyId;
                        txt_Rate.ClientEnabled = false;
                        int ConvertedCurrencyId = Convert.ToInt32(CurrencyId);

                        DataTable dt = objPurchaseChallanBL.GetCurrentConvertedRate(Convert.ToInt16(CurrencyId), ConvertedCurrencyId, CompID);
                        if (dt != null && dt.Rows.Count > 0)
                        {
                            txt_Rate.Text = Convert.ToString(dt.Rows[0]["PurchaseRate"]);
                        }
                    }

                    #region Debjyoti Get Tax Details in Edit Mode


                    CreateDataTaxTable();


                    #endregion Debjyoti Get Tax Details in Edit Mode

                    hdnPageStatus.Value = "first";
                    ddlInventory.Focus();


                }
                else
                {

                    Keyval_internalId.Value = "PurchaseChallan_Stock" + Request.QueryString["key"];

                    //string strCustomer = oDBEngine.ExeSclar("select PurchaseChallan_VendorId from dbo.tbl_trans_PurchaseChallan where PurchaseChallan_Id=" + Request.QueryString["key"]);
                    hdnCustomerId.Value = Request.QueryString["key"];
                    hiddenOnGridBind.Value = "OnGridBindAddRow";

                    hdnPageStatus.Value = "update";
                    lblHeading.Text = "Modify Purchase GRN";
                    divNumberingScheme.Style.Add("display", "none");
                    lbl_NumberingScheme.Visible = false;
                    ddl_numberingScheme.Visible = false;
                    Session["PurchaseChallan_Id"] = Request.QueryString["key"];
                    ViewState["ActionType"] = "Edit";
                    FillGrid();
                    CalculateGRNAmount();

                    Session["PCProductOrderDetails"] = GetPurchaseChallanData().Tables[0];
                    grid.DataSource = GetPurchaseChallanBatch();
                    grid.DataBind();
                    hdnPageStatus.Value = "update";


                    Session["PC_WarehouseData"] = GetChallanWarehouseData();

                    #region Debjyoti Get Tax Details in Edit Mode
                    Session["PCTaxDetails"] = GetTaxDataWithGST(GetTaxData(dt_PLQuote.Date.ToString("yyyy-MM-dd")));
                    //    Session["PChallanTaxDetails"] = GetQuotationTaxData().Tables[0];
                    DataTable quotetable = GetQuotationEditedTaxData().Tables[0];
                    if (quotetable == null)
                    {
                        CreateDataTaxTable();
                    }
                    else
                    {
                        Session["PCFinalTaxRecord"] = quotetable;
                    }

                    #endregion Debjyoti Get Tax Details in Edit Mode

                    #region Sandip Approval Section Start
                    if (Request.QueryString["status"] == null)
                    {
                        IsExistsDocumentInERPDocApproveStatus(hdnCustomerId.Value);
                    }
                    #endregion Sandip Approval Section End

                    if (Request.QueryString["req"] == "V")
                    {
                        btn_SaveRecords.Visible = false;
                        btn_SaveRecordsExit.Visible = false;
                        lbl_quotestatusmsg.Text = "*** View Mode Only";
                    }
                    else
                    {
                        bool IsExist = IsPITransactionExist(Convert.ToString(Session["PurchaseChallan_Id"]));
                        if (IsExist == true)
                        {
                            btn_SaveRecords.Visible = false;
                            btn_SaveRecordsExit.Visible = false;
                            lbl_IsTagged.Text = "*** This Purchase Challan is tagged in other modules. Cannot Modify data except UDF";
                        }
                    }
                }

                ///Mail Visibility
                VisiblitySendEmail();


                ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "GridCallBack()", true);
                //CmbScheme.Value = 0;
            }
            else
            {
                //PopulateCustomerDetail();
            }


        }

        #region Others

        private bool IsPITransactionExist(string PIid)
        {
            bool IsExist = false;
            if (PIid != "" && Convert.ToString(PIid).Trim() != "")
            {
                DataTable dt = new DataTable();
                dt = CheckPITraanaction(PIid);
                if (dt.Rows.Count > 0 && Convert.ToString(dt.Rows[0]["isexist"]) != "0")
                {
                    IsExist = true;
                }
            }

            return IsExist;
        }
        public DataTable CheckPITraanaction(string piid)
        {
            DataTable dt = new DataTable();

            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 100, "PurchaseChallanTagOrNot");
            proc.AddVarcharPara("@PCID", 200, piid);

            dt = proc.GetTable();
            return dt;
        }
        public void GetFinacialYear()
        {
            string finyear = "";
            DateTime MinDate, MaxDate;

            if (Session["LastFinYear"] != null)
            {
                finyear = Convert.ToString(Session["LastFinYear"]).Trim();
                DataTable dtFinYear = objSlaesActivitiesBL.GetFinacialYearBasedQouteDate(finyear);
                if (dtFinYear != null && dtFinYear.Rows.Count > 0)
                {
                    MinDate = Convert.ToDateTime(dtFinYear.Rows[0]["finYearStartDate"]);
                    MaxDate = Convert.ToDateTime(dtFinYear.Rows[0]["finYearEndDate"]);

                    dt_PLQuote.Value = null;
                    dt_PLQuote.MinDate = MinDate;
                    dt_PLQuote.MaxDate = MaxDate;

                    if (DateTime.Now > MaxDate)
                    {
                        dt_PLQuote.Value = MaxDate;
                    }
                    else
                    {
                        dt_PLQuote.Value = DateTime.Now;
                    }
                }
            }
        }
        public void BindBranch()
        {
            DS_Branch.SelectCommand = "SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where BRANCH_id in(" + Convert.ToString(Session["userbranchHierarchy"]) + ")";
            ddl_Branch.DataBind();
        }
        public void PopulateCustomerDetail()
        {
            if (Session["PCVendorsDetail"] == null)
            {
                DataTable dtCustomer = new DataTable();
                dtCustomer = objPurchaseChallanBL.PopulateVendorsDetail();

                if (dtCustomer != null && dtCustomer.Rows.Count > 0)
                {
                    lookup_Customer.DataSource = dtCustomer;
                    lookup_Customer.DataBind();
                    Session["PCVendorsDetail"] = dtCustomer;
                }
            }
            else
            {
                lookup_Customer.DataSource = (DataTable)Session["PCVendorsDetail"];
                lookup_Customer.DataBind();
            }

        }
        public void FillGrid()
        {
            DataTable PurchaseOrderEditdt = GetPurchaseChallanEditData();
            if (PurchaseOrderEditdt != null && PurchaseOrderEditdt.Rows.Count > 0)
            {
                string PurchaseOrder_Number = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_Number"]);//0
                string PurchaseOrder_IndentId = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_PurchaseOrderId"]);//1
                string PurchaseOrder_BranchId = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_BranchId"]);//2
                string PurchaseOrder_Date = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_Date"]);//3

                string Customer_Id = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_VendorId"]);//5
                string Contact_Person_Id = Convert.ToString(PurchaseOrderEditdt.Rows[0]["Contact_Person_Id"]);//6
                string PurchaseOrder_Reference = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_Reference"]);//7
                string PurchaseOrder_Currency_Id = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_Currency_Id"]);//8
                string Currency_Conversion_Rate = Convert.ToString(PurchaseOrderEditdt.Rows[0]["Currency_Conversion_Rate"]);//9
                string Tax_Option = Convert.ToString(PurchaseOrderEditdt.Rows[0]["Tax_Option"]);//10
                string Tax_Code = Convert.ToString(PurchaseOrderEditdt.Rows[0]["Tax_Code"]);//11
                string PurchaseOrder_SalesmanId = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_SalesmanId"]);//12
                string PurchaseOrder_IndentDate = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_PurchaseOrderDate"]);//13
                string PurchaseOrderDate = Convert.ToString(PurchaseOrderEditdt.Rows[0]["OrderDate"]);//13
                string IsInventory = Convert.ToString(PurchaseOrderEditdt.Rows[0]["IsInventoryType"]);
                string strPartyInvoice = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PartyInvoiceNo"]);
                string strPartyDate = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PartyInvoiceDate"]);

                barnchid = PurchaseOrder_BranchId;
                if (IsInventory != "") ddlInventory.SelectedValue = IsInventory;
                ddlInventory.Enabled = false;
                txtPartyInvoice.Text = strPartyInvoice;
                if (strPartyDate != "") dt_PartyDate.Date = Convert.ToDateTime(strPartyDate);


                txtVoucherNo.Text = PurchaseOrder_Number;
                txtVoucherNo.ReadOnly = true;
                dt_PLQuote.Date = Convert.ToDateTime(PurchaseOrder_Date);
                // ddl_IndentRequisitionNo.SelectedValue = PurchaseOrder_IndentId;

                if (!string.IsNullOrEmpty(PurchaseOrder_IndentDate))
                {
                    txtDateIndentRequis.Date = Convert.ToDateTime(PurchaseOrder_IndentDate);
                }
                //else
                //{
                //    txtDateIndentRequis.Date = "";
                //}
                // ddl_Vendor.SelectedValue = Customer_Id;
                lookup_Customer.GridView.Selection.SelectRowByKey(Customer_Id);
                PopulateContactPersonOfCustomer(Customer_Id);
                if (Customer_Id != "")
                {
                    hdfLookupCustomer.Value = Customer_Id;
                }
                if (Contact_Person_Id != "0")
                {
                    cmbContactPerson.Value = Contact_Person_Id;
                }

                txt_Refference.Text = PurchaseOrder_Reference;
                ddl_Branch.SelectedValue = PurchaseOrder_BranchId;
                ddl_SalesAgent.SelectedValue = PurchaseOrder_SalesmanId;
                ddl_Currency.SelectedValue = PurchaseOrder_Currency_Id;
                txt_Rate.Text = Currency_Conversion_Rate;

                if (Tax_Option != "0")
                {
                    if (Tax_Option == "4")
                    {
                        ListEditItem li = new ListEditItem();
                        li.Text = "Import";
                        li.Value = "4";
                        ddl_AmountAre.Items.Insert(3, li);
                    }

                    ddl_AmountAre.Value = Tax_Option;
                }
                PopulateGSTCSTVAT("2");
                if (Tax_Code != "0")
                {
                    ddl_VatGstCst.Value = Tax_Code;
                }
                else
                {
                    ddl_VatGstCst.SelectedIndex = 0;
                }
                ddl_AmountAre.ClientEnabled = false;
                ddl_VatGstCst.ClientEnabled = false;

                string dates = Convert.ToDateTime(PurchaseOrder_Date).ToString("yyyy-MM-dd");
                //if (Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_PurchaseOrderDate"]).Contains("1900"))
                //{
                //    dates = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_Date"]);
                //}
                //else
                //{
                //    dates = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_PurchaseOrderDate"]);
                //}

                //DataTable IndentTable = objPurchaseChallanBL.GetPO(Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_VendorId"]), dates, "DONE");
                //if (IndentTable.Rows.Count <= 0)
                //{
                //    IndentTable = objPurchaseChallanBL.GetPO(Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_VendorId"]), dates, "NOT-DONE");
                //}

                string strChallanID = Convert.ToString(Session["PurchaseChallan_Id"]);
                string FinYear = Convert.ToString(Session["LastFinYear"]);
                string Action = "GetPurchaseOrder";
                DataTable IndentTable = objSalesInvoiceBL.GetComponent(Customer_Id, dates, "", FinYear, PurchaseOrder_BranchId, Action, strChallanID);

                Session["PORequiData"] = IndentTable;

                lookup_quotation.GridView.Selection.CancelSelection();
                lookup_quotation.DataSource = IndentTable;
                lookup_quotation.DataBind();


                string[] eachQuo = Convert.ToString(PurchaseOrderEditdt.Rows[0]["PurchaseChallan_PurchaseOrderId"]).Split(',');
                if (eachQuo.Length > 1)//More tha one quotation
                {
                    dt_Quotation.Text = "Multiple Purchase Order Dates";

                    foreach (string val in eachQuo)
                    {
                        if (!string.IsNullOrEmpty(val))
                        {
                            lookup_quotation.GridView.Selection.SelectRowByKey(Convert.ToInt32(val));
                        }
                    }
                    //grid.JSProperties["cpPurchaseorderbindnewrow"] = "yes";
                }
                else if (eachQuo.Length == 1)//Single Quotation
                {
                    foreach (string val in eachQuo)
                    {
                        if (!string.IsNullOrEmpty(val))
                        {
                            lookup_quotation.GridView.Selection.SelectRowByKey(Convert.ToInt32(val));
                            dt_Quotation.Text = PurchaseOrderDate;

                            int VisibleIndex = lookup_quotation.GridView.FindVisibleIndexByKeyValue(val);
                            lookup_quotation.GridView.FocusedRowIndex = VisibleIndex;
                        }

                    }
                    //grid.JSProperties["cpPurchaseorderbindnewrow"] = "yes";
                }
            }
        }
        public void CalculateGRNAmount()
        {
            DataTable PurchaseOrderEditdt = GetPurchaseChallanCalculater();
            if (PurchaseOrderEditdt != null && PurchaseOrderEditdt.Rows.Count > 0)
            {
                string ProductAmount = Convert.ToString(PurchaseOrderEditdt.Rows[0]["ProductAmount"]);
                string ProductTotalAmount = Convert.ToString(PurchaseOrderEditdt.Rows[0]["ProductTotalAmount"]);
                string NetAmount = Convert.ToString(PurchaseOrderEditdt.Rows[0]["NetAmount"]);
                string ChargesAmount = Convert.ToString(PurchaseOrderEditdt.Rows[0]["ChargesAmount"]);
                string ProductTaxAmount = Convert.ToString(PurchaseOrderEditdt.Rows[0]["ProductTaxAmount"]);
                string ProductQuantity = Convert.ToString(PurchaseOrderEditdt.Rows[0]["ProductQuantity"]);

                txt_Charges.Text = ChargesAmount;
                txt_TaxableAmtval.Text = ProductAmount;
                txt_OtherTaxAmtval.Text = ChargesAmount;
                txt_TaxAmtval.Text = ProductTaxAmount;
                txt_cInvValue.Text = ProductTotalAmount;
                txt_TotalAmt.Text = NetAmount;
                txt_TotalQty.Text = ProductQuantity;
            }
        }
        public IEnumerable GetPurchaseChallanBatch()
        {
            List<PurchaseChallanList_Stock> PurchaseOrderList = new List<PurchaseChallanList_Stock>();
            DataTable Quotationdt = GetPurchaseChallanData().Tables[0];

            for (int i = 0; i < Quotationdt.Rows.Count; i++)
            {
                PurchaseChallanList_Stock PurchaseOrders = new PurchaseChallanList_Stock();

                PurchaseOrders.SrlNo = Convert.ToString(Quotationdt.Rows[i]["SrlNo"]);

                PurchaseOrders.OrderDetails_Id = Convert.ToString(Quotationdt.Rows[i]["OrderDetails_Id"]);
                PurchaseOrders.gvColProduct = Convert.ToString(Quotationdt.Rows[i]["ProductID"]);

                PurchaseOrders.gvColDiscription = Convert.ToString(Quotationdt.Rows[i]["Description"]);
                PurchaseOrders.gvColQuantity = Convert.ToString(Quotationdt.Rows[i]["Quantity"]);
                PurchaseOrders.gvColUOM = Convert.ToString(Quotationdt.Rows[i]["UOM"]);
                PurchaseOrders.Warehouse = "";
                PurchaseOrders.gvColStockQty = Convert.ToString(Quotationdt.Rows[i]["StockQuantity"]);
                PurchaseOrders.gvColStockUOM = Convert.ToString(Quotationdt.Rows[i]["StockUOM"]);
                PurchaseOrders.gvColStockPurchasePrice = Convert.ToString(Quotationdt.Rows[i]["PurchasePrice"]);
                PurchaseOrders.gvColDiscount = Convert.ToString(Quotationdt.Rows[i]["Discount"]);
                PurchaseOrders.gvColAmount = Convert.ToString(Quotationdt.Rows[i]["Amount"]);
                PurchaseOrders.gvColTaxAmount = Convert.ToString(Quotationdt.Rows[i]["TaxAmount"]);
                PurchaseOrders.gvColTotalAmountINR = Convert.ToString(Quotationdt.Rows[i]["TotalAmount"]);
                PurchaseOrders.ProductName = Convert.ToString(Quotationdt.Rows[i]["ProductName"]);
                if (Convert.ToString(Quotationdt.Rows[i]["PoNumber"]) != "0")
                {
                    PurchaseOrders.PoNumber = Convert.ToString(Quotationdt.Rows[i]["PoNumber"]);
                }

                PurchaseOrderList.Add(PurchaseOrders);

                var stocks = Convert.ToString(Quotationdt.Rows[i]["ProductID"]).Split(new string[] { "||@||" }, StringSplitOptions.None)[10];
                var productid = Convert.ToString(Quotationdt.Rows[i]["ProductID"]).Split(new string[] { "||@||" }, StringSplitOptions.None)[0];
                if (!string.IsNullOrEmpty(Convert.ToString(stocks)) && !string.IsNullOrEmpty(Convert.ToString(productid)))
                {
                    InitGetStockWarehouseData(stocks, productid, barnchid);
                }

                PurchaseOrders.TotalQty = Convert.ToString(Quotationdt.Rows[i]["TotalQty"]);
                PurchaseOrders.BalanceQty = Convert.ToString(Quotationdt.Rows[i]["BalanceQty"]);
                PurchaseOrders.IsComponentProduct = Convert.ToString(Quotationdt.Rows[i]["IsComponentProduct"]);
                PurchaseOrders.IsLinkedProduct = Convert.ToString(Quotationdt.Rows[i]["IsLinkedProduct"]);
            }

            return PurchaseOrderList;
        }
        public DataSet GetPurchaseChallanData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "PcBatchEditDetails");
            proc.AddVarcharPara("@PurchaseChallan_Id", 500, Convert.ToString(Session["PurchaseChallan_Id"]));
            proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));

            string dd = ddl_Branch.SelectedValue;

            proc.AddVarcharPara("@branchid", 500, Convert.ToString(Session["userbranchID"]));
            proc.AddVarcharPara("@campany_Id", 500, Convert.ToString(Session["LastCompany"]));

            ds = proc.GetDataSet();
            return ds;
        }
        public DataTable GetPurchaseChallanEditData()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "PurchaseChallanEditDetails");
            proc.AddIntegerPara("@PurchaseChallan_Id", Convert.ToInt32(Session["PurchaseChallan_Id"]));
            proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
            proc.AddVarcharPara("@branchid", 500, Convert.ToString(Session["userbranchID"]));
            proc.AddVarcharPara("@campany_Id", 500, Convert.ToString(Session["LastCompany"]));
            dt = proc.GetTable();
            return dt;
        }
        public DataTable GetPurchaseChallanCalculater()
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "CalculateGRNAmount");
            proc.AddIntegerPara("@PurchaseChallan_Id", Convert.ToInt32(Session["PurchaseChallan_Id"]));
            dt = proc.GetTable();
            return dt;
        }
        public DataSet GetProductData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "ProductDetails");
            proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
            proc.AddVarcharPara("@branchid", 500, Convert.ToString(Session["userbranchID"]));
            proc.AddVarcharPara("@campany_Id", 500, Convert.ToString(Session["LastCompany"]));
            ds = proc.GetDataSet();
            return ds;
        }
        public IEnumerable GetProduct()
        {
            List<Product> ProductList = new List<Product>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = GetProductData().Tables[0];
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                Product Products = new Product();
                Products.ProductID = Convert.ToString(DT.Rows[i]["Products_ID"]);
                Products.ProductName = Convert.ToString(DT.Rows[i]["Products_Name"]);
                ProductList.Add(Products);
            }

            return ProductList;
        }
        public void GetAllDropDownDetailForPurchaseChallan()
        {
            DataSet dst = new DataSet();
            dst = objPurchaseChallanBL.GetAllDropDownDetailForPurchaseChallan();


            if (dst.Tables[3] != null && dst.Tables[3].Rows.Count > 0)
            {
                ddl_AmountAre.TextField = "taxGrp_Description";
                ddl_AmountAre.ValueField = "taxGrp_Id";
                ddl_AmountAre.DataSource = dst.Tables[3];
                ddl_AmountAre.DataBind();

                //ListEditItem li = new ListEditItem();
                //li.Text = "Import";
                //li.Value = "4";
                //ddl_AmountAre.Items.Insert(3, li);
            }

            //if (Session["userbranchID"] != null)
            //{
            //    if (ddl_Branch.Items.Count > 0)
            //    {
            //        int branchindex = 0;
            //        int cnt = 0;
            //        foreach (ListItem li in ddl_Branch.Items)
            //        {
            //            if (li.Value == Convert.ToString(Session["userbranchID"]))
            //            {
            //                cnt = 1;
            //                break;
            //            }
            //            else
            //            {
            //                branchindex += 1;
            //            }
            //        }
            //        if (cnt == 1)
            //        {
            //            ddl_Branch.SelectedIndex = branchindex;
            //        }
            //        else
            //        {
            //            ddl_Branch.SelectedIndex = cnt;
            //        }
            //    }
            //}

            ddl_SalesAgent.Items.Insert(0, new ListItem("Select", "0"));


            //if (Session["ActiveCurrency"] != null)
            //{
            //    if (ddl_Currency.Items.Count > 0)
            //    {
            //        string[] ActCurrency = new string[] { };
            //        string currency = Convert.ToString(HttpContext.Current.Session["ActiveCurrency"]);
            //        ActCurrency = currency.Split('~');
            //        foreach (ListItem li in ddl_Currency.Items)
            //        {
            //            if (li.Value == Convert.ToString(ActCurrency[0]))
            //            {
            //                ddl_Currency.Items.Remove(li);
            //                break;
            //            }
            //        }
            //    }
            //    ddl_Currency.Items.Insert(0, new ListItem("Select", "0"));
            //    ddl_Currency.SelectedIndex = 0;
            //}
        }
        [WebMethod]
        public static string getSchemeType(string sel_scheme_id)
        {
            string strschematype = "", strschemalength = "", strschemavalue = "", strbranchID = "";
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.GetDataTable("tbl_master_Idschema", " schema_type,length,IsNull(Branch,0) as Branch", " Id = " + Convert.ToInt32(sel_scheme_id));

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                strschematype = Convert.ToString(DT.Rows[i]["schema_type"]);
                strschemalength = Convert.ToString(DT.Rows[i]["length"]);
                strbranchID = Convert.ToString(DT.Rows[i]["Branch"]);

                strschemavalue = strschematype + "~" + strschemalength + "~" + strbranchID;
            }
            return Convert.ToString(strschemavalue);
        }
        [WebMethod]
        public static string getIndentRequisitionDate(string IndentRequisitionNo)
        {
            BusinessLogicLayer.DBEngine oDbEngine1 = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            string[] RequisitionDate = oDbEngine1.GetFieldValue1("tbl_trans_Indent", "Indent_RequisitionDate", "Indent_Id = " + Convert.ToInt32(IndentRequisitionNo), 1);
            return Convert.ToString(RequisitionDate[0]);
        }
        [WebMethod]
        public static String GetRate(string basedCurrency, string Currency_ID, string Campany_ID)
        {
            //PurchaseChallanBL objPurchaseChallanBL = new PurchaseChallanBL();
            //DataTable dt = objPurchaseChallanBL.GetCurrentConvertedRate(Convert.ToInt16(basedCurrency), Convert.ToInt16(Currency_ID), Campany_ID);

            SlaesActivitiesBL objSlaesActivitiesBL = new SlaesActivitiesBL();
            DataTable dt = objSlaesActivitiesBL.GetCurrentConvertedRate(Convert.ToInt16(basedCurrency), Convert.ToInt16(Currency_ID), Campany_ID);

            string SalesRate = "";
            if (dt.Rows.Count > 0)
            {
                SalesRate = Convert.ToString(dt.Rows[0]["SalesRate"]);//Convert.ToString(dt.Rows[0]["PurchaseRate"]);
            }

            return SalesRate;
        }
        protected void cmbContactPerson_Callback(object sender, CallbackEventArgsBase e)
        {
            Session["PurchaseChallanAddressDtl"] = null;
            Session["PCBillingAddressLookup"] = null;
            Session["PCShippingAddressLookup"] = null;
            string WhichCall = e.Parameter.Split('~')[0];
            if (WhichCall == "BindContactPerson")
            {
                string InternalId = Convert.ToString(Convert.ToString(e.Parameter.Split('~')[1]));
                string vendorbranchid = Convert.ToString(ddl_Branch.SelectedValue);

                PopulateContactPersonOfCustomer(InternalId);

                DataSet vendst = new DataSet();
                PurchaseInvoiceBL objPurchaseInvoice = new PurchaseInvoiceBL();
                vendst = objPurchaseInvoice.GetCustomerDetails_InvoiceRelated(InternalId, vendorbranchid);

                if (vendst.Tables[2] != null && vendst.Tables[2].Rows.Count > 0)
                {
                    string strGSTN = Convert.ToString(vendst.Tables[2].Rows[0]["CNT_GSTIN"]);
                    if (strGSTN != "")
                    {
                        cmbContactPerson.JSProperties["cpGSTN"] = "Yes";

                    }
                    else
                    {
                        cmbContactPerson.JSProperties["cpGSTN"] = "No";
                    }
                }

                if (vendst.Tables[3] != null && vendst.Tables[3].Rows.Count > 0)
                {
                    string strCountry = Convert.ToString(vendst.Tables[3].Rows[0]["add_country"]);
                    if (strCountry != "")
                    {
                        cmbContactPerson.JSProperties["cpcountry"] = strCountry;

                    }
                    else
                    {
                        cmbContactPerson.JSProperties["cpcountry"] = "1";
                    }
                }
                else
                {
                    cmbContactPerson.JSProperties["cpcountry"] = "1";
                }
            }
        }
        protected void ddl_VatGstCst_Callback(object sender, CallbackEventArgsBase e)
        {
            string type = e.Parameter.Split('~')[0];
            PopulateGSTCSTVAT(type);
        }
        protected void PopulateGSTCSTVAT(string type)
        {
            DataTable dtGSTCSTVAT = new DataTable();

            if (type == "2")
            {
                dtGSTCSTVAT = objPurchaseChallanBL.PopulateGSTCSTVAT(dt_PLQuote.Date.ToString("yyyy-MM-dd"));

                #region Delete Igst,Cgst,Sgst respectively

                string CompInternalId = Convert.ToString(Session["LastCompany"]);
                string[] compGstin = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_gstin", "cmp_internalid='" + CompInternalId + "'", 1);

                string ShippingState = "";

                #region ##### Added By : Samrat Roy -- For BillingShippingUserControl ######
                string sstateCode = BillingShippingControl.GetShippingStateCode(Request.QueryString["key"]);
                ShippingState = sstateCode;
                if (ShippingState.Trim() != "")
                {
                    ShippingState = ShippingState.Substring(ShippingState.IndexOf("(State Code:")).Replace("(State Code:", "").Replace(")", "");
                }
                #region ##### Old Code -- BillingShipping ######
                //////if (chkBilling.Checked)
                //////{
                //////    if (CmbState.Value != null)
                //////    {
                //////        ShippingState = CmbState.Text;
                //////        ShippingState = ShippingState.Substring(ShippingState.IndexOf("(State Code:")).Replace("(State Code:", "").Replace(")", "");
                //////    }
                //////}
                //////else
                //////{
                //////    if (CmbState1.Value != null)
                //////    {
                //////        ShippingState = CmbState1.Text;
                //////        ShippingState = ShippingState.Substring(ShippingState.IndexOf("(State Code:")).Replace("(State Code:", "").Replace(")", "");
                //////    }
                //////}
                #endregion

                #endregion

                if (ShippingState.Trim() != "" && compGstin[0].Trim() != "")
                {

                    if (compGstin.Length > 0)
                    {
                        if (compGstin[0].Substring(0, 2) == ShippingState)
                        {
                            //Check if the state is in union territories then only UTGST will apply
                            //   Chandigarh     Andaman and Nicobar Islands    DADRA & NAGAR HAVELI    DAMAN & DIU    Lakshadweep              PONDICHERRY
                            if (ShippingState == "4" || ShippingState == "26" || ShippingState == "25" || ShippingState == "35" || ShippingState == "31" || ShippingState == "34")
                            {
                                foreach (DataRow dr in dtGSTCSTVAT.Rows)
                                {
                                    if (Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "I" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "C" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "S")
                                    {
                                        dr.Delete();
                                    }
                                }

                            }
                            else
                            {
                                foreach (DataRow dr in dtGSTCSTVAT.Rows)
                                {
                                    if (Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "I" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "U")
                                    {
                                        dr.Delete();
                                    }
                                }
                            }
                            dtGSTCSTVAT.AcceptChanges();
                        }
                        else
                        {
                            foreach (DataRow dr in dtGSTCSTVAT.Rows)
                            {
                                if (Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "C" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "S" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "U")
                                {
                                    dr.Delete();
                                }
                            }
                            dtGSTCSTVAT.AcceptChanges();

                        }

                    }
                }

                //If Company GSTIN is blank then Delete All CGST,UGST,IGST,CGST
                if (compGstin[0].Trim() == "")
                {
                    foreach (DataRow dr in dtGSTCSTVAT.Rows)
                    {
                        if (Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "C" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "S" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "U" || Convert.ToString(dr["TaxRates_GSTtype"]).Trim() == "I")
                        {
                            dr.Delete();
                        }
                    }
                    dtGSTCSTVAT.AcceptChanges();
                }


                #endregion


                if (dtGSTCSTVAT != null && dtGSTCSTVAT.Rows.Count > 0)
                {
                    ddl_VatGstCst.TextField = "Taxes_Name";
                    ddl_VatGstCst.ValueField = "Taxes_ID";
                    ddl_VatGstCst.DataSource = dtGSTCSTVAT;
                    ddl_VatGstCst.DataBind();
                    ddl_VatGstCst.SelectedIndex = 0;
                }
            }
            else
            {
                ddl_VatGstCst.DataSource = null;
                ddl_VatGstCst.DataBind();
            }
        }
        protected void PopulateContactPersonOfCustomer(string InternalId)
        {
            string ContactPerson = "";
            DataTable dtContactPerson = new DataTable();
            dtContactPerson = objPurchaseChallanBL.PopulateContactPersonOfCustomer(InternalId);
            if (dtContactPerson != null && dtContactPerson.Rows.Count > 0)
            {
                cmbContactPerson.TextField = "contactperson";
                cmbContactPerson.ValueField = "add_id";
                cmbContactPerson.DataSource = dtContactPerson;
                cmbContactPerson.DataBind();
                foreach (DataRow dr in dtContactPerson.Rows)
                {
                    if (Convert.ToString(dr["Isdefault"]) == "True")
                    {
                        ContactPerson = Convert.ToString(dr["add_id"]);
                        break;
                    }
                }
                cmbContactPerson.SelectedItem = cmbContactPerson.Items.FindByValue(ContactPerson);

            }



            //dtContactPerson = objSlaesActivitiesBL.PopulateContactPersonForCustomerOrLead(InternalId);
            //oGenericMethod = new BusinessLogicLayer.GenericMethod();

            //DataTable dtCmb = new DataTable();
            //dtCmb = oGenericMethod.GetDataTable("Select city_id,city_name From tbl_master_city Where state_id=" + stateID + " Order By city_name");//+ " Order By state "
            //AspxHelper oAspxHelper = new AspxHelper();
            //if (dtCmb.Rows.Count > 0)
            //{
            //    //CmbState.Enabled = true;
            //    // oAspxHelper.Bind_Combo(CmbCity, dtCmb, "city_name", "city_id", 0);
            //}
            //else
            //{
            //    //CmbCity.Enabled = false;
            //}
        }

        #endregion

        #region Page Classes

        public class PurchaseChallanList_Stock
        {
            public string SrlNo { get; set; }
            public string OrderDetails_Id { get; set; }
            public string gvColProduct { get; set; }
            public string gvColDiscription { get; set; }
            public string gvColQuantity { get; set; }
            public string gvColUOM { get; set; }
            public string Warehouse { get; set; }
            public string gvColStockQty { get; set; }
            public string gvColStockUOM { get; set; }
            public string gvColStockPurchasePrice { get; set; }
            public string gvColDiscount { get; set; }
            public string gvColAmount { get; set; }
            public string gvColTaxAmount { get; set; }
            public string gvColTotalAmountINR { get; set; }
            public string ProductName { get; set; }
            public string PoNumber { get; set; }
            public string TotalQty { get; set; }
            public string BalanceQty { get; set; }
            public string IsComponentProduct { get; set; }
            public string IsLinkedProduct { get; set; }
            public string ComponentID { get; set; }
        }
        public class SalesOrder
        {

            public string SrlNo { get; set; }
            public string OrderDetails_Id { get; set; }
            public string gvColProduct { get; set; }
            public string gvColDiscription { get; set; }
            public string gvColQuantity { get; set; }
            public string gvColUOM { get; set; }
            public string Warehouse { get; set; }
            public string gvColStockQty { get; set; }
            public string gvColStockUOM { get; set; }
            public string gvColStockPurchasePrice { get; set; }
            public string gvColDiscount { get; set; }
            public string gvColAmount { get; set; }
            public string gvColTaxAmount { get; set; }
            public string gvColTotalAmountINR { get; set; }
            public Int64 Quotation_No { get; set; }
            public string Quotation_Num { get; set; }
            public string Key_UniqueId { get; set; }
            public string Product_Shortname { get; set; }
            public string ProductName { get; set; }

            //public string PO_Num { get; set; }
            public string PoNumber { get; set; }
            public string TotalQty { get; set; }
            public string BalanceQty { get; set; }
            public string IsComponentProduct { get; set; }
            public string IsLinkedProduct { get; set; }
            public string ComponentID { get; set; }
        }
        public class TaxSetailsJson
        {
            public string SchemeName { get; set; }
            public int vissibleIndex { get; set; }
            public string applicableOn { get; set; }
            public string applicableBy { get; set; }
        }

        public class TaxDetails
        {
            public int Taxes_ID { get; set; }
            public string Taxes_Name { get; set; }

            public double Amount { get; set; }
            public string TaxField { get; set; }

            public string taxCodeName { get; set; }

            public decimal calCulatedOn { get; set; }

        }
        class taxCode
        {
            public string Taxes_ID { get; set; }
            public string Taxes_Name { get; set; }
        }
        public class Product
        {
            public string ProductID { get; set; }
            public string ProductName { get; set; }
        }
        public class Taxes
        {
            public string TaxID { get; set; }
            public string TaxName { get; set; }
            public string Percentage { get; set; }
            public string Amount { get; set; }
            public decimal calCulatedOn { get; set; }
        }

        #endregion

        #region  Batch Grid
        protected void grid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "Display")
            {
                string IsDeleteFrom = Convert.ToString(hdfIsDelete.Value);
                if (IsDeleteFrom == "D" || IsDeleteFrom == "C")
                {
                    DataTable POdt = (DataTable)Session["PCProductOrderDetails"];
                    grid.DataSource = GetPurchaseOrderBatch(POdt);
                    grid.DataBind();

                    if (e.Parameters.Split('~').Length > 1)
                    {
                        if (e.Parameters.Split('~')[1] == "fromComponent")
                        {
                            grid.JSProperties["cpComponent"] = "true";
                        }
                    }
                }
            }
            else if (strSplitCommand == "BindGridOnQuotation")
            {
                hiddenOnGridBind.Value = "OnGridBindAddRow";
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                String QuoComponent1 = "";
                string Product_id1 = "";

                //for (int i = 0; i < grid_Products.GetSelectedFieldValues("ComponentID").Count; i++)
                //{
                //    QuoComponent1 += "," + Convert.ToString(grid_Products.GetSelectedFieldValues("ComponentID")[i]);
                //    Product_id1 += "," + Convert.ToString(grid_Products.GetSelectedFieldValues("ProductID")[i]);
                //}

                for (int i = 0; i < grid_Products.GetSelectedFieldValues("ComponentDetailsID").Count; i++)
                {
                    QuoComponent1 += "," + Convert.ToString(grid_Products.GetSelectedFieldValues("ComponentDetailsID")[i]);
                    Product_id1 += "," + Convert.ToString(grid_Products.GetSelectedFieldValues("ProductID")[i]);
                }

                QuoComponent1 = QuoComponent1.TrimStart(',');
                Product_id1 = Product_id1.TrimStart(',');
                string Quote_Nos = Convert.ToString(e.Parameters.Split('~')[1]);
                string companyId = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string fin_year = Convert.ToString(HttpContext.Current.Session["LastFinYear"]);

                if (Quote_Nos != "$")
                {
                    //DataTable dt_QuotationDetails = new DataTable();
                    //string IdKey = Convert.ToString(Request.QueryString["key"]);
                    //if (!string.IsNullOrEmpty(IdKey))
                    //{
                    //    if (IdKey != "ADD")
                    //    {
                    //        dt_QuotationDetails = objPurchaseChallanBL.GetIndentDetailsForPOGridBind(QuoComponent1, IdKey, Product_id1, companyId, fin_year);
                    //    }
                    //    else
                    //    {
                    //        dt_QuotationDetails = objPurchaseChallanBL.GetIndentDetailsForPOGridBind(QuoComponent1, "", Product_id1, companyId, fin_year);
                    //    }

                    //}
                    //else
                    //{
                    //    dt_QuotationDetails = objPurchaseChallanBL.GetIndentDetailsForPOGridBind(QuoComponent1, "", Product_id1, companyId, fin_year);
                    //}

                    string strInvoiceID = Convert.ToString(Session["PurchaseChallan_Id"]);
                    DataTable dt_QuotationDetails = objSalesInvoiceBL.GetSelectedComponentProductList("GetSeletedPurchaseOrderProducts", QuoComponent1, strInvoiceID);

                    Session["OrderDetails"] = null;
                    grid.DataSource = GetSalesOrderInfo(dt_QuotationDetails, strInvoiceID);
                    grid.DataBind();

                    DataTable PurchaseOrderdt = (DataTable)Session["PCProductOrderDetails"];
                    String _Amount = CalculateOrderAmount(PurchaseOrderdt);

                    grid.JSProperties["cpOrderRunningBalance"] = _Amount;
                    grid.JSProperties["cpPurchaseorderbindnewrow"] = "yes";
                }
                else
                {
                    grid.DataSource = null;
                    grid.DataBind();
                }

            }
        }
        public IEnumerable GetSalesOrderInfo(DataTable SalesOrderdt1, string Order_Id)
        {
            List<SalesOrder> OrderList = new List<SalesOrder>();
            DataColumnCollection dtC = SalesOrderdt1.Columns;
            CreateDataTaxTable();

            // Fetch All Warehouse Data , Product Tax Details

            string commaSeparatedString = String.Join(",", SalesOrderdt1.AsEnumerable().Select(x => x.Field<Int64>("OrderDetails_Id").ToString()).ToArray());
            DataTable tempWarehouse = GetQuotationWarehouse(commaSeparatedString);
            DataTable tempProductTax = GetQuotationProductTaxData(commaSeparatedString);

            //GetOrderWarehouseData
            // End

            /////////////////////////////////////////////////////// Create Session Datatable

            DataTable PurchaseOrderdt = new DataTable();
            PurchaseOrderdt.Columns.Add("SrlNo", typeof(string));
            PurchaseOrderdt.Columns.Add("OrderDetails_Id", typeof(string));
            PurchaseOrderdt.Columns.Add("ProductID", typeof(string));
            PurchaseOrderdt.Columns.Add("Description", typeof(string));
            PurchaseOrderdt.Columns.Add("Quantity", typeof(string));
            PurchaseOrderdt.Columns.Add("UOM", typeof(string));
            PurchaseOrderdt.Columns.Add("Warehouse", typeof(string));
            PurchaseOrderdt.Columns.Add("StockQuantity", typeof(string));
            PurchaseOrderdt.Columns.Add("StockUOM", typeof(string));
            PurchaseOrderdt.Columns.Add("PurchasePrice", typeof(string));
            PurchaseOrderdt.Columns.Add("Discount", typeof(string));
            PurchaseOrderdt.Columns.Add("Amount", typeof(string));
            PurchaseOrderdt.Columns.Add("TaxAmount", typeof(string));
            PurchaseOrderdt.Columns.Add("TotalAmount", typeof(string));
            PurchaseOrderdt.Columns.Add("Status", typeof(string));
            PurchaseOrderdt.Columns.Add("ProductName", typeof(string));
            PurchaseOrderdt.Columns.Add("PO_Number", typeof(string));
            PurchaseOrderdt.Columns.Add("TotalQty", typeof(string));
            PurchaseOrderdt.Columns.Add("BalanceQty", typeof(string));
            PurchaseOrderdt.Columns.Add("IsComponentProduct", typeof(string));
            PurchaseOrderdt.Columns.Add("IsLinkedProduct", typeof(string));
            PurchaseOrderdt.Columns.Add("ComponentID", typeof(string));

            ///////////////////////////////////////////////////////

            for (int i = 0; i < SalesOrderdt1.Rows.Count; i++)
            {
                SalesOrder Orders = new SalesOrder();

                Orders.SrlNo = Convert.ToString(i + 1);
                Orders.OrderDetails_Id = Convert.ToString(i + 1);
                Orders.gvColProduct = Convert.ToString(SalesOrderdt1.Rows[i]["ProductID"]);
                Orders.gvColDiscription = Convert.ToString(SalesOrderdt1.Rows[i]["QuoteDetails_ProductDescription"]);
                Orders.gvColQuantity = Convert.ToString(SalesOrderdt1.Rows[i]["Quantity"]);
                Orders.gvColUOM = Convert.ToString(SalesOrderdt1.Rows[i]["StockUOM"]);
                Orders.Warehouse = "";
                Orders.gvColStockQty = Convert.ToString(SalesOrderdt1.Rows[i]["StockQuantity"]);
                Orders.gvColStockUOM = Convert.ToString(SalesOrderdt1.Rows[i]["StockUOM"]);
                //Orders.gvColStockPurchasePrice = Convert.ToString(SalesOrderdt1.Rows[i]["SalePrice"]);
                Orders.gvColStockPurchasePrice = Convert.ToString(SalesOrderdt1.Rows[i]["PurchasePrice"]);
                Orders.gvColDiscount = Convert.ToString(SalesOrderdt1.Rows[i]["Discount"]);
                Orders.gvColAmount = Convert.ToString(SalesOrderdt1.Rows[i]["Amount"]);
                Orders.gvColTaxAmount = Convert.ToString(SalesOrderdt1.Rows[i]["TaxAmount"]);
                Orders.gvColTotalAmountINR = Convert.ToString(SalesOrderdt1.Rows[i]["TotalAmount"]);
                Orders.ProductName = Convert.ToString(SalesOrderdt1.Rows[i]["Products_Name"]);
                if (!string.IsNullOrEmpty(Convert.ToString(SalesOrderdt1.Rows[i]["Quotation_No"])))//Added on 15-02-2017
                { Orders.Quotation_No = Convert.ToInt64(SalesOrderdt1.Rows[i]["Quotation_No"]); }
                else
                { Orders.Quotation_No = 0; }
                if (dtC.Contains("Quotation"))
                {
                    Orders.Quotation_Num = Convert.ToString(SalesOrderdt1.Rows[i]["Quotation"]);//subhabrata on 21-02-2017
                    Orders.PoNumber = Convert.ToString(SalesOrderdt1.Rows[i]["Quotation"]);
                }
                Orders.TotalQty = Convert.ToString(SalesOrderdt1.Rows[i]["TotalQty"]);
                Orders.BalanceQty = Convert.ToString(SalesOrderdt1.Rows[i]["BalanceQty"]);
                Orders.IsComponentProduct = Convert.ToString(SalesOrderdt1.Rows[i]["IsComponentProduct"]);
                Orders.IsLinkedProduct = Convert.ToString(SalesOrderdt1.Rows[i]["IsLinkedProduct"]);
                Orders.ComponentID = Convert.ToString(SalesOrderdt1.Rows[i]["ComponentID"]);

                // Mapping With Warehouse with Product Srl No

                string strQuoteDetails_Id = Convert.ToString(SalesOrderdt1.Rows[i]["OrderDetails_Id"]).Trim();

                if (ImplementTaxOnTagging(Convert.ToInt32(strQuoteDetails_Id), Convert.ToInt32(Orders.SrlNo)))
                {
                    Orders.gvColTaxAmount = "0.00";
                }


                OrderList.Add(Orders);

                PurchaseOrderdt.Rows.Add(Convert.ToString(i + 1), Convert.ToString(i + 1), Convert.ToString(SalesOrderdt1.Rows[i]["ProductID"]), Convert.ToString(SalesOrderdt1.Rows[i]["QuoteDetails_ProductDescription"]),
                Convert.ToString(SalesOrderdt1.Rows[i]["Quantity"]), Convert.ToString(SalesOrderdt1.Rows[i]["StockUOM"]), "", Convert.ToString(SalesOrderdt1.Rows[i]["StockQuantity"]),
                Convert.ToString(SalesOrderdt1.Rows[i]["StockUOM"]), Convert.ToString(SalesOrderdt1.Rows[i]["PurchasePrice"]), Convert.ToString(SalesOrderdt1.Rows[i]["Discount"]),
                Convert.ToString(SalesOrderdt1.Rows[i]["Amount"]), Convert.ToString(SalesOrderdt1.Rows[i]["TaxAmount"]), Convert.ToString(SalesOrderdt1.Rows[i]["TotalAmount"]), "", Convert.ToString(SalesOrderdt1.Rows[i]["Products_Name"]),
                Convert.ToString(SalesOrderdt1.Rows[i]["Quotation"]), Convert.ToString(SalesOrderdt1.Rows[i]["TotalQty"]), Convert.ToString(SalesOrderdt1.Rows[i]["BalanceQty"]),
                Convert.ToString(SalesOrderdt1.Rows[i]["IsComponentProduct"]), Convert.ToString(SalesOrderdt1.Rows[i]["IsLinkedProduct"]), Convert.ToString(SalesOrderdt1.Rows[i]["ComponentID"]));

                if (tempProductTax != null && tempProductTax.Rows.Count > 0)
                {
                    var taxrows = tempProductTax.Select("ProductTax_ProductId ='" + strQuoteDetails_Id + "'");
                    foreach (var row in taxrows)
                    {
                        row["SlNo"] = Convert.ToString(i + 1);
                    }
                    tempProductTax.AcceptChanges();
                }

                if (tempWarehouse != null && tempWarehouse.Rows.Count > 0)
                {
                    var taxrows = tempWarehouse.Select("OrderDetails_Id ='" + strQuoteDetails_Id + "'");
                    foreach (var row in taxrows)
                    {
                        row["Product_SrlNo"] = Convert.ToString(i + 1);
                    }
                    tempWarehouse.AcceptChanges();
                }
            }

            if (tempProductTax != null)
            {
                tempProductTax.Columns.Remove("ProductTax_ProductId");
                Session["PCFinalTaxRecord"] = tempProductTax;
            }
            else { Session["PCFinalTaxRecord"] = null; }


            if (tempWarehouse != null)
            {
                tempWarehouse.Columns.Remove("OrderDetails_Id");

                DataTable dt = GetOrderWarehouseData(tempWarehouse);
                Session["PC_WarehouseData"] = dt;
            }
            else { Session["PC_WarehouseData"] = null; }

            Session["PCProductOrderDetails"] = PurchaseOrderdt;
            return OrderList;
        }
        public string CalculateOrderAmount(DataTable PurchaseOrderdt)
        {
            decimal SUM_Amount = 0, SUM_TotalAmount = 0, SUM_TaxAmount = 0, SUM_ChargesAmount = 0, SUM_ProductQuantity = 0;

            if (PurchaseOrderdt != null && PurchaseOrderdt.Rows.Count > 0)
            {
                foreach (DataRow rrow in PurchaseOrderdt.Rows)
                {
                    string Quantity = (Convert.ToString(rrow["Quantity"]) != "") ? Convert.ToString(rrow["Quantity"]) : "0";
                    string Amount = (Convert.ToString(rrow["Amount"]) != "") ? Convert.ToString(rrow["Amount"]) : "0";
                    string TotalAmount = (Convert.ToString(rrow["TotalAmount"]) != "") ? Convert.ToString(rrow["TotalAmount"]) : "0";

                    SUM_ProductQuantity = SUM_ProductQuantity + Convert.ToDecimal(Quantity);
                    SUM_Amount = SUM_Amount + Convert.ToDecimal(Amount);
                    SUM_TotalAmount = SUM_TotalAmount + Convert.ToDecimal(TotalAmount);
                }
            }

            SUM_TaxAmount = SUM_TotalAmount - SUM_Amount;

            return Convert.ToString(SUM_ChargesAmount + "~" + SUM_Amount + "~" + SUM_ChargesAmount + "~" + SUM_TaxAmount + "~" + SUM_TotalAmount + "~" + SUM_TotalAmount + "~" + SUM_ProductQuantity);
        }
        public DataTable GetQuotationProductTaxData(string strQuotationList)
        {
            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
                proc.AddVarcharPara("@Action", 500, "PurchaseOrderProductTax");
                proc.AddVarcharPara("@OrderList", 3000, strQuotationList);
                dt = proc.GetTable();

                return dt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable GetQuotationWarehouse(string strQuotationList)
        {
            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
                proc.AddVarcharPara("@Action", 500, "PurchaseOrderProductStock");
                proc.AddVarcharPara("@OrderList", 3000, strQuotationList);
                dt = proc.GetTable();

                return dt;
            }
            catch
            {
                return null;
            }
        }
        public bool ImplementTaxOnTagging(int id, int slno)
        {
            Boolean inUse = false;
            DataTable taxTable = (DataTable)Session["PCFinalTaxRecord"];
            ProcedureExecute proc = new ProcedureExecute("prc_taxReturnTable");
            proc.AddVarcharPara("@Module", 20, "PurchaseChallan_Stock");
            proc.AddIntegerPara("@id", id);
            proc.AddIntegerPara("@slno", slno);
            proc.AddBooleanPara("@inUse", true, QueryParameterDirection.Output);

            DataTable returnedTable = proc.GetTable();
            inUse = Convert.ToBoolean(proc.GetParaValue("@inUse"));

            if (returnedTable != null)
                taxTable.Merge(returnedTable);


            Session["PCFinalTaxRecord"] = taxTable;

            return inUse;
        }
        protected void Grid_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void Grid_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void Grid_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void grid_DataBinding(object sender, EventArgs e)
        {
            //grid.DataSource = GetVoucher();
            if (Session["PCProductOrderDetails"] != null)
            {
                DataTable POdt = (DataTable)Session["PCProductOrderDetails"];
                DataView dvData = new DataView(POdt);
                dvData.RowFilter = "Status <> 'D'";

                grid.DataSource = GetPurchaseOrderBatch(dvData.ToTable());
            }
        }
        protected void grid_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "gvColDiscription")
            {
                e.Editor.Enabled = true;
            }
            else if (e.Column.FieldName == "gvColUOM")
            {
                e.Editor.Enabled = true;
            }
            else if (e.Column.FieldName == "gvColStockUOM")
            {
                e.Editor.Enabled = true;
            }
            else if (e.Column.FieldName == "gvColTaxAmount")
            {
                e.Editor.Enabled = true;
            }

            else if (e.Column.FieldName == "gvColTotalAmountINR")
            {
                e.Editor.Enabled = true;
            }
            else if (e.Column.FieldName == "SrlNo")
            {
                e.Editor.Enabled = true;
            }
            else if (e.Column.FieldName == "ProductName")
            {
                e.Editor.Enabled = true;
            }
            else if (e.Column.FieldName == "PoNumber")
            {
                e.Editor.Enabled = true;
            }
            else
            {
                e.Editor.ReadOnly = false;
            }

        }
        protected void grid_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            bool Iswarenotthere = false;
            string message = string.Empty;
            string validate = "";

            grid.JSProperties["cpSaveSuccessOrFail"] = null;
            grid.JSProperties["cpPurchaseOrderNo"] = null;
            DataTable PurchaseOrderdt = new DataTable();
            string IsDeleteFrom = Convert.ToString(hdfIsDelete.Value);
            string warehousemsg = string.Empty;

            if (Session["PCProductOrderDetails"] != null)
            {
                DataTable Productlist = (DataTable)Session["PCProductOrderDetails"];
                if (Productlist.Rows.Count > 0)
                { PurchaseOrderdt = Productlist.DefaultView.ToTable(false, "SrlNo", "OrderDetails_Id", "ProductID", "Description", "Quantity", "UOM", "Warehouse", "StockQuantity", "StockUOM", "PurchasePrice", "Discount", "Amount", "TaxAmount", "TotalAmount", "Status", "ProductName", "PO_Number", "TotalQty", "BalanceQty", "IsComponentProduct", "IsLinkedProduct", "ComponentID"); }
                else
                {
                    PurchaseOrderdt.Columns.Add("SrlNo", typeof(string));
                    PurchaseOrderdt.Columns.Add("OrderDetails_Id", typeof(string));
                    PurchaseOrderdt.Columns.Add("ProductID", typeof(string));
                    PurchaseOrderdt.Columns.Add("Description", typeof(string));
                    PurchaseOrderdt.Columns.Add("Quantity", typeof(string));
                    PurchaseOrderdt.Columns.Add("UOM", typeof(string));
                    PurchaseOrderdt.Columns.Add("Warehouse", typeof(string));
                    PurchaseOrderdt.Columns.Add("StockQuantity", typeof(string));
                    PurchaseOrderdt.Columns.Add("StockUOM", typeof(string));
                    PurchaseOrderdt.Columns.Add("PurchasePrice", typeof(string));
                    PurchaseOrderdt.Columns.Add("Discount", typeof(string));
                    PurchaseOrderdt.Columns.Add("Amount", typeof(string));
                    PurchaseOrderdt.Columns.Add("TaxAmount", typeof(string));
                    PurchaseOrderdt.Columns.Add("TotalAmount", typeof(string));
                    PurchaseOrderdt.Columns.Add("Status", typeof(string));
                    PurchaseOrderdt.Columns.Add("ProductName", typeof(string));
                    PurchaseOrderdt.Columns.Add("PO_Number", typeof(string));
                    PurchaseOrderdt.Columns.Add("TotalQty", typeof(string));
                    PurchaseOrderdt.Columns.Add("BalanceQty", typeof(string));
                    PurchaseOrderdt.Columns.Add("IsComponentProduct", typeof(string));
                    PurchaseOrderdt.Columns.Add("IsLinkedProduct", typeof(string));
                    PurchaseOrderdt.Columns.Add("ComponentID", typeof(string));
                }
            }
            else
            {
                PurchaseOrderdt.Columns.Add("SrlNo", typeof(string));
                PurchaseOrderdt.Columns.Add("OrderDetails_Id", typeof(string));
                PurchaseOrderdt.Columns.Add("ProductID", typeof(string));
                PurchaseOrderdt.Columns.Add("Description", typeof(string));
                PurchaseOrderdt.Columns.Add("Quantity", typeof(string));
                PurchaseOrderdt.Columns.Add("UOM", typeof(string));
                PurchaseOrderdt.Columns.Add("Warehouse", typeof(string));
                PurchaseOrderdt.Columns.Add("StockQuantity", typeof(string));
                PurchaseOrderdt.Columns.Add("StockUOM", typeof(string));
                PurchaseOrderdt.Columns.Add("PurchasePrice", typeof(string));
                PurchaseOrderdt.Columns.Add("Discount", typeof(string));
                PurchaseOrderdt.Columns.Add("Amount", typeof(string));
                PurchaseOrderdt.Columns.Add("TaxAmount", typeof(string));
                PurchaseOrderdt.Columns.Add("TotalAmount", typeof(string));
                PurchaseOrderdt.Columns.Add("Status", typeof(string));
                PurchaseOrderdt.Columns.Add("ProductName", typeof(string));
                PurchaseOrderdt.Columns.Add("PO_Number", typeof(string));
                PurchaseOrderdt.Columns.Add("TotalQty", typeof(string));
                PurchaseOrderdt.Columns.Add("BalanceQty", typeof(string));
                PurchaseOrderdt.Columns.Add("IsComponentProduct", typeof(string));
                PurchaseOrderdt.Columns.Add("IsLinkedProduct", typeof(string));
                PurchaseOrderdt.Columns.Add("ComponentID", typeof(string));
            }

            foreach (var args in e.InsertValues)
            {
                string ProductDetails = Convert.ToString(args.NewValues["gvColProduct"]);

                if (ProductDetails != "" && ProductDetails != "0")
                {
                    string SrlNo = Convert.ToString(args.NewValues["SrlNo"]);
                    string[] ProductDetailsList = ProductDetails.Split(new string[] { "||@||" }, StringSplitOptions.None);
                    string ProductID = ProductDetailsList[0];
                    string Productwarehouse = ProductDetailsList[16];

                    string Description = ProductDetailsList[1];
                    string ProductName = Convert.ToString(args.NewValues["ProductName"]);
                    string Quantity = Convert.ToString(args.NewValues["gvColQuantity"]);
                    string UOM = Convert.ToString(ProductDetailsList[4]);
                    // string UOM = Convert.ToString(args.NewValues["gvColUOM"]);
                    string Warehouse = Convert.ToString(args.NewValues["Warehouse"]);
                    //string StockQuantity = Convert.ToString(args.NewValues["gvColStockQty"]);
                    string StockQuantity = "0";
                    //string StockUOM = Convert.ToString(args.NewValues["gvColStockUOM"]);
                    string StockUOM = Convert.ToString(ProductDetailsList[5]);
                    string PurchasePrice = Convert.ToString(args.NewValues["gvColStockPurchasePrice"]);
                    // string PurchasePrice = Convert.ToString(ProductDetailsList[6]);
                    string Discount = Convert.ToString(args.NewValues["gvColDiscount"]);
                    string Amount = (Convert.ToString(args.NewValues["gvColAmount"]) != "") ? Convert.ToString(args.NewValues["gvColAmount"]) : "0";
                    string TaxAmount = (Convert.ToString(args.NewValues["gvColTaxAmount"]) != "") ? Convert.ToString(args.NewValues["gvColTaxAmount"]) : "0";
                    string TotalAmount = (Convert.ToString(args.NewValues["gvColTotalAmountINR"]) != "") ? Convert.ToString(args.NewValues["gvColTotalAmountINR"]) : "0";
                    string PoNumber = (Convert.ToString(args.NewValues["PoNumber"]) != "") ? Convert.ToString(args.NewValues["PoNumber"]) : "0";

                    string TotalQty = (Convert.ToString(args.NewValues["TotalQty"]) != "") ? Convert.ToString(args.NewValues["TotalQty"]) : "0";
                    string BalanceQty = (Convert.ToString(args.NewValues["BalanceQty"]) != "") ? Convert.ToString(args.NewValues["BalanceQty"]) : "0";
                    string IsComponentProduct = (Convert.ToString(args.NewValues["IsComponentProduct"]) != "") ? Convert.ToString(args.NewValues["IsComponentProduct"]) : "N";
                    string IsLinkedProduct = (Convert.ToString(args.NewValues["IsLinkedProduct"]) != "") ? Convert.ToString(args.NewValues["IsLinkedProduct"]) : "N";
                    string ComponentID = (Convert.ToString(args.NewValues["ComponentID"]) != "") ? Convert.ToString(args.NewValues["ComponentID"]) : "0";

                    PurchaseOrderdt.Rows.Add(SrlNo, "0", ProductDetails, Description, Quantity, UOM, Warehouse, StockQuantity, StockUOM, PurchasePrice, Discount,
                        Amount, TaxAmount, TotalAmount, "I", ProductName, PoNumber, TotalQty, BalanceQty, "", IsLinkedProduct, ComponentID);

                    if (IsComponentProduct == "Y")
                    {
                        DataTable ComponentTable = objSalesInvoiceBL.GetLinkedProductList("LinkedProduct", ProductID);
                        foreach (DataRow drr in ComponentTable.Rows)
                        {
                            string sProductsID = Convert.ToString(drr["sProductsID"]);
                            string Products_Description = Convert.ToString(drr["Products_Description"]);
                            string Sales_UOM_Name = Convert.ToString(drr["Pur_UOM_Name"]);
                            string Conversion_Multiplier = Convert.ToString(drr["Conversion_Multiplier"]);
                            string Stk_UOM_Name = Convert.ToString(drr["Stk_UOM_Name"]);
                            string Product_SalePrice = Convert.ToString(drr["Product_PurPrice"]);
                            string Products_Name = Convert.ToString(drr["Products_Name"]);
                            string StkQty = Convert.ToString(Convert.ToDecimal(Quantity) * Convert.ToDecimal(Conversion_Multiplier));

                            PurchaseOrderdt.Rows.Add(Convert.ToString(Convert.ToInt32(SrlNo) + 1), "0", sProductsID, Products_Description, Quantity, Sales_UOM_Name, "", StkQty, Stk_UOM_Name, Product_SalePrice, "0.0",
                                "0.0", "0.0", "0.0", "I", Products_Name, PoNumber, "0.0", "0.0", "", "Y", ComponentID);
                        }
                    }
                }
            }
            foreach (var args in e.UpdateValues)
            {
                string SrlNo = Convert.ToString(args.NewValues["SrlNo"]);
                string OrderDetails_Id = Convert.ToString(args.Keys["OrderDetails_Id"]);
                string ProductDetails = Convert.ToString(args.NewValues["gvColProduct"]);

                bool isDeleted = false;
                foreach (var arg in e.DeleteValues)
                {
                    string DeleteID = Convert.ToString(arg.Keys["OrderDetails_Id"]);
                    if (DeleteID == OrderDetails_Id)
                    {
                        isDeleted = true;
                        break;
                    }
                }

                if (isDeleted == false)
                {
                    if (ProductDetails != "" && ProductDetails != "0")
                    {
                        string[] ProductDetailsList = ProductDetails.Split(new string[] { "||@||" }, StringSplitOptions.None);
                        string ProductID = Convert.ToString(ProductDetailsList[0]);

                        string Description = ProductDetailsList[1];
                        string Quantity = Convert.ToString(args.NewValues["gvColQuantity"]);
                        string ProductName = Convert.ToString(args.NewValues["ProductName"]);
                        string UOM = Convert.ToString(ProductDetailsList[4]);
                        // string UOM = Convert.ToString(args.NewValues["gvColUOM"]);
                        string Warehouse = Convert.ToString(args.NewValues["Warehouse"]);
                        //string StockQuantity = Convert.ToString(args.NewValues["gvColStockQty"]);
                        string StockQuantity = "0";
                        //string StockUOM = Convert.ToString(args.NewValues["gvColStockUOM"]);
                        string StockUOM = Convert.ToString(ProductDetailsList[5]);
                        string PurchasePrice = Convert.ToString(args.NewValues["gvColStockPurchasePrice"]);
                        // string PurchasePrice = Convert.ToString(ProductDetailsList[6]);
                        string Discount = Convert.ToString(args.NewValues["gvColDiscount"]);
                        string Amount = (Convert.ToString(args.NewValues["gvColAmount"]) != "") ? Convert.ToString(args.NewValues["gvColAmount"]) : "0";
                        string TaxAmount = (Convert.ToString(args.NewValues["gvColTaxAmount"]) != "") ? Convert.ToString(args.NewValues["gvColTaxAmount"]) : "0";
                        string TotalAmount = (Convert.ToString(args.NewValues["gvColTotalAmountINR"]) != "") ? Convert.ToString(args.NewValues["gvColTotalAmountINR"]) : "0";
                        string PoNumber = (Convert.ToString(args.NewValues["PoNumber"]) != "") ? Convert.ToString(args.NewValues["PoNumber"]) : "0";

                        string TotalQty = (Convert.ToString(args.NewValues["TotalQty"]) != "") ? Convert.ToString(args.NewValues["TotalQty"]) : "0";
                        string BalanceQty = (Convert.ToString(args.NewValues["BalanceQty"]) != "") ? Convert.ToString(args.NewValues["BalanceQty"]) : "0";
                        string IsComponentProduct = (Convert.ToString(args.NewValues["IsComponentProduct"]) != "") ? Convert.ToString(args.NewValues["IsComponentProduct"]) : "N";
                        string IsLinkedProduct = (Convert.ToString(args.NewValues["IsLinkedProduct"]) != "") ? Convert.ToString(args.NewValues["IsLinkedProduct"]) : "N";
                        string ComponentID = (Convert.ToString(args.NewValues["ComponentID"]) != "") ? Convert.ToString(args.NewValues["ComponentID"]) : "0";

                        string Productwarehouse = ProductDetailsList[16];

                        bool Isexists = false;
                        foreach (DataRow drr in PurchaseOrderdt.Rows)
                        {
                            string OldOrderDetailsId = Convert.ToString(drr["OrderDetails_Id"]);

                            if (OldOrderDetailsId == OrderDetails_Id)
                            {
                                Isexists = true;

                                drr["ProductID"] = ProductDetails;
                                drr["Description"] = Description;
                                drr["Quantity"] = Quantity;
                                drr["UOM"] = UOM;
                                drr["Warehouse"] = Warehouse;
                                drr["StockQuantity"] = StockQuantity;
                                drr["StockUOM"] = StockUOM;
                                drr["PurchasePrice"] = PurchasePrice;
                                drr["Discount"] = Discount;
                                drr["Amount"] = Amount;
                                drr["TaxAmount"] = TaxAmount;
                                drr["TotalAmount"] = TotalAmount;
                                drr["Status"] = "U";
                                drr["TotalQty"] = TotalQty;
                                drr["BalanceQty"] = BalanceQty;
                                drr["IsComponentProduct"] = IsComponentProduct;
                                drr["IsLinkedProduct"] = IsLinkedProduct;
                                drr["ComponentID"] = ComponentID;

                                break;
                            }
                        }

                        if (Isexists == false)
                        {
                            PurchaseOrderdt.Rows.Add(SrlNo, OrderDetails_Id, ProductDetails, Description, Quantity, UOM, Warehouse, StockQuantity, StockUOM,
                                PurchasePrice, Discount, Amount, TaxAmount, TotalAmount, "U", ProductName, PoNumber, TotalQty, BalanceQty, "", IsLinkedProduct, ComponentID);
                        }

                        if (IsComponentProduct == "Y")
                        {
                            DataTable ComponentTable = objSalesInvoiceBL.GetLinkedProductList("LinkedProduct", ProductID);
                            foreach (DataRow drr in ComponentTable.Rows)
                            {
                                string sProductsID = Convert.ToString(drr["sProductsID"]);
                                string Products_Description = Convert.ToString(drr["Products_Description"]);
                                string Sales_UOM_Name = Convert.ToString(drr["Pur_UOM_Code"]);
                                string Conversion_Multiplier = Convert.ToString(drr["Conversion_Multiplier"]);
                                string Stk_UOM_Name = Convert.ToString(drr["Stk_UOM_Name"]);
                                string Product_SalePrice = Convert.ToString(drr["Product_PurPrice"]);
                                string Products_Name = Convert.ToString(drr["Products_Name"]);
                                string StkQty = Convert.ToString(Convert.ToDecimal(Quantity) * Convert.ToDecimal(Conversion_Multiplier));

                                PurchaseOrderdt.Rows.Add(Convert.ToString(Convert.ToInt32(SrlNo) + 1), "0", sProductsID, Products_Description, Quantity, Sales_UOM_Name, "", StkQty, Stk_UOM_Name, Product_SalePrice, "0.0",
                               "0.0", "0.0", "0.0", "I", Products_Name, PoNumber, "0.0", "0.0", "", "Y", ComponentID);
                            }
                        }
                    }
                }
            }

            foreach (var args in e.DeleteValues)
            {
                string OrderDetails_Id = Convert.ToString(args.Keys["OrderDetails_Id"]);

                // Check Stock Out or Not

                string Del_OrderDetails_Id = "", Del_SrlNo = "";
                bool IsDelete = true;
                if (Session["PC_WarehouseData"] != null)
                {
                    DataTable Warehousedt = (DataTable)Session["PC_WarehouseData"];

                    foreach (DataRow drr in PurchaseOrderdt.Rows)
                    {
                        Del_OrderDetails_Id = Convert.ToString(drr["OrderDetails_Id"]);
                        if (Del_OrderDetails_Id == OrderDetails_Id)
                        {
                            Del_SrlNo = Convert.ToString(drr["SrlNo"]);
                        }
                    }

                    //var CheckStockOut_dt = Warehousedt.Select("Product_SrlNo ='" + Del_SrlNo + "' AND IsOutStatusMsg='visibility: visible'");
                    //if (CheckStockOut_dt.Length > 0)
                    //{
                    //    IsDelete = false;
                    //    grid.JSProperties["cpSaveSuccessOrFail"] = "stockOut";
                    //}
                }

                // Check Stock Out or Not

                if (IsDelete == true)
                {
                    for (int i = PurchaseOrderdt.Rows.Count - 1; i >= 0; i--)
                    {
                        DataRow dr = PurchaseOrderdt.Rows[i];
                        string delOrderDetailsId = Convert.ToString(dr["OrderDetails_Id"]);

                        if (delOrderDetailsId == OrderDetails_Id)
                            dr.Delete();
                    }
                    PurchaseOrderdt.AcceptChanges();

                    DeleteWarehouse(Del_SrlNo);
                    DeleteTaxDetails(Del_SrlNo);

                    if (OrderDetails_Id.Contains("~") != true)
                    {
                        PurchaseOrderdt.Rows.Add("0", OrderDetails_Id, "0", "", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "D", "", "");
                    }
                }
            }

            // DataTable Of Billing Address
            #region ##### Added By : Samrat Roy -- to get BillingShipping user control data
            DataTable tempBillAddress = new DataTable();
            tempBillAddress = BillingShippingControl.SaveBillingShippingControlData();

            #region #### Old_Process ####
            //// DataTable Of Billing Address
            //DataTable tempBillAddress = new DataTable();
            //if (Session["PurchaseChallanAddressDtl"] != null)
            //{
            //    tempBillAddress = (DataTable)Session["PurchaseChallanAddressDtl"];
            //}
            //// End

            #endregion

            #endregion

            ///////////////////////

            int j = 1;
            foreach (DataRow dr in PurchaseOrderdt.Rows)
            {
                string Status = Convert.ToString(dr["Status"]);
                dr["SrlNo"] = j.ToString();

                if (Status != "D")
                {
                    if (Status == "I")
                    {
                        string strID = Convert.ToString("Q~" + j);
                        dr["OrderDetails_Id"] = strID;
                    }
                    j++;
                }
            }
            PurchaseOrderdt.AcceptChanges();

            Session["PCProductOrderDetails"] = PurchaseOrderdt;
            if (IsDeleteFrom != "D" && IsDeleteFrom != "C")
            {
                string ActionType = Convert.ToString(ViewState["ActionType"]);
                string PurchaseOrder_Id = Convert.ToString(Session["PurchaseChallan_Id"]);
                string strSchemeType = Convert.ToString(ddl_numberingScheme.SelectedValue.Split('~')[0]);
                string strPurchaseNumber = Convert.ToString(txtVoucherNo.Text);
                string strPurchaseDate = Convert.ToString(dt_PLQuote.Date);
                // string IndentRequisitionNo = Convert.ToString(ddl_IndentRequisitionNo.SelectedValue);
                String IndentRequisitionNo = "";
                List<object> QuoList = lookup_quotation.GridView.GetSelectedFieldValues("PurchaseOrder_Id");
                foreach (object Quo in QuoList)
                {
                    IndentRequisitionNo += "," + Quo;
                }
                IndentRequisitionNo = IndentRequisitionNo.TrimStart(',');
                //string IndentRequisitionDate = Convert.ToString(txtDateIndentRequis.Date);
                string[] eachQuo = IndentRequisitionNo.Split(',');
                string IndentRequisitionDate = string.Empty;
                if (eachQuo.Length == 1)
                {
                    IndentRequisitionDate = Convert.ToString(dt_Quotation.Text);
                }
                //string strVendor = Convert.ToString(ddl_Vendor.SelectedValue);
                string strVendor = Convert.ToString(hdfLookupCustomer.Value);
                string strContactName = Convert.ToString(cmbContactPerson.Value);
                string Reference = Convert.ToString(txt_Refference.Text);
                string strBranch = Convert.ToString(ddl_Branch.SelectedValue);
                string strAgents = Convert.ToString(ddl_SalesAgent.SelectedValue);
                string strCurrency = Convert.ToString(ddl_Currency.SelectedValue);
                string strRate = (Convert.ToString(txt_Rate.Value).Trim() != "") ? Convert.ToString(txt_Rate.Value) : "0";
                string strTaxOption = Convert.ToString(ddl_AmountAre.Value);
                string strTaxCode = Convert.ToString(ddl_VatGstCst.Value).Split('~')[0];

                string CompanyID = Convert.ToString(HttpContext.Current.Session["LastCompany"]);
                string currency = Convert.ToString(HttpContext.Current.Session["LocalCurrency"]);
                string[] ActCurrency = currency.Split('~');
                int BaseCurrencyId = Convert.ToInt32(ActCurrency[0]);

                string strIsInventory = Convert.ToString(ddlInventory.SelectedValue);
                string strPartyInvoice = Convert.ToString(txtPartyInvoice.Text);
                string strPartyDate = "";
                if (dt_PartyDate.Date.ToString("yyyy-MM-dd") != "0001-01-01") strPartyDate = dt_PartyDate.Date.ToString("yyyy-MM-dd");

                DataTable tempQuotation = PurchaseOrderdt.Copy();

                foreach (DataRow dr in tempQuotation.Rows)
                {
                    string Status = Convert.ToString(dr["Status"]);

                    if (Status == "I")
                    {
                        dr["OrderDetails_Id"] = "0";

                        string[] list = Convert.ToString(dr["ProductID"]).Split(new string[] { "||@||" }, StringSplitOptions.None);
                        dr["ProductID"] = Convert.ToString(list[0]);
                        dr["UOM"] = Convert.ToString(list[3]);
                        dr["StockUOM"] = Convert.ToString(list[5]);
                    }
                    else if (Status == "U" || Status == "")
                    {

                        string delQuotationID = Convert.ToString(dr["OrderDetails_Id"]);
                        if (delQuotationID.Contains("~") == true)
                        {
                            dr["OrderDetails_Id"] = "0";
                            dr["Status"] = "I";
                        }

                        string[] list = Convert.ToString(dr["ProductID"]).Split(new string[] { "||@||" }, StringSplitOptions.None);
                        dr["ProductID"] = Convert.ToString(list[0]);
                        dr["UOM"] = Convert.ToString(list[3]);
                        dr["StockUOM"] = Convert.ToString(list[5]);
                    }
                }
                tempQuotation.AcceptChanges();

                // DataTable of Warehouse

                DataTable tempWarehousedt = new DataTable();
                if (Session["PC_WarehouseData"] != null)
                {
                    DataTable Warehousedt = (DataTable)Session["PC_WarehouseData"];
                    tempWarehousedt = Warehousedt.DefaultView.ToTable(false, "Product_SrlNo", "LoopID", "SrlNo", "WarehouseID", "Quantity", "BatchID", "SerialNo", "MfgDate", "ExpiryDate");
                }
                else
                {
                    tempWarehousedt.Columns.Add("Product_SrlNo", typeof(string));
                    tempWarehousedt.Columns.Add("SrlNo", typeof(string));
                    tempWarehousedt.Columns.Add("Row_Number", typeof(string));
                    tempWarehousedt.Columns.Add("WarehouseID", typeof(string));
                    tempWarehousedt.Columns.Add("Quantity", typeof(string));
                    tempWarehousedt.Columns.Add("BatchID", typeof(string));
                    tempWarehousedt.Columns.Add("SerialNo", typeof(string));
                    tempWarehousedt.Columns.Add("MfgDate", typeof(string));
                    tempWarehousedt.Columns.Add("ExpiryDate", typeof(string));
                }

                foreach (DataRow wtrow in tempWarehousedt.Rows)
                {
                    string strMfgDate = Convert.ToString(wtrow["MfgDate"]).Trim();
                    string strExpiryDate = Convert.ToString(wtrow["ExpiryDate"]).Trim();

                    if (strMfgDate != "")
                    {
                        string DD = strMfgDate.Substring(0, 2);
                        string MM = strMfgDate.Substring(3, 2);
                        string YYYY = strMfgDate.Substring(6, 4);
                        string Date = YYYY + '-' + MM + '-' + DD;

                        wtrow["MfgDate"] = Date;
                    }

                    if (strExpiryDate != "")
                    {
                        string DD = strExpiryDate.Substring(0, 2);
                        string MM = strExpiryDate.Substring(3, 2);
                        string YYYY = strExpiryDate.Substring(6, 4);
                        string Date = YYYY + '-' + MM + '-' + DD;

                        wtrow["ExpiryDate"] = Date;
                    }
                }

                // End

                //DataTable TaxDetailTable = getAllTaxDetails(e);

                DataTable TaxDetailTable = new DataTable();
                if (Session["PCFinalTaxRecord"] != null)
                {
                    TaxDetailTable = (DataTable)Session["PCFinalTaxRecord"];
                }

                // DataTable Of Quotation Tax Details 

                DataTable TaxDetailsdt = new DataTable();
                if (Session["PCTaxDetails"] != null)
                {
                    TaxDetailsdt = (DataTable)Session["PCTaxDetails"];
                }
                else
                {
                    TaxDetailsdt.Columns.Add("Taxes_ID", typeof(string));
                    TaxDetailsdt.Columns.Add("Taxes_Name", typeof(string));
                    TaxDetailsdt.Columns.Add("Percentage", typeof(string));
                    TaxDetailsdt.Columns.Add("Amount", typeof(string));
                    TaxDetailsdt.Columns.Add("AltTax_Code", typeof(string));
                }

                DataTable tempTaxDetailsdt = new DataTable();
                tempTaxDetailsdt = TaxDetailsdt.DefaultView.ToTable(false, "Taxes_ID", "Percentage", "Amount", "AltTax_Code");

                tempTaxDetailsdt.Columns.Add("SlNo", typeof(string));
                //    tempTaxDetailsdt.Columns.Add("AltTaxCode", typeof(string));

                tempTaxDetailsdt.Columns["SlNo"].SetOrdinal(0);
                tempTaxDetailsdt.Columns["Taxes_ID"].SetOrdinal(1);
                tempTaxDetailsdt.Columns["AltTax_Code"].SetOrdinal(2);
                tempTaxDetailsdt.Columns["Percentage"].SetOrdinal(3);
                tempTaxDetailsdt.Columns["Amount"].SetOrdinal(4);

                foreach (DataRow d in tempTaxDetailsdt.Rows)
                {
                    d["SlNo"] = "0";
                    //d["AltTaxCode"] = "0";
                }

                // End
                #region Sandip Section For Approval Section Start
                string approveStatus = "";
                if (Request.QueryString["status"] != null)
                {
                    approveStatus = Convert.ToString(Request.QueryString["status"]);
                }

                #endregion Sandip Section For Approval Section end

                if (ActionType == "Add")
                {
                    string[] SchemeList = strSchemeType.Split(new string[] { "~" }, StringSplitOptions.None);
                    validate = checkNMakeJVCode(strPurchaseNumber, Convert.ToInt32(SchemeList[0]));
                }

                if (ddlInventory.SelectedValue != "N")
                {
                    foreach (DataRow dr in tempQuotation.Rows)
                    {
                        string ProductID = Convert.ToString(dr["ProductID"]);
                        decimal ProductQuantity = Convert.ToDecimal(dr["Quantity"]);
                        string Status = Convert.ToString(dr["Status"]);

                        if (CheckProduct_IsInventory(ProductID) == true)
                        {
                            if (Status != "D")
                            {
                                if (ProductQuantity == 0)
                                {
                                    validate = "nullQuantity";
                                    break;
                                }
                            }
                        }
                    }
                }

                if (ddlInventory.SelectedValue != "N")
                {
                    foreach (DataRow dr in tempQuotation.Rows)
                    {
                        string ProductID = Convert.ToString(dr["ProductID"]);
                        string strSrlNo = Convert.ToString(dr["SrlNo"]);
                        decimal strProductQuantity = Convert.ToDecimal(dr["Quantity"]);
                        string Status = Convert.ToString(dr["Status"]);
                        string IsLinkedProduct = Convert.ToString(dr["IsLinkedProduct"]);

                        decimal strWarehouseQuantity = 0;
                        GetQuantityBaseOnProduct(strSrlNo, ref strWarehouseQuantity);

                        if (CheckProduct_IsInventory(ProductID) == true)
                        {
                            if (Status != "D")
                            {
                                if (IsLinkedProduct != "Y")
                                {
                                    if (strProductQuantity != strWarehouseQuantity)
                                    {
                                        validate = "checkWarehouse";
                                        grid.JSProperties["cpProductSrlIDCheck"] = strSrlNo;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }

                //----------Start-------------------------
                //Data: 31-05-2017 Author: Sayan Dutta
                //Details:To check T&C Mandatory Control
                #region TC
                BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable DT_TC = objEngine.GetDataTable("Config_SystemSettings", " Variable_Value ", " Variable_Name='TC_PCMandatory' AND IsActive=1");
                if (DT_TC != null && DT_TC.Rows.Count > 0)
                {
                    string IsMandatory = Convert.ToString(DT_TC.Rows[0]["Variable_Value"]).Trim();

                    objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                    DataTable DTVisible = objEngine.GetDataTable("Config_SystemSettings", " Variable_Value ", " Variable_Name='Show_TC_PC' AND IsActive=1");
                    if (Convert.ToString(DTVisible.Rows[0]["Variable_Value"]).Trim() == "Yes")
                    {
                        if (IsMandatory == "Yes")
                        {
                            if (TermsConditionsControl.GetControlValue("dtDeliveryDate") == "" || TermsConditionsControl.GetControlValue("dtDeliveryDate") == "@")
                            {
                                validate = "TCMandatory";
                            }
                        }
                    }
                }
                #endregion
                //----------End-------------------------

                //// ############# Added By : Samrat Roy -- 02/05/2017 -- To check Transporter Mandatory Control 
                objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                DataTable DT = objEngine.GetDataTable("Config_SystemSettings", " Variable_Value ", " Variable_Name='Transporter_PCMandatory' AND IsActive=1");
                if (DT != null && DT.Rows.Count > 0)
                {
                    string IsMandatory = Convert.ToString(DT.Rows[0]["Variable_Value"]).Trim();
                    //objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                    //DataTable DTVisible = objEngine.GetDataTable("Config_SystemSettings", " Variable_Value ", " Variable_Name='Show_Transporter' AND IsActive=1");
                    if (Convert.ToString(Session["TransporterVisibilty"]).Trim() == "Yes")
                    {
                        if (IsMandatory == "Yes")
                        {
                            if (hfControlData.Value.Trim() == "")
                            {
                                validate = "transporteMandatory";
                            }
                        }
                    }
                }

                //// ############# Added By : Samrat Roy -- 02/05/2017 -- To check Transporter Mandatory Control 


                //foreach (DataRow dr in tempQuotation.Rows)
                //{
                //    decimal ProductPurchasePrice = Convert.ToDecimal(dr["PurchasePrice"]);
                //    string Status = Convert.ToString(dr["Status"]);

                //    if (Status != "D")
                //    {
                //        if (ProductPurchasePrice == 0)
                //        {
                //            validate = "nullPurchasePrice";
                //            break;
                //        }
                //    }
                //}

                DataView _dvData = new DataView(tempQuotation);
                _dvData.RowFilter = "Status<>'D'";
                DataTable _tempQuotation = _dvData.ToTable();

                var _duplicateRecords = _tempQuotation.AsEnumerable()
               .GroupBy(r => r["ProductID"]) //coloumn name which has the duplicate values
               .Where(gr => gr.Count() > 1)
               .Select(g => g.Key);

                //foreach (var d in _duplicateRecords)
                //{
                //    validate = "duplicateProduct";
                //}

                DataTable Copy_tempWarehousedt = tempWarehousedt.Copy();
                DataView dvData = new DataView(Copy_tempWarehousedt);
                dvData.RowFilter = "SerialNo <> ''";
                DataTable Filter_tempWarehousedt = dvData.ToTable();

                var duplicateRecords = Filter_tempWarehousedt.AsEnumerable()
               .GroupBy(r => r["SerialNo"]) //coloumn name which has the duplicate values
               .Where(gr => gr.Count() > 1)
               .Select(g => g.Key);
                //foreach (var d in duplicateRecords)
                //{
                //    grid.JSProperties["cpduplicateSerialMsg"] = "Cannot process with duplicate Serial No.";
                //    validate = "duplicateSerial";
                //}

                //if (PurchaseOrder_Id.Trim() != "")
                //{
                //    foreach (DataRow dr in tempWarehousedt.Rows)
                //    {
                //        string SerialNo = Convert.ToString(dr["SerialNo"]);

                //        if (SerialNo.Trim() != "")
                //        {
                //            DataTable dtDuplicate = objEngine.GetDataTable("v_Stock_WarehouseDetails", " ProductsName,SerialNo ", " SerialNo='" + SerialNo.Trim() + "' AND Stock_IN_Out_Type='IN' AND IN_DocNumber<>'" + PurchaseOrder_Id.Trim() + "'  AND SerialNo<>'' ");
                //            if (dtDuplicate != null && dtDuplicate.Rows.Count > 0)
                //            {
                //                string ProductName = Convert.ToString(dtDuplicate.Rows[0]["ProductsName"]).Trim();

                //                grid.JSProperties["cpduplicateSerialMsg"] = "(" + SerialNo + ")  Serial No already exists for  (" + ProductName + ")  Product.";
                //                validate = "duplicateSerial";
                //                break;
                //            }
                //        }
                //    }
                //}
                //else
                //{
                //    foreach (DataRow dr in tempWarehousedt.Rows)
                //    {
                //        string SerialNo = Convert.ToString(dr["SerialNo"]);

                //        if (SerialNo.Trim() != "")
                //        {
                //            DataTable dtDuplicate = objEngine.GetDataTable("v_Stock_WarehouseDetails", " ProductsName,SerialNo ", " SerialNo='" + SerialNo.Trim() + "' AND Stock_IN_Out_Type='IN'  AND SerialNo<>''  ");
                //            if (dtDuplicate != null && dtDuplicate.Rows.Count > 0)
                //            {
                //                string ProductName = Convert.ToString(dtDuplicate.Rows[0]["ProductsName"]).Trim();

                //                grid.JSProperties["cpduplicateSerialMsg"] = "(" + SerialNo + ")  Serial No already exists for  (" + ProductName + ")  Product.";
                //                validate = "duplicateSerial";
                //                break;
                //            }
                //        }
                //    }
                //}

                if (validate == "outrange" || validate == "duplicateProduct" || validate == "nullQuantity" || validate == "duplicate" || validate == "checkWarehouse" || validate == "duplicateSerial" || validate == "TCMandatory" || validate == "nullPurchasePrice" || validate == "transporteMandatory")
                {
                    grid.JSProperties["cpSaveSuccessOrFail"] = validate;
                }
                else
                {
                    if (Iswarenotthere == true)
                    {
                        grid.JSProperties["cpinserterrorwarehouse"] = warehousemsg;
                    }
                    else
                    {
                        //Cheking PC being used by another module
                        if (!IsPcTransactionExist(PurchaseOrder_Id))
                        {
                            //Cheking PO is there or not
                            if (IsPOExist(IndentRequisitionNo))
                            {
                                int strIsComplete = 0, strChallanID = 0;

                                string TaxType = "", ShippingState = "";
                                ShippingState = Convert.ToString(BillingShippingControl.GetShippingStateCode());

                                if (ddl_AmountAre.Value == "1") TaxType = "E";
                                else if (ddl_AmountAre.Value == "2") TaxType = "I";

                                TaxDetailTable = gstTaxDetails.SetTaxTableDataWithProductSerialForPurchaseRoundOff(ref tempQuotation, "SrlNo", "ProductID", "Amount", "TaxAmount","TotalAmount", TaxDetailTable, "P", dt_PLQuote.Date.ToString("yyyy-MM-dd"), strBranch, ShippingState, TaxType, Convert.ToString(lookup_Customer.Value));

                                AddModifyPurchaseOrder(PurchaseOrder_Id, UniquePurchaseNumber, strPurchaseDate, IndentRequisitionNo, IndentRequisitionDate, strVendor, strContactName,
                                Reference, strBranch, strAgents, strCurrency, strRate, strTaxOption, strTaxCode, CompanyID, BaseCurrencyId, tempQuotation, ActionType, tempWarehousedt,
                                tempBillAddress, TaxDetailTable, tempTaxDetailsdt, approveStatus, strIsInventory, strPartyInvoice, strPartyDate, ref strIsComplete, ref strChallanID);


                                if (strIsComplete == 1)
                                {
                                    #region Sandip Section For Approval Section Start
                                    if (approveStatus != "")
                                    {
                                        if (approveStatus == "2")
                                        {
                                            grid.JSProperties["cpApproverStatus"] = "approve";
                                        }
                                        else
                                        {
                                            grid.JSProperties["cpApproverStatus"] = "rejected";
                                        }
                                    }
                                    #endregion Sandip Section For Approval Section end
                                    grid.JSProperties["cpPurchaseOrderNo"] = UniquePurchaseNumber;

                                    if (Session["PCProductOrderDetails"] != null)
                                    {
                                        Session["PCProductOrderDetails"] = null;

                                    }
                                }
                                else if (strIsComplete == -99)
                                {
                                    grid.JSProperties["cpSaveSuccessOrFail"] = "allStockOut";
                                }
                                else
                                {
                                    grid.JSProperties["cpSaveSuccessOrFail"] = "errorInsert";
                                }
                            }
                            else
                            {
                                grid.JSProperties["cpSaveSuccessOrFail"] = "Ponotexist";
                            }

                        }
                        else
                        {
                            grid.JSProperties["cpSaveSuccessOrFail"] = "transactionbeingused";
                        }
                    }
                }
            }
            else
            {
                DataView dvData = new DataView(PurchaseOrderdt);
                dvData.RowFilter = "Status <> 'D'";

                grid.DataSource = GetPurchaseOrderBatch(dvData.ToTable());
                grid.DataBind();
            }

        }
        public IEnumerable GetPurchaseOrderBatch(DataTable Quotationdt)
        {
            List<PurchaseChallanList_Stock> PurchaseOrderList = new List<PurchaseChallanList_Stock>();
            // DataTable Quotationdt = GetPurchaseOrderData().Tables[0];

            if (Quotationdt != null)
            {
                for (int i = 0; i < Quotationdt.Rows.Count; i++)
                {
                    PurchaseChallanList_Stock PurchaseOrders = new PurchaseChallanList_Stock();

                    PurchaseOrders.SrlNo = Convert.ToString(Quotationdt.Rows[i]["SrlNo"]);
                    PurchaseOrders.OrderDetails_Id = Convert.ToString(Quotationdt.Rows[i]["OrderDetails_Id"]);
                    PurchaseOrders.gvColProduct = Convert.ToString(Quotationdt.Rows[i]["ProductID"]);
                    PurchaseOrders.gvColDiscription = Convert.ToString(Quotationdt.Rows[i]["Description"]);
                    PurchaseOrders.gvColQuantity = Convert.ToString(Quotationdt.Rows[i]["Quantity"]);
                    PurchaseOrders.gvColUOM = Convert.ToString(Quotationdt.Rows[i]["UOM"]);
                    PurchaseOrders.Warehouse = "";
                    PurchaseOrders.gvColStockQty = Convert.ToString(Quotationdt.Rows[i]["StockQuantity"]);
                    PurchaseOrders.gvColStockUOM = Convert.ToString(Quotationdt.Rows[i]["StockUOM"]);
                    PurchaseOrders.gvColStockPurchasePrice = Convert.ToString(Quotationdt.Rows[i]["PurchasePrice"]);
                    PurchaseOrders.gvColDiscount = Convert.ToString(Quotationdt.Rows[i]["Discount"]);
                    PurchaseOrders.gvColAmount = Convert.ToString(Quotationdt.Rows[i]["Amount"]);
                    PurchaseOrders.gvColTaxAmount = Convert.ToString(Quotationdt.Rows[i]["TaxAmount"]);
                    PurchaseOrders.gvColTotalAmountINR = Convert.ToString(Quotationdt.Rows[i]["TotalAmount"]);
                    PurchaseOrders.ProductName = Convert.ToString(Quotationdt.Rows[i]["ProductName"]);
                    if (Convert.ToString(Quotationdt.Rows[i]["PO_Number"]) != "0")
                    {
                        PurchaseOrders.PoNumber = Convert.ToString(Quotationdt.Rows[i]["PO_Number"]);
                    }
                    //PurchaseOrders.PoNumber = Convert.ToString(Quotationdt.Rows[i]["PO_Number"]);
                    PurchaseOrders.TotalQty = Convert.ToString(Quotationdt.Rows[i]["TotalQty"]);
                    PurchaseOrders.BalanceQty = Convert.ToString(Quotationdt.Rows[i]["BalanceQty"]);
                    PurchaseOrders.IsComponentProduct = Convert.ToString(Quotationdt.Rows[i]["IsComponentProduct"]);
                    PurchaseOrders.IsLinkedProduct = Convert.ToString(Quotationdt.Rows[i]["IsLinkedProduct"]);
                    PurchaseOrders.ComponentID = Convert.ToString(Quotationdt.Rows[i]["ComponentID"]);

                    PurchaseOrderList.Add(PurchaseOrders);
                }
            }

            return PurchaseOrderList;
        }
        public bool AddModifyPurchaseOrder(string PurchaseOrder_Id, string UniquePurchaseNumber, string strPurchaseDate, string IndentRequisitionNo, string IndentRequisitionDate,
                                            string strVendor, string strContactName, string Reference, string strBranch,
                                            string strAgents, string strCurrency, string strRate, string strTaxOption,
                                            string strTaxCode, string CompanyID, int BaseCurrencyId, DataTable PurchaseOrderdt,
                                            string ActionType, DataTable Warehousedt, DataTable tempBillAddress,
                                            DataTable TaxDetailTable, DataTable QuotationTaxdt, string approveStatus,
                                            string strIsInventory, string strPartyInvoice, string strPartyDate,
                                            ref int strIsComplete, ref int strChallanID)
        {
            try
            {
                string[] IndentRequisitionDateArray;
                string IndentRequisitionDateformate = string.Empty;
                if (!string.IsNullOrEmpty(IndentRequisitionDate))
                {
                    IndentRequisitionDateformate = IndentRequisitionDate.Split('-')[2] + "/" + IndentRequisitionDate.Split('-')[1] + "/" + IndentRequisitionDate.Split('-')[0] + " 00:01:47.480";
                }

                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                //SqlCommand cmd = new SqlCommand("prc_Purchasechallan", con);
                SqlCommand cmd = new SqlCommand("prc_Purchasechallan_Modify", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", ActionType);
                cmd.Parameters.AddWithValue("@PurchaseChallanEdit_Id", PurchaseOrder_Id);

                cmd.Parameters.AddWithValue("@IsInventory", strIsInventory);
                cmd.Parameters.AddWithValue("@PartyInvoiceNo", strPartyInvoice);
                cmd.Parameters.AddWithValue("@PartyInvoiceDate", strPartyDate);

                #region Sandip Section For Approval Section Start
                cmd.Parameters.AddWithValue("@approveStatus", approveStatus);
                #endregion Sandip Section For Approval Section end

                cmd.Parameters.AddWithValue("@PurchaseChallan_CompanyID", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@PurchaseChallan_BranchId", strBranch);
                cmd.Parameters.AddWithValue("@PurchaseChallan_FinYear", Convert.ToString(Session["LastFinYear"]));
                cmd.Parameters.AddWithValue("@PurchaseChallan_Number", UniquePurchaseNumber);
                cmd.Parameters.AddWithValue("@PurchaseChallan_IndentIds", IndentRequisitionNo);

                if (!string.IsNullOrEmpty(IndentRequisitionDateformate))
                {
                    cmd.Parameters.AddWithValue("@PurchaseChallan_IndentDate", Convert.ToDateTime(IndentRequisitionDateformate).ToString("yyyy-MM-dd"));
                }
                if (!string.IsNullOrEmpty(strPurchaseDate))
                {
                    cmd.Parameters.AddWithValue("@PurchaseChallan_Date", Convert.ToDateTime(strPurchaseDate).ToString("yyyy-MM-dd"));
                }
                cmd.Parameters.AddWithValue("@PurchaseChallan_VendorId", strVendor);
                cmd.Parameters.AddWithValue("@Contact_Person_Id", strContactName);
                cmd.Parameters.AddWithValue("@PurchaseChallan_Reference", Reference);
                cmd.Parameters.AddWithValue("@PurchaseChallan_Currency_Id", BaseCurrencyId);
                cmd.Parameters.AddWithValue("@Currency_Conversion_Rate", strRate);
                cmd.Parameters.AddWithValue("@Tax_Option", strTaxOption);

                cmd.Parameters.AddWithValue("@TaxDetail", TaxDetailTable);
                cmd.Parameters.AddWithValue("@QuotationTax", QuotationTaxdt);
                if (tempBillAddress != null && tempBillAddress.Rows.Count > 0)
                {
                    cmd.Parameters.AddWithValue("@PurchaseChallanAddress", tempBillAddress);
                }
                if (strTaxCode == "")
                {
                    cmd.Parameters.AddWithValue("@Tax_Code", 0);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@Tax_Code", strTaxCode);
                    //cmd.Parameters.AddWithValue("@Tax_Code", 0);
                }

                cmd.Parameters.AddWithValue("@PurchaseChallan_SalesmanId", strAgents);
                //cmd.Parameters.AddWithValue("@StockID", Convert.ToString(hdfstockidPC.Value));
                cmd.Parameters.AddWithValue("@CreatedBy", Convert.ToString(Session["userid"]));

                if (PurchaseOrderdt.Rows.Count > 0)
                {
                    DataTable Productlist = PurchaseOrderdt.DefaultView.ToTable(false, "SrlNo", "OrderDetails_Id", "ProductID", "Description", "Quantity", "UOM", "Warehouse", "StockQuantity", "StockUOM", "PurchasePrice", "Discount", "Amount", "TaxAmount", "TotalAmount", "Status", "ProductName", "ComponentID", "IsComponentProduct", "IsLinkedProduct");
                    cmd.Parameters.AddWithValue("@PurchaseChallanDetails", Productlist);
                }

                //if (Session["Pcwarehousedetailstemp"] != null)
                //{
                //    DataTable temtable = new DataTable();
                //    DataTable Warehousedtssss = (DataTable)Session["Pcwarehousedetailstemp"];

                //    temtable = Warehousedtssss.DefaultView.ToTable(false, "SrlNo", "BatchWarehouseID", "BatchWarehousedetailsID", "BatchID", "SerialID", "WarehouseID", "WarehouseName", "BatchNo", "SerialNo", "MFGDate", "ExpiryDate", "Quantitysum", "productid", "Inventrytype", "StockID", "isnew");
                //    cmd.Parameters.AddWithValue("@udt_StockOpeningwarehousentrie", temtable);
                //}

                cmd.Parameters.AddWithValue("@WarehouseDetail", Warehousedt);


                cmd.Parameters.Add("@ReturnValue", SqlDbType.VarChar, 50);
                cmd.Parameters.Add("@ReturnChallanID", SqlDbType.VarChar, 50);

                cmd.Parameters["@ReturnValue"].Direction = ParameterDirection.Output;
                cmd.Parameters["@ReturnChallanID"].Direction = ParameterDirection.Output;

                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);

                strIsComplete = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value.ToString());
                strChallanID = Convert.ToInt32(cmd.Parameters["@ReturnChallanID"].Value.ToString());

                if (strIsComplete == 1)
                {

                    if (!string.IsNullOrEmpty(hfControlData.Value))
                    {
                        CommonBL objCommonBL = new CommonBL();
                        objCommonBL.InsertTransporterControlDetails(Convert.ToInt64(strChallanID), "PC", hfControlData.Value, Convert.ToString(HttpContext.Current.Session["userid"]));
                    }

                    if (strChallanID > 0)
                    {
                        if (!string.IsNullOrEmpty(hfTermsConditionData.Value))
                        {
                            TermsConditionsControl.SaveTC(hfTermsConditionData.Value, Convert.ToString(strChallanID), "PC");
                        }
                    }

                    //Udf Add mode
                    DataTable udfTable = (DataTable)Session["UdfDataOnAdd"];
                    if (udfTable != null)
                    {
                        Session["UdfDataOnAdd"] = reCat.insertRemarksCategoryAddMode("PC", "PurchaseChallan_Stock" + Convert.ToString(strChallanID), udfTable, Convert.ToString(Session["userid"]));
                    }

                    int retval = 0;
                    if (!string.IsNullOrEmpty(Convert.ToString(strChallanID)))
                    {
                        retval = Sendmail_PurchaseChallan(strChallanID.ToString());
                    }
                }
                cmd.Dispose();
                con.Dispose();

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public string checkNMakeJVCode(string manual_str, int sel_schema_Id)
        {

            oDBEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable dtSchema = new DataTable();
            DataTable dtC = new DataTable();
            string prefCompCode = string.Empty, sufxCompCode = string.Empty, startNo, paddedStr, sqlQuery = string.Empty;
            int EmpCode, prefLen, sufxLen, paddCounter;

            if (sel_schema_Id > 0)
            {
                dtSchema = oDBEngine.GetDataTable("tbl_master_idschema", "prefix, suffix, digit, startno, schema_type", "id=" + sel_schema_Id);
                int scheme_type = Convert.ToInt32(dtSchema.Rows[0]["schema_type"]);

                if (scheme_type != 0)
                {
                    startNo = dtSchema.Rows[0]["startno"].ToString();
                    paddCounter = Convert.ToInt32(dtSchema.Rows[0]["digit"]);
                    paddedStr = startNo.PadLeft(paddCounter, '0');
                    prefCompCode = dtSchema.Rows[0]["prefix"].ToString();
                    sufxCompCode = dtSchema.Rows[0]["suffix"].ToString();
                    prefLen = Convert.ToInt32(prefCompCode.Length);
                    sufxLen = Convert.ToInt32(sufxCompCode.Length);

                    sqlQuery = "SELECT max(tjv.PurchaseChallan_Number) FROM tbl_trans_PurchaseChallan tjv WHERE dbo.RegexMatch('";
                    if (prefLen > 0)
                        sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                    else if (scheme_type == 2)
                        sqlQuery += "^";
                    sqlQuery += "[0-9]{" + paddCounter + "}";
                    if (sufxLen > 0)
                        sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                    //sqlQuery += "?$', LTRIM(RTRIM(tjv.PurchaseChallan_Number))) = 1";
                    sqlQuery += "?$', LTRIM(RTRIM(tjv.PurchaseChallan_Number))) = 1 and PurchaseChallan_Number like '" + prefCompCode + "%'";
                    if (scheme_type == 2)
                        sqlQuery += " AND CONVERT(DATE, CreatedDate) = CONVERT(DATE, GETDATE())";
                    dtC = oDBEngine.GetDataTable(sqlQuery);

                    if (dtC.Rows[0][0].ToString() == "")
                    {
                        sqlQuery = "SELECT max(tjv.PurchaseChallan_Number) FROM tbl_trans_PurchaseChallan tjv WHERE dbo.RegexMatch('";
                        if (prefLen > 0)
                            sqlQuery += "^[" + prefCompCode + "]{" + prefLen + "}";
                        else if (scheme_type == 2)
                            sqlQuery += "^";
                        sqlQuery += "[0-9]{" + (paddCounter - 1) + "}";
                        if (sufxLen > 0)
                            sqlQuery += "[" + sufxCompCode + "]{" + sufxLen + "}";
                        //sqlQuery += "?$', LTRIM(RTRIM(tjv.PurchaseChallan_Number))) = 1";
                        sqlQuery += "?$', LTRIM(RTRIM(tjv.PurchaseChallan_Number))) = 1 and PurchaseChallan_Number like '" + prefCompCode + "%'";
                        if (scheme_type == 2)
                            sqlQuery += " AND CONVERT(DATE, CreatedDate) = CONVERT(DATE, GETDATE())";
                        dtC = oDBEngine.GetDataTable(sqlQuery);
                    }

                    if (dtC.Rows.Count > 0 && dtC.Rows[0][0].ToString().Trim() != "")
                    {
                        string uccCode = dtC.Rows[0][0].ToString().Trim();
                        int UCCLen = uccCode.Length;
                        int decimalPartLen = UCCLen - (prefCompCode.Length + sufxCompCode.Length);
                        string uccCodeSubstring = uccCode.Substring(prefCompCode.Length, decimalPartLen);
                        EmpCode = Convert.ToInt32(uccCodeSubstring) + 1;
                        // out of range journal scheme
                        if (EmpCode.ToString().Length > paddCounter)
                        {
                            return "outrange";
                        }
                        else
                        {
                            paddedStr = EmpCode.ToString().PadLeft(paddCounter, '0');
                            UniquePurchaseNumber = prefCompCode + paddedStr + sufxCompCode;
                            return "ok";
                        }
                    }
                    else
                    {
                        UniquePurchaseNumber = startNo.PadLeft(paddCounter, '0');
                        UniquePurchaseNumber = prefCompCode + paddedStr + sufxCompCode;
                        return "ok";
                    }
                }
                else
                {
                    sqlQuery = "SELECT PurchaseChallan_Number FROM tbl_trans_PurchaseChallan WHERE PurchaseChallan_Number LIKE '" + manual_str.Trim() + "'";
                    dtC = oDBEngine.GetDataTable(sqlQuery);
                    // duplicate manual entry check
                    if (dtC.Rows.Count > 0 && dtC.Rows[0][0].ToString().Trim() != "")
                    {
                        return "duplicate";
                    }

                    UniquePurchaseNumber = manual_str.Trim();
                    return "ok";
                }
            }
            else
            {
                return "noid";
            }
        }
        [WebMethod]
        public static bool CheckUniqueName(string VoucherNo)
        {
            MShortNameCheckingBL objMShortNameCheckingBL = new MShortNameCheckingBL();
            DataTable dt = new DataTable();
            Boolean status = false;
            BusinessLogicLayer.GenericMethod oGeneric = new BusinessLogicLayer.GenericMethod();

            if (VoucherNo != "" && Convert.ToString(VoucherNo).Trim() != "")
            {
                status = objMShortNameCheckingBL.CheckUnique(Convert.ToString(VoucherNo).Trim(), "0", "PurchaseChallan_Check");
            }
            return status;
        }
        protected void grid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data)
                return;

            string IsLinkedProduct = Convert.ToString(e.GetValue("IsLinkedProduct"));
            if (IsLinkedProduct == "Y")
                e.Row.ForeColor = Color.Blue;
        }
        public bool CheckProduct_IsInventory(string ProductID)
        {
            bool IsInventory = true;

            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = objEngine.GetDataTable("Master_sProducts", " sProduct_IsInventory ", " sProducts_ID='" + ProductID + "'");
            if (DT != null && DT.Rows.Count > 0)
            {
                string strIsInventory = Convert.ToString(DT.Rows[0]["sProduct_IsInventory"]).Trim();

                if (strIsInventory == "True") IsInventory = true;
                else IsInventory = false;
            }

            return IsInventory;
        }

        #endregion

        #region   Purchase Order Tagging

        protected void lookup_quotation_DataBinding(object sender, EventArgs e)
        {
            if (Session["PORequiData"] != null)
            {
                lookup_quotation.DataSource = (DataTable)Session["PORequiData"];
            }
        }
        protected void ComponentQuotation_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string status = string.Empty;
            string Customer = string.Empty;
            string OrderDate = string.Empty;
            string ComponentType = string.Empty;
            string Action = string.Empty;
            string BranchID = string.Empty;
            string FinYear = Convert.ToString(Session["LastFinYear"]);

            if (e.Parameter.Split('~')[0] == "BindComponentGrid")
            {
                Action = "GetPurchaseOrder";
                BranchID = Convert.ToString(ddl_Branch.SelectedValue);
                if (e.Parameter.Split('~')[1] != null) Customer = e.Parameter.Split('~')[1];
                if (e.Parameter.Split('~')[2] != null) OrderDate = e.Parameter.Split('~')[2];
                if (e.Parameter.Split('~')[3] != null) ComponentType = e.Parameter.Split('~')[3];

                if (e.Parameter.Split('~')[3] == "DateCheck")
                {
                    lookup_quotation.GridView.Selection.UnselectAll();
                }

                string strChallanID = Convert.ToString(Session["PurchaseChallan_Id"]);
                DataTable ComponentTable = objSalesInvoiceBL.GetComponent(Customer, OrderDate, ComponentType, FinYear, BranchID, Action, strChallanID);
                lookup_quotation.GridView.Selection.CancelSelection();
                lookup_quotation.DataSource = ComponentTable;
                lookup_quotation.DataBind();

                Session["PORequiData"] = ComponentTable;
            }
        }
        protected void ComponentDatePanel_Callback(object sender, CallbackEventArgsBase e)
        {
            string strSplitCommand = e.Parameter.Split('~')[0];
            if (strSplitCommand == "BindQuotationDate")
            {
                string Indent_No = Convert.ToString(e.Parameter.Split('~')[1]);
                DataTable dt_indentDetails = objPurchaseChallanBL.GetIndentRequisitionDate(Indent_No);
                if (dt_indentDetails != null && dt_indentDetails.Rows.Count > 0)
                {
                    string quotationdate = Convert.ToString(dt_indentDetails.Rows[0]["Indent_RequisitionDate"]);
                    if (!string.IsNullOrEmpty(quotationdate))
                    {
                        dt_Quotation.Text = Convert.ToString(quotationdate);

                    }
                }
            }
        }
        protected void cgridProducts_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "BindProductsDetails")
            {
                string Quote_Nos = Convert.ToString(e.Parameters.Split('~')[1]);

                String QuoComponent = "";
                List<object> QuoList = lookup_quotation.GridView.GetSelectedFieldValues("PurchaseOrder_Id");
                foreach (object Quo in QuoList)
                {
                    QuoComponent += "," + Quo;
                }
                QuoComponent = QuoComponent.TrimStart(',');

                if (Quote_Nos != "$")
                {
                    string strAction = "GetPurchaseOrderProducts";
                    string strChallanID = Convert.ToString(Session["PurchaseChallan_Id"]);
                    DataTable dtDetails = objSalesInvoiceBL.GetComponentProductList(strAction, QuoComponent, strChallanID);

                    grid_Products.DataSource = dtDetails;
                    grid_Products.DataBind();
                }
                else
                {
                    grid_Products.DataSource = null;
                    grid_Products.DataBind();
                }
            }
            if (strSplitCommand == "SelectAndDeSelectProducts")
            {
                ASPxGridView gv = sender as ASPxGridView;
                string command = e.Parameters.ToString();
                string State = Convert.ToString(e.Parameters.Split('~')[1]);
                if (State == "SelectAll")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        gv.Selection.SelectRow(i);
                    }
                }
                if (State == "UnSelectAll")
                {
                    for (int i = 0; i < gv.VisibleRowCount; i++)
                    {
                        gv.Selection.UnselectRow(i);
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
                }
            }
        }

        #endregion

        #region warehousepopup

        protected void GrdWarehousePC_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];


            if (hdniswarehouse.Value == "true")
            {
                GrdWarehousePC.Columns["viewWarehouseName"].Visible = true;
                GrdWarehousePC.Columns["Quantity"].Visible = true;
                GrdWarehousePC.Columns["viewQuantity"].Visible = false;

            }
            else
            {
                GrdWarehousePC.Columns["viewWarehouseName"].Visible = false;
                GrdWarehousePC.Columns["Quantity"].Visible = false;
                GrdWarehousePC.Columns["viewQuantity"].Visible = true;
            }
            if (hdnisbatch.Value == "true")
            {
                GrdWarehousePC.Columns["viewBatchNo"].Visible = true;
                GrdWarehousePC.Columns["viewMFGDate"].Visible = true;
                GrdWarehousePC.Columns["viewExpiryDate"].Visible = true;
                GrdWarehousePC.Columns["Quantity"].Visible = false;
                GrdWarehousePC.Columns["viewQuantity"].Visible = true;

            }
            else
            {
                GrdWarehousePC.Columns["viewBatchNo"].Visible = false;
                GrdWarehousePC.Columns["viewMFGDate"].Visible = false;
                GrdWarehousePC.Columns["viewExpiryDate"].Visible = false;
                GrdWarehousePC.Columns["Quantity"].Visible = true;
                GrdWarehousePC.Columns["viewQuantity"].Visible = false;
            }
            if (hdnisserial.Value == "true")
            {
                GrdWarehousePC.Columns["viewSerialNo"].Visible = true;
                GrdWarehousePC.Columns["Quantity"].Visible = false;
                GrdWarehousePC.Columns["viewQuantity"].Visible = true;
            }
            else
            {
                GrdWarehousePC.Columns["viewSerialNo"].Visible = false;
            }


            #region Savenew
            if (strSplitCommand == "Display")
            {
                string WarehouseName = Convert.ToString(e.Parameters.Split('~')[2]);

                string WarehouseID = Convert.ToString(e.Parameters.Split('~')[1]).Trim();

                string BatchName = Convert.ToString(e.Parameters.Split('~')[3]);

                string SerialName = Convert.ToString(e.Parameters.Split('~')[4]);
                string ProductID = Convert.ToString(hdfProductIDPC.Value);
                string stockid = Convert.ToString(hdfstockidPC.Value);
                decimal openingstock = Convert.ToDecimal(txtqnty.Text);
                string branchid = Convert.ToString(hdbranchIDPC.Value);
                string qnty = Convert.ToString(e.Parameters.Split('~')[5]);

                decimal totalopeining = Convert.ToDecimal(hdfopeningstockPC.Value);
                decimal oldtotalopeining = Convert.ToDecimal(oldopeningqntity.Value);

                if (qnty == "0.0000" && openingstock <= 0)
                {
                    qnty = batchqnty.Text;
                    openingstock = Convert.ToDecimal(qnty);
                }

                if (!string.IsNullOrEmpty(BatchName))
                {
                    BatchName = BatchName.Trim();
                }
                if (!string.IsNullOrEmpty(SerialName))
                {
                    SerialName = SerialName.Trim();
                }
                if (WarehouseID == "null")
                {
                    WarehouseID = "0";
                }
                bool isserialunique = false;
                if (hdnisserial.Value == "true")
                {
                    isserialunique = CheckUniqueSerial(SerialName, "new");
                }

                if (Convert.ToDecimal(openingstock) > totalopeining)
                {
                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("You have entered Quantity greater than  Quantity. Cannot Proceed.");

                }

                else if (isserialunique == false)
                {
                    DataTable Warehousedt = new DataTable();
                    DataTable Warehousedtnew = new DataTable();
                    if (Session["PCWarehouseData"] != null)
                    {
                        Warehousedt = (DataTable)Session["PCWarehouseData"];
                    }
                    else
                    {
                        Warehousedt.Columns.Add("SrlNo", typeof(Int32));
                        Warehousedt.Columns.Add("WarehouseID", typeof(string));
                        Warehousedt.Columns.Add("WarehouseName", typeof(string));

                        Warehousedt.Columns.Add("BatchNo", typeof(string));
                        Warehousedt.Columns.Add("SerialNo", typeof(string));

                        Warehousedt.Columns.Add("MFGDate", typeof(DateTime));
                        Warehousedt.Columns.Add("ExpiryDate", typeof(DateTime));
                        Warehousedt.Columns.Add("Quantity", typeof(decimal));

                        Warehousedt.Columns.Add("BatchWarehouseID", typeof(string));
                        Warehousedt.Columns.Add("BatchWarehousedetailsID", typeof(string));
                        Warehousedt.Columns.Add("BatchID", typeof(string));
                        Warehousedt.Columns.Add("SerialID", typeof(string));


                        Warehousedt.Columns.Add("viewWarehouseName", typeof(string));

                        Warehousedt.Columns.Add("viewBatchNo", typeof(string));
                        Warehousedt.Columns.Add("viewQuantity", typeof(string));
                        Warehousedt.Columns.Add("viewSerialNo", typeof(string));



                        Warehousedt.Columns.Add("viewMFGDate", typeof(DateTime));
                        Warehousedt.Columns.Add("viewExpiryDate", typeof(DateTime));

                        Warehousedt.Columns.Add("Quantitysum", typeof(decimal));
                        Warehousedt.Columns.Add("isnew", typeof(string));
                        Warehousedt.Columns.Add("productid", typeof(string));
                        Warehousedt.Columns.Add("Inventrytype", typeof(string));
                        Warehousedt.Columns.Add("StockID", typeof(string));
                        Warehousedt.Columns.Add("pcslno", typeof(Int32));

                    }



                    DateTime dtmgh = txtmkgdate.Date;
                    DateTime dtexp = txtexpirdate.Date;

                    string isedited = hdnisedited.Value;
                    decimal inputqnty = 0;
                    int noofserial = 0;
                    int oldrowcount = Convert.ToInt32(hdnoldrowcount.Value);
                    int newrowcount = 0;
                    decimal hdntotalqntyPCs = Convert.ToDecimal(hdntotalqntyPC.Value);


                    if (Session["PCWarehouseData"] != null)
                    {
                        DataTable Warehousedts = (DataTable)Session["PCWarehouseData"];

                        newrowcount = Warehousedts.Select("isnew = 'new'").Count<DataRow>();

                        if (newrowcount != null && hdnisserial.Value == "true")
                        {

                            var inputqntys = Warehousedts.Select("WarehouseName= '" + WarehouseName + "' AND BatchNo = '" + BatchName + "' AND isnew = 'new'").Count<DataRow>();
                            if (inputqntys != null && !string.IsNullOrEmpty(Convert.ToString(inputqntys)))
                            {
                                noofserial = Convert.ToInt32(inputqntys + 1);

                            }
                            else
                            {
                                noofserial = 0;
                            }
                        }
                    }

                    if (hidencountforserial.Value != "2")
                    {
                        if (Warehousedt.Rows.Count > 0)
                        {
                            var inputqntys = Warehousedt.Compute("sum(Quantitysum)", "isnew = 'new'");
                            if (inputqntys != null && !string.IsNullOrEmpty(Convert.ToString(inputqntys)))
                            {
                                inputqnty = Convert.ToDecimal(inputqntys);

                            }
                            else
                            {
                                inputqnty = 0;
                            }

                        }
                        //commentout below line for it should not add.
                        if (hdnisserial.Value == "false" && hdniswarehouse.Value == "true" && hdnisbatch.Value == "false")
                        {
                            inputqnty = inputqnty + Convert.ToDecimal(openingstock);
                        }
                        if (hdnisserial.Value == "false" && hdniswarehouse.Value == "true" && hdnisbatch.Value == "true")
                        {
                            inputqnty = inputqnty + Convert.ToDecimal(openingstock);
                        }
                        if (hdnisserial.Value == "false" && hdniswarehouse.Value == "false" && hdnisbatch.Value == "true")
                        {
                            inputqnty = inputqnty + Convert.ToDecimal(openingstock);
                        }


                    }

                    //checking quantity only for warehouse is true.
                    if (inputqnty == 0 && hdnisserial.Value == "false")
                    {
                        inputqnty = Convert.ToDecimal(openingstock);
                    }

                    if (hidencountforserial.Value == "1" && hdnisserial.Value == "true" && noofserial != openingstock && hdnisbatch.Value == "true" && hdniswarehouse.Value == "true")
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssgserialsetdisblebatch"] = Convert.ToString("disable");
                    }
                    if (hidencountforserial.Value == "2" && hdnisserial.Value == "true" && noofserial == openingstock && hdnisbatch.Value == "true" && hdniswarehouse.Value == "true")
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssgserialsetenablebatch"] = Convert.ToString("enable");
                    }
                    if (hidencountforserial.Value == "1" && hdnisserial.Value == "true" && noofserial != openingstock && hdnisbatch.Value == "false" && hdniswarehouse.Value == "true")
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssgserialsetdisblebatch"] = Convert.ToString("disable");
                    }
                    if (hidencountforserial.Value == "2" && hdnisserial.Value == "true" && noofserial == openingstock && hdnisbatch.Value == "false" && hdniswarehouse.Value == "true")
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssgserialsetenablebatch"] = Convert.ToString("enable");
                    }

                    ///batch and serial only
                    if (hidencountforserial.Value == "1" && hdnisserial.Value == "true" && noofserial != openingstock && hdnisbatch.Value == "true" && hdniswarehouse.Value == "false")
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssgserialsetdisblebatch"] = Convert.ToString("disable");
                    }

                    if (hidencountforserial.Value == "2" && hdnisserial.Value == "true" && noofserial == openingstock && hdnisbatch.Value == "true" && hdniswarehouse.Value == "false")
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssgserialsetenablebatch"] = Convert.ToString("enable");
                    }

                    ///end batch and serial only



                    //

                    //if (hdnisserial.Value == "true" && ((Convert.ToDecimal(Convert.ToString((oldrowcount - newrowcount)).Replace('-', '0')) == hdntotalqntyPCs) || (Convert.ToDecimal(Convert.ToString((oldrowcount - newrowcount)).Replace('-', '0')) == (hdntotalqntyPCs * Convert.ToDecimal(hdnbatchchanged.Value)))) && ((hdniswarehouse.Value == "true" && hdnisbatch.Value == "true") && (hdnoldwarehousname.Value == WarehouseName && hdnoldbatchno.Value == BatchName)) || (hdniswarehouse.Value == "true" && hdnisbatch.Value == "false") && (hdnoldwarehousname.Value == WarehouseName) || (hdniswarehouse.Value == "false" && hdnisbatch.Value == "true") && (hdnoldbatchno.Value == BatchName))
                    //{
                    //    GrdWarehousePC.JSProperties["cpupdatemssgserial"] = Convert.ToString("Please make sure quantity and no of Serial are equal or not.");
                    //}
                    if (hdnisserial.Value == "true" && noofserial > openingstock)
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssgserial"] = Convert.ToString("Please make sure quantity and no of Serial are equal or not.");
                    }
                    else
                    {

                        if (inputqnty <= totalopeining || isedited == "true")
                        {

                            if (hdniswarehouse.Value == "true" && hdnisbatch.Value == "true" && hidencountforserial.Value == "2" && hdnisserial.Value == "true" && hdnoldwarehousname.Value == WarehouseName && hdnoldbatchno.Value == BatchName)
                            {
                                if (Convert.ToString(dtmgh) != "1/1/0001 12:00:00 AM" && Convert.ToString(dtexp) != "1/1/0001 12:00:00 AM")
                                {

                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, dtmgh, dtexp, openingstock, "0", "0", "0", "0", "", "", "", SerialName, null, null, 0, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");

                                }
                                else
                                {
                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, null, null, openingstock, "0", "0", "0", "0", "", "", "", SerialName, null, null, 0, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));

                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");

                                }
                            }
                            else if (hdniswarehouse.Value == "false" && hdnisbatch.Value == "false" && hdnisserial.Value == "true")
                            {

                                if (Convert.ToString(dtmgh) != "1/1/0001 12:00:00 AM" && Convert.ToString(dtexp) != "1/1/0001 12:00:00 AM")
                                {

                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, dtmgh, dtexp, openingstock, "0", "0", "0", "0", WarehouseName, BatchName, openingstock, SerialName, dtmgh, dtexp, openingstock, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");
                                }
                                else
                                {
                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, null, null, openingstock, "0", "0", "0", "0", WarehouseName, BatchName, openingstock, SerialName, null, null, openingstock, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");

                                }

                            }
                            else if (hdniswarehouse.Value == "true" && hidencountforserial.Value == "2" && hdnisbatch.Value == "false" && hdnisserial.Value == "true")
                            {
                                if (Convert.ToString(dtmgh) != "1/1/0001 12:00:00 AM" && Convert.ToString(dtexp) != "1/1/0001 12:00:00 AM")
                                {

                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, dtmgh, dtexp, openingstock, "0", "0", "0", "0", "", "", "", SerialName, null, null, 0, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");

                                }
                                else
                                {
                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, null, null, openingstock, "0", "0", "0", "0", "", "", "", SerialName, null, null, 0, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));

                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");

                                }
                            }
                            //batch only with serial

                            else if (hdniswarehouse.Value == "false" && hidencountforserial.Value == "2" && hdnisbatch.Value == "true" && hdnisserial.Value == "true")
                            {
                                if (Convert.ToString(dtmgh) != "1/1/0001 12:00:00 AM" && Convert.ToString(dtexp) != "1/1/0001 12:00:00 AM")
                                {

                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, dtmgh, dtexp, openingstock, "0", "0", "0", "0", "", "", "", SerialName, null, null, 0, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");

                                }
                                else
                                {
                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, null, null, openingstock, "0", "0", "0", "0", "", "", "", SerialName, null, null, 0, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));

                                    GrdWarehousePC.JSProperties["cpinsertmssgserial"] = Convert.ToString("Inserted.");

                                }
                            }
                            //batch only.
                            else
                            {
                                if (Convert.ToString(dtmgh) != "1/1/0001 12:00:00 AM" && Convert.ToString(dtexp) != "1/1/0001 12:00:00 AM")
                                {

                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, dtmgh, dtexp, openingstock, "0", "0", "0", "0", WarehouseName, BatchName, openingstock, SerialName, dtmgh, dtexp, openingstock, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));

                                }
                                else
                                {
                                    Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, null, null, openingstock, "0", "0", "0", "0", WarehouseName, BatchName, openingstock, SerialName, null, null, openingstock, "new", Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));


                                }
                                if (hdnisserial.Value == "true")
                                {
                                    GrdWarehousePC.JSProperties["cpinsertmssg"] = Convert.ToString("Inserted.");
                                }
                                if (hdnisserial.Value == "false" && hdniswarehouse.Value == "true" && hdnisbatch.Value == "true")
                                {
                                    GrdWarehousePC.JSProperties["cpbatchinsertmssg"] = Convert.ToString("Inserted.");
                                }

                            }


                            Session["PCWarehouseData"] = Warehousedt;


                            GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                            GrdWarehousePC.DataBind();
                        }
                        else
                        {
                            GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("You have entered Quantity greater than Stock Quantity. Cannot Proceed.");
                        }
                    }
                }
                else
                {
                    GrdWarehousePC.JSProperties["cpserialuniquemssg"] = Convert.ToString("Duplicate Serial. Cannot Proceed.");
                }
                //
            }
            #endregion
            #region SaveAll
            if (strSplitCommand == "Saveall")
            {
                if (Session["PCWarehouseData"] == null && hdnisolddeleted.Value == "false")
                {
                    if (!string.IsNullOrEmpty(hdnvalue.Value) && !string.IsNullOrEmpty(hdnrate.Value))
                    {

                    }
                    else
                    {
                        GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Nothing to Saved .");
                    }

                }
                else if (Session["PCWarehouseData"] == null && hdnisolddeleted.Value == "true")
                {

                    deleteALL();
                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Saved Successfully.");
                }
                else
                {
                    string ProductID = Convert.ToString(hdfProductIDPC.Value);
                    string stockid = Convert.ToString(hdfstockidPC.Value);
                    string openingstock = Convert.ToString(hdfopeningstockPC.Value);
                    string branchid = Convert.ToString(hdbranchIDPC.Value);
                    string isolddeletd = hdnisolddeleted.Value;

                    int oldrowcount = Convert.ToInt32(hdnoldrowcount.Value);
                    int newrowcount = 0;
                    int updaterows = 0;
                    int deleted = 0;
                    decimal hdntotalqntyPCs = Convert.ToDecimal(hdntotalqntyPC.Value);

                    DataTable Warehousedts = (DataTable)Session["PCWarehouseData"];

                    newrowcount = Warehousedts.Select("isnew = 'new'").Count<DataRow>();
                    updaterows = Warehousedts.Select("isnew = 'Updated'").Count<DataRow>();


                    if (newrowcount != 0 || updaterows != 0 || Session["PCWarehouseDataDelete"] != null)
                    {
                        decimal inputqnty = 0;
                        decimal totalopeining = Convert.ToDecimal(hdfopeningstockPC.Value);
                        decimal oldtotalopeining = Convert.ToDecimal(oldopeningqntity.Value);

                        var inputqntys = Warehousedts.Compute("sum(Quantitysum)", "isnew = 'new'");
                        var updateqnty = Warehousedts.Compute("sum(Quantitysum)", "isnew = 'Updated'");
                        var oldeqnty = Warehousedts.Compute("sum(Quantitysum)", "isnew = 'old'");
                        decimal deletd = Convert.ToDecimal(hdndeleteqnity.Value);

                        if (inputqntys != null && !string.IsNullOrEmpty(Convert.ToString(inputqntys)))
                        {
                            inputqnty = Convert.ToDecimal(inputqntys);

                        }
                        if (updateqnty != null && !string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                        {
                            inputqnty = inputqnty + Convert.ToDecimal(updateqnty);


                        }
                        if (oldeqnty != null && !string.IsNullOrEmpty(Convert.ToString(oldeqnty)))
                        {
                            inputqnty = inputqnty + Convert.ToDecimal(oldeqnty);


                        }
                        //commnet for allowing reduce from main page
                        //if ((oldeqnty != null && !string.IsNullOrEmpty(Convert.ToString(oldeqnty))) || (updateqnty != null && !string.IsNullOrEmpty(Convert.ToString(updateqnty))))
                        //{

                        //    //totalopeining = totalopeining + oldtotalopeining; //commnet for allowing reduce from main page
                        //    //if (hdnisreduing.Value == "true")
                        //    //{
                        //    //    totalopeining = oldtotalopeining;
                        //    //}
                        //    //else
                        //    //{
                        //    //    totalopeining = totalopeining + oldtotalopeining;
                        //    //}
                        //    totalopeining = oldtotalopeining;
                        //}
                        //if (deletd > 0 & isolddeletd == "true")
                        //{
                        //    totalopeining = Convert.ToDecimal(oldopeningqntity.Value) - deletd;
                        //}

                        if (inputqnty == totalopeining)
                        {
                            //if (hdnisserial.Value == "true" && ((Convert.ToDecimal(Convert.ToString((oldrowcount - newrowcount)).Replace('-', '0')) == hdntotalqntyPCs) || (Convert.ToDecimal(Convert.ToString((oldrowcount - newrowcount)).Replace('-', '0')) == (hdntotalqntyPCs * Convert.ToDecimal(hdnbatchchanged.Value)))))
                            if (hdnisserial.Value == "true" && hdnisbatch.Value == "true" && hdniswarehouse.Value == "true")
                            {

                                if (ProductID != "0" && branchid != "0")
                                {
                                    int output = Insertupdatedata(ProductID, stockid, branchid);
                                    if (output > 0)
                                    {
                                        DataTable Warehousedt = new DataTable();
                                        Warehousedt = GetRecord(stockid);
                                        if (Warehousedt.Rows.Count > 0)
                                        {
                                            Session["PCWarehouseData"] = Warehousedt;

                                            GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                                            GrdWarehousePC.DataBind();
                                        }
                                        else
                                        {

                                            Session["PCWarehouseData"] = null;

                                            GrdWarehousePC.DataSource = null;
                                            GrdWarehousePC.DataBind();

                                        }

                                        GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Saved Successfully.");

                                    }

                                }
                                else
                                {
                                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Please try again null parameters.");
                                }
                            }
                            else if (hdnisserial.Value != "true" && hdnisbatch.Value != "true" && hdniswarehouse.Value == "true")
                            {
                                if (ProductID != "0" && branchid != "0")
                                {
                                    int output = Insertupdatedata(ProductID, stockid, branchid);
                                    if (output > 0)
                                    {
                                        DataTable Warehousedt = new DataTable();
                                        Warehousedt = GetRecord(stockid);
                                        if (Warehousedt.Rows.Count > 0)
                                        {
                                            Session["PCWarehouseData"] = Warehousedt;

                                            GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                                            GrdWarehousePC.DataBind();
                                        }
                                        else
                                        {

                                            Session["PCWarehouseData"] = null;

                                            GrdWarehousePC.DataSource = null;
                                            GrdWarehousePC.DataBind();

                                        }

                                        GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Saved Successfully.");

                                    }

                                }
                                else
                                {
                                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Please try again null parameters.");
                                }
                            }
                            else if (hdnisserial.Value != "true" && hdnisbatch.Value == "true")
                            {
                                if (ProductID != "0" && branchid != "0")
                                {
                                    int output = Insertupdatedata(ProductID, stockid, branchid);
                                    if (output > 0)
                                    {
                                        DataTable Warehousedt = new DataTable();
                                        Warehousedt = GetRecord(stockid);
                                        if (Warehousedt.Rows.Count > 0)
                                        {
                                            Session["PCWarehouseData"] = Warehousedt;

                                            GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                                            GrdWarehousePC.DataBind();
                                        }
                                        else
                                        {

                                            Session["PCWarehouseData"] = null;

                                            GrdWarehousePC.DataSource = null;
                                            GrdWarehousePC.DataBind();

                                        }

                                        GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Saved Successfully.");

                                    }

                                }
                                else
                                {
                                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Please try again null parameters.");
                                }

                            }
                            else if (hdnisserial.Value == "true" && hdnisbatch.Value != "true" && hdniswarehouse.Value != "true")
                            {
                                if (ProductID != "0" && branchid != "0")
                                {
                                    int output = Insertupdatedata(ProductID, stockid, branchid);
                                    if (output > 0)
                                    {
                                        DataTable Warehousedt = new DataTable();
                                        Warehousedt = GetRecord(stockid);
                                        if (Warehousedt.Rows.Count > 0)
                                        {
                                            Session["PCWarehouseData"] = Warehousedt;

                                            GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                                            GrdWarehousePC.DataBind();
                                        }
                                        else
                                        {

                                            Session["PCWarehouseData"] = null;

                                            GrdWarehousePC.DataSource = null;
                                            GrdWarehousePC.DataBind();

                                        }

                                        GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Saved Successfully.");

                                    }

                                }
                                else
                                {
                                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Please try again null parameters.");
                                }
                            }
                            else if (hdnisserial.Value == "true" && hdnisbatch.Value != "true" && hdniswarehouse.Value == "true")
                            {

                                if (ProductID != "0" && branchid != "0")
                                {
                                    int output = Insertupdatedata(ProductID, stockid, branchid);
                                    if (output > 0)
                                    {
                                        DataTable Warehousedt = new DataTable();
                                        Warehousedt = GetRecord(stockid);
                                        if (Warehousedt.Rows.Count > 0)
                                        {
                                            Session["PCWarehouseData"] = Warehousedt;

                                            GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                                            GrdWarehousePC.DataBind();
                                        }
                                        else
                                        {

                                            Session["PCWarehouseData"] = null;

                                            GrdWarehousePC.DataSource = null;
                                            GrdWarehousePC.DataBind();

                                        }

                                        GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Saved Successfully.");

                                    }

                                }
                                else
                                {
                                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Please try again null parameters.");
                                }
                            }
                            else if (hdnisserial.Value == "true" && hdnisbatch.Value == "true" && hdniswarehouse.Value != "true")
                            {

                                if (ProductID != "0" && branchid != "0")
                                {
                                    int output = Insertupdatedata(ProductID, stockid, branchid);
                                    if (output > 0)
                                    {
                                        DataTable Warehousedt = new DataTable();
                                        Warehousedt = GetRecord(stockid);
                                        if (Warehousedt.Rows.Count > 0)
                                        {
                                            Session["PCWarehouseData"] = Warehousedt;

                                            GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                                            GrdWarehousePC.DataBind();
                                        }
                                        else
                                        {

                                            Session["PCWarehouseData"] = null;

                                            GrdWarehousePC.DataSource = null;
                                            GrdWarehousePC.DataBind();

                                        }

                                        GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Saved Successfully.");

                                    }

                                }
                                else
                                {
                                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Please try again null parameters.");
                                }
                            }
                            else
                            {
                                GrdWarehousePC.JSProperties["cpupdatemssgserial"] = Convert.ToString("Please make sure quantity and no of Serial are equal or not.");

                            }

                        }
                        else
                        {
                            GrdWarehousePC.JSProperties["cpupdatemssgserial"] = Convert.ToString("You have entered Quantity greater than Opening Quantity. Cannot Proceed.");
                        }

                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(hdnvalue.Value) && !string.IsNullOrEmpty(hdnrate.Value))
                        {
                            int olfdatterows = Warehousedts.Select("isnew = 'old'").Count<DataRow>();
                            if (olfdatterows != 0)
                            {
                                var oldeqnty = Warehousedts.Compute("sum(Quantitysum)", "isnew = 'old'");
                                if (Convert.ToDecimal(hdfopeningstockPC.Value) < Convert.ToDecimal(oldeqnty))
                                {
                                    GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Opening quantity and enterd quantity are mismatch.");
                                }
                                else
                                {

                                }

                            }
                            else
                            {

                            }

                        }
                        else
                        {
                            GrdWarehousePC.JSProperties["cpupdatemssg"] = Convert.ToString("Nothing to Saved .");
                        }

                    }
                }

            }

            #endregion
            #region CheckDataExist
            if (strSplitCommand == "checkdataexist")
            {
                Session["PCWarehouseData"] = null;

                GrdWarehousePC.DataSource = null;

                string strProductname = Convert.ToString(e.Parameters.Split('~')[4]);
                string name = strProductname;
                name = name.Replace("squot", "'");
                name = name.Replace("coma", ",");
                name = name.Replace("slash", "/");

                Session["WarehouseUpdatedData"] = null;
                Session["PCWarehouseDataDelete"] = null;

                GrdWarehousePC.JSProperties["cpproductname"] = Convert.ToString(name);


                string strProductID = Convert.ToString(e.Parameters.Split('~')[1]);

                string stockids = Convert.ToString(e.Parameters.Split('~')[2]);

                string branchid = Convert.ToString(e.Parameters.Split('~')[3]);

                DataTable Warehousedt = new DataTable();
                Warehousedt = GetRecord(stockids);
                if (Warehousedt.Rows.Count > 0)
                {
                    Session["PCWarehouseData"] = Warehousedt;

                    GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                    GrdWarehousePC.DataBind();
                }
                else
                {

                    Session["PCWarehouseData"] = null;

                    GrdWarehousePC.DataSource = null;
                    GrdWarehousePC.DataBind();

                }


            }
            //if (strSplitCommand == "UpdatedataReffresh")
            //{
            //    if (Session["PCWarehouseData"] != null)
            //    {

            //        GrdWarehousePC.DataSource = Session["PCWarehouseData"];
            //        GrdWarehousePC.DataBind();
            //    }
            //}
            #endregion
            #region updatedata
            if (strSplitCommand == "Updatedata")
            {
                string WarehouseID = Convert.ToString(e.Parameters.Split('~')[1]);

                string WarehouseName = Convert.ToString(e.Parameters.Split('~')[2]);

                string BatchName = Convert.ToString(e.Parameters.Split('~')[3]);

                string SerialName = Convert.ToString(e.Parameters.Split('~')[4]);

                string slno = Convert.ToString(e.Parameters.Split('~')[5]);
                string qntity = Convert.ToString(e.Parameters.Split('~')[6]);
                string isviewqntitynull = hdnisviewqntityhas.Value;
                string isserialenable = hdnisserial.Value;
                DateTime expdate = txtexpirdate.Date;
                DateTime mkgdate = txtmkgdate.Date;
                DataTable Warehousedt = new DataTable();

                decimal openingstock = Convert.ToDecimal(txtqnty.Text);
                if (qntity == "0.0000" && openingstock <= 0)
                {
                    qntity = batchqnty.Text;
                    openingstock = Convert.ToDecimal(qntity);
                }

                if (WarehouseID == "null")
                {
                    WarehouseID = "0";
                    WarehouseName = "";
                }
                bool isserialunique = false;
                if (hdnisserial.Value == "true")
                {
                    isserialunique = CheckUniqueSerial(SerialName, slno);
                }
                if (Session["PCWarehouseData"] != null && isserialunique == false)
                {
                    Warehousedt = (DataTable)Session["PCWarehouseData"];
                    DataSet dataSet1 = new DataSet();
                    DataTable dt1 = new DataTable();
                    dt1 = Warehousedt.Copy();
                    dataSet1.Tables.Add(dt1);

                    if (dataSet1.Tables[0].Rows.Count > 0)
                    {
                        DataRow[] customerRow = dataSet1.Tables[0].Select("SrlNo ='" + slno + "'");
                        if (isserialenable == "false" && isviewqntitynull != "false")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;

                            if (Convert.ToString(expdate) != "1/1/0001 12:00:00 AM" && Convert.ToString(mkgdate) != "1/1/0001 12:00:00 AM")
                            {
                                customerRow[0]["viewMFGDate"] = mkgdate;
                                customerRow[0]["viewExpiryDate"] = expdate;
                            }

                            customerRow[0]["viewWarehouseName"] = WarehouseName;
                            customerRow[0]["viewBatchNo"] = BatchName;
                            customerRow[0]["viewSerialNo"] = SerialName;
                            customerRow[0]["viewQuantity"] = qntity;
                            customerRow[0]["Quantitysum"] = openingstock;
                            customerRow[0]["isnew"] = "Updated";
                        }
                        if (isserialenable == "true" && isviewqntitynull == "false")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;

                            if (Convert.ToString(expdate) != "1/1/0001 12:00:00 AM" && Convert.ToString(mkgdate) != "1/1/0001 12:00:00 AM")
                            {
                                customerRow[0]["viewMFGDate"] = mkgdate;
                                customerRow[0]["viewExpiryDate"] = expdate;
                            }

                            customerRow[0]["viewWarehouseName"] = WarehouseName;
                            customerRow[0]["viewBatchNo"] = BatchName;
                            customerRow[0]["viewSerialNo"] = SerialName;
                            customerRow[0]["viewQuantity"] = openingstock;
                            customerRow[0]["Quantitysum"] = openingstock;
                            customerRow[0]["isnew"] = "Updated";
                        }
                        if (isserialenable == "true" && isviewqntitynull == "true")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;



                            customerRow[0]["viewSerialNo"] = SerialName;

                            customerRow[0]["Quantitysum"] = 0;
                            customerRow[0]["isnew"] = "Updated";
                        }
                        if (isserialenable == "false" && isviewqntitynull == "false")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;

                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;
                            if (Convert.ToString(expdate) != "1/1/0001 12:00:00 AM" && Convert.ToString(mkgdate) != "1/1/0001 12:00:00 AM")
                            {
                                customerRow[0]["viewMFGDate"] = mkgdate;
                                customerRow[0]["viewExpiryDate"] = expdate;
                            }
                            customerRow[0]["viewWarehouseName"] = WarehouseName;
                            customerRow[0]["viewBatchNo"] = BatchName;
                            customerRow[0]["viewSerialNo"] = SerialName;
                            customerRow[0]["viewQuantity"] = openingstock;
                            customerRow[0]["Quantitysum"] = openingstock;
                            customerRow[0]["isnew"] = "Updated";
                        }

                        GrdWarehousePC.JSProperties["cpupdateexistingdata"] = Convert.ToString("Saved.");
                    }
                    Warehousedt = null;
                    Warehousedt = dataSet1.Tables[0];
                    Session["PCWarehouseData"] = Warehousedt;

                    Session["WarehouseUpdatedData"] = Warehousedt;

                    GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                    GrdWarehousePC.DataBind();

                }
                else
                {

                    GrdWarehousePC.JSProperties["cpserialuniquemssg"] = Convert.ToString("Duplicate Serial. Cannot Proceed.");
                }
            }

            #endregion
            #region newrowupdate
            if (strSplitCommand == "NewUpdatedata")
            {
                string WarehouseID = Convert.ToString(e.Parameters.Split('~')[1]);

                string WarehouseName = Convert.ToString(e.Parameters.Split('~')[2]);

                string BatchName = Convert.ToString(e.Parameters.Split('~')[3]);

                string SerialName = Convert.ToString(e.Parameters.Split('~')[4]);

                string slno = Convert.ToString(e.Parameters.Split('~')[5]);
                string qntity = Convert.ToString(e.Parameters.Split('~')[6]);
                string isviewqntitynull = hdnisviewqntityhas.Value;
                string isserialenable = hdnisserial.Value;
                DataTable Warehousedt = new DataTable();
                decimal openingstock = Convert.ToDecimal(txtqnty.Text);
                if (qntity == "0.0000" && openingstock <= 0)
                {
                    qntity = batchqnty.Text;
                    openingstock = Convert.ToDecimal(qntity);
                }

                bool isserialunique = false;
                if (hdnisserial.Value == "true")
                {
                    isserialunique = CheckUniqueSerial(SerialName, slno);
                }


                if (Session["PCWarehouseData"] != null && isserialunique == false)
                {
                    Warehousedt = (DataTable)Session["PCWarehouseData"];
                    DataSet dataSet1 = new DataSet();
                    DataTable dt1 = new DataTable();
                    dt1 = Warehousedt.Copy();
                    dataSet1.Tables.Add(dt1);

                    if (dataSet1.Tables[0].Rows.Count > 0)
                    {
                        DataRow[] customerRow = dataSet1.Tables[0].Select("SrlNo ='" + slno + "'");
                        if (isserialenable == "false" && isviewqntitynull != "false")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;

                            customerRow[0]["viewWarehouseName"] = WarehouseName;
                            customerRow[0]["viewBatchNo"] = BatchName;
                            customerRow[0]["viewSerialNo"] = SerialName;
                            customerRow[0]["viewQuantity"] = openingstock;
                            customerRow[0]["Quantitysum"] = openingstock;
                            customerRow[0]["isnew"] = "new";
                        }
                        if (isserialenable == "true" && isviewqntitynull == "false")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;

                            customerRow[0]["viewWarehouseName"] = WarehouseName;
                            customerRow[0]["viewBatchNo"] = BatchName;
                            customerRow[0]["viewSerialNo"] = SerialName;
                            customerRow[0]["viewQuantity"] = openingstock;
                            customerRow[0]["Quantitysum"] = openingstock;
                            customerRow[0]["isnew"] = "new";
                        }
                        if (isserialenable == "true" && isviewqntitynull == "true")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;



                            customerRow[0]["viewSerialNo"] = SerialName;

                            customerRow[0]["Quantitysum"] = 0;
                            customerRow[0]["isnew"] = "new";
                        }
                        if (isserialenable == "false" && isviewqntitynull == "false")
                        {
                            customerRow[0]["WarehouseID"] = WarehouseID;
                            customerRow[0]["WarehouseName"] = WarehouseName;
                            customerRow[0]["BatchNo"] = BatchName;
                            customerRow[0]["SerialNo"] = SerialName;
                            customerRow[0]["Quantity"] = openingstock;

                            customerRow[0]["viewWarehouseName"] = WarehouseName;
                            customerRow[0]["viewBatchNo"] = BatchName;
                            customerRow[0]["viewSerialNo"] = SerialName;
                            customerRow[0]["viewQuantity"] = openingstock;
                            customerRow[0]["Quantitysum"] = openingstock;
                            customerRow[0]["isnew"] = "new";
                        }

                        GrdWarehousePC.JSProperties["cpupdatenewdata"] = Convert.ToString("Saved.");
                    }
                    Warehousedt = null;
                    Warehousedt = dataSet1.Tables[0];
                    Session["PCWarehouseData"] = Warehousedt;

                    GrdWarehousePC.DataSource = Warehousedt.DefaultView;
                    GrdWarehousePC.DataBind();

                }
                else
                {

                    GrdWarehousePC.JSProperties["cpserialuniquemssg"] = Convert.ToString("Duplicate Serial. Cannot Proceed.");
                }

            }
            #endregion
            #region Delete
            if (strSplitCommand == "Delete")
            {
                string slno = Convert.ToString(e.Parameters.Split('~')[1]);

                string viewQuantity = Convert.ToString(e.Parameters.Split('~')[2]);

                string Quantity = Convert.ToString(e.Parameters.Split('~')[3]);
                string warehouseid = Convert.ToString(e.Parameters.Split('~')[4]);
                string batch = Convert.ToString(e.Parameters.Split('~')[5]);
                DataTable Warehousedt = new DataTable();

                // string isviewqntitynull = hdnisviewqntityhas.Value;
                string isserialenable = hdnisserial.Value;
                string isbatch = hdnisbatch.Value;
                string iswarehouse = hdniswarehouse.Value;
                string isolddeletd = hdnisolddeleted.Value;
                if (Session["PCWarehouseData"] != null)
                {
                    Warehousedt = (DataTable)Session["PCWarehouseData"];
                    DataSet dataSet1 = new DataSet();

                    DataTable dt1 = new DataTable();
                    dt1 = Warehousedt.Copy();



                    dataSet1.Tables.Add(dt1);

                    if (dataSet1.Tables[0].Rows.Count > 0)
                    {

                        if (isserialenable == "true" && (viewQuantity == "" || viewQuantity == "0") && isbatch == "true" && iswarehouse == "true")
                        {
                            DataRow[] customerRows = dataSet1.Tables[0].Select("WarehouseID= '" + warehouseid + "' AND BatchNo='" + batch + "'");

                            for (int i = 0; i <= customerRows.Count() - 1; i++)
                            {
                                if (Convert.ToString(customerRows[i]["SrlNo"]) == slno && string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {
                                    customerRows[i]["isnew"] = "DeleteSL";
                                }
                                else if (Convert.ToString(customerRows[i]["SrlNo"]) == slno && !string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {

                                    customerRows[i]["isnew"] = "DeleteWHBTSL";

                                }

                                if (!string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {
                                    customerRows[i]["viewQuantity"] = Convert.ToDecimal(customerRows[i]["Quantitysum"]) - 1;
                                    customerRows[i]["Quantity"] = Convert.ToDecimal(customerRows[i]["Quantity"]) - 1;
                                    customerRows[i]["Quantitysum"] = Convert.ToDecimal(customerRows[i]["Quantitysum"]) - 1;

                                    if (Convert.ToString(customerRows[i]["isnew"]) != "new")
                                    {
                                        customerRows[i]["isnew"] = "Updated";
                                    }
                                    else
                                    {
                                        customerRows[i]["isnew"] = "new";
                                    }

                                }
                                //else
                                //{
                                //    customerRows[i]["Quantity"] = 0;
                                //    customerRows[i]["Quantitysum"] = 0;
                                //}
                            }


                            GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(1);

                        }
                        else if (isserialenable == "true" && (viewQuantity == "" || viewQuantity == "0") && isbatch != "true" && iswarehouse == "true")
                        {
                            DataRow[] customerRows = dataSet1.Tables[0].Select("WarehouseID= '" + warehouseid + "'");

                            for (int i = 0; i <= customerRows.Count() - 1; i++)
                            {
                                if (Convert.ToString(customerRows[i]["SrlNo"]) == slno && string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {
                                    customerRows[i]["isnew"] = "DeleteSL";
                                }
                                else if (Convert.ToString(customerRows[i]["SrlNo"]) == slno && !string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {

                                    customerRows[i]["isnew"] = "DeleteWHSL";


                                }

                                if (!string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {
                                    customerRows[i]["viewQuantity"] = Convert.ToDecimal(customerRows[i]["Quantitysum"]) - 1;
                                    customerRows[i]["Quantity"] = Convert.ToDecimal(customerRows[i]["Quantity"]) - 1;
                                    customerRows[i]["Quantitysum"] = Convert.ToDecimal(customerRows[i]["Quantitysum"]) - 1;

                                    if (Convert.ToString(customerRows[i]["isnew"]) != "new")
                                    {
                                        customerRows[i]["isnew"] = "Updated";
                                    }
                                    else
                                    {
                                        customerRows[i]["isnew"] = "new";
                                    }

                                }
                                else
                                {
                                    customerRows[i]["Quantity"] = 0;
                                    customerRows[i]["Quantitysum"] = 0;
                                }
                            }


                            GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(1);

                        }

                        else if (isserialenable == "true" && (viewQuantity == "" || viewQuantity == "0") && isbatch == "true" && iswarehouse != "true")
                        {
                            DataRow[] customerRows = dataSet1.Tables[0].Select("BatchNo= '" + batch + "'");

                            for (int i = 0; i <= customerRows.Count() - 1; i++)
                            {
                                if (Convert.ToString(customerRows[i]["SrlNo"]) == slno && string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {
                                    customerRows[i]["isnew"] = "DeleteSL";
                                }
                                else if (Convert.ToString(customerRows[i]["SrlNo"]) == slno && !string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {

                                    customerRows[i]["isnew"] = "DeleteWHBTSL";

                                    //customerRows[i]["isnew"] = "DeleteWHBTSL";
                                }
                                if (!string.IsNullOrEmpty(Convert.ToString(customerRows[i]["viewQuantity"])))
                                {
                                    customerRows[i]["viewQuantity"] = Convert.ToDecimal(customerRows[i]["Quantitysum"]) - 1;
                                    customerRows[i]["Quantity"] = Convert.ToDecimal(customerRows[i]["Quantity"]) - 1;
                                    customerRows[i]["Quantitysum"] = Convert.ToDecimal(customerRows[i]["Quantitysum"]) - 1;

                                    if (Convert.ToString(customerRows[i]["isnew"]) != "new")
                                    {
                                        customerRows[i]["isnew"] = "Updated";
                                    }
                                    else
                                    {
                                        customerRows[i]["isnew"] = "new";
                                    }

                                }
                                else
                                {

                                    customerRows[i]["Quantity"] = 0;
                                    customerRows[i]["Quantitysum"] = 0;

                                }

                            }

                            GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(1);


                        }
                        else
                        {

                            DataRow[] customerRow = dataSet1.Tables[0].Select("SrlNo ='" + slno + "'");
                            if (isserialenable != "true" && isbatch == "true" && iswarehouse == "true")
                            {
                                customerRow[0]["isnew"] = "DeleteWHBT";
                                GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(viewQuantity);
                            }
                            if (isserialenable != "true" && isbatch != "true" && iswarehouse == "true")
                            {
                                customerRow[0]["isnew"] = "DeleteWH";
                                GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(Quantity);
                            }
                            if (isserialenable != "true" && isbatch == "true" && iswarehouse != "true")
                            {
                                customerRow[0]["isnew"] = "DeleteWHBT";
                                GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(viewQuantity);
                            }
                            if (isserialenable == "true" && isbatch == "true" && iswarehouse == "true")
                            {
                                customerRow[0]["isnew"] = "DeleteWHBTSL";
                                GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(Quantity);
                            }
                            if (isserialenable == "true" && isbatch != "true" && iswarehouse == "true")
                            {
                                customerRow[0]["isnew"] = "DeleteWHBTSL";
                                GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(1);
                            }
                            if (isserialenable == "true" && isbatch == "true" && iswarehouse != "true")
                            {
                                customerRow[0]["isnew"] = "DeleteWHBTSL";
                                GrdWarehousePC.JSProperties["cpdeletedata"] = Convert.ToString(1);
                            }
                        }

                    }

                    Warehousedt = null;
                    DataTable setdeletedate = new DataTable();
                    DataTable getdeletedate = dataSet1.Tables[0];

                    DataRow[] drs = getdeletedate.Select("isnew = 'DeleteWHBT' OR isnew = 'DeleteWH' OR isnew = 'DeleteWHBT' OR isnew = 'DeleteBTSL' OR isnew = 'DeleteSL' OR isnew = 'DeleteWHSL' OR isnew = 'DeleteWHBTSL'");
                    if (drs.Count() != 0)
                    {
                        if (Session["PCWarehouseDataDelete"] != null)
                        {
                            setdeletedate = drs.CopyToDataTable();
                            DataTable dtmp = (DataTable)Session["PCWarehouseDataDelete"];
                            dtmp.Merge(setdeletedate);
                            Session["PCWarehouseDataDelete"] = dtmp;
                        }
                        else
                        {
                            setdeletedate = drs.CopyToDataTable();
                            Session["PCWarehouseDataDelete"] = setdeletedate;
                        }


                    }


                    DataTable Warehousedts = dataSet1.Tables[0];
                    DataRow[] dr = Warehousedts.Select("isnew = 'new' OR isnew = 'Updated' OR isnew = 'old'");
                    if (dr.Count() > 0)
                    {

                        Warehousedt = dr.CopyToDataTable();
                        Warehousedt.DefaultView.Sort = "SrlNo asc";
                        Warehousedt = Warehousedt.DefaultView.ToTable(true);

                        Session["PCWarehouseData"] = Warehousedt;

                        GrdWarehousePC.DataSource = Session["PCWarehouseData"];
                        GrdWarehousePC.DataBind();
                    }
                    else
                    {
                        Session["PCWarehouseData"] = null;

                        //Warehousedt.Columns.Add("SrlNo", typeof(string));
                        //Warehousedt.Columns.Add("WarehouseID", typeof(string));
                        //Warehousedt.Columns.Add("WarehouseName", typeof(string));

                        //Warehousedt.Columns.Add("BatchNo", typeof(string));
                        //Warehousedt.Columns.Add("SerialNo", typeof(string));

                        //Warehousedt.Columns.Add("MFGDate", typeof(DateTime));
                        //Warehousedt.Columns.Add("ExpiryDate", typeof(DateTime));
                        //Warehousedt.Columns.Add("Quantity", typeof(decimal));

                        //Warehousedt.Columns.Add("BatchWarehouseID", typeof(string));
                        //Warehousedt.Columns.Add("BatchWarehousedetailsID", typeof(string));
                        //Warehousedt.Columns.Add("BatchID", typeof(string));
                        //Warehousedt.Columns.Add("SerialID", typeof(string));


                        //Warehousedt.Columns.Add("viewWarehouseName", typeof(string));

                        //Warehousedt.Columns.Add("viewBatchNo", typeof(string));
                        //Warehousedt.Columns.Add("viewQuantity", typeof(string));
                        //Warehousedt.Columns.Add("viewSerialNo", typeof(string));



                        //Warehousedt.Columns.Add("viewMFGDate", typeof(DateTime));
                        //Warehousedt.Columns.Add("viewExpiryDate", typeof(DateTime));

                        //Warehousedt.Columns.Add("Quantitysum", typeof(decimal));
                        //Warehousedt.Columns.Add("isnew", typeof(string));

                        GrdWarehousePC.DataSource = Warehousedt;
                        GrdWarehousePC.DataBind();



                    }


                }
            #endregion
            }


        }
        public DataTable GetRecord(string stockids)
        {
            Session["PCWarehouseData"] = null;
            DataTable Warehousedt = new DataTable();

            if (Session["PCWarehouseData"] != null)
            {
                Warehousedt = (DataTable)Session["PCWarehouseData"];
            }
            else
            {
                Warehousedt.Columns.Add("SrlNo", typeof(Int32));
                Warehousedt.Columns.Add("WarehouseID", typeof(string));
                Warehousedt.Columns.Add("WarehouseName", typeof(string));

                Warehousedt.Columns.Add("BatchNo", typeof(string));
                Warehousedt.Columns.Add("SerialNo", typeof(string));

                Warehousedt.Columns.Add("MFGDate", typeof(DateTime));
                Warehousedt.Columns.Add("ExpiryDate", typeof(DateTime));
                Warehousedt.Columns.Add("Quantity", typeof(decimal));

                Warehousedt.Columns.Add("BatchWarehouseID", typeof(string));
                Warehousedt.Columns.Add("BatchWarehousedetailsID", typeof(string));
                Warehousedt.Columns.Add("BatchID", typeof(string));
                Warehousedt.Columns.Add("SerialID", typeof(string));


                Warehousedt.Columns.Add("viewWarehouseName", typeof(string));

                Warehousedt.Columns.Add("viewBatchNo", typeof(string));
                Warehousedt.Columns.Add("viewQuantity", typeof(string));
                Warehousedt.Columns.Add("viewSerialNo", typeof(string));



                Warehousedt.Columns.Add("viewMFGDate", typeof(DateTime));
                Warehousedt.Columns.Add("viewExpiryDate", typeof(DateTime));

                Warehousedt.Columns.Add("Quantitysum", typeof(decimal));
                Warehousedt.Columns.Add("isnew", typeof(string));

                Warehousedt.Columns.Add("productid", typeof(string));
                Warehousedt.Columns.Add("Inventrytype", typeof(string));
                Warehousedt.Columns.Add("StockID", typeof(string));
                Warehousedt.Columns.Add("pcslno", typeof(Int32));
            }


            DataTable dts = GetStockWarehouseData(stockids);

            string oldwarehousename = string.Empty;
            string oldbatchname = string.Empty;
            string oldquantity = string.Empty;
            string isoldornew = string.Empty;
            string BatchWarehouseID = string.Empty;

            if (dts.Rows.Count > 0)
            {
                for (int i = 0; i <= dts.Rows.Count - 1; i++)
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["BatchWarehouseID"])) && Convert.ToString(dts.Rows[i]["BatchWarehouseID"]) != "0" && Convert.ToString(ViewState["ActionType"]) == "Edit")
                    {
                        isoldornew = "old";
                    }
                    else
                    {
                        isoldornew = "new";
                    }

                    if (hdnisserial.Value == "true" && i != 0)
                    {
                        oldwarehousename = Convert.ToString(dts.Rows[i - 1]["warehouseID"]);
                        oldbatchname = Convert.ToString(dts.Rows[i - 1]["batchNO"]);
                        oldquantity = Convert.ToString(dts.Rows[i - 1]["Quantitysum"]);
                        BatchWarehouseID = Convert.ToString(dts.Rows[i - 1]["BatchWarehouseID"]);

                        if (oldwarehousename == Convert.ToString(dts.Rows[i]["warehouseID"]) && oldbatchname == Convert.ToString(dts.Rows[i]["batchNO"]) && (oldquantity == Convert.ToString(dts.Rows[i]["Quantitysum"]) || Convert.ToString(dts.Rows[i]["Quantitysum"]) == "0") && BatchWarehouseID == Convert.ToString(dts.Rows[i]["BatchWarehouseID"]))
                        {
                            if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else
                            {

                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                        }
                        //else if (oldwarehousename == Convert.ToString(dts.Rows[i]["warehouseID"]) && oldbatchname == Convert.ToString(dts.Rows[i]["batchNO"]))
                        //{
                        //    if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                        //    {
                        //        Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, "old");
                        //    }
                        //    else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                        //    {
                        //        Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, "old");
                        //    }
                        //    else
                        //    {

                        //        Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, "old");
                        //    }
                        //}
                        else
                        {
                            //string viewqunatity = (Convert.ToString(dts.Rows[i]["viewQuantity"])!=string.Empty)? Convert.ToString(dts.Rows[i]["viewQuantity"]):"0";
                            string viewqunatity = Convert.ToString(dts.Rows[i]["viewQuantity"]);
                            string sumquantiy = (Convert.ToString(dts.Rows[i]["Quantitysum"]) != string.Empty) ? Convert.ToString(dts.Rows[i]["Quantitysum"]) : "0";
                            if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(sumquantiy), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), viewqunatity, Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(sumquantiy), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(sumquantiy), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), viewqunatity, Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(sumquantiy), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else
                            {

                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), viewqunatity, Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToString(sumquantiy), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }

                        }

                    }
                    else if (hdnisserial.Value == "false" && hdniswarehouse.Value == "true" && hdnisbatch.Value == "true")
                    {
                        //string oldquantity=string.Empty;
                        if (i != 0)
                        {
                            oldwarehousename = Convert.ToString(dts.Rows[i - 1]["warehouseID"]);
                            oldquantity = Convert.ToString(dts.Rows[i - 1]["viewQuantity"]);
                        }



                        if (oldwarehousename == Convert.ToString(dts.Rows[i]["warehouseID"]))
                        {
                            if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else
                            {

                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                        }
                        else
                        {
                            if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else
                            {

                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                            }
                        }

                    }
                    else
                    {

                        if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                        {
                            Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                        }
                        else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                        {
                            Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(hdfProductIDPC.Value), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                        }
                        else
                        {

                            Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToString(dts.Rows[i]["viewQuantity"]), isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(hdfstockidPC.Value), Convert.ToInt32(hdnpcslno.Value));
                        }

                    }


                    //Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, "", "", openingstock, "isnew");

                }
            }

            hdnoldrowcount.Value = Convert.ToString(Warehousedt.Rows.Count);

            return Warehousedt;
        }
        private int Insertupdatedata(string ProductID, string stockid, string branchid)
        {
            DataSet dsEmail = new DataSet();

            string IsserialActive = "false";

            int newrowcount = 0;

            #region Insert

            DataTable temtable = new DataTable();
            DataTable temtable2 = new DataTable();
            DataTable temtable23 = new DataTable();
            if (Session["PCWarehouseData"] != null)
            {
                DataTable Warehousedt = (DataTable)Session["PCWarehouseData"];

                temtable = Warehousedt.DefaultView.ToTable(false, "SrlNo", "BatchWarehouseID", "BatchWarehousedetailsID", "BatchID", "SerialID", "WarehouseID", "WarehouseName", "BatchNo", "SerialNo", "MFGDate", "ExpiryDate", "Quantitysum", "isnew", "viewQuantity", "productid", "Inventrytype", "StockID", "pcslno");

                if (Session["Pcwarehousedetailstemp"] != null)
                {
                    temtable23 = (DataTable)Session["Pcwarehousedetailstemp"];
                    DataRow[] rows;
                    rows = temtable23.Select("pcslno = '" + hdnpcslno.Value + "'");  //'UserName' is ColumnName
                    foreach (DataRow row in rows)
                        temtable23.Rows.Remove(row);

                    temtable23.Merge(temtable);
                    Session["Pcwarehousedetailstemp"] = temtable23;
                }
                else
                {
                    Session["Pcwarehousedetailstemp"] = temtable;
                }

            }


            #endregion
            #region Update
            if (Session["PCWarehouseData"] != null)
            {
                DataTable dt = new DataTable();
                DataTable Warehousedtups = (DataTable)Session["PCWarehouseData"];
                DataRow[] dr = Warehousedtups.Select("isnew = 'Updated'");
                if (dr.Count() != 0)
                {
                    dt = dr.CopyToDataTable();
                    if (Session["PcwarehousedetailstempUpdate"] != null)
                    {
                        temtable23 = (DataTable)Session["PcwarehousedetailstempUpdate"];
                        DataRow[] rows;
                        rows = temtable23.Select("pcslno = '" + hdnpcslno.Value + "'");  //'UserName' is ColumnName
                        foreach (DataRow row in rows)
                            temtable23.Rows.Remove(row);

                        temtable23.Merge(dt);
                        Session["PcwarehousedetailstempUpdate"] = temtable23;
                    }
                    else
                    {
                        Session["PcwarehousedetailstempUpdate"] = dt;
                    }


                }
            }

            #endregion
            #region delete

            if (Session["PCWarehouseDataDelete"] != null)
            {
                DataTable dt = new DataTable();
                DataTable Warehousedtups = (DataTable)Session["PCWarehouseDataDelete"];
                DataRow[] dr = Warehousedtups.Select("isnew = 'DeleteWHBT' OR isnew = 'DeleteWH' OR isnew = 'DeleteWHBT' OR isnew = 'DeleteBTSL' OR isnew = 'DeleteSL' OR isnew = 'DeleteWHSL' OR isnew = 'DeleteWHBTSL'");
                if (dr.Count() != 0)
                {
                    dt = dr.CopyToDataTable();
                    if (Session["PcwarehousedetailstempDelete"] != null)
                    {
                        temtable23 = (DataTable)Session["PcwarehousedetailstempDelete"];
                        DataRow[] rows;
                        rows = temtable23.Select("pcslno = '" + hdnpcslno.Value + "'");  //'UserName' is ColumnName
                        foreach (DataRow row in rows)
                            temtable23.Rows.Remove(row);

                        temtable23.Merge(dt);
                        Session["PcwarehousedetailstempDelete"] = temtable23;
                    }
                    else
                    {
                        Session["PcwarehousedetailstempDelete"] = dt;
                    }


                }

                //deleteALL(stockid);

            }
            #endregion

            return 1;


        }
        protected void GrdWarehousePC_DataBinding(object sender, EventArgs e)
        {
            if (Session["PCWarehouseData"] != null)
            {
                DataTable Warehousedt = (DataTable)Session["PCWarehouseData"];

                GrdWarehousePC.DataSource = Warehousedt;
            }
        }
        protected void CmbWarehouse_Callback(object sender, CallbackEventArgsBase e)
        {
            string WhichCall = e.Parameter.Split('~')[0];

            if (WhichCall == "BindWarehouse")
            {
                DataTable dt = GetWarehouseData();
                GetAvailableStock();

                CmbWarehouse.Items.Clear();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    CmbWarehouse.Items.Add(Convert.ToString(dt.Rows[i]["WarehouseName"]), Convert.ToString(dt.Rows[i]["WarehouseID"]));
                }
                if (hdndefaultID != null || hdndefaultID.Value != "")
                    CmbWarehouse.Value = hdndefaultID.Value;
            }

        }
        public DataTable GetWarehouseData()
        {
            string strBranch = Convert.ToString(ddl_Branch.SelectedValue);

            DataTable dt = new DataTable();
            dt = oDBEngine.GetDataTable("select  bui_id as WarehouseID,bui_Name as WarehouseName from tbl_master_building Where IsNull(bui_BranchId,0) in ('0','" + strBranch + "') order by bui_Name");
            return dt;
        }
        public void GetAvailableStock()
        {
            //DataTable dt2 = oDBEngine.GetDataTable("select ISnull(ISNULL(tblwarehous.StockBranchWarehouse_StockIn,0)- isnull(tblwarehous.StockBranchWarehouse_StockOut,0),0) as branchopenstock from Trans_StockBranchWarehouse tblwarehous where tblwarehous.StockBranchWarehouse_StockId=" + hdfstockidPC.Value + " and tblwarehous.StockBranchWarehouse_CompanyId='" + Convert.ToString(Session["LastCompany"]) + "' and tblwarehous.StockBranchWarehouse_FinYear='" + Convert.ToString(Session["LastFinYear"]) + "' and tblwarehous.StockBranchWarehouse_BranchId=" + hdbranchIDPC.Value + "");
            try
            {
                DataTable dt2 = oDBEngine.GetDataTable("Select dbo.fn_CheckAvailableStockOpening(" + hdbranchIDPC.Value + ",'" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]) + "'," + hdfstockidPC.Value + ") as branchopenstock");

                if (dt2.Rows.Count > 0)
                {
                    CmbWarehouse.JSProperties["cpstock"] = Convert.ToString(dt2.Rows[0]["branchopenstock"]);
                }
                else
                {

                    CmbWarehouse.JSProperties["cpstock"] = "0.0000";
                }
            }
            catch (Exception ex)
            {

            }
        }
        public DataTable GetStockWarehouseData(string stockid)
        {
            DataTable dt = new DataTable();
            DataTable dt2 = new DataTable();
            if (Convert.ToString(ViewState["ActionType"]) == "Edit")
            {
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_StockGetPCwarehousentry", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@StockID", Convert.ToInt32(stockid));
                cmd.Parameters.AddWithValue("@ProductID", Convert.ToInt32(hdfProductIDPC.Value));
                cmd.Parameters.AddWithValue("@branchID", Convert.ToInt32(hdbranchIDPC.Value));
                cmd.Parameters.AddWithValue("@compnay", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@Finyear", Convert.ToString(Session["LastFinYear"]));
                cmd.Parameters.AddWithValue("@PCNumber", Convert.ToString(Session["PurchaseChallan_Id"]));
                cmd.Parameters.AddWithValue("@ISfromPO", "MainWarehouse");
                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);
                cmd.Dispose();
                con.Dispose();

                if (dsInst.Tables != null)
                {


                    if (Session["Pcwarehousedetailstemp"] != null)
                    {
                        DataTable Warehousedtss = (DataTable)Session["Pcwarehousedetailstemp"];

                        DataRow[] dr = Warehousedtss.Select("productid = '" + Convert.ToString(hdfProductIDPC.Value) + "' AND pcslno = '" + hdnpcslno.Value + "'");
                        if (dr.Count() > 0)
                        {

                            Warehousedtss = dr.CopyToDataTable();
                            Warehousedtss.DefaultView.Sort = "SrlNo asc";
                            Warehousedtss = Warehousedtss.DefaultView.ToTable(true);

                            Session["PCWarehouseDatabyslno"] = Warehousedtss;

                            dt2 = (DataTable)Session["PCWarehouseDatabyslno"];
                            DataTable dtmp = dsInst.Tables[0];

                            if (Session["PcwarehousedetailstempUpdate"] != null)
                            {
                                DataRow[] drs = Warehousedtss.Select("productid = '" + Convert.ToString(hdfProductIDPC.Value) + "' AND pcslno = '" + hdnpcslno.Value + "' AND isnew='Updated'");
                                if (drs.Count() <= 0)
                                {
                                    dt2.Merge(dtmp);
                                }
                            }

                            dt = dt2;

                        }
                        else
                        {
                            dt = dsInst.Tables[0];
                        }

                    }
                    else
                    {
                        dt = dsInst.Tables[0];
                    }

                }
            }
            else if (Convert.ToString(ViewState["ActionType"]) != "Edit")
            {
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_StockGetPCwarehousentry", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@StockID", Convert.ToInt32(stockid));
                cmd.Parameters.AddWithValue("@ProductID", Convert.ToInt32(hdfProductIDPC.Value));
                cmd.Parameters.AddWithValue("@branchID", Convert.ToInt32(hdbranchIDPC.Value));
                cmd.Parameters.AddWithValue("@compnay", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@Finyear", Convert.ToString(Session["LastFinYear"]));
                cmd.Parameters.AddWithValue("@PCNumber", Convert.ToString(hdnPOnumber.Value));
                cmd.Parameters.AddWithValue("@ISfromPO", "MainPurchaseOrderWarehouse");
                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);
                cmd.Dispose();
                con.Dispose();

                if (dsInst.Tables != null)
                {

                    if (Session["Pcwarehousedetailstemp"] != null)
                    {
                        DataTable Warehousedtss = (DataTable)Session["Pcwarehousedetailstemp"];

                        DataRow[] dr = Warehousedtss.Select("productid = '" + Convert.ToString(hdfProductIDPC.Value) + "' AND pcslno = '" + hdnpcslno.Value + "'");
                        if (dr.Count() > 0)
                        {

                            Warehousedtss = dr.CopyToDataTable();
                            Warehousedtss.DefaultView.Sort = "SrlNo asc";
                            Warehousedtss = Warehousedtss.DefaultView.ToTable(true);

                            Session["PCWarehouseDatabyslno"] = Warehousedtss;

                            dt2 = (DataTable)Session["PCWarehouseDatabyslno"];
                            DataTable dtmp = dsInst.Tables[0];

                            if (Session["PcwarehousedetailstempUpdate"] != null)
                            {
                                DataRow[] drs = Warehousedtss.Select("productid = '" + Convert.ToString(hdfProductIDPC.Value) + "' AND pcslno = '" + hdnpcslno.Value + "' AND isnew='Updated'");
                                if (drs.Count() <= 0)
                                {
                                    dt2.Merge(dtmp);
                                }
                            }

                            dt = dt2;

                        }
                        else
                        {
                            dt = dsInst.Tables[0];
                        }

                    }
                    else
                    {
                        dt = dsInst.Tables[0];
                    }

                }
            }
            else if (Session["Pcwarehousedetailstemp"] != null)
            {
                DataTable Warehousedtss = (DataTable)Session["Pcwarehousedetailstemp"];

                DataRow[] dr = Warehousedtss.Select("productid = '" + Convert.ToString(hdfProductIDPC.Value) + "' AND pcslno = '" + hdnpcslno.Value + "'");
                if (dr.Count() > 0)
                {

                    Warehousedtss = dr.CopyToDataTable();
                    Warehousedtss.DefaultView.Sort = "SrlNo asc";
                    Warehousedtss = Warehousedtss.DefaultView.ToTable(true);

                    Session["PCWarehouseDatabyslno"] = Warehousedtss;

                    dt = (DataTable)Session["PCWarehouseDatabyslno"];

                }

            }

            return dt;
        }
        private string getinventry()
        {

            string inventryType = string.Empty;
            if (hdniswarehouse.Value == "true")
            {
                inventryType = "WH";

            }
            if (hdnisbatch.Value == "true")
            {

                inventryType += "BT";
            }
            if (hdnisserial.Value == "true")
            {
                inventryType += "SL";

            }
            return inventryType;
        }
        public string SetVisibilityStock(object container)
        {
            string vs = string.Empty;
            GridViewDataItemTemplateContainer c = container as GridViewDataItemTemplateContainer;
            if (!string.IsNullOrEmpty(Convert.ToString(c.KeyValue)))
            {
                //if (isexist)
                //{
                vs = "display:block";
                //}
                //else
                //{
                //    vs = "display:none";
                //}

            }
            else
            {
                vs = "display:block";
            }

            return vs;


        }
        public void deleteALL()
        {

            #region delete

            if (Session["PcwarehousedetailstempDelete"] != null)
            {
                string stockid = string.Empty;
                DataTable Warehousedtups = (DataTable)Session["PcwarehousedetailstempDelete"];
                for (int i = 0; i <= Warehousedtups.Rows.Count - 1; i++)
                {
                    if (!string.IsNullOrEmpty(Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"])) && Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) != "0")
                    {
                        stockid = Convert.ToString(Warehousedtups.Rows[i]["StockID"]);

                        if (Convert.ToString(Warehousedtups.Rows[i]["isnew"]) == "DeleteSL")
                        {
                            string sqls = "delete Trans_StockSerialMapping where Stock_MapId=" + Convert.ToString(Warehousedtups.Rows[i]["SerialID"]) + " " +
                                               " update Trans_Stock set Stock_In=isnull(Stock_In,0)-1," +
                                       " Stock_ModifiedDate=GETDATE() WHERE Stock_ID=" + stockid + "	";

                            oDBEngine.GetDataTable(sqls);
                        }
                        else if (Convert.ToString(Warehousedtups.Rows[i]["isnew"]) == "DeleteWHBTSL")
                        {
                            var updateqnty = Warehousedtups.Compute("sum(Quantitysum)", "isnew = 'DeleteWHBTSL' AND BatchWarehouseID='" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) + "'");

                            string sqls = "delete from Trans_StockBranchWarehouseDetails where StockBranchWarehouseDetail_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehousedetailsID"]) + " " +
                                          " delete from Trans_StockBranchWarehouse where StockBranchWarehouse_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) + " " +
                                          " delete from Trans_StockBranchBatch where StockBranchWarehouseDetail_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehousedetailsID"]) + " " +
                                          " delete from Trans_StockSerialMapping where Stock_BranchBatchId=" + Convert.ToString(Warehousedtups.Rows[i]["BatchID"]) + " update Trans_Stock set Stock_In=isnull(Stock_In,0)-" + updateqnty + "," +
                                       " Stock_ModifiedDate=GETDATE() WHERE Stock_ID=" + stockid + "	";
                            if (!string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            {
                                oDBEngine.GetDataTable(sqls);
                            }

                        }
                        else if (Convert.ToString(Warehousedtups.Rows[i]["isnew"]) == "DeleteWHSL")
                        {

                            var updateqnty = Warehousedtups.Compute("sum(Quantitysum)", "isnew = 'DeleteWHSL' AND BatchWarehouseID='" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) + "'");

                            string sqls = "delete from Trans_StockBranchWarehouseDetails where StockBranchWarehouseDetail_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehousedetailsID"]) + " " +
                                          " delete from Trans_StockBranchWarehouse where StockBranchWarehouse_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) + " " +
                                          " delete from Trans_StockBranchBatch where StockBranchWarehouseDetail_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehousedetailsID"]) + " " +
                                          " delete from Trans_StockSerialMapping where Stock_BranchBatchId=" + Convert.ToString(Warehousedtups.Rows[i]["BatchID"]) + " update Trans_Stock set Stock_In=isnull(Stock_In,0)-" + updateqnty + "," +
                                       " Stock_ModifiedDate=GETDATE() WHERE Stock_ID=" + stockid + "	";
                            if (!string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            {
                                oDBEngine.GetDataTable(sqls);
                            }


                        }
                        else if (Convert.ToString(Warehousedtups.Rows[i]["isnew"]) == "DeleteWHBT")
                        {
                            string sqls = string.Empty;
                            var updateqnty = Warehousedtups.Compute("sum(Quantitysum)", "isnew = 'DeleteWHBT' AND BatchWarehouseID='" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) + "'");

                            if (string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            { updateqnty = 0.0; }


                            if (stockid != "0")
                            {
                                DataSet dsEmail = new DataSet();

                                String conn = ConfigurationSettings.AppSettings["DBConnectionDefault"];
                                SqlConnection con = new SqlConnection(conn);
                                SqlCommand cmd3 = new SqlCommand("prc_StockPchallanwarehousbatchDelete", con);
                                cmd3.CommandType = CommandType.StoredProcedure;

                                cmd3.Parameters.AddWithValue("@compnay", Convert.ToString(Session["LastCompany"]));
                                cmd3.Parameters.AddWithValue("@Finyear", Convert.ToString(Session["LastFinYear"]));
                                cmd3.Parameters.AddWithValue("@StockID", Convert.ToInt32(stockid));

                                cmd3.Parameters.AddWithValue("@BatchWarehouseID", Convert.ToInt32(Warehousedtups.Rows[i]["BatchWarehouseID"]));
                                cmd3.Parameters.AddWithValue("@BatchWarehousedetailsID", Convert.ToInt32(Warehousedtups.Rows[i]["BatchWarehousedetailsID"]));
                                cmd3.Parameters.AddWithValue("@BatchID", Convert.ToInt32(Warehousedtups.Rows[i]["BatchID"]));


                                //cmd3.Parameters.AddWithValue("@branchID", Convert.ToInt32(hdnselectedbranch.Value));
                                cmd3.Parameters.AddWithValue("@modifiedBy", Convert.ToInt32(HttpContext.Current.Session["userid"]));
                                cmd3.Parameters.AddWithValue("@rate", Convert.ToDecimal(hdnrate.Value));
                                cmd3.Parameters.AddWithValue("@updateqnty", Convert.ToDecimal(updateqnty));

                                SqlParameter output = new SqlParameter("@ReturnValue", SqlDbType.Int);
                                output.Direction = ParameterDirection.Output;
                                cmd3.Parameters.Add(output);
                                cmd3.CommandTimeout = 0;
                                SqlDataAdapter Adap = new SqlDataAdapter();
                                Adap.SelectCommand = cmd3;
                                Adap.Fill(dsEmail);
                                dsEmail.Clear();
                                cmd3.Dispose();
                                con.Dispose();
                                GC.Collect();
                            }
                        }
                        else if (Convert.ToString(Warehousedtups.Rows[i]["isnew"]) == "DeleteWH")
                        {

                            var updateqnty = Warehousedtups.Compute("sum(Quantity)", "isnew = 'DeleteWH' AND BatchWarehouseID='" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) + "'");

                            string sqls = "delete from Trans_StockBranchWarehouseDetails where StockBranchWarehouseDetail_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehousedetailsID"]) + " " +
                                          " delete from Trans_StockBranchWarehouse where StockBranchWarehouse_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehouseID"]) + " " +
                                          " delete from Trans_StockBranchBatch where StockBranchWarehouseDetail_Id=" + Convert.ToString(Warehousedtups.Rows[i]["BatchWarehousedetailsID"]) + "  update Trans_Stock set Stock_In=isnull(Stock_In,0)-" + updateqnty + "," +
                                       " Stock_ModifiedDate=GETDATE() WHERE Stock_ID=" + stockid + "	";
                            if (!string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            {
                                oDBEngine.GetDataTable(sqls);
                            }
                        }
                    }


                }


            }
            #endregion

        }
        public bool CheckUniqueSerial(string serial, string slno)
        {
            bool ISexist = false;

            if (Session["PCWarehouseData"] != null && hdnisserial.Value == "true")
            {
                DataTable Warehousedts = (DataTable)Session["PCWarehouseData"];
                //
                DataRow[] dr = Warehousedts.Select(" productid = '" + Convert.ToString(hdfProductIDPC.Value) + "'and isnew = 'new' OR isnew = 'Updated' OR isnew = 'old'");

                if (dr.Count() > 0)
                {
                    DataTable dt = dr.CopyToDataTable();
                    if (dt.Rows.Count > 0)
                    {
                        for (int i = 0; i <= dt.Rows.Count - 1; i++)
                        {
                            if (slno == "new")
                            {
                                if (Convert.ToString(dt.Rows[i]["viewSerialNo"]).ToUpper() == serial.ToUpper())
                                {
                                    ISexist = true;
                                    break;
                                }
                            }
                            else
                            {
                                if (Convert.ToString(dt.Rows[i]["viewSerialNo"]).ToUpper() == serial.ToUpper() && Convert.ToString(dt.Rows[i]["SrlNo"]) != slno)
                                {
                                    ISexist = true;
                                    break;
                                }
                            }


                        }

                    }
                }


            }
            return ISexist;

        }
        private int Insertwaredataalldata(string ProductID, string stockid, string branchid)
        {
            DataSet dsEmail = new DataSet();
            string inventryType = string.Empty;
            string IsserialActive = "false";

            int newrowcount = 0;

            #region Insert
            String conn = ConfigurationSettings.AppSettings["DBConnectionDefault"];
            SqlConnection con = new SqlConnection(conn);
            SqlCommand cmd3 = new SqlCommand("prc_StockPChallanwarehousentry", con);
            cmd3.CommandType = CommandType.StoredProcedure;

            cmd3.Parameters.AddWithValue("@compnay", Convert.ToString(Session["LastCompany"]));
            cmd3.Parameters.AddWithValue("@Finyear", Convert.ToString(Session["LastFinYear"]));
            cmd3.Parameters.AddWithValue("@StockID", Convert.ToInt32(stockid));
            cmd3.Parameters.AddWithValue("@ProductID", Convert.ToInt32(ProductID));
            cmd3.Parameters.AddWithValue("@branchID", Convert.ToInt32(branchid));
            cmd3.Parameters.AddWithValue("@createdBy", Convert.ToInt32(HttpContext.Current.Session["userid"]));
            cmd3.Parameters.AddWithValue("@PCNumber", Convert.ToInt32(HttpContext.Current.Session["userid"]));
            cmd3.Parameters.AddWithValue("@totalqntity", Convert.ToString(hdntotalqntyPC.Value));


            if (hdniswarehouse.Value == "true")
            {
                inventryType = "WH";

            }
            if (hdnisbatch.Value == "true")
            {

                inventryType += "BT";
            }
            if (hdnisserial.Value == "true")
            {
                inventryType += "SL";
                IsserialActive = "true";
            }

            cmd3.Parameters.AddWithValue("@IsSerialActive", IsserialActive);


            cmd3.Parameters.AddWithValue("@Inventrytype", inventryType);

            DataTable temtable = new DataTable();
            DataTable temtable2 = new DataTable();
            DataTable temtable23 = new DataTable();
            if (Session["PCWarehouseData"] != null)
            {
                DataTable Warehousedt = (DataTable)Session["PCWarehouseData"];

                temtable = Warehousedt.DefaultView.ToTable(false, "SrlNo", "BatchWarehouseID", "BatchWarehousedetailsID", "BatchID", "SerialID", "WarehouseID", "WarehouseName", "BatchNo", "SerialNo", "MFGDate", "ExpiryDate", "Quantitysum", "productid", "Inventrytype", "StockID", "isnew");
                cmd3.Parameters.AddWithValue("@udt_StockOpeningwarehousentried", temtable);
            }
            if (Session["PCWarehouseDataDelete"] != null)
            {
                DataTable Warehousedts = (DataTable)Session["PCWarehouseDataDelete"];

                temtable2 = Warehousedts.DefaultView.ToTable(false, "SrlNo", "BatchWarehouseID", "BatchWarehousedetailsID", "BatchID", "SerialID", "WarehouseID", "WarehouseName", "BatchNo", "SerialNo", "MFGDate", "ExpiryDate", "Quantity", "isnew");
                cmd3.Parameters.AddWithValue("@udt_StockOpeningwarehousentrieDelete", null);
            }

            #endregion

            return 1;


        }
        public void InitGetStockWarehouseData(string stockid, string productid, string branchid)
        {
            DataTable Warehousedt = new DataTable();
            if (Session["PcwarehousedetailstempCheckUpdate"] != null)
            {
                Warehousedt = (DataTable)Session["PcwarehousedetailstempCheckUpdate"];
            }
            else
            {
                Warehousedt.Columns.Add("SrlNo", typeof(Int32));
                Warehousedt.Columns.Add("WarehouseID", typeof(string));
                Warehousedt.Columns.Add("WarehouseName", typeof(string));

                Warehousedt.Columns.Add("BatchNo", typeof(string));
                Warehousedt.Columns.Add("SerialNo", typeof(string));

                Warehousedt.Columns.Add("MFGDate", typeof(DateTime));
                Warehousedt.Columns.Add("ExpiryDate", typeof(DateTime));
                Warehousedt.Columns.Add("Quantity", typeof(decimal));

                Warehousedt.Columns.Add("BatchWarehouseID", typeof(string));
                Warehousedt.Columns.Add("BatchWarehousedetailsID", typeof(string));
                Warehousedt.Columns.Add("BatchID", typeof(string));
                Warehousedt.Columns.Add("SerialID", typeof(string));


                Warehousedt.Columns.Add("viewWarehouseName", typeof(string));

                Warehousedt.Columns.Add("viewBatchNo", typeof(string));
                Warehousedt.Columns.Add("viewQuantity", typeof(string));
                Warehousedt.Columns.Add("viewSerialNo", typeof(string));



                Warehousedt.Columns.Add("viewMFGDate", typeof(DateTime));
                Warehousedt.Columns.Add("viewExpiryDate", typeof(DateTime));

                Warehousedt.Columns.Add("Quantitysum", typeof(decimal));
                Warehousedt.Columns.Add("isnew", typeof(string));

                Warehousedt.Columns.Add("productid", typeof(string));
                Warehousedt.Columns.Add("Inventrytype", typeof(string));
                Warehousedt.Columns.Add("StockID", typeof(string));
                Warehousedt.Columns.Add("pcslno", typeof(Int32));
            }

            DataTable dt = new DataTable();
            DataTable dt2 = new DataTable();
            if (Convert.ToString(ViewState["ActionType"]) == "Edit")
            {
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("prc_StockGetPCwarehousentry", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@StockID", Convert.ToInt32(stockid));
                cmd.Parameters.AddWithValue("@ProductID", Convert.ToInt32(productid));
                cmd.Parameters.AddWithValue("@branchID", Convert.ToInt32(branchid));
                cmd.Parameters.AddWithValue("@compnay", Convert.ToString(Session["LastCompany"]));
                cmd.Parameters.AddWithValue("@Finyear", Convert.ToString(Session["LastFinYear"]));
                cmd.Parameters.AddWithValue("@PCNumber", Convert.ToString(Session["PurchaseChallan_Id"]));
                cmd.Parameters.AddWithValue("@ISfromPO", "MainWarehouse");
                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);
                cmd.Dispose();
                con.Dispose();

                if (dsInst.Tables != null)
                {
                    if (Session["PcwarehousedetailstempCheckUpdate"] != null)
                    {
                        DataTable Warehousedtss = (DataTable)Session["PcwarehousedetailstempCheckUpdate"];

                        DataTable dtmp = Warehousedtss;
                        DataTable dts = dsInst.Tables[0];
                        for (int i = 0; i <= dts.Rows.Count - 1; i++)
                        {
                            string isoldornew = string.Empty;
                            if (!string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["BatchWarehouseID"])) && Convert.ToString(dts.Rows[i]["BatchWarehouseID"]) != "0" && Convert.ToString(ViewState["ActionType"]) == "Edit")
                            {
                                isoldornew = "old";
                            }
                            else
                            {
                                isoldornew = "new";
                            }


                            if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                            {
                                dtmp.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(stockid), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                            {
                                dtmp.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(stockid), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else
                            {

                                dtmp.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(stockid), Convert.ToInt32(hdnpcslno.Value));
                            }
                        }

                        Warehousedtss.Merge(dtmp);
                        Session["PcwarehousedetailstempCheckUpdate"] = Warehousedtss;
                    }
                    else
                    {
                        DataTable dts = dsInst.Tables[0];
                        for (int i = 0; i <= dts.Rows.Count - 1; i++)
                        {
                            string isoldornew = string.Empty;
                            if (!string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["BatchWarehouseID"])) && Convert.ToString(dts.Rows[i]["BatchWarehouseID"]) != "0" && Convert.ToString(ViewState["ActionType"]) == "Edit")
                            {
                                isoldornew = "old";
                            }
                            else
                            {
                                isoldornew = "new";
                            }


                            if (Convert.ToString(dts.Rows[i]["MfgDate"]) == "1/1/1900 12:00:00 AM")
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(stockid), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else if (string.IsNullOrEmpty(Convert.ToString(dts.Rows[i]["MfgDate"])))
                            {
                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), null, null, Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(stockid), Convert.ToInt32(hdnpcslno.Value));
                            }
                            else
                            {

                                Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, Convert.ToString(dts.Rows[i]["warehouseID"]).Trim(), Convert.ToString(dts.Rows[i]["WarehouseName"]), Convert.ToString(dts.Rows[i]["batchNO"]), Convert.ToString(dts.Rows[i]["serialno"]), Convert.ToDateTime(dts.Rows[i]["MfgDate"]), Convert.ToDateTime(dts.Rows[i]["ExpiryDate"]), Convert.ToDecimal(dts.Rows[i]["Quantitysum"]), Convert.ToString(dts.Rows[i]["BatchWarehouseID"]), Convert.ToString(dts.Rows[i]["BatchWarehousedetailsID"]), Convert.ToString(dts.Rows[i]["BatchID"]), Convert.ToString(dts.Rows[i]["SerialID"]), "", "", "", Convert.ToString(dts.Rows[i]["serialno"]), null, null, 0, isoldornew, Convert.ToString(dts.Rows[i]["productid"]), getinventry(), Convert.ToString(stockid), Convert.ToInt32(hdnpcslno.Value));
                            }
                        }

                        //Warehousedt.Rows.Add(Warehousedt.Rows.Count + 1, WarehouseID, WarehouseName, BatchName, SerialName, "", "", openingstock, "isnew");


                        Session["PcwarehousedetailstempCheckUpdate"] = Warehousedt;

                    }

                }
            }

        }
        private int updatewarehouse()
        {
            if (Session["PcwarehousedetailstempUpdate"] != null)
            {
                DataTable dt = new DataTable();
                DataTable Warehousedtups = (DataTable)Session["PcwarehousedetailstempUpdate"];
                DataRow[] dr = Warehousedtups.Select("isnew = 'Updated'");
                if (dr.Count() != 0)
                {
                    dt = dr.CopyToDataTable();
                    //if (Session["PcwarehousedetailstempUpdate"] != null)
                    //{
                    //    temtable23 = (DataTable)Session["PcwarehousedetailstempUpdate"];
                    //    DataRow[] rows;
                    //    rows = temtable23.Select("pcslno = '" + hdnpcslno.Value + "'");  //'UserName' is ColumnName
                    //    foreach (DataRow row in rows)
                    //        temtable23.Rows.Remove(row);

                    //    temtable23.Merge(dt);
                    //    Session["PcwarehousedetailstempUpdate"] = temtable23;
                    //}
                    //else
                    //{
                    //    Session["PcwarehousedetailstempUpdate"] = dt;
                    //}

                    for (int i = 0; i <= dt.Rows.Count - 1; i++)
                    {
                        string iswarehouse = string.Empty;
                        string isbatch = string.Empty;
                        string isserial = string.Empty;



                        #region WHBTSL
                        if (Convert.ToString(dt.Rows[i]["Inventrytype"]) == "WHBTSL")
                        {
                            DateTime? mfgex;
                            DateTime? exdate;
                            if (!string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewMFGDate"])) && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewExpiryDate"])))
                            {
                                if ((Convert.ToString(dt.Rows[i]["viewMFGDate"]) != "1/1/0001 12:00:00 AM" && Convert.ToString(dt.Rows[i]["viewExpiryDate"]) != "1/1/0001 12:00:00 AM"))
                                {
                                    mfgex = Convert.ToDateTime(dt.Rows[i]["viewMFGDate"]);
                                    exdate = Convert.ToDateTime(dt.Rows[i]["viewExpiryDate"]);
                                }
                                else
                                {
                                    mfgex = null;
                                    exdate = null;
                                }

                            }
                            else
                            {
                                mfgex = null;
                                exdate = null;
                            }

                            if (Convert.ToString(dt.Rows[i]["viewQuantity"]) != "0" && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewQuantity"])))
                            {
                                string sql = string.Empty;
                                if (mfgex == null && exdate == null)
                                {
                                    if (hdnisolddeleted.Value == "true")
                                    {

                                        var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND WarehouseID='" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + "' AND BatchNo='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'");
                                        if (string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                                        {
                                            updateqnty = Convert.ToDecimal(dt.Rows[i]["Quantitysum"]);
                                        }

                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                  "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                             "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                             "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                             "ModifiedDate=GETDATE()" +
                                                             "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                             "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                           "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +


                                                           "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                           "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                      "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                      "  update Trans_StockSerialMapping" +
                                            " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                            " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }
                                    else
                                    {
                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                    "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                               "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                               "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                               "ModifiedDate=GETDATE() " +
                                                               "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                               "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                             "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +


                                                             "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                             "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                        "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                        "  update Trans_StockSerialMapping" +
                                              " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                              " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }
                                }
                                else
                                {
                                    if (hdnisolddeleted.Value == "true")
                                    {

                                        var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND WarehouseID='" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + "' AND BatchNo='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'");
                                        if (string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                                        {
                                            updateqnty = Convert.ToDecimal(dt.Rows[i]["Quantitysum"]);
                                        }
                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                      "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                                 "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                                 "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                                 "ModifiedDate=GETDATE()" +
                                                                 "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                                 "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                               "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +

                                                               "StockBranchBatch_MfgDate='" + mfgex + "'," +
                                                               "StockBranchBatch_ExpiryDate='" + exdate + "'," +
                                                               "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                               "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                          "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                          "  update Trans_StockSerialMapping" +
                                                " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                                " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }
                                    else
                                    {
                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                 "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                            "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                            "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                            "ModifiedDate=GETDATE()" +
                                                            "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                            "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                          "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +

                                                          "StockBranchBatch_MfgDate='" + mfgex + "'," +
                                                          "StockBranchBatch_ExpiryDate='" + exdate + "'," +
                                                          "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                          "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                     "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                     "  update Trans_StockSerialMapping" +
                                           " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                           " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }


                                }


                                oDBEngine.GetDataTable(sql);

                            }
                            else
                            {
                                //var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND WarehouseID='" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + "' AND BatchNo='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'");


                                string sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                              "  update Trans_StockBranchWarehouseDetails set " +
                                                         "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                         "ModifiedDate=GETDATE() " +
                                                         "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +

                                                  "  update Trans_StockSerialMapping" +
                                        " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                        " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";

                                oDBEngine.GetDataTable(sql);
                            }
                        }
                        #endregion
                        #region WHBT
                        if (Convert.ToString(dt.Rows[i]["Inventrytype"]) == "WHBT")
                        {
                            DateTime? mfgex;
                            DateTime? exdate;

                            var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND BatchWarehouseID='" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "'");
                            var OLDSAMEwarehouse = Warehousedtups.Compute("sum(Quantitysum)", "isnew = 'old' AND BatchWarehouseID='" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "'");
                            if (!string.IsNullOrEmpty(Convert.ToString(OLDSAMEwarehouse)) && !string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            {

                                updateqnty = Convert.ToDecimal(updateqnty) + Convert.ToDecimal(OLDSAMEwarehouse);
                            }

                            if (!string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewMFGDate"])) && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewExpiryDate"])))
                            {
                                if ((Convert.ToString(dt.Rows[i]["viewMFGDate"]) != "1/1/0001 12:00:00 AM" && Convert.ToString(dt.Rows[i]["viewExpiryDate"]) != "1/1/0001 12:00:00 AM"))
                                {
                                    mfgex = Convert.ToDateTime(dt.Rows[i]["viewMFGDate"]);
                                    exdate = Convert.ToDateTime(dt.Rows[i]["viewExpiryDate"]);
                                }
                                else
                                {
                                    mfgex = null;
                                    exdate = null;
                                }

                            }
                            else
                            {
                                mfgex = null;
                                exdate = null;
                            }

                            if (Convert.ToString(dt.Rows[i]["viewQuantity"]) != "0" && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewQuantity"])) && !string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            {
                                string sql = string.Empty;
                                if (mfgex == null && exdate == null)
                                {
                                    sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                              "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                         "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                         "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                         "ModifiedDate=GETDATE() " +
                                                         "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                         "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                       "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +


                                                       "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                       "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                  "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]);


                                }
                                else
                                {
                                    sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                  "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                             "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                             "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                             "ModifiedDate=GETDATE() " +
                                                             "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                             "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                           "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +

                                                           "StockBranchBatch_MfgDate='" + mfgex + "'," +
                                                           "StockBranchBatch_ExpiryDate='" + exdate + "'," +
                                                           "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                           "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                      "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]);
                                }


                                oDBEngine.GetDataTable(sql);

                            }


                        }
                        #endregion
                        #region WHSL
                        if (Convert.ToString(dt.Rows[i]["Inventrytype"]) == "WHSL")
                        {
                            DateTime? mfgex;
                            DateTime? exdate;
                            if (!string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewMFGDate"])) && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewExpiryDate"])))
                            {
                                if ((Convert.ToString(dt.Rows[i]["viewMFGDate"]) != "1/1/0001 12:00:00 AM" && Convert.ToString(dt.Rows[i]["viewExpiryDate"]) != "1/1/0001 12:00:00 AM"))
                                {
                                    mfgex = Convert.ToDateTime(dt.Rows[i]["viewMFGDate"]);
                                    exdate = Convert.ToDateTime(dt.Rows[i]["viewExpiryDate"]);
                                }
                                else
                                {
                                    mfgex = null;
                                    exdate = null;
                                }

                            }
                            else
                            {
                                mfgex = null;
                                exdate = null;
                            }

                            if (Convert.ToString(dt.Rows[i]["viewQuantity"]) != "0" && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewQuantity"])))
                            {
                                string sql = string.Empty;
                                if (mfgex == null && exdate == null)
                                {
                                    sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                              "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                         "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                         "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                         "ModifiedDate=GETDATE()" +
                                                         "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                         "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                       "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +


                                                       "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                       "StockBranchBatch_ModifiedDate=GETDATE()" +
                                                  "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                  "  update Trans_StockSerialMapping" +
                                        " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                        " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";

                                }
                                else
                                {
                                    sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                  "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                             "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                             "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                             "ModifiedDate=GETDATE()" +
                                                             "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                             "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                           "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +

                                                           "StockBranchBatch_MfgDate='" + mfgex + "'," +
                                                           "StockBranchBatch_ExpiryDate='" + exdate + "'," +
                                                           "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                           "StockBranchBatch_ModifiedDate=GETDATE()" +
                                                      "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                      "  update Trans_StockSerialMapping" +
                                            " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                            " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                }


                                oDBEngine.GetDataTable(sql);

                            }
                            else
                            {
                                //var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND WarehouseID='" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + "' AND BatchNo='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'");


                                string sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                              "  update Trans_StockBranchWarehouseDetails set " +
                                                         "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                         "ModifiedDate=GETDATE()" +
                                                         "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +

                                                  "  update Trans_StockSerialMapping" +
                                        " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                        " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";

                                oDBEngine.GetDataTable(sql);
                            }
                        }
                        #endregion

                        #region WH
                        if (Convert.ToString(dt.Rows[i]["Inventrytype"]) == "WH")
                        {
                            if (Convert.ToString(dt.Rows[i]["viewQuantity"]) != "0" && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["Quantity"])))
                            {

                                string sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantity"]) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                            "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                       " Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(dt.Rows[i]["Quantity"]) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                       " ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                       " ModifiedDate=GETDATE() " +
                                                       " where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                       "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                     "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantity"]) + "," +


                                                     "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                     "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                " where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]);




                                oDBEngine.GetDataTable(sql);

                            }


                        }
                        #endregion

                        #region BTSL
                        if (Convert.ToString(dt.Rows[i]["Inventrytype"]) == "BTSL")
                        {
                            DateTime? mfgex;
                            DateTime? exdate;
                            if (!string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewMFGDate"])) && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewExpiryDate"])))
                            {
                                if ((Convert.ToString(dt.Rows[i]["viewMFGDate"]) != "1/1/0001 12:00:00 AM" && Convert.ToString(dt.Rows[i]["viewExpiryDate"]) != "1/1/0001 12:00:00 AM"))
                                {
                                    mfgex = Convert.ToDateTime(dt.Rows[i]["viewMFGDate"]);
                                    exdate = Convert.ToDateTime(dt.Rows[i]["viewExpiryDate"]);
                                }
                                else
                                {
                                    mfgex = null;
                                    exdate = null;
                                }

                            }
                            else
                            {
                                mfgex = null;
                                exdate = null;
                            }

                            if (Convert.ToString(dt.Rows[i]["viewQuantity"]) != "0" && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewQuantity"])))
                            {
                                string sql = string.Empty;
                                if (mfgex == null && exdate == null)
                                {
                                    if (hdnisolddeleted.Value == "true")
                                    {

                                        var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated'  AND BatchNo='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'");
                                        if (string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                                        {
                                            updateqnty = Convert.ToDecimal(dt.Rows[i]["Quantitysum"]);
                                        }

                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                  "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                             "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                             "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                             "ModifiedDate=GETDATE()" +
                                                             "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                             "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                           "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +


                                                           "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                           "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                      "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                      "  update Trans_StockSerialMapping" +
                                            " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                            " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }
                                    else
                                    {
                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                    "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                               "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                               "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                               "ModifiedDate=GETDATE() " +
                                                               "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                               "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                             "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +


                                                             "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                             "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                        "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                        "  update Trans_StockSerialMapping" +
                                              " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                              " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }
                                }
                                else
                                {
                                    if (hdnisolddeleted.Value == "true")
                                    {

                                        var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND BatchNo='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'");
                                        if (string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                                        {
                                            updateqnty = Convert.ToDecimal(dt.Rows[i]["Quantitysum"]);
                                        }
                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                      "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                                 "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                                 "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                                 "ModifiedDate=GETDATE()" +
                                                                 "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                                 "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                               "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +

                                                               "StockBranchBatch_MfgDate='" + mfgex + "'," +
                                                               "StockBranchBatch_ExpiryDate='" + exdate + "'," +
                                                               "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                               "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                          "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                          "  update Trans_StockSerialMapping" +
                                                " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                                " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }
                                    else
                                    {
                                        sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                 "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                            "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                            "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                            "ModifiedDate=GETDATE()" +
                                                            "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                            "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                          "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +

                                                          "StockBranchBatch_MfgDate='" + mfgex + "'," +
                                                          "StockBranchBatch_ExpiryDate='" + exdate + "'," +
                                                          "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                          "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                     "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]) + "	  " +
                                                     "  update Trans_StockSerialMapping" +
                                           " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                           " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";
                                    }


                                }


                                oDBEngine.GetDataTable(sql);

                            }
                            else
                            {
                                //var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND WarehouseID='" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + "' AND BatchNo='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'");


                                string sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                              "  update Trans_StockBranchWarehouseDetails set " +
                                                         "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                         "ModifiedDate=GETDATE() " +
                                                         "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +

                                                  "  update Trans_StockSerialMapping" +
                                        " Set Stock_BranchSerialNumber='" + Convert.ToString(dt.Rows[i]["SerialNo"]) + "'" +
                                        " where Stock_MapId=" + Convert.ToString(dt.Rows[i]["SerialID"]) + "" + "";

                                oDBEngine.GetDataTable(sql);
                            }
                        }
                        #endregion

                        #region BT
                        if (Convert.ToString(dt.Rows[i]["Inventrytype"]) == "BTSL")
                        {
                            DateTime? mfgex;
                            DateTime? exdate;

                            var updateqnty = dt.Compute("sum(Quantitysum)", "isnew = 'Updated' AND BatchWarehouseID='" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "'");
                            var OLDSAMEwarehouse = Warehousedtups.Compute("sum(Quantitysum)", "isnew = 'old' AND BatchWarehouseID='" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "'");
                            if (!string.IsNullOrEmpty(Convert.ToString(OLDSAMEwarehouse)) && !string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            {

                                updateqnty = Convert.ToDecimal(updateqnty) + Convert.ToDecimal(OLDSAMEwarehouse);
                            }

                            if (!string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewMFGDate"])) && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewExpiryDate"])))
                            {
                                if ((Convert.ToString(dt.Rows[i]["viewMFGDate"]) != "1/1/0001 12:00:00 AM" && Convert.ToString(dt.Rows[i]["viewExpiryDate"]) != "1/1/0001 12:00:00 AM"))
                                {
                                    mfgex = Convert.ToDateTime(dt.Rows[i]["viewMFGDate"]);
                                    exdate = Convert.ToDateTime(dt.Rows[i]["viewExpiryDate"]);
                                }
                                else
                                {
                                    mfgex = null;
                                    exdate = null;
                                }

                            }
                            else
                            {
                                mfgex = null;
                                exdate = null;
                            }

                            if (Convert.ToString(dt.Rows[i]["viewQuantity"]) != "0" && !string.IsNullOrEmpty(Convert.ToString(dt.Rows[i]["viewQuantity"])) && !string.IsNullOrEmpty(Convert.ToString(updateqnty)))
                            {
                                string sql = string.Empty;
                                if (mfgex == null && exdate == null)
                                {
                                    sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                              "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                         "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                         "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                         "ModifiedDate=GETDATE() " +
                                                         "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                         "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                       "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +


                                                       "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                       "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                  "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]);


                                }
                                else
                                {
                                    sql = "update Trans_StockBranchWarehouse set StockBranchWarehouse_StockIn=" + Convert.ToDecimal(updateqnty) + ",StockBranchWarehouse_WarehouseId=" + Convert.ToString(dt.Rows[i]["WarehouseID"]) + ",ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + ",ModifiedDate=getdate() where StockBranchWarehouse_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehouseID"]) + "" +
                                                  "  update Trans_StockBranchWarehouseDetails set Stock_OpeningRate=" + Convert.ToDecimal(hdnrate.Value) + "," +
                                                             "Stock_OpeningValue=ISNULL(isnull(" + Convert.ToDecimal(updateqnty) + ",0)*isnull(" + Convert.ToDecimal(hdnrate.Value) + ",0),0)," +
                                                             "ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                             "ModifiedDate=GETDATE() " +
                                                             "where StockBranchWarehouseDetail_Id=" + Convert.ToString(dt.Rows[i]["BatchWarehousedetailsID"]) + "" +
                                                             "   update Trans_StockBranchBatch set   StockBranchBatch_BatchNumber='" + Convert.ToString(dt.Rows[i]["BatchNo"]) + "'," +
                                                           "StockBranchBatch_StockIn=" + Convert.ToDecimal(dt.Rows[i]["Quantitysum"]) + "," +

                                                           "StockBranchBatch_MfgDate='" + mfgex + "'," +
                                                           "StockBranchBatch_ExpiryDate='" + exdate + "'," +
                                                           "StockBranchBatch_ModifiedBy=" + Convert.ToInt32(HttpContext.Current.Session["userid"]) + "," +
                                                           "StockBranchBatch_ModifiedDate=GETDATE() " +
                                                      "where StockBranchBatch_Id=" + Convert.ToString(dt.Rows[i]["BatchID"]);
                                }


                                oDBEngine.GetDataTable(sql);

                            }


                        }
                        #endregion

                    }
                }
            }

            return 0;
        }
        private bool IsPcTransactionExist(string pcid)
        {
            bool IsExist = false;
            if (pcid != "" && Convert.ToString(pcid).Trim() != "")
            {
                DataTable dt = new DataTable();
                dt = objPurchaseChallanBL.CheckPCTraanaction(pcid);
                if (dt.Rows.Count > 0 && Convert.ToString(dt.Rows[0]["isexist"]) != "0")
                {
                    IsExist = true;
                }
            }

            return IsExist;
        }
        private bool IsPOExist(string pcid)
        {
            bool IsExist = false;
            if (pcid != "" && Convert.ToString(pcid).Trim() != "")
            {
                DataTable dt = new DataTable();

                var elements = pcid.Split(new[] { ',' }, System.StringSplitOptions.RemoveEmptyEntries);
                foreach (string items in elements)
                {
                    dt = oDBEngine.GetDataTable("select Count(*) as isexist from tbl_trans_PurchaseOrder where PurchaseOrder_Id=" + items + "");
                    if (dt.Rows.Count > 0 && Convert.ToString(dt.Rows[0]["isexist"]) != "0")
                    {
                        IsExist = true;
                    }
                }

            }
            else
            {
                IsExist = true;
            }

            return IsExist;
        }
        [WebMethod]
        public static string getProductType(string Products_ID)
        {
            string Type = "";
            string query = @"Select
                           (Case When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='0' Then ''
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='0' Then 'W'
                           When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='0' Then 'B'
                           When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='1' Then 'S'
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='0' Then 'WB'
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='0' AND Isnull(Is_active_serialno,'0')='1' Then 'WS'
                           When Isnull(Is_active_warehouse,'0')='1' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='1' Then 'WBS'
                           When Isnull(Is_active_warehouse,'0')='0' AND Isnull(Is_active_Batch,'0')='1' AND Isnull(Is_active_serialno,'0')='1' Then 'BS'
                           END) as Type
                           from Master_sProducts
                           where sProducts_ID='" + Products_ID + "'";

            BusinessLogicLayer.DBEngine oDbEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable dt = oDbEngine.GetDataTable(query);
            if (dt != null && dt.Rows.Count > 0)
            {
                Type = Convert.ToString(dt.Rows[0]["Type"]);
            }

            return Convert.ToString(Type);
        }

        #region  Available Stock
        protected void acpAvailableStock_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string performpara = e.Parameter;
            string strProductID = Convert.ToString(performpara.Split('~')[0]);
            string strBranch = Convert.ToString(ddl_Branch.SelectedValue);
            acpAvailableStock.JSProperties["cpstock"] = "0.00";

            try
            {
                if (!string.IsNullOrEmpty(strProductID))
                {
                    DataTable dt2 = oDBEngine.GetDataTable("Select dbo.fn_CheckAvailableQuotation(" + strBranch + ",'" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]) + "'," + strProductID + ") as branchopenstock");

                    if (dt2.Rows.Count > 0)
                    {
                        acpAvailableStock.JSProperties["cpstock"] = Convert.ToString(Math.Round(Convert.ToDecimal(dt2.Rows[0]["branchopenstock"]), 2));
                    }
                    else
                    {
                        acpAvailableStock.JSProperties["cpstock"] = "0.00";
                    }
                }
                else
                {
                    acpAvailableStock.JSProperties["cpstock"] = "0.00";
                }

            }
            catch (Exception ex)
            {
            }
        }
        #endregion Available Stock

        #endregion

        #region Debu - Tax Details

        public void setValueForHeaderGST(ASPxComboBox aspxcmb, string taxId)
        {
            for (int i = 0; i < aspxcmb.Items.Count; i++)
            {
                if (Convert.ToString(aspxcmb.Items[i].Value).Split('~')[0] == taxId.Split('~')[0])
                {
                    aspxcmb.Items[i].Selected = true;
                    break;
                }
            }

        }

        protected DataTable GetTaxDataWithGST(DataTable existing)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "TaxDetailsForGst");
            proc.AddVarcharPara("@PurchaseChallan_Id", 500, Convert.ToString(Session["PurchaseChallan_Id"]));
            dt = proc.GetTable();
            if (dt.Rows.Count > 0)
            {
                DataRow gstRow = existing.NewRow();
                gstRow["Taxes_ID"] = 0;
                gstRow["Taxes_Name"] = dt.Rows[0]["TaxRatesSchemeName"];
                gstRow["Percentage"] = dt.Rows[0]["ChallanTax_Percentage"];
                gstRow["Amount"] = dt.Rows[0]["ChallanTax_Amount"];
                gstRow["AltTax_Code"] = dt.Rows[0]["Gst"];

                UpdateGstForCharges(Convert.ToString(dt.Rows[0]["Gst"]));
                txtGstCstVatCharge.Value = gstRow["Amount"];
                existing.Rows.Add(gstRow);
            }
            SetTotalCharges(existing);
            return existing;
        }

        public decimal SetTotalCharges(DataTable taxTableFinal)
        {
            decimal totalCharges = 0;
            foreach (DataRow dr in taxTableFinal.Rows)
            {
                if (Convert.ToString(dr["Taxes_ID"]) != "0")
                {
                    if (Convert.ToString(dr["Taxes_Name"]).Contains("(+)"))
                    {
                        totalCharges += Convert.ToDecimal(dr["Amount"]);
                    }
                    else
                    {
                        totalCharges -= Convert.ToDecimal(dr["Amount"]);
                    }
                }
                else
                {//Else part For Gst 
                    totalCharges += Convert.ToDecimal(dr["Amount"]);
                }
            }
            txtQuoteTaxTotalAmt.Value = totalCharges;
            return totalCharges;

        }

        protected void UpdateGstForCharges(string data)
        {
            for (int i = 0; i < cmbGstCstVatcharge.Items.Count; i++)
            {
                if (Convert.ToString(cmbGstCstVatcharge.Items[i].Value).Split('~')[0] == data)
                {
                    cmbGstCstVatcharge.Items[i].Selected = true;
                    break;
                }
            }
        }
        public void GetStock(string strProductID)
        {
            string strBranch = Convert.ToString(ddl_Branch.SelectedValue);
            acpAvailableStock.JSProperties["cpstock"] = "0.00";

            try
            {
                DataTable dt2 = oDBEngine.GetDataTable("Select dbo.fn_CheckAvailableQuotation(" + strBranch + ",'" + Convert.ToString(Session["LastCompany"]) + "','" + Convert.ToString(Session["LastFinYear"]) + "'," + strProductID + ") as branchopenstock");

                if (dt2.Rows.Count > 0)
                {
                    taxUpdatePanel.JSProperties["cpstock"] = Convert.ToString(Math.Round(Convert.ToDecimal(dt2.Rows[0]["branchopenstock"]), 2));
                }
                else
                {
                    taxUpdatePanel.JSProperties["cpstock"] = "0.00";
                }
            }
            catch (Exception ex)
            {
            }
        }
        protected void taxUpdatePanel_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {

            string performpara = e.Parameter;
            if (performpara.Split('~')[0] == "DelProdbySl")
            {
                DataTable MainTaxDataTable = (DataTable)Session["PCFinalTaxRecord"];

                DataRow[] deletedRow = MainTaxDataTable.Select("SlNo=" + performpara.Split('~')[1]);
                if (deletedRow.Length > 0)
                {
                    foreach (DataRow dr in deletedRow)
                    {
                        MainTaxDataTable.Rows.Remove(dr);
                    }

                }

                Session["PCFinalTaxRecord"] = MainTaxDataTable;
                GetStock(Convert.ToString(performpara.Split('~')[2]));
                DeleteWarehouse(Convert.ToString(performpara.Split('~')[1]));
                DataTable taxDetails = (DataTable)Session["PCTaxDetails"];
                if (taxDetails != null)
                {
                    foreach (DataRow dr in taxDetails.Rows)
                    {
                        dr["Amount"] = "0.00";
                    }
                    Session["PCTaxDetails"] = taxDetails;
                }
            }
            else if (performpara.Split('~')[0] == "DeleteAllTax")
            {
                CreateDataTaxTable();

                DataTable taxDetails = (DataTable)Session["PCTaxDetails"];

                if (taxDetails != null)
                {
                    foreach (DataRow dr in taxDetails.Rows)
                    {
                        dr["Amount"] = "0.00";
                    }
                    Session["PCTaxDetails"] = taxDetails;
                }
            }
            else
            {
                DataTable MainTaxDataTable = (DataTable)Session["PCFinalTaxRecord"];

                DataRow[] deletedRow = MainTaxDataTable.Select("SlNo=" + performpara.Split('~')[1]);
                if (deletedRow.Length > 0)
                {
                    foreach (DataRow dr in deletedRow)
                    {
                        MainTaxDataTable.Rows.Remove(dr);
                    }

                }

                Session["PCFinalTaxRecord"] = MainTaxDataTable;
                DataTable taxDetails = (DataTable)Session["PCTaxDetails"];
                if (taxDetails != null)
                {
                    foreach (DataRow dr in taxDetails.Rows)
                    {
                        dr["Amount"] = "0.00";
                    }
                    Session["PCTaxDetails"] = taxDetails;
                }
            }
        }
        public double ReCalculateTaxAmount(string slno, double amount)
        {
            DataTable MainTaxDataTable = (DataTable)Session["PCFinalTaxRecord"];
            double totalSum = 0.0;
            //Get The Existing datatable
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "PopulateAllTax");
            DataTable TaxDt = proc.GetTable();

            DataRow[] filterRow = MainTaxDataTable.Select("SlNo=" + slno);

            if (filterRow.Length > 0)
            {
                foreach (DataRow dr in filterRow)
                {
                    if (Convert.ToString(dr["TaxCode"]) != "0")
                    {
                        DataRow[] taxrow = TaxDt.Select("Taxes_ID=" + dr["TaxCode"]);
                        if (taxrow.Length > 0)
                        {
                            if (taxrow[0]["TaxCalculateMethods"] == "A")
                            {
                                dr["Amount"] = (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                                totalSum += (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                            }
                            else
                            {
                                dr["Amount"] = (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                                totalSum -= (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                            }
                        }
                    }
                    else
                    {
                        DataRow[] taxrow = TaxDt.Select("Taxes_ID=" + dr["AltTaxCode"]);
                        if (taxrow.Length > 0)
                        {
                            if (taxrow[0]["TaxCalculateMethods"] == "A")
                            {
                                dr["Amount"] = (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                                totalSum += (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                            }
                            else
                            {
                                dr["Amount"] = (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                                totalSum -= (amount * Convert.ToDouble(dr["Percentage"])) / 100;
                            }
                        }
                    }
                }

            }
            Session["PCFinalTaxRecord"] = MainTaxDataTable;

            return totalSum;

        }

        public void PopulateGSTCSTVATCombo(string quoteDate)
        {
            string LastCompany = "";
            if (Convert.ToString(Session["LastCompany"]) != null)
            {
                LastCompany = Convert.ToString(Session["LastCompany"]);
            }
            //DataTable dt = new DataTable();
            //dt = objCRMSalesDtlBL.PopulateGSTCSTVATCombo();
            //DataTable DT = oDBEngine.GetDataTable("select cast(td.TaxRates_ID as varchar(5))+'~'+ cast (td.TaxRates_Rate as varchar(25)) 'Taxes_ID',td.TaxRatesSchemeName 'Taxes_Name',th.Taxes_Name as 'TaxCodeName' from Master_Taxes th inner join Config_TaxRates td on th.Taxes_ID=td.TaxRates_TaxCode where (td.TaxRates_Country=0 or td.TaxRates_Country=(select add_country from tbl_master_address where add_cntId ='" + Convert.ToString(Session["LastCompany"]) + "' ))  and th.Taxes_ApplicableFor in ('B','S') and th.TaxTypeCode in('G','V','C')");

            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "LoadGSTCSTVATCombo");
            proc.AddVarcharPara("@campany_Id", 10, Convert.ToString(LastCompany));
            proc.AddVarcharPara("@OrderDate", 10, quoteDate);
            DataTable DT = proc.GetTable();
            cmbGstCstVat.DataSource = DT;
            cmbGstCstVat.TextField = "Taxes_Name";
            cmbGstCstVat.ValueField = "Taxes_ID";
            cmbGstCstVat.DataBind();



        }
        public void CreateDataTaxTable()
        {
            DataTable TaxRecord = new DataTable();

            TaxRecord.Columns.Add("SlNo", typeof(System.Int32));
            TaxRecord.Columns.Add("TaxCode", typeof(System.String));
            TaxRecord.Columns.Add("AltTaxCode", typeof(System.String));
            TaxRecord.Columns.Add("Percentage", typeof(System.Decimal));
            TaxRecord.Columns.Add("Amount", typeof(System.Decimal));
            Session["PCFinalTaxRecord"] = TaxRecord;
        }

        //public IEnumerable GetTaxCode()
        //{
        //    List<taxCode> TaxList = new List<taxCode>();
        //    BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
        //    // DataTable DT = objEngine.GetDataTable("select Taxes_ID,Taxes_Name from dbo.Master_Taxes");
        //    DataTable DT = objEngine.GetDataTable("select cast(th.Taxes_ID as varchar(5))+'~'+ cast (td.TaxRates_Rate as varchar(25)) 'Taxes_ID',th.Taxes_Name 'Taxes_Name' from Master_Taxes th inner join Config_TaxRates td on th.Taxes_ID=td.TaxRates_TaxCode where (td.TaxRates_Country=0 or td.TaxRates_Country=(select add_country from tbl_master_address where add_cntId ='" + Convert.ToString(Session["LastCompany"]) + "' ))  and th.Taxes_ApplicableFor in ('B','S')");


        //    for (int i = 0; i < DT.Rows.Count; i++)
        //    {
        //        taxCode tax = new taxCode();
        //        tax.Taxes_ID = Convert.ToString(DT.Rows[i]["Taxes_ID"]);
        //        tax.Taxes_Name = Convert.ToString(DT.Rows[i]["Taxes_Name"]);
        //        TaxList.Add(tax);
        //    }

        //    return TaxList;
        //}

        public string GetTaxName(int id)
        {
            string taxName = "";
            string[] arr = oDBEngine.GetFieldValue1("Master_taxes", "Taxes_Name", "Taxes_ID=" + Convert.ToString(id), 1);
            if (arr[0] != "n")
            {
                taxName = arr[0];
            }
            return taxName;
        }
        public DataSet GetQuotationTaxData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "ProductTaxDetails");
            proc.AddVarcharPara("@PurchaseChallan_Id", 500, Convert.ToString(Session["PurchaseChallan_Id"]));
            ds = proc.GetDataSet();
            return ds;
        }
        public DataSet GetQuotationEditedTaxData()
        {
            DataSet ds = new DataSet();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "ProductEditedTaxDetails");
            proc.AddVarcharPara("@PurchaseChallan_Id", 500, Convert.ToString(Session["PurchaseChallan_Id"]));
            ds = proc.GetDataSet();
            return ds;
        }
        public double GetTotalTaxAmount(List<TaxDetails> tax)
        {
            double sum = 0;
            foreach (TaxDetails td in tax)
            {
                if (td.Taxes_Name.Substring(td.Taxes_Name.Length - 3, 3) == "(+)")
                    sum += td.Amount;
                else
                    sum -= td.Amount;

            }
            return sum;
        }
        protected void cgridTax_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string retMsg = "";
            if (e.Parameters.Split('~')[0] == "SaveGST")
            {
                DataTable TaxRecord = (DataTable)Session["PCFinalTaxRecord"];
                int slNo = Convert.ToInt32(HdSerialNo.Value);
                //For GST/CST/VAT
                if (cmbGstCstVat.Value != null)
                {

                    DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='0'");
                    if (finalRow.Length > 0)
                    {
                        finalRow[0]["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                        finalRow[0]["Amount"] = txtGstCstVat.Text;
                        finalRow[0]["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];

                    }
                    else
                    {
                        DataRow newRowGST = TaxRecord.NewRow();
                        newRowGST["slNo"] = slNo;
                        newRowGST["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                        newRowGST["TaxCode"] = "0";
                        newRowGST["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];
                        newRowGST["Amount"] = txtGstCstVat.Text;
                        TaxRecord.Rows.Add(newRowGST);
                    }
                }
                //End Here

                aspxGridTax.JSProperties["cpUpdated"] = "";

                Session["PCFinalTaxRecord"] = TaxRecord;
            }
            else
            {
                #region fetch All data For Tax

                DataTable taxDetail = new DataTable();
                DataTable MainTaxDataTable = (DataTable)Session["PCFinalTaxRecord"];
                //    DataTable databaseReturnTable = (DataTable)Session["PChallanTaxDetails"];

                //if (Convert.ToInt32(e.Parameters.Split('~')[1]) == 1)
                //    taxDetail = oDBEngine.GetDataTable("select TaxRates_ID as Taxes_ID,TaxRatesSchemeName as Taxes_Name,TaxCalculateMethods,tm.Taxes_Name as taxCodeName,tm.Taxes_ApplicableOn as 'ApplicableOn',isnull((select TaxRatesSchemeName from Config_TaxRates where TaxRates_ID=tm.Taxes_OtherTax),'')  as dependOn from Master_taxes tm inner join Config_TaxRates ct on tm.Taxes_ID=ct.TaxRates_TaxCode where tm.TaxTypeCode not in('G','V','C') and tm.TaxItemlevel='Y'");
                //else if (Convert.ToInt32(e.Parameters.Split('~')[1]) == 2)
                //taxDetail = oDBEngine.GetDataTable("select TaxRates_ID as Taxes_ID,TaxRatesSchemeName as Taxes_Name,TaxCalculateMethods,tm.Taxes_Name as taxCodeName,tm.Taxes_ApplicableOn as 'ApplicableOn',isnull((select TaxRatesSchemeName from Config_TaxRates where TaxRates_ID=tm.Taxes_OtherTax),'')  as dependOn from Master_taxes tm inner join Config_TaxRates ct on tm.Taxes_ID=ct.TaxRates_TaxCode where tm.TaxTypeCode not in('G','V','C') and tm.TaxItemlevel='Y'");
                if (Convert.ToString(ddl_AmountAre.Value).Trim() != "4")
                {
                    ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
                    proc.AddVarcharPara("@Action", 500, "LoadOtherTaxDetails");
                    proc.AddVarcharPara("@SProducts_ID", 10, Convert.ToString(setCurrentProdCode.Value));
                    proc.AddVarcharPara("@OrderDate", 10, dt_PLQuote.Date.ToString("yyyy-MM-dd"));
                    taxDetail = proc.GetTable();
                }
                else
                {
                    ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
                    proc.AddVarcharPara("@Action", 500, "LoadImportTaxDetails");
                    proc.AddVarcharPara("@OrderDate", 10, dt_PLQuote.Date.ToString("yyyy-MM-dd"));
                    taxDetail = proc.GetTable();
                }
                //Get Company Gstin 09032017
                string CompInternalId = Convert.ToString(Session["LastCompany"]);
                string[] compGstin = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_gstin", "cmp_internalid='" + CompInternalId + "'", 1);

                //Get BranchStateCode
                string BranchStateCode = "", BranchGSTIN = "";
                DataTable BranchTable = oDBEngine.GetDataTable("select StateCode,branch_GSTIN   from tbl_master_branch branch inner join tbl_master_state st on branch.branch_state=st.id where branch_id=" + Convert.ToString(ddl_Branch.SelectedValue));
                if (BranchTable != null)
                {
                    BranchStateCode = Convert.ToString(BranchTable.Rows[0][0]);
                    BranchGSTIN = Convert.ToString(BranchTable.Rows[0][1]);

                    if (BranchGSTIN.Trim() != "")
                    {
                        BranchStateCode = BranchGSTIN.Substring(0, 2);
                    }

                }

                if (BranchGSTIN.Trim() == "")
                {
                    BranchStateCode = compGstin[0].Substring(0, 2);
                }




                string VendorState = "";


                ProcedureExecute GetVendorGstin = new ProcedureExecute("prc_GstTaxDetails");
                GetVendorGstin.AddVarcharPara("@Action", 500, "GetVendorGSTINByBranch");
                GetVendorGstin.AddVarcharPara("@branchId", 10, Convert.ToString(ddl_Branch.SelectedValue));
                GetVendorGstin.AddVarcharPara("@entityId", 10, Convert.ToString(lookup_Customer.Value));
                DataTable VendorGstin = GetVendorGstin.GetTable();

                if (VendorGstin.Rows.Count > 0)
                {
                    if (Convert.ToString(VendorGstin.Rows[0][0]).Trim() != "")
                    {
                        VendorState = Convert.ToString(VendorGstin.Rows[0][0]).Substring(0, 2);
                    }

                }


                if (Convert.ToString(ddl_AmountAre.Value).Trim() != "4")
                {

                    if (VendorState.Trim() != "" && BranchStateCode != "")
                    {


                        if (BranchStateCode == VendorState)
                        {
                            //Check if the state is in union territories then only UTGST will apply
                            //   Chandigarh     Andaman and Nicobar Islands    DADRA & NAGAR HAVELI    DAMAN & DIU                  Lakshadweep              PONDICHERRY
                            if (VendorState == "4" || VendorState == "26" || VendorState == "25" || VendorState == "35" || VendorState == "31" || VendorState == "34")
                            {
                                foreach (DataRow dr in taxDetail.Rows)
                                {
                                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                                    {
                                        dr.Delete();
                                    }
                                }

                            }
                            else
                            {
                                foreach (DataRow dr in taxDetail.Rows)
                                {
                                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                                    {
                                        dr.Delete();
                                    }
                                }
                            }
                            taxDetail.AcceptChanges();
                        }
                        else
                        {
                            foreach (DataRow dr in taxDetail.Rows)
                            {
                                if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                                {
                                    dr.Delete();
                                }
                            }
                            taxDetail.AcceptChanges();

                        }


                    }

                    //If Company GSTIN is blank then Delete All CGST,UGST,IGST,CGST
                    if ((compGstin[0].Trim() == "" && BranchGSTIN == "") || VendorState == "")
                    {
                        foreach (DataRow dr in taxDetail.Rows)
                        {
                            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST")
                            {
                                dr.Delete();
                            }
                        }
                        taxDetail.AcceptChanges();
                    }
                }
                else
                {
                    foreach (DataRow dr in taxDetail.Rows)
                    {
                        if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                        {
                            dr.Delete();
                        }
                    }
                    taxDetail.AcceptChanges();

                }

                ////Check If any TaxScheme Set Against that Product Then update there rate 22-03-2017 and rate
                //string[] schemeIDViaProdID = oDBEngine.GetFieldValue1("master_sproducts", "isnull(sProduct_TaxSchemeSale,0)sProduct_TaxSchemeSale", "sProducts_ID='" + Convert.ToString(setCurrentProdCode.Value) + "'", 1);
                ////&& schemeIDViaProdID[0] != ""
                //if (schemeIDViaProdID.Length > 0)
                //{

                //    if (taxDetail.Select("Taxes_ID='" + schemeIDViaProdID[0] + "'").Length > 0)
                //    {
                //        foreach (DataRow dr in taxDetail.Rows)
                //        {
                //            if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST")
                //            {
                //                if (Convert.ToString(dr["Taxes_ID"]).Trim() != schemeIDViaProdID[0].Trim())
                //                    dr["TaxRates_Rate"] = 0;
                //            }
                //        }
                //    }
                //}


                int slNo = Convert.ToInt32(HdSerialNo.Value);

                //Get Gross Amount and Net Amount 
                decimal ProdGrossAmt = Convert.ToDecimal(HdProdGrossAmt.Value);
                decimal ProdNetAmt = Convert.ToDecimal(HdProdNetAmt.Value);

                List<TaxDetails> TaxDetailsDetails = new List<TaxDetails>();

                //Debjyoti 09032017
                decimal totalParcentage = 0;
                foreach (DataRow dr in taxDetail.Rows)
                {
                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                    {
                        totalParcentage += Convert.ToDecimal(dr["TaxRates_Rate"]);
                    }
                }

                if (e.Parameters.Split('~')[0] == "New")
                {
                    foreach (DataRow dr in taxDetail.Rows)
                    {
                        TaxDetails obj = new TaxDetails();
                        obj.Taxes_ID = Convert.ToInt32(dr["Taxes_ID"]);
                        obj.taxCodeName = Convert.ToString(dr["taxCodeName"]);
                        obj.TaxField = Convert.ToString(dr["TaxRates_Rate"]);
                        obj.Amount = 0.0;

                        #region set calculated on
                        //Check Tax Applicable on and set to calculated on
                        if (Convert.ToString(dr["ApplicableOn"]) == "G")
                        {
                            obj.calCulatedOn = ProdGrossAmt;
                        }
                        else if (Convert.ToString(dr["ApplicableOn"]) == "N")
                        {
                            obj.calCulatedOn = ProdNetAmt;
                        }
                        else
                        {
                            obj.calCulatedOn = 0;
                        }
                        //End Here
                        #endregion

                        //Debjyoti 09032017
                        if (Convert.ToString(ddl_AmountAre.Value) == "2")
                        {
                            if (Convert.ToString(ddl_VatGstCst.Value) == "0~0~X")
                            {
                                if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                                {
                                    decimal finalCalCulatedOn = 0;
                                    decimal backProcessRate = (1 + (totalParcentage / 100));
                                    finalCalCulatedOn = obj.calCulatedOn / backProcessRate;
                                    obj.calCulatedOn = finalCalCulatedOn;
                                }
                            }
                        }

                        if (Convert.ToString(dr["TaxCalculateMethods"]) == "A")
                        {
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(+)";

                        }
                        else
                        {
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(-)";
                        }

                        obj.Amount = Convert.ToDouble(obj.calCulatedOn * (Convert.ToDecimal(obj.TaxField) / 100));




                        DataRow[] filtr = MainTaxDataTable.Select("TaxCode ='" + obj.Taxes_ID + "' and slNo=" + Convert.ToString(slNo));
                        if (filtr.Length > 0)
                        {
                            obj.Amount = Convert.ToDouble(filtr[0]["Amount"]);
                            if (obj.Taxes_ID == 0)
                            {
                                //   obj.TaxField = GetTaxName(Convert.ToInt32(Convert.ToString(filtr[0]["AltTaxCode"])));
                                aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(filtr[0]["AltTaxCode"]);
                            }
                            else
                                obj.TaxField = Convert.ToString(filtr[0]["Percentage"]);
                        }

                        TaxDetailsDetails.Add(obj);
                    }
                }
                else
                {
                    string keyValue = e.Parameters.Split('~')[0];

                    DataTable TaxRecord = (DataTable)Session["PCFinalTaxRecord"];


                    foreach (DataRow dr in taxDetail.Rows)
                    {
                        TaxDetails obj = new TaxDetails();
                        obj.Taxes_ID = Convert.ToInt32(dr["Taxes_ID"]);
                        obj.taxCodeName = Convert.ToString(dr["taxCodeName"]);

                        if (Convert.ToString(dr["TaxCalculateMethods"]) == "A")
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(+)";
                        else
                            obj.Taxes_Name = Convert.ToString(dr["Taxes_Name"]) + "(-)";
                        obj.TaxField = "";
                        obj.Amount = 0.0;

                        #region set calculated on
                        //Check Tax Applicable on and set to calculated on
                        if (Convert.ToString(dr["ApplicableOn"]) == "G")
                        {
                            obj.calCulatedOn = ProdGrossAmt;
                        }
                        else if (Convert.ToString(dr["ApplicableOn"]) == "N")
                        {
                            obj.calCulatedOn = ProdNetAmt;
                        }
                        else
                        {
                            obj.calCulatedOn = 0;
                        }
                        //End Here
                        #endregion

                        //Debjyoti 09032017
                        if (Convert.ToString(ddl_AmountAre.Value) == "2")
                        {
                            if (Convert.ToString(ddl_VatGstCst.Value) == "0~0~X")
                            {
                                if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                                {
                                    decimal finalCalCulatedOn = 0;
                                    decimal backProcessRate = (1 + (totalParcentage / 100));
                                    finalCalCulatedOn = obj.calCulatedOn / backProcessRate;
                                    obj.calCulatedOn = finalCalCulatedOn;
                                }
                            }
                        }

                        DataRow[] filtronexsisting1 = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                        if (filtronexsisting1.Length > 0)
                        {
                            if (obj.Taxes_ID == 0)
                            {
                                obj.TaxField = "0";
                            }
                            else
                            {
                                obj.TaxField = Convert.ToString(filtronexsisting1[0]["Percentage"]);
                            }
                            obj.Amount = Convert.ToDouble(filtronexsisting1[0]["Amount"]);
                        }
                        else
                        {
                            #region checkingFordb


                            //DataRow[] filtr = databaseReturnTable.Select("ProductTax_ProductId ='" + keyValue + "' and ProductTax_QuoteId=" +Convert.ToString( Session["PurchaseChallan_Id"] )+ " and ProductTax_TaxTypeId=" + obj.Taxes_ID);
                            //if (filtr.Length > 0)
                            //{
                            //    obj.Amount = Convert.ToDouble(filtr[0]["ProductTax_Amount"]);
                            //    if (obj.Taxes_ID == 0)
                            //    {
                            //        //obj.TaxField = GetTaxName();
                            //        obj.TaxField = "0";
                            //    }
                            //    else
                            //    {
                            //        obj.TaxField = Convert.ToString(filtr[0]["ProductTax_Percentage"]);
                            //    }


                            //    DataRow[] filtronexsisting = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                            //    if (filtronexsisting.Length > 0)
                            //    {
                            //        filtronexsisting[0]["Amount"] = obj.Amount;
                            //        if (obj.Taxes_ID == 0)
                            //        {
                            //            filtronexsisting[0]["Percentage"] = 0;
                            //        }
                            //        else
                            //        {
                            //            filtronexsisting[0]["Percentage"] = obj.TaxField;
                            //        }

                            //    }
                            //    else
                            //    {

                            //        DataRow taxRecordNewRow = TaxRecord.NewRow();
                            //        taxRecordNewRow["SlNo"] = slNo;
                            //        taxRecordNewRow["TaxCode"] = obj.Taxes_ID;
                            //        taxRecordNewRow["AltTaxCode"] = "0";
                            //        taxRecordNewRow["Percentage"] = obj.TaxField;
                            //        taxRecordNewRow["Amount"] = obj.Amount;

                            //        TaxRecord.Rows.Add(taxRecordNewRow);
                            //    }

                            //}
                            //else
                            //{
                            //    DataRow[] filtronexsisting = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                            //    if (filtronexsisting.Length > 0)
                            //    {
                            //        DataRow taxRecordNewRow = TaxRecord.NewRow();
                            //        taxRecordNewRow["SlNo"] = slNo;
                            //        taxRecordNewRow["TaxCode"] = obj.Taxes_ID;
                            //        taxRecordNewRow["AltTaxCode"] = "0";
                            //        taxRecordNewRow["Percentage"] = 0.0;
                            //        taxRecordNewRow["Amount"] = "0";

                            //        TaxRecord.Rows.Add(taxRecordNewRow);
                            //    }
                            //}




                            #endregion


                            DataRow[] filtronexsisting = TaxRecord.Select("TaxCode=" + obj.Taxes_ID + " and SlNo=" + Convert.ToString(slNo));
                            if (filtronexsisting.Length > 0)
                            {
                                DataRow taxRecordNewRow = TaxRecord.NewRow();
                                taxRecordNewRow["SlNo"] = slNo;
                                taxRecordNewRow["TaxCode"] = obj.Taxes_ID;
                                taxRecordNewRow["AltTaxCode"] = "0";
                                taxRecordNewRow["Percentage"] = 0.0;
                                taxRecordNewRow["Amount"] = "0";

                                TaxRecord.Rows.Add(taxRecordNewRow);
                            }

                        }
                        TaxDetailsDetails.Add(obj);

                        //      DataRow[] filtrIndex = databaseReturnTable.Select("ProductTax_ProductId ='" + keyValue + "' and ProductTax_QuoteId=" + Session["PurchaseChallan_Id"] + " and ProductTax_TaxTypeId=0");
                        DataRow[] filtrIndex = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode=0");
                        if (filtrIndex.Length > 0)
                        {
                            aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(filtrIndex[0]["AltTaxCode"]);
                        }
                    }
                    Session["PCFinalTaxRecord"] = TaxRecord;

                }
                //New Changes 170217
                //GstCode should fetch everytime
                DataRow[] finalFiltrIndex = MainTaxDataTable.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode=0");
                if (finalFiltrIndex.Length > 0)
                {
                    aspxGridTax.JSProperties["cpComboCode"] = Convert.ToString(finalFiltrIndex[0]["AltTaxCode"]);
                }

                aspxGridTax.JSProperties["cpJsonData"] = createJsonForDetails(taxDetail);

                retMsg = Convert.ToString(GetTotalTaxAmount(TaxDetailsDetails));
                aspxGridTax.JSProperties["cpUpdated"] = "ok~" + retMsg;

                TaxDetailsDetails = setCalculatedOn(TaxDetailsDetails, taxDetail);
                aspxGridTax.DataSource = TaxDetailsDetails;
                aspxGridTax.DataBind();

                #endregion
            }
        }


        public string createJsonForDetails(DataTable lstTaxDetails)
        {
            List<TaxSetailsJson> jsonList = new List<TaxSetailsJson>();
            TaxSetailsJson jsonObj;
            int visIndex = 0;
            foreach (DataRow taxObj in lstTaxDetails.Rows)
            {
                jsonObj = new TaxSetailsJson();

                jsonObj.SchemeName = Convert.ToString(taxObj["Taxes_Name"]);
                jsonObj.vissibleIndex = visIndex;
                jsonObj.applicableOn = Convert.ToString(taxObj["ApplicableOn"]);
                if (jsonObj.applicableOn == "G" || jsonObj.applicableOn == "N")
                {
                    jsonObj.applicableBy = "None";
                }
                else
                {
                    jsonObj.applicableBy = Convert.ToString(taxObj["dependOn"]);
                }
                visIndex++;
                jsonList.Add(jsonObj);
            }

            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            return oSerializer.Serialize(jsonList);
        }

        public List<TaxDetails> setCalculatedOn(List<TaxDetails> gridSource, DataTable taxDt)
        {
            foreach (TaxDetails taxObj in gridSource)
            {
                DataRow[] dependOn = taxDt.Select("dependOn='" + taxObj.Taxes_Name.Replace("(+)", "").Replace("(-)", "") + "'");
                if (dependOn.Length > 0)
                {
                    foreach (DataRow dr in dependOn)
                    {
                        //  List<TaxDetails> dependObj = gridSource.Where(r => r.Taxes_Name.Replace("(+)", "").Replace("(-)", "") == Convert.ToString(dependOn[0]["Taxes_Name"])).ToList();
                        foreach (var setCalObj in gridSource.Where(r => r.Taxes_Name.Replace("(+)", "").Replace("(-)", "") == Convert.ToString(dependOn[0]["Taxes_Name"])))
                        {
                            setCalObj.calCulatedOn = Convert.ToDecimal(taxObj.Amount);
                        }
                    }

                }

            }
            return gridSource;
        }



        protected void aspxGridTax_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {

            if (e.Column.FieldName == "Taxes_Name")
            {
                e.Editor.ReadOnly = true;
            }
            if (e.Column.FieldName == "taxCodeName")
            {
                e.Editor.ReadOnly = true;
            }
            if (e.Column.FieldName == "calCulatedOn")
            {
                e.Editor.ReadOnly = true;
            }
            //else if (e.Column.FieldName == "Amount")
            //{
            //    e.Editor.ReadOnly = true;
            //}
            else
            {
                e.Editor.ReadOnly = false;
            }
        }
        protected void aspxGridTax_HtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {

        }
        protected void taxgrid_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

            int slNo = Convert.ToInt32(HdSerialNo.Value);
            DataTable TaxRecord = (DataTable)Session["PCFinalTaxRecord"];
            foreach (var args in e.UpdateValues)
            {

                string TaxCodeDes = Convert.ToString(args.NewValues["Taxes_Name"]);
                decimal Percentage = 0;

                Percentage = Convert.ToDecimal(args.NewValues["TaxField"]);

                decimal Amount = Convert.ToDecimal(args.NewValues["Amount"]);
                string TaxCode = "0";
                if (!Convert.ToString(args.Keys[0]).Contains('~'))
                {
                    TaxCode = Convert.ToString(args.Keys[0]);
                }



                DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='" + TaxCode + "'");
                if (finalRow.Length > 0)
                {
                    finalRow[0]["Percentage"] = Percentage;
                    // finalRow[0]["TaxCode"] = args.NewValues["TaxField"]; 
                    finalRow[0]["Amount"] = Amount;

                    finalRow[0]["TaxCode"] = args.Keys[0];
                    finalRow[0]["AltTaxCode"] = "0";

                }
                else
                {
                    DataRow newRow = TaxRecord.NewRow();
                    newRow["slNo"] = slNo;
                    newRow["Percentage"] = Percentage;
                    newRow["TaxCode"] = TaxCode;
                    newRow["AltTaxCode"] = "0";
                    newRow["Amount"] = Amount;
                    TaxRecord.Rows.Add(newRow);
                }


            }

            //For GST/CST/VAT
            if (cmbGstCstVat.Value != null)
            {

                DataRow[] finalRow = TaxRecord.Select("SlNo=" + Convert.ToString(slNo) + " and TaxCode='0'");
                if (finalRow.Length > 0)
                {
                    finalRow[0]["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                    finalRow[0]["Amount"] = txtGstCstVat.Text;
                    finalRow[0]["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];

                }
                else
                {
                    DataRow newRowGST = TaxRecord.NewRow();
                    newRowGST["slNo"] = slNo;
                    newRowGST["Percentage"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[1];
                    newRowGST["TaxCode"] = "0";
                    newRowGST["AltTaxCode"] = Convert.ToString(cmbGstCstVat.Value).Split('~')[0];
                    newRowGST["Amount"] = txtGstCstVat.Text;
                    TaxRecord.Rows.Add(newRowGST);
                }
            }
            //End Here


            Session["PCFinalTaxRecord"] = TaxRecord;


            #region oldpart


            //DataTable taxdtByProductCode = new DataTable();
            //if (Session["ProdTax" + "_" + Convert.ToString(HdSerialNo.Value)] == null)
            //{

            //    taxdtByProductCode.TableName = "ProdTax"  + "_" + Convert.ToString(HdSerialNo.Value);


            //    taxdtByProductCode.Columns.Add("TaxCode", typeof(System.String));
            //    taxdtByProductCode.Columns.Add("TaxCodeDescription", typeof(System.String));
            //    taxdtByProductCode.Columns.Add("Percentage", typeof(System.Decimal));
            //    taxdtByProductCode.Columns.Add("Amount", typeof(System.Decimal));
            //    DataRow dr;
            //    foreach (var args in e.UpdateValues)
            //    {
            //        dr = taxdtByProductCode.NewRow();
            //        string TaxCodeDes = Convert.ToString(args.NewValues["Taxes_Name"]);
            //        decimal Percentage = 0;
            //        if (TaxCodeDes == "GST/CST/VAT")
            //        {
            //            Percentage = Convert.ToDecimal(Convert.ToString(args.NewValues["TaxField"]).Split('~')[1]);
            //        }
            //        else
            //        {
            //            Percentage = Convert.ToDecimal(args.NewValues["TaxField"]);
            //        }
            //        decimal Amount = Convert.ToDecimal(args.NewValues["Amount"]);

            //        dr["TaxCodeDescription"] = TaxCodeDes;
            //        if (Convert.ToString(args.Keys[0]) == "0")
            //        {
            //            dr["TaxCode"] = "0~" + Convert.ToString(args.NewValues["TaxField"]).Split('~')[0];
            //        }
            //        else
            //        {
            //            dr["TaxCode"] = args.Keys[0];
            //        }
            //        dr["Percentage"] = Percentage;
            //        dr["Amount"] = Amount;

            //        taxdtByProductCode.Rows.Add(dr);
            //    }
            //}
            //else
            //{
            //    taxdtByProductCode = (DataTable)Session["ProdTax"  +"_"+ Convert.ToString(HdSerialNo.Value)];

            //    foreach (var args in e.UpdateValues)
            //    {
            //        DataRow[] filtr ;

            //        if (Convert.ToString(args.Keys[0]) == "0")
            //        {
            //            filtr = taxdtByProductCode.Select("TaxCode like '%0~%'"); ;
            //        }
            //        else
            //        {
            //            filtr = taxdtByProductCode.Select("TaxCode='" + args.Keys[0]+"'");
            //        }

            //        if (filtr.Length > 0)
            //        {
            //            string TaxCodeDes = Convert.ToString(args.NewValues["Taxes_Name"]);
            //        filtr[0]["TaxCodeDescription"] = TaxCodeDes;
            //        if (Convert.ToString(args.Keys[0]) == "0")
            //        {
            //            filtr[0]["TaxCode"] = "0~" + Convert.ToString(args.NewValues["TaxField"]).Split('~')[0];
            //        }
            //        else
            //        {
            //            filtr[0]["TaxCode"] = args.Keys[0];
            //        }

            //        decimal Percentage = 0;
            //        if (TaxCodeDes == "GST/CST/VAT")
            //        {
            //            Percentage = Convert.ToDecimal(Convert.ToString(args.NewValues["TaxField"]).Split('~')[1]);
            //        }
            //        else
            //        {
            //            Percentage = Convert.ToDecimal(args.NewValues["TaxField"]);
            //        }
            //        decimal Amount = Convert.ToDecimal(args.NewValues["Amount"]);
            //        filtr[0]["Percentage"] = Percentage;
            //        filtr[0]["Amount"] = Amount;

            //        }
            //    }


            //}

            #endregion
            //  Session[taxdtByProductCode.TableName] = taxdtByProductCode;

        }
        protected void cmbGstCstVat_Callback(object sender, CallbackEventArgsBase e)
        {
            DateTime quoteDate = Convert.ToDateTime(dt_PLQuote.Date.ToString("yyyy-MM-dd"));

            PopulateGSTCSTVATCombo(quoteDate.ToString("yyyy-MM-dd"));
            CreateDataTaxTable();
            //DataTable taxTableItemLvl = (DataTable)Session["PCFinalTaxRecord"];
            //foreach (DataRow dr in taxTableItemLvl.Rows)
            //    dr.Delete();
            //taxTableItemLvl.AcceptChanges();
            //Session["PCFinalTaxRecord"] = taxTableItemLvl;
        }

        protected void cmbGstCstVatcharge_Callback(object sender, CallbackEventArgsBase e)
        {
            Session["PCTaxDetails"] = null;
            DateTime quoteDate = Convert.ToDateTime(dt_PLQuote.Date.ToString("yyyy-MM-dd"));
            PopulateChargeGSTCSTVATCombo(quoteDate.ToString("yyyy-MM-dd"));
        }
        public DataTable getAllTaxDetails(DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            DataTable FinalTable = new DataTable();
            FinalTable.Columns.Add("SlNo", typeof(System.Int32));
            FinalTable.Columns.Add("TaxCode", typeof(System.String));
            FinalTable.Columns.Add("AltTaxCode", typeof(System.String));
            FinalTable.Columns.Add("Percentage", typeof(System.Decimal));
            FinalTable.Columns.Add("Amount", typeof(System.Decimal));

            //for insert
            foreach (var args in e.InsertValues)
            {
                string Slno = Convert.ToString(args.NewValues["SrlNo"]);
                DataRow existsRow;
                if (Session["ProdTax_" + Slno] != null)
                {
                    DataTable sessiontable = (DataTable)Session["ProdTax_" + Slno];
                    foreach (DataRow dr in sessiontable.Rows)
                    {
                        existsRow = FinalTable.NewRow();

                        existsRow["SlNo"] = Slno;
                        if (Convert.ToString(dr["taxCode"]).Contains("~"))
                        {
                            existsRow["TaxCode"] = "0";
                            existsRow["AltTaxCode"] = Convert.ToString(dr["taxCode"]).Split('~')[1];
                        }
                        else
                        {
                            existsRow["TaxCode"] = Convert.ToString(dr["taxCode"]);
                            existsRow["AltTaxCode"] = "0";
                        }

                        existsRow["Percentage"] = Convert.ToString(dr["Percentage"]);
                        existsRow["Amount"] = Convert.ToString(dr["Amount"]);

                        FinalTable.Rows.Add(existsRow);
                    }
                    Session.Remove("ProdTax_" + Slno);
                }
            }

            return FinalTable;
        }
        protected void taxgrid_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void taxgrid_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void taxgrid_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            e.Cancel = true;
        }
        public void DeleteTaxDetails(string SrlNo)
        {
            DataTable TaxDetailTable = new DataTable();
            if (Session["PCFinalTaxRecord"] != null)
            {
                TaxDetailTable = (DataTable)Session["PCFinalTaxRecord"];

                var rows = TaxDetailTable.Select("SlNo ='" + SrlNo + "'");
                foreach (var row in rows)
                {
                    row.Delete();
                }
                TaxDetailTable.AcceptChanges();

                Session["PCFinalTaxRecord"] = TaxDetailTable;
            }
        }
        public void UpdateTaxDetails(string oldSrlNo, string newSrlNo)
        {
            DataTable TaxDetailTable = new DataTable();
            if (Session["PCFinalTaxRecord"] != null)
            {
                TaxDetailTable = (DataTable)Session["PCFinalTaxRecord"];

                for (int i = 0; i < TaxDetailTable.Rows.Count; i++)
                {
                    DataRow dr = TaxDetailTable.Rows[i];
                    string Product_SrlNo = Convert.ToString(dr["SlNo"]);
                    if (oldSrlNo == Product_SrlNo)
                    {
                        dr["SlNo"] = newSrlNo;
                    }
                }
                TaxDetailTable.AcceptChanges();

                Session["PCFinalTaxRecord"] = TaxDetailTable;
            }
        }


        public string createJsonForChargesTax(DataTable lstTaxDetails)
        {
            List<TaxSetailsJson> jsonList = new List<TaxSetailsJson>();
            TaxSetailsJson jsonObj;
            int visIndex = 0;
            foreach (DataRow taxObj in lstTaxDetails.Rows)
            {
                jsonObj = new TaxSetailsJson();

                jsonObj.SchemeName = Convert.ToString(taxObj["Taxes_Name"]);
                jsonObj.vissibleIndex = visIndex;
                jsonObj.applicableOn = Convert.ToString(taxObj["ApplicableOn"]);
                if (jsonObj.applicableOn == "G" || jsonObj.applicableOn == "N")
                {
                    jsonObj.applicableBy = "None";
                }
                else
                {
                    jsonObj.applicableBy = Convert.ToString(taxObj["dependOn"]);
                }
                visIndex++;
                jsonList.Add(jsonObj);
            }

            var oSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            return oSerializer.Serialize(jsonList);
        }
        public List<Taxes> setChargeCalculatedOn(List<Taxes> gridSource, DataTable taxDt)
        {
            foreach (Taxes taxObj in gridSource)
            {
                DataRow[] dependOn = taxDt.Select("dependOn='" + taxObj.TaxName.Replace("(+)", "").Replace("(-)", "").Trim() + "'");
                if (dependOn.Length > 0)
                {
                    foreach (DataRow dr in dependOn)
                    {
                        //  List<TaxDetails> dependObj = gridSource.Where(r => r.Taxes_Name.Replace("(+)", "").Replace("(-)", "") == Convert.ToString(dependOn[0]["Taxes_Name"])).ToList();
                        foreach (var setCalObj in gridSource.Where(r => r.TaxName.Replace("(+)", "").Replace("(-)", "").Trim() == Convert.ToString(dependOn[0]["Taxes_Name"]).Replace("(+)", "").Replace("(-)", "").Trim()))
                        {
                            setCalObj.calCulatedOn = Convert.ToDecimal(taxObj.Amount);
                        }
                    }

                }

            }
            return gridSource;
        }

        public void PopulateChargeGSTCSTVATCombo(string quoteDate)
        {
            string LastCompany = "";
            if (Convert.ToString(Session["LastCompany"]) != null)
            {
                LastCompany = Convert.ToString(Session["LastCompany"]);
            }
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "LoadChargeGSTCSTVATCombo");
            proc.AddVarcharPara("@campany_Id", 10, Convert.ToString(LastCompany));
            proc.AddVarcharPara("@OrderDate", 10, quoteDate);
            DataTable DT = proc.GetTable();
            cmbGstCstVatcharge.DataSource = DT;
            cmbGstCstVatcharge.TextField = "Taxes_Name";
            cmbGstCstVatcharge.ValueField = "Taxes_ID";
            cmbGstCstVatcharge.DataBind();
        }

        #endregion

        #region Quotation Tax Details

        public IEnumerable GetTaxes()
        {
            List<Taxes> TaxList = new List<Taxes>();
            BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
            DataTable DT = GetTaxData(dt_PLQuote.Date.ToString("yyyy-MM-dd"));
            for (int i = 0; i < DT.Rows.Count; i++)
            {
                Taxes Taxes = new Taxes();
                Taxes.TaxID = Convert.ToString(DT.Rows[i]["Taxes_ID"]);
                Taxes.TaxName = Convert.ToString(DT.Rows[i]["Taxes_Name"]);
                Taxes.Percentage = Convert.ToString(DT.Rows[i]["Percentage"]);
                Taxes.Amount = Convert.ToString(DT.Rows[i]["Amount"]);
                TaxList.Add(Taxes);
            }

            return TaxList;
        }
        public IEnumerable GetTaxes(DataTable DT)
        {
            List<Taxes> TaxList = new List<Taxes>();

            decimal totalParcentage = 0;
            foreach (DataRow dr in DT.Rows)
            {
                if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                {
                    totalParcentage += Convert.ToDecimal(dr["Percentage"]);
                }
            }

            for (int i = 0; i < DT.Rows.Count; i++)
            {
                if (Convert.ToString(DT.Rows[i]["Taxes_ID"]) != "0")
                {
                    Taxes Taxes = new Taxes();
                    Taxes.TaxID = Convert.ToString(DT.Rows[i]["Taxes_ID"]);
                    Taxes.TaxName = Convert.ToString(DT.Rows[i]["Taxes_Name"]);
                    Taxes.Percentage = Convert.ToString(DT.Rows[i]["Percentage"]);
                    Taxes.Amount = Convert.ToString(DT.Rows[i]["Amount"]);
                    if (Convert.ToString(DT.Rows[i]["ApplicableOn"]) == "G")
                    {
                        Taxes.calCulatedOn = Convert.ToDecimal(HdChargeProdAmt.Value);
                    }
                    else if (Convert.ToString(DT.Rows[i]["ApplicableOn"]) == "N")
                    {
                        Taxes.calCulatedOn = Convert.ToDecimal(HdChargeProdNetAmt.Value);
                    }
                    else
                    {
                        Taxes.calCulatedOn = 0;
                    }
                    //Set Amount Value 
                    if (Taxes.Amount == "0.00")
                    {
                        Taxes.Amount = Convert.ToString(Taxes.calCulatedOn * (Convert.ToDecimal(Taxes.Percentage) / 100));
                    }


                    if (Convert.ToString(ddl_AmountAre.Value) == "2")
                    {
                        if (Convert.ToString(ddl_VatGstCst.Value) == "0~0~X")
                        {
                            if (Convert.ToString(DT.Rows[i]["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(DT.Rows[i]["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(DT.Rows[i]["TaxTypeCode"]).Trim() == "SGST")
                            {
                                decimal finalCalCulatedOn = 0;
                                decimal backProcessRate = (1 + (totalParcentage / 100));
                                finalCalCulatedOn = Taxes.calCulatedOn / backProcessRate;
                                Taxes.calCulatedOn = Math.Round(finalCalCulatedOn);
                            }
                        }
                    }

                    TaxList.Add(Taxes);
                }
            }

            return TaxList;
        }
        public DataTable GetTaxData(string quoteDate)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
            proc.AddVarcharPara("@Action", 500, "TaxDetails");
            proc.AddVarcharPara("@PurchaseChallan_Id", 500, Convert.ToString(Session["PurchaseChallan_Id"]));
            proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
            proc.AddVarcharPara("@branchid", 500, Convert.ToString(ddl_Branch.SelectedValue));
            proc.AddVarcharPara("@campany_Id", 500, Convert.ToString(Session["LastCompany"]));
            proc.AddVarcharPara("@OrderDate", 10, quoteDate);
            dt = proc.GetTable();
            return dt;
        }
        protected void gridTax_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];
            if (strSplitCommand == "Display")
            {
                DataTable TaxDetailsdt = new DataTable();
                if (Session["PCTaxDetails"] == null)
                {
                    Session["PCTaxDetails"] = GetTaxData(dt_PLQuote.Date.ToString("yyyy-MM-dd"));
                }

                if (Session["PCTaxDetails"] != null)
                {
                    TaxDetailsdt = (DataTable)Session["PCTaxDetails"];

                    #region Delete Igst,Cgst,Sgst respectively
                    //Get Company Gstin 09032017
                    string CompInternalId = Convert.ToString(Session["LastCompany"]);
                    string[] compGstin = oDBEngine.GetFieldValue1("tbl_master_company", "cmp_gstin", "cmp_internalid='" + CompInternalId + "'", 1);
                    string ShippingState = "";
                    #region ##### Added By : Samrat Roy -- For BillingShippingUserControl ######
                    string sstateCode = BillingShippingControl.GetShippingStateCode(Request.QueryString["key"]);
                    ShippingState = sstateCode;
                    if (ShippingState.Trim() != "")
                    {
                        ShippingState = ShippingState.Substring(ShippingState.IndexOf("(State Code:")).Replace("(State Code:", "").Replace(")", "");
                    }

                    #region ##### Old Code -- BillingShipping ######
                    //////if (chkBilling.Checked)
                    //////{
                    //////    if (CmbState.Value != null)
                    //////    {
                    //////        ShippingState = CmbState.Text;
                    //////        ShippingState = ShippingState.Substring(ShippingState.IndexOf("(State Code:")).Replace("(State Code:", "").Replace(")", "");
                    //////    }
                    //////}
                    //////else
                    //////{
                    //////    if (CmbState1.Value != null)
                    //////    {
                    //////        ShippingState = CmbState1.Text;
                    //////        ShippingState = ShippingState.Substring(ShippingState.IndexOf("(State Code:")).Replace("(State Code:", "").Replace(")", "");
                    //////    }
                    //////}
                    #endregion

                    #endregion

                    if (ShippingState.Trim() != "" && compGstin[0].Trim() != "")
                    {
                        if (compGstin.Length > 0)
                        {
                            if (compGstin[0].Substring(0, 2) == ShippingState)
                            {
                                //Check if the state is in union territories then only UTGST will apply
                                //   Chandigarh     Andaman and Nicobar Islands    DADRA & NAGAR HAVELI    DAMAN & DIU      Lakshadweep              PONDICHERRY
                                if (ShippingState == "4" || ShippingState == "26" || ShippingState == "25" || ShippingState == "35" || ShippingState == "31" || ShippingState == "34")
                                {
                                    foreach (DataRow dr in TaxDetailsdt.Rows)
                                    {
                                        if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST")
                                        {
                                            dr.Delete();
                                        }
                                    }

                                }
                                else
                                {
                                    foreach (DataRow dr in TaxDetailsdt.Rows)
                                    {
                                        if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "IGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                                        {
                                            dr.Delete();
                                        }
                                    }
                                }
                                TaxDetailsdt.AcceptChanges();
                            }
                            else
                            {
                                foreach (DataRow dr in TaxDetailsdt.Rows)
                                {
                                    if (Convert.ToString(dr["TaxTypeCode"]).Trim() == "CGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "SGST" || Convert.ToString(dr["TaxTypeCode"]).Trim() == "UTGST")
                                    {
                                        dr.Delete();
                                    }
                                }
                                TaxDetailsdt.AcceptChanges();

                            }

                        }
                    }

                    #endregion

                    //gridTax.DataSource = GetTaxes();
                    var taxlist = (List<Taxes>)GetTaxes(TaxDetailsdt);
                    var taxChargeDataSource = setChargeCalculatedOn(taxlist, TaxDetailsdt);
                    gridTax.DataSource = taxChargeDataSource;
                    gridTax.DataBind();
                    gridTax.JSProperties["cpJsonChargeData"] = createJsonForChargesTax(TaxDetailsdt);
                    gridTax.JSProperties["cpTotalCharges"] = ClculatedTotalCharge(taxChargeDataSource);
                }
            }
            else if (strSplitCommand == "SaveGst")
            {
                DataTable TaxDetailsdt = new DataTable();
                if (Session["PCTaxDetails"] != null)
                {
                    TaxDetailsdt = (DataTable)Session["PCTaxDetails"];
                }
                else
                {
                    TaxDetailsdt.Columns.Add("Taxes_ID", typeof(string));
                    TaxDetailsdt.Columns.Add("Taxes_Name", typeof(string));
                    TaxDetailsdt.Columns.Add("Percentage", typeof(string));
                    TaxDetailsdt.Columns.Add("Amount", typeof(string));
                    //ForGst
                    TaxDetailsdt.Columns.Add("AltTax_Code", typeof(string));
                }
                DataRow[] existingRow = TaxDetailsdt.Select("Taxes_ID='0'");
                if (Convert.ToString(cmbGstCstVatcharge.Value) == "0")
                {
                    if (existingRow.Length > 0)
                    {
                        TaxDetailsdt.Rows.Remove(existingRow[0]);
                    }
                }
                else
                {
                    if (existingRow.Length > 0)
                    {
                        existingRow[0]["Percentage"] = (cmbGstCstVatcharge.Value != null) ? Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[1] : "0";
                        existingRow[0]["Amount"] = txtGstCstVatCharge.Text;
                        existingRow[0]["AltTax_Code"] = (cmbGstCstVatcharge.Value != null) ? Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[0] : "0";

                    }
                    else
                    {
                        string GstTaxId = (cmbGstCstVatcharge.Value != null) ? Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[0] : "0";
                        string GstPerCentage = (cmbGstCstVatcharge.Value != null) ? Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[1] : "0";

                        string GstAmount = txtGstCstVatCharge.Text;
                        DataRow gstRow = TaxDetailsdt.NewRow();
                        gstRow["Taxes_ID"] = 0;
                        gstRow["Taxes_Name"] = cmbGstCstVatcharge.Text;
                        gstRow["Percentage"] = GstPerCentage;
                        gstRow["Amount"] = GstAmount;
                        gstRow["AltTax_Code"] = GstTaxId;
                        TaxDetailsdt.Rows.Add(gstRow);
                    }

                    Session["PCTaxDetails"] = TaxDetailsdt;
                }
            }
        }

        protected decimal ClculatedTotalCharge(List<Taxes> taxChargeDataSource)
        {
            decimal totalCharges = 0;
            foreach (Taxes txObj in taxChargeDataSource)
            {

                if (Convert.ToString(txObj.TaxName).Contains("(+)"))
                {
                    totalCharges += Convert.ToDecimal(txObj.Amount);
                }
                else
                {
                    totalCharges -= Convert.ToDecimal(txObj.Amount);
                }

            }
            totalCharges += Convert.ToDecimal(txtGstCstVatCharge.Text);

            return totalCharges;

        }
        protected void gridTax_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void gridTax_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void gridTax_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            e.Cancel = true;
        }
        protected void gridTax_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            DataTable TaxDetailsdt = new DataTable();
            if (Session["PCTaxDetails"] != null)
            {
                TaxDetailsdt = (DataTable)Session["PCTaxDetails"];
            }
            else
            {
                TaxDetailsdt.Columns.Add("Taxes_ID", typeof(string));
                TaxDetailsdt.Columns.Add("Taxes_Name", typeof(string));
                TaxDetailsdt.Columns.Add("Percentage", typeof(string));
                TaxDetailsdt.Columns.Add("Amount", typeof(string));
                //ForGst
                TaxDetailsdt.Columns.Add("AltTax_Code", typeof(string));
            }

            foreach (var args in e.UpdateValues)
            {
                string TaxID = Convert.ToString(args.Keys["TaxID"]);
                string TaxName = Convert.ToString(args.NewValues["TaxName"]);
                string Percentage = Convert.ToString(args.NewValues["Percentage"]);
                string Amount = Convert.ToString(args.NewValues["Amount"]);

                bool Isexists = false;
                foreach (DataRow drr in TaxDetailsdt.Rows)
                {
                    string OldTaxID = Convert.ToString(drr["Taxes_ID"]);

                    if (OldTaxID == TaxID)
                    {
                        Isexists = true;

                        drr["Percentage"] = Percentage;
                        drr["Amount"] = Amount;

                        break;
                    }
                }

                if (Isexists == false)
                {
                    TaxDetailsdt.Rows.Add(TaxID, TaxName, Percentage, Amount, 0);
                }
            }

            if (cmbGstCstVatcharge.Value != null)
            {
                DataRow[] existingRow = TaxDetailsdt.Select("Taxes_ID='0'");
                if (Convert.ToString(cmbGstCstVatcharge.Value) == "0")
                {
                    if (existingRow.Length > 0)
                    {
                        TaxDetailsdt.Rows.Remove(existingRow[0]);
                    }
                }
                else
                {
                    if (existingRow.Length > 0)
                    {

                        existingRow[0]["Percentage"] = Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[1];
                        existingRow[0]["Amount"] = txtGstCstVatCharge.Text;
                        existingRow[0]["AltTax_Code"] = Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[0]; ;

                    }
                    else
                    {
                        string GstTaxId = Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[0];
                        string GstPerCentage = Convert.ToString(cmbGstCstVatcharge.Value).Split('~')[1];
                        string GstAmount = txtGstCstVatCharge.Text;
                        DataRow gstRow = TaxDetailsdt.NewRow();
                        gstRow["Taxes_ID"] = 0;
                        gstRow["Taxes_Name"] = cmbGstCstVatcharge.Text;
                        gstRow["Percentage"] = GstPerCentage;
                        gstRow["Amount"] = GstAmount;
                        gstRow["AltTax_Code"] = GstTaxId;
                        TaxDetailsdt.Rows.Add(gstRow);
                    }
                }
            }

            Session["PCTaxDetails"] = TaxDetailsdt;

            decimal cpChargesAmt = 0;
            if (TaxDetailsdt != null && TaxDetailsdt.Rows.Count > 0)
            {
                foreach (DataRow rrow in TaxDetailsdt.Rows)
                {
                    string value = (Convert.ToString(rrow["Amount"]) != "") ? Convert.ToString(rrow["Amount"]) : "0";

                    if (Convert.ToString(rrow["Taxes_Name"]).Contains('+') == true)
                    {
                        cpChargesAmt = cpChargesAmt + Convert.ToDecimal(value);
                    }
                    else if (Convert.ToString(rrow["Taxes_Name"]).Contains('-') == true)
                    {
                        cpChargesAmt = cpChargesAmt - Convert.ToDecimal(value);
                    }
                }
            }
            gridTax.JSProperties["cpChargesAmt"] = Convert.ToString(cpChargesAmt);

            gridTax.DataSource = GetTaxes(TaxDetailsdt);
            gridTax.DataBind();
        }
        protected void gridTax_DataBinding(object sender, EventArgs e)
        {
            if (Session["PCTaxDetails"] != null)
            {
                DataTable TaxDetailsdt = (DataTable)Session["PCTaxDetails"];

                //gridTax.DataSource = GetTaxes();
                var taxlist = (List<Taxes>)GetTaxes(TaxDetailsdt);
                var taxChargeDataSource = setChargeCalculatedOn(taxlist, TaxDetailsdt);
                gridTax.DataSource = taxChargeDataSource;
            }
        }


        #endregion

        #region Warehouse Details

        protected void CmbWarehouseID_Callback(object sender, CallbackEventArgsBase e)
        {
            string WhichCall = e.Parameter.Split('~')[0];

            if (WhichCall == "BindWarehouse")
            {
                DataTable dt = GetWarehouseData();
                GetAvailableStock();

                CmbWarehouseID.Items.Clear();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    CmbWarehouseID.Items.Add(Convert.ToString(dt.Rows[i]["WarehouseName"]), Convert.ToString(dt.Rows[i]["WarehouseID"]));
                }

                BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                string strBranch = Convert.ToString(ddl_Branch.SelectedValue);
                DataTable dtdefaultStock = objEngine.GetDataTable("tbl_master_building", " top 1 bui_id ", " bui_BranchId='" + strBranch + "' ");
                if (dtdefaultStock != null && dtdefaultStock.Rows.Count > 0)
                {
                    string defaultID = Convert.ToString(dtdefaultStock.Rows[0]["bui_id"]).Trim();

                    if (defaultID != null || defaultID != "" || defaultID != "0")
                    {
                        CmbWarehouseID.Value = defaultID;
                    }
                }
            }
        }
        protected void GrdWarehouse_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            GrdWarehouse.JSProperties["cpIsSave"] = "";
            string strSplitCommand = e.Parameters.Split('~')[0];
            string Type = "", Sales_UOM_Name = "", Sales_UOM_Code = "", Stk_UOM_Name = "", Stk_UOM_Code = "", Conversion_Multiplier = "", Trans_Stock = "0";
            bool IsDelete = false;

            DataTable Warehousedt = new DataTable();
            if (Session["PC_WarehouseData"] != null)
            {
                Warehousedt = (DataTable)Session["PC_WarehouseData"];
            }
            else
            {
                Warehousedt.Columns.Add("Product_SrlNo", typeof(string));
                Warehousedt.Columns.Add("SrlNo", typeof(int));
                Warehousedt.Columns.Add("WarehouseID", typeof(string));
                Warehousedt.Columns.Add("WarehouseName", typeof(string));
                Warehousedt.Columns.Add("Quantity", typeof(string));
                Warehousedt.Columns.Add("TotalQuantity", typeof(string));
                Warehousedt.Columns.Add("SalesQuantity", typeof(string));
                Warehousedt.Columns.Add("SalesUOMName", typeof(string));
                Warehousedt.Columns.Add("BatchID", typeof(string));
                Warehousedt.Columns.Add("BatchNo", typeof(string));
                Warehousedt.Columns.Add("MfgDate", typeof(string));
                Warehousedt.Columns.Add("ExpiryDate", typeof(string));
                Warehousedt.Columns.Add("SerialNo", typeof(string));
                Warehousedt.Columns.Add("LoopID", typeof(string));
                Warehousedt.Columns.Add("Status", typeof(string));
                Warehousedt.Columns.Add("ViewMfgDate", typeof(string));
                Warehousedt.Columns.Add("ViewExpiryDate", typeof(string));
                Warehousedt.Columns.Add("IsOutStatus", typeof(string));
                Warehousedt.Columns.Add("IsOutStatusMsg", typeof(string));
            }

            Warehousedt.Columns["IsOutStatus"].DefaultValue = "visibility: visible";
            Warehousedt.Columns["IsOutStatusMsg"].DefaultValue = "visibility: hidden";

            if (strSplitCommand == "Display")
            {
                GetProductType(ref Type);
                string ProductID = Convert.ToString(hdfProductID.Value);
                string SerialID = Convert.ToString(e.Parameters.Split('~')[1]);

                if (Warehousedt != null && Warehousedt.Rows.Count > 0)
                {
                    Warehousedt.DefaultView.Sort = "LoopID,SrlNo ASC";
                    DataTable sortWarehousedt = Warehousedt.DefaultView.ToTable();

                    DataView dvData = new DataView(sortWarehousedt);
                    dvData.RowFilter = "Product_SrlNo = '" + SerialID + "'";

                    GrdWarehouse.DataSource = dvData;
                    GrdWarehouse.DataBind();
                }
                else
                {
                    GrdWarehouse.DataSource = Warehousedt.DefaultView;
                    GrdWarehouse.DataBind();
                }
                changeGridOrder();
            }
            else if (strSplitCommand == "SaveDisplay")
            {
                GetProductType(ref Type);
                int loopId = Convert.ToInt32(Session["PC_LoopWarehouse"]);

                string WarehouseID = Convert.ToString(e.Parameters.Split('~')[1]);
                string WarehouseName = Convert.ToString(e.Parameters.Split('~')[2]);
                string BatchName = Convert.ToString(e.Parameters.Split('~')[3]);
                string MfgDate = Convert.ToString(e.Parameters.Split('~')[4]);
                string ExpiryDate = Convert.ToString(e.Parameters.Split('~')[5]);
                string SerialNo = Convert.ToString(e.Parameters.Split('~')[6]);
                string Qty = Convert.ToString(e.Parameters.Split('~')[7]);
                string editWarehouseID = Convert.ToString(e.Parameters.Split('~')[8]);

                string ProductID = Convert.ToString(hdfProductID.Value);
                string ProductSerialID = Convert.ToString(hdfProductSerialID.Value);

                if (Type == "WBS")
                {
                    GetProductUOM(ref Sales_UOM_Name, ref Sales_UOM_Code, ref Stk_UOM_Name, ref Stk_UOM_Code, ref Conversion_Multiplier, ProductID);
                    int SerialNoCount_Server = CheckSerialNoExists(SerialNo);
                    var SerialNoCount_Local = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND SrlNo<>'" + editWarehouseID + "'");

                    if (editWarehouseID == "0")
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            string maxID = GetWarehouseMaxValue(Warehousedt);
                            var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND BatchID ='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");

                            if (updaterows.Length == 0)
                            {
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                            }
                            else
                            {
                                int newloopID = 0;
                                decimal oldQuantity = 0;

                                foreach (var row in updaterows)
                                {
                                    oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                    row["Quantity"] = (oldQuantity + Convert.ToDecimal(1));
                                    row["MfgDate"] = MfgDate;
                                    row["ExpiryDate"] = ExpiryDate;
                                    newloopID = Convert.ToInt32(row["LoopID"]);


                                    if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                    {
                                        row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                        row["ViewMfgDate"] = MfgDate;
                                        row["ViewExpiryDate"] = ExpiryDate;
                                    }
                                }
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "");
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                    else
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            var rows = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND WarehouseID ='" + WarehouseID + "' AND BatchID ='" + BatchName + "' AND SrlNo='" + editWarehouseID + "'");
                            if (rows.Length == 0)
                            {
                                int oldloopID = 0;
                                decimal oldTotalQuantity = 0;
                                string Pre_batcgid = "", Pre_batchname = "", Pre_warehouse = "", Pre_warehouseName = "", Pre_MfgDate = "", Pre_ExpiryDate = "";

                                var oldrows = Warehousedt.Select("SrlNo='" + editWarehouseID + "'");
                                foreach (var roww in oldrows)
                                {
                                    Pre_warehouse = Convert.ToString(roww["WarehouseID"]);
                                    Pre_warehouseName = Convert.ToString(roww["WarehouseName"]);
                                    Pre_batcgid = Convert.ToString(roww["BatchID"]);
                                    Pre_batchname = Convert.ToString(roww["BatchID"]);
                                    Pre_MfgDate = Convert.ToString(roww["MfgDate"]);
                                    Pre_ExpiryDate = Convert.ToString(roww["ExpiryDate"]);

                                    oldloopID = Convert.ToInt32(roww["LoopID"]);
                                    oldTotalQuantity = Convert.ToDecimal(roww["TotalQuantity"]);
                                }

                                if ((Pre_batcgid.Trim() == BatchName.Trim()) && (Pre_warehouse.Trim() == WarehouseID.Trim()))
                                {
                                    foreach (var rowww in oldrows)
                                    {
                                        rowww["SerialNo"] = SerialNo;
                                    }

                                    var Oldupdaterows = Warehousedt.Select("LoopID='" + oldloopID + "'");
                                    foreach (DataRow updaterow in Oldupdaterows)
                                    {
                                        updaterow["MfgDate"] = MfgDate;
                                        updaterow["ExpiryDate"] = ExpiryDate;

                                        if (Convert.ToString(updaterow["ViewMfgDate"]) != "") updaterow["ViewMfgDate"] = MfgDate;
                                        if (Convert.ToString(updaterow["ViewExpiryDate"]) != "") updaterow["ViewExpiryDate"] = ExpiryDate;
                                    }
                                }
                                else
                                {
                                    foreach (DataRow delrow in oldrows)
                                    {
                                        delrow.Delete();
                                    }
                                    Warehousedt.AcceptChanges();

                                    var Oldupdaterows = Warehousedt.Select("LoopID='" + oldloopID + "'");

                                    if (oldTotalQuantity != 0)
                                    {
                                        foreach (DataRow updaterow in Oldupdaterows)
                                        {
                                            decimal PreQuantity = Convert.ToDecimal(updaterow["Quantity"]);
                                            updaterow["WarehouseName"] = Pre_warehouseName;
                                            updaterow["BatchNo"] = Pre_batchname;
                                            updaterow["SalesQuantity"] = (PreQuantity - Convert.ToDecimal(1)) + " " + Sales_UOM_Name;

                                            updaterow["ViewMfgDate"] = Pre_MfgDate;
                                            updaterow["ViewExpiryDate"] = Pre_ExpiryDate;

                                            break;
                                        }
                                    }

                                    foreach (DataRow updaterow in Oldupdaterows)
                                    {
                                        decimal PreQuantity = Convert.ToDecimal(updaterow["Quantity"]);

                                        if (Convert.ToString(updaterow["SalesQuantity"]) != "")
                                        {
                                            updaterow["Quantity"] = (PreQuantity - Convert.ToDecimal(1));
                                            updaterow["SalesQuantity"] = (PreQuantity - Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                            updaterow["TotalQuantity"] = (PreQuantity - Convert.ToDecimal(1));
                                        }
                                        else
                                        {
                                            updaterow["Quantity"] = (PreQuantity - Convert.ToDecimal(1));
                                            updaterow["TotalQuantity"] = "0";
                                            updaterow["WarehouseName"] = "";
                                            updaterow["BatchNo"] = "";
                                        }
                                    }

                                    string maxID = GetWarehouseMaxValue(Warehousedt);
                                    var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND BatchID ='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");

                                    if (updaterows.Length == 0)
                                    {
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                                    }
                                    else
                                    {
                                        int newloopID = 0;
                                        decimal oldQuantity = 0;

                                        foreach (var row in updaterows)
                                        {
                                            oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                            row["Quantity"] = (oldQuantity + Convert.ToDecimal(1));
                                            row["MfgDate"] = MfgDate;
                                            row["ExpiryDate"] = ExpiryDate;
                                            newloopID = Convert.ToInt32(row["LoopID"]);

                                            if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                            {
                                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                                row["ViewMfgDate"] = MfgDate;
                                                row["ViewExpiryDate"] = ExpiryDate;
                                            }
                                        }
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "");
                                    }
                                }
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                }
                else if (Type == "W")
                {
                    GetProductUOM(ref Sales_UOM_Name, ref Sales_UOM_Code, ref Stk_UOM_Name, ref Stk_UOM_Code, ref Conversion_Multiplier, ProductID);

                    if (editWarehouseID == "0")
                    {
                        string maxID = GetWarehouseMaxValue(Warehousedt);
                        var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND Product_SrlNo='" + ProductSerialID + "'");

                        if (updaterows.Length == 0)
                        {
                            Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                        }
                        else
                        {
                            foreach (var row in updaterows)
                            {
                                decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                row["Quantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["TotalQuantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(Qty)) + " " + Sales_UOM_Name;
                            }
                        }
                    }
                    else
                    {
                        var rows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND Convert(Quantity, 'System.Decimal')='" + Qty + "' AND SrlNo='" + editWarehouseID + "'");
                        if (rows.Length == 0)
                        {
                            string whID = "";
                            string maxID = GetWarehouseMaxValue(Warehousedt);

                            var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND Product_SrlNo='" + ProductSerialID + "'");
                            foreach (var row in updaterows)
                            {
                                whID = Convert.ToString(row["SrlNo"]);
                            }

                            if (updaterows.Length == 0)
                            {
                                IsDelete = true;
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                            }
                            else if (editWarehouseID == whID)
                            {
                                foreach (var row in updaterows)
                                {
                                    whID = Convert.ToString(row["SrlNo"]);
                                    decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);

                                    row["Quantity"] = Qty;
                                    row["TotalQuantity"] = Qty;
                                    row["SalesQuantity"] = Qty + " " + Sales_UOM_Name;
                                }
                            }
                            else if (editWarehouseID != whID)
                            {
                                IsDelete = true;
                                foreach (var row in updaterows)
                                {
                                    ID = Convert.ToString(row["SrlNo"]);
                                    decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);

                                    row["Quantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                    row["TotalQuantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                    row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(Qty)) + " " + Sales_UOM_Name;
                                }
                            }
                        }
                    }
                }
                else if (Type == "WB")
                {
                    GetProductUOM(ref Sales_UOM_Name, ref Sales_UOM_Code, ref Stk_UOM_Name, ref Stk_UOM_Code, ref Conversion_Multiplier, ProductID);

                    if (editWarehouseID == "0")
                    {
                        string maxID = GetWarehouseMaxValue(Warehousedt);
                        var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND BatchID='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");

                        if (updaterows.Length == 0)
                        {
                            Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                        }
                        else
                        {
                            foreach (var row in updaterows)
                            {
                                decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                row["Quantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["TotalQuantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(Qty)) + " " + Sales_UOM_Name;
                                row["MfgDate"] = MfgDate;
                                row["ExpiryDate"] = ExpiryDate;
                            }
                        }
                    }
                    else
                    {
                        var rows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND BatchID='" + BatchName + "' AND Convert(TotalQuantity, 'System.Decimal')='" + Qty + "' AND SrlNo='" + editWarehouseID + "'");
                        if (rows.Length == 0)
                        {
                            string whID = "";
                            string maxID = GetWarehouseMaxValue(Warehousedt);

                            var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND BatchID='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");
                            foreach (var row in updaterows)
                            {
                                whID = Convert.ToString(row["SrlNo"]);
                            }

                            if (updaterows.Length == 0)
                            {
                                IsDelete = true;
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                            }
                            else if (editWarehouseID == whID)
                            {
                                foreach (var row in updaterows)
                                {
                                    whID = Convert.ToString(row["SrlNo"]);
                                    decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);

                                    row["Quantity"] = Qty;
                                    row["TotalQuantity"] = Qty;
                                    row["SalesQuantity"] = Qty + " " + Sales_UOM_Name;
                                    row["MfgDate"] = MfgDate;
                                    row["ExpiryDate"] = ExpiryDate;
                                }
                            }
                            else if (editWarehouseID != whID)
                            {
                                IsDelete = true;
                                foreach (var row in updaterows)
                                {
                                    ID = Convert.ToString(row["SrlNo"]);
                                    decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);

                                    row["Quantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                    row["TotalQuantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                    row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(Qty)) + " " + Sales_UOM_Name;
                                    row["MfgDate"] = MfgDate;
                                    row["ExpiryDate"] = ExpiryDate;
                                }
                            }
                        }
                    }
                }
                else if (Type == "B")
                {
                    GetProductUOM(ref Sales_UOM_Name, ref Sales_UOM_Code, ref Stk_UOM_Name, ref Stk_UOM_Code, ref Conversion_Multiplier, ProductID);
                    WarehouseID = "0";

                    if (editWarehouseID == "0")
                    {
                        string maxID = GetWarehouseMaxValue(Warehousedt);
                        var updaterows = Warehousedt.Select("BatchID ='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");

                        if (updaterows.Length == 0)
                        {
                            Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                        }
                        else
                        {
                            foreach (var row in updaterows)
                            {
                                decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                row["Quantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["TotalQuantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(Qty)) + " " + Sales_UOM_Name;
                                row["MfgDate"] = MfgDate;
                                row["ExpiryDate"] = ExpiryDate;
                            }
                        }
                    }
                    else
                    {
                        var rows = Warehousedt.Select("BatchID='" + BatchName + "' AND Convert(TotalQuantity, 'System.Decimal')='" + Qty + "' AND SrlNo='" + editWarehouseID + "'");
                        if (rows.Length == 0)
                        {
                            string whID = "";
                            string maxID = GetWarehouseMaxValue(Warehousedt);

                            var updaterows = Warehousedt.Select("BatchID ='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");
                            foreach (var row in updaterows)
                            {
                                whID = Convert.ToString(row["SrlNo"]);
                            }

                            if (updaterows.Length == 0)
                            {
                                IsDelete = true;
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                            }
                            else if (editWarehouseID == whID)
                            {
                                foreach (var row in updaterows)
                                {
                                    whID = Convert.ToString(row["SrlNo"]);
                                    decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);

                                    row["Quantity"] = Qty;
                                    row["TotalQuantity"] = Qty;
                                    row["SalesQuantity"] = Qty + " " + Sales_UOM_Name;
                                    row["MfgDate"] = MfgDate;
                                    row["ExpiryDate"] = ExpiryDate;
                                }
                            }
                            else if (editWarehouseID != whID)
                            {
                                IsDelete = true;
                                foreach (var row in updaterows)
                                {
                                    ID = Convert.ToString(row["SrlNo"]);
                                    decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);

                                    row["Quantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                    row["TotalQuantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                    row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(Qty)) + " " + Sales_UOM_Name;
                                    row["MfgDate"] = MfgDate;
                                    row["ExpiryDate"] = ExpiryDate;
                                }
                            }
                        }
                    }
                }
                else if (Type == "S")
                {
                    GetProductUOM(ref Sales_UOM_Name, ref Sales_UOM_Code, ref Stk_UOM_Name, ref Stk_UOM_Code, ref Conversion_Multiplier, ProductID);
                    int SerialNoCount_Server = CheckSerialNoExists(SerialNo);
                    var SerialNoCount_Local = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND SrlNo<>'" + editWarehouseID + "'");

                    if (editWarehouseID == "0")
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            string maxID = GetWarehouseMaxValue(Warehousedt);

                            int newloopID = 0;
                            decimal oldQuantity = 0;

                            var updaterows = Warehousedt.Select("Product_SrlNo='" + ProductSerialID + "'");
                            if (updaterows.Length > 0)
                            {
                                foreach (var row in updaterows)
                                {
                                    oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                    newloopID = Convert.ToInt32(row["LoopID"]);

                                    row["Quantity"] = (oldQuantity + Convert.ToDecimal(1));
                                    if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                    {
                                        row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                    }
                                }

                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate);
                            }
                            else
                            {
                                newloopID = loopId;
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal(1) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate);
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                    else
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            var rows = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND SrlNo='" + editWarehouseID + "'");
                            if (rows.Length == 0)
                            {
                                DataRow[] updaterows = Warehousedt.Select("SrlNo ='" + editWarehouseID + "'");
                                foreach (DataRow row in updaterows)
                                {
                                    row["SerialNo"] = SerialNo;
                                }
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                }
                else if (Type == "WS")
                {
                    GetProductUOM(ref Sales_UOM_Name, ref Sales_UOM_Code, ref Stk_UOM_Name, ref Stk_UOM_Code, ref Conversion_Multiplier, ProductID);
                    int SerialNoCount_Server = CheckSerialNoExists(SerialNo);
                    var SerialNoCount_Local = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND SrlNo<>'" + editWarehouseID + "'");

                    if (editWarehouseID == "0")
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            string maxID = GetWarehouseMaxValue(Warehousedt);
                            var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND Product_SrlNo='" + ProductSerialID + "'");

                            if (updaterows.Length == 0)
                            {
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                            }
                            else
                            {
                                int newloopID = 0;
                                decimal oldQuantity = 0;

                                foreach (var row in updaterows)
                                {
                                    oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                    row["Quantity"] = (oldQuantity + Convert.ToDecimal(1));
                                    row["MfgDate"] = MfgDate;
                                    row["ExpiryDate"] = ExpiryDate;
                                    newloopID = Convert.ToInt32(row["LoopID"]);

                                    if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                    {
                                        row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                    }
                                }
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate);
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                    else
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            var rows = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND WarehouseID ='" + WarehouseID + "' AND SrlNo='" + editWarehouseID + "'");
                            if (rows.Length == 0)
                            {
                                int oldloopID = 0;
                                decimal oldTotalQuantity = 0;
                                string Pre_warehouse = "", Pre_warehouseName = "";

                                var oldrows = Warehousedt.Select("SrlNo='" + editWarehouseID + "'");
                                foreach (var roww in oldrows)
                                {
                                    Pre_warehouse = Convert.ToString(roww["WarehouseID"]);
                                    Pre_warehouseName = Convert.ToString(roww["WarehouseName"]);
                                    oldloopID = Convert.ToInt32(roww["LoopID"]);
                                    oldTotalQuantity = Convert.ToDecimal(roww["TotalQuantity"]);
                                }

                                if (Pre_warehouse.Trim() == WarehouseID.Trim())
                                {
                                    foreach (var rowww in oldrows)
                                    {
                                        rowww["SerialNo"] = SerialNo;
                                    }
                                }
                                else
                                {
                                    foreach (DataRow delrow in oldrows)
                                    {
                                        delrow.Delete();
                                    }
                                    Warehousedt.AcceptChanges();

                                    var Oldupdaterows = Warehousedt.Select("LoopID='" + oldloopID + "'");

                                    if (oldTotalQuantity != 0)
                                    {
                                        foreach (DataRow updaterow in Oldupdaterows)
                                        {
                                            decimal PreQuantity = Convert.ToDecimal(updaterow["Quantity"]);
                                            updaterow["WarehouseName"] = Pre_warehouseName;
                                            updaterow["SalesQuantity"] = (PreQuantity - Convert.ToDecimal(1)) + " " + Sales_UOM_Name;

                                            break;
                                        }
                                    }

                                    foreach (DataRow updaterow in Oldupdaterows)
                                    {
                                        decimal PreQuantity = Convert.ToDecimal(updaterow["Quantity"]);

                                        if (Convert.ToString(updaterow["SalesQuantity"]) != "")
                                        {
                                            updaterow["Quantity"] = (PreQuantity - Convert.ToDecimal(1));
                                            updaterow["SalesQuantity"] = (PreQuantity - Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                            updaterow["TotalQuantity"] = (PreQuantity - Convert.ToDecimal(1));
                                        }
                                        else
                                        {
                                            updaterow["Quantity"] = (PreQuantity - Convert.ToDecimal(1));
                                            updaterow["TotalQuantity"] = "0";
                                            updaterow["WarehouseName"] = "";
                                        }
                                    }

                                    string maxID = GetWarehouseMaxValue(Warehousedt);
                                    var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND Product_SrlNo='" + ProductSerialID + "'");

                                    if (updaterows.Length == 0)
                                    {
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                                    }
                                    else
                                    {
                                        int newloopID = 0;
                                        decimal oldQuantity = 0;

                                        foreach (var row in updaterows)
                                        {
                                            oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                            row["Quantity"] = (oldQuantity + Convert.ToDecimal(1));
                                            row["MfgDate"] = MfgDate;
                                            row["ExpiryDate"] = ExpiryDate;
                                            newloopID = Convert.ToInt32(row["LoopID"]);

                                            if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                            {
                                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                            }
                                        }
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate);
                                    }
                                }
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                }
                else if (Type == "BS")
                {
                    GetProductUOM(ref Sales_UOM_Name, ref Sales_UOM_Code, ref Stk_UOM_Name, ref Stk_UOM_Code, ref Conversion_Multiplier, ProductID);
                    int SerialNoCount_Server = CheckSerialNoExists(SerialNo);
                    var SerialNoCount_Local = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND SrlNo<>'" + editWarehouseID + "'");

                    if (editWarehouseID == "0")
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            string maxID = GetWarehouseMaxValue(Warehousedt);
                            var updaterows = Warehousedt.Select("BatchID ='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");

                            if (updaterows.Length == 0)
                            {
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                            }
                            else
                            {
                                int newloopID = 0;
                                decimal oldQuantity = 0;

                                foreach (var row in updaterows)
                                {
                                    oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                    row["Quantity"] = (oldQuantity + Convert.ToDecimal(1));
                                    row["MfgDate"] = MfgDate;
                                    row["ExpiryDate"] = ExpiryDate;
                                    newloopID = Convert.ToInt32(row["LoopID"]);

                                    if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                    {
                                        row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                    }
                                }
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "");
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                    else
                    {
                        if (SerialNoCount_Server == 0 && SerialNoCount_Local.Length == 0)
                        {
                            var rows = Warehousedt.Select("SerialNo ='" + SerialNo + "' AND BatchID ='" + BatchName + "' AND SrlNo='" + editWarehouseID + "'");
                            if (rows.Length == 0)
                            {
                                int oldloopID = 0;
                                decimal oldTotalQuantity = 0;
                                string Pre_batcgid = "", Pre_batchname = "";

                                var oldrows = Warehousedt.Select("SrlNo='" + editWarehouseID + "'");
                                foreach (var roww in oldrows)
                                {
                                    Pre_batcgid = Convert.ToString(roww["BatchID"]);
                                    Pre_batchname = Convert.ToString(roww["BatchID"]);
                                    oldloopID = Convert.ToInt32(roww["LoopID"]);
                                    oldTotalQuantity = Convert.ToDecimal(roww["TotalQuantity"]);
                                }

                                if (Pre_batcgid.Trim() == BatchName.Trim())
                                {
                                    foreach (var rowww in oldrows)
                                    {
                                        rowww["SerialNo"] = SerialNo;
                                    }
                                }
                                else
                                {
                                    foreach (DataRow delrow in oldrows)
                                    {
                                        delrow.Delete();
                                    }
                                    Warehousedt.AcceptChanges();

                                    var Oldupdaterows = Warehousedt.Select("LoopID='" + oldloopID + "'");

                                    if (oldTotalQuantity != 0)
                                    {
                                        foreach (DataRow updaterow in Oldupdaterows)
                                        {
                                            decimal PreQuantity = Convert.ToDecimal(updaterow["Quantity"]);
                                            updaterow["BatchNo"] = Pre_batchname;
                                            updaterow["SalesQuantity"] = (PreQuantity - Convert.ToDecimal(1)) + " " + Sales_UOM_Name;

                                            break;
                                        }
                                    }

                                    foreach (DataRow updaterow in Oldupdaterows)
                                    {
                                        decimal PreQuantity = Convert.ToDecimal(updaterow["Quantity"]);

                                        if (Convert.ToString(updaterow["SalesQuantity"]) != "")
                                        {
                                            updaterow["Quantity"] = (PreQuantity - Convert.ToDecimal(1));
                                            updaterow["SalesQuantity"] = (PreQuantity - Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                            updaterow["TotalQuantity"] = (PreQuantity - Convert.ToDecimal(1));
                                        }
                                        else
                                        {
                                            updaterow["Quantity"] = (PreQuantity - Convert.ToDecimal(1));
                                            updaterow["TotalQuantity"] = "0";
                                            updaterow["BatchNo"] = "";
                                        }
                                    }

                                    string maxID = GetWarehouseMaxValue(Warehousedt);
                                    var updaterows = Warehousedt.Select("BatchID ='" + BatchName + "' AND Product_SrlNo='" + ProductSerialID + "'");

                                    if (updaterows.Length == 0)
                                    {
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate);
                                    }
                                    else
                                    {
                                        int newloopID = 0;
                                        decimal oldQuantity = 0;

                                        foreach (var row in updaterows)
                                        {
                                            oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                            row["Quantity"] = (oldQuantity + Convert.ToDecimal(1));
                                            row["MfgDate"] = MfgDate;
                                            row["ExpiryDate"] = ExpiryDate;
                                            newloopID = Convert.ToInt32(row["LoopID"]);

                                            if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                            {
                                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                            }
                                        }
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "");
                                    }
                                }
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                }


                if (IsDelete == true)
                {
                    DataRow[] delResult = Warehousedt.Select("SrlNo ='" + editWarehouseID + "'");
                    foreach (DataRow delrow in delResult)
                    {
                        delrow.Delete();
                    }
                    Warehousedt.AcceptChanges();
                }

                Session["PC_WarehouseData"] = Warehousedt;
                Session["PC_LoopWarehouse"] = loopId + 1;
                changeGridOrder();

                Warehousedt.DefaultView.Sort = "LoopID,SrlNo ASC";
                GrdWarehouse.DataSource = Warehousedt.DefaultView.ToTable();
                GrdWarehouse.DataBind();
            }
            else if (strSplitCommand == "Delete")
            {
                string strKey = e.Parameters.Split('~')[1];
                string strLoopID = "", strPreLoopID = "";

                if (Session["PC_WarehouseData"] != null)
                {
                    Warehousedt = (DataTable)Session["PC_WarehouseData"];
                }

                DataRow[] result = Warehousedt.Select("SrlNo ='" + strKey + "'");
                foreach (DataRow row in result)
                {
                    strLoopID = row["LoopID"].ToString();
                }

                if (Warehousedt != null && Warehousedt.Rows.Count > 0)
                {
                    int count = 0;
                    bool IsFirst = false, IsAssign = false;
                    string WarehouseName = "", Quantity = "", SalesUOMName = "", BatchNo = "", SalesQuantity = "", MfgDate = "", ExpiryDate = "";

                    for (int i = 0; i < Warehousedt.Rows.Count; i++)
                    {
                        DataRow dr = Warehousedt.Rows[i];
                        string delSrlID = Convert.ToString(dr["SrlNo"]);
                        string delLoopID = Convert.ToString(dr["LoopID"]);

                        if (strPreLoopID != delLoopID)
                        {
                            count = 0;
                        }

                        if ((delLoopID == strLoopID) && (strKey == delSrlID) && count == 0)
                        {
                            IsFirst = true;

                            WarehouseName = Convert.ToString(dr["WarehouseName"]);
                            Quantity = Convert.ToString(dr["Quantity"]);
                            SalesUOMName = Convert.ToString(dr["SalesUOMName"]);
                            BatchNo = Convert.ToString(dr["BatchNo"]);
                            SalesQuantity = Convert.ToString(dr["SalesQuantity"]);
                            MfgDate = Convert.ToString(dr["MfgDate"]);
                            ExpiryDate = Convert.ToString(dr["ExpiryDate"]);

                            //dr.Delete();
                        }
                        else
                        {
                            if (delLoopID == strLoopID)
                            {
                                if (strKey == delSrlID)
                                {
                                    //dr.Delete();
                                }
                                else
                                {
                                    decimal S_Quantity = Convert.ToDecimal(dr["Quantity"]);
                                    dr["Quantity"] = S_Quantity - 1;

                                    if (IsFirst == true && IsAssign == false)
                                    {
                                        IsAssign = true;

                                        dr["WarehouseName"] = WarehouseName;
                                        dr["BatchNo"] = BatchNo;
                                        dr["SalesUOMName"] = SalesUOMName;
                                        dr["SalesQuantity"] = (S_Quantity - 1) + " " + SalesUOMName;
                                        dr["MfgDate"] = MfgDate;
                                        dr["ExpiryDate"] = ExpiryDate;
                                        dr["TotalQuantity"] = S_Quantity - 1;
                                        dr["ViewMfgDate"] = MfgDate;
                                        dr["ViewExpiryDate"] = ExpiryDate;
                                    }
                                    else
                                    {
                                        if (IsAssign == false)
                                        {
                                            IsAssign = true;
                                            SalesUOMName = Convert.ToString(dr["SalesUOMName"]);
                                            dr["SalesQuantity"] = (S_Quantity - 1) + " " + SalesUOMName;
                                        }
                                    }
                                }
                            }
                        }

                        strPreLoopID = delLoopID;
                        count++;
                    }
                    Warehousedt.AcceptChanges();


                    for (int i = 0; i < Warehousedt.Rows.Count; i++)
                    {
                        DataRow dr = Warehousedt.Rows[i];
                        string delSrlID = Convert.ToString(dr["SrlNo"]);
                        if (strKey == delSrlID)
                        {
                            dr.Delete();
                        }
                    }
                    Warehousedt.AcceptChanges();
                }

                Session["PC_WarehouseData"] = Warehousedt;
                GrdWarehouse.DataSource = Warehousedt.DefaultView;
                GrdWarehouse.DataBind();
            }
            else if (strSplitCommand == "WarehouseFinal")
            {
                if (Session["PC_WarehouseData"] != null)
                {
                    DataTable PC_WarehouseData = (DataTable)Session["PC_WarehouseData"];
                    string ProductID = Convert.ToString(hdfProductSerialID.Value);
                    decimal sum = 0;

                    for (int i = 0; i < PC_WarehouseData.Rows.Count; i++)
                    {
                        DataRow dr = PC_WarehouseData.Rows[i];
                        string delLoopID = Convert.ToString(dr["LoopID"]);
                        string Product_SrlNo = Convert.ToString(dr["Product_SrlNo"]);

                        if (ProductID == Product_SrlNo)
                        {
                            string strQuantity = (Convert.ToString(dr["SalesQuantity"]) != "") ? Convert.ToString(dr["SalesQuantity"]) : "0";
                            var weight = Decimal.Parse(Regex.Match(strQuantity, "[0-9]*\\.*[0-9]*").Value);

                            sum = sum + Convert.ToDecimal(weight);
                        }
                    }

                    if (Convert.ToDecimal(sum) == Convert.ToDecimal(hdnProductQuantity.Value))
                    {
                        GrdWarehouse.JSProperties["cpIsSave"] = "Y";
                        for (int i = 0; i < PC_WarehouseData.Rows.Count; i++)
                        {
                            DataRow dr = PC_WarehouseData.Rows[i];
                            string Product_SrlNo = Convert.ToString(dr["Product_SrlNo"]);
                            if (ProductID == Product_SrlNo)
                            {
                                dr["Status"] = "I";
                            }
                        }
                        PC_WarehouseData.AcceptChanges();
                    }
                    else
                    {
                        GrdWarehouse.JSProperties["cpIsSave"] = "N";
                    }

                    Session["PC_WarehouseData"] = PC_WarehouseData;
                }
            }
            else if (strSplitCommand == "WarehouseDelete")
            {
                string ProductID = Convert.ToString(hdfProductSerialID.Value);
                DeleteUnsaveWarehouse(ProductID);
            }
        }
        public void DeleteUnsaveWarehouse(string SrlNo)
        {
            DataTable Warehousedt = new DataTable();
            if (Session["PC_WarehouseData"] != null)
            {
                Warehousedt = (DataTable)Session["PC_WarehouseData"];

                var rows = Warehousedt.Select("Product_SrlNo ='" + SrlNo + "' AND Status='D'");
                foreach (var row in rows)
                {
                    row.Delete();
                }
                Warehousedt.AcceptChanges();

                Session["PC_WarehouseData"] = Warehousedt;
            }
        }
        public void GetProductType(ref string Type)
        {
            ProcedureExecute proc = new ProcedureExecute("prc_SalesCRM_Details");
            proc.AddVarcharPara("@Action", 500, "GetSchemeType");
            proc.AddVarcharPara("@ProductID", 100, Convert.ToString(hdfProductID.Value));
            DataTable dt = proc.GetTable();

            if (dt != null && dt.Rows.Count > 0)
            {
                Type = Convert.ToString(dt.Rows[0]["Type"]);
            }
        }
        public void GetProductUOM(ref string Sales_UOM_Name, ref string Sales_UOM_Code, ref string Stk_UOM_Name, ref string Stk_UOM_Code, ref string Conversion_Multiplier, string ProductID)
        {
            DataTable Productdt = GetProductDetailsData(ProductID);
            if (Productdt != null && Productdt.Rows.Count > 0)
            {
                Sales_UOM_Name = Convert.ToString(Productdt.Rows[0]["Sales_UOM_Name"]);
                Sales_UOM_Code = Convert.ToString(Productdt.Rows[0]["Sales_UOM_Code"]);
                Stk_UOM_Name = Convert.ToString(Productdt.Rows[0]["Stk_UOM_Name"]);
                Stk_UOM_Code = Convert.ToString(Productdt.Rows[0]["Stk_UOM_Code"]);
                Conversion_Multiplier = Convert.ToString(Productdt.Rows[0]["Conversion_Multiplier"]);
            }
        }
        public DataTable GetProductDetailsData(string ProductID)
        {
            DataTable dt = new DataTable();
            ProcedureExecute proc = new ProcedureExecute("prc_SalesCRM_Details");
            proc.AddVarcharPara("@Action", 500, "ProductDetailsSearch");
            proc.AddVarcharPara("@ProductID", 500, ProductID);
            dt = proc.GetTable();
            return dt;
        }
        protected void GrdWarehouse_DataBinding(object sender, EventArgs e)
        {
            if (Session["PC_WarehouseData"] != null)
            {
                string Type = "";
                GetProductType(ref Type);
                string SerialID = Convert.ToString(hdfProductSerialID.Value);
                DataTable Warehousedt = (DataTable)Session["PC_WarehouseData"];

                if (Warehousedt != null && Warehousedt.Rows.Count > 0)
                {
                    Warehousedt.DefaultView.Sort = "LoopID,SrlNo ASC";
                    DataTable sortWarehousedt = Warehousedt.DefaultView.ToTable();

                    DataView dvData = new DataView(sortWarehousedt);
                    dvData.RowFilter = "Product_SrlNo = '" + SerialID + "'";

                    GrdWarehouse.DataSource = dvData;
                }
                else
                {
                    GrdWarehouse.DataSource = Warehousedt.DefaultView;
                }
            }
        }
        protected void CallbackPanel_Callback(object source, DevExpress.Web.CallbackEventArgsBase e)
        {
            string performpara = e.Parameter;
            if (performpara.Split('~')[0] == "EditWarehouse")
            {
                string SrlNo = performpara.Split('~')[1];
                string ProductType = Convert.ToString(hdfProductType.Value);

                if (Session["PC_WarehouseData"] != null)
                {
                    DataTable Warehousedt = (DataTable)Session["PC_WarehouseData"];

                    string strWarehouse = "", strBatchID = "", strSrlID = "", strQuantity = "0", MfgDate = "", ExpiryDate = "";
                    var rows = Warehousedt.Select(string.Format("SrlNo ='{0}'", SrlNo));
                    foreach (var dr in rows)
                    {
                        strWarehouse = (Convert.ToString(dr["WarehouseID"]) != "") ? Convert.ToString(dr["WarehouseID"]) : "0";
                        strBatchID = (Convert.ToString(dr["BatchID"]) != "") ? Convert.ToString(dr["BatchID"]) : "";
                        MfgDate = (Convert.ToString(dr["MfgDate"]) != "") ? Convert.ToString(dr["MfgDate"]) : "";
                        ExpiryDate = (Convert.ToString(dr["ExpiryDate"]) != "") ? Convert.ToString(dr["ExpiryDate"]) : "";
                        strSrlID = (Convert.ToString(dr["SerialNo"]) != "") ? Convert.ToString(dr["SerialNo"]) : "";
                        strQuantity = (Convert.ToString(dr["Quantity"]) != "") ? Convert.ToString(dr["Quantity"]) : "0";
                    }

                    CallbackPanel.JSProperties["cpEdit"] = strWarehouse + "~" + strBatchID + "~" + MfgDate + "~" + ExpiryDate + "~" + strSrlID + "~" + strQuantity;
                }
            }
        }
        public void changeGridOrder()
        {
            string Type = "";
            GetProductType(ref Type);
            if (Type == "W")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = false;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = false;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = false;
                GrdWarehouse.Columns["SerialNo"].Visible = false;
            }
            else if (Type == "WB")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = false;
            }
            else if (Type == "WBS")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
            }
            else if (Type == "B")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = false;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = false;
            }
            else if (Type == "S")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = false;
                GrdWarehouse.Columns["BatchNo"].Visible = false;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = false;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = false;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
            }
            else if (Type == "WS")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = false;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = false;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = false;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
            }
            else if (Type == "BS")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = false;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
            }
        }
        public string GetWarehouseMaxValue(DataTable dt)
        {
            string maxValue = "1";
            if (dt != null && dt.Rows.Count > 0)
            {
                List<int> myList = new List<int>();
                foreach (DataRow rrow in dt.Rows)
                {
                    string value = (Convert.ToString(rrow["SrlNo"]) != "") ? Convert.ToString(rrow["SrlNo"]) : "0";
                    myList.Add(Convert.ToInt32(value));
                }

                maxValue = Convert.ToString(Convert.ToInt32(myList.Max()) + 1);
            }

            return maxValue;
        }
        public string GetWarehouseMaxLoopValue(DataTable dt)
        {
            string maxValue = "1";
            if (dt != null && dt.Rows.Count > 0)
            {
                List<int> myList = new List<int>();
                foreach (DataRow rrow in dt.Rows)
                {
                    string value = (Convert.ToString(rrow["LoopID"]) != "") ? Convert.ToString(rrow["LoopID"]) : "0";
                    myList.Add(Convert.ToInt32(value));
                }

                maxValue = Convert.ToString(Convert.ToInt32(myList.Max()) + 1);
            }

            return maxValue;
        }
        public int CheckSerialNoExists(string SerialNo)
        {
            string ProductID = Convert.ToString(hdfProductID.Value);
            string BranchID = Convert.ToString(ddl_Branch.SelectedValue);

            //string query = "SELECT SerialNo FROM v_Stock_WarehouseDetails Where ProductID<>'" + ProductID.Trim() + "' AND SerialNo='" + SerialNo.Trim() + "' AND Stock_IN_Out_Type='IN'";
            //DataTable SerialCount = oDBEngine.GetDataTable(query);

            //DataTable SerialCount = CheckDuplicateSerial(SerialNo, ProductID, BranchID, "PurchaseSide");
            DataTable SerialCount = CheckDuplicateSerial(SerialNo, ProductID, BranchID, "PurchaseChallan_Stock");
            return SerialCount.Rows.Count;
        }
        public void GetQuantityBaseOnProduct(string strProductSrlNo, ref decimal WarehouseQty)
        {
            decimal sum = 0;

            DataTable Warehousedt = new DataTable();
            if (Session["PC_WarehouseData"] != null)
            {
                Warehousedt = (DataTable)Session["PC_WarehouseData"];
                for (int i = 0; i < Warehousedt.Rows.Count; i++)
                {
                    DataRow dr = Warehousedt.Rows[i];
                    string Product_SrlNo = Convert.ToString(dr["Product_SrlNo"]);

                    if (strProductSrlNo == Product_SrlNo)
                    {
                        string strQuantity = (Convert.ToString(dr["SalesQuantity"]) != "") ? Convert.ToString(dr["SalesQuantity"]) : "0";
                        var weight = Decimal.Parse(Regex.Match(strQuantity, "[0-9]*\\.*[0-9]*").Value);

                        sum = sum + Convert.ToDecimal(weight);
                    }
                }
            }

            WarehouseQty = sum;
        }
        public DataTable GetChallanWarehouseData()
        {
            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_Purchasechallan_Details");
                proc.AddVarcharPara("@Action", 500, "GetChallanWarehouse");
                proc.AddVarcharPara("@PurchaseChallan_Id", 500, Convert.ToString(Session["PurchaseChallan_Id"]));
                dt = proc.GetTable();

                DataTable tempdt = new DataTable();
                if (dt != null && dt.Rows.Count > 0)
                {
                    var CheckStockOut_dt = dt.Select("IsOutStatusMsg='visibility: visible'");
                    if (CheckStockOut_dt.Length > 0)
                    {
                        dt_PLQuote.ClientEnabled = false;
                    }

                    string strNewVal = "", strOldVal = "", strProductType = "";
                    tempdt = dt.Copy();
                    foreach (DataRow drr in tempdt.Rows)
                    {
                        strNewVal = Convert.ToString(drr["QuoteWarehouse_Id"]);
                        strProductType = Convert.ToString(drr["ProductType"]);

                        if (strNewVal == strOldVal)
                        {
                            drr["WarehouseName"] = "";
                            drr["TotalQuantity"] = "0";
                            drr["BatchNo"] = "";
                            drr["SalesQuantity"] = "";
                            drr["ViewMfgDate"] = "";
                            drr["ViewExpiryDate"] = "";
                        }

                        strOldVal = strNewVal;
                    }

                    tempdt.Columns.Remove("QuoteWarehouse_Id");
                    tempdt.Columns.Remove("ProductType");

                    string maxLoopID = GetWarehouseMaxLoopValue(tempdt);
                    Session["PC_LoopWarehouse"] = maxLoopID;
                }
                else
                {
                    tempdt.Columns.Add("Product_SrlNo", typeof(string));
                    tempdt.Columns.Add("SrlNo", typeof(int));
                    tempdt.Columns.Add("WarehouseID", typeof(string));
                    tempdt.Columns.Add("WarehouseName", typeof(string));
                    tempdt.Columns.Add("Quantity", typeof(string));
                    tempdt.Columns.Add("TotalQuantity", typeof(string));
                    tempdt.Columns.Add("SalesQuantity", typeof(string));
                    tempdt.Columns.Add("SalesUOMName", typeof(string));
                    tempdt.Columns.Add("BatchID", typeof(string));
                    tempdt.Columns.Add("BatchNo", typeof(string));
                    tempdt.Columns.Add("MfgDate", typeof(string));
                    tempdt.Columns.Add("ExpiryDate", typeof(string));
                    tempdt.Columns.Add("SerialNo", typeof(string));
                    tempdt.Columns.Add("LoopID", typeof(string));
                    tempdt.Columns.Add("Status", typeof(string));
                    tempdt.Columns.Add("ViewMfgDate", typeof(string));
                    tempdt.Columns.Add("ViewExpiryDate", typeof(string));
                    tempdt.Columns.Add("IsOutStatus", typeof(string));
                    tempdt.Columns.Add("IsOutStatusMsg", typeof(string));

                    Session["PC_LoopWarehouse"] = "1";
                }

                return tempdt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable GetOrderWarehouseData(DataTable dt)
        {
            try
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    string strNewVal = "", strOldVal = "", strProductType = "";
                    dt = dt.Copy();
                    foreach (DataRow drr in dt.Rows)
                    {
                        strNewVal = Convert.ToString(drr["QuoteWarehouse_Id"]);
                        strProductType = Convert.ToString(drr["ProductType"]);

                        if (strNewVal == strOldVal)
                        {
                            drr["WarehouseName"] = "";
                            drr["TotalQuantity"] = "0";
                            drr["BatchNo"] = "";
                            drr["SalesQuantity"] = "";
                            drr["ViewMfgDate"] = "";
                            drr["ViewExpiryDate"] = "";
                        }

                        strOldVal = strNewVal;
                    }

                    dt.Columns.Remove("QuoteWarehouse_Id");
                    dt.Columns.Remove("ProductType");

                    string maxLoopID = GetWarehouseMaxLoopValue(dt);
                    Session["PC_LoopWarehouse"] = maxLoopID;
                }
                else
                {
                    dt.Columns.Add("Product_SrlNo", typeof(string));
                    dt.Columns.Add("SrlNo", typeof(int));
                    dt.Columns.Add("WarehouseID", typeof(string));
                    dt.Columns.Add("WarehouseName", typeof(string));
                    dt.Columns.Add("Quantity", typeof(string));
                    dt.Columns.Add("TotalQuantity", typeof(string));
                    dt.Columns.Add("SalesQuantity", typeof(string));
                    dt.Columns.Add("SalesUOMName", typeof(string));
                    dt.Columns.Add("BatchID", typeof(string));
                    dt.Columns.Add("BatchNo", typeof(string));
                    dt.Columns.Add("MfgDate", typeof(string));
                    dt.Columns.Add("ExpiryDate", typeof(string));
                    dt.Columns.Add("SerialNo", typeof(string));
                    dt.Columns.Add("LoopID", typeof(string));
                    dt.Columns.Add("Status", typeof(string));
                    dt.Columns.Add("ViewMfgDate", typeof(string));
                    dt.Columns.Add("ViewExpiryDate", typeof(string));
                    dt.Columns.Add("IsOutStatus", typeof(string));
                    dt.Columns.Add("IsOutStatusMsg", typeof(string));

                    Session["PC_LoopWarehouse"] = "1";
                }

                return dt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable CheckDuplicateSerial(string SerialNo, string ProductID, string BranchID, string Action)
        {
            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("proc_CheckDuplicateProduct");
                proc.AddVarcharPara("@Action", 500, Action);
                proc.AddVarcharPara("@SerialNo", 500, SerialNo);
                proc.AddVarcharPara("@ProductID", 500, ProductID);
                proc.AddVarcharPara("@BranchID", 500, BranchID);
                proc.AddVarcharPara("@DocID", 500, Convert.ToString(Session["PurchaseChallan_Id"]));
                dt = proc.GetTable();

                return dt;
            }
            catch
            {
                return null;
            }
        }
        public void DeleteWarehouse(string SrlNo)
        {
            DataTable Warehousedt = new DataTable();
            if (Session["PC_WarehouseData"] != null)
            {
                Warehousedt = (DataTable)Session["PC_WarehouseData"];

                var rows = Warehousedt.Select(string.Format("Product_SrlNo ='{0}'", SrlNo));
                foreach (var row in rows)
                {
                    row.Delete();
                }
                Warehousedt.AcceptChanges();

                Session["PC_WarehouseData"] = Warehousedt;
            }
        }

        #endregion

        #region Purchase Challan Mail
        public int Sendmail_PurchaseChallan(string Output)
        {
            int stat = 0;
            if (chkmail.Checked)
            {

                Employee_BL objemployeebal = new Employee_BL();
                ExceptionLogging mailobj = new ExceptionLogging();
                EmailSenderHelperEL emailSenderSettings = new EmailSenderHelperEL();
                DataTable dt_EmailConfig = new DataTable();
                DataTable dt_EmailConfigpurchase = new DataTable();

                DataTable dt_Emailbodysubject = new DataTable();
                PurchasechallanEmailTags fetchModel = new PurchasechallanEmailTags();
                string Subject = "";
                string Body = "";
                string emailTo = "";
                // dt_EmailConfig = objemployeebal.GetEmailAccountConfigDetails("", 13); 
                //  Dt_LevelUser = objemployeebal.GetAllLevelUsers("1", 12);
                int MailStatus = 0;


                // var customerid = lookup_Customer.GridView.GetRowValues(lookup_Customer.GridView.FocusedRowIndex, lookup_Customer.KeyFieldName).ToString();
                if (!string.IsNullOrEmpty(Convert.ToString(cmbContactPerson.Value)))
                {
                    var customerid = cmbContactPerson.Value.ToString();

                    dt_EmailConfig = objemployeebal.GetemailidsForChallan(customerid);
                }
                //string FilePath = ConfigurationManager.AppSettings["ReportPCpdf"].ToString() + "PO-Default-" + Output + ".pdf";
                string FilePath = Server.MapPath("~/Reports/RepxReportDesign/PurchaseChallan_Stock/DocDesign/PDFFiles/" + "PC-Default-" + Output + ".pdf");

                string FileName = FilePath;
                if (dt_EmailConfig.Rows.Count > 0)
                {
                    emailTo = Convert.ToString(dt_EmailConfig.Rows[0]["eml_email"]);
                    //  emailTo = "sayan.dutta@indusnet.co.in";
                    dt_Emailbodysubject = objemployeebal.Getemailtemplates("14");  //for purchase order

                    if (dt_Emailbodysubject.Rows.Count > 0)
                    {
                        Body = Convert.ToString(dt_Emailbodysubject.Rows[0]["body"]);
                        Subject = Convert.ToString(dt_Emailbodysubject.Rows[0]["subjct"]);

                        dt_EmailConfigpurchase = objemployeebal.Getemailtagsforpurchase(Output, "PurchaseChallanEmailTags");  //For Purchase Order Get all Tags Value

                        if (dt_EmailConfigpurchase.Rows.Count > 0)
                        {

                            fetchModel = DbHelpers.ToModel<PurchasechallanEmailTags>(dt_EmailConfigpurchase);

                            Body = Employee_BL.GetFormattedString<PurchasechallanEmailTags>(fetchModel, Body);
                            Subject = Employee_BL.GetFormattedString<PurchasechallanEmailTags>(fetchModel, Subject);


                        }

                        emailSenderSettings = mailobj.GetEmailSettingsforAllreport(emailTo, "", "", FilePath, Body, Subject);

                        if (emailSenderSettings.IsSuccess)
                        {
                            string Message = "";
                            // checkmailId = new SendEmailUL().CheckMailIdExistence(emailSenderSettings.ModelCast<EmailSenderEL>());
                            //if (checkmailId == true)
                            //{
                            EmailSenderEL obj2 = new EmailSenderEL();
                            stat = SendEmailUL.sendMailInHtmlFormat(emailSenderSettings.ModelCast<EmailSenderEL>(), out Message);
                            //}


                        }
                    }
                }



            }
            return stat;
        }
        #endregion

        #region Visibility of Send Mail

        public void VisiblitySendEmail()
        {
            Employee_BL objemployeebal = new Employee_BL();
            chkmail.Visible = true;
            if (Request.QueryString["key"] != "ADD")
            {
                chkmail.Visible = false;
            }
            DataTable dt2 = new DataTable();
            dt2 = objemployeebal.GetSystemsettingmail("Show Email in GRN");
            if (Convert.ToString(dt2.Rows[0]["Variable_Value"]) == "Yes")
            {
                chkmail.Visible = true;
            }
            else
            {
                chkmail.Visible = false;
            }


        }

        #endregion
    }
}