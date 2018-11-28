<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="frm_purintaxreg.aspx.cs" Inherits="Reports.Reports.GridReports.frm_purintaxreg" EnableViewState="false"%>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

      <%-- <script src="../../OMS/JSFUNCTION/jquery-ui.js"></script>
       <script src="../../assests/js/Date/datevalidate.js"></script--%>

    <%--<script>
        $(document).ready(function () {
            $("#FromDate").datepicker({ dateFormat: "dd-mm-yy" }).datepicker("setDate", new Date());
            validatedate('#FromDate');
            $("#ToDate").datepicker({ dateFormat: "dd-mm-yy" }).datepicker("setDate", new Date());
            validatedate('#ToDate');
        });

        $(function () {
            $('#FromDate').datepicker({
                changeMonth: true,
                changeYear: true,Fop
                dateFormat: 'dd-mm-yy',
                yearRange: '-2: +10'
            })

            $('#ToDate').datepicker({
                changeMonth: true,
                changeYear: true,
                dateFormat: 'dd-mm-yy',
                yearRange: '-2: +10'
            })

        });

    </script>--%>

    <script type="text/javascript">
        function updateGridByDate() {
            $("#drdExport").val(0);

            if (ddlgstn.value=='') {
                jAlert('Please select GSTIN');
            }
            else{
            if (griddoctypeLookup.GetValue() == null) {
                jAlert('Please select atleast one Document Type');
            }
            else {

                //debugger;
                //var sdate = $('#FromDate').datepicker("getDate");
                //var edate = $('#ToDate').datepicker("getDate");

                if (cxdeToDate.GetDate() < cxdeFromDate.GetDate()) {
                //if (edate < sdate) {
                    jAlert('From Date should not be grater than To Date');
                }
                else {
                    if ($("#ddlgstn").val()) {
                        cOPTREGGrid.PerformCallback('BindOPTREGGrid' + '~' + $("#ddlgstn").val());
                    }
                    else {
                        cOPTREGGrid.PerformCallback('BindOPTREGGrid' + '~' + 0);
                    }

                }
            }
            }

          
        }

        function CloseGridBranchLookup() {
            gridbranchLookup.ConfirmCurrentSelection();
            gridbranchLookup.HideDropDown();
            gridbranchLookup.Focus();
        }

        function selectAll_branch() {
            gridbranchLookup.gridView.SelectRows();
        }
        function unselectAll_branch() {
            gridbranchLookup.gridView.UnselectRows();
        }

        function CloseGridDocTypeLookup() {
            griddoctypeLookup.ConfirmCurrentSelection();
            griddoctypeLookup.HideDropDown();
            griddoctypeLookup.Focus();
        }

        function doctypeselectAll_branch() {
            griddoctypeLookup.gridView.SelectRows();
        }
        function doctypeunselectAll_branch() {
            griddoctypeLookup.gridView.UnselectRows();
        }

        $(function () {
           /// debugger;
            $('body').on('change', '#ddlgstn', function () {
                if ($("#ddlgstn").val()) {
                    cProductbranchComponentPanel.PerformCallback('BindComponentGrid' + '~' + $("#ddlgstn").val());
                }
                else {
                    cProductbranchComponentPanel.PerformCallback('BindComponentGrid' + '~' + 0);
                }
            });
        });

        function GetContactPerson(e) {
            if (!cCustomerComboBox.FindItemByValue(cCustomerComboBox.GetValue())) {
                jAlert("Vendor not Exists.", "Alert", function () { cCustomerComboBox.SetValue(); cCustomerComboBox.Focus(); });
                return;
            }
        }

        //function btn_ShowRecordsClick(e) {
        //    e.preventDefault;
        //    var v = $("#ddlgstn").val();
        //    Grid.PerformCallback('ListData~' + v);
        //    Gridreturn.PerformCallback('ListData~' + v);
        //}

    </script>
    <style>
        .mrtable, .padtbl {
            margin-left: 15px;
        }

            .mrtable > tbody > tr > td {
                padding-right: 25px;
            }

            .padtbl > tbody > tr > td {
                padding-right: 15px;
            }
    </style>


    <div class="panel-heading">
        <div class="panel-title">
            <%-- <h3>GSTR Report</h3>--%>
            <h3>GST Input Tax Register</h3>
        </div>

    </div>
    <div class="form_main">

        <%--<div class="SearchArea">--%>
        <div class="clear"></div>
        <div class="clearfix row">

            <div class="col-md-2">
                <%--<label>GSTIN: </label>--%>
                <%-- <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label6" runat="Server" Text="GSTIN : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </div>
                <div>

                    <dxe:ASPxComboBox ID="cmbGstinlist" ClientInstanceName="ccmbGstinlist" runat="server" SelectedIndex="0"
                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                    </dxe:ASPxComboBox>
                </div>--%>

                    <label style="color: #b5285f; font-weight: bold;" class="clsFrom">
                        <asp:Label ID="Label6" runat="Server" Text="GSTIN : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </label>
                
                    <asp:DropDownList ID="ddlgstn" runat="server" Width="150px"></asp:DropDownList>
                
            </div>

            <div class="col-md-2">
                
                    <label style="color: #b5285f; font-weight: bold;" class="clsTo">
                        <asp:Label ID="Label5" runat="Server" Text="Branch : " CssClass="mylabel1"
                            Width="92px"></asp:Label>
                    </label>
               


                

                    <asp:ListBox ID="ListBoxBranches" Visible="false" runat="server" SelectionMode="Multiple" Font-Size="12px" Height="90px" Width="253px" CssClass="mb0 chsnProduct  hide" data-placeholder="--- ALL ---"></asp:ListBox>
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                    <asp:HiddenField ID="HiddenField2" runat="server" />
                    <span id="MandatoryBranch" style="display: none" class="validclass">
                        <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor1112_EII" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                    <asp:HiddenField ID="HiddenField3" runat="server" />

                    <dxe:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel1" ClientInstanceName="cProductbranchComponentPanel" OnCallback="Componentbranch_Callback">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <dxe:ASPxGridLookup ID="lookup_branch" SelectionMode="Multiple" runat="server" ClientInstanceName="gridbranchLookup"
                                    OnDataBinding="lookup_branch_DataBinding"
                                    KeyFieldName="branch_id" Width="100%" TextFormatString="{1}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                                    <Columns>
                                        <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="60" Caption=" " />
                                        <dxe:GridViewDataColumn FieldName="branch_code" Visible="true" VisibleIndex="1" width="200px" Caption="Branch code" Settings-AutoFilterCondition="Contains">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>

                                        <dxe:GridViewDataColumn FieldName="branch_description" Visible="true" VisibleIndex="2" width="200px" Caption="Branch Name" Settings-AutoFilterCondition="Contains">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>
                                    </Columns>
                                    <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                                        <Templates>
                                            <StatusBar>
                                                <table class="OptionsTable" style="float: right">
                                                    <tr>
                                                        <td>
                                                            <%--<div class="hide">--%>
                                                                <dxe:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="false" Text="Select All" ClientSideEvents-Click="selectAll_branch" />
                                                           <%-- </div>--%>
                                                            <dxe:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" Text="Deselect All" ClientSideEvents-Click="unselectAll_branch" />                                                            
                                                            <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridBranchLookup" UseSubmitBehavior="False" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </StatusBar>
                                        </Templates>
                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                        <SettingsPager Mode="ShowPager">
