﻿<%@ Page Title="Purchase Invoice for transporter" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" EnableEventValidation="false"
    AutoEventWireup="true" CodeBehind="PurchaseInvoiceforTransporter.aspx.cs" Inherits="ERP.OMS.Management.Activities.PurchaseInvoiceforTransporter" %>

<%@ Register Src="~/OMS/Management/Activities/UserControls/VehicleDetailsControl.ascx" TagPrefix="uc1" TagName="VehicleDetailsControl" %>
<%@ Register Src="~/OMS/Management/Activities/UserControls/BillingShippingControl.ascx" TagPrefix="ucBS" TagName="BillingShippingControl" %>
<%@ Register Src="~/OMS/Management/Activities/UserControls/TermsConditionsControl.ascx" TagPrefix="uc2" TagName="TermsConditionsControl" %>

 <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .inline {
            display: inline !important;
        }
        /*a:first-child*/
        .statusBar {
            display: none;
        }

        .dxtcLite_PlasticBlue.dxtc-top > .dxtc-content {
            overflow: visible !important;
        }

        strong .dxeBase_PlasticBlue {
            font-weight: 700 !important;
        }

        .abs {
            position: absolute;
            right: -20px;
            top: 10px;
        }

        .fa.fa-exclamation-circle:before {
            font-family: FontAwesome;
        }

        .tp2 {
            right: -18px;
            top: 7px;
            position: absolute;
        }

        #txtCreditLimit_EC {
            position: absolute;
        }

        #grid_DXStatus span > a {
            display: none;
        }

        #aspxGridTax_DXEditingErrorRow0 {
            display: none;
        }

        .horizontal-images.content li {
            float: left;
        }

        #rdl_SaleInvoice {
            margin-top: 3px;
        }

            #rdl_SaleInvoice > tbody > tr > td {
                padding-right: 5px;
            }
    </style>

    <style>
        .bod-table {
            width: 100%;
            border-radius: 5px;
        }

            .bod-table > tbody > tr > td {
                padding: 5px;
                background: #c2d8e6;
                font-weight: 500;
            }

            .bod-table.none > tbody > tr > td {
                background: none;
            }

        .bac {
            background: #c2d8e6;
            margin: 10px 0;
            padding: 2px 15px;
            border-radius: 5px;
        }

        .greyd {
            background: #ececec;
            margin: 10px 0;
            padding: 0px 15px;
            border-radius: 5px;
        }

        .newLbl .lblHolder table tr:first-child td {
            background: #2bb1bf;
        }

        table.pad > tbody > tr > td {
            padding: 0px 10px;
        }

        section.rds {
            margin-top: 25px;
            border: 1px solid #ccc;
            padding: 3px 15px;
        }

        span.fieldsettype {
            background: #1671b7;
            padding: 8px 10px;
            color: #fff;
            position: relative;
            top: -10px;
            z-index: 5;
        }

            span.fieldsettype::before {
                content: "";
                border-left: 9px solid transparent;
                border-right: 9px solid transparent;
                border-bottom: 13px solid #184d75;
                position: absolute;
                right: -9px;
                z-index: -1;
            }

        .horizontallblHolder {
            height: auto;
            border: 1px solid #12a79b;
            border-radius: 3px;
            overflow: hidden;
        }

            .horizontallblHolder > table > tbody > tr > td {
                padding: 8px 10px;
                background: #ffffff;
                background: -moz-linear-gradient(top, #ffffff 0%, #f3f3f3 50%, #ededed 51%, #ffffff 100%);
                background: -webkit-linear-gradient(top, #ffffff 0%,#f3f3f3 50%,#ededed 51%,#ffffff 100%);
                background: linear-gradient(to bottom, #ffffff 0%,#f3f3f3 50%,#ededed 51%,#ffffff 100%);
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#ffffff',GradientType=0 );
            }

                .horizontallblHolder > table > tbody > tr > td:first-child {
                    background: #12a79b;
                    color: #fff;
                }

                .horizontallblHolder > table > tbody > tr > td:last-child {
                    font-weight: 500;
                    text-transform: uppercase;
                    color: #121212;
                }
    </style>
    <script src="../../Tax%20Details/Js/TaxDetailsItemlevel.js" type="text/javascript">

    </script>

    <script type="text/javascript">
        function specialedit_ButtonClick() {
            flag = true;
            var invtype = $('#ddlInventory').val();
            if (invtype != 'N') {
                if (ctxt_partyInvNo.GetText() == '' || ctxt_partyInvNo.GetText() == null) {
                    flag = false;
                    $("#MandatorysPartyinvno").show();
                    LoadingPanel.Hide();
                    return false;
                }
            }
            // Invoice Date validation Start
            var sdate = cdt_partyInvDt.GetValue();
            var edate = cPLQuoteDate.GetValue();
            var startDate = new Date(sdate);
            var endDate = new Date(edate);
            if (invtype == 'N') {
                if (sdate == null || sdate == "") {
                }
                else {
                    $('#MandatoryPartyDate').attr('style', 'display:none');

                    if (startDate > endDate) {
                        LoadingPanel.Hide();
                        flag = false;
                        $('#MandatoryEgSDate').attr('style', 'display:block');
                    }
                    else {
                        $('#MandatoryEgSDate').attr('style', 'display:none');
                        flag = true;
                    }
                }
            }
            else if (invtype != 'N') {
                if (sdate == null || sdate == "") {
                    flag = false;
                    $('#MandatoryPartyDate').attr('style', 'display:block');
                    LoadingPanel.Hide();
                    return false;
                }
                else {
                    $('#MandatoryPartyDate').attr('style', 'display:none');

                    if (startDate > endDate) {
                        LoadingPanel.Hide();
                        return false;
                        flag = false;
                        $('#MandatoryEgSDate').attr('style', 'display:block');
                    }
                    else {
                        $('#MandatoryEgSDate').attr('style', 'display:none');
                        flag = true;
                    }
                }
            }
            if (flag == true) {
                cpartyInvoicepanel.PerformCallback('SpecialEdit');
            }
        }
        //function VendorFilterEndCallBack() {
        //    gridLookup.GetGridView().Refresh();
        //}
        function GlobalBillingShippingEndCallBack() {
            if (cbsComponentPanel.cpGlobalBillingShippingEndCallBack_Edit == "0") {
                cbsComponentPanel.cpGlobalBillingShippingEndCallBack_Edit = "0";
                var invtype = $('#ddlInventory').val();
                var startDate = new Date();
                startDate = cPLQuoteDate.GetDate().format('yyyy/MM/dd');
                var branchid = $('#ddl_Branch').val();
                // For Checking Shipping AddressOfVendor
                var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                if (gridquotationLookup.GetValue() != null) {
                    cContactPerson.PerformCallback('BindContactPerson~' + key + '~' + branchid);
                    var startDate = new Date();
                    startDate = cPLQuoteDate.GetDate().format('yyyy/MM/dd');
                    cQuotationComponentPanel.PerformCallback('DateCheckOnChanged' + '~' + key + '~' + startDate + '~' + '@');
                    if (key != null && key != '') {
                        var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                        //cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type);
                        cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type + '~' + invtype);

                    }
                    grid.PerformCallback('GridBlank');
                    ccmbGstCstVat.PerformCallback();
                    ccmbGstCstVatcharge.PerformCallback();
                    ctaxUpdatePanel.PerformCallback('DeleteAllTax');
                }
                else {
                    var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                    if (key != null && key != '') {
                        cContactPerson.PerformCallback('BindContactPerson~' + key + '~' + branchid);
                    }
                }
            }
        }
    </script>

    <%--// Running Balance Calculation--%>
    <script>


        function partyInvDtMandatorycheck() {
            var invtype = $('#ddlInventory').val();
            if (invtype != 'N') {
                var Podt = cdt_partyInvDt.GetValue();
                if (Podt != null) {
                    $('#MandatoryPartyDate').attr('style', 'display:none');
                    var sdate = cdt_partyInvDt.GetValue();
                    var edate = cPLQuoteDate.GetValue();

                    var startDate = new Date(sdate);
                    var endDate = new Date(edate);
                    if (startDate > endDate) {
                        //LoadingPanel.Hide();
                        //flag = false;
                        $('#MandatoryEgSDate').attr('style', 'display:block');
                    }
                    else { $('#MandatoryEgSDate').attr('style', 'display:none'); }
                }
                else {
                    $('#MandatoryPartyDate').attr('style', 'display:none');
                }


            }
            else {

            }

        }
        function DuplicatePartyNo() {

            var invtype = $('#ddlInventory').val();
            var partyno = '';
            if (invtype != 'N') {
                var PBid = ''
                var partyno = ctxt_partyInvNo.GetText();

                if (partyno != null && partyno != '') {
                    $("#MandatorysPartyinvno").hide();
                }
                else {
                    $("#MandatorysPartyinvno").show();
                }

                var vendorid = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
                if (vendorid != null && vendorid != '') {

                    if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                        mode = 'A'
                    }
                    else {
                        mode = 'E'
                        PBid = "<%=Convert.ToString(Session["PurchaseInvoice_Id"])%>"
                    }
                    $.ajax({
                        type: "POST",
                        url: "PurchaseInvoiceforTransporter.aspx/CheckUniquePartyNo",
                        data: JSON.stringify({ vendorid: vendorid, partyno: partyno, mode: mode, PBid: PBid }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,
                        success: function (msg) {
                            var data = msg.d;

                            if (data == true) {
                                $("#DuplicatePartyinvno").show();
                                ctxt_partyInvNo.SetText('');
                                ctxt_partyInvNo.Focus();
                                //document.getElementById("txtVoucherNo").value = '';
                                //document.getElementById("txtVoucherNo").focus();
                            }
                            else {
                                $("#DuplicatePartyinvno").hide();
                            }
                        }
                    });

                }
            }
            else {
                $("#MandatorysPartyinvno").hide();
            }
        }
    </script>

    <script>
        var Pre_Quantity = "0";
        var Pre_Amt = "0";
        var Pre_TotalAmt = "0";
        var Cur_Quantity = "0";
        var Cur_Amt = "0";
        var Cur_TotalAmt = "0";

        function CalculateAmount() {
            var Quantity = (parseFloat((cTotalQty.GetValue()).toString())).toFixed(2);
            var Amount = (parseFloat((cTaxableAmtval.GetValue()).toString())).toFixed(2);
            var TotalAmount = (parseFloat((cInvValue.GetValue()).toString())).toFixed(2);
            var ChargesAmount = (ctxt_Charges.GetValue() != null) ? (parseFloat(ctxt_Charges.GetValue())).toFixed(2) : "0";

            var Calculate_Quantity = (parseFloat(Quantity) + parseFloat(Cur_Quantity) - parseFloat(Pre_Quantity)).toFixed(2);
            var Calculate_Amount = (parseFloat(Amount) + parseFloat(Cur_Amt) - parseFloat(Pre_Amt)).toFixed(2);
            var Calculate_TotalAmount = (parseFloat(TotalAmount) + parseFloat(Cur_TotalAmt) - parseFloat(Pre_TotalAmt)).toFixed(2);
            var Calculate_TaxAmount = (parseFloat(Calculate_TotalAmount) - parseFloat(Calculate_Amount)).toFixed(2);
            var Calculate_SumAmount = (parseFloat(Calculate_TotalAmount) + parseFloat(ChargesAmount)).toFixed(2);

            cTotalQty.SetValue(Calculate_Quantity);
            cTaxableAmtval.SetValue(Calculate_Amount);
            cTaxAmtval.SetValue(Calculate_TaxAmount);
            cOtherTaxAmtval.SetValue(ChargesAmount);
            cInvValue.SetValue(Calculate_TotalAmount);
            cTotalAmt.SetValue(Calculate_SumAmount);
        }

    </script>

    <script>
        $(document).ready(function () {
            $('.number').keypress(function (event) {
                if (event.which < 46 || event.which > 59) {
                    event.preventDefault();
                } // prevent if not number/dot

                if (event.which == 46 && $(this).val().indexOf('.') != -1) {
                    event.preventDefault();
                } // prevent if already dot
            });
        });
    </script>

    <script>
        var PreviousCurrency = "1";
        function GetPreviousCurrency() {
            PreviousCurrency = ctxtRate.GetValue();
        }

        function OnAddNewClick_Default() {
            grid.AddNewRow();

            var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var tbQuotation = grid.GetEditor("SrlNo");
            tbQuotation.SetValue(noofvisiblerows);
        }

        function showhide(obj) {
            alert(obj);
            if (obj == 'Y') {
                $('#divselectunselect').addClass('hide');
            }
            else {
                $('#divselectunselect').removeClass('hide');
            }
        }
        function GridProductBind(e) {
            var invtype = $('#ddlInventory').val();
            //cproductLookUp.GetGridView().Refresh();
            cproductPanel.PerformCallback(invtype);






            //var schemeid = cddl_TdsScheme.GetValue();
            //if (schemeid != '0')
            //{
            //    cproductLookUp.GetGridView().Refresh();
            //}
            //else
            //{
            //    jAlert('Select a TDS Section');
            //    return;
            //}


            //CApplicableAmtPopup.PerformCallback('BindProductForNonInvItem')
        }

        function cproductPanelEndCallBack() {
            cproductLookUp.GetGridView().Refresh();
        }
    </script>
    <script>

        $(document).ready(function () {
            var mode = $('#<%=hdnADDEditMode.ClientID %>').val();
            if (mode == 'Edit') {
                //var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                //$("[id$='rdl_PurchaseInvoice']").attr("disabled", "disabled");
                $("#<%=rdl_PurchaseInvoice.ClientID %>").find('input').prop('disabled', true);
                if ($('#<%=hdnTDSShoworNot.ClientID %>').val() == 'S') {
                    $('#divTdsScheme').removeClass('hide');
                }
                else if ($('#<%=hdnTDSShoworNot.ClientID %>').val() == 'H') {
                    $('#divTdsScheme').addClass('hide');
                }

            }
            else {
                $("#<%=rdl_PurchaseInvoice.ClientID %>").find('input').prop('disabled', false);
            }
            //GetIndentReqNoOnLoad();
        })



        // To set lookup quotation false if PC tagging is available by Sam on 10062017 Start 

        function DisableDeleteOption(s, e) {
            var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
            if (type == 'PO' || type == 'PC') {
                var objTxtBox = window.event.srcElement;
                // declare the variable for the bool value.
                var isOk = false;
                // Here we need not backspace keycode = 8 and the delete keycode 46
                isOk = (event.keyCode == 8 || event.keyCode == 46) ? false : true;
                event.keyCode = (!isOk) ? 0 : event.keyCode;

            }
        }
        // To set lookup quotation false if PC tagging is available by Sam on 10062017 END 
    </script>
    <%-- UDF and Transport Section Start--%>
    <script>
        var canCallBack = true;
        function AllControlInitilize() {
            if (canCallBack) {
                if ($('#hdnADDEditMode').val() == 'Edit') {

                    cchk_reversemechenism.SetEnabled(false);

                    if (cchk_reversemechenism.GetValue()) {
                        $('#divreverse').removeClass('hide');
                        grid.GetEditor('TaxAmount').SetEnabled(false);
                    }

                }

                canCallBack = false;
            }
        }

        function acbpCrpUdfEndCall(s, e) {


            //if (cacbpCrpUdf.cpUDF) {
            var result = 0;
            if (cacbpCrpUdf.cpUDF == "true") {
                result = 1;
                //grid.batchEditApi.StartEdit(0, 5);
                //grid.UpdateEdit();
                //cacbpCrpUdf.cpUDF = null;
                //cacbpCrpUdf.cpTransport = null;
                //cacbpCrpUdf.cpTC = null;
            }
            else {
                jAlert("UDF is set as Mandatory. Please enter values.", "Alert", function () { OpenUdf(); });
                cacbpCrpUdf.cpUDF = null;
                cacbpCrpUdf.cpTransport = null;
                cacbpCrpUdf.cpTC = null;
                LoadingPanel.Hide();
                $('#<%=hdnRefreshType.ClientID %>').val('');
                result = 0;
                return;
            }

            if (cacbpCrpUdf.cpTransport == "true") {
                result = 1;
            }
            else {
                jAlert("Transporter is set as Mandatory. Please enter values.", "Alert", function () { $("#exampleModal").modal('show'); });
                cacbpCrpUdf.cpUDF = null;
                cacbpCrpUdf.cpTransport = null;
                cacbpCrpUdf.cpTC = null;
                LoadingPanel.Hide();
                $('#<%=hdnRefreshType.ClientID %>').val('');
                result = 0;
                return;
            }
            var invtype = $('#ddlInventory').val();
            if (invtype != 'N') {
                if (cacbpCrpUdf.cpTC == "true") {
                    result = 1;
                }
                else {
                    jAlert("Terms and Condition is set as Mandatory. Please enter values.", "Alert", function () { $("#TermsConditionseModal").modal('show'); });
                    cacbpCrpUdf.cpUDF = null;
                    cacbpCrpUdf.cpTransport = null;
                    cacbpCrpUdf.cpTC = null;
                    LoadingPanel.Hide();
                    $('#<%=hdnRefreshType.ClientID %>').val('');
                    result = 0;
                    return;
                }
            }
            else {
                result = 1;
            }


            if (cacbpCrpUdf.cpPartyno == "N") {
                result = 1;
            }
            else {
                jAlert("Party Invoice No. already exist for the selected vendor.", "Alert", function () { });
                cacbpCrpUdf.cpUDF = null;
                cacbpCrpUdf.cpTransport = null;
                cacbpCrpUdf.cpTC = null;
                LoadingPanel.Hide();
                $('#<%=hdnRefreshType.ClientID %>').val('');
                result = 0;
                return;
            }

            if (cacbpCrpUdf.cpStateId == "Y") {
                result = 1;
                FinalSaveUpdate();
            }
            else {

                LoadingPanel.Hide();
                var messege = 'Vendor' + "'s " + 'shipping address not exist.GST/Reverse charges not to be calculated.Proceed?';
                //var r= jConfirm(messege, 'Confirmation Dialog', function (r) {
                jConfirm(messege, 'Confirmation Dialog', function (r) {
                    if (r == true) {
                        result = 1;
                        FinalSaveUpdate();
                    }
                    else {
                        result = 0;
                        $('#<%=hdnRefreshType.ClientID %>').val('');
                    }
                    cacbpCrpUdf.cpStateId = null;

                    //result = 0;
                    return;
                });
            }

            //if (result == 1) {
            //grid.batchEditApi.StartEdit(0, 5);
            //$("#loading").fadeIn();
            //OnAddNewClick_Default();
            //grid.UpdateEdit();
            //cacbpCrpUdf.cpUDF = null;
            //cacbpCrpUdf.cpTransport = null;
            //cacbpCrpUdf.cpTC = null;
            //}

        }

        function FinalSaveUpdate() {
            OnAddNewClick_Default();
            grid.UpdateEdit();
            cacbpCrpUdf.cpUDF = null;
            cacbpCrpUdf.cpTransport = null;
            cacbpCrpUdf.cpTC = null;
        }
        //}

        function gridFocusedRowChanged(s, e) {
            globalRowIndex = e.visibleIndex;
        }


    </script>
    <%--UDF and Transport Section End--%>
    <style type="text/css">
        .inline {
            display: inline !important;
        }

        .dxtcLite_PlasticBlue.dxtc-top > .dxtc-content {
            overflow: visible !important;
        }


        #DivBilling [class^="col-md"], #DivShipping [class^="col-md"] {
            padding-top: 5px;
            padding-bottom: 5px;
        }


        .voucherno {
            position: absolute;
            right: -3px;
            top: 22px;
        }

        .POVendor {
            position: absolute;
            right: -3px;
            top: 22px;
        }

        .abs {
            position: absolute;
            right: -20px;
            top: 10px;
        }

        .fa.fa-exclamation-circle:before {
            font-family: FontAwesome;
        }

        .tp2 {
            right: -18px;
            top: 7px;
            position: absolute;
        }

        #txtCreditLimit_EC {
            position: absolute;
        }

        #grid_DXStatus span > a {
            display: none;
        }

        .dxgvControl_PlasticBlue td.dxgvBatchEditModifiedCell_PlasticBlue {
            background: #fff !important;
        }

        .absolute, #grid_DXMainTable .dxeErrorFrameSys.dxeErrorCellSys {
            position: absolute;
        }

        .col-md-3 > label, .col-md-3 > span {
            margin-top: 0px;
            display: inline-block;
        }

        #grid_DXMainTable > tbody > tr > td:last-child {
            display: none !important;
        }

        #aspxGridTax_DXStatus {
            display: none !important;
        }

        .mTop {
            margin-top: 10px;
        }
    </style>




    <script>

        function HideSelectAllSection() {
            if (cgridproducts.cpSelectHide != null) {
                if (cgridproducts.cpSelectHide == 'Y') {
                    //cgridproducts.SetEnabled(false);
                    $('#divselectunselect').addClass('hide')

                }
                else if (cgridproducts.cpSelectHide == 'N') {
                    //cgridproducts.SetEnabled(true);
                    $('#divselectunselect').removeClass('hide')
                }
                else {
                    $('#divselectunselect').removeClass('hide')
                }
                cgridproducts.cpSelectHide == null;
            }
        }

        <%--Div Detail for Vendor Section Start--%>
        function acpContactPersonPhoneEndCall(s, e) {
            if (cacpContactPersonPhone.cpPhone != null && cacpContactPersonPhone.cpPhone != undefined) {
                pageheaderContent.style.display = "block";
                $("#<%=divContactPhone.ClientID%>").attr('style', 'display:block');
                document.getElementById('<%=lblContactPhone.ClientID %>').innerHTML = cacpContactPersonPhone.cpPhone;
                cacpContactPersonPhone.cpPhone = null;

            }
            else {
                $("#<%=divContactPhone.ClientID%>").attr('style', 'display:none');
                document.getElementById('<%=lblContactPhone.ClientID %>').innerHTML = '';
                cacpContactPersonPhone.cpPhone = null;
            }
        }

        function GetContactPersonPhone(e) {
            var key = cContactPerson.GetValue();
            cacpContactPersonPhone.PerformCallback('ContactPersonPhone~' + key);
        }

        function cmbContactPersonEndCall(s, e) {

            if (cContactPerson.cpContactdtl != null && cContactPerson.cpContactdtl != undefined) {
                if (cContactPerson.cpContactdtl == 'Y') {
                    $("#<%=pageheaderContent.ClientID%>").attr('style', 'display:block');
                    $("#<%=divContactPhone.ClientID%>").attr('style', 'display:block');
                    <%--document.getElementById('<%=lblContactPhone.ClientID %>').innerHTML = cacpContactPersonPhone.cpPhone;--%>
                }
                else {
                    $("#<%=divContactPhone.ClientID%>").attr('style', 'display:none');
                    document.getElementById('<%=lblContactPhone.ClientID %>').innerHTML = '';
                }
                cContactPerson.cpContactdtl = null;
            }
            else {
                $("#<%=divContactPhone.ClientID%>").attr('style', 'display:none');
                document.getElementById('<%=lblContactPhone.ClientID %>').innerHTML = '';
            }

            //if (cContactPerson.cpDueDate != null) {
            //    var DeuDate = cContactPerson.cpDueDate;
            //    var myDate = new Date(DeuDate);

            //    cdt_SaleInvoiceDue.SetDate(myDate);
            //    cContactPerson.cpDueDate = null;
            //}

            if ((cContactPerson.cpGSTN != null && cContactPerson.cpGSTN != undefined) &&
                (cContactPerson.cpvendortype != null && cContactPerson.cpvendortype != undefined)) {
                $("#<%=pageheaderContent.ClientID%>").attr('style', 'display:block');
                $("#<%=divGSTN.ClientID%>").attr('style', 'display:block');
                document.getElementById('<%=lblGSTIN.ClientID %>').innerHTML = cContactPerson.cpGSTN + ' (' + cContactPerson.cpvendortype + ')';
                if (cContactPerson.cpGSTN == 'Yes' && cContactPerson.cpvendortype == 'Regular') {
                    var invtype = $('#ddlInventory').val();
                    if (invtype == 'Y') {

                        $('#rdlbutton').removeClass('hide');
                        $('#rdldate').removeClass('hide');
                    }
                    else if (invtype == 'N') {

                        $('#rdlbutton').addClass('hide');
                        $('#rdldate').addClass('hide');
                    }

                    <%--var RB = document.getElementById("<%=rdl_PurchaseInvoice.ClientID%>");
                    if (RB.rows.length > 0) {
                        for (i = 0; i < RB.rows.length; i++) {
                            var cell = RB.rows[i].cells;
                            for (j = 0; j < cell.length; j++) {
                                if (cell[j].childNodes[0].type == "radio") {
                                    document.getElementById(cell[j].childNodes[0].id).checked = true;
                                }
                            }
                        }
                    }--%>
                    // $('#chk_reversemechenism').attr('checked', false);
                    cchk_reversemechenism.SetValue(false);
                    $('#divreverse').addClass('hide');

                    //$('#chk_reversemechenism').attr('visible', false);
                    cddl_AmountAre.SetValue(1);
                    PopulateGSTCSTVAT();
                    cddl_AmountAre.SetEnabled(true);


                }
                else if (cContactPerson.cpGSTN == 'Yes' && cContactPerson.cpvendortype == 'Composite') {
                    var invtype = $('#ddlInventory').val();
                    if (invtype == 'Y') {

                        $('#rdlbutton').removeClass('hide');
                        $('#rdldate').removeClass('hide');
                    }
                    else if (invtype == 'N') {

                        $('#rdlbutton').addClass('hide');
                        $('#rdldate').addClass('hide');
                    }
                    cchk_reversemechenism.SetValue(false);
                    $('#divreverse').addClass('hide');
                    cddl_AmountAre.SetValue(3);
                    PopulateGSTCSTVAT();
                    cddl_AmountAre.SetEnabled(false);
                }

                else {




                    //$('#rdlbutton').addClass('hide');
                    //$('#rdldate').addClass('hide');
                    <%--var RB = document.getElementById("<%=rdl_PurchaseInvoice.ClientID%>");
                    if (RB.rows.length > 0) {
                        for (i = 0; i < RB.rows.length; i++) {
                            var cell = RB.rows[i].cells;
                            for (j = 0; j < cell.length; j++) {
                                if (cell[j].childNodes[0].type == "radio") {
                                    document.getElementById(cell[j].childNodes[0].id).checked = false;
                                }
                            }
                        }
                    }--%>
                    //$('#chk_reversemechenism').attr('checked', true);

                    //cchk_reversemechenism.SetValue(true);
                    //cchk_reversemechenism.SetEnabled(false)
                    ////$('#chk_reversemechenism').attr('enabled', false);
                    $('#divreverse').removeClass('hide');
                    //cddl_AmountAre.SetValue(3);
                    if (cContactPerson.cpcountry != null && cContactPerson.cpcountry != '') {
                        if (cContactPerson.cpcountry != '1') {
                            cchk_reversemechenism.SetValue(false);
                            cchk_reversemechenism.SetEnabled(false)
                            $('#rdlbutton').removeClass('hide');
                            $('#rdldate').removeClass('hide');

                            cddl_AmountAre.SetValue(4);
                            cContactPerson.cpcountry == null
                        }
                        else {
                            $('#rdlbutton').addClass('hide');
                            $('#rdldate').addClass('hide');

                            cchk_reversemechenism.SetValue(true);
                            cchk_reversemechenism.SetEnabled(false)
                            cddl_AmountAre.SetValue(3);
                            cContactPerson.cpcountry == null
                        }

                    }
                    else {
                        $('#rdlbutton').addClass('hide');
                        $('#rdldate').addClass('hide');
                        cchk_reversemechenism.SetValue(true);
                        cchk_reversemechenism.SetEnabled(false)
                        cddl_AmountAre.SetValue(3);
                        cContactPerson.cpcountry == null
                    }
                    PopulateGSTCSTVAT();
                    cddl_AmountAre.SetEnabled(false);

                }

            cContactPerson.cpGSTN = null;


        }
        else {
            $("#<%=divGSTN.ClientID%>").attr('style', 'display:none');
                document.getElementById('<%=lblGSTIN.ClientID %>').innerHTML = '';
                cContactPerson.cpGSTN = null;
            }


            if (cContactPerson.cpOutstanding != null && cContactPerson.cpOutstanding != undefined) {
                //alert(cContactPerson.cpOutstanding);

                $("#<%=pageheaderContent.ClientID%>").attr('style', 'display:block');
                // pageheaderOutContent.style.display = "block";

                $("#<%=divOutstanding.ClientID%>").attr('style', 'display:block');
                document.getElementById('<%=lblOutstanding.ClientID %>').innerHTML = cContactPerson.cpOutstanding;

                cContactPerson.cpOutstanding = null;
            }
            else {
                <%--$("#<%=pageheaderContent.ClientID%>").attr('style', 'display:none');--%>
                //pageheaderOutContent.style.display = "none";
                $("#<%=divOutstanding.ClientID%>").attr('style', 'display:none');
                document.getElementById('<%=lblOutstanding.ClientID %>').innerHTML = '';
            }


        }

        <%--Div Detail for Vendor Section End--%>

         <%--Inventory Item Section Start--%>
        function ddlInventory_OnChange() {
            var invtype = $('#ddlInventory').val();
            if (invtype == 'N') {
                $("#MandatorysPartyinvno").hide();
                $("#MandatoryPartyDate").hide();

                var val = $("#ddl_numberingScheme").val();

                var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                //geet
                //if (schemabranch != '' && schemabranch != undefined ) {
                //    cddl_noninventoryBranch.PerformCallback(schemabranch);
                //}
                //else {
                //    cddl_noninventoryBranch.PerformCallback('0');
                //}
                //geet
                //$('#divreverse').addClass('hide');
                $('#divTdsScheme').removeClass('hide');
                $('#rdlbutton').addClass('hide');
                $('#rdldate').addClass('hide');
                //cddl_TdsScheme.PerformCallback('BindScheme');
            }
            else {
                //$('#divreverse').removeClass('hide');
                $('#divTdsScheme').addClass('hide');
                $('#rdlbutton').removeClass('hide');
                $('#rdldate').removeClass('hide');
                selectValue();
            }
            var val = $("#ddl_numberingScheme").val();

            var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];

            if (val != '0') {
                cvendorPanel.PerformCallback(schemabranch)
            }
            else {
                cvendorPanel.PerformCallback('<%=Session["userbranchID"]%>')
            }
            //gridLookup.GetGridView().Refresh();
            //var strInventory = document.getElementById('ddlInventory').value; 

            cproductLookUp.GetGridView().Refresh();
            cproductPanel.PerformCallback(invtype);

            //cgridinventory.PerformCallback('0~0~BindAllDropDown')
        }
        <%--Inventory Item Section End--%>
    </script>


    <script type="text/javascript">
        var globalRowIndex;
        var rowEditCtrl;

        var ProductGetQuantity = "0";
        var ProductGetTotalAmount = "0";
        var ProductPurchaseprice = "0";
        var ProductDiscount = "0";
        var ProductDiscountAmt = "0";
        var ProductGrsAmt = "0";



        // Running Calculation As New Modification
        var globalNetAmount = 0;
        //var globalGrossAmt = 0;
        //var globaltaxAmt = 0;

        //function SetInvoiceLebelValue() { 
        //    var invValue = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) 
        //    cbnrLblInvValue.SetValue(parseFloat(Math.round(Math.abs(invValue) * 100) / 100).toFixed(2)); 
        //    SetRunningBalance(); 
        //}
        //function SetRunningBalance() {
        //    var paymentValue = 0; 
        //    var InvoiceValue = parseFloat(cbnrLblInvValue.GetValue()); 
        //    var runningBalance = 0;
        //    runningBalance = parseFloat(Math.round((InvoiceValue) * 100) / 100).toFixed(2); 
        //    if (runningBalance < 0) {
        //        runningBalance = 0.00;
        //    } 
        //    clblRunningBalanceCapsul.SetValue(runningBalance);
        //}
        function DiscountGotChange() {
            globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
            ProductGetTotalAmount = globalNetAmount;

            ProductDiscount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";
            ProductGetQuantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            ProductPurchaseprice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";

            // Running total Calculation Start

            Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

            // Running total Calculation End
        }



        function DiscountAmtGotChange() {


            globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
            ProductGetTotalAmount = globalNetAmount;


            ProductGetQuantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            ProductPurchaseprice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
            ProductDiscount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";
            ProductDiscountAmt = (grid.GetEditor('Discountamt').GetValue() != null) ? grid.GetEditor('Discountamt').GetValue() : "0";

            // Running total Calculation Start

            Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

            // Running total Calculation End
        }

        function AmtGotFocus() {
            globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
            ProductGetTotalAmount = globalNetAmount;

            ProductGetQuantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            ProductPurchaseprice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
            ProductDiscount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";
            ProductDiscountAmt = (grid.GetEditor('Discountamt').GetValue() != null) ? grid.GetEditor('Discountamt').GetValue() : "0";
            ProductGrsAmt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";

            // Running total Calculation Start

            Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

            // Running total Calculation End
        }

        // Running Calculation As New Modification


        // To set Quantity column false if tagging is available by Sam on 10062017 Start   
        function QuantityGotFocus(s, e) {




            var taxqty = grid.GetEditor("Quantity").GetValue();
            $('#<%=hdntaxqty.ClientID %>').val(taxqty);
            var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
            if (type == 'PC') {
                grid.GetEditor("Quantity").SetEnabled(false);

            }
            else {
                grid.GetEditor("Quantity").SetEnabled(true);
            }
            //var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            ProductGetQuantity = QuantityValue;
            globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());


            // Running total Calculation Start

            Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

            // Running total Calculation End
        }
        // To set Quantity column false if tagging is available by Sam on 10062017 End

        function PurPriceGotFocus() {
            ProductPurchaseprice = grid.GetEditor("PurchasePrice").GetValue();


            globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
            // Running total Calculation Start

            Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

            // Running total Calculation End


        }




        //............................Product Pazination..............
        function ChangeState(value) {

            cgridproducts.PerformCallback('SelectAndDeSelectProducts' + '~' + value);
        }
        function ctaxUpdatePanelEndCall(s, e) {
            if (ctaxUpdatePanel.cpstock != null) {
                divAvailableStk.style.display = "block";
                // divpopupAvailableStock.style.display = "block";

                var AvlStk = ctaxUpdatePanel.cpstock + " " + document.getElementById('<%=lblStkUOM.ClientID %>').innerHTML;
                document.getElementById('<%=lblAvailableStkPro.ClientID %>').innerHTML = AvlStk;
                document.getElementById('<%=lblAvailableStk.ClientID %>').innerHTML = ctaxUpdatePanel.cpstock;

                ctaxUpdatePanel.cpstock = null;
                grid.batchEditApi.StartEdit(globalRowIndex, 5);
            }

            return false;
        }
        function ProductsGotFocusFromID(s, e) {
            var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
            //var vendorid = GetObjectID('hdnCustomerId').value


            //var inventoryItem = $('#ddlInventory').val();
            //if (inventoryItem == 'N') {
            //var schemeid = cddl_TdsScheme.GetValue();
            //{
            //    if(schemeid=="0")
            //    {
            //        jAlert('Select a Scheme first')
            //        cddl_TdsScheme.Focus();
            //        return;
            //    }
            //}
            if ($('#txtVoucherNo').val() == '' || $('#txtVoucherNo').val() == null) {
                jAlert('Select a numbering schema first.')
                $('#ddl_numberingScheme').focus();
                return false;
            }

            else if (customerval == '' || customerval == null || customerval == "") {

                jAlert('Select a Vendor first')
                gridLookup.Focus();
                return false;
            }
                //}
            else {
                pageheaderContent.style.display = "block";
                var ProductID = (grid.GetEditor('ProductID').GetValue() != null) ? grid.GetEditor('ProductID').GetValue() : "0";
                var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
                //var ProductID = (cCmbProduct.GetValue() != null) ? cCmbProduct.GetValue() : "0";
                //var strProductName = (cCmbProduct.GetText() != null) ? cCmbProduct.GetText() : "0";

                var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";

                var ddlbranch = $("[id*=ddl_Branch]");
                var strBranch = ddlbranch.find("option:selected").text();

                var SpliteDetails = ProductID.split("||@||");
                var strProductID = SpliteDetails[0];
                var strDescription = SpliteDetails[1];
                var strUOM = SpliteDetails[2];
                var strStkUOM = SpliteDetails[4];
                var strSalePrice = SpliteDetails[6];
                var IsPackingActive = SpliteDetails[13];
                var Packing_Factor = SpliteDetails[14];
                var Packing_UOM = SpliteDetails[15];
                var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

                if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                    $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                    //divPacking.style.display = "block";
                } else {
                    divPacking.style.display = "none";
                }

                $('#<%= lblStkQty.ClientID %>').text(QuantityValue);
                $('#<%= lblStkUOM.ClientID %>').text(strStkUOM);
                $('#<%= lblProduct.ClientID %>').text(strProductName);
                $('#<%= lblbranchName.ClientID %>').text(strBranch);

                if (ProductID != "0") {
                    cacpAvailableStock.PerformCallback(strProductID);
                }
            }
    }
    function ProductlookUpKeyDown(s, e) {
        if (e.htmlEvent.key == "Escape") {
            cProductpopUp.Hide();
            grid.batchEditApi.StartEdit(globalRowIndex, 6);
        }
    }
    function ProductSelected(s, e) {

        if (cproductLookUp.GetGridView().GetFocusedRowIndex() == -1) {
            cProductpopUp.Hide();
            grid.batchEditApi.StartEdit(globalRowIndex, 6);
            return;
        }
        var LookUpData = cproductLookUp.GetGridView().GetRowKey(cproductLookUp.GetGridView().GetFocusedRowIndex());
        var ProductCode = cproductLookUp.GetValue();
        if (!ProductCode) {
            LookUpData = null;
        }
        cProductpopUp.Hide();
        grid.batchEditApi.StartEdit(globalRowIndex);
        grid.GetEditor("ProductID").SetText(LookUpData);
        grid.GetEditor("ProductName").SetText(ProductCode);
        //console.log(LookUpData);
        pageheaderContent.style.display = "block";
        cddl_AmountAre.SetEnabled(false);
        cddl_TdsScheme.SetEnabled(false);
        $('#ddlInventory').prop('disabled', true);
        var tbDescription = grid.GetEditor("Description");
        var tbUOM = grid.GetEditor("UOM");
        var tbSalePrice = grid.GetEditor("PurchasePrice");

        //var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
        var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
        var SpliteDetails = ProductID.split("||@||");
        var strProductID = SpliteDetails[0];
        var strDescription = SpliteDetails[1];
        var strUOM = SpliteDetails[2];
        var strStkUOM = SpliteDetails[4];
        var strSalePrice = SpliteDetails[6];

        var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
        var IsPackingActive = SpliteDetails[10];
        var Packing_Factor = SpliteDetails[11];
        var Packing_UOM = SpliteDetails[12];

        var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
        if (strRate == 0) {
            strSalePrice = strSalePrice;
        }
        else {
            strSalePrice = strSalePrice / strRate;
        }

        tbDescription.SetValue(strDescription);
        tbUOM.SetValue(strUOM);
        tbSalePrice.SetValue(strSalePrice);

        grid.GetEditor("Quantity").SetValue("0.00");
        grid.GetEditor("Discount").SetValue("0.00");
        grid.GetEditor("Amount").SetValue("0.00");
        grid.GetEditor("TaxAmount").SetValue("0.00");
        grid.GetEditor("TotalAmount").SetValue("0.00");

        var ddlbranch = $("[id*=ddl_Branch]");
        var strBranch = ddlbranch.find("option:selected").text();

        $('#<%= lblStkQty.ClientID %>').text("0.00");
        $('#<%= lblStkUOM.ClientID %>').text(strStkUOM);
        $('#<%= lblProduct.ClientID %>').text(strDescription);
        $('#<%= lblbranchName.ClientID %>').text(strBranch);

        if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
            $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
            // divPacking.style.display = "block";
        } else {
            divPacking.style.display = "none";
        }
        //divPacking.style.display = "none";

        //lblbranchName lblProduct
        //tbStkUOM.SetValue(strStkUOM);
        //tbStockQuantity.SetValue("0");


        // Running total Calculation Start
        Cur_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
        Cur_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
        Cur_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
        CalculateAmount();
        // Running total Calculation End

        //Debjyoti
        ctaxUpdatePanel.PerformCallback('DelProdbySl~' + grid.GetEditor("SrlNo").GetValue() + '~' + strProductID);
        grid.batchEditApi.StartEdit(globalRowIndex, 6);
    }
    function ProductKeyDown(s, e) {
        if (e.htmlEvent.key == "Enter") {
            s.OnButtonClick(0);
        }
        if (e.htmlEvent.key == "Tab") {

            s.OnButtonClick(0);
        }
    }
    function ProductButnClick(s, e) {
        if (e.buttonIndex == 0) {
            var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";

            if ($('#txtVoucherNo').val() == '' || $('#txtVoucherNo').val() == null) {
                jAlert('Select a numbering schema first.')
                $('#ddl_numberingScheme').focus();
                return false;
            }

            else if (customerval == '' || customerval == null || customerval == "") {

                jAlert('Select a Vendor first')
                gridLookup.Focus();
                return false;
            }
            else if (cproductLookUp.Clear()) {

                // Running total Calculation Start

                Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
                Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

                // Running total Calculation End
                cProductpopUp.Show();
                cproductLookUp.Focus();
                cproductLookUp.ShowDropDown();
            }
        }
    }
    //..............End Product........................
    //.............Available Stock Div Show............................
    function ProductsGotFocus(s, e) {
        pageheaderContent.style.display = "block";
        var ProductID = (grid.GetEditor('ProductID').GetValue() != null) ? grid.GetEditor('ProductID').GetValue() : "0";
        var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
        //var ProductID = (cCmbProduct.GetValue() != null) ? cCmbProduct.GetValue() : "0";
        //var strProductName = (cCmbProduct.GetText() != null) ? cCmbProduct.GetText() : "0";

        var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";

        var ddlbranch = $("[id*=ddl_Branch]");
        var strBranch = ddlbranch.find("option:selected").text();

        var SpliteDetails = ProductID.split("||@||");
        var strProductID = SpliteDetails[0];
        var strDescription = SpliteDetails[1];
        var strUOM = SpliteDetails[2];
        var strStkUOM = SpliteDetails[4];
        var strSalePrice = SpliteDetails[6];
        var IsPackingActive = SpliteDetails[13];
        var Packing_Factor = SpliteDetails[14];
        var Packing_UOM = SpliteDetails[15];
        var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

        if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
            $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
            //  divPacking.style.display = "block";
        } else {
            divPacking.style.display = "none";
        }

        $('#<%= lblStkQty.ClientID %>').text(QuantityValue);
        $('#<%= lblStkUOM.ClientID %>').text(strStkUOM);
        $('#<%= lblProduct.ClientID %>').text(strProductName);
        $('#<%= lblbranchName.ClientID %>').text(strBranch);

        if (ProductID != "0") {
            cacpAvailableStock.PerformCallback(strProductID);
        }
    }
    function acpAvailableStockEndCall(s, e) {
        if (cacpAvailableStock.cpstock != null) {
            divAvailableStk.style.display = "block";
            //divpopupAvailableStock.style.display = "block";

            var AvlStk = cacpAvailableStock.cpstock + " " + document.getElementById('<%=lblStkUOM.ClientID %>').innerHTML;
            document.getElementById('<%=lblAvailableStkPro.ClientID %>').innerHTML = AvlStk;
            document.getElementById('<%=lblAvailableStk.ClientID %>').innerHTML = cacpAvailableStock.cpstock;


            cCmbWarehouse.cpstock = null;
        }
    }
    //................Available Stock Div Show....................
    //Code for UDF Control 
    function OpenUdf(s, e) {
        if (document.getElementById('IsUdfpresent').value == '0') {
            jAlert("UDF not define.");
        }
        else {
            var keyVal = document.getElementById('Keyval_internalId').value;
            var url = '/OMS/management/Master/frm_BranchUdfPopUp.aspx?Type=PB&&KeyVal_InternalID=' + keyVal;
            popup.SetContentUrl(url);
            popup.Show();
        }
        return true;
    }
    // End Udf Code
    //............Check Unique   Purchase Order................
    function txtBillNo_TextChanged() {
        var mode = ''
        var VoucherNo = document.getElementById("txtVoucherNo").value;


        $.ajax({
            type: "POST",
            url: "PurchaseInvoiceforTransporter.aspx/CheckUniqueName",
            data: JSON.stringify({ VoucherNo: VoucherNo }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (msg) {
                var data = msg.d;

                if (data == true) {
                    $("#DuplicateBillNo").show();

                    document.getElementById("txtVoucherNo").value = '';
                    document.getElementById("txtVoucherNo").focus();
                }
                else {
                    $("#DuplicateBillNo").hide();
                }
            }
        });
    }
    //..................Rate........................
    function ReBindGrid_Currency() {
        var frontRow = 0;
        var backRow = -1;
        var IsProduct = "";
        for (var i = 0; i <= grid.GetVisibleRowsOnPage() ; i++) {
            var frontProduct = (grid.batchEditApi.GetCellValue(backRow, 'ProductID') != null) ? (grid.batchEditApi.GetCellValue(backRow, 'ProductID')) : "";
            var backProduct = (grid.batchEditApi.GetCellValue(frontRow, 'ProductID') != null) ? (grid.batchEditApi.GetCellValue(frontRow, 'ProductID')) : "";

            if (frontProduct != "" || backProduct != "") {
                IsProduct = "Y";
                break;
            }

            backRow--;
            frontRow++;
        }

        if (IsProduct == "Y") {
            $('#<%=hdfIsDelete.ClientID %>').val('D');
            grid.UpdateEdit();
            grid.PerformCallback('CurrencyChangeDisplay~' + PreviousCurrency);
            //grid.PerformCallback('CurrencyChangeDisplay');
        }
    }
    //...............end.........................
    //...............PopulateVAT........................
    function PopulateGSTCSTVAT(e) {
        var key = cddl_AmountAre.GetValue();
        //deleteAllRows();

        if (key == 1 || key == 4) {

            grid.GetEditor('TaxAmount').SetEnabled(true);
            cddlVatGstCst.SetEnabled(false);
            //cddlVatGstCst.PerformCallback('1');
            cddlVatGstCst.SetSelectedIndex(-1);
            cbtn_SaveRecords.SetVisible(true);
            grid.GetEditor('ProductID').Focus();
            if (grid.GetVisibleRowsOnPage() == 1) {
                grid.batchEditApi.StartEdit(-1, 2);
            }

        }
        else if (key == 2) {
            grid.GetEditor('TaxAmount').SetEnabled(true);

            cddlVatGstCst.SetEnabled(true);
            cddlVatGstCst.PerformCallback('2');
            cddlVatGstCst.Focus();
            cbtn_SaveRecords.SetVisible(true);
        }
        else if (key == 3) {

            grid.GetEditor('TaxAmount').SetEnabled(false);

            //cddlVatGstCst.PerformCallback('3');
            cddlVatGstCst.SetSelectedIndex(-1);
            cddlVatGstCst.SetEnabled(false);
            cbtn_SaveRecords.SetVisible(false);
            if (grid.GetVisibleRowsOnPage() == 1) {
                grid.batchEditApi.StartEdit(-1, 2);
            }


        }

    }
    function Keypressevt() {

        if (event.keyCode == 13) {

            //run code for Ctrl+X -- ie, Save & Exit! 
            SaveWarehouse();
            return false;
        }
    }

    function SetFocusonDemand(e) {
        var key = cddl_AmountAre.GetValue();
        if (key == '1' || key == '3') {
            if (grid.GetVisibleRowsOnPage() == 1) {
                grid.batchEditApi.StartEdit(-1, 2);
            }
        }
        else if (key == '2') {
            cddlVatGstCst.Focus();
        }

    }

    //.................End PopulateVAT...............
    //................Amount Calculation.........................
    function TaxAmountKeyDown(s, e) {

        if (e.htmlEvent.key == "Enter") {
            s.OnButtonClick(0);
        }
    }
    function taxAmtButnClick1(s, e) {
        // console.log(grid.GetFocusedRowIndex());
        rowEditCtrl = s;
    }
    function taxAmtButnClick(s, e) {
        if (e.buttonIndex == 0) {

            if (cddl_AmountAre.GetValue() != null) {
                var ProductID = (grid.GetEditor('ProductID').GetValue() != null) ? grid.GetEditor('ProductID').GetValue() : "";

                if (ProductID.trim() != "") {

                    // Running total Calculation Start

                    Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                    Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
                    Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

                    // Running total Calculation End

                    document.getElementById('setCurrentProdCode').value = ProductID.split('||')[0];
                    document.getElementById('HdSerialNo').value = grid.GetEditor('SrlNo').GetText();
                    ctxtTaxTotAmt.SetValue(0);
                    ccmbGstCstVat.SetSelectedIndex(0);
                    $('.RecalculateInline').hide();
                    caspxTaxpopUp.Show();
                    //Set Product Gross Amount and Net Amount

                    var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                    var SpliteDetails = ProductID.split("||@||");
                    var strMultiplier = SpliteDetails[7];
                    var strFactor = SpliteDetails[8];
                    var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
                    //var strRate = "1";
                    var strStkUOM = SpliteDetails[4];
                    // var strSalePrice = SpliteDetails[6];
                    var strSalePrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "";
                    if (strRate == 0) {
                        strRate = 1;
                    }
                    //  console.log("1");
                    var StockQuantity = strMultiplier * QuantityValue;
                    var Amount = parseFloat(Math.round(QuantityValue * strFactor * (strSalePrice / strRate) * 100) / 100).toFixed(2);
                    clblTaxProdGrossAmt.SetText(Amount);
                    clblProdNetAmt.SetText(grid.GetEditor('Amount').GetValue());
                    document.getElementById('HdProdGrossAmt').value = Amount;
                    document.getElementById('HdProdNetAmt').value = parseFloat(Math.round(grid.GetEditor('Amount').GetValue() * 100) / 100).toFixed(2);

                    //End Here

                    //Set Discount Here
                    if (parseFloat(grid.GetEditor('Discount').GetValue()) > 0) {
                        var discount = Math.round((Amount * grid.GetEditor('Discount').GetValue() / 100)).toFixed(2);
                        clblTaxDiscount.SetText(discount);
                    }
                    else {
                        clblTaxDiscount.SetText('0.00');
                    }
                    //End Here 


                    //Checking is gstcstvat will be hidden or not
                    if (cddl_AmountAre.GetValue() == "2") {
                        $('.GstCstvatClass').hide();
                        $('.gstGrossAmount').show();
                        clblTaxableGross.SetText("(Taxable)");
                        clblTaxableNet.SetText("(Taxable)");
                        $('.gstNetAmount').hide();
                        //Set Gross Amount with GstValue
                        //Get The rate of Gst
                        var gstRate = parseFloat(cddlVatGstCst.GetValue().split('~')[1]);
                        if (gstRate) {
                            if (gstRate != 0) {
                                var gstDis = (gstRate / 100) + 1;
                                if (cddlVatGstCst.GetValue().split('~')[2] == "G") {
                                    $('.gstNetAmount').hide();
                                    clblTaxProdGrossAmt.SetText(Math.round(Amount / gstDis).toFixed(2));
                                    document.getElementById('HdProdGrossAmt').value = Math.round(Amount / gstDis).toFixed(2);
                                    clblGstForGross.SetText(Math.round(Amount - parseFloat(document.getElementById('HdProdGrossAmt').value)).toFixed(2));
                                    clblTaxableNet.SetText("");
                                }
                                else {
                                    $('.gstGrossAmount').hide();
                                    clblProdNetAmt.SetText(Math.round(grid.GetEditor('Amount').GetValue() / gstDis).toFixed(2));
                                    document.getElementById('HdProdNetAmt').value = Math.round(grid.GetEditor('Amount').GetValue() / gstDis).toFixed(2);
                                    clblGstForNet.SetText(Math.round(grid.GetEditor('Amount').GetValue() - parseFloat(document.getElementById('HdProdNetAmt').value)).toFixed(2));
                                    clblTaxableGross.SetText("");
                                }
                            }

                        } else {
                            $('.gstGrossAmount').hide();
                            $('.gstNetAmount').hide();
                            clblTaxableGross.SetText("");
                            clblTaxableNet.SetText("");
                        }
                    }
                    else if (cddl_AmountAre.GetValue() == "1") {
                        $('.GstCstvatClass').show();
                        $('.gstGrossAmount').hide();
                        $('.gstNetAmount').hide();
                        clblTaxableGross.SetText("");
                        clblTaxableNet.SetText("");

                        //###### Added By : Samrat Roy ##########
                        //Get Customer Shipping StateCode
                        var shippingStCode = '';
                        shippingStCode = cbsSCmbState.GetText();
                        shippingStCode = shippingStCode.substring(shippingStCode.lastIndexOf('(')).replace('(State Code:', '').replace(')', '').trim();

                        //// ###########  Old Code #####################
                        ////Get Customer Shipping StateCode
                        //var shippingStCode = '';
                        //if (cchkBilling.GetValue()) {
                        //    shippingStCode = CmbState.GetText();
                        //}
                        //else {
                        //    shippingStCode = CmbState1.GetText();
                        //}
                        //shippingStCode = shippingStCode.substring(shippingStCode.lastIndexOf('(')).replace('(State Code:', '').replace(')', '').trim();
                        //###### END : Samrat Roy : END ########## 

                        //Debjyoti 09032017
                        if (shippingStCode.trim() != '') {
                            for (var cmbCount = 1; cmbCount < ccmbGstCstVat.GetItemCount() ; cmbCount++) {
                                //Check if gstin is blank then delete all tax
                                if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[5] != "") {

                                    if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[5] == shippingStCode) {

                                        //if its state is union territories then only UTGST will apply
                                        if (shippingStCode == "4" || shippingStCode == "26" || shippingStCode == "25" || shippingStCode == "35" || shippingStCode == "31" || shippingStCode == "34") {
                                            if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'I' || ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'C' || ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'S') {
                                                ccmbGstCstVat.RemoveItem(cmbCount);
                                                cmbCount--;
                                            }
                                        }
                                        else {
                                            if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'I' || ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'U') {
                                                ccmbGstCstVat.RemoveItem(cmbCount);
                                                cmbCount--;
                                            }
                                        }
                                    } else {
                                        if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'S' || ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'C' || ccmbGstCstVat.GetItem(cmbCount).value.split('~')[4] == 'U') {
                                            ccmbGstCstVat.RemoveItem(cmbCount);
                                            cmbCount--;
                                        }
                                    }
                                } else {
                                    //remove tax because GSTIN is not define
                                    ccmbGstCstVat.RemoveItem(cmbCount);
                                    cmbCount--;
                                }
                            }
                        }

                    } else {
                        clblTaxableGross.SetText("");
                        clblTaxableNet.SetText("");

                    }
                    //End here

                    if (globalRowIndex > -1) {
                        cgridTax.PerformCallback(grid.keys[globalRowIndex] + '~' + cddl_AmountAre.GetValue());
                    } else {

                        cgridTax.PerformCallback('New~' + cddl_AmountAre.GetValue());
                        //Set default combo
                        cgridTax.cpComboCode = grid.GetEditor('ProductID').GetValue().split('||@||')[9];
                    }

                    ctxtprodBasicAmt.SetValue(grid.GetEditor('Amount').GetValue());
                } else {
                    grid.batchEditApi.StartEdit(globalRowIndex, 13);
                }
            }
        }
    }

    function SalePriceTextChange(s, e) {
        pageheaderContent.style.display = "block";
        var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
        var ProductID = grid.GetEditor('ProductID').GetValue();
        if (ProductID != null) {
            var SpliteDetails = ProductID.split("||@||");
            var strMultiplier = SpliteDetails[7];//Conversion_Multiplier 
            var strFactor = SpliteDetails[14]; //Packing_Factor 
            var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
            //console.log("Rate"+strRate);
            var strProductID = SpliteDetails[0];
            var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            var ddlbranch = $("[id*=ddl_Branch]");
            var strBranch = ddlbranch.find("option:selected").text();

            //var strRate = "1";
            var strStkUOM = SpliteDetails[4];//Stk_UOM_Name
            var strSalePrice = SpliteDetails[6];// purchase Price
            //console.log("PurchasePrice"+strSalePrice);

            if (strRate == 0) {
                strRate = 1;
            }
            if (strSalePrice == 0.00000) {
                strSalePrice = 1;
            }

            var StockQuantity = strMultiplier * QuantityValue;
            var Amount = QuantityValue * strFactor * (strSalePrice / strRate);

            // alert("here" + Amount);
            $('#<%= lblbranchName.ClientID %>').text(strBranch);

                var IsPackingActive = SpliteDetails[13];//IsPackingActive
                var Packing_Factor = SpliteDetails[14];//Packing_Factor
                var Packing_UOM = SpliteDetails[15];//Packing_UOM
                var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

                if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                    $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                    // divPacking.style.display = "block";
                } else {
                    divPacking.style.display = "none";
                }



                var tbAmount = grid.GetEditor("Amount");
                tbAmount.SetValue(Amount);

                var tbTotalAmount = grid.GetEditor("TotalAmount");
                tbTotalAmount.SetValue(Amount);

                DiscountTextChange(s, e);
                //.........AvailableStock.............

                //SamNewCodeon 03072017
                //cacpAvailableStock.PerformCallback(strProductID);
                //SamNewCodeon 03072017
            }
            else {
                jAlert('Select a product first.');
                grid.GetEditor('Quantity').SetValue('0');
                grid.GetEditor('ProductID').Focus();
            }
        }

        // Non Inventory Section By Sam on 24052017

        function TDSChecking(s, e) {
            var inventoryItem = $('#ddlInventory').val();
            if (inventoryItem == 'N') {
                var schemeid = cddl_TdsScheme.GetValue()
                if (schemeid != '0') {
                    var ProductID = grid.GetEditor('ProductID').GetValue();
                    if (ProductID != null) {

                        <%--$('#<%=hdntdschecking.ClientID %>').val('1')--%>
                        var slno = grid.GetEditor('SrlNo').GetValue();
                        if ($('#<%=hdntdschecking.ClientID %>').val() == '') {
                            $('#<%=hdntdschecking.ClientID %>').val(slno + ',');
                        }
                        else {
                            var myArray = $('#<%=hdntdschecking.ClientID %>').val().split(',');
                            if ($.inArray(slno, myArray) != -1) {

                            }
                            else {
                                $('#<%=hdntdschecking.ClientID %>').val($('#<%=hdntdschecking.ClientID %>').val() + slno)
                            }


                        }
                    }
                }
            }
        }





        function qtyvalidate() {
            var srlno = grid.GetEditor('SrlNo').GetValue();
            var previousqty = grid.GetEditor('Quantity').GetValue();

            return $.ajax({
                type: "POST",
                url: 'PurchaseInvoiceforTransporter.aspx/ValidQuantity',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ srlno: srlno, previousqty: previousqty }),
                cache: false
                //success: function (data) {
                //    //callBack(data);


                //    }

            });

        }


        <%--function QuantityGotFocus(s, e)
        {
            
            var purPrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
            $('#<%=hdntaxpurprice.ClientID %>').val(purPrice);
        }--%>

        // Non Inventory Section By Sam on 24052017
        function QuantityTextChange(s, e) {

            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            if (parseFloat(QuantityValue) != parseFloat(ProductGetQuantity)) {
                var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                if (type == 'PO') {
                    var TotalQty = (grid.GetEditor('TotalQty').GetText() != null) ? grid.GetEditor('TotalQty').GetText() : "0";
                    var BalanceQty = (grid.GetEditor('BalanceQty').GetText() != null) ? grid.GetEditor('BalanceQty').GetText() : "0";
                    var CurrQty = 0;

                    BalanceQty = parseFloat(BalanceQty);
                    TotalQty = parseFloat(TotalQty);
                    QuantityValue = parseFloat(QuantityValue);

                    if (TotalQty > QuantityValue) {
                        CurrQty = BalanceQty + (TotalQty - QuantityValue);
                    }
                    else {
                        CurrQty = BalanceQty - (QuantityValue - TotalQty);
                    }

                    if (CurrQty < 0) {
                        grid.GetEditor("TotalQty").SetValue(TotalQty);
                        grid.GetEditor("Quantity").SetValue(TotalQty);
                        var OrdeMsg = 'Balance Quantity of selected Product from tagged document is (' + ((QuantityValue - TotalQty) + BalanceQty) + '). <br/>Cannot enter quantity more than balance quantity.';
                        grid.batchEditApi.EndEdit();
                        jAlert(OrdeMsg, 'Alert Dialog: [Balace Quantity ]', function (r) {
                            grid.batchEditApi.StartEdit(globalRowIndex, 6);
                        });
                        return false;
                    }
                    else {
                        grid.GetEditor("TotalQty").SetValue(QuantityValue);
                        grid.GetEditor("BalanceQty").SetValue(CurrQty);
                    }
                }
                else {
                    grid.GetEditor("TotalQty").SetValue(QuantityValue);
                    grid.GetEditor("BalanceQty").SetValue(QuantityValue);
                }
                <%--$('#<%=hdnprevqty.ClientID %>').val('');
                qtyvalidate().done(function(data){
               
                    var status = data.d
                    var result = status.split('~');
                    if (result[0] == "0") {
                        var setqty = result[1];
                        

                        $('#<%=hdnprevqty.ClientID %>').val(setqty);
                        jAlert('Quantity can not be greater then ' + parseFloat(setqty) + ' .');

                        //return;

                    }
                })
                if ($('#<%=hdnprevqty.ClientID %>').val() != '')
                    {

                var lastqty = grid.GetEditor("Quantity");
                lastqty.SetValue(parseFloat($('#<%=hdnprevqty.ClientID %>').val()));
                }--%>
                <%--$('#<%=hdnprevqty.ClientID %>').val('');
                if ($('#<%=hdnprevqty.ClientID %>').val() != '' && $('#<%=hdnprevqty.ClientID %>').val() != null)
                    {
                var lastqty = grid.GetEditor("Quantity");
                lastqty.SetValue($('#<%=hdnprevqty.ClientID %>').val());
                   
                jAlert('Quantity can not be greater then ' + $('#<%=hdnprevqty.ClientID %>').val() + ' .');--%>

                //return;
                //}


                //} 
                $('#<%=hdnqtyupdate.ClientID %>').val('Y');
                TDSChecking();
                pageheaderContent.style.display = "block";
                var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                var ProductID = grid.GetEditor('ProductID').GetValue();
                if (ProductID != null) {
                    var SpliteDetails = ProductID.split("||@||");
                    // console.log(SpliteDetails)
                    var strMultiplier = SpliteDetails[7];//Conversion_Multiplier
                    //console.log("Multiplier"+strMultiplier);
                    var strFactor = SpliteDetails[8]; //Packing_Factor
                    // console.log("Factor"+strFactor);
                    var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
                    //console.log("Rate"+strRate);
                    var strProductID = SpliteDetails[0];
                    var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
                    var ddlbranch = $("[id*=ddl_Branch]");
                    var strBranch = ddlbranch.find("option:selected").text();

                    //var strRate = "1";
                    var strStkUOM = SpliteDetails[4];//Stk_UOM_Name
                    //var strSalePrice = SpliteDetails[6];// purchase Price
                    var strSalePrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
                    $('#<%=hdntaxpurprice.ClientID %>').val(strSalePrice);
                    //console.log("PurchasePrice"+strSalePrice);
                    if (strFactor == 0) {
                        strFactor = 1;
                    }
                    if (strRate == 0) {
                        strRate = 1;
                    }
                    if (strSalePrice == 0.00000) {
                        strSalePrice = 1;
                    }
                    //var inventoryItem = $('#ddlInventory').val();
                    //if (inventoryItem != 'N') {
                    var StockQuantity = strMultiplier * QuantityValue;
                    var Amount = QuantityValue * strFactor * (strSalePrice / strRate);
                    //}
                    //else
                    //{
                    //    if (QuantityValue == '0.0') {
                    //        var Amount = strSalePrice;
                    //    }
                    //    else {
                    //        var Amount = strSalePrice * QuantityValue;
                    //    }

                    //}


                    <%--Packing Section will not use in this module
        
                 $('#<%= lblbranchName.ClientID %>').text(strBranch);

                var IsPackingActive = SpliteDetails[13];//IsPackingActive
                var Packing_Factor = SpliteDetails[14];//Packing_Factor
                var Packing_UOM = SpliteDetails[15];//Packing_UOM
                var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

                if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                    $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                   
                } else {
                    divPacking.style.display = "none";
                }--%>




                    var tbAmount = grid.GetEditor("Amount");
                    tbAmount.SetValue(Amount);

                    var tbTotalAmount = grid.GetEditor("TotalAmount");
                    tbTotalAmount.SetValue(Amount);

                    DiscountTextChange(s, e);
                    //.........AvailableStock.............
                    //SamNewCodeon 03072017Start
                    //cacpAvailableStock.PerformCallback(strProductID);
                    //SamNewCodeon 03072017End
                }
                else {
                    jAlert('Select a product first.');
                    grid.GetEditor('Quantity').SetValue('0');
                    grid.GetEditor('PurchasePrice').SetValue('0');
                    grid.GetEditor('ProductID').Focus();
                }
            }
        }

        function PurchasePriceTextChange(s, e) {
            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";

            var PriceValue = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
            if (ProductPurchaseprice != parseFloat(PriceValue)) {
                var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                if (type == 'PO') {
                    var TotalQty = (grid.GetEditor('TotalQty').GetText() != null) ? grid.GetEditor('TotalQty').GetText() : "0";
                    var BalanceQty = (grid.GetEditor('BalanceQty').GetText() != null) ? grid.GetEditor('BalanceQty').GetText() : "0";
                    var CurrQty = 0;

                    BalanceQty = parseFloat(BalanceQty);
                    TotalQty = parseFloat(TotalQty);
                    QuantityValue = parseFloat(QuantityValue);

                    if (TotalQty > QuantityValue) {
                        CurrQty = BalanceQty + (TotalQty - QuantityValue);
                    }
                    else {
                        CurrQty = BalanceQty - (QuantityValue - TotalQty);
                    }

                    if (CurrQty < 0) {
                        grid.GetEditor("TotalQty").SetValue(TotalQty);
                        grid.GetEditor("Quantity").SetValue(TotalQty);
                        var OrdeMsg = 'Balance Quantity of selected Product from tagged document is (' + ((QuantityValue - TotalQty) + BalanceQty) + '). <br/>Cannot enter quantity more than balance quantity.';
                        grid.batchEditApi.EndEdit();
                        jAlert(OrdeMsg, 'Alert Dialog: [Balace Quantity ]', function (r) {
                            grid.batchEditApi.StartEdit(globalRowIndex, 6);
                        });
                        return false;
                    }
                    else {
                        grid.GetEditor("TotalQty").SetValue(QuantityValue);
                        grid.GetEditor("BalanceQty").SetValue(CurrQty);
                    }
                }
                else {
                    grid.GetEditor("TotalQty").SetValue(QuantityValue);
                    grid.GetEditor("BalanceQty").SetValue(QuantityValue);
                }
                <%--$('#<%=hdnprevqty.ClientID %>').val('');
                qtyvalidate().done(function(data){
               
                    var status = data.d
                    var result = status.split('~');
                    if (result[0] == "0") {
                        var setqty = result[1];
                        

                        $('#<%=hdnprevqty.ClientID %>').val(setqty);
                        jAlert('Quantity can not be greater then ' + parseFloat(setqty) + ' .');

                        //return;

                    }
                })
                if ($('#<%=hdnprevqty.ClientID %>').val() != '')
                    {

                var lastqty = grid.GetEditor("Quantity");
                lastqty.SetValue(parseFloat($('#<%=hdnprevqty.ClientID %>').val()));
                }--%>
                <%--$('#<%=hdnprevqty.ClientID %>').val('');
                if ($('#<%=hdnprevqty.ClientID %>').val() != '' && $('#<%=hdnprevqty.ClientID %>').val() != null)
                    {
                var lastqty = grid.GetEditor("Quantity");
                lastqty.SetValue($('#<%=hdnprevqty.ClientID %>').val());
                   
                jAlert('Quantity can not be greater then ' + $('#<%=hdnprevqty.ClientID %>').val() + ' .');--%>

                //return;
                //}


                //} 
                $('#<%=hdnqtyupdate.ClientID %>').val('Y');
                TDSChecking();
                pageheaderContent.style.display = "block";
                var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                var ProductID = grid.GetEditor('ProductID').GetValue();
                if (ProductID != null) {
                    var SpliteDetails = ProductID.split("||@||");
                    // console.log(SpliteDetails)
                    var strMultiplier = SpliteDetails[7];//Conversion_Multiplier
                    //console.log("Multiplier"+strMultiplier);
                    var strFactor = SpliteDetails[8]; //Packing_Factor
                    // console.log("Factor"+strFactor);
                    var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
                    //console.log("Rate"+strRate);
                    var strProductID = SpliteDetails[0];
                    var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
                    var ddlbranch = $("[id*=ddl_Branch]");
                    var strBranch = ddlbranch.find("option:selected").text();

                    //var strRate = "1";
                    var strStkUOM = SpliteDetails[4];//Stk_UOM_Name
                    //var strSalePrice = SpliteDetails[6];// purchase Price
                    var strSalePrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
                    //console.log("PurchasePrice"+strSalePrice);
                    if (strFactor == 0) {
                        strFactor = 1;
                    }
                    if (strRate == 0) {
                        strRate = 1;
                    }
                    if (strSalePrice == 0.00000) {
                        strSalePrice = 1;
                    }
                    //var inventoryItem = $('#ddlInventory').val();
                    //if (inventoryItem != 'N') {
                    var StockQuantity = strMultiplier * QuantityValue;
                    var Amount = QuantityValue * strFactor * (strSalePrice / strRate);
                    //}
                    //else
                    //{
                    //    if (QuantityValue == '0.0') {
                    //        var Amount = strSalePrice;
                    //    }
                    //    else {
                    //        var Amount = strSalePrice * QuantityValue;
                    //    }

                    //}


                    <%--Packing Section will not use in this module
        
                 $('#<%= lblbranchName.ClientID %>').text(strBranch);

                var IsPackingActive = SpliteDetails[13];//IsPackingActive
                var Packing_Factor = SpliteDetails[14];//Packing_Factor
                var Packing_UOM = SpliteDetails[15];//Packing_UOM
                var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

                if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                    $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                   
                } else {
                    divPacking.style.display = "none";
                }--%>




                    var tbAmount = grid.GetEditor("Amount");
                    tbAmount.SetValue(Amount);
                    grid.GetEditor('TaxAmount').SetValue(0);
                    var tbTotalAmount = grid.GetEditor("TotalAmount");
                    tbTotalAmount.SetValue(Amount);

                    DiscountTextChange(s, e);
                    //.........AvailableStock.............
                    //SamNewCodeon 03072017Start
                    //cacpAvailableStock.PerformCallback(strProductID);
                    //SamNewCodeon 03072017End
                }
                else {
                    jAlert('Select a product first.');
                    grid.GetEditor('Quantity').SetValue('0');
                    grid.GetEditor('PurchasePrice').SetValue('0');
                    grid.GetEditor('ProductID').Focus();
                }
            }
        }
        function AmtTextChange(s, e) {
            TDSChecking();
            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            var PurPrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
            var Discount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";
            var Discountamt = (grid.GetEditor('Discountamt').GetValue() != null) ? grid.GetEditor('Discountamt').GetValue() : "0";
            var ProductWiseGrsAmt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";









            var ProductID = grid.GetEditor('ProductID').GetValue();
            if (ProductID != null) {
                if (parseFloat(Discount) != parseFloat(ProductDiscount)
                    || parseFloat(QuantityValue) != parseFloat(ProductGetQuantity)
                    || parseFloat(PurPrice) != parseFloat(ProductPurchaseprice)
                    || parseFloat(Discountamt) != parseFloat(ProductDiscountAmt)
                     || parseFloat(ProductWiseGrsAmt) != parseFloat(ProductGrsAmt)) {
                    var SpliteDetails = ProductID.split("||@||");
                    var strFactor = SpliteDetails[8];
                    var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
                    var strSalePrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
                    if (strFactor == 0) {
                        strFactor = 1;
                    }
                    if (strSalePrice == '0') {
                        strSalePrice = SpliteDetails[6];
                    }
                    if (strRate == 0) {
                        strRate = 1;
                    }
                    var Discountamt = (grid.GetEditor('Discountamt').GetValue() != null) ? grid.GetEditor('Discountamt').GetValue() : "0";
                    var Amount = QuantityValue * strFactor * (strSalePrice / strRate);
                    var Discount = ((parseFloat(Discountamt) * 100) / parseFloat(Amount));
                    var amountAfterDiscount = parseFloat(Amount) - ((parseFloat(Discount) * parseFloat(Amount)) / 100);


                    var grossamt = grid.GetEditor('Amount').GetValue();
                    grid.GetEditor('TaxAmount').SetValue(0);
                    var _TotalTaxAmt = (grid.GetEditor('TaxAmount').GetValue() != null) ? grid.GetEditor('TaxAmount').GetValue() : "0";
                    var tbTotalAmount = grid.GetEditor("TotalAmount");
                    tbTotalAmount.SetValue(parseFloat(grossamt) + parseFloat(_TotalTaxAmt));

                    //var _TotalAmount = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
                    var _TotalAmount = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

                    if (parseFloat(_TotalAmount) != parseFloat(ProductGetTotalAmount)) {
                        grid.GetEditor('TaxAmount').SetValue(0);
                        ctaxUpdatePanel.PerformCallback('DelQtybySl~' + grid.GetEditor("SrlNo").GetValue());
                        var incluexclutype = ''
                        var taxtype = cddl_AmountAre.GetValue();
                        if (taxtype == '1') {
                            incluexclutype = 'E'
                        }
                        else if (taxtype == '2') {
                            incluexclutype = 'I'
                        }
                        var checkval = cchk_reversemechenism.GetChecked();
            <%-- var checkval = $('#<%=chk_reversemechenism.ClientID%>').attr('checked')? true : false;--%>
                        if (!checkval) {
                            if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                                var schemabranchid = $('#ddl_numberingScheme').val();
                                if (schemabranchid != '0') {
                                    var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                                    caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, grossamt, incluexclutype, $("#bsSCmbStateHF").val(), schemabranch, 'P')
                                    //caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, grossamt, incluexclutype, $("#bsSCmbStateHF").val(), $('#ddl_Branch').val(), 'P')
                                }
                            }
                            else if ($('#<%=hdnADDEditMode.ClientID %>').val() == 'Edit') {
                                var schemabranchid = $('#ddl_Branch').val();
                                if (schemabranchid != '0') {
                                    var schemabranch = schemabranchid;
                                    caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, grossamt, incluexclutype, $("#bsSCmbStateHF").val(), schemabranch, 'P')
                                    //caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, grossamt, incluexclutype, $("#bsSCmbStateHF").val(), $('#ddl_Branch').val(), 'P')
                                }
                            }
                        }
                    }
                    // Running total Calculation Start
                    Cur_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                    Cur_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
                    Cur_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
                    CalculateAmount();
                    // Running total Calculation End
                }
            }
            else {
                jAlert('Select a product first.');
                grid.GetEditor('Amount').SetValue('0');
                grid.GetEditor('ProductID').Focus();
            }

            //TDSDetail();
        }

        function DiscountAmtTextChange(s, e) {
            TDSChecking();

            //ProductGetQuantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            //ProductPurchaseprice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
            //ProductDiscount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";
            //ProductDiscountAmt = (grid.GetEditor('Discountamt').GetValue() != null) ? grid.GetEditor('Discountamt').GetValue() : "0";

            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            var PurPrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
            var Discount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";
            var Discountamt = (grid.GetEditor('Discountamt').GetValue() != null) ? grid.GetEditor('Discountamt').GetValue() : "0";



            var ProductID = grid.GetEditor('ProductID').GetValue();
            if (ProductID != null) {
                if (parseFloat(Discount) != parseFloat(ProductDiscount) || parseFloat(QuantityValue) != parseFloat(ProductGetQuantity) || parseFloat(PurPrice) != parseFloat(ProductPurchaseprice) || parseFloat(Discountamt) != parseFloat(ProductDiscountAmt)) {
                    var SpliteDetails = ProductID.split("||@||");
                    var strFactor = SpliteDetails[8];
                    var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
                    var strSalePrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
                    if (strFactor == 0) {
                        strFactor = 1;
                    }
                    if (strSalePrice == '0') {
                        strSalePrice = SpliteDetails[6];
                    }
                    if (strRate == 0) {
                        strRate = 1;
                    }
                    //var inventoryItem = $('#ddlInventory').val();
                    //if (inventoryItem != 'N') {
                    var Amount = QuantityValue * strFactor * (strSalePrice / strRate);
                    var Discount = ((parseFloat(Discountamt) * 100) / parseFloat(Amount));
                    var amountAfterDiscount = parseFloat(Amount) - ((parseFloat(Discount) * parseFloat(Amount)) / 100);
                    //}
                    //else {

                    //    if (QuantityValue == '0.0') {
                    //        var amountAfterDiscount = strSalePrice;
                    //    }
                    //    else {
                    //        var amountAfterDiscount = strSalePrice * QuantityValue;
                    //    }
                    //}


                    var DiscountamtField = grid.GetEditor("Discount");
                    DiscountamtField.SetValue(Discount);
                    var tbAmount = grid.GetEditor("Amount");
                    tbAmount.SetValue(amountAfterDiscount);

                    var IsPackingActive = SpliteDetails[13];
                    var Packing_Factor = SpliteDetails[14];
                    var Packing_UOM = SpliteDetails[15];
                    var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

                    if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                        $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                        // divPacking.style.display = "block";
                    } else {
                        divPacking.style.display = "none";
                    }
                    grid.GetEditor('TaxAmount').SetValue(0);
                    var tbTotalAmount = grid.GetEditor("TotalAmount");
                    var _TotalTaxAmt = (grid.GetEditor('TaxAmount').GetValue() != null) ? grid.GetEditor('TaxAmount').GetValue() : "0";
                    var tbTotalAmount = grid.GetEditor("TotalAmount");

                    tbTotalAmount.SetValue(parseFloat(amountAfterDiscount) + parseFloat(_TotalTaxAmt));


                    //tbTotalAmount.SetValue(amountAfterDiscount);


                    //// Running total Calculation Start
                    //Cur_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                    //Cur_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
                    //Cur_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
                    //CalculateAmount();
                    //// Running total Calculation End
                }
            }
            else {
                jAlert('Select a product first.');
                grid.GetEditor('Discountamt').SetValue('0');
                grid.GetEditor('ProductID').Focus();
            }
            //Debjyoti 


            var _TotalAmount = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

            if (parseFloat(_TotalAmount) != parseFloat(ProductGetTotalAmount)) {
                grid.GetEditor('TaxAmount').SetValue(0);
                ctaxUpdatePanel.PerformCallback('DelQtybySl~' + grid.GetEditor("SrlNo").GetValue());
                var incluexclutype = ''
                var taxtype = cddl_AmountAre.GetValue();
                if (taxtype == '1') {
                    incluexclutype = 'E'
                }
                else if (taxtype == '2') {
                    incluexclutype = 'I'
                }
                var checkval = cchk_reversemechenism.GetChecked();
                <%-- var checkval = $('#<%=chk_reversemechenism.ClientID%>').attr('checked')? true : false;--%>
                if (!checkval) {
                    if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                        var schemabranchid = $('#ddl_numberingScheme').val();
                        if (schemabranchid != '0') {
                            var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                            caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), schemabranch, 'P')
                            //caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), $('#ddl_Branch').val(), 'P')
                        }
                    }
                    else if ($('#<%=hdnADDEditMode.ClientID %>').val() == 'Edit') {
                        var schemabranchid = $('#ddl_Branch').val();
                        if (schemabranchid != '0') {
                            var schemabranch = schemabranchid;
                            //var schemabranchid = $('#ddl_numberingScheme').val();
                            //if (schemabranchid != '0') {
                            //    var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                            caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), schemabranch, 'P')
                            //caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), $('#ddl_Branch').val(), 'P')
                        }
                    }


                }
            }

            // Running total Calculation Start
            Cur_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            Cur_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            Cur_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
            CalculateAmount();
            // Running total Calculation End

            //Running total Calculation
            //var finalNetAmount = parseFloat(tbTotalAmount.GetValue());
            //var finalAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) + (finalNetAmount - globalNetAmount);
            //cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(finalAmount) * 100) / 100).toFixed(2));
            //cbnrLblTaxableAmtval.SetText(grid.GetEditor("Amount").GetText());
            //cbnrLblTaxAmtval.SetText(grid.GetEditor("TaxAmount").GetText());
            //SetInvoiceLebelValue();
            //Running total Calculation

        }

        function DiscountTextChange(s, e) {
            //var Amount = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";

            TDSChecking();



            var PurPrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";


            var Discount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";

            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            var ProductID = grid.GetEditor('ProductID').GetValue();
            if (ProductID != null) {
                if (parseFloat(Discount) != parseFloat(ProductDiscount) || parseFloat(QuantityValue) != parseFloat(ProductGetQuantity) || parseFloat(PurPrice) != parseFloat(ProductPurchaseprice)) {
                    var SpliteDetails = ProductID.split("||@||");
                    var strFactor = SpliteDetails[8];
                    var strRate = (ctxtRate.GetValue() != null && ctxtRate.GetValue() != "0") ? ctxtRate.GetValue() : "1";
                    var strSalePrice = (grid.GetEditor('PurchasePrice').GetValue() != null) ? grid.GetEditor('PurchasePrice').GetValue() : "0";
                    if (strFactor == 0) {
                        strFactor = 1;
                    }
                    if (strSalePrice == '0') {
                        strSalePrice = SpliteDetails[6];
                    }
                    if (strRate == 0) {
                        strRate = 1;
                    }
                    var Amount = QuantityValue * strFactor * (strSalePrice / strRate);
                    var Discountamt = ((parseFloat(Discount) * parseFloat(Amount)) / 100);
                    var amountAfterDiscount = parseFloat(Amount) - ((parseFloat(Discount) * parseFloat(Amount)) / 100);
                    //}
                    //else {

                    //    if (QuantityValue == '0.0') {
                    //        var amountAfterDiscount = strSalePrice;
                    //    }
                    //    else
                    //    {
                    //        var amountAfterDiscount = strSalePrice * QuantityValue;
                    //    }

                    //}



                    var DiscountamtField = grid.GetEditor("Discountamt");
                    DiscountamtField.SetValue(Discountamt);
                    var tbAmount = grid.GetEditor("Amount");
                    tbAmount.SetValue(amountAfterDiscount);

                    var IsPackingActive = SpliteDetails[13];
                    var Packing_Factor = SpliteDetails[14];
                    var Packing_UOM = SpliteDetails[15];
                    var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

                    if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                        $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                            // divPacking.style.display = "block";
                        } else {
                            divPacking.style.display = "none";
                        }
                        grid.GetEditor('TaxAmount').SetValue(0);
                        var _TotalTaxAmt = (grid.GetEditor('TaxAmount').GetValue() != null) ? grid.GetEditor('TaxAmount').GetValue() : "0";
                        var tbTotalAmount = grid.GetEditor("TotalAmount");

                        tbTotalAmount.SetValue(parseFloat(amountAfterDiscount) + parseFloat(_TotalTaxAmt));
                    }

                }
                else {
                    jAlert('Select a product first.');
                    grid.GetEditor('Discount').SetValue('0');
                    grid.GetEditor('ProductID').Focus();
                }
                //Debjyoti 

                //var _TotalTax = (grid.GetEditor('TaxAmount').GetValue() != null) ? grid.GetEditor('TaxAmount').GetValue() : "0";
                var _TotalAmount = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";


                if (parseFloat(_TotalAmount) != parseFloat(ProductGetTotalAmount)) {
                    grid.GetEditor('TaxAmount').SetValue(0);
                    ctaxUpdatePanel.PerformCallback('DelQtybySl~' + grid.GetEditor("SrlNo").GetValue());

                    var incluexclutype = ''
                    var taxtype = cddl_AmountAre.GetValue();
                    if (taxtype == '1') {
                        incluexclutype = 'E'
                    }
                    else if (taxtype == '2') {
                        incluexclutype = 'I'
                    }
                    var checkval = cchk_reversemechenism.GetChecked();
                    if (!checkval) {
                        if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                var schemabranchid = $('#ddl_numberingScheme').val();
                if (schemabranchid != '0') {
                    var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                    caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), schemabranch, 'P')
                    //caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), $('#ddl_Branch').val(), 'P')
                }
            }
            else if ($('#<%=hdnADDEditMode.ClientID %>').val() == 'Edit') {
                //var schemabranchid = $('#ddl_numberingScheme').val();
                //if (schemabranchid != '0') {
                //    var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                var schemabranchid = $('#ddl_Branch').val();
                if (schemabranchid != '0') {
                    var schemabranch = schemabranchid;
                    caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), schemabranch, 'P')
                    //caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[18], Amount, amountAfterDiscount, incluexclutype, $("#bsSCmbStateHF").val(), $('#ddl_Branch').val(), 'P')
                }
            }

        }
    }

                // Running total Calculation Start
    Cur_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
    Cur_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
    Cur_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
    CalculateAmount();
                // Running total Calculation End

                //Running total Calculation
                //var finalNetAmount = parseFloat(tbTotalAmount.GetValue());
                //var finalAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) + (finalNetAmount - globalNetAmount);
                //cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(finalAmount) * 100) / 100).toFixed(2));
                //cbnrLblTaxableAmtval.SetText(grid.GetEditor("Amount").GetText());
                //cbnrLblTaxAmtval.SetText(grid.GetEditor("TaxAmount").GetText());
                //SetInvoiceLebelValue();
                //Running total Calculation

}

//......................Amount Calculation End.......................
/*........................Tax Start...........................*/
var taxAmountGlobalCharges;
var chargejsonTax;
var taxAmountGlobal;
var GlobalCurChargeTaxAmt;
var ChargegstcstvatGlobalName;
var GlobalCurTaxAmt = 0;
var rowEditCtrl;
var globalRowIndex;
var globalTaxRowIndex;
var gstcstvatGlobalName;
var taxJson;
function Save_TaxClick() {
    if (gridTax.GetVisibleRowsOnPage() > 0) {
        gridTax.UpdateEdit();
    }
    else {
        gridTax.PerformCallback('SaveGst');
    }
    cPopup_Taxes.Hide();
}
//Set Running Total for Charges And Tax 
function SetChargesRunningTotal() {
    var runningTot = parseFloat(ctxtProductNetAmount.GetValue());
    for (var i = 0; i < chargejsonTax.length; i++) {
        gridTax.batchEditApi.StartEdit(i, 3);
        if (chargejsonTax[i].applicableOn == "R") {
            gridTax.GetEditor("calCulatedOn").SetValue(runningTot);
            var totLength = gridTax.GetEditor("TaxName").GetText().length;
            var taxNameWithSign = gridTax.GetEditor("Percentage").GetText();
            var sign = gridTax.GetEditor("TaxName").GetText().substring(totLength - 3);
            var ProdAmt = parseFloat(gridTax.GetEditor("calCulatedOn").GetValue());
            var Amount = gridTax.GetEditor("calCulatedOn").GetValue();
            var GlobalTaxAmt = 0;

            var Percentage = gridTax.GetEditor("Percentage").GetText();
            var totLength = gridTax.GetEditor("TaxName").GetText().length;
            var sign = gridTax.GetEditor("TaxName").GetText().substring(totLength - 3);
            Sum = ((parseFloat(Amount) * parseFloat(Percentage)) / 100);

            if (sign == '(+)') {
                GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
                gridTax.GetEditor("Amount").SetValue(Sum);
                ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + parseFloat(Sum) - GlobalTaxAmt);
                ctxtTotalAmount.SetValue(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
                //ctxtTotalAmount.SetText(parseFloat(ctxtTotalAmount.GetValue()) + parseFloat(Sum) - GlobalTaxAmt);
                GlobalTaxAmt = 0;
            }
            else {
                GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
                gridTax.GetEditor("Amount").SetValue(Sum);
                ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) - parseFloat(Sum) + GlobalTaxAmt);
                ctxtTotalAmount.SetValue(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
                //ctxtTotalAmount.SetText(parseFloat(ctxtTotalAmount.GetValue()) - parseFloat(Sum) + GlobalTaxAmt);
                GlobalTaxAmt = 0;
            }

            SetOtherChargeTaxValueOnRespectiveRow(0, Sum, gridTax.GetEditor("TaxName").GetText());


        }
        runningTot = runningTot + parseFloat(gridTax.GetEditor("Amount").GetValue());
        gridTax.batchEditApi.EndEdit();
    }
}
function GetPercentageData() {
    var Amount = ctxtProductAmount.GetValue();
    var GlobalTaxAmt = 0;
    var noofvisiblerows = gridTax.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
    var i, cnt = 1;
    var sumAmount = 0, totalAmount = 0;
    for (i = 0 ; cnt <= noofvisiblerows ; i++) {
        var totLength = gridTax.batchEditApi.GetCellValue(i, 'TaxName').length;
        var sign = gridTax.batchEditApi.GetCellValue(i, 'TaxName').substring(totLength - 3);
        var DisAmount = (gridTax.batchEditApi.GetCellValue(i, 'Amount') != null) ? (gridTax.batchEditApi.GetCellValue(i, 'Amount')) : "0";

        if (sign == '(+)') {
            sumAmount = sumAmount + parseFloat(DisAmount);
        }
        else {
            sumAmount = sumAmount - parseFloat(DisAmount);
        }

        cnt++;
    }

    totalAmount = (parseFloat(Amount)) + (parseFloat(sumAmount));
    // ctxtTotalAmount.SetValue(totalAmount);
}
function Save_TaxesClick() {
    grid.batchEditApi.EndEdit();
    var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
    var i, cnt = 1;
    var sumAmount = 0, sumTaxAmount = 0, sumDiscount = 0, sumNetAmount = 0, sumDiscountAmt = 0;

    cnt = 1;
    for (i = -1 ; cnt <= noofvisiblerows ; i--) {
        var Amount = (grid.batchEditApi.GetCellValue(i, 'Amount') != null) ? (grid.batchEditApi.GetCellValue(i, 'Amount')) : "0";
        var TaxAmount = (grid.batchEditApi.GetCellValue(i, 'TaxAmount') != null) ? (grid.batchEditApi.GetCellValue(i, 'TaxAmount')) : "0";
        var Discount = (grid.batchEditApi.GetCellValue(i, 'Discount') != null) ? (grid.batchEditApi.GetCellValue(i, 'Discount')) : "0";
        var NetAmount = (grid.batchEditApi.GetCellValue(i, 'TotalAmount') != null) ? (grid.batchEditApi.GetCellValue(i, 'TotalAmount')) : "0";
        var sumDiscountAmt = ((parseFloat(Discount) * parseFloat(Amount)) / 100);

        sumAmount = sumAmount + parseFloat(Amount);
        sumTaxAmount = sumTaxAmount + parseFloat(TaxAmount);
        sumDiscount = sumDiscount + parseFloat(sumDiscountAmt);
        sumNetAmount = sumNetAmount + parseFloat(NetAmount);

        cnt++;
    }

    if (sumAmount == 0 && sumTaxAmount == 0 && Discount == 0) {
        cnt = 1;
        for (i = 0 ; cnt <= noofvisiblerows ; i++) {
            var Amount = (grid.batchEditApi.GetCellValue(i, 'Amount') != null) ? (grid.batchEditApi.GetCellValue(i, 'Amount')) : "0";
            var TaxAmount = (grid.batchEditApi.GetCellValue(i, 'TaxAmount') != null) ? (grid.batchEditApi.GetCellValue(i, 'TaxAmount')) : "0";
            var Discount = (grid.batchEditApi.GetCellValue(i, 'Discount') != null) ? (grid.batchEditApi.GetCellValue(i, 'Discount')) : "0";
            var NetAmount = (grid.batchEditApi.GetCellValue(i, 'TotalAmount') != null) ? (grid.batchEditApi.GetCellValue(i, 'TotalAmount')) : "0";
            var sumDiscountAmt = ((parseFloat(Discount) * parseFloat(Amount)) / 100);

            sumAmount = sumAmount + parseFloat(Amount);
            sumTaxAmount = sumTaxAmount + parseFloat(TaxAmount);
            sumDiscount = sumDiscount + parseFloat(sumDiscountAmt);
            sumNetAmount = sumNetAmount + parseFloat(NetAmount);

            cnt++;
        }
    }

    //Debjyoti 
    document.getElementById('HdChargeProdAmt').value = sumAmount;
    document.getElementById('HdChargeProdNetAmt').value = sumNetAmount;
    //End Here

    ctxtProductAmount.SetValue(parseFloat(Math.round(sumAmount * 100) / 100).toFixed(2));
    ctxtProductTaxAmount.SetValue(parseFloat(Math.round(sumTaxAmount * 100) / 100).toFixed(2));
    ctxtProductDiscount.SetValue(parseFloat(Math.round(sumDiscount * 100) / 100).toFixed(2));
    ctxtProductNetAmount.SetValue(parseFloat(Math.round(sumNetAmount * 100) / 100).toFixed(2));
    clblChargesTaxableGross.SetText("");
    clblChargesTaxableNet.SetText("");

    //Checking is gstcstvat will be hidden or not
    if (cddl_AmountAre.GetValue() == "2") {

        $('.lblChargesGSTforGross').show();
        $('.lblChargesGSTforNet').show();

        //Set Gross Amount with GstValue
        //Get The rate of Gst
        var gstRate = parseFloat(cddlVatGstCst.GetValue().split('~')[1]);
        if (gstRate) {
            if (gstRate != 0) {
                var gstDis = (gstRate / 100) + 1;
                if (cddlVatGstCst.GetValue().split('~')[2] == "G") {
                    $('.lblChargesGSTforNet').hide();
                    ctxtProductAmount.SetText(Math.round(sumAmount / gstDis).toFixed(2));
                    document.getElementById('HdChargeProdAmt').value = Math.round(sumAmount / gstDis).toFixed(2);
                    clblChargesGSTforGross.SetText(Math.round(sumAmount - parseFloat(document.getElementById('HdChargeProdAmt').value)).toFixed(2));
                    clblChargesTaxableGross.SetText("(Taxable)");

                }
                else {
                    $('.lblChargesGSTforGross').hide();
                    ctxtProductNetAmount.SetText(Math.round(sumNetAmount / gstDis).toFixed(2));
                    document.getElementById('HdChargeProdNetAmt').value = Math.round(sumNetAmount / gstDis).toFixed(2);
                    clblChargesGSTforNet.SetText(Math.round(sumNetAmount - parseFloat(document.getElementById('HdChargeProdNetAmt').value)).toFixed(2));
                    clblChargesTaxableNet.SetText("(Taxable)");
                }
            }

        } else {
            $('.lblChargesGSTforGross').hide();
            $('.lblChargesGSTforNet').hide();
        }
    }
    else if (cddl_AmountAre.GetValue() == "1") {
        $('.lblChargesGSTforGross').hide();
        $('.lblChargesGSTforNet').hide();
    }
    //End here





    //Set Total amount
    ctxtTotalAmount.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + parseFloat(ctxtProductNetAmount.GetValue()));

    gridTax.PerformCallback('Display');
    //Checking is gstcstvat will be hidden or not
    if (cddl_AmountAre.GetValue() == "2") {
        $('.chargeGstCstvatClass').hide();
    }
    else if (cddl_AmountAre.GetValue() == "1") {
        $('.chargeGstCstvatClass').show();
    }
    //End here
    $('.RecalculateCharge').hide();
    cPopup_Taxes.Show();
    gridTax.StartEditRow(0);
}
function SetFocusonDemand(e) {
    var key = cddl_AmountAre.GetValue();
    if (key == '1' || key == '3') {
        if (grid.GetVisibleRowsOnPage() == 1) {
            grid.batchEditApi.StartEdit(-1, 2);
        }
    }
    else if (key == '2') {
        cddlVatGstCst.Focus();
    }

}
function QuotationTaxAmountTextChange(s, e) {
    //var Amount = ctxtProductAmount.GetValue();
    var Amount = gridTax.GetEditor("calCulatedOn").GetValue();
    var GlobalTaxAmt = 0;
    //var Percentage = (gridTax.GetEditor('Percentage').GetValue() != null) ? gridTax.GetEditor('Percentage').GetValue() : "0";
    //var Percentage = s.GetText();
    var totLength = gridTax.GetEditor("TaxName").GetText().length;
    var sign = gridTax.GetEditor("TaxName").GetText().substring(totLength - 3);
    //Sum = ((parseFloat(Amount) * parseFloat(Percentage)) / 100);

    if (sign == '(+)') {
        GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
        //gridTax.GetEditor("Amount").SetValue(Sum);
        ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + GlobalTaxAmt - taxAmountGlobalCharges);
        ctxtTotalAmount.SetText(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        //ctxtTotalAmount.SetText(parseFloat(ctxtTotalAmount.GetValue()) + parseFloat(Sum) - GlobalTaxAmt);
        GlobalTaxAmt = 0;
        SetOtherChargeTaxValueOnRespectiveRow(0, s.GetValue(), gridTax.GetEditor("TaxName").GetText());
    }
    else {
        GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
        //gridTax.GetEditor("Amount").SetValue(Sum);
        ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) - GlobalTaxAmt + taxAmountGlobalCharges);
        ctxtTotalAmount.SetValue(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        //ctxtTotalAmount.SetText(parseFloat(ctxtTotalAmount.GetValue()) - parseFloat(Sum) + GlobalTaxAmt);
        GlobalTaxAmt = 0;
        SetOtherChargeTaxValueOnRespectiveRow(0, s.GetValue(), gridTax.GetEditor("TaxName").GetText());
    }

    RecalCulateTaxTotalAmountCharges();
}
function OnTaxEndCallback(s, e) {
    GetPercentageData();
    $('.gridTaxClass').show();
    if (gridTax.GetVisibleRowsOnPage() == 0) {
        $('.gridTaxClass').hide();
        ccmbGstCstVatcharge.Focus();
    }
    else {
        gridTax.StartEditRow(0);
    }
    //check Json data
    if (gridTax.cpJsonChargeData) {
        if (gridTax.cpJsonChargeData != "") {
            chargejsonTax = JSON.parse(gridTax.cpJsonChargeData);
            gridTax.cpJsonChargeData = null;
        }
    }


    if (gridTax.cpChargesAmt) {
        ctxt_Charges.SetValue(gridTax.cpChargesAmt);
        gridTax.cpChargesAmt = null;

        Pre_Quantity = "0";
        Pre_Amt = "0";
        Pre_TotalAmt = "0";
        Cur_Quantity = "0";
        Cur_Amt = "0";
        Cur_TotalAmt = "0";
        CalculateAmount();
    }

    //Set Total Charges And total Amount
    if (gridTax.cpTotalCharges) {
        if (gridTax.cpTotalCharges != "") {
            ctxtQuoteTaxTotalAmt.SetValue(gridTax.cpTotalCharges);
            ctxtTotalAmount.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + parseFloat(ctxtProductNetAmount.GetValue()));
            gridTax.cpTotalCharges = null;
        }
    }


    SetChargesRunningTotal();
    ShowTaxPopUp("IN");
}
function QuotationTaxAmountGotFocus(s, e) {
    taxAmountGlobalCharges = parseFloat(s.GetValue());
}
function PercentageTextChange(s, e) {
    //var Amount = ctxtProductAmount.GetValue();
    var Amount = gridTax.GetEditor("calCulatedOn").GetValue();
    var GlobalTaxAmt = 0;
    //var Percentage = (gridTax.GetEditor('Percentage').GetValue() != null) ? gridTax.GetEditor('Percentage').GetValue() : "0";
    var Percentage = s.GetText();
    var totLength = gridTax.GetEditor("TaxName").GetText().length;
    var sign = gridTax.GetEditor("TaxName").GetText().substring(totLength - 3);
    Sum = ((parseFloat(Amount) * parseFloat(Percentage)) / 100);

    if (sign == '(+)') {
        GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
        gridTax.GetEditor("Amount").SetValue(Sum);
        ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + parseFloat(Sum) - GlobalTaxAmt);
        ctxtTotalAmount.SetValue(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        //ctxtTotalAmount.SetText(parseFloat(ctxtTotalAmount.GetValue()) + parseFloat(Sum) - GlobalTaxAmt);
        GlobalTaxAmt = 0;
    }
    else {
        GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
        gridTax.GetEditor("Amount").SetValue(Sum);
        ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) - parseFloat(Sum) + GlobalTaxAmt);
        ctxtTotalAmount.SetValue(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        //ctxtTotalAmount.SetText(parseFloat(ctxtTotalAmount.GetValue()) - parseFloat(Sum) + GlobalTaxAmt);
        GlobalTaxAmt = 0;
    }

    SetOtherChargeTaxValueOnRespectiveRow(0, Sum, gridTax.GetEditor("TaxName").GetText());
    SetChargesRunningTotal();

    RecalCulateTaxTotalAmountCharges();
}
function RecalCulateTaxTotalAmountCharges() {
    var totalTaxAmount = 0;
    for (var i = 0; i < chargejsonTax.length; i++) {
        gridTax.batchEditApi.StartEdit(i, 3);
        var totLength = gridTax.GetEditor("TaxName").GetText().length;
        var sign = gridTax.GetEditor("TaxName").GetText().substring(totLength - 3);
        if (sign == '(+)') {
            totalTaxAmount = totalTaxAmount + parseFloat(gridTax.GetEditor("Amount").GetValue());
        } else {
            totalTaxAmount = totalTaxAmount - parseFloat(gridTax.GetEditor("Amount").GetValue());
        }

        gridTax.batchEditApi.EndEdit();
    }

    totalTaxAmount = totalTaxAmount + parseFloat(ctxtGstCstVatCharge.GetValue());

    ctxtQuoteTaxTotalAmt.SetValue(totalTaxAmount);
    ctxtTotalAmount.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + parseFloat(ctxtProductNetAmount.GetValue()));
}

function ShowTaxPopUp(type) {
    if (type == "IY") {
        $('#ContentErrorMsg').hide();
        $('#content-6').show();


        if (ccmbGstCstVat.GetItemCount() <= 1) {
            $('.InlineTaxClass').hide();
        } else {
            $('.InlineTaxClass').show();
        }
        if (cgridTax.GetVisibleRowsOnPage() < 1) {
            $('.cgridTaxClass').hide();

        } else {
            $('.cgridTaxClass').show();
        }

        if (ccmbGstCstVat.GetItemCount() <= 1 && cgridTax.GetVisibleRowsOnPage() < 1) {
            $('#ContentErrorMsg').show();
            $('#content-6').hide();
        }
    }
    if (type == "IN") {
        $('#ErrorMsgCharges').hide();
        $('#content-5').show();

        if (ccmbGstCstVatcharge.GetItemCount() <= 1) {
            $('.chargesDDownTaxClass').hide();
        } else {
            $('.chargesDDownTaxClass').show();
        }
        if (gridTax.GetVisibleRowsOnPage() < 1) {
            $('.gridTaxClass').hide();

        } else {
            $('.gridTaxClass').show();
        }

        if (ccmbGstCstVatcharge.GetItemCount() <= 1 && gridTax.GetVisibleRowsOnPage() < 1) {
            $('#ErrorMsgCharges').show();
            $('#content-5').hide();
        }
    }
}
function gridFocusedRowChanged(s, e) {
    globalRowIndex = e.visibleIndex;
}
function TaxAmountKeyDown(s, e) {

    if (e.htmlEvent.key == "Enter") {
        s.OnButtonClick(0);
    }
}


function taxAmountGotFocus(s, e) {
    taxAmountGlobal = parseFloat(s.GetValue());
}

function taxAmountLostFocus(s, e) {
    var finalTaxAmt = parseFloat(s.GetValue());
    var totAmt = parseFloat(ctxtTaxTotAmt.GetText());
    var totLength = cgridTax.GetEditor("Taxes_Name").GetText().length;
    var sign = cgridTax.GetEditor("Taxes_Name").GetText().substring(totLength - 3);
    if (sign == '(+)') {
        ctxtTaxTotAmt.SetValue(Math.round(totAmt + finalTaxAmt - taxAmountGlobal));
    } else {
        ctxtTaxTotAmt.SetValue(Math.round(totAmt + (finalTaxAmt * -1) - (taxAmountGlobal * -1)));
    }


    SetOtherTaxValueOnRespectiveRow(0, cgridTax.GetEditor("Amount").GetValue(), cgridTax.GetEditor("Taxes_Name").GetText().replace('(+)', '').replace('(-)', ''));
    //Set Running Total
    SetRunningTotal();

    RecalCulateTaxTotalAmountInline();
}

function cmbGstCstVatChange(s, e) {

    SetOtherTaxValueOnRespectiveRow(0, 0, gstcstvatGlobalName);
    $('.RecalculateInline').hide();
    var ProdAmt = parseFloat(ctxtprodBasicAmt.GetValue());
    if (s.GetValue().split('~')[2] == 'G') {
        ProdAmt = parseFloat(clblTaxProdGrossAmt.GetValue());
    }
    else if (s.GetValue().split('~')[2] == 'N') {
        ProdAmt = parseFloat(clblProdNetAmt.GetValue());
    }
    else if (s.GetValue().split('~')[2] == 'O') {
        //Check for Other Dependecy
        $('.RecalculateInline').show();
        ProdAmt = 0;
        var taxdependentName = s.GetValue().split('~')[3];
        for (var i = 0; i < taxJson.length; i++) {
            cgridTax.batchEditApi.StartEdit(i, 3);
            var gridTaxName = cgridTax.GetEditor("Taxes_Name").GetText();
            gridTaxName = gridTaxName.substring(0, gridTaxName.length - 3).trim();
            if (gridTaxName == taxdependentName) {
                ProdAmt = cgridTax.GetEditor("Amount").GetValue();
            }
        }
    }
    else if (s.GetValue().split('~')[2] == 'R') {
        ProdAmt = GetTotalRunningAmount();
        $('.RecalculateInline').show();
    }

    GlobalCurTaxAmt = parseFloat(ctxtGstCstVat.GetText());

    var calculatedValue = parseFloat(ProdAmt * ccmbGstCstVat.GetValue().split('~')[1]) / 100;
    ctxtGstCstVat.SetValue(calculatedValue);

    var totAmt = parseFloat(ctxtTaxTotAmt.GetText());
    ctxtTaxTotAmt.SetValue(Math.round(totAmt + calculatedValue - GlobalCurTaxAmt));

    //tax others
    SetOtherTaxValueOnRespectiveRow(0, calculatedValue, ccmbGstCstVat.GetText());
    gstcstvatGlobalName = ccmbGstCstVat.GetText();
}


//for tax and charges

function ChargecmbGstCstVatChange(s, e) {

    SetOtherChargeTaxValueOnRespectiveRow(0, 0, ChargegstcstvatGlobalName);
    $('.RecalculateCharge').hide();
    var ProdAmt = parseFloat(ctxtProductAmount.GetValue());

    //Set ProductAmount
    if (s.GetValue().split('~')[2] == 'G') {
        ProdAmt = parseFloat(ctxtProductAmount.GetValue());
    }
    else if (s.GetValue().split('~')[2] == 'N') {
        ProdAmt = parseFloat(clblProdNetAmt.GetValue());
    }
    else if (s.GetValue().split('~')[2] == 'O') {
        //Check for Other Dependecy
        $('.RecalculateCharge').show();
        ProdAmt = 0;
        var taxdependentName = s.GetValue().split('~')[3];
        for (var i = 0; i < taxJson.length; i++) {
            gridTax.batchEditApi.StartEdit(i, 3);
            var gridTaxName = gridTax.GetEditor("TaxName").GetText();
            gridTaxName = gridTaxName.substring(0, gridTaxName.length - 3).trim();
            if (gridTaxName == taxdependentName) {
                ProdAmt = gridTax.GetEditor("Amount").GetValue();
            }
        }
    }
    else if (s.GetValue().split('~')[2] == 'R') {
        $('.RecalculateCharge').show();
        ProdAmt = GetChargesTotalRunningAmount();
    }


    GlobalCurChargeTaxAmt = parseFloat(ctxtGstCstVatCharge.GetText());

    var calculatedValue = parseFloat(ProdAmt * ccmbGstCstVatcharge.GetValue().split('~')[1]) / 100;
    ctxtGstCstVatCharge.SetValue(calculatedValue);

    var totAmt = parseFloat(ctxtQuoteTaxTotalAmt.GetText());
    ctxtQuoteTaxTotalAmt.SetValue(totAmt + calculatedValue - GlobalCurChargeTaxAmt);

    //tax others
    SetOtherChargeTaxValueOnRespectiveRow(0, calculatedValue, ctxtGstCstVatCharge.GetText());
    ChargegstcstvatGlobalName = ctxtGstCstVatCharge.GetText();

    //set Total Amount
    ctxtTotalAmount.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + parseFloat(ctxtProductNetAmount.GetValue()));
}




function GetChargesTotalRunningAmount() {
    var runningTot = parseFloat(ctxtProductNetAmount.GetValue());
    for (var i = 0; i < chargejsonTax.length; i++) {
        gridTax.batchEditApi.StartEdit(i, 3);
        runningTot = runningTot + parseFloat(gridTax.GetEditor("Amount").GetValue());
        gridTax.batchEditApi.EndEdit();
    }

    return runningTot;
}

function chargeCmbtaxClick(s, e) {
    GlobalCurChargeTaxAmt = parseFloat(ctxtGstCstVatCharge.GetText());
    ChargegstcstvatGlobalName = s.GetText();
}




function GetVisibleIndex(s, e) {
    globalRowIndex = e.visibleIndex;
}
function GetTaxVisibleIndex(s, e) {
    globalTaxRowIndex = e.visibleIndex;
}
function cmbtaxCodeindexChange(s, e) {
    if (cgridTax.GetEditor("Taxes_Name").GetText() == "GST/CST/VAT") {

        var taxValue = s.GetValue();

        if (taxValue == null) {
            taxValue = 0;
            GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
            cgridTax.GetEditor("Amount").SetValue(0);
            ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) - GlobalCurTaxAmt);
        }


        var isValid = taxValue.indexOf('~');
        if (isValid != -1) {
            var rate = parseFloat(taxValue.split('~')[1]);
            var ProdAmt = parseFloat(ctxtprodBasicAmt.GetValue());

            GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());


            cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * rate) / 100);
            ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * rate) / 100) - GlobalCurTaxAmt);
            GlobalCurTaxAmt = 0;
        }
        else {
            s.SetText("");
        }

    } else {
        var ProdAmt = parseFloat(ctxtprodBasicAmt.GetValue());

        if (s.GetValue() == null) {
            s.SetValue(0);
        }

        if (!isNaN(parseFloat(ProdAmt * s.GetText()) / 100)) {

            GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
            cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * s.GetText()) / 100);

            ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt);
            GlobalCurTaxAmt = 0;
        } else {
            s.SetText("");
        }
    }

}

function SetOtherTaxValueOnRespectiveRow(idx, amt, name) {
    for (var i = 0; i < taxJson.length; i++) {
        if (taxJson[i].applicableBy == name) {
            cgridTax.batchEditApi.StartEdit(i, 3);
            cgridTax.GetEditor('calCulatedOn').SetValue(amt);

            var totLength = cgridTax.GetEditor("Taxes_Name").GetText().length;
            var taxNameWithSign = cgridTax.GetEditor("TaxField").GetText();
            var sign = cgridTax.GetEditor("Taxes_Name").GetText().substring(totLength - 3);
            var ProdAmt = parseFloat(cgridTax.GetEditor("calCulatedOn").GetValue());
            var s = cgridTax.GetEditor("TaxField");
            if (sign == '(+)') {
                GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * s.GetText()) / 100);

                ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt);
                GlobalCurTaxAmt = 0;
            }
            else {

                GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * s.GetText()) / 100) * -1);

                ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) * -1) - (GlobalCurTaxAmt * -1));
                GlobalCurTaxAmt = 0;
            }




        }
    }
    //return;
    cgridTax.batchEditApi.EndEdit();

}



function SetOtherChargeTaxValueOnRespectiveRow(idx, amt, name) {
    name = name.substring(0, name.length - 3).trim();
    for (var i = 0; i < chargejsonTax.length; i++) {
        if (chargejsonTax[i].applicableBy == name) {
            gridTax.batchEditApi.StartEdit(i, 3);
            gridTax.GetEditor('calCulatedOn').SetValue(amt);

            var totLength = gridTax.GetEditor("TaxName").GetText().length;
            var taxNameWithSign = gridTax.GetEditor("Percentage").GetText();
            var sign = gridTax.GetEditor("TaxName").GetText().substring(totLength - 3);
            var ProdAmt = parseFloat(gridTax.GetEditor("calCulatedOn").GetValue());
            var s = gridTax.GetEditor("Percentage");
            if (sign == '(+)') {
                GlobalCurTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
                gridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * s.GetText()) / 100);

                ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt);
                GlobalCurTaxAmt = 0;
            }
            else {

                GlobalCurTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
                gridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * s.GetText()) / 100) * -1);

                ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) * -1) - (GlobalCurTaxAmt * -1));
                GlobalCurTaxAmt = 0;
            }




        }
    }
    //return;
    gridTax.batchEditApi.EndEdit();
}



function txtPercentageLostFocus(s, e) {

    //var ProdAmt = parseFloat(ctxtprodBasicAmt.GetValue());
    var ProdAmt = parseFloat(cgridTax.GetEditor("calCulatedOn").GetValue());
    if (s.GetText().trim() != '') {

        if (!isNaN(parseFloat(ProdAmt * s.GetText()) / 100)) {
            //Checking Add or less
            var totLength = cgridTax.GetEditor("Taxes_Name").GetText().length;
            var taxNameWithSign = cgridTax.GetEditor("TaxField").GetText();
            var sign = cgridTax.GetEditor("Taxes_Name").GetText().substring(totLength - 3);
            if (sign == '(+)') {
                GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * s.GetText()) / 100);

                ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt));
                GlobalCurTaxAmt = 0;
            }
            else {

                GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * s.GetText()) / 100) * -1);

                ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) * -1) - (GlobalCurTaxAmt * -1)));
                GlobalCurTaxAmt = 0;
            }
            SetOtherTaxValueOnRespectiveRow(0, cgridTax.GetEditor("Amount").GetValue(), cgridTax.GetEditor("Taxes_Name").GetText().replace('(+)', '').replace('(-)', ''));

            //Call for Running Total
            SetRunningTotal();

        } else {
            s.SetText("");
        }
    }

    RecalCulateTaxTotalAmountInline();
}

function RecalCulateTaxTotalAmountInline() {
    var totalInlineTaxAmount = 0;
    for (var i = 0; i < taxJson.length; i++) {
        cgridTax.batchEditApi.StartEdit(i, 3);
        var totLength = cgridTax.GetEditor("Taxes_Name").GetText().length;
        var sign = cgridTax.GetEditor("Taxes_Name").GetText().substring(totLength - 3);
        if (sign == '(+)') {
            totalInlineTaxAmount = totalInlineTaxAmount + parseFloat(cgridTax.GetEditor("Amount").GetValue());
        } else {
            totalInlineTaxAmount = totalInlineTaxAmount - parseFloat(cgridTax.GetEditor("Amount").GetValue());
        }

        cgridTax.batchEditApi.EndEdit();
    }

    totalInlineTaxAmount = totalInlineTaxAmount + parseFloat(ctxtGstCstVat.GetValue());

    ctxtTaxTotAmt.SetValue(totalInlineTaxAmount);
}


function SetRunningTotal() {
    var runningTot = parseFloat(clblProdNetAmt.GetValue());
    for (var i = 0; i < taxJson.length; i++) {
        cgridTax.batchEditApi.StartEdit(i, 3);
        if (taxJson[i].applicableOn == "R") {
            cgridTax.GetEditor("calCulatedOn").SetValue(runningTot);
            var totLength = cgridTax.GetEditor("Taxes_Name").GetText().length;
            var taxNameWithSign = cgridTax.GetEditor("TaxField").GetText();
            var sign = cgridTax.GetEditor("Taxes_Name").GetText().substring(totLength - 3);
            var ProdAmt = parseFloat(cgridTax.GetEditor("calCulatedOn").GetValue());
            var thisRunningAmt = 0;
            if (sign == '(+)') {
                GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * cgridTax.GetEditor("TaxField").GetValue()) / 100);

                ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(cgridTax.GetEditor("TaxField").GetValue())) / 100) - GlobalCurTaxAmt);
                GlobalCurTaxAmt = 0;
            }
            else {

                GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * cgridTax.GetEditor("TaxField").GetValue()) / 100) * -1);

                ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(cgridTax.GetEditor("TaxField").GetValue())) / 100) * -1) - (GlobalCurTaxAmt * -1));
                GlobalCurTaxAmt = 0;
            }
            SetOtherTaxValueOnRespectiveRow(0, cgridTax.GetEditor("Amount").GetValue(), cgridTax.GetEditor("Taxes_Name").GetText().replace('(+)', '').replace('(-)', ''));
        }
        runningTot = runningTot + parseFloat(cgridTax.GetEditor("Amount").GetValue());
        cgridTax.batchEditApi.EndEdit();
    }
}

function GetTotalRunningAmount() {
    var runningTot = parseFloat(clblProdNetAmt.GetValue());
    for (var i = 0; i < taxJson.length; i++) {
        cgridTax.batchEditApi.StartEdit(i, 3);
        runningTot = runningTot + parseFloat(cgridTax.GetEditor("Amount").GetValue());
        cgridTax.batchEditApi.EndEdit();
    }

    return runningTot;
}




function CmbtaxClick(s, e) {
    GlobalCurTaxAmt = parseFloat(ctxtGstCstVat.GetText());
    gstcstvatGlobalName = s.GetText();
}


function txtTax_TextChanged(s, i, e) {
    cgridTax.batchEditApi.StartEdit(i, 2);
    var ProdAmt = parseFloat(ctxtprodBasicAmt.GetValue());
    cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * s.GetText()) / 100);
}
function NonInventoryBatchUpdate() {
    var cnt = cgridinventory.GetVisibleItemsOnPage();

    cgridinventory.PerformCallback('0' + '~' + '0' + '~' + 'SaveNonInventoryProductChg' + '~' + cnt);
    //cgridTax.batchEditApi.StartEdit(0, 1);

    //if (cgridTax.GetEditor("TaxField").GetText().indexOf('.') == -1) {
    //    cgridTax.GetEditor("TaxField").SetText(cgridTax.GetEditor("TaxField").GetText().trim() + '.00');
    //} else {
    //    cgridTax.GetEditor("TaxField").SetText(cgridTax.GetEditor("TaxField").GetText().trim() + '0');
    //}
    //if (cgridinventory.GetVisibleRowsOnPage() > 0) {
    //    cgridinventory.UpdateEdit();
    //}
    //else {
    //    cgridinventory.PerformCallback('SaveNonInventoryProductChg');
    //}
    return false;
}


function BatchUpdate() {

    //cgridTax.batchEditApi.StartEdit(0, 1);

    //if (cgridTax.GetEditor("TaxField").GetText().indexOf('.') == -1) {
    //    cgridTax.GetEditor("TaxField").SetText(cgridTax.GetEditor("TaxField").GetText().trim() + '.00');
    //} else {
    //    cgridTax.GetEditor("TaxField").SetText(cgridTax.GetEditor("TaxField").GetText().trim() + '0');
    //}
    if (cgridTax.GetVisibleRowsOnPage() > 0) {
        cgridTax.UpdateEdit();
    }
    else {
        cgridTax.PerformCallback('SaveGST');
    }
    return false;
}


function cgridTax_EndCallBack(s, e) {
    //cgridTax.batchEditApi.StartEdit(0, 1);
    $('.cgridTaxClass').show();

    cgridTax.StartEditRow(0);


    //check Json data
    if (cgridTax.cpJsonData) {
        if (cgridTax.cpJsonData != "") {
            taxJson = JSON.parse(cgridTax.cpJsonData);
            cgridTax.cpJsonData = null;
        }
    }
    //End Here

    if (cgridTax.cpComboCode) {
        if (cgridTax.cpComboCode != "") {
            if (cddl_AmountAre.GetValue() == "1") {
                var selectedIndex;
                for (var i = 0; i < ccmbGstCstVat.GetItemCount() ; i++) {
                    if (ccmbGstCstVat.GetItem(i).value.split('~')[0] == cgridTax.cpComboCode) {
                        selectedIndex = i;
                    }
                }
                if (selectedIndex && ccmbGstCstVat.GetItem(selectedIndex) != null) {
                    ccmbGstCstVat.SetValue(ccmbGstCstVat.GetItem(selectedIndex).value);
                }
                cmbGstCstVatChange(ccmbGstCstVat);
                cgridTax.cpComboCode = null;
            }
        }
    }

    if (cgridTax.cpUpdated.split('~')[0] == 'ok') {
        ctxtTaxTotAmt.SetValue(Math.round(cgridTax.cpUpdated.split('~')[1]));
        var gridValue = parseFloat(cgridTax.cpUpdated.split('~')[1]);
        var ddValue = parseFloat(ctxtGstCstVat.GetValue());
        ctxtTaxTotAmt.SetValue(Math.round(gridValue + ddValue));
        cgridTax.cpUpdated = "";
    }

    else {
        var totAmt = ctxtTaxTotAmt.GetValue();
        cgridTax.CancelEdit();
        caspxTaxpopUp.Hide();
        grid.batchEditApi.StartEdit(globalRowIndex, 13);
        grid.GetEditor("TaxAmount").SetValue(totAmt);
        grid.GetEditor("TotalAmount").SetValue(DecimalRoundoff(parseFloat(totAmt) + parseFloat(grid.GetEditor("Amount").GetValue()), 2));
        if (cddl_AmountAre.GetValue() == '2') {
            var totalNetAmount = parseFloat(totAmt) + parseFloat(grid.GetEditor("Amount").GetValue());
            var totalRoundOffAmount = Math.round(totalNetAmount);
            grid.GetEditor("Amount").SetValue(parseFloat(grid.GetEditor("Amount").GetValue()) + (totalRoundOffAmount - totalNetAmount));
        }

        // Running total Calculation Start
        Cur_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
        Cur_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
        Cur_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
        CalculateAmount();
        // Running total Calculation End

    }

    if (cgridTax.GetVisibleRowsOnPage() == 0) {
        $('.cgridTaxClass').hide();
        ccmbGstCstVat.Focus();
    }
    //Debjyoti Check where any Gst Present or not
    // If Not then hide the hole section

    SetRunningTotal();
    ShowTaxPopUp("IY");
    RecalCulateTaxTotalAmountInline();
}

function recalculateTax() {
    cmbGstCstVatChange(ccmbGstCstVat);
}
function recalculateTaxCharge() {
    ChargecmbGstCstVatChange(ccmbGstCstVatcharge);
}




/*............................End Tax...........................................*/




function PerformCallToGridBind() {

    if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                var loadingmade = $('#<%=hdnADDEditMode.ClientID %>').val();
                grid.PerformCallback('BindGridOnQuotation' + '~' + '@');
                cQuotationComponentPanel.PerformCallback('BindQuotationGridOnSelection' + '~' + loadingmade);
                $('#hdnPageStatus').val('Quoteupdate');
                cProductsPopup.Hide();
                //#### added by Samrat Roy for Transporter Control #############
                var quote_Id = gridquotationLookup.gridView.GetSelectedKeysOnPage();
                if ("<%=Convert.ToString(Session["TransporterVisibilty"])%>" == "Yes") {
                    callTransporterControl(quote_Id[0], $("#rdl_PurchaseInvoice").find(":checked").val());
                }
                if (quote_Id.length > 0) {

                    BSDocTagging(quote_Id[0], $("#rdl_PurchaseInvoice").find(":checked").val());
                }
                if ($("#btn_TermsCondition").is(":visible")) {
                    callTCControl(quote_Id[0], $("#rdl_PurchaseInvoice").find(":checked").val());
                }
            }
            else {
                cProductsPopup.Hide();
            }

            return false;
        }

        function componentEndCallBack(s, e) {
            var loadingmode = $('#<%=hdnADDEditMode.ClientID %>').val();
            if (loadingmode != 'Edit') {
                gridquotationLookup.gridView.Refresh();
            }
            if (grid.GetVisibleRowsOnPage() == 0) {
                OnAddNewClick();
            }

            // Tagging Component Section Start
            if (cQuotationComponentPanel.cpDetails != null) {
                var details = cQuotationComponentPanel.cpDetails;
                cQuotationComponentPanel.cpDetails = null;

                var SpliteDetails = details.split("~");
                var Reference = SpliteDetails[0];
                var Currency_Id = SpliteDetails[1];
                var SalesmanId = SpliteDetails[2];
                var ExpiryDate = SpliteDetails[3];
                var CurrencyRate = SpliteDetails[4];

                ctxt_Refference.SetValue(Reference);
                ctxtRate.SetValue(CurrencyRate);
                document.getElementById('ddl_Currency').value = Currency_Id;
                document.getElementById('ddl_SalesAgent').value = SalesmanId;

                if (ExpiryDate != "") {
                    var myDate = new Date(ExpiryDate);
                    var invoiceDate = new Date();
                    var datediff = Math.round((myDate - invoiceDate) / (1000 * 60 * 60 * 24));

                    ctxtCreditDays.SetValue(datediff);
                    cdt_SaleInvoiceDue.SetDate(myDate);
                }
            }
        }
        function CloseGridQuotationLookup() {
            gridquotationLookup.ConfirmCurrentSelection();
            gridquotationLookup.HideDropDown();
            gridquotationLookup.Focus();
        }

        function QuotationNumberChanged() {

            var quote_Id = gridquotationLookup.GetValue();
            if (quote_Id != null) {
                var arr = quote_Id.split(',');
                if (arr.length > 1) {
                    cComponentDatePanel.PerformCallback('BindQuotationDate' + '~' + arr[0]);
                }
                else {
                    if (arr.length == 1) {
                        cComponentDatePanel.PerformCallback('BindQuotationDate' + '~' + quote_Id);
                    }
                    else {
                        cPLQADate.SetText('');
                    }
                }
            }
            else { cPLQADate.SetText(''); }

            if (quote_Id != null) {

                cgridproducts.PerformCallback('BindProductsDetails' + '~' + '@');
                cProductsPopup.Show();

            }
            //else {
            //    cgridproducts.PerformCallback('BindProductsDetails' + '~' + '$');
            //    cProductsPopup.Show();
            //}
            //txt_OANumber.Focus();           
        }
        function SetDifference1() {
            var diff = CheckDifferenceOfFromDateWithTodate();
        }
        function CheckDifferenceOfFromDateWithTodate() {
            var startDate = new Date();
            var endDate = new Date();
            var difference = -1;
            startDate = cPLSalesOrderDate.GetDate();
            if (startDate != null) {
                endDate = cExpiryDate.GetDate();
                var startTime = startDate.getTime();
                var endTime = endDate.getTime();
                difference = (startTime - endTime) / 86400000;

            }
            return difference;

        }
        function SetDifference() {
            var diff = CheckDifference();
        }
        function CheckDifference() {
            var startDate = new Date();
            var endDate = new Date();
            var difference = -1;
            startDate = cPLSalesOrderDate.GetDate();
            if (startDate != null) {
                endDate = cExpiryDate.GetDate();
                var startTime = startDate.getTime();
                var endTime = endDate.getTime();
                difference = (endTime - startTime) / 86400000;

            }
            return difference;

        }
        //.................WareHouse.......


        //...............end..........................
        //...............Addeess Part.......

        //function ClosebillingLookup() {
        //    billingLookup.ConfirmCurrentSelection();
        //    billingLookup.HideDropDown();
        //    billingLookup.Focus();
        //}
        //function CloseshippingLookup() {
        //    shippingLookup.ConfirmCurrentSelection();
        //    shippingLookup.HideDropDown();
        //    shippingLookup.Focus();
        //}

        //.......end........
        //function GetVisibleIndex(s, e) {
        //    globalRowIndex = e.visibleIndex;
        //}
        //gridinventory.JSProperties["cpproamt"] = proamt;
        //gridinventory.JSProperties["cpprochargeamt"] = Convert.ToString(amountcharge);
        function OnInventoryEndCallback(s, e) {
            //gridinventory.JSProperties["PopupReq"] = "N";
            //if (cgridinventory.cpPopupReq != null)
            //{
            if (cgridinventory.cpPopupReq == 'N') {
                OnAddNewClick();
               <%-- $('#<%=hdntdschecking.ClientID %>').val('0')--%>
                jAlert('Applicable amount is greater than entered amount.TDS is not required for this amount.')
                return;
            }
                //}

            else if (cgridinventory.cpgrid == "Y") {
                if (cgridinventory.cpbrMonAmtDtl != null) {
                    //.toString().split('~')[1]
                    //var brMonthPro = cgridinventory.cpbrMonAmtDtl.split("~");
                    var tdsbranch = cgridinventory.cpbrMonAmtDtl.toString().split('~')[0];
                    //brMonthPro[0];
                    var tdsmonth = cgridinventory.cpbrMonAmtDtl.toString().split('~')[1];
                    //brMonthPro[1];
                    var tdsTotalAmt = cgridinventory.cpbrMonAmtDtl.toString().split('~')[2];

                    var tdsProbAmt = cgridinventory.cpbrMonAmtDtl.toString().split('~')[3];
                    //brMonthPro[2];
                    //geet
                    //cddl_noninventoryBranch.SetValue(tdsbranch);
                    var branchid = $("#ddl_Branch option:selected").text();
                    $('#lbltdsBranch').text(branchid);
                    if (cgridinventory.cpmonth != null) {
                        var monthnm = cgridinventory.cpmonth;
                        if (monthnm == '1') {
                            cddl_month.SetValue('January');

                        }
                        else if (monthnm == '2') {
                            cddl_month.SetValue('February');
                        }
                        else if (monthnm == '3') {
                            cddl_month.SetValue('March');
                        }
                        else if (monthnm == '4') {
                            cddl_month.SetValue('April');
                        }
                        else if (monthnm == '5') {
                            cddl_month.SetValue('May');
                        }
                        else if (monthnm == '6') {
                            cddl_month.SetValue('June');
                        }
                        else if (monthnm == '7') {
                            cddl_month.SetValue('July');
                        }
                        else if (monthnm == '8') {
                            cddl_month.SetValue('August');
                        }
                        else if (monthnm == '9') {
                            cddl_month.SetValue('September');

                        }
                        else if (monthnm == '10') {
                            cddl_month.SetValue('October');
                        }
                        else if (monthnm == '11') {
                            cddl_month.SetValue('November');
                        }
                        else if (monthnm == '12') {
                            cddl_month.SetValue('December');
                        }
                    }
                    //geet
                    cddl_month.SetValue(tdsmonth);
                    if (tdsTotalAmt != null && tdsTotalAmt != '') {
                        ctxt_totalnoninventoryproductamt.SetText(Math.round(tdsTotalAmt));
                    }
                    ctxt_proamt.SetText(tdsProbAmt);

                }
                else if (cgridinventory.cpbrMonAmtDtl == null) {
                    ctxt_proamt.SetText(parseFloat(cgridinventory.cpproamt));
                    ctxt_totalnoninventoryproductamt.SetText(Math.round(parseFloat(cgridinventory.cpprochargeamt)));


                    var branchid = $("#ddl_Branch option:selected").text();
                    $('#lbltdsBranch').text(branchid);
                    if (cgridinventory.cpmonth != null) {
                        var monthnm = cgridinventory.cpmonth;
                        if (monthnm == '1') {
                            cddl_month.SetValue('January');

                        }
                        else if (monthnm == '2') {
                            cddl_month.SetValue('February');
                        }
                        else if (monthnm == '3') {
                            cddl_month.SetValue('March');
                        }
                        else if (monthnm == '4') {
                            cddl_month.SetValue('April');
                        }
                        else if (monthnm == '5') {
                            cddl_month.SetValue('May');
                        }
                        else if (monthnm == '6') {
                            cddl_month.SetValue('June');
                        }
                        else if (monthnm == '7') {
                            cddl_month.SetValue('July');
                        }
                        else if (monthnm == '8') {
                            cddl_month.SetValue('August');
                        }
                        else if (monthnm == '9') {
                            cddl_month.SetValue('September');

                        }
                        else if (monthnm == '10') {
                            cddl_month.SetValue('October');
                        }
                        else if (monthnm == '11') {
                            cddl_month.SetValue('November');
                        }
                        else if (monthnm == '12') {
                            cddl_month.SetValue('December');
                        }
                    }

                }
                cinventorypopup.Show();
            }
                //gridinventory.JSProperties["cppopuphide"] = "Y";
            else if (cgridinventory.cppopuphide == "Y") {
                //geet
                //cddl_noninventoryBranch.SetSelectedIndex(-1);
                var branchid = $("#ddl_Branch option:selected").text();
                $('#lbltdsBranch').text(branchid);
                //geet
                cddl_month.SetSelectedIndex(-1);
                ctxt_proamt.SetText('');
                ctxt_totalnoninventoryproductamt.SetText('');
                cinventorypopup.Hide();
                <%--$('#<%=hdntdschecking.ClientID %>').val('0')--%>
                OnAddNewClick();
                //ctxt_proamt.SetText(parseFloat(cgridinventory.cpproamt));
                //ctxt_totalnoninventoryproductamt.SetText(parseFloat(cgridinventory.cpprochargeamt));
                //cinventorypopup.Show();
            }
}

function panelEndCallBack(s, e) {
    if (cComponentDatePanel.cppartydetail != null) {
        var invtype = $('#ddlInventory').val();
        //var partydtl = cComponentDatePanel.cppartydetail.split[]
        var partyno = cComponentDatePanel.cppartydetail.toString().split('~')[0];
        var partydate = cComponentDatePanel.cppartydetail.toString().split('~')[1];

        var modetype = $('#<%=hdnADDEditMode.ClientID %>').val();
        if (modetype != 'Edit') {
            ctxt_partyInvNo.SetText(partyno);
            if (invtype != 'N') {
                if (partyno != null && partyno != '') {
                    $("#MandatorysPartyinvno").hide();
                }
                else {
                    $("#MandatorysPartyinvno").show();
                }
            }
            else {
                $("#MandatorysPartyinvno").hide();
            }

            if (invtype != 'N') {

                if (partydate != null && partydate != '') {
                    cdt_partyInvDt.SetText(partydate);
                    $('#MandatoryPartyDate').attr('style', 'display:none');
                } else {
                    $('#MandatoryPartyDate').attr('style', 'display:block');
                }
            }
            else {
                $('#MandatoryPartyDate').attr('style', 'display:none');
            }
        }
        //ComponentDatePanel.JSProperties["cppartydetail"] = partyInvNo + "~" + PartyInvoiceDate + "~" + reff + "~" + curr + "~" + rate + "~" + person + "~" + amtare + "~" + taxcode;

        var reff = cComponentDatePanel.cppartydetail.toString().split('~')[2];
        var curr = cComponentDatePanel.cppartydetail.toString().split('~')[3];
        var rate = cComponentDatePanel.cppartydetail.toString().split('~')[4];
        var person = cComponentDatePanel.cppartydetail.toString().split('~')[5];
        var amtare = cComponentDatePanel.cppartydetail.toString().split('~')[6];
        var taxcode = cComponentDatePanel.cppartydetail.toString().split('~')[7];
        cddl_AmountAre.SetEnabled(false);
        //cContactPerson
        //ddl_Currency
        //ctxtRate
        //cddl_AmountAre
        //cddlVatGstCst
        if (reff != '') {
            ctxt_Refference.SetText(reff);
        }

        if (person != '') {

            cContactPerson.SetValue(person);
        }
        if (curr != '') {

            $("#<%=ddl_Currency.ClientID%>").val(curr);
        }
        if (rate != '') {
            ctxtRate.SetText(rate);
        }
        //if(this.val() == anyvalue))
        if (amtare != '') {
            cddl_AmountAre.SetValue(amtare);
        }
        if (taxcode != '') {
            cddlVatGstCst.PerformCallback('SetTaxCode' + '~' + taxcode)
            var items = $('#cddlVatGstCst option').length;

            //$('#cddlVatGstCst option').each(function () {
            //    var taxval=this.val()

            //})
            cddlVatGstCst.SetValue(taxcode);
        }
        cComponentDatePanel.cppartydetail = null;
    }
}

function OnEndCallback(s, e) {
    var pageStatus = document.getElementById('hdnPageStatus').value;
    var value = document.getElementById('hdnRefreshType').value;
    var pageStatus = document.getElementById('hdnPageStatus').value;
    LoadingPanel.Hide();
    if (grid.cpComponent) {
        if (grid.cpComponent == 'true') {
            grid.cpComponent = null;
            $('#<%=hdfIsComp.ClientID %>').val('');
                OnAddNewClick();
            }
        }
        //if (grid.tagging = 'Y') {
        //    $("#ddl_numberingScheme").attr("disabled", true);

        //}

        //grid.JSProperties["tagging"] = "Y";

        if (grid.cpSaveSuccessOrFail == "outrange") {
            cbtn_SaveRecords.SetEnabled(true);
            //
            grid.batchEditApi.StartEdit(0, 2);
            jAlert('Can Not Add More Quotation Number as Quotation Scheme Exausted.<br />Update The Scheme and Try Again');
            //OnAddNewClick();
        }
        else if (grid.cpSaveSuccessOrFail == "AddressProblem") {
            cbtn_SaveRecords.SetEnabled(true);
            jAlert("Billing and Shipping Address can not be blank.Save unsuccessful.", "Alert", function () { $("#exampleModal").modal('show'); });
            grid.cpSaveSuccessOrFail = null;
            OnAddNewClick();
        }

        else if (grid.cpSaveSuccessOrFail == "duplicateProduct") {
            OnAddNewClick();

            cbtn_SaveRecords.SetEnabled(true);
            jAlert("Duplicate Product not allowed.Save unsuccessful.", "Alert", function () { $("#exampleModal").modal('show'); });
            grid.cpSaveSuccessOrFail = null;
        }
        else if (grid.cpSaveSuccessOrFail == "transporteMandatory") {

            //OnAddNewClick();
            cbtn_SaveRecords.SetEnabled(true);
            jAlert("Transporter is set as Mandatory. Please enter values.", "Alert", function () { $("#exampleModal").modal('show'); });

            grid.cpSaveSuccessOrFail = null;
        }
        else if (grid.cpSaveSuccessOrFail == "TCMandatory") {

            cbtn_SaveRecords.SetEnabled(true);
            //OnAddNewClick();
            jAlert("Terms and Condition is set as Mandatory. Please enter values.", "Alert", function () { $("#TermsConditionseModal").modal('show'); });
            grid.cpSaveSuccessOrFail = null;
            grid.batchEditApi.StartEdit(0, 2);
        }
        else if (grid.cpSaveSuccessOrFail == "duplicate") {

            cbtn_SaveRecords.SetEnabled(true);
            grid.batchEditApi.StartEdit(0, 2);
            jAlert('Can Not Save as Duplicate Quotation Numbe No. Found');
            //if (grid.GetVisibleRowsOnPage() == 0) {
            //    OnAddNewClick();
            //}
        }
        else if (grid.cpSaveSuccessOrFail == "errorInsert") {

            cbtn_SaveRecords.SetEnabled(true);
            grid.batchEditApi.StartEdit(0, 2);
            jAlert('Please try after sometime.');
            //if (grid.GetVisibleRowsOnPage() == 0) {
            //    OnAddNewClick();
            //}
        } else if (grid.cpSaveSuccessOrFail == "Ponotexist") {

            cbtn_SaveRecords.SetEnabled(true);
            grid.batchEditApi.StartEdit(0, 2);
            jAlert('Cannot Save. Selected Purchase Indent(s) in this document do not exist.');
        }
        else if (grid.cpRVMechMainAc == '-20') {

            cbtn_SaveRecords.SetEnabled(true);
            grid.batchEditApi.StartEdit(0, 2);
            jAlert('Reverse Charge is applicable here. No ledger is found mapped for posting within Masters->Accounts->Tax Component Scheme->"Reverse Charge Posting Ledger". Cannot Proceed.');
            OnAddNewClick();
        }
            //grid.JSProperties["cpRVMechMainAc"] = 
            <%-- else if (pageStatus == "delete") {
                 grid.batchEditApi.StartEdit(0, 2);
                 hdndelcnt
                 $('#<%=hdndelcnt.ClientID %>').val('1');
                $('#<%=hdnPageStatus.ClientID %>').val('');

            } --%>
        else {

            var PurchaseOrder_Number = grid.cpPurchaseOrderNo;
            var Order_Msg = "Purchase Invoice No. " + PurchaseOrder_Number + " saved.";
            if (value == "E") {

                cbtn_SaveRecords.SetEnabled(true);
                if (grid.cpApproverStatus == "approve") {
                    window.parent.popup.Hide();
                    window.parent.cgridPendingApproval.PerformCallback();
                }
                else if (grid.cpApproverStatus == "rejected") {
                    window.parent.popup.Hide();
                    window.parent.cgridPendingApproval.PerformCallback();
                }
                // window.location.assign("PurchaseInvoiceListForTransporter.aspx");
                if (PurchaseOrder_Number != "") {
                    jAlert(Order_Msg, 'Alert Dialog: [PurchaseInvoice]', function (r) {
                        if (r == true) {
                            if (PurchaseOrder_Number != null) {
                                //var newInvoiceId = grid.cpGeneratedInvoice;
                                //var reportName = "PurchaseInvoice-GST~D";
                                //window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=PInvoice&id=' + newInvoiceId + '&PrintOption=1', '_blank')
                            }
                            grid.cpPurchaseOrderNo = null;
                            grid.cpGeneratedInvoice = null;
                            window.location.assign("PurchaseInvoiceListForTransporter.aspx");
                        }
                    });

                }
                else {
                    window.location.assign("PurchaseInvoiceListForTransporter.aspx");
                }
            }
            else if (value == "N") {

                cbtn_SaveRecords.SetEnabled(true);
                if (grid.cpApproverStatus == "approve") {
                    window.parent.popup.Hide();
                    window.parent.cgridPendingApproval.PerformCallback();
                }
                else if (grid.cpApproverStatus == "rejected") {
                    window.parent.popup.Hide();
                    window.parent.cgridPendingApproval.PerformCallback();
                }
                if (PurchaseOrder_Number != "") {
                    jAlert(Order_Msg, 'Alert Dialog: [PurchaseInvoice]', function (r) {

                        //grid.cpSalesOrderNo = null;
                        if (r == true) {
                            if (PurchaseOrder_Number != null) {
                                //var newInvoiceId = grid.cpGeneratedInvoice;
                                //var reportName = "PurchaseInvoice-GST~D";
                                //window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=PInvoice&id=' + newInvoiceId + '&PrintOption=1', '_blank')
                            }
                            grid.cpPurchaseOrderNo = null;
                            grid.cpGeneratedInvoice = null;
                            window.location.assign("PurchaseInvoiceforTransporter.aspx?key=ADD");
                        }
                    });


                }
                else {
                    window.location.assign("PurchaseInvoiceforTransporter.aspx?key=ADD");

                }
            }
            else {
                if (pageStatus == "first") {
                    if (grid.GetVisibleRowsOnPage() == 0) {
                        OnAddNewClick();

                        grid.batchEditApi.EndEdit();
                        // document.getElementByIdfocus();
                        $('#<%=hdnPageStatus.ClientID %>').val('');
                        var val = '<%= Session["schemavaluePB"] %>';
                        if (val != '') {
                            $.ajax({
                                type: "POST",
                                url: 'PurchaseInvoiceforTransporter.aspx/getSchemeType',
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                data: "{sel_scheme_id:\"" + val + "\"}",
                                success: function (type) {

                                    var schemetypeValue = type.d;
                                    var schemetype = schemetypeValue.toString().split('~')[0];
                                    var schemelength = schemetypeValue.toString().split('~')[1];
                                    $('#txtVoucherNo').attr('maxLength', schemelength);
                                    if (schemetype == '0') {

                                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = false;
                                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
                                        $("#txtVoucherNo").focus();
                                        if ($('#<%=hdnManual.ClientID %>').val() == 'N') {
                                            cPLQuoteDate.SetEnabled(false);
                                        }
                                        else if ($('#<%=hdnManual.ClientID %>').val() == 'Y') {
                                            cPLQuoteDate.SetEnabled(true);
                                        }

                                    }
                                    else if (schemetype == '1') {

                                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Auto";
                                        cPLQuoteDate.Focus();
                                        $("#MandatoryBillNo").hide();
                                        if ($('#<%=hdnAuto.ClientID %>').val() == 'N') {
                                            cPLQuoteDate.SetEnabled(false);
                                        }
                                        else if ($('#<%=hdnAuto.ClientID %>').val() == 'Y') {
                                            cPLQuoteDate.SetEnabled(true);
                                        }

                                    }
                                    else if (schemetype == '2') {

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
        }

    }
    else if (pageStatus == "update") {

        OnAddNewClick();
        $('#<%=hdnPageStatus.ClientID %>').val('');
        }
        else if (pageStatus == "Quoteupdate") {
            cProductsPopup.Hide();
            //OnAddGridNewClick();
            grid.StartEditRow(0);
            $('#<%=hdnPageStatus.ClientID %>').val('');
        }
        else if (pageStatus == "delete") {
            // grid.StartEditRow(0);
            var inventoryItem = $('#ddlInventory').val();
            if (inventoryItem == 'N') {
                var schemeid = cddl_TdsScheme.GetValue()
                if (schemeid != '0') {
                                <%--$('#<%=hdntdschecking.ClientID %>').val('1')--%>
                }
            }
            OnAddNewClick();
            $('#<%=hdnPageStatus.ClientID %>').val('');
        }

        else {
            //grid.StartEditRow(0);
            //grid.batchEditApi.EndEdit();
                        <%--OnAddNewClick();
                        $('#<%=hdnPageStatus.ClientID %>').val('');--%>
        }
            }
        }
        if (grid.cpdelete != null && grid.cpdelete != '' && grid.cpdelete != undefined) {
            if (grid.cpdelete == 'Y') {
                $('#<%=hdnDeleteSrlNo.ClientID %>').val('');
            }
        }
        var inventoryItem = $('#ddlInventory').val();
        if (inventoryItem != 'N') {
            if (gridquotationLookup.GetValue() != null) {
                grid.GetEditor('ProductName').SetEnabled(false);
                grid.GetEditor('Description').SetEnabled(false);
                grid.StartEditRow(0);
                $('#<%=hdnPageStatus.ClientID %>').val('');
            }
        }
        //else
        //{
        //    grid.GetEditor('ProductName').SetEnabled(true);
        //    grid.GetEditor('Description').SetEnabled(true);
        //    if (grid.GetVisibleRowsOnPage() == 0) {
        //        OnAddNewClick();
        //    }
        //    $("#txtVoucherNo").focus();
        //}
        //cProductsPopup.Hide();

        if (cchk_reversemechenism.GetValue()) {
            grid.GetEditor('TaxAmount').SetEnabled(false);
        }

        if (grid.cpPurchaseorderbindnewrow == "yes") {
            grid.AddNewRow();
            var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var tbQuotation = grid.GetEditor("SrlNo");
            tbQuotation.SetValue(noofvisiblerows);
        }

        if (grid.cpOrderRunningBalance) {
            var RunningBalance = grid.cpOrderRunningBalance;
            var RunningSpliteDetails = RunningBalance.split("~");
            grid.cpOrderRunningBalance = null;

            var SUM_ChargesAmount = RunningSpliteDetails[0];
            var SUM_Amount = RunningSpliteDetails[1];
            //var SUM_ChargesAmount = RunningSpliteDetails[2];
            var SUM_TaxAmount = RunningSpliteDetails[3];
            var SUM_TotalAmount = RunningSpliteDetails[4];
            //var SUM_TotalAmount = RunningSpliteDetails[5];
            var SUM_ProductQuantity = parseFloat(RunningSpliteDetails[6]).toFixed(2);

            cTaxableAmtval.SetValue(SUM_Amount);
            cTaxAmtval.SetValue(SUM_TaxAmount);
            ctxt_Charges.SetValue(SUM_ChargesAmount);
            cOtherTaxAmtval.SetValue(SUM_ChargesAmount);
            cInvValue.SetValue(SUM_TotalAmount);
            cTotalAmt.SetValue(SUM_TotalAmount);
            cTotalQty.SetValue(SUM_ProductQuantity);
        }

    }
    function GridCallBack() {
        //page.GetTabByName('[B]illing/Shipping').SetEnabled(false);
        grid.PerformCallback('Display');

    }

    function TDSDetail(s, e) {
        var inventoryItem = $('#ddlInventory').val();
        if (inventoryItem == 'N') {
            //grid.batchEditApi.StartEdit(e.visibleIndex);
            document.getElementById('hdnInvWiseSlno').value = grid.GetEditor('SrlNo').GetText();
            var Productdtl = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "";
            var Amt = (grid.GetEditor('Amount').GetText() != null) ? grid.GetEditor('Amount').GetText() : "0";
            var Productdt = Productdtl.split("||@||");
            var ProductID = Productdt[0];
            //if (ProductID == "")
            //{
            //    jAlert('Select a product first')
            //    return;
            //}
            //else
            //{
            ctxt_proamt.SetText('Amt');
            cgridinventory.PerformCallback(ProductID + '~' + Amt + '~' + 'ShowBindGrid');
            //}


        }
    }
    function OnCustomButtonClick(s, e) {

        if (e.buttonID == 'CustomDelete') {
            grid.batchEditApi.StartEdit();
            var SrlNo = grid.batchEditApi.GetCellValue(e.visibleIndex, 'SrlNo');
            //grid.batchEditApi.EndEdit();
            //grid.batchEditApi.StartEdit();
            //grid.batchEditApi.EndEdit();

            //grid.batchEditApi.EndEdit();

            $('#<%=hdnRefreshType.ClientID %>').val('');
            $('#<%=hdnDeleteSrlNo.ClientID %>').val(SrlNo);
            var inventoryItem = $('#ddlInventory').val();
            if (inventoryItem == 'Y' || inventoryItem == 'B') {
                if (gridquotationLookup.GetValue() != null) {
                    //jAlert();
                    var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                    if (type == 'PO') {
                               
                        jAlert('Cannot Delete using this button as the Purchase Order is linked with this Purchase Invoice.<br/>Click on Plus(+) sign to Add or Delete Product from last column.!', 'Alert Dialog', function (r) { });
                    }
                    else if (type == 'PC') {
                        $('#<%=hdnDeleteSrlNo.ClientID %>').val('');
                        jAlert('Cannot Delete using this button as the Purchase Challan is linked with this Purchase Invoice.<br/>Click on Plus(+) sign to Add or Delete Product from last column.!', 'Alert Dialog', function (r) { });
                    }
                }
                else {
                    var noofvisiblerows = grid.GetVisibleRowsOnPage();
                    //if (noofvisiblerows != "1" && lookup_quotation.GetValue() == null) {
                    if (noofvisiblerows != "1" && gridquotationLookup.GetValue() == null) {

                        // Running total Calculation Start

                        Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                        Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
                        Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
                        Cur_Quantity = "0";
                        Cur_Amt = "0";
                        Cur_TotalAmt = "0";
                        CalculateAmount();

                        // Running total Calculation End


                        grid.DeleteRow(e.visibleIndex);
                        if (inventoryItem == 'N') {
                            $('#<%=hdinvetorttype.ClientID %>').val('N');
                        }
                        $('#<%=hdfIsDelete.ClientID %>').val('D');
                        grid.UpdateEdit();

                        //grid.PerformCallback('Display');
                        //grid.batchEditApi.StartEdit(-1, 2);
                        //grid.batchEditApi.StartEdit(0, 2);
                        $('#<%=hdnPageStatus.ClientID %>').val('delete');

                    }
                }
            }
            else {
                var noofvisiblerows = grid.GetVisibleRowsOnPage();
                //if (noofvisiblerows != "1" && lookup_quotation.GetValue() == null) {
                if (noofvisiblerows != "1") {

                    // Running total Calculation Start

                    Pre_Quantity = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
                    Pre_Amt = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
                    Pre_TotalAmt = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";
                    Cur_Quantity = "0";
                    Cur_Amt = "0";
                    Cur_TotalAmt = "0";
                    CalculateAmount();

                    // Running total Calculation End


                    grid.DeleteRow(e.visibleIndex);
                    if (inventoryItem == 'N') {
                        $('#<%=hdinvetorttype.ClientID %>').val('N');
                    }
                    $('#<%=hdfIsDelete.ClientID %>').val('D');
                    grid.UpdateEdit();

                    //grid.PerformCallback('Display');
                    //grid.batchEditApi.StartEdit(-1, 2);
                    //grid.batchEditApi.StartEdit(0, 2);
                    $('#<%=hdnPageStatus.ClientID %>').val('delete');

                    }
                }
            }
            if (e.buttonID == 'CustomAddNewRow') {
                grid.batchEditApi.StartEdit(e.visibleIndex);

                var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "";
                var scembranch = '';
                //if (ProductID != "" && ProductID != null) {
                if (ProductID != "") {
                    var inventoryItem = $('#ddlInventory').val();
                    if (inventoryItem == 'N') {
                <%--if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                    var val = $("#ddl_numberingScheme").val();

                    var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                    if (schemabranch != '' && schemabranch != undefined) {
                        scembranch = schemabranch;
                    }
                }--%>
                        var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
                        var vendorid = GetObjectID('hdnCustomerId').value
                        if (customerval == '' || customerval == null) {
                            jAlert('Select a vendor first');
                            return
                        }
                        else {
                            var Productdtl = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "";
                            if (Productdtl != null && Productdtl != '') {
                                var Productdt = Productdtl.split("||@||");
                                var ProductID = Productdt[0];
                                var schemeid = cddl_TdsScheme.GetValue()
                                if (schemeid != '0') {
                                    document.getElementById('hdnInvWiseSlno').value = grid.GetEditor('SrlNo').GetText();

                                    var Productdtl = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "";
                                    var Amt = (grid.GetEditor('Amount').GetText() != null) ? grid.GetEditor('Amount').GetText() : "0";
                                    var Productdt = Productdtl.split("||@||");
                                    var ProductID = Productdt[0];
                                    ctxt_proamt.SetText('Amt');
                                    //cgridinventory.PerformCallback(ProductID + '~' + Amt + '~' + 'ShowBindGrid');
                                    cgridinventory.PerformCallback(ProductID + '~' + Amt + '~' + 'ShowBindGrid' + '~' + 'CheckApplicableAmt');

                                    var slno = grid.GetEditor('SrlNo').GetValue();
                                    if ($('#<%=hdntdschecking.ClientID %>').val() != '') {
                                        var myArray = $('#<%=hdntdschecking.ClientID %>').val().split(',');
                                        var index = myArray.indexOf(slno);
                                        if (index > -1) {
                                            myArray.splice(index, 1);
                                            $('#<%=hdntdschecking.ClientID %>').val(myArray);
                                    }
                                }
                                    //var frontAmt = 0;
                                    //var frontRow = 0;
                                    //var backRow = -1;
                                    //var backAmt = 0;
                                    //for (var i = 0; i < grid.GetVisibleRowsOnPage() ; i++) {
                                    //    frontAmt += parseFloat((grid.batchEditApi.GetCellValue(backRow, 'Amount') != null) ? (grid.batchEditApi.GetCellValue(backRow, 'Amount')) : '0.00');
                                    //    backAmt += parseFloat((grid.batchEditApi.GetCellValue(frontRow, 'Amount') != null) ? (grid.batchEditApi.GetCellValue(frontRow, 'Amount')) : '0.00');

                                    //    //if (frontProduct != "" || backProduct != "") {
                                    //    //    IsProduct = "Y";
                                    //    //    break;
                                    //    //}

                                    //    backRow--;
                                    //    frontRow++;
                                    //}
                                    //if (frontAmt != 0) {
                                    //    //cgridinventory.PerformCallback('ApplicableAmtChecking' + '~' + vendorid + '~' + schemeid + '~' + frontAmt);
                                    //}
                                    //else {
                                    //    //cgridinventory.PerformCallback('ApplicableAmtChecking' + '~' + vendorid + '~' + schemeid + '~' + backAmt);
                                    //}
                                    //cgridinventory.PerformCallback('ApplicableAmtChecking' + '~' + vendorid + '~' + schemeid + '~' + frontAmt);
                            }
                            else {
                                OnAddNewClick();
                            }

                                //CApplicableAmtPopup.PerformCallback('ApplicableAmtChecking' + '~' + vendorid + '~' + schemeid + '~' + frontAmt);
                        }
                        else {
                            jAlert('Select a Product first.');
                            return;
                        }
                    }

                        // geet Start on 18082017
                <%-- document.getElementById('hdnInvWiseSlno').value = grid.GetEditor('SrlNo').GetText();

                var Productdtl = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "";
                var Amt = (grid.GetEditor('Amount').GetText() != null) ? grid.GetEditor('Amount').GetText() : "0";
                var Productdt = Productdtl.split("||@||");
                var ProductID = Productdt[0];
                ctxt_proamt.SetText('Amt');
                //cgridinventory.PerformCallback(ProductID + '~' + Amt + '~' + 'ShowBindGrid');
                cgridinventory.PerformCallback(ProductID + '~' + Amt + '~' + 'ShowBindGrid'+'~'+'CheckApplicableAmt');

                var slno = grid.GetEditor('SrlNo').GetValue();
                if ($('#<%=hdntdschecking.ClientID %>').val() != '') {
                    var myArray = $('#<%=hdntdschecking.ClientID %>').val().split(',');
                    var index = myArray.indexOf(slno);
                    if (index > -1) {
                        myArray.splice(index, 1);
                        $('#<%=hdntdschecking.ClientID %>').val(myArray);
                    }
                } --%>
                        // geet End




                    }

                        //AddBatchNew();
                    else if (gridquotationLookup.GetValue() == null) {
                        //grid.batchEditApi.StartEdit(e.visibleIndex, 3);
                        //var Product = (grid.GetEditor('ProductID').GetValue() != null) ? grid.GetEditor('ProductID').GetValue() : "";


                        // Component tagging Section Start by Sam
                        var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "";
                        var SpliteDetails = ProductID.split("||@||");

                        var IsComponentProduct = SpliteDetails[16];
                        var ComponentProduct = SpliteDetails[17];

                        if (IsComponentProduct == "Y") {
                            var messege = "Selected product is defined with components.<br/> Would you like to proceed with components (" + ComponentProduct + ") ?";
                            jConfirm(messege, 'Confirmation Dialog', function (r) {
                                if (r == true) {
                                    grid.GetEditor("IsComponentProduct").SetValue("Y");
                            <%-- $('#<%=hdfIsDelete.ClientID %>').val('C');--%>
                                    $('#<%=hdfIsComp.ClientID %>').val('C');


                                    grid.UpdateEdit();
                                    grid.PerformCallback('Display~fromComponent');
                                    //grid.batchEditApi.StartEdit(globalRowIndex, 3);
                                }
                                else {
                                    OnAddNewClick();
                                }
                            });
                            document.getElementById('popup_ok').focus();
                        }
                            // Component tagging Section End by Sam
                        else if (ProductID != "") {
                            OnAddNewClick();
                            //grid.AddNewRow();
                            //var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
                            //var tbQuotation = grid.GetEditor("SrlNo");
                            //tbQuotation.SetValue(noofvisiblerows);
                            //setTimeout(function () {
                            //    grid.batchEditApi.StartEdit(globalRowIndex, 3);
                            //}, 500);
                            //return false;
                            //InsgridBatch.batchEditApi.StartEdit(-1, 2);
                        }
                        else {
                            grid.batchEditApi.StartEdit(e.visibleIndex, 2);
                        }
                        //else {
                        //    //grid.batchEditApi.StartEdit(e.visibleIndex, 3);
                        //    setTimeout(function () {
                        //        grid.batchEditApi.StartEdit(globalRowIndex, 3);
                        //    }, 50);
                        //    //return false;
                        //}
                    }
                    else {
                        var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                        if (type == 'PO') {
                            //jAlert('Cannot Delete using this button as the Purchase Order is linked with this Purchase Invoice.<br/>Click on Plus(+) sign to Add or Delete Product from last column.!', 'Alert Dialog', function (r) { });
                            cgridproducts.SetEnabled(false);
                        }
                        else if (type == 'PC') {
                            //jAlert('Cannot Delete using this button as the Purchase Challan is linked with this Purchase Invoice.<br/>Click on Plus(+) sign to Add or Delete Product from last column.!', 'Alert Dialog', function (r) { });
                            cgridproducts.SetEnabled(false);
                        }
                        QuotationNumberChanged();
                    }
            }
            else {
                jAlert('Select a product first');
                    //grid.GetEditor('ProductID').Focus();
                grid.GetEditor("ProductName").Focus();
                return;
            }



        }
        else if (e.buttonID == 'CustomWarehouse') {
            var inventoryItem = $('#ddlInventory').val();
            if (inventoryItem == 'N') {
                jAlert("NonInventory Item has no warehouse detail.")
                return
            }
            var index = e.visibleIndex;
            grid.batchEditApi.StartEdit(index, 2)
            Warehouseindex = index;
            //document.getElementById('setCurrentProdCode').value = e.visibleIndex;
            document.getElementById('hdngridvselectedrowno').value = e.visibleIndex;
            var SrlNo = (grid.GetEditor('SrlNo').GetValue() != null) ? grid.GetEditor('SrlNo').GetValue() : "";
            var ProductID = (grid.GetEditor('ProductID').GetValue() != null) ? grid.GetEditor('ProductID').GetValue() : "";
            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
            if (type != 'PC' && type != 'PO') {
                return;
            }
            if (QuantityValue == "0.0") {
                jAlert("Quantity should not be zero !.");
            }
                //else if(type=='PC' || type=='PO')
                //{
                //    //jAlert('Invoice is tagged with other document.Cannot change Stock Details.')
                //    //return;
                //    cbtnaddWarehouse.SetEnabled(false); // During Tagging Add button should be Enabled false
                //    cbtnWarehouse.SetEnabled(false);    // During Tagging Save button should be Enabled false
                //}
            else {
                if (type == 'PC' || type == 'PO') {
                    cbtnaddWarehouse.SetVisible(false); // During Tagging Add button should be Enabled false
                    cbtnWarehouse.SetVisible(false);
                    cButton1.SetVisible(false);
                    cbtnrefreshWarehouse.SetVisible(false);
                    cCmbWarehouse.SetEnabled(false);
                }
                else {

                    cbtnaddWarehouse.SetVisible(true);
                    cbtnWarehouse.SetVisible(true);
                    cButton1.SetVisible(true);
                    cbtnrefreshWarehouse.SetVisible(true);
                    cCmbWarehouse.SetEnabled(true);
                }
                $("#spnCmbWarehouse").hide();  // First Hide during stock detail clicking
                $("#spnCmbBatch").hide();      // First Hide during stock detail clicking
                $("#spncheckComboBox").hide(); // First Hide during stock detail clicking
                $("#spntxtQuantity").hide();   // First Hide during stock detail clicking
                //alert(ProductID);
                if (ProductID != "") {
                    var SpliteDetails = ProductID.split("||@||");
                    var strProductID = SpliteDetails[0];
                    var strDescription = SpliteDetails[1];
                    var strUOM = SpliteDetails[2];
                    var strStkUOM = SpliteDetails[4];
                    var strMultiplier = SpliteDetails[7];
                    var strProductName = (grid.GetEditor('ProductName').GetText() != null) ? grid.GetEditor('ProductName').GetText() : "";
                    var StkQuantityValue = QuantityValue * strMultiplier;
                    //alert(strProductID);
                    $('#<%=hdfProductIDPC.ClientID %>').val(strProductID);  // assign Productid of the selected row
                $('#<%=hdfProductType.ClientID %>').val("");            // assign Producttype of the selected row
                $('#<%=hdfProductSerialID.ClientID %>').val(SrlNo);     // assign sl no of the selected row
            <%--$('#<%=hdfProductSerialID.ClientID %>').val(SrlNo);--%>
                $('#<%=hdnProductQuantity.ClientID %>').val(QuantityValue); // assign Product qty of the selected row
                var Ptype = "";

                $('#<%=hdnisserial.ClientID %>').val("");        // serial id is black initialized in first time
                    $('#<%=hdnisbatch.ClientID %>').val("");     // Batch id is black initialized in first time
                $('#<%=hdniswarehouse.ClientID %>').val("");    // Warehouse id is black initialized in first time

                $.ajax({
                    type: "POST",
                    url: 'PurchaseChallan.aspx/getProductType',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: "{Products_ID:\"" + strProductID + "\"}",
                    success: function (type) {
                        Ptype = type.d;
                        $('#<%=hdfProductType.ClientID %>').val(Ptype);
                            //alert(Ptype);
                            if (Ptype == "") {
                                jAlert("No Warehouse or Batch or Serial is actived !.");
                            } else {
                                if (Ptype == "W") {
                                    $('#<%=hdnisserial.ClientID %>').val("false");
                                    $('#<%=hdnisbatch.ClientID %>').val("false");
                                    $('#<%=hdniswarehouse.ClientID %>').val("true");
                                    //cCmbWarehouse.PerformCallback('BindWarehouse');

                                }

                                else if (Ptype == "B") {
                                    $('#<%=hdnisserial.ClientID %>').val("false");
                            $('#<%=hdnisbatch.ClientID %>').val("true");
                            $('#<%=hdniswarehouse.ClientID %>').val("false");

                        }
                        else if (Ptype == "S") {
                            $('#<%=hdnisserial.ClientID %>').val("true");
                            $('#<%=hdnisbatch.ClientID %>').val("false");
                            $('#<%=hdniswarehouse.ClientID %>').val("false");

                        }
                        else if (Ptype == "WB") {

                            $('#<%=hdnisserial.ClientID %>').val("false");
                            $('#<%=hdnisbatch.ClientID %>').val("true");
                            $('#<%=hdniswarehouse.ClientID %>').val("true");
                            //cCmbWarehouse.PerformCallback('BindWarehouse');
                            //cGrdWarehousePC.PerformCallback('Display~' + SrlNo);
                        }
                        else if (Ptype == "WS") {
                            $('#<%=hdnisserial.ClientID %>').val("true");
                            $('#<%=hdnisbatch.ClientID %>').val("false");
                            $('#<%=hdniswarehouse.ClientID %>').val("true");
                            //cCmbWarehouse.PerformCallback('BindWarehouse');
                            //cGrdWarehousePC.PerformCallback('Display~' + SrlNo);
                        }
                        else if (Ptype == "WBS") {
                            $('#<%=hdnisserial.ClientID %>').val("true");
                                $('#<%=hdnisbatch.ClientID %>').val("true");
                                $('#<%=hdniswarehouse.ClientID %>').val("true");
                                //cCmbWarehouse.PerformCallback('BindWarehouse');
                                //cGrdWarehousePC.PerformCallback('Display~' + SrlNo);
                            }
                            else if (Ptype == "BS") {
                                $('#<%=hdnisserial.ClientID %>').val("true");
                            $('#<%=hdnisbatch.ClientID %>').val("true");
                            $('#<%=hdniswarehouse.ClientID %>').val("false");

                            //cCmbBatch.PerformCallback('BindBatch~' + "0");
                            //cGrdWarehousePC.PerformCallback('Display~' + SrlNo);
                        }
                        else {
                            $('#<%=hdnisserial.ClientID %>').val("false");
                            $('#<%=hdnisbatch.ClientID %>').val("false");
                            $('#<%=hdniswarehouse.ClientID %>').val("false");
                        }

    $("#RequiredFieldValidatortxtbatch").css("display", "none");         // validation are hidden in starting for batch detail txt box
    $("#RequiredFieldValidatortxtserial").css("display", "none");        // validation are hidden in starting for serial detail txt box
    $("#RequiredFieldValidatorCmbWarehouse").css("display", "none");     // validation are hidden in starting for ware house detail txt box

    $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");   // validation are hidden in starting for batch qty txt box
    $("#RequiredFieldValidatortxtwareqntity").css("display", "none");    // validation are hidden in starting for warehouse qty txt box

    $(".blockone").css("display", "none");                // this div is hidden for warehouse detail in starting
    $(".blocktwo").css("display", "none");                 // this div is hidden for Batch detail in starting
    $(".blockthree").css("display", "none");             // this div is hidden for Serial detail in starting

    ctxtqnty.SetText("0.0");            // for warehouse quantity text box
    ctxtqnty.SetEnabled(true);

    ctxtbatchqnty.SetText("0.0");       // for Batch quantity text box not for detail text box
    ctxtserial.SetText("");             // for serial  detail text box
    ctxtbatchqnty.SetText("");

    ctxtbatch.SetEnabled(true);        // for Batch Number text box
    cCmbWarehouse.SetEnabled(true);

    $('#<%=hdnoutstock.ClientID %>').val("0");              // starting Phase
    $('#<%=hdnisedited.ClientID %>').val("false");           // starting Phase
                                $('#<%=hdnisoldupdate.ClientID %>').val("false");        // starting Phase
                                $('#<%=hdnisnewupdate.ClientID %>').val("false");        // starting Phase

                                $('#<%=hdnisolddeleted.ClientID %>').val("false");       // starting Phase

                                $('#<%=hdntotalqntyPC.ClientID %>').val(0);              // starting Phase
                                $('#<%=hdnoldrowcount.ClientID %>').val(0);              // starting Phase
                                $('#<%=hdndeleteqnity.ClientID %>').val(0);              // starting Phase
                                $('#<%=hidencountforserial.ClientID %>').val("1");       // starting Phase

                                $('#<%=hdfstockidPC.ClientID %>').val(0);               // starting Phase
                                $('#<%=hdfopeningstockPC.ClientID %>').val(0);          // starting Phase
                                $('#<%=oldopeningqntity.ClientID %>').val(0);           // starting Phase
                                $('#<%=hdnnewenterqntity.ClientID %>').val(0);          // starting Phase

                                $('#<%=hdnenterdopenqnty.ClientID %>').val(0);         // starting Phase
                                $('#<%=hdbranchIDPC.ClientID %>').val(0);              // starting Phase

                                $('#<%=hdnisviewqntityhas.ClientID %>').val("false");  // starting Phase


                                $('#<%=hdndefaultID.ClientID %>').val("");             // starting Phase
                                $('#<%=hdnbatchchanged.ClientID %>').val("0");        // starting Phase
                                $('#<%=hdnrate.ClientID %>').val("0");                // starting Phase
                                $('#<%=hdnvalue.ClientID %>').val("0");               // starting Phase
                                $('#<%=hdnstrUOM.ClientID %>').val(strUOM);          // starting Phase
                                // var branchid = ccmbbranch.GetValue();
                                var branchid = $("#ddl_Branch option:selected").val();

                                $('#<%=hdnisreduing.ClientID %>').val("false");

                                //var productid = strProductID ? strProductID : "";
                        var productid = SpliteDetails[0] ? SpliteDetails[0] : "";

                        var StkQuantityValue = QuantityValue ? QuantityValue : "0.0000";

                                //  Commented By Sandip to avoid Stockid Start
                                // var stockids = SpliteDetails[10];
                        var stockids = 0;
                                //  Commented By Sandip to avoid Stockid End

                        var checkstockdecimalornot = StkQuantityValue.toString().split(".")[1]

                        $('#<%=hdnpcslno.ClientID %>').val(SrlNo);
                                //var ProductName = (cOpeningGrid.GetEditor('ProductName').GetValue() != null) ? cOpeningGrid.GetEditor('ProductID').GetValue() : "";
                                //var ProductName = SpliteDetails[12];
                                //var ProductName = strProductName;
                        var ProductName = SpliteDetails[1] ? SpliteDetails[1] : "";
                        var ratevalue = "0";
                        var rate = "0";
                                // var branchid = (cOpeningGrid.GetEditor('branch').GetValue() != null) ? cOpeningGrid.GetEditor('branch').GetValue() : "0";
                                // var branchid = ccmbbranch.GetValue();
                        var branchid = $('#<%=ddl_Branch.ClientID %>').val();
                                //var BranchNames = (cOpeningGrid.GetEditor('branch').GetText() != null) ? cOpeningGrid.GetEditor('branch').GetText() : "0";
                                //var BranchNames = ccmbbranch.GetText();

                        var BranchNames = $("#ddl_Branch option:selected").text();
                                //alert(BranchNames);
                                // ProductName = ProductName.replace('dquote', '"');
                        var strProductID = productid;
                        var strDescription = "";
                        var strUOM = (strUOM != null) ? strUOM : "0";
                        var strProductName = ProductName;

                        document.getElementById('<%=lblbranchName.ClientID %>').innerHTML = BranchNames;
                        var availablestock = SpliteDetails[12];
                        $('#<%=hdndefaultID.ClientID %>').val("0");

                            $('#<%=hdfstockidPC.ClientID %>').val(stockids);
                                var calculateopein = Number(StkQuantityValue) - Number(availablestock);
                                var oldopeing = 0;
                                var oldqnt = Number(oldopeing);

                                $('#<%=hdfopeningstockPC.ClientID %>').val(QuantityValue);
                        $('#<%=oldopeningqntity.ClientID %>').val(0);
                                $('#<%=hdnnewenterqntity.ClientID %>').val(QuantityValue);
                                $('#<%=hdnenterdopenqnty.ClientID %>').val(0);
                                $('#<%=hdbranchIDPC.ClientID %>').val(branchid);
                                $('#<%=hdnselectedbranch.ClientID %>').val(branchid);

                                $('#<%=hdnrate.ClientID %>').val(rate);
                                $('#<%=hdnvalue.ClientID %>').val(ratevalue);

                                var dtd = (Number(StkQuantityValue)).toFixed(4);

                                $("#lblopeningstock").text(dtd + " " + strUOM);

                                ctxtmkgdate.SetDate = null;
                                txtexpirdate.SetDate = null;
                                ctxtserial.SetValue("");
                                ctxtbatch.SetValue("");
                                ctxtqnty.SetValue("0.0");
                                ctxtbatchqnty.SetValue("0.0");

                                var hv = $('#hdnselectedbranch').val();

                                var iswarehousactive = $('#hdniswarehouse').val();
                                var isactivebatch = $('#hdnisbatch').val();
                                var isactiveserial = $('#hdnisserial').val();
                                // alert(iswarehousactive + "/" + isactivebatch + "/" + isactiveserial);

                                cCmbWarehouse.PerformCallback('BindWarehouse');




                                if (iswarehousactive == "true") {    // If Product type Has WH or W Type

                                    cCmbWarehouse.SetVisible(true);
                                    cCmbWarehouse.SetSelectedIndex(1);
                                    cCmbWarehouse.Focus();
                                    ctxtqnty.SetVisible(true);
                                    $('#<%=hdniswarehouse.ClientID %>').val("true");

                            $(".blockone").css("display", "block");

                        } else {
                            cCmbWarehouse.SetVisible(false);
                            ctxtqnty.SetVisible(false);
                            $('#<%=hdniswarehouse.ClientID %>').val("false");
                            cCmbWarehouse.SetSelectedIndex(-1);
                            $(".blockone").css("display", "none");

                        }

                        if (isactivebatch == "true") {

                            ctxtbatch.SetVisible(true);
                            ctxtmkgdate.SetVisible(true);
                            ctxtexpirdate.SetVisible(true);
                            $('#<%=hdnisbatch.ClientID %>').val("true");

                            $(".blocktwo").css("display", "block");

                        } else {
                            ctxtbatch.SetVisible(false);
                            ctxtmkgdate.SetVisible(false);
                            ctxtexpirdate.SetVisible(false);
                            $('#<%=hdnisbatch.ClientID %>').val("false");

                            $(".blocktwo").css("display", "none");

                        }
                        if (isactiveserial == "true") {
                            ctxtserial.SetVisible(true);
                            $('#<%=hdnisserial.ClientID %>').val("true");


                                $(".blockthree").css("display", "block");
                            } else {
                                ctxtserial.SetVisible(false);
                                $('#<%=hdnisserial.ClientID %>').val("false");


                            $(".blockthree").css("display", "none");
                        }

                        if (iswarehousactive == "false" && isactivebatch == "true") {
                            ctxtbatchqnty.SetVisible(true);

                            $(".blocktwoqntity").css("display", "block");
                        } else {
                            ctxtbatchqnty.SetVisible(false);
                            $(".blocktwoqntity").css("display", "none");
                        }

                        if (iswarehousactive == "false" && isactivebatch == "true") {
                            ctxtbatch.Focus();
                        } else {
                            cCmbWarehouse.Focus();
                        }

                                //cbtnWarehouse.SetVisible(true);
                        cGrdWarehousePC.PerformCallback('checkdataexist~' + strProductID + '~' + stockids + '~' + branchid + '~' + strProductName);

                        cPopup_WarehousePC.Show();
                    }
                        }
                    });
        }

            ////////





    }
}


}
function Save_ButtonClick() {
    flag = true;
    LoadingPanel.Show();
    cbtn_SaveRecords.SetEnabled(false);
    // Custom Control Data Bind      
    $('#<%=hfControlData.ClientID %>').val($('#hfControlSaveData').val());
    var txtPurchaseNo = $("#txtVoucherNo").val();
    var ddl_Vendor = $("#ddl_Vendor").val();
    var Podt = cPLQuoteDate.GetValue();
    if (txtPurchaseNo == null || txtPurchaseNo == "") {
        flag = false;
        $("#MandatoryBillNo").show();
        LoadingPanel.Hide();
        return false;
    }
    var Podt = cPLQuoteDate.GetValue();
    if (Podt == null) {
        LoadingPanel.Hide();
        $("#MandatoryDate").show();
        flag = false;
        return false;
    }
    var invtype = $('#ddlInventory').val();
    if (invtype != 'N') {
        if (ctxt_partyInvNo.GetText() == '' || ctxt_partyInvNo.GetText() == null) {
            flag = false;
            $("#MandatorysPartyinvno").show();
            LoadingPanel.Hide();
            return false;
        }
    }
    // Invoice Date validation Start
    var sdate = cdt_partyInvDt.GetValue();
    var edate = cPLQuoteDate.GetValue();
    var startDate = new Date(sdate);
    var endDate = new Date(edate);
    if (invtype == 'N') {
        if (sdate == null || sdate == "") {
        }
        else {
            $('#MandatoryPartyDate').attr('style', 'display:none');

            if (startDate > endDate) {
                LoadingPanel.Hide();
                flag = false;
                $('#MandatoryEgSDate').attr('style', 'display:block');
            }
            else { $('#MandatoryEgSDate').attr('style', 'display:none'); }
        }
    }
    else if (invtype != 'N') {
        if (sdate == null || sdate == "") {
            flag = false;
            $('#MandatoryPartyDate').attr('style', 'display:block');
            LoadingPanel.Hide();
            return false;
        }
        else {
            $('#MandatoryPartyDate').attr('style', 'display:none');
            if (startDate > endDate) {
                LoadingPanel.Hide();
                flag = false;
                $('#MandatoryEgSDate').attr('style', 'display:block');
            }
            else { $('#MandatoryEgSDate').attr('style', 'display:none'); }
        }
    }
    var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
    if (customerval == '' || customerval == null) {
        LoadingPanel.Hide();
        $('#MandatorysVendor').attr('style', 'display:block');
        return false;
    }
    else {
        $('#MandatorysVendor').attr('style', 'display:none');
    }
    if (Podt == null) {
        $("#MandatoryDate").show();
        LoadingPanel.Hide();
        return false;
    }
    var frontRow = 0;
    var backRow = -1;
    var IsProduct = "";
    for (var i = 0; i <= grid.GetVisibleRowsOnPage() ; i++) {
        var frontProduct = (grid.batchEditApi.GetCellValue(backRow, 'ProductID') != null) ? (grid.batchEditApi.GetCellValue(backRow, 'ProductID')) : "";
        var backProduct = (grid.batchEditApi.GetCellValue(frontRow, 'ProductID') != null) ? (grid.batchEditApi.GetCellValue(frontRow, 'ProductID')) : "";

        if (frontProduct != "" || backProduct != "") {
            IsProduct = "Y";
            break;
        }

        backRow--;
        frontRow++;
    }
    if (flag != false) {
        if (IsProduct == "Y") {
            var inventoryItem = $('#ddlInventory').val();
            if (inventoryItem == 'N' && cddl_TdsScheme.GetValue() != '0') {
                if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                    var tdschk = $('#<%=hdntdschecking.ClientID %>').val()
                    if (tdschk != '') {
                        LoadingPanel.Hide();
                        jAlert('Please enter TDS detail for Sl no.' + tdschk)
                        return false;

                    }
                }
            }
            if (grid.GetVisibleRowsOnPage() > 0) {
                var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
                $('#<%=hdfLookupCustomer.ClientID %>').val(customerval);
                $('#<%=hdfIsDelete.ClientID %>').val('I');
                $('#<%=hdnRefreshType.ClientID %>').val('N');
                grid.batchEditApi.EndEdit();
                cacbpCrpUdf.PerformCallback();
            }
            else {
                LoadingPanel.Hide();
                jAlert('Please add atleast single record first');
            }
        }
        else {
            LoadingPanel.Hide();
            jAlert('Cannot Save. You must enter atleast one Product to save this entry.');
        }
    }
}


function SaveExit_ButtonClick() {
    flag = true;
    LoadingPanel.Show();
    cbtn_SaveRecords.SetEnabled(false);
    // Custom Control Data Bind      
    $('#<%=hfControlData.ClientID %>').val($('#hfControlSaveData').val());
    var txtPurchaseNo = $("#txtVoucherNo").val();
    var ddl_Vendor = $("#ddl_Vendor").val();
    // alert(txtPurchaseNo);
    if (txtPurchaseNo == null || txtPurchaseNo == "") {
        LoadingPanel.Hide();
        flag = false;
        $("#MandatoryBillNo").show();
        return false;
    }
    var invtype = $('#ddlInventory').val();
    if (invtype != 'N') {
        if (ctxt_partyInvNo.GetText() == '' || ctxt_partyInvNo.GetText() == null) {
            flag = false;
            $("#MandatorysPartyinvno").show();
            LoadingPanel.Hide();
            return false;
        }
    }
    // Invoice Date validation Start
    var sdate = cdt_partyInvDt.GetValue();
    var edate = cPLQuoteDate.GetValue();
    var startDate = new Date(sdate);
    var endDate = new Date(edate);
    if (invtype == 'N') {
        if (sdate == null || sdate == "") {
        }
        else {
            $('#MandatoryPartyDate').attr('style', 'display:none');

            if (startDate > endDate) {
                LoadingPanel.Hide();
                flag = false;
                $('#MandatoryEgSDate').attr('style', 'display:block');
            }
            else {
                $('#MandatoryEgSDate').attr('style', 'display:none');
                flag = true;
            }
        }
    }
    else if (invtype != 'N') {
        if (sdate == null || sdate == "") {
            flag = false;
            $('#MandatoryPartyDate').attr('style', 'display:block');
            LoadingPanel.Hide();
            return false;
        }
        else {
            $('#MandatoryPartyDate').attr('style', 'display:none');

            if (startDate > endDate) {
                LoadingPanel.Hide();
                return false;
                flag = false;
                $('#MandatoryEgSDate').attr('style', 'display:block');
            }
            else {
                $('#MandatoryEgSDate').attr('style', 'display:none');
                flag = true;
            }
        }
    }
    var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
    if (customerval == '' || customerval == null) {
        LoadingPanel.Hide();
        flag = false;
        $('#MandatorysVendor').attr('style', 'display:block');
        return false;
    }
    else {
        $('#MandatorysVendor').attr('style', 'display:none');
    }
    var frontRow = 0;
    var backRow = -1;
    var IsProduct = "";
    for (var i = 0; i <= grid.GetVisibleRowsOnPage() ; i++) {
        var frontProduct = (grid.batchEditApi.GetCellValue(backRow, 'ProductID') != null) ? (grid.batchEditApi.GetCellValue(backRow, 'ProductID')) : "";
        var backProduct = (grid.batchEditApi.GetCellValue(frontRow, 'ProductID') != null) ? (grid.batchEditApi.GetCellValue(frontRow, 'ProductID')) : "";

        if (frontProduct != "" || backProduct != "") {
            IsProduct = "Y";
            break;
        }
        backRow--;
        frontRow++;
    }
    if (flag != false) {
        if (IsProduct == "Y") {
            var inventoryItem = $('#ddlInventory').val();
            if (inventoryItem == 'N' && cddl_TdsScheme.GetValue() != '0') {
                if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                    var tdschk = $('#<%=hdntdschecking.ClientID %>').val()
                    if (tdschk != '') {
                        LoadingPanel.Hide();
                        //jAlert('Please enter TDS detail.')
                        jAlert('Please enter TDS detail for Sl no.' + tdschk)
                        return false;
                    }
                }
            }
            if (grid.GetVisibleRowsOnPage() > 0) {
                var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
                $('#<%=hdfLookupCustomer.ClientID %>').val(customerval);
                $('#<%=hdnRefreshType.ClientID %>').val('E');
                $('#<%=hdfIsDelete.ClientID %>').val('I');
                grid.batchEditApi.EndEdit();
                cacbpCrpUdf.PerformCallback();
                //grid.UpdateEdit();
            }
            else {
                LoadingPanel.Hide();
                jAlert('Please add atleast single record first');
            }
        }
        else {
            LoadingPanel.Hide();
            jAlert('Cannot Save. You must enter atleast one Product to save this entry.');
        }
    }
}

function OnAddNewClick() {
    var inventoryItem = $('#ddlInventory').val();
    if (inventoryItem != 'N') {
        if (gridquotationLookup.GetValue() == null) {
            grid.AddNewRow();

            var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var tbQuotation = grid.GetEditor("SrlNo");
            tbQuotation.SetValue(noofvisiblerows);
        }
    }
    else {
        grid.AddNewRow();
        var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
        var tbQuotation = grid.GetEditor("SrlNo");
        tbQuotation.SetValue(noofvisiblerows);
    }
    //else {
    //    QuotationNumberChanged();
    //    grid.batchEditApi.StartEdit(0, 2);
    //    //grid.StartEditRow(0);
    //}


}
//function OnAddNewClick() {

//    grid.AddNewRow();
//    var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
//    var i;
//    var cnt = 1;
//    for (i = -1 ; cnt <= noofvisiblerows ; i--) {
//        var tbQuotation = grid.GetEditor("SrlNo");
//        tbQuotation.SetValue(cnt);


//        cnt++;
//    }
//var tbQuotation = grid.GetEditor("SrlNo");
//tbQuotation.SetValue(noofvisiblerows);

//}
function ProductsCombo_SelectedIndexChanged(s, e) {

    var tbDescription = grid.GetEditor("Description");
    var tbUOM = grid.GetEditor("UOM");
    var tbStockUOM = grid.GetEditor("gvColStockUOM");
    var tbPurchasePrice = grid.GetEditor("PurchasePrice");

    var ProductID = (grid.GetEditor('ProductID').GetValue() != null) ? grid.GetEditor('ProductID').GetValue() : "0";
    // var ProductID = s.GetValue();
    var SpliteDetails = ProductID.split("||@||");
    var strProductID = SpliteDetails[0];
    var strDescription = SpliteDetails[1];
    var strUOM = SpliteDetails[2];
    var strStockUOM = SpliteDetails[4];
    var strPurchasePrice = SpliteDetails[6];
    var strStockId = SpliteDetails[10];
    tbDescription.SetValue(strDescription);
    tbUOM.SetValue(strUOM);
    tbStockUOM.SetValue(strStockUOM);
    tbPurchasePrice.SetValue(strPurchasePrice);
    if (ProductID != "0") {
        cacpAvailableStock.PerformCallback(strProductID);
    }

}
function ddl_Currency_Rate_Change() {
    var Campany_ID = '<%=Session["LastCompany"]%>';
    var LocalCurrency = '<%=Session["LocalCurrency"]%>';
    var basedCurrency = LocalCurrency.split("~");
    var Currency_ID = $("#ddl_Currency").val();


    //if ($("#ddl_Currency").text().trim() == basedCurrency[1]) {
    if (Currency_ID == basedCurrency[0]) {
        ctxtRate.SetValue("0.00");
        ctxtRate.SetEnabled(false);
    }
    else {
        $.ajax({
            type: "POST",
            url: "PurchaseInvoiceforTransporter.aspx/GetRate",
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
function ddl_AmountAre_valueChange() {
    var key = $("#ddl_AmountAre").val();
    if (key == 1) {
        // grid.GetEditor('TaxAmount').SetEnabled(true);
        cddlVatGstCst.SetEnabled(false);
        cddlVatGstCst.PerformCallback('1');
    }
    else if (key == 2) {
        // grid.GetEditor('TaxAmount').SetEnabled(true);
        cddlVatGstCst.SetEnabled(true);
        cddlVatGstCst.PerformCallback('2');

    }
    else if (key == 3) {
        //  grid.GetEditor('TaxAmount').SetEnabled(false);
        cddlVatGstCst.SetEnabled(false);
        cddlVatGstCst.PerformCallback('3');

    }
}
//function ddl_Vendor_ValueChange() {
//    var venderId = $("#ddl_Vendor").val();
//    cContactPerson.PerformCallback("BindContact~" + venderId);
//}
//function GetIndentREquiNo(e) {

//    var PODate = new Date();
//    PODate = cPLQuoteDate.GetValueString();
//    cQuotationComponentPanel.PerformCallback('BindIndentGrid' + '~' + PODate);
//    ctaxUpdatePanel.PerformCallback('DeleteAllTax');
//    grid.PerformCallback('GridBlank');
//}

function GetIndentReqNoOnLoad() {

    var PODate = new Date();
    PODate = cPLQuoteDate.GetValueString();
    cQuotationComponentPanel.PerformCallback('BindIndentGrid' + '~' + PODate);

}

//function EndCallBackpanelVendor(e) {
//    if(cpanelVendor.cpStateId !=null && cpanelVendor.cpStateId != undefined) 
//    {
//        if(cpanelVendor.cpStateId=='N')
//        {
//            //jAlert('Vendors shipping address not exist')
//        }
//    }
//}

        <%--function VendorGotFocus()
        {
            var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            if(key!=null && key!='')
            {
                $('#<%=hdnTaggedVender.ClientID %>').val(key);
            }
        }--%>
        function GetContactPerson(e) {
            var invtype = $('#ddlInventory').val();
            var startDate = new Date();
            startDate = cPLQuoteDate.GetDate().format('yyyy/MM/dd');
            var branchid = $('#ddl_Branch').val();
            // For Checking Shipping AddressOfVendor
            var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            GetObjectID('hdnCustomerId').value = key;

            // For Checking Shipping AddressOfVendor End    
            if (gridquotationLookup.GetValue() != null) {
                jConfirm('Documents tagged are to be automatically De-selected. Confirm ?', 'Confirmation Dialog', function (r) {

                    if (r == true) {

                        var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                        if (key != null && key != '') {
                            if ($('#<%=hdnTaggedVender.ClientID %>').val() != null && $('#<%=hdnTaggedVender.ClientID %>').val() != '') {
                                $('#<%=hdnTaggedVender.ClientID %>').val(key);
                            }
                            gridquotationLookup.SetValue('');
                            //ctxt_InvoiceDate.SetText('');
                            //cContactPerson.PerformCallback('BindContactPerson~' + key + '~' + branchid);

                            $('.dxeErrorCellSys').addClass('abc');



                            var startDate = new Date();
                            startDate = cPLQuoteDate.GetDate().format('yyyy/MM/dd');
                            //cQuotationComponentPanel.PerformCallback('DateCheckOnChanged' + '~' + key + '~' + startDate + '~' + '@');

                            var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());

                            if (key != null && key != '') {
                                var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                                //cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type);
                                //cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type + '~' + invtype);

                            }
                            //grid.PerformCallback('GridBlank');
                            //   cQuotationComponentPanel.PerformCallback('RemoveComponentGridOnSelection');
                            if ("<%=Convert.ToString(Session["TransporterVisibilty"])%>" == "Yes") {
                                clearTransporter();
                            }
                            //ccmbGstCstVat.PerformCallback();
                            //ccmbGstCstVatcharge.PerformCallback();
                            //ctaxUpdatePanel.PerformCallback('DeleteAllTax');
                            //ctxt_InvoiceDate.SetText('');

                            //###### Added By : Samrat Roy ##########
                            //cchkBilling.SetChecked(false);
                            //cchkShipping.SetChecked(false);
                            //$('.crossBtn').hide();
                            //page.GetTabByName('Billing/Shipping').SetEnabled(true);
                            //page.GetTabByName('General').SetEnabled(false);
                            //page.SetActiveTabIndex(1);
                            if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                                var schemabranchid = $('#ddl_numberingScheme').val();
                                if (schemabranchid != '0') {
                                    var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                                    LoadCustomerAddress(key, schemabranch, 'PB');
                                    page.tabs[0].SetEnabled(true);
                                    page.tabs[1].SetEnabled(true);
                                }
                            }
                            else if ($('#<%=hdnADDEditMode.ClientID %>').val() == 'Edit') {
                                //var schemabranchid = $('#ddl_numberingScheme').val();
                                //if (schemabranchid != '0') {
                                //    var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                                var schemabranchid = $('#ddl_Branch').val();
                                if (schemabranchid != '0') {
                                    var schemabranch = schemabranchid;
                                    LoadCustomerAddress(key, schemabranch, 'PB');
                                    page.tabs[0].SetEnabled(true);
                                    page.tabs[1].SetEnabled(true);
                                }
                            }
                            else {
                                jAlert('Select a numbering schema first');
                                return;
                            }
                            //LoadCustomerAddress(key, $('#ddl_Branch').val(), 'PB');
                            //GetObjectID('hdnCustomerId').value = key;
                            //if ($('#hfBSAlertFlag').val() == "1") {
                            //    jConfirm('Wish to View/Select Billing and Shipping details?', 'Confirmation Dialog', function (r) {
                            //        if (r == true) {
                            //            page.SetActiveTabIndex(1);
                            //            cbsSave_BillingShipping.Focus();
                            //            page.tabs[0].SetEnabled(false);
                            //            $("#divcross").hide();
                            //        }
                            //    });
                            //}
                            //else {
                            //    page.SetActiveTabIndex(1);
                            //    cbsSave_BillingShipping.Focus();
                            //    page.tabs[0].SetEnabled(false);
                            //    $("#divcross").hide();
                            //}
                            //###### END : Samrat Roy : END ########## 


                            //  billingLookup.focus();
                            //  });

                            //   document.getElementById('popup_ok').focus();
                        }
                        else {
                            jAlert('Vendor can not be blank.')
                            gridLookup.SetValue($('#<%=hdnTaggedVender.ClientID %>').val());
                        }

                    }
                    else {
                        gridLookup.SetValue($('#<%=hdnTaggedVender.ClientID %>').val());
                    }
                });
            }
            else {
                var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                if (key != null && key != '') {

                    //cContactPerson.PerformCallback('BindContactPerson~' + key);
                    //cContactPerson.PerformCallback('BindContactPerson~' + key + '~' + branchid);
                    //###### Added By : Samrat Roy ##########
                    //cchkBilling.SetChecked(false);
                    //cchkShipping.SetChecked(false);
                    //page.GetTabByName('Billing/Shipping').SetEnabled(true);
                    //page.SetActiveTabIndex(1);
                    //page.GetTabByName('General').SetEnabled(false);
                    if ($('#<%=hdnADDEditMode.ClientID %>').val() != 'Edit') {
                        var schemabranchid = $('#ddl_numberingScheme').val();
                        if (schemabranchid != '0') {
                            var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                            LoadCustomerAddress(key, schemabranch, 'PB');
                            page.tabs[0].SetEnabled(true);
                            page.tabs[1].SetEnabled(true);
                        }
                    }
                    else if ($('#<%=hdnADDEditMode.ClientID %>').val() == 'Edit') {
                        var schemabranchid = $('#ddl_Branch').val();
                        if (schemabranchid != '0') {
                            var schemabranch = schemabranchid;
                            LoadCustomerAddress(key, schemabranch, 'PB');
                            page.tabs[0].SetEnabled(true);
                            page.tabs[1].SetEnabled(true);
                        }
                    }
                    else {
                        jAlert('Select a numbering schema first');
                        return;
                    }
                    //LoadCustomerAddress(key, $('#ddl_Branch').val(), 'PB');

                    //GetObjectID('hdnCustomerId').value = key;
                    //if ($('#hfBSAlertFlag').val() == "1") {
                    //    jConfirm('Wish to View/Select Billing and Shipping details?', 'Confirmation Dialog', function (r) {
                    //        if (r == true) {
                    //            page.SetActiveTabIndex(1);
                    //            cbsSave_BillingShipping.Focus();
                    //            page.tabs[0].SetEnabled(false);
                    //            $("#crossdiv").hide();
                    //        }
                    //    });
                    //}
                    //else {
                    //    page.SetActiveTabIndex(1);
                    //    cbsSave_BillingShipping.Focus();
                    //    page.tabs[0].SetEnabled(false);
                    //    $("#crossdiv").hide();
                    //}
                    //###### END : Samrat Roy : END ########## 


                    selectValue();
                    //  GetObjectID('hdnAddressDtl').value = '0';

                    //PODate = cPLQuoteDate.GetValueString();
                    //cQuotationComponentPanel.PerformCallback('BindIndentGrid' + '~' + key + '~' + PODate + '~' + 'DateCheck');

                }
                else {

                    jAlert('Vendor can not be blank.')
                    gridLookup.Focus();
                }
            }

        }


        function CmbBranch_ValueChange() {
            var ddlbranch = $("[id*=ddl_Branch]");
            var strBranch = ddlbranch.find("option:selected").val();
            //cvendorPanel.PerformCallback(strBranch)
            //gridLookup.GetGridView().Refresh();
            var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
            if (type == 'PO' || type == 'PC') {
                selectValue();
            }
            else {
                cvendorPanel.PerformCallback(strBranch)
            }
        }
        function CmbScheme_ValueChange() {
            //GetIndentReqNoOnLoad();
            var val = $("#ddl_numberingScheme").val();

            var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];

            if (val != '0') {
                cvendorPanel.PerformCallback(schemabranch)
                var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                if (type == 'PO' || type == 'PC') {
                    selectValue();
                }

                //else
                //{ 
                //    //var schemabranch = $('#ddl_numberingScheme').val().split('~')[1];
                //    LoadCustomerAddress('', schemabranch, 'PB'); 
                //}
                //var schemabranch = val.toString().split('~')[1];;
                var schemabranchid = val.toString().split('~')[1];

                var invtype = $('#ddlInventory').val();
                if (invtype == 'N') {
                    //geet
                    //if (schemabranchid != '' && schemabranch != undefined) {
                    //    cddl_noninventoryBranch.PerformCallback(schemabranchid);
                    //}
                    //else {
                    //    cddl_noninventoryBranch.PerformCallback('0');
                    //}
                    //geet
                }
                //$('#ddl_branch').val(schemabranchid).attr("selected", "selected");
                document.getElementById('ddl_Branch').value = schemabranchid;

                $.ajax({
                    type: "POST",
                    url: 'PurchaseInvoiceforTransporter.aspx/getSchemeType',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: "{sel_scheme_id:\"" + val + "\"}",
                    success: function (type) {

                        var schemetypeValue = type.d;
                        <%--'<%= Session["schemavaluePB"] %>' = schemetypeValue;--%>
                        var schemetype = schemetypeValue.toString().split('~')[0];
                        var schemelength = schemetypeValue.toString().split('~')[1];
                        $('#txtVoucherNo').attr('maxLength', schemelength);
                        if (schemetype == '0') {

                            document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = false;
                            document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";

                            $("#txtVoucherNo").focus();
                            if ($('#<%=hdnManual.ClientID %>').val() == 'N') {
                                cPLQuoteDate.SetEnabled(false);
                            }
                            else if ($('#<%=hdnManual.ClientID %>').val() == 'Y') {
                                cPLQuoteDate.SetEnabled(true);
                            }
                            //cPLQuoteDate.SetEnabled(true);

                        }
                        else if (schemetype == '1') {

                            document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                            document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Auto";
                            //cPLQuoteDate.SetEnabled(false);
                            cPLQuoteDate.Focus();
                            $("#MandatoryBillNo").hide();
                            if ($('#<%=hdnAuto.ClientID %>').val() == 'N') {
                                cPLQuoteDate.SetEnabled(false);
                            }
                            else if ($('#<%=hdnAuto.ClientID %>').val() == 'Y') {
                                cPLQuoteDate.SetEnabled(true);
                            }

                        }
                        else if (schemetype == '2') {

                            document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                            document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Datewise";
                        }
                        else if (schemetype == 'n') {
                            document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                            document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
                            //cPLQuoteDate.SetEnabled(false);
                        }
                    }
                });


}
else {
    document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
                document.getElementById('ddl_Branch').value = '<%=Session["userbranchID"]%>';
                cvendorPanel.PerformCallback('<%=Session["userbranchID"]%>')
            }

            //gridLookup.GetGridView().Refresh();
        }

        // NO use checked by Sandip Start
        //function IndentRequisitionNo_ValueChange() {

        //    var val = $("#ddl_IndentRequisitionNo").val();
        //    if (val != 0) {
        //        $.ajax({
        //            type: "POST",
        //            url: 'PurchaseOrder.aspx/getIndentRequisitionDate',
        //            contentType: "application/json; charset=utf-8",
        //            dataType: "json",
        //            data: "{IndentRequisitionNo:\"" + val + "\"}",
        //            success: function (type) {
        //                //console.log(type);
        //                var Transdt = new Date(type.d);
        //                cIndentRequisDate.SetDate(Transdt);

        //            }
        //        });
        //    }
        //    else {
        //        cIndentRequisDate.SetVal("");
        //    }

        //}
        // NO use checked by Sandip End

        function CloseGridLookup() {
            gridLookup.ConfirmCurrentSelection();
            gridLookup.HideDropDown();
            gridLookup.Focus();
        }

        //function GetContactPerson(e) {
        //    var internalid = e.Get
        //}

        function SetDifference() {
            var diff = CheckDifference();
            if (diff > 0) {
                clientResult.SetText(diff.toString());
            }

        }

        function CheckDifference() {
            var startDate = new Date();
            var endDate = new Date();
            var difference = -1;
            startDate = cPLQuoteDate.GetDate();
            if (startDate != null) {
                endDate = cExpiryDate.GetDate();
                var startTime = startDate.getTime();
                var endTime = endDate.getTime();
                difference = (endTime - startTime) / 86400000;

            }
            return difference;

        }

        //$(document).ready(function () {

        //    GetIndentReqNoOnLoad();
        //})
    </script>
    <%--   Warehouse  Script   --%>
    <script type="text/javascript">

        function Keypressevt() {

            if (event.keyCode == 13) {

                //run code for Ctrl+X -- ie, Save & Exit! 
                SaveWarehouse();
                return false;
            }
        }

        function getUrlVars() {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            return vars;
        }

        $(document).ready(function () {
            //$("#ddl_Branch").attr("disabled", true);
            document.getElementById('txtVoucherNo').disabled = true;
            if (GetObjectID('hdnCustomerId').value == null || GetObjectID('hdnCustomerId').value == '') {
                page.GetTabByName('Billing/Shipping').SetEnabled(false);
            }
            //GetIndentReqNoOnLoad();
            var isCtrl = false;
            document.onkeydown = function (e) {
                if (event.keyCode == 78 && event.altKey == true && getUrlVars().req != "V") { //run code for Alt + n -- ie, Save & New  
                    StopDefaultAction(e);
                    Save_ButtonClick();
                }
                else if (event.keyCode == 88 && event.altKey == true && getUrlVars().req != "V") { //run code for Alt+X -- ie, Save & Exit!     
                    StopDefaultAction(e);
                    SaveExit_ButtonClick();
                }
                else if (event.keyCode == 79 && event.altKey == true) { //run code for Alt+O -- ie, Billing/Shipping Samrat!     
                    StopDefaultAction(e);
                    if (page.GetActiveTabIndex() == 1) {
                        fnSaveBillingShipping();
                    }
                }
                else if (event.keyCode == 77 && event.altKey == true) { //run code for Alt+m -- ie, TC Sayan!
                    $('#TermsConditionseModal').modal({
                        show: 'true'
                    });
                }
                else if (event.keyCode == 69 && event.altKey == true) { //run code for Alt+e -- ie, TC Sayan!
                    if (($("#TermsConditionseModal").data('bs.modal') || {}).isShown) {
                        StopDefaultAction(e);
                        SaveTermsConditionData();
                    }
                }
                else if (event.keyCode == 76 && event.altKey == true) { //run code for Alt+l -- ie, TC Sayan!
                    StopDefaultAction(e);
                    calcelbuttonclick();
                }
                else if (event.keyCode == 85 && event.altKey == true) {//run code for Alt+U -- ie,
                    OpenUdf();
                }
                else if (event.keyCode == 84 && event.altKey == true) {//run code for Alt+T
                    Save_TaxesClick();
                }
                else if (event.keyCode == 83 && event.altKey == true) { //run code for Alt+X -- ie, Save & Exit!     
                    StopDefaultAction(e);
                    if (($("#exampleModal").data('bs.modal') || {}).isShown) {
                        SaveVehicleControlData();
                    }
                }
                else if (event.keyCode == 67 && event.altKey == true) { //run code for Alt+X -- ie, Save & Exit!     
                    StopDefaultAction(e);
                    modalShowHide(0);
                }
                else if (event.keyCode == 82 && event.altKey == true) { //run code for Alt+X -- ie, Save & Exit!     
                    StopDefaultAction(e);
                    $('body').on('shown.bs.modal', '#exampleModal', function () {
                        $('input:visible:enabled:first', this).focus();
                    })
                }
                //if (event.keyCode == 116) {

                //    //run code for Ctrl+X -- ie, Save & Exit! 
                //    //cPopup_WarehousePC.Hide();
                //    return false;
                //}

            }
        });

        function StopDefaultAction(e) {
            if (e.preventDefault) { e.preventDefault() }
            else { e.stop() };

            e.returnValue = false;
            e.stopPropagation();
        }

        function DeleteWarehousebatchserial(SrlNo, BatchWarehouseID, viewQuantity, Quantity, WarehouseID, BatchNo) {
            //alert(viewQuantity);
            var IsSerial = $('#hdnisserial').val();
            if (IsSerial == "true" && viewQuantity != "1.0000" && viewQuantity != "1.0" && viewQuantity != "") {
                jAlert("Cannot Proceed. You have to delete subsequent data first before delete this data.");
            } else {
                if (BatchWarehouseID == "" || BatchWarehouseID == "0") {

                    $('#<%=hdnisolddeleted.ClientID %>').val("false");
                    if (SrlNo != "") {


                        cGrdWarehousePC.PerformCallback('Delete~' + SrlNo + '~' + viewQuantity + '~' + Quantity + '~' + WarehouseID + '~' + BatchNo);
                    }

                } else {

                    $('#<%=hdnisolddeleted.ClientID %>').val("true");
                    if (SrlNo != "") {

                        cGrdWarehousePC.PerformCallback('Delete~' + SrlNo + '~' + viewQuantity + '~' + Quantity + '~' + WarehouseID + '~' + BatchNo);
                    }
                }
            }



        }

        function Setenterfocuse(s) {

           <%-- var Isbatch = $('#hdnisbatch').val();
            var IsSerial = $('#hdnisserial').val();
            //alert(Isbatch);
            if (Isbatch == "true") {
                ctxtbatch.Focus();
                document.getElementById("<%=txtbatch.ClientID%>").focus();
            } else if (IsSerial == "true") {
                ctxtserial.Focus();
            }--%>
        }

        function UpdateWarehousebatchserial(SrlNo, WarehouseID, BatchNo, SerialNo, isnew, viewQuantity, Quantity) {


            var Isbatch = $('#hdnisbatch').val();

            if (isnew == "old" || isnew == "Updated") {

                $('#<%=hdnisoldupdate.ClientID %>').val("true");
                $('#<%=hdncurrentslno.ClientID %>').val("");
                cCmbWarehouse.SetValue(WarehouseID);
                if (Quantity != null && Quantity != "" && Isbatch != "true") {
                    ctxtqnty.SetText(Quantity);
                } else {
                    ctxtqnty.SetText(viewQuantity);
                }
                var IsSerial = $('#hdnisserial').val();

                if (IsSerial == "true") {

                    if (viewQuantity == "") {
                        ctxtbatch.SetEnabled(false);
                        cCmbWarehouse.SetEnabled(false);
                        ctxtqnty.SetEnabled(false);
                        ctxtserial.Focus();
                    } else {
                        ctxtbatch.SetEnabled(true);
                        cCmbWarehouse.SetEnabled(true);
                        ctxtqnty.SetEnabled(true);
                        ctxtserial.Focus();
                    }

                }
                else {
                    ctxtbatch.SetEnabled(true);
                    cCmbWarehouse.SetEnabled(true);
                    ctxtqnty.SetEnabled(true);
                    ctxtbatch.Focus();
                }
                // ctxtqnty.SetEnabled(false);

                ctxtbatchqnty.SetText(Quantity);
                //ctxtbatchqnty.SetEnabled(false);
                ctxtbatch.SetText(BatchNo);
                ctxtserial.SetText(SerialNo);

                if (viewQuantity == "") {
                    ctxtbatch.SetEnabled(false);
                    cCmbWarehouse.SetEnabled(false);
                    $('#<%=hdnisviewqntityhas.ClientID %>').val("true");
                } else {
                    ctxtbatch.SetEnabled(true);
                    cCmbWarehouse.SetEnabled(true);
                    $('#<%=hdnisviewqntityhas.ClientID %>').val("false");
                }

                var hdniswarehouse = $('#hdniswarehouse').val();


                if (hdniswarehouse != "true" && Isbatch == "true") {
                    ctxtbatchqnty.SetText(viewQuantity);
                    ctxtbatchqnty.Focus();

                } else {
                    ctxtqnty.Focus();
                }
                $('#<%=hdncurrentslno.ClientID %>').val(SrlNo);

            } else {

                $('#<%=hdnisoldupdate.ClientID %>').val("false");

                ctxtqnty.SetText("0.0");
                ctxtqnty.SetEnabled(true);

                ctxtbatchqnty.SetText("0.0");
                ctxtserial.SetText("");
                ctxtbatchqnty.SetText("");
                $('#<%=hdncurrentslno.ClientID %>').val("");

                $('#<%=hdnisnewupdate.ClientID %>').val("true");
                $('#<%=hdncurrentslno.ClientID %>').val("");
                cCmbWarehouse.SetValue(WarehouseID);
                if (Quantity != null && Quantity != "" && Isbatch != "true") {
                    ctxtqnty.SetText(Quantity);
                } else {
                    ctxtqnty.SetText(viewQuantity);
                }
                var IsSerial = $('#hdnisserial').val();
                if (IsSerial == "true") {

                    if (viewQuantity == "") {
                        ctxtbatch.SetEnabled(false);
                        cCmbWarehouse.SetEnabled(false);
                        ctxtqnty.SetEnabled(false);
                        $('#<%=hdnisviewqntityhas.ClientID %>').val("true");
                        ctxtserial.Focus();
                    } else {
                        ctxtbatch.SetEnabled(true);
                        cCmbWarehouse.SetEnabled(true);
                        ctxtqnty.SetEnabled(true);
                        $('#<%=hdnisviewqntityhas.ClientID %>').val("false");
                        ctxtserial.Focus();
                    }

                } else {
                    ctxtbatch.SetEnabled(true);
                    cCmbWarehouse.SetEnabled(true);
                    ctxtqnty.SetEnabled(true);
                    ctxtbatch.Focus();
                }
                // ctxtqnty.SetEnabled(false);

                ctxtbatchqnty.SetText(Quantity);
                //ctxtbatchqnty.SetEnabled(false);
                ctxtbatch.SetText(BatchNo);
                ctxtserial.SetText(SerialNo);

                if (viewQuantity == "") {
                    ctxtbatch.SetEnabled(false);
                    cCmbWarehouse.SetEnabled(false);
                } else {
                    ctxtbatch.SetEnabled(true);
                    cCmbWarehouse.SetEnabled(true);
                }

                var hdniswarehouse = $('#hdniswarehouse').val();


                if (hdniswarehouse != "true" && Isbatch == "true") {
                    ctxtbatchqnty.SetText(viewQuantity);
                } else {
                    ctxtqnty.Focus();
                }

                $('#<%=hdncurrentslno.ClientID %>').val(SrlNo);

                //jAlert("Sorry, This is new entry you can not update. please click on 'Clear Entries' and Add again.");
            }
        }


        function changedqnty(s) {

            <%-- var qnty = s.GetText();
            var sum = $('#hdntotalqntyPC').val();

            sum = Number(Number(sum) + Number(qnty));
             
            $('#<%=hdntotalqntyPC.ClientID %>').val(sum);--%>


           <%-- document.getElementById("<%=txtbatch.ClientID%>").focus();
            var Isbatch = $('#hdnisbatch').val();
            var IsSerial = $('#hdnisserial').val();
            //alert(Isbatch);
            if (Isbatch == "true") {
                ctxtbatch.Focus();
                document.getElementById("<%=txtbatch.ClientID%>").focus();
            } else if (IsSerial == "true") {
                ctxtserial.Focus();
            }--%>
        }

        function endcallcmware(s) {

            if (cCmbWarehouse.cpstock != null) {

                var ddd = cCmbWarehouse.cpstock + " " + $('#hdnstrUOM').val();
                document.getElementById('<%=lblAvailableStk.ClientID %>').innerHTML = ddd;
                cCmbWarehouse.cpstock = null;
            }
        }
        function changedqntybatch(s) {

            var qnty = s.GetText();
            var sum = $('#hdntotalqntyPC').val();
            sum = Number(Number(sum) + Number(qnty));
            //alert(sum);
            $('#<%=hdntotalqntyPC.ClientID %>').val(sum);

            //var Isbatch = $('#hdnisbatch').val();
            //var IsSerial = $('#hdnisserial').val();
            ////alert(Isbatch);
            //if (IsSerial == "true") {
            //    ctxtserial.Focus();
            //}

        }
        function chnagedbtach(s) {

            $('#<%=hdnoldbatchno.ClientID %>').val(s.GetText());
            $('#<%=hidencountforserial.ClientID %>').val(1);

            var sum = $('#hdnbatchchanged').val();
            sum = Number(Number(sum) + Number(1));

            $('#<%=hdnbatchchanged.ClientID %>').val(sum);
            //ctxtqnty.SetValue("0.0");
            //ctxtbatchqnty.SetValue("0.0");
            //ctxtmkgdate.SetDate = null;
            //txtexpirdate.SetDate = null;
            //ASPx.CalClearClick('txtmkgdate_DDD_C');
            //ASPx.CalClearClick('txtexpirdate_DDD_C');
            ctxtexpirdate.SetText("");
            ctxtmkgdate.SetText("");
        }

        function CmbWarehouse_ValueChange(s) {

            var ISupdate = $('#hdnisoldupdate').val();
            var isnewupdate = $('#hdnisnewupdate').val();

            $('#<%=hdnoldwarehousname.ClientID %>').val(s.GetText());

            if (ISupdate == "true" || isnewupdate == "true") {


            } else {
        <%--$('#<%=hidencountforserial.ClientID %>').val(1);
           
            $('#<%=hdnbatchchanged.ClientID %>').val("0");
            $('#<%=hidencountforserial.ClientID %>').val("1");--%>

                ctxtserial.SetValue("");
                //ctxtbatch.SetValue("");
                //ctxtmkgdate.SetDate = null;
                //txtexpirdate.SetDate = null;

                ctxtbatch.SetEnabled(true);
                ctxtexpirdate.SetEnabled(true);
                ctxtmkgdate.SetEnabled(true);

                //ctxtqnty.SetValue("0.0");
                //ctxtbatchqnty.SetValue("0.0");

                //cCmbWarehouse.PerformCallback('Bindstock');
                //ASPx.CalClearClick('txtmkgdate_DDD_C');
                //ASPx.CalClearClick('txtexpirdate_DDD_C');
                //ctxtexpirdate.SetText("");
                //ctxtmkgdate.SetText("");
            }


        }

        function Clraear() {
            ctxtbatch.SetValue("");

            ASPx.CalClearClick('txtmkgdate_DDD_C');
            ASPx.CalClearClick('txtexpirdate_DDD_C');
            $('#<%=hdnisoldupdate.ClientID %>').val("false");
            //ctxtmkgdate.SetDate = null;
            //txtexpirdate.SetDate = null;

            //ctxtexpirdate.SetText("");
            //ctxtmkgdate.SetText("");

            //ctxtmkgdate.CalClearClick('txtmkgdate_DDD_C');
            //ctxtexpirdate.CalClearClick('txtexpirdate_DDD_C');
            ctxtserial.SetValue("");
            ctxtqnty.SetValue("0.0000");
            ctxtbatchqnty.SetValue("0.0000");
            $('#<%=hdntotalqntyPC.ClientID %>').val(0);
              $('#<%=hidencountforserial.ClientID %>').val(1);
            $('#<%=hdnbatchchanged.ClientID %>').val("0");
            var strProductID = $('#hdfProductIDPC').val();
            var stockids = $('#hdfstockidPC').val();
            var branchid = $('#hdbranchIDPC').val();
            var strProductName = $('#lblProductName').text();
            $('#<%=hdnisnewupdate.ClientID %>').val("false");
              ctxtbatch.SetEnabled(true);
              ctxtexpirdate.SetEnabled(true);
              ctxtmkgdate.SetEnabled(true);
              ctxtbatch.SetEnabled(true);
              cCmbWarehouse.SetEnabled(true);
              $('#<%=hdnisviewqntityhas.ClientID %>').val("false");
              $('#<%=hdnisolddeleted.ClientID %>').val("false");
            ctxtqnty.SetEnabled(true);

            var existingqntity = $('#hdfopeningstockPC').val();
            var totaldeleteqnt = $('#hdndeleteqnity').val();

            var addqntity = Number(existingqntity) + Number(totaldeleteqnt);

            $('#<%=hdndeleteqnity.ClientID %>').val(0);
           <%-- $('#<%=hdfopeningstockPC.ClientID %>').val(addqntity);--%>



            cGrdWarehousePC.PerformCallback('checkdataexist~' + strProductID + '~' + stockids + '~' + branchid + '~' + strProductName);

        }

        function SaveWarehouse() {


            //SAM CODE FOR QTY CHECKING

            //var producttype= $('#hdfProductType').val()
            //if(producttype=='WBS')
            //{
            if ($('#wbsqtychecking').val() == '1') {
                var qnty = ctxtqnty.GetText();
                var sum = $('#hdntotalqntyPC').val();
                sum = Number(Number(sum) + Number(qnty));
                $('#<%=hdntotalqntyPC.ClientID %>').val(sum);
                  ctxtqnty.SetEnabled(false);
                  $('#wbsqtychecking').val('0');
              }
              //}
              //SAM CODE FOR QTY CHECKING


              var prosrlno = $('#hdfProductSerialID').val();
              var WarehouseID = cCmbWarehouse.GetValue();
              var WarehouseName = cCmbWarehouse.GetText();

              var qnty = ctxtqnty.GetText();
              var IsSerial = $('#hdnisserial').val();
              //alert(qnty);

              if (qnty == "0.0000") {
                  qnty = ctxtbatchqnty.GetText();
              }

              if (Number(qnty) % 1 != 0 && IsSerial == "true") {
                  jAlert("Serial number is activated, Quantity should not contain decimals. ");
                  return;
              }

              //alert(qnty);
              var BatchName = ctxtbatch.GetText();
              var SerialName = ctxtserial.GetText();
              var Isbatch = $('#hdnisbatch').val();

              var enterdqntity = $('#hdfopeningstockPC').val();

              var hdniswarehouse = $('#hdniswarehouse').val();

              var ISupdate = $('#hdnisoldupdate').val();
              var isnewupdate = $('#hdnisnewupdate').val();
              //alert(Isbatch + "/" + IsSerial);
              //alert(hdniswarehouse+"/"+WarehouseID);
              if (Isbatch == "true" && hdniswarehouse == "false") {
                  qnty = ctxtbatchqnty.GetText();
              }

              if (ISupdate == "true") {

                  if (hdniswarehouse == "true" && WarehouseID == null) {

                      $("#RequiredFieldValidatorCmbWarehouse").css("display", "block");
                  }
                  else {
                      $("#RequiredFieldValidatorCmbWarehouse").css("display", "none");
                  }
                  if (qnty == "0.0") {

                      if (Isbatch != "false" || hdniswarehouse != "false") {
                          $("#RequiredFieldValidatortxtbatchqntity").css("display", "block");
                          $("#RequiredFieldValidatortxtwareqntity").css("display", "block");
                          //jAlert("Quantity should not be 0.0");
                      } else if (Isbatch == "false" && hdniswarehouse == "false" && IsSerial == "true") {
                          qnty = "0.00"
                          $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                          $("#RequiredFieldValidatortxtwareqntity").css("display", "none");
                      }
                  } else {

                      qnty = "0.00"
                      $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                      $("#RequiredFieldValidatortxtwareqntity").css("display", "none");
                  }

                  if (Isbatch == "true" && BatchName == "") {

                      $("#RequiredFieldValidatortxtbatch").css("display", "block");
                      ctxtbatch.Focus();
                  } else {
                      $("#RequiredFieldValidatortxtbatch").css("display", "none");
                  }
                  if (IsSerial == "true" && SerialName == "") {
                      $("#RequiredFieldValidatortxtserial").css("display", "block");
                      ctxtserial.Focus();

                  } else {
                      $("#RequiredFieldValidatortxtserial").css("display", "none");
                  }
                  var slno = $('#hdncurrentslno').val();



                  if (slno != "") {

                      cGrdWarehousePC.PerformCallback('Updatedata~' + WarehouseID + '~' + WarehouseName + '~' + BatchName + '~' + SerialName + '~' + slno + '~' + qnty + '~' + prosrlno);

               <%--     $('#<%=hdnisoldupdate.ClientID %>').val("false");
                    ctxtqnty.SetText("0.0");
                    ctxtbatch.SetText("");
                    ctxtbatch.SetEnabled(true);
                    cCmbWarehouse.SetEnabled(true);
                    ctxtqnty.SetEnabled(true);--%>
                      return false;
                  }


              } else if (isnewupdate == "true") {
                  if (hdniswarehouse == "true" && WarehouseID == null) {

                      $("#RequiredFieldValidatorCmbWarehouse").css("display", "block");
                  }
                  else {
                      $("#RequiredFieldValidatorCmbWarehouse").css("display", "none");
                  }
                  if (qnty == "0.0") {

                      if (Isbatch != "false" || hdniswarehouse != "false") {
                          $("#RequiredFieldValidatortxtbatchqntity").css("display", "block");
                          $("#RequiredFieldValidatortxtwareqntity").css("display", "block");
                          //jAlert("Quantity should not be 0.0");
                      } else if (Isbatch == "false" && hdniswarehouse == "false" && IsSerial == "true") {
                          qnty = "0.00"
                          $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                          $("#RequiredFieldValidatortxtwareqntity").css("display", "none");
                      }
                  } else {

                      qnty = "0.00"
                      $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                      $("#RequiredFieldValidatortxtwareqntity").css("display", "none");
                  }

                  if (Isbatch == "true" && BatchName == "") {

                      $("#RequiredFieldValidatortxtbatch").css("display", "block");
                      ctxtbatch.Focus();
                  }
                  else {
                      $("#RequiredFieldValidatortxtbatch").css("display", "none");
                  }
                  if (IsSerial == "true" && SerialName == "") {


                      $("#RequiredFieldValidatortxtserial").css("display", "block");
                      ctxtserial.Focus();

                  } else {
                      $("#RequiredFieldValidatortxtserial").css("display", "none");
                  }
                  var slno = $('#hdncurrentslno').val();

                  if (slno != "") {

                      cGrdWarehousePC.PerformCallback('NewUpdatedata~' + WarehouseID + '~' + WarehouseName + '~' + BatchName + '~' + SerialName + '~' + slno + '~' + qnty + '~' + prosrlno);

                      $('#<%=hdnisviewqntityhas.ClientID %>').val("false");
                     $('#<%=hdnisnewupdate.ClientID %>').val("false");
                     ctxtbatch.SetEnabled(true);
                     cCmbWarehouse.SetEnabled(true);
                     ctxtqnty.SetEnabled(true);
                     ctxtqnty.SetText("0.0");
                     ctxtbatch.SetText("");
                     return false;
                 }

             }
             else {

                 var hdnisediteds = $('#hdnisedited').val();

                 if (hdniswarehouse == "true" && WarehouseID == null) {

                     $("#RequiredFieldValidatorCmbWarehouse").css("display", "block");

                     return;
                 } else {
                     $("#RequiredFieldValidatorCmbWarehouse").css("display", "none");
                 }
                 if (qnty == "0.0") {

                     if (Isbatch != "false" || hdniswarehouse != "false") {
                         $("#RequiredFieldValidatortxtbatchqntity").css("display", "block");
                         $("#RequiredFieldValidatortxtwareqntity").css("display", "block");
                         //jAlert("Quantity should not be 0.0");
                     } else if (Isbatch == "false" && hdniswarehouse == "false" && IsSerial == "true") {
                         qnty = "0.00"
                         $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                         $("#RequiredFieldValidatortxtwareqntity").css("display", "none");
                     }
                 } else {

                     qnty = "0.00"
                     $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                     $("#RequiredFieldValidatortxtwareqntity").css("display", "none");
                 }
                 if (Isbatch == "true" && BatchName == "") {

                     $("#RequiredFieldValidatortxtbatch").css("display", "block");
                     ctxtbatch.Focus();
                     return;

                 } else {
                     $("#RequiredFieldValidatortxtbatch").css("display", "none");
                 }
                 if (IsSerial == "true" && SerialName == "") {


                     $("#RequiredFieldValidatortxtserial").css("display", "block");
                     ctxtserial.Focus();
                     return;

                 } else {
                     $("#RequiredFieldValidatortxtserial").css("display", "none");
                 }
                 if (Isbatch == "true" && hdniswarehouse == "false") {

                     qnty = ctxtbatchqnty.GetText();

                     if (qnty == "0.0000") {
                         //alert("Enter" + ctxtbatchqnty.GetText());

                         ctxtbatchqnty.Focus();
                     }
                 }

                 if (qnty == "0.0") {

                     if (Isbatch != "false" || hdniswarehouse != "false") {
                         $("#RequiredFieldValidatortxtbatchqntity").css("display", "block");
                         $("#RequiredFieldValidatortxtwareqntity").css("display", "block");
                         //jAlert("Quantity should not be 0.0");
                     } else if (Isbatch == "false" && hdniswarehouse == "false" && IsSerial == "true") {
                         qnty = "0.00"
                         $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                         $("#RequiredFieldValidatortxtwareqntity").css("display", "none");
                     }
                 }
                 else if (((hdniswarehouse == "true" && WarehouseID != null) || hdniswarehouse == "false") && ((Isbatch == "true" && BatchName != "") || Isbatch == "false") && ((IsSerial == "true" && SerialName != "") || IsSerial == "false") && qnty != "0.0") {
                     $("#RequiredFieldValidatorCmbWarehouse").css("display", "none");
                     $("#RequiredFieldValidatortxtbatch").css("display", "none");
                     $("#RequiredFieldValidatortxtserial").css("display", "none");

                     $("#RequiredFieldValidatortxtwareqntity").removeAttr("style");
                     $("#RequiredFieldValidatortxtbatchqntity").removeAttr("style");
                     $("#RequiredFieldValidatortxtbatchqntity").css("display", "none");
                     $("#RequiredFieldValidatortxtwareqntity").css("display", "none");


                     if (Isbatch == "true" && hdniswarehouse == "false") {

                         qnty = ctxtbatchqnty.GetText();

                         if (qnty = "0.0000") {
                             ctxtbatchqnty.Focus();
                         }
                     }


                     var oldenterqntity = $('#hdnenterdopenqnty').val();
                     var enterdqntityss = $('#hdnnewenterqntity').val();
                     var deletedquantity = $('#hdndeleteqnity').val();
                     //alert(deletedquantity);
                     // alert(enterdqntityss + "|" + oldenterqntity);
                     //if (Number(enterdqntityss) < Number(oldenterqntity)) {
                     //    qnty = "0.00";
                     //    jConfirm('You have entered Quantity less than Opening Quantity. Do you want to clear all existing entries.?', 'Confirmation Dialog', function (r) {
                     //        if (r == true) {

                     //            cGrdWarehousePC.PerformCallback('Delete~' + WarehouseID);
                     //            var strProductID = $('#hdfProductIDPC').val();
                     //            var stockids = $('#hdfstockidPC').val();
                     //            var branchid = $('#hdbranchIDPC').val();
                     //            var strProductName = $('#lblProductName').text();
                     //            cGrdWarehousePC.PerformCallback('checkdataexist~' + strProductID + '~' + stockids + '~' + branchid + '~' + strProductName);
                     //        }
                     //    });


                     //}




                     if (Number(qnty) > (Number(enterdqntity) + Number(deletedquantity)) && hdnisediteds == "false") {
                         qnty = "0.00";
                         jAlert("You have entered Quantity greater than Opening Quantity. Cannot Proceed.");


                     }
                     else {


                         cGrdWarehousePC.PerformCallback('Display~' + WarehouseID + '~' + WarehouseName + '~' + BatchName + '~' + SerialName + '~' + qnty + '~' + prosrlno);

                         //ctxtserial.SetValue("");

                         //ASPx.CalClearClick('txtmkgdate_DDD_C');
                         //ASPx.CalClearClick('txtexpirdate_DDD_C');

                         cCmbWarehouse.Focus();
                     }
                 }
                 //}

                 //ctxtexpirdate.SetText("");
                 //ctxtmkgdate.SetText("");
                 return false;
             }
     }
     function SaveWarehouseAll() {
         //var openqnty = Number($('#hdfopeningstockPC').val());
         //var totalqnty = Number($('#hdntotalqntyPC').val());
         // if (totalqnty != openqnty) {

         //jAlert("Please make sure Opening quantity should not be greater and less than total INput quantity.");
         //} else {

         cGrdWarehousePC.PerformCallback('Saveall~');


         //}

     }

     function cGrdWarehousePCShowError(obj) {

         if (cGrdWarehousePC.cperrorMsg != null && cGrdWarehousePC.cperrorMsg != undefined) {
             jAlert(cGrdWarehousePC.cperrorMsg);
             ctxtserial.Focus();
             return;
         }

         if (cGrdWarehousePC.cpdeletedata != null) {
             var existingqntity = $('#hdfopeningstockPC').val();
             var totaldeleteqnt = $('#hdndeleteqnity').val();

             var addqntity = Number(cGrdWarehousePC.cpdeletedata) + Number(existingqntity);
             var adddeleteqnty = Number(cGrdWarehousePC.cpdeletedata) + Number(totaldeleteqnt);

             $('#<%=hdndeleteqnity.ClientID %>').val(adddeleteqnty);
            <%--$('#<%=hdfopeningstockPC.ClientID %>').val(addqntity);--%>
             cGrdWarehousePC.cpdeletedata = null;
         }

         if (cGrdWarehousePC.cpdeletedatasubsequent != null) {
             jAlert(cGrdWarehousePC.cpdeletedatasubsequent);
             cGrdWarehousePC.cpdeletedatasubsequent = null;
         }
         if (cGrdWarehousePC.cpbatchinsertmssg != null) {
             ctxtbatch.SetText("");

             ctxtqnty.SetValue("0.0000");
             ctxtbatchqnty.SetValue("0.0000");
             cGrdWarehousePC.cpbatchinsertmssg = null;
         }
         if (cGrdWarehousePC.cpupdateexistingdata != null) {

             $('#<%=hdnisedited.ClientID %>').val("true");
            cGrdWarehousePC.cpupdateexistingdata = null;
        }
        if (cGrdWarehousePC.cpupdatenewdata != null) {

            $('#<%=hdnisedited.ClientID %>').val("true");

            cGrdWarehousePC.cpupdateexistingdata = null;
        }

        if (cGrdWarehousePC.cpupdatemssgserialsetdisblebatch != null) {
            ctxtbatch.SetEnabled(false);
            ctxtexpirdate.SetEnabled(false);
            ctxtmkgdate.SetEnabled(false);
            cGrdWarehousePC.cpupdatemssgserialsetdisblebatch = null;
        }
        if (cGrdWarehousePC.cpupdatemssgserialsetenablebatch != null) {
            ctxtbatch.SetEnabled(true);
            ctxtexpirdate.SetEnabled(true);
            ctxtmkgdate.SetEnabled(true);
            $('#<%=hidencountforserial.ClientID %>').val(1);
            //New Code Added by Sam
            ctxtqnty.SetEnabled(true)
            $('#wbsqtychecking').val('1')
            //New Code Added by Sam
            $('#<%=hdnbatchchanged.ClientID %>').val("0");
            $('#<%=hidencountforserial.ClientID %>').val("1");
            ctxtqnty.SetValue("0.0000");
            ctxtbatchqnty.SetValue("0.0000");
            ctxtbatch.SetText("");
            cGrdWarehousePC.cpupdatemssgserialsetenablebatch = null;
        }


        if (cGrdWarehousePC.cpproductname != null) {
            document.getElementById('<%=lblpro.ClientID %>').innerHTML = cGrdWarehousePC.cpproductname;
            cGrdWarehousePC.cpproductname = null;
        }

          <%--  if (cGrdWarehousePC.cpbranchqntity != null) {

                var qnty = cGrdWarehousePC.cpbranchqntity;
                var sum = $('#hdfopeningstockPC').val();
                sum = Number(Number(sum) + Number(qnty));
               
                document.getElementById('<%=lblAvailableStk.ClientID %>').innerHTML = "0";
                cGrdWarehousePC.cpbranchqntity = null;
            }--%>

         if (cGrdWarehousePC.cpupdatemssg != null) {
             if (cGrdWarehousePC.cpupdatemssg == "Saved Successfully.") {
                 $('#<%=hdntotalqntyPC.ClientID %>').val("0");
                $('#<%=hdnbatchchanged.ClientID %>').val("0");
                $('#<%=hidencountforserial.ClientID %>').val("1");
                //New Code Added by Sam
                //ctxtqnty.SetEnabled(true)
                //$('#wbsqtychecking').val('1')
                //New Code Added by Sam
                ctxtqnty.SetValue("0.0000");
                ctxtbatchqnty.SetValue("0.0000");

                parent.cPopup_WarehousePC.Hide();
                var hdnselectedbranch = $('#hdnselectedbranch').val();
                var selectedrow = $('#hdngridvselectedrowno').val();
                //grid.GetEditor('PurchasePrice').Focus();
                grid.batchEditApi.StartEdit(selectedrow, 8);
                //cOpeningGrid.Enable = false;
                // parent.cOpeningGrid.PerformCallback("branchwise~" + hdnselectedbranch);
            } else {
                jAlert(cGrdWarehousePC.cpupdatemssg);
            }

            cGrdWarehousePC.cpupdatemssg = null;


        }
        if (cGrdWarehousePC.cpupdatemssgserial != null) {
            jAlert(cGrdWarehousePC.cpupdatemssgserial);
            cGrdWarehousePC.cpupdatemssgserial = null;
        }

        if (cGrdWarehousePC.cpinsertmssg != null) {
            $('#<%=hidencountforserial.ClientID %>').val(2);
            ctxtserial.SetValue("");
            ctxtserial.Focus();
            cGrdWarehousePC.cpinsertmssg = null;
        }
        if (cGrdWarehousePC.cpinsertmssgserial != null) {

            ctxtserial.SetValue("");
            ctxtserial.Focus();
            cGrdWarehousePC.cpinsertmssgserial = null;
        }


    }
    function Onddl_VatGstCstEndCallback(s, e) {
        if (s.GetItemCount() == 1) {
            cddlVatGstCst.SetEnabled(false);
        }
    }
    </script>
    <%--   Warehouse Script End    --%>

    <%--Sam Section For extra Modification and tagging Section Start--%>
    <script>
        $(document).ready(function () {
            $('#ApprovalCross').click(function () {

                window.parent.popup.Hide();
                window.parent.cgridPendingApproval.Refresh()();
            })
            //if (val == null) {
            //    var schemaid = $('#ddl_numberingScheme').val();
            //    if (schemaid != null) {
            //        if (schemaid == '') {
            //            $('#txtVoucherNo').attr("disabled", "disabled");
            //            //ctxt_PLQuoteNo.SetEnabled(false);
            //        }
            //    }
            //}

        })
        function DateCheck() {
            var invtype = $('#ddlInventory').val();
            if (gridquotationLookup.GetValue() != null) {

                jConfirm('Documents tagged are to be automatically De-selected. Confirm ?', 'Confirmation Dialog', function (r) {
                    if (r == true) {

                        page.SetActiveTabIndex(0);
                        $('.dxeErrorCellSys').addClass('abc');


                        //  var startDate = tstartdate.GetValueString();

                        var startDate = new Date();
                        startDate = cPLQuoteDate.GetDate().format('yyyy/MM/dd');
                        cQuotationComponentPanel.PerformCallback('DateCheckOnChanged' + '~' + key + '~' + startDate + '~' + '@');
                        var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                        var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());

                        if (key != null && key != '') {
                            var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                            //cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type);
                            cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type + '~' + invtype);
                        }
                        grid.PerformCallback('GridBlank');
                        //cQuotationComponentPanel.PerformCallback('RemoveComponentGridOnSelection');
                        if ("<%=Convert.ToString(Session["TransporterVisibilty"])%>" == "Yes") {
                            clearTransporter(); disc
                        }
                        ccmbGstCstVat.PerformCallback();
                        ccmbGstCstVatcharge.PerformCallback();
                        ctaxUpdatePanel.PerformCallback('DeleteAllTax');
                        //ctxt_InvoiceDate.SetText('');
                        //  OnAddNewClick();
                    }
                });
            }
            else {
                var startDate = new Date();
                startDate = cPLQuoteDate.GetValueString();
                var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
                var componentType = gridquotationLookup.GetGridView().GetRowKey(gridquotationLookup.GetGridView().GetFocusedRowIndex());

                cQuotationComponentPanel.PerformCallback('DateCheckOnChanged' + '~' + key + '~' + startDate + '~' + '@');

                if (key != null && key != '' && type != "") {
                    //cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type);
                    cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type + '~' + invtype);
                }

                if (componentType != null && componentType != '') {
                    grid.PerformCallback('GridBlank');
                }
            }
        }
        function selectValue() {
            var startDate = new Date();
            startDate = cPLQuoteDate.GetValueString();
            var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            if (key != null && key != '') {
                $('#<%=hdnTaggedVender.ClientID %>').val(key);
            }

            var invtype = $('#ddlInventory').val();
            var type = ($("[id$='rdl_PurchaseInvoice']").find(":checked").val() != null) ? $("[id$='rdl_PurchaseInvoice']").find(":checked").val() : "";
            var schemaid = $('#ddl_numberingScheme').val();
            if (schemaid != '0') {
                if (type == "PO") {
                    //gridLookup.SetEnabled(false);
                    //clbl_InvoiceNO.SetText('Purchase Order Date');
                    $("#ddlInventory").attr("disabled", true);
                    if (invtype == 'Y') {
                        grid.GetEditor('ProductName').SetEnabled(false);
                    }
                }
                else if (type == "PC") {
                    //gridLookup.SetEnabled(false);
                    //clbl_InvoiceNO.SetText('Purchase Challan Date');
                    $("#ddlInventory").attr("disabled", true);
                    $("#ddl_numberingScheme").attr("disabled", true);
                    if (invtype == 'Y') {
                        grid.GetEditor('ProductName').SetEnabled(false);
                    }
                }
                else {
                    $("#ddlInventory").attr("disabled", false);
                    $("#ddl_numberingScheme").attr("disabled", false);
                    grid.GetEditor('ProductName').SetEnabled(true);
                }


                cQuotationComponentPanel.PerformCallback('DateCheckOnChanged' + '~' + key + '~' + startDate + '~' + '@');

                if (key != null && key != '' && type != "") {
                    cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type + '~' + invtype);
                }

                var componentType = gridquotationLookup.GetGridView().GetRowKey(gridquotationLookup.GetGridView().GetFocusedRowIndex());
                if (componentType != null && componentType != '') {
                    grid.PerformCallback('GridBlank');
                }
            }
            <%--else {
                var RB = document.getElementById("<%=rdl_PurchaseInvoice.ClientID%>");
                if (RB.rows.length > 0) {
                    for (i = 0; i < RB.rows.length; i++) {
                        var cell = RB.rows[i].cells;
                        for (j = 0; j < cell.length; j++) {
                            if (cell[j].childNodes[0].type == "radio") {
                                document.getElementById(cell[j].childNodes[0].id).checked = false;
                            }
                        }
                    }
                }
                $('#ddl_numberingScheme').focus();
                 
            }--%>
        }
    </script>
    <%--Sam Section For extra Modification Section End--%>

    <%--Added By : Samrat Roy -- New Billing/Shipping Section--%>
    <script>
        function SettingTabStatus() {
            if (GetObjectID('hdnCustomerId').value != null && GetObjectID('hdnCustomerId').value != '' && GetObjectID('hdnCustomerId').value != '0') {
                page.GetTabByName('[B]illing/Shipping').SetEnabled(true);
            }
        }

        function disp_prompt(name) {

            if (name == "tab0") {
                //gridLookup.Focus();
                ctxt_partyInvNo.Focus();
                $("#crossdiv").show();
                //alert(name);
                //document.location.href = "SalesQuotation.aspx?";
            }
            if (name == "tab1") {
                var custID = GetObjectID('hdnCustomerId').value;
                if (custID == null && custID == '') {
                    jAlert('Please select a customer');
                    page.SetActiveTabIndex(0);
                    return;
                }
                else {
                    page.SetActiveTabIndex(1);
                    //fn_PopOpen();
                }
            }
        }

    </script>
    <style>
        .pullleftClass {
            position: absolute;
            right: -3px;
            top: 20px;
        }
    </style>

    <%--Added By : Samrat Roy -- New Billing/Shipping Section End--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="pull-left">
                <span class="">
                    <asp:Label ID="lblHeading" runat="server" Text="Add Purchase Invoice For Transporter"></asp:Label>

                </span>
            </h3>

            <div id="pageheaderContent" class="scrollHorizontal pull-right reverse wrapHolder content horizontal-images" style="display: none;" runat="server">
                <div class="Top clearfix">
                    <ul>

                        <li>
                            <div class="lblHolder" id="divContactPhone" style="display: none;" runat="server">
                                <table>
                                    <tr>
                                        <td>Contact Person's Phone</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblContactPhone" runat="server" Text="N/A" CssClass="classout"></asp:Label></td>
                                    </tr>
                                </table>
                            </div>

                        </li>
                        <li>
                            <div class="lblHolder" id="divOutstanding" style="display: none;" runat="server">
                                <table>
                                    <tr>
                                        <td>Receivable</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblOutstanding" runat="server" Text="0.0" CssClass="classout"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>

                        <li>
                            <div class="lblHolder" id="divAvailableStk" style="display: none;">
                                <table>
                                    <tr>
                                        <td>Available Stock</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblAvailableStkPro" runat="server" Text="0.0"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                        <li>
                            <div class="lblHolder" id="divPacking" style="display: none;">
                                <table>
                                    <tr>
                                        <td>Packing Quantity</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblPackingStk" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                        <li>
                            <div class="lblHolder" id="divGSTN" style="display: none;" runat="server">
                                <table>
                                    <tr>
                                        <td>GST Registed?</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblGSTIN" runat="server" Text=""></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                    </ul>
                    <ul style="display: none;">
                        <li>
                            <div class="lblHolder">
                                <table>
                                    <tr>
                                        <td>Selected Branch</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label1" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                        <li>
                            <div class="lblHolder">
                                <table>
                                    <tr>
                                        <td>Selected Product</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblProduct" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                        <li>
                            <div class="lblHolder">
                                <table>
                                    <tr>
                                        <td>Stock Quantity</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblStkQty" runat="server" Text="0.00"></asp:Label>
                                            <asp:Label ID="lblStkUOM" runat="server" Text=" "></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div id="ApprovalCross" runat="server" class="crossBtn">
                <a href=""><i class="fa fa-times"></i></a>

            </div>
            <%--<div id="divcross1" runat="server" class="crossBtn" margin-left: 50px;">--%>
            <div id="crossdiv" runat="server" class="crossBtn">
                <a href="PurchaseInvoiceListForTransporter.aspx"><i class="fa fa-times"></i></a>
            </div>
            <%--</div>--%>
        </div>

    </div>

    <div class="form_main">

        <%-- <div id="loading" style="">
            <div id="loadingcont" >
                <p id="loadingspinr">
                    <img src="/assests/images/loader.gif"
                </p>
            </div>
        </div>--%>


        <div class="row">
            <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ClientInstanceName="page" Width="100%">
                <tabpages>
                    <dxe:TabPage Name="General" Text="General">
                        <ContentCollection>
                            <dxe:ContentControl runat="server">
                                <div class="row">
                                    <div class="col-md-2">
                                        <div class="cityDiv " style="height: auto;">

                                            <asp:Label ID="Label12" runat="server" Text="Inventory Item?" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <asp:DropDownList ID="ddlInventory" runat="server" Width="100%" CssClass="backSelect" onchange="ddlInventory_OnChange()">
                                                <asp:ListItem Value="B">Both</asp:ListItem>
                                                <asp:ListItem Value="Y">Inventory Items</asp:ListItem>
                                                <asp:ListItem Value="N">Non-Inventory Items</asp:ListItem> 
                                                <asp:ListItem Value="C">Capital Goods</asp:ListItem>
                                                
                                            </asp:DropDownList>

                                        </div>
                                    </div>

                                    <div class="col-md-2" runat="server" id="divNumberingScheme">

                                        <dxe:ASPxLabel ID="lbl_NumberingScheme" Width="120px" runat="server" Text="Numbering Scheme">
                                        </dxe:ASPxLabel>
                                        <asp:DropDownList ID="ddl_numberingScheme" runat="server" Width="100%" DataSourceID="SqlSchematype" DataTextField="SchemaName" DataValueField="ID"
                                            onchange="CmbScheme_ValueChange()">
                                        </asp:DropDownList>
                                        <%-- --%>
                                    </div>

                                    <div class="col-md-2">

                                        <dxe:ASPxLabel ID="lbl_PIQuoteNo" runat="server" Text="Invoice Number">
                                        </dxe:ASPxLabel>
                                        <span style="color: red;">*</span>
                                        <asp:TextBox ID="txtVoucherNo" runat="server" Width="100%" MaxLength="50" onchange="txtBillNo_TextChanged()">                             
                                        </asp:TextBox>
                                        <span id="MandatoryBillNo" class="voucherno  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                        <span id="DuplicateBillNo" class="voucherno  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Duplicate Bill Number not allowed"></span>


                                    </div>
                                    <div class="col-md-2">
                                        <dxe:ASPxLabel ID="ASPxLabel2" runat="server" Text="Date">
                                        </dxe:ASPxLabel>
                                        <span style="color: red;">*</span>

                                        <dxe:ASPxDateEdit ID="dt_PLQuote" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cPLQuoteDate" Width="100%">
                                            <ButtonStyle Width="13px">
                                            </ButtonStyle>
                                            <ClientSideEvents DateChanged="function(s, e) { DateCheck()}" GotFocus="function(s,e){cPLQuoteDate.ShowDropDown();}" />
                                        </dxe:ASPxDateEdit>
                                        <span id="MandatoryDate" class="PODate  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>

                                    </div>
                                    <div class="col-md-2">
                                        <dxe:ASPxLabel ID="lbl_Branch" runat="server" Text="for Branch">
                                        </dxe:ASPxLabel>
                                        <span style="color: red;">*</span>
                                        <asp:DropDownList ID="ddl_Branch" runat="server" Width="100%" onchange="CmbBranch_ValueChange()">
                                        </asp:DropDownList>
                                        <%-- DataSourceID="DS_Branch"  DataTextField="branch_description" DataValueField="branch_id"--%>
                                    </div>

                                    <div class="col-md-2">



                                        <dxe:ASPxLabel ID="lbl_Refference" runat="server" Text="Reference">
                                        </dxe:ASPxLabel>


                                        <dxe:ASPxTextBox ID="txt_Refference" runat="server" Width="100%" ClientInstanceName="ctxt_Refference">
                                        </dxe:ASPxTextBox>


                                    </div>

                                    <div style="clear: both"></div>
                                    <div class="col-md-2">

                                        <dxe:ASPxLabel ID="lbl_Customer" runat="server" Text="Transporter">
                                        </dxe:ASPxLabel>
                                        <span style="color: red;">*</span>

                                        <%--  <dxe:ASPxGridLookup ID="ASPxGridLookup1" runat="server" DataSourceID="ProductDataSource" ClientInstanceName="cproductLookUp"   
                        KeyFieldName="Products_ID" Width="800" TextFormatString="{0}" MultiTextSeparator=", " ClientSideEvents-TextChanged="ProductSelected" ClientSideEvents-KeyDown="ProductlookUpKeyDown">
                                        --%>
                                       <%-- DataSourceID="CustomerDataSource"--%>
                                        <dxe:ASPxCallbackPanel runat="server" ID="vendorPanel" ClientInstanceName="cvendorPanel" OnCallback="vendorPanel_Callback">
                                    <PanelCollection>

                        <dxe:PanelContent runat="server">
                                        <dxe:ASPxGridLookup ID="lookup_Customer" runat="server" ClientInstanceName="gridLookup"  OnDataBinding="lookup_Customer_DataBinding" 
                                            KeyFieldName="cnt_internalid" Width="100%" TextFormatString="{1}" AutoGenerateColumns="False">

                                            <Columns>
                                                <dxe:GridViewDataColumn FieldName="shortname" Visible="true" VisibleIndex="0" Caption="Short Name" Width="200px" Settings-AutoFilterCondition="Contains" />
                                                <dxe:GridViewDataColumn FieldName="Name" Visible="true" VisibleIndex="1" Caption="Name" Settings-AutoFilterCondition="Contains" Width="200px">
                                                </dxe:GridViewDataColumn>
                                                <dxe:GridViewDataColumn FieldName="Type" Visible="true" VisibleIndex="2" Caption="Type" Settings-AutoFilterCondition="Contains" Width="200px">
                                                </dxe:GridViewDataColumn>
                                                <dxe:GridViewDataColumn FieldName="cnt_internalid" Visible="false" VisibleIndex="3" Settings-AllowAutoFilter="False" Width="200px">
                                                    <Settings AllowAutoFilter="False"></Settings>
                                                </dxe:GridViewDataColumn>


                                                <%-- <dxe:GridViewDataColumn FieldName="Name" Visible="true" VisibleIndex="0" Caption="Name" Width="150" Settings-AutoFilterCondition="Contains">
                                                                            </dxe:GridViewDataColumn>
                                                                             <dxe:GridViewDataColumn FieldName="shortname" Visible="true" VisibleIndex="1" Caption="Short Name" Width="100" Settings-AutoFilterCondition="Contains">
                                                                            </dxe:GridViewDataColumn>
                                                                            <dxe:GridViewDataColumn FieldName="cnt_internalid" Visible="false" VisibleIndex="2" Settings-AllowAutoFilter="False" Width="150">
                                                                                <Settings AllowAutoFilter="False"></Settings>
                                                                            </dxe:GridViewDataColumn>--%>
                                            </Columns>
                                            <GridViewProperties Settings-VerticalScrollBarMode="Auto">
                                                <Templates>
                                                    <StatusBar>
                                                        <table class="OptionsTable" style="float: right">
                                                            <tr>
                                                                <td>
                                                                    <%--<dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridLookup" UseSubmitBehavior ="False"/>--%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </StatusBar>
                                                </Templates>

                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>

                                                <%-- <Settings ShowFilterRow="True" ShowStatusBar="Visible" />--%>

                                                <Settings ShowFilterRow="True" ShowFilterRowMenu="true" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                                             <%--   GotFocus="function(s,e){gridLookup.ShowDropDown();}"--%> <%--EndCallback="VendorFilterEndCallBack"--%>
                                            </GridViewProperties>
                                            <ClientSideEvents  TextChanged="function(s, e) { GetContactPerson(e)}" GotFocus="function(s,e){gridLookup.ShowDropDown();}"  />
                                            
                                            <ClearButton DisplayMode="Auto">
                                            </ClearButton>
                                        </dxe:ASPxGridLookup>
                                        <span id="MandatorysVendor" class="POVendor  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                   </dxe:PanelContent>
                        </PanelCollection>
                         </dxe:ASPxCallbackPanel>
                             </div>


                                    <%-- Code Added by Sam on 25052017--%>
                                      <dxe:ASPxCallbackPanel runat="server" ID="partyInvoicepanel" ClientInstanceName="cpartyInvoicepanel" OnCallback="partyInvoicepanel_Callback">
                                    <PanelCollection>

                        <dxe:PanelContent runat="server">
                                    <div class="col-md-2">



                                        <dxe:ASPxLabel ID="lbl_partyInvNo" runat="server" Text="Party Invoice No">
                                        </dxe:ASPxLabel>


                                        <dxe:ASPxTextBox ID="txt_partyInvNo" runat="server" Width="100%" ClientInstanceName="ctxt_partyInvNo">
                                            <ClientSideEvents LostFocus="DuplicatePartyNo" />
                                            <%--<ClientSideEvents  GotFocus="function(s,e){ctxt_partyInvNo.ShowDropDown();}" />--%>
                                        </dxe:ASPxTextBox>
                                         <span id="MandatorysPartyinvno" class="POVendor  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                        <span id="DuplicatePartyinvno" class="POVendor  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Party Invoice No. already exist for the selected vendor."></span>


                                    </div>

                                    <div class="col-md-2">
                                        <dxe:ASPxLabel ID="lbl_partyInvDt" runat="server" Text="Party Invoice Date">
                                        </dxe:ASPxLabel>

                                        <dxe:ASPxDateEdit ID="dt_partyInvDt" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cdt_partyInvDt"
                                            Width="100%">
                                            <ButtonStyle Width="13px">
                                            </ButtonStyle>
                                            <ClientSideEvents LostFocus="partyInvDtMandatorycheck" GotFocus="function(s,e){cdt_partyInvDt.ShowDropDown();}" />
                                        </dxe:ASPxDateEdit>
                                        <span id="MandatoryPartyDate" class="PODate  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                        <span id="MandatoryEgSDate" class="PODate  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Party Invoice Date can not be greater than Invoice Date"></span>
                                        <%--                                            <span id="MandatoryDate" class="PODate  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>--%>
                                    </div>

                            </dxe:PanelContent>
                        </PanelCollection>
                         </dxe:ASPxCallbackPanel>
                                    <%--Code added by Sam on 25052017  --%>


                                    <div class="col-md-2">

                                        <dxe:ASPxLabel ID="lbl_ContactPerson" runat="server" Text="Contact Person">
                                        </dxe:ASPxLabel>
                                        <dxe:ASPxComboBox ID="cmbContactPerson" runat="server" OnCallback="cmbContactPerson_Callback" Width="100%" ClientInstanceName="cContactPerson" Font-Size="12px" ClientSideEvents-EndCallback="cmbContactPersonEndCall">
                                            <ClientSideEvents TextChanged="function(s, e) { GetContactPersonPhone(e)}" GotFocus="function(s,e){cContactPerson.ShowDropDown();}" />
                                        </dxe:ASPxComboBox>

                                    </div>


                                    <div class="col-md-2 relative" id="rdlbutton">
                                        <%-- <i class="fa fa-close" style="position:absolute; right:18px;top:0;color:red" aria-hidden="true" title="clear"></i>--%>
                                        <asp:RadioButtonList ID="rdl_PurchaseInvoice" runat="server" RepeatDirection="Horizontal" onchange="return selectValue();" Width="150px">
                                            <asp:ListItem Text="Order" Value="PO"></asp:ListItem>
                                            <asp:ListItem Text="GRN" Value="PC"></asp:ListItem>
                                        </asp:RadioButtonList>
                                        <dxe:ASPxCallbackPanel runat="server" ID="ComponentQuotationPanel" ClientInstanceName="cQuotationComponentPanel" OnCallback="ComponentQuotation_Callback">
                                            <PanelCollection>
                                                <dxe:PanelContent runat="server">
                                                    <dxe:ASPxGridLookup ID="lookup_quotation" SelectionMode="Multiple" runat="server" ClientInstanceName="gridquotationLookup"
                                                        OnDataBinding="lookup_quotation_DataBinding"
                                                        KeyFieldName="ComponentID" Width="100%" TextFormatString="{0}" AutoGenerateColumns="False" MultiTextSeparator=", ">

                                                        <Columns>
                                                            <dxe:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Width="60" Caption=" " />


                                                            <dxe:GridViewDataColumn FieldName="ComponentNumber" Visible="true" VisibleIndex="1" Caption="Number" Settings-AutoFilterCondition="Contains" Width="120" />
                                                            <dxe:GridViewDataColumn FieldName="ComponentDate" Visible="true" VisibleIndex="2" Caption="Date" Settings-AutoFilterCondition="Contains" Width="120" />
                                                            <dxe:GridViewDataColumn FieldName="CustomerName" Visible="true" VisibleIndex="3" Caption="Vendor Name" Settings-AutoFilterCondition="Contains" Width="120" />
                                                            <dxe:GridViewDataColumn FieldName="branch" Visible="true" VisibleIndex="4" Caption="Branch" Settings-AutoFilterCondition="Contains" Width="120" />
                                                            <dxe:GridViewDataColumn FieldName="reference" Visible="true" VisibleIndex="5" Caption="Reference" Settings-AutoFilterCondition="Contains" Width="120" />
                                                            <dxe:GridViewDataColumn FieldName="Invtype" Visible="true" VisibleIndex="5" Caption="Type" Settings-AutoFilterCondition="Contains" Width="120" />
                                                            <dxe:GridViewDataColumn FieldName="PartyInvoiceNo" Visible="true" VisibleIndex="5" Caption="Party Invoice No" Settings-AutoFilterCondition="Contains" Width="120" />
                                                            <dxe:GridViewDataColumn FieldName="PartyInvoiceDate" Visible="true" VisibleIndex="5" Caption="Party Invoice Date" Settings-AutoFilterCondition="Contains" Width="120" />
                                                        </Columns>
                                                        <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                                                            <Templates>
                                                                <StatusBar>
                                                                    <table class="OptionsTable" style="float: right">
                                                                        <tr>
                                                                            <td>
                                                                                <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridQuotationLookup" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </StatusBar>
                                                            </Templates>
                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                            <SettingsPager Mode="ShowAllRecords">
                                                            </SettingsPager>
                                                            <Settings ShowFilterRow="True" ShowFilterRowMenu="true" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                                                        </GridViewProperties>
                                                        <ClientSideEvents ValueChanged="function(s, e) { QuotationNumberChanged();}" GotFocus="DisableDeleteOption" />
                                                    </dxe:ASPxGridLookup>
                                                    <%--GotFocus="function(s,e){gridquotationLookup.ShowDropDown();}"--%>
                                                </dxe:PanelContent>
                                            </PanelCollection>
                                            <ClientSideEvents EndCallback="componentEndCallBack" />
                                        </dxe:ASPxCallbackPanel>

                                        <dxe:ASPxPopupControl ID="ASPxProductsPopup" runat="server" ClientInstanceName="cProductsPopup"
                                            Width="900px" HeaderText="Select Tax" PopupHorizontalAlign="WindowCenter"
                                            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                                            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
                                            <HeaderTemplate>
                                                <strong><span style="color: #fff">Select Products</span></strong>
                                                <dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                                                    <ClientSideEvents Click="function(s, e){ 
                                                                                        cProductsPopup.Hide();
                                                                                    }" />
                                                </dxe:ASPxImage>
                                            </HeaderTemplate>
                                            <ContentCollection>
                                                <dxe:PopupControlContentControl runat="server">
                                                    <div style="padding: 7px 0;" id="divselectunselect" runat="server">
                                                        <input type="button" value="Select All Products" onclick="ChangeState('SelectAll')" class="btn btn-primary"></input>
                                                        <input type="button" value="De-select All Products" onclick="ChangeState('UnSelectAll')" class="btn btn-primary"></input>
                                                        <input type="button" value="Revert" onclick="ChangeState('Revart')" class="btn btn-primary"></input>
                                                    </div>
                                                    <dxe:ASPxGridView runat="server" KeyFieldName="ComponentDetailsID" ClientInstanceName="cgridproducts" ID="grid_Products"
                                                        Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" SettingsPager-Mode="ShowAllRecords" OnCustomCallback="cgridProducts_CustomCallback"
                                                        Settings-ShowFooter="false" AutoGenerateColumns="False" Settings-VerticalScrollableHeight="300" Settings-VerticalScrollBarMode="Visible" OnCommandButtonInitialize="grid_Products_CommandButtonInitialize">
                                                        <SettingsBehavior AllowDragDrop="False" AllowSort="False"></SettingsBehavior>
                                                        <SettingsPager Visible="false"></SettingsPager>
                                                        <Columns>
                                                            <dxe:GridViewCommandColumn ShowSelectCheckbox="True" Width="40" Caption=" " VisibleIndex="0" />
                                                            <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="SrlNo" Width="40" ReadOnly="true" Caption="Sl. No.">
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="ComponentNumber" Width="120" ReadOnly="true" Caption="Number">
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="ProductID" ReadOnly="true" Caption="Product" Width="0">
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="ProductsName" ReadOnly="true" Width="100" Caption="Product Name">
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="ProductDescription" Width="200" ReadOnly="true" Caption="Product Description">
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn Caption="Balance Quantity" FieldName="Quantity" Width="70" VisibleIndex="6">
                                                                <PropertiesTextEdit>
                                                                    <MaskSettings Mask="<0..999999999999>.<0..99>" AllowMouseWheel="false" />
                                                                </PropertiesTextEdit>
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="7" FieldName="ComponentID" ReadOnly="true" Caption="ComponentID" Width="0">
                                                            </dxe:GridViewDataTextColumn>
                                                        </Columns>
                                                        <SettingsDataSecurity AllowEdit="true" />
                                                        <ClientSideEvents EndCallback="HideSelectAllSection" />
                                                    </dxe:ASPxGridView>

                                                    <div class="text-center">


                                                        <dxe:ASPxButton ID="Button2" ClientInstanceName="cButton2" runat="server" AutoPostBack="False" Text="OK" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                                            <ClientSideEvents Click="function(s, e) {return PerformCallToGridBind();}" />
                                                        </dxe:ASPxButton>
                                                    </div>
                                                </dxe:PopupControlContentControl>
                                            </ContentCollection>
                                            <ContentStyle VerticalAlign="Top" CssClass="pad"></ContentStyle>
                                            <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                                        </dxe:ASPxPopupControl>



                                    </div>
                                    <div class="col-md-2" id="rdldate">
                                        <dxe:ASPxLabel ID="lbl_InvoiceNO" runat="server" Text="Order/Challan Date" ClientInstanceName="clbl_InvoiceNO">
                                        </dxe:ASPxLabel>
                                        <div style="width: 100%; height: 23px">


                                            <dxe:ASPxCallbackPanel runat="server" ID="ComponentDatePanel" ClientInstanceName="cComponentDatePanel" OnCallback="ComponentDatePanel_Callback">
                                                <PanelCollection>
                                                    <dxe:PanelContent runat="server">
                                                        <dxe:ASPxTextBox ID="dt_Quotation" runat="server" Width="100%" DisplayFormatString="dd-MM-yyyy" ClientEnabled="false" ClientInstanceName="cPLQADate">
                                                        </dxe:ASPxTextBox>

                                                        <%--<dxe:ASPxDateEdit ID="txtDateIndentRequis" runat="server" Enabled="false" Visible="false" EditFormat="Custom" ClientInstanceName="cIndentRequisDate" Width="100%">
                                                            <ButtonStyle Width="13px">
                                                            </ButtonStyle>
                                                            <ValidationSettings CausesValidation="True" ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right" ErrorText="Expiry date can not be shorter than Pl/Indent date.">
                                                                <RequiredField IsRequired="true" />
                                                            </ValidationSettings>

                                                            <ClientSideEvents  DateChanged="function(s,e){SetDifference1();}"
                                                                Validation="function(s,e){e.isValid = (CheckDifference()>=0)}" />
                                                        </dxe:ASPxDateEdit>--%>
                                                    </dxe:PanelContent>
                                                </PanelCollection>
                                                <ClientSideEvents EndCallback="panelEndCallBack" />
                                            </dxe:ASPxCallbackPanel>

                                        </div>
                                    </div>




                                    <div style="clear: both"></div>

                                    <div class="col-md-2 lblmTop8 hide">

                                        <dxe:ASPxLabel ID="ASPxLabel1" runat="server" Text="Cash">
                                        </dxe:ASPxLabel>
                                        <dxe:ASPxComboBox ID="ddl_cashBank" runat="server" ClientIDMode="Static" ClientInstanceName="cddl_cashBank" Width="100%">
                                            <ClientSideEvents GotFocus="function(s,e){cddl_cashBank.ShowDropDown();}" />
                                        </dxe:ASPxComboBox>
                                    </div>

                                    <div class="col-md-2 lblmTop8">

                                        <dxe:ASPxLabel ID="lbl_Currency" runat="server" Text="Currency">
                                        </dxe:ASPxLabel>
                                        <asp:DropDownList ID="ddl_Currency" runat="server" Width="100%" onchange="ddl_Currency_Rate_Change()">
                                        </asp:DropDownList>
                                        <%--DataSourceID="SqlCurrency" DataValueField="Currency_ID" DataTextField="Currency_AlphaCode"--%>
                                    </div>
                                    <div class="col-md-2 lblmTop8">

                                        <dxe:ASPxLabel ID="lbl_Rate" runat="server" Text="Rate">
                                        </dxe:ASPxLabel>


                                        <dxe:ASPxTextBox ID="txt_Rate" runat="server" Width="100%" ClientInstanceName="ctxtRate" CssClass="number" DisplayFormatString="0.00">
                                            <ClientSideEvents LostFocus="ReBindGrid_Currency" GotFocus="GetPreviousCurrency"/>
                                        </dxe:ASPxTextBox>
                                       <%-- <dxe:ASPxSpinEdit ID="txt_Rate" runat="server" DecimalPlaces="2" Width="100%" ClientInstanceName="ctxtRate">
                                                   <SpinButtons ShowIncrementButtons="false" />
                                            <ClientSideEvents LostFocus="ReBindGrid_Currency" GotFocus="GetPreviousCurrency" />
                                       </dxe:ASPxSpinEdit>--%>

                                    </div>

                                    <div id="divreverse" class="col-md-2 lblmTop8 hide" style="padding-top: 18px;">
                                        <%--    <asp:CheckBox ID="chk_reversemechenism" runat="server" Enabled="false" />--%>
                                        <dxe:ASPxCheckBox ID="chk_reversemechenism" ClientInstanceName="cchk_reversemechenism" runat="server">
                                        </dxe:ASPxCheckBox>
                                        <dxe:ASPxLabel ID="ASPxLabel3" runat="server" Text="Reverse Mechanism">
                                        </dxe:ASPxLabel>

                                    </div>

                                    <%--SamModification after --%>

                                    <div id="divTdsScheme" class="col-md-2 lblmTop8 hide" runat="server">

                                        <dxe:ASPxLabel ID="ASPxLabel4" runat="server" Text="Select TDS Section">
                                        </dxe:ASPxLabel>
                                        <dxe:ASPxComboBox ID="ddl_TdsScheme" runat="server" OnCallback="ddl_TdsScheme_Callback" Width="100%" ClientInstanceName="cddl_TdsScheme" Font-Size="12px">
                                            <ClientSideEvents TextChanged="function(s, e) { GridProductBind(e)}" />
                                            <%-- GotFocus="function(s,e){cContactPerson.ShowDropDown();}"--%>
                                            <%-- ClientSideEvents-EndCallback="cmbContactPersonEndCall"--%>
                                        </dxe:ASPxComboBox>

                                    </div>
                                    <%--SamModification after --%>
                                    <div class="col-md-2 lblmTop8">

                                        <dxe:ASPxLabel ID="lbl_AmountAre" runat="server" Text="Amounts are">
                                        </dxe:ASPxLabel>


                                        <dxe:ASPxComboBox ID="ddl_AmountAre" runat="server" ClientIDMode="Static" ClientInstanceName="cddl_AmountAre" Width="100%">
                                            <ClientSideEvents SelectedIndexChanged="function(s, e) { PopulateGSTCSTVAT(e)}" />
                                            <ClientSideEvents LostFocus="function(s, e) { SetFocusonDemand(e)}" GotFocus="function(s,e){cddl_AmountAre.ShowDropDown();}" />
                                        </dxe:ASPxComboBox>

                                    </div>
                                    <div class="col-md-2 lblmTop8 hide" style="margin-bottom: 15px">

                                        <dxe:ASPxLabel ID="lblVatGstCst" runat="server" Text="Select GST">
                                        </dxe:ASPxLabel>
                                        <dxe:ASPxComboBox ID="ddl_VatGstCst" runat="server" ClientInstanceName="cddlVatGstCst" Width="100%" OnCallback="ddl_VatGstCst_Callback">
                                            <ClientSideEvents EndCallback="Onddl_VatGstCstEndCallback" GotFocus="function(s,e){cddlVatGstCst.ShowDropDown();}" />
                                        </dxe:ASPxComboBox>

                                    </div>
                                    <div style="clear: both;"></div>
                                            <div class="col-md-6">
                                                <dxe:ASPxLabel ID="ASPxLabel9" runat="server" Text="Remarks">
                                                </dxe:ASPxLabel>
                                                <asp:TextBox ID="txtRemarks" runat="server" MaxLength="500"></asp:TextBox>
                                            </div>
                                    <%--<div class="col-md-3">
                                    <dxe:ASPxTextBox ID="txt_pbamt" MaxLength="80" ClientInstanceName="ctxt_pbamt" Text="0.00"  
                                                runat="server" Width="100%" CssClass="pull-left mTop">
                                                <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                 
                                            </dxe:ASPxTextBox>
                                        </div>--%>
                                    <div style="clear: both;"></div>
                                    <div class="col-md-12">


                                        <dxe:ASPxGridView runat="server" OnBatchUpdate="grid_BatchUpdate"  KeyFieldName="PurchaseInvoiceDetailID" 
                                            ClientInstanceName="grid" ID="grid"
                                            Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" 
                                            OnCellEditorInitialize="grid_CellEditorInitialize" OnHtmlRowPrepared="grid_HtmlRowPrepared"
                                            Settings-ShowFooter="false" OnCustomCallback="grid_CustomCallback" OnDataBinding="grid_DataBinding" 
                                            OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting"
                                            Settings-VerticalScrollBarMode="auto" Settings-VerticalScrollableHeight="150" RowHeight="2">
                                            <SettingsPager  Mode="ShowAllRecords"></SettingsPager>

                                            <Columns>
                                                <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="2.5%" VisibleIndex="0"
                                                    Caption="">
                                                    <CustomButtons>
                                                        <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomDelete" Image-Url="/assests/images/crs.png">
                                                        </dxe:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                </dxe:GridViewCommandColumn>
                                                <dxe:GridViewDataTextColumn FieldName="SrlNo" Caption="Sl" ReadOnly="true" VisibleIndex="1" Width="2%">
                                                    <PropertiesTextEdit>
                                                    </PropertiesTextEdit>
                                                </dxe:GridViewDataTextColumn>
                                                <%--Batch Product Popup Start--%>
                                                <%--<dxe:GridViewDataTextColumn Caption="Indent" FieldName="Indent_Num" ReadOnly="True" Width="80" VisibleIndex="2">
                                                        <PropertiesTextEdit>
                                                        </PropertiesTextEdit>
                                                    </dxe:GridViewDataTextColumn>--%>
                                                <dxe:GridViewDataTextColumn FieldName="ComponentNumber" Caption="Doc Number" VisibleIndex="2" ReadOnly="True" Width="6%">
                                                    <CellStyle Wrap="True"></CellStyle>
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataButtonEditColumn FieldName="ProductName" Caption="Product" VisibleIndex="3" Width="11%">
                                                    <PropertiesButtonEdit>
                                                        <ClientSideEvents ButtonClick="ProductButnClick" KeyDown="ProductKeyDown" GotFocus="ProductsGotFocusFromID" LostFocus="ProductsGotFocus" />
                                                        <Buttons>
                                                            <dxe:EditButton Text="..." Width=".5%">
                                                            </dxe:EditButton>
                                                        </Buttons>
                                                    </PropertiesButtonEdit>
                                                </dxe:GridViewDataButtonEditColumn>
                                                <%--<dxe:GridViewDataTextColumn FieldName="ProductID" Caption="hidden Field Id" VisibleIndex="16" ReadOnly="True" Width="0" EditCellStyle-CssClass="hide" PropertiesTextEdit-FocusedStyle-CssClass="hide" PropertiesTextEdit-Style-CssClass="hide" PropertiesTextEdit-Height="15px">
                                                        <CellStyle Wrap="True" CssClass="hide"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>--%>

                                                <%--Batch Product Popup End--%>
                                                <%-- <dxe:GridViewDataComboBoxColumn Caption="Product" FieldName="ProductID" VisibleIndex="2" Width="15%">
                                                        <PropertiesComboBox ValueField="ProductID" ClientInstanceName="ProductID" TextField="ProductName"  EnableCallbackMode="true" CallbackPageSize="100">
                                                             <ClientSideEvents SelectedIndexChanged="ProductsCombo_SelectedIndexChanged" GotFocus="ProductsGotFocus" />
                                                        </PropertiesComboBox>
                                                          <CellStyle Wrap="True"></CellStyle>
                                                    </dxe:GridViewDataComboBoxColumn>--%>
                                                <%--<dxe:GridViewDataTextColumn FieldName="Description" Caption="Description" VisibleIndex="4"  Width="200"  >
                                                        <PropertiesTextEdit>
                                                        </PropertiesTextEdit>
                                                         <CellStyle Wrap="True"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>--%>
                                                <dxe:GridViewDataTextColumn FieldName="Description" Caption="Description" VisibleIndex="4" ReadOnly="True" Width="16%">
                                                    <CellStyle Wrap="True"></CellStyle>

                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="Quantity" Caption="Quantity" VisibleIndex="5" Width="7%"
                                                    HeaderStyle-HorizontalAlign="Right">
                                                    <PropertiesTextEdit DisplayFormatString="0.0000" Style-HorizontalAlign="Right"></PropertiesTextEdit>
                                                    <PropertiesTextEdit>
                                                        <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..9999&gt;" AllowMouseWheel="false" />
                                                        <ClientSideEvents LostFocus="QuantityTextChange" GotFocus="QuantityGotFocus" />
                                                        <%-- LostFocus="QuantityTextChange"--%>
                                                    </PropertiesTextEdit>
                                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="UOM" Caption="UOM(Purc.)" VisibleIndex="6" Width="6%" ReadOnly="true">
                                                    <PropertiesTextEdit>
                                                        <%-- <ClientSideEvents LostFocus="QuantityTextChange" />--%>
                                                    </PropertiesTextEdit>
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewCommandColumn Width="5.5%" VisibleIndex="6" Caption="Stk Details">
                                                    <CustomButtons>
                                                        <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomWarehouse" Image-Url="/assests/images/warehouse.png">
                                                        </dxe:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                </dxe:GridViewCommandColumn>


                                                <dxe:GridViewDataTextColumn FieldName="PurchasePrice" Caption="Purc. Price" VisibleIndex="7" Width="7%" HeaderStyle-HorizontalAlign="Right">
                                                    <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right"></PropertiesTextEdit>
                                                    <PropertiesTextEdit>
                                                        <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                        <%-- <MaskSettings Mask="&lt;0..999999999g&gt;.&lt;00..99&gt;" AllowMouseWheel="false"/>--%>
                                                        <ClientSideEvents LostFocus="PurchasePriceTextChange" GotFocus="PurPriceGotFocus" />
                                                        <%--LostFocus="QuantityTextChange"--%>
                                                    </PropertiesTextEdit>
                                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="Discount" Caption="Disc(%)" VisibleIndex="8" Width="4%" HeaderStyle-HorizontalAlign="Right">
                                                    <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right"></PropertiesTextEdit>
                                                    <PropertiesTextEdit>
                                                        <MaskSettings Mask="&lt;0..99999999999&gt;.&lt;00..999&gt;" AllowMouseWheel="false" />
                                                        <ClientSideEvents LostFocus="DiscountTextChange" GotFocus="DiscountGotChange"  />
                                                        <%--LostFocus="DiscountTextChange" GotFocus="DiscountGotChange"--%>
                                                    </PropertiesTextEdit>
                                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                                </dxe:GridViewDataTextColumn>

                                                <%-- Discount in Amt Section Start By Sam on 17052017--%>

                                                <dxe:GridViewDataTextColumn FieldName="Discountamt" Caption="Disc Amt" VisibleIndex="8" Width="6%" HeaderStyle-HorizontalAlign="Right">
                                                    <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right"></PropertiesTextEdit>
                                                    <PropertiesTextEdit>
                                                        <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..999&gt;" AllowMouseWheel="false" />
                                                        <ClientSideEvents LostFocus="DiscountAmtTextChange" GotFocus="DiscountAmtGotChange" />
                                                        <%--LostFocus="DiscountAmtTextChange"--%>
                                                    </PropertiesTextEdit>
                                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                                </dxe:GridViewDataTextColumn>
                                                <%-- Discount in Amt Section Start By Sam on 17052017--%>

                                                <dxe:GridViewDataTextColumn FieldName="Amount" Caption="Amount" VisibleIndex="9" Width="8%" HeaderStyle-HorizontalAlign="Right">
                                                    <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right"></PropertiesTextEdit>
                                                    <PropertiesTextEdit>
                                                         <MaskSettings Mask="&lt;0..9999999999999999999999&gt;.&lt;00..999&gt;" AllowMouseWheel="false" />
                                                       <%-- <MaskSettings Mask="&lt;0..9999999999999999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />--%>
                                                        <ClientSideEvents LostFocus="AmtTextChange" GotFocus="AmtGotFocus" />
                                                        <%-- LostFocus="AmtTextChange"--%>
                                                    </PropertiesTextEdit>
                                                    <CellStyle HorizontalAlign="Right"></CellStyle>

                                                </dxe:GridViewDataTextColumn>
                                                <%-- <dxe:GridViewDataTextColumn FieldName="TaxAmount" Caption="Tax Amount" VisibleIndex="12" Width="6%">
                                                        <PropertiesTextEdit>
                                                              <MaskSettings Mask="<0..999999999>.<0..9999>" AllowMouseWheel="false" />
                                                        </PropertiesTextEdit>
                                                    </dxe:GridViewDataTextColumn>--%>

                                                <dxe:GridViewDataButtonEditColumn FieldName="TaxAmount" Caption="Charges" VisibleIndex="10" Width="6%" HeaderStyle-HorizontalAlign="Right">

                                                    <PropertiesButtonEdit>
                                                        <ClientSideEvents ButtonClick="taxAmtButnClick" GotFocus="taxAmtButnClick1" KeyDown="TaxAmountKeyDown" />
                                                        <Buttons>
                                                            <dxe:EditButton Text="..." Width="20px">
                                                            </dxe:EditButton>
                                                        </Buttons>
                                                        <%--<MaskSettings Mask="<0..999999999999g>.<0..99g>" />--%>
                                                    </PropertiesButtonEdit>
                                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                                </dxe:GridViewDataButtonEditColumn>
                                                <dxe:GridViewDataTextColumn FieldName="TotalAmount" Caption="Net Amount" VisibleIndex="11" Width="6.5%" HeaderStyle-HorizontalAlign="Right">
                                                    <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right"></PropertiesTextEdit>
                                                    <PropertiesTextEdit>
                                                        <MaskSettings Mask="&lt;0..9999999999999999999999&gt;.&lt;00..999&gt;" AllowMouseWheel="false" />
                                                        <%--<MaskSettings Mask="&lt;0..9999999999999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />--%>
                                                    </PropertiesTextEdit>
                                                    <CellStyle HorizontalAlign="Right"></CellStyle>
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="5%" VisibleIndex="12" Caption="Add New">
                                                    <CustomButtons>
                                                        <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomAddNewRow" Image-Url="/assests/images/add.png">
                                                        </dxe:GridViewCommandColumnCustomButton>

                                                    </CustomButtons>

                                                </dxe:GridViewCommandColumn>
                                                <dxe:GridViewDataTextColumn FieldName="ComponentID" Caption="Component ID" VisibleIndex="16" ReadOnly="True" Width="0">
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="ComponentDetailID" Caption="ComponentDetailID" VisibleIndex="20" ReadOnly="True" Width="0">
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="TotalQty" Caption="Total Qty" VisibleIndex="18" ReadOnly="True" Width="0">
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="BalanceQty" Caption="Balance Qty" VisibleIndex="17" ReadOnly="True" Width="0">
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="IsComponentProduct" Caption="IsComponentProduct" VisibleIndex="19" ReadOnly="True" Width="0">
                                                </dxe:GridViewDataTextColumn>
                                                <dxe:GridViewDataTextColumn FieldName="ProductID" PropertiesTextEdit-ValidationSettings-ErrorImage-IconID="ghg" Caption="hidden Field Id" VisibleIndex="21" ReadOnly="True" Width="0" PropertiesTextEdit-Height="15px" PropertiesTextEdit-Style-CssClass="abcd">
                                                    <CellStyle Wrap="True" CssClass="abcd"></CellStyle>
                                                </dxe:GridViewDataTextColumn>
                                                <%-- <dxe:GridViewDataTextColumn Caption="Quotation No" FieldName="Indent" Width="0"  VisibleIndex="13">
                                                <PropertiesTextEdit >
                                                    <NullTextStyle ></NullTextStyle>
                                                    <ReadOnlyStyle ></ReadOnlyStyle>
                                                    <Style></Style>
                                                </PropertiesTextEdit>
                                                <HeaderStyle  />
                                                <CellStyle >
                                                </CellStyle>
                                            </dxe:GridViewDataTextColumn> 
                                                     <dxe:GridViewDataTextColumn FieldName="gvColStockQty" Caption="Stock Qty"   Width="0" >
                                                        <PropertiesTextEdit >
                                                            <MaskSettings Mask="<0..999999999>.<0..9999>" AllowMouseWheel="false" />
                                                            <NullTextStyle ></NullTextStyle>
                                                        <ReadOnlyStyle ></ReadOnlyStyle>
                                                        <Style ></Style>
                                                        </PropertiesTextEdit>
                                                         <HeaderStyle  />
                                                    <CellStyle >
                                                    </CellStyle>
                                                          <CellStyle HorizontalAlign="Right"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>
                                                   <dxe:GridViewDataTextColumn FieldName="gvColStockUOM" Caption="Stk UOM"  
                                                       width="0">
                                                        <PropertiesTextEdit >
                                                             <NullTextStyle ></NullTextStyle>
                                                             <ReadOnlyStyle ></ReadOnlyStyle>
                                                             <Style ></Style>
                                                        </PropertiesTextEdit>
                                                       <HeaderStyle  />
                                                        <CellStyle > </CellStyle>
                                                   
                                                    </dxe:GridViewDataTextColumn>--%>
                                                <%--BatchEditStartEditing="OnBatchStartEdit"--%>
                                            </Columns>
                                            <%--      Init="OnInit"BatchEditStartEditing="OnBatchEditStartEditing" BatchEditEndEditing="OnBatchEditEndEditing"
                                                    CustomButtonClick="OnCustomButtonClick" EndCallback="OnEndCallback" --%>
                                            <ClientSideEvents EndCallback="OnEndCallback" CustomButtonClick="OnCustomButtonClick" RowClick="GetVisibleIndex"
                                                BatchEditStartEditing="gridFocusedRowChanged" />
                                            <SettingsDataSecurity AllowEdit="true" />
                                            <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                                                <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="row" />
                                            </SettingsEditing>
                                        </dxe:ASPxGridView>
                                    </div>
                                   <div style="clear: both;">
                                    <br />
                                    <div style="display: none;">
                                        <dxe:ASPxLabel ID="txt_Charges" runat="server" Text="0.00" ClientInstanceName="ctxt_Charges" />
                                        <dxe:ASPxLabel ID="txt_cInvValue" runat="server" Text="0.00" ClientInstanceName="cInvValue" />
                                    </div>
                                </div>
                                   <%-- Sam New Section Added--%>
                                    <div class="content reverse horizontal-images clearfix" style="width: 100%; margin-right: 0; padding: 8px; height: auto; border-top: 1px solid #ccc; border-bottom: 1px solid #ccc; border-radius: 0;">
                                    <ul>
                                        <li class="clsbnrLblTaxableAmt">
                                            <div class="horizontallblHolder">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <dxe:ASPxLabel ID="bnrLblTotalQty" runat="server" Text="Total Quantity" ClientInstanceName="cbnrLblTotalQty" />
                                                            </td>
                                                            <td>
                                                                <dxe:ASPxLabel ID="txt_TotalQty" runat="server" Text="0.00" ClientInstanceName="cTotalQty" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>
                                        <li class="clsbnrLblTaxableAmt">
                                            <div class="horizontallblHolder">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <dxe:ASPxLabel ID="bnrLblTaxableAmt" runat="server" Text="Taxable Amount" ClientInstanceName="cbnrLblTaxableAmt" />
                                                            </td>
                                                            <td>
                                                                <dxe:ASPxLabel ID="txt_TaxableAmtval" runat="server" Text="0.00" ClientInstanceName="cTaxableAmtval" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>
                                        <li class="clsbnrLblTaxAmt">
                                            <div class="horizontallblHolder">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <dxe:ASPxLabel ID="bnrLblTaxAmt" runat="server" Text="Tax & Charges" ClientInstanceName="cbnrLblTaxAmt" />
                                                            </td>
                                                            <td>
                                                                <dxe:ASPxLabel ID="txt_TaxAmtval" runat="server" Text="0.00" ClientInstanceName="cTaxAmtval" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>
                                        <li class="clsbnrLblTaxAmt">
                                            <div class="horizontallblHolder">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <dxe:ASPxLabel ID="bnrLblOtherTaxAmt" runat="server" Text="Other Charges" ClientInstanceName="cbnrLblOtherTaxAmt" />
                                                            </td>
                                                            <td>
                                                                <dxe:ASPxLabel ID="txt_OtherTaxAmtval" runat="server" Text="0.00" ClientInstanceName="cOtherTaxAmtval" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>
                                        <li class="clsbnrLblInvVal">
                                            <div class="horizontallblHolder">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <dxe:ASPxLabel ID="bnrLblInvVal" runat="server" Text="Total Amount" ClientInstanceName="cbnrLblInvVal" />
                                                            </td>
                                                            <td>
                                                                <dxe:ASPxLabel ID="txt_TotalAmt" runat="server" Text="0.00" ClientInstanceName="cTotalAmt" />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>
                                    </ul>
                                </div>

                                    <%-- Sam New Section Above Added--%>
                                   <%-- id="divSubmitButton" runat="server"--%>
                                     <div class="col-md-12" >
                                        <asp:Label ID="lbl_quotestatusmsg" runat="server" Text="" Font-Bold="true" ForeColor="Red" Font-Size="Medium"></asp:Label>
                                        <dxe:ASPxButton ID="btn_SaveRecords" ClientInstanceName="cbtn_SaveNewRecords" runat="server" AccessKey="X" AutoPostBack="False" Text="S&#818;ave & New" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                            <ClientSideEvents Click="function(s, e) {Save_ButtonClick();}"  />
                                        </dxe:ASPxButton>
                                        <dxe:ASPxButton ID="ASPxButton1" ClientInstanceName="cbtn_SaveRecords" runat="server" AccessKey="X" AutoPostBack="False" Text="Save & E&#818;xit" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                            <ClientSideEvents Click="function(s, e) {SaveExit_ButtonClick();}" />
                                        </dxe:ASPxButton>
                                        <dxe:ASPxButton ID="btnSaveUdf" ClientInstanceName="cbtn_SaveUdf" runat="server" AutoPostBack="False" Text="U&#818;DF" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                            <ClientSideEvents Click="function(s, e) {OpenUdf();}" />
                                        </dxe:ASPxButton>
                                        <dxe:ASPxButton ID="ASPxButton3" ClientInstanceName="cbtn_SaveRecords" runat="server" AccessKey="X" AutoPostBack="False" Text="T&#818;axes" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                            <ClientSideEvents Click="function(s, e) {Save_TaxesClick();}" />
                                        </dxe:ASPxButton>

                                         <dxe:ASPxButton ID="ASPxButton2" ClientInstanceName="cbtn_specialedit" runat="server"  AutoPostBack="False" Text="Special Edit" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False" Visible="false">
                                            <ClientSideEvents Click="function(s, e) {specialedit_ButtonClick();}" />
                                        </dxe:ASPxButton>

                                        <uc1:VehicleDetailsControl runat="server" ID="VehicleDetailsControl" />
                                        <asp:HiddenField ID="hfControlData" runat="server" />

                                        <uc2:TermsConditionsControl runat="server" ID="TermsConditionsControl" />
                                        <asp:HiddenField runat="server" ID="hfTermsConditionData" />
                                        <asp:HiddenField runat="server" ID="hfTermsConditionDocType" Value="PB" />

                                        <asp:HiddenField ID="hdnqtyupdate" runat="server" Value="N" />

                                        <asp:HiddenField ID="hdndelcnt" runat="server" Value="N" />

                                          <asp:HiddenField ID="hdnTaggedVender" runat="server" Value="" />

                                        <%--Tax Related Hiddenfield--%>
                                        <asp:HiddenField ID="hdntaxqty" runat="server" Value="0" />
                                        <asp:HiddenField ID="hdntaxpurprice" runat="server" Value="0" />
                                        <asp:HiddenField ID="hdntaxdisc" runat="server" Value="0" />
                                        <asp:HiddenField ID="hdntaxdiscamt" runat="server" Value="0" />
                                        <asp:HiddenField ID="hdntaxamt" runat="server" Value="0" />

                                        <asp:HiddenField ID="hdnTDSShoworNot" runat="server" Value="N" />

                                          <asp:HiddenField ID="hdnrunningtaxbleAmt" runat="server" Value="" />
                                          <asp:HiddenField ID="hdnRunningTaxAmt" runat="server" Value="" />
                                        <%--Tax Related Hiddenfield--%>

                                        <asp:CheckBox ID="chkmail" runat="server" Text="Send Mail" />
                                    </div>
                                </div>
                            </dxe:ContentControl>
                        </ContentCollection>
                    </dxe:TabPage>
                    <dxe:TabPage Name="Billing/Shipping" Text="Our Billing/Shipping">
                        <ContentCollection>
                            <dxe:ContentControl runat="server">
                                <%-- <dxe:ASPxPopupControl ID="ASPXPopupControl1" runat="server" ContentUrl="AddArea_PopUp.aspx"
                                        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupan" Height="250px"
                                        Width="300px" HeaderText="Add New Area" AllowResize="true" ResizingMode="Postponed" Modal="true">
                                        <ContentCollection>
                                            <dxe:PopupControlContentControl runat="server">
                                            </dxe:PopupControlContentControl>
                                        </ContentCollection>
                                        <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
                                    </dxe:ASPxPopupControl>--%>

                                <ucBS:BillingShippingControl runat="server" ID="BillingShippingControl" />
                            </dxe:ContentControl>
                        </ContentCollection>
                    </dxe:TabPage>

                </tabpages>
                <clientsideevents activetabchanged="function(s, e) {
	                                            var activeTab   = page.GetActiveTab();
	                                            var Tab0 = page.GetTab(0);
	                                            var Tab1 = page.GetTab(1);
	                                            var Tab2 = page.GetTab(2);
                                                
                                               if(activeTab == Tab0)
	                                            {
	                                                disp_prompt('tab0');
	                                            }
	                                            if(activeTab == Tab1)
	                                            {
	                                                disp_prompt('tab1');
	                                            }
	                                           else if(activeTab == Tab2)
	                                            {
	                                                disp_prompt('tab2');
	                                            }


	                                            }"></clientsideevents>
            </dxe:ASPxPageControl>
        </div>
        <%--InlineTax--%>

        <dxe:ASPxPopupControl ID="aspxTaxpopUp" runat="server" ClientInstanceName="caspxTaxpopUp"
            Width="850px" HeaderText="Select Tax" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <headertemplate>
                <span style="color: #fff"><strong>Select Tax</strong></span>
                <dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                    <ClientSideEvents Click="function(s, e){ 
                                                            cgridTax.CancelEdit();
                                                            caspxTaxpopUp.Hide();
                                                        }" />
                </dxe:ASPxImage>
            </headertemplate>
            <contentcollection>
                <dxe:PopupControlContentControl runat="server">
                    <asp:HiddenField runat="server" ID="setCurrentProdCode" />
                    <asp:HiddenField runat="server" ID="HdSerialNo" />
                    <asp:HiddenField runat="server" ID="hdnInvWiseSlno" />
                    <asp:HiddenField runat="server" ID="HdProdGrossAmt" />
                    <asp:HiddenField runat="server" ID="HdProdNetAmt" />
                    <%-- <asp:HiddenField ID="hdnPageStatus1" runat="server" />--%>
                    <%-- Added by Sam to show default cursor after save--%>
                    <asp:HiddenField ID="hdnschemeid" runat="server" />
                    <asp:HiddenField ID="hdnDeleteSrlNo" runat="server" />
                    <asp:HiddenField ID="hdnADDEditMode" runat="server" />
                    <asp:HiddenField ID="hdnprevqty" runat="server" />
                    <%-- Added by Sam to show default cursor after save--%>
                    <div id="content-6">
                        <div class="col-sm-3">
                            <div class="lblHolder">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>Gross Amount
                                                    <dxe:ASPxLabel ID="ASPxLabel5" runat="server" Text="(Taxable)" ClientInstanceName="clblTaxableGross"></dxe:ASPxLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dxe:ASPxLabel ID="lblTaxProdGrossAmt" runat="server" Text="" ClientInstanceName="clblTaxProdGrossAmt"></dxe:ASPxLabel>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="col-sm-3 gstGrossAmount hide">
                            <div class="lblHolder">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>GST</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dxe:ASPxLabel ID="lblGstForGross" runat="server" Text="" ClientInstanceName="clblGstForGross"></dxe:ASPxLabel>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="col-sm-3">
                            <div class="lblHolder">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>Discount</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dxe:ASPxLabel ID="lblTaxDiscount" runat="server" Text="" ClientInstanceName="clblTaxDiscount"></dxe:ASPxLabel>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>


                        <div class="col-sm-3">
                            <div class="lblHolder">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>Net Amount
                                                    <dxe:ASPxLabel ID="ASPxLabel6" runat="server" Text="(Taxable)" ClientInstanceName="clblTaxableNet"></dxe:ASPxLabel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dxe:ASPxLabel ID="lblProdNetAmt" runat="server" Text="" ClientInstanceName="clblProdNetAmt"></dxe:ASPxLabel>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="col-sm-2 gstNetAmount hide">
                            <div class="lblHolder">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>GST</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dxe:ASPxLabel ID="lblGstForNet" runat="server" Text="" ClientInstanceName="clblGstForNet"></dxe:ASPxLabel>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>

                    <%--Error Message--%>
                    <div id="ContentErrorMsg">
                        <div class="col-sm-8">
                            <div class="lblHolder">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>Status
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tax Code/Charges Not defined.
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>





                    <table style="width: 100%;">
                        <tr>
                            <td colspan="2"></td>
                        </tr>

                        <tr>
                            <td colspan="2"></td>
                        </tr>


                        <tr style="display: none">
                            <td><span><strong>Product Basic Amount</strong></span></td>
                            <td>
                                <dxe:ASPxTextBox ID="txtprodBasicAmt" MaxLength="80" ClientInstanceName="ctxtprodBasicAmt" ReadOnly="true"
                                    runat="server" Width="50%">
                                    <MaskSettings Mask="<0..999999999>.<0..99>" AllowMouseWheel="false" />
                                </dxe:ASPxTextBox>
                            </td>
                        </tr>

                        <tr class="cgridTaxClass">
                            <td colspan="3">
                                <dxe:ASPxGridView runat="server" OnBatchUpdate="taxgrid_BatchUpdate" KeyFieldName="Taxes_ID" ClientInstanceName="cgridTax" ID="aspxGridTax"
                                    Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" SettingsPager-Mode="ShowAllRecords" OnCustomCallback="cgridTax_CustomCallback"
                                    Settings-ShowFooter="false" AutoGenerateColumns="False" OnCellEditorInitialize="aspxGridTax_CellEditorInitialize" OnHtmlRowCreated="aspxGridTax_HtmlRowCreated"
                                    OnRowInserting="taxgrid_RowInserting" OnRowUpdating="taxgrid_RowUpdating" OnRowDeleting="taxgrid_RowDeleting">
                                    <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto"></Settings>
                                    <SettingsBehavior AllowDragDrop="False" AllowSort="False"></SettingsBehavior>
                                    <SettingsPager Visible="false"></SettingsPager>
                                    <Columns>
                                        <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="Taxes_Name" ReadOnly="true" Caption="Tax Component ID">
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="taxCodeName" ReadOnly="true" Caption="Tax Component Name">
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="calCulatedOn" ReadOnly="true" Caption="Calculated On">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <%--<dxe:GridViewDataComboBoxColumn Caption="percentage" FieldName="TaxField" VisibleIndex="2">
                                                <PropertiesComboBox ClientInstanceName="cTaxes_Name" ValueField="Taxes_ID" TextField="Taxes_Name" DropDownStyle="DropDown">
                                                    <ClientSideEvents SelectedIndexChanged="cmbtaxCodeindexChange"
                                                        GotFocus="CmbtaxClick" />
                                                </PropertiesComboBox>
                                            </dxe:GridViewDataComboBoxColumn>--%>
                                        <dxe:GridViewDataTextColumn Caption="Percentage" FieldName="TaxField" VisibleIndex="4">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />
                                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="Amount" Caption="Amount" ReadOnly="true">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <ClientSideEvents LostFocus="taxAmountLostFocus" GotFocus="taxAmountGotFocus" />
                                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                    </Columns>
                                    <%--  <SettingsPager Mode="ShowAllRecords"></SettingsPager>--%>
                                    <SettingsDataSecurity AllowEdit="true" />
                                    <SettingsEditing Mode="Batch">
                                        <BatchEditSettings EditMode="row" />
                                    </SettingsEditing>
                                    <ClientSideEvents EndCallback=" cgridTax_EndCallBack " RowClick="GetTaxVisibleIndex" />

                                </dxe:ASPxGridView>

                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <table class="InlineTaxClass hide" >
                                    <tr class="GstCstvatClass" style="">
                                        <td style="padding-top: 10px; padding-bottom: 15px; padding-right: 25px"><span><strong>GST</strong></span></td>
                                        <td style="padding-top: 10px; padding-bottom: 15px;">
                                            <dxe:ASPxComboBox ID="cmbGstCstVat" ClientInstanceName="ccmbGstCstVat" runat="server" SelectedIndex="-1"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" TextFormatString="{0}"
                                                ClearButton-DisplayMode="Always" OnCallback="cmbGstCstVat_Callback">

                                                <Columns>
                                                    <dxe:ListBoxColumn FieldName="Taxes_Name" Caption="Tax Component ID" Width="250" />
                                                    <dxe:ListBoxColumn FieldName="TaxCodeName" Caption="Tax Component Name" Width="250" />

                                                </Columns>

                                                <ClientSideEvents SelectedIndexChanged="cmbGstCstVatChange"
                                                    GotFocus="CmbtaxClick" />
                                            </dxe:ASPxComboBox>



                                        </td>
                                        <td style="padding-left: 15px; padding-top: 10px; padding-bottom: 15px; padding-right: 25px">
                                            <dxe:ASPxTextBox ID="txtGstCstVat" MaxLength="80" ClientInstanceName="ctxtGstCstVat" ReadOnly="true" Text="0.00"
                                                runat="server" Width="100%">
                                                <MaskSettings Mask="<-999999999..999999999>.<0..99>" AllowMouseWheel="false" />
                                            </dxe:ASPxTextBox>


                                        </td>
                                        <td>
                                            <input type="button" onclick="recalculateTax()" class="btn btn-info btn-small RecalculateInline" value="Recalculate GST" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div class="pull-left">

                                    <dxe:ASPxButton ID="Button1" ClientInstanceName="cButton1" runat="server" AutoPostBack="False" Text="OK" CssClass="btn btn-primary mTop" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                        <ClientSideEvents Click="function(s, e) {return BatchUpdate();}" />
                                    </dxe:ASPxButton>

                                    <dxe:ASPxButton ID="Button3" ClientInstanceName="cButton3" runat="server" AutoPostBack="False" Text="Cancel" CssClass="btn btn-danger mTop" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                        <ClientSideEvents Click="function(s, e) {cgridTax.CancelEdit(); caspxTaxpopUp.Hide(); return false;}" />
                                    </dxe:ASPxButton>
                                </div>
                                <table class="pull-right">
                                    <tr>
                                        <td style="padding-top: 10px; padding-right: 5px"><strong>Total Charges</strong></td>
                                        <td>
                                            <dxe:ASPxTextBox ID="txtTaxTotAmt" MaxLength="80" ClientInstanceName="ctxtTaxTotAmt" Text="0.00" ReadOnly="true"
                                                runat="server" Width="100%" CssClass="pull-left mTop">
                                                <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                <%--<MaskSettings Mask="<0..999999999>.<0..99>" AllowMouseWheel="false" /> --%>
                                            </dxe:ASPxTextBox>

                                        </td>
                                    </tr>
                                </table>


                                <div class="clear"></div>
                            </td>
                        </tr>

                    </table>
                </dxe:PopupControlContentControl>
            </contentcollection>
            <contentstyle verticalalign="Top" cssclass="pad"></contentstyle>
            <headerstyle backcolor="LightGray" forecolor="Black" />
        </dxe:ASPxPopupControl>
        <dxe:ASPxCallbackPanel runat="server" ID="taxUpdatePanel" ClientInstanceName="ctaxUpdatePanel" OnCallback="taxUpdatePanel_Callback">
            <panelcollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </panelcollection>
            <clientsideevents endcallback="ctaxUpdatePanelEndCall" />
        </dxe:ASPxCallbackPanel>

        <%--<dxe:ASPxCallbackPanel runat="server" ID="panelVendor" ClientInstanceName="cpanelVendor" OnCallback="panelVendor_Callback" >
            <PanelCollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </PanelCollection>
            <ClientSideEvents EndCallback="EndCallBackpanelVendor" />
        </dxe:ASPxCallbackPanel>--%>
        <asp:HiddenField ID="HdChargeProdAmt" runat="server" />
        <asp:HiddenField ID="HdChargeProdNetAmt" runat="server" />
        <%--ChargesTax--%>
        <dxe:ASPxPopupControl ID="Popup_Taxes" runat="server" ClientInstanceName="cPopup_Taxes"
            Width="900px" Height="300px" HeaderText="Purchase Invoice Taxes" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <contentstyle verticalalign="Top" cssclass="pad">
            </contentstyle>
            <contentcollection>
                <dxe:PopupControlContentControl runat="server">
                    <div class="Top clearfix">
                        <div id="content-5" class="col-md-12  wrapHolder content horizontal-images" style="width: 100%; margin-right: 0;">
                            <ul>
                                <li>
                                    <div class="lblHolder">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>Gross Amount Total
                                                                <dxe:ASPxLabel ID="ASPxLabel7" runat="server" Text="ASPxLabel" ClientInstanceName="clblChargesTaxableGross"></dxe:ASPxLabel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dxe:ASPxLabel ID="txtProductAmount" runat="server" Text="ASPxLabel" ClientInstanceName="ctxtProductAmount">
                                                        </dxe:ASPxLabel>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                                <li class="lblChargesGSTforGross">
                                    <div class="lblHolder">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>GST</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dxe:ASPxLabel ID="lblChargesGSTforGross" runat="server" Text="ASPxLabel" ClientInstanceName="clblChargesGSTforGross">
                                                        </dxe:ASPxLabel>
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
                                                    <td>Total Discount</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dxe:ASPxLabel ID="txtProductDiscount" runat="server" Text="ASPxLabel" ClientInstanceName="ctxtProductDiscount">
                                                        </dxe:ASPxLabel>
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
                                                    <td>Total Charges</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dxe:ASPxLabel ID="txtProductTaxAmount" runat="server" Text="ASPxLabel" ClientInstanceName="ctxtProductTaxAmount"></dxe:ASPxLabel>
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
                                                    <td>Net Amount Total
                                                                <dxe:ASPxLabel ID="ASPxLabel8" runat="server" Text="ASPxLabel" ClientInstanceName="clblChargesTaxableNet"></dxe:ASPxLabel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dxe:ASPxLabel ID="txtProductNetAmount" runat="server" Text="ASPxLabel" ClientInstanceName="ctxtProductNetAmount"></dxe:ASPxLabel>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                                <li class="lblChargesGSTforNet">
                                    <div class="lblHolder">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>GST</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <dxe:ASPxLabel ID="lblChargesGSTforNet" runat="server" Text="ASPxLabel" ClientInstanceName="clblChargesGSTforNet">
                                                        </dxe:ASPxLabel>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="clear">
                        </div>
                        <%--Error Msg--%>

                        <div class="col-md-8" id="ErrorMsgCharges">
                            <div class="lblHolder">
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>Status
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Tax Code/Charges Not Defined.
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>

                        <div class="clear">
                        </div>
                        <div class="col-md-12 gridTaxClass" style="">
                            <dxe:ASPxGridView runat="server" KeyFieldName="TaxID" ClientInstanceName="gridTax" ID="gridTax"
                                Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false"
                                Settings-ShowFooter="false" OnCustomCallback="gridTax_CustomCallback" OnBatchUpdate="gridTax_BatchUpdate"
                                OnRowInserting="gridTax_RowInserting" OnRowUpdating="gridTax_RowUpdating" OnRowDeleting="gridTax_RowDeleting"
                                OnDataBinding="gridTax_DataBinding">
                                <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto"></Settings>
                                <SettingsPager Visible="false"></SettingsPager>
                                <Columns>
                                    <dxe:GridViewDataTextColumn FieldName="TaxName" Caption="Tax" VisibleIndex="0" Width="40%" ReadOnly="true">
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn FieldName="calCulatedOn" Caption="Calculated On" VisibleIndex="0" Width="20%" ReadOnly="true">
                                        <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                        </PropertiesTextEdit>
                                        <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                    </dxe:GridViewDataTextColumn>

                                    <dxe:GridViewDataTextColumn FieldName="Percentage" Caption="Percentage" VisibleIndex="1" Width="20%">
                                        <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                            <ClientSideEvents LostFocus="PercentageTextChange" />
                                            <ClientSideEvents />
                                        </PropertiesTextEdit>
                                        <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                    </dxe:GridViewDataTextColumn>
                                    <dxe:GridViewDataTextColumn FieldName="Amount" Caption="Amount" VisibleIndex="2" Width="20%">
                                        <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                            <ClientSideEvents LostFocus="QuotationTaxAmountTextChange" GotFocus="QuotationTaxAmountGotFocus" />
                                        </PropertiesTextEdit>
                                        <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                    </dxe:GridViewDataTextColumn>
                                </Columns>
                                <ClientSideEvents EndCallback="OnTaxEndCallback" />
                                <SettingsDataSecurity AllowEdit="true" />
                                <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                                    <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="row" />
                                </SettingsEditing>
                                <Styles>
                                <StatusBar CssClass="statusBar">
                                </StatusBar>
                            </Styles>
                            </dxe:ASPxGridView>
                        </div>
                        <div class="col-md-12">
                            <table style="" class="chargesDDownTaxClass">
                                <tr class="chargeGstCstvatClass">
                                    <td style="padding-top: 10px; padding-right: 25px"><span><strong>GST</strong></span></td>
                                    <td style="padding-top: 10px; width: 200px;">
                                        <dxe:ASPxComboBox ID="cmbGstCstVatcharge" ClientInstanceName="ccmbGstCstVatcharge" runat="server" SelectedIndex="0"
                                            ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" TextFormatString="{0}"
                                            OnCallback="cmbGstCstVatcharge_Callback">
                                            <Columns>
                                                <dxe:ListBoxColumn FieldName="Taxes_Name" Caption="Tax Component ID" Width="250" />
                                                <dxe:ListBoxColumn FieldName="TaxCodeName" Caption="Tax Component Name" Width="250" />

                                            </Columns>
                                            <ClientSideEvents SelectedIndexChanged="ChargecmbGstCstVatChange"
                                                GotFocus="chargeCmbtaxClick" />

                                        </dxe:ASPxComboBox>



                                    </td>
                                    <td style="padding-left: 15px; padding-top: 10px; width: 200px;">
                                        <dxe:ASPxTextBox ID="txtGstCstVatCharge" MaxLength="80" ClientInstanceName="ctxtGstCstVatCharge" ReadOnly="true" Text="0.00"
                                            runat="server" Width="100%">
                                            
                                            <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                            <%--<MaskSettings Mask="<-999999999..999999999>.<0..99>" AllowMouseWheel="false" />--%>
                                        </dxe:ASPxTextBox>

                                    </td>
                                    <td style="padding-left: 15px; padding-top: 10px">
                                        <input type="button" onclick="recalculateTaxCharge()" class="btn btn-info btn-small RecalculateCharge" value="Recalculate GST" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="clear">
                            <br />
                        </div>



                        <div class="col-sm-3">
                            <div>
                                <dxe:ASPxButton ID="btn_SaveTax" ClientInstanceName="cbtn_SaveTax" runat="server" AccessKey="X" AutoPostBack="False" Text="Save" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                    <ClientSideEvents Click="function(s, e) {Save_TaxClick();}" />
                                </dxe:ASPxButton>
                                <dxe:ASPxButton ID="ASPxButton4" ClientInstanceName="cbtn_tax_cancel" runat="server" AutoPostBack="False" Text="Cancel" CssClass="btn btn-danger" UseSubmitBehavior="False">
                                    <ClientSideEvents Click="function(s, e) {cPopup_Taxes.Hide();}" />
                                </dxe:ASPxButton>
                            </div>
                        </div>

                        <div class="col-sm-9">
                            <table class="pull-right">
                                <tr>
                                    <td style="padding-right: 30px"><strong>Total Charges</strong></td>
                                    <td>
                                        <div>
                                            <dxe:ASPxTextBox ID="txtQuoteTaxTotalAmt" runat="server" Width="100%" ClientInstanceName="ctxtQuoteTaxTotalAmt" Text="0.00" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">
                                                <MaskSettings  Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                <%-- <MaskSettings Mask="<0..999999999999g>.<0..99g>" />--%>
                                            </dxe:ASPxTextBox>
                                        </div>

                                    </td>
                                    <td style="padding-right: 30px; padding-left: 5px"><strong>Total Amount</strong></td>
                                    <td>
                                        <div>
                                            <dxe:ASPxTextBox ID="txtTotalAmount" runat="server" Width="100%" ClientInstanceName="ctxtTotalAmount" Text="0.00" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">
                                                <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                <%--<MaskSettings Mask="<0..999999999999g>.<0..99g>" />--%>
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </td>

                                </tr>
                            </table>
                        </div>
                        <div class="col-sm-2" style="padding-top: 8px;">
                            <span></span>
                        </div>
                        <div class="col-sm-4">
                        </div>
                        <div class="col-sm-2" style="padding-top: 8px;">
                            <span></span>
                        </div>
                        <div class="col-sm-4">
                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </contentcollection>
            <headerstyle backcolor="LightGray" forecolor="Black" />
        </dxe:ASPxPopupControl>
        <%--   Inline Tax End    --%>

        <%--   Warehouse     --%>
        <dxe:ASPxPopupControl ID="ASPxPopupControl3" runat="server" ClientInstanceName="cPopup_WarehousePC"
            Width="900px" HeaderText="Stock Details" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <contentstyle verticalalign="Top" cssclass="pad">
            </contentstyle>
            <contentcollection>
                <dxe:PopupControlContentControl runat="server">
                    <div class="Top clearfix">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="lblHolder">
                                    <table>
                                        <tr>
                                            <td>Selected Branch</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblbranchName" runat="server"></asp:Label></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="lblHolder">
                                    <table>
                                        <tr>
                                            <td>Selected Product</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblpro" runat="server"></asp:Label></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="lblHolder">
                                    <table>
                                        <tr>
                                            <td>Available Stock</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblAvailableStk" runat="server" Text="0.0"></asp:Label></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="lblHolder">
                                    <table>
                                        <tr>
                                            <td>Entered Stock</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblopeningstock" runat="server" Text="0.0000"></asp:Label></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>


                        <div class="clear">
                            <br />
                        </div>
                        <div class="clearfix">
                            <div class="row manAb">
                                <div class="blockone">
                                    <div class="col-md-3">
                                        <div>
                                            <span id="RequiredFieldValidatorCmbWarehousetxt">Warehouse</span>
                                        </div>
                                        <div class="Left_Content relative" style="">
                                            <%-- <dxe:ASPxTextBox ID="txtwarehousname" runat="server" Width="80%" ClientInstanceName="ctxtwarehousname" HorizontalAlign="Left" Font-Size="12px">
                                    </dxe:ASPxTextBox>--%>
                                            <dxe:ASPxComboBox ID="CmbWarehouse" EnableIncrementalFiltering="True" ClientInstanceName="cCmbWarehouse" SelectedIndex="0"
                                                TextField="WarehouseName" ValueField="WarehouseID" runat="server" Width="100%" OnCallback="CmbWarehouse_Callback">
                                                <ClientSideEvents ValueChanged="function(s,e){CmbWarehouse_ValueChange(s)}" EndCallback="function(s,e){endcallcmware(s)}"></ClientSideEvents>

                                            </dxe:ASPxComboBox>
                                            <span id="RequiredFieldValidatorCmbWarehouse" title="Mandatory" class="tp2 fa fa-exclamation-circle iconRed" style="display: none;"></span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div>
                                            <span id="RequiredFieldValidatorCmbWarehouseQuantity">Quantity</span>
                                        </div>
                                        <div class="Left_Content" style="">
                                            <dxe:ASPxTextBox ID="txtqnty" runat="server" Width="100%" ClientInstanceName="ctxtqnty" HorizontalAlign="Left" Font-Size="12px">
                                                <MaskSettings Mask="<0..999999999>.<0..9999>" IncludeLiterals="DecimalSymbol" />
                                                <ClientSideEvents TextChanged="function(s,e){changedqnty(s)}" LostFocus="function(s,e){Setenterfocuse(s)}" KeyPress="function(s, e) {Keypressevt();}" />
                                            </dxe:ASPxTextBox>
                                            <span id="RequiredFieldValidatortxtwareqntity" title="Mandatory" class="tp2 fa fa-exclamation-circle iconRed" style="display: none;"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="blocktwo">
                                    <div class="col-md-3">
                                        <div>
                                            <span id="RequiredFieldValidatortxtbatchtxt">Batch</span>
                                        </div>
                                        <div class="Left_Content relative" style="">
                                            <dxe:ASPxTextBox ID="txtbatch" runat="server" Width="100%" ClientInstanceName="ctxtbatch" HorizontalAlign="Left" Font-Size="12px" MaxLength="49">
                                                <ClientSideEvents TextChanged="function(s,e){chnagedbtach(s)}" KeyPress="function(s, e) {Keypressevt();}" />
                                            </dxe:ASPxTextBox>
                                            <span id="RequiredFieldValidatortxtbatch" title="Mandatory" class="tp2 fa fa-exclamation-circle iconRed" style="display: none;"></span>
                                        </div>
                                    </div>
                                    <div class="col-md-3 blocktwoqntity">
                                        <div>
                                            <span id="RequiredFieldValidatorbatchQuantity">Quantity</span>
                                        </div>
                                        <div class="Left_Content" style="">
                                            <dxe:ASPxTextBox ID="batchqnty" runat="server" Width="100%" ClientInstanceName="ctxtbatchqnty" HorizontalAlign="Left" Font-Size="12px">
                                                <MaskSettings Mask="<0..999999999>.<0..9999>" IncludeLiterals="DecimalSymbol" />
                                                <ClientSideEvents TextChanged="function(s,e){changedqntybatch(s)}" />
                                            </dxe:ASPxTextBox>
                                            <span id="RequiredFieldValidatortxtbatchqntity" title="Mandatory" class="tp2 fa fa-exclamation-circle iconRed" style="display: none;"></span>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div>
                                            <span id="RequiredFieldValidatortxtbatchtxtmkgdate">Manufacture Date</span>
                                        </div>
                                        <div class="Left_Content" style="">
                                            <%--<dxe:ASPxTextBox ID="txtmkgdate" runat="server" Width="80%" ClientInstanceName="ctxtmkgdate" HorizontalAlign="Left" Font-Size="12px">
                                    </dxe:ASPxTextBox>--%>
                                            <dxe:ASPxDateEdit ID="txtmkgdate" runat="server" Width="100%" EditFormat="custom" UseMaskBehavior="True" ClientInstanceName="ctxtmkgdate" AllowNull="true" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy">
                                                <ButtonStyle Width="13px">
                                                </ButtonStyle>

                                            </dxe:ASPxDateEdit>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div>
                                            <span id="RequiredFieldValidatortxtbatchtxtexpdate">Expiry Date</span>
                                        </div>
                                        <div class="Left_Content" style="">
                                            <%-- <dxe:ASPxTextBox ID="txtexpirdate" runat="server" Width="80%" ClientInstanceName="ctxtexpirdate" HorizontalAlign="Left" Font-Size="12px">
                                    </dxe:ASPxTextBox>--%>
                                            <dxe:ASPxDateEdit ID="txtexpirdate" runat="server" Width="100%" EditFormat="custom" UseMaskBehavior="True" ClientInstanceName="ctxtexpirdate" AllowNull="true" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy">
                                                <ButtonStyle Width="13px">
                                                </ButtonStyle>

                                            </dxe:ASPxDateEdit>
                                        </div>
                                    </div>
                                </div>
                                <div class="clear"></div>
                                <div class="blockthree">
                                    <div class="col-md-3">
                                        <div>
                                            <span id="RequiredFieldValidatortxtserialtxt">Serial No</span>
                                        </div>
                                        <div class="Left_Content relative" style="">
                                            <dxe:ASPxTextBox ID="ASPxTextBox1" runat="server" Width="100%" ClientInstanceName="ctxtserial" HorizontalAlign="Left" Font-Size="12px" MaxLength="49">
                                                <ClientSideEvents KeyPress="function(s, e) {Keypressevt();}" />
                                            </dxe:ASPxTextBox>
                                            <span id="RequiredFieldValidatortxtserial" title="Mandatory" class="tp2 fa fa-exclamation-circle iconRed" style="display: none;"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div>
                                    </div>
                                    <div class=" clearfix" style="padding-top: 11px;">
                                        <dxe:ASPxButton ID="ASPxButton5" ClientInstanceName="cbtnaddWarehouse" Width="50px" runat="server" AutoPostBack="False" Text="Add" CssClass="btn btn-primary pull-left" UseSubmitBehavior="False">
                                            <ClientSideEvents Click="function(s, e) {SaveWarehouse();}" />
                                        </dxe:ASPxButton>

                                        <dxe:ASPxButton ID="ASPxButton6" ClientInstanceName="cbtnrefreshWarehouse" Width="50px" runat="server" AutoPostBack="False" Text="Clear Entries" CssClass="btn btn-primary pull-left" UseSubmitBehavior="False">
                                            <ClientSideEvents Click="function(s, e) {Clraear();}" />
                                        </dxe:ASPxButton>

                                    </div>
                                </div>

                            </div>
                            <br />


                            <div class="clearfix">
                                <dxe:ASPxGridView ID="GrdWarehousePC" runat="server" KeyFieldName="SrlNo" AutoGenerateColumns="False" SettingsBehavior-AllowSort="false"
                                    Width="100%" ClientInstanceName="cGrdWarehousePC" OnCustomCallback="GrdWarehousePC_CustomCallback" OnDataBinding="GrdWarehousePC_DataBinding">
                                    <Columns>
                                        <dxe:GridViewDataTextColumn Caption="Warehouse Name" FieldName="viewWarehouseName"
                                            VisibleIndex="0">
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Batch Number" FieldName="viewBatchNo"
                                            VisibleIndex="2">
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataDateColumn Caption="Manufacture Date" FieldName="viewMFGDate"
                                            VisibleIndex="2">
                                            <Settings AllowHeaderFilter="False" />
                                            <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy"></PropertiesDateEdit>
                                        </dxe:GridViewDataDateColumn>

                                        <dxe:GridViewDataDateColumn Caption="Expiry Date" FieldName="viewExpiryDate"
                                            VisibleIndex="2">
                                            <Settings AllowHeaderFilter="False" />
                                            <PropertiesDateEdit DisplayFormatString="dd-MM-yyyy"></PropertiesDateEdit>
                                        </dxe:GridViewDataDateColumn>
                                        <dxe:GridViewDataTextColumn Caption="Quantity" FieldName="viewQuantity"
                                            VisibleIndex="3">
                                            <Settings ShowInFilterControl="False" />
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="Quantity" FieldName="Quantity"
                                            VisibleIndex="5">
                                            <Settings ShowInFilterControl="False" />
                                        </dxe:GridViewDataTextColumn>

                                        <dxe:GridViewDataTextColumn Caption="Serial Number" FieldName="viewSerialNo"
                                            VisibleIndex="4">
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="Action" FieldName="SrlNo" CellStyle-VerticalAlign="Middle" VisibleIndex="6" CellStyle-HorizontalAlign="Center" Settings-ShowFilterRowMenu="False" Settings-AllowHeaderFilter="False" Settings-AllowAutoFilter="False" Width="100px">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <a href="javascript:void(0);" onclick="UpdateWarehousebatchserial(<%#Eval("SrlNo")%>,'<%#Eval("WarehouseID")%>','<%#Eval("BatchNo")%>','<%#Eval("SerialNo")%>','<%#Eval("isnew")%>','<%#Eval("viewQuantity")%>','<%#Eval("Quantity")%>')" title="update Details" class="pad">
                                                    <img src="../../../assests/images/Edit.png" />
                                                </a>
                                                <a href="javascript:void(0);" onclick="DeleteWarehousebatchserial(<%#Eval("SrlNo")%>,'<%#Eval("BatchWarehouseID")%>','<%#Eval("viewQuantity")%>',<%#Eval("Quantity")%>,'<%#Eval("WarehouseID")%>','<%#Eval("BatchNo")%>')" title="delete Details" class="pad">
                                                    <img src="../../../assests/images/crs.png" />
                                                </a>
                                            </DataItemTemplate>

                                        </dxe:GridViewDataTextColumn>
                                    </Columns>
                                    <ClientSideEvents EndCallback="function(s,e) { cGrdWarehousePCShowError(s.cpInsertError);}" />
                                    <%-- <SettingsPager NumericButtonCount="20" PageSize="10" ShowSeparators="True">
                                    <FirstPageButton Visible="True">
                                    </FirstPageButton>
                                    <LastPageButton Visible="True">
                                    </LastPageButton>
                                </SettingsPager>--ShowFilterRow="true" ShowFilterRowMenu="true" --%>
                                    <SettingsPager Mode="ShowAllRecords" />
                                    <Settings ShowGroupPanel="false" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" VerticalScrollBarMode="Visible" VerticalScrollableHeight="190" />
                                    <SettingsLoadingPanel Text="Please Wait..." />
                                </dxe:ASPxGridView>
                            </div>
                            <br />
                            <div class="Center_Content" style="">
                                <dxe:ASPxButton ID="ASPxButton7" ClientInstanceName="cbtnWarehouse" Width="50px" runat="server" AutoPostBack="False" Text="S&#818;ave & Exit" AccessKey="S" CssClass="btn btn-primary" UseSubmitBehavior="False">
                                    <ClientSideEvents Click="function(s, e) {SaveWarehouseAll();}" />
                                </dxe:ASPxButton>


                            </div>
                        </div>
                        <%-- <div class="text-center">
                        <table class="pull-right">
                            <tr>
                                <td style="padding-right: 15px"><strong>Total</strong></td>
                                <td>
                                    <dxe:ASPxTextBox ID="ASPxTextBox3" runat="server" Width="100%" ClientInstanceName="ctxtTotalAmount" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">
                                    </dxe:ASPxTextBox>
                                </td>
                            </tr>
                        </table>
                    </div>--%>
                    </div>
                </dxe:PopupControlContentControl>
            </contentcollection>
            <headerstyle backcolor="LightGray" forecolor="Black" />
        </dxe:ASPxPopupControl>
        <div id="hdnFieldWareHouse">
            <asp:HiddenField ID="hdfProductIDPC" runat="server" />
            <asp:HiddenField ID="hdfstockidPC" runat="server" />
            <asp:HiddenField ID="hdfopeningstockPC" runat="server" />
            <asp:HiddenField ID="hdbranchIDPC" runat="server" />
            <asp:HiddenField ID="hdnselectedbranch" runat="server" Value="0" />

            <asp:HiddenField ID="hdnProductQuantity" runat="server" />

            <asp:HiddenField ID="hdniswarehouse" runat="server" />
            <asp:HiddenField ID="hdnisbatch" runat="server" />
            <asp:HiddenField ID="hdnisserial" runat="server" />
            <asp:HiddenField ID="hdndefaultID" runat="server" />

            <asp:HiddenField ID="hdnoldrowcount" runat="server" Value="0" />

            <asp:HiddenField ID="hdntotalqntyPC" runat="server" Value="0" />

            <%-- Sam New Modification For Qty Checking--%>
            <asp:HiddenField ID="wbsqtychecking" runat="server" Value="1" />
            <asp:HiddenField ID="producttype" runat="server" Value="" />
            <%--Sam New Modification For Qty Checking--%>
            <asp:HiddenField ID="hdnoldwarehousname" runat="server" />
            <asp:HiddenField ID="hdnoldbatchno" runat="server" />
            <asp:HiddenField ID="hidencountforserial" runat="server" />
            <asp:HiddenField ID="hdnbatchchanged" runat="server" Value="0" />

            <asp:HiddenField ID="hdnrate" runat="server" Value="0" />
            <asp:HiddenField ID="hdnvalue" runat="server" Value="0" />

            <asp:HiddenField ID="oldhdnoldwarehousname" runat="server" Value="0" />

            <asp:HiddenField ID="oldhidencountforserial" runat="server" Value="0" />
            <asp:HiddenField ID="oldhdnbatchchanged" runat="server" Value="0" />
            <asp:HiddenField ID="hdnstrUOM" runat="server" />
            <asp:HiddenField ID="hdnenterdopenqnty" runat="server" />
            <asp:HiddenField ID="hdnnewenterqntity" runat="server" />

            <asp:HiddenField ID="hdnisoldupdate" runat="server" />
            <asp:HiddenField ID="hdncurrentslno" runat="server" />
            <asp:HiddenField ID="oldopeningqntity" runat="server" Value="0" />
            <asp:HiddenField ID="hdnisedited" runat="server" />

            <asp:HiddenField ID="hdnisnewupdate" runat="server" />

            <asp:HiddenField ID="hdnisviewqntityhas" runat="server" />
            <asp:HiddenField ID="hdndeleteqnity" runat="server" Value="0" />
            <asp:HiddenField ID="hdnisolddeleted" runat="server" Value="false" />

            <asp:HiddenField ID="hdnisreduing" runat="server" Value="false" />
            <asp:HiddenField ID="hdnoutstock" runat="server" Value="0" />

            <asp:HiddenField ID="hdnpcslno" runat="server" Value="0" />
        </div>

        <%--   Warehouse End    --%>

        <%-- HiddenField --%>
        <div>
            <asp:HiddenField ID="hdfLookupCustomer" runat="server" />
            <asp:HiddenField ID="hdfIsDelete" runat="server" />
            <asp:HiddenField ID="hdfIsComp" runat="server" />
            <asp:HiddenField ID="hdnPageStatus" runat="server" />
            <asp:HiddenField ID="hdfProductID" runat="server" />
            <asp:HiddenField ID="hdfProductType" runat="server" />
            <asp:HiddenField ID="hdfProductSerialID" runat="server" />
            <asp:HiddenField ID="hdnRefreshType" runat="server" />
            <asp:HiddenField ID="hdnCustomerId" runat="server" />
            <%--added by sam to delete the noninventory item and its session detail from grid--%>

            <asp:HiddenField ID="hdinvetorttype" runat="server" />
            <%-- added by sam to delete the noninventory item and its session detail from grid--%>
        </div>
        <%-- HiddenField End--%>
        <%--UDF--%>
        <dxe:ASPxPopupControl ID="ASPXPopupControl" runat="server"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popup" Height="630px"
            Width="600px" HeaderText="Add/Modify UDF" Modal="true" AllowResize="true" ResizingMode="Postponed">
            <%-- <HeaderTemplate>
                <span>UDF</span>
                <dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png"  Cursor="pointer" cssClass="popUpHeader" >
                    <ClientSideEvents Click="function(s, e){ 
                        popup.Hide();
                    }" />
            </dxe:ASPxImage>
            </HeaderTemplate>--%>
            <contentcollection>
                <dxe:PopupControlContentControl runat="server">
                </dxe:PopupControlContentControl>
            </contentcollection>
        </dxe:ASPxPopupControl>
        <asp:HiddenField runat="server" ID="IsUdfpresent" />
        <asp:HiddenField runat="server" ID="Keyval_internalId" />
        <%--End UDF--%>
        <%--Batch Product Popup Start--%>

        <dxe:ASPxPopupControl ID="ProductpopUp" runat="server" ClientInstanceName="cProductpopUp"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Height="400"
            Width="700" HeaderText="Select Product" AllowResize="true" ResizingMode="Postponed" Modal="true">
            <contentcollection>
                <dxe:PopupControlContentControl runat="server">
                    <label><strong>Search By Product Name</strong></label>
                   <%--  DataSourceID="ProductDataSource"--%>
                    <dxe:ASPxCallbackPanel runat="server" ID="productPanel" ClientInstanceName="cproductPanel" OnCallback="productPanel_Callback" 
                        ClientSideEvents-EndCallback="cproductPanelEndCallBack">
                    <PanelCollection>

                        <dxe:PanelContent runat="server">

                    <dxe:ASPxGridLookup ID="productLookUp" runat="server" ClientInstanceName="cproductLookUp" OnDataBinding="productLookUp_DataBinding"
                        KeyFieldName="Products_ID" Width="800" TextFormatString="{0}" MultiTextSeparator=", " ClientSideEvents-TextChanged="ProductSelected" 
                        ClientSideEvents-KeyDown="ProductlookUpKeyDown">
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
                            </dxe:PanelContent>
                    </PanelCollection>
                </dxe:ASPxCallbackPanel>

                </dxe:PopupControlContentControl>
            </contentcollection>
            <headerstyle backcolor="Blue" font-bold="True" forecolor="White" />
        </dxe:ASPxPopupControl>

        <%--<asp:SqlDataSource runat="server" ID="ProductDataSource" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="prc_PurchaseInvoiceDetail" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Type="String" Name="Action" DefaultValue="ProductDetails" />
                <asp:SessionParameter Name="campany_Id" SessionField="LastCompany1" Type="String" />
                <asp:SessionParameter Type="String" Name="FinYear" SessionField="LastFinYear1" />
                <asp:ControlParameter Type="String" Name="IsInventory" ControlID="ctl00$ContentPlaceHolder1$ASPxPageControl1$ddlInventory" PropertyName="SelectedValue" />
                <asp:ControlParameter Type="String" Name="SchemeID" ControlID="ctl00$ContentPlaceHolder1$ASPxPageControl1$ddl_TdsScheme" PropertyName="Value" />

            </SelectParameters>
        </asp:SqlDataSource>--%>

        <asp:SqlDataSource runat="server" ID="CustomerDataSource" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="prc_PurchaseInvoiceDetail" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:Parameter Type="String" Name="Action" DefaultValue="PopulateVendorsDetailByInventoryItem" />
                <asp:ControlParameter Type="String" Name="InventoryType" ControlID="ctl00$ContentPlaceHolder1$ASPxPageControl1$ddlInventory" PropertyName="SelectedValue" />
                <asp:ControlParameter Type="String" Name="branchId" ControlID="ctl00$ContentPlaceHolder1$ASPxPageControl1$ddl_Branch" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>

        <%--Batch Product Popup End--%>
        <dxe:ASPxCallbackPanel runat="server" ID="acpAvailableStock" ClientInstanceName="cacpAvailableStock" OnCallback="acpAvailableStock_Callback">
            <panelcollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </panelcollection>
            <clientsideevents endcallback="acpAvailableStockEndCall" />
        </dxe:ASPxCallbackPanel>

        <%--Div Detail for Vendor Section Start--%>

        <dxe:ASPxCallbackPanel runat="server" ID="acpContactPersonPhone" ClientInstanceName="cacpContactPersonPhone" OnCallback="acpContactPersonPhone_Callback">
            <panelcollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </panelcollection>
            <clientsideevents endcallback="acpContactPersonPhoneEndCall" />
        </dxe:ASPxCallbackPanel>
        <%--Div Detail for Vendor Section Start--%>

        <%--Sandip Hidden Field Declaration Start--%>
        <asp:HiddenField runat="server" ID="hdngridvselectedrowno" />
        <%--Sandip Hidden Field Declaration End--%>

        <%--<asp:SqlDataSource ID="SqlSchematype" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select * From ((Select '0' as ID,'Select' as SchemaName) Union (Select ID,SchemaName From tbl_master_Idschema  Where TYPE_ID='17')) as X Order By ID ASC"></asp:SqlDataSource>--%>
        <asp:SqlDataSource ID="SqlSchematype" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select * From ((Select '0' as ID,' Select' as SchemaName) Union (Select  convert(nvarchar(10),ID)+'~'+convert(nvarchar(10),b.branch_id) as ID,SchemaName+'('+b.branch_description +')'as SchemaName  From tbl_master_Idschema  join tbl_master_branch b on tbl_master_Idschema.Branch=b.branch_id  Where TYPE_ID='19' 
                    and financial_year_id IN(select FinYear_ID from Master_FinYear where FinYear_Code=@year) 
                    and Isnull(Branch,'') in (select s FROM dbo.GetSplit(',',@userbranchHierarchy)) and comapanyInt=@company)) as X Order By SchemaName ASC">

            <%--and Branch=@userbranch and comapanyInt=@company)) as X Order By ID ASC">--%>
            <SelectParameters>
                <%-- <asp:sessionparameter name="userbranch" sessionfield="userbranch" type="string" />--%>
                <asp:SessionParameter Name="userbranchHierarchy" SessionField="userbranchHierarchy" Type="string" />
                <asp:SessionParameter Name="company" SessionField="LastCompany1" Type="string" />
                <asp:SessionParameter Name="year" SessionField="LastFinYear1" Type="string" />

            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlIndentRequisitionNo" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="(Select '0' as Indent_Id,'Select' as Indent_RequisitionNumber) Union
            (select Indent_Id,Indent_RequisitionNumber from tbl_trans_Indent)"></asp:SqlDataSource>
        <asp:SqlDataSource ID="Sqlvendor" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select '0' as cnt_internalId,'Select' as Name 
            union select cnt_internalId,isnull(cnt_firstName,'')+isnull(cnt_middleName,'')+isnull(cnt_lastName,'') Name 
            from tbl_master_contact  where cnt_contacttype='DV'"></asp:SqlDataSource>
        <%--<asp:SqlDataSource ID="SqlCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select Currency_ID,Currency_AlphaCode from Master_Currency Order By Currency_ID"></asp:SqlDataSource>--%>
        <%--<asp:SqlDataSource ID="DS_Branch" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select * From (select '0' as branch_id,'Select' as branch_description 
            union select branch_id,branch_description from tbl_master_branch)tbl "></asp:SqlDataSource>--%>
        <%--<asp:SqlDataSource ID="DS_SalesAgent" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select '0' as cnt_id,'Select' as Name
            union select cnt_id,isnull(cnt_firstName,'')+isnull(cnt_middleName,'')+isnull(cnt_lastName,'') Name from tbl_master_contact  where Substring(cnt_internalId,1,2)='AG'"></asp:SqlDataSource>--%>
        <%--<asp:SqlDataSource ID="DS_AmountAre" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select '0'as taxGrp_Id,'Select'as taxGrp_Description
            union select taxGrp_Id,taxGrp_Description from tbl_master_taxgrouptype order by taxGrp_Id"></asp:SqlDataSource>--%>


        <asp:SqlDataSource ID="CountrySelect" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="SELECT cou_id, cou_country as Country FROM tbl_master_country order by cou_country"></asp:SqlDataSource>
        <asp:SqlDataSource ID="StateSelect" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="SELECT s.id as ID,s.state+' (State Code:' +s.StateCode+')' as State from tbl_master_state s where (s.countryId = @State) ORDER BY s.state">
            <SelectParameters>
                <asp:Parameter Name="State" Type="string" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SelectCity" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="SELECT c.city_id AS CityId, c.city_name AS City FROM tbl_master_city c where c.state_id=@City order by c.city_name">
            <SelectParameters>
                <asp:Parameter Name="City" Type="string" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SelectArea" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="SELECT area_id, area_name from tbl_master_area where (city_id = @Area) ORDER BY area_name">
            <SelectParameters>
                <asp:Parameter Name="Area" Type="string" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SelectPin" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select pin_id,pin_code from tbl_master_pinzip where city_id=@City order by pin_code">
            <SelectParameters>
                <asp:Parameter Name="City" Type="string" />
            </SelectParameters>
        </asp:SqlDataSource>
        <dxe:ASPxCallbackPanel runat="server" ID="acbpCrpUdf" ClientInstanceName="cacbpCrpUdf" OnCallback="acbpCrpUdf_Callback">
            <panelcollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </panelcollection>
            <clientsideevents endcallback="acbpCrpUdfEndCall" />
        </dxe:ASPxCallbackPanel>

        <%--Inventory Section By Sam Start on 15052017--%>

        <dxe:ASPxPopupControl ID="inventorypopup" runat="server" ClientInstanceName="cinventorypopup"
            Width="1080px" HeaderText="Select TDS" PopupHorizontalAlign="WindowCenter" ShowCloseButton="false"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <%-- <HeaderTemplate>--%>
            <%-- <span style="color: #fff"><strong>Select Tax</strong></span>--%>
            <%--<dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                        <ClientSideEvents Click="function(s, e){ 
                                                            
                                                            cinventorypopup.Hide();
                                                        }" />
                    </dxe:ASPxImage>--%>
            <%--</HeaderTemplate>--%>
            <contentcollection>
                <dxe:PopupControlContentControl runat="server">
                    <%--<asp:HiddenField runat="server" ID="HiddenField1" />
                        <asp:HiddenField runat="server" ID="HiddenField2" />
                        <asp:HiddenField runat="server" ID="HiddenField3" />
                        <asp:HiddenField runat="server" ID="HiddenField4" />
                        <asp:HiddenField ID="HiddenField5" runat="server" />--%>
                    <%-- Added by Sam to show default cursor after save--%>

                    <%-- Added by Sam to show default cursor after save--%>


                    <%--Error Message--%>





                    <div class="row">
                        <div class="col-md-4">
                            <label><span><strong>Select Branch</strong></span></label>
                            <%--<dxe:ASPxComboBox ID="ddl_noninventoryBranch" ClientInstanceName="cddl_noninventoryBranch" runat="server" SelectedIndex="-1"
                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" TextFormatString="{0}"
                                ClearButton-DisplayMode="Always" OnCallback="ddl_noninventoryBranch_Callback">
                            </dxe:ASPxComboBox>--%>
                            <div>
                            <asp:Label ID="lbltdsBranch" runat="server" ></asp:Label>
                            </div>

                        </div>
                        <div class="col-md-4">
                            <label><span><strong>Select Month for TDS</strong></span></label>
                            <dxe:ASPxComboBox ID="ddl_month" ClientInstanceName="cddl_month" runat="server" SelectedIndex="-1"
                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" TextFormatString="{0}"
                                ClearButton-DisplayMode="Always">
                                <Items>
                                    <dxe:ListEditItem Text="April" Value="April" />
                                    <dxe:ListEditItem Text="May" Value="May" />
                                    <dxe:ListEditItem Text="June" Value="June" />
                                    <dxe:ListEditItem Text="July" Value="July" />
                                    <dxe:ListEditItem Text="August" Value="August" />
                                    <dxe:ListEditItem Text="September" Value="September" />
                                    <dxe:ListEditItem Text="October" Value="October" />
                                    <dxe:ListEditItem Text="November" Value="November" />
                                    <dxe:ListEditItem Text="December" Value="December" />
                                    <dxe:ListEditItem Text="January" Value="January" />
                                    <dxe:ListEditItem Text="February" Value="February" />
                                    <dxe:ListEditItem Text="March" Value="March" />
                                </Items>
                            </dxe:ASPxComboBox>
                        </div>

                        <div class="col-md-4 ">
                            <label><span><strong>Product Basic Amount</strong></span></label>
                            <div style="padding-bottom: 5px">
                                <dxe:ASPxTextBox ID="txt_proamt" MaxLength="80" ClientInstanceName="ctxt_proamt" ReadOnly="true" DisplayFormatString="0.00"
                                    runat="server" Width="50%">
                                     <%--<MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />--%>
                                    <%--<MaskSettings Mask="<0..999999999>.<0..99>" AllowMouseWheel="false" />--%>
                                </dxe:ASPxTextBox>
                            </div>
                        </div>
                    </div>
                    <table style="width: 100%;">



                        <tr>
                        </tr>

                        <%--<tr class="cgridTaxClass">--%>
                        <tr>

                            <td colspan="4">

                                <dxe:ASPxGridView runat="server" KeyFieldName="TDSID" ClientInstanceName="cgridinventory" ID="gridinventory"
                                    Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" SettingsPager-Mode="ShowAllRecords"
                                    OnCustomCallback="gridinventory_CustomCallback"
                                    Settings-ShowFooter="false" AutoGenerateColumns="False">
                                    <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto"></Settings>
                                    <SettingsBehavior AllowDragDrop="False" AllowSort="False"></SettingsBehavior>
                                    <SettingsPager Visible="false"></SettingsPager>
                                    <Columns>
                                        <%--<dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="TDSTCSRates_Code" ReadOnly="true" Caption="TDS CODE">
                                            </dxe:GridViewDataTextColumn>--%>

                                        <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="TDSRate" ReadOnly="true" Caption="TDS Rate(%)" Width="8%">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="TDS amount" FieldName="TDSAmount" VisibleIndex="3" Width="8%">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>


                                        <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="SurchargeRate" ReadOnly="true" Caption="Surcharge Rate(%)" Width="11%">
                                        <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                             </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="Surcharge amount" FieldName="SurchargeAmount" VisibleIndex="5" Width="11%">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>


                                        <dxe:GridViewDataTextColumn VisibleIndex="6" FieldName="EducationCessRate" ReadOnly="true" Caption="Education Cess Rate(%)" Width="14%">
                                         <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="Education Cess Amount" FieldName="EducationCessAmt" VisibleIndex="7" Width="14%">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>


                                        <dxe:GridViewDataTextColumn VisibleIndex="8" FieldName="HgrEducationCessRate" ReadOnly="true" Caption="Higher Education Cess Rate(%)" Width="17%">
                                         <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="Higher Education Cess Amount" FieldName="HgrEducationCessAmt" VisibleIndex="9" Width="17%">
                                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                <%--<ClientSideEvents LostFocus="txtPercentageLostFocus" GotFocus="CmbtaxClick" />--%>
                                                 <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />
                                            </PropertiesTextEdit>
                                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                        </dxe:GridViewDataTextColumn>




                                    </Columns>
                                    <ClientSideEvents EndCallback="OnInventoryEndCallback" />
                                    <%--  <SettingsPager Mode="ShowAllRecords"></SettingsPager>--%>
                                    <%-- <SettingsDataSecurity AllowEdit="true" />--%>
                                    <%--<SettingsEditing Mode="Batch">
                                            <BatchEditSettings EditMode="row" />
                                        </SettingsEditing>--%>
                                </dxe:ASPxGridView>

                            </td>
                        </tr>

                        <tr>
                            <td colspan="4">
                                <div class="pull-left">

                                    <dxe:ASPxButton ID="btn_noninventoryOk" ClientInstanceName="cbtn_noninventoryOk" runat="server" AutoPostBack="False" Text="OK" CssClass="btn btn-primary mTop" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                        <ClientSideEvents Click="function(s, e) {return NonInventoryBatchUpdate();}" />
                                    </dxe:ASPxButton>

                                </div>
                                <table class="pull-right">
                                    <tr>
                                        <td style="padding-top: 10px; padding-right: 5px"><strong>Total TDS</strong></td>
                                        <td>
                                            <dxe:ASPxTextBox ID="txt_totalnoninventoryproductamt" MaxLength="80" ClientInstanceName="ctxt_totalnoninventoryproductamt" DisplayFormatString="0.00"
                                                  ReadOnly="true"
                                                runat="server" Width="100%" CssClass="pull-left mTop">
                                               <%-- <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..00&gt;" AllowMouseWheel="false" />--%>
                                                <%--<MaskSettings Mask="<-999999999..999999999>.<0..00>" AllowMouseWheel="false" />--%>
                                                <%--<MaskSettings Mask="<0..999999999>.<0..99>" AllowMouseWheel="false" /> --%>
                                            </dxe:ASPxTextBox>

                                        </td>
                                    </tr>
                                </table>


                                <div class="clear"></div>
                            </td>
                        </tr>




                    </table>
                </dxe:PopupControlContentControl>
            </contentcollection>
            <contentstyle verticalalign="Top" cssclass="pad"></contentstyle>
            <headerstyle backcolor="LightGray" forecolor="Black" />
        </dxe:ASPxPopupControl>
        <asp:HiddenField ID="hdntdschecking" runat="server" />
        <%--Inventory Section By Sam End on 15052017 --%>

        <dxe:ASPxCallbackPanel runat="server" ID="ApplicableAmtPopup" ClientInstanceName="CApplicableAmtPopup" OnCallback="ApplicableAmtPopup_Callback">
            <panelcollection>
                <dxe:PanelContent runat="server">
                </dxe:PanelContent>
            </panelcollection>
            <clientsideevents endcallback="panelEndCallBack" />
        </dxe:ASPxCallbackPanel>
    </div>

    <%-- new Modified Hidden Tax Field--%>
    <asp:HiddenField runat="server" ID="HDItemLevelTaxDetails" />
    <asp:HiddenField runat="server" ID="HDHSNCodewisetaxSchemid" />
    <asp:HiddenField runat="server" ID="HDBranchWiseStateTax" />
    <asp:HiddenField runat="server" ID="HDStateCodeWiseStateIDTax" />
    <%--  new Modified Hidden Tax Field--%>

     <asp:HiddenField ID="hdnManual" runat="server" Value="" />
     <asp:HiddenField ID="hdnAuto" runat="server" Value="" />
    <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
        <clientsideevents controlsinitialized="AllControlInitilize" />
    </dxe:ASPxGlobalEvents>

    <dxe:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" ContainerElementID="divSubmitButton"
        Modal="True">
    </dxe:ASPxLoadingPanel>
</asp:Content>