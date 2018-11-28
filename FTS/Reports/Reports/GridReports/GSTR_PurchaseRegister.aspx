<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="GSTR_PurchaseRegister.aspx.cs"
    Inherits="Reports.Reports.GridReports.GSTR_PurchaseRegister" %>

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

        .dxtc-activeTab .dxtc-link {
            color: #fff !important;
        }

        .tablpad > tbody > tr > td {
            padding: 0 10px;
        }

        .lblo > label {
            display: block;
        }
    </style>


    <script type="text/javascript">

        function fn_OpenDetails(keyValue) {
            Grid.PerformCallback('Edit~' + keyValue);
        }

        $(function () {

            //    BindBranches(null);

        });


        $(document).ready(function () {
            $("#ListBoxBranches").chosen().change(function () {
                var Ids = $(this).val();
                // BindLedgerType(Ids);                    

                $('#<%=hdnSelectedBranches.ClientID %>').val(Ids);
                $('#MandatoryActivityType').attr('style', 'display:none');

            })

        })

        function cxdeToDate_OnChaged(s, e) {
            debugger;
            var data = "OnDateChanged";
            data += '~' + cxdeFromDate.GetDate();
            data += '~' + cxdeToDate.GetDate();

        }


        function btn_ShowRecordsClick(e) {
            e.preventDefault;

            var v = $("#ddlgstn").val();


            var activeTab = page.GetActiveTab();

            if (activeTab.name == 'purchase') {
                Grid.PerformCallback('ListData~' + v);

            }


            else if (activeTab.name == 'Return') {

                Gridreturn.PerformCallback('ListData~' + v);

            }

            else if (activeTab.name == 'debitNote') {
                cgrid_debitNote.PerformCallback('ListData~' + v);
            }

            else if (activeTab.name == 'creditNote') {

                cgrid_creditNote.PerformCallback('ListData~' + v);
            }

        }

        function OnContextMenuItemClick(sender, args) {
            if (args.item.name == "ExportToPDF" || args.item.name == "ExportToXLS") {
                args.processOnServer = true;
                args.usePostBack = true;
            } else if (args.item.name == "SumSelected")
                args.processOnServer = true;
        }


        function OpenBillDetails(branch) {

            cgridPendingApproval.PerformCallback('BndPopupgrid~' + branch);
            cpopupApproval.Show();
            return true;

        }

        function popupHide(s, e) {

            cpopupApproval.Hide();

        }


        function OpenPOSDetails(invoice, type) {

            if (type == 'POS') {


                window.open('/OMS/Management/Activities/posSalesInvoice.aspx?key=' + invoice + '&Viemode=1', '_blank')
            }
            else if (type == 'SI') {

                ///    window.location.href = '/OMS/Management/Activities/SalesInvoice.aspx?key=' + invoice + '&req=V&type=' + type;

                window.open('/OMS/Management/Activities/SalesInvoice.aspx?key=' + invoice + '&req=V&type=' + type, '_blank')

            }


        }
        function Callback_EndCallback() {

            $("#drdExport").val(0);
        }


        $(function () {
            $('body').on('change', '#ddlgstn', function () {
                if ($("#ddlgstn").val()) {
                    cProductbranchComponentPanel.PerformCallback('BindComponentGrid' + '~' + $("#ddlgstn").val());

                }

                else {

                    cProductbranchComponentPanel.PerformCallback('BindComponentGrid' + '~' + 0);
                }
            });
        });


        function selectAll_branch() {
            gridbranchLookup.gridView.SelectRows();
        }


        function unselectAll_branch() {
            gridbranchLookup.gridView.UnselectRows();
        }


        function CloseGridQuotationLookupbranch() {
            gridbranchLookup.ConfirmCurrentSelection();
            gridbranchLookup.HideDropDown();
            gridbranchLookup.Focus();
        }



    </script>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="panel-heading">
        <div class="panel-title">
            <h3>Purchase GSTR Report </h3>
        </div>
    </div>


    <div class="form_main">
        <asp:HiddenField runat="server" ID="hdndaily" />
        <asp:HiddenField runat="server" ID="hdtid" />
        <div>
            <div class="col-md-3 lblo">
                <label>
                    <asp:Label ID="lblFromDate" runat="Server" Text="GSTIN : " CssClass="mylabel1"></asp:Label></label>
                <asp:DropDownList ID="ddlgstn" runat="server" Width="100%"></asp:DropDownList>
            </div>
            <div class="col-md-3 lblo">
                <label>
                    <asp:Label ID="lblbranch" runat="Server" Text="Branch : " CssClass="mylabel1"></asp:Label></label>
                <dxe:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel1" ClientInstanceName="cProductbranchComponentPanel" OnCallback="Componentbranch_Callback">
                    <panelcollection>
                        <dxe:PanelContent runat="server">
                            <dxe:ASPxGridLookup ID="lookup_branch" SelectionMode="Multiple" runat="server" ClientInstanceName="gridbranchLookup"
                                OnDataBinding="lookup_branch_DataBinding"
                                KeyFieldName="branch_id" Width="100%" TextFormatString="{1}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                                <Columns>
                                    <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="60" Caption=" " />
                                    <dxe:GridViewDataColumn FieldName="branch_code" Visible="true" VisibleIndex="1" Caption="Branch code" Settings-AutoFilterCondition="Contains">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dxe:GridViewDataColumn>
                                    <dxe:GridViewDataColumn FieldName="branch_description" Visible="true" VisibleIndex="2" Caption="Branch Name" Settings-AutoFilterCondition="Contains">
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
                                                            <dxe:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="false" Text="Select All" ClientSideEvents-Click="selectAll_branch" />
                                                        </div>
                                                        <dxe:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" Text="Deselect All" ClientSideEvents-Click="unselectAll_branch" />
                                                        <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridQuotationLookupbranch" UseSubmitBehavior="False" />
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
                                    <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                                </GridViewProperties>

                            </dxe:ASPxGridLookup>
                        </dxe:PanelContent>
                    </panelcollection>

                </dxe:ASPxCallbackPanel>
            </div>
            <div class="col-md-3 lblo">
                <label>
                    <asp:Label ID="lbl" runat="Server" Text="Inventory : " CssClass="mylabel1"></asp:Label></label>
                <asp:DropDownList ID="ddlinventory" runat="server" Width="100%">
                    <asp:ListItem Text="All" Value=""></asp:ListItem>
                    <asp:ListItem Text="Inventory" Value="1"></asp:ListItem>
                    <asp:ListItem Text="NonInventory" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Capital Goods" Value="2"></asp:ListItem>

                </asp:DropDownList>
            </div>


            <div class="col-md-3">
                <label>&nbsp</label><br />
                <asp:CheckBox runat="server" ID="chkgrndate" Text="Search by GRN Date" />
            </div>



            <div class="clear"></div>
            <table class="tablpad">
                <tr>
                    <td>
                        <label>&nbsp</label><br />
                        <asp:CheckBox runat="server" ID="chkparty" Checked="true" Text="Search by Party Invoice Date" />
                    </td>
                    <td>
                        <asp:Label ID="Label1" runat="Server" Text="From Date : " CssClass="mylabel1"></asp:Label>
                        <dxe:ASPxDateEdit ID="ASPxFromDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                            UseMaskBehavior="True" Width="100%" ClientInstanceName="cxdeFromDate">
                            <buttonstyle width="13px">
                            </buttonstyle>
                        </dxe:ASPxDateEdit>
                    </td>
                    <td>
                        <asp:Label ID="lblToDate" runat="Server" Text="To Date : " CssClass="mylabel1"></asp:Label>
                        <dxe:ASPxDateEdit ID="ASPxToDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                            UseMaskBehavior="True" Width="100%" ClientInstanceName="cxdeToDate">
                            <buttonstyle width="13px">
                            </buttonstyle>
                        </dxe:ASPxDateEdit>
                    </td>
                    <td>

                        <label>&nbsp</label><br />
                        <asp:CheckBox runat="server" ID="chkrcm" Text="Show RCM data only " />
                        <asp:CheckBox runat="server" ID="chkitc" Text="Show ITC data only" />
                        <asp:CheckBox runat="server" ID="chkwithouttax" Text="Include No Tax" />

                    </td>


                    <td style="padding-top: 15px;">
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

            <div class="col-md-4">
            </div>
            <div class="clear"></div>
            <div class="col-md-2" style="padding-top: 20px;"></div>
        </div>
        <table class="pull-left tablpad">
            <tr>

                <td style="width: 254px; display: none">

                    <asp:HiddenField ID="hdnActivityType" runat="server" />
                    <asp:HiddenField ID="hdnActivityTypeText" runat="server" />
                    <span id="MandatoryActivityType" style="display: none" class="validclass">
                        <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor1112_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                    <asp:HiddenField ID="hdnSelectedBranches" runat="server" />


                </td>

            </tr>




        </table>
        <div class="clear"></div>


        <div class="pull-right">
        </div>

        <table class="TableMain100">

            <tr>
                <td colspan="2">

                    <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" ClientInstanceName="page"
                        Font-Size="12px" Width="100%">
                        <tabpages>
                            <dxe:TabPage Name="purchase" Text="Purchase">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">


                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="ShowGrid" ClientInstanceName="Grid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="ShowGrid_SummaryDisplayText" OnDataBound="Showgrid_Datarepared" Settings-HorizontalScrollBarMode="Auto"
                                                OnCustomCallback="Grid_CustomCallback" OnDataBinding="grid_DataBinding"
                                                ClientSideEvents-BeginCallback="Callback_EndCallback"
                                                OnCustomSummaryCalculate="ASPxGridView1_CustomSummaryCalculate"
                                                OnCustomColumnDisplayText="gridpur_CustomColumnDisplayText">

                                                <Columns>


                                                    <%--                                                    <dxe:GridViewDataTextColumn Caption="Sl" ReadOnly="True" UnboundType="String"
                                                        VisibleIndex="0">
                                                        <Settings AllowAutoFilter="False" AllowAutoFilterTextInputTimer="False"
                                                            AllowDragDrop="False" AllowGroup="False" AllowHeaderFilter="False"
                                                            AllowSort="False" />
                                                    </dxe:GridViewDataTextColumn>--%>

                                                    <dxe:GridViewDataTextColumn FieldName="Branchname" Caption="Branch Name" VisibleIndex="0">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Date" Caption="Doc. Date" VisibleIndex="1" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Number" Caption="Doc. Number" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Partytype" Caption="Vendor Type" VisibleIndex="3">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="GSTIN" Caption="Supplier's GSTIN" VisibleIndex="4">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Customer" Caption="Supplier's  Name" VisibleIndex="5">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Grn" Caption="GRN. No." VisibleIndex="6">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="grndate" Caption="GRN.Date" VisibleIndex="7" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="partyinvoice" Caption="Invoice No." VisibleIndex="8">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Partyinvdate" Caption="Invoice Date" VisibleIndex="9" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="branch_description" Caption="GRN Branch" VisibleIndex="10">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="invnoninv" Caption="Inventory/Non Inventory item" VisibleIndex="11">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="rcmf" Caption="RCM" VisibleIndex="12">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Itcf" Caption="ITC" VisibleIndex="13">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="sProducts_HsnCode" Caption="HSN/SAC" VisibleIndex="14">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="InvoiceDetails_ProductDescription" Caption="Product Description" VisibleIndex="15">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="sysledgr" Caption="Ledger Description" VisibleIndex="16">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Qty" Caption="QTY" VisibleIndex="17" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Rateunit" Caption="Rate Per Unit" VisibleIndex="18" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="TAxAmt" Caption="Purchase Price (Before tax)" CellStyle-HorizontalAlign="Right" VisibleIndex="19" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="dicount" Caption="Discount %" VisibleIndex="20" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="disamnt" Caption="Discount Amount" VisibleIndex="21" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="CGSTRate2" Caption="CGST%" VisibleIndex="22" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="CGSTRate" Caption="CGST Amount" VisibleIndex="23" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="SGSTRate2" Caption="SGST%" VisibleIndex="24" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="SGSTRate" Caption="SGST Amount" VisibleIndex="25" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="IGSTRate2" Caption="IGST%" VisibleIndex="26" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="IGSTRate" Caption="IGST" VisibleIndex="27" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="globaltax" Caption="Other Charges(Line)" VisibleIndex="28" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Net" Caption="Amount with Tax" VisibleIndex="29" CellStyle-HorizontalAlign="Right" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="othertax" Caption="Other Charges(Global)" VisibleIndex="30" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Totalnet" Caption="Total Bill Amount" VisibleIndex="31" Width="120px" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                </Columns>

                                                <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" ColumnResizeMode="Control" />
                                                <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                                                <SettingsEditing Mode="EditForm" />
                                                <SettingsContextMenu Enabled="true" />
                                                <SettingsBehavior AutoExpandAllGroups="true" />
                                                <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                                                <SettingsSearchPanel Visible="false" />
                                                <SettingsPager PageSize="10">
                                                    <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                                </SettingsPager>
                                                <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                                <TotalSummary>

                                                    <dxe:ASPxSummaryItem FieldName="TAxAmt" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Net" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="CGSTRate" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="SGSTRate" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="IGSTRate" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Qty" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="othertax" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Totalnet" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="globaltax" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Number" SummaryType="Custom" DisplayFormat="Count" />

                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>


                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Name="Return" Text="Return">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">



                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="ShowGrid2" ClientInstanceName="Gridreturn" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="ShowGrid2_SummaryDisplayText" Settings-HorizontalScrollBarMode="Auto"
                                                OnCustomCallback="Grid2_CustomCallback"
                                                ClientSideEvents-BeginCallback="Callback_EndCallback"
                                                OnCustomSummaryCalculate="ASPxGridView2_CustomSummaryCalculate"
                                                OnDataBinding="grid2_DataBinding" OnCustomColumnDisplayText="gridpur2_CustomColumnDisplayText">

                                                <Columns>



                                                    <dxe:GridViewDataTextColumn FieldName="Branchname" Caption="Branch Name" VisibleIndex="0">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Date" Caption="Doc. Date" VisibleIndex="1" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Number" Caption="Doc. Number" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Partytype" Caption="Vendor Type" VisibleIndex="3">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="GSTIN" Caption="Supplier's GSTIN" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Customer" Caption="Supplier's  Name" VisibleIndex="5">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Grn" Caption="GRN. No." VisibleIndex="6">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="grndate" Caption="GRN.Date" VisibleIndex="7" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="partyinvoice" Caption="Against Inv No." VisibleIndex="8">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Partyinvdate" Caption="Against Inv Date" VisibleIndex="9" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="branch_description" Caption="GRN Branch" VisibleIndex="10">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="invnoninv" Caption="Inventory/Non Inventory item" VisibleIndex="11">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="rcmf" Caption="RCM" VisibleIndex="12">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Itcf" Caption="ITC" VisibleIndex="13">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="sProducts_HsnCode" Caption="HSN/SAC" VisibleIndex="14">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="InvoiceDetails_ProductDescription" Caption="Product Description" VisibleIndex="15">
                                                    </dxe:GridViewDataTextColumn>

                                                    
                                                    <dxe:GridViewDataTextColumn FieldName="sysledgr" Caption="Ledger Description" VisibleIndex="16">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Qty" Caption="QTY" VisibleIndex="17" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Rateunit" Caption="Rate Per Unit" VisibleIndex="18" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="TAxAmt" Caption="Purchase Price (Before tax)" VisibleIndex="19" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="dicount" Caption="Discount %" VisibleIndex="20" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="disamnt" Caption="Discount Amount" VisibleIndex="21" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="CGSTRate2" Caption="CGST%" VisibleIndex="22" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="CGSTRate" Caption="CGST Amount" VisibleIndex="23" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="SGSTRate2" Caption="SGST%" VisibleIndex="24" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="SGSTRate" Caption="SGST Amount" VisibleIndex="25" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="IGSTRate2" Caption="IGST%" VisibleIndex="26" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="IGSTRate" Caption="IGST" VisibleIndex="27" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="globaltax" Caption="Other Charges(Line)" VisibleIndex="28" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Net" Caption="Amount with Tax" VisibleIndex="29" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="othertax" Caption="Other Charges(Global)" VisibleIndex="30" PropertiesTextEdit-DisplayFormatString="0.000">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="Totalnet" Caption="Total Bill Amount" Width="120px" VisibleIndex="31" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                </Columns>

                                                <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" ColumnResizeMode="Control" />
                                                <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                                                <SettingsEditing Mode="EditForm" />
                                                <SettingsContextMenu Enabled="true" />
                                                <SettingsBehavior AutoExpandAllGroups="true" />
                                                <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                                                <SettingsSearchPanel Visible="false" />
                                                <SettingsPager PageSize="10">
                                                    <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                                </SettingsPager>

                                                <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />

                                                <TotalSummary>
                                                    <dxe:ASPxSummaryItem FieldName="TAxAmt" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Net" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="CGSTRate" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="SGSTRate" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="IGSTRate" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Qty" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="othertax" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Totalnet" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Number" SummaryType="Custom" DisplayFormat="Count" />

                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>


                                    </dxe:ContentControl>
                                </ContentCollection>

                            </dxe:TabPage>

                            <dxe:TabPage Name="debitNote" Text="Debit Note">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                        <div onkeypress="OnWaitingGridKeyPress(event)">
                                            <dxe:ASPxGridView runat="server" ID="grid_debitNote" ClientInstanceName="cgrid_debitNote" Width="100%"
                                                EnableRowsCache="false" Settings-HorizontalScrollBarMode="Visible"
                                                OnCustomCallback="grid_debitNote_CustomCallback" OnDataBinding="grid_debitNote_DataBinding" ClientSideEvents-BeginCallback="Callback_EndCallback"
                                                OnSummaryDisplayText="grid_debitNote_SummaryDisplayText">
                                                <Columns>
                                                    <dxe:GridViewDataTextColumn FieldName="BranchName" Caption="Branch Name" VisibleIndex="0" Width="180px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="NoteDate" Caption="Doc Date" VisibleIndex="1" Width="120px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="Doc_Number" Caption="Doc Number" VisibleIndex="2" Width="120px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Partytype" Caption="Vendor Type" VisibleIndex="3">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="GSTIN_Number" Caption="GSTIN" VisibleIndex="4" Width="120px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="StateName" Caption="State" VisibleIndex="5" Width="120px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="NoteType" Caption="Note Type" VisibleIndex="6">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="CustomerName" Caption="Vendor" VisibleIndex="7" Width="180px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="MainAccount_Name" Caption="MainAccount" VisibleIndex="8" Width="180px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="HSN_Number" Caption="HSN/SAC" VisibleIndex="9">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="TaxableAmount" Caption="Taxable Amount" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>




                                                    <dxe:GridViewDataTextColumn FieldName="CGSTRate" Caption="CGST%" VisibleIndex="11" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="CGSTAmount" Caption="CGST" VisibleIndex="12" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="SGSTRate" Caption="SGST%" VisibleIndex="13" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="SGSTAmount" Caption="SGST" VisibleIndex="14" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="IGSTRate" Caption="IGST%" VisibleIndex="15" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="IGSTAmount" Caption="IGST" VisibleIndex="16" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="UTGSTRate" Caption="UTGST%" VisibleIndex="17" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="UTGSTAmount" Caption="UTGST" VisibleIndex="18" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="OtherAmount" Caption="Other Amount" VisibleIndex="19" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="NetAmount" Caption="Net Amount" VisibleIndex="20" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                </Columns>
                                                <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" ColumnResizeMode="Control" />
                                                <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                                                <SettingsEditing Mode="EditForm" />
                                                <SettingsContextMenu Enabled="true" />
                                                <SettingsBehavior AutoExpandAllGroups="true" />
                                                <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                                                <SettingsSearchPanel Visible="false" />
                                                <SettingsPager PageSize="10">
                                                    <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                                </SettingsPager>
                                                <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                                <TotalSummary>
                                                    <dxe:ASPxSummaryItem FieldName="TaxableAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="CGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="SGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="IGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="UTGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="OtherAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="NetAmount" SummaryType="Sum" />
                                                </TotalSummary>
                                            </dxe:ASPxGridView>
                                        </div>
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Name="creditNote" Text="Credit Note">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                        <div onkeypress="OnWaitingGridKeyPress(event)">
                                            <dxe:ASPxGridView runat="server" ID="grid_creditNote" ClientInstanceName="cgrid_creditNote" Width="100%"
                                                EnableRowsCache="false" Settings-HorizontalScrollBarMode="Visible"
                                                OnCustomCallback="grid_creditNote_CustomCallback" OnDataBinding="grid_creditNote_DataBinding" ClientSideEvents-BeginCallback="Callback_EndCallback"
                                                OnSummaryDisplayText="grid_creditNote_SummaryDisplayText">
                                                <Columns>
                                                    <dxe:GridViewDataTextColumn FieldName="BranchName" Caption="Branch Name" VisibleIndex="0" Width="180px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="NoteDate" Caption="Doc Date" VisibleIndex="1" Width="120px">
                                                    </dxe:GridViewDataTextColumn>
                               
                                                       <dxe:GridViewDataTextColumn FieldName="Doc_Number" Caption="Doc Number" VisibleIndex="2" Width="120px">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Partytype" Caption="Vendor Type" VisibleIndex="3">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="GSTIN_Number" Caption="GSTIN" VisibleIndex="4" Width="120px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="StateName" Caption="State" VisibleIndex="5" Width="120px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="NoteType" Caption="Note Type" VisibleIndex="6">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="CustomerName" Caption="Vendor" VisibleIndex="7" Width="180px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="MainAccount_Name" Caption="MainAccount" VisibleIndex="8" Width="180px">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="HSN_Number" Caption="HSN/SAC" VisibleIndex="9">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="TaxableAmount" Caption="Taxable Amount" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="CGSTRate" Caption="CGST%" VisibleIndex="11" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="CGSTAmount" Caption="CGST" VisibleIndex="12" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="SGSTRate" Caption="SGST%" VisibleIndex="13" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="SGSTAmount" Caption="SGST" VisibleIndex="14" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="IGSTRate" Caption="IGST%" VisibleIndex="15" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="IGSTAmount" Caption="IGST" VisibleIndex="16" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="UTGSTRate" Caption="UTGST%" VisibleIndex="17" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="UTGSTAmount" Caption="UTGST" VisibleIndex="18" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="OtherAmount" Caption="Other Amount" VisibleIndex="19" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="NetAmount" Caption="Net Amount" VisibleIndex="20" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                </Columns>
                                                <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" ColumnResizeMode="Control" />
                                                <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                                                <SettingsEditing Mode="EditForm" />
                                                <SettingsContextMenu Enabled="true" />
                                                <SettingsBehavior AutoExpandAllGroups="true" />
                                                <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                                                <SettingsSearchPanel Visible="false" />
                                                <SettingsPager PageSize="10">
                                                    <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                                </SettingsPager>
                                                <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                                <TotalSummary>
                                                    <dxe:ASPxSummaryItem FieldName="TaxableAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="CGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="SGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="IGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="UTGSTAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="OtherAmount" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="NetAmount" SummaryType="Sum" />
                                                </TotalSummary>
                                            </dxe:ASPxGridView>
                                        </div>
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>



                        </tabpages>
                    </dxe:ASPxPageControl>

                </td>
            </tr>
        </table>
    </div>
    <div>
    </div>

    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>
</asp:Content>

