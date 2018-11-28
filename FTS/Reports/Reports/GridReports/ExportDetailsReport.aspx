<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="ExportDetailsReport.aspx.cs" Inherits="Reports.Reports.GridReports.ExportDetailsReport" %>

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

        #ListBoxTransporter {
            width: 200px;
        }

        .hide {
            display: none;
        }

        .dxtc-activeTab .dxtc-link {
            color: #fff !important;
        }
    </style>


    <script type="text/javascript">

        $(function () {
            cProducttransporterComponentPanel.PerformCallback('BindComponentGrid' + '~' + 0);
            function OnWaitingGridKeyPress(e) {
                if (e.code == "Enter") {

                }

            }


        });

        function selectAll_branch() {
          //  gridtransporterLookup.gridView.SelectRows();
        }
        function unselectAll_branch() {
            gridtransporterLookup.gridView.UnselectRows();
        }


        function CloseGridQuotationLookupbranch() {
            gridtransporterLookup.ConfirmCurrentSelection();
            gridtransporterLookup.HideDropDown();
            gridtransporterLookup.Focus();
        }
    </script>


    <script type="text/javascript">


        function cxdeToDate_OnChaged(s, e) {
            debugger;
            var data = "OnDateChanged";
            data += '~' + cxdeFromDate.GetDate();
            data += '~' + cxdeToDate.GetDate();
            //CallServer(data, "");
            // Grid.PerformCallback('');
        }

        function btn_ShowRecordsClick(e) {
            Grid.PerformCallback();
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
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">

            <%--<h3>Export Details Report </h3>--%>
            <h3>Local Freight Report </h3>
        </div>

    </div>
    <div class="form_main">
        <asp:HiddenField runat="server" ID="hdndaily" />
        <asp:HiddenField runat="server" ID="hdtid" />
        <table class="pull-left">
            <tr>
                <td>
                    <div style="color: #b5285f; font-weight: bold;" class="clsFrom">
                        <asp:Label ID="lblFromDate" runat="Server" Text="From Date : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td>
                    <dxe:ASPxDateEdit ID="ASPxFromDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                        UseMaskBehavior="True" Width="100%" ClientInstanceName="cxdeFromDate">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>
                    </dxe:ASPxDateEdit>
                </td>
                <td style="padding-left: 15px">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="lblToDate" runat="Server" Text="To Date : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td>
                    <dxe:ASPxDateEdit ID="ASPxToDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                        UseMaskBehavior="True" Width="100%" ClientInstanceName="cxdeToDate">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>

                    </dxe:ASPxDateEdit>
                </td>
                <td style="padding-left: 15px">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label1" runat="Server" Text="Vehicle : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td>
                    <dxe:ASPxTextBox ID="txtVehicle" runat="server" TabIndex="4" Width="100%" MaxLength="100" CssClass="upper">
                    </dxe:ASPxTextBox>
                </td>
                <td style="width: 102px; padding-left: 15px;">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label2" runat="Server" Text="Transporter : " CssClass="mylabel1"
                            Width="74px"></asp:Label>

                    </div>
                </td>
                <td>

                    <asp:ListBox ID="ListBoxTransporter" Visible="false" runat="server" SelectionMode="Multiple" Font-Size="12px" Height="90px" Width="253px" CssClass="mb0 chsnProduct  hide" data-placeholder="--- ALL ---"></asp:ListBox>
                    <asp:HiddenField ID="hdnActivityType" runat="server" />
                    <asp:HiddenField ID="hdnActivityTypeText" runat="server" />
                    <span id="MandatoryActivityType" style="display: none" class="validclass">
                        <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor1112_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                    <asp:HiddenField ID="hdnSelectedTransporter" runat="server" />


                    <dxe:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel1" ClientInstanceName="cProducttransporterComponentPanel" OnCallback="Componenttransporter_Callback">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <dxe:ASPxGridLookup ID="lookup_transporter" SelectionMode="Multiple" runat="server" ClientInstanceName="gridtransporterLookup"
                                    OnDataBinding="lookup_transporter_DataBinding"
                                    KeyFieldName="ID" Width="100%" TextFormatString="{1}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                                    <Columns>
                                        <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="60" Caption=" " />
                                        <dxe:GridViewDataColumn FieldName="ID" Visible="false" VisibleIndex="1" Caption="ID" Settings-AutoFilterCondition="Contains">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>

                                        <dxe:GridViewDataColumn FieldName="Name" Visible="true" VisibleIndex="2" Caption="Name" Settings-AutoFilterCondition="Contains">
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
                        </PanelCollection>

                    </dxe:ASPxCallbackPanel>

                </td>
                <td></td>
                <td style="padding-left: 10px; padding-top: 3px; width: 165px;">
                    <button id="btnShow" class="btn btn-primary" type="button" onclick="btn_ShowRecordsClick(this);">Show</button>
                    <%-- <% if (rights.CanExport)
                           { %>--%>

                    <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary"
                        OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true" OnChange="if(!AvailableExportOption()){return false;}">
                        <asp:ListItem Value="0">Export to</asp:ListItem>
                        <asp:ListItem Value="1">PDF</asp:ListItem>
                        <asp:ListItem Value="2">XLSX</asp:ListItem>
                        <asp:ListItem Value="3">RTF</asp:ListItem>
                        <asp:ListItem Value="4">CSV</asp:ListItem>

                    </asp:DropDownList>
                    <%-- <% } %>--%>
                </td>
            </tr>
        </table>
        <div class="pull-right">
        </div>
        <table class="TableMain100">
            <tr>
                <td colspan="2">
                    <div onkeypress="OnWaitingGridKeyPress(event)">
                        <dxe:ASPxGridView runat="server" ID="ShowGrid" ClientInstanceName="Grid" Width="100%" EnableRowsCache="false" AutoGenerateColumns="False"
                            OnDataBinding="grid2_DataBinding"
                            ClientSideEvents-BeginCallback="Callback2_EndCallback"
                            OnCustomCallback="Grid_CustomCallback" Settings-HorizontalScrollBarMode="Visible">
                            <Columns>
                                <dxe:GridViewDataTextColumn FieldName="Sl_No" Caption="Sl.No" Width="5%" VisibleIndex="1" />
                                <dxe:GridViewDataTextColumn FieldName="Challan_Date" Caption="Date" VisibleIndex="2"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Challan_Number" Caption="Challan No." VisibleIndex="3" Width="120px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="VehicleNo" Caption="Vehicle No." VisibleIndex="4"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Out_Time" Caption="Out Time" VisibleIndex="5"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="TransporterName" Caption="Transporter Name" VisibleIndex="6" Width="150px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Party" Caption="Party" VisibleIndex="7" Width="150px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Address" Caption="PLACE" VisibleIndex="8" Width="250px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="ChallanDetails_ProductDescription" Caption="Particulars" VisibleIndex="9" Width="200px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="ChallanDetails_Quantity" Caption="Weight (Kgs.)" VisibleIndex="10"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Godown_From" Caption="Godown From" VisibleIndex="11"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="ChallanDetails_SalePrice" Caption="RATE" VisibleIndex="12" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="trp_LocationPoint" Caption="POINT" VisibleIndex="13" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="trp_LoadingCharge" Caption="LOADING" VisibleIndex="14" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="trp_UnloadingCharge" Caption="UNLOADING" VisibleIndex="15" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="trp_ParkingCharge" Caption="PARKING" VisibleIndex="16" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Service_Tax" Caption="SERVICE TAX" VisibleIndex="17" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="trp_Weight" Caption="WEIGHMENT" VisibleIndex="18" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="trp_TollTax" Caption="TOLL TAX" VisibleIndex="19" Width="80px"></dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Total" Caption="TOTAL" VisibleIndex="20" Width="80px"></dxe:GridViewDataTextColumn>

                            </Columns>
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
                            <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="true" ShowFilterRow="true" ShowFilterRowMenu="true" />
                        </dxe:ASPxGridView>

                    </div>
                </td>
            </tr>
        </table>
    </div>

    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>
</asp:Content>
