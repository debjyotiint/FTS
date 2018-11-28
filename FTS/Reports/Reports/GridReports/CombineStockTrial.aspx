﻿<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="CombineStockTrial.aspx.cs" Inherits="Reports.Reports.GridReports.CombineStockTrial" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="/assests/pluggins/choosen/choosen.min.js"></script>

    <style>
        #pageControl, .dxtc-content {
            overflow: visible !important;
        }

        #MandatoryAssign {
            position: absolute;
            right: -17px;
            top: 6px;
        }

        #MandatorySupervisorAssign {
            position: absolute;
            right: 1px;
            top: 27px;
        }

        .chosen-container.chosen-container-multi,
        .chosen-container.chosen-container-single {
            width: 100% !important;
        }

        .chosen-choices {
            width: 100% !important;
        }

        #ListBoxBranches {
            width: 200px;
        }

        .hide {
            display: none;
        }
    </style>

    <script type="text/javascript">
        document.onkeyup = function (e) {
            if (event.keyCode == 27 && cpopup2ndLevel.GetVisible() == true && cpopup3rdLevel.GetVisible() == false) { //run code for alt+N -- ie, Save & New  
                popupHide();
            }
            else if (event.keyCode == 27 && cpopup3rdLevel.GetVisible() == true) { //run code for alt+N -- ie, Save & New  
                popupHide3();
            }
        }


        function ClearGridLookup() {
            var grid = gridcustomerLookup.GetGridView();
            grid.UnselectRows();
        }

        function OnWaitingGridKeyPress(e) {
            debugger;
            if (e.code == "Enter" || e.code == "NumpadEnter") {
                var index = Grid.GetFocusedRowIndex();
                $("#hfProductID").val(Grid.GetRowKey(index));
                cShowGridDetails2Level.PerformCallback(Grid.GetRowKey(index));
                cpopup2ndLevel.Show();
            }

        }

        function OnWaitingGridKeyPress2(e) {
            // debugger;
            if (e.code == "Enter" || e.code == "NumpadEnter") {
                var index = cShowGridDetails2Level.GetFocusedRowIndex();
                var productID = cShowGridDetails2Level.GetRow(index).children[1].innerHTML;
                var branchID = cShowGridDetails2Level.GetRow(index).children[3].innerHTML;

                $("#hfProductID2").val(productID);
                $("#hfBranchID2").val(branchID);

                cShowGridDetails3Level.PerformCallback(productID + "~" + branchID);
                cpopup3rdLevel.Show();


                //      cShowGridDetails2Level.GetRowValues(cShowGridDetails2Level.GetFocusedRowIndex(), 'sProducts_ID;sProducts_Code;branch_id', OnGetRowValuesLvl2);
            }
        }


        function OnWaitingGridKeyPress3(e) {
            // debugger;
            if (e.code == "Enter" || e.code == "NumpadEnter") {
                /// var index = cShowGridDetails2Level.GetFocusedRowIndex();
                //var productID = cShowGridDetails2Level.GetRow(index).children[1].innerHTML;
                //var branchID = cShowGridDetails2Level.GetRow(index).children[3].innerHTML;
                //$("#hfProductID2").val(productID);
                //$("#hfBranchID2").val(branchID);
                //  OpenDetailsDocuments
                cShowGridDetails3Level.GetRowValues(cShowGridDetails3Level.GetFocusedRowIndex(), 'Doc_ID;Trans_Type', OnGetRowValuesLvl3);
            }
        }



        function OnGetRowValuesLvl2(values) {
            //  alert(values[0]);

            $("#hfProductID2").val(values[0]);
            $("#hfBranchID2").val(values[2]);

            cShowGridDetails3Level.PerformCallback(values[0] + "~" + values[2]);
            cpopup3rdLevel.Show();

            // OpenAnalysisDetails(values[0], values[1])
        }



        function EndShowGridDetails2Level() {
            //   debugger;
            cShowGridDetails2Level.Focus();
            ctxtProductCode2ndLevel.SetText(cShowGridDetails2Level.cpProductCode);
            ctxtProductDesc2ndLevel.SetText(cShowGridDetails2Level.cpProductDesc);
            $("#lblFromDate2ndLevel")[0].innerHTML = "From " + cShowGridDetails2Level.cpFromDate;
            $("#lblToDate2ndLevel")[0].innerHTML = " To " + cShowGridDetails2Level.cpToDate;

            //cShowGridDetails2Level.cpProductCode = null;
            //cShowGridDetails2Level.cpProductDesc = null;
            //cShowGridDetails2Level.cpFromDate = null;
            //cShowGridDetails2Level.cpToDate = null;
        }

        function EndShowGridDetails3Level() {
            debugger;
            cShowGridDetails3Level.Focus();
            ctxtProductCode3rdLevel.SetText(ctxtProductCode2ndLevel.GetText());
            ctxtProductDesc3rdLevel.SetText(ctxtProductDesc2ndLevel.GetText());
            $("#lblFromDate3rdLevel")[0].innerHTML = $("#lblFromDate2ndLevel")[0].innerHTML;
            $("#lblToDate3rdLevel")[0].innerHTML = $("#lblToDate2ndLevel")[0].innerHTML;
        }



        function OpenDetailsDocuments(Doc_ID, TransType) {

            debugger;
            // alert(type);
            if (TransType == 'PB') {
                url = '/OMS/Management/Activities/PurchaseInvoice.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'PR') {
                url = '/OMS/Management/Activities/PReturn.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SC') {
                url = '/OMS/Management/Activities/SalesChallanAdd.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SD' || TransType == 'OD') {
                url = '/OMS/Management/Activities/CustomerDeliveryPendingOurDelv.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'OUR') {
                url = '/OMS/Management/Activities/OldUnitReceivedFromServiceCenter.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'GRN') {
                url = '/OMS/Management/Activities/PurchaseChallan.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SR') {
                url = '/OMS/Management/Activities/SalesReturn.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SISRM') {
                url = '/OMS/Management/Activities/ReturnManual.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SISRN') {
                url = '/OMS/Management/Activities/ReturnNormal.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'RFS') {
                url = '/OMS/Management/Activities/ReceiveFromServiceCenter.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'BI') {
                url = '/OMS/Management/Activities/BranchTransferIn.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'RSI') {

            }
            else if (TransType == 'ITS') {
                url = '/OMS/Management/Activities/IssueToServiceCenter.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'BO') {
                url = '/OMS/Management/Activities/BranchTransferOut.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'RSO') {
            }
            else if (TransType == 'CRI') {
                url = '/OMS/Management/Activities/IssuetoCustomerReturn.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SI') {
                url = '/OMS/Management/Activities/SalesInvoice.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'POS') {
                url = '/OMS/Management/Activities/posSalesInvoice.aspx?key=' + Doc_ID + '&IsTagged=1&req=V&type=' + TransType;
            }


            popupdocument.SetContentUrl(url);
            popupdocument.Show();




        }



        function OnGetRowValuesLvl3(values) {
            var docid = values[0];
            var TransType = values[1];
            //  alert(docid + '' + TransType);
            // alert(type);
            if (TransType == 'PB') {
                url = '/OMS/Management/Activities/PurchaseInvoice.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'PR') {
                url = '/OMS/Management/Activities/PReturn.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SC') {
                url = '/OMS/Management/Activities/SalesChallanAdd.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'GRN') {
                url = '/OMS/Management/Activities/PurchaseChallan.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SR') {
                url = '/OMS/Management/Activities/SalesReturn.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SISRM') {
                url = '/OMS/Management/Activities/ReturnManual.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SISRN') {
                url = '/OMS/Management/Activities/ReturnNormal.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'RFS') {
                url = '/OMS/Management/Activities/ReceiveFromServiceCenter.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'BI') {
                url = '/OMS/Management/Activities/BranchTransferIn.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'RSI') {

            }
            else if (TransType == 'ITS') {
                url = '/OMS/Management/Activities/IssueToServiceCenter.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'BO') {
                url = '/OMS/Management/Activities/BranchTransferOut.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'RSO') {
            }
            else if (TransType == 'CRI') {
                url = '/OMS/Management/Activities/IssuetoCustomerReturn.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }
            else if (TransType == 'SI') {
                url = '/OMS/Management/Activities/SalesInvoice.aspx?key=' + docid + '&IsTagged=1&req=V&type=' + TransType;
            }


            console.log(url);
            popupdocument.SetContentUrl(url);
            popupdocument.Show();




        }




        function DocumentAfterHide(s, e) {
            popupdocument.Hide();
        }

        function closePopup(s, e) {
            e.cancel = false;
            Grid.Focus();
            $("#drdExport").val(0);
            $("#ddldetails").val(0);
            $("#hfProductID").val('');
        }

        function closePopup3(s, e) {
            e.cancel = false;

            $("#drdExport").val(0);
            $("#ddldetails").val(0);
            $("#ddlExport3").val(0);
            $("#hfProductID2").val('');
            $("#hfBranchID2").val('');
            cShowGridDetails2Level.Focus();
        }

        function popupHide(s, e) {
            cpopup2ndLevel.Hide();
            Grid.Focus();
            $("#drdExport").val(0);
            $("#ddldetails").val(0);
            $("#hfProductID").val('');
        }

        function popupHide3(s, e) {
            cpopup3rdLevel.Hide();
            $("#drdExport").val(0);
            $("#ddldetails").val(0);
            $("#ddlExport3").val(0);
            $("#hfProductID2").val('');
            $("#hfBranchID2").val('');
            cShowGridDetails2Level.Focus();
        }

    </script>

    <script type="text/javascript">


        function cxdeToDate_OnChaged(s, e) {
            debugger;
            var data = "OnDateChanged";

            data += '~' + cxdeToDate.GetDate();
            //CallServer(data, "");
            // Grid.PerformCallback('');
        }

        function btn_ShowRecordsClick(e) {
            e.preventDefault;
            var data = "OnDateChanged";

            data += '~' + cxdeToDate.GetDate();


            Grid.PerformCallback(data);
        }


        function OnContextMenuItemClick(sender, args) {
            if (args.item.name == "ExportToPDF" || args.item.name == "ExportToXLS") {
                args.processOnServer = true;
                args.usePostBack = true;
            } else if (args.item.name == "SumSelected")
                args.processOnServer = true;
        }

        function Callback2_EndCallback() {
            // alert('');
            $("#drdExport").val(0);
            Grid.Focus();
            Grid.SetFocusedRowIndex(0);
        }


        function _selectAll_Class() {
            clookupClass.gridView.SelectRows();
            document.getElementById("hflookupClassAllFlag").value = "ALL";
        }
        function _unselectAll_Class() {
            clookupClass.gridView.UnselectRows();
            document.getElementById("hflookupClassAllFlag").value = "";
        }
        function _CloseLookup_Class() {
            clookupClass.ConfirmCurrentSelection();
            clookupClass.HideDropDown();
            clookupClass.Focus();
        }

        function _selectAll_Brand() {
            clookupBrand.gridView.SelectRows();
            document.getElementById("hflookupBrandAllFlag").value = "ALL";
        }
        function _unselectAll_Brand() {
            clookupBrand.gridView.UnselectRows();
            document.getElementById("hflookupBrandAllFlag").value = "";
        }
        function _CloseLookup_Brand() {
            clookupBrand.ConfirmCurrentSelection();
            clookupBrand.HideDropDown();
            clookupBrand.Focus();
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Combined Stock Trial Report</h3>
        </div>
    </div>
    <td class="form_main">

        <table class="pull-left">
            <tr>


                <td style="">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label1" runat="Server" Text="Class : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td style="width: 205px">
                    <asp:HiddenField ID="hflookupClassAllFlag" runat="server" Value="" />
                    <dxe:ASPxGridLookup ID="lookupClass" ClientInstanceName="clookupClass" SelectionMode="Multiple" runat="server"
                        OnDataBinding="lookupClass_DataBinding" KeyFieldName="ProductClass_ID" Width="100%" TextFormatString="{0}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                        <Columns>
                            <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="60" Caption=" " />
                            <dxe:GridViewDataColumn FieldName="ProductClass_Name" Visible="true" VisibleIndex="1" Caption="Class Name" Settings-AutoFilterCondition="Contains">
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataColumn>
                            <dxe:GridViewDataColumn FieldName="ProductClass_ID" Visible="true" VisibleIndex="2" Caption="Class ID" Settings-AutoFilterCondition="Contains" Width="0">
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataColumn>
                        </Columns>
                        <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                            <Templates>
                                <StatusBar>
                                    <table class="OptionsTable" style="float: right">
                                        <tr>
                                            <td>
                                                <div class="hide">
                                                    <dxe:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="false" Text="Select All" ClientSideEvents-Click="_selectAll_Class" />
                                                </div>
                                                <dxe:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" Text="Deselect All" ClientSideEvents-Click="_unselectAll_Class" />                                                
                                                <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="_CloseLookup_Class" UseSubmitBehavior="False" />
                                            </td>
                                        </tr>
                                    </table>
                                </StatusBar>
                            </Templates>
                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                            <SettingsPager Mode="ShowPager">
                            </SettingsPager>
                            <SettingsPager PageSize="20">
                                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,20,50,100,150,200" />
                            </SettingsPager>
                            <Settings ShowFilterRow="True" ShowFilterRowMenu="true" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                        </GridViewProperties>
                    </dxe:ASPxGridLookup>
                </td>


                <td style="padding-left: 15px">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label2" runat="Server" Text="Brand : " CssClass="mylabel1"
                            Width="110px"></asp:Label>
                    </div>
                </td>
                <td style="width: 205px">
                    <asp:HiddenField ID="hflookupBrandAllFlag" runat="server" Value="" />
                    <dxe:ASPxGridLookup ID="lookupBrand" ClientInstanceName="clookupBrand" SelectionMode="Multiple" runat="server"
                        OnDataBinding="lookupBrand_DataBinding" KeyFieldName="Brand_Id" Width="100%" TextFormatString="{0}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                        <Columns>
                            <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="60" Caption=" " />
                            <dxe:GridViewDataColumn FieldName="Brand_Name" Visible="true" VisibleIndex="1" Caption="Brand Name" Settings-AutoFilterCondition="Contains">
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataColumn>
                            <dxe:GridViewDataColumn FieldName="Brand_Id" Visible="true" VisibleIndex="1" Caption="Brand ID" Settings-AutoFilterCondition="Contains" Width="0">
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataColumn>
                        </Columns>
                        <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                            <Templates>
                                <StatusBar>
                                    <table class="OptionsTable" style="float: right">
                                        <tr>
                                            <td>
                                                <div class="hide">
                                                    <dxe:ASPxButton ID="ASPxButton4" runat="server" AutoPostBack="false" Text="Select All" ClientSideEvents-Click="_selectAll_Brand" />
                                                </div>
                                                <dxe:ASPxButton ID="ASPxButton5" runat="server" AutoPostBack="false" Text="Deselect All" ClientSideEvents-Click="_unselectAll_Brand" />                                                
                                                <dxe:ASPxButton ID="ASPxButton6" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="_CloseLookup_Brand" UseSubmitBehavior="False" />
                                            </td>
                                        </tr>
                                    </table>
                                </StatusBar>
                            </Templates>
                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                            <SettingsPager Mode="ShowPager">
                            </SettingsPager>
                            <SettingsPager PageSize="20">
                                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,20,50,100,150,200" />
                            </SettingsPager>
                            <Settings ShowFilterRow="True" ShowFilterRowMenu="true" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                        </GridViewProperties>
                    </dxe:ASPxGridLookup>
                </td>


                <td style="padding-left: 15px">


                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label8" runat="Server" Text="Tran Type: " CssClass="mylabel1" Width="110px"></asp:Label>
                    </div>

                </td>

                <td style="width: 114px">
                    <asp:DropDownList ID="ddlisdocument" runat="server" Width="100%">
                        <asp:ListItem Text="All" Value="All"></asp:ListItem>
                        <asp:ListItem Text="Sales" Value="Sales"></asp:ListItem>
                        <asp:ListItem Text="Purchases" Value="Purchases"></asp:ListItem>
                    </asp:DropDownList>
                </td>

            </tr>

            <tr>
                <td style="">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="lblToDate" runat="Server" Text="From Date : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td>
                    <dxe:ASPxDateEdit ID="ASPxFromDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                        UseMaskBehavior="True" Width="205px" ClientInstanceName="cxdeFromDate">
                        <ButtonStyle Width="13px"></ButtonStyle>
                    </dxe:ASPxDateEdit>
                </td>
                <td style="padding-left: 15px">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label4" runat="Server" Text="To Date : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td>
                    <dxe:ASPxDateEdit ID="ASPxToDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                        UseMaskBehavior="True" Width="205px" ClientInstanceName="cxdeToDate">
                        <ButtonStyle Width="13px"></ButtonStyle>
                    </dxe:ASPxDateEdit>
                </td>
                <td style="padding-left: 15px" colspan="3">
                    <button id="btnShow" class="btn btn-primary" type="button" onclick="btn_ShowRecordsClick(this);">Show</button>

                    <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary"
                        OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true" OnChange="if(!AvailableExportOption()){return false;}">
                        <asp:ListItem Value="0">Export to</asp:ListItem>
                        <asp:ListItem Value="1">PDF</asp:ListItem>
                        <asp:ListItem Value="2">XLSX</asp:ListItem>
                        <asp:ListItem Value="3">RTF</asp:ListItem>
                        <asp:ListItem Value="4">CSV</asp:ListItem>

                    </asp:DropDownList>
                </td>
            </tr>
        </table>
        <div class="pull-right">
        </div>
        <table class="TableMain100">
            <tr>
                <td>
                    <div onkeypress="OnWaitingGridKeyPress(event)">
                        <dxe:ASPxGridView runat="server" ID="ShowGrid" ClientInstanceName="Grid" Width="100%" EnableRowsCache="false" AutoGenerateColumns="true" KeyboardSupport="true"
                            OnDataBinding="grid2_DataBinding" KeyFieldName="sProducts_ID" OnDataBound="Showgrid_DataBound"
                            OnCustomCallback="Grid_CustomCallback">
                            <%--<columns>
                                <dxe:GridViewDataTextColumn FieldName="SL" Caption="Sl No" Width="10%" VisibleIndex="2" />
                                <dxe:GridViewDataTextColumn FieldName="Brand_Name" Caption="Category" Width="50%" VisibleIndex="3" />
                                <dxe:GridViewDataTextColumn FieldName="ProductClass_Description" Caption="Class" Width="50%" VisibleIndex="2" />
                                <dxe:GridViewDataTextColumn FieldName="sProducts_Description" Caption="Particulars" Width="50%" VisibleIndex="3" />
                                <dxe:GridViewDataTextColumn FieldName="IN_QTY_OP" Caption="Opening" Width="25%" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="IN_QTY" Caption="Received" Width="20%" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="OUT_QTY" Caption="Issue" Width="25%" VisibleIndex="6" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="CLOSE_QTY" Caption="Closing" Width="25%" VisibleIndex="7" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="UNIT" Caption="Units" Width="25%" VisibleIndex="8" />
                                <dxe:GridViewDataTextColumn FieldName="sProducts_ID" Caption="Product ID" Width="0%" visible="false">
                                </dxe:GridViewDataTextColumn>
                            </columns>--%>
                            <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" />
                            <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                            <SettingsEditing Mode="EditForm" />
                            <SettingsContextMenu Enabled="true" />
                            <SettingsBehavior AutoExpandAllGroups="true" ColumnResizeMode="Control" />
                            <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                            <SettingsSearchPanel Visible="false" />
                            <SettingsPager PageSize="10">
                                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />

                            </SettingsPager>
                            <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
                            <TotalSummary>
                                <%--<dxe:ASPxSummaryItem FieldName="Over 120 Days" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Within 120 Days" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Total" SummaryType="Sum" />--%>
                            </TotalSummary>
                            <ClientSideEvents EndCallback="Callback2_EndCallback" />
                        </dxe:ASPxGridView>

                    </div>
                </td>
            </tr>
        </table>
        </div>

    <dxe:ASPxPopupControl ID="popup" runat="server" ClientInstanceName="cpopup2ndLevel"
        Width="1000px" Height="600px" ScrollBars="Vertical" HeaderText="Combine Stock Trial 2nd Level Report" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
        PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
        Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
        ContentStyle-CssClass="pad">
        <ClientSideEvents Closing="function(s, e) {
	closePopup(s, e);}" />
        <ContentStyle VerticalAlign="Top" CssClass="pad">
        </ContentStyle>
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
                <input id="hfProductID" type="hidden" />
                <div class="col-md-12">
                    <div class="row clearfix">
                        <table class="pdbot" style="margin: 4px 0 16px 10px; float: left;">
                            <tr>
                                <td>
                                    <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                        <asp:Label ID="Label5" runat="Server" Text="Product Code : " CssClass="mylabel1"></asp:Label>
                                    </label>
                                </td>
                                <td>
                                    <dxe:ASPxTextBox ID="txtProductCode2ndLevel" ClientInstanceName="ctxtProductCode2ndLevel" runat="server" ReadOnly="true" Width="600px"></dxe:ASPxTextBox>
                                </td>

                            </tr>
                            <tr>
                                <td style="padding-top: 10px">
                                    <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                        <asp:Label ID="Label3" runat="Server" Text="Product Name : " CssClass="mylabel1"></asp:Label>
                                    </label>
                                </td>
                                <td style="padding-top: 10px">
                                    <dxe:ASPxTextBox ID="txtProductDesc2ndLevel" ClientInstanceName="ctxtProductDesc2ndLevel" runat="server" ReadOnly="true" Width="600px"></dxe:ASPxTextBox>
                                </td>

                            </tr>

                            <tr>
                                <td></td>
                                <td>
                                    <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                        <asp:Label ID="lblFromDate2ndLevel" runat="Server" CssClass="mylabel1"></asp:Label>
                                    </label>
                                    <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                        <asp:Label ID="lblToDate2ndLevel" runat="Server" CssClass="mylabel1"></asp:Label>
                                    </label>
                                </td>

                            </tr>
                        </table>
                        <div class="pull-right" style="padding-top: 26px;">
                            <span style="padding-right: 10px; display: inline-block">Press Esc to Close</span>
                            <asp:DropDownList ID="ddldetails" runat="server" CssClass="btn btn-sm btn-primary" AutoPostBack="true" OnSelectedIndexChanged="ddldetails_SelectedIndexChanged">
                                <asp:ListItem Value="0">Export to</asp:ListItem>
                                <asp:ListItem Value="1">PDF</asp:ListItem>
                                <asp:ListItem Value="2">XLS</asp:ListItem>
                                <asp:ListItem Value="3">RTF</asp:ListItem>
                                <asp:ListItem Value="4">CSV</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>



                <div onkeypress="OnWaitingGridKeyPress2(event)">
                    <dxe:ASPxGridView runat="server" ID="ShowGridDetails2Level" ClientInstanceName="cShowGridDetails2Level" Width="100%" EnableRowsCache="false" AutoGenerateColumns="true"
                        OnCustomCallback="ShowGridDetails2Level_CustomCallback" OnDataBinding="ShowGridDetails2Level_DataBinding" OnDataBound="ShowGridDetails2Level_DataBound"
                        KeyboardSupport="true" KeyFieldName="SL"
                        OnSummaryDisplayText="ShowGridDetails2Level_SummaryDisplayText">
                        <%-- <Columns>
                            <dxe:GridViewDataTextColumn FieldName="Branch" Caption="Branch" Width="19%" VisibleIndex="0" >
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="Particulars" Caption="Particulars" Width="50%" VisibleIndex="1">
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="Opening" Caption="Opening" Width="9%" VisibleIndex="2">
                            
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="Received" Caption="Received" Width="9%" VisibleIndex="3">
                            
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="Issue" Caption="Issue" Width="9%" VisibleIndex="4">
                        
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="Closing" Caption="Closing" Width="9%" VisibleIndex="5">
                               
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn FieldName="sProducts_ID" Caption="Product ID"   Visible="false">
                            </dxe:GridViewDataTextColumn>
                             <dxe:GridViewDataTextColumn FieldName="branch_id" Caption="Branch ID"   Visible="false">
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn FieldName="sProducts_Code" Caption="Code"  Visible="false">
                            </dxe:GridViewDataTextColumn>

                        </Columns>--%>
                        <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" />
                        <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                        <SettingsEditing Mode="EditForm" />
                        <SettingsContextMenu Enabled="true" />
                        <SettingsBehavior AutoExpandAllGroups="true" ColumnResizeMode="Control" />
                        <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                        <SettingsSearchPanel Visible="false" />
                        <SettingsPager PageSize="10">
                            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                        </SettingsPager>
                        <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />

                        <ClientSideEvents EndCallback="EndShowGridDetails2Level" />
                    </dxe:ASPxGridView>
                </div>
            </dxe:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="popupHide" />
    </dxe:ASPxPopupControl>

        <dxe:ASPxPopupControl ID="popup3" runat="server" ClientInstanceName="cpopup3rdLevel"
            Width="1000px" Height="600px" ScrollBars="Vertical" HeaderText="Combine Stock Trial 3rd Level Report" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <ClientSideEvents Closing="function(s, e) {
	        closePopup3(s, e);}" />
            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <input id="hfProductID2" type="hidden" />
                    <input id="hfBranchID3" type="hidden" />
                    <div class="col-md-12">
                        <div class="row clearfix">
                            <table class="pdbot" style="margin: 4px 0 16px 10px; float: left;">
                                <tr>
                                    <td>
                                        <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                            <asp:Label ID="Label6" runat="Server" Text="Product Code : " CssClass="mylabel1"></asp:Label>
                                        </label>
                                    </td>
                                    <td>
                                        <dxe:ASPxTextBox ID="txtProductCode3rdLevel" ClientInstanceName="ctxtProductCode3rdLevel" runat="server" ReadOnly="true" Width="600px"></dxe:ASPxTextBox>
                                    </td>

                                </tr>
                                <tr>
                                    <td style="padding-top: 10px">
                                        <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                            <asp:Label ID="Label7" runat="Server" Text="Product Name : " CssClass="mylabel1"></asp:Label>
                                        </label>
                                    </td>
                                    <td style="padding-top: 10px">
                                        <dxe:ASPxTextBox ID="txtProductDesc3rdLevel" ClientInstanceName="ctxtProductDesc3rdLevel" runat="server" ReadOnly="true" Width="600px"></dxe:ASPxTextBox>
                                    </td>

                                </tr>

                                <tr>
                                    <td></td>
                                    <td>
                                        <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                            <asp:Label ID="lblFromDate3rdLevel" runat="Server" CssClass="mylabel1"></asp:Label>
                                        </label>
                                        <label style="color: #b5285f; font-weight: bold; margin-top: 5px;" class="clsTo">
                                            <asp:Label ID="lblToDate3rdLevel" runat="Server" CssClass="mylabel1"></asp:Label>
                                        </label>
                                    </td>

                                </tr>
                            </table>
                            <div class="pull-right" style="padding-top: 26px;">
                                <span style="padding-right: 10px; display: inline-block">Press Esc to Close</span>
                                <asp:DropDownList ID="ddlExport3" runat="server" CssClass="btn btn-sm btn-primary" AutoPostBack="true" OnSelectedIndexChanged="ddlExport3_SelectedIndexChanged">
                                    <asp:ListItem Value="0">Export to</asp:ListItem>
                                    <asp:ListItem Value="1">PDF</asp:ListItem>
                                    <asp:ListItem Value="2">XLS</asp:ListItem>
                                    <asp:ListItem Value="3">RTF</asp:ListItem>
                                    <asp:ListItem Value="4">CSV</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix" onkeypress="OnWaitingGridKeyPress3(event)">
                        <dxe:ASPxGridView runat="server" ID="ShowGridDetails3Level" ClientInstanceName="cShowGridDetails3Level" KeyFieldName="Sl_No" Width="100%" EnableRowsCache="false" AutoGenerateColumns="False"
                            OnCustomCallback="ShowGridDetails3Level_CustomCallback" OnDataBinding="ShowGridDetails3Level_DataBinding" KeyboardSupport="true" Settings-HorizontalScrollBarMode="Visible"
                            OnSummaryDisplayText="ShowGridDetails3Level_SummaryDisplayText">
                            <Columns>
                                <dxe:GridViewDataTextColumn FieldName="branch_description" Caption="Branch" Width="100" VisibleIndex="0">
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Document_Date" Caption="Date" Width="100" VisibleIndex="1">
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Particulars" Caption="Particulars" Width="400" VisibleIndex="2">
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Trans_Type" Caption="Type" Width="200" VisibleIndex="3">
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Document_No" Caption="Voucher No" Width="200" VisibleIndex="4">
                                    <CellStyle HorizontalAlign="Center">
                                    </CellStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <DataItemTemplate>

                                        <a href="javascript:void(0)" onclick="OpenDetailsDocuments('<%#Eval("Doc_ID") %>','<%#Eval("Trans_Type") %>')" class="pad">
                                            <%#Eval("Document_No")%>
                                        </a>
                                    </DataItemTemplate>

                                    <EditFormSettings Visible="False" />
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Received" Caption="Received" Width="100" VisibleIndex="5">
                                    <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Issue" Caption="Issue" Width="100" VisibleIndex="6">
                                    <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Rate" Caption="Rate" Width="100" VisibleIndex="7">
                                    <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Value" Caption="Value" Width="100" VisibleIndex="8">
                                    <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Closing" Caption="Closing" Width="100" VisibleIndex="9">
                                    <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Reference" Caption="Reference" Width="200" VisibleIndex="10">
                                </dxe:GridViewDataTextColumn>

                                <dxe:GridViewDataTextColumn FieldName="Doc_ID" Caption="Doc_ID" Width="100" VisibleIndex="11" Visible="false">
                                </dxe:GridViewDataTextColumn>

                                <%--<dxe:GridViewDataTextColumn FieldName="sProducts_ID" Caption="Reference" Width="19%" VisibleIndex="10">
                            </dxe:GridViewDataTextColumn>--%>
                            </Columns>
                            <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" ColumnResizeMode="Control" />
                            <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                            <SettingsEditing Mode="EditForm" />
                            <SettingsContextMenu Enabled="true" />
                            <SettingsBehavior AutoExpandAllGroups="true" />
                            <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
                            <SettingsSearchPanel Visible="false" />
                            <SettingsPager PageSize="10">
                                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                            </SettingsPager>
                            <TotalSummary>
                                <%-- <dxe:ASPxSummaryItem FieldName="IN_QTY" SummaryType="Sum" />
                            <dxe:ASPxSummaryItem FieldName="OUT_QTY" SummaryType="Sum" />
                            <dxe:ASPxSummaryItem FieldName="CLOSE_QTY" SummaryType="Sum" />--%>
                            </TotalSummary>
                            <ClientSideEvents EndCallback="EndShowGridDetails3Level" />
                        </dxe:ASPxGridView>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>

        </dxe:ASPxPopupControl>


        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
        <dxe:ASPxGridViewExporter ID="exporterDetails" runat="server" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>

        <dxe:ASPxPopupControl ID="ASPXPopupControl2" runat="server"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupdocument" Height="500px"
            Width="1200px" HeaderText="Details" Modal="true" AllowResize="true">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                </dxe:PopupControlContentControl>
            </ContentCollection>

            <ClientSideEvents CloseUp="DocumentAfterHide" />
        </dxe:ASPxPopupControl>
        <%--<dxe:ASPxGridViewExporter ID="exporterDetails3rdLevel" runat="server" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>--%>
</asp:Content>