<PageSizeItemSettings Items="10, 20, 50, 100, 150, 200" Visible="True"></PageSizeItemSettings>
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
               

            </div>

            <div class="col-md-2">
                <label style="color: #b5285f; font-weight: bold;" class="clsTo">
                    <asp:Label ID="Label2" runat="Server" Text="Document Type: " CssClass="mylabel1"></asp:Label>
                </label>
               <%-- <asp:DropDownList ID="ddlisdocument" runat="server" Width="100%">
                    <asp:ListItem Text="All" Value="All"></asp:ListItem>
                    <asp:ListItem Text="Cash/Bank" Value="Cash/Bank"></asp:ListItem>
                    <asp:ListItem Text="Purchases" Value="Purchases"></asp:ListItem>
                    <asp:ListItem Text="Journal" Value="Journal"></asp:ListItem>

                </asp:DropDownList>--%>


              
                 <%--<dxe:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel2" ClientInstanceName="cProductbranchComponentPanel" OnCallback="Componentbranch_Callback">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">--%>
                                <dxe:ASPxGridLookup ID="lookup_doctype" SelectionMode="Multiple" runat="server" ClientInstanceName="griddoctypeLookup"
                                    OnDataBinding="lookup_doctype_DataBinding"
                                    KeyFieldName="doctype_code" Width="100%" TextFormatString="{1}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                                    <Columns>
                                        <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="60" Caption=" " />
                                        <dxe:GridViewDataColumn FieldName="doctype_code" Visible="false" VisibleIndex="1" Caption="Document Type code" Settings-AutoFilterCondition="Contains">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>

                                        <dxe:GridViewDataColumn FieldName="doctype_description" Visible="true" VisibleIndex="2" Caption="Document Type Name" Settings-AutoFilterCondition="Contains">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>
                                    </Columns>
                                    <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                                        <Templates>
                                            <StatusBar>
                                                <table class="OptionsTable" style="float: right">
                                                    <tr>
                                                        <td>
                                                            <%--<div class="hide">--%>
                                                                <dxe:ASPxButton ID="ASPxselect" runat="server" AutoPostBack="false" Text="Select All" ClientSideEvents-Click="doctypeselectAll_branch" />
                                                            <%--</div>--%>
                                                            <dxe:ASPxButton ID="ASPxdselect" runat="server" AutoPostBack="false" Text="Deselect All" ClientSideEvents-Click="doctypeunselectAll_branch" />                                                            
                                                            <dxe:ASPxButton ID="Closedoc" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridDocTypeLookup" UseSubmitBehavior="False" />
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
                         <%--   </dxe:PanelContent>
                        </PanelCollection>

                    </dxe:ASPxCallbackPanel>--%>



            </div>
          
            <div class="col-md-2">
                <label style="color: #b5285f; font-weight: bold;" class="clsTo">
                    <asp:Label ID="Label4" runat="Server" Text="Vendor (Min. 4 Char): " CssClass="mylabel1"></asp:Label>
                </label>
                <dxe:ASPxComboBox ID="CustomerComboBox" runat="server" EnableCallbackMode="true" CallbackPageSize="15"  FilterMinLength="4"
                    ValueType="System.String" ValueField="cnt_internalid" ClientInstanceName="cCustomerComboBox" Width="92%"
                    OnItemsRequestedByFilterCondition="ASPxComboBox_OnItemsRequestedByFilterCondition_SQL"
                    OnItemRequestedByValue="ASPxComboBox_OnItemRequestedByValue_SQL" TextFormatString="{1} [{0}]"
                        DropDownStyle="DropDown">
                    <Columns>
                        <dxe:ListBoxColumn FieldName="Name" Caption="Name"  Width="300px"/>
                    </Columns> 
                     <ClientSideEvents ValueChanged="function(s, e) {GetContactPerson(e)}" GotFocus="function(s,e){cCustomerComboBox.ShowDropDown();}" />
                </dxe:ASPxComboBox> 
            </div>
            <div class="col-md-2">
                <label style="color: #b5285f; font-weight: bold;" class="clsFrom">
                            <asp:Label ID="lblFromDate" runat="Server" Text="From Date : " CssClass="mylabel1"></asp:Label>
                        </label>
                        <dxe:ASPxDateEdit ID="ASPxFromDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                            UseMaskBehavior="True" Width="150px" ClientInstanceName="cxdeFromDate">
                            <ButtonStyle Width="13px">
                            </ButtonStyle>
                        </dxe:ASPxDateEdit>
                        <%--<input id="FromDate" type="text" runat="server" autocomplete="off" onkeyup="dateValidationFormat(event)"  maxlength="10" />--%>
            </div>
            <div class="col-md-2">
                <label style="color: #b5285f; font-weight: bold;" class="clsTo">
                    <asp:Label ID="lblToDate" runat="Server" Text="To Date : " CssClass="mylabel1"
                        Width="92px"></asp:Label>
                </label>
                <dxe:ASPxDateEdit ID="ASPxToDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                    UseMaskBehavior="True" Width="150px" ClientInstanceName="cxdeToDate">
                    <ButtonStyle Width="13px">
                    </ButtonStyle>
                </dxe:ASPxDateEdit>

               <%-- <input id="ToDate" type="text" runat="server" autocomplete="off" onkeyup="dateValidationFormat(event)"  maxlength="10" />--%>
            </div>

            <div class="clear"></div>
            <table class="padtbl">
                <tr>
                    <td class="pTop15">
                        <asp:CheckBox ID="chkPartyInvDt" runat="server" Checked="true"></asp:CheckBox>
                        <asp:Label ID="Label7" runat="Server" Text="Search by Party Invoice Date " CssClass="mylabel1"></asp:Label></td>

                    

                    <td style="width: 200px; padding-top: 18px;">
                        <input type="button" style="margin-top: 2px;" value="Show" class="btn btn-primary" onclick="updateGridByDate()" />
                        <%--<asp:DropDownList ID="drdExport" runat="server" Style="margin-top: 2px;" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
                            <asp:ListItem Value="0">Export to</asp:ListItem>
                            <asp:ListItem Value="1">PDF</asp:ListItem>
                            <asp:ListItem Value="2">XLSX</asp:ListItem>
                            <asp:ListItem Value="3">RTF</asp:ListItem>
                            <asp:ListItem Value="4">CSV</asp:ListItem>
                        </asp:DropDownList>--%>
                         <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="drdExport_SelectedIndexChanged"
                        AutoPostBack="true" OnChange="if(!AvailableExportOption()){return false;}">
                        <asp:ListItem Value="0">Export to</asp:ListItem>
                        <asp:ListItem Value="1">PDF</asp:ListItem>
                        <asp:ListItem Value="2">XLSX</asp:ListItem>
                        <asp:ListItem Value="3">RTF</asp:ListItem>
                        <asp:ListItem Value="4">CSV</asp:ListItem>
                    </asp:DropDownList>
                    </td>
                </tr>
            </table>

            <%--<div class="col-md-3">
                <label>From: </label>
                <div>

                    <dxe:ASPxDateEdit ID="FormDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cFormDate" Width="100%">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>
                    </dxe:ASPxDateEdit>
                </div>
            </div>--%>





            <%--<div class="col-md-3">
                <label>To: </label>
                <div>

                    <dxe:ASPxDateEdit ID="toDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="ctoDate" Width="100%">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>
                    </dxe:ASPxDateEdit>

                </div>
            </div>--%>
            <div class="col-md-2">
            </div>

            <div class="col-md-2">

                <table>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>
                </table>



            </div>


        </div>
        <%--  </div>--%>


       <%-- <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" ClientInstanceName="page"
            Font-Size="12px" Width="100%">
            <TabPages>
                <dxe:TabPage Name="OTR" Text="Output Tax Register">
                    <ContentCollection>
                        <dxe:ContentControl runat="server">


                         

                        </dxe:ContentControl>
                    </ContentCollection>
                </dxe:TabPage>

            </TabPages>
        </dxe:ASPxPageControl>--%>

           <div class="GridViewArea">
                                <%--<dxe:ASPxGridView ID="OPTREGGrid" runat="server" KeyFieldName="Document No" AutoGenerateColumns="False"
                                    Width="100%" ClientInstanceName="cOPTREGGrid" OnCustomCallback="OPTREGGrid_CustomCallback" SettingsBehavior-AllowFocusedRow="true"
                                    SettingsBehavior-AllowSelectSingleRowOnly="false"
                                    OnCustomSummaryCalculate="ASPxGridView1_CustomSummaryCalculate"
                                    OnSummaryDisplayText="OPTREGGrid_SummaryDisplayText"
                                    SettingsBehavior-AllowSelectByRowClick="true" OnDataBinding="OPTREGGrid_DataBinding" Settings-HorizontalScrollBarMode="Auto"
                                    SettingsCookies-Enabled="true" SettingsCookies-StorePaging="true" SettingsCookies-StoreFiltering="true"
                                    SettingsCookies-StoreGroupingAndSorting="true" SettingsBehavior-ColumnResizeMode="Control" EnableRowsCache="false" >--%>
                  <dxe:ASPxGridView runat="server" ID="OPTREGGrid" ClientInstanceName="cOPTREGGrid" KeyFieldName="Document No" Width="100%" EnableRowsCache="false" AutoGenerateColumns="False"
                OnCustomCallback="OPTREGGrid_CustomCallback" OnDataBinding="OPTREGGrid_DataBinding" OnCustomSummaryCalculate="OPTREGGrid_CustomSummaryCalculate"
                OnSummaryDisplayText="OPTREGGrid_SummaryDisplayText" Settings-HorizontalScrollBarMode="Visible">
                                    <Columns>

                                   
                                        <dxe:GridViewDataTextColumn Caption="Document Type" FieldName="Document_type" width="200px" GroupIndex="0"
                                            VisibleIndex="1" >
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Location" FieldName="Branch Name" width="200px"
                                            VisibleIndex="2">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Document No" FieldName="Document No"
                                            VisibleIndex="3">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Document Date" FieldName="Document Date"
                                            VisibleIndex="4">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                         <dxe:GridViewDataTextColumn Caption="Vendor Bill Number" FieldName="PartyInvNo" width="160px"
                                            VisibleIndex="5">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Vendor Bill Date" FieldName="PartyInvDate" width="160px"
                                            VisibleIndex="6">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="HSN/SAC code" FieldName="HsnCode" Width="140px"
                                            VisibleIndex="7">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                         <dxe:GridViewDataTextColumn Caption="Vendor Name" FieldName="Vendor_Name" Width="140px"
                                            VisibleIndex="8">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Party GSTIN" FieldName="GSTINID" Width="140px"
                                            VisibleIndex="9" >
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                         <dxe:GridViewDataTextColumn Caption="Vendor Type" FieldName="Vend_type" Width="140px"
                                            VisibleIndex="10">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Place of supply" FieldName="Place of Supply" Width="170px"
                                            VisibleIndex="11">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Type of Movement(Inter/Intra/Import)" FieldName="Type_of_movement"  width="250px"
                                            VisibleIndex="12">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Doc Type Description" FieldName="Doc Type Description"  width="200px"
                                            VisibleIndex="13">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Total Amount" FieldName="Invoice_Value"
                                            VisibleIndex="14">
                                            <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            <Style HorizontalAlign="Right"></Style>
                                            </PropertiesTextEdit>
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Taxable Value" FieldName="Taxable Amount"
                                            VisibleIndex="15">
                                            <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            
