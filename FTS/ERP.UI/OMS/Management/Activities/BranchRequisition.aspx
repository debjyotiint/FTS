<%@ Page Title="Branch Requisition" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="BranchRequisition.aspx.cs"
    Inherits="ERP.OMS.Management.Activities.BranchRequisition" EnableEventValidation="false" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Code Added By Sandip For Approval Detail Section Start--%>
    <script>
        var isFirstTime = true;
        function AllControlInitilize() {
            ///  document.getElementById('AddButton').style.display = 'inline-block';
            if (isFirstTime) {

                if (localStorage.getItem('BrReqFromDate')) {
                    var fromdatearray = localStorage.getItem('BrReqFromDate').split('-');
                    var fromdate = new Date(fromdatearray[0], parseFloat(fromdatearray[1]) - 1, fromdatearray[2], 0, 0, 0, 0);
                    cFormDate.SetDate(fromdate);
                }

                if (localStorage.getItem('BrReqToDate')) {
                    var todatearray = localStorage.getItem('BrReqToDate').split('-');
                    var todate = new Date(todatearray[0], parseFloat(todatearray[1]) - 1, todatearray[2], 0, 0, 0, 0);
                    ctoDate.SetDate(todate);
                }
                if (localStorage.getItem('BrReqBranch')) {
                    if (ccmbBranchfilter.FindItemByValue(localStorage.getItem('BrReqBranch'))) {
                        ccmbBranchfilter.SetValue(localStorage.getItem('BrReqBranch'));
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

                localStorage.setItem("BrReqFromDate", cFormDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("BrReqToDate", ctoDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("BrReqBranch", ccmbBranchfilter.GetValue());

                //cdownpaygrid.PerformCallback('FilterGridByDate~' + cFormDate.GetDate().format('yyyy-MM-dd') + '~' + ctoDate.GetDate().format('yyyy-MM-dd') + '~' + ccmbBranchfilter.GetValue());

                $("#hfFromDate").val(cFormDate.GetDate().format('yyyy-MM-dd'));
                $("#hfToDate").val(ctoDate.GetDate().format('yyyy-MM-dd'));
                $("#hfBranchID").val(ccmbBranchfilter.GetValue());
                $("#hfIsFilter").val("Y");

                CgvPurchaseIndent.Refresh();

                $("#drdExport").val(0);
            }
        }

        //This function is called to show the Status of All Sales Order Created By Login User Start
        function OpenPopUPUserWiseQuotaion() {
            cgridUserWiseQuotation.PerformCallback();
            cPopupUserWiseQuotation.Show();
        }
        // function above  End

        //This function is called to show all Pending Approval of Sales Order whose Userid has been set LevelWise using Approval Configuration Module 
        function OpenPopUPApprovalStatus() {
            cgridPendingApproval.PerformCallback();
            cpopupApproval.Show();
        }
        // function above  End
        // Status 2 is passed If Approved Check box is checked by User Both Below function is called and used to show in POPUP,  the Add Page of Respective Segment(like Page for Adding Quotation ,Sale Order ,Challan)
        function GetApprovedQuoteId(s, e, itemIndex) {
            var rowvalue = cgridPendingApproval.GetRowValues(itemIndex, 'ID', OnGetApprovedRowValues);
        }
        function OnGetApprovedRowValues(obj) {
            uri = "BranchRequisition.aspx?key=" + obj + "&status=2";
            popup.SetContentUrl(uri);
            popup.Show();
        }
        // function above  End For Approved
        // Status 3 is passed If Approved Check box is checked by User Both Below function is called and used to show in POPUP,  the Add Page of Respective Segment(like Page for Adding Quotation ,Sale Order ,Challan)
        function GetRejectedQuoteId(s, e, itemIndex) {
            cgridPendingApproval.GetRowValues(itemIndex, 'ID', OnGetRejectedRowValues);
        }
        function OnGetRejectedRowValues(obj) {
            uri = "BranchRequisition.aspx?key=" + obj + "&status=3";
            popup.SetContentUrl(uri);
            popup.Show();
        }
        // function above  End For Rejected
        // To Reflect the Data in Pending Waiting Grid and Pending Waiting Counting if the user approve or Rejecte the Order and Saved 

        function OnApprovalEndCall(s, e) {
            $.ajax({
                type: "POST",
                url: "BranchRequisition.aspx/GetPendingCase",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    $('#<%= lblWaiting.ClientID %>').text(data.d);
                }
            });
            }
            // function above  End 
            // To Hide the Popup and Refresh the Data in Pending Waiting Grid 

            $(document).ready(function () {
                $('#ApprovalCross').click(function () {
                    window.parent.popup.Hide();
                    window.parent.cgridPendingApproval.PerformCallback();
                    window.location.href = 'BranchRequisition.aspx'
                })
            });

            // Basic Setting for Approval in Edit Mode this page has the List and Detial Part so to call it
            function StartingSetupForApproval(indentid) {
                $('#<%=hdnEditClick.ClientID %>').val('T'); //Edit
                $('#<%=hdn_Mode.ClientID %>').val('Edit'); //Edit

                $('#<%= lblHeading.ClientID %>').text("Modify Branch Requisition");
                document.getElementById('DivEntry').style.display = 'block';
                document.getElementById('DivEdit').style.display = 'none';
                document.getElementById('btnAddNew').style.display = 'none';

                InsgridBatch.PerformCallback("ApprovalEdit~" + indentid);
                chkAccount = 1;
                document.getElementById('divNumberingScheme').style.display = 'none';
            }

            // function above  End 

    </script>

    <script>
        var IndentId = 0;
        function onPrintJv(id) {

            IndentId = id;
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

            if (cSelectPanel.cpSuccess != null) {
                var reportName = cCmbDesignName.GetValue();
                var module = 'BranchReq';
                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=' + module + '&id=' + IndentId, '_blank')
            }
            cSelectPanel.cpSuccess = null
            if (cSelectPanel.cpSuccess == null) {
                cCmbDesignName.SetSelectedIndex(0);
            }
        }
    </script>

    <%-- Code Added By Sandip For Approval Detail Section End--%>
    <style>
        .BranchTo {
            position: absolute;
            right: -2px;
            top: 29px;
        }

        .brnchreq label {
            font-size: 13px;
            font-weight: 300;
        }

        .voucherno {
            position: absolute;
            right: -3px;
            top: 29px;
        }

        /*.dxgv {
            display: none;
        }*/

        .dxgv.dx-al, .dxgv.dx-ar, .dx-nowrap.dxgv, .gridcellleft.dxgv, .dxgv.dx-ac, .dxgvCommandColumn_PlasticBlue.dxgv.dx-ac {
            display: table-cell !important;
        }

        #gridBatch_DXMainTable tr td:first-child {
            display: table-cell !important;
        }

        .dxgvControl_PlasticBlue td.dxgvBatchEditModifiedCell_PlasticBlue {
            background: #fff !important;
        }

        #gridBatch_DXStatus span > a {
            display: none;
        }

        #gridBatch_DXEditingErrorRow-1 {
            display: none;
        }

        #Grid_PurchaseIndent_DXMainTable .dxgv {
            display: table-cell !important;
        }

        #Grid_PurchaseIndent_DXFilterRow .dxgv {
            display: table-cell !important;
        }

        #gridBatch .dxeButtonEditSys.dxeButtonEdit_PlasticBlue {
            margin-bottom: 0px !important;
            height: 27px;
        }

        .dxeTextBoxSys.dxeTextBox_PlasticBlue {
            height: 25PX;
        }
          .padTabtype2>tbody>tr>td {
            padding-right:15px;
        }
        padTabtype2>tbody>tr>td:last-child {
            padding-right:0px;
        }
    </style>
    <script>
        function CallFeedback_save() {
            var KeyVal = $("#<%=hddnKeyValue.ClientID%>").val();
            var flag = true;
            $("#<%=hddnIsSavedFeedback.ClientID%>").val("1");
            var Remarks = txtFeedback.GetValue();
            if (Remarks == "" || Remarks == null) {
                $('#MandatoryRemarksFeedback').attr('style', 'display:block;position: absolute; right: -20px; top: 8px;');
                flag = false;
            }
            else {
                $('#MandatoryRemarksFeedback').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');
                cPopup_Feedback.Hide();
                CgvPurchaseIndent.PerformCallback("Cancel~" + KeyVal + '~' + Remarks);
            }
            return flag;
        }
        function CancelFeedback_save() {
            $("#<%=hddnIsSavedFeedback.ClientID%>").val("0");
            txtFeedback.SetValue();
            cPopup_Feedback.Hide();
            $('#chkmailfeedback').prop('checked', false);
        }
        //Code for UDF Control 
        function OpenUdf() {
            if (document.getElementById('IsUdfpresent').value == '0') {
                jAlert("UDF not define.");
            }
            else {
                var keyVal = document.getElementById('Keyval_internalId').value;
                var url = '/OMS/management/Master/frm_BranchUdfPopUp.aspx?Type=BI&&KeyVal_InternalID=' + keyVal;
                cUDFpopup.SetContentUrl(url);
                cUDFpopup.Show();
            }
            return true;
        }
        function acbpCrpUdfEndCall(s, e) {
            if (cacbpCrpUdf.cpUDFBI) {
                if (cacbpCrpUdf.cpUDFBI == "true") {
                    InsgridBatch.batchEditApi.EndEdit();
                    InsgridBatch.UpdateEdit();
                    cacbpCrpUdf.cpUDFBI = null;
                }
                else {
                    // jAlert('UDF is set as Mandatory. Please enter values.');
                    jAlert('UDF is set as Mandatory. Please enter values.', 'Alert Dialog: [BranchRequisition]', function (r) {
                        if (r == true) {
                            OpenUdf();
                            InsgridBatch.batchEditApi.StartEdit(-1, 1);
                            InsgridBatch.batchEditApi.StartEdit(0, 2);
                        }
                    });

                    cacbpCrpUdf.cpUDFBI = null;
                }
            }
        }
        // End Udf Code
        function gridFocusedRowChanged(s, e) {
            globalRowIndex = e.visibleIndex;
        }
        var preColumn = '';
        var globalRowIndex;
        var chkAccount = 0;
        var currentval = '';
        function PageLoad() {
            FinYearCheckOnPageLoad();
        }
        function FinYearCheckOnPageLoad() {
            var SelectedDate = new Date(ctDate.GetDate());
            var monthnumber = SelectedDate.getMonth();
            var monthday = SelectedDate.getDate();
            var year = SelectedDate.getYear();

            var SelectedDateValue = new Date(year, monthnumber, monthday);

            var FYS = "<%=Session["FinYearStart"]%>";
            var FYE = "<%=Session["FinYearEnd"]%>";
            var LFY = "<%=Session["LastFinYear"]%>";
            var FinYearStartDate = new Date(FYS);
            var FinYearEndDate = new Date(FYE);
            var LastFinYearDate = new Date(LFY);

            monthnumber = FinYearStartDate.getMonth();
            monthday = FinYearStartDate.getDate();
            year = FinYearStartDate.getYear();
            var FinYearStartDateValue = new Date(year, monthnumber, monthday);


            monthnumber = FinYearEndDate.getMonth();
            monthday = FinYearEndDate.getDate();
            year = FinYearEndDate.getYear();
            var FinYearEndDateValue = new Date(year, monthnumber, monthday);

            var SelectedDateNumericValue = SelectedDateValue.getTime();
            var FinYearStartDateNumericValue = FinYearStartDateValue.getTime();
            var FinYearEndDatNumbericValue = FinYearEndDateValue.getTime();
            if (SelectedDateNumericValue >= FinYearStartDateNumericValue && SelectedDateNumericValue <= FinYearEndDatNumbericValue) {
                //                   alert('Between');
            }
            else {
                if (SelectedDateNumericValue < FinYearStartDateNumericValue) {
                    ctDate.SetDate(new Date(FinYearStartDate));
                }
                if (SelectedDateNumericValue > FinYearEndDatNumbericValue) {
                    ctDate.SetDate(new Date(FinYearEndDate));
                }
            }
        }
        function TDateChange() {
            var SelectedDate = new Date(ctDate.GetDate());
            var monthnumber = SelectedDate.getMonth();
            var monthday = SelectedDate.getDate();
            var year = SelectedDate.getYear();

            var SelectedDateValue = new Date(year, monthnumber, monthday);
            ///Checking of Transaction Date For MaxLockDate
            var MaxLockDate = new Date('<%=Session["LCKBNK"]%>');
            monthnumber = MaxLockDate.getMonth();
            monthday = MaxLockDate.getDate();
            year = MaxLockDate.getYear();
            var MaxLockDateNumeric = new Date(year, monthnumber, monthday).getTime();

            if (SelectedDateValue <= MaxLockDateNumeric) {
                jAlert('This Entry Date has been Locked.');
                MaxLockDate.setDate(MaxLockDate.getDate() + 1);
                ctDate.SetDate(MaxLockDate);
                return;
            }
            ///End Checking of Transaction Date For MaxLockDate

            ///Date Should Between Current Fin Year StartDate and EndDate
            var FYS = "<%=Session["FinYearStart"]%>";
             var FYE = "<%=Session["FinYearEnd"]%>";
            var LFY = "<%=Session["LastFinYear"]%>";
            var FinYearStartDate = new Date(FYS);
            var FinYearEndDate = new Date(FYE);
            var LastFinYearDate = new Date(LFY);

            monthnumber = FinYearStartDate.getMonth();
            monthday = FinYearStartDate.getDate();
            year = FinYearStartDate.getYear();
            var FinYearStartDateValue = new Date(year, monthnumber, monthday);


            monthnumber = FinYearEndDate.getMonth();
            monthday = FinYearEndDate.getDate();
            year = FinYearEndDate.getYear();
            var FinYearEndDateValue = new Date(year, monthnumber, monthday);


            var SelectedDateNumericValue = SelectedDateValue.getTime();
            var FinYearStartDateNumericValue = FinYearStartDateValue.getTime();
            var FinYearEndDatNumbericValue = FinYearEndDateValue.getTime();
            if (SelectedDateNumericValue >= FinYearStartDateNumericValue && SelectedDateNumericValue <= FinYearEndDatNumbericValue) {

            }
            else {
                jAlert('Enter Date Is Outside Of Financial Year !!');
                if (SelectedDateNumericValue < FinYearStartDateNumericValue) {
                    ctDate.SetDate(new Date(FinYearStartDate));
                }
                if (SelectedDateNumericValue > FinYearEndDatNumbericValue) {
                    ctDate.SetDate(new Date(FinYearEndDate));
                }
            }
            ///End OF Date Should Between Current Fin Year StartDate and EndDate
        }
        function InstrumentDateChange() {

            var ExpectedDeliveryDate = new Date(InsgridBatch.GetEditor('ExpectedDeliveryDate').GetValue());
            var requisitionDate = new Date(ctDate.GetValue());


            var datediff = ExpectedDeliveryDate - requisitionDate;
            if (ExpectedDeliveryDate.format('yyyy-MM-dd') != requisitionDate.format('yyyy-MM-dd'))
                if (ExpectedDeliveryDate < requisitionDate) {
                    jAlert('Expected Delivery date must be same or later to Requisition Date. Cannot Proceed.');
                    InsgridBatch.GetEditor('ExpectedDeliveryDate').SetValue(null);
                }


        }
        function ddlBranchFor_SelectedIndexChanged() {
            var BranchFor = $("#ddlBranch").val();
            cddlBranchTo.PerformCallback(BranchFor);

        }
        function GetVisibleIndex(s, e) {
            globalRowIndex = e.visibleIndex;
        }
        //...................Shortcut keys.................
        var isCtrl = false;
        document.onkeydown = function (e) {
            if (event.keyCode == 18) isCtrl = true;



            if (event.keyCode == 78 && event.altKey == true) {


            }
            else if (event.keyCode == 88 && event.altKey == true) {

                //run code for Ctrl+X -- ie, Save & Exit! 
                if (document.getElementById('btnSaveExit').style.display != 'none') {
                    document.getElementById('btnSaveExit').click();
                    return false;
                }
            }
            else if ((event.keyCode == 120 || event.keyCode == 65) && event.altKey == true) {
                //run code for Ctrl+A -- ie, Add New
                if (document.getElementById('DivEntry').style.display != 'block') {
                    AddButtonClick();
                }
            }
            else if (event.keyCode == 85 && event.altKey == true) {
                OpenUdf();
            }
        }
        //...................end............................
        function ChangeBranchTo() {

            if (document.getElementById('ddlBranchTo').value == "0") {
                $("#MandatoryBranchTo").show();

            }
            else {
                $("#MandatoryBranchTo").hide();
            }
        }
        function ShowMsgLastCall() {

            if (CgvPurchaseIndent.cpDelete != null) {

                jAlert(CgvPurchaseIndent.cpDelete)
                //CgvPurchaseIndent.PerformCallback();
                CgvPurchaseIndent.cpDelete = null;
                CgvPurchaseIndent.Refresh();
            }
            if (CgvPurchaseIndent.cpCancel != null) {

                jAlert(CgvPurchaseIndent.cpCancel)
                //CgvPurchaseIndent.PerformCallback();
                CgvPurchaseIndent.Refresh();
                CgvPurchaseIndent.cpCancel = null;
                txtFeedback.SetValue();
            }
        }
        function CustomButtonClick(s, e) {
            if (e.buttonID == 'CustomBtnView') {
                document.getElementById("divfromTo").style.display = 'none';

                $('#<%=hdnEditClick.ClientID %>').val('T'); //Edit

                 VisibleIndexE = e.visibleIndex;
                 $('#<%= lblHeading.ClientID %>').text("View Branch Requisition");
                document.getElementById('DivEntry').style.display = 'block';

                document.getElementById('DivEdit').style.display = 'none';
                document.getElementById('btnAddNew').style.display = 'none';

                btncross.style.display = "block";
                $('#<%=hdn_Mode.ClientID %>').val('View');
                InsgridBatch.PerformCallback("View~" + VisibleIndexE);

                chkAccount = 1;
                document.getElementById('divNumberingScheme').style.display = 'none';
            }
            else if (e.buttonID == 'CustomBtnEdit') {

                document.getElementById("divfromTo").style.display = 'none';
                var userbranchID = '<%=Session["userbranchID"]%>';


                $('#<%=hdnEditClick.ClientID %>').val('T'); //Edit
                $('#<%=hdn_Mode.ClientID %>').val('Edit'); //Edit
                VisibleIndexE = e.visibleIndex;

                $('#<%= lblHeading.ClientID %>').text("Modify Branch Requisition");
                document.getElementById('DivEntry').style.display = 'block';
                document.getElementById('DivEdit').style.display = 'none';
                document.getElementById('btnAddNew').style.display = 'none';
                btncross.style.display = "block";
                chkAccount = 1;

                InsgridBatch.PerformCallback("Edit~" + VisibleIndexE);

                document.getElementById('divNumberingScheme').style.display = 'none';
            }
            else if (e.buttonID == 'CustomBtnDelete') {
                jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                    if (r == true) {
                        VisibleIndexE = e.visibleIndex;
                        CgvPurchaseIndent.PerformCallback("Delete~" + VisibleIndexE);

                    }
                    else {
                        return false;
                    }
                });
            }
            else if (e.buttonID == 'CustomBtnPrint') {
                var keyValueindex = s.GetRowKey(e.visibleIndex);
                onPrintJv(keyValueindex);
            }
            else if (e.buttonID == 'CustomBtnCancel') {
                // VisibleIndexE = e.visibleIndex;
                // CgvPurchaseIndent.SetFocusedRowIndex(VisibleIndexE);
                // var IsCancel = CgvPurchaseIndent.GetRow(CgvPurchaseIndent.GetFocusedRowIndex()).children[13].innerText;
                CgvPurchaseIndent.GetRowValues(e.visibleIndex, 'IsCancel', function (value) {
                    if (value == true) {
                        jAlert("Branch requisition is already cancelled");
                    }
                    else {
                        jConfirm('Do you want to cancel the Branch Requisition?', 'Confirmation Dialog', function (r) {
                            if (r == true) {
                                VisibleIndexE = e.visibleIndex;
                                $("#<%=hddnKeyValue.ClientID%>").val(VisibleIndexE);

                                $('#MandatoryRemarksFeedback').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');
                                cPopup_Feedback.Show();

                            }
                            else {
                                return false;
                            }
                        });
                    }
                });

            }
}
function SaveExitButtonClick() {
    cLoadingPanelCRP.Show();
    $('#<%=hdnSaveNew.ClientID %>').val("Save_Exit");

    $('#<%=hdnRefreshType.ClientID %>').val('E');
    $('#<%=hdfIsDelete.ClientID %>').val('I');
    if (document.getElementById('<%= txtVoucherNo.ClientID %>').value == "") {
        $("#MandatoryBillNo").show();
        cLoadingPanelCRP.Hide();
        return false;
    }

    if (cddlBranchTo.GetValue() == null) {
        $("#MandatoryBranchTo").show();
        cLoadingPanelCRP.Hide();
        return false;
    }
    var IsType = "";
    var frontRow = 0;
    var backRow = -1;

    for (var i = 0; i <= InsgridBatch.GetVisibleRowsOnPage() ; i++) {
        var frontProduct = "";
        var backProduct = "";

        frontProduct = (InsgridBatch.batchEditApi.GetCellValue(backRow, 'ProductName') != null) ? (InsgridBatch.batchEditApi.GetCellValue(backRow, 'ProductName')) : "";
        backProduct = (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'ProductName') != null) ? (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'ProductName')) : "";
        if (frontProduct != "" || backProduct != "") {
            IsType = "Y";
            break;
        }
        backRow--;
        frontRow++;
    }

    if (InsgridBatch.GetVisibleRowsOnPage() > 0) {

        if (IsType == "Y") {

            cacbpCrpUdf.PerformCallback();
        }
        else {
            jAlert('Cannot Save. You must enter atleast one Product to save this entry.');
            cLoadingPanelCRP.Hide();
        }
    }
    else {
        jAlert('Cannot Save. You must enter atleast one Product to save this entry.');
        cLoadingPanelCRP.Hide();
    }
    chkAccount = 0;
    return false;

}
function deleteAllRows() {
    var frontRow = 0;
    var backRow = -1;
    for (var i = 0; i <= InsgridBatch.GetVisibleRowsOnPage() + 100 ; i++) {
        InsgridBatch.DeleteRow(frontRow);
        InsgridBatch.DeleteRow(backRow);
        backRow--;
        frontRow++;
    }

}
function AutoCalValue(s, e) {

    var Quantity = (InsgridBatch.GetEditor('gvColQuantity').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('gvColQuantity').GetValue()) : "0";
    var Rate = (InsgridBatch.GetEditor('gvColRate').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('gvColRate').GetValue()) : "0";
    InsgridBatch.GetEditor('gvColValue').SetValue(Quantity * Rate);



}
function AutoCalValueBtRate(s, e) {
    var Quantity = (InsgridBatch.GetEditor('gvColQuantity').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('gvColQuantity').GetValue()) : "0";
    var Rate = (InsgridBatch.GetEditor('gvColRate').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('gvColRate').GetValue()) : "0";
    InsgridBatch.GetEditor('gvColValue').SetValue(Quantity * Rate);
}
function txtBillNo_TextChanged() {
    var VoucherNo = document.getElementById("txtVoucherNo").value;

    $.ajax({
        type: "POST",
        url: "BranchRequisition.aspx/CheckUniqueName",
        data: JSON.stringify({ VoucherNo: VoucherNo }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            var data = msg.d;

            if (data == true) {
                $("#MandatoryBillNo").show();

                document.getElementById("txtVoucherNo").value = '';
                document.getElementById("txtVoucherNo").focus();
            }
            else {
                $("#MandatoryBillNo").hide();
            }
        }
    });
}
function BtnVisible() {
    document.getElementById('btnSaveExit').style.display = 'none'
    document.getElementById('btnnew').style.display = 'none'
    document.getElementById('tagged').style.display = 'block'

}
function AddNewRow() {
    InsgridBatch.AddNewRow();
    var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
    var tbQuotation = InsgridBatch.GetEditor("SrlNo");
    tbQuotation.SetValue(noofvisiblerows);
}
function OnEndCallback(s, e) {
    if (InsgridBatch.cpAddNewRow != null && InsgridBatch.cpAddNewRow != "") {
        InsgridBatch.cpAddNewRow = null;
        AddNewRow();
    }

    if (InsgridBatch.cpBtnVisible != null && InsgridBatch.cpBtnVisible != "") {
        InsgridBatch.cpBtnVisible = null;
        BtnVisible();
    }
    if (InsgridBatch.cpModifyOrNot != null && InsgridBatch.cpModifyOrNot != "") {

        document.getElementById('btnSaveExit').style.display = 'none'
        document.getElementById('btnnew').style.display = 'none'
        document.getElementById('taggModify').style.display = 'block'
        InsgridBatch.cpModifyOrNot = null;
    }
    if (InsgridBatch.cpEdit != null) {
        //Sandip Section For Approval Detail Start


        //Sandip Section For Approval Detail End
        var Indent_RequisitionNumber = InsgridBatch.cpEdit.split('~')[0];
        var Indent_RequisitionDate = InsgridBatch.cpEdit.split('~')[1];
        var Indent_BranchIdFor = InsgridBatch.cpEdit.split('~')[2];
        var Indent_Purpose = InsgridBatch.cpEdit.split('~')[3];
        var Indent_CurrencyId = InsgridBatch.cpEdit.split('~')[4];
        var Indent_ExchangeRtae = InsgridBatch.cpEdit.split('~')[5];
        var Indent_ID = InsgridBatch.cpEdit.split('~')[6];
        document.getElementById('Keyval_internalId').value = "BranchRequisition" + Indent_ID;
        var Indent_BranchIdTo = InsgridBatch.cpEdit.split('~')[7];
        var Transdt = new Date(Indent_RequisitionDate);
        ctDate.SetDate(Transdt);
        document.getElementById('txtVoucherNo').value = Indent_RequisitionNumber;
        $("#txtVoucherNo").attr("disabled", "disabled");
        $("#ddlBranch").attr("disabled", "disabled");
        cddlBranchTo.SetEnabled(true);
        document.getElementById('hdnEditIndentID').value = Indent_ID;
        ctxtMemoPurpose.SetValue(Indent_Purpose);
        cCmbCurrency.SetValue(Indent_CurrencyId);
        document.getElementById('ddlBranch').value = Indent_BranchIdFor;
        cddlBranchTo.PerformCallback(Indent_BranchIdFor + '~' + Indent_BranchIdTo);

        ctxtRate.SetValue(Indent_ExchangeRtae);
        InsgridBatch.batchEditApi.StartEdit(-1, 1);

        if ($('#<%=hdnEditClick.ClientID %>').val() == 'T') {
            InsgridBatch.AddNewRow();
            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var tbQuotation = InsgridBatch.GetEditor("SrlNo");
            tbQuotation.SetValue(noofvisiblerows);
            $('#<%=hdnEditClick.ClientID %>').val("");
        }
        if (InsgridBatch.cpApproval != null) {
            if (InsgridBatch.cpApproval == 'A') {


                $('#lbl_quotestatusmsg').css('display', 'block');
                $('#lbl_quotestatusmsg').text('Document already approved');
                $('#btnnew').css('display', 'none');
                $('#btnSaveExit').css('display', 'none');
            }
            else if (InsgridBatch.cpApproval == 'R') {
                $('#lbl_quotestatusmsg').css('display', 'block');
                $('#lbl_quotestatusmsg').text('Document already rejected');
                $('#btnnew').css('display', 'none');
                $('#btnSaveExit').css('display', 'none');
            }
            else {
                $('#lbl_quotestatusmsg').css('display', 'none');
                $('#btnnew').css('display', 'block');
                $('#btnSaveExit').css('display', 'block');
            }
        }
    }
    if (InsgridBatch.cpSaveSuccessOrFail == "nullQuantity") {

        InsgridBatch.AddNewRow();
        var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
        var tbQuotation = InsgridBatch.GetEditor("SrlNo");
        tbQuotation.SetValue(noofvisiblerows);
        InsgridBatch.cpSaveSuccessOrFail = null;
        $('#<%=hdnSaveNew.ClientID %>').val('');
        jAlert('Cannot save. Entered quantity must be greater then ZERO(0).');
        cLoadingPanelCRP.Hide();
    }
    else if (InsgridBatch.cpSaveSuccessOrFail == "duplicateProduct") {
        AddNewRow();
        InsgridBatch.cpSaveSuccessOrFail = null;
        $('#<%=hdnSaveNew.ClientID %>').val('');
           jAlert('Can not Add Duplicate Product in the Branch Requisition.');
           InsgridBatch.cpSaveSuccessOrFail = '';
           cLoadingPanelCRP.Hide();
       }
       else if (InsgridBatch.cpSaveSuccessOrFail == "outrange") {
           InsgridBatch.batchEditApi.StartEdit(0, 2);
           $('#<%=hdnSaveNew.ClientID %>').val('');
            jAlert('Can Not Add More Quotation Number as Quotation Scheme Exausted.<br />Update The Scheme and Try Again');
            cLoadingPanelCRP.Hide();

        }
        else if (InsgridBatch.cpSaveSuccessOrFail == "duplicate") {
            InsgridBatch.batchEditApi.StartEdit(0, 2);
            $('#<%=hdnSaveNew.ClientID %>').val('');
                jAlert('Can Not Save as Duplicate Quotation Numbe No. Found');
                cLoadingPanelCRP.Hide();

            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "errorInsert") {
                InsgridBatch.batchEditApi.StartEdit(0, 2);
                $('#<%=hdnSaveNew.ClientID %>').val('');
                jAlert('Please try after sometime.');
                cLoadingPanelCRP.Hide();

            }
            else {
                if (InsgridBatch.cpVouvherNo != null) {
                    var JV_Number = InsgridBatch.cpVouvherNo;

                    var value = document.getElementById('hdnRefreshType').value;

                    var JV_Msg = "Branch Requisition No. " + JV_Number + " generated.";
                    var strSchemaType = document.getElementById('hdnSchemaType').value;

                    if (value == "E") {

                        if (JV_Number != "") {
                            if (strSchemaType == '1') {

                                jAlert(JV_Msg, 'Alert Dialog: [BranchRequisition]', function (r) {
                                    if (r == true) {
                                        InsgridBatch.cpVouvherNo = null;
                                        window.location.assign("BranchRequisition.aspx");
                                    }
                                });

                            }
                            else {
                                window.location.assign("BranchRequisition.aspx");
                            }
                        }
                        else {
                            window.location.assign("BranchRequisition.aspx");
                        }

                    }
                    else if (value == "S") {

                        if (JV_Number != "") {
                            if (strSchemaType == '1') {
                                jAlert(JV_Msg, 'Alert Dialog: [BranchRequisition]', function (r) {
                                    if (r == true) {
                                        InsgridBatch.cpVouvherNo = null;

                                    }
                                });

                            }
                        }
                    }
                }

                if ($('#<%=hdnSaveNew.ClientID %>').val() == "Save_Exit") {

                    if (InsgridBatch.cpExitNew == "YES") {
                        <%--Code Added By Sandip For Approval Detail Section Start--%>
                        if (InsgridBatch.cpApproverStatus == "approve") {
                            window.parent.popup.Hide();
                            window.parent.cgridPendingApproval.PerformCallback();
                            window.parent.parent.CgvPurchaseIndent.Refresh();
                        }
                        <%--Code Above Added By Sandip For Approval Detail Section End--%>
                        deleteAllRows();

                    }
                    else {
                        InsgridBatch.AddNewRow();
                        var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
                        var tbQuotation = InsgridBatch.GetEditor("SrlNo");
                        tbQuotation.SetValue(noofvisiblerows);
                    }
                    var newInvoiceId = InsgridBatch.cpAutoID;

                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=BR-Default~D&modulename=BranchReq&id=" + newInvoiceId, '_blank');


                }
                if ($('#<%=hdnSaveNew.ClientID %>').val() == "Save_New") {

                    ctxtMemoPurpose.SetValue("");
                    $("#divNumberingScheme").show();
                    var Campany_ID = '<%=Session["LastCompany"]%>';
                    var LocalCurrency = '<%=Session["LocalCurrency"]%>';
                    var basedCurrency = LocalCurrency.split("~");
                    cCmbCurrency.SetValue(basedCurrency[0]);
                    ctxtRate.SetValue("");
                    ctxtRate.SetEnabled(false);
                    $('#<%=lblHeading.ClientID %>').text("");
                    $('#<%=lblHeading.ClientID %>').text("Add Branch Requisition");
                    deleteAllRows();
                    InsgridBatch.AddNewRow();
                    var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
                    var tbQuotation = InsgridBatch.GetEditor("SrlNo");
                    $('#<%=hdn_Mode.ClientID %>').val('Entry');
                    tbQuotation.SetValue(noofvisiblerows);
                    if (document.getElementById('txtVoucherNo').value == "Auto") {
                        document.getElementById('txtVoucherNo').value = "Auto";
                        $("#txtMemoPurpose_I").focus();
                    }
                    else {
                        document.getElementById('txtVoucherNo').value = "";

                        $('#txtVoucherNo').focus();
                    }


                    cCmbScheme.Focus();
                    var newInvoiceId = InsgridBatch.cpAutoID;
                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=BR-Default~D&modulename=BranchReq&id=" + newInvoiceId, '_blank');

                }
            }
    if (InsgridBatch.cpView == "1") {
        viewOnly();
    }
}
function viewOnly() {

    if ($('#<%=hdn_Mode.ClientID %>').val().toUpperCase() == 'VIEW') {
        $('#DivEntry').find('input, textarea, button, select').attr('disabled', 'disabled');

        InsgridBatch.SetEnabled(false);
        cddlBranchTo.SetEnabled(false);
        ctDate.SetEnabled(false);

        cbtn_SaveRecords.SetVisible(false);
        cbtn_SaveRecordsExit.SetVisible(false);
        cbtn_SaveUdf.SetVisible(false);
        document.getElementById('tagged').style.display = 'none';
        document.getElementById('taggModify').style.display = 'none';
    }

}
function OnCustomButtonClick(s, e) {

    if (e.buttonID == 'CustomDeleteIDS') {

        if (InsgridBatch.GetVisibleRowsOnPage() > 1) {
            var tbQuotation = InsgridBatch.GetEditor("SrlNo");
            InsgridBatch.batchEditApi.EndEdit();
            InsgridBatch.DeleteRow(e.visibleIndex);
            $('#<%=hdfIsDelete.ClientID %>').val('D');

            InsgridBatch.UpdateEdit();
            InsgridBatch.PerformCallback('Display');

            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc                  
            tbQuotation.SetValue(noofvisiblerows);
        }

    }
    if (e.buttonID == 'CustomAddNewRow') {

        InsgridBatch.batchEditApi.StartEdit(e.visibleIndex, 2);
        var Product = (InsgridBatch.GetEditor('gvColProduct').GetValue() != null) ? InsgridBatch.GetEditor('gvColProduct').GetValue() : "";
        var Quantity = (InsgridBatch.GetEditor('gvColQuantity').GetValue() != null) ? InsgridBatch.GetEditor('gvColQuantity').GetValue() : "0.0";
        if (Product != "" && Quantity != "0.0") {
            InsgridBatch.AddNewRow();
            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var tbQuotation = InsgridBatch.GetEditor("SrlNo");
            tbQuotation.SetValue(noofvisiblerows);

            setTimeout(function () {
                InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 2);
            }, 500);
            return false;
        }


    }
}
//....Tab Index Change From Rate to Grid First Column......
$(document).ready(function () {
    $('#txtMemoPurpose_I').blur(function () {
        if (InsgridBatch.GetVisibleRowsOnPage() == 1) {
            InsgridBatch.batchEditApi.StartEdit(-1, 2);
        }
    })


});
//.....end..........
function Save_ButtonClick() {
    $('#<%=hdnSaveNew.ClientID %>').val("Save_New");
    $('#<%=hdfIsDelete.ClientID %>').val('I');
    $('#<%=hdnRefreshType.ClientID %>').val('S');
    if (document.getElementById('<%= txtVoucherNo.ClientID %>').value == "") {
        $("#MandatoryBillNo").show();

        return false;
    }
    if (cddlBranchTo.GetValue() == null) {
        $("#MandatoryBranchTo").show();
        return false;
    }
    var IsType = "";
    var frontRow = 0;
    var backRow = -1;

    for (var i = 0; i <= InsgridBatch.GetVisibleRowsOnPage() ; i++) {
        var frontProduct = "";
        var backProduct = "";

        frontProduct = (InsgridBatch.batchEditApi.GetCellValue(backRow, 'ProductName') != null) ? (InsgridBatch.batchEditApi.GetCellValue(backRow, 'ProductName')) : "";
        backProduct = (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'ProductName') != null) ? (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'ProductName')) : "";
        if (frontProduct != "" || backProduct != "") {
            IsType = "Y";
            break;
        }
        backRow--;
        frontRow++;
    }
    if (InsgridBatch.GetVisibleRowsOnPage() > 0) {


        if (IsType == "Y") {

            cacbpCrpUdf.PerformCallback();
        }
        else {
            jAlert('Cannot Save. You must enter atleast one Product to save this entry.');
        }
    }
    else {
        jAlert('Cannot Save. You must enter atleast one Product to save this entry.');

    }
    chkAccount = 0;
    return false;
}

