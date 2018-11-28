﻿<%@ Page Title="Proforma Invoice/ Quotation" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true"
    CodeBehind="SalesQuotationList.aspx.cs" Inherits="ERP.OMS.Management.Activities.frm_SalesQuotationMain" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        //function onPrintJv(id) {
        //    debugger;
        //    window.location.href = "../../reports/XtraReports/QuotationReportViewer.aspx?id=" + id;
        //}

        function OpenPopUPUserWiseQuotaion() {
            cgridUserWiseQuotation.PerformCallback();
            cPopupUserWiseQuotation.Show();
        }
        document.onkeydown = function (e) {
            if (event.keyCode == 18) isCtrl = true;
            if (event.keyCode == 65 && isCtrl == true) { //run code for Ctrl+S -- ie, Save & New  
                StopDefaultAction(e);
                OnAddButtonClick();
            }
        }

        function StopDefaultAction(e) {
            if (e.preventDefault) { e.preventDefault() }
            else { e.stop() };

            e.returnValue = false;
            e.stopPropagation();
        }



        function OnClickDelete(keyValue) {
            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    cGrdQuotation.PerformCallback('Delete~' + keyValue);
                }
            });
        }
        function OnClickStatus(keyValue) {
            GetObjectID('hiddenedit').value = keyValue;
            cGrdQuotation.PerformCallback('Edit~' + keyValue);
        }

        function OpenPopUPApprovalStatus() {
            cgridPendingApproval.PerformCallback();
            cpopupApproval.Show();
        }

        var PIQAId = 0;
        function onPrintJv(id) {
            debugger;
            PIQAId = id;
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

        function cSelectPanelEndCall(s, e) {
            debugger;
            if (cSelectPanel.cpSuccess != "") {
                var TotDocument = cSelectPanel.cpSuccess.split(',');
                var reportName = cCmbDesignName.GetValue();
                var module = 'PIQuotation';
                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=' + module + '&id=' + PIQAId, '_blank')
            }
            //cSelectPanel.cpSuccess = null
            if (cSelectPanel.cpSuccess == "") {
                cCmbDesignName.SetSelectedIndex(0);
            }
        }

        //var globalRowIndex;
        //function GetVisibleIndex(s, e) {
        //    globalRowIndex = e.visibleIndex;
        //}
        //RowClick = "GetVisibleIndex"

        //function Approvalgrid_EndCallBack() {
        //    if (cgridPendingApproval.cpEdit != null) {
        //        cpopupApproval.Show(); 
        //    }
        //}

        function grid_EndCallBack() {
            if (cGrdQuotation.cpEdit != null) {
                GetObjectID('hiddenedit').value = cGrdQuotation.cpEdit.split('~')[0];
                cProforma.SetText(cGrdQuotation.cpEdit.split('~')[1]);
                cCustomer.SetText(cGrdQuotation.cpEdit.split('~')[4]);
                var pro_status = cGrdQuotation.cpEdit.split('~')[2]
                //cGrdQuotation.cpEdit = null;
                if (pro_status != null) {
                    var radio = $("[id*=rbl_QuoteStatus] label:contains('" + pro_status + "')").closest("td").find("input");
                    radio.attr("checked", "checked");
                    //return false;
                    //$('#rbl_QuoteStatus[type=radio][value=' + pro_status + ']').prop('checked', true); 
                    cQuotationRemarks.SetText(cGrdQuotation.cpEdit.split('~')[3]);

                    cQuotationStatus.Show();
                }
            }
            if (cGrdQuotation.cpUpdate != null) {
                GetObjectID('hiddenedit').value = '';
                cProforma.SetText('');
                cCustomer.SetText('');
                cQuotationRemarks.SetText('');
                var pro_status = 2;
                if (pro_status != null) {
                    var radio = $("[id*=rbl_QuoteStatus] label:contains('" + pro_status + "')").closest("td").find("input");
                    radio.attr("checked", "checked");
                    cQuotationStatus.Hide();
                }
                jAlert(cGrdQuotation.cpUpdate);
                cGrdQuotation.Refresh();
            }
            if (cGrdQuotation.cpDelete != null) {
                jAlert(cGrdQuotation.cpDelete);
                cGrdQuotation.cpDelete = null;
                cGrdQuotation.Refresh();
            }


        }
        function SavePrpformaStatus() {
            if (document.getElementById('hiddenedit').value == '') {
                cGrdQuotation.PerformCallback('save~');
            }
            else {
                var checked_radio = $("[id*=rbl_QuoteStatus] input:checked");
                var status = checked_radio.val();
                var remarks = cQuotationRemarks.GetText();
                cGrdQuotation.PerformCallback('update~' + GetObjectID('hiddenedit').value + '~' + status + '~' + remarks);
            }

        }

        function OnMoreInfoClick(keyValue) {
            var ActiveUser = '<%=Session["userid"]%>'
            if (ActiveUser != null) {
                $.ajax({
                    type: "POST",
                    url: "SalesQuotationList.aspx/GetEditablePermission",
                    data: "{'ActiveUser':'" + ActiveUser + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var status = msg.d;
                        var url = 'SalesQuotation.aspx?key=' + keyValue + '&Permission=' + status + '&type=QO';
                        window.location.href = url;
                    }
                });
            }
        }

        ////##### coded by Samrat Roy - 04/05/2017  
        ////Add an another param to define request type 
        function OnViewClick(keyValue) {
            var url = 'SalesQuotation.aspx?key=' + keyValue + '&req=V' + '&type=QO';
            window.location.href = url;
        }

        function OnclickViewAttachment(obj) {
            //var URL = '/OMS/Management/Activities/Quotation_Document.aspx?idbldng=' + obj + '&type=Quotation';
            var URL = '/OMS/Management/Activities/EntriesDocuments.aspx?idbldng=' + obj + '&type=Quotation';
            window.location.href = URL;
        }

        function OnAddButtonClick() {
            var url = 'SalesQuotation.aspx?key=' + 'ADD';
            window.location.href = url;
        }
        var keyval;
        //function FocusedRowChanged(s, e) {
        //    keyval=s.GetRowKey(s.GetFocusedRowIndex());
        //}

        //var globalRowIndex;

        //function GetVisibleIndex(s, e) {
        //    globalRowIndex = e.visibleIndex;
        //}
        //RowClick = "GetVisibleIndex"

        // User Approval Status Start

        function GetApprovedQuoteId(s, e, itemIndex) {
            var rowvalue = cgridPendingApproval.GetRowValues(itemIndex, 'Quote_Id', OnGetApprovedRowValues);
            //var currentRow = cgridPendingApproval.GetRow(0);
            //var col1 = currentRow.find("td:eq(0)").html();

            cgridPendingApproval.PerformCallback('Status~' + rowvalue);
            cgridPendingApproval.GetRowValues(itemIndex, 'Quote_Id', OnGetApprovedRowValues);

        }
        function OnGetApprovedRowValues(obj) {
            uri = "SalesQuotation.aspx?key=" + obj + "&status=2" + '&type=QO';
            popup.SetContentUrl(uri);
            popup.Show();
            //window.location.href = uri;

        }

        function ch_fnApproved() {
        }


        function GetRejectedQuoteId(s, e, itemIndex) {
            debugger;
            cgridPendingApproval.GetRowValues(itemIndex, 'Quote_Id', OnGetRejectedRowValues);

        }
        function OnGetRejectedRowValues(obj) {
            uri = "SalesQuotation.aspx?key=" + obj + "&status=3" + '&type=QO';
            popup.SetContentUrl(uri);
            popup.Show();
        }

        // User Approval Status End

        function OnApprovalEndCall(s, e) {
            $.ajax({
                type: "POST",
                url: "SalesQuotationList.aspx/GetPendingCase",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    $('#<%= lblWaiting.ClientID %>').text(data.d);
                }
            });
            }
    </script>
    <style>
        strong label {
            font-weight: bold !important;
        }

        input[type="radio"] {
            webkit-transform: translateY(3px);
            -moz-transform: translateY(3px);
            transform: translateY(3px);
        }
    </style>
    <style>
        .smllpad > tbody > tr > td {
            padding-right: 25px;
        }

        .errorField {
            position: absolute;
            right: 5px;
            top: 9px;
        }

        .padTab {
            margin-bottom: 4px;
        }

            .padTab > tbody > tr > td {
                padding-right: 15px;
                vertical-align: middle;
            }

                .padTab > tbody > tr > td > label, .padTab > tbody > tr > td > input[type="button"] {
                    margin-bottom: 0 !important;
                }

        .backBranch {
            font-weight: 600;
            background: #75c1f5;
            padding: 5px;
        }
    </style>
    <script>
        var isFirstTime = true;

        function AllControlInitilize() {
            if (isFirstTime) {
                if (localStorage.getItem('QuotationList_FromDate')) {
                    var fromdatearray = localStorage.getItem('QuotationList_FromDate').split('-');
                    var fromdate = new Date(fromdatearray[0], parseFloat(fromdatearray[1]) - 1, fromdatearray[2], 0, 0, 0, 0);
                    cFormDate.SetDate(fromdate);
                }

                if (localStorage.getItem('QuotationList_ToDate')) {
                    var todatearray = localStorage.getItem('QuotationList_ToDate').split('-');
                    var todate = new Date(todatearray[0], parseFloat(todatearray[1]) - 1, todatearray[2], 0, 0, 0, 0);
                    ctoDate.SetDate(todate);
                }

                if (localStorage.getItem('QuotationList_Branch')) {
                    if (ccmbBranchfilter.FindItemByValue(localStorage.getItem('QuotationList_Branch'))) {
                        ccmbBranchfilter.SetValue(localStorage.getItem('QuotationList_Branch'));
                    }

                }

                //updateGridByDate();
                isFirstTime = false;
            }
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
                localStorage.setItem("QuotationList_FromDate", cFormDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("QuotationList_ToDate", ctoDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("QuotationList_Branch", ccmbBranchfilter.GetValue());

                $("#hfFromDate").val(cFormDate.GetDate().format('yyyy-MM-dd'));
                $("#hfToDate").val(ctoDate.GetDate().format('yyyy-MM-dd'));
                $("#hfBranchID").val(ccmbBranchfilter.GetValue());
                $("#hfIsFilter").val("Y");

                cGrdQuotation.Refresh();

                //cGrdQuotation.PerformCallback('FilterGridByDate~' + cFormDate.GetDate().format('yyyy-MM-dd') + '~' + ctoDate.GetDate().format('yyyy-MM-dd') + '~' + ccmbBranchfilter.GetValue())
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%--<dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
           <ClientSideEvents ControlsInitialized="AllControlInitilize" />
        </dxe:ASPxGlobalEvents>--%>
    <div class="panel-heading clearfix">
        <div class="panel-title pull-left">
            <h3>Proforma Invoice/ Quotation</h3>
        </div>
        <table class="padTab pull-right" style="margin-top: 7px;">
            <tr>
                <td>
                    <label>From </label>
                </td>
                <td style="width: 150px">
                    <dxe:ASPxDateEdit ID="FormDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cFormDate" Width="100%">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>
                    </dxe:ASPxDateEdit>
                </td>
                <td>
                    <label>To </label>
                </td>
                <td style="width: 150px">
                    <dxe:ASPxDateEdit ID="toDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="ctoDate" Width="100%">
                        <ButtonStyle Width="13px">
                        </ButtonStyle>
                    </dxe:ASPxDateEdit>
                </td>
                <td>Branch</td>
                <td>
                    <dxe:ASPxComboBox ID="cmbBranchfilter" runat="server" ClientInstanceName="ccmbBranchfilter" Width="100%">
                    </dxe:ASPxComboBox>
                </td>
                <td>
                    <input type="button" value="Show" class="btn btn-primary" onclick="updateGridByDate()" />
                </td>
            </tr>
        </table>
    </div>
    <div class="form_main">
        <div class="clearfix">
            <% if (rights.CanAdd)
               { %>
            <a href="javascript:void(0);" onclick="OnAddButtonClick()" class="btn btn-primary"><span><u>A</u>dd New</span> </a><%} %>

            <%--<dxe:ASPxButton ID="btn_Approval" runat="server" class="btn btn-primary" Text="Pending Approval" ClientInstanceName="cbtn_Approval">
                <ClientSideEvents Click="function (s, e) {OpenPopUPApprovalStatus();}" />
            </dxe:ASPxButton>--%>
            <% if (rights.CanExport)
               { %>
            <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true" OnChange="if(!AvailableExportOption()){return false;}">
                <asp:ListItem Value="0">Export to</asp:ListItem>
                <asp:ListItem Value="1">PDF</asp:ListItem>
                <asp:ListItem Value="2">XLS</asp:ListItem>
                <asp:ListItem Value="3">RTF</asp:ListItem>
                <asp:ListItem Value="4">CSV</asp:ListItem>
            </asp:DropDownList>
            <% } %>
            <span id="spanStatus" runat="server">
                <a href="javascript:void(0);" onclick="OpenPopUPUserWiseQuotaion()" class="btn btn-primary">
                    <span>My Quotation Status</span>
                    <%--<asp:Label ID="Label1" runat="server" Text=""></asp:Label>--%>                   
                </a>
            </span>
            <span id="divPendingWaiting" runat="server">
                <a href="javascript:void(0);" onclick="OpenPopUPApprovalStatus()" class="btn btn-primary">
                    <span>Approval Waiting</span>
                    <asp:Label ID="lblWaiting" runat="server" Text=""></asp:Label>
                </a>
                <i class="fa fa-reply blink" style="font-size: 20px; margin-right: 10px;" aria-hidden="true"></i>
            </span>
        </div>
    </div>
    <div class="GridViewArea">
        <dxe:ASPxGridView ID="GrdQuotation" runat="server" KeyFieldName="Quote_Id" AutoGenerateColumns="False" SettingsBehavior-AllowFocusedRow="true"
            Width="100%" ClientInstanceName="cGrdQuotation" OnCustomCallback="GrdQuotation_CustomCallback" DataSourceID="EntityServerModeDataSource">
            <Columns>
                <dxe:GridViewDataTextColumn FieldName="Quote_Id" Visible="false" SortOrder="Descending">
                    <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn Caption="Document No." FieldName="QuotationNo"
                    VisibleIndex="0" FixedStyle="Left" Width="150px">
                    <CellStyle CssClass="gridcellleft" Wrap="true">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" />
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn Caption="Date" FieldName="Quote_Date"
                    VisibleIndex="1" FixedStyle="Left" Width="100px">
                    <CellStyle CssClass="gridcellleft" Wrap="true">
                    </CellStyle>
                    <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy"></PropertiesTextEdit>
                    <Settings AutoFilterCondition="Contains" />
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn Caption="Customer" FieldName="CustomerName"
                    VisibleIndex="2" FixedStyle="Left">
                    <CellStyle CssClass="gridcellleft" Wrap="true">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" />
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn Caption="Amount" FieldName="Amount"
                    VisibleIndex="3" FixedStyle="Left" Width="150px">
                    <CellStyle CssClass="gridcellleft" Wrap="true">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" />
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn Caption="Expiry Date" FieldName="Quote_Expiry"
                    VisibleIndex="4" FixedStyle="Left" Width="100px">
                    <CellStyle CssClass="gridcellleft" Wrap="true">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" />
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn Caption="Customer Acceptance Status" FieldName="Status"
                    VisibleIndex="5" FixedStyle="Left" Width="150px">
                    <CellStyle CssClass="gridcellleft" Wrap="true">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" />
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="center" VisibleIndex="17" Width="15%">
                    <DataItemTemplate>
                        <% if (rights.CanView)
                           { %>
                        <a href="javascript:void(0);" onclick="OnViewClick('<%# Container.KeyValue %>')" class="pad" title="View">
                            <img src="../../../assests/images/doc.png" /></a>
                        <% } %>
                        <% if (rights.CanEdit)
                           { %>
                        <a href="javascript:void(0);" onclick="OnMoreInfoClick('<%# Container.KeyValue %>')" class="pad" title="Edit">
                            <img src="../../../assests/images/info.png" /></a><%} %>
                        <% if (rights.CanDelete)
                           { %>
                        <a href="javascript:void(0);" onclick="OnClickDelete('<%# Container.KeyValue %>')" class="pad" title="Delete">
                            <img src="../../../assests/images/Delete.png" /></a><%} %>
                        <%-- <a href="javascript:void(0);" onclick="OnClickCopy('<%# Container.KeyValue %>')" class="pad" title="Copy ">
                            <i class="fa fa-copy"></i></a>--%>
                        <% if (rights.CanEdit)
                           { %>
                        <a href="javascript:void(0);" onclick="OnClickStatus('<%# Container.KeyValue %>')" class="pad" title="Status">
                            <img src="../../../assests/images/verified.png" /></a><%} %>
                        <% if (rights.CanView)
                           { %>
                        <a href="javascript:void(0);" onclick="OnclickViewAttachment('<%# Container.KeyValue %>')" class="pad" title="View Attachment">
                            <img src="../../../assests/images/attachment.png" />
                        </a><%} %>
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
            <ClientSideEvents EndCallback="function (s, e) {grid_EndCallBack();}" />
            <SettingsPager NumericButtonCount="10" PageSize="10" ShowSeparators="True" Mode="ShowPager">
                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                <FirstPageButton Visible="True">
                </FirstPageButton>
                <LastPageButton Visible="True">
                </LastPageButton>
            </SettingsPager>
            <SettingsSearchPanel Visible="false" />
            <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
            <SettingsLoadingPanel Text="Please Wait..." />
        </dxe:ASPxGridView>
        <dx:LinqServerModeDataSource ID="EntityServerModeDataSource" runat="server" OnSelecting="EntityServerModeDataSource_Selecting"
            ContextTypeName="ERPDataClassesDataContext" TableName="v_PurchaseChallanList" />
        <asp:HiddenField ID="hiddenedit" runat="server" />
    </div>
    <div style="display: none">
        <dxe:ASPxGridViewExporter ID="exporter" GridViewID="GrdQuotation" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
    </div>
    <div class="PopUpArea">
        <%--Client Wise Quotation Status Section Start--%>

        <dxe:ASPxPopupControl ID="Popup_QuotationStatus" runat="server" ClientInstanceName="cQuotationStatus"
            Width="500px" HeaderText="Approvers Configuration" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <%--<div style="Width:400px;background-color:#FFFFFF;margin:0px;border:1px solid red;">--%>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="col-md-12">
                                <table width="">
                                    <tr>
                                        <td style="padding-right: 8px; vertical-align: top">
                                            <strong>
                                                <label style="margin-bottom: 5px">Proforma:-</label></strong>
                                        </td>
                                        <td style="padding-top: 0; vertical-align: top; padding-right: 35px">
                                            <%--<dxe:ASPxTextBox ID="txt_Proforma" MaxLength="80" ClientInstanceName="cProforma" TabIndex="1" 
                                                runat="server" Width="100%"> 
                                            </dxe:ASPxTextBox>--%>
                                            <strong>
                                                <dxe:ASPxLabel ID="lbl_Proforma" runat="server" ClientInstanceName="cProforma" Text="ASPxLabel"></dxe:ASPxLabel>
                                            </strong>
                                        </td>
                                        <td style="padding-right: 8px; padding-left: 8px; vertical-align: top">
                                            <strong>
                                                <label style="margin-bottom: 5px">Customer:-</label></strong>
                                        </td>
                                        <td style="padding-top: 0; vertical-align: top">
                                            <%-- <dxe:ASPxTextBox ID="txt_Customer" ClientInstanceName="cCustomer"  runat="server" MaxLength="100" TabIndex="2"
                                            Width="100%"> 
                                        </dxe:ASPxTextBox>--%>
                                            <strong>
                                                <dxe:ASPxLabel ID="lbl_Customer" runat="server" ClientInstanceName="cCustomer" Text="ASPxLabel"></dxe:ASPxLabel>
                                            </strong>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                            </div>
                            <div class="col-md-6">
                            </div>
                            <div class="clear"></div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <table>
                            <tr>
                                <td style="width: 70px; padding: 13px 0;"><strong>Status </strong></td>
                                <td>
                                    <asp:RadioButtonList ID="rbl_QuoteStatus" runat="server" Width="172px" CssClass="mTop5" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Accepted" Value="2" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Declined" Value="3"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="clear"></div>
                    <div class="col-md-12">
                        <div class="" style="margin-bottom: 5px;">
                            <strong>Reason </strong>
                        </div>
                        <div>
                            <dxe:ASPxMemo ID="txt_QuotationRemarks" runat="server" ClientInstanceName="cQuotationRemarks" Height="71px" Width="100%"></dxe:ASPxMemo>
                        </div>
                    </div>
                    <div class="col-md-12" style="padding-top: 10px;">
                        <dxe:ASPxButton ID="btn_PrpformaStatus" CausesValidation="true" ClientInstanceName="cbtn_PrpformaStatus" runat="server"
                            AutoPostBack="False" Text="Save" CssClass="btn btn-primary">
                            <ClientSideEvents Click="function (s, e) {SavePrpformaStatus();}" />
                        </dxe:ASPxButton>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
        </dxe:ASPxPopupControl>

        <%--Client Wise Quotation Status Section END--%>

        <%-- Sandip Approval Dtl Section Start--%>


        <dxe:ASPxPopupControl ID="popupApproval" runat="server" ClientInstanceName="cpopupApproval"
            Width="900px" HeaderText="Pending Approvals" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <%--<div style="Width:400px;background-color:#FFFFFF;margin:0px;border:1px solid red;">--%>
                    <div class="row">
                        <div class="col-md-12">
                            <dxe:ASPxGridView ID="gridPendingApproval" runat="server" KeyFieldName="Quote_Id" AutoGenerateColumns="False" OnPageIndexChanged="gridPendingApproval_PageIndexChanged"
                                Width="100%" ClientInstanceName="cgridPendingApproval" OnCustomCallback="gridPendingApproval_CustomCallback">
                                <Columns>
                                    <dxe:GridViewDataTextColumn Caption="Proforma/Quotation No." FieldName="Quote_Number"
                                        VisibleIndex="0" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Created On" FieldName="Quote_Date"
                                        VisibleIndex="1" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Branch" FieldName="branch_description"
                                        VisibleIndex="2" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn Caption="Entered By" FieldName="craetedby"
                                        VisibleIndex="3" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                    <dxe:GridViewDataCheckColumn UnboundType="Boolean" Caption="Approved">
                                        <DataItemTemplate>
                                            <dxe:ASPxCheckBox ID="chkapprove" runat="server" AllowGrayed="false" OnInit="chkapprove_Init" ValueType="System.Boolean" ValueChecked="true" ValueUnchecked="false">
                                                <%-- <ClientSideEvents CheckedChanged="function (s, e) {ch_fnApproved();}" />--%>
                                            </dxe:ASPxCheckBox>
                                        </DataItemTemplate>
                                        <Settings ShowFilterRowMenu="False" AllowFilterBySearchPanel="False" AllowAutoFilter="False" />
                                    </dxe:GridViewDataCheckColumn>

                                    <dxe:GridViewDataCheckColumn UnboundType="Boolean" Caption="Rejected">
                                        <DataItemTemplate>
                                            <dxe:ASPxCheckBox ID="chkreject" runat="server" AllowGrayed="false" OnInit="chkreject_Init" ValueType="System.Boolean" ValueChecked="true" ValueUnchecked="false">
                                                <%-- <ClientSideEvents CheckedChanged="function (s, e) {ch_fnApproved();}" />--%>
                                            </dxe:ASPxCheckBox>
                                        </DataItemTemplate>
                                        <Settings ShowFilterRowMenu="False" AllowFilterBySearchPanel="False" AllowAutoFilter="False" />
                                    </dxe:GridViewDataCheckColumn>
                                </Columns>
                                <SettingsBehavior AllowFocusedRow="true" />
                                <SettingsPager NumericButtonCount="20" PageSize="10" ShowSeparators="True">
                                    <FirstPageButton Visible="True">
                                    </FirstPageButton>
                                    <LastPageButton Visible="True">
                                    </LastPageButton>
                                </SettingsPager>
                                <SettingsEditing Mode="Inline">
                                </SettingsEditing>
                                <SettingsSearchPanel Visible="True" />
                                <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                <SettingsLoadingPanel Text="Please Wait..." />
                                <ClientSideEvents EndCallback="OnApprovalEndCall" />
                            </dxe:ASPxGridView>
                        </div>
                        <div class="clear"></div>


                        <%--<div class="col-md-12" style="padding-top: 10px;">
                            <dxe:ASPxButton ID="ASPxButton1" CausesValidation="true" ClientInstanceName="cbtn_PrpformaStatus" runat="server"
                                AutoPostBack="False" Text="Save" CssClass="btn btn-primary">
                                <ClientSideEvents Click="function (s, e) {SaveApprovalStatus();}" />
                            </dxe:ASPxButton>
                        </div>--%>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
        </dxe:ASPxPopupControl>

        <dxe:ASPxPopupControl ID="ASPXPopupControl" runat="server"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popup" Height="630px"
            Width="1200px" HeaderText="Quotation Approval" Modal="true" AllowResize="true" ResizingMode="Postponed">
            <HeaderTemplate>
                <span>User Approval</span>
            </HeaderTemplate>
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                </dxe:PopupControlContentControl>
            </ContentCollection>
        </dxe:ASPxPopupControl>
        <dxe:ASPxPopupControl ID="PopupUserWiseQuotation" runat="server" ClientInstanceName="cPopupUserWiseQuotation"
            Width="900px" HeaderText="User Wise Quotation Status" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <div class="row">
                        <div class="col-md-12">
                            <dxe:ASPxGridView ID="gridUserWiseQuotation" runat="server" KeyFieldName="Quote_Id" AutoGenerateColumns="False"
                                Width="100%" ClientInstanceName="cgridUserWiseQuotation" OnCustomCallback="gridUserWiseQuotation_CustomCallback">
                                <Columns>
                                    <dxe:GridViewDataTextColumn Caption="Proforma/Quotation No." FieldName="Quote_Number"
                                        VisibleIndex="0" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                    <dxe:GridViewDataTextColumn Caption="Entered On" FieldName="createddate"
                                        VisibleIndex="1" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                    <dxe:GridViewDataTextColumn Caption="Approval User" FieldName="approvedby"
                                        VisibleIndex="2" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                    <dxe:GridViewDataTextColumn Caption="User Level" FieldName="UserLevel"
                                        VisibleIndex="3" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                    <dxe:GridViewDataTextColumn Caption="Status" FieldName="status"
                                        VisibleIndex="4" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                    <dxe:GridViewDataTextColumn Caption="Approved On" FieldName="ApprovedOn"
                                        VisibleIndex="5" FixedStyle="Left">
                                        <CellStyle CssClass="gridcellleft" Wrap="true">
                                        </CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                </Columns>
                                <SettingsBehavior AllowFocusedRow="true" />
                                <SettingsPager NumericButtonCount="20" PageSize="10" ShowSeparators="True">
                                    <FirstPageButton Visible="True">
                                    </FirstPageButton>
                                    <LastPageButton Visible="True">
                                    </LastPageButton>
                                </SettingsPager>
                                <SettingsEditing Mode="Inline">
                                </SettingsEditing>
                                <SettingsSearchPanel Visible="True" />
                                <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                <SettingsLoadingPanel Text="Please Wait..." />

                            </dxe:ASPxGridView>
                        </div>
                        <div class="clear"></div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
        </dxe:ASPxPopupControl>

        <%-- Sandip Approval Dtl Section End--%>
    </div>
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

    <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
        <ClientSideEvents ControlsInitialized="AllControlInitilize" />
    </dxe:ASPxGlobalEvents>

    <div>
        <asp:HiddenField ID="hfIsFilter" runat="server" />
        <asp:HiddenField ID="hfFromDate" runat="server" />
        <asp:HiddenField ID="hfToDate" runat="server" />
        <asp:HiddenField ID="hfBranchID" runat="server" />
    </div>
</asp:Content>