<Style HorizontalAlign="Right"></Style>

</PropertiesTextEdit>
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Taxable/Exempt" FieldName="TaxableExempt"
                                            VisibleIndex="16">
                                            <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            
<Style HorizontalAlign="Right"></Style>

</PropertiesTextEdit>
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Central Tax Rate" FieldName="CGST Rate"
                                            VisibleIndex="17">
                                            <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            
<Style HorizontalAlign="Right"></Style>

</PropertiesTextEdit>
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>


                                        <dxe:GridViewDataTextColumn Caption="State Tax Rate" FieldName="SGST Rate"
                                            VisibleIndex="18">
                                            <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            
<Style HorizontalAlign="Right"></Style>

</PropertiesTextEdit>
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Integrated Tax Rate" FieldName="IGST Rate" width="130px"
                                            VisibleIndex="19">
                                            <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            
<Style HorizontalAlign="Right"></Style>

</PropertiesTextEdit>
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Central Tax Amount" FieldName="CGST Amount" width="140px"
                                            VisibleIndex="20">
                                            <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            
<Style HorizontalAlign="Right"></Style>

</PropertiesTextEdit>
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="State Tax Amount" FieldName="SGST Amount" width="140px"
                                            VisibleIndex="21">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Integrated Tax Amount" FieldName="IGST Amount"  width="140px"
                                            VisibleIndex="22">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                          <dxe:GridViewDataTextColumn Caption="Central REV Tax Rate" FieldName="CGSTRateREV"  width="140px"
                                            VisibleIndex="23">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                         <dxe:GridViewDataTextColumn Caption="State REV Tax Rate" FieldName="SGSTRateREV"  width="140px"
                                            VisibleIndex="24">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Integrated REV Tax Rate" FieldName="IGSTRateREV"  width="140px"
                                            VisibleIndex="25">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                          <dxe:GridViewDataTextColumn Caption="Central REV Tax Amount" FieldName="Total_CGSTREV"  width="140px"
                                            VisibleIndex="26">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                          <dxe:GridViewDataTextColumn Caption="State REV Tax Amount" FieldName="Total_SGSTREV"  width="140px"
                                            VisibleIndex="27">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                         <dxe:GridViewDataTextColumn Caption="Integrated REV Tax Amount" FieldName="Total_IGSTREV"  width="160px"
                                            VisibleIndex="28">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="ITC Eligible?" FieldName="ITC"
                                            VisibleIndex="29">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="RCM" FieldName="Reverse Charge"
                                            VisibleIndex="30">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataTextColumn>
                                    </Columns>

                                  <%--  <SettingsPager PageSize="10">
                                        <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,20,50,100,150,200" />
                                    </SettingsPager>

