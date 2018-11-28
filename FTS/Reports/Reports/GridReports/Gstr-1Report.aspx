<%@ Page Title="GSTR-1 All Report" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" EnableEventValidation="false" AutoEventWireup="true"
    CodeBehind="Gstr-1Report.aspx.cs" Inherits="Reports.Reports.GridReports.Gstr_1Report" %>


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

        #ShowGrid, #ShowGrid .dxgvCSD {
            width: 100% !important;
        }
    </style>

    <script type="text/javascript">

        function fn_OpenDetails(keyValue) {
            //cPopup_Empcitys.SetHeaderText('Modify Products');
            Grid.PerformCallback('Edit~' + keyValue);

        }

        function Tabchange()
        {
            $("#drdExport").val(0);

        }

        $(function () {

            ///   BindBranches(null);

            function OnWaitingGridKeyPress(e) {
             
                if (e.code == "Enter") {

                }

            }


        });


        $(document).ready(function () {
            $("#ListBoxBranches").chosen().change(function () {
                var Ids = $(this).val();
                // BindLedgerType(Ids);                    

                $('#<%=hdnSelectedBranches.ClientID %>').val(Ids);
                $('#MandatoryActivityType').attr('style', 'display:none');

            })

        })



    </script>

    <script type="text/javascript">


        $("#drdExport").val(0);
        function btn_ShowRecordsClick(e) {
            debugger;
            e.preventDefault;

            var v = $("#ddlgstn").val();



            var activeTab = page.GetActiveTab();
            if (activeTab.name == 'B2B') {

                Gridb2b.PerformCallback('ListData~' + v);

            }
            else if (activeTab.name == 'B2CL') {

                b2clGrid.PerformCallback('ListData~' + v);

            }

            else if (activeTab.name == 'B2CS') {

                b2csGrid.PerformCallback('ListData~' + v);

            }

            else if (activeTab.name == 'CDNR9B') {

                cdnrGrid.PerformCallback('ListData~' + v);

            }


            else if (activeTab.name == 'CDNUR9B') {

                cdnurGrid.PerformCallback('ListData~' + v);

            }


            else if (activeTab.name == 'EXP') {

                expGrid.PerformCallback('ListData~' + v);

            }

            else if (activeTab.name == 'AT') {

                atGrid.PerformCallback('ListData~' + v);
            }

            else if (activeTab.name == 'ADJ') {

                adjGrid.PerformCallback('ListData~' + v);
            }

            else if (activeTab.name == 'EXEMP') {

                exempGrid.PerformCallback('ListData~' + v);
            }


            else if (activeTab.name == 'HSN') {

                hsnGrid.PerformCallback('ListData~' + v);
            }
            else if (activeTab.name == 'GSTINDocumentCount') {

                GSTNInDocumentCount.PerformCallback('ListData~' + v);
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


        function Callback_BeginCallback() {


            $("#drdExport").val(0);
        }






    </script>
     

</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="panel-heading">
        <div class="panel-title">
            <h3>GSTR-1 All  Report </h3>

        </div>

    </div>
    <div class="form_main">
        <asp:HiddenField runat="server" ID="hdndaily" />
        <asp:HiddenField runat="server" ID="hdtid" />
        <table class="pull-left">
            <tr>


                <td style="width: 254px; display: none">


                    <asp:HiddenField ID="hdnActivityType" runat="server" />
                    <asp:HiddenField ID="hdnActivityTypeText" runat="server" />
                    <span id="MandatoryActivityType" style="display: none" class="validclass">
                        <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor1112_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                    <asp:HiddenField ID="hdnSelectedBranches" runat="server" />


                </td>



                <td>
                    <div style="color: #b5285f; font-weight: bold;" class="clsFrom">
                        <asp:Label ID="lblFromDate" runat="Server" Text="GSTIN : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                </td>
                <td>


                    <asp:DropDownList ID="ddlgstn" runat="server" Width="150px"></asp:DropDownList>

                </td>


                <td>

                    <table>

                        <tr>

                            <td>
                                <div style="color: #b5285f; font-weight: bold;" class="clsFrom">
                                    <asp:Label ID="Label1" runat="Server" Text="From Date : " CssClass="mylabel1"
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

                            </td>

                        </tr>
                    </table>
                </td>



            </tr>



            <tr>
            </tr>
        </table>
        <div class="pull-right">



            <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary"
                OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true" OnChange="if(!AvailableExportOption()){return false;}">
                <asp:ListItem Value="0">Export to</asp:ListItem>
                <asp:ListItem Value="1">PDF</asp:ListItem>
                <asp:ListItem Value="2">XLSX</asp:ListItem>
                <asp:ListItem Value="3">RTF</asp:ListItem>
                <asp:ListItem Value="4">CSV</asp:ListItem>

            </asp:DropDownList>

        </div>

        <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" ClientInstanceName="page"
            Font-Size="12px" Width="100%">

            <TabPages>
                <dxe:TabPage Name="B2B" Text="GSTR-1 B2B">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">

                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div onkeypress="OnWaitingGridKeyPress(event)">
                                            <dxe:ASPxGridView runat="server" ID="ShowGrid" ClientInstanceName="Gridb2b" Width="100%" EnableRowsCache="false" ClientSideEvents-BeginCallback="Callback_BeginCallback"
                                                OnSummaryDisplayText="ShowGrid_SummaryDisplayText" OnDataBound="Showgrid_Datarepared" Settings-HorizontalScrollBarMode="Auto" OnCustomSummaryCalculate="ASPxGridView1_CustomSummaryCalculate"
                                                OnCustomCallback="Grid_CustomCallback" OnDataBinding="grid_DataBinding">

                                                <Columns>
                                                    <dxe:GridViewDataTextColumn FieldName="GSTINUIN" Caption="GSTIN/UIN of Recipient" VisibleIndex="1" Width="20%">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="InvoiceNo" Caption="Invoice Number" VisibleIndex="2" Width="18%">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Date" Caption="Invoice Date" VisibleIndex="3" Width="15%">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Value" Caption="Invoice Value" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="0.00" Width="30%">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="POS" Caption="Place of Supply" VisibleIndex="5" Width="20%">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="Reverse Charge" Caption="Reverse Charge" VisibleIndex="6">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="Type" Caption="Invoice Type" VisibleIndex="7" Width="10%">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="GSTIN E-Commerce" Caption="E-Commerce GSTIN" VisibleIndex="8" Width="10%">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="Rate" Caption="Rate" VisibleIndex="9" Width="10%" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Taxable value" Caption="Taxable value" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00" Width="30%">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="cesss" Caption="Cess Amount" VisibleIndex="11" PropertiesTextEdit-DisplayFormatString="0.00">
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
                                                    <dxe:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Taxable value" SummaryType="Sum" />

                                                    <dxe:ASPxSummaryItem FieldName="InvoiceNo" SummaryType="Custom" DisplayFormat="Count" />

                                                    <dxe:ASPxSummaryItem FieldName="GSTINUIN" SummaryType="Custom" DisplayFormat="Count" />

                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>


                            </table>

                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>


                <dxe:TabPage Name="B2CL" Text="GSTR-1 B2CL">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">

                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="grid_b2cl" ClientInstanceName="b2clGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_b2cl_SummaryDisplayText"
                                                OnCustomSummaryCalculate="GridView_b2cl_CustomSummaryCalculate" ClientSideEvents-BeginCallback="Callback_BeginCallback"
                                                OnCustomCallback="Grid_b2cl__CustomCallback" OnDataBinding="grid_b2cl_DataBinding">

                                                <Columns>

                                                    <dxe:GridViewDataTextColumn FieldName="InvoiceNo" Caption="Invoice No." Width="15%" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Date" Caption="Invoice Date" VisibleIndex="3">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Value" Caption="Invoice Value" VisibleIndex="4" Width="20%" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="POS" Caption="Place of Supply" VisibleIndex="5">
                                                    </dxe:GridViewDataTextColumn>




                                                    <dxe:GridViewDataTextColumn FieldName="Rate" Caption="Rate" VisibleIndex="6" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Taxable value" Caption="Taxable value" Width="20%" VisibleIndex="7" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="cesss" Caption="Cess Amount" VisibleIndex="8" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="GSTIN E-Commerce" Caption="E-Commerce GSTIN" VisibleIndex="9">
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
                                                    <dxe:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Taxable value" SummaryType="Sum" />

                                                    <dxe:ASPxSummaryItem FieldName="InvoiceNo" SummaryType="Custom" DisplayFormat="Count" />



                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>


                <dxe:TabPage Name="B2CS" Text="GSTR-1 B2CS">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">
                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="grid_b2cs" ClientInstanceName="b2csGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_b2cs_SummaryDisplayText" 
                                                ClientSideEvents-BeginCallback="Callback_BeginCallback"
                                                OnCustomCallback="Grid_b2cs__CustomCallback" OnDataBinding="grid_b2cs_DataBinding">

                                                <Columns>


                                                    <dxe:GridViewDataTextColumn FieldName="Type" Caption="Type" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="POS" Caption="Place of Supply" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Rate" Caption="Rate" VisibleIndex="3" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Taxable value" Caption="Taxable value" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="00.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="cesss" Caption="Cess Amount" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="GSTIN E-Commerce" Caption="E-Commerce GSTIN" VisibleIndex="6">
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

                                                    <dxe:ASPxSummaryItem FieldName="Taxable value" SummaryType="Sum" />




                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>

                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>



                <dxe:TabPage Name="CDNR9B" Text="GSTR-1 CDNR">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">

                            <table class="TableMain100">
                                <tr>
                                    <td colspan="2">
                                        <div class="GridViewArea">
                                            <dxe:ASPxGridView runat="server" ID="grid_cdnr" ClientInstanceName="cdnrGrid" Width="100%"
                                                EnableRowsCache="false" ClientSideEvents-BeginCallback="Callback_BeginCallback"
                                                OnSummaryDisplayText="Grid_cdnr_SummaryDisplayText" Settings-HorizontalScrollBarMode="Visible"
                                                OnCustomSummaryCalculate="GridView_cdnr_CustomSummaryCalculate"
                                                OnCustomCallback="Grid_cdnr_CustomCallback" OnDataBinding="grid_cdnr_DataBinding">

                                                <Columns>
                                                    <dxe:GridViewDataTextColumn FieldName="GSTINUIN" Caption="GSTIN/UIN of Recipient" VisibleIndex="1" Width="140px">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Invoice" Caption="Invoice/Advance Receipt Number" VisibleIndex="2" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Invoice_Date" Caption="Invoice/Advance Receipt date" VisibleIndex="3" Width="170px">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Return_Number" Caption="Note/Refund Voucher Number" VisibleIndex="4" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Return_Date" Caption="Note/Refund Voucher date" VisibleIndex="5" Width="170px">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="type" Caption="Document Type" VisibleIndex="6">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="reason" Caption="Reason For Issuing document" VisibleIndex="7" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="POS" Caption="Place Of Supply" VisibleIndex="8">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="Value" Caption="Note/Refund Voucher Value" VisibleIndex="9" PropertiesTextEdit-DisplayFormatString="0.00" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Rate" Caption="Rate" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Taxable value" Caption="Taxable Value" VisibleIndex="11" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="cess" Caption="Cess Amount" VisibleIndex="12" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="pregst" Caption="Pre GST" VisibleIndex="13" PropertiesTextEdit-DisplayFormatString="0.00">
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
                                                    <dxe:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Taxable value" SummaryType="Sum" />


                                                    <dxe:ASPxSummaryItem FieldName="Invoice" SummaryType="Custom" DisplayFormat="Count" />

                                                    <dxe:ASPxSummaryItem FieldName="GSTINUIN" SummaryType="Custom" DisplayFormat="Count" />

                                                    <dxe:ASPxSummaryItem FieldName="Return_Number" SummaryType="Custom" DisplayFormat="Count" />

                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>



                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>


                <dxe:TabPage Name="CDNUR9B" Text="GSTR-1 CDNUR">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">



                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div class="GridViewArea">
                                            <dxe:ASPxGridView runat="server" ID="grid_cdnur" ClientInstanceName="cdnurGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_cdnur_SummaryDisplayText"
                                                BeginCallback="Callback_BeginCallback"
                                                Settings-HorizontalScrollBarMode="Visible" OnCustomSummaryCalculate="GridView_cdnur_CustomSummaryCalculate"
                                                OnCustomCallback="Grid_cdnur_CustomCallback" OnDataBinding="grid_cdnur_DataBinding">

                                                <Columns>
                                                    <dxe:GridViewDataTextColumn FieldName="urltype" Caption="UR Type" VisibleIndex="1" Width="140px">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Return_Number" Caption="Note/Refund Voucher Number" VisibleIndex="2" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Return_Date" Caption="Note/Refund Voucher date" VisibleIndex="3" Width="170px">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="type" Caption="Document Type" VisibleIndex="4">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Invoice" Caption="Invoice/Advance Receipt Number" VisibleIndex="5" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Invoice_Date" Caption="Invoice/Advance Receipt date" VisibleIndex="6" Width="170px">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="reason" Caption="Reason For Issuing document" VisibleIndex="7" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="POS" Caption="Place Of Supply" VisibleIndex="8">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="Value" Caption="Note/Refund Voucher Value" VisibleIndex="9" PropertiesTextEdit-DisplayFormatString="0.00" Width="190px">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Rate" Caption="Rate" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Taxable value" Caption="Taxable Value" VisibleIndex="11" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="cess" Caption="Cess Amount" VisibleIndex="12" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="pregst" Caption="Pre GST" VisibleIndex="13" PropertiesTextEdit-DisplayFormatString="0.00">
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
                                                    <dxe:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Taxable value" SummaryType="Sum" />


                                                    <dxe:ASPxSummaryItem FieldName="Invoice" SummaryType="Custom" DisplayFormat="Count" />

                                                    <dxe:ASPxSummaryItem FieldName="GSTINUIN" SummaryType="Custom" DisplayFormat="Count" />

                                                    <dxe:ASPxSummaryItem FieldName="Return_Number" SummaryType="Custom" DisplayFormat="Count" />

                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>



                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>



                <dxe:TabPage Name="EXP" Text="GSTR-1 EXP">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">

                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="grid_exp" ClientInstanceName="expGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_exp_SummaryDisplayText" BeginCallback="Callback_BeginCallback"
                                                Settings-HorizontalScrollBarMode="Auto" OnCustomSummaryCalculate="GridView_exp_CustomSummaryCalculate"
                                                OnCustomCallback="Grid_exp_CustomCallback" OnDataBinding="grid_exp_DataBinding">

                                                <Columns>
                                                    <dxe:GridViewDataTextColumn FieldName="exptype" Caption="Export Type" VisibleIndex="1" Width="20%">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="InvoiceNo" Caption="Invoice Number" VisibleIndex="2" Width="18%">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Date" Caption="Invoice Date" VisibleIndex="3" Width="15%">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Value" Caption="Invoice Value" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="0.00" Width="30%">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="portcode" Caption="Port Code" VisibleIndex="5" Width="20%">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="shipbill" Caption="Shipping Bill Number" VisibleIndex="6">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="shipdate" Caption="Shipping Bill Date" VisibleIndex="7" Width="10%">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="Rate" Caption="Rate" VisibleIndex="9" Width="10%" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Taxable value" Caption="Taxable value" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00" Width="30%">
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
                                                    <dxe:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Taxable value" SummaryType="Sum" />

                                                    <dxe:ASPxSummaryItem FieldName="InvoiceNo" SummaryType="Custom" DisplayFormat="Count" />



                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>



                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>





                <dxe:TabPage Name="AT" Text="GSTR-1 AT">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">

                            <table class="TableMain100">

                                <tr>

                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="grid_at" ClientInstanceName="atGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_at_SummaryDisplayText" BeginCallback="Callback_BeginCallback"
                                                OnCustomCallback="Grid_at_CustomCallback" OnDataBinding="grid_at_DataBinding">

                                                <Columns>



                                                    <dxe:GridViewDataTextColumn FieldName="POS" Caption="Place of Supply" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Rate2" Caption="Rate" VisibleIndex="3" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Value" Caption="Gross Advance Received" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="00.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="cesss" Caption="Cess Amount" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="0.00">
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

                                                    <dxe:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />




                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>

                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>




                <dxe:TabPage Name="ADJ" Text="GSTR-1 ADVANCED  ADJUSTED">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">


                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="grid_adj" ClientInstanceName="adjGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_adj_SummaryDisplayText" BeginCallback="Callback_BeginCallback"
                                                OnCustomCallback="Grid_adj_CustomCallback" OnDataBinding="grid_adj_DataBinding">

                                                <Columns>



                                                    <dxe:GridViewDataTextColumn FieldName="POS" Caption="Place of Supply" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Rate2" Caption="Rate" VisibleIndex="3" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Value" Caption="Gross Advance Adjusted" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="cesss" Caption="Cess Amount" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="0.00">
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

                                                    <dxe:ASPxSummaryItem FieldName="Value" SummaryType="Sum" />




                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>



                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>


                <dxe:TabPage Name="EXEMP" Text="GSTR-1 EXEMP">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">


                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="grid_exemp" ClientInstanceName="exempGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_exemp_SummaryDisplayText" BeginCallback="Callback_BeginCallback"
                                                OnCustomCallback="Grid_exemp_CustomCallback" OnDataBinding="grid_exemp_DataBinding">

                                                <Columns>


                                                    <dxe:GridViewDataTextColumn FieldName="name" Caption="Description" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>




                                                      <dxe:GridViewDataTextColumn FieldName="nilrated" Caption="Nil Rated Supplies" VisibleIndex="3" PropertiesTextEdit-DisplayFormatString="00.00">
                                                    </dxe:GridViewDataTextColumn>



                                                     <dxe:GridViewDataTextColumn FieldName="exempted" Caption="Exempted (other than nil rated/non GST supply )" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="00.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Amount" Caption="Non-GST Supplies" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="00.00">
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

                                                    <dxe:ASPxSummaryItem FieldName="Amount" SummaryType="Sum" />




                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>


                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>


                <dxe:TabPage Name="HSN" Text="GSTR-1 HSN(12)">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">


                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="grid_hsn" ClientInstanceName="hsnGrid" Width="100%" EnableRowsCache="false"
                                                OnSummaryDisplayText="Grid_hsn_SummaryDisplayText"  BeginCallback="Callback_BeginCallback"
                                                OnCustomCallback="Grid_hsn_CustomCallback" OnDataBinding="grid_hsn_DataBinding">

                                                <Columns>


                                                    <dxe:GridViewDataTextColumn FieldName="sProducts_HsnCode" Caption="HSN" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="sProducts_Description" Caption="Description" VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="UOM" Caption="UQC" VisibleIndex="3">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Qty" Caption="Total Quantity" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Net" Caption="Total Value" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>



                                                    <dxe:GridViewDataTextColumn FieldName="TAxAmt" Caption="Taxable Value" VisibleIndex="6" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="IGSTRate" Caption="Integrated Tax Amount" VisibleIndex="7" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="CGSTRate" Caption="Central tax Amount" VisibleIndex="8" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="SGSTRate" Caption="State/UT tax Amount" VisibleIndex="9" PropertiesTextEdit-DisplayFormatString="0.00">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="cess" Caption="Cess Amount" VisibleIndex="10" PropertiesTextEdit-DisplayFormatString="0.00">
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

                                                    <dxe:ASPxSummaryItem FieldName="Qty" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="Net" SummaryType="Sum" />

                                                    <dxe:ASPxSummaryItem FieldName="TAxAmt" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="IGSTRate" SummaryType="Sum" />


                                                    <dxe:ASPxSummaryItem FieldName="CGSTRate" SummaryType="Sum" />
                                                    <dxe:ASPxSummaryItem FieldName="SGSTRate" SummaryType="Sum" />

                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>

                

                <dxe:TabPage Name="GSTINDocumentCount" Text="GSTR-1 Document Count">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">


                            <table class="TableMain100">

                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <dxe:ASPxGridView runat="server" ID="GST_DocumentCount" ClientInstanceName="GSTNInDocumentCount" Width="100%" EnableRowsCache="false"
                                               OnSummaryDisplayText="Grid_Document_SummaryDisplayText"  BeginCallback="Callback_BeginCallback" 
                                                OnCustomCallback="Grid_DocumentCount_CustomCallback" OnDataBinding="grid_DocumentCount_DataBinding">

                                                <Columns>


                                                    <dxe:GridViewDataTextColumn FieldName="Nature_of_Document" Caption="Document Nature" VisibleIndex="1">
                                                    </dxe:GridViewDataTextColumn>

                                                    <dxe:GridViewDataTextColumn FieldName="Start_Documnet_number" Caption="Start Doc No." VisibleIndex="2">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="End_Documnet_number" Caption="End Doc No." VisibleIndex="3">
                                                    </dxe:GridViewDataTextColumn>


                                                    <dxe:GridViewDataTextColumn FieldName="Total_Number" Caption="Total Number" VisibleIndex="4" >
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

                                                    <dxe:ASPxSummaryItem FieldName="Total_Number" SummaryType="Sum" />
                                                    

                                                </TotalSummary>

                                            </dxe:ASPxGridView>

                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>




            </TabPages>
            <ClientSideEvents ActiveTabChanged="Tabchange" />
        </dxe:ASPxPageControl>




    </div>

    <div>
    </div>

    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>




</asp:Content>

