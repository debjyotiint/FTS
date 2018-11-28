<%@ Page Title="Opening Balances - Product(s)" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="ProductsOpeningEntries.aspx.cs" Inherits="ERP.OMS.Management.Master.ProductsOpeningEntries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        var currentEditableVisibleIndex;

        function OnKeyDown(s, e) {
            if (e.htmlEvent.keyCode == 40 || e.htmlEvent.keyCode == 38)
                return ASPxClientUtils.PreventEvent(e.htmlEvent);
        }

        function OnBatchStartEdit(s, e) {
            currentEditableVisibleIndex = e.visibleIndex;
        }

        function OnEndCallback(s, e) {
            if (OpeningGrid.cpfinalMsg == "checkWarehouse") {
                OpeningGrid.cpfinalMsg = null;
                jAlert("You have entered Quantity greater than Opening Quantity. Cannot Proceed.");
            }
            else if (OpeningGrid.cpfinalMsg == "errorrInsert") {
                OpeningGrid.cpfinalMsg = null;
                jAlert("Try after sometime.");
            }
            else if (OpeningGrid.cpfinalMsg == "SuccesInsert") {
                OpeningGrid.cpfinalMsg = null;
                cPopup_Warehouse.Hide();
                jAlert("Saved Successfully.");
            }

            if (OpeningGrid.cpTotalSum != null) {
                var TotalSum = OpeningGrid.cpTotalSum;
                OpeningGrid.cpTotalSum = null;
                document.getElementById('<%=lblTotalSum.ClientID %>').innerHTML = TotalSum;
            }
        }
    </script>
    <script>
        var SelectedWarehouseID = "0";
        var SelectWarehouse = "0";
        var IsFocus = "0";
        var warehouserateList;


        function CheckProductStockdetails(ProductID, ProductName, UOM, VisibleIndex, DefaultWarehouse) {
            currentEditableVisibleIndex = VisibleIndex;
            //OpeningGrid.batchEditApi.StartEdit(currentEditableVisibleIndex, 9)
            OpeningGrid.batchEditApi.StartEdit(currentEditableVisibleIndex);

            var InventoryType = "", AvailableStock = "", OpeningStock = "";

            if (OpeningGrid.GetEditor('InventoryType').GetValue() != null) InventoryType = OpeningGrid.GetEditor('InventoryType').GetValue();
            if (OpeningGrid.GetEditor('AvailableStock').GetValue() != null) AvailableStock = OpeningGrid.GetEditor('AvailableStock').GetValue();
            //if (OpeningGrid.GetEditor('OpeningStock').GetValue() != null) OpeningStock = OpeningGrid.GetEditor('OpeningStock').GetValue();

            document.getElementById('<%=lblProductName.ClientID %>').innerHTML = ProductName.replace("squot", "'").replace("coma", ",").replace("slash", "/");
            document.getElementById('<%=lblAvailableStock.ClientID %>').innerHTML = AvailableStock;
            document.getElementById('<%=lblAvailableStockUOM.ClientID %>').innerHTML = UOM;
            //document.getElementById('<%=txt_EnteredSalesAmount.ClientID %>').innerHTML = QuantityValue;
            document.getElementById('<%=txt_EnteredSalesUOM.ClientID %>').innerHTML = UOM;

            SelectWarehouse = "0";
            $("#spnCmbWarehouse").hide();
            $("#spntxtBatch").hide();
            $("#spntxtQuantity").hide();
            $("#spntxtserialID").hide();

            $('#<%=hdfProductType.ClientID %>').val(InventoryType);
            $('#<%=hdfProductID.ClientID %>').val(ProductID);
            $('#<%=hdfProductSerialID.ClientID %>').val(ProductID);
            $('#<%=hdndefaultID.ClientID %>').val(DefaultWarehouse);

            ctxtQuantity.SetValue("0");
            ctxtRate.SetValue("0");
            ctxtBatchName.SetValue("");
            ctxtserialID.SetValue("");
            warehouserateList = "";

            if (InventoryType == "W") {
                div_Warehouse.style.display = 'block';
                div_Rate.style.display = 'block';
                div_Batch.style.display = 'none';
                div_Manufacture.style.display = 'none';
                div_Expiry.style.display = 'none';
                div_Quantity.style.display = 'block';
                div_Serial.style.display = 'none';
                div_Break.style.display = 'none';
                div_Rate_Break.style.display = 'none';

                SelectedWarehouseID = "0";
                cGrdWarehouse.PerformCallback('Display~' + ProductID);
                cCmbWarehouseID.PerformCallback('BindWarehouse');
                cPopup_Warehouse.Show();
            }
            else if (InventoryType == "B") {
                div_Warehouse.style.display = 'none';
                div_Rate.style.display = 'none';
                div_Batch.style.display = 'block';
                div_Manufacture.style.display = 'block';
                div_Expiry.style.display = 'block';
                div_Quantity.style.display = 'block';
                div_Serial.style.display = 'none';
                div_Break.style.display = 'none';
                div_Rate_Break.style.display = 'none';

                SelectedWarehouseID = "0";
                cGrdWarehouse.PerformCallback('Display~' + ProductID);
                cPopup_Warehouse.Show();
            }
            else if (InventoryType == "S") {
                div_Warehouse.style.display = 'none';
                div_Rate.style.display = 'none';
                div_Batch.style.display = 'none';
                div_Manufacture.style.display = 'none';
                div_Expiry.style.display = 'none';
                div_Quantity.style.display = 'none';
                div_Serial.style.display = 'block';
                div_Break.style.display = 'none';
                div_Rate_Break.style.display = 'none';

                SelectedWarehouseID = "0";
                cGrdWarehouse.PerformCallback('Display~' + ProductID);
                cPopup_Warehouse.Show();
            }
            else if (InventoryType == "WB") {
                div_Warehouse.style.display = 'block';
                div_Rate.style.display = 'block';
                div_Batch.style.display = 'block';
                div_Manufacture.style.display = 'block';
                div_Expiry.style.display = 'block';
                div_Quantity.style.display = 'block';
                div_Serial.style.display = 'none';
                div_Break.style.display = 'none';
                div_Rate_Break.style.display = 'block';

                SelectedWarehouseID = "0";
                cGrdWarehouse.PerformCallback('Display~' + ProductID);
                cCmbWarehouseID.PerformCallback('BindWarehouse');
                cPopup_Warehouse.Show();
            }
            else if (InventoryType == "WS") {
                div_Warehouse.style.display = 'block';
                div_Rate.style.display = 'block';
                div_Batch.style.display = 'none';
                div_Manufacture.style.display = 'none';
                div_Expiry.style.display = 'none';
                div_Quantity.style.display = 'none';
                div_Serial.style.display = 'block';
                div_Break.style.display = 'block';
                div_Rate_Break.style.display = 'none';

                SelectedWarehouseID = "0";
                cGrdWarehouse.PerformCallback('Display~' + ProductID);
                cCmbWarehouseID.PerformCallback('BindWarehouse');
                cPopup_Warehouse.Show();
            }
            else if (InventoryType == "WBS") {
                div_Warehouse.style.display = 'block';
                div_Rate.style.display = 'block';
                div_Batch.style.display = 'block';
                div_Manufacture.style.display = 'block';
                div_Expiry.style.display = 'block';
                div_Quantity.style.display = 'none';
                div_Serial.style.display = 'block';
                div_Break.style.display = 'block';
                div_Rate_Break.style.display = 'block';

                SelectedWarehouseID = "0";
                cGrdWarehouse.PerformCallback('Display~' + ProductID);
                cCmbWarehouseID.PerformCallback('BindWarehouse');
                cPopup_Warehouse.Show();
            }
            else if (InventoryType == "BS") {
                div_Warehouse.style.display = 'none';
                div_Rate.style.display = 'none';
                div_Batch.style.display = 'block';
                div_Manufacture.style.display = 'block';
                div_Expiry.style.display = 'block';
                div_Quantity.style.display = 'none';
                div_Serial.style.display = 'block';
                div_Break.style.display = 'none';
                div_Rate_Break.style.display = 'none';

                SelectedWarehouseID = "0";
                cGrdWarehouse.PerformCallback('Display~' + ProductID);
                cPopup_Warehouse.Show();
            }
            else {
                div_Warehouse.style.display = 'none';
                div_Rate.style.display = 'none';
                div_Batch.style.display = 'none';
                div_Manufacture.style.display = 'none';
                div_Expiry.style.display = 'none';
                div_Quantity.style.display = 'none';
                div_Serial.style.display = 'none';
            }
        }

        function closeWarehouse(s, e) {
            e.cancel = false;
        }
        function GetDateFormat(today) {
            if (today != "") {
                var dd = today.getDate();
                var mm = today.getMonth() + 1; //January is 0!

                var yyyy = today.getFullYear();
                if (dd < 10) {
                    dd = '0' + dd;
                }
                if (mm < 10) {
                    mm = '0' + mm;
                }
                today = dd + '-' + mm + '-' + yyyy;
            }

            return today;
        }
        function GetReverseDateFormat(today) {
            if (today != "") {
                var dd = today.substring(0, 2);
                var mm = today.substring(3, 5);
                var yyyy = today.substring(6, 10);

                today = mm + '-' + dd + '-' + yyyy;
            }

            return today;
        }
        function SubmitWarehouse() {
            debugger;
            var WarehouseID = (cCmbWarehouseID.GetValue() != null) ? cCmbWarehouseID.GetValue() : "0";
            var WarehouseName = (cCmbWarehouseID.GetText() != null) ? cCmbWarehouseID.GetText() : "";
            var BatchName = (ctxtBatchName.GetValue() != null) ? ctxtBatchName.GetValue() : "";
            var MfgDate = (ctxtStartDate.GetValue() != null) ? ctxtStartDate.GetValue() : "";
            var ExpiryDate = (ctxtEndDate.GetValue() != null) ? ctxtEndDate.GetValue() : "";
            var SerialNo = (ctxtserialID.GetValue() != null) ? ctxtserialID.GetValue() : "";
            var Rate = (ctxtRate.GetValue() != null) ? ctxtRate.GetValue() : "";
            var Qty = ctxtQuantity.GetValue();

            MfgDate = GetDateFormat(MfgDate);
            ExpiryDate = GetDateFormat(ExpiryDate);

            $("#spnCmbWarehouse").hide();
            $("#spntxtBatch").hide();
            $("#spntxtQuantity").hide();
            $("#spntxtserialID").hide();

            var Ptype = document.getElementById('hdfProductType').value;
            if ((Ptype == "W" && WarehouseID == "0") || (Ptype == "WB" && WarehouseID == "0") || (Ptype == "WS" && WarehouseID == "0") || (Ptype == "WBS" && WarehouseID == "0")) {
                $("#spnCmbWarehouse").show();
            }
            else if ((Ptype == "B" && BatchName == "") || (Ptype == "WB" && BatchName == "") || (Ptype == "WBS" && BatchName == "") || (Ptype == "BS" && BatchName == "")) {
                $("#spntxtBatch").show();
            }
            else if ((Ptype == "W" && Qty == "0.0") || (Ptype == "B" && Qty == "0.0") || (Ptype == "WB" && Qty == "0.0")) {
                $("#spntxtQuantity").show();
            }
            else if ((Ptype == "S" && SerialNo == "") || (Ptype == "WS" && SerialNo == "") || (Ptype == "WBS" && SerialNo == "") || (Ptype == "BS" && SerialNo == "")) {
                $("#spntxtserialID").show();
            }
            else {
                if ((Ptype == "S" && SelectedWarehouseID == "0") || (Ptype == "WS" && SelectedWarehouseID == "0") || (Ptype == "WBS" && SelectedWarehouseID == "0") || (Ptype == "BS" && SelectedWarehouseID == "0")) {
                    ctxtserialID.SetValue("");
                    ctxtserialID.Focus();
                    IsFocus = "1";
                }
                else {
                    cCmbWarehouseID.PerformCallback('BindWarehouse');
                    ctxtQuantity.SetValue("0");
                    ctxtRate.SetValue("0");
                    ctxtBatchName.SetValue("");
                    ctxtStartDate.SetDate(null);
                    ctxtEndDate.SetDate(null);
                    ctxtserialID.SetValue("");
                }

                cGrdWarehouse.PerformCallback('SaveDisplay~' + WarehouseID + '~' + WarehouseName + '~' + BatchName + '~' + MfgDate + '~' + ExpiryDate + '~' + SerialNo + '~' + Qty + '~' + SelectedWarehouseID + '~' + Rate);
                SelectedWarehouseID = "0";
                SelectWarehouse = "0";
            }
        }
        function fn_Edit(keyValue) {
            SelectedWarehouseID = keyValue;

            ctxtQuantity.SetValue("0");
            ctxtRate.SetValue("0");
            ctxtBatchName.SetValue("");
            ctxtStartDate.SetDate(null);
            ctxtEndDate.SetDate(null);
            ctxtserialID.SetValue("");

            cCallbackPanel.PerformCallback('EditWarehouse~' + keyValue);
        }
        function fn_Delete(keyValue) {
            cGrdWarehouse.PerformCallback('Delete~' + keyValue);
        }
        function CmbWarehouseIDEndCallback(s, e) {
            if (SelectWarehouse != "0") {
                cCmbWarehouseID.SetValue(SelectWarehouse);
                SelectWarehouse = "0";
            }
            else {
                cCmbWarehouseID.Focus();
            }
        }
        function CallbackPanelEndCall(s, e) {
            if (cCallbackPanel.cpEdit != null) {
                var strWarehouse = cCallbackPanel.cpEdit.split('~')[0];
                var strBatchID = cCallbackPanel.cpEdit.split('~')[1];
                var MfgDate = cCallbackPanel.cpEdit.split('~')[2];
                var ExpiryDate = cCallbackPanel.cpEdit.split('~')[3];
                var strSrlID = cCallbackPanel.cpEdit.split('~')[4];
                var strQuantity = cCallbackPanel.cpEdit.split('~')[5];
                var strRate = cCallbackPanel.cpEdit.split('~')[6];

                SelectWarehouse = strWarehouse;

                cCmbWarehouseID.PerformCallback('BindWarehouse');
                ctxtQuantity.SetValue(strQuantity);
                ctxtBatchName.SetValue(strBatchID);
                ctxtserialID.SetValue(strSrlID);
                ctxtRate.SetValue(strRate);

                if (MfgDate != "") {
                    var strMfgDate = new Date(GetReverseDateFormat(MfgDate));
                    ctxtStartDate.SetDate(strMfgDate);
                }

                if (ExpiryDate != "") {
                    var strExpiryDate = new Date(GetReverseDateFormat(ExpiryDate));
                    ctxtEndDate.SetDate(strExpiryDate);
                }
            }
        }

        function ddlInventory_OnChange() {
            cproductLookUp.GetGridView().Refresh();
        }

        function OnWarehouseEndCallback(s, e) {
            if (cGrdWarehouse.cperrorMsg == "duplicateSerial") {
                cGrdWarehouse.cperrorMsg = null;
                jAlert("Duplicate Serial. Cannot Proceed.");
            }

            if (cGrdWarehouse.cpEnteredQty != null) {
                var EnteredQty = cGrdWarehouse.cpEnteredQty;
                cGrdWarehouse.cpEnteredQty = null;

                if (EnteredQty >= 0) {
                    document.getElementById('<%=txt_EnteredSalesAmount.ClientID %>').innerHTML = EnteredQty;
            }
        }

        if (IsFocus == "1") {
            ctxtserialID.Focus();
            IsFocus = "0";
        }

        if (cGrdWarehouse.cpRateList) {
            var RateList = cGrdWarehouse.cpRateList;
            warehouserateList = JSON.parse(RateList);

            cGrdWarehouse.cpRateList = null;
        }
    }

    function FinalSubmitWarehouse() {
        OpeningGrid.PerformCallback('FinalSubmit');
    }

    function CmbWarehouse_ValueChange() {
        var WarehouseID = cCmbWarehouseID.GetValue();
        var List = $.grep(warehouserateList, function (e) { return e.WarehouseID == WarehouseID; })

        if (List.length > 0) {
            var Rate = List[0].Rate;
            ctxtRate.SetValue(Rate);
        }
        else {
            ctxtRate.SetValue("0");
        }
    }
    </script>
    <script>
        function chnagedcombo(s) {
            document.getElementById('drdExport').value = "0";
            OpeningGrid.PerformCallback("ReBindGrid");
        }
    </script>
    <style>
        #OpeningGrid_DXStatus span > a {
            display: none;
        }

        #OpeningGrid_DXStatus {
            display: none;
        }

        #OpeningGrid_DXMainTable > tbody > tr > td:first-child {
            display: none !important;
        }

        #OpeningGrid_DXMainTable > tbody > tr > td:nth-child(2) {
            display: none !important;
        }

        #OpeningGrid_DXMainTable > tbody > tr > td:nth-child(3) {
            display: none !important;
        }

        .pullleftClass {
            position: absolute;
            right: -3px;
            top: 18px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title clearfix" id="td_contact1" runat="server">
            <h3 class="clearfix pull-left">
                <asp:Label ID="lblHeadTitle" runat="server" Text="Opening Balances - Product(s)"></asp:Label>
            </h3>
            <div id="pageheaderContent" class="hide">
                <div class="Top clearfix">
                    <ul>
                        <li>
                            <div class="lblHolder">
                                <table>
                                    <tr>
                                        <td>Total Values</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b>
                                                <asp:Label ID="lblTotalSum" runat="server" Text=""></asp:Label></b>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="form_main">
        <div class="SearchArea">
            <div class="FilterSide">
                <div class="pull-right">
                    <% if (rights.CanExport)
                       { %>
                    <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnChange="if(!AvailableExportOption()){return false;}" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
                        <asp:ListItem Value="0">Export to</asp:ListItem>
                        <asp:ListItem Value="1">PDF</asp:ListItem>
                        <asp:ListItem Value="2">XLS</asp:ListItem>
                        <asp:ListItem Value="3">RTF</asp:ListItem>
                        <asp:ListItem Value="4">CSV</asp:ListItem>
                    </asp:DropDownList>
                    <% } %>
                </div>
            </div>
            <div class="FilterSide">
                <div style="width: 60px; float: left; padding-top: 5px">Branch: </div>
                <div class="col-sm-4">
                    <dxe:ASPxComboBox ID="cmbbranch" runat="server" ClientInstanceName="ccmbbranch" TextField="branch_description" ValueField="branch_id">
                        <ClientSideEvents SelectedIndexChanged="function(s,e) { chnagedcombo(s);}" />
                    </dxe:ASPxComboBox>
                </div>
            </div>
            <div class="clear">
                <br />
            </div>
        </div>
        <div>
            <dxe:ASPxGridView ID="OpeningGrid" ClientInstanceName="OpeningGrid" runat="server" KeyFieldName="ProductID" AutoGenerateColumns="False"
                Width="100%" EnableRowsCache="true" SettingsBehavior-AllowFocusedRow="true"
                OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting" OnDataBinding="OpeningGrid_DataBinding"
                OnCustomCallback="OpeningGrid_CustomCallback">
                <Columns>
                    <dxe:GridViewDataTextColumn FieldName="AvailableStock" Caption="AvailableStock" VisibleIndex="0">
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn FieldName="InventoryType" Caption="InventoryType" VisibleIndex="1">
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn FieldName="StockID" Caption="StockID" VisibleIndex="2">
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataColumn Caption="Product Code" FieldName="ProductCode" VisibleIndex="6" Width="25%" Settings-AutoFilterCondition="Contains">
                        <EditFormSettings Visible="False" />
                    </dxe:GridViewDataColumn>
                    <dxe:GridViewDataColumn Caption="Product Name" FieldName="ViewProductName" VisibleIndex="7" Width="40%" Settings-AutoFilterCondition="Contains">
                        <EditFormSettings Visible="False" />
                    </dxe:GridViewDataColumn>
                    <%-- <dxe:GridViewDataTextColumn FieldName="OpeningStock" Caption="Opening Quantity" VisibleIndex="8" Width="10%" HeaderStyle-HorizontalAlign="Right">
                        <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                            <MaskSettings AllowMouseWheel="False" IncludeLiterals="DecimalSymbol" Mask="<0..999999999>.<0..99>" />
                            <ValidationSettings RequiredField-IsRequired="false" Display="None"></ValidationSettings>
                            <ClientSideEvents KeyDown="OnKeyDown" />
                        </PropertiesTextEdit>
                        <HeaderStyle HorizontalAlign="Right" />
                        <CellStyle HorizontalAlign="Right"></CellStyle>
                    </dxe:GridViewDataTextColumn>--%>
                    <dxe:GridViewDataTextColumn Caption="Opening Quantity" FieldName="OpeningStock" VisibleIndex="8" Width="10%" Settings-ShowFilterRowMenu="true"
                        Settings-AllowHeaderFilter="true" Settings-AllowAutoFilter="true">
                        <EditFormSettings Visible="False" />
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn Caption="Stock UOM" FieldName="UOM" ReadOnly="true" VisibleIndex="9" Width="10%">
                        <EditFormSettings Visible="False" />
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn Caption="Stock Details" FieldName="Stock_ID" VisibleIndex="10" CellStyle-VerticalAlign="Middle"
                        CellStyle-HorizontalAlign="Center" Settings-ShowFilterRowMenu="False" Settings-AllowHeaderFilter="False" Settings-AllowAutoFilter="False" Width="5%">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <a href="javascript:void(0);" title="Stock Details" onclick="CheckProductStockdetails('<%#Eval("ProductID")%>','<%#Eval("ProductName")%>','<%#Eval("UOM")%>','<%#GetvisibleIndex(Container)%>','<%#Eval("DefaultWarehouse")%>')" class="pad" style='<%#Eval("IsInventoryEnable")%>'>
                                <img src="../../../assests/images/warehouse.png" />
                            </a>
                        </DataItemTemplate>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn Caption="Value" FieldName="OpeningValue" VisibleIndex="11" Width="10%" Settings-ShowFilterRowMenu="true"
                        Settings-AllowHeaderFilter="true" Settings-AllowAutoFilter="true">
                        <EditFormSettings Visible="False" />
                    </dxe:GridViewDataTextColumn>
                </Columns>
                <ClientSideEvents BatchEditStartEditing="OnBatchStartEdit" EndCallback="OnEndCallback" />
                <SettingsDataSecurity AllowEdit="true" />
                <SettingsEditing Mode="Batch">
                    <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="row" />
                </SettingsEditing>
                <Settings ShowFilterRow="true" ShowFilterRowMenu="true" ShowFooter="true" ShowGroupFooter="VisibleIfExpanded" />
                <SettingsBehavior ColumnResizeMode="Disabled" />
                <SettingsPager NumericButtonCount="10" PageSize="15" ShowSeparators="True" Mode="ShowPager">
                    <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                    <FirstPageButton Visible="True">
                    </FirstPageButton>
                    <LastPageButton Visible="True">
                    </LastPageButton>
                </SettingsPager>
                <TotalSummary>
                    <dxe:ASPxSummaryItem FieldName="OpeningStock" SummaryType="Sum" />
                    <dxe:ASPxSummaryItem FieldName="OpeningValue" SummaryType="Sum" />
                    <dxe:ASPxSummaryItem FieldName="ProductCode" SummaryType="Count" DisplayFormat="Product Count : #######"  />
                </TotalSummary>
            </dxe:ASPxGridView>
        </div>
    </div>
    <div>
        <%--Warehouse Details Start--%>

        <dxe:ASPxPopupControl ID="Popup_Warehouse" runat="server" ClientInstanceName="cPopup_Warehouse"
            Width="850px" HeaderText="Warehouse Details" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <ClientSideEvents Closing="function(s, e) {
	closeWarehouse(s, e);}" />
            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <div class="Top clearfix">
                        <div id="content-5" class="pull-right wrapHolder content horizontal-images" style="width: 100%; margin-right: 0px;">
                            <ul>
                                <li>
                                    <div class="lblHolder">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>Selected Product</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblProductName" runat="server"></asp:Label></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                                <li>
                                    <div class="lblHolder">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>Entered Quantity </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="txt_EnteredSalesAmount" runat="server" Font-Bold="true"></asp:Label>
                                                        <asp:Label ID="txt_EnteredSalesUOM" runat="server" Font-Bold="true"></asp:Label>

                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                                <li>
                                    <div class="lblHolder">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>Opening Stock</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblAvailableStock" runat="server"></asp:Label>
                                                        <asp:Label ID="lblAvailableStockUOM" runat="server"></asp:Label>

                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="clear">
                            <br />
                        </div>
                        <div class="clearfix col-md-12" style="background: #f5f4f3; padding: 8px 0; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ccc;">
                            <div>
                                <div class="col-md-3" id="div_Warehouse">
                                    <div>
                                        Warehouse
                                    </div>
                                    <div class="Left_Content" style="">
                                        <dxe:ASPxComboBox ID="CmbWarehouseID" EnableIncrementalFiltering="True" ClientInstanceName="cCmbWarehouseID" SelectedIndex="0"
                                            TextField="WarehouseName" ValueField="WarehouseID" runat="server" Width="100%" OnCallback="CmbWarehouseID_Callback">
                                            <ClientSideEvents ValueChanged="function(s,e){CmbWarehouse_ValueChange()}" EndCallback="CmbWarehouseIDEndCallback"></ClientSideEvents>
                                        </dxe:ASPxComboBox>
                                        <span id="spnCmbWarehouse" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                    </div>
                                </div>
                                <div class="col-md-3" id="div_Rate">
                                    <div>
                                        Rate
                                    </div>
                                    <div class="Left_Content" style="">
                                        <dxe:ASPxTextBox ID="txtRate" runat="server" Width="100%" ClientInstanceName="ctxtRate" HorizontalAlign="Left" Font-Size="12px">
                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" />
                                        </dxe:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="clear" id="div_Rate_Break"></div>
                                <div class="col-md-3" id="div_Batch">
                                    <div>
                                        Batch
                                    </div>
                                    <div class="Left_Content" style="">
                                        <dxe:ASPxTextBox ID="txtBatchName" runat="server" Width="100%" ClientInstanceName="ctxtBatchName" HorizontalAlign="Left" Font-Size="12px">
                                        </dxe:ASPxTextBox>
                                        <span id="spntxtBatch" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                    </div>
                                </div>
                                <div class="col-md-3" id="div_Manufacture">
                                    <div>
                                        Manufacture Date
                                    </div>
                                    <div class="Left_Content" style="">
                                        <dxe:ASPxDateEdit ID="txtStartDate" runat="server" Width="100%" EditFormat="custom" UseMaskBehavior="True" ClientInstanceName="ctxtStartDate" AllowNull="true" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy">
                                            <ButtonStyle Width="13px">
                                            </ButtonStyle>
                                        </dxe:ASPxDateEdit>
                                    </div>
                                </div>
                                <div class="col-md-3" id="div_Expiry">
                                    <div>
                                        Expiry Date
                                    </div>
                                    <div class="Left_Content" style="">
                                        <dxe:ASPxDateEdit ID="txtEndDate" runat="server" Width="100%" EditFormat="custom" UseMaskBehavior="True" ClientInstanceName="ctxtEndDate" AllowNull="true" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy">
                                            <ButtonStyle Width="13px">
                                            </ButtonStyle>
                                        </dxe:ASPxDateEdit>
                                    </div>
                                </div>
                                <div class="clear" id="div_Break"></div>
                                <div class="col-md-3" id="div_Quantity">
                                    <div>
                                        Quantity
                                    </div>
                                    <div class="Left_Content" style="">
                                        <dxe:ASPxTextBox ID="txtQuantity" runat="server" ClientInstanceName="ctxtQuantity" HorizontalAlign="Right" Font-Size="12px" Width="100%" Height="15px">
                                            <MaskSettings Mask="<0..999999999999>.<0..99>" IncludeLiterals="DecimalSymbol" />
                                            <%-- <ClientSideEvents TextChanged="function(s, e) {SaveWarehouse();}" />--%>
                                        </dxe:ASPxTextBox>
                                        <span id="spntxtQuantity" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                    </div>
                                </div>
                                <div class="col-md-3" id="div_Serial">
                                    <div>
                                        Serial No
                                    </div>
                                    <div class="Left_Content" style="">
                                        <dxe:ASPxTextBox ID="txtserialID" runat="server" Width="100%" ClientInstanceName="ctxtserialID" HorizontalAlign="Left" Font-Size="12px" MaxLength="49">
                                            <ClientSideEvents LostFocus="SubmitWarehouse" />
                                        </dxe:ASPxTextBox>
                                        <span id="spntxtserialID" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="col-md-3">
                                    <div>
                                    </div>
                                    <div class="Left_Content" style="padding-top: 14px">
                                        <dxe:ASPxButton ID="btnWarehouse" ClientInstanceName="cbtnWarehouse" Width="50px" runat="server" AutoPostBack="False" Text="Add" CssClass="btn btn-primary">
                                            <ClientSideEvents Click="SubmitWarehouse" />
                                        </dxe:ASPxButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="clearfix">
                            <dxe:ASPxGridView ID="GrdWarehouse" runat="server" KeyFieldName="SrlNo" AutoGenerateColumns="False"
                                Width="100%" ClientInstanceName="cGrdWarehouse" OnCustomCallback="GrdWarehouse_CustomCallback" OnDataBinding="GrdWarehouse_DataBinding"
                                SettingsPager-Mode="ShowAllRecords" Settings-VerticalScrollBarMode="auto" Settings-VerticalScrollableHeight="200" SettingsBehavior-AllowSort="false">
                                <Columns>
                                    <dxe:GridViewDataTextColumn Caption="Warehouse Name" FieldName="WarehouseName"
                                        VisibleIndex="0">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Rate" FieldName="ViewRate"
                                        VisibleIndex="1">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Batch Number" FieldName="BatchNo"
                                        VisibleIndex="2">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Mfg Date" FieldName="ViewMfgDate"
                                        VisibleIndex="3">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Expiry Date" FieldName="ViewExpiryDate"
                                        VisibleIndex="4">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Quantity" FieldName="SalesQuantity"
                                        VisibleIndex="5">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Serial Number" FieldName="SerialNo"
                                        VisibleIndex="6">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn VisibleIndex="7" Width="100px" FieldName="ModifyComment" Caption=" " CellStyle-HorizontalAlign="Center">
                                        <DataItemTemplate>
                                            <%-- <a href="javascript:void(0);" onclick="fn_Edit('<%# Container.KeyValue %>')" title="Delete">
                                                <img src="../../../assests/images/Edit.png" /></a>
                                            &nbsp;
                                                        <a href="javascript:void(0);" onclick="fn_Delete('<%# Container.KeyValue %>')" title="Delete">
                                                            <img src="/assests/images/crs.png" /></a>--%>

                                            <a href="javascript:void(0);" onclick="fn_Edit('<%# Container.KeyValue %>')" title="Delete" style='<%#Eval("IsOutStatus")%>'>
                                                <img src="../../../assests/images/Edit.png" /></a>
                                            &nbsp;
                                            <a href="javascript:void(0);" onclick="fn_Delete('<%# Container.KeyValue %>')" title="Delete" style='<%#Eval("IsOutStatus")%>'>
                                                <img src="/assests/images/crs.png" /></a>
                                            <a class="anchorclass" style='<%#Eval("IsOutStatusMsg")%>'>Already used</a>
                                        </DataItemTemplate>
                                    </dxe:GridViewDataTextColumn>
                                </Columns>
                                <ClientSideEvents EndCallback="OnWarehouseEndCallback" />
                                <SettingsPager Visible="false"></SettingsPager>
                                <SettingsLoadingPanel Text="Please Wait..." />
                            </dxe:ASPxGridView>
                        </div>
                        <div>
                            <br />
                        </div>
                        <div class="clearfix">
                            <dxe:ASPxButton ID="btnFinalSubmit" ClientInstanceName="cbtnFinalSubmit" Width="50px" runat="server" AutoPostBack="False" Text="Save & Exit" CssClass="btn btn-primary">
                                <ClientSideEvents Click="FinalSubmitWarehouse" />
                            </dxe:ASPxButton>
                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <HeaderStyle BackColor="LightGray" ForeColor="Black" />
        </dxe:ASPxPopupControl>
        <dxe:ASPxCallbackPanel runat="server" ID="CallbackPanel" ClientInstanceName="cCallbackPanel" OnCallback="CallbackPanel_Callback">
            <PanelCollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </PanelCollection>
            <ClientSideEvents EndCallback="CallbackPanelEndCall" />
        </dxe:ASPxCallbackPanel>

        <asp:HiddenField ID="hdndefaultID" runat="server" />
        <asp:HiddenField ID="hdfProductIDPC" runat="server" />
        <asp:HiddenField ID="hdfProductID" runat="server" />
        <asp:HiddenField ID="hdfProductSerialID" runat="server" />
        <asp:HiddenField ID="hdfProductType" runat="server" />
        <%--Warehouse Details End--%>
    </div>
    <div>
        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A3" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
    </div>
    <div style="display: none">
        <dxe:ASPxGridView ID="openingGridExport" runat="server" KeyFieldName="ProductID" AutoGenerateColumns="True"
            Width="100%" EnableRowsCache="true" SettingsBehavior-AllowFocusedRow="true"
            OnDataBinding="openingGridExport_DataBinding">
            <Columns>
                <dxe:GridViewDataTextColumn FieldName="Product_Code" Caption="Product Code" VisibleIndex="0">
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn FieldName="Product_Name" Caption="Product Name" VisibleIndex="1">
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn FieldName="Opening_Quontity" Caption="Opening Quontity" VisibleIndex="2">
                    <PropertiesTextEdit DisplayFormatString="0.0000"></PropertiesTextEdit>
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn FieldName="Stock_UOM" Caption="Stock UOM" VisibleIndex="3">
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn FieldName="Opening_Value" Caption="Opening Value" VisibleIndex="4">
                    <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                </dxe:GridViewDataTextColumn>
            </Columns>
        </dxe:ASPxGridView>
    </div>


</asp:Content>
