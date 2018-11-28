using DataAccessLayer;
using DevExpress.Web;
using DevExpress.Web.Data;
using EntityLayer.CommonELS;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ERP.OMS.Management.Master
{
    public partial class ProductsOpeningEntries : ERP.OMS.ViewState_class.VSPage
    {
        BusinessLogicLayer.DBEngine oDBEngine = new BusinessLogicLayer.DBEngine(string.Empty);
        public static EntityLayer.CommonELS.UserRightsForPage rights;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["userid"] != null)
            {
                if (!IsPostBack)
                {
                    rights = new UserRightsForPage();
                    rights = BusinessLogicLayer.CommonBLS.CommonBL.GetUserRightSession("/management/master/ProductsOpeningEntries.aspx");

                    GetBranchDetails();

                    // To Get Sotal Opening Value

                    DataTable computeDT = GetOpeningStockDetails();
                    string TotalSum = "0.00";

                    //if (computeDT != null && computeDT.Rows.Count > 0)
                    //{
                    //    object sumObject = computeDT.Compute("Sum(OpeningValue)", "");
                    //    TotalSum = Convert.ToString(sumObject);
                    //}
                    //lblTotalSum.Text = TotalSum;

                    // To Get Sotal Opening Value

                    OpeningGrid.DataSource = GetGriddata();
                    OpeningGrid.DataBind();
                }
            }
            else
            {
                Page.ClientScript.RegisterStartupScript(GetType(), "SighOff", "<script>SignOff();</script>");
            }
        }
        public void GetBranchDetails()
        {
            string userbranchHierarchy = Convert.ToString(Session["userbranchHierarchy"]);
            string userbranchID = Convert.ToString(Session["userbranchID"]);

            DataTable dt = GetBranchDetails(userbranchHierarchy);
            if (dt != null && dt.Rows.Count > 0)
            {
                cmbbranch.DataSource = dt;
                cmbbranch.DataBind();

                if (Session["userbranchID"] != null)
                {
                    cmbbranch.Value = userbranchID;
                }
            }
        }
        public DataTable GetBranchDetails(string userbranchHierarchy)
        {
            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_GetOpeningStockEntrys");
                proc.AddVarcharPara("@Action", 3000, "GetBranch");
                proc.AddVarcharPara("@BranchList", 3000, userbranchHierarchy);
                dt = proc.GetTable();
                return dt;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #region Export Event

        public void bindexport(int Filter)
        {
            string filename = "Opening Balances - Product";
            exporter.FileName = filename;

            exporter.PageHeader.Left = "Opening Balances - Product";
            exporter.PageFooter.Center = "[Page # of Pages #]";
            exporter.PageFooter.Right = "[Date Printed]";

            exporter.GridViewID = "openingGridExport";
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
            drdExport.SelectedIndex = 0;
        }
        protected void cmbExport_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 Filter = int.Parse(Convert.ToString(drdExport.SelectedItem.Value));
            if (Filter != 0)
            {
                bindexport(Filter);

                //if (Session["exportval"] == null)
                //{
                //    Session["exportval"] = Filter;
                //    bindexport(Filter);
                //}
                //else if (Convert.ToInt32(Session["exportval"]) != Filter)
                //{
                //    Session["exportval"] = Filter;
                //    bindexport(Filter);
                //}
            }
        }

        #endregion

        #region Grid Event

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
        protected void OpeningGrid_DataBinding(object sender, EventArgs e)
        {
            OpeningGrid.DataSource = GetGriddata();
        }
        protected void openingGridExport_DataBinding(object sender, EventArgs e)
        {
            openingGridExport.DataSource = GetOpeningStockDetailsForExport();
        }
        private IEnumerable GetGriddata()
        {
            List<Openinglist> Openinglists = new List<Openinglist>();
            DataTable dt = GetOpeningStockDetails();

            Openinglists = (from DataRow dr in dt.Rows
                            select new Openinglist()
                            {
                                StockID = Convert.ToString(dr["StockID"]),
                                ProductID = Convert.ToString(dr["ProductID"]),
                                ProductCode = Convert.ToString(dr["ProductCode"]),
                                ViewProductName = Convert.ToString(dr["ProductName"]),
                                ProductName = Convert.ToString(dr["ProductName"]).Replace("'", "squot").Replace(",", "coma").Replace("/", "slash"),
                                //ProductName = dr["ProductName"].ToString().Replace("'", "squot").Replace(",", "coma").Replace("/", "slash"),

                                UOM = Convert.ToString(dr["UOM"]),
                                AvailableStock = Convert.ToDecimal(dr["OpeningQty"]),
                                OpeningStock = Convert.ToDecimal(dr["OpeningQty"]),
                                OpeningValue = Convert.ToDecimal(dr["OpeningValue"]),
                                InventoryType = Convert.ToString(dr["InventoryType"]),
                                IsInventoryEnable = Convert.ToString(dr["IsInventoryEnable"]),
                                DefaultWarehouse = Convert.ToString(dr["DefaultWarehouse"])
                            }).ToList();

            return Openinglists;
        }
        public int GetvisibleIndex(object container)
        {
            GridViewDataItemTemplateContainer c = container as GridViewDataItemTemplateContainer;
            return c.VisibleIndex;
        }
        public DataTable GetOpeningStockDetails()
        {
            try
            {
                string BranchID = Convert.ToString(cmbbranch.Value);
                string CompanyID = Convert.ToString(Session["LastCompany"]);
                string FinYear = Convert.ToString(Session["LastFinYear"]);

                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_GetOpeningStockEntrys");
                proc.AddVarcharPara("@Action", 3000, "GetOpeningStock");
                proc.AddVarcharPara("@BranchID", 3000, BranchID);
                proc.AddVarcharPara("@CompanyID", 3000, CompanyID);
                proc.AddVarcharPara("@FinYear", 3000, FinYear);
                dt = proc.GetTable();
                return dt;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable GetOpeningStockDetailsForExport()
        {
            try
            {
                string BranchID = Convert.ToString(cmbbranch.Value);
                string CompanyID = Convert.ToString(Session["LastCompany"]);
                string FinYear = Convert.ToString(Session["LastFinYear"]);

                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_GetOpeningStockEntrys");
                proc.AddVarcharPara("@Action", 3000, "GetOpeningStockForExport");
                proc.AddVarcharPara("@BranchID", 3000, BranchID);
                proc.AddVarcharPara("@CompanyID", 3000, CompanyID);
                proc.AddVarcharPara("@FinYear", 3000, FinYear);
                dt = proc.GetTable();
                return dt;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        protected void OpeningGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string strSplitCommand = e.Parameters.Split('~')[0];

            if (strSplitCommand == "FinalSubmit")
            {
                string ProductID = Convert.ToString(hdfProductID.Value);
                string CompanyID = Convert.ToString(Session["LastCompany"]);
                string FinYear = Convert.ToString(Session["LastFinYear"]);
                string BranchID = Convert.ToString(cmbbranch.Value);
                string ProductQuantity = "0", validate = "";
                decimal strWarehouseQuantity = 0;

                DataTable tempWarehousedt = new DataTable();
                if (Session["Stock_WarehouseData"] != null)
                {
                    DataTable Warehousedt = (DataTable)Session["Stock_WarehouseData"];
                    tempWarehousedt = Warehousedt.DefaultView.ToTable(false, "Product_SrlNo", "LoopID", "WarehouseID", "Quantity", "BatchID", "SerialNo", "MfgDate", "ExpiryDate", "Rate");
                }
                else
                {
                    tempWarehousedt.Columns.Add("Product_SrlNo", typeof(string));
                    tempWarehousedt.Columns.Add("SrlNo", typeof(string));
                    tempWarehousedt.Columns.Add("WarehouseID", typeof(string));
                    tempWarehousedt.Columns.Add("Quantity", typeof(string));
                    tempWarehousedt.Columns.Add("BatchID", typeof(string));
                    tempWarehousedt.Columns.Add("SerialNo", typeof(string));
                    tempWarehousedt.Columns.Add("MfgDate", typeof(string));
                    tempWarehousedt.Columns.Add("ExpiryDate", typeof(string));
                    tempWarehousedt.Columns.Add("Rate", typeof(string));
                }


                GetQuantityBaseOnProduct(ProductID, ref strWarehouseQuantity);
                ProductQuantity = Convert.ToString(strWarehouseQuantity);

                if (validate == "checkWarehouse")
                {
                    OpeningGrid.JSProperties["cpfinalMsg"] = validate;
                }
                else
                {
                    int strIsComplete = 0;
                    ModifyStockOpening(ProductID, CompanyID, FinYear, BranchID, ProductQuantity, tempWarehousedt, ref strIsComplete);

                    if (strIsComplete == 1)
                    {
                        OpeningGrid.JSProperties["cpfinalMsg"] = "SuccesInsert";
                        OpeningGrid.DataSource = GetGriddata();
                        OpeningGrid.DataBind();
                    }
                    else
                    {
                        OpeningGrid.JSProperties["cpfinalMsg"] = "errorrInsert";
                    }
                }
            }
            else if (strSplitCommand == "ReBindGrid")
            {
                OpeningGrid.DataSource = GetGriddata();
                OpeningGrid.DataBind();
            }

            // To Get Sotal Opening Value

            DataTable computeDT = GetOpeningStockDetails();
            string TotalSum = "0.00";

            //if (computeDT != null && computeDT.Rows.Count > 0)
            //{
            //    object sumObject = computeDT.Compute("Sum(OpeningValue)", "");
            //    TotalSum = Convert.ToString(sumObject);
            //}

            OpeningGrid.JSProperties["cpTotalSum"] = TotalSum;
        }
        public void ModifyStockOpening(string ProductID, string CompanyID, string FinYear, string BranchID, string ProductQuantity, DataTable tempWarehousedt, ref int strIsComplete)
        {
            try
            {
                DataSet dsInst = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                SqlCommand cmd = new SqlCommand("proc_OpeningStock_Modify", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@ProductID", ProductID);
                cmd.Parameters.AddWithValue("@CompanyID", CompanyID);
                cmd.Parameters.AddWithValue("@FinYear", FinYear);
                cmd.Parameters.AddWithValue("@BranchID", BranchID);
                cmd.Parameters.AddWithValue("@ProductQuantity", ProductQuantity);
                cmd.Parameters.AddWithValue("@WarehouseDetail", tempWarehousedt);

                cmd.Parameters.Add("@ReturnValue", SqlDbType.VarChar, 50);
                cmd.Parameters["@ReturnValue"].Direction = ParameterDirection.Output;

                cmd.CommandTimeout = 0;
                SqlDataAdapter Adap = new SqlDataAdapter();
                Adap.SelectCommand = cmd;
                Adap.Fill(dsInst);

                strIsComplete = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value.ToString());

                cmd.Dispose();
                con.Dispose();
            }
            catch (Exception ex)
            {
            }
        }
        public class Openinglist
        {
            public string StockID { get; set; }
            public string ProductID { get; set; }
            public string ProductCode { get; set; }
            public string ProductName { get; set; }
            public string ViewProductName { get; set; }
            public string UOM { get; set; }
            public decimal AvailableStock { get; set; }
            public decimal OpeningStock { get; set; }
            public decimal OpeningValue { get; set; }
            public string InventoryType { get; set; }
            public string IsInventoryEnable { get; set; }
            public string DefaultWarehouse { get; set; }
        }

        #endregion

        #region Warehouse Details

        protected void CmbWarehouseID_Callback(object sender, CallbackEventArgsBase e)
        {
            string WhichCall = e.Parameter.Split('~')[0];

            if (WhichCall == "BindWarehouse")
            {
                DataTable dt = GetWarehouseData();
                //GetAvailableStock();

                CmbWarehouseID.Items.Clear();
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    CmbWarehouseID.Items.Add(Convert.ToString(dt.Rows[i]["WarehouseName"]), Convert.ToString(dt.Rows[i]["WarehouseID"]));
                }

                BusinessLogicLayer.DBEngine objEngine = new BusinessLogicLayer.DBEngine(ConfigurationManager.AppSettings["DBConnectionDefault"]);
                string strBranch = Convert.ToString(cmbbranch.Value);
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
            if (Session["Stock_WarehouseData"] != null)
            {
                Warehousedt = (DataTable)Session["Stock_WarehouseData"];
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
                Warehousedt.Columns.Add("Rate", typeof(string));
                Warehousedt.Columns.Add("ViewRate", typeof(string));
                Warehousedt.Columns.Add("IsOutStatus", typeof(string));
                Warehousedt.Columns.Add("IsOutStatusMsg", typeof(string));
            }

            Warehousedt.Columns["IsOutStatus"].DefaultValue = "visibility: visible";
            Warehousedt.Columns["IsOutStatusMsg"].DefaultValue = "visibility: hidden";


            if (strSplitCommand == "Display")
            {
                Session["Stock_LoopID"] = "1";
                Session["Stock_WarehouseData"] = GetStockData();

                //GetProductType(ref Type);
                Type = Convert.ToString(hdfProductType.Value);
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

                string warehouserateList = GetWarehouseRateList(SerialID);
                GrdWarehouse.JSProperties["cpRateList"] = warehouserateList;

            }
            else if (strSplitCommand == "SaveDisplay")
            {
                //GetProductType(ref Type);
                Type = Convert.ToString(hdfProductType.Value);
                int loopId = Convert.ToInt32(Session["Stock_LoopID"]);

                string WarehouseID = Convert.ToString(e.Parameters.Split('~')[1]);
                string WarehouseName = Convert.ToString(e.Parameters.Split('~')[2]);
                string BatchName = Convert.ToString(e.Parameters.Split('~')[3]);
                string MfgDate = Convert.ToString(e.Parameters.Split('~')[4]);
                string ExpiryDate = Convert.ToString(e.Parameters.Split('~')[5]);
                string SerialNo = Convert.ToString(e.Parameters.Split('~')[6]);
                string Qty = Convert.ToString(e.Parameters.Split('~')[7]);
                string editWarehouseID = Convert.ToString(e.Parameters.Split('~')[8]);
                string Rate = Convert.ToString(e.Parameters.Split('~')[9]);

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
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                    row["Rate"] = Rate;
                                    newloopID = Convert.ToInt32(row["LoopID"]);


                                    if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                    {
                                        row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                        row["ViewMfgDate"] = MfgDate;
                                        row["ViewExpiryDate"] = ExpiryDate;
                                        row["ViewRate"] = Rate;
                                    }
                                }
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "", Rate, "");
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
                                string Pre_batcgid = "", Pre_batchname = "", Pre_warehouse = "", Pre_warehouseName = "", Pre_MfgDate = "", Pre_ExpiryDate = "", Pre_Rate = "";

                                var oldrows = Warehousedt.Select("SrlNo='" + editWarehouseID + "'");
                                foreach (var roww in oldrows)
                                {
                                    Pre_warehouse = Convert.ToString(roww["WarehouseID"]);
                                    Pre_warehouseName = Convert.ToString(roww["WarehouseName"]);
                                    Pre_batcgid = Convert.ToString(roww["BatchID"]);
                                    Pre_batchname = Convert.ToString(roww["BatchID"]);
                                    Pre_MfgDate = Convert.ToString(roww["MfgDate"]);
                                    Pre_ExpiryDate = Convert.ToString(roww["ExpiryDate"]);
                                    Pre_Rate = Convert.ToString(roww["Rate"]);

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
                                        updaterow["Rate"] = Rate;

                                        if (Convert.ToString(updaterow["ViewMfgDate"]) != "") updaterow["ViewMfgDate"] = MfgDate;
                                        if (Convert.ToString(updaterow["ViewExpiryDate"]) != "") updaterow["ViewExpiryDate"] = ExpiryDate;
                                        if (Convert.ToString(updaterow["ViewRate"]) != "") updaterow["ViewRate"] = Rate;
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
                                            updaterow["ViewRate"] = Pre_Rate;

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
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                            row["Rate"] = Rate;
                                            newloopID = Convert.ToInt32(row["LoopID"]);

                                            if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                            {
                                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                                row["ViewMfgDate"] = MfgDate;
                                                row["ViewExpiryDate"] = ExpiryDate;
                                                row["ViewRate"] = Rate;
                                            }
                                        }
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "", Rate, "");
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
                            Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
                        }
                        else
                        {
                            foreach (var row in updaterows)
                            {
                                decimal oldQuantity = Convert.ToDecimal(row["Quantity"]);
                                row["Quantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["TotalQuantity"] = (oldQuantity + Convert.ToDecimal(Qty));
                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(Qty)) + " " + Sales_UOM_Name;
                                row["Rate"] = Rate;
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
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                    row["Rate"] = Rate;
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
                                    row["Rate"] = Rate;
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
                            Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                row["Rate"] = Rate;
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
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                    row["Rate"] = Rate;
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
                                    row["Rate"] = Rate;
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
                            Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                row["Rate"] = Rate;
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
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, Qty, Qty, Convert.ToDecimal(Qty) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                    row["Rate"] = Rate;
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
                                    row["Rate"] = Rate;
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

                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate, Rate, Rate);
                            }
                            else
                            {
                                newloopID = loopId;
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal(1) + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                    row["Rate"] = Rate;

                                    newloopID = Convert.ToInt32(row["LoopID"]);

                                    if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                    {
                                        row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                        row["ViewRate"] = Rate;
                                    }
                                }

                                //Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate, Rate, "");
                                DataRow dr = Warehousedt.NewRow();
                                dr["Product_SrlNo"] = ProductSerialID.ToString();
                                dr["SrlNo"] = Convert.ToInt32(maxID);
                                dr["WarehouseID"] = WarehouseID.ToString();
                                dr["WarehouseName"] = "";
                                dr["Quantity"] = (oldQuantity + Convert.ToDecimal(1)).ToString();
                                dr["TotalQuantity"] = "0";
                                dr["SalesQuantity"] = "";
                                dr["SalesUOMName"] = Sales_UOM_Name.ToString();
                                dr["BatchID"] = BatchName.ToString();
                                dr["BatchNo"] = BatchName.ToString();
                                dr["MfgDate"] = MfgDate.ToString();
                                dr["ExpiryDate"] = ExpiryDate.ToString();
                                dr["SerialNo"] = SerialNo.ToString();
                                dr["LoopID"] = newloopID.ToString();
                                dr["Status"] = "D";
                                dr["ViewMfgDate"] = MfgDate.ToString();
                                dr["ViewExpiryDate"] = ExpiryDate.ToString();
                                dr["Rate"] = Rate.ToString();
                                dr["ViewRate"] = "D";
                                dr["IsOutStatus"] = "visibility: visible";
                                dr["IsOutStatusMsg"] = "visibility: hidden";
                                Warehousedt.Rows.Add(dr);
                            }
                        }
                        else
                        {
                            GrdWarehouse.JSProperties["cperrorMsg"] = "duplicateSerial";
                        }
                    }
                    else
                    {
                        SerialNoCount_Server = CheckProductSerialNoExists(SerialNo);
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
                                            updaterow["ViewRate"] = Rate;

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
                                            updaterow["ViewRate"] = Rate;
                                        }
                                        else
                                        {
                                            updaterow["Quantity"] = (PreQuantity - Convert.ToDecimal(1));
                                            updaterow["TotalQuantity"] = "0";
                                            updaterow["WarehouseName"] = "";
                                            updaterow["ViewRate"] = "";
                                        }
                                    }

                                    string maxID = GetWarehouseMaxValue(Warehousedt);
                                    var updaterows = Warehousedt.Select("WarehouseID ='" + WarehouseID + "' AND Product_SrlNo='" + ProductSerialID + "'");

                                    if (updaterows.Length == 0)
                                    {
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                            row["Rate"] = Rate;
                                            row["ViewRate"] = "";
                                            newloopID = Convert.ToInt32(row["LoopID"]);

                                            if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                            {
                                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                                row["ViewRate"] = Rate;
                                            }
                                        }
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, newloopID, "D", MfgDate, ExpiryDate, Rate, "");
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
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                    row["Rate"] = Rate;
                                    newloopID = Convert.ToInt32(row["LoopID"]);

                                    if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                    {
                                        row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                    }
                                }
                                Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "", Rate, "");
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
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, WarehouseName, "1", "1", Convert.ToDecimal("1") + " " + Sales_UOM_Name, Sales_UOM_Name, BatchName, BatchName, MfgDate, ExpiryDate, SerialNo, loopId, "D", MfgDate, ExpiryDate, Rate, Rate);
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
                                            row["Rate"] = Rate;
                                            newloopID = Convert.ToInt32(row["LoopID"]);

                                            if (Convert.ToDecimal(row["TotalQuantity"]) != 0)
                                            {
                                                row["SalesQuantity"] = (oldQuantity + Convert.ToDecimal(1)) + " " + Sales_UOM_Name;
                                            }
                                        }
                                        Warehousedt.Rows.Add(ProductSerialID, maxID, WarehouseID, "", (oldQuantity + Convert.ToDecimal(1)), "0", "", Sales_UOM_Name, BatchName, "", MfgDate, ExpiryDate, SerialNo, newloopID, "D", "", "", Rate, "");
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

                if (editWarehouseID != "0")
                {
                    var updatedrows = Warehousedt.Select("SrlNo='" + editWarehouseID + "'");
                    string updatedLoopID = "";

                    foreach (DataRow rows in updatedrows)
                    {
                        updatedLoopID = Convert.ToString(rows["LoopID"]);
                    }

                    if(updatedLoopID!="")
                    {
                        var Needupdatedrows = Warehousedt.Select("LoopID='" + updatedLoopID + "'");
                        foreach (DataRow _rows in Needupdatedrows)
                        {
                            if (Convert.ToString(_rows["SalesQuantity"]) != "")
                            {
                                _rows["Rate"] = Rate;
                                _rows["ViewRate"] = Rate;
                            }
                            else
                            {
                                _rows["Rate"] = Rate;
                                _rows["ViewRate"] = "";
                            }
                        }
                    }
                }

                Session["Stock_WarehouseData"] = Warehousedt;
                Session["Stock_LoopID"] = loopId + 1;
                changeGridOrder();

                Warehousedt.DefaultView.Sort = "LoopID,SrlNo ASC";
                GrdWarehouse.DataSource = Warehousedt.DefaultView.ToTable();
                GrdWarehouse.DataBind();
            }
            else if (strSplitCommand == "Delete")
            {
                string strKey = e.Parameters.Split('~')[1];
                string strLoopID = "", strPreLoopID = "";

                if (Session["Stock_WarehouseData"] != null)
                {
                    Warehousedt = (DataTable)Session["Stock_WarehouseData"];
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

                Session["Stock_WarehouseData"] = Warehousedt;
                GrdWarehouse.DataSource = Warehousedt.DefaultView;
                GrdWarehouse.DataBind();
            }

            decimal strWarehouseQuantity = 0;
            string Product_ID = Convert.ToString(hdfProductID.Value);
            GetQuantityBaseOnProduct(Product_ID, ref strWarehouseQuantity);
            txt_EnteredSalesAmount.Text = Convert.ToString(strWarehouseQuantity);
            GrdWarehouse.JSProperties["cpEnteredQty"] = Convert.ToString(strWarehouseQuantity);
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
            if (Session["Stock_WarehouseData"] != null)
            {
                string Type = "";
                //GetProductType(ref Type);
                Type = Convert.ToString(hdfProductType.Value);

                string SerialID = Convert.ToString(hdfProductSerialID.Value);
                DataTable Warehousedt = (DataTable)Session["Stock_WarehouseData"];

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

                if (Session["Stock_WarehouseData"] != null)
                {
                    DataTable Warehousedt = (DataTable)Session["Stock_WarehouseData"];

                    string strWarehouse = "", strBatchID = "", strSrlID = "", strQuantity = "0", MfgDate = "", ExpiryDate = "", Rate = "";
                    var rows = Warehousedt.Select(string.Format("SrlNo ='{0}'", SrlNo));
                    foreach (var dr in rows)
                    {
                        strWarehouse = (Convert.ToString(dr["WarehouseID"]) != "") ? Convert.ToString(dr["WarehouseID"]) : "0";
                        strBatchID = (Convert.ToString(dr["BatchID"]) != "") ? Convert.ToString(dr["BatchID"]) : "";
                        MfgDate = (Convert.ToString(dr["MfgDate"]) != "") ? Convert.ToString(dr["MfgDate"]) : "";
                        ExpiryDate = (Convert.ToString(dr["ExpiryDate"]) != "") ? Convert.ToString(dr["ExpiryDate"]) : "";
                        strSrlID = (Convert.ToString(dr["SerialNo"]) != "") ? Convert.ToString(dr["SerialNo"]) : "";
                        strQuantity = (Convert.ToString(dr["Quantity"]) != "") ? Convert.ToString(dr["Quantity"]) : "0";
                        Rate = (Convert.ToString(dr["Rate"]) != "") ? Convert.ToString(dr["Rate"]) : "0";
                    }

                    CallbackPanel.JSProperties["cpEdit"] = strWarehouse + "~" + strBatchID + "~" + MfgDate + "~" + ExpiryDate + "~" + strSrlID + "~" + strQuantity + "~" + Rate;
                }
            }
        }
        public void changeGridOrder()
        {
            string Type = "";
            //GetProductType(ref Type);
            Type = Convert.ToString(hdfProductType.Value);

            if (Type == "W")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = false;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = false;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = false;
                GrdWarehouse.Columns["SerialNo"].Visible = false;
                GrdWarehouse.Columns["ViewRate"].Visible = true;
            }
            else if (Type == "WB")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = false;
                GrdWarehouse.Columns["ViewRate"].Visible = true;
            }
            else if (Type == "WBS")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
                GrdWarehouse.Columns["ViewRate"].Visible = true;
            }
            else if (Type == "B")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = false;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = false;
                GrdWarehouse.Columns["ViewRate"].Visible = false;
            }
            else if (Type == "S")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = false;
                GrdWarehouse.Columns["BatchNo"].Visible = false;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = false;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = false;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
                GrdWarehouse.Columns["ViewRate"].Visible = false;
            }
            else if (Type == "WS")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = true;
                GrdWarehouse.Columns["BatchNo"].Visible = false;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = false;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = false;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
                GrdWarehouse.Columns["ViewRate"].Visible = true;
            }
            else if (Type == "BS")
            {
                GrdWarehouse.Columns["WarehouseName"].Visible = false;
                GrdWarehouse.Columns["BatchNo"].Visible = true;
                GrdWarehouse.Columns["ViewMfgDate"].Visible = true;
                GrdWarehouse.Columns["ViewExpiryDate"].Visible = true;
                GrdWarehouse.Columns["SerialNo"].Visible = true;
                GrdWarehouse.Columns["ViewRate"].Visible = false;
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
            string BranchID = Convert.ToString(cmbbranch.Value);
            //string query = "SELECT SerialNo FROM v_Stock_WarehouseDetails Where ProductID<>'" + ProductID.Trim() + "' AND SerialNo='" + SerialNo.Trim() + "' AND BranchID<>'" + BranchID.Trim() + "' AND Stock_IN_Out_Type='IN'";
            //DataTable SerialCount = oDBEngine.GetDataTable(query);

            //DataTable SerialCount = CheckDuplicateSerial(SerialNo, ProductID, BranchID, "PurchaseSide");
            DataTable SerialCount = CheckDuplicateSerial(SerialNo, ProductID, BranchID, "OpeningStock");
            return SerialCount.Rows.Count;
        }
        public int CheckProductSerialNoExists(string SerialNo)
        {
            string ProductID = Convert.ToString(hdfProductID.Value);
            string BranchID = Convert.ToString(cmbbranch.Value);

            DataTable SerialCount = CheckDuplicateSerial(SerialNo, ProductID, BranchID, "OpeningStockProduct");
            return SerialCount.Rows.Count;
        }
        public void GetQuantityBaseOnProduct(string strProductSrlNo, ref decimal WarehouseQty)
        {
            decimal sum = 0;

            DataTable Warehousedt = new DataTable();
            if (Session["Stock_WarehouseData"] != null)
            {
                Warehousedt = (DataTable)Session["Stock_WarehouseData"];
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

                string strNewVal = "", strOldVal = "", strProductType = "";
                DataTable tempdt = dt.Copy();
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

                Session["Stock_LoopID"] = Convert.ToString(Convert.ToInt32(strNewVal) + 1);
                tempdt.Columns.Remove("QuoteWarehouse_Id");
                tempdt.Columns.Remove("ProductType");
                return tempdt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable GetWarehouseData()
        {
            string strBranch = Convert.ToString(cmbbranch.Value);

            DataTable dt = new DataTable();
            dt = oDBEngine.GetDataTable("select  bui_id as WarehouseID,bui_Name as WarehouseName from tbl_master_building Where IsNull(bui_BranchId,0) in ('0','" + strBranch + "') order by bui_Name");
            return dt;
        }
        public DataTable GetStockData()
        {
            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_GetOpeningStockEntrys");
                proc.AddVarcharPara("@Action", 500, "GetStockDetails");
                proc.AddVarcharPara("@ProductID", 500, Convert.ToString(hdfProductID.Value));
                proc.AddVarcharPara("@CompanyID", 500, Convert.ToString(Session["LastCompany"]));
                proc.AddVarcharPara("@FinYear", 500, Convert.ToString(Session["LastFinYear"]));
                proc.AddVarcharPara("@BranchID", 500, Convert.ToString(cmbbranch.Value));
                dt = proc.GetTable();

                string strNewVal = "", strOldVal = "", strProductType = "";
                DataTable tempdt = dt.Copy();

                if (tempdt != null && tempdt.Rows.Count > 0)
                {
                    foreach (DataRow drr in tempdt.Rows)
                    {
                        strNewVal = Convert.ToString(drr["LoopID"]);
                        strProductType = Convert.ToString(drr["ProductType"]);

                        if (strNewVal == strOldVal)
                        {
                            drr["WarehouseName"] = "";
                            drr["TotalQuantity"] = "0";
                            drr["BatchNo"] = "";
                            drr["SalesQuantity"] = "";
                            drr["ViewMfgDate"] = "";
                            drr["ViewExpiryDate"] = "";
                            drr["ViewRate"] = "";
                        }

                        strOldVal = strNewVal;
                    }

                    string maxLoopID = GetWarehouseMaxLoopValue(tempdt);
                    Session["Stock_LoopID"] = maxLoopID;
                    tempdt.Columns.Remove("ProductType");
                }
                else
                {
                    DataTable Warehousedt = new DataTable();
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
                    Warehousedt.Columns.Add("Rate", typeof(string));
                    Warehousedt.Columns.Add("ViewRate", typeof(string));
                    Warehousedt.Columns.Add("IsOutStatus", typeof(string));
                    Warehousedt.Columns.Add("IsOutStatusMsg", typeof(string));

                    Session["Stock_LoopID"] = "1";
                    tempdt = Warehousedt;
                }

                return tempdt;
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
                dt = proc.GetTable();

                return dt;
            }
            catch
            {
                return null;
            }
        }
        public DataTable GetWarehouseRate(string ProductID)
        {
            try
            {
                DataTable dt = new DataTable();
                ProcedureExecute proc = new ProcedureExecute("prc_GetOpeningStockEntrys");
                proc.AddVarcharPara("@Action", 500, "GetWarehouseRate");
                proc.AddVarcharPara("@BranchID", 3000,  Convert.ToString(cmbbranch.Value));
                proc.AddVarcharPara("@FinYear", 3000,  Convert.ToString(Session["LastFinYear"]));
                proc.AddVarcharPara("@CompanyID", 3000, Convert.ToString(Session["LastCompany"]));
                proc.AddVarcharPara("@ProductID", 3000,  Convert.ToString(ProductID));
                dt = proc.GetTable();

                return dt;
            }
            catch
            {
                return null;
            }
        }
        public string GetWarehouseRateList( string ProductID)
        {
            List<WarehouseRate> warehouseRateList = new List<WarehouseRate>();

            DataTable dt = GetWarehouseRate(ProductID);

            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    WarehouseRate WarehouseRates = new WarehouseRate();

                    string WarehouseID = Convert.ToString(dt.Rows[i]["WarehouseID"]);
                    string OpeningRate = Convert.ToString(dt.Rows[i]["OpeningRate"]);

                    WarehouseRates.WarehouseID = WarehouseID;
                    WarehouseRates.Rate = Convert.ToDecimal(OpeningRate);

                    warehouseRateList.Add(WarehouseRates);
                }
            }

            return JsonConvert.SerializeObject(warehouseRateList);
        }

        #endregion
    }

    public class WarehouseRate
    {
        public string WarehouseID { get; set; }
        public decimal Rate { get; set; }

    }
}