function AddBatchNew() {
    InsgridBatch.batchEditApi.EndEdit();

    var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc

    var i;
    var cnt = 1;
    if (noofvisiblerows == "0") {
        InsgridBatch.AddNewRow();
    }
    InsgridBatch.SetFocusedRowIndex();

    for (i = -1 ; cnt <= noofvisiblerows ; i--) {
        cnt++;
    }

    var tbQuotation = InsgridBatch.GetEditor("SrlNo");
    console.log(tbQuotation);
    tbQuotation.SetValue(cnt);

}
function ProductsGotFocus(s, e) {
    document.getElementById("pageheaderContent").style.display = 'block';
    document.getElementById("liToBranch").style.display = 'block';
    var tbDescription = InsgridBatch.GetEditor("gvColDiscription");
    var tbUOM = InsgridBatch.GetEditor("gvColUOM");
    var tdRate = InsgridBatch.GetEditor("gvColRate");
    var AvailableStock = InsgridBatch.GetEditor("gvColAvailableStock");
    var ProductID = (InsgridBatch.GetEditor('gvColProduct').GetValue() != null) ? InsgridBatch.GetEditor('gvColProduct').GetValue() : "0";
    var SpliteDetails = ProductID.split("||@||");
    var strProductID = SpliteDetails[0];
    var strDescription = SpliteDetails[1];
    var strUOM = SpliteDetails[2];
    var strUOMstk = SpliteDetails[4];

    var strRate = SpliteDetails[6];
    chkAccount = 1;
    tbDescription.SetValue(strDescription);
    tbUOM.SetValue(strUOM);
    tdRate.SetValue(strRate);
    $('#<%= lblStkQty.ClientID %>').text("0.00");
    $('#<%= lblStkUOM.ClientID %>').text(strUOM);
    $('#<%= lblStkUOMTo.ClientID %>').text(strUOM);
    if (ProductID != "0") {
        cacpAvailableStock.PerformCallback(strProductID);
    }
}
function ProductsGotFocusFromID(s, e) {
    pageheaderContent.style.display = "block";
    document.getElementById("liToBranch").style.display = 'block';

    var ProductID = (InsgridBatch.GetEditor('gvColProduct').GetValue() != null) ? InsgridBatch.GetEditor('gvColProduct').GetValue() : "0";
    var strProductName = (InsgridBatch.GetEditor('gvColProduct').GetText() != null) ? InsgridBatch.GetEditor('gvColProduct').GetText() : "0";


    var QuantityValue = (InsgridBatch.GetEditor('gvColQuantity').GetValue() != null) ? InsgridBatch.GetEditor('gvColQuantity').GetValue() : "0";
    var tbDescription = InsgridBatch.GetEditor("gvColDiscription");
    var tbUOM = InsgridBatch.GetEditor("gvColUOM");
    var tdRate = InsgridBatch.GetEditor("gvColRate");

    var SpliteDetails = ProductID.split("||@||");
    var strProductID = SpliteDetails[0];
    var strDescription = SpliteDetails[1];
    var strUOM = SpliteDetails[2];
    var strUOMstk = SpliteDetails[4];

    var strRate = SpliteDetails[6];
    chkAccount = 1;
    tbDescription.SetValue(strDescription);
    tbUOM.SetValue(strUOM);

    $('#<%= lblStkQty.ClientID %>').text("0.00");
    $('#<%= lblStkUOM.ClientID %>').text(strUOM);
    $('#<%= lblStkUOMTo.ClientID %>').text(strUOM);

    if (ProductID != "0") {
        cacpAvailableStock.PerformCallback(strProductID);
    }

}
function acpAvailableStockEndCall(s, e) {
    if (cacpAvailableStock.cpstock != null) {
        var AvailableStock = cacpAvailableStock.cpstock + " " + document.getElementById('<%=lblStkUOM.ClientID %>').innerHTML;
        $('#<%=B_AvailableStock.ClientID %>').text(AvailableStock);
        cacpAvailableStock.cpstock = null;
    }
    if (cacpAvailableStock.cpstockBranchTo != null) {
        document.getElementById("liToBranch").style.display = 'block';
        var AvailableStock = cacpAvailableStock.cpstockBranchTo + " " + document.getElementById('<%=lblStkUOMTo.ClientID %>').innerHTML;
        $('#<%=B_AvailableStockToBranch.ClientID %>').text(AvailableStock);
        cacpAvailableStock.cpstockBranchTo = null;
    }
    if (preColumn == "Product") {
        InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 5);
        preColumn = '';
        return;
    }


}
function ProductsComboGotFocusChange(s, e) {

    var tbDescription = InsgridBatch.GetEditor("gvColDiscription");
    var tbUOM = InsgridBatch.GetEditor("gvColUOM");
    var tdRate = InsgridBatch.GetEditor("gvColRate");
    var AvailableStock = InsgridBatch.GetEditor("gvColAvailableStock");
    var ProductID = (InsgridBatch.GetEditor('gvColProduct').GetValue() != null) ? InsgridBatch.GetEditor('gvColProduct').GetValue() : "0";


    var SpliteDetails = ProductID.split("||@||");
    var strProductID = SpliteDetails[0];
    var strDescription = SpliteDetails[1];
    var strUOM = SpliteDetails[2];
    var strRate = SpliteDetails[6];
    chkAccount = 1;
    tbDescription.SetValue(strDescription);
    tbUOM.SetValue(strUOM);
    tdRate.SetValue(strRate);
    var Campany_ID = '<%=Session["LastCompany"]%>';
    var LastFinYear = '<%=Session["LastFinYear"]%>';
    var BranchFor = $("#ddlBranch").val();
    if (ProductID != "0" && ProductID != "") {

        $.ajax({
            type: "POST",
            url: 'BranchRequisition.aspx/getAvilableStock',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ Campany_ID: Campany_ID, ProductID: strProductID, LastFinYear: LastFinYear, BranchFor: BranchFor }),
            success: function (msg) {
                var data = msg.d;

                document.getElementById("pageheaderContent").style.display = 'block';


                var AvailableStock = data + " " + strUOM;
                $('#<%=B_AvailableStock.ClientID %>').text(AvailableStock);

                    }
                });
                var BranchTo = $("#ddlBranchTo").val();

                if (BranchTo != "0" && ProductID != "") {

                    $.ajax({
                        type: "POST",
                        url: 'BranchRequisition.aspx/getAvilableStock',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({ Campany_ID: Campany_ID, ProductID: strProductID, LastFinYear: LastFinYear, BranchFor: BranchTo }),
                        success: function (msg) {
                            var data = msg.d;

                            document.getElementById("liToBranch").style.display = 'block';


                            var AvailableStock = data + " " + strUOM;
                            $('#<%=B_AvailableStockToBranch.ClientID %>').text(AvailableStock);

                        }
                    });
                }

            }

        }
        function ProductsCombo_SelectedIndexChanged(s, e) {
            var tbDescription = InsgridBatch.GetEditor("gvColDiscription");
            var tbUOM = InsgridBatch.GetEditor("gvColUOM");
            var tdRate = InsgridBatch.GetEditor("gvColRate");
            var AvailableStock = InsgridBatch.GetEditor("gvColAvailableStock");
            var ProductID = s.GetValue();
            var SpliteDetails = ProductID.split("||@||");
            var strProductID = SpliteDetails[0];
            var strDescription = SpliteDetails[1];
            var strUOM = SpliteDetails[2];
            var strRate = SpliteDetails[6];
            chkAccount = 1;
            tbDescription.SetValue(strDescription);
            tbUOM.SetValue(strUOM);
            tdRate.SetValue(strRate);
            var Campany_ID = '<%=Session["LastCompany"]%>';
            var LastFinYear = '<%=Session["LastFinYear"]%>';
            var BranchFor = $("#ddlBranch").val();
            $.ajax({
                type: "POST",
                url: 'BranchRequisition.aspx/getAvilableStock',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ Campany_ID: Campany_ID, ProductID: strProductID, LastFinYear: LastFinYear, BranchFor: BranchFor }),
                success: function (msg) {
                    var data = msg.d;

                    document.getElementById("pageheaderContent").style.display = 'block';

                    var AvailableStock = data + " " + strUOM;
                    $('#<%=B_AvailableStock.ClientID %>').text(AvailableStock);

                }
            });
            var BranchTo = $("#ddlBranchTo").val();

            if (BranchTo != "0") {
                $.ajax({
                    type: "POST",
                    url: 'BranchRequisition.aspx/getAvilableStock',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: JSON.stringify({ Campany_ID: Campany_ID, ProductID: strProductID, LastFinYear: LastFinYear, BranchFor: BranchTo }),
                    success: function (msg) {
                        var data = msg.d;

                        document.getElementById("pageheaderAvToBranch").style.display = 'block';

                        var AvailableStock = data + " " + strUOM;
                        $('#<%=B_AvailableStockToBranch.ClientID %>').text(AvailableStock);

                    }
                });
            }

        }
        function AddButtonClick() {
            $('#<%=hdn_Mode.ClientID %>').val('Entry'); //Entry
            $('#<%=Keyval_internalId.ClientID %>').val('Add');
            cCmbScheme.SetValue("0");
            ctxtRate.SetEnabled(false);
            document.getElementById('DivEntry').style.display = 'block';
            document.getElementById('DivEdit').style.display = 'none';
            document.getElementById('btnAddNew').style.display = 'none';
            document.getElementById('divfromTo').style.display = 'none';
            btncross.style.display = "block";

            document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
            document.getElementById('<%= txtRate.ClientID %>').disabled = true;
            document.getElementById('<%= ddlBranch.ClientID %>').disabled = true;
            $('#<%=lblHeading.ClientID %>').text("");
            $('#<%=lblHeading.ClientID %>').text("Add Branch Requisition");
            deleteAllRows();
            InsgridBatch.AddNewRow();
            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var tbQuotation = InsgridBatch.GetEditor("SrlNo");
            tbQuotation.SetValue(noofvisiblerows);
            cCmbScheme.Focus();
            ddlBranchFor_SelectedIndexChanged();

        }
        function CmbScheme_ValueChange() {
            var val = cCmbScheme.GetValue();
            $.ajax({
                type: "POST",
                url: 'BranchRequisition.aspx/getSchemeType',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{sel_scheme_id:\"" + val + "\"}",
                success: function (type) {
                    var schemetypeValue = type.d;
                    var schemetype = schemetypeValue.toString().split('~')[0];
                    var schemelength = schemetypeValue.toString().split('~')[1];
                    $('#txtVoucherNo').attr('maxLength', schemelength);
                    var branchID = schemetypeValue.toString().split('~')[2];
                    if (schemetypeValue != "") {
                        document.getElementById('ddlBranch').value = branchID;
                        document.getElementById('<%= ddlBranch.ClientID %>').disabled = true;
                        cddlBranchTo.PerformCallback(branchID);

                    }
                    if (schemetype == '0') {
                        $('#<%=hdnSchemaType.ClientID %>').val('0');
                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = false;
                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
                        $('#<%=txtVoucherNo.ClientID %>').focus();
                    }
                    else if (schemetype == '1') {
                        $('#<%=hdnSchemaType.ClientID %>').val('1');
                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Auto";
                        $("#MandatoryBillNo").hide();
                        ctDate.Focus();
                    }
                    else if (schemetype == '2') {
                        $('#<%=hdnSchemaType.ClientID %>').val('2');
                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Datewise";
                    }
                    else if (schemetype == 'n') {
                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
                    }
                }
            });
}
function Currency_Rate() {

    var Campany_ID = '<%=Session["LastCompany"]%>';
    var LocalCurrency = '<%=Session["LocalCurrency"]%>';
    var basedCurrency = LocalCurrency.split("~");
    var Currency_ID = cCmbCurrency.GetValue();
    $('#<%=hdnCurrenctId.ClientID %>').val(Currency_ID);


    if (cCmbCurrency.GetText().trim() == basedCurrency[1]) {
        ctxtRate.SetValue("");
        ctxtRate.SetEnabled(false);
    }
    else {
        $.ajax({
            type: "POST",
            url: "BranchRequisition.aspx/GetRate",
            data: JSON.stringify({ Currency_ID: Currency_ID, Campany_ID: Campany_ID, basedCurrency: basedCurrency[0] }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var data = msg.d;
                ctxtRate.SetValue(data);


            }
        });

        ctxtRate.SetEnabled(true);
    }

}
    </script>
    <style>
        .absolute, #gridBatch_DXMainTable .dxeErrorFrameSys.dxeErrorCellSys {
            position: absolute;
        }

        #gridBatch_DXMainTable > tbody > tr > td:last-child {
            display: none !important;
        }
    </style>
    <%--Batch Product Popup Start--%>

    <script>
        function ProductKeyDown(s, e) {
            console.log(e.htmlEvent.key);
            if (e.htmlEvent.key == "Enter") {

                s.OnButtonClick(0);
            }
            if (e.htmlEvent.key == "Tab") {

                s.OnButtonClick(0);
            }
        }

        function ProductButnClick(s, e) {
            if (e.buttonIndex == 0) {

                if (cproductLookUp.Clear()) {
                    cProductpopUp.Show();
                    cproductLookUp.Focus();
                    cproductLookUp.ShowDropDown();
                }
            }
        }
        function ProductlookUpKeyDown(s, e) {
            if (e.htmlEvent.key == "Escape") {
                cProductpopUp.Hide();
                InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 5);
            }
        }
        function ProductSelected(s, e) {
            if (cproductLookUp.GetGridView().GetFocusedRowIndex() == -1) {
                cProductpopUp.Hide();
                InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 5);
                return;
            }
            var LookUpData = cproductLookUp.GetGridView().GetRowKey(cproductLookUp.GetGridView().GetFocusedRowIndex());
            var ProductCode = cproductLookUp.GetValue();
            if (!ProductCode) {
                LookUpData = null;
            }
            else {
                chkAccount = 1;
            }
            cProductpopUp.Hide();
            InsgridBatch.batchEditApi.StartEdit(globalRowIndex);
            InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 5);
            InsgridBatch.GetEditor("gvColProduct").SetText(LookUpData);
            InsgridBatch.GetEditor("ProductName").SetText(ProductCode);

            pageheaderContent.style.display = "block";

            var tbDescription = InsgridBatch.GetEditor("gvColDiscription");
            var tbUOM = InsgridBatch.GetEditor("gvColUOM");
            var tbSalePrice = InsgridBatch.GetEditor("gvColRate");


            var ProductID = (InsgridBatch.GetEditor('gvColProduct').GetText() != null) ? InsgridBatch.GetEditor('gvColProduct').GetText() : "0";
            var SpliteDetails = ProductID.split("||@||");
            var strProductID = SpliteDetails[0];
            var strDescription = SpliteDetails[1];
            var strUOM = SpliteDetails[2];
            var strStkUOM = SpliteDetails[4];
            var strSalePrice = SpliteDetails[6];

            var QuantityValue = (InsgridBatch.GetEditor('gvColQuantity').GetValue() != null) ? InsgridBatch.GetEditor('gvColQuantity').GetValue() : "0";


            tbDescription.SetValue(strDescription);
            tbUOM.SetValue(strUOM);
            tbSalePrice.SetValue(strSalePrice);

            InsgridBatch.GetEditor("gvColQuantity").SetValue("0.00");

            $('#<%= lblStkQty.ClientID %>').text("0.00");
            $('#<%= lblStkUOM.ClientID %>').text(strUOM);
            $('#<%= lblStkUOMTo.ClientID %>').text(strUOM);



            preColumn = "Product";
            cacpAvailableStock.PerformCallback(strProductID);
            InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 5);

        }
    </script>

    <%--Batch Product Popup End--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading clearfix">
        <div class="panel-title clearfix">
            <div style="padding-right: 5px;">
                <h3 class="pull-left"><span class="">
                    <asp:Label ID="lblHeading" runat="server" Text="Branch Requisition"></asp:Label></span>
                </h3>
                <div id="pageheaderContent" class="pull-right wrapHolder reverse content horizontal-images" style="display: none;">
                    <div class="Top clearfix">
                        <ul>
                            <li id="liToBranch" style="display: none;">
                                <div class="lblHolder" style="max-width: 350px">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>Available Balance of Request To Branch </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div style="width: 100%;">

                                                        <asp:Label ID="B_AvailableStockToBranch" runat="server" Text="0.0"></asp:Label>
                                                    </div>

                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </li>
                            <li>
                                <div class="lblHolder" style="max-width: 350px">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>Available Balance of Request From Branch </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div style="width: 100%;">

                                                        <asp:Label ID="B_AvailableStock" runat="server" Text="0.0"></asp:Label>
                                                    </div>

                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </li>
                            <li>
                                <div class="lblHolder" style="display: none;">
                                    <table>
                                        <tr>
                                            <td>Stock Quantity</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblStkQty" runat="server" Text="0.00"></asp:Label>
                                                <asp:Label ID="lblStkUOM" runat="server" Text=" "></asp:Label>
                                                <asp:Label ID="lblStkUOMTo" runat="server" Text=" "></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <%--Abhisek--%>
                <div id="divfromTo">
                    <table class="padTabtype2 pull-right brnchreq" style="margin-top: 7px">
                        <tr>
                            <td>
                                <label>From Date</label></td>
                            <td>
                                <dxe:ASPxDateEdit ID="FormDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cFormDate" Width="100%">
                                    <ButtonStyle Width="13px">
                                    </ButtonStyle>
                                </dxe:ASPxDateEdit>
                            </td>
                            <td>
                                <label>To Date</label>
                            </td>
                            <td>
                                <dxe:ASPxDateEdit ID="toDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="ctoDate" Width="100%">
                                    <ButtonStyle Width="13px">
                                    </ButtonStyle>
                                </dxe:ASPxDateEdit>
                            </td>
                            <td>
                                <label>Branch</label></td>
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
                <div id="ApprovalCross" runat="server" class="crossBtn"><a><i class="fa fa-times"></i></a></div>
                <div id="btncross" runat="server" class="crossBtn" style="display: none; margin-left: 50px;"><a href="BranchRequisition.aspx"><i class="fa fa-times"></i></a></div>
            </div>

        </div>

    </div>
    <div class="form_main">
        <div class="clearfix" id="btnAddNew">
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


                <%--Sandip Section for Approval Section in Design Start --%>

                <span id="spanStatus" runat="server">
                    <a href="javascript:void(0);" onclick="OpenPopUPUserWiseQuotaion()" class="btn btn-primary">
                        <span>My Branch Requisition Status</span>

                    </a>
                </span>
                <span id="divPendingWaiting" runat="server">
                    <a href="javascript:void(0);" onclick="OpenPopUPApprovalStatus()" class="btn btn-primary">
                        <span>Branch Requisition Waiting</span>
                        <asp:Label ID="lblWaiting" runat="server" Text=""></asp:Label>
                    </a>
                    <i class="fa fa-reply blink" style="font-size: 20px; margin-right: 10px;" aria-hidden="true"></i>

                </span>

                <%--Sandip Section for Approval Section in Design End --%>
            </div>
        </div>
        <div id="DivEntry" style="display: none">
            <div style="background: #f5f4f3; padding: 8px 0; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ccc;" class="clearfix">
                <div class="col-md-2" id="divNumberingScheme">
                    <label style="">Numbering Scheme</label>
                    <div>
                        <dxe:ASPxComboBox ID="CmbScheme" EnableIncrementalFiltering="True" ClientInstanceName="cCmbScheme"
                            TextField="SchemaName" ValueField="ID" IncrementalFilteringMode="Contains"
                            runat="server" ValueType="System.String" Width="100%" EnableSynchronization="True">
                            <ClientSideEvents ValueChanged="function(s,e){CmbScheme_ValueChange()}" GotFocus="function(s,e){cCmbScheme.ShowDropDown();}"></ClientSideEvents>
                        </dxe:ASPxComboBox>
                        <span id="MandatoryNumberingScheme" class="iconNumberScheme pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>

                    </div>
                </div>
                <div class="col-md-2">
                    <label>Branch/Requisition No.<span style="color: red;">*</span></label>
                    <div>
                        <asp:TextBox ID="txtVoucherNo" runat="server" Width="100%" MaxLength="50" onchange="txtBillNo_TextChanged()">                             
                        </asp:TextBox>

                        <span id="MandatoryBillNo" class="voucherno  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>

                    </div>
                </div>
                <div class="col-md-2">
                    <label>Date<span style="color: red;">*</span></label>
                    <div>
                        <dxe:ASPxDateEdit ID="tDate" runat="server" EditFormat="Custom" ClientInstanceName="ctDate" DisplayFormatString="dd-MM-yyyy"
                            UseMaskBehavior="True" Width="100%" EditFormatString="dd-MM-yyyy">

                            <ClientSideEvents DateChanged="function(s,e){TDateChange();}" GotFocus="function(s,e){ctDate.ShowDropDown();}"></ClientSideEvents>
                            <ValidationSettings RequiredField-IsRequired="true" ErrorFrameStyle-CssClass="absolute"></ValidationSettings>
                        </dxe:ASPxDateEdit>
                    </div>
                </div>
                <div class="col-md-2">

                    <label>From Branch</label>
                    <div>
                        <asp:DropDownList ID="ddlBranch" runat="server" DataSourceID="dsBranch" onchange="ddlBranchFor_SelectedIndexChanged()"
                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%">
                        </asp:DropDownList>

                    </div>
                </div>
                <div class="col-md-2">

                    <label>Request To Branch<span style="color: red;">*</span></label>
                    <div>

                        <dxe:ASPxComboBox ID="ddlBranchTo" runat="server" ClientIDMode="Static" ClientInstanceName="cddlBranchTo" Width="100%"
                            OnCallback="ddlBranchTo_Callback">
                            <ClientSideEvents SelectedIndexChanged="ChangeBranchTo" />
                        </dxe:ASPxComboBox>
                        <span id="MandatoryBranchTo" class="BranchTo  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                    </div>
                </div>


                <div style="clear: both"></div>
                <div class="col-md-8">
                    <label style="margin-bottom: 5px; display: inline-block">Purpose</label>
                    <div>
                        <dxe:ASPxMemo ID="txtMemoPurpose" ClientInstanceName="ctxtMemoPurpose" runat="server" Height="50px" Width="100%" Font-Names="Arial"></dxe:ASPxMemo>
                    </div>
                </div>
                <div style="clear: both"></div>
                <div>
                    <br />
                </div>
                <div style="display: none;">
                    <div class="col-md-1">
                        <label>Currency:  </label>
                        <div>
                            <dxe:ASPxComboBox ID="CmbCurrency" EnableIncrementalFiltering="True" ClientInstanceName="cCmbCurrency"
                                TextField="Currency_AlphaCode" ValueField="Currency_ID" DataSourceID="SqlCurrency"
                                runat="server" ValueType="System.String" EnableSynchronization="True" Width="100%" CssClass="pull-left">
                                <ClientSideEvents ValueChanged="function(s,e){Currency_Rate()}"></ClientSideEvents>
                            </dxe:ASPxComboBox>

                        </div>
                    </div>
                    <div class="col-md-2">
                        <label>Rate:  </label>
                        <div>
                            <dxe:ASPxTextBox runat="server" ID="txtRate" ClientInstanceName="ctxtRate" Width="100%" CssClass="pull-left">
                                <MaskSettings Mask="<0..9999>.<0..99999>" IncludeLiterals="DecimalSymbol" />

                            </dxe:ASPxTextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <div>
                    <br />
                </div>
                <dxe:ASPxGridView runat="server" ClientInstanceName="InsgridBatch" ID="gridBatch" KeyFieldName="PurchaseIndentID" OnBatchUpdate="gridBatch_BatchUpdate"
                    OnCellEditorInitialize="gridBatch_CellEditorInitialize" OnDataBinding="gridBatch_DataBinding"
                    Width="100%" Settings-ShowFooter="false" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false"
                    OnRowInserting="Grid_RowInserting" Settings-VerticalScrollBarMode="Auto" Settings-VerticalScrollableHeight="200" SettingsPager-Mode="ShowAllRecords"
                    OnRowUpdating="Grid_RowUpdating"
                    OnRowDeleting="Grid_RowDeleting"
                    OnCustomCallback="gridBatch_CustomCallback">
                    <SettingsPager Visible="false"></SettingsPager>
                    <Columns>
                        <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="50" VisibleIndex="0" Caption="Action" HeaderStyle-HorizontalAlign="Center">
                            <CustomButtons>
                                <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomDeleteIDS" Image-Url="/assests/images/crs.png">
                                </dxe:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dxe:GridViewCommandColumn>
                        <dxe:GridViewDataTextColumn FieldName="SrlNo" Caption="Sl" VisibleIndex="1" Width="30">
                            <PropertiesTextEdit>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <%-- <dxe:GridViewDataComboBoxColumn Caption="Product" FieldName="gvColProduct" VisibleIndex="2">
                            <PropertiesComboBox ValueField="ProductID" ClientInstanceName="ProductID" TextField="ProductName">
                                <ClientSideEvents SelectedIndexChanged="ProductsCombo_SelectedIndexChanged" GotFocus="ProductsComboGotFocusChange" />
                            </PropertiesComboBox>
                        </dxe:GridViewDataComboBoxColumn>--%>
                        <%--Batch Product Popup Start--%>

                        <dxe:GridViewDataButtonEditColumn FieldName="ProductName" Caption="Product" VisibleIndex="2">
                            <PropertiesButtonEdit>
                                <ClientSideEvents ButtonClick="ProductButnClick" KeyDown="ProductKeyDown" LostFocus="ProductsGotFocus" GotFocus="ProductsGotFocusFromID" />
                                <Buttons>
                                    <dxe:EditButton Text="..." Width="20px">
                                    </dxe:EditButton>
                                </Buttons>
                            </PropertiesButtonEdit>
                        </dxe:GridViewDataButtonEditColumn>
                        <dxe:GridViewDataTextColumn FieldName="gvColProduct" Caption="hidden Field Id" VisibleIndex="11" ReadOnly="True" Width="0"
                            EditCellStyle-CssClass="hide" PropertiesTextEdit-FocusedStyle-CssClass="hide" PropertiesTextEdit-Style-CssClass="hide">
                            <CellStyle CssClass="hide"></CellStyle>
                        </dxe:GridViewDataTextColumn>

                        <%--Batch Product Popup End--%>
                        <dxe:GridViewDataTextColumn VisibleIndex="3" Caption="Description" FieldName="gvColDiscription">
                            <PropertiesTextEdit>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="true" HorizontalAlign="Left" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn VisibleIndex="4" Caption="Quantity" FieldName="gvColQuantity" Width="110" HeaderStyle-HorizontalAlign="Right">
                            <PropertiesTextEdit>
                                <MaskSettings Mask="<0..999999999>.<0..9999>" />
                                <ClientSideEvents LostFocus="AutoCalValue" />
                            </PropertiesTextEdit>

                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="5" Caption="UOM(Stock)" FieldName="gvColUOM" Width="110">
                            <PropertiesTextEdit>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataDateColumn VisibleIndex="6" Caption="Expected Delivery Date" FieldName="ExpectedDeliveryDate" Width="140">
                            <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy">
                                <ClientSideEvents DateChanged="function(s,e){InstrumentDateChange();}"></ClientSideEvents>
                            </PropertiesDateEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataDateColumn>
                        <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="80" VisibleIndex="7" Caption="Action" HeaderStyle-HorizontalAlign="Center">
                            <CustomButtons>
                                <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomAddNewRow" Image-Url="/assests/images/add.png">
                                </dxe:GridViewCommandColumnCustomButton>

                            </CustomButtons>
                        </dxe:GridViewCommandColumn>
                        <dxe:GridViewDataTextColumn Caption="Rate" FieldName="gvColRate" Width="0" HeaderStyle-HorizontalAlign="Right">
                            <PropertiesTextEdit>
                                <MaskSettings Mask="<0..999999999>.<0..99>" />
                                <ClientSideEvents LostFocus="AutoCalValueBtRate" />
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Caption="Value" FieldName="gvColValue" Width="0" HeaderStyle-HorizontalAlign="Right">
                            <PropertiesTextEdit>
                                <MaskSettings Mask="<0..999999999999999999>.<0..99>" />
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="10" Caption="Available Stock" FieldName="gvColAvailableStock" Width="0">
                            <PropertiesTextEdit NullTextStyle-CssClass="hide" ReadOnlyStyle-CssClass="hide" Style-CssClass="hide">
                                <MaskSettings Mask="<0..999999999999>.<0..99999>" />
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                        </dxe:GridViewDataTextColumn>


                    </Columns>

                    <ClientSideEvents EndCallback="OnEndCallback" RowClick="GetVisibleIndex"
                        CustomButtonClick="OnCustomButtonClick" BatchEditStartEditing="gridFocusedRowChanged" />
                    <SettingsDataSecurity AllowEdit="true" />
                    <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                        <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="Row" />
                    </SettingsEditing>

                    <Styles>
                        <StatusBar CssClass="statusBar">
                        </StatusBar>
                    </Styles>
                </dxe:ASPxGridView>
                <div>
                    <br />
                </div>
                <div>
                    <table style="float: left;">
                        <tr>

                            <td>
                                <asp:Label ID="lbl_quotestatusmsg" runat="server" Text="" Font-Bold="true" ForeColor="Red" Font-Size="Medium"></asp:Label>
                                <dxe:ASPxButton ID="btnnew" ClientInstanceName="cbtn_SaveRecords" runat="server" AutoPostBack="False" Text="Save & N&#818;ew"
                                    CssClass="btn btn-primary  hide"
                                    meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                    <ClientSideEvents Click="function(s, e) {Save_ButtonClick();}" />
                                </dxe:ASPxButton>

                            </td>
                            <td>
                                <dxe:ASPxButton ID="btnSaveExit" ClientInstanceName="cbtn_SaveRecordsExit" runat="server" AutoPostBack="False" Text="Save & Ex&#818;it" CssClass="btn btn-primary"
                                    meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                    <ClientSideEvents Click="function(s, e) {SaveExitButtonClick();}" />
                                </dxe:ASPxButton>

                            </td>
                            <td>
                                <dxe:ASPxButton ID="btnSaveUdf" ClientInstanceName="cbtn_SaveUdf" runat="server" AutoPostBack="False" Text="U&#818;DF" UseSubmitBehavior="False"
                                    CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1">
                                    <ClientSideEvents Click="function(s, e) {OpenUdf();}" />
                                </dxe:ASPxButton>
                            </td>


                        </tr>
                        <tr><b><span id="tagged" style="display: none; color: red">Tagged in Branch Transfer Out. Cannot Modify</span></b></tr>
                        <tr><b><span id="taggModify" style="display: none; color: red">Requested By Other Branch. Cannot Modify</span></b></tr>
                    </table>
                </div>
                <%--Batch Product Popup Start--%>

                <dxe:ASPxPopupControl ID="ProductpopUp" runat="server" ClientInstanceName="cProductpopUp"
                    CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Height="400"
                    Width="700" HeaderText="Select Product" AllowResize="true" ResizingMode="Postponed" Modal="true">
                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <label><strong>Search By Product Name</strong></label>
                            <dxe:ASPxGridLookup ID="productLookUp" runat="server" DataSourceID="ProductDataSource" ClientInstanceName="cproductLookUp"
                                KeyFieldName="Products_ID" Width="800" TextFormatString="{0}" MultiTextSeparator=", " ClientSideEvents-TextChanged="ProductSelected" ClientSideEvents-KeyDown="ProductlookUpKeyDown">
                                <Columns>
                                    <dxe:GridViewDataColumn FieldName="Products_Name" Caption="Name" Width="220">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dxe:GridViewDataColumn>
                                    <dxe:GridViewDataColumn FieldName="IsInventory" Caption="Inventory" Width="60">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dxe:GridViewDataColumn>
                                    <dxe:GridViewDataColumn FieldName="HSNSAC" Caption="HSN/SAC" Width="80">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dxe:GridViewDataColumn>
                                    <dxe:GridViewDataColumn FieldName="ClassCode" Caption="Class" Width="200">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dxe:GridViewDataColumn>
                                    <dxe:GridViewDataColumn FieldName="BrandName" Caption="Brand" Width="100">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dxe:GridViewDataColumn>
                                    <dxe:GridViewDataColumn FieldName="sProducts_isInstall" Caption="Installation Reqd." Width="120">
                                        <Settings AutoFilterCondition="Contains" />
                                    </dxe:GridViewDataColumn>
                                </Columns>
                                <GridViewProperties Settings-VerticalScrollBarMode="Auto">

                                    <Templates>
                                        <StatusBar>
                                            <table class="OptionsTable" style="float: right">
                                                <tr>
                                                    <td>
                                                        <%--  <dxe:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridLookup" />--%>
                                                    </td>
                                                </tr>
                                            </table>
                                        </StatusBar>
                                    </Templates>
                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="true" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                                </GridViewProperties>
                            </dxe:ASPxGridLookup>

                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
                </dxe:ASPxPopupControl>

                <asp:SqlDataSource runat="server" ID="ProductDataSource" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                    SelectCommand="prc_PurchaseIndentDetailsList" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:Parameter Type="String" Name="Action" DefaultValue="ProductDetails" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <%--Batch Product Popup End--%>
            </div>

        </div>
        <div id="DivEdit">
            <dxe:ASPxGridView ID="Grid_PurchaseIndent" runat="server" AutoGenerateColumns="False" OnCustomCallback="Grid_PurchaseIndent_CustomCallback"
                ClientInstanceName="CgvPurchaseIndent" KeyFieldName="Indent_Id" Width="100%" OnCustomButtonInitialize="Grid_PurchaseIndent_CustomButtonInitialize"
                SettingsCookies-Enabled="true" SettingsCookies-StorePaging="true" SettingsBehavior-AllowFocusedRow="true"
                OnHtmlRowPrepared="Grid_PurchaseIndent_HtmlRowPrepared"
                SettingsCookies-StoreFiltering="true" SettingsCookies-StoreGroupingAndSorting="true" DataSourceID="EntityServerModeDataSource">


                <%--  <SettingsSearchPanel Visible="false" />--%>
                <ClientSideEvents CustomButtonClick="CustomButtonClick" />
                <Columns>
                    <dxe:GridViewDataCheckColumn VisibleIndex="0" Visible="false">
                        <EditFormSettings Visible="True" />
                        <EditItemTemplate>
                            <dxe:ASPxCheckBox ID="ASPxCheckBox1" Text="" runat="server"></dxe:ASPxCheckBox>
                        </EditItemTemplate>
                        <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataCheckColumn>
                    <dxe:GridViewDataTextColumn FieldName="Indent_Id" Visible="false" SortOrder="Descending">
                        <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="1" Caption="Requisition No." FieldName="Indent_RequisitionNumber">
                        <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="2" Caption="Date" FieldName="Indent_RequisitionDate">
                        <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                       <%-- <PropertiesTextEdit DisplayFormatString="dd-MM-yyyy"
                            DisplayFormatInEditMode="True">
                        </PropertiesTextEdit>--%>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="3" Caption="Requisition sent From" FieldName="Indent_branch">
                        <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="4" Caption="Requested to Branch" FieldName="Indent_branch_to">
                        <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>

                    <%--<dxe:GridViewDataTextColumn VisibleIndex="5" Caption="Total Amount" FieldName="ValueInBaseCurrency">
                        <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>--%>
                    <%-- <dxe:GridViewDataTextColumn VisibleIndex="6" Caption="Purpose" FieldName="Indent_Purpose">
                        <CellStyle CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>--%>
                    <dxe:GridViewDataTextColumn VisibleIndex="7" Caption="Transfer Out No." FieldName="Stk_TransferNumber">
                        <CellStyle CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="8" Caption="Transfer Date" FieldName="Stk_TransferDate">
                        <CellStyle CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="9" Caption="Pending" FieldName="Pending">
                        <CellStyle CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="10" Caption="Approval Status" FieldName="ApprovalStatus">
                        <CellStyle CssClass="gridcellleft"></CellStyle>
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewCommandColumn VisibleIndex="11" Width="150px" Caption="Actions" ButtonType="Image" HeaderStyle-HorizontalAlign="Center">
                        <CustomButtons>
                            <dxe:GridViewCommandColumnCustomButton ID="CustomBtnView" Text="View" Styles-Style-CssClass="pad">
                                <Image Url="/assests/images/viewIcon.png" ToolTip="View"></Image>
                            </dxe:GridViewCommandColumnCustomButton>
                            <dxe:GridViewCommandColumnCustomButton ID="CustomBtnEdit" Text="Edit" Styles-Style-CssClass="pad">
                                <Image Url="/assests/images/Edit.png" ToolTip="Edit"></Image>
                            </dxe:GridViewCommandColumnCustomButton>
                            <dxe:GridViewCommandColumnCustomButton ID="CustomBtnDelete" Text="Delete">
                                <Image Url="/assests/images/Delete.png" ToolTip="Delete"></Image>
                            </dxe:GridViewCommandColumnCustomButton>
                            <dxe:GridViewCommandColumnCustomButton ID="CustomBtnPrint" Text="Print">
                                <Image Url="/assests/images/Print.png" ToolTip="Print"></Image>
                            </dxe:GridViewCommandColumnCustomButton>
                            <dxe:GridViewCommandColumnCustomButton ID="CustomBtnCancel" Text="Cancel">
                                <Image Url="/assests/images/not-verified.png" ToolTip="Cancel"></Image>
                            </dxe:GridViewCommandColumnCustomButton>
                        </CustomButtons>
                    </dxe:GridViewCommandColumn>

                    <dxe:GridViewDataTextColumn VisibleIndex="12" Visible="false" FieldName="Indent_BranchIdFor">
                    </dxe:GridViewDataTextColumn>
                    <dxe:GridViewDataTextColumn VisibleIndex="13" Visible="false" FieldName="IsCancel">
                    </dxe:GridViewDataTextColumn>
                </Columns>
                <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
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
                ContextTypeName="ERPDataClassesDataContext" TableName="V_BranchRequisitionList" />
            <asp:HiddenField ID="hfIsFilter" runat="server" />
            <asp:HiddenField ID="hfFromDate" runat="server" />
            <asp:HiddenField ID="hfToDate" runat="server" />
            <asp:HiddenField ID="hfBranchID" runat="server" />
            <dxe:ASPxGridViewExporter ID="exporter" runat="server">
            </dxe:ASPxGridViewExporter>
            <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
                <ClientSideEvents ControlsInitialized="AllControlInitilize" />
            </dxe:ASPxGlobalEvents>
            <dxe:ASPxPopupControl ID="Popup_Feedback" runat="server" ClientInstanceName="cPopup_Feedback"
                Width="400px" HeaderText="Reason For Cancel" PopupHorizontalAlign="WindowCenter"
                BackColor="white" Height="100px" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">

                        <div class="Top clearfix">
                            <table style="width: 94%">
                                <tr>
                                    <td>Reason<span style="color: red">*</span></td>
                                    <td class="relative">
                                        <dxe:ASPxMemo ID="txtInstFeedback" runat="server" Width="100%" Height="30px" ClientInstanceName="txtFeedback"></dxe:ASPxMemo>
                                        <span id="MandatoryRemarksFeedback" style="display: none">
                                            <img id="gridHistory_DXPEForm_efnew_DXEFL_DXEditor1234_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                                    </td>
                                </tr>
                                <tr></tr>
                                <tr>
                                    <td colspan="3" style="padding-left: 121px;">
                                        <input id="btnFeedbackSave" class="btn btn-primary" onclick="CallFeedback_save()" type="button" value="Save" />
                                        <input id="btnFeedbackCancel" class="btn btn-danger" onclick="CancelFeedback_save()" type="button" value="Cancel" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </dxe:PopupControlContentControl>
                </ContentCollection>
                <HeaderStyle BackColor="LightGray" ForeColor="Black" />
            </dxe:ASPxPopupControl>
        </div>
        <asp:HiddenField ID="hdnRefreshType" runat="server" />
        <asp:HiddenField ID="hdnEditIndentID" runat="server" />
        <asp:HiddenField ID="hdfIsDelete" runat="server" />
        <asp:HiddenField ID="hdnSchemaType" runat="server" />
        <asp:HiddenField ID="hdnCurrenctId" runat="server" />
        <asp:HiddenField ID="hdnSaveNew" runat="server" />
        <asp:HiddenField ID="hdn_Mode" runat="server" />

        <asp:HiddenField ID="hdnEditClick" runat="server" />
        <asp:SqlDataSource ID="dsBranchTo" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            ConflictDetection="CompareAllValues"
            SelectCommand=""></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsBranch" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            ConflictDetection="CompareAllValues"
            SelectCommand=""></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlSchematype" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select * From ((Select '0' as ID,'Select' as SchemaName) Union (Select ID,SchemaName From tbl_master_Idschema  Where TYPE_ID='16')) as X Order By ID ASC"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select Currency_ID,Currency_AlphaCode from Master_Currency Order By Currency_ID"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlCurrencyBind" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"></asp:SqlDataSource>

        <%-- Sandip Approval Dtl Section Start--%>
        <asp:HiddenField ID="hdngridkeyval" runat="server" />
        <div class="PopUpArea">
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
                                <dxe:ASPxGridView ID="gridPendingApproval" runat="server" KeyFieldName="ID" AutoGenerateColumns="False" OnPageIndexChanged="gridPendingApproval_PageIndexChanged"
                                    Width="100%" ClientInstanceName="cgridPendingApproval" OnCustomCallback="gridPendingApproval_CustomCallback">
                                    <Columns>
                                        <dxe:GridViewDataTextColumn Caption="Branch Requisition No." FieldName="Number"
                                            VisibleIndex="0" FixedStyle="Left">
                                            <CellStyle CssClass="gridcellleft" Wrap="true">
                                            </CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="Created On" FieldName="CreateDate"
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
                                                    <ClientSideEvents CheckedChanged="function (s, e) {ch_fnApproved();}" />
                                                </dxe:ASPxCheckBox>
                                            </DataItemTemplate>
                                            <Settings ShowFilterRowMenu="False" AllowFilterBySearchPanel="False" AllowAutoFilter="False" />
                                        </dxe:GridViewDataCheckColumn>

                                        <dxe:GridViewDataCheckColumn UnboundType="Boolean" Caption="Rejected">
                                            <DataItemTemplate>
                                                <dxe:ASPxCheckBox ID="chkreject" runat="server" AllowGrayed="false" OnInit="chkreject_Init" ValueType="System.Boolean" ValueChecked="true" ValueUnchecked="false">
                                                    <ClientSideEvents CheckedChanged="function (s, e) {ch_fnApproved();}" />
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
                Width="900px" HeaderText="User Wise Purchase Indent Status" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                ContentStyle-CssClass="pad">
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                        <div class="row">
                            <div class="col-md-12">
                                <dxe:ASPxGridView ID="gridUserWiseQuotation" runat="server" KeyFieldName="ID" AutoGenerateColumns="False" OnPageIndexChanged="gridUserWiseQuotation_PageIndexChanged"
                                    Width="100%" ClientInstanceName="cgridUserWiseQuotation" OnCustomCallback="gridUserWiseQuotation_CustomCallback">
                                    <Columns>
                                        <dxe:GridViewDataTextColumn Caption="Branch Requisition No." FieldName="number"
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
        </div>

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
        <%--DEBASHIS--%>

        <%-- Sandip Approval Dtl Section End--%>
        <dxe:ASPxCallbackPanel runat="server" ID="acpAvailableStock" ClientInstanceName="cacpAvailableStock" OnCallback="acpAvailableStock_Callback">
            <PanelCollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </PanelCollection>
            <ClientSideEvents EndCallback="acpAvailableStockEndCall" />
        </dxe:ASPxCallbackPanel>
        <%--UDF Popup --%>
        <dxe:ASPxPopupControl ID="ASPXPopupControl1" runat="server"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="cUDFpopup" Height="630px"
            Width="600px" HeaderText="Add/Modify UDF" Modal="true" AllowResize="true" ResizingMode="Postponed">

            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                </dxe:PopupControlContentControl>
            </ContentCollection>
        </dxe:ASPxPopupControl>
        <asp:HiddenField runat="server" ID="IsUdfpresent" />
        <asp:HiddenField runat="server" ID="Keyval_internalId" />
        <asp:HiddenField ID="hddnKeyValue" runat="server" />
        <asp:HiddenField ID="hddnIsSavedFeedback" runat="server" />
        <%--UDF Popup End--%>
        <dxe:ASPxCallbackPanel runat="server" ID="acbpCrpUdf" ClientInstanceName="cacbpCrpUdf" OnCallback="acbpCrpUdf_Callback">
            <PanelCollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </PanelCollection>
            <ClientSideEvents EndCallback="acbpCrpUdfEndCall" />
        </dxe:ASPxCallbackPanel>
        <dxe:ASPxLoadingPanel ID="LoadingPanelCRP" runat="server" ClientInstanceName="cLoadingPanelCRP" ContainerElementID="divSubmitButton"
            Modal="True">
        </dxe:ASPxLoadingPanel>
    </div>
    
</asp:Content>
