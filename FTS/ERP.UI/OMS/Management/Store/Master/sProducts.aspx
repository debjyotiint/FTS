<%@ Page Title="Products" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master"
    Inherits="ERP.OMS.Management.Store.Master.management_master_Store_sProducts" CodeBehind="sProducts.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <script type="text/javascript" src="../../../CentralData/JSScript/GenericJScript.js"></script>
    <script src="../../Activities/JS/SearchPopup.js"></script>
    <link href="../../Activities/CSS/SearchPopup.css" rel="stylesheet" />
    

    <script type="text/javascript">

        function PopupproductHide()
        {
            jAlert('Import Successfully.Follwing lists showing status');
        }
        //$(document).ready(function () {
        //    $('#MainAccountModelSI').on('shown.bs.modal', function () {
        //        clearPopup();
        //        $('#txtMainAccountSearch').focus();
        //    })
        //})

        //function is called on changing country
        //        function OnCountryChanged(cmbCountry) 
        //        {
        //            grid.GetEditor("cou_country").PerformCallback(cmbCountry.GetValue().toString());
        //        }

        function ShowHideFilter(obj) {
            grid.PerformCallback(obj);
        }

    </script>


    <style>
        .normaltble {
            border:1px solid #ccc;
            margin-top:10px;
        }
        .normaltble>tbody>tr>th {
            padding:5px 5px;
            background:#54749D ;
            color:#fff;
        }
        .normaltble>tbody>tr>td {
            padding:3px 5px;
        }
        .myImage {
            max-height: 100px;
            max-width: 100px;
        }

        .boxarea {
            border: 1px solid #a7a6a64a;
            position: relative;
            margin: 15px;
            padding-top: 8px;
            padding-bottom: 7px;
        }

        .boxareaH {
            position: absolute;
            font-size: 14px;
            font-weight: bold;
            top: -13px;
            left: 9px;
            /* border: 1px solid #ccc; */
            background: #edf3f4;
            padding: 3px 5px;
            color: #b11212;
        }
    </style>

    <script type="text/javascript">

        //document.onkeydown = function (e) { 
        //  //  console.log(e);
        //    if (e.ctrlKey && (e.key == 's' || e.key == 'S'))
        //    {
        //        console.log('save not');
        //        if (cPopup_Empcitys.IsVisible()) {
        //            console.log('save');
        //            cbtnSave_citys.DoClick();
        //        }
        //        return false;
        //    }

        //    if (e.ctrlKey && (e.key == 'a' || e.key == 'A')) { 
        //        if (!cPopup_Empcitys.IsVisible()) {
        //            console.log('new');
        //            fn_PopOpen();
        //            return false;
        //        }

        //    }

        //    //if (event.keyCode == 17) isCtrl = true;
        //    //if (event.keyCode == 83 && isCtrl == true) { 
        //    //    console.log(e);
        //    //    return false;

        //    //} 

        //}






        //Added for lite popup


        //*************************************************  SI Main Account  *********************************************************************************

        function MainAccountButnClick() {
            var txt = "<table border='1' width=\"100%\"><tr class=\"HeaderStyle\"><th>Main Account Name</th></tr><table>";
            $("#txtMainAccountSearch").val("");
            document.getElementById("MainAccountTable").innerHTML = txt;
            cMainAccountModelSI.Show();
        }

        function MainAccountNewkeydown(e) {
            var OtherDetails = {}
            OtherDetails.SearchKey = $("#txtMainAccountSearch").val();
            if (e.code == "Enter" || e.code == "NumpadEnter") {
                if ($("#txtMainAccountSearch").val() == "")
                    return;
                var HeaderCaption = [];
                HeaderCaption.push("Main Account Name");
                callonServer("../Master/sProducts.aspx/GetMainAccount", OtherDetails, "MainAccountTable", HeaderCaption, "MainAccountSIIndex", "SetMainAccountSI");
            }
            else if (e.code == "ArrowDown") {
                if ($("input[MainAccountSIIndex=0]"))
                    $("input[MainAccountSIIndex=0]").focus();
            }
            else if (e.code == "Escape") {
                cMainAccountModelSI.Hide();
                cMainAccountModelSI.Focus();
            }
        }

        function SetMainAccountSI(Id, name, e) {
            $("#hdnSIMainAccount").val(Id);
            cSIMainAccount.SetText(name);
            cMainAccountModelSI.Hide();
        }

        //************************************************* End SI Main Account  *********************************************************************************



        //*************************************************  SR Main Account  *********************************************************************************

        function SRMainAccountButnClick() {
            var txt = "<table border='1' width=\"100%\"><tr class=\"HeaderStyle\"><th>Main Account Name</th></tr><table>";
            document.getElementById("MainAccountTableSR").innerHTML = txt;
            $("#txtMainAccountSRSearch").val("");
            cMainAccountModelSR.Show();
        }

        function MainAccountSRNewkeydown(e) {
            var OtherDetails = {}
            OtherDetails.SearchKey = $("#txtMainAccountSRSearch").val();
            if (e.code == "Enter" || e.code == "NumpadEnter") {
                if ($("#txtMainAccountSRSearch").val() == "")
                    return;
                var HeaderCaption = [];
                HeaderCaption.push("Main Account Name");
                callonServer("../Master/sProducts.aspx/GetMainAccount", OtherDetails, "MainAccountTableSR", HeaderCaption, "MainAccountSRIndex", "SetMainAccountSR");
            }
            else if (e.code == "ArrowDown") {
                if ($("input[MainAccountSRIndex=0]"))
                    $("input[MainAccountSRIndex=0]").focus();
            }
            else if (e.code == "Escape") {
                cMainAccountModelSR.Hide();
            }
        }
        function SetMainAccountSR(Id, name, e) {
            $("#hdnSRMainAccount").val(Id);
            cSRMainAccount.SetText(name);
            cMainAccountModelSR.Hide();
        }

        //************************************************* End SR Main Account  *********************************************************************************


        //*************************************************  PI Main Account  *********************************************************************************

        function PIMainAccountButnClick() {
            var txt = "<table border='1' width=\"100%\"><tr class=\"HeaderStyle\"><th>Main Account Name</th></tr><table>";
            document.getElementById("MainAccountTablePI").innerHTML = txt;
            $("#txtMainAccountPISearch").val("");
            cMainAccountModelPI.Show();
        }

        function MainAccountPINewkeydown(e) {
            var OtherDetails = {}
            OtherDetails.SearchKey = $("#txtMainAccountPISearch").val();
            if (e.code == "Enter" || e.code == "NumpadEnter") {
                if ($("#txtMainAccountPISearch").val() == "")
                    return;
                var HeaderCaption = [];
                HeaderCaption.push("Main Account Name");
                callonServer("../Master/sProducts.aspx/GetMainAccount", OtherDetails, "MainAccountTablePI", HeaderCaption, "MainAccountPIIndex", "SetMainAccountPI");
            }
            else if (e.code == "ArrowDown") {
                if ($("input[MainAccountPIIndex=0]"))
                    $("input[MainAccountPIIndex=0]").focus();
            }
            else if (e.code == "Escape") {
                cMainAccountModelPI.Hide();
            }
        }
        function SetMainAccountPI(Id, name, e) {
            $("#hdnPIMainAccount").val(Id);
            cPIMainAccount.SetText(name);
            cMainAccountModelPI.Hide();
        }

        //************************************************* End PI Main Account  *********************************************************************************



        //*************************************************  PR Main Account  *********************************************************************************

        function PRMainAccountButnClick() {
            var txt = "<table border='1' width=\"100%\"><tr class=\"HeaderStyle\"><th>Main Account Name</th></tr><table>";
            document.getElementById("MainAccountTablePR").innerHTML = txt;
            $("#txtMainAccountPRSearch").val("");
            cMainAccountModelPR.Show();
        }

        function MainAccountPRNewkeydown(e) {
            var OtherDetails = {}
            OtherDetails.SearchKey = $("#txtMainAccountPRSearch").val();
            if (e.code == "Enter" || e.code == "NumpadEnter") {
                if ($("#txtMainAccountPRSearch").val() == "")
                    return;
                var HeaderCaption = [];
                HeaderCaption.push("Main Account Name");
                callonServer("../Master/sProducts.aspx/GetMainAccount", OtherDetails, "MainAccountTablePR", HeaderCaption, "MainAccountPRIndex", "SetMainAccountPR");
            }
            else if (e.code == "ArrowDown") {
                if ($("input[MainAccountPRIndex=0]"))
                    $("input[MainAccountPRIndex=0]").focus();
            }
            else if (e.code == "Escape") {
                cMainAccountModelPR.Hide();
            }
        }
        function SetMainAccountPR(Id, name, e) {
            $("#hdnPRMainAccount").val(Id);
            cPRMainAccount.SetText(name);
            cMainAccountModelPR.Hide();
        }

        //************************************************* End PR Main Account  *********************************************************************************

        function MainAccountKeyDown(s, e) {
            if (e.htmlEvent.key == "Enter" || e.htmlEvent.key == "NumEnter") {
                s.OnButtonClick(0);
            }
        }

        function ValueSelected(e, indexName) {
            if (indexName == "MainAccountSIIndex") {
                if (e.code == "Enter" || e.code == "NumpadEnter") {
                    var Code = e.target.parentElement.parentElement.cells[0].innerText;
                    var name = e.target.parentElement.parentElement.cells[1].children[0].value;

                    $("#hdnSIMainAccount").val(Code);
                    cSIMainAccount.SetText(name);
                    cMainAccountModelSI.Hide();
                } else if (e.code == "ArrowDown") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex++;
                    if (thisindex < 10)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                }

                else if (e.code == "ArrowUp") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex--;
                    if (thisindex > -1)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                    else {
                        $('#txtMainAccountSearch').focus();
                    }
                }

            }

            else if (indexName == "MainAccountSRIndex") {
                if (e.code == "Enter" || e.code == "NumpadEnter") {
                    var Code = e.target.parentElement.parentElement.cells[0].innerText;
                    var name = e.target.parentElement.parentElement.cells[1].children[0].value;

                    $("#hdnSRMainAccount").val(Code);
                    cSRMainAccount.SetText(name);
                    cMainAccountModelSR.Hide();
                } else if (e.code == "ArrowDown") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex++;
                    if (thisindex < 10)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                }

                else if (e.code == "ArrowUp") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex--;
                    if (thisindex > -1)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                    else {
                        $('#txtMainAccountSRSearch').focus();
                    }
                }

            }
            else if (indexName == "MainAccountPIIndex") {
                if (e.code == "Enter" || e.code == "NumpadEnter") {
                    var Code = e.target.parentElement.parentElement.cells[0].innerText;
                    var name = e.target.parentElement.parentElement.cells[1].children[0].value;

                    $("#hdnPIMainAccount").val(Code);
                    cPIMainAccount.SetText(name);
                    cMainAccountModelPI.Hide();
                } else if (e.code == "ArrowDown") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex++;
                    if (thisindex < 10)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                }

                else if (e.code == "ArrowUp") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex--;
                    if (thisindex > -1)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                    else {
                        $('#txtMainAccountPISearch').focus();
                    }
                }

            }
            else if (indexName == "MainAccountPRIndex") {
                if (e.code == "Enter" || e.code == "NumpadEnter") {
                    var Code = e.target.parentElement.parentElement.cells[0].innerText;
                    var name = e.target.parentElement.parentElement.cells[1].children[0].value;

                    $("#hdnPRMainAccount").val(Code);
                    cPRMainAccount.SetText(name);
                    cMainAccountModelPR.Hide();
                } else if (e.code == "ArrowDown") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex++;
                    if (thisindex < 10)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                }

                else if (e.code == "ArrowUp") {
                    thisindex = parseFloat(e.target.getAttribute(indexName));
                    thisindex--;
                    if (thisindex > -1)
                        $("input[" + indexName + "=" + thisindex + "]").focus();
                    else {
                        $('#txtMainAccountPRSearch').focus();
                    }
                }

            }
        }




        //End lite Pop up

        var PurReturnOldValue = '';
        function cmbPurReturnGotFocus(s, e) {
            PurReturnOldValue = s.GetValue();
        }

        function mainAccountPurReturn(s, e) {
            for (var i = 0; i < mainAccountInUse.length; i++) {
                if (mainAccountInUse[i] == 'purchaseReturn') {

                    jAlert("Transaction exists for the selected Ledger. Cannot proceed.");
                    s.SetValue(PurReturnOldValue);
                }
            }
        }


        var PurInvoiceOldValue = '';
        function cmbPurInvoiceGotFocus(s, e) {
            PurInvoiceOldValue = s.GetValue();
        }

        function mainAccountPurInvoice(s, e) {

            for (var i = 0; i < mainAccountInUse.length; i++) {

                if (mainAccountInUse[i] == 'purchaseInvoice') {
                    jAlert("Transaction exists for the selected Ledger. Cannot proceed.");
                    s.SetValue(PurInvoiceOldValue);
                }

            }

        }

        var salesReturnOldValue = '';
        function cmbsalesReturnGotFocus(s, e) {
            salesReturnOldValue = s.GetValue();
        }

        function mainAccountSalesReturn(s, e) {
            for (var i = 0; i < mainAccountInUse.length; i++) {
                if (mainAccountInUse[i] == 'salesReturn') {
                    jAlert("Transaction exists for the selected Ledger. Cannot proceed.");
                    s.SetValue(salesReturnOldValue);
                }
            }
        }


        var salesInvoiceOldValue = '';
        function cmbsalesInvoiceGotFocus(s, e) {
            salesInvoiceOldValue = s.GetValue();
        }

        function mainAccountSalesInvoice(s, e) {
            for (var i = 0; i < mainAccountInUse.length; i++) {
                if (mainAccountInUse[i] == 'SalesInvoice') {

                    jAlert("Transaction exists for the selected Ledger. Cannot proceed.");
                    s.SetValue(salesInvoiceOldValue);
                }
            }
        }


        $(function () {
            var vAnotherKeyWasPressed = false;
            var ALT_CODE = 18;

            //When some key is pressed
            $(window).keydown(function (event) {
                var vKey = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
                vAnotherKeyWasPressed = vKey != ALT_CODE;
                if (!LoadingPanel.IsVisible()) {
                    if (event.altKey && (event.key == 's' || event.key == 'S')) {
                        console.log('save not');
                        if (cPopup_Empcitys.IsVisible()) {
                            if (cbtnSave_citys.IsVisible())
                                cbtnSave_citys.DoClick();
                        }
                        return false;
                    }

                    if (event.altKey && (event.key == 'a' || event.key == 'A')) {
                        if (!cPopup_Empcitys.IsVisible()) {
                            if (document.getElementById('AddBtn') != null) {
                                console.log('new');
                                fn_PopOpen();
                                return false;
                            }

                        }

                    }

                    if (event.altKey && (event.key == 'c' || event.key == 'C')) {
                        console.log('save not');
                        if (cPopup_Empcitys.IsVisible()) {
                            fn_btnCancel();
                        }
                        return false;
                    }
                }
            });

            //When some key is left
            $(window).keyup(function (event) {

                var vKey = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;

            });
        });



        function SetHSnPanelEndCallBack() {
            LoadingPanel.Hide();
            if (cSetHSnPanel.cpHsnCode) {
                if (cSetHSnPanel.cpHsnCode != "") {
                    //cHsnLookUp.gridView.SelectItemsByKey(cSetHSnPanel.cpHsnCode);
                    cSetHSnPanel.cpHsnCode = null;
                } else {
                    cHsnLookUp.Clear();
                }
            }
        }
        function CmbProClassCodeChanged(s, e) {
            if (s.GetValue() != null) {
                cSetHSnPanel.PerformCallback(s.GetValue());
                LoadingPanel.SetText('Please wait searching HSN...');
                LoadingPanel.Show();
            }

        }
        function cCmbTradingLotUnitsLostFocus() {
            var saleUomVal = cCmbTradingLotUnits.GetValue();
            if (saleUomVal == null) {
                $('#btnPackingConfig').attr('disabled', 'disabled');
            }
            else {
                $('#btnPackingConfig').attr('disabled', false);
            }
        }

        function ShowTdsSection() {
            ctdsPopup.Show();
        }

        function ShowPackingDetails() {
            $('#invalidPackingUom').css({ 'display': 'none' });
            ctxtpackingSaleUom.SetText(cCmbTradingLotUnits.GetText());
            ctxtpackingSaleUom.SetEnabled(false);
            cpackingDetails.Show();
        }

        function PackingDetailsOkClick() {

            $('#invalidPackingUom').css({ 'display': 'none' });

            if (ccmbPackingUom.GetValue() == null) {
                $('#invalidPackingUom').css({ 'display': 'block' });
            } else {
                cpackingDetails.Hide();
            }
        }

        function ServicetaxOkClick() {
            cServiceTaxPopup.Hide();
        }
        function isInventoryChanged(s, e) {
            //changeControlStateWithInventory(s.GetValue());
            changeControlStateWithInventory();
        }
        function isCapitalChanged(s, e) {

            var Inv = ccmbIsInventory.GetValue();
            var cap = ccmbIsCapitalGoods.GetValue();
            if (Inv != 1) {
                if (cap == 1) {
                    cCmbProType.SetEnabled(true);
                    cCmbStockValuation.SetEnabled(true);
                    //HsnChange
                    //   caspxHsnCode.SetEnabled(true);
                    // cHsnLookUp.SetEnabled(true);
                    ctxtQuoteLot.SetEnabled(true);
                    cCmbQuoteLotUnit.SetEnabled(true);
                    ctxtTradingLot.SetEnabled(true);
                    cCmbTradingLotUnits.SetEnabled(true);
                    ctxtDeliveryLot.SetEnabled(true);
                    cCmbDeliveryLotUnit.SetEnabled(true);
                    ccmbStockUom.SetEnabled(true);
                    ctxtMinLvl.SetEnabled(true);
                    ctxtReorderLvl.SetEnabled(true);
                    ccmbNegativeStk.SetEnabled(true);


                    $('#btnBarCodeConfig').attr('disabled', false);
                    $('#btnProdConfig').attr('disabled', false);

                    $('#btnServiceTaxConfig').attr('disabled', 'disabled');
                    cAspxServiceTax.SetValue('');

                    $('#btnTDS').attr('disabled', 'disabled');
                    cmb_tdstcs.SetValue('');
                }
                else {
                    cCmbProType.SetText('');
                    cCmbProType.SetEnabled(false);

                    cCmbStockValuation.SetValue('A');
                    cCmbStockValuation.SetEnabled(false);

                    //caspxHsnCode.SetText('');
                    //caspxHsnCode.SetEnabled(false);
                    // cHsnLookUp.SetEnabled(false);
                    // cHsnLookUp.Clear();

                    ctxtQuoteLot.SetText('0');
                    ctxtQuoteLot.SetEnabled(false);

                    cCmbQuoteLotUnit.SetText('0');
                    cCmbQuoteLotUnit.SetEnabled(false);

                    ctxtTradingLot.SetText('0');
                    ctxtTradingLot.SetEnabled(false);

                    cCmbTradingLotUnits.SetText('');
                    cCmbTradingLotUnits.SetEnabled(false);

                    ctxtDeliveryLot.SetText('0');
                    ctxtDeliveryLot.SetEnabled(false);

                    cCmbDeliveryLotUnit.SetText('');
                    cCmbDeliveryLotUnit.SetEnabled(false);


                    ccmbStockUom.SetText('');
                    ccmbStockUom.SetEnabled(false);

                    ctxtMinLvl.SetText('0');
                    ctxtMinLvl.SetEnabled(false);

                    ctxtReorderLvl.SetText('0');
                    ctxtReorderLvl.SetEnabled(false);

                    ccmbNegativeStk.SetValue('I');
                    ccmbNegativeStk.SetEnabled(false);

                    //Product Configuration
                    $('#btnProdConfig').attr('disabled', 'disabled');
                    $('#btnBarCodeConfig').attr('disabled', 'disabled');
                    $('#btnServiceTaxConfig').attr('disabled', false);
                    $('#btnTDS').attr('disabled', false);
                    $('#btnPackingConfig').attr('disabled', 'disabled');
                }
            }
        }


        function changeControlStateWithInventory(obj) {
            obj = ccmbIsInventory.GetValue();
            if (obj == 1) {
                cCmbProType.SetEnabled(true);
                cCmbStockValuation.SetEnabled(true);
                //HsnChange
                //   caspxHsnCode.SetEnabled(true);
                // cHsnLookUp.SetEnabled(true);
                ctxtQuoteLot.SetEnabled(true);
                cCmbQuoteLotUnit.SetEnabled(true);
                ctxtTradingLot.SetEnabled(true);
                cCmbTradingLotUnits.SetEnabled(true);
                ctxtDeliveryLot.SetEnabled(true);
                cCmbDeliveryLotUnit.SetEnabled(true);
                ccmbStockUom.SetEnabled(true);
                ctxtMinLvl.SetEnabled(true);
                ctxtReorderLvl.SetEnabled(true);
                ccmbNegativeStk.SetEnabled(true);
                ccmbServiceItem.SetValue('0');
                ccmbServiceItem.SetEnabled(false);

                $('#btnBarCodeConfig').attr('disabled', false);
                $('#btnProdConfig').attr('disabled', false);

                $('#btnServiceTaxConfig').attr('disabled', 'disabled');
                cAspxServiceTax.SetValue('');

                $('#btnTDS').attr('disabled', 'disabled');
                cmb_tdstcs.SetValue('');

            } else {
                cCmbProType.SetText('');
                cCmbProType.SetEnabled(false);

                cCmbStockValuation.SetValue('A');
                cCmbStockValuation.SetEnabled(false);

                //caspxHsnCode.SetText('');
                //caspxHsnCode.SetEnabled(false);
                // cHsnLookUp.SetEnabled(false);
                // cHsnLookUp.Clear();

                ctxtQuoteLot.SetText('1');
                ctxtQuoteLot.SetEnabled(false);

                cCmbQuoteLotUnit.SetText('');
                cCmbQuoteLotUnit.SetEnabled(false);

                ctxtTradingLot.SetText('1');
                ctxtTradingLot.SetEnabled(false);

                cCmbTradingLotUnits.SetText('');
                cCmbTradingLotUnits.SetEnabled(false);

                ctxtDeliveryLot.SetText('1');
                ctxtDeliveryLot.SetEnabled(false);

                cCmbDeliveryLotUnit.SetText('');
                cCmbDeliveryLotUnit.SetEnabled(false);

                ccmbStockUom.SetText('');
                ccmbStockUom.SetEnabled(false);

                ctxtMinLvl.SetText('0');
                ctxtMinLvl.SetEnabled(false);

                ctxtReorderLvl.SetText('0');
                ctxtReorderLvl.SetEnabled(false);


                ccmbServiceItem.SetEnabled(true);

                ccmbNegativeStk.SetValue('I');
                ccmbNegativeStk.SetEnabled(false);

                //Product Configuration
                $('#btnProdConfig').attr('disabled', 'disabled');
                $('#btnBarCodeConfig').attr('disabled', 'disabled');
                $('#btnServiceTaxConfig').attr('disabled', false);
                $('#btnTDS').attr('disabled', false);
                $('#btnPackingConfig').attr('disabled', 'disabled');
            }
        }
        //Code for UDF Control 
        function OpenUdf() {
            if (document.getElementById('IsUdfpresent').value == '0') {
                jAlert("UDF not define.");
            }
            else {
                var keyVal = document.getElementById('Keyval_internalId').value;
                var url = '/OMS/management/Master/frm_BranchUdfPopUp.aspx?Type=Prd&&KeyVal_InternalID=' + keyVal;
                popup.SetContentUrl(url);
                popup.Show();
            }
            return true;
        }
        // End Udf Code
        //Declare some global variable for poopUP
        var barCodeType;
        var BarCode, GlobalCode;
        var taxCodeSale, taxCodePur, taxScheme;
        var autoApply;
        var ProdColor, ProdSize, ColApp, SizeApp;
        var tdsValue = '';
        //Declare some global variable for poopUP End Here

        //Close the particular popup on esc
        function OnInitTax(s, e) {
            ASPxClientUtils.AttachEventToElement(window.document, "keydown", function (evt) {
                if (evt.keyCode == ASPxClientUtils.StringToShortcutCode("ESCAPE"))
                    cTaxCodePopup.Hide();
            });
        }
        function OnInitBarCode(s, e) {
            ASPxClientUtils.AttachEventToElement(window.document, "keydown", function (evt) {
                if (evt.keyCode == ASPxClientUtils.StringToShortcutCode("ESCAPE"))
                    cBarCodePopUp.Hide();
            });
        }
        function OnInitProductAttribute(s, e) {
            ASPxClientUtils.AttachEventToElement(window.document, "keydown", function (evt) {
                if (evt.keyCode == ASPxClientUtils.StringToShortcutCode("ESCAPE"))
                    cproductAttributePopUp.Hide();
            });
        }

        //for Image Upload

        function OnUploadComplete(args) {
            console.log(args.callbackData);
            document.getElementById('fileName').value = args.callbackData;
            // cProdImage.SetImageUrl(args.callbackData);
            afterFileUpload();

        }

        function uploadClick() {
            Callback1.PerformCallback('');
        }


        function onFileUploadStart(s, e) {
            uploadInProgress = true;
            uploadErrorOccurred = false;
        }
        //Image upload end here


        //code added by debjyoti 04-01-2017
        function ShowProductAttribute() {

            cproductAttributePopUp.Show();
        }

        function productAttributeOkClik() {
            ProdSize = cCmbProductSize.GetValue();
            ProdColor = cCmbProductColor.GetValue();
            ColApp = RrdblappColor.GetSelectedIndex();
            SizeApp = Rrdblapp.GetSelectedIndex();

            cproductAttributePopUp.Hide();
        }


        function ShowBarCode() {
            cBarCodePopUp.Show();
        }
        function BarCodeOkClick() {
            barCodeType = cCmbBarCodeType.GetSelectedIndex();
            BarCode = ctxtBarCodeNo.GetText();
            GlobalCode = ctxtGlobalCode.GetText();
            cBarCodePopUp.Hide();
        }

        function ShowTaxCode() {
            cTaxCodePopup.Show();
        }

        function ShowServiceTax() {
            cServiceTaxPopup.Show();
        }


        function taxCodeOkClick() {
            taxCodeSale = cCmbTaxCodeSale.GetValue();
            taxCodePur = cCmbTaxCodePur.GetValue();
            autoApply = cChkAutoApply.GetChecked();
            taxScheme = cCmbTaxScheme.GetValue();
            cTaxCodePopup.Hide();
        }

        function GetCheckBoxValue(value) {
            //var value = s.GetChecked();
            if (value == true) {
                cCmbTaxCodePur.SetValue(0);
                cCmbTaxCodePur.SetEnabled(false);

                cCmbTaxCodeSale.SetValue(0);
                cCmbTaxCodeSale.SetEnabled(false);

                cCmbTaxScheme.SetEnabled(true);

            } else {
                cCmbTaxScheme.SetValue(0);
                cCmbTaxScheme.SetEnabled(false);
                cCmbTaxCodePur.SetEnabled(true);
                cCmbTaxCodeSale.SetEnabled(true);
            }
        }

        function CloseGridLookup() {
            gridLookup.ConfirmCurrentSelection();
            gridLookup.HideDropDown();
            gridLookup.Focus();
        }
        //changes end here 04-01-2017


        function fn_AllowonlyNumeric(s, e) {
            var theEvent = e.htmlEvent || window.event;
            var key = theEvent.keyCode || theEvent.which;
            var keychar = String.fromCharCode(key);
            if (key == 9 || key == 37 || key == 38 || key == 39 || key == 40 || key == 8 || key == 46) { //tab/ Left / Up / Right / Down Arrow, Backspace, Delete keys
                return;
            }
            var regex = /[0-9\b]/;

            if (!regex.test(keychar)) {
                theEvent.returnValue = false;
                if (theEvent.preventDefault)
                    theEvent.preventDefault();
            }
        }


        function  ChekprodUpload()
        {

            var filename = $("#fileprod").val();
            if ($('#fileprod').get(0).files.length === 0) {
                jAlert("No files selected.");
                return false;
            }
            else {
             

                var extension = filename.replace(/^.*\./, '');

                switch (extension) {
                    case 'xls':
                    case 'xlsx':

                        return true;

                    default:

                        // Cancel the form submission
                        jAlert('Only excel file require.');
                        return false;
                }
                
            }

        }
        
        function fn_PopOpenProducts() {

            $("table[id$='grdproductlog']").html("");
            cproductimport.Show();

        }
        function fn_PopOpen() {
            cbtnSave_citys.SetVisible(true);
            mainAccountInUse = [];
            //ccmbsalesInvoice.SetSelectedIndex(0); SI
            //ccmbSalesReturn.SetSelectedIndex(0);
            //ccmbPurInvoice.SetSelectedIndex(0);
            //ccmbPurReturn.SetSelectedIndex(0);

            $("#hdnSIMainAccount").val("");
            $("#hdnSRMainAccount").val("");
            $("#hdnPIMainAccount").val("");
            $("#hdnPRMainAccount").val("");

            cSIMainAccount.SetText("");
            cSRMainAccount.SetText("");
            cPIMainAccount.SetText("");
            cPRMainAccount.SetText("");


            cSIMainAccount.SetEnabled(true);
            cSRMainAccount.SetEnabled(true);
            cPIMainAccount.SetEnabled(true);
            cPRMainAccount.SetEnabled(true);


            document.getElementById('Keyval_internalId').value = 'Add';
            //document.getElementById('btnUdf').disabled =true;

            cPopup_Empcitys.SetHeaderText('Add Products');
            document.getElementById('hiddenedit').value = "";
            ctxtPro_Code.SetText('');
            ctxtPro_Name.SetText('');
            ctxtPro_Description.SetText('');
            cCmbProType.SetSelectedIndex(-1);
            cCmbProClassCode.SetSelectedIndex(-1);
            ctxtGlobalCode.SetText('');
            ctxtTradingLot.SetText('');
            cCmbTradingLotUnits.SetSelectedIndex(-1);
            cCmbQuoteCurrency.SetSelectedIndex(-1);
            ctxtQuoteLot.SetText('');
            cCmbQuoteLotUnit.SetSelectedIndex(-1);
            ctxtDeliveryLot.SetText('');
            cCmbDeliveryLotUnit.SetSelectedIndex(-1);
            cCmbProductColor.SetSelectedIndex(0);
            cCmbProductSize.SetSelectedIndex(0);
            RrdblappColor.SetSelectedIndex(0);
            Rrdblapp.SetSelectedIndex(0);
            gridLookup.Clear();
            //Debjyoti Code Added:30-12-2016
            //Reason: Barcode Type and No
            cCmbBarCodeType.SetSelectedIndex(-1);
            barCodeType = -1;
            BarCode = "";
            GlobalCode = "";
            ctxtBarCodeNo.SetText('');


            //End Debjyoti 30-12-2016
            taxCodeSale = 0;
            taxCodePur = 0;
            taxScheme = 0;
            autoApply = false;

            ProdColor = 0;
            ProdSize = 0;
            ColApp = 0;
            SizeApp = 0;
            //Debjyoti 04-01-2017
            ccmbIsInventory.SetSelectedIndex(0);
            cCmbStockValuation.SetSelectedIndex(1);
            ctxtSalePrice.SetText('');
            ctxtMinSalePrice.SetText('');
            ctxtPurPrice.SetText('');
            ctxtMrp.SetText('');
            ccmbStockUom.SetSelectedIndex(-1);
            ctxtMinLvl.SetText('');
            ctxtReorderLvl.SetText('');
            ctxtReorderQty.SetText('');
            ccmbNegativeStk.SetSelectedIndex(0);
            cCmbTaxCodeSale.SetSelectedIndex(0);
            cCmbTaxCodePur.SetSelectedIndex(0);
            cCmbTaxScheme.SetSelectedIndex(0);
            cChkAutoApply.SetChecked(false);
            GetCheckBoxValue(false);
            document.getElementById('fileName').value = '';
            cProdImage.SetImageUrl('');
            upload1.ClearText();
            //  gridLookup.SetValue(0);
            cCmbStatus.SetSelectedIndex(0);
            //caspxHsnCode.SetText('');
            cHsnLookUp.Clear();
            //Debjyoti 31-01-2017
            ctxtPro_Code.SetEnabled(true);
            ccmbIsInventory.SetEnabled(true);
            ccmbIsInventory.SetSelectedIndex(0);
            changeControlStateWithInventory();
            $('#reOrderError').css({ 'display': 'None' });
            $('#mrpError').css({ 'display': 'None' });
            cAspxServiceTax.SetValue('');
            $('#btnPackingConfig').attr('disabled', 'disabled');

            //packing details
            ctxtPackingQty.SetValue(0);
            ctxtpacking.SetValue(0);
            ccmbPackingUom.SetSelectedIndex(-1);
            //packing details End Here
            caspxInstallation.SetValue('0');
            ccmbBrand.SetValue('');
            cmb_tdstcs.SetValue('');
            //cPopup_Empcitys.SetWidth(window.screen.width - 50);
            //cPopup_Empcitys.SetHeight(window.innerHeight.height - 70);
            cPopup_Empcitys.Show();
            cHsnLookUp.SetEnabled(true);
            ctxtPro_Code.Focus();
            //ccmbStatusad.SetSelectedIndex(0);
        }
        function afterFileUpload() {
            if (document.getElementById('hiddenedit').value == '') {
                grid.PerformCallback('savecity~' + GetObjectID('fileName').value);
            }
            else {
                grid.PerformCallback('updatecity~' + GetObjectID('hiddenedit').value + "~" + GetObjectID('fileName').value);
            }

        }

        function btnSave_citys() {

            //   alert(ccmbIsInventory.GetValue());
            debugger;
            if ($("#txtPro_Code_I").val() == '')
            {
                jAlert('Mandatory Fields are required');

            }
            else if ($("#txtPro_Name_I").val() == '') {

                jAlert('Mandatory Fields are required');
            }

           


           else  if ($("#CmbTradingLotUnits_I").val() == '')
            {
               jAlert('Mandatory Fields are required');

            }
            else if ($("#CmbDeliveryLotUnit_I").val() == '') {

                jAlert('Mandatory Fields are required');
            }

            else {
                if (ccmbIsInventory.GetValue() == 0) {
                    if ((ctxtPro_Code.GetText() != '') && (ctxtPro_Name.GetText().trim() != '')) {
                        if (upload1.GetText().trim() != '') {
                            upload1.Upload();
                        } else {
                            afterFileUpload();
                        }
                    }
                } else {
                    /// if ((ctxtPro_Code.GetText() != '') && (ctxtPro_Name.GetText().trim() != '') && (cCmbTradingLotUnits.GetText().trim() != '') && (cCmbDeliveryLotUnit.GetText().trim() != '') && (ccmbStockUom.GetValue() != null)) {

                    if (validReorder() && validMRP()) {
                        if (upload1.GetText().trim() != '') {
                            upload1.Upload();
                        } else {
                            afterFileUpload();
                        }
                    }
                    //  }
                }
            }

        }

        function validReorder() {
            var retval = true;
            var minlvl = (ctxtMinLvl.GetValue() != null) ? ctxtMinLvl.GetValue() : "0";
            var reordLvl = (ctxtReorderLvl.GetValue() != null) ? ctxtReorderLvl.GetValue() : "0";
            if (reordLvl < minlvl) {
                $('#reOrderError').css({ 'display': 'block' });
                retval = false;
            }
            else {
                $('#reOrderError').css({ 'display': 'None' });
            }
            return retval;
        }

        function validMRP() {
            var retval = true;
            var txtMinSalePrice = (ctxtMinSalePrice.GetValue() != null) ? ctxtMinSalePrice.GetValue() : "0";
            var txtMrp = (ctxtMrp.GetValue() != null) ? ctxtMrp.GetValue() : "0";

            if (parseFloat(txtMrp) != 0 && parseFloat(txtMrp) < parseFloat(txtMinSalePrice)) {
                $('#mrpError').css({ 'display': 'block' });
                retval = false;
            }
            else {
                $('#mrpError').css({ 'display': 'None' });
            }
            return retval;
        }

        function btnSave_citysOld() {

            var valiEmail = false;

            var validPhNo = false;

            var CheckUniqueCode = false;

            var reg = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/;
            if (reg.test(ctxtMarkets_Email.GetText())) {
                valiEmail = true;
            }

            if (!isNaN(ctxtMarkets_Phones.GetText()) && ctxtMarkets_Phones.GetText().length == 10) {
                validPhNo = true;
            }


            //for unique code ajax call
            var MarketsCode = ctxtMarkets_Code.GetText();
            $.ajax({
                type: "POST",
                url: "sMarkets.aspx/CheckUniqueCode",
                data: "{'MarketsCode':'" + MarketsCode + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    //                    CheckUniqueCode = msg.d;

                    if (document.getElementById('hiddenedit').value == '') {
                        CheckUniqueCode = msg.d;
                    }
                    else {
                        CheckUniqueCode == false
                    }

                    if (CheckUniqueCode == false && ctxtMarkets_Code.GetText() != '' && ctxtMarkets_Name.GetText() != '' && (ctxtMarkets_Email.GetText() == '' || valiEmail == true) && (ctxtMarkets_Phones.GetText() == '' || validPhNo == true)) {
                        if (document.getElementById('hiddenedit').value == '') {
                            //alert("in add");
                            grid.PerformCallback('savecity~');
                        }
                        else {
                            //alert("in update");
                            grid.PerformCallback('updatecity~' + GetObjectID('hiddenedit').value);
                        }
                    }
                    else if (CheckUniqueCode == true) {
                        jAlert('Please enter unique market code');
                        ctxtMarkets_Code.Focus();
                    }
                    else if (ctxtMarkets_Code.GetText() == '') {
                        jAlert('Please Enter Markets Code');
                        ctxtMarkets_Code.Focus();
                    }
                    else if (ctxtMarkets_Name.GetText() == '') {
                        jAlert('Please Enter Markets Name');
                        ctxtMarkets_Name.Focus();
                    }
                    else if (!reg.test(ctxtMarkets_Email.GetText())) {
                        jAlert('Please enter valid email');
                        ctxtMarkets_Email.Focus();
                    }
                    else if (isNaN(ctxtMarkets_Phones.GetText()) || ctxtMarkets_Phones.GetText().length != 10) {
                        jAlert('Please enter valid Phone No');
                        ctxtMarkets_Phones.Focus();
                    }

                }

            });
        }


        function fn_btnCancel() {
            cPopup_Empcitys.Hide();
            $("#txtPro_Code_EC, #txtPro_Name_EC, #txtQuoteLot_EC, #txtTradingLot_EC, #txtDeliveryLot_EC").hide();
        }

        function fn_ViewProduct(keyValue) {
            /*-------------------------------------------------Arindam-----------------------------------------------------------*/

            var url = '/OMS/management/master/View/ViewProduct.html?v=0.07&&id=' + keyValue;

            CAspxDirectCustomerViewPopup.SetWidth(window.screen.width - 50);
            CAspxDirectCustomerViewPopup.SetHeight(window.innerHeight - 70);
            CAspxDirectCustomerViewPopup.SetContentUrl(url);
            CAspxDirectCustomerViewPopup.RefreshContentUrl();
            CAspxDirectCustomerViewPopup.Show();




            /*-------------------------------------------------Arindam-----------------------------------------------------------*/
            //  fn_Editcity(keyValue);
            //  cbtnSave_citys.SetVisible(false);

        }

        function fn_Editcity(keyValue) {
            cbtnSave_citys.SetVisible(true);
           // document.getElementById('btnUdf').disabled = false;
            cPopup_Empcitys.SetHeaderText('Modify Products');
            grid.PerformCallback('Edit~' + keyValue);
            document.getElementById('Keyval_internalId').value = 'ProductMaster' + keyValue;
        }

        function fn_Deletecity(keyValue) {
            //if (confirm("Confirm Delete?")) {
            //    grid.PerformCallback('Delete~' + keyValue);
            //}
            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    grid.PerformCallback('Delete~' + keyValue);
                }
            });
        }


        function componentEndCallBack(s, e) {
            console.log(e);
            // cPopup_Empcitys.Show();
        }

        var mainAccountInUse = [];
        function grid_EndCallBack() {
         
            if (grid.cpinsert != null) {
                if (grid.cpinsert == 'Success') {
                    jAlert('Saved Successfully');
                    //alert('Saved Successfully');
                    //................CODE  UPDATED BY sAM ON 18102016.................................................
                    ctxtPro_Name.GetInputElement().readOnly = false;
                    //................CODE ABOVE UPDATED BY sAM ON 18102016.................................................
                    cPopup_Empcitys.Hide();
                }
                else if (grid.cpinsert == 'fail') {
                    jAlert("Mandatory Fields Require")
                }
                else if (grid.cpinsert == 'UDFManddratory') {
                    jAlert("UDF is set as Mandatory. Please enter values.", "Alert", function () { OpenUdf(); });

                }
                else {
                    jAlert(grid.cpinsert);
                    //cPopup_Empcitys.Hide();
                }
            }
            if (grid.cpMainAccountInUse != null) {
                if (grid.cpMainAccountInUse != '') {
                    for (var mainCount = 0; mainCount < grid.cpMainAccountInUse.split('~').length; mainCount++) {
                        mainAccountInUse.push(grid.cpMainAccountInUse.split('~')[mainCount]);
                    }
                }
            }

            if (grid.cpEdit != null) {
                var col = grid.cpEdit.split('~')[15];
                var size = grid.cpEdit.split('~')[16];

                //................. Code Added By Sam on 25102016....................
                var sizeapplicable = grid.cpEdit.split('~')[18];
                var colorapplicable = grid.cpEdit.split('~')[19];


                //................. Code Added By Sam on 25102016....................
                ctxtPro_Code.SetText(grid.cpEdit.split('~')[1]);
                ctxtPro_Name.SetText(grid.cpEdit.split('~')[2]);
                //ctxtPro_Name.GetInputElement().readOnly = true;
                ctxtPro_Description.SetText(grid.cpEdit.split('~')[3]);
                cCmbProType.SetValue(grid.cpEdit.split('~')[4]);
                cCmbProClassCode.SetValue(grid.cpEdit.split('~')[6]);
                ctxtGlobalCode.SetText(grid.cpEdit.split('~')[7]);
                GlobalCode = grid.cpEdit.split('~')[7];
                ctxtTradingLot.SetText(grid.cpEdit.split('~')[8]);
                cCmbTradingLotUnits.SetValue(grid.cpEdit.split('~')[9]);
                cCmbQuoteCurrency.SetValue(grid.cpEdit.split('~')[10]);
                ctxtQuoteLot.SetText(grid.cpEdit.split('~')[11]);
                cCmbQuoteLotUnit.SetValue(grid.cpEdit.split('~')[12]);
                ctxtDeliveryLot.SetText(grid.cpEdit.split('~')[13]);
                cCmbDeliveryLotUnit.SetValue(grid.cpEdit.split('~')[14]);
                if (col != '') {
                    cCmbProductColor.SetValue(grid.cpEdit.split('~')[15]);
                    ProdColor = grid.cpEdit.split('~')[15];
                }
                else {
                    cCmbProductColor.SetValue('0');
                    ProdColor = 0;
                }
                if (size != '') {
                    cCmbProductSize.SetValue(grid.cpEdit.split('~')[16]);
                    ProdSize = grid.cpEdit.split('~')[16];
                }
                else {
                    cCmbProductSize.SetValue('0');
                    ProdSize = 0;
                }


                if (sizeapplicable == 'True') {
                    Rrdblapp.SetSelectedIndex(0);
                    SizeApp = 0;
                }
                else {
                    Rrdblapp.SetSelectedIndex(1);
                    SizeApp = 1;
                }

                if (colorapplicable == 'True') {
                    RrdblappColor.SetSelectedIndex(0);
                    ColApp = 0;
                }
                else {
                    RrdblappColor.SetSelectedIndex(1);
                    ColApp = 1;
                }
                GetObjectID('hiddenedit').value = grid.cpEdit.split('~')[17];

                //Code Added by Debjyoti 30-12-2016
                if (grid.cpEdit.split('~')[20] != '0') {
                    cCmbBarCodeType.SetValue(grid.cpEdit.split('~')[20]);
                    barCodeType = grid.cpEdit.split('~')[20];
                }
                ctxtBarCodeNo.SetText(grid.cpEdit.split('~')[21]);
                BarCode = grid.cpEdit.split('~')[21];


                //Code added by debjyoti 04-01-2017
                if (grid.cpEdit.split('~')[22] == 'False')
                    ccmbIsInventory.SetValue('0');
                else
                    ccmbIsInventory.SetValue('1');

                cCmbStockValuation.SetValue(grid.cpEdit.split('~')[23].trim());
                if (grid.cpEdit.split('~')[24].trim() == '0')
                    ctxtSalePrice.SetText('');
                else
                    ctxtSalePrice.SetText(grid.cpEdit.split('~')[24].trim());

                if (grid.cpEdit.split('~')[25].trim() == '0')
                    ctxtMinSalePrice.SetText('');
                else
                    ctxtMinSalePrice.SetText(grid.cpEdit.split('~')[25].trim());

                if (grid.cpEdit.split('~')[26].trim() == '0')
                    ctxtPurPrice.SetText('');
                else
                    ctxtPurPrice.SetText(grid.cpEdit.split('~')[26].trim());

                if (grid.cpEdit.split('~')[27].trim() == '0')
                    ctxtMrp.SetText('');
                else
                    ctxtMrp.SetText(grid.cpEdit.split('~')[27].trim());

                ccmbStockUom.SetValue(grid.cpEdit.split('~')[28]);
                ctxtMinLvl.SetText(grid.cpEdit.split('~')[29]);
                ctxtReorderLvl.SetText(grid.cpEdit.split('~')[30]);
                ccmbNegativeStk.SetValue(grid.cpEdit.split('~')[31].trim());
                cCmbTaxCodeSale.SetValue(grid.cpEdit.split('~')[32].trim());
                taxCodeSale = grid.cpEdit.split('~')[32].trim();

                cCmbTaxCodePur.SetValue(grid.cpEdit.split('~')[33].trim());
                taxCodePur = grid.cpEdit.split('~')[33].trim();

                if (grid.cpEdit.split('~')[34].trim() == '') {
                    cCmbTaxScheme.SetValue(0);
                    taxScheme = 0;
                }
                else {
                    cCmbTaxScheme.SetValue(grid.cpEdit.split('~')[34].trim());
                    taxScheme = grid.cpEdit.split('~')[34].trim();
                }
                if (grid.cpEdit.split('~')[35].trim() == 'True') {
                    cChkAutoApply.SetChecked(true);
                    autoApply = true;
                    GetCheckBoxValue(true);
                } else {
                    cChkAutoApply.SetChecked(false);
                    autoApply = false;
                    GetCheckBoxValue(false);
                }

                cProdImage.SetImageUrl(grid.cpEdit.split('~')[36].trim());
                document.getElementById('fileName').value = grid.cpEdit.split('~')[36].trim();
                gridLookup.Clear();
                cComponentPanel.PerformCallback(grid.cpEdit.split('~')[37].trim());
                cCmbStatus.SetValue(grid.cpEdit.split('~')[38].trim());

                //  ctxtHsnCode.SetText(grid.cpEdit.split('~')[39].trim()); 
                cHsnLookUp.gridView.SelectItemsByKey(grid.cpEdit.split('~')[39].trim());
                cAspxServiceTax.SetValue(grid.cpEdit.split('~')[40].trim());
                // ccmbStatusad.SetValue(grid.cpEdit.split('~')[31].trim());
                //Debjyoti 31-01-2017
                //packing details
                ctxtPackingQty.SetValue(grid.cpEdit.split('~')[41].trim());
                ctxtpacking.SetValue(grid.cpEdit.split('~')[42].trim());
                ccmbPackingUom.SetValue(grid.cpEdit.split('~')[43].trim());
                //packing details End Here
                console.log(grid.cpEdit.split('~')[44]);
                if (grid.cpEdit.split('~')[44] == 'False')
                    caspxInstallation.SetValue('0');
                else
                    caspxInstallation.SetValue('1');
                ccmbBrand.SetValue(grid.cpEdit.split('~')[45].trim());

                if (grid.cpEdit.split('~')[46] == 'True')
                    ccmbIsCapitalGoods.SetValue('1');
                else
                    ccmbIsCapitalGoods.SetValue('0');
                //  ccmbIsCapitalGoods.SetValue(grid.cpEdit.split('~')[46].trim());

                cmb_tdstcs.SetValue(grid.cpEdit.split('~')[47]);

                if (grid.cpEdit.split('~')[48] == "True")
                    ccmbOldUnit.SetValue('1');
                else
                    ccmbOldUnit.SetValue('0');


                //ccmbsalesInvoice.SetValue(grid.cpEdit.split('~')[49].trim());
                //ccmbSalesReturn.SetValue(grid.cpEdit.split('~')[50].trim());
                //ccmbPurInvoice.SetValue(grid.cpEdit.split('~')[51].trim());
                //ccmbPurReturn.SetValue(grid.cpEdit.split('~')[52].trim());

                $("#hdnSIMainAccount").val(grid.cpEdit.split('~')[49].trim());
                $("#hdnSRMainAccount").val(grid.cpEdit.split('~')[50].trim());
                $("#hdnPIMainAccount").val(grid.cpEdit.split('~')[51].trim());
                $("#hdnPRMainAccount").val(grid.cpEdit.split('~')[52].trim());


                //Subhabrata
                console.log(grid.cpEdit.split('~')[53]);
                if (grid.cpEdit.split('~')[53] == "True")
                    cchkFurtherance.SetValue(true);
                else
                    cchkFurtherance.SetValue(false);

                //alert(grid.cpEdit.split('~')[54]);
                if (grid.cpEdit.split('~')[54] == 'True')
                    ccmbServiceItem.SetValue('1');
                else if (grid.cpEdit.split('~')[54] == 'False')
                    ccmbServiceItem.SetValue('0');
                else
                    ccmbServiceItem.SetValue('0');


                cSIMainAccount.SetText(grid.cpEdit.split('~')[55].trim());
                cSRMainAccount.SetText(grid.cpEdit.split('~')[56].trim());
                cPIMainAccount.SetText(grid.cpEdit.split('~')[57].trim());
                cPRMainAccount.SetText(grid.cpEdit.split('~')[58].trim());


                if (grid.cpEdit.split('~')[59].trim() == "1") {
                    cSIMainAccount.SetEnabled(false);
                }
                if (grid.cpEdit.split('~')[60].trim() == "1") {
                    cSRMainAccount.SetEnabled(false);
                }
                if (grid.cpEdit.split('~')[61].trim() == "1") {
                    cPIMainAccount.SetEnabled(false);
                }
                if (grid.cpEdit.split('~')[62].trim() == "1") {
                    cPRMainAccount.SetEnabled(false);
                }

                ctxtReorderQty.SetText(grid.cpEdit.split('~')[63]);

                ctxtPro_Code.SetEnabled(false);
                ccmbIsInventory.SetEnabled(false);

                changeControlStateWithInventory();
                //cPopup_Empcitys.SetWidth(window.screen.width - 50);
                // cPopup_Empcitys.SetHeight(window.screen.height - 70);
                cPopup_Empcitys.Show();

                ctxtPro_Name.Focus();
            }
            if (grid.cpUpdate != null) {
                if (grid.cpUpdate == 'Success') {
                    jAlert('Saved Successfully');
                    cPopup_Empcitys.Hide();
                }
                else {
                    jAlert("Error on Updation\n'Please Try again!!'")
                    //cPopup_Empcitys.Hide();
                }
            }
            if (grid.cpUpdateValid != null) {
                if (grid.cpUpdateValid == "StateInvalid") {
                    jAlert("Please Select proper country state and city");
                    //cPopup_Empcitys.Show();
                    //cCmbState.Focus();
                    //alert(GetObjectID('<%#hiddenedit.ClientID%>').value);
                    //grid.PerformCallback('Edit~'+GetObjectID('<%#hiddenedit.ClientID%>').value);
                    //grid.cpUpdateValid=null;
                }
            }
            if (grid.cpDelete != null) {
                if (grid.cpDelete == 'Success')
                    jAlert('Deleted Successfully');
                //else
                //    jAlert("Error on deletion\n'Please Try again!!'")
            }
            //debjyoti
            if (grid.cpErrormsg != null) {
                jAlert(grid.cpErrormsg);
                grid.cpErrormsg = null;
            }

            if (grid.cpExists != null) {
                if (grid.cpExists == "Exists") {
                    jAlert('Record already Exists');
                    //cPopup_Empcitys.Hide();
                }
                else {
                    jAlert("Error on operation \n 'Please Try again!!'")
                    //cPopup_Empcitys.Hide();
                }
            }
        }
        function OnCmbCountryName_ValueChange() {
            cCmbState.PerformCallback("BindState~" + cCmbCountryName.GetValue());
        }
        function CmbState_EndCallback() {
            cCmbState.SetSelectedIndex(0);
            cCmbState.Focus();
        }
        function OnCmbStateName_ValueChange() {
            cCmbCity.PerformCallback("BindCity~" + cCmbState.GetValue());
        }
        function CmbCity_EndCallback() {
            cCmbCity.SetSelectedIndex(0);
            cCmbCity.Focus();
        }
        $(document).ready(function () {
            $('.dxpc-closeBtn').click(function () {
                fn_btnCancel();
            });
        });
    </script>

    <script type="text/javascript">
        function fn_ctxtPro_Name_TextChanged(s, e) {
            var procode = 0;
            if (GetObjectID('hiddenedit').value != '') {
                procode = GetObjectID('hiddenedit').value;
            }

            //var ProductName = ctxtPro_Name.GetText();
            var ProductName = ctxtPro_Code.GetText().trim();
            $.ajax({
                type: "POST",
                url: "sProducts.aspx/CheckUniqueName",
                //data: "{'ProductName':'" + ProductName + "'}",
                data: JSON.stringify({ ProductName: ProductName, procode: procode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;

                    if (data == true) {
                        jAlert("Please enter unique name", "Alert", function () { ctxtPro_Code.SetFocus(); });
                        ctxtPro_Code.SetText("");
                        // ctxtPro_Code.SetFocus();
                        //document.getElementById("Popup_Empcitys_ctxtPro_Code_I").focus();
                        //  document.getElementById("txtPro_Code_I").focus();

                        return false;
                    }
                }

            });
        }
    </script>

    <style type="text/css">
        .cityDiv {
            height: 25px;
        }

        .cityTextbox {
            height: 25px;
            width: 50px;
        }

        .Top {
            height: 90px;
            width: 100%;
            padding-top: 5px;
            valign: top;
        }

        .Footer {
            height: 30px;
            width: 400px;
            padding-top: 10px;
        }

        .ScrollDiv {
            height: 250px;
            width: 400px;
            overflow-x: hidden;
            overflow-y: scroll;
        }

        .ContentDiv {
            width: 100%;
            height: 300px;
            border: 2px;
        }



        .TitleArea {
            height: 20px;
            padding-left: 10px;
            padding-right: 3px;
            background-image: url( '../images/EHeaderBack.gif' );
            background-repeat: repeat-x;
            background-position: bottom;
            text-align: center;
        }

        .FilterSide {
            float: left;
            width: 50%;
        }

        .SearchArea {
            width: 100%;
            height: 30px;
            padding-top: 5px;
        }

        .newLbl {
            margin: 5px 0 !important;
            display: block;
        }
        .padTbl>tbody>tr>td {
            padding-right:15px;
        }
        .mpad {
            padding:20px 15px;
        }
    </style>


    <script type="text/javascript">
        function OnAddBusinessClick(keyValue) {
            var url = '../../master/AssignIndustry.aspx?id1=' + keyValue + '&EntType=product';
            window.location.href = url;
        }
        function PopupOpen(obj) {
            var URL = '/OMS/Management/Master/Product_Document.aspx?idbldng=' + obj + '&type=Product';
            //OnMoreInfoClick(URL, "Products Document Details", '1000px', '400px', "Y");
            //document.getElementById("marketsGrid_DXPEForm_efnew_DXEditor1_I").focus();
            window.location.href = URL;
        }



        var KEYCODE_ENTER = 13;
        var KEYCODE_ESC = 27;



        $(document).keyup(function (e) {
            if (e.keyCode == KEYCODE_ESC) {
                // cPopup_Empcitys.Hide();
                //$('#cPopup_Empcitys').hide();
            }
        });

        function PopupOpentoProductUpload(obj, prod_name) {

            ///  alert(prod_name);
            var URL = '/OMS/Management/Master/Product-Multipleimage.aspx?prodid=' + obj + '&name=' + prod_name;
            window.location.href = URL;

        }

    </script>


    <script type="text/javascript">

        var counter = 0;


        function fetchLebel() {

            $("#generatedForm").html("");
            counter = 0;


            $(".newLbl").each(function () {

                var newField = "<div style='width:500px; margin-left:5px; float:left; margin-bottom:5px;'><label id='LblKey" + counter + "' style='width:110px; float:left;'>" + $(this).text() + "</label>";
                newField += "<input type='text' id='TxtKey" + counter + "' value='" + $(this).text() + "' style='margin-left:41px; width:250px;' />";

                //alert($(this).attr("id").split('_')[4]);

                if (String($(this).attr("id").split('_')[2]) != "undefined") {
                    newField += "<input type='text' id='HddnKey" + counter + "' value='" + $(this).attr("id").split('_')[2] + "' style='display:none; margin-left:41px; width:250px;' />";
                }
                else {
                    //alert($(this).attr("id"));
                    newField += "<input type='text' id='HddnKey" + counter + "' value='" + $(this).attr("id") + "' style='display:none; margin-left:41px; width:250px;' />";
                }
                newField += "</div>";

                $("#generatedForm").append(newField);

                counter++;

            });

            AssignValuePopup.Show();

        }


        function tdsOkClick() {
            tdsValue = cmb_tdstcs.GetValue();
            ctdsPopup.Hide();
        }

        function SaveDataToResource() {

            var key = "";
            var value = "";

            for (var i = 0; i < counter; i++) {

                if (key == "") {

                    key = $("#HddnKey" + i).val();
                    value = $("#TxtKey" + i).val();

                }
                else {

                    key += "," + $("#HddnKey" + i).val();
                    value += "," + $("#TxtKey" + i).val();

                }

            }

            $("#AssignValuePopup_KeyField").val(key);
            $("#AssignValuePopup_ValueField").val(value);
            $("#AssignValuePopup_RexPageName").val("ProductValues");


            return true;

        }


    </script>

    <style>
        .imageArea {
            width: 150px;
            height: 100px !important;
            overflow: hidden;
        }

        .popUpHeader {
            float: right;
        }

        .blll {
            margin: 0;
            padding: 0 !important;
            margin-top: 6px;
        }

        .dxeErrorCellSys.dxeNoBorderLeft {
            position: absolute;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Products</h3>
        </div>
    </div>
    <div class="form_main">
        <div class="Main">
            <%-- <div class="TitleArea">
                <strong><span style="color: #000099">marketss</span></strong>
            </div>--%>
            <div class="SearchArea">
                <div class="FilterSide">
                    <div style="float: left; padding-right: 5px;">
                        <%--<a href="javascript:ShowHideFilter('s');"><span style="color: #000099; text-decoration: underline">Show Filter</span></a>--%>
                        <% if (rights.CanAdd)
                           { %>
                        <a class="btn btn-primary" href="javascript:void(0);" onclick="fn_PopOpen()" id="AddBtn"><span><u>A</u>dd New</span> </a><%} %>
                        <% if (rights.CanExport)
                           { %>
                        <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" OnChange="if(!AvailableExportOption()){return false;}" AutoPostBack="true">
                            <asp:ListItem Value="0">Export to</asp:ListItem>
                            <asp:ListItem Value="1">PDF</asp:ListItem>
                            <asp:ListItem Value="2">XLS</asp:ListItem>
                            <asp:ListItem Value="3">RTF</asp:ListItem>
                            <asp:ListItem Value="4">CSV</asp:ListItem>
                        </asp:DropDownList>
                        <%} %>


                       <asp:Button ID="btndownload" runat="server" cssclass="btn btn-primary" OnClick="btnDownload_Click" Text="Download Format" />
                    
                        <a class="btn btn-primary" href="javascript:void(0);" onclick="fn_PopOpenProducts()" id="btnimportexcel"><span>Import</span> </a>

                    </div>
                    <%-- <div>
                        <a class="btn btn-primary" href="javascript:ShowHideFilter('All');"><span>All Records</span></a>
                    </div>--%>
                </div>
                <%--<div class="ExportSide pull-right">
                    <div>
                        <dxe:ASPxComboBox ID="cmbExport" runat="server" AutoPostBack="true"
                            Font-Bold="False" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged"
                            ValueType="System.Int32" Width="130px">
                            <Items>
                                <dxe:ListEditItem Text="Select" Value="0" />
                                <dxe:ListEditItem Text="PDF" Value="1" />
                                <dxe:ListEditItem Text="XLS" Value="2" />
                                <dxe:ListEditItem Text="RTF" Value="3" />
                                <dxe:ListEditItem Text="CSV" Value="4" />
                            </Items>
                            <Border BorderColor="black" />
                            <DropDownButton Text="Export">
                            </DropDownButton>
                        </dxe:ASPxComboBox>
                    </div>
                </div>--%>
            </div>
            <%--debjyoti 22-12-2016--%>
            <dxe:ASPxPopupControl ID="ASPXPopupControl" runat="server"
                CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popup" Height="630px"
                Width="600px" HeaderText="Add/Modify UDF" Modal="true" AllowResize="true" ResizingMode="Postponed">
                <HeaderTemplate>
                    <span>UDF</span>
                    <dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                        <ClientSideEvents Click="function(s, e){ 
                                                            popup.Hide();
                                                        }" />
                    </dxe:ASPxImage>
                </HeaderTemplate>
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                    </dxe:PopupControlContentControl>
                </ContentCollection>
            </dxe:ASPxPopupControl>
            <asp:HiddenField runat="server" ID="IsUdfpresent" />
            <asp:HiddenField runat="server" ID="Keyval_internalId" />
            <%--End debjyoti 22-12-2016--%>


            <div class="GridViewArea">
                <dxe:ASPxGridView ID="cityGrid" runat="server" AutoGenerateColumns="False" ClientInstanceName="grid"
                    KeyFieldName="sProducts_ID" Width="100%" OnHtmlRowCreated="cityGrid_HtmlRowCreated"
                    OnHtmlEditFormCreated="cityGrid_HtmlEditFormCreated" OnCustomCallback="cityGrid_CustomCallback"
                    CssClass="pull-left" SettingsBehavior-AllowFocusedRow="true" SettingsDataSecurity-AllowEdit="false"
                    SettingsDataSecurity-AllowInsert="false" SettingsDataSecurity-AllowDelete="false" Settings-HorizontalScrollBarMode="Auto">
                    <SettingsSearchPanel Visible="True" Delay="7000" />
                    <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowFilterRow="true" ShowFilterRowMenu="True" />
                    <Columns>

                        <dxe:GridViewDataTextColumn Caption="Short Name (Code)" FieldName="sProducts_Code" ReadOnly="True"
                            Visible="True" VisibleIndex="0" FixedStyle="Left" Width="160px">
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Caption="Name" FieldName="sProducts_Name" ReadOnly="True"
                            Visible="True" VisibleIndex="1" FixedStyle="Left" Width="300px">
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Caption="Description" FieldName="sProducts_Description" ReadOnly="True"
                            Visible="True" VisibleIndex="2" Width="300px">
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="Brand" FieldName="Brand_Name" ReadOnly="True" Width="120px"
                            Visible="True" VisibleIndex="3">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>


<%--                        <dxe:GridViewDataTextColumn Caption="Inventory" FieldName="sProduct_IsInventory" ReadOnly="True"
                            Visible="True" VisibleIndex="3" Width="80px">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>--%>


                      <%--  <dxe:GridViewDataTextColumn Caption="Service Item?" FieldName="Is_ServiceItem" ReadOnly="True"
                            Visible="True" VisibleIndex="3" Width="80px">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>--%>

                        <%--<dxe:GridViewDataTextColumn Caption="Class Name" FieldName="ProductClass_Name" ReadOnly="True"
                            Visible="True" FixedStyle="Left" VisibleIndex="4">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                        </dxe:GridViewDataTextColumn>--%>

                        <dxe:GridViewDataComboBoxColumn Caption="Class Name (Category)" FieldName="ProductClass_Name" VisibleIndex="4" Width="120px">
                            <PropertiesComboBox EnableSynchronization="False" EnableIncrementalFiltering="True"
                                ValueType="System.String" DataSourceID="SqlClassSource" TextField="ProductClass_Name" ValueField="ProductClass_Name">
                            </PropertiesComboBox>
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataComboBoxColumn>


                        <%--  <dxe:GridViewDataTextColumn Caption="HSN Code" FieldName="HSNCODE" ReadOnly="True"
                            Visible="True" FixedStyle="Left" VisibleIndex="5">
                            <EditFormSettings Visible="True" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>--%>

             <%--           <dxe:GridViewDataComboBoxColumn Caption="HSN/SAC" FieldName="HSNCODE" VisibleIndex="5">
                            <PropertiesComboBox EnableSynchronization="False" EnableIncrementalFiltering="True"
                                ValueType="System.String" DataSourceID="SqlHSNDataSource" TextField="Code" ValueField="Code">
                            </PropertiesComboBox>
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataComboBoxColumn>--%>

                <%--        <dxe:GridViewDataTextColumn Caption="Capital Goods?" FieldName="sProduct_IsCapitalGoods" ReadOnly="True"
                            Visible="True" VisibleIndex="6">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>--%>

               <%--         <dxe:GridViewDataTextColumn Caption="Sales Invoice Ledger" FieldName="sInv_MainAccount" ReadOnly="True"
                            Visible="True" VisibleIndex="7" Width="160px">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>--%>

                   <%--     <dxe:GridViewDataTextColumn Caption="Sales Return Ledger" FieldName="sRet_MainAccount" ReadOnly="True"
                            Visible="True" VisibleIndex="8" Width="160px">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>--%>


              <%--          <dxe:GridViewDataTextColumn Caption="Purchase Invoice Ledger" FieldName="pInv_MainAccount" ReadOnly="True"
                            Visible="True" VisibleIndex="9" Width="160px">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>--%>


<%--                        <dxe:GridViewDataTextColumn Caption="Purchase Return Ledger" FieldName="pRet_MainAccount" ReadOnly="True"
                            Visible="True" VisibleIndex="10" Width="160px">
                            <Settings AutoFilterCondition="Contains" />
                            <EditFormSettings Visible="True" />
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>--%>


                        <dxe:GridViewDataTextColumn ReadOnly="True" CellStyle-HorizontalAlign="Center" Width="180px">
                            <HeaderStyle HorizontalAlign="Center" />

                            <CellStyle HorizontalAlign="Center"></CellStyle>
                            <HeaderTemplate>
                                Actions
                            </HeaderTemplate>
                            <DataItemTemplate>
                                <%--<% if (rights.CanView)
                                   { %>
                                <a href="javascript:void(0);" id="DocunemtInsert" onclick="PopupOpen(<%#Eval("sProducts_ID")%>)" title="Document" class="pad" style="text-decoration: none;">
                                    <img src="/assests/images/document.png" />
                                </a>
                                <%} %>--%>
                                <%if (rights.CanEdit)
                                  { %>
                                <a href="javascript:void(0);" onclick="fn_Editcity('<%# Container.KeyValue %>')" title="Edit" class="pad">
                                    <img src="/assests/images/Edit.png" /></a>
                                <%} %>
                        <%--        <%if (rights.CanView)
                                  { %>
                                <a href="javascript:void(0);" onclick="fn_ViewProduct('<%# Container.KeyValue %>')" title="View" class="pad">
                                    <img src="/assests/images/doc.png" /></a>
                                <%} %>--%>

                                <%if (rights.CanDelete)
                                  { %>
                                <a href="javascript:void(0);" onclick="fn_Deletecity('<%# Container.KeyValue %>')" title="Delete" class="pad">
                                    <img src="/assests/images/Delete.png" /></a>
                                <%} %>
                               <%-- <%if (rights.CanIndustry)
                                  { %>
                                <a href="javascript:void(0);" onclick="OnAddBusinessClick('<%# (Convert.ToString( Eval("sProducts_Code"))).Replace("'",@"\'").Replace("\"","&quot") %>')" title="Add Industry" class="pad" style="text-decoration: none;">
                                    <img src="/assests/images/icoaccts.gif" />
                                </a>

                                <%} %>--%>


                                <%--                                  <% if (rights.Imagaeupload)--%>

                               <%-- <% if (rights.CanEdit)
                                   { %>

                                <a href="javascript:void(0);" onclick="PopupOpentoProductUpload('<%#Eval("sProducts_ID")%>','<%# (Convert.ToString( Eval("sProducts_Code"))).Replace("'",@"\'").Replace("\"","&quot") %>')" title="Produc Image Upload" class="pad" style="text-decoration: none;">
                                    <img src="/assests/images/upload.png" />
                                </a>

                                <%} %>--%>
                            </DataItemTemplate>
                            <Settings AllowAutoFilterTextInputTimer="False" />
                        </dxe:GridViewDataTextColumn>

                    </Columns>
                    <SettingsContextMenu Enabled="true"></SettingsContextMenu>
                    <SettingsPager PageSize="10">
                        <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                    </SettingsPager>
                    <SettingsBehavior ColumnResizeMode="NextColumn" />
                    <ClientSideEvents EndCallback="function (s, e) {grid_EndCallBack();}" />
                </dxe:ASPxGridView>
            </div>
            <div class="PopUpArea">

                <%--Packing Details popup--%>
                <dxe:ASPxPopupControl ID="ASPxPopupControl2" runat="server" ClientInstanceName="cpackingDetails"
                    Width="500px" HeaderText="Packing Details" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <HeaderTemplate>
                        <span>Set Packing Details</span>
                        <dxe:ASPxImage ID="ASPxImage5" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                            <ClientSideEvents Click="function(s, e){ 
                                $('#invalidPackingUom').css({ 'display': 'none' });
                                cpackingDetails.Hide();
                            }" />
                        </dxe:ASPxImage>
                    </HeaderTemplate>
                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <div style="clear: both"></div>

                            <table>
                                <tr>
                                    <td>Quantity</td>
                                    <td>Sale UOM</td>
                                    <td></td>
                                    <td>Packing</td>
                                    <td>Select UOM</td>
                                </tr>
                                <tr>
                                    <td style="padding-right: 7px">
                                        <dxe:ASPxTextBox ID="txtPackingQty" ClientInstanceName="ctxtPackingQty" MaxLength="50" runat="server" Width="100%">
                                            <MaskSettings Mask="<0..99999999>.<0..99>" />
                                        </dxe:ASPxTextBox>
                                    </td>
                                    <td style="padding-right: 7px">
                                        <dxe:ASPxTextBox ID="txtpackingSaleUom" ClientInstanceName="ctxtpackingSaleUom" MaxLength="50" runat="server" Width="100%">
                                        </dxe:ASPxTextBox>
                                    </td>
                                    <td style="padding-right: 7px">
                                        <span>=</span>

                                    </td>
                                    <td style="padding-right: 7px">
                                        <dxe:ASPxTextBox ID="txtpacking" ClientInstanceName="ctxtpacking" MaxLength="50" runat="server" Width="100%">
                                            <MaskSettings Mask="<0..99999999>.<0..99>" />
                                        </dxe:ASPxTextBox>
                                    </td>
                                    <td style="padding-right: 7px">
                                        <dxe:ASPxComboBox ID="cmbPackingUom" ClientInstanceName="ccmbPackingUom" runat="server" SelectedIndex="0"
                                            ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                        </dxe:ASPxComboBox>
                                        <span id="invalidPackingUom" class="pullleftClass fa fa-exclamation-circle iconRed " style="color: red; display: none; padding-left: 9px;" title="Invalid GSTIN"></span>
                                    </td>
                                </tr>

                            </table>



                            <div style="clear: both"></div>
                            <div class="" style="margin-top: 12px">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">
                                    <button type="button" class="btn btn-primary" onclick="PackingDetailsOkClick()">Ok</button>

                                </div>
                            </div>

                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                    <ClientSideEvents Init="OnInitTax" />
                </dxe:ASPxPopupControl>
                <%--Packing Details popup end Here--%>




                <%--Service Tax popup--%>
                <dxe:ASPxPopupControl ID="ASPxPopupControl1" runat="server" ClientInstanceName="cServiceTaxPopup"
                    Width="360px" HeaderText="Service Category" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <HeaderTemplate>
                        <span>Set Service Category</span>
                        <dxe:ASPxImage ID="ASPxImage4" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                            <ClientSideEvents Click="function(s, e){ 
                                cServiceTaxPopup.Hide();
                            }" />
                        </dxe:ASPxImage>
                    </HeaderTemplate>
                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <div style="clear: both"></div>
                            <div class="cityDiv" style="height: auto;">

                                <asp:Label ID="Label4" runat="server" Text="Service Category" CssClass="newLbl"></asp:Label>
                            </div>
                            <div class="Left_Content">
                                <dxe:ASPxComboBox ID="AspxServiceTax" ClientInstanceName="cAspxServiceTax" runat="server" SelectedIndex="0" DropDownWidth="800"
                                    ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True"
                                    ValueField="TAX_ID" IncrementalFilteringMode="Contains" CallbackPageSize="30" TextFormatString="{0} {1}" ItemStyle-Wrap="True">
                                    <Columns>
                                        <dxe:ListBoxColumn FieldName="SERVICE_CATEGORY_CODE" Caption="Code" Width="45" />
                                        <dxe:ListBoxColumn FieldName="SERVICE_TAX_NAME" Caption="Name" Width="250" />
                                        <%-- <dxe:ListBoxColumn FieldName="ACCOUNT_HEAD_TAX_RECEIPTS" Caption="Receipts" Width="65" />
                                        <dxe:ListBoxColumn FieldName="ACCOUNT_HEAD_OTHERS_RECEIPTS" Caption="Oth Receipts" Width="65" />
                                        <dxe:ListBoxColumn FieldName="ACCOUNT_HEAD_PENALTIES" Caption="Penalties" Width="65" />
                                        <dxe:ListBoxColumn FieldName="ACCOUNT_HEAD_DeductRefund" Caption="A/C Head (Deduct Refund)" Width="120" />--%>
                                    </Columns>

                                </dxe:ASPxComboBox>
                            </div>



                            <div style="clear: both"></div>
                            <div class="col-md-6" style="margin-top: 25px">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">
                                    <button type="button" class="btn btn-primary" onclick="ServicetaxOkClick()">Ok</button>

                                </div>
                            </div>

                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                    <ClientSideEvents Init="OnInitTax" />
                </dxe:ASPxPopupControl>
                <%--TaxCode popup End Here--%>

                <%--Tds Section start Here--%>
                <dxe:ASPxPopupControl ID="tdsPopup" runat="server" ClientInstanceName="ctdsPopup"
                    Width="450" HeaderText="Set TDS" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <HeaderTemplate>
                        <span>Set TDS Codes</span>
                        <dxe:ASPxImage ID="ASPxImage6" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                            <ClientSideEvents Click="function(s, e){ 
                                cmb_tdstcs.SetValue(tdsValue);
                                ctdsPopup.Hide();
                            }" />
                        </dxe:ASPxImage>
                    </HeaderTemplate>
                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <div style="clear: both"></div>
                            <div class="col-md-12">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="Label15" runat="server" Text="TDS Section" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="cmb_tdstcs" ClientInstanceName="cmb_tdstcs" DataSourceID="tdstcs" Width="100%" ItemStyle-Wrap="True"
                                        ClearButton-DisplayMode="Always" runat="server" TextField="tdscode" ValueField="TDSTCS_ID">
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>

                            <div style="clear: both"></div>
                            <div class="col-md-6" style="margin-top: 25px">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">
                                    <button type="button" class="btn btn-primary" onclick="tdsOkClick()">Ok</button>

                                </div>
                            </div>

                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                    <ClientSideEvents Init="OnInitTax" />
                </dxe:ASPxPopupControl>
                <%--TDS popup End Here--%>






                <%--taxCode popup--%>
                <dxe:ASPxPopupControl ID="TaxCodePopup" runat="server" ClientInstanceName="cTaxCodePopup"
                    Width="360px" HeaderText="Set Tax Codes" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <HeaderTemplate>
                        <span>Set Tax Codes</span>
                        <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                            <ClientSideEvents Click="function(s, e){
                                cCmbTaxCodeSale.SetValue(taxCodeSale);
                                cCmbTaxCodePur.SetValue(taxCodePur);
                                 cChkAutoApply.SetChecked(autoApply);
                                cCmbTaxScheme.SetValue(taxScheme);
                                GetCheckBoxValue(autoApply);
                                cTaxCodePopup.Hide();
                            }" />
                        </dxe:ASPxImage>
                    </HeaderTemplate>
                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <div style="clear: both"></div>
                            <div class="col-md-12">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="Label9" runat="server" Text="Select Tax Code Scheme -Sales" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="CmbTaxCodeSale" ClientInstanceName="cCmbTaxCodeSale" runat="server" SelectedIndex="0"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="Label10" runat="server" Text="Select Tax Code Scheme -Purchases" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="CmbTaxCodePur" ClientInstanceName="cCmbTaxCodePur" runat="server" SelectedIndex="0"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>
                            <div style="clear: both"></div>
                            <div class="hide">
                                <div class="col-md-12">
                                    <div class="cityDiv" style="height: auto;">

                                        <asp:Label ID="Label11" runat="server" Text="Apply Auto Selection in Entries" CssClass="newLbl"></asp:Label>
                                    </div>
                                    <div class="Left_Content">
                                        <dxe:ASPxCheckBox runat="server" ID="ChkAutoApply" ClientInstanceName="cChkAutoApply">
                                            <ClientSideEvents CheckedChanged="function(s, e) { 
                                            GetCheckBoxValue(s.GetChecked()); 
                                        }" />
                                        </dxe:ASPxCheckBox>
                                    </div>
                                </div>

                                <div style="clear: both"></div>
                                <div class="col-md-12">
                                    <div class="cityDiv" style="height: auto;">

                                        <asp:Label ID="Label12" runat="server" Text="Select Tax Scheme" CssClass="newLbl"></asp:Label>
                                    </div>
                                    <div class="Left_Content">
                                        <dxe:ASPxComboBox ID="CmbTaxScheme" ClientInstanceName="cCmbTaxScheme" runat="server" SelectedIndex="0"
                                            ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                        </dxe:ASPxComboBox>
                                    </div>
                                </div>
                            </div>


                            <div style="clear: both"></div>
                            <div class="col-md-6" style="margin-top: 25px">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">
                                    <button type="button" class="btn btn-primary" onclick="taxCodeOkClick()">Ok</button>

                                </div>
                            </div>

                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                    <ClientSideEvents Init="OnInitTax" />
                </dxe:ASPxPopupControl>
                <%--TaxCode popup End Here--%>




                <%--Barcode popup--%>
                <dxe:ASPxPopupControl ID="BarCodePopUp" runat="server" ClientInstanceName="cBarCodePopUp"
                    Width="360px" HeaderText="Set Barcode" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <HeaderTemplate>
                        <span>Set Barcode</span>
                        <dxe:ASPxImage ID="ASPxImage2" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                            <ClientSideEvents Click="function(s, e){
                                cCmbBarCodeType.SetSelectedIndex(barCodeType);
                                ctxtBarCodeNo.SetText(BarCode);
                                ctxtGlobalCode.SetText(GlobalCode);
                                cBarCodePopUp.Hide();
                            }" />
                        </dxe:ASPxImage>
                    </HeaderTemplate>

                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <div style="clear: both"></div>
                            <div class="col-md-12">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="lblBarCodeType" runat="server" Text="Barcode Type" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="CmbBarCodeType" ClientInstanceName="cCmbBarCodeType" runat="server" SelectedIndex="0" TabIndex="6" ClearButton-DisplayMode="Always"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="lblBarcodeNo" runat="server" Text="Barcode No." CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxTextBox ID="txtBarCodeNo" ClientInstanceName="ctxtBarCodeNo" MaxLength="50" TabIndex="7"
                                        runat="server" Width="100%">
                                    </dxe:ASPxTextBox>
                                </div>
                            </div>

                            <div style="clear: both"></div>

                            <div class="col-md-12">
                                <div class="cityDiv" style="height: auto;">
                                    <%--Global Code--%>
                                    <asp:Label ID="LblGlobalCode" runat="server" Text="Global Code(UPC)" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxTextBox ID="txtGlobalCode" ClientInstanceName="ctxtGlobalCode" MaxLength="30" TabIndex="8"
                                        runat="server" Width="100%" Text='<%# Bind("txtMarkets_Description") %>'>
                                    </dxe:ASPxTextBox>
                                </div>
                            </div>

                            <div style="clear: both"></div>
                            <div class="col-md-6" style="margin-top: 25px">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">
                                    <button type="button" class="btn btn-primary" onclick="BarCodeOkClick()">Ok</button>

                                </div>
                            </div>
                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                    <ClientSideEvents Init="OnInitBarCode" />
                </dxe:ASPxPopupControl>
                <%--Barcode popup End Here--%>
                <%--Product Attribute popup 
            added by debjyoti 04-01-2017--%>
                <dxe:ASPxPopupControl ID="productAttributePopUp" runat="server" ClientInstanceName="cproductAttributePopUp"
                    Width="550px" HeaderText="Set Product Attribute(s)" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">

                    <HeaderTemplate>
                        <span>Set Product Attribute(s)</span>
                        <dxe:ASPxImage ID="img" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                            <ClientSideEvents Click="function(s, e){
                                cCmbProductSize.SetValue(ProdSize);
                                cCmbProductColor.SetValue(ProdColor);
                                 RrdblappColor.SetSelectedIndex(ColApp);
                                Rrdblapp.SetSelectedIndex(SizeApp);
                                cproductAttributePopUp.Hide();
                            }" />
                        </dxe:ASPxImage>
                    </HeaderTemplate>

                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <div class="col-md-6" style="display:none;">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="LblProductColor" runat="server" Text="Product Color" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="CmbProductColor" ClientInstanceName="cCmbProductColor" ClearButton-DisplayMode="Always" runat="server" TabIndex="16"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>


                            <div class="col-md-6" style="margin-top: 25px;display:none;">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">

                                    <dxe:ASPxRadioButtonList ID="rdblappColor" ClientInstanceName="RrdblappColor" runat="server" RepeatDirection="Horizontal" Width="100%" TabIndex="17">
                                        <Items>
                                            <dxe:ListEditItem Text="Applicable" Value="1" Selected="true" />
                                            <dxe:ListEditItem Text="Not Applicable" Value="0" />

                                        </Items>
                                    </dxe:ASPxRadioButtonList>
                                </div>
                            </div>

                            <div style="clear: both"></div>

                            <div class="col-md-6" >
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="LblProductSize" runat="server" Text="Product Strength" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="CmbProductSize" ClientInstanceName="cCmbProductSize" ClearButton-DisplayMode="Always" runat="server" TabIndex="18"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>
                            <div class="col-md-6" style="margin-top: 25px;display:none;">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">

                                    <dxe:ASPxRadioButtonList ID="rdblapp" ClientInstanceName="Rrdblapp" runat="server" RepeatDirection="Horizontal" Width="100%" TabIndex="19">
                                        <Items>
                                            <dxe:ListEditItem Text="Applicable" Value="1" Selected="true" />
                                            <dxe:ListEditItem Text="Not Applicable" Value="0" />

                                        </Items>
                                    </dxe:ASPxRadioButtonList>
                                </div>
                            </div>

                            <%--Product Component--%>
                            <div class="clear"></div>
                            <div class="col-md-6" style="margin-top: 7px;display:none;">
                                <div class="cityDiv" style="height: auto; margin-bottom: 5px;">
                                    Components
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxCallbackPanel runat="server" ID="ComponentPanel" ClientInstanceName="cComponentPanel" OnCallback="Component_Callback">
                                        <PanelCollection>
                                            <dxe:PanelContent runat="server">


                                                <dxe:ASPxGridLookup ID="GridLookup" runat="server" SelectionMode="Multiple" DataSourceID="ProductDataSource" ClientInstanceName="gridLookup"
                                                    KeyFieldName="sProducts_ID" Width="100%" TextFormatString="{0}" MultiTextSeparator=", ">
                                                    <Columns>
                                                        <dxe:GridViewCommandColumn ShowSelectCheckbox="True" Width="60" Caption=" " />
                                                        <dxe:GridViewDataColumn FieldName="sProducts_Code" Caption="Product Code" Width="150" />
                                                        <dxe:GridViewDataColumn FieldName="sProducts_Name" Caption="Product Name" Width="300" />
                                                    </Columns>
                                                    <%--<GridViewProperties  Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords"   >--%>
                                                    <GridViewProperties Settings-VerticalScrollBarMode="Auto">

                                                        <Templates>
                                                            <StatusBar>
                                                                <table class="OptionsTable" style="float: right">
                                                                    <tr>
                                                                        <td>
                                                                            <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridLookup" />
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
                                        <ClientSideEvents EndCallback="componentEndCallBack" />
                                    </dxe:ASPxCallbackPanel>
                                </div>
                            </div>





                            <%--Installation Required--%>
                            <div class="col-md-6"  style="display:none;">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="Label8" runat="server" Text="Installation Required" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="aspxInstallation" ClientInstanceName="caspxInstallation" runat="server" TabIndex="16"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="1">
                                        <Items>
                                            <dxe:ListEditItem Text="Yes" Value="1" />
                                            <dxe:ListEditItem Text="No" Value="0" />
                                        </Items>
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>

                            <div style="clear: both"></div>





                            <%--Brand --%>
                            <div class="col-md-6">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="Label13" runat="server" Text="Brand" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="cmbBrand" ClientInstanceName="ccmbBrand" ClearButton-DisplayMode="Always" runat="server" TabIndex="16"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="1">
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>


                            <div class="col-md-6"  style="display:none;">
                                <div class="cityDiv" style="height: auto;">

                                    <asp:Label ID="Label16" runat="server" Text="Old Unit?" CssClass="newLbl"></asp:Label>
                                </div>
                                <div class="Left_Content">
                                    <dxe:ASPxComboBox ID="cmbOldUnit" ClientInstanceName="ccmbOldUnit" runat="server" TabIndex="16"
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="1">
                                        <Items>
                                            <dxe:ListEditItem Text="Yes" Value="1" />
                                            <dxe:ListEditItem Text="No" Value="0" />
                                        </Items>
                                    </dxe:ASPxComboBox>
                                </div>
                            </div>





                            <div style="clear: both"></div>


                            <div class="col-md-6" style="margin-top: 25px">
                                <div class="cityDiv" style="height: auto;">
                                </div>
                                <div class="Left_Content">
                                    <button class="btn btn-primary" type="button" onclick="productAttributeOkClik()">Ok</button>

                                </div>
                            </div>

                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                    <ClientSideEvents Init="OnInitProductAttribute" />
                </dxe:ASPxPopupControl>














                <dxe:ASPxPopupControl ID="Popup_Empcitys" runat="server" ClientInstanceName="cPopup_Empcitys"
                    Width="700px" HeaderText="Add/Modify products" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                    PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <%--<div style="Width:400px;background-color:#FFFFFF;margin:0px;border:1px solid red;">--%>
                            <div class="ProductMainContaint">

                                <div class="row ">
                                    <div class="col-md-12 ">
                                        <div class="col-md-12 clearfix" style="padding: 0">
                                            <div class="col-md-6">
                                                <div class="cityDiv" style="height: auto; margin-bottom: 5px;">
                                                    <%--Code--%>
                                            Short Name (Unique)
                                           <%-- <asp:Label ID="LblCode" runat="server" Text="Short Name (Unique)" CssClass="newLbl"></asp:Label>--%><span style="color: red;"> *</span>

                                                </div>
                                                <div class="Left_Content">
                                                    <dxe:ASPxTextBox ID="txtPro_Code" MaxLength="80" ClientInstanceName="ctxtPro_Code" TabIndex="1"
                                                        runat="server" Width="100%" CssClass="upper">
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="product" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                            <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                            <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                        </ValidationSettings>
                                                        <ClientSideEvents TextChanged="function(s,e){fn_ctxtPro_Name_TextChanged()}" />

                                                    </dxe:ASPxTextBox>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="cityDiv" style="height: auto; margin-bottom: 5px;">
                                                    Name<span style="color: red;">*</span>
                                                    <%--<asp:Label ID="LblName" runat="server" Text="Name" CssClass="newLbl"></asp:Label>--%>
                                                </div>
                                                <div class="Left_Content" style="">
                                                    <dxe:ASPxTextBox ID="txtPro_Name" ClientInstanceName="ctxtPro_Name" runat="server" MaxLength="100" TabIndex="2"
                                                        Width="100%" CssClass="upper">
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="product" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                            <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                            <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                        </ValidationSettings>
                                                        <%--<ClientSideEvents TextChanged="function(s,e){fn_ctxtPro_Name_TextChanged()}" />--%>
                                                    </dxe:ASPxTextBox>
                                                </div>
                                            </div>

                                            <%--place here--%>
                                            <div class="col-md-4" style="display:none;">
                                                <div class="cityDiv" style="height: auto;">
                                                    <%--Inventory Item--%>
                                                    <asp:Label ID="Label2" runat="server" Text="Inventory Item?" CssClass="newLbl"></asp:Label>
                                                </div>
                                                <div class="Left_Content">
                                                    <dxe:ASPxComboBox ID="cmbIsInventory" ClientInstanceName="ccmbIsInventory" runat="server" TabIndex="4"
                                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                        <Items>
                                                            <dxe:ListEditItem Text="Yes" Value="1" />
                                                            <dxe:ListEditItem Text="No" Value="0" />
                                                        </Items>

                                                        <ClientSideEvents SelectedIndexChanged="isInventoryChanged" />
                                                    </dxe:ASPxComboBox>
                                                </div>
                                            </div>
                                                <div class="col-md-4" style="display:none;">
                                                <div class="cityDiv" style="height: auto;">
                                                    <asp:Label ID="Label22" runat="server" Text="Service Item?" CssClass="newLbl"></asp:Label>
                                                </div>
                                                <div class="Left_Content">
                                                    <dxe:ASPxComboBox ID="cmbServiceItem" ClientInstanceName="ccmbServiceItem" runat="server" TabIndex="5"
                                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                        <Items>
                                                            <dxe:ListEditItem Text="No" Value="0" />
                                                            <dxe:ListEditItem Text="Yes" Value="1" />

                                                        </Items>


                                                    </dxe:ASPxComboBox>
                                                </div>
                                            </div>
                                            <div class="col-md-4" style="display:none;">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Inventory Item--%>
                                            <asp:Label ID="Label14" runat="server" Text="Capital Goods?" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="cmbIsCapitalGoods" ClientInstanceName="ccmbIsCapitalGoods" runat="server" TabIndex="8"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="1">
                                                <Items>
                                                    <dxe:ListEditItem Text="Yes" Value="1" />
                                                    <dxe:ListEditItem Text="No" Value="0" />
                                                </Items>

                                                <ClientSideEvents SelectedIndexChanged="isCapitalChanged" />
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>

                                        </div>

                                        


                                        <div class="col-md-12">
                                            <div class="cityDiv" style="height: auto; margin-top: -5px;">
                                                <%--Description--%>
                                                <asp:Label ID="LblDecs" runat="server" Text="Description" CssClass="newLbl"></asp:Label>
                                            </div>
                                            <div class="Left_Content">
                                                <dxe:ASPxMemo ID="txtPro_Description" ClientInstanceName="ctxtPro_Description" MaxLength="300" TabIndex="3"
                                                    runat="server" Width="100%" Height="60px" Text='<%# Bind("txtMarkets_Description") %>' CssClass="upper">
                                                </dxe:ASPxMemo>
                                            </div>
                                        </div>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="col-md-4" style="display: none">
                                        <div class="">

                                            <div class="imageArea" style="height: auto; margin-bottom: 5px;">
                                                <dxe:ASPxImage ID="ProdImage" runat="server" ClientInstanceName="cProdImage" CssClass="myImage">
                                                </dxe:ASPxImage>
                                            </div>


                                            <div class="Left_Content">
                                                <%--<dxe:ASPxCallbackPanel  ID="ASPxCallback1" runat="server" ClientInstanceName="Callback1" OnCallback="ASPxCallback1_Callback">
                                            <PanelCollection>
                                                  <dxe:PanelContent ID="PanelContent3" runat="server">
                                                         <button type="button" onclick="uploadClick()">Upload</button>
                                                       <asp:FileUpload ID="FileUpload1" runat="server"></asp:FileUpload>
                                                   
                                                      </dxe:PanelContent>
                                                </PanelCollection>
                                            </dxe:ASPxCallbackPanel>--%>

                                                <dxe:ASPxUploadControl ID="ASPxUploadControl1" runat="server" ClientInstanceName="upload1" OnFileUploadComplete="ASPxUploadControl1_FileUploadComplete"
                                                    ShowProgressPanel="True" CssClass="pull-left">
                                                    <ValidationSettings MaxFileSize="2194304" AllowedFileExtensions=".jpg, .jpeg, .gif, .png" ErrorStyle-CssClass="validationMessage" />
                                                    <ClientSideEvents FileUploadComplete="function(s, e) { OnUploadComplete(e); }" />
                                                </dxe:ASPxUploadControl>
                                                <dxe:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Upload" ClientInstanceName="btnUpload" CssClass="pull-right btn btn-primary btn-small blll hide">
                                                    <ClientSideEvents Click="function(s, e) {
                                                     upload1.Upload(); 
                                                    }"></ClientSideEvents>
                                                </dxe:ASPxButton>

                                                <asp:HiddenField runat="server" ID="fileName" />

                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="Top">


                                    <%--Product Image--%>


                                    <%--Product Image--%>

                                     <div class="boxarea clearfix">
                                       <span class="boxareaH">Miscellaneous</span>
                                   

                                    <%--<div class="clear"></div>--%>
                                    <%--End of Inventory Type--%>

                                    <div class="col-md-6">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Product Class Code--%>
                                            <asp:Label ID="LblPCcode" runat="server" Text="Class Name" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbProClassCode" ClientInstanceName="cCmbProClassCode" runat="server" SelectedIndex="0" TabIndex="9" ClearButton-DisplayMode="Always"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <ClientSideEvents SelectedIndexChanged="CmbProClassCodeChanged" />
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Product Class Code--%>
                                            <asp:Label ID="Label1" runat="server" Text="Status" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbStatus" ClientInstanceName="cCmbStatus" runat="server" SelectedIndex="0" TabIndex="10"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                                <Items>
                                                    <dxe:ListEditItem Text="Active" Value="A" />
                                                    <dxe:ListEditItem Text="Dormant" Value="D" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>

                                    <div class="col-md-3" style="display:none;">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Product Class Code--%>
                                            <asp:Label ID="Label7" runat="server" Text="HSN Code" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <div style="display: none">
                                                <dxe:ASPxTextBox ID="txtHsnCode" ClientInstanceName="ctxtHsnCode" MaxLength="10" TabIndex="11"
                                                    runat="server" Width="100%" Text='<%# Bind("txtMarkets_Description") %>'>
                                                    <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <%--<dxe:ASPxComboBox ID="aspxHsnCode" ClientInstanceName="caspxHsnCode" runat="server" Width="100%"  ValueType="System.String" AutoPostBack="false" 
                                          ItemStyle-Wrap="True" ClearButton-DisplayMode="Always"  EnableCallbackMode="true"  >                         
                                        </dxe:ASPxComboBox>--%>

                                            <dxe:ASPxCallbackPanel runat="server" ID="SetHSnPanel" ClientInstanceName="cSetHSnPanel" OnCallback="SetHSnPanel_Callback">
                                                <PanelCollection>
                                                    <dxe:PanelContent runat="server">






                                                        <dxe:ASPxGridLookup ID="HsnLookUp" runat="server" DataSourceID="HsnDataSource" ClientInstanceName="cHsnLookUp" TabIndex="12"
                                                            KeyFieldName="Code" Width="100%" TextFormatString="{0}" MultiTextSeparator=", ">
                                                            <Columns>
                                                                <dxe:GridViewDataColumn FieldName="Code" Caption="Code" Width="50" />
                                                                <dxe:GridViewDataColumn FieldName="Description" Caption="Description" Width="350" />
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
                                                <ClientSideEvents EndCallback="SetHSnPanelEndCallBack" />
                                            </dxe:ASPxCallbackPanel>



                                        </div>
                                    </div>

                                    <div class="col-md-3" style="display:none;">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label21" runat="server" Text="Furtherance to Business" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxCheckBox ID="chkFurtherance" ClientInstanceName="cchkFurtherance" runat="server" TabIndex="13">
                                            </dxe:ASPxCheckBox>
                                        </div>
                                    </div>


                                         </div>



                                    <div class="clear"></div>
                                    <div class="col-md-3" style="display: none">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Quote Currency--%>
                                            <asp:Label ID="LblQCurrency" runat="server" Text="Quote Currency" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbQuoteCurrency" ClientInstanceName="cCmbQuoteCurrency" runat="server" SelectedIndex="0" TabIndex="14" ClearButton-DisplayMode="Always"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>



                                    <div class="col-md-3" style="display: none">
                                        <div class="cityDiv lblmTop8" style="height: auto; margin-bottom: 5px;">
                                            <span>UOM Factor <span style="color: red;">*</span></span>
                                            <%--<asp:Label ID="LblQLot" runat="server" Text="Quote Lot" CssClass="newLbl"></asp:Label>--%>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtQuoteLot" ClientInstanceName="ctxtQuoteLot" MaxLength="8" TabIndex="15"
                                                runat="server" Width="100%" Text='<%# Bind("txtMarkets_Description") %>'>

                                                <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-3" style="display: none">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Quote Lot Unit<span style="color:red;"> *</span>--%>
                                            <span class="newLbl">Quote UOM<span style="color: red;"> *</span></span>
                                            <%--<asp:Label ID="LblQLotUnit" runat="server" Text="Quote Lot unit" CssClass="newLbl"></asp:Label>--%>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbQuoteLotUnit" ClientInstanceName="cCmbQuoteLotUnit" runat="server" TabIndex="16" ClearButton-DisplayMode="Always"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                              

                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>







                                    <div class="col-md-3" style="display: none">
                                        <div class="cityDiv" style="height: auto;">
                                            <span class="newLbl">Sale UOM Factor<span style="color: red;"> *</span></span>
                                            <%--<asp:Label ID="LblTradingLot" runat="server" Text="Trading Lot" CssClass="newLbl"></asp:Label>--%>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtTradingLot" ClientInstanceName="ctxtTradingLot" MaxLength="8" TabIndex="17"
                                                runat="server" Width="100%" Text='<%# Bind("txtMarkets_Description") %>'>

                                                <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>


                                    <div class="col-md-6" style="padding: 0px !important;">

                                    <div class="boxarea clearfix">
                                        <span class="boxareaH">Sales</span>

                                    
                                   
                                    <div class="col-md-12">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Trading Lot Units--%>
                                            <%--<asp:Label ID="LblTLotUnit" runat="server" Text="Trading Lot Units" CssClass="newLbl"></asp:Label>--%>
                                            <span class="newLbl">Unit<span style="color: red;"> *</span></span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbTradingLotUnits" ClientInstanceName="cCmbTradingLotUnits" runat="server" TabIndex="18" ClearButton-DisplayMode="Always"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="product" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                </ValidationSettings>
                                              
                                                <ClientSideEvents LostFocus="cCmbTradingLotUnitsLostFocus" SelectedIndexChanged="cCmbTradingLotUnitsLostFocus" />
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>

                                    <%--Debjyoti Sale price & min sale price--%>

                                    <div class="col-md-12" style="display:none;">
                                        <div class="cityDiv" style="height: auto;">
                                            <span class="newLbl">Sell @</span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtSalePrice" ClientInstanceName="ctxtSalePrice" MaxLength="18" TabIndex="19" DisplayFormatString="{0:0.00}"
                                                runat="server" Width="100%">

                                                <MaskSettings Mask="<0..99999999>.<0..99>" />

                                                <%-- <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />--%>
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-3" style="display:none;" >
                                        <div class="cityDiv" style="height: auto;">
                                            <span class="newLbl">Minimum Sell @</span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtMinSalePrice" ClientInstanceName="ctxtMinSalePrice" MaxLength="18" TabIndex="20" DisplayFormatString="{0:0.00}"
                                                runat="server" Width="100%">
                                                <MaskSettings Mask="<0..99999999>.<0..99>" />
                                                <%--<ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />--%>
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-3" style="display:none;">
                                        <div class="cityDiv" style="height: auto;">
                                            <span class="newLbl">MRP </span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtMrp" ClientInstanceName="ctxtMrp" MaxLength="18" TabIndex="21" DisplayFormatString="{0:0.00}"
                                                runat="server" Width="100%">
                                                <MaskSettings Mask="<0..99999999>.<0..99>" />
                                                <%-- <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />--%>
                                            </dxe:ASPxTextBox>
                                            <span id="mrpError" class="pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; right: -2px; top: 27px; display: none" title="Must be greater than Min Sale Price"></span>
                                        </div>
                                    </div>

                                    </div>

                                   </div>

                                    <%--End here--%>
                                    <%--<div class="clear"></div>--%>
                                      <div class="col-md-6" style="padding: 0px !important;">
                                    <div class="boxarea clearfix">
                                        <span class="boxareaH">Purchases</span>
                                    <div class="col-md-12" style="display: none">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Purchase UOM <span style="color:red;"> *</span>--%>
                                            <span class="newLbl">Purchase UOM Factor<span style="color: red;"> *</span></span>
                                            <%--<asp:Label ID="LblDeliveryLot" runat="server" Text="Delivery Lot" CssClass="newLbl"></asp:Label>--%>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtDeliveryLot" ClientInstanceName="ctxtDeliveryLot" MaxLength="8" TabIndex="22"
                                                runat="server" Width="100%" Text='<%# Bind("txtMarkets_Description") %>'>

                                                <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>

                                    <div class="col-md-12">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Delivery Lot Unit--%>
                                            <%--<asp:Label ID="LblDeliveryLotUnit" runat="server" Text="Delivery Lot Unit" CssClass="newLbl"></asp:Label>--%>

                                            <span class="newLbl">Unit<span style="color: red;"> *</span></span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbDeliveryLotUnit" ClientInstanceName="cCmbDeliveryLotUnit" runat="server" TabIndex="23" ClearButton-DisplayMode="Always"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="product" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                </ValidationSettings>
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>



                                    <%--Debjyoti Purchase price & MRP--%>

                                    <div class="col-md-3" style="display:none;">
                                        <div class="cityDiv" style="height: auto;">
                                            <span class="newLbl">Buy @</span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtPurPrice" ClientInstanceName="ctxtPurPrice" MaxLength="18" TabIndex="24" DisplayFormatString="{0:0.00}"
                                                runat="server" Width="100%">
                                                <MaskSettings Mask="<0..99999999>.<0..99>" />
                                                <%--  <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />--%>
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>
                                   </div>
                                    </div>



                                    <div class="clear"></div>
                                    <div class="col-md-6"  style="padding: 0px !important;display:none;"> 
                                      <div class="boxarea clearfix">
                                        <span class="boxareaH">Inventory</span>
                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <span class="newLbl">Min Level        </span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtMinLvl" ClientInstanceName="ctxtMinLvl" MaxLength="18" TabIndex="26" DisplayFormatString="{0:0.00}"
                                                runat="server" Width="100%">
                                                <MaskSettings Mask="<0..99999999>.<0..99>" />
                                                <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>


                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label5" runat="server" Text="Reorder Level" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtReorderLvl" ClientInstanceName="ctxtReorderLvl" MaxLength="18" TabIndex="27" DisplayFormatString="{0:0.00}"
                                                runat="server" Width="100%">
                                                <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                <%--<MaskSettings Mask="&lt;0..9999999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />--%>
                                                <MaskSettings Mask="<0..99999999>.<0..99>" />
                                            </dxe:ASPxTextBox>
                                            <span id="reOrderError" class="pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; right: -6px; top: 29px; display: none" title="Must be greater than Min level"></span>
                                        </div>
                                    </div>

                                     <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label23" runat="server" Text="Reorder Quantity" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxTextBox ID="txtReorderQty" ClientInstanceName="ctxtReorderQty" MaxLength="18" TabIndex="28" DisplayFormatString="{0:0.0000}"
                                                runat="server" Width="100%">
                                                <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                <%--<MaskSettings Mask="&lt;0..9999999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />--%>
                                                <MaskSettings Mask="&lt;0..9999999999g&gt;.&lt;00..9999&gt;" />
                                            </dxe:ASPxTextBox>
                                            <span id="reOrderQuantityError" class="pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; right: -6px; top: 29px; display: none" title="Must be greater than Min level"></span>
                                        </div>
                                    </div>

 

                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label6" runat="server" Text="Negative Stock" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="cmbNegativeStk" ClientInstanceName="ccmbNegativeStk" runat="server" TabIndex="29"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                <Items>
                                                    <dxe:ListEditItem Text="Warn" Value="W" />
                                                    <dxe:ListEditItem Text="Ignore" Value="I" />
                                                    <dxe:ListEditItem Text="Block" Value="B" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>


                                    <div class="clear"></div>

                                           <%--Debjyoti Add Inventory Type--%>
                                          
                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Type--%>
                                            <asp:Label ID="LblType" runat="server" Text="Type" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbProType" ClientInstanceName="cCmbProType" runat="server" TabIndex="29" ClearButton-DisplayMode="Always"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>

                                    <%--End of Inventory Type--%>
                                    <%--Debjyoti Stock Valuation Tech.--%>
                                    <div class="col-md-4">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--Inventory Item--%>
                                            <asp:Label ID="Label3" runat="server" Text="Stock Valuation Tech." CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="CmbStockValuation" ClientInstanceName="cCmbStockValuation" runat="server" TabIndex="29"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="1">
                                                <Items>
                                                    <dxe:ListEditItem Text="Average" Value="A" />
                                                    <dxe:ListEditItem Text="LIFO" Value="L" />
                                                    <dxe:ListEditItem Text="FIFO" Value="F" />
                                                    <%--<dxe:ListEditItem Text="RATED" Value="R" />--%>
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <%--  <asp:Label ID="Label4" runat="server" Text="Stock UOM" CssClass="newLbl"></asp:Label>--%>
                                            <span class="newLbl">Stock Unit<span style="color: red;"> *</span></span>
                                        </div>
                                        <div class="Left_Content">
                                            <dxe:ASPxComboBox ID="cmbStockUom" ClientInstanceName="ccmbStockUom" runat="server" TabIndex="29" ClearButton-DisplayMode="Always"
                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="product" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                </ValidationSettings>
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                   

                                          </div>
                                    <%--End here--%>
                                    </div>
                                    <div class="col-md-6"  style="padding: 0px !important;display:none;"> 

                                   <%-- <div style="clear: both"></div>--%>
                                    <div class="boxarea clearfix">
                                        <span class="boxareaH">Ledger Mapping</span>
                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label17" runat="server" Text="Sales" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <div class="Left_Content">

                                            <dxe:ASPxButtonEdit ID="SIMainAccount" runat="server" ReadOnly="true" ClientInstanceName="cSIMainAccount" Width="100%" TabIndex="30">
                                                <Buttons>
                                                    <dxe:EditButton>
                                                    </dxe:EditButton>
                                                </Buttons>
                                                <ClientSideEvents ButtonClick="MainAccountButnClick" KeyDown="MainAccountKeyDown" />
                                            </dxe:ASPxButtonEdit>
                                            <%--<dxe:ASPxComboBox ID="cmbsalesInvoice" ClientInstanceName="ccmbsalesInvoice" runat="server" TabIndex="25"
                                            ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                            <ClientSideEvents SelectedIndexChanged="mainAccountSalesInvoice" GotFocus="cmbsalesInvoiceGotFocus" />
                                        </dxe:ASPxComboBox>--%>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label18" runat="server" Text="Sales Return" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <dxe:ASPxButtonEdit ID="SRMainAccount" runat="server" ReadOnly="true" ClientInstanceName="cSRMainAccount" Width="100%" TabIndex="31">
                                            <Buttons>
                                                <dxe:EditButton>
                                                </dxe:EditButton>
                                            </Buttons>
                                            <ClientSideEvents ButtonClick="SRMainAccountButnClick" KeyDown="MainAccountKeyDown" />
                                        </dxe:ASPxButtonEdit>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label19" runat="server" Text="Purchase" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <dxe:ASPxButtonEdit ID="PIMainAccount" runat="server" ReadOnly="true" ClientInstanceName="cPIMainAccount" Width="100%" TabIndex="32">
                                            <Buttons>
                                                <dxe:EditButton>
                                                </dxe:EditButton>
                                            </Buttons>
                                            <ClientSideEvents ButtonClick="PIMainAccountButnClick" KeyDown="MainAccountKeyDown" />
                                        </dxe:ASPxButtonEdit>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                            <asp:Label ID="Label20" runat="server" Text="Purchase Return" CssClass="newLbl"></asp:Label>
                                        </div>
                                        <dxe:ASPxButtonEdit ID="PRMainAccount" runat="server" ReadOnly="true" ClientInstanceName="cPRMainAccount" Width="100%" TabIndex="33">
                                            <Buttons>
                                                <dxe:EditButton>
                                                </dxe:EditButton>
                                            </Buttons>
                                            <ClientSideEvents ButtonClick="PRMainAccountButnClick" KeyDown="MainAccountKeyDown" />
                                        </dxe:ASPxButtonEdit>
                                    </div>

                                    </div>
                                    </div>
                                    <div style="clear: both"></div>

                                    <%--Code commented and added by debjyoti--%>
                                    <%--Reason: Product attribute now showing on popup--%>
                                    <div class="col-md-12">
                                        <div class="cityDiv" style="height: auto;">

                                            <%--<asp:Label ID="Label1" runat="server" Text="(s)" CssClass="newLbl"></asp:Label>--%>
                                        </div>
                                        <div class="Left_Content" style="padding-top: 10px">
                                            <button type="button" class="btn btn-info btn-small" onclick="ShowProductAttribute()" tabindex="34" id="btnProdConfig">Configure Product Attribute</button>
                                            <button type="button" class="btn btn-info btn-small" onclick="ShowBarCode()" tabindex="35" id="btnBarCodeConfig" style="display: none">Configure Barcode</button>
                                            <button type="button" class="btn btn-info btn-small" onclick="ShowTaxCode()" tabindex="36" style="display: none">Configure Tax</button>
                                            <button type="button" class="btn btn-info btn-small" onclick="ShowServiceTax()" tabindex="37" id="btnServiceTaxConfig" style="display: none">Configure Service Category</button>
                                            <button type="button" class="btn btn-info btn-small" onclick="ShowPackingDetails()" tabindex="38" id="btnPackingConfig" style="display: none">Configure Packing Details</button>
                                            <button type="button" class="btn btn-info btn-small" onclick="ShowTdsSection()" tabindex="39" id="btnTDS" style="display: none">Configure TDS Section</button>
                                        </div>
                                    </div>


                                    <div class="col-md-2">
                                        <div class="cityDiv" style="height: auto;">

                                            <%--<asp:Label ID="Label7" runat="server" Text="Bar Code" CssClass="newLbl"></asp:Label>--%>
                                        </div>
                                        <div class="Left_Content" style="padding-top: 10px">
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="cityDiv" style="height: auto;">

                                            <%--<asp:Label ID="Label8" runat="server" Text="Tax Codes" CssClass="newLbl"></asp:Label>--%>
                                        </div>
                                        <div class="Left_Content" style="padding-top: 10px">
                                        </div>
                                    </div>

                                    <div class="col-md-2">
                                        <div class="cityDiv" style="height: auto;">
                                        </div>
                                        <div class="Left_Content" style="padding-top: 10px">
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="cityDiv" style="height: auto;">
                                        </div>
                                        <div class="Left_Content" style="padding-top: 10px">
                                        </div>
                                    </div>


                    
                                </div>
                                <div class="ContentDiv" style="height: auto">
                                    <div style="display: none">
                                        <div style="height: 20px; width: 280px; background-color: Gray; padding-left: 120px;">
                                            <h5>Static Code</h5>
                                        </div>
                                        <div style="height: 20px; width: 130px; padding-left: 70px; background-color: Gray; float: left;">
                                            Exchange
                                        </div>
                                        <div style="height: 20px; width: 200px; background-color: Gray; text-align: left;">
                                            Value
                                        </div>
                                        <div class="ScrollDiv">
                                            <div class="cityDiv" style="padding-top: 5px;">
                                                NSE Code
                                            </div>
                                            <div style="padding-top: 5px;">
                                                <dxe:ASPxTextBox ID="txtNseCode" ClientInstanceName="ctxtNseCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                BSE Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtBseCode" ClientInstanceName="ctxtBseCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                MCX Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtMcxCode" ClientInstanceName="ctxtMcxCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                MCXSX Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtMcsxCode" ClientInstanceName="ctxtMcsxCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                NCDEX Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtNcdexCode" ClientInstanceName="ctxtNcdexCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                CDSL Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtCdslCode" ClientInstanceName="ctxtCdslCode" CssClass="cityTextbox"
                                                    runat="server">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                NSDL Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtNsdlCode" ClientInstanceName="ctxtNsdlCode" CssClass="cityTextbox"
                                                    runat="server">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                NDML Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtNdmlCode" ClientInstanceName="ctxtNdmlCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                CVL Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtCvlCode" ClientInstanceName="ctxtCvlCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <br style="clear: both;" />
                                            <div class="cityDiv">
                                                DOTEX Code
                                            </div>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtDotexCode" ClientInstanceName="ctxtDotexCode" runat="server"
                                                    CssClass="cityTextbox">
                                                </dxe:ASPxTextBox>
                                            </div>
                                        </div>
                                    </div>

                                    <br style="clear: both;" />
                                    <div class="col-md-12"></div>
                                    <div class="Footer clearfix" style="padding-left: 16px">


                                        <dxe:ASPxButton ID="btnSave_citys" CausesValidation="true" ClientInstanceName="cbtnSave_citys" runat="server" ValidationGroup="product" EncodeHtml="false"
                                            AutoPostBack="False" Text="<u>S</u>ave" CssClass="btn btn-primary" TabIndex="26">
                                            <ClientSideEvents Click="function (s, e) {btnSave_citys();}" />
                                        </dxe:ASPxButton>


                                        <dxe:ASPxButton ID="btnCancel_citys" runat="server" AutoPostBack="False" Text="<u>C</u>ancel" CssClass="btn btn-danger" TabIndex="27" EncodeHtml="false">
                                            <ClientSideEvents Click="function (s, e) {fn_btnCancel();}" />
                                        </dxe:ASPxButton>
                                        <asp:Button ID="btnUdf" runat="server" Text="UDF" CssClass="btn btn-primary dxbButton" Visible="false"  OnClientClick="if(OpenUdf()){ return false;}" />
                                        <input type="button" value="Assing Values" style="display: none;" onclick="fetchLebel()" class="btn btn-primary"/
                                            >

                                        <br style="clear: both;" />
                                    </div>
                                    <br style="clear: both;" />
                                </div>
                                <%-- </div>--%>
                            </div>
                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <ContentStyle VerticalAlign="Top" CssClass="pad"></ContentStyle>

                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />

                </dxe:ASPxPopupControl>
                <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="true" PaperKind="A3" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
                </dxe:ASPxGridViewExporter>
            </div>
            <div class="HiddenFieldArea" style="display: none;">
                <asp:HiddenField runat="server" ID="hiddenedit" />
            </div>
        </div>


        <dxe:ASPxPopupControl ID="AssignValuePopup" runat="server" ClientInstanceName="AssignValuePopup"
            Width="200px" HeaderText="Add / Edit Key Value" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">
            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl ID="AssignValuePopupContent" runat="server">
                    <div id="generatedForm">
                    </div>
                    <div id="SubmitFrm">

                        <asp:TextBox ID="KeyField" runat="server" Style="display: none;"></asp:TextBox>
                        <asp:TextBox ID="ValueField" runat="server" Style="display: none;"></asp:TextBox>
                        <asp:TextBox ID="RexPageName" runat="server" Style="display: none;"></asp:TextBox>


                        <asp:Button ID="Button1" runat="server" Text="Save" CssClass="btn btn-primary" OnClientClick="return SaveDataToResource()" OnClick="BTNSave_clicked" Style="margin-left: 155px;" />

                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <HeaderStyle BackColor="LightGray" ForeColor="Black" />
        </dxe:ASPxPopupControl>

        <asp:SqlDataSource ID="ProductDataSource" runat="server"
            SelectCommand="select sProducts_ID,sProducts_Code,sProducts_Name from Master_sProducts"></asp:SqlDataSource>
        <asp:SqlDataSource ID="HsnDataSource" runat="server"
            SelectCommand="select * from tbl_HSN_Master"></asp:SqlDataSource>
        <asp:SqlDataSource ID="tdstcs" runat="server" 
            SelectCommand="Select  TDSTCS_ID,ltrim(rtrim(tdstcs_description))+' ['+ltrim(rtrim(tdstcs_code))+']' as tdsdescription ,ltrim(rtrim(tdstcs_code)) tdscode  from master_tdstcs "></asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlClassSource" runat="server" 
            SelectCommand="select ProductClass_Name from Master_ProductClass order by ProductClass_Name"></asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlHSNDataSource" runat="server" 
            SelectCommand="select distinct sProducts_HsnCode Code  from master_sproducts where sProducts_HsnCode<>''  union all select  distinct SERVICE_CATEGORY_CODE   from Master_sProducts MP inner join TBL_MASTER_SERVICE_TAX sac on MP.sProducts_serviceTax=sac.TAX_ID "></asp:SqlDataSource>





        <dxe:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" ContainerElementID="ProductMainContaint"
            Modal="True">
        </dxe:ASPxLoadingPanel>




        <dxe:ASPxPopupControl runat="server" ID="MainAccountModelSI" ClientInstanceName="cMainAccountModelSI"
            Width="500px" Height="300px" HeaderText="Search Main Account" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">

            <HeaderTemplate>
                <span>Search Main Account</span>
                <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                    <ClientSideEvents Click="function(s, e){ 
                                cMainAccountModelSI.Hide();
                            }" />
                </dxe:ASPxImage>
            </HeaderTemplate>


            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                    <div class="modal-body">
                        <input type="text" onkeydown="MainAccountNewkeydown(event)" id="txtMainAccountSearch" autofocus width="100%" placeholder="Search by Main Account Name or Short Name" />

                        <div id="MainAccountTable">
                            <table border='1' width="100%">
                                <tr class="HeaderStyle">
                                    <th>Main Account Name</th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents Shown="function(){ $('#txtMainAccountSearch').focus();}" />
        </dxe:ASPxPopupControl>
        <asp:HiddenField runat="server" ID="hdnSIMainAccount" />

        <dxe:ASPxPopupControl runat="server" ID="MainAccountModelSR" ClientInstanceName="cMainAccountModelSR"
            Width="500px" Height="300px" HeaderText="Search Main Account" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">

            <HeaderTemplate>
                <span>Search Main Account</span>
                <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                    <ClientSideEvents Click="function(s, e){ 
                                cMainAccountModelSR.Hide();
                            }" />
                </dxe:ASPxImage>
            </HeaderTemplate>


            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl ID="PopupControlContentControl2" runat="server">
                    <div class="modal-body">
                        <input type="text" onkeydown="MainAccountSRNewkeydown(event)" id="txtMainAccountSRSearch" autofocus width="100%" placeholder="Search by Main Account Name or Short Name" />

                        <div id="MainAccountTableSR">
                            <table border='1' width="100%">
                                <tr class="HeaderStyle">
                                    <th>Main Account Name</th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents Shown="function(){ $('#txtMainAccountSRSearch').focus();}" />
        </dxe:ASPxPopupControl>
        <asp:HiddenField runat="server" ID="hdnSRMainAccount" />


        <dxe:ASPxPopupControl runat="server" ID="MainAccountModelPI" ClientInstanceName="cMainAccountModelPI"
            Width="500px" Height="300px" HeaderText="Search Main Account" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">

            <HeaderTemplate>
                <span>Search Main Account</span>
                <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                    <ClientSideEvents Click="function(s, e){ 
                                cMainAccountModelPI.Hide();
                            }" />
                </dxe:ASPxImage>
            </HeaderTemplate>


            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl ID="PopupControlContentControl3" runat="server">
                    <div class="modal-body">
                        <input type="text" onkeydown="MainAccountPINewkeydown(event)" id="txtMainAccountPISearch" autofocus width="100%" placeholder="Search by Main Account Name or Short Name" />

                        <div id="MainAccountTablePI">
                            <table border='1' width="100%">
                                <tr class="HeaderStyle">
                                    <th>Main Account Name</th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents Shown="function(){ $('#txtMainAccountPISearch').focus();}" />
        </dxe:ASPxPopupControl>
        <asp:HiddenField runat="server" ID="hdnPIMainAccount" />

        <dxe:ASPxPopupControl runat="server" ID="MainAccountModelPR" ClientInstanceName="cMainAccountModelPR"
            Width="500px" Height="300px" HeaderText="Search Main Account" PopupHorizontalAlign="WindowCenter"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">

            <HeaderTemplate>
                <span>Search Main Account</span>
                <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                    <ClientSideEvents Click="function(s, e){ 
                                cMainAccountModelPR.Hide();
                            }" />
                </dxe:ASPxImage>
            </HeaderTemplate>


            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl ID="PopupControlContentControl4" runat="server">
                    <div class="modal-body">
                        <input type="text" onkeydown="MainAccountPRNewkeydown(event)" id="txtMainAccountPRSearch" autofocus width="100%" placeholder="Search by Main Account Name or Short Name" />

                        <div id="MainAccountTablePR">
                            <table border='1' width="100%">
                                <tr class="HeaderStyle">
                                    <th>Main Account Name</th>
                                </tr>
                            </table>
                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
           <ClientSideEvents Shown="function(){ $('#txtMainAccountPRSearch').focus();}" />
        </dxe:ASPxPopupControl>
        <asp:HiddenField runat="server" ID="hdnPRMainAccount" />

        <dxe:ASPxPopupControl ID="AspxDirectCustomerViewPopup" runat="server"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="CAspxDirectCustomerViewPopup" Height="650px"
            Width="1020px" HeaderText="View Product" Modal="true" AllowResize="False">

            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                </dxe:PopupControlContentControl>
            </ContentCollection>
        </dxe:ASPxPopupControl>



        <dxe:ASPxPopupControl runat="server" ID="popupproductimport" ClientInstanceName="cproductimport"
            Width="700px" Height="200px" HeaderText="Search Product" PopupHorizontalAlign="WindowCenter" ScrollBars="Vertical"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">

            <HeaderTemplate>

              
                <span>Upload File to Import Products</span>
                <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                    <ClientSideEvents Click="function(s, e){ 
                                cproductimport.Hide();
                            }" />
                </dxe:ASPxImage>
      
               
            </HeaderTemplate>


            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl ID="PopupControlContentControl5" runat="server">
                    <div class="mpad">

                        <div id="divproduct">

                            <table class="padTbl">
                                <tr class="HeaderStyle">

                                   <td style="width: 80px;">File</td>
                                   <td style="width: 200px;"> <asp:FileUpload runat="server" ID="fileprod" accept=".xls,.xlsx"  /></td>  
                                   <td><asp:Button runat="server" ID="btnimportxls" OnClick="ImportExcel" Text="Import" OnClientClick="return ChekprodUpload();" CssClass="btn btn-primary" /></td>

                                </tr>

                               <tr>
                                   <td colspan="3">
                                 
                                   </td>
                               </tr>
                            </table>
                            <div><label></label></div>

                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents Shown="function(){ $('#txtMainAccountPISearch').focus();}" />
        </dxe:ASPxPopupControl>




        <dxe:ASPxPopupControl runat="server" ID="panelproductlog" ClientInstanceName="cproductimportlog"
            Width="700px" Height="200px" HeaderText="Search Product" PopupHorizontalAlign="WindowCenter" ScrollBars="Vertical"
            BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
            ContentStyle-CssClass="pad">

            <HeaderTemplate>

              
                <span>Upload File to Import Products</span>
                <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                    <ClientSideEvents Click="function(s, e){ 
                                cproductimport.Hide();
                            }" />
                </dxe:ASPxImage>
      
               
            </HeaderTemplate>


            <ContentStyle VerticalAlign="Top" CssClass="pad">
            </ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl ID="PopupControlContentControl6" runat="server">
                    <div class="mpad">

                        <div id="divproductlog">

                            <table class="padTbl">
                                <tr class="HeaderStyle">

                                   <td style="width: 80px;">Product Log</td>
                                   <td>

                                         <asp:GridView ID="grdproductlog" runat="server" AutoGenerateColumns="true" CssClass="normaltble"></asp:GridView>


                                   </td>
                               </tr>
                            </table>
                            <div><label></label></div>

                        </div>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents Shown="function(){ $('#txtMainAccountPISearch').focus();}" />
        </dxe:ASPxPopupControl>

</asp:Content>
