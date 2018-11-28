<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="FinanceCNReport.aspx.cs" Inherits="ERP.OMS.Reports.Master.FinanceCNReport" %>

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
    </style>


    <script type="text/javascript">


        $(function () {


            //cProductbranchPanel.PerformCallback('BindComponentGrid' + '~' + $("#ddlbranchHO").val());
            //cProductfinancerPanel.PerformCallback('BindComponentGrid' + '~' + $("#ddlbranchHO").val());


            function OnWaitingGridKeyPress(e) {
                alert('1Hi');
                if (e.code == "Enter") {
                    alert('Hi');

                }

            }




        });









        function BEginClickfinancerBind() {

            cProductfinancerPanel.PerformCallback('BindComponentGrid' + '~' + 0);

        }

        $(document).ready(function () {

            $("#ddlbranchHO").change(function () {
                var Ids = $(this).val();

                //  $('#MandatoryActivityType').attr('style', 'display:none');
                //  $("#hdnSelectedBranches").val('');

                cProductbranchPanel.PerformCallback('BindComponentGrid' + '~' + $("#ddlbranchHO").val());
                cProductfinancerPanel.PerformCallback('BindComponentGrid' + '~' + $("#ddlbranchHO").val());
            });




            $("#ListBoxBranches").chosen().change(function () {
                var Ids = $(this).val();
                BindLedgerType(Ids);
                //BindCustomerVendor(Ids);

                $('#<%=hdnSelectedBranches.ClientID %>').val(Ids);
                $('#MandatoryActivityType').attr('style', 'display:none');

            })




            $("#ListBoxCustomerVendor").chosen().change(function () {
                var Ids = $(this).val();

                $('#<%=hdnSelectedCustomerVendor.ClientID %>').val(Ids);
                $('#MandatoryCustomerType').attr('style', 'display:none');

            })


            var myDate = new Date();
            // var date = myDate.GetDate();
            ///  alert(myDate);
            cxdeFromDate.SetDate(myDate);
            cxdeToDate.SetDate(myDate);
        })




    </script>


    <script type="text/javascript">


        function cxdeToDate_OnChaged(s, e) {
          //  debugger;
            var data = "OnDateChanged";
            data += '~' + cxdeFromDate.GetDate();
            data += '~' + cxdeToDate.GetDate();
            //CallServer(data, "");
            // Grid.PerformCallback('');
        }


        function btn_ShowRecordsClick(e) {
            //e.preventDefault;
            var data = "OnDateChanged";

            data += '~' + cxdeFromDate.GetDate();
            data += '~' + cxdeToDate.GetDate();
            //CallServer(data, "");
            // alert( data);

            //if (gridbranchLookup.GetValue() == null) {
            //    jAlert('Please select atleast one branch');
            //}
            //else {

                Grid.PerformCallback(data);
            //}
        }


        function OnContextMenuItemClick(sender, args) {
            if (args.item.name == "ExportToPDF" || args.item.name == "ExportToXLS") {
                args.processOnServer = true;
                args.usePostBack = true;
            } else if (args.item.name == "SumSelected")
                args.processOnServer = true;
        }




        function OpenPOSDetails(Uniqueid, type) {
            //  alert(type);
            var url = '';
            if (type == 'POS') {
                //  window.location.href = '/OMS/Management/Activities/posSalesInvoice.aspx?key=' + invoice + '&Viemode=1';
                //   window.open('/OMS/Management/Activities/posSalesInvoice.aspx?key=' + Uniqueid + '&Viemode=1', '_blank')

                url = '/OMS/Management/Activities/posSalesInvoice.aspx?key=' + Uniqueid + '&IsTagged=1&Viemode=1';
            }



            popupbudget.SetContentUrl(url);
            popupbudget.Show();

        }
        function BudgetAfterHide(s, e) {
            popupbudget.Hide();
        }

        function Callback_EndCallback() {

            // alert('');
            $("#drdExport").val(0);
        }

        function CloseGridQuotationLookup() {
            gridbranchLookup.ConfirmCurrentSelection();
            gridbranchLookup.HideDropDown();
            gridbranchLookup.Focus();
        }

        function CloseGridQuotationLookup2() {
            gridfinancerLookup.ConfirmCurrentSelection();
            gridfinancerLookup.HideDropDown();
            gridfinancerLookup.Focus();
        }


        function selectAll() {
            gridfinancerLookup.gridView.SelectRows();
        }

        function unselectAll() {
            gridfinancerLookup.gridView.UnselectRows();
        }

        function selectAll_branch() {
            gridbranchLookup.gridView.SelectRows();
        }

        function unselectAll_branch() {
            gridbranchLookup.gridView.UnselectRows();
        }

         $(document).keyup(function (e) {
            popupbudget.Hide();
        });

    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="panel-heading">
        <div class="panel-title">
            <h3>Finance Register</h3>

        </div>

    </div>
    <div class="form_main">
        <asp:HiddenField runat="server" ID="hdndaily" />
        <asp:HiddenField runat="server" ID="hdtid" />
        <table>
            <tr>


                <td style="">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label4" runat="Server" Text="Head Branch : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>

                <td>
                    <asp:DropDownList ID="ddlbranchHO" runat="server" Width="100%"></asp:DropDownList>
                </td>


                <td style="">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label1" runat="Server" Text="Branch : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>


                <td style="width: 254px">

                    <asp:ListBox ID="ListBoxBranches" Visible="false" runat="server" SelectionMode="Multiple" Font-Size="12px" Height="90px" Width="253px" CssClass="mb0 chsnProduct  hide" data-placeholder="--- ALL ---"></asp:ListBox>
                    <asp:HiddenField ID="hdnActivityType" runat="server" />
                    <asp:HiddenField ID="hdnActivityTypeText" runat="server" />
                    <span id="MandatoryActivityType" style="display: none" class="validclass">
                        <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor1112_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                    <asp:HiddenField ID="hdnSelectedBranches" runat="server" />



                    <dxe:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel1" ClientInstanceName="cProductbranchPanel" OnCallback="Componentbranch_Callback">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <dxe:ASPxGridLookup ID="lookup_branch" SelectionMode="Multiple" runat="server" ClientInstanceName="gridbranchLookup"
                                    OnDataBinding="lookup_branch_DataBinding"
                                    KeyFieldName="ID" Width="100%" TextFormatString="{1}" AutoGenerateColumns="False" MultiTextSeparator=", ">
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
                                                                <dxe:ASPxButton ID="btn_select" runat="server" AutoPostBack="false" Text="Select All" ClientSideEvents-Click="selectAll_branch" />
                                                            </div>
                                                            <dxe:ASPxButton ID="btn_unselect" runat="server" AutoPostBack="false" Text="Deselect All" ClientSideEvents-Click="unselectAll_branch" />                                                            
                                                            <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridQuotationLookup" UseSubmitBehavior="False" />
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
                                    <ClientSideEvents ValueChanged="BEginClickfinancerBind" />
                                </dxe:ASPxGridLookup>
                            </dxe:PanelContent>
                        </PanelCollection>

                    </dxe:ASPxCallbackPanel>



                </td>
                <td style="padding-left: 15px">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <span>Outstanding</span>
                    </div>
                </td>
                <td style="padding: 0 15px;">
                    <asp:DropDownList ID="ddlfinanceout" runat="server" Width="90px">
                        <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                        <asp:ListItem Value="0" Text="All"></asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td style="">
                    <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label3" runat="Server" Text="Financer : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td style="width: 254px">
                    <asp:ListBox ID="ListBoxCustomerVendor" Visible="false" runat="server" SelectionMode="Multiple" Font-Size="12px" Height="90px" Width="100%" CssClass="mb0 chsnProduct  hide" data-placeholder="--- ALL ---"></asp:ListBox>
                    <asp:HiddenField ID="hdnSelectedCustomerVendor" runat="server" />

                    <dxe:ASPxCallbackPanel runat="server" ID="cpFinancer" ClientInstanceName="cProductfinancerPanel" OnCallback="Componentfinancer_Callback">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <dxe:ASPxGridLookup ID="gridfinancerLookup" SelectionMode="Multiple" runat="server" ClientInstanceName="gridfinancerLookup"
                                    OnDataBinding="lookup_financer_DataBinding"
                                    KeyFieldName="ID" TextFormatString="{0}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                                    <Columns>
                                        <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="50" Caption=" " />


                                        <dxe:GridViewDataColumn FieldName="Name" Visible="true" VisibleIndex="1" Width="150" Caption="Financer Name" Settings-AutoFilterCondition="Contains">
                                        </dxe:GridViewDataColumn>
                                    </Columns>
                                    <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                                        <Templates>
                                            <StatusBar>
                                                <table class="OptionsTable" style="float: right">
                                                    <tr>
                                                        <td>
                                                            <div class="hide">
                                                                <dxe:ASPxButton ID="ASPxButton2_finance" runat="server" AutoPostBack="false" Text="Select All" ClientSideEvents-Click="selectAll" />
                                                            </div>
                                                            <dxe:ASPxButton ID="ASPxButton1_finance" runat="server" AutoPostBack="false" Text="Deselect All" ClientSideEvents-Click="unselectAll" />                                                            
                                                            <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridQuotationLookup2" UseSubmitBehavior="False" />

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
                            </dxe:PanelContent>
                        </PanelCollection>

                    </dxe:ASPxCallbackPanel>
                    <span id="MandatoryCustomerType" style="display: none" class="validclass">
                        <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor1112_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>

                </td>
            </tr>
        </table>
        <table>

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

                <td style="padding-left: 10px; padding-top: 3px">
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
                    <div>
                        <%-- <div  id="divRowview">--%>
                        <dxe:ASPxGridView runat="server" ID="ShowGrid" ClientInstanceName="Grid" Width="100%" EnableRowsCache="false"
                            AutoGenerateColumns="False" KeyboardSupport="true" KeyFieldName="Invoice_Id" 
                            OnCustomCallback="Grid_CustomCallback" OnDataBinding="ShowGrid_DataBinding" OnDataBound="Showgrid_Htmlprepared"
                            OnSummaryDisplayText="ShowGrid_SummaryDisplayText" ClientSideEvents-BeginCallback="Callback_EndCallback"
                            SettingsBehavior-AllowFocusedRow="true" SettingsBehavior-AllowSelectSingleRowOnly="true"
                            Settings-HorizontalScrollBarMode="Visible" SettingsBehavior-AutoExpandAllGroups="true">
                            <Columns>

                                <%--    <dxe:GridViewDataTextColumn FieldName="BRANCH_DESC" Caption="Unit"  VisibleIndex="1" />--%>

                                <dxe:GridViewDataTextColumn FieldName="Branch" Caption="Unit" SortOrder="Descending" FixedStyle="Left">
                                    <%--   <PropertiesComboBox
                                        ValueField="AssignTo" TextField="AssignTo" />--%>
                                </dxe:GridViewDataTextColumn>


                                <dxe:GridViewDataTextColumn FieldName="Date" Caption="Date" VisibleIndex="1" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy" FixedStyle="Left" />
                                <%--     <dxe:GridViewDataTextColumn FieldName="Bill Nubmer" Caption="Bill Number" VisibleIndex="2" Width="180"  FixedStyle="Left" />--%>



                                <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="Bill Nubmer" Caption="Bill Number" FixedStyle="Left" Width="150">
                                    <CellStyle HorizontalAlign="Left">
                                    </CellStyle>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <DataItemTemplate>

                                        <a href="javascript:void(0)" onclick="OpenPOSDetails('<%#Eval("Invoice_Id") %>','<%#Eval("Module_Type") %>')" class="pad">
                                            <%#Eval("Bill Nubmer")%>
                                        </a>
                                    </DataItemTemplate>

                                    <EditFormSettings Visible="False" />
                                </dxe:GridViewDataTextColumn>



                                <dxe:GridViewDataTextColumn FieldName="Challan No" Caption="Challan No" VisibleIndex="3" Width="150" />
                                <dxe:GridViewDataTextColumn FieldName="SRN" Caption="SRN?" VisibleIndex="4" Width="35" />
                                <dxe:GridViewDataTextColumn FieldName="Return_Number" Caption="Return Number" VisibleIndex="5" Width="150" />
                                <dxe:GridViewDataTextColumn FieldName="Return_Date" Caption="Return Date" VisibleIndex="6" Width="100" />
                                <dxe:GridViewDataTextColumn FieldName="Party Name" Caption="Customer" VisibleIndex="7" />

                                <dxe:GridViewDataTextColumn FieldName="Product Descprition" Caption="Product Descprition" VisibleIndex="8" />
                                <dxe:GridViewDataTextColumn FieldName="Bill Amount" Caption="Bill Amount" VisibleIndex="9" PropertiesTextEdit-DisplayFormatString="0.00" />


                                <dxe:GridViewDataTextColumn FieldName="Arn.No1" Caption="Arn.No1" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00">
                                </dxe:GridViewDataTextColumn>
                                <dxe:GridViewDataTextColumn FieldName="Down Pay1" Caption="Down Pay1" VisibleIndex="11" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Arn.No2" Caption="Arn.No2" VisibleIndex="12" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Down Pay2" Caption="Down Pay2" VisibleIndex="13" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="Disb. Doc No1" Caption="Disb. Doc No1" VisibleIndex="14" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Disb. Date1" Caption="Disb. Date1" VisibleIndex="15" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="Disb. Amount1" Caption="Disb. Amount1" VisibleIndex="16" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="Disb. Doc No2" Caption="Disb. Doc No2" VisibleIndex="17" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Disb. Date2" Caption="Disb. Date2" VisibleIndex="18" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Disb. Amount2" Caption="Disb. Amount2" VisibleIndex="19" PropertiesTextEdit-DisplayFormatString="0.00" />



                                <dxe:GridViewDataTextColumn FieldName="Disb. Doc No3" Caption="Disb. Doc No3" VisibleIndex="20" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Disb. Date3" Caption="Disb. Date3" VisibleIndex="21" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Disb. Amount3" Caption="Disb. Amount3" VisibleIndex="22" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="Processing Fee" Caption="Processing Fee" VisibleIndex="23" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="DBD Amt." Caption="DBD Amt." VisibleIndex="24" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="DBD%" Caption="DBD%" VisibleIndex="25" PropertiesTextEdit-DisplayFormatString="0.00" />



                                <dxe:GridViewDataTextColumn FieldName="Emaicharge" Caption="Other Charges" VisibleIndex="26" PropertiesTextEdit-DisplayFormatString="0.00" />


                                <dxe:GridViewDataTextColumn FieldName="Arn. No." Caption="Arn. No." VisibleIndex="27" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Final Pay" Caption="Final Pay" VisibleIndex="28" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Chq No" Caption="Chq No" VisibleIndex="29" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="Finance Amt" Caption="Finance Amt" VisibleIndex="30" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="MBD %" Caption="MBD %" VisibleIndex="31" PropertiesTextEdit-DisplayFormatString="0.00" />
                                <dxe:GridViewDataTextColumn FieldName="MBD Amt." Caption="MBD Amt." VisibleIndex="32" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="Outstandingref" Caption="Outstanding" VisibleIndex="33" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="ShortAmt" Caption="Short" VisibleIndex="34" PropertiesTextEdit-DisplayFormatString="0.00" />


                                <dxe:GridViewDataTextColumn FieldName="Excess" Caption="Excess" VisibleIndex="35" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="SFCode" Caption="SFCode" VisibleIndex="36" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <dxe:GridViewDataTextColumn FieldName="Pos_FinChallanNo" Caption="Finance Challan No" VisibleIndex="37" />

                                <dxe:GridViewDataTextColumn FieldName="Pos_FinChallanDate" Caption="Challan Date" VisibleIndex="38" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy" />


                                <dxe:GridViewDataTextColumn FieldName="Tot.Payment" Caption="Tot.Payment" VisibleIndex="39" PropertiesTextEdit-DisplayFormatString="0.00" />
                                  <dxe:GridViewDataTextColumn FieldName="Otstatus" Caption="Status" VisibleIndex="40" PropertiesTextEdit-DisplayFormatString="0.00" />

                                <%--  <dxe:GridViewDataTextColumn FieldName="SerialNo" Caption="Serials" VisibleIndex="39" PropertiesTextEdit-DisplayFormatString="0.00" />--%>
                            </Columns>
                            <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" />
                            <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                            <SettingsEditing Mode="EditForm" />
                            <SettingsContextMenu Enabled="true" />
                            <SettingsBehavior AutoExpandAllGroups="true" ColumnResizeMode="Control" />
                            <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
                         
                            <SettingsPager PageSize="10">
                                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                            </SettingsPager>
                            <Settings ShowFilterRow="True" ShowStatusBar="Visible" UseFixedTableLayout="true" />


                            <TotalSummary>
                                <dxe:ASPxSummaryItem FieldName="Bill Amount" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Disb. Amount1" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Disb. Amount3" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Finance Amt" SummaryType="Sum" />

                                <dxe:ASPxSummaryItem FieldName="Down Pay1" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Down Pay2" SummaryType="Sum" />

                                <dxe:ASPxSummaryItem FieldName="Disb. Amount2" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="DBD Amt." SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="MBD %" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="MBD Amt." SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Processing Fee" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Tot.Payment" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Outstanding" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="ShortAmt" SummaryType="Sum" />
                                <dxe:ASPxSummaryItem FieldName="Excess" SummaryType="Sum" />

                                <dxe:ASPxSummaryItem FieldName="Emaicharge" SummaryType="Sum" />
                            </TotalSummary>


                        </dxe:ASPxGridView>

                    </div>
                </td>
            </tr>
        </table>
    </div>

    <asp:SqlDataSource ID="SalesDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="sp_DailySales_Report" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
    <%--    <asp:SqlDataSource ID="EntityDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="SELECT aty_id ,aty_activityType Type FROM tbl_master_activitytype where (Is_Active=1 or aty_id=9)order by aty_id"></asp:SqlDataSource>--%>

    <%--<asp:SqlDataSource ID="EntityDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="sp_DailySales_Report" SelectCommandType="StoredProcedure"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="EntityDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="sp_DailySales_Report" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>


    <dxe:ASPxPopupControl ID="ASPXPopupControl2" runat="server"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupbudget" Height="500px"
        Width="1310px" HeaderText="Details" Modal="true" AllowResize="true" ResizingMode="Postponed">
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
            </dxe:PopupControlContentControl>
        </ContentCollection>

        <ClientSideEvents CloseUp="BudgetAfterHide" />
    </dxe:ASPxPopupControl>

</asp:Content>