<SettingsBehavior ColumnResizeMode="Control" AllowFocusedRow="True" AllowSelectByRowClick="True"></SettingsBehavior>

<SettingsCookies Enabled="True"></SettingsCookies>

                                    <SettingsSearchPanel Visible="false" />
                                    <Settings ShowGroupPanel="True" ShowFooter="true" ShowGroupFooter="VisibleIfExpanded" ShowStatusBar="Hidden" ShowHorizontalScrollBar="true" ShowFilterRow="true" ShowFilterRowMenu="false" />
                                    <SettingsLoadingPanel Text="Please Wait..." />
                                    <SettingsBehavior AutoExpandAllGroups="true" />--%>

                      
                                     <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" ColumnResizeMode="Control" />
                                     <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
                                     <SettingsEditing Mode="EditForm" />
                                     <SettingsContextMenu Enabled="true" />
                                     <SettingsBehavior AutoExpandAllGroups="true" />
                                     <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                     <SettingsSearchPanel Visible="false" />
                                    <SettingsLoadingPanel Text="Please Wait..." />
                                     <SettingsPager PageSize="10">
                                       <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                     </SettingsPager>

                                    <TotalSummary>
                                       <%-- <dxe:ASPxSummaryItem FieldName="Document No" SummaryType="Custom" />--%>
                                        <dxe:ASPxSummaryItem FieldName="Invoice_Value" SummaryType="Sum" />
                                        <dxe:ASPxSummaryItem FieldName="Taxable Amount" SummaryType="Sum" />
                                       <%-- <dxe:ASPxSummaryItem FieldName="CGST Rate" SummaryType="Sum" />--%>
                                        <dxe:ASPxSummaryItem FieldName="CGST Amount" SummaryType="Sum" />
                                       <%-- <dxe:ASPxSummaryItem FieldName="SGST Rate" SummaryType="Sum" />--%>
                                        <dxe:ASPxSummaryItem FieldName="SGST Amount" SummaryType="Sum" />
                                        <%--<dxe:ASPxSummaryItem FieldName="IGST Rate" SummaryType="Sum" />--%>
                                        <dxe:ASPxSummaryItem FieldName="IGST Amount" SummaryType="Sum" />
                                      <%--  <dxe:ASPxSummaryItem FieldName="CGSTRateREV" SummaryType="Sum" />--%>
                                        <dxe:ASPxSummaryItem FieldName="Total_CGSTREV" SummaryType="Sum" />
                                       <%-- <dxe:ASPxSummaryItem FieldName="SGSTRateREV" SummaryType="Sum" />--%>
                                        <dxe:ASPxSummaryItem FieldName="Total_SGSTREV" SummaryType="Sum" />
                                     <%--   <dxe:ASPxSummaryItem FieldName="IGSTRateREV" SummaryType="Sum" />--%>
                                        <dxe:ASPxSummaryItem FieldName="Total_IGSTREV" SummaryType="Sum" />
                                    </TotalSummary>


                                </dxe:ASPxGridView>
                                <asp:HiddenField ID="hiddenedit" runat="server" />
                            </div>
                            <div style="display: none"> 

                      
                            </div>


    </div>

      <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="true" PaperKind="A3" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>
     <asp:SqlDataSource ID="CustomerDataSource" runat="server"  ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"/>
     <asp:HiddenField ID="DeleteCustomer" runat="server"></asp:HiddenField>

</asp:Content>
