﻿<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="CustomerReceiptPaymentList.aspx.cs" Inherits="ERP.OMS.Management.Activities.CustomerReceiptPaymentList" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
     Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">


        document.onkeydown = function (e) {          
            if ((event.keyCode == 120 || event.keyCode == 65) && event.altKey == true) { //run code for alt+A -- ie, Save & New  
                StopDefaultAction(e);
                AddButtonClick();
            }
        }

        function AllControlInitilize() {
            if (localStorage.getItem('CustomerRecPayFromDate')) {
                var fromdatearray = localStorage.getItem('CustomerRecPayFromDate').split('-');
                var fromdate = new Date(fromdatearray[0], parseFloat(fromdatearray[1]) - 1, fromdatearray[2], 0, 0, 0, 0);
                cFormDate.SetDate(fromdate);
            }

            if (localStorage.getItem('CustomerRecPayToDate')) {
                var todatearray = localStorage.getItem('CustomerRecPayToDate').split('-');
                var todate = new Date(todatearray[0], parseFloat(todatearray[1]) - 1, todatearray[2], 0, 0, 0, 0);
                ctoDate.SetDate(todate);
            }
            if (localStorage.getItem('CustomerRecPayBranch')) {
                if (ccmbBranchfilter.FindItemByValue(localStorage.getItem('CustomerRecPayBranch'))) {
                    ccmbBranchfilter.SetValue(localStorage.getItem('CustomerRecPayBranch'));
                }

            }
            // updateGridByDate();
        }
        function updateGridByDate() {
            if (cFormDate.GetDate() == null) {
                jAlert('Please select from date.', 'Alert', function () { cFormDate.Focus(); });
            }
            else if (ctoDate.GetDate() == null) {
                jAlert('Please select to date.', 'Alert', function () { ctoDate.Focus(); });
            }
            else if (ccmbBranchfilter.GetValue() == null) {
                jAlert('Please select Branch.', 'Alert', function () { ccmbBranchfilter.Focus(); });
            }
            else {
                localStorage.setItem("CustomerRecPayFromDate", cFormDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("CustomerRecPayToDate", ctoDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("CustomerRecPayBranch", ccmbBranchfilter.GetValue());
                $("#hfFromDate").val(cFormDate.GetDate().format('yyyy-MM-dd'));
                $("#hfToDate").val(ctoDate.GetDate().format('yyyy-MM-dd'));
                $("#hfBranchID").val(ccmbBranchfilter.GetValue());
                $("#hfIsFilter").val("Y");
                CgvCustomerReceiptPayment.Refresh();
                
                //CgvCustomerReceiptPayment.Refresh();
                //$("#drdExport").val(0);

                //CgvCustomerReceiptPayment.PerformCallback('FilterGridByDate~' + cFormDate.GetDate().format('yyyy-MM-dd') + '~' + ctoDate.GetDate().format('yyyy-MM-dd') + '~' + ccmbBranchfilter.GetValue())
            }
        }
        function StopDefaultAction(e) {
            if (e.preventDefault) { e.preventDefault() }
            else { e.stop() };

            e.returnValue = false;
            e.stopPropagation();
        }
        function AddButtonClick() {
            var url = 'CustomerReceiptPayment.aspx?key=' + 'ADD';
            window.location.href = url;
        }
        function OnViewClick(keyValue) {
            var url = 'CustomerReceiptPayment.aspx?key=' + keyValue + '&type=CRP' + '&req=V';
            window.location.href = url;
        }
        function OnMoreInfoClick(keyValue) {
            var url = 'CustomerReceiptPayment.aspx?key=' + keyValue + '&type=CRP';
            window.location.href = url;
        }
        function OnClickDelete(keyValue) {
            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    CgvCustomerReceiptPayment.PerformCallback('Delete~' + keyValue);
                }
            });
        }
        function ShowMsgLastCall() {

            if (CgvCustomerReceiptPayment.cpDelete != null) {

                jAlert(CgvCustomerReceiptPayment.cpDelete)
                CgvCustomerReceiptPayment.PerformCallback();
                CgvCustomerReceiptPayment.cpDelete = null
                CgvCustomerReceiptPayment.Refresh();
            }
        }

        var RecPayId = 0;
        function onPrintJv(id) {
            debugger;
            RecPayId = id;
            cSelectPanel.cpSuccess = "";
            cDocumentsPopup.Show();
            cCmbDesignName.SetSelectedIndex(0);
            cSelectPanel.PerformCallback('Bindalldesignes');
            $('#btnOK').focus();
        }

        function PerformCallToGridBind() {
            cSelectPanel.PerformCallback('Bindsingledesign');
            cDocumentsPopup.Hide();
            return false;
        }

        //function cSelectPanelEndCall(s, e) {
        //    debugger;
        //    if (cSelectPanel.cpSuccess != null) {
        //        var TotDocument = cSelectPanel.cpSuccess.split(',');
        //        var reportName = cCmbDesignName.GetValue();
        //        var module = 'CUSTRECPAY';
        //        window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=' + module + '&id=' + RecPayId, '_blank')
        //    }
        //    cSelectPanel.cpSuccess = null
        //    if (cSelectPanel.cpSuccess == null) {
        //        cCmbDesignName.SetSelectedIndex(0);
        //    }
        //}


        function cSelectPanelEndCall(s, e) {
            debugger;
            if (cSelectPanel.cpSuccess != "") {
                var TotDocument = cSelectPanel.cpSuccess.split(',');
                var reportName = cCmbDesignName.GetValue();
                var module = 'CUSTRECPAY';
                if (TotDocument.length > 0) {
                    for (var i = 0; i < TotDocument.length; i++) {
                        if (TotDocument[i] != "") {
                            window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=' + module + '&id=' + RecPayId + '&PrintOption=' + TotDocument[i], '_blank')
                        }
                    }
                }
            }
            if (cSelectPanel.cpSuccess == "") {
                if (cSelectPanel.cpChecked != "") {
                    jAlert('Please check Original For Recipient and proceed.');
                }
                CselectOriginal.SetCheckState('UnChecked');
                CselectDuplicate.SetCheckState('UnChecked');
                CselectTriplicate.SetCheckState('UnChecked');
                cCmbDesignName.SetSelectedIndex(0);
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title" id="td_contact1" runat="server">
            <h3>
                <asp:Label ID="lblHeadTitle" runat="server" Text="Customer Receipt/Payment"></asp:Label>
            </h3>
        </div>
        <table class="padTabtype2 pull-right" id="gridFilter">
            <tr>
                <td>
                    <label>From Date</label></td>
                <td>&nbsp;</td>
                <td>
                    <dxe:ASPxDateEdit ID="FormDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cFormDate" Width="100%">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>
                    </dxe:ASPxDateEdit>
                </td>
                <td>&nbsp;</td>
                <td>
                    <label>To Date</label>
                </td>
                <td>&nbsp;</td>
                <td>
                    <dxe:ASPxDateEdit ID="toDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="ctoDate" Width="100%">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>
                    </dxe:ASPxDateEdit>
                </td>
                <td>&nbsp;</td>
                <td>Branch</td>
                <td>
                    <dxe:ASPxComboBox ID="cmbBranchfilter" runat="server" ClientInstanceName="ccmbBranchfilter" Width="100%">
                    </dxe:ASPxComboBox>
                </td>
                <td>&nbsp;</td>
                <td>
                    <input type="button" value="Show" class="btn btn-primary" onclick="updateGridByDate()" />
                </td>

            </tr>

        </table>
    </div>

    <div class="form_main clearfix" id="btnAddNew">
        <div style="float: left; padding-right: 5px;">
            <% if (rights.CanAdd)
               { %>
            <a href="javascript:void(0);" onclick="AddButtonClick()" class="btn btn-primary"><span><u>A</u>dd New</span> </a>
            <% } %>
            <% if (rights.CanExport)
               { %>
            <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="drdExport_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem Value="0">Export to</asp:ListItem>
                <asp:ListItem Value="1">PDF</asp:ListItem>
                <asp:ListItem Value="2">XLS</asp:ListItem>
                <asp:ListItem Value="3">RTF</asp:ListItem>
                <asp:ListItem Value="4">CSV</asp:ListItem>
            </asp:DropDownList>
            <% } %>
        </div>
    </div>

    <dxe:ASPxGridView ID="Grid_CustomerReceiptPayment" runat="server" AutoGenerateColumns="False" KeyFieldName="ReceiptPayment_ID"
        ClientInstanceName="CgvCustomerReceiptPayment" Width="100%" SettingsBehavior-AllowFocusedRow="true"
        OnCustomCallback="Grid_CustomerReceiptPayment_CustomCallback"  OnDataBinding="Grid_CustomerReceiptPayment_DataBinding"
        
       DataSourceID="EntityServerModeDataSource" OnSummaryDisplayText="Grid_CustomerReceiptPayment_SummaryDisplayText" Settings-HorizontalScrollBarMode="Auto">
       <%-- <SettingsSearchPanel Visible="True" />--%>
        <%--SettingsCookies-Enabled="true" SettingsCookies-StorePaging="true"
        SettingsCookies-StoreFiltering="true" SettingsCookies-StoreGroupingAndSorting="true"--%>
        <ClientSideEvents />
        <Columns>

            <dxe:GridViewDataTextColumn FieldName="ReceiptPayment_ID" Visible="false" SortOrder="Descending">
                <CellStyle Wrap="True" CssClass="gridcellleft"></CellStyle>
            </dxe:GridViewDataTextColumn>

            <dxe:GridViewDataTextColumn VisibleIndex="0" Caption="Serial" FieldName="SrlNo" Width="50px">
                <CellStyle Wrap="True" CssClass="gridcellleft"></CellStyle>
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="1" Caption="Type" FieldName="ReceiptPayment_TransactionType" Width="80px">
                <CellStyle Wrap="True" CssClass="gridcellleft"></CellStyle>
                <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="2" Caption="Date" FieldName="ReceiptPayment_TransactionDt" Width="80px" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy">
                <CellStyle Wrap="True" CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="3" Caption="Voucher Number" FieldName="ReceiptPayment_VoucherNumber" Width="130px">
                <CellStyle Wrap="True" CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <%-- <dxe:GridViewDataTextColumn VisibleIndex="4" Caption="Currency" FieldName="ReceiptPayment_Currency">
                <CellStyle Wrap="False" CssClass="gridcellleft" HorizontalAlign="left"></CellStyle>
            </dxe:GridViewDataTextColumn>--%>
            <dxe:GridViewDataTextColumn VisibleIndex="4" Caption="Doc. Type" FieldName="ReceiptDetail_DocumentTypeID" Width="200px" >
                <CellStyle CssClass="gridcellleft" Wrap="True"> </CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>

            <dxe:GridViewDataTextColumn VisibleIndex="5" Caption="Branch" FieldName="BranchName" Width="200px">
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="6" Caption="Customer(s)" FieldName="Customer" Width="200px">
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>

             <dxe:GridViewDataTextColumn VisibleIndex="6" Caption="Instrument Type" FieldName="InstrumentType" Width="150px">
                <CellStyle CssClass="gridcellleft"></CellStyle>
            </dxe:GridViewDataTextColumn>
             <dxe:GridViewDataTextColumn VisibleIndex="6" Caption="Instrument No" FieldName="InstrumentNumber" Width="150px">
                <CellStyle CssClass="gridcellleft"></CellStyle>
                  <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>

            <dxe:GridViewDataTextColumn VisibleIndex="7" Caption="Tax Amount" FieldName="CRPTax_Amount">
                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="8" Caption="CGST Amount" FieldName="Total_CGST">
                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="9" Caption="SGST Amount" FieldName="Total_SGST">

                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="10" Caption="IGST Amount" FieldName="Total_IGST">
                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="11" Caption="UTGST Amount" FieldName="Total_UTGST">
                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="12" Caption="Voucher Amount" FieldName="Amount">
                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="13" Caption="Cash/Bank" FieldName="CashBankID">
                <CellStyle CssClass="gridcellleft"></CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="14" FieldName="ReceiptPayment_CreateUser"
                Caption="Entered By">
                <CellStyle CssClass="gridcellleft" Wrap="True">
                </CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="15" FieldName="ReceiptPayment_CreateDateTime" PropertiesTextEdit-DisplayFormatString="dd-MM-yyyy"
                Caption="Last Update On">
                <CellStyle CssClass="gridcellleft" Wrap="True">
                </CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>
            <dxe:GridViewDataTextColumn VisibleIndex="16" FieldName="ReceiptPayment_ModifyUser"
                Caption="Updated By">
                <CellStyle CssClass="gridcellleft" Wrap="True">
                </CellStyle>
                 <Settings AutoFilterCondition="Contains" />
            </dxe:GridViewDataTextColumn>

            <dxe:GridViewDataTextColumn HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="center" VisibleIndex="16" Width="180px">
                <DataItemTemplate>
                    <% if (rights.CanView)
                       { %>
                    <a href="javascript:void(0);" onclick="OnViewClick('<%# Container.KeyValue %>')" class="pad" title="View">
                        <img src="../../../assests/images/viewIcon.png" /></a>
                    <% } %>
                    <% if (rights.CanEdit)
                       { %>
                    <a href="javascript:void(0);" onclick="OnMoreInfoClick('<%# Container.KeyValue %>')" class="pad" title="Edit">
                        <img src="../../../assests/images/info.png" /></a>
                    <% } %>
                    <% if (rights.CanDelete)
                       { %>
                    <a href="javascript:void(0);" onclick="OnClickDelete('<%# Container.KeyValue %>')" class="pad" title="Delete">
                        <img src="../../../assests/images/Delete.png" /></a>
                    <% } %>
                    <% if (rights.CanPrint)
                       { %>
                    <a href="javascript:void(0);" onclick="onPrintJv('<%# Container.KeyValue %>')" class="pad" title="print">
                        <img src="../../../assests/images/Print.png" />
                    </a><%} %>
                </DataItemTemplate>
                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                <CellStyle HorizontalAlign="Center"></CellStyle>
                <HeaderTemplate><span>Actions</span></HeaderTemplate>
                <EditFormSettings Visible="False"></EditFormSettings>
            </dxe:GridViewDataTextColumn>

        </Columns>
        <TotalSummary>
            <dxe:ASPxSummaryItem FieldName="Amount" SummaryType="Sum" />
            <dxe:ASPxSummaryItem FieldName="CRPTax_Amount" SummaryType="Sum" />
            <dxe:ASPxSummaryItem FieldName="Total_CGST" SummaryType="Sum" />
            <dxe:ASPxSummaryItem FieldName="Total_SGST" SummaryType="Sum" />
            <dxe:ASPxSummaryItem FieldName="Total_IGST" SummaryType="Sum" />
            <dxe:ASPxSummaryItem FieldName="Total_UTGST" SummaryType="Sum" />
        </TotalSummary>

        <Settings ShowGroupPanel="True" HorizontalScrollBarMode="Visible" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" ShowFooter="true"
            ShowGroupFooter="VisibleIfExpanded" />
        <ClientSideEvents EndCallback="function(s, e) {
	                                        ShowMsgLastCall();
                                        }" />
        <SettingsBehavior ConfirmDelete="True" />
        <Styles>
            <Header SortingImageSpacing="5px" ImageSpacing="5px"></Header>
            <FocusedRow HorizontalAlign="Left" VerticalAlign="Top" CssClass="gridselectrow"></FocusedRow>
            <LoadingPanel ImageSpacing="10px"></LoadingPanel>
            <FocusedGroupRow CssClass="gridselectrow"></FocusedGroupRow>
            <Footer CssClass="gridfooter"></Footer>
        </Styles>
        <SettingsPager NumericButtonCount="10" PageSize="10" ShowSeparators="True" Mode="ShowPager">
            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
        </SettingsPager>


    </dxe:ASPxGridView>
     <dx:LinqServerModeDataSource ID="EntityServerModeDataSource" runat="server" OnSelecting="EntityServerModeDataSource_Selecting"
            ContextTypeName="ERPDataClassesDataContext"  TableName="v_CustomerReceiptPaymentList" />
    <dxe:ASPxGridViewExporter ID="exporter" runat="server">
    </dxe:ASPxGridViewExporter>
    <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">

        <ClientSideEvents ControlsInitialized="AllControlInitilize" />
    </dxe:ASPxGlobalEvents>
    <%--DEBASHIS--%>
    <div class="PopUpArea">
        <dxe:ASPxPopupControl ID="ASPxDocumentsPopup" runat="server" ClientInstanceName="cDocumentsPopup"
            Width="350px" HeaderText="Select Design(s)" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <dxe:ASPxCallbackPanel runat="server" ID="SelectPanel" ClientInstanceName="cSelectPanel" OnCallback="SelectPanel_Callback" ClientSideEvents-EndCallback="cSelectPanelEndCall">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <dxe:ASPxCheckBox ID="selectOriginal" Text="Original For Recipient" runat="server" ToolTip="Select Original"
                                    ClientInstanceName="CselectOriginal">
                                </dxe:ASPxCheckBox>
                                <dxe:ASPxCheckBox ID="selectDuplicate" Text="Duplicate For Transporter" runat="server" ToolTip="Select Duplicate"
                                    ClientInstanceName="CselectDuplicate">
                                </dxe:ASPxCheckBox>
                                <dxe:ASPxCheckBox ID="selectTriplicate" Text="Triplicate For Supplier" runat="server" ToolTip="Select Triplicate"
                                    ClientInstanceName="CselectTriplicate">
                                </dxe:ASPxCheckBox>
                                <dxe:ASPxComboBox ID="CmbDesignName" ClientInstanceName="cCmbDesignName" runat="server" ValueType="System.String" Width="100%" EnableSynchronization="True">
                                </dxe:ASPxComboBox>
                                <div class="text-center pTop10">
                                    <dxe:ASPxButton ID="btnOK" ClientInstanceName="cbtnOK" runat="server" AutoPostBack="False" Text="OK" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                        <ClientSideEvents Click="function(s, e) {return PerformCallToGridBind();}" />
                                    </dxe:ASPxButton>
                                </div>
                            </dxe:PanelContent>
                        </PanelCollection>
                    </dxe:ASPxCallbackPanel>
                </dxe:PopupControlContentControl>
            </ContentCollection>
        </dxe:ASPxPopupControl>
    </div>
     <div>
        <asp:HiddenField ID="hfIsFilter" runat="server" />
        <asp:HiddenField ID="hfFromDate" runat="server" />
        <asp:HiddenField ID="hfToDate" runat="server" />
        <asp:HiddenField ID="hfBranchID" runat="server" />
    </div>
</asp:Content>
