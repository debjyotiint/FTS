<%@ Page Language="C#" AutoEventWireup="true"  MasterPageFile="~/OMS/MasterPage/ERP.Master" EnableViewStateMac="false" EnableEventValidation="false" CodeBehind="PosSalesInvoiceEdit.aspx.cs" Inherits="ERP.OMS.Management.Activities.PosSalesInvoiceEdit" %>



<%@ Register Src="~/OMS/Management/Activities/UserControls/ucPaymentDetails.ascx" TagPrefix="uc1" TagName="ucPaymentDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .inline {
            display: inline !important;
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

    <script src="../../Tax%20Details/Js/TaxDetailsItemlevel.js" type="text/javascript"></script>

    <script>



        var globalOldUnitTotalValue = 0;
        var globalNetAmount = 0;
        var CustomerCurrentDateAmount = 0;
        var isExecutiveHasLedger = 0;
                

        function InvoiceExists(){
        jAlert("Selected Invoice Number Already Exists.", 'Alert', function(){ctxt_PLQuoteNo.SetEnabled(true);});
        
        }

        function AvailableStockClick() {
            if ($('#HDSelectedProduct').val() == "") {
                jAlert("Please select a Product First.");
            } else {
                cShowAvailableStock.Show();
                cAvailableStockgrid.PerformCallback();
            }
        }




        function SetTotalDownPaymentAmount() {
            var totDownPay = parseFloat(ctxtEmiOtherCharges.GetValue()) + parseFloat(ctxtprocFee.GetValue()) + parseFloat(ctxtdownPayment.GetValue());
            ctxtTotDpAmt.SetValue(totDownPay);

            var InvoiceValue = parseFloat(cbnrLblInvValue.GetValue());
            ctxtFinanceAmt.SetValue(InvoiceValue - totDownPay);

        }

        function SetDownPayment() {
            var InvoiceValue = parseFloat(cbnrLblInvValue.GetValue());
            var FinanceAmount = parseFloat(ctxtFinanceAmt.GetValue());

            ctxtdownPayment.SetValue(InvoiceValue - FinanceAmount);
        }

        function SetOtherChargesLbl() {
            var finalOtherCharges = parseFloat(Math.round(ctxtQuoteTaxTotalAmt.GetValue() * 100) / 100).toFixed(2);
            if (finalOtherCharges == 0) {
                $('#otherChargesId').hide();
            } else {
                $('#otherChargesId').show();
            }
            cbnrOtherChargesvalue.SetValue(finalOtherCharges);
            SetRunningBalance();
        }


        function ccmbExecNameEndCallBack() {
            if (ccmbExecName.cpFinancerHasLedger) {
                if (ccmbExecName.cpFinancerHasLedger != '') {
                    isExecutiveHasLedger = parseFloat(ccmbExecName.cpFinancerHasLedger);
                    ccmbExecName.cpFinancerHasLedger = null;
                    if (isExecutiveHasLedger == 0) {
                        jAlert("No ledger is mapped for the selected Financer.", "Alert", function () {
                            ccmbFinancer.Focus();
                        });
                    }
                }
            }
        }

        function Updated() {
            jAlert('Updated Successfully.', 'Alert', function () {
                window.location.assign("PosSalesInvoiceList.aspx");
            });
        }

        function ParentCustomerOnClose(newCustId) {
            AspxDirectAddCustPopup.Hide();
            // gridLookup.gridView.Refresh();
            //  gridLookup.Focus();
            cCustomerCallBackPanel.PerformCallback('SetCustomer~' + newCustId);
        }

        function CustomerCallBackPanelEndCallBack() {
            GetContactPerson();
        }


        function SetInvoiceLebelValue() {

            var invValue = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) - (parseFloat(cbnrLblLessAdvanceValue.GetValue()) + parseFloat(cbnrLblLessOldMainVal.GetValue()));

            if (document.getElementById('HdPosType').value == 'Crd' || document.getElementById('HdPosType').value == 'Fin') {
                if (invValue < 0) {
                    var newAdvAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) - parseFloat(cbnrLblLessOldMainVal.GetValue());
                    cbnrLblLessAdvanceValue.SetValue(parseFloat(Math.round(Math.abs(newAdvAmount) * 100) / 100).toFixed(2));
                }
            }

            if (document.getElementById('HdPosType').value == 'Crd')
                invValue = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) - (parseFloat(cbnrLblLessAdvanceValue.GetValue()) + parseFloat(cbnrLblLessOldMainVal.GetValue()));
            else if (document.getElementById('HdPosType').value == 'Fin')
                invValue = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) - parseFloat(cbnrLblLessOldMainVal.GetValue());


            cbnrLblInvValue.SetValue(parseFloat(Math.round(Math.abs(invValue) * 100) / 100).toFixed(2));


            SetRunningBalance();

        }

        function DiscountGotChange() {
            globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
            ProductGetTotalAmount = globalNetAmount;
        }

        function challanNoSchemeSelectedIndexChanged() {
            var schemeValue = cchallanNoScheme.GetValue();
            if (schemeValue == null) {
                ctxtChallanNo.SetEnabled(false);
                ctxtChallanNo.SetText('');
            }
            else if (schemeValue.split('~')[1] == '1') {
                ctxtChallanNo.SetEnabled(false);
                ctxtChallanNo.SetText('Auto');
            }
            else if (schemeValue.split('~')[1] == '0') {
                ctxtChallanNo.SetEnabled(true);
                ctxtChallanNo.SetText('');
            }
        }

        function challanNoSchemeEndCallback() {

        }

        function CustomerReceiptEndCallback() {
            if (caspxCustomerReceiptGridview.cpCustomerReceiptTotalAmount) {
                if (caspxCustomerReceiptGridview.cpCustomerReceiptTotalAmount != '') {
                    ctxtAdvnceReceipt.SetValue(caspxCustomerReceiptGridview.cpCustomerReceiptTotalAmount);
                    cbnrLblLessAdvanceValue.SetValue(caspxCustomerReceiptGridview.cpCustomerReceiptTotalAmount);
                    SetInvoiceLebelValue();
                    caspxCustomerReceiptGridview.cpCustomerReceiptTotalAmount = null;

                    //if (caspxCustomerReceiptGridview.cpReceiptList) {
                    //    $('#hdAddvanceReceiptNo').val(caspxCustomerReceiptGridview.cpReceiptList);
                    //    caspxCustomerReceiptGridview.cpReceiptList = null;
                    //}
                }
            }

            if (caspxCustomerReceiptGridview.cpReceiptList != null) {
                $('#hdAddvanceReceiptNo').val(caspxCustomerReceiptGridview.cpReceiptList);
                caspxCustomerReceiptGridview.cpReceiptList = null;
            }

            if (caspxCustomerReceiptGridview.cpTotalTransectionAmount) {
                if (caspxCustomerReceiptGridview.cpTotalTransectionAmount != "") {
                    CustomerCurrentDateAmount = parseFloat(caspxCustomerReceiptGridview.cpTotalTransectionAmount);
                    caspxCustomerReceiptGridview.cpTotalTransectionAmount = null;
                }
            }

        }
        function CustomerReceiptSaveandExitClick() {
            cpopupCustomerRecipt.Hide();
            caspxCustomerReceiptGridview.PerformCallback('SaveCustomerReceiptGridview');
            //    if (document.getElementById('HdPosType').value != 'Crd'  ) {
            ccmbUcpaymentCashLedger.Focus();
            //} else {
            //    cbtn_SaveRecords.Focus();
            //}

        }

        function SelectAllCustomerReceipt() {
            caspxCustomerReceiptGridview.PerformCallback('SelectAllRecords');
        }

        function UnSelectAllCustomerReceipt() {
            caspxCustomerReceiptGridview.PerformCallback('UnSelectAllRecords');
        }

        function RevertCustomerReceipt() {
            caspxCustomerReceiptGridview.PerformCallback('Revert');
        }

        function AdvanceReceiptOnClick() {
            var custId = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            caspxCustomerReceiptGridview.PerformCallback('BindCustomerGridByInternalId~' + custId + '~' + tstartdate.GetDate().format('yyyy-MM-dd'));
            cpopupCustomerRecipt.Show();
        }

        function onMainGridKeyPress(e) {
            console.log("key pressed", e.code);
            if (e.code == "Tab") {
                ccmbOldUnit.Focus();
            }
        }

        function oldUnitGridClearClick() {
            ClearOldUnitData();
            coldUnitProductLookUp.Focus();
            $('#HdDiscountAmount').val('0');

        }
        function oldunitPopupSaveAndEXitClick() {
            cOldUnitPopUpControl.Hide();
            ctxtRemarks.Focus();
        }
        function oldUnitButtonShouldVissible() {
            if (ccmbOldUnit.GetValue() == "0")
                $('#OldUnitSelectionButton').hide();
            else
                $('#OldUnitSelectionButton').show();
        }

        function ccmbOldUnitTextChanged() {
            oldUnitButtonShouldVissible();
            if (ccmbOldUnit.GetValue() == "1") {
                OldUnitButtonOnClick();
                coldUnitProductLookUp.Focus();
            } else {
                if (parseFloat(ctxtunitValue.GetValue()) > 0) {
                    jConfirm("Old Unit already entered. Selecting 'No' will clear Old Unit data. Wish to proceed?", "Alert", function (data) {
                        if (data == true) {
                            cOldUnitGrid.PerformCallback('DeleteAllRecord');
                        } else {
                            ccmbOldUnit.SetValue('1');
                            $('#OldUnitSelectionButton').show();
                        }
                    });
                }
            }
        }
        function oldUnitGridRowChange() {
            if (cOldUnitGrid.GetVisibleRowsOnPage() > 0) {
                if (document.getElementById('hdAddOrEdit').value != "Edit") {
                    coldunitPopupSaveAndClickClick.SetVisible(true);
                }
            } else {
                coldunitPopupSaveAndClickClick.SetVisible(false);
            }
        }

        function OldUnitGridEndCallback() {
            if (cOldUnitGrid.cpReturnString) {
                if (cOldUnitGrid.cpReturnString != "") {
                    if (cOldUnitGrid.cpReturnString == 'AddDataToTable') {
                        ClearOldUnitData();
                        coldUnitProductLookUp.Focus();
                        cOldUnitGrid.cpReturnString = null;
                    }
                }
            }

            if (cOldUnitGrid.cpTotalOldUnit) {
                if (cOldUnitGrid.cpTotalOldUnit != "") {
                    ctxtunitValue.SetValue(parseFloat(cOldUnitGrid.cpTotalOldUnit));
                    cbnrLblLessOldMainVal.SetText(ctxtunitValue.GetText());
                    SetInvoiceLebelValue();
                    if (parseFloat(ctxtunitValue.GetValue()) == 0) {
                        ccmbOldUnit.SetValue('0');
                        $('#OldUnitSelectionButton').hide();
                    } else {
                        ccmbOldUnit.SetValue('1');
                        $('#OldUnitSelectionButton').show();
                    }
                }
            }
            oldUnitGridRowChange();
        }

        function ClearOldUnitData() {
            coldUnitProductLookUp.Clear();
            ctxtOldUnitUom.SetText('');
            ctxtOldUnitqty.SetText('');
            ctxtoldUnitValue.SetText('');
        }

        function OldUnitButtonOnClick() {
            cOldUnitPopUpControl.Show();
            coldUnitProductLookUp.Focus();
            cOldUnitGrid.PerformCallback('DisplayOldUnit');

        }

        function oldUnitProductTextChanged(s, e) {
            var key = coldUnitProductLookUp.GetGridView().GetRowKey(coldUnitProductLookUp.GetGridView().GetFocusedRowIndex());
            ctxtOldUnitUom.SetText(key.split('|@|')[1]);
        }

        function fn_EditOldUnit(keyVal) {
            coldUnitUpdatePanel.PerformCallback(keyVal);
        }

        function fn_removeOldUnit(keyVal) {
            cOldUnitGrid.PerformCallback("DeleteFromTable~" + keyVal);
        }

        function oldUnitGridAddClick() {
            $('#mandetoryOldUnit').attr('style', 'display:none');
            var focusedRow = coldUnitProductLookUp.gridView.GetFocusedRowIndex();

            var MRP = parseFloat(coldUnitProductLookUp.gridView.GetRow(focusedRow).children[5].innerText);

            if (coldUnitProductLookUp.GetValue() == null) {

                $('#mandetoryOldUnit').attr('style', 'display:block');
            }
            else if (MRP != 0 && ctxtoldUnitValue.GetValue() > MRP) {
                var roundOfValue = parseFloat(Math.round(Math.abs(MRP) * 100) / 100).toFixed(2);
                jAlert("Old Unit Value cannot be Greater then MRP defined.", "Alert", function () { ctxtoldUnitValue.Focus(); });
            }
            else {
                cOldUnitGrid.PerformCallback("AddDataToTable");
            }
        }

        function financerIndexChange(s, e) {
            ccmbExecName.PerformCallback(ccmbFinancer.GetValue());
        }

        function isDeliveryTypeChanged(s, e) {
            var type = s.GetValue();
            document.getElementById('ddDeliveredFrom').value = $('#sessionBranch').val();
            if (type == 'S') {
                $('#ddDeliveredFrom').attr('disabled', 'disabled');
            }
            else {
                $('#ddDeliveredFrom').attr('disabled', false);
            }

            if (type == "D") {

                cchallanNoScheme.SetEnabled(true);
                tstartdate.SetEnabled(true);

            } else {
                cchallanNoScheme.SetSelectedIndex(0);
                cchallanNoScheme.SetEnabled(false);
                ctxtChallanNo.SetEnabled(false);
                tstartdate.SetEnabled(false);
                tstartdate.SetDate(new Date);
                cdeliveryDate.SetDate(tstartdate.GetDate());
                DateCheck();

                if (isDeliveryTypeChanged != "") {
                    if ($('#ddl_numberingScheme').val().split('~')[1] == "0") {
                        tstartdate.SetEnabled(true);
                    }
                }

            }

        }


        (function (global) {

            if (typeof (global) === "undefined") {
                throw new Error("window is undefined");
            }

            var _hash = "!";
            var noBackPlease = function () {
                global.location.href += "#";

                // making sure we have the fruit available for juice (^__^)
                global.setTimeout(function () {
                    global.location.href += "!";
                }, 50);
            };

            global.onhashchange = function () {
                if (global.location.hash !== _hash) {
                    global.location.hash = _hash;
                }
            };

            global.onload = function () {
                noBackPlease();

                // disables backspace on page except on input fields and textarea..
                document.body.onkeydown = function (e) {
                    var elm = e.target.nodeName.toLowerCase();
                    if (e.which === 8 && (elm !== 'input' && elm !== 'textarea')) {
                        e.preventDefault();
                    }
                    // stopping event bubbling up the DOM tree..
                    e.stopPropagation();
                };
            }

        })(window);

        var isCtrl = false;
        //document.onkeyup = function (e) {
        //    if (event.keyCode == 17) {
        //        isCtrl = false;
        //    }
        //    else if (event.keyCode == 27) {
        //        btnCancel_Click();
        //    }
        //}

        document.onkeydown = function (e) {
            if (event.keyCode == 18) isCtrl = true;
            if (event.keyCode == 78 && event.altKey == true) { //run code for Alt + n -- ie, Save & New  
                StopDefaultAction(e);
                Save_ButtonClick();
            }
            else if (event.keyCode == 88 && event.altKey == true) { //run code for Ctrl+X -- ie, Save & Exit!     
                StopDefaultAction(e);
              
                    SaveExit_ButtonClick();
                
            }
            else if (event.keyCode == 85 && event.altKey == true) { //run code for Ctrl+X -- ie, Save & Exit!     
                StopDefaultAction(e);
                OpenUdf();
            }
        }

        function StopDefaultAction(e) {
            if (e.preventDefault) { e.preventDefault() }
            else { e.stop() };

            e.returnValue = false;
            e.stopPropagation();
        }
    </script>

    <%--Debu Section--%>
    <script type="text/javascript">
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
            //var roundedOfAmount = Math.round(totalInlineTaxAmount);
            var roundedOfAmount = totalInlineTaxAmount;
            ctxtTaxTotAmt.SetValue(totalInlineTaxAmount);


            var diffDisc = roundedOfAmount - totalInlineTaxAmount;
            if (diffDisc > 0)
                document.getElementById('taxroundedOf').innerText = 'Adjustment ' + Math.abs(diffDisc.toFixed(3));
            else if (diffDisc < 0)
                document.getElementById('taxroundedOf').innerText = 'Adjustment ' + Math.abs(diffDisc.toFixed(3));
            else
                document.getElementById('taxroundedOf').innerText = '';
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

            //var ProductIDColumn = s.GetColumnByField("ProductID");
            //if (!e.rowValues.hasOwnProperty(ProductIDColumn.index))
            //    return;
            //var cellInfo = e.rowValues[ProductIDColumn.index];

            //if (cCmbProduct.FindItemByValue(cellInfo.value) != null) {
            //    cCmbProduct.SetValue(cellInfo.value);
            //}
            //else {
            //    cCmbProduct.SetSelectedIndex(-1);
            //}

        }

        function OnBatchEditEndEditing(s, e) {
            var ProductIDColumn = s.GetColumnByField("ProductID");
            if (!e.rowValues.hasOwnProperty(ProductIDColumn.index))
                return;
            var cellInfo = e.rowValues[ProductIDColumn.index];
            if (cCmbProduct.GetSelectedIndex() > -1 || cellInfo.text != cCmbProduct.GetText()) {
                cellInfo.value = cCmbProduct.GetValue();
                cellInfo.text = cCmbProduct.GetText();
                cCmbProduct.SetValue(null);
            }
        }

        function TaxAmountKeyDown(s, e) {

            if (e.htmlEvent.key == "Enter") {
                s.OnButtonClick(0);
            }
        }

        var taxAmountGlobal;
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
        function Onddl_VatGstCstEndCallback(s, e) {
            if (s.GetItemCount() == 1) {
                cddlVatGstCst.SetEnabled(false);
            }
        }
        var GlobalCurChargeTaxAmt;
        var ChargegstcstvatGlobalName;
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

        var GlobalCurTaxAmt = 0;
        var rowEditCtrl;
        var globalRowIndex;
        var globalTaxRowIndex;
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
                    ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) - GlobalCurTaxAmt));
                }


                var isValid = taxValue.indexOf('~');
                if (isValid != -1) {
                    var rate = parseFloat(taxValue.split('~')[1]);
                    var ProdAmt = parseFloat(ctxtprodBasicAmt.GetValue());

                    GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());


                    cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * rate) / 100);
                    ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * rate) / 100) - GlobalCurTaxAmt));
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

                    ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt));
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

                        ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt));
                        GlobalCurTaxAmt = 0;
                    }
                    else {

                        GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                        cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * s.GetText()) / 100) * -1);

                        ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) * -1) - (GlobalCurTaxAmt * -1)));
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

                        ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt));
                        GlobalCurTaxAmt = 0;
                    }
                    else {

                        GlobalCurTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
                        gridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * s.GetText()) / 100) * -1);

                        ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) * -1) - (GlobalCurTaxAmt * -1)));
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

                        ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(cgridTax.GetEditor("TaxField").GetValue())) / 100) - GlobalCurTaxAmt));
                        GlobalCurTaxAmt = 0;
                    }
                    else {

                        GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                        cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * cgridTax.GetEditor("TaxField").GetValue()) / 100) * -1);

                        ctxtTaxTotAmt.SetValue(Math.round(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(cgridTax.GetEditor("TaxField").GetValue())) / 100) * -1) - (GlobalCurTaxAmt * -1)));
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



        var gstcstvatGlobalName;
        function CmbtaxClick(s, e) {
            GlobalCurTaxAmt = parseFloat(ctxtGstCstVat.GetText());
            gstcstvatGlobalName = s.GetText();
        }


        function txtTax_TextChanged(s, i, e) {
            cgridTax.batchEditApi.StartEdit(i, 2);
            var ProdAmt = parseFloat(ctxtprodBasicAmt.GetValue());
            cgridTax.GetEditor("Amount").SetValue(parseFloat(ProdAmt * s.GetText()) / 100);
        }

        function taxAmtButnClick(s, e) {
            if (e.buttonIndex == 0) {

                if (cddl_AmountAre.GetValue() != null) {
                    var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";

                    if (ProductID.trim() != "") {
                        globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
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
                        var strRate = (ctxt_Rate.GetValue() != null && ctxt_Rate.GetValue() != "0") ? ctxt_Rate.GetValue() : "1";
                        //var strRate = "1";
                        var strStkUOM = SpliteDetails[4];
                        // var strSalePrice = SpliteDetails[6];
                        var strSalePrice = (grid.GetEditor('SalePrice').GetValue() != null) ? grid.GetEditor('SalePrice').GetValue() : "";
                        if (strRate == 0) {
                            strRate = 1;
                        }

                        var StockQuantity = strMultiplier * QuantityValue;
                        var Amount = Math.round(QuantityValue * strFactor * (strSalePrice / strRate)).toFixed(2);
                        clblTaxProdGrossAmt.SetText(Math.round(grid.GetEditor('Amount').GetValue()).toFixed(2));
                        clblProdNetAmt.SetText(Math.round(grid.GetEditor('Amount').GetValue()).toFixed(2));
                        document.getElementById('HdProdGrossAmt').value = Amount;
                        document.getElementById('HdProdNetAmt').value = Math.round(grid.GetEditor('Amount').GetValue()).toFixed(2);

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
                            $('.gstNetAmount').show();
                            //   var gstRate = parseFloat(cddlVatGstCst.GetValue().split('~')[1]);
                            var gstRate = 0;
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

                            //Get Customer Shipping StateCode
                            var shippingStCode = '';
                            if (cchkBilling.GetValue()) {
                                shippingStCode = CmbState.GetText();
                            }
                            else {
                                shippingStCode = CmbState1.GetText();
                            }
                            shippingStCode = shippingStCode.substring(shippingStCode.lastIndexOf('(')).replace('(State Code:', '').replace(')', '').trim();

                            //Debjyoti 09032017
                            if (shippingStCode.trim() != '') {
                                for (var cmbCount = 1; cmbCount < ccmbGstCstVat.GetItemCount() ; cmbCount++) {
                                    //Check if gstin is blank then delete all tax
                                    if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[5] != "") {

                                        if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[5] == shippingStCode) {

                                            //if its state is union territories then only UTGST will apply
                                            if (shippingStCode == "4" || shippingStCode == "26" || shippingStCode == "25" || shippingStCode == "7" || shippingStCode == "31" || shippingStCode == "34") {
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
        function taxAmtButnClick1(s, e) {
            console.log(grid.GetFocusedRowIndex());
            rowEditCtrl = s;
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

        var taxJson;
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

                var totalNetAmount = parseFloat(totAmt) + parseFloat(grid.GetEditor("Amount").GetValue());
                var totalRoundOffAmount = Math.round(totalNetAmount);
                grid.GetEditor("TotalAmount").SetValue(totalRoundOffAmount);

                grid.GetEditor("Amount").SetValue(parseFloat(grid.GetEditor("Amount").GetValue()) + (totalRoundOffAmount - totalNetAmount));


                var finalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
                var finalAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) + (finalNetAmount - globalNetAmount);
                cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(finalAmount) * 100) / 100).toFixed(2));
                SetInvoiceLebelValue();

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



    </script>





    <%--Debu Section End--%>

    <%-- ------Subhra Address and Billing Sectin Start-----25-01-2017---------%>
    <script type="text/javascript">
        //window.onload = function () {

        //    grid.AddNewRow();
        //};
        //$(document).ready(function () {
        //    page.SetActiveTabIndex(parseInt(document.getElementById("hdntab2").value));
        //})
        function SettingTabStatus() {
            if (GetObjectID('hdnCustomerId').value != null && GetObjectID('hdnCustomerId').value != '' && GetObjectID('hdnCustomerId').value != '0') {
                page.GetTabByName('[B]illing/Shipping').SetEnabled(true);
            }
        }

        function CopyBillingAddresstoShipping(obj) {
            var chkbill = obj.GetChecked();
            if (chkbill == true) {
                $('#DivShipping').hide();
            }
            else {
                $('#DivShipping').show();
            }
            ctaxUpdatePanel.PerformCallback('DeleteAllTax');
            //cComponentPanel.PerformCallback('Edit~BillingAddresstoShipping');
        }
        function CopyShippingAddresstoBilling(obj) {
            var chkship = obj.GetChecked();
            if (chkship == true) {
                $('#DivBilling').hide();
            }
            else {
                $('#DivBilling').show();
            }
            //cComponentPanel.PerformCallback('Edit~ShippingAddresstoBilling');
        }



        function btnSave_QuoteAddress() {
            checking = true;
            var chkbilling = cchkBilling.GetChecked();
            var chkShipping = cchkShipping.GetChecked();

            if (chkbilling == false && chkShipping == false) {
                // Billing Start
                if (ctxtAddress1.GetText() == '' || ctxtAddress1.GetText() == null) {
                    $('#badd1').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#badd1').attr('style', 'display:none'); }

                if (CmbCountry.GetValue() == '' || CmbCountry.GetValue() == null || CmbCountry.GetValue() == 'select') {
                    $('#bcountry').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bcountry').attr('style', 'display:none'); }


                // State

                if (CmbState.GetValue() == '' || CmbState.GetValue() == null || CmbState.GetValue() == 'select') {
                    $('#bstate').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bstate').attr('style', 'display:none'); }

                // city
                if (CmbCity.GetValue() == '' || CmbCity.GetValue() == null || CmbCity.GetValue() == 'select') {
                    $('#bcity').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bcity').attr('style', 'display:none'); }

                // pin

                if (CmbPin.GetValue() == '' || CmbPin.GetValue() == null || CmbPin.GetValue() == 'select') {
                    $('#bpin').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bpin').attr('style', 'display:none'); }
                // Billing End

                // Shipping Start

                if (ctxtsAddress1.GetText() == '' || ctxtsAddress1.GetText() == null) {
                    $('#sadd1').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#sadd1').attr('style', 'display:none'); }

                if (CmbCountry1.GetValue() == '' || CmbCountry1.GetValue() == null || CmbCountry1.GetValue() == 'select') {
                    $('#scountry').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#scountry').attr('style', 'display:none'); }


                // State

                if (CmbState1.GetValue() == '' || CmbState1.GetValue() == null || CmbState1.GetValue() == 'select') {
                    $('#sstate').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#sstate').attr('style', 'display:none'); }

                // city
                if (CmbCity1.GetValue() == '' || CmbCity1.GetValue() == null || CmbCity1.GetValue() == 'select') {
                    $('#scity').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#scity').attr('style', 'display:none'); }

                // pin

                if (CmbPin1.GetValue() == '' || CmbPin1.GetValue() == null || CmbPin1.GetValue() == 'select') {
                    $('#spin').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#spin').attr('style', 'display:none'); }

                // Shipping End

            }


            else if (chkbilling == true && chkShipping == false) {
                // Billing Start
                if (ctxtAddress1.GetText() == '' || ctxtAddress1.GetText() == null) {
                    $('#badd1').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#badd1').attr('style', 'display:none'); }

                if (CmbCountry.GetValue() == '' || CmbCountry.GetValue() == null || CmbCountry.GetValue() == 'select') {
                    $('#bcountry').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bcountry').attr('style', 'display:none'); }


                // State

                if (CmbState.GetValue() == '' || CmbState.GetValue() == null || CmbState.GetValue() == 'select') {
                    $('#bstate').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bstate').attr('style', 'display:none'); }

                // city
                if (CmbCity.GetValue() == '' || CmbCity.GetValue() == null || CmbCity.GetValue() == 'select') {
                    $('#bcity').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bcity').attr('style', 'display:none'); }

                // pin

                if (CmbPin.GetValue() == '' || CmbPin.GetValue() == null || CmbPin.GetValue() == 'select') {
                    $('#bpin').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#bpin').attr('style', 'display:none'); }
                // Billing End
            }

            else if (chkbilling == false && chkShipping == true) {
                // Shipping Start

                if (ctxtsAddress1.GetText() == '' || ctxtsAddress1.GetText() == null) {
                    $('#sadd1').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#sadd1').attr('style', 'display:none'); }

                if (CmbCountry1.GetValue() == '' || CmbCountry1.GetValue() == null || CmbCountry1.GetValue() == 'select') {
                    $('#scountry').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#scountry').attr('style', 'display:none'); }


                // State

                if (CmbState1.GetValue() == '' || CmbState1.GetValue() == null || CmbState1.GetValue() == 'select') {
                    $('#sstate').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#sstate').attr('style', 'display:none'); }

                // city
                if (CmbCity1.GetValue() == '' || CmbCity1.GetValue() == null || CmbCity1.GetValue() == 'select') {
                    $('#scity').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#scity').attr('style', 'display:none'); }

                // pin

                if (CmbPin1.GetValue() == '' || CmbPin1.GetValue() == null || CmbPin1.GetValue() == 'select') {
                    $('#spin').attr('style', 'display:block');
                    checking = false;
                    //return false;
                }
                else { $('#spin').attr('style', 'display:none'); }

                // Shipping End

            }
            if (checking == true) {

                var custID = GetObjectID('hdnCustomerId').value;
                var chkbilling = cchkBilling.GetChecked();
                //var chkbilling = cchkBilling.GetChecked;
                var chkShipping = cchkShipping.GetChecked();
                //var chkShipping = cchkShipping.GetChecked;
                if ((chkbilling == false) && (chkShipping == false)) {
                    cComponentPanel.PerformCallback('save~1');
                }
                else if ((chkbilling == true) && (chkShipping == false)) {
                    cComponentPanel.PerformCallback('save~2');
                }
                else if ((chkbilling == false) && (chkShipping == true)) {
                    cComponentPanel.PerformCallback('save~3');
                }
                GetObjectID('hdnAddressDtl').value = '1';
                page.SetActiveTabIndex(0);
                //   gridLookup.Focus();
                cddl_SalesAgent.Focus();
                gridquotationLookup.HideDropDown();
                $('.crossBtn').show();
            }
            else {
                page.SetActiveTabIndex(1);
                $('.crossBtn').show();
            }
        }


        function ClosebillingLookup() {
            billingLookup.ConfirmCurrentSelection();
            billingLookup.HideDropDown();
            billingLookup.Focus();
        }
        function CloseshippingLookup() {
            shippingLookup.ConfirmCurrentSelection();
            shippingLookup.HideDropDown();
            shippingLookup.Focus();
        }

        //Subhra-----23-01-2017-------
        var Billing_state;
        var Billing_city;
        var Billing_pin;
        var billing_area;

        var Shipping_state;
        var Shipping_city;
        var Shipping_pin;
        var Shipping_area;


        function OnCountryChanged(cmbCountry) {

            CmbState.PerformCallback(cmbCountry.GetValue().toString());
        }
        function OnCountryChanged1(cmbCountry1) {
            CmbState1.PerformCallback(cmbCountry1.GetValue().toString());
        }

        function OnStateChanged(cmbState) {

            CmbCity.PerformCallback(cmbState.GetValue().toString());
            ctaxUpdatePanel.PerformCallback('DeleteAllTax');
        }
        function OnStateChanged1(cmbState1) {
            CmbCity1.PerformCallback(cmbState1.GetValue().toString());
            ctaxUpdatePanel.PerformCallback('DeleteAllTax');
        }

        function OnCityChanged(abc) {

            CmbPin.PerformCallback(abc.GetValue().toString());
            CmbArea.PerformCallback(abc.GetValue().toString());
        }
        function OnCityChanged1(abc) {
            CmbPin1.PerformCallback(abc.GetValue().toString());
            CmbArea1.PerformCallback(abc.GetValue().toString());


        }
        //----------------------------------
        function OnChildCall(CmbCity) {

            OnCityChanged(CmbCity.GetValue());
            OnCityChanged(CmbCity1.GetValue());
        }
        function openAreaPage() {
            var left = (screen.width - 300) / 2;
            var top = (screen.height - 250) / 2;
            var cityid = CmbCity.GetValue();
            var cityname = CmbCity.GetText();
            var URL = '../Master/AddArea_PopUp.aspx?id=' + cityid + '&name=' + cityname + '';
            popupan.SetContentUrl(URL);
            popupan.Show();
        }

        function openAreaPageShip() {
            var left = (screen.width - 300) / 2;
            var top = (screen.height - 250) / 2;
            var cityid = CmbCity1.GetValue();
            var cityname = CmbCity1.GetText();
            var URL = '../Master/AddArea_PopUp.aspx?id=' + cityid + '&name=' + cityname + '';
            popupan.SetContentUrl(URL);
            popupan.Show();
        }



        function fn_PopOpen() {
            CmbCountry.SetSelectedIndex(-1);
            CmbCountry1.SetSelectedIndex(-1);
            CmbState.SetSelectedIndex(-1);
            CmbState1.SetSelectedIndex(-1);
            CmbCity.SetSelectedIndex(-1);
            CmbCity1.SetSelectedIndex(-1);
            CmbPin.SetSelectedIndex(-1);
            CmbPin1.SetSelectedIndex(-1);
            CmbArea.SetSelectedIndex(-1);
            CmbArea1.SetSelectedIndex(-1);
            cComponentPanel.PerformCallback('Edit~1');
            //cComponentPanel.PerformCallback('Edit~1' + GetObjectID('hdnAddressDtl').value); 
        }

        function cmbstate_endcallback(s, e) {
            if (Billing_state != 0) {
                s.SetValue(Billing_state);
            }
            CmbCity.PerformCallback(CmbState.GetValue());
            //Billing_state = 0;
        }
        function cmbshipstate_endcallback(s, e) {
            if (Shipping_state != 0) {
                s.SetValue(Shipping_state);
            }
            CmbCity1.PerformCallback(CmbState1.GetValue());
            Shipping_state = 0;
        }

        function cmbcity_endcallback(s, e) {
            if (Billing_city != 0) {
                s.SetValue(Billing_city);
            }
            CmbPin.PerformCallback(CmbCity.GetValue());
            CmbArea.PerformCallback(CmbCity.GetValue());
            Billing_city = 0;

        }
        function cmbshipcity_endcallback(s, e) {
            if (Shipping_city != 0) {
                s.SetValue(Shipping_city);
            }
            CmbPin1.PerformCallback(CmbCity1.GetValue());
            CmbArea1.PerformCallback(CmbCity1.GetValue());
            Shipping_city = 0;

        }

        function cmbPin_endcallback(s, e) {
            if (Billing_pin != 0) {
                s.SetValue(Billing_pin);
            }
            if (Billing_pin != null || Billing_pin != '' || Billing_pin != '0') {
                cchkBilling.SetEnabled(true);
            }
            Billing_pin = 0;
        }
        function cmbshipPin_endcallback(s, e) {
            if (Shipping_pin != 0) {
                s.SetValue(Shipping_pin);
            }
            if (Shipping_pin != null || Shipping_pin != '' || Shipping_pin != '0') {
                cchkShipping.SetEnabled(true);
            }
            Shipping_pin = 0;
        }

        function cmbArea_endcallback(s, e) {
            if (billing_area != 0) {
                s.SetValue(billing_area);
            }
            billing_area = 0;
        }

        function cmbshipArea_endcallback(s, e) {
            if (Shipping_area != 0) {
                s.SetValue(Shipping_area);
            }
            Shipping_area = 0;
        }

        //function Popup_SalesQuote_EndCallBack() {
        //    if (Popup_SalesQuote.cpshow != null) {


        //        CmbAddressType.SetText(Popup_SalesQuote.cpshow.split('~')[0]);
        //        ctxtAddress1.SetText(Popup_SalesQuote.cpshow.split('~')[1]);
        //        ctxtAddress2.SetText(Popup_SalesQuote.cpshow.split('~')[2]);
        //        ctxtAddress3.SetText(Popup_SalesQuote.cpshow.split('~')[3]);
        //        ctxtlandmark.SetText(Popup_SalesQuote.cpshow.split('~')[4]);
        //        CmbCountry.SetValue(Popup_SalesQuote.cpshow.split('~')[5]);
        //        Billing_state = Popup_SalesQuote.cpshow.split('~')[6];
        //        Billing_city = Popup_SalesQuote.cpshow.split('~')[7];
        //        Billing_pin = Popup_SalesQuote.cpshow.split('~')[8];
        //        billing_area = Popup_SalesQuote.cpshow.split('~')[9];
        //        CmbState.PerformCallback(CmbCountry.GetValue());
        //    }

        //    if (Popup_SalesQuote.cpshowShip != null) {


        //        CmbAddressType1.SetText(Popup_SalesQuote.cpshowShip.split('~')[0]);
        //        ctxtsAddress1.SetText(Popup_SalesQuote.cpshowShip.split('~')[1]);
        //        ctxtsAddress2.SetText(Popup_SalesQuote.cpshowShip.split('~')[2]);
        //        ctxtsAddress3.SetText(Popup_SalesQuote.cpshowShip.split('~')[3]);
        //        ctxtslandmark.SetText(Popup_SalesQuote.cpshow.split('~')[4]);
        //        CmbCountry1.SetValue(Popup_SalesQuote.cpshowShip.split('~')[5]);
        //        Shipping_state = Popup_SalesQuote.cpshowShip.split('~')[6];
        //        Shipping_city = Popup_SalesQuote.cpshowShip.split('~')[7];
        //        Shipping_pin = Popup_SalesQuote.cpshowShip.split('~')[8];
        //        Shipping_area = Popup_SalesQuote.cpshowShip.split('~')[9];
        //        CmbState1.PerformCallback(CmbCountry1.GetValue());
        //    }

        //}
        function Panel_endcallback() {

            var billingStatus = null;
            var shippingStatus = null;
            if (cComponentPanel.cpshow != null) {


                //CmbAddressType.SetText(cComponentPanel.cpshow.split('~')[0]);
                ctxtAddress1.SetText(cComponentPanel.cpshow.split('~')[1]);
                ctxtAddress2.SetText(cComponentPanel.cpshow.split('~')[2]);
                ctxtAddress3.SetText(cComponentPanel.cpshow.split('~')[3]);
                ctxtlandmark.SetText(cComponentPanel.cpshow.split('~')[4]);
                var bcon = cComponentPanel.cpshow.split('~')[5];
                if (bcon == '') {
                    CmbCountry.SetSelectedIndex(-1);
                }
                else {
                    CmbCountry.SetValue(cComponentPanel.cpshow.split('~')[5]);
                }

                var bsta = cComponentPanel.cpshow.split('~')[6];
                if (bsta == '') {
                    CmbState.SetSelectedIndex(-1);
                    Billing_state = 0;
                }
                else {
                    Billing_state = cComponentPanel.cpshow.split('~')[6];
                }
                var bcity = cComponentPanel.cpshow.split('~')[7];
                if (bcity == '') {
                    CmbCity.SetSelectedIndex(-1);
                    Billing_city = 0;
                }
                else {
                    Billing_city = cComponentPanel.cpshow.split('~')[7];
                }

                var bpin = cComponentPanel.cpshow.split('~')[8];
                if (bpin == '') {
                    CmbPin.SetSelectedIndex(-1);
                    Billing_pin = 0;
                }
                else {
                    Billing_pin = cComponentPanel.cpshow.split('~')[8];
                }

                var barea = cComponentPanel.cpshow.split('~')[9];
                if (barea == '') {
                    CmbArea.SetSelectedIndex(-1);
                    billing_area = 0;
                }
                else {
                    billing_area = cComponentPanel.cpshow.split('~')[9];
                }
                //CmbCountry.SetValue(cComponentPanel.cpshow.split('~')[5]);
                //Billing_state = cComponentPanel.cpshow.split('~')[6];
                //Billing_city = cComponentPanel.cpshow.split('~')[7];
                //Billing_pin = cComponentPanel.cpshow.split('~')[8];
                //billing_area = cComponentPanel.cpshow.split('~')[9];
                billingStatus = cComponentPanel.cpshow.split('~')[10];
                var countryid = CmbCountry.GetValue()
                if (countryid != null && countryid != '' && countryid != '0') {
                    CmbState.PerformCallback(countryid);
                }
            }

            if (cComponentPanel.cpshowShip != null) {

                //CmbAddressType1.SetText(cComponentPanel.cpshowShip.split('~')[0]);
                ctxtsAddress1.SetText(cComponentPanel.cpshowShip.split('~')[1]);

                ctxtsAddress2.SetText(cComponentPanel.cpshowShip.split('~')[2]);
                ctxtsAddress3.SetText(cComponentPanel.cpshowShip.split('~')[3]);
                ctxtslandmark.SetText(cComponentPanel.cpshowShip.split('~')[4]);
                var scon = cComponentPanel.cpshowShip.split('~')[5];
                if (scon == '') {
                    CmbCountry1.SetSelectedIndex(-1);
                }
                else {
                    CmbCountry1.SetValue(cComponentPanel.cpshowShip.split('~')[5]);
                }
                var ssta = cComponentPanel.cpshowShip.split('~')[6];
                if (ssta == '') {
                    CmbState1.SetSelectedIndex(-1);
                }
                else {
                    Shipping_state = cComponentPanel.cpshowShip.split('~')[6];
                }
                var scity = cComponentPanel.cpshowShip.split('~')[7];
                if (scity == '') {
                    CmbCity1.SetSelectedIndex(-1);
                }
                else {
                    Shipping_city = cComponentPanel.cpshowShip.split('~')[7];
                }

                var spin = cComponentPanel.cpshowShip.split('~')[8];
                if (spin == '') {
                    CmbPin1.SetSelectedIndex(-1);
                }
                else {
                    Shipping_pin = cComponentPanel.cpshowShip.split('~')[8];
                }

                var sarea = cComponentPanel.cpshowShip.split('~')[9];
                if (sarea == '') {
                    CmbArea1.SetSelectedIndex(-1);
                }
                else {
                    Shipping_area = cComponentPanel.cpshowShip.split('~')[9];
                }
                //CmbCountry1.SetValue(cComponentPanel.cpshowShip.split('~')[5]);
                //Shipping_state = 
                //Shipping_city = cComponentPanel.cpshowShip.split('~')[7];
                //Shipping_pin = cComponentPanel.cpshowShip.split('~')[8];
                //Shipping_area = cComponentPanel.cpshowShip.split('~')[9];
                shippingStatus = cComponentPanel.cpshowShip.split('~')[10];
                var countryid1 = CmbCountry1.GetValue()
                if (countryid1 != null && countryid1 != '' && countryid1 != '0') {
                    CmbState1.PerformCallback(countryid1);
                }
                //CmbState1.PerformCallback(CmbCountry1.GetValue());
            }
            if (billingStatus == 'Y' && shippingStatus == 'N') {
                cchkBilling.SetEnabled(true);
                cchkShipping.SetEnabled(false);
            }
            else if (billingStatus == 'N' && shippingStatus == 'Y') {
                cchkBilling.SetEnabled(false);
                cchkShipping.SetEnabled(true);

            }
            else if (billingStatus == 'Y' && shippingStatus == 'Y') {
                cchkBilling.SetEnabled(false);
                cchkShipping.SetEnabled(false);

            }
            else if (billingStatus == 'N' && shippingStatus == 'N') {
                cchkBilling.SetEnabled(false);
                cchkShipping.SetEnabled(false);
            }
        }

        function AddcustomerClick() {
            var url = '/OMS/management/Master/Customer_general.aspx';
            AspxDirectAddCustPopup.SetContentUrl(url);
            AspxDirectAddCustPopup.Show();
        }

        function disp_prompt(name) {

            if (name == "tab0") {
                //gridLookup.Focus();
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
                    fn_PopOpen();
                }
            }
        }

    </script>
    <%-- ------Subhra Address and Billing Section End-----25-01-2017---------%>

    <%--Sam Section Start--%>
    <script type="text/javascript">
        $(document).ready(function () {



            $('body').addClass('mini-navbar');
            if ($("#paymentDetails")) {

                $('html, body').animate({
                    scrollTop: $("#myDiv").offset().top
                }, 500);
            }
            cProductsPopup.Hide();
            if (GetObjectID('hdnCustomerId').value == null || GetObjectID('hdnCustomerId').value == '') {
                page.GetTabByName('[B]illing/Shipping').SetEnabled(false);
            }
            $('#ApprovalCross').click(function () {

                window.parent.popup.Hide();
                window.parent.cgridPendingApproval.Refresh()();
            })



            $('#ddl_VatGstCst_I').blur(function () {
                if (grid.GetVisibleRowsOnPage() == 1) {
                    grid.batchEditApi.StartEdit(-1, 2);
                }
            });
            $('#ddl_AmountAre').blur(function () {
                var id = cddl_AmountAre.GetValue();
                if (id == '1' || id == '3') {
                    if (grid.GetVisibleRowsOnPage() == 1) {
                        grid.batchEditApi.StartEdit(-1, 2);
                    }
                }
            });


            setPosView(document.getElementById('HdPosType').value);
            setBannerView($('#HdPosType').val());
            setViewMode();
        });


        function setViewMode() {
            if ($('#HdViewmode').val() == 'Yes') {
                $('#divSubmitButton').hide();
            }
        }

        function setBannerView(type) {
            if (type == 'Cash') {
                $('.clsbnrLblLessAdvance').hide();
            }
        }

        function setPosView(type) {
            if (type == 'Cash') {
                $('#FinancerTable').hide();
            }
            else if (type == 'Crd') {
                $('#FinancerTable').hide();
            }
            else if (type == 'Fin') {

            }
        }

        function GetBillingAddressDetailByAddressId(e) {
            var addresskey = billingLookup.GetGridView().GetRowKey(billingLookup.GetGridView().GetFocusedRowIndex());
            if (addresskey != null && addresskey != '') {

                cComponentPanel.PerformCallback('BlookupEdit~' + addresskey);
            }
        }

        function GetShippingAddressDetailByAddressId(e) {

            var saddresskey = shippingLookup.GetGridView().GetRowKey(shippingLookup.GetGridView().GetFocusedRowIndex());
            if (saddresskey != null && saddresskey != '') {

                cComponentPanel.PerformCallback('SlookupEdit~' + saddresskey);
            }
        }
        function UniqueCodeCheck() {

            var QuoteNo = ctxt_PLQuoteNo.GetText();
            if (QuoteNo != '') {
                var CheckUniqueCode = false;
                $.ajax({
                    type: "POST",
                    url: "SalesInvoice.aspx/CheckUniqueCode",
                    data: JSON.stringify({ QuoteNo: QuoteNo }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        CheckUniqueCode = msg.d;
                        if (CheckUniqueCode == true) {
                            //jAlert('Please enter unique PI/Quotation number');
                            $('#duplicateQuoteno').attr('style', 'display:block');
                            ctxt_PLQuoteNo.SetValue('');
                            ctxt_PLQuoteNo.Focus();
                        }
                        else {
                            $('#duplicateQuoteno').attr('style', 'display:none');
                        }
                    }
                });
            }
        }
        function CloseGridLookup() {
            gridLookup.ConfirmCurrentSelection();
            gridLookup.HideDropDown();
            gridLookup.Focus();
        }
        function GetContactPerson(e) {
            if (gridquotationLookup.GetValue() != null) {
                jConfirm('Documents tagged are to be automatically De-selected. Confirm ?', 'Confirmation Dialog', function (r) {

                    if (r == true) {
                        var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                        if (key != null && key != '') {
                            cchkBilling.SetChecked(false);
                            cchkShipping.SetChecked(false);
                            cContactPerson.PerformCallback('BindContactPerson~' + key);
                            page.GetTabByName('[B]illing/Shipping').SetEnabled(true);

                            //jConfirm('Wish to View/Select Billing and Shipping details?', 'Confirmation Dialog', function (r) {
                            //    if (r == true) {
                            //        page.SetActiveTabIndex(1);
                            //        $('.dxeErrorCellSys').addClass('abc');
                            //    }
                            //});

                            var type = ($("[id$='rdl_SaleInvoice']").find(":checked").val() != null) ? $("[id$='rdl_SaleInvoice']").find(":checked").val() : "";
                            var startDate = new Date();
                            startDate = tstartdate.GetValueString();

                            if (type != "") {
                                cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + '%' + '~' + type);
                            }

                            var componentType = gridquotationLookup.GetValue();//gridquotationLookup.GetGridView().GetRowKey(gridquotationLookup.GetGridView().GetFocusedRowIndex());
                            if (componentType != null && componentType != '') {
                                grid.PerformCallback('GridBlank');
                                $('#<%=hdnPageStatus.ClientID %>').val('update');
                            }

                            GetObjectID('hdnCustomerId').value = key;
                            GetObjectID('hdnAddressDtl').value = '0';

                            page.SetActiveTabIndex(1);
                            $('.dxeErrorCellSys').addClass('abc');
                            $('.crossBtn').hide();
                            page.GetTabByName('General').SetEnabled(false);


                        }
                    }
                });
            }
            else {
                var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                if (key != null && key != '') {
                    cchkBilling.SetChecked(false);
                    cchkShipping.SetChecked(false);
                    cContactPerson.PerformCallback('BindContactPerson~' + key);
                    page.GetTabByName('[B]illing/Shipping').SetEnabled(true);

                    //jConfirm('Wish to View/Select Billing and Shipping details?', 'Confirmation Dialog', function (r) {
                    //    if (r == true) {
                    //        page.SetActiveTabIndex(1);
                    //        $('.dxeErrorCellSys').addClass('abc');
                    //    }
                    //});

                    var type = ($("[id$='rdl_SaleInvoice']").find(":checked").val() != null) ? $("[id$='rdl_SaleInvoice']").find(":checked").val() : "";
                    var startDate = new Date();
                    startDate = tstartdate.GetValueString();

                    if (type != "") {
                        cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + '%' + '~' + type);
                    }

                    var componentType = gridquotationLookup.GetValue();//gridquotationLookup.GetGridView().GetRowKey(gridquotationLookup.GetGridView().GetFocusedRowIndex());
                    if (componentType != null && componentType != '') {
                        grid.PerformCallback('GridBlank');
                        $('#<%=hdnPageStatus.ClientID %>').val('update');
                    }

                    GetObjectID('hdnCustomerId').value = key;
                    GetObjectID('hdnAddressDtl').value = '0';

                    page.SetActiveTabIndex(1);
                    $('.dxeErrorCellSys').addClass('abc');
                    $('.crossBtn').hide();
                    page.GetTabByName('General').SetEnabled(false);
                }
            }

            //var custId = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            //caspxCustomerReceiptGridview.PerformCallback('BindCustomerGridByInternalId~' + custId + '~' + tstartdate.GetDate().format('yyyy-MM-dd'));
        }
        $(document).ready(function () {
            var schemaid = $('#ddl_numberingScheme').val();

            if (schemaid != null) {
                if (schemaid == '') {
                    ctxt_PLQuoteNo.SetEnabled(false);
                }
            }
            $('#ddl_numberingScheme').change(function () {

                if ($('#ddl_numberingScheme').val() == "") {
                    return;
                }

                var NoSchemeTypedtl = $(this).val();
                var NoSchemeType = NoSchemeTypedtl.toString().split('~')[1];
                var quotelength = NoSchemeTypedtl.toString().split('~')[2];


                if ($('#ddl_numberingScheme').val().split('~')[1] == "0") {
                    tstartdate.SetEnabled(true);
                } else {
                    tstartdate.SetEnabled(false);
                    tstartdate.SetDate(new Date);
                    cdeliveryDate.SetDate(tstartdate.GetDate());
                }

                var branchID = (NoSchemeTypedtl.toString().split('~')[3] != null) ? NoSchemeTypedtl.toString().split('~')[3] : "";
                ccmbFinancer.PerformCallback(branchID);
                if (branchID != "") document.getElementById('ddl_Branch').value = branchID;
                // if (document.getElementById('HdPosType').value != 'Crd') {
                $('#HdSelectedBranch').val(branchID);
                // }

                if ($('#hdBasketId').val() != "0") {
                    document.getElementById('hdnPageStatus').value = 'Rebindbasketgrid';
                    grid.PerformCallback('rebindgridFromBasket');
                }


                cddl_SalesAgent.PerformCallback(branchID);
                cmbUcpaymentCashLedgerChanged(ccmbUcpaymentCashLedger);
                cchallanNoScheme.PerformCallback('BindChallanScheme~' + NoSchemeTypedtl.toString().split('~')[3])
                //ctxt_PLQuoteNo.SetMaxLength(quotelength);
                if (NoSchemeType == '1') {
                    ctxt_PLQuoteNo.SetText('Auto');
                    ctxt_PLQuoteNo.SetEnabled(false);
                    //ctxt_PLQuoteNo.SetClientEnabled(false);

                    tstartdate.Focus();
                }
                else if (NoSchemeType == '0') {
                    ctxt_PLQuoteNo.SetEnabled(true);
                    ctxt_PLQuoteNo.GetInputElement().maxLength = quotelength;
                    //ctxt_PLQuoteNo.SetClientEnabled(true);
                    ctxt_PLQuoteNo.SetText('');
                    ctxt_PLQuoteNo.Focus();
                }
                else if (NoSchemeType == '2') {
                    ctxt_PLQuoteNo.SetText('Datewise');
                    ctxt_PLQuoteNo.SetEnabled(false);
                    //ctxt_PLQuoteNo.SetClientEnabled(false);

                    tstartdate.Focus();
                }
                else {
                    ctxt_PLQuoteNo.SetText('');
                    ctxt_PLQuoteNo.SetEnabled(false);
                    //ctxt_PLQuoteNo.SetClientEnabled(true);
                }
            });

            $('#ddl_Currency').change(function () {

                var CurrencyId = $(this).val();
                var ActiveCurrency = '<%=Session["ActiveCurrency"]%>'
                var Currency = ActiveCurrency.toString().split('~')[0];
                if (Currency != CurrencyId) {
                    if (ActiveCurrency != null) {
                        if (CurrencyId != '0') {
                            $.ajax({
                                type: "POST",
                                url: "PosSalesInvoice.aspx/GetCurrentConvertedRate",
                                data: "{'CurrencyId':'" + CurrencyId + "'}",
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (msg) {
                                    var currentRate = msg.d;
                                    if (currentRate != null) {
                                        //$('#txt_Rate').text(currentRate);
                                        ctxt_Rate.SetValue(currentRate);
                                    }
                                    else {
                                        ctxt_Rate.SetValue('1');
                                    }
                                    ReBindGrid_Currency();
                                }
                            });
                        }
                        else {
                            ctxt_Rate.SetValue("1");
                            ReBindGrid_Currency();
                        }
                    }
                }
                else {
                    ctxt_Rate.SetValue("1");
                    ReBindGrid_Currency();
                }
            });
        });

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

        function PopulateGSTCSTVAT(e) {
            var key = cddl_AmountAre.GetValue();
            //deleteAllRows();

            if (key == 1) {

                grid.GetEditor('TaxAmount').SetEnabled(true);
                cddlVatGstCst.SetEnabled(false);
                //cddlVatGstCst.PerformCallback('1');
                cddlVatGstCst.SetSelectedIndex(0);
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
                cddlVatGstCst.SetSelectedIndex(0);
                cddlVatGstCst.SetEnabled(false);
                cbtn_SaveRecords.SetVisible(false);
                if (grid.GetVisibleRowsOnPage() == 1) {
                    grid.batchEditApi.StartEdit(-1, 2);
                }


            }

        }

        //Date Function Start

        function Startdate(s, e) {
            grid.batchEditApi.EndEdit();
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


            var t = s.GetDate();
            ccmbGstCstVat.PerformCallback(t);
            ccmbGstCstVatcharge.PerformCallback(t);
            ctaxUpdatePanel.PerformCallback('DeleteAllTax');
            if (IsProduct == "Y") {
                $('#<%=hdfIsDelete.ClientID %>').val('D');
                $('#<%=HdUpdateMainGrid.ClientID %>').val('True');
                grid.UpdateEdit();
            }

            if (t == "")
            { $('#MandatorysDate').attr('style', 'display:block'); }
            else { $('#MandatorysDate').attr('style', 'display:none'); }
        }
        function Enddate(s, e) {

            var t = s.GetDate();
            if (t == "")
            { $('#MandatoryEDate').attr('style', 'display:block'); }
            else { $('#MandatoryEDate').attr('style', 'display:none'); }



            var sdate = tstartdate.GetValue();
            //var edate = tenddate.GetValue();

            //var startDate = new Date(sdate);
            //var endDate = new Date(edate);

            //if (startDate > endDate) {

            //    flag = false;
            //    $('#MandatoryEgSDate').attr('style', 'display:block');
            //}
            //else { $('#MandatoryEgSDate').attr('style', 'display:none'); }
        }

        //Date Function End

        // Popup Section

        function ShowCustom() {

            cPopup_wareHouse.Show();


        }

        // Popup Section End

    </script>
    <%--Sam Section End--%>

    <%--Sudip--%>
    <script>
        var IsProduct = "";
        var currentEditableVisibleIndex;
        var preventEndEditOnLostFocus = false;
        var lastProductID;
        var setValueFlag;
        var canCallBack = false;

        function GridCallBack() {
            grid.PerformCallback('Display');
            canCallBack = true;
        }
        function AllControlInitilize() {
            if (canCallBack) {
                grid.PerformCallback();

                if ($('#isBasketContainComponent').val() == 'yes') {
                    jAlert("You have selected Products for which Component exist. Components are shown for respective products. Enter Quantity and Values as applicable.", "Alert", function () { $('#ddl_numberingScheme').focus(); });
                }

                //document.getElementById('HdPosType').value != 'Crd' &&
                if (document.getElementById('HdPosType').value != 'IST') {
                    cmbUcpaymentCashLedgerChanged(ccmbUcpaymentCashLedger);
                    $('#HdSelectedBranch').val(document.getElementById('ddl_Branch').value);
                } else {
                    $('#idCashbalanace').hide();
                }



                if ($('#hdBasketId').val() != "0") {
                    SetInvoiceLebelValue();
                }



                if (document.getElementById('hdAddOrEdit').value == "Edit") {
                    isExecutiveHasLedger = 1;
                    $('#customerReceiptButtonSet').hide();
                    if (ccmbOldUnit.GetValue() == "1") {
                        $('#OldUnitSelectionButton').show();
                    } else {
                        $('#OldUnitSelectionButton').hide();
                    }
                    ctxt_PLQuoteNo.SetEnabled(true);
                    SetInvoiceLebelValue();
                } else {
                    $('#otherChargesId').hide();
                    $('#hdHsnList').val(',');
                }

                if (document.getElementById('HdPosType').value == 'Fin') {
                    $('#HeaderTextforPaymentDetails')[0].innerText = 'Down Payment Details';
                }
                canCallBack = false;
            }
        }






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
                grid.PerformCallback('CurrencyChangeDisplay');
            }
        }

        function ProductsCombo_SelectedIndexChanged(s, e) {
            pageheaderContent.style.display = "block";
            cddl_AmountAre.SetEnabled(false);

            var tbDescription = grid.GetEditor("Description");
            var tbUOM = grid.GetEditor("UOM");
            var tbSalePrice = grid.GetEditor("SalePrice");
            //var tbStkUOM = grid.GetEditor("StockUOM");
            //var tbStockQuantity = grid.GetEditor("StockQuantity");

            //var ProductID = (cCmbProduct.GetValue() != null) ? cCmbProduct.GetValue() : "0";
            //var strProductName = (cCmbProduct.GetText() != null) ? cCmbProduct.GetText() : "";
            var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            var ProductID = (grid.GetEditor('ProductID').GetValue() != null) ? grid.GetEditor('ProductID').GetValue() : "0";
            var SpliteDetails = ProductID.split("||@||");
            var strProductID = SpliteDetails[0];
            var strDescription = SpliteDetails[1];
            var strUOM = SpliteDetails[2];
            var strStkUOM = SpliteDetails[4];
            var strSalePrice = SpliteDetails[6];
            strProductName = strDescription;

            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            var IsPackingActive = SpliteDetails[10];
            var Packing_Factor = SpliteDetails[11];
            var Packing_UOM = SpliteDetails[12];

            var strRate = (ctxt_Rate.GetValue() != null && ctxt_Rate.GetValue() != "0") ? ctxt_Rate.GetValue() : "1";
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
            $('#<%= lblProduct.ClientID %>').text(strProductName);
            $('#<%= lblbranchName.ClientID %>').text(strBranch);

            if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                divPacking.style.display = "block";
            } else {
                divPacking.style.display = "none";
            }
            //divPacking.style.display = "none";

            //lblbranchName lblProduct
            //tbStkUOM.SetValue(strStkUOM);
            //tbStockQuantity.SetValue("0");
            //Debjyoti
            ctaxUpdatePanel.PerformCallback('DelProdbySl~' + grid.GetEditor("SrlNo").GetValue());
            //cacpAvailableStock.PerformCallback(strProductID);
        }
        function cmbContactPersonEndCall(s, e) {
            if (cContactPerson.cpDueDate != null) {
                var DeuDate = cContactPerson.cpDueDate;
                var myDate = new Date(DeuDate);

                cdt_SaleInvoiceDue.SetDate(myDate);
                cContactPerson.cpDueDate = null;
            }

            if (cContactPerson.cpTotalDue != null) {
                var TotalDue = cContactPerson.cpTotalDue;
                var TotalCustDue = "";
                if (TotalDue >= 0) {
                    TotalCustDue = TotalDue + ' Cr';
                    document.getElementById('<%=lblTotalDues.ClientID %>').style.color = "red";
                }
                else {
                    TotalDue = TotalDue * (-1);
                    TotalCustDue = TotalDue + ' Db';
                    document.getElementById('<%=lblTotalDues.ClientID %>').style.color = "black";
                }

                document.getElementById('<%=lblTotalDues.ClientID %>').innerHTML = TotalCustDue;
                pageheaderContent.style.display = "block";
                divDues.style.display = "block";
                cContactPerson.cpTotalDue = null;
            }

        }

        function OnEndCallback(s, e) {
            LoadingPanel.Hide();
            var value = document.getElementById('hdnRefreshType').value;
            //Debjyoti Check grid needs to be refreshed or not

            if (grid.cpTaggingTotalAmount) {
                if (grid.cpTaggingTotalAmount != '') {
                    var returnTaggingAmount = parseFloat(grid.cpTaggingTotalAmount);
                    cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(returnTaggingAmount) * 100) / 100).toFixed(2));
                    SetInvoiceLebelValue();
                    grid.cpTaggingTotalAmount = null;
                }
            }


            if ($('#<%=HdUpdateMainGrid.ClientID %>').val() == 'True') {
                $('#<%=HdUpdateMainGrid.ClientID %>').val('False');
                grid.PerformCallback('DateChangeDisplay');
            }

            if (grid.cpComponent) {
                if (grid.cpComponent == 'true') {
                    grid.cpComponent = null;
                    OnAddNewClick();
                }
            }

            if (grid.cpSaveSuccessOrFail == "outrange") {
                jAlert('Can Not Add More Invoice (POS) Number as Invoice (POS) Scheme Exausted.<br />Update The Scheme and Try Again');
                // OnAddNewClick();
                grid.StartEditRow(0);
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "duplicate") {
                //  OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('Can Not Save as Duplicate Invoice (POS) Numbe No. Found');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "quantityTagged") {
                //OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('Proforma is tagged in Sale Order. So, Quantity of selected products cannot be less than Ordered Quantity.');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "errorInsert") {
                //OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('Please try again later.');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "nullAmount") {
                //  OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('total amount cant not be zero(0).');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "nullQuantity") {
                //OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('Please fill Quantity');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "duplicateProduct") {
                //  OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('Can not save Duplicate Product in the Invoice (POS) List.');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "minSalePriceMust") {
                //OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('Sale Price Should be equal or higher than Min Sale Price');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "MRPLess") {
                //OnAddNewClick();
                grid.StartEditRow(0);
                jAlert('Sale Price Should be equal or less than MRP');
                grid.cpSaveSuccessOrFail = '';
            }
            else if (grid.cpSaveSuccessOrFail == "InValidReceipt") {
                grid.StartEditRow(0);
                jAlert('Mismatched found of HSN for the selected Product(s) and Advance(s). Correct and proceed.');
                grid.cpSaveSuccessOrFail = '';
            }

            else if (grid.cpSaveSuccessOrFail == "checkWarehouse") {
                var SrlNo = grid.cpProductSrlIDCheck;
                //OnAddNewClick();
                grid.StartEditRow(0);
                //   var msg = "Product Sales Quantity must be equal to Warehouse Quantity for SL No. " + SrlNo;
                var msg = 'You must enter Stock details for type "Already Delivered".';
                jAlert(msg);
                grid.cpSaveSuccessOrFail = '';
            }
            else {
                var Quote_Number = grid.cpQuotationNo;
                grid.cpQuotationNo = null;
                var Quote_Msg = "Invoice No. '" + Quote_Number + "' saved.";

                if (value == "E") {
                    if (grid.cpApproverStatus == "approve") {
                        window.parent.popup.Hide();
                        window.parent.cgridPendingApproval.PerformCallback();
                    }
                    else if (grid.cpApproverStatus == "rejected") {
                        window.parent.popup.Hide();
                        window.parent.cgridPendingApproval.PerformCallback();
                    }
                    else {
                        if (Quote_Number != "") {
                            if (grid.cpGeneratedInvoice) {
                                var newInvoiceId = grid.cpGeneratedInvoice;
                                var reportName = "";
                                if (document.getElementById('HdPosType').value == "Cash") {
                                    reportName = "POS-Cash~D";
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');

                                } else if (document.getElementById('HdPosType').value == "Crd") {
                                    reportName = "POS-Credit~D";
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');

                                } else if (document.getElementById('HdPosType').value == "Fin") {
                                    reportName = "POS-Finance~D";
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=3', '_blank');

                                } else if (document.getElementById('HdPosType').value == "IST") {
                                    reportName = "InterstateStockTransfer-GST~D";
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');
                                }


                              

                                if (grid.cpIsInstallRequired) {
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=IC-Default~D&modulename=Install_Coupon&id=" + newInvoiceId, '_blank');
                                }

                                window.location.assign("PosSalesInvoiceList.aspx");
                            }
                        }
                        else {
                            window.location.assign("PosSalesInvoiceList.aspx");
                        }
                    }

                }
                else if (value == "N") {
                    if (grid.cpApproverStatus == "approve") {
                        window.parent.popup.Hide();
                        window.parent.cgridPendingApproval.PerformCallback();
                    }
                    else {
                        if (Quote_Number != "") {

                            var newInvoiceId = grid.cpGeneratedInvoice;

                            var reportName = "";
                            if (document.getElementById('HdPosType').value == "Cash") {
                                reportName = "POS-Cash~D";
                                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');

                            } else if (document.getElementById('HdPosType').value == "Crd") {
                                reportName = "POS-Credit~D";
                                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');

                            } else if (document.getElementById('HdPosType').value == "Fin") {
                                reportName = "POS-Finance~D";
                                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');
                                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=3', '_blank');

                            } else if (document.getElementById('HdPosType').value == "IST") {
                                reportName = "InterstateStockTransfer-GST~D";
                                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=Invoice_POS&id=' + newInvoiceId + '&PrintOption=1', '_blank');
                            }


                            

                            if (grid.cpIsInstallRequired) {
                                window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=IC-Default~D&modulename=Install_Coupon&id=" + newInvoiceId, '_blank');
                                grid.cpIsInstallRequired = null;
                            }

                            window.location.reload();
                        }
                        else {
                            window.location.assign("PosSalesInvoice.aspx?key=ADD");
                        }
                    }
                }
                else {
                    var pageStatus = document.getElementById('hdnPageStatus').value;
                    if (pageStatus == "first") {
                        OnAddNewClick();
                        grid.batchEditApi.EndEdit();
                        // it has been commented by sam on 04032017 due to set focus from server side start
                        //document.getElementById("<%=ddl_numberingScheme.ClientID%>").focus();
                        // above part has been commented by sam on 04032017 due to set focus from server side start

                        $('#<%=hdnPageStatus.ClientID %>').val('');

                        var LocalCurrency = '<%=Session["LocalCurrency"]%>';
                        var basedCurrency = LocalCurrency.split("~");
                        if ($("#ddl_Currency").val() == basedCurrency[0]) {
                            ctxt_Rate.SetEnabled(false);
                        }
                    }
                    else if (pageStatus == "update") {
                        OnAddNewClick();
                        $('#<%=hdnPageStatus.ClientID %>').val('');
                        //document.getElementById("ddlInventory").disabled = true;

                        var LocalCurrency = '<%=Session["LocalCurrency"]%>';
                        var basedCurrency = LocalCurrency.split("~");
                        if ($("#ddl_Currency").val() == basedCurrency[0]) {
                            ctxt_Rate.SetEnabled(false);
                        }
                    }
                    else if (pageStatus == "Quoteupdate") {
                        grid.StartEditRow(0);
                        $('#<%=hdnPageStatus.ClientID %>').val('');
                    }
                    else if (pageStatus == "delete") {
                        grid.StartEditRow(0);

                        $('#<%=hdnPageStatus.ClientID %>').val('');
                    }
                    else if (pageStatus == "Rebindbasketgrid") {
                        grid.StartEditRow(0);
                        $('#<%=hdnPageStatus.ClientID %>').val('');
                    }
                    else {
                        grid.StartEditRow(0);
                    }
}


                //if (grid.cpReturnParameter) {
                //    if (grid.cpReturnParameter != '') {
                //        if (grid.cpReturnParameter == 'UpdateExistingData') {
                //            jAlert('Updated Successfully.', 'Alert', function () {
                //                window.location.assign("PosSalesInvoiceList.aspx");
                //            });
                //        }
                //        grid.cpReturnParameter = null;
                //    }
                //}

}

    if (gridquotationLookup.GetValue() != null) {
        grid.GetEditor('ComponentNumber').SetEnabled(false);
        grid.GetEditor('ProductName').SetEnabled(false);
        grid.GetEditor('Description').SetEnabled(false);
    }
    cProductsPopup.Hide();
}

        function Save_ButtonClick() {
            LoadingPanel.Show();



    flag = true;
    grid.batchEditApi.EndEdit();

    if (document.getElementById('PaymentTable')) {
        var table = document.getElementById('PaymentTable');
        if (table.rows[table.rows.length - 1].children[0].children[1].value != "-Select-") {
            flag = validatePaymentDetails(table.rows[table.rows.length - 1]);
        }

    }

    if (parseFloat(ctxtunitValue.GetValue()) != 0 && cOldUnitGrid.GetVisibleRowsOnPage() == 0) {
        jAlert("Selected data is having Old Unit value as " + parseFloat(Math.round(Math.abs(parseFloat($('#HdDiscountAmount').val())) * 100) / 100).toFixed(2) + ". Please select 'Yes' in Old Unit to enter product details and proceed.", "Alert", function () { ccmbOldUnit.Focus(); });
        flag = false;
        LoadingPanel.Hide();
    }

    if (flag) {
        if ($('#hdBasketId').val() != "0") {
            var receivedDisAmtByTab = parseFloat($('#HdDiscountAmount').val());
            var enteredDiscountAmt = parseFloat(ctxtunitValue.GetValue());
            if (receivedDisAmtByTab != enteredDiscountAmt) {
                flag = false;
                LoadingPanel.Hide();
                jAlert("Selected data is having Old Unit value as " + parseFloat(Math.round(Math.abs(receivedDisAmtByTab) * 100) / 100).toFixed(2) + ". Please select 'Yes' in Old Unit to enter product details and proceed.", "Alert", function () { ccmbOldUnit.Focus(); });
            }
        }
    }
    if (flag) {
        flag = isEnteredAmountValid();
    }

    if (flag) {
        if (document.getElementById('HdPosType').value != 'Crd' && document.getElementById('HdPosType').value != 'Fin') {
            var EnteredCashAmount = parseFloat($('#cmbUcpaymentCashLedgerAmt').val());
            if (CustomerCurrentDateAmount + EnteredCashAmount >= 200000) {
                jAlert("Cannot Receive more than  1,99,999.00 on a single day.");
                flag = false;
                LoadingPanel.Hide();
            }
        }
    }

    //Delivery Date Checking
    if (cdeliveryDate.GetDate() == null) {
        $('#MandatorysdeliveryDate').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    } else if (cdeliveryDate.GetDate() < tstartdate.GetDate()) {
        $('#MandatorysdeliveryDate').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    }
    else {
        $('#MandatorysdeliveryDate').attr('style', 'display:none');
    }

    // Quote no validation Start
    var QuoteNo = ctxt_PLQuoteNo.GetText();
    if (QuoteNo == '' || QuoteNo == null) {
        $('#MandatorysQuoteno').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    }
    else {
        $('#MandatorysQuoteno').attr('style', 'display:none');
    }
    // Quote no validation End
    if (ccmbDeliveryType.GetValue() == "0") {
        $('#mandetorydeliveryType').show();
        flag = false;
        LoadingPanel.Hide();
    } else {
        $('#mandetorydeliveryType').hide();
    }

    if (ccmbDeliveryType.GetValue() == 'D') {
        if (cchallanNoScheme.GetValue() == null) {
            $('#mandetorydchallanNoScheme').attr('style', 'display:block');
            flag = false;
            LoadingPanel.Hide();
        } else {
            $('#mandetorydchallanNoScheme').attr('style', 'display:none');
            if (ctxtChallanNo.GetText().trim() == '') {
                $('#mandetorydtxtChallanNo').attr('style', 'display:block');
                flag = false;
                LoadingPanel.Hide();
            } else {
                $('#mandetorydtxtChallanNo').attr('style', 'display:none');
            }
        }
    }

    // Quote Date validation Start
    var sdate = tstartdate.GetValue();
    var edate = tenddate.GetValue();

    var startDate = new Date(sdate);
    var endDate = new Date(edate);
    if (sdate == null || sdate == "") {
        flag = false;
        LoadingPanel.Hide();
        $('#MandatorysDate').attr('style', 'display:block');
    }
    else { $('#MandatorysDate').attr('style', 'display:none'); }
    if (sdate == "") {
        flag = false;
        LoadingPanel.Hide();
        $('#MandatoryEDate').attr('style', 'display:block');
    }
    else {
        $('#MandatoryEDate').attr('style', 'display:none');

    }
    // Quote Date validation End

    // Quote Customer validation Start
    var customerId = GetObjectID('hdnCustomerId').value
    if (customerId == '' || customerId == null) {

        $('#MandatorysCustomer').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    }
    else {
        $('#MandatorysCustomer').attr('style', 'display:none');
    }
    // Quote Customer validation End
    //var amtare = cddl_AmountAre.GetValue();
    //if (amtare == '2') {
    //    var taxcodeid = cddlVatGstCst.GetValue();
    //    if (taxcodeid == '' || taxcodeid == null) {
    //        $('#Mandatorytaxcode').attr('style', 'display:block');
    //        flag = false;
    //    }
    //    else {
    //        $('#Mandatorytaxcode').attr('style', 'display:none');
    //    }
    //}

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
            //divSubmitButton.style.display = "none";
            var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
            $('#<%=hdfLookupCustomer.ClientID %>').val(customerval);

            $('#<%=hdnRefreshType.ClientID %>').val('N');
            $('#<%=hdfIsDelete.ClientID %>').val('I');
            grid.batchEditApi.EndEdit();

            //   if (document.getElementById('HdPosType').value != 'Crd' ) {
            SelectAllData(gridUpdateEdit);
            //} else {
            //    gridUpdateEdit();
            //}


        }
        else {
            jAlert('Please add atleast single record first');
            LoadingPanel.Hide();
        }
    } else {
        LoadingPanel.Hide();
    }
}


function isEnteredAmountValid() {
    var returnValue = true;
    var enteredAmount = 0;
    var otherCharges = parseFloat(cbnrOtherChargesvalue.GetValue());
    if (document.getElementById('HdPosType').value != 'IST') {
        enteredAmount = parseFloat(GetPaymentTotalEnteredAmount());
    }

    //- parseFloat(ctxtprocFee.GetValue()) - parseFloat(ctxtEmiOtherCharges.GetValue())
    var unPaidAmount = parseFloat(ctxtunitValue.GetValue()) + parseFloat(cbnrLblLessAdvanceValue.GetValue()) + parseFloat(ctxtFinanceAmt.GetValue()) + enteredAmount - otherCharges;
    // if (document.getElementById('HdPosType').value != 'Fin') {



    if (document.getElementById('HdPosType').value != 'Crd' && document.getElementById('HdPosType').value != 'Fin' && document.getElementById('HdPosType').value != 'IST') {

        if (parseFloat(cbnrlblAmountWithTaxValue.GetValue()) != unPaidAmount) {
            jAlert("Mismatch detected in between Invoice Amount and Payment Amount. Cannot proceed.", "Alert", function () {
                $('#cmbUcpaymentCashLedgerAmt').focus();
            });
            returnValue = false;
        }
    }
    else if (document.getElementById('HdPosType').value == 'Fin') {
        var runningBal = parseFloat(clblRunningBalanceCapsul.GetValue());
        if (runningBal > 0) {
            jAlert("Mismatch detected in between Invoice Amount and Payment Amount. Cannot proceed.", "Alert", function () {

            });
            returnValue = false;
        }
    }
    //}
    //else {
    //    if (parseFloat(clblRunningBalanceCapsul.GetValue()) != parseFloat(ctxtFinanceAmt.GetValue())) {
    //        jAlert("Mismatch detected in between Invoice Amount and Payment Amount. Cannot proceed.", "Alert", function () {
    //            ctxtFinanceAmt.Focus();
    //        });
    //        returnValue = false;
    //    }
    //}

    return returnValue;
}

function SaveExit_ButtonClick(s, e) {
    LoadingPanel.Show();

    flag = true;
    grid.batchEditApi.EndEdit();

    if (document.getElementById('PaymentTable')) {
        if (document.getElementById('hdAddOrEdit').value == "Add") {
            var table = document.getElementById('PaymentTable');
            if (table.rows[table.rows.length - 1].children[0].children[1].value != "-Select-") {
                flag = validatePaymentDetails(table.rows[table.rows.length - 1]);
            }
        }
    }

    if (parseFloat(ctxtunitValue.GetValue()) != 0 && cOldUnitGrid.GetVisibleRowsOnPage() == 0) {
        jAlert("Selected data is having Old Unit value as " + parseFloat(Math.round(Math.abs(parseFloat($('#HdDiscountAmount').val())) * 100) / 100).toFixed(2) + ". Please select 'Yes' in Old Unit to enter product details and proceed.", "Alert", function () { ccmbOldUnit.Focus(); });
        flag = false;
        LoadingPanel.Hide();
    }


    if (flag) {
        if ($('#hdBasketId').val() != "0") {
            var receivedDisAmtByTab = parseFloat($('#HdDiscountAmount').val());
            var enteredDiscountAmt = parseFloat(ctxtunitValue.GetValue());
            if (receivedDisAmtByTab != enteredDiscountAmt) {
                flag = false;
                jAlert("Selected data is having Old Unit value as " + parseFloat(Math.round(Math.abs(receivedDisAmtByTab) * 100) / 100).toFixed(2) + ". Please select 'Yes' in Old Unit to enter product details and proceed.", "Alert", function () { ccmbOldUnit.Focus(); });
                LoadingPanel.Hide();
            }
        }
    }
    if (flag) {
        flag = isEnteredAmountValid();
    }

    if (flag) {
        if (document.getElementById('HdPosType').value != 'Crd' && document.getElementById('HdPosType').value != 'Fin') {
            var EnteredCashAmount = parseFloat($('#cmbUcpaymentCashLedgerAmt').val());
            if (CustomerCurrentDateAmount + EnteredCashAmount >= 200000) {
                jAlert("Cannot Receive more than  1,99,999.00 on a single day.");
                flag = false;
                LoadingPanel.Hide();
            }
        }
    }
    //Delivery Date Checking
    if (cdeliveryDate.GetDate() == null) {
        $('#MandatorysdeliveryDate').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    } else if (cdeliveryDate.GetDate() < tstartdate.GetDate()) {
        $('#MandatorysdeliveryDate').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    }
    else {
        $('#MandatorysdeliveryDate').attr('style', 'display:none');
    }


    // Quote no validation Start
    var QuoteNo = ctxt_PLQuoteNo.GetText();
    if (QuoteNo == '' || QuoteNo == null) {
        $('#MandatorysQuoteno').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    }
    else {
        $('#MandatorysQuoteno').attr('style', 'display:none');
    }
    // Quote no validation End
    if (ccmbDeliveryType.GetValue() == "0") {
        $('#mandetorydeliveryType').show();
        flag = false;
        LoadingPanel.Hide();
    } else {
        $('#mandetorydeliveryType').hide();
    }

    if (ccmbDeliveryType.GetValue() == 'D') {
        if (cchallanNoScheme.GetValue() == null) {
            $('#mandetorydchallanNoScheme').attr('style', 'display:block');
            flag = false;
            LoadingPanel.Hide();
        } else {
            $('#mandetorydchallanNoScheme').attr('style', 'display:none');
            if (ctxtChallanNo.GetText().trim() == '') {
                $('#mandetorydtxtChallanNo').attr('style', 'display:block');
                flag = false;
                LoadingPanel.Hide();
            } else {
                $('#mandetorydtxtChallanNo').attr('style', 'display:none');
            }
        }
    }


    // Quote Date validation Start
    var sdate = tstartdate.GetValue();
    var edate = tenddate.GetValue();

    var startDate = new Date(sdate);
    var endDate = new Date(edate);
    if (sdate == null || sdate == "") {
        flag = false;
        $('#MandatorysDate').attr('style', 'display:block');
    }
    else { $('#MandatorysDate').attr('style', 'display:none'); }
    if (sdate == "") {
        flag = false;
        $('#MandatoryEDate').attr('style', 'display:block');
    }
    else {
        $('#MandatoryEDate').attr('style', 'display:none');

    }

    if (flag) {
        if (document.getElementById('HdPosType').value == 'Fin') {
            if (isExecutiveHasLedger == 0) {
                jAlert("No ledger is mapped for the selected Financer.", "Alert", function () {
                    ccmbFinancer.Focus();
                });
                flag = false;
                LoadingPanel.Hide();
            }


        }
    }
    // Quote Date validation End

    // Quote Customer validation Start
    var customerId = GetObjectID('hdnCustomerId').value
    if (customerId == '' || customerId == null) {
        $('#MandatorysCustomer').attr('style', 'display:block');
        flag = false;
        LoadingPanel.Hide();
    }
    else {
        $('#MandatorysCustomer').attr('style', 'display:none');
    }
    // Quote Customer validation End

    //var amtare = cddl_AmountAre.GetValue();
    //if (amtare == '2') {
    //    var taxcodeid = cddlVatGstCst.GetValue();
    //    if (taxcodeid == '' || taxcodeid == null) {
    //        $('#Mandatorytaxcode').attr('style', 'display:block');
    //        flag = false;
    //    }
    //    else {
    //        $('#Mandatorytaxcode').attr('style', 'display:none');
    //    }
    //}

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
            //divSubmitButton.style.display = "none";
            var customerval = (gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) != null) ? gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex()) : "";
            $('#<%=hdfLookupCustomer.ClientID %>').val(customerval);

            $('#<%=hdnRefreshType.ClientID %>').val('E');
            $('#<%=hdfIsDelete.ClientID %>').val('I');
            grid.batchEditApi.EndEdit();



            if (document.getElementById('HdPosType').value != 'IST') {

                SelectAllData(gridUpdateEdit);

            } else {
                gridUpdateEdit();
            }

            // grid.UpdateEdit();
        }
        else {
            jAlert('Please add atleast single record first');
            LoadingPanel.Hide();
        }
    } else {
        LoadingPanel.Hide();
        if (document.getElementById('hdAddOrEdit').value != "Add") {
            e.processOnServer = false;
        }
    }

}

function gridUpdateEdit() {

if (document.getElementById('hdAddOrEdit').value != "Edit") {
    OnAddNewClick();
    grid.UpdateEdit();
}

    // grid.PerformCallback('UpdateExistingData');
}

function QuantityTextChange(s, e) {
    pageheaderContent.style.display = "block";
    var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
    var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
    var key = gridquotationLookup.GetGridView().GetRowKey(gridquotationLookup.GetGridView().GetFocusedRowIndex());

    if (parseFloat(QuantityValue) != parseFloat(ProductGetQuantity)) {
        if (ProductID != null) {
            var SpliteDetails = ProductID.split("||@||");
            var strMultiplier = SpliteDetails[7];
            var strFactor = SpliteDetails[8];
            var strRate = (ctxt_Rate.GetValue() != null && ctxt_Rate.GetValue() != "0") ? ctxt_Rate.GetValue() : "1";

            if (key != null && key != '') {
                var IsComponentProduct = SpliteDetails[15];
                var ComponentProduct = SpliteDetails[16];
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

            var strProductID = SpliteDetails[0];
            var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            var ddlbranch = $("[id*=ddl_Branch]");
            var strBranch = ddlbranch.find("option:selected").text();

            var strStkUOM = SpliteDetails[4];
            var strSalePrice = SpliteDetails[6];

            if (strRate == 0) {
                strRate = 1;
            }

            var StockQuantity = strMultiplier * QuantityValue;
            var Amount = QuantityValue * strFactor * (strSalePrice / strRate);

            $('#<%= lblStkQty.ClientID %>').text(StockQuantity);
            $('#<%= lblStkUOM.ClientID %>').text(strStkUOM);
            $('#<%= lblProduct.ClientID %>').text(strProductName);
            $('#<%= lblbranchName.ClientID %>').text(strBranch);

            var IsPackingActive = SpliteDetails[10];
            var Packing_Factor = SpliteDetails[11];
            var Packing_UOM = SpliteDetails[12];
            var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

            if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                divPacking.style.display = "block";
            } else {
                divPacking.style.display = "none";
            }

            //var tbStockQuantity = grid.GetEditor("StockQuantity");
            //tbStockQuantity.SetValue(StockQuantity);

            var tbAmount = grid.GetEditor("Amount");
            tbAmount.SetValue(Amount);

            var tbTotalAmount = grid.GetEditor("TotalAmount");
            tbTotalAmount.SetValue(Amount);

            DiscountTextChange(s, e);



            //  cacpAvailableStock.PerformCallback(strProductID);
        }
        else {
            jAlert('Select a product first.');
            grid.GetEditor('Quantity').SetValue('0');
            grid.GetEditor('ProductID').Focus();
        }
    }
}

/// Code Added By Sam on 23022017 after make editable of sale price field Start

function SalePriceTextChange(s, e) {
    pageheaderContent.style.display = "block";
    var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
    var Saleprice = (grid.GetEditor('SalePrice').GetValue() != null) ? grid.GetEditor('SalePrice').GetValue() : "0";
    var ProductID = grid.GetEditor('ProductID').GetValue();
    if (ProductID != null) {
        var SpliteDetails = ProductID.split("||@||");
        console.log(SpliteDetails);

        if (parseFloat(s.GetValue()) < parseFloat(SpliteDetails[17])) {
            jAlert("Sale price cannot be lesser than Min Sale Price locked as: " + parseFloat(Math.round(Math.abs(parseFloat(SpliteDetails[17])) * 100) / 100).toFixed(2), "Alert", function () {
                grid.batchEditApi.StartEdit(globalRowIndex, 10);
                return;
            });
            s.SetValue(parseFloat(SpliteDetails[6]));
            return;
        }



        if ($('#hdBasketId').val() == "0") {
            if (parseFloat(SpliteDetails[18]) != 0 && parseFloat(s.GetValue()) > parseFloat(SpliteDetails[18])) {
                jAlert("Sale price cannot be greater than MRP locked as: " + parseFloat(Math.round(Math.abs(parseFloat(SpliteDetails[18])) * 100) / 100).toFixed(2), "Alert", function () {
                    grid.batchEditApi.StartEdit(globalRowIndex, 10);
                    return;
                });
                s.SetValue(parseFloat(SpliteDetails[6]));
                return;
            }
        }

        var strMultiplier = SpliteDetails[7];
        var strFactor = SpliteDetails[8];
        var strRate = (ctxt_Rate.GetValue() != null && ctxt_Rate.GetValue() != "0") ? ctxt_Rate.GetValue() : "1";
        //var strRate = "1";
        var strStkUOM = SpliteDetails[4];
        //var strSalePrice = SpliteDetails[6];

        var strProductID = SpliteDetails[0];
        var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
        var ddlbranch = $("[id*=ddl_Branch]");
        var strBranch = ddlbranch.find("option:selected").text();

        if (strRate == 0) {
            strRate = 1;
        }

        var StockQuantity = strMultiplier * QuantityValue;
        var Discount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";

        var Amount = QuantityValue * strFactor * (Saleprice / strRate);
        var amountAfterDiscount = parseFloat(Amount) - ((parseFloat(Discount) * parseFloat(Amount)) / 100);

        var tbAmount = grid.GetEditor("Amount");
        tbAmount.SetValue(amountAfterDiscount);

        var tbTotalAmount = grid.GetEditor("TotalAmount");
        tbTotalAmount.SetValue(amountAfterDiscount);

        //GetShipping State Value
        var ShippingStateCode = '';
        if (cchkBilling.GetValue()) {
            ShippingStateCode = CmbState.GetValue();
        } else {
            ShippingStateCode = CmbState1.GetValue();
        }

        caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[19], Amount, amountAfterDiscount, 'I', ShippingStateCode, $('#ddl_Branch').val())

        var finalNetAmount = parseFloat(tbTotalAmount.GetValue());
        var finalAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) + (finalNetAmount - globalNetAmount);
        cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(finalAmount) * 100) / 100).toFixed(2));
        cbnrLblTaxableAmtval.SetText(grid.GetEditor("Amount").GetText());
        cbnrLblTaxAmtval.SetText(grid.GetEditor("TaxAmount").GetText());

        SetInvoiceLebelValue();

        $('#<%= lblProduct.ClientID %>').text(strProductName);
        $('#<%= lblbranchName.ClientID %>').text(strBranch);

        var IsPackingActive = SpliteDetails[10];
        var Packing_Factor = SpliteDetails[11];
        var Packing_UOM = SpliteDetails[12];
        var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

        if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
            $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
            divPacking.style.display = "block";
        } else {
            divPacking.style.display = "none";
        }




        cacpAvailableStock.PerformCallback(strProductID);
    }
    else {
        jAlert('Select a product first.');
        grid.GetEditor('SalePrice').SetValue('0');
        grid.GetEditor('ProductID').Focus();
    }
}


/// Code Above Added By Sam on 23022017 after make editable of sale price field End




function DiscountTextChange(s, e) {
    //var Amount = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
    var Discount = (grid.GetEditor('Discount').GetValue() != null) ? grid.GetEditor('Discount').GetValue() : "0";

    var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
    var ProductID = grid.GetEditor('ProductID').GetValue();
    if (ProductID != null) {
        var SpliteDetails = ProductID.split("||@||");
        var strFactor = SpliteDetails[8];
        var strRate = (ctxt_Rate.GetValue() != null && ctxt_Rate.GetValue() != "0") ? ctxt_Rate.GetValue() : "1";
        var strSalePrice = (grid.GetEditor('SalePrice').GetValue() != null) ? grid.GetEditor('SalePrice').GetValue() : "0";
        if (strSalePrice == '0') {
            strSalePrice = SpliteDetails[6];
        }
        if (strRate == 0) {
            strRate = 1;
        }
        var Amount = QuantityValue * strFactor * (strSalePrice / strRate);

        var amountAfterDiscount = parseFloat(Amount) - ((parseFloat(Discount) * parseFloat(Amount)) / 100);

        var tbAmount = grid.GetEditor("Amount");
        tbAmount.SetValue(amountAfterDiscount);

        var IsPackingActive = SpliteDetails[10];
        var Packing_Factor = SpliteDetails[11];
        var Packing_UOM = SpliteDetails[12];
        var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

        if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
            $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
            divPacking.style.display = "block";
        } else {
            divPacking.style.display = "none";
        }

        var tbTotalAmount = grid.GetEditor("TotalAmount");
        tbTotalAmount.SetValue(amountAfterDiscount);


        var ShippingStateCode = '';
        if (cchkBilling.GetValue()) {
            ShippingStateCode = CmbState.GetValue();
        } else {
            ShippingStateCode = CmbState1.GetValue();
        }
        caluculateAndSetGST(grid.GetEditor("Amount"), grid.GetEditor("TaxAmount"), grid.GetEditor("TotalAmount"), SpliteDetails[19], Amount, amountAfterDiscount, 'I', ShippingStateCode, $('#ddl_Branch').val());


        var finalNetAmount = parseFloat(tbTotalAmount.GetValue());
        var finalAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) + (finalNetAmount - globalNetAmount);
        cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(finalAmount) * 100) / 100).toFixed(2));
        cbnrLblTaxableAmtval.SetText(grid.GetEditor("Amount").GetText());
        cbnrLblTaxAmtval.SetText(grid.GetEditor("TaxAmount").GetText());
        SetInvoiceLebelValue();
    }
    else {
        jAlert('Select a product first.');
        grid.GetEditor('Discount').SetValue('0');
        grid.GetEditor('ProductID').Focus();
    }
    //Debjyoti 
    //  grid.GetEditor('TaxAmount').SetValue(0);

    var _TotalAmount = (grid.GetEditor('TotalAmount').GetValue() != null) ? grid.GetEditor('TotalAmount').GetValue() : "0";

    if (parseFloat(_TotalAmount) != parseFloat(ProductGetTotalAmount)) {
        ctaxUpdatePanel.PerformCallback('DelQtybySl~' + grid.GetEditor("SrlNo").GetValue());
    }
}
function AddBatchNew(s, e) {
    var ProductIDValue = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";

    var globalRow_Index = 0;
    if (globalRowIndex > 0) {
        globalRow_Index = globalRowIndex + 1;
    }
    else {
        globalRow_Index = globalRowIndex - 1;
    }


    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode === 13) {
        if (ProductIDValue != "") {
            //var noofvisiblerows = grid.GetVisibleRowsOnPage();
            //var i;
            //var cnt = 2;

            grid.batchEditApi.EndEdit();

            grid.AddNewRow();
            grid.SetFocusedRowIndex();
            var noofvisiblerows = grid.GetVisibleRowsOnPage();

            var tbQuotation = grid.GetEditor("SrlNo");
            tbQuotation.SetValue(noofvisiblerows);

            grid.batchEditApi.StartEdit(globalRow_Index, 2);
            //grid.batchEditApi.StartEdit(-1, 1);
        }
    }
}
function OnAddNewClick(callback) {
    if (gridquotationLookup.GetValue() == null) {
        grid.AddNewRow();

        var noofvisiblerows = grid.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
        var tbQuotation = grid.GetEditor("SrlNo");
        tbQuotation.SetValue(noofvisiblerows);
    }
    else {
        QuotationNumberChanged();
    }



}

function Save_TaxClick() {
    if (gridTax.GetVisibleRowsOnPage() > 0) {
        gridTax.UpdateEdit();
    }
    else {
        gridTax.PerformCallback('SaveGst');
    }
    cPopup_Taxes.Hide();
}

var Warehouseindex;
function OnCustomButtonClick(s, e) {

    if (e.buttonID == 'CustomDelete') {
        grid.batchEditApi.StartEdit(e.visibleIndex);
        var SrlNo = grid.batchEditApi.GetCellValue(e.visibleIndex, 'SrlNo');
        var totalNetAmount = grid.batchEditApi.GetCellValue(e.visibleIndex, 'TotalAmount');

        grid.batchEditApi.EndEdit();

        $('#<%=hdnRefreshType.ClientID %>').val('');
        $('#<%=hdnDeleteSrlNo.ClientID %>').val(SrlNo);
        var noofvisiblerows = grid.GetVisibleRowsOnPage();

        if (gridquotationLookup.GetValue() != null) {
            var type = ($("[id$='rdl_SaleInvoice']").find(":checked").val() != null) ? $("[id$='rdl_SaleInvoice']").find(":checked").val() : "";
            var messege = "";
            if (type == "QO") {
                messege = "Cannot Delete using this button as the Proforma is linked with this Sale Invoice.<br /> Click on Plus(+) sign to Add or Delete Product from last column !";
            }
            else if (type == "SO") {
                messege = "Cannot Delete using this button as the Sales Order is linked with this Sale Invoice.<br /> Click on Plus(+) sign to Add or Delete Product from last column !";
            }
            else if (type == "SC") {
                messege = "Cannot Delete using this button as the Sales Challan is linked with this Sale Invoice.<br /> Click on Plus(+) sign to Add or Delete Product from last column !";
            }

            jAlert(messege, 'Alert Dialog: [Delete Challan Products]', function (r) {
            });
        }
        else {
            if (noofvisiblerows != "1") {

                var newTotalNetAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) - parseFloat(totalNetAmount);
                cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(newTotalNetAmount) * 100) / 100).toFixed(2));
                SetInvoiceLebelValue();

                var prodIDForHsn = grid.batchEditApi.GetCellValue(e.visibleIndex, 'ProductID').split("||@||");
                if (prodIDForHsn.length > 19) {
                    var HSNSac = prodIDForHsn[19];
                    RemoveHSnSacFromList(HSNSac);
                }


                grid.DeleteRow(e.visibleIndex);

                $('#<%=hdfIsDelete.ClientID %>').val('D');
                grid.UpdateEdit();
                grid.PerformCallback('Display');

                $('#<%=hdnPageStatus.ClientID %>').val('delete');
                //grid.batchEditApi.StartEdit(-1, 2);
                //grid.batchEditApi.StartEdit(0, 2);
            }
        }
    }
    else if (e.buttonID == 'AddNew') {
        var ProductIDValue = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
        if (ProductIDValue != "") {
            var SpliteDetails = ProductIDValue.split("||@||");
            var IsComponentProduct = SpliteDetails[15];
            var ComponentProduct = SpliteDetails[16];

            if (IsComponentProduct == "Y") {
                var messege = "Selected product is defined with components.<br/> Would you like to proceed with components (" + ComponentProduct + ") ?";
                jConfirm(messege, 'Confirmation Dialog', function (r) {
                    if (r == true) {
                        grid.batchEditApi.StartEdit(e.visibleIndex, 2);
                        grid.GetEditor("IsComponentProduct").SetValue("Y");
                        $('#<%=hdfIsDelete.ClientID %>').val('C');

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
            else {
                OnAddNewClick();
            }
        }
        else {
            grid.batchEditApi.StartEdit(e.visibleIndex, 2);
        }
    }
    else if (e.buttonID == 'CustomWarehouse') {

        var index = e.visibleIndex;

        if (ccmbDeliveryType.GetValue() != "D") {
            jAlert("Only Applicable for delivery type 'Already Delivered'.");
            return;
        }

        grid.batchEditApi.StartEdit(index, 2)
        Warehouseindex = index;

        var SrlNo = (grid.GetEditor('SrlNo').GetValue() != null) ? grid.GetEditor('SrlNo').GetValue() : "";
        var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
        var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
        //var StkQuantityValue = (grid.GetEditor('StockQuantity').GetValue() != null) ? grid.GetEditor('StockQuantity').GetValue() : "0";

        $("#spnCmbWarehouse").hide();
        $("#spnCmbBatch").hide();
        $("#spncheckComboBox").hide();
        $("#spntxtQuantity").hide();

        if (ProductID != "" && parseFloat(QuantityValue) != 0) {
            var SpliteDetails = ProductID.split("||@||");
            var strProductID = SpliteDetails[0];
            var strDescription = SpliteDetails[1];
            var strUOM = SpliteDetails[2];
            var strStkUOM = SpliteDetails[4];
            var strMultiplier = SpliteDetails[7];
            var strProductName = strDescription;
            //var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "";
            var StkQuantityValue = QuantityValue * strMultiplier;
            var Ptype = SpliteDetails[14];
            $('#<%=hdfProductType.ClientID %>').val(Ptype);

            document.getElementById('<%=lblProductName.ClientID %>').innerHTML = strProductName;
            document.getElementById('<%=txt_SalesAmount.ClientID %>').innerHTML = QuantityValue;
            document.getElementById('<%=txt_SalesUOM.ClientID %>').innerHTML = strUOM;
            document.getElementById('<%=txt_StockAmount.ClientID %>').innerHTML = StkQuantityValue;
            document.getElementById('<%=txt_StockUOM.ClientID %>').innerHTML = strStkUOM;

            $('#<%=hdfProductID.ClientID %>').val(strProductID);
            $('#<%=hdfProductSerialID.ClientID %>').val(SrlNo);
            $('#<%=hdfProductSerialID.ClientID %>').val(SrlNo);
            $('#<%=hdnProductQuantity.ClientID %>').val(QuantityValue);
            cacpAvailableStock.PerformCallback(strProductID);

            if (Ptype == "W") {
                div_Warehouse.style.display = 'block';
                div_Batch.style.display = 'none';
                div_Serial.style.display = 'none';
                div_Quantity.style.display = 'block';
                cCmbWarehouse.PerformCallback('BindWarehouse');
                cGrdWarehouse.PerformCallback('Display~' + SrlNo);

                SelectedWarehouseID = "0";
                cPopup_Warehouse.Show();
            }
            else if (Ptype == "B") {
                div_Warehouse.style.display = 'none';
                div_Batch.style.display = 'block';
                div_Serial.style.display = 'none';
                div_Quantity.style.display = 'block';
                cCmbBatch.PerformCallback('BindBatch~' + "0");
                cGrdWarehouse.PerformCallback('Display~' + SrlNo);

                SelectedWarehouseID = "0";
                cPopup_Warehouse.Show();
            }
            else if (Ptype == "S") {
                div_Warehouse.style.display = 'none';
                div_Batch.style.display = 'none';
                div_Serial.style.display = 'block';
                div_Quantity.style.display = 'none';
                checkListBox.PerformCallback('BindSerial~' + "0" + '~' + "0");
                cGrdWarehouse.PerformCallback('Display~' + SrlNo);

                SelectedWarehouseID = "0";
                cPopup_Warehouse.Show();
            }
            else if (Ptype == "WB") {
                div_Warehouse.style.display = 'block';
                div_Batch.style.display = 'block';
                div_Serial.style.display = 'none';
                div_Quantity.style.display = 'block';
                cCmbWarehouse.PerformCallback('BindWarehouse');
                cGrdWarehouse.PerformCallback('Display~' + SrlNo);

                SelectedWarehouseID = "0";
                cPopup_Warehouse.Show();
            }
            else if (Ptype == "WS") {
                div_Warehouse.style.display = 'block';
                div_Batch.style.display = 'none';
                div_Serial.style.display = 'block';
                div_Quantity.style.display = 'none';
                cCmbWarehouse.PerformCallback('BindWarehouse');
                cGrdWarehouse.PerformCallback('Display~' + SrlNo);

                SelectedWarehouseID = "0";
                cPopup_Warehouse.Show();
            }
            else if (Ptype == "WBS") {
                div_Warehouse.style.display = 'block';
                div_Batch.style.display = 'block';
                div_Serial.style.display = 'block';
                div_Quantity.style.display = 'none';
                cCmbWarehouse.PerformCallback('BindWarehouse');
                cGrdWarehouse.PerformCallback('Display~' + SrlNo);

                SelectedWarehouseID = "0";
                cPopup_Warehouse.Show();
            }
            else if (Ptype == "BS") {
                div_Warehouse.style.display = 'none';
                div_Batch.style.display = 'block';
                div_Serial.style.display = 'block';
                div_Quantity.style.display = 'none';
                cCmbBatch.PerformCallback('BindBatch~' + "0");
                cGrdWarehouse.PerformCallback('Display~' + SrlNo);

                SelectedWarehouseID = "0";
                cPopup_Warehouse.Show();
            }
            else {
                //div_Warehouse.style.display = 'none';
                //div_Batch.style.display = 'none';
                //div_Serial.style.display = 'none';
                //div_Quantity.style.display = 'none';
                jAlert("Please enter Quantity !");
                //var strconfirm = confirm("No Warehouse or Batch or Serial is actived.");
                //if (strconfirm == true) {
                //    grid.batchEditApi.StartEdit(index, 5);
                //}
                //else {
                //    grid.batchEditApi.StartEdit(index, 5);
                //}

                //jAlert("No Warehouse or Batch or Serial is actived.");
            }
        }
        else if (ProductID != "" && parseFloat(QuantityValue) == 0) {
            jAlert('Please enter Quantity.');
        }
    }
}

function FinalWarehouse() {
    cGrdWarehouse.PerformCallback('WarehouseFinal');
}

function closeWarehouse(s, e) {
    e.cancel = false;
    cGrdWarehouse.PerformCallback('WarehouseDelete');
}

function OnWarehouseEndCallback(s, e) {
    var Ptype = document.getElementById('hdfProductType').value;

    if (cGrdWarehouse.cpIsSave == "Y") {
        cPopup_Warehouse.Hide();
        grid.batchEditApi.StartEdit(Warehouseindex, 5);
    }
    else if (cGrdWarehouse.cpIsSave == "N") {
        jAlert('Sales Quantity must be equal to Warehouse Quantity.');
    }
    else {
        if (document.getElementById("myCheck").checked == true) {
            if (IsPostBack == "N") {
                checkListBox.PerformCallback('BindSerial~' + PBWarehouseID + '~' + PBBatchID);

                IsPostBack = "";
                PBWarehouseID = "";
                PBBatchID = "";
            }

            if (Ptype == "W" || Ptype == "WB") {
                cCmbWarehouse.Focus();
            }
            else if (Ptype == "B") {
                cCmbBatch.Focus();
            }
            else {
                ctxtserial.Focus();
            }
        }
        else {
            if (Ptype == "W" || Ptype == "WB" || Ptype == "WS" || Ptype == "WBS") {
                cCmbWarehouse.Focus();
            }
            else if (Ptype == "B" || Ptype == "BS") {
                cCmbBatch.Focus();
            }
            else if (Ptype == "S") {
                checkComboBox.Focus();
            }
        }
    }
}

var SelectWarehouse = "0";
var SelectBatch = "0";
var SelectSerial = "0";
var SelectedWarehouseID = "0";

function CallbackPanelEndCall(s, e) {
    if (cCallbackPanel.cpEdit != null) {
        var strWarehouse = cCallbackPanel.cpEdit.split('~')[0];
        var strBatchID = cCallbackPanel.cpEdit.split('~')[1];
        var strSrlID = cCallbackPanel.cpEdit.split('~')[2];
        var strQuantity = cCallbackPanel.cpEdit.split('~')[3];

        SelectWarehouse = strWarehouse;
        SelectBatch = strBatchID;
        SelectSerial = strSrlID;

        cCmbWarehouse.PerformCallback('BindWarehouse');
        cCmbBatch.PerformCallback('BindBatch~' + strWarehouse);
        checkListBox.PerformCallback('EditSerial~' + strWarehouse + '~' + strBatchID + '~' + strSrlID);

        cCmbWarehouse.SetValue(strWarehouse);
        ctxtQuantity.SetValue(strQuantity);
    }
}

function acpAvailableStockEndCall(s, e) {
    if (cacpAvailableStock.cpstock != null) {
        divAvailableStk.style.display = "block";
        divpopupAvailableStock.style.display = "block";

        var AvlStk = cacpAvailableStock.cpstock + " " + document.getElementById('<%=lblStkUOM.ClientID %>').innerHTML;
        document.getElementById('<%=lblAvailableStk.ClientID %>').innerHTML = AvlStk;
        document.getElementById('<%=lblAvailableStock.ClientID %>').innerHTML = cacpAvailableStock.cpstock;
        document.getElementById('<%=lblAvailableStockUOM.ClientID %>').innerHTML = document.getElementById('<%=lblStkUOM.ClientID %>').innerHTML;

        document.getElementById('<%=lblInvoiced.ClientID %>').innerHTML = cacpAvailableStock.cpActualStock;
        document.getElementById('<%=lblActStock.ClientID %>').innerHTML = cacpAvailableStock.cpbalanceStock;

        cCmbWarehouse.cpstock = null;
        cacpAvailableStock.cpActualStock = null;
        cacpAvailableStock.cpbalanceStock = null;
    }
}
function ctaxUpdatePanelEndCall(s, e) {
    if (ctaxUpdatePanel.cpstock != null) {
        divAvailableStk.style.display = "block";
        divpopupAvailableStock.style.display = "block";

        var AvlStk = ctaxUpdatePanel.cpstock + " " + document.getElementById('<%=lblStkUOM.ClientID %>').innerHTML;
        document.getElementById('<%=lblAvailableStk.ClientID %>').innerHTML = AvlStk;
        document.getElementById('<%=lblAvailableStock.ClientID %>').innerHTML = ctaxUpdatePanel.cpstock;
        document.getElementById('<%=lblAvailableStockUOM.ClientID %>').innerHTML = document.getElementById('<%=lblStkUOM.ClientID %>').innerHTML;

        document.getElementById('<%=lblInvoiced.ClientID %>').innerHTML = ctaxUpdatePanel.cpActualStock;
        document.getElementById('<%=lblActStock.ClientID %>').innerHTML = ctaxUpdatePanel.cpbalanceStock;
       
        
        
        ctaxUpdatePanel.cpstock = null;
        ctaxUpdatePanel.cpstock = null;
        ctaxUpdatePanel.cpstock = null;
        grid.batchEditApi.StartEdit(globalRowIndex, 5);
        return false;
    }
}

function CmbWarehouseEndCallback(s, e) {
    if (SelectWarehouse != "0") {
        cCmbWarehouse.SetValue(SelectWarehouse);
        SelectWarehouse = "0";
    }
    else {
        cCmbWarehouse.SetEnabled(true);
    }
}

function CmbBatchEndCall(s, e) {
    if (SelectBatch != "0") {
        cCmbBatch.SetValue(SelectBatch);
        SelectBatch = "0";
    }
    else {
        cCmbBatch.SetEnabled(true);
    }
}

function listBoxEndCall(s, e) {
    if (SelectSerial != "0") {
        var values = [SelectSerial];
        checkListBox.SelectValues(values);
        UpdateSelectAllItemState();
        UpdateText();
        //checkListBox.SetValue(SelectWarehouse);
        SelectSerial = "0";
        cCmbBatch.SetEnabled(false);
        cCmbWarehouse.SetEnabled(false);
    }
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

    ctxtProductAmount.SetValue((Math.round(sumAmount*100)/100).toFixed(2));
    ctxtProductTaxAmount.SetValue((Math.round(sumTaxAmount*100)/100).toFixed(2));
    ctxtProductDiscount.SetValue((Math.round(sumDiscount*100)/100).toFixed(2));
    ctxtProductNetAmount.SetValue((Math.round(sumNetAmount * 100)/100).toFixed(2));
    clblChargesTaxableGross.SetText("");
    clblChargesTaxableNet.SetText("");

    //Checking is gstcstvat will be hidden or not
    if (cddl_AmountAre.GetValue() == "2") {

        $('.lblChargesGSTforGross').show();
        $('.lblChargesGSTforNet').show();

        //Set Gross Amount with GstValue
        //Get The rate of Gst
        var gstRate = 0;
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

        //Debjyoti 09032017
        for (var cmbCount = 1; cmbCount < ccmbGstCstVatcharge.GetItemCount() ; cmbCount++) {
            if (ccmbGstCstVatcharge.GetItem(cmbCount).value.split('~')[5] == '19') {
                if (ccmbGstCstVatcharge.GetItem(cmbCount).value.split('~')[4] == 'I') {
                    ccmbGstCstVatcharge.RemoveItem(cmbCount);
                    cmbCount--;
                }
            } else {
                if (ccmbGstCstVatcharge.GetItem(cmbCount).value.split('~')[4] == 'S' || ccmbGstCstVatcharge.GetItem(cmbCount).value.split('~')[4] == 'C') {
                    ccmbGstCstVatcharge.RemoveItem(cmbCount);
                    cmbCount--;
                }
            }
        }






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

var chargejsonTax;
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
    RecalCulateTaxTotalAmountCharges();
    SetOtherChargesLbl();
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
        //ctxtTotalAmount.SetValue(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue())); 
        ctxtTotalAmount.SetValue(parseFloat(ctxtProductNetAmount.GetValue()) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        GlobalTaxAmt = 0;
    }
    else {
        GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
        gridTax.GetEditor("Amount").SetValue(Sum);
        ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) - parseFloat(Sum) + GlobalTaxAmt);
        //ctxtTotalAmount.SetValue(parseFloat(Amount) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue())); 
        ctxtTotalAmount.SetValue(parseFloat(ctxtProductNetAmount.GetValue()) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        GlobalTaxAmt = 0;
    }

    SetOtherChargeTaxValueOnRespectiveRow(0, Sum, gridTax.GetEditor("TaxName").GetText());
    SetChargesRunningTotal();

    RecalCulateTaxTotalAmountCharges();
}

function RecalCulateTaxTotalAmountCharges() {
    var totalTaxAmount = 0;
    for (var i = 0; i < chargejsonTax.length; i++) {

        if (chargejsonTax[i].SchemeName != "-Select-") {
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
    }

    totalTaxAmount = totalTaxAmount + parseFloat(ctxtGstCstVatCharge.GetValue());

    ctxtQuoteTaxTotalAmt.SetValue(totalTaxAmount);
    ctxtTotalAmount.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) + parseFloat(ctxtProductNetAmount.GetValue()));
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

/////////////////// QuotationTaxAmountTextChange By Sam on 23022017
var taxAmountGlobalCharges;
function QuotationTaxAmountGotFocus(s, e) {
    taxAmountGlobalCharges = parseFloat(s.GetValue());
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
        ctxtTotalAmount.SetValue(parseFloat(ctxtProductNetAmount.GetValue()) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        GlobalTaxAmt = 0;
        SetOtherChargeTaxValueOnRespectiveRow(0, s.GetValue(), gridTax.GetEditor("TaxName").GetText());
    }
    else {
        GlobalTaxAmt = parseFloat(gridTax.GetEditor("Amount").GetValue());
        //gridTax.GetEditor("Amount").SetValue(Sum);
        ctxtQuoteTaxTotalAmt.SetValue(parseFloat(ctxtQuoteTaxTotalAmt.GetValue()) - GlobalTaxAmt + taxAmountGlobalCharges);
        ctxtTotalAmount.SetValue(parseFloat(ctxtProductNetAmount.GetValue()) + parseFloat(ctxtQuoteTaxTotalAmt.GetValue()));
        GlobalTaxAmt = 0;
        SetOtherChargeTaxValueOnRespectiveRow(0, s.GetValue(), gridTax.GetEditor("TaxName").GetText());
    }

    RecalCulateTaxTotalAmountCharges();

}



////////////

var AmountOldValue;
var AmountNewValue;

function AmountTextChange(s, e) {
    AmountLostFocus(s, e);
    var RecieveValue = (grid.GetEditor('Amount').GetValue() != null) ? parseFloat(grid.GetEditor('Amount').GetValue()) : "0";
}

function AmountLostFocus(s, e) {
    AmountNewValue = s.GetText();
    var indx = AmountNewValue.indexOf(',');

    if (indx != -1) {
        AmountNewValue = AmountNewValue.replace(/,/g, '');
    }
    if (AmountOldValue != AmountNewValue) {
        changeReciptTotalSummary();
    }
}

function AmountGotFocus(s, e) {
    AmountOldValue = s.GetText();
    var indx = AmountOldValue.indexOf(',');
    if (indx != -1) {
        AmountOldValue = AmountOldValue.replace(/,/g, '');
    }
}

function changeReciptTotalSummary() {
    var newDif = AmountOldValue - AmountNewValue;
    var CurrentSum = ctxtSumTotal.GetText();
    var indx = CurrentSum.indexOf(',');
    if (indx != -1) {
        CurrentSum = CurrentSum.replace(/,/g, '');
    }

    ctxtSumTotal.SetValue(parseFloat(CurrentSum - newDif));
}

function CmbWarehouse_ValueChange() {
    var WarehouseID = cCmbWarehouse.GetValue();
    var type = document.getElementById('hdfProductType').value;

    if (type == "WBS" || type == "WB") {
        cCmbBatch.PerformCallback('BindBatch~' + WarehouseID);
    }
    else if (type == "WS") {
        checkListBox.PerformCallback('BindSerial~' + WarehouseID + '~' + "0");
    }
}
function CmbBatch_ValueChange() {
    var WarehouseID = cCmbWarehouse.GetValue();
    var BatchID = cCmbBatch.GetValue();
    var type = document.getElementById('hdfProductType').value;

    if (type == "WBS") {
        checkListBox.PerformCallback('BindSerial~' + WarehouseID + '~' + BatchID);
    }
    else if (type == "BS") {
        checkListBox.PerformCallback('BindSerial~' + "0" + '~' + BatchID);
    }
}
function SaveWarehouse() {
    var WarehouseID = (cCmbWarehouse.GetValue() != null) ? cCmbWarehouse.GetValue() : "0";
    var WarehouseName = cCmbWarehouse.GetText();
    var BatchID = (cCmbBatch.GetValue() != null) ? cCmbBatch.GetValue() : "0";
    var BatchName = cCmbBatch.GetText();
    var SerialID = "";
    var SerialName = "";
    var Qty = ctxtQuantity.GetValue();

    var items = checkListBox.GetSelectedItems();
    var vals = [];
    var texts = [];

    for (var i = 0; i < items.length; i++) {
        if (items[i].index != 0) {
            if (i == 0) {
                SerialID = items[i].value;
                SerialName = items[i].text;
            }
            else {
                if (SerialID == "" && SerialID == "") {
                    SerialID = items[i].value;
                    SerialName = items[i].text;
                }
                else {
                    SerialID = SerialID + '||@||' + items[i].value;
                    SerialName = SerialName + '||@||' + items[i].text;
                }
            }
            //texts.push(items[i].text);
            //vals.push(items[i].value);
        }
    }

    //WarehouseID, BatchID, SerialID, Qty=0.0
    $("#spnCmbWarehouse").hide();
    $("#spnCmbBatch").hide();
    $("#spncheckComboBox").hide();
    $("#spntxtQuantity").hide();

    var Ptype = document.getElementById('hdfProductType').value;
    if ((Ptype == "W" && WarehouseID == "0") || (Ptype == "WB" && WarehouseID == "0") || (Ptype == "WS" && WarehouseID == "0") || (Ptype == "WBS" && WarehouseID == "0")) {
        $("#spnCmbWarehouse").show();
    }
    else if ((Ptype == "B" && BatchID == "0") || (Ptype == "WB" && BatchID == "0") || (Ptype == "WBS" && BatchID == "0") || (Ptype == "BS" && BatchID == "0")) {
        $("#spnCmbBatch").show();
    }
    else if ((Ptype == "W" && Qty == "0.0") || (Ptype == "B" && Qty == "0.0") || (Ptype == "WB" && Qty == "0.0")) {
        $("#spntxtQuantity").show();
    }
    else if ((Ptype == "S" && SerialID == "") || (Ptype == "WS" && SerialID == "") || (Ptype == "WBS" && SerialID == "") || (Ptype == "BS" && SerialID == "")) {
        $("#spncheckComboBox").show();
    }
    else {
        if (document.getElementById("myCheck").checked == true && SelectedWarehouseID == "0") {
            if (Ptype == "W" || Ptype == "WB" || Ptype == "B") {
                cCmbWarehouse.PerformCallback('BindWarehouse');
                cCmbBatch.PerformCallback('BindBatch~' + "");
                checkListBox.PerformCallback('BindSerial~' + "" + '~' + "");
                ctxtQuantity.SetValue("0");
            }
            else {
                IsPostBack = "N";
                PBWarehouseID = WarehouseID;
                PBBatchID = BatchID;
            }
        }
        else {
            cCmbWarehouse.PerformCallback('BindWarehouse');
            cCmbBatch.PerformCallback('BindBatch~' + "");
            checkListBox.PerformCallback('BindSerial~' + "" + '~' + "");
            ctxtQuantity.SetValue("0");
        }
        UpdateText();
        cGrdWarehouse.PerformCallback('SaveDisplay~' + WarehouseID + '~' + WarehouseName + '~' + BatchID + '~' + BatchName + '~' + SerialID + '~' + SerialName + '~' + Qty + '~' + SelectedWarehouseID);
        SelectedWarehouseID = "0";
    }
}

var IsPostBack = "";
var PBWarehouseID = "";
var PBBatchID = "";


//$(document).ready(function () {
//    $('#ddl_VatGstCst_I').blur(function () {
//        if (grid.GetVisibleRowsOnPage() == 1) {
//            grid.batchEditApi.StartEdit(-1, 2);
//        }
//    })
//    $('#ddl_AmountAre').blur(function () {
//        var id = cddl_AmountAre.GetValue();
//        if (id == '1' || id == '3') {
//            if (grid.GetVisibleRowsOnPage() == 1) {
//                grid.batchEditApi.StartEdit(-1, 2);
//            }
//        }
//    })


//});

function deleteAllRows() {
    var frontRow = 0;
    var backRow = -1;
    for (var i = 0; i <= grid.GetVisibleRowsOnPage() + 100 ; i++) {
        grid.DeleteRow(frontRow);
        grid.DeleteRow(backRow);
        backRow--;
        frontRow++;
    }
    OnAddNewClick();
}
function txtserialTextChanged() {
    checkListBox.UnselectAll();
    var SerialNo = (ctxtserial.GetValue() != null) ? (ctxtserial.GetValue()) : "0";

    if (SerialNo != "0") {
        ctxtserial.SetValue("");
        var texts = [SerialNo];
        var values = GetValuesByTexts(texts);

        if (values.length > 0) {
            checkListBox.SelectValues(values);
            UpdateSelectAllItemState();
            UpdateText(); // for remove non-existing texts
            SaveWarehouse();
        }
        else {
            jAlert("This Serial Number does not exists.");
        }
    }
}

function AutoCalculateMandateOnChange(element) {
    $("#spnCmbWarehouse").hide();
    $("#spnCmbBatch").hide();
    $("#spncheckComboBox").hide();
    $("#spntxtQuantity").hide();

    if (document.getElementById("myCheck").checked == true) {
        divSingleCombo.style.display = "block";
        divMultipleCombo.style.display = "none";

        checkComboBox.Focus();
    }
    else {
        divSingleCombo.style.display = "none";
        divMultipleCombo.style.display = "block";

        ctxtserial.Focus();
    }
}

function fn_Deletecity(keyValue) {
    var WarehouseID = (cCmbWarehouse.GetValue() != null) ? cCmbWarehouse.GetValue() : "0";
    var BatchID = (cCmbBatch.GetValue() != null) ? cCmbBatch.GetValue() : "0";

    cGrdWarehouse.PerformCallback('Delete~' + keyValue);
    checkListBox.PerformCallback('BindSerial~' + WarehouseID + '~' + BatchID);
}
function fn_Edit(keyValue) {
    //cGrdWarehouse.PerformCallback('EditWarehouse~' + keyValue);
    SelectedWarehouseID = keyValue;
    cCallbackPanel.PerformCallback('EditWarehouse~' + keyValue);
}
    </script>
    <script type="text/javascript">
        // <![CDATA[
        var textSeparator = ";";
        var selectedChkValue = "";

        function OnListBoxSelectionChanged(listBox, args) {
            if (args.index == 0)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            UpdateSelectAllItemState();
            UpdateText();
        }
        function UpdateSelectAllItemState() {
            IsAllSelected() ? checkListBox.SelectIndices([0]) : checkListBox.UnselectIndices([0]);
        }
        function IsAllSelected() {
            var selectedDataItemCount = checkListBox.GetItemCount() - (checkListBox.GetItem(0).selected ? 0 : 1);
            return checkListBox.GetSelectedItems().length == selectedDataItemCount;
        }
        function UpdateText() {
            var selectedItems = checkListBox.GetSelectedItems();
            selectedChkValue = GetSelectedItemsText(selectedItems);
            //checkComboBox.SetText(GetSelectedItemsText(selectedItems));

            var serialLength = GetSelectedItemsCount(selectedItems);
            checkComboBox.SetText(serialLength + " Items");
            //checkComboBox.SetText(selectedItems.length + " Items");

            var val = GetSelectedItemsText(selectedItems);
            $("#abpl").attr('data-content', val);
        }
        function SynchronizeListBoxValues(dropDown, args) {
            checkListBox.UnselectAll();
            // var texts = dropDown.GetText().split(textSeparator);
            var texts = selectedChkValue.split(textSeparator);

            var values = GetValuesByTexts(texts);
            checkListBox.SelectValues(values);
            UpdateSelectAllItemState();
            UpdateText(); // for remove non-existing texts
        }
        function GetSelectedItemsText(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                if (items[i].index != 0)
                    texts.push(items[i].text);
            return texts.join(textSeparator);
        }

        function GetSelectedItemsCount(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                if (items[i].index != 0)
                    texts.push(items[i].text);
            return texts.length;
        }


        function GetValuesByTexts(texts) {
            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = checkListBox.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }
        $(function () {
            $('[data-toggle="popover"]').popover();
        })
        // ]]>
    </script>
    <script>
        var ProductGetQuantity = "0";
        var ProductGetTotalAmount = "0";

        function ProductsGotFocus(s, e) {
            pageheaderContent.style.display = "block";
            var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            //var ProductID = (cCmbProduct.GetValue() != null) ? cCmbProduct.GetValue() : "0";
            //var strProductName = (cCmbProduct.GetText() != null) ? cCmbProduct.GetText() : "0";

            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            ProductGetQuantity = QuantityValue;

            var ddlbranch = $("[id*=ddl_Branch]");
            var strBranch = ddlbranch.find("option:selected").text();

            var SpliteDetails = ProductID.split("||@||");
            var strProductID = SpliteDetails[0];
            var strDescription = SpliteDetails[1];
            var strUOM = SpliteDetails[2];
            var strStkUOM = SpliteDetails[4];
            var strSalePrice = SpliteDetails[6];
            var IsPackingActive = SpliteDetails[10];
            var Packing_Factor = SpliteDetails[11];
            var Packing_UOM = SpliteDetails[12];
            var strProductShortCode = SpliteDetails[14];
            var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

            strProductName = strDescription;

            if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                divPacking.style.display = "block";
            } else {
                divPacking.style.display = "none";
            }

            $('#<%= lblStkQty.ClientID %>').text(QuantityValue);
            $('#<%= lblStkUOM.ClientID %>').text(strStkUOM);
            $('#<%= lblProduct.ClientID %>').text(strProductName);
            $('#<%= lblbranchName.ClientID %>').text(strBranch);
            globalNetAmount = parseFloat(grid.GetEditor("TotalAmount").GetValue());
            //if (ProductID != "0") {
            //   cacpAvailableStock.PerformCallback(strProductID);
            //}
        }
        function ProductsGotFocusFromID(s, e) {
            pageheaderContent.style.display = "block";
            var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
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
            var IsPackingActive = SpliteDetails[10];
            var Packing_Factor = SpliteDetails[11];
            var Packing_UOM = SpliteDetails[12];
            var strProductShortCode = SpliteDetails[14];
            var PackingValue = (Packing_Factor * QuantityValue) + " " + Packing_UOM;

            $('#HDSelectedProduct').val(strProductID);
            strProductName = strDescription;

            if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                divPacking.style.display = "block";
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




        function PopulateCurrentBankBalance(MainAccountID) {

            var BranchId = $('#ddl_Branch').val();
            $.ajax({
                type: "POST",
                url: 'PosSalesInvoice.aspx/GetCurrentBankBalance',
                data: JSON.stringify({ MainAccountID: MainAccountID, BranchId: BranchId }),

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var list = msg.d;

                    if (msg.d.length > 0) {
                        document.getElementById("pageheaderContent").style.display = 'block';
                        if (msg.d.split('~')[0] != '') {

                            document.getElementById('<%=B_BankBalance.ClientID %>').innerHTML = msg.d.split('~')[0];
                            document.getElementById('<%=B_BankBalance.ClientID %>').style.color = "Black";
                        }
                        else {
                            document.getElementById('<%=B_BankBalance.ClientID %>').innerHTML = '0.0';
                            document.getElementById('<%=B_BankBalance.ClientID %>').style.color = "Black";

                        }
                    }

                },

            });

        }


    </script>



    <%--  <script>
        document.onkeydown = function (e) {
            if (event.keyCode == 79 && event.altKey == true) { //run code for Ctrl+S -- ie, Save & New  
                StopDefaultAction(e);


                btnSave_QuoteAddress();
                // document.getElementById('Button3').click();

                // return false;
            }

            if (event.keyCode == 88 && event.altKey == true) { //run code for Ctrl+S -- ie, Save & New  
                StopDefaultAction(e);


                page.SetActiveTabIndex(0);
                gridLookup.Focus();
                // document.getElementById('Button3').click();

                // return false;
            }
        }

    </script>--%>


    <style>
        .dxgvControl_PlasticBlue td.dxgvBatchEditModifiedCell_PlasticBlue {
            background: #fff !important;
        }

        .popover {
            z-index: 999999;
            max-width: 350px;
        }

            .popover .popover-title {
                margin-top: 0 !important;
                background: #465b9d;
                color: #fff;
            }

        .pdLeft15 {
            padding-left: 15px;
        }

        .mTop {
            margin-top: 10px;
        }

        .mLeft {
            margin-left: 15px;
        }

        .popover .popover-content {
            min-height: 60px;
        }
        /*#grid_DXEditingErrorRow-1 {
            display: none;
        }*/

        /*#grid_DXStatus span > a {
            display: none;
        }

        #gridTax_DXStatus span > a {
            display: none;
        }*/

        #grid_DXStatus {
            display: none;
        }

        #aspxGridTax_DXStatus {
            display: none;
        }

        #gridTax_DXStatus {
            display: none;
        }

        .hideCell {
            display: none;
        }

        .pullleftClass {
            position: absolute;
            right: -3px;
            top: 24px;
        }

        #myCheck {
            transform: translateY(2px);
            -webkit-transform: translateY(2px);
            -moz-transform: translateY(2px);
            margin-right: 5px;
        }
    </style>
    <%--End Sudip--%>

    <style>
        .dxeErrorFrameSys.dxeErrorCellSys {
            position: absolute;
        }

        .dxeButtonEditClearButton_PlasticBlue {
            display: none;
        }

        .mbot5 .col-md-8 {
            margin-bottom: 5px;
        }

        .validclass {
            position: absolute;
            right: -4px;
            top: 20px;
        }

        .mandt {
            position: absolute;
            right: -18px;
            top: 4px;
        }

        #txtProductAmount, #txtProductTaxAmount, #txtProductDiscount {
            font-weight: bold;
        }

        /*#grid, #grid div {
            width: 100% !important;
        }*/
        .crossBtn {
            cursor: pointer;
        }

        #txtTaxTotAmt input, #txtprodBasicAmt input, #txtGstCstVat input {
            text-align: right;
        }

        #grid .dxgvHSDC > div, #grid .dxgvCSD {
            width: 100% !important;
        }
    </style>


    <%--Batch Product Popup Start--%>

    <script>
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

                if (cproductLookUp.Clear()) {
                    cProductpopUp.Show();
                    cproductLookUp.Focus();
                    cproductLookUp.ShowDropDown();
                }
            }
        }

        function SetHsnSac(newHsnSac) {
            newHsnSac = newHsnSac.trim();
            if (newHsnSac != "") {
                var existsHsnSac = $('#hdHsnList').val();
                if (existsHsnSac.indexOf(',' + newHsnSac + ',') == -1) {
                    existsHsnSac = existsHsnSac + newHsnSac + ',';
                    $('#hdHsnList').val(existsHsnSac);
                }
            }
        }

        function RemoveHSnSacFromList(newHsnSac) {
            newHsnSac = newHsnSac.trim();
            if (newHsnSac != "") {
                var existsHsnSac = $('#hdHsnList').val();

                existsHsnSac = existsHsnSac.replace(newHsnSac + ',', '');
                $('#hdHsnList').val(existsHsnSac);

            }
        }

        function ProductSelected(s, e) {
            if (cproductLookUp.GetGridView().GetFocusedRowIndex() == -1) {
                cProductpopUp.Hide();
                grid.batchEditApi.StartEdit(globalRowIndex, 5);
                return;
            }

            var LookUpData = cproductLookUp.GetGridView().GetRowKey(cproductLookUp.GetGridView().GetFocusedRowIndex());
            var ProductCode = cproductLookUp.GetValue();
            if (!ProductCode) {
                LookUpData = null;
            }
            cProductpopUp.Hide();
            grid.batchEditApi.StartEdit(globalRowIndex);
            //Delete hsn
            if (grid.GetEditor("ProductID").GetText() != "") {
                var previousProductId = grid.GetEditor("ProductID").GetText();
                RemoveHSnSacFromList(previousProductId.split("||@||")[19]);
            }


            grid.GetEditor("ProductID").SetText(LookUpData);
            grid.GetEditor("ProductName").SetText(ProductCode);

            pageheaderContent.style.display = "block";
            cddl_AmountAre.SetEnabled(false);

            var tbDescription = grid.GetEditor("Description");
            var tbUOM = grid.GetEditor("UOM");
            var tbSalePrice = grid.GetEditor("SalePrice");

            //var strProductName = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            var ProductID = (grid.GetEditor('ProductID').GetText() != null) ? grid.GetEditor('ProductID').GetText() : "0";
            var SpliteDetails = ProductID.split("||@||");
            var strProductID = SpliteDetails[0];
            var strDescription = SpliteDetails[1];
            var strUOM = SpliteDetails[2];
            var strStkUOM = SpliteDetails[4];
            var strSalePrice = SpliteDetails[6];
            $('#HDSelectedProduct').val(strProductID);


            var QuantityValue = (grid.GetEditor('Quantity').GetValue() != null) ? grid.GetEditor('Quantity').GetValue() : "0";
            var IsPackingActive = SpliteDetails[10];
            var Packing_Factor = SpliteDetails[11];
            var Packing_UOM = SpliteDetails[12];
            SetHsnSac(SpliteDetails[19]);
            var strRate = (ctxt_Rate.GetValue() != null && ctxt_Rate.GetValue() != "0") ? ctxt_Rate.GetValue() : "1";
            if (strRate == 0) {
                strSalePrice = strSalePrice;
            }
            else {
                strSalePrice = strSalePrice / strRate;
            }

            tbDescription.SetValue(strDescription);
            tbUOM.SetValue(strUOM);
            tbSalePrice.SetValue(strSalePrice);



            var totalNetAmount = grid.GetEditor("TotalAmount").GetValue();

            var newTotalNetAmount = parseFloat(cbnrlblAmountWithTaxValue.GetValue()) - parseFloat(totalNetAmount);
            cbnrlblAmountWithTaxValue.SetValue(parseFloat(Math.round(Math.abs(newTotalNetAmount) * 100) / 100).toFixed(2));
            SetInvoiceLebelValue();


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

            <%--if (IsPackingActive == "Y" && (parseFloat(Packing_Factor * QuantityValue) > 0)) {
                $('#<%= lblPackingStk.ClientID %>').text(PackingValue);
                divPacking.style.display = "block";
            } else {
                divPacking.style.display = "none";
            }--%>

            //divPacking.style.display = "none";
            //lblbranchName lblProduct
            //tbStkUOM.SetValue(strStkUOM);
            //tbStockQuantity.SetValue("0");

            //var IsComponentProduct = SpliteDetails[15];
            //var ComponentProduct = SpliteDetails[16];

            //if (IsComponentProduct == "Y") {
            //    var messege = "Selected product is defined with components.<br/> Would you like to proceed with components (" + ComponentProduct + ") ?";
            //    jConfirm(messege, 'Confirmation Dialog', function (r) {
            //        if (r == true) {
            //            grid.GetEditor("IsComponentProduct").SetValue("Y");
            //            grid.batchEditApi.StartEdit(globalRowIndex, 5);
            //        }
            //        else {
            //            grid.batchEditApi.StartEdit(globalRowIndex, 5);
            //        }
            //    });
            //}

            //Debjyoti
            ctaxUpdatePanel.PerformCallback('DelProdbySl~' + grid.GetEditor("SrlNo").GetValue() + '~' + strProductID);
            grid.batchEditApi.StartEdit(globalRowIndex, 5);
        }
        function ProductlookUpKeyDown(s, e) {
            if (e.htmlEvent.key == "Escape") {
                cProductpopUp.Hide();
                grid.batchEditApi.StartEdit(globalRowIndex, 5);
            }
        }
    </script>
    <style>
        #grid_DXMainTable > tbody > tr > td:last-child {
            display: none !important;
        }

        #taxroundedOf, #chargesRoundOf {
            font-weight: 600;
            font-size: 15px;
            color: #7f0826;
        }

        #openlink {
            font-size: 18px;
        }
    </style>
    <%--Batch Product Popup End--%>

    <%--Compnent Tag Start--%>

    <script>
        function DateCheck() {
            var startDate = new Date();
            startDate = tstartdate.GetValueString();
            var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            var type = ($("[id$='rdl_SaleInvoice']").find(":checked").val() != null) ? $("[id$='rdl_SaleInvoice']").find(":checked").val() : "";
            var componentType = gridquotationLookup.GetGridView().GetRowKey(gridquotationLookup.GetGridView().GetFocusedRowIndex());

            cQuotationComponentPanel.PerformCallback('DateCheckOnChanged' + '~' + key + '~' + startDate + '~' + '@');

            if (key != null && key != '' && type != "") {
                cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type);
            }

            if (componentType != null && componentType != '') {
                grid.PerformCallback('GridBlank');
            }

            cdtChallandate.SetDate(tstartdate.GetDate());


            if (gridLookup.GetValue()) {
                var custId = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
                caspxCustomerReceiptGridview.PerformCallback('BindCustomerGridByInternalId~' + custId + '~' + tstartdate.GetDate().format('yyyy-MM-dd'));
            }


        }
        function componentEndCallBack(s, e) {
            gridquotationLookup.gridView.Refresh();
            if (grid.GetVisibleRowsOnPage() == 0) {
                OnAddNewClick(function () { gridquotationLookup.Focus(); });
            }

        }
        function selectValue() {
            var startDate = new Date();
            startDate = tstartdate.GetValueString();
            var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            var type = ($("[id$='rdl_SaleInvoice']").find(":checked").val() != null) ? $("[id$='rdl_SaleInvoice']").find(":checked").val() : "";

            if (type == "QO") {
                clbl_InvoiceNO.SetText('PI/Quotation Date');
            }
            else if (type == "SO") {
                clbl_InvoiceNO.SetText('Sales Order Date');
            }
            else if (type == "SC") {
                clbl_InvoiceNO.SetText('Sales Challan Date');
            }

            cQuotationComponentPanel.PerformCallback('DateCheckOnChanged' + '~' + key + '~' + startDate + '~' + '@');

            if (key != null && key != '' && type != "") {
                cQuotationComponentPanel.PerformCallback('BindComponentGrid' + '~' + key + '~' + startDate + '~' + 'DateCheck' + '~' + type);
            }

            var componentType = gridquotationLookup.GetValue();
            if (componentType != null && componentType != '') {
                grid.PerformCallback('GridBlank');
            }
        }
        function CloseGridQuotationLookup() {
            gridquotationLookup.ConfirmCurrentSelection();
            gridquotationLookup.HideDropDown();
            gridquotationLookup.Focus();
        }
        function QuotationNumberChanged() {
            var quote_Id = gridquotationLookup.GetValue();
            var type = ($("[id$='rdl_SaleInvoice']").find(":checked").val() != null) ? $("[id$='rdl_SaleInvoice']").find(":checked").val() : "";

            if (quote_Id != null) {
                var arr = quote_Id.split(',');

                if (arr.length > 1) {
                    if (type == "QO") {
                        ctxt_InvoiceDate.SetText('Multiple Select Quotation Dates');
                    }
                    else if (type == "SO") {
                        ctxt_InvoiceDate.SetText('Multiple Select Order Dates');
                    }
                    else if (type == "SC") {
                        ctxt_InvoiceDate.SetText('Multiple Select Challan Dates');
                    }
                }
                else {
                    if (arr.length == 1) {
                        cComponentDatePanel.PerformCallback('BindComponentDate' + '~' + quote_Id);
                    }
                    else {
                        ctxt_InvoiceDate.SetText('');
                    }
                }
            }
            else { ctxt_InvoiceDate.SetText(''); }

            if (quote_Id != null) {
                cgridproducts.PerformCallback('BindProductsDetails' + '~' + '@');
                cProductsPopup.Show();
            }
        }
        function ChangeState(value) {

            cgridproducts.PerformCallback('SelectAndDeSelectProducts' + '~' + value);
        }
        function PerformCallToGridBind() {
            grid.PerformCallback('BindGridOnQuotation' + '~' + '@');
            cQuotationComponentPanel.PerformCallback('BindComponentGridOnSelection');
            $('#hdnPageStatus').val('Quoteupdate');
            cProductsPopup.Hide();
            return false;
        }


        function SetRunningBalance() {
            var paymentValue = 0;
            if (document.getElementById('HdPosType').value != 'IST') {
                paymentValue = parseFloat(GetPaymentTotalEnteredAmount());
            }
            //  SetDownPayment();
            if (document.getElementById('HdPosType').value == 'Fin') {
                SetTotalDownPaymentAmount();
            }
            var InvoiceValue = parseFloat(cbnrLblInvValue.GetValue());
            var FinanceAmount = parseFloat(ctxtFinanceAmt.GetValue());
            var otherCharges = parseFloat(cbnrOtherChargesvalue.GetValue());
            var procFee = parseFloat(ctxtprocFee.GetValue());
            var EmiCardOtCharge = parseFloat(ctxtEmiOtherCharges.GetValue());

            var runningBalance = 0;
            runningBalance = parseFloat(Math.round((InvoiceValue - paymentValue - FinanceAmount + otherCharges) * 100) / 100).toFixed(2);

            if (document.getElementById('HdPosType').value == 'Fin') {
                runningBalance = runningBalance - parseFloat(ctxtAdvnceReceipt.GetValue());
                if (runningBalance < 0) {
                    runningBalance = 0.00;
                }
            }
            clblRunningBalanceCapsul.SetValue(runningBalance);
        }
    </script>

    <%--Compnent Tag End--%>

    <%--Receipt/Payment Popup Start--%>
    <script>
        function ShowReceiptPayment() {
            uri = "CustomerReceiptPayment.aspx?key=ADD&IsTagged=Y";
            capcReciptPopup.SetContentUrl(uri);
            capcReciptPopup.Show();
        }
        //$(document).ready(function () {
        //    $("#openlink").on("click", function () {
        //        //window.location.href='master/Contact_general.aspx?id=ADD';
        //        window.open('../master/Contact_general.aspx?id=ADD', '_blank');
        //    });
        //});
    </script>
    <%--Receipt/Payment Popup End--%>

    <script>
        //Code for UDF Control 
        function OpenUdf() {
            if (document.getElementById('IsUdfpresent').value == '0') {
                jAlert("UDF not define.");
            }
            else {
                var keyVal = document.getElementById('Keyval_internalId').value;
                var url = '/OMS/management/Master/frm_BranchUdfPopUp.aspx?Type=POS&&KeyVal_InternalID=' + keyVal;
                popup.SetContentUrl(url);
                popup.Show();
            }
            return true;
        }
        // End Udf Code
    </script>
    <style>
        .errorField {
            position: absolute;
            right: 0;
            top: 20px;
        }

        .mTop10 {
            margin-top: 10px;
        }

        .backBranch {
            font-weight: 600;
            background: #75c1f5;
            padding: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-title clearfix" id="myDiv">
        <h3 class="pull-left">
            <asp:Label ID="lblHeadTitle" Text="" runat="server"></asp:Label>
            <%--<label>Add Proforma Invoice/ Quotation</label>--%>
            <%--<div class="pull-right" style="font-size: 14px;"> Login into: <span class="backBranch"></span></div>--%>

        </h3>


        <div id="pageheaderContent" class="scrollHorizontal pull-right wrapHolder content horizontal-images">
            <div class="Top clearfix">
                <ul>

                    <li>
                        <div class="lblHolder" id="divDues" style="display: none;">
                            <table>
                                <tr>
                                    <td>Customer Balance</td>
                                </tr>
                                <tr>
                                    <td class="lower">
                                        <asp:Label ID="lblTotalDues" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </li>

                    <li>
                        <div class="lblHolder hide" >
                            <table>
                                <tr>
                                    <td>Login into</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="branchName" Text=""></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </li>
                    <li>
                        <div class="lblHolder" id="idCashbalanace">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Cash Balance </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="width: 100%;">
                                                <b style="text-align: center" id="B_BankBalance" runat="server">0.00</b>
                                            </div>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>

                    <li style="cursor:pointer">
                        <div class="lblHolder" id="divAvailableStk" onclick="AvailableStockClick()">
                            <table>
                                <tr>
                                    <td>Available Stock</td>
                                </tr>
                                <tr>
                                    <td style="color:blue">
                                        <asp:Label ID="lblAvailableStk" runat="server" Text="0.0"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </li>


                    <li>
                        <div class="lblHolder" id="divinvoiced"  >
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Currently Invoiced</td>
                                    </tr>
                                    <tr>
                                        <td>
                                                               
                                            <asp:Label ID="lblInvoiced" runat="server" Text="0.0"></asp:Label>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>

                     <li>
                        <div class="lblHolder"  >
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Actual Stock</td>
                                    </tr>
                                    <tr>
                                        <td>
                                                               
                                            <asp:Label ID="lblActStock" runat="server" Text="0.0"></asp:Label>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>


                    <li class="hide">

                        <div class="lblHolder " id="divPacking" style="display: none;">
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
                                        <asp:Label ID="lblbranchName" runat="server"></asp:Label>
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
        <div id="ApprovalCross" runat="server" class="crossBtn"><a href=""><i class="fa fa-times"></i></a></div>
        <div id="divcross" runat="server" class="crossBtn"><a href="PosSalesInvoiceList.aspx"><i class="fa fa-times"></i></a></div>

    </div>
    <div class="form_main">
        <asp:Panel ID="pnl_quotation" runat="server">
            <div class="">
                <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ClientInstanceName="page" Width="100%">
                    <TabPages>
                        <dxe:TabPage Name="General" Text="General">
                            <ContentCollection>
                                <dxe:ContentControl runat="server">
                                    <div class="">
                                        <div style="background: #c2d8e6;">
                                            <table class="bod-table">
                                                <tbody>
                                                    <tr>

                                                        <td id="divScheme" runat="server" style="padding-top: 10px; width: 177px">
                                                            <dxe:ASPxLabel ID="lbl_NumberingScheme" runat="server" Text="Numbering Scheme">
                                                            </dxe:ASPxLabel>
                                                            <div>
                                                                <asp:DropDownList ID="ddl_numberingScheme" runat="server" Width="100%">
                                                                </asp:DropDownList>
                                                            </div>
                                                        </td>

                                                        <td class="relative">
                                                            <dxe:ASPxLabel ID="lbl_SaleInvoiceNo" runat="server" Text="Invoice Number">
                                                            </dxe:ASPxLabel>
                                                            <dxe:ASPxTextBox ID="txt_PLQuoteNo" runat="server" ClientInstanceName="ctxt_PLQuoteNo" Width="92%">
                                                                <ClientSideEvents TextChanged="function(s, e) {UniqueCodeCheck();}" />
                                                            </dxe:ASPxTextBox>
                                                            <span id="MandatorysQuoteno" style="display: none" class="errorField">
                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"> </img>
                                                            </span><span id="duplicateQuoteno" class="validclass" style="display: none">
                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Duplicate number"> </img>
                                                            </span></td>

                                                        <td class="relative">
                                                            <dxe:ASPxLabel ID="lbl_SaleInvoiceDt" runat="server" Text="Date">
                                                            </dxe:ASPxLabel>
                                                            <dxe:ASPxDateEdit ID="dt_PLQuote" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="tstartdate" Width="100%">
                                                                <ButtonStyle Width="13px">
                                                                </ButtonStyle>
                                                                <ClientSideEvents DateChanged="function(s, e) {DateCheck();}" GotFocus="function(s,e){tstartdate.ShowDropDown();}" />
                                                            </dxe:ASPxDateEdit>
                                                        </td>

                                                        <td class="relative">
                                                            <dxe:ASPxLabel ID="ASPxLabel4" runat="server" Text="Delivery Type">
                                                            </dxe:ASPxLabel>
                                                            <dxe:ASPxComboBox ID="cmbDeliveryType" ClientInstanceName="ccmbDeliveryType" runat="server"
                                                                ValueType="System.String" Width="92%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                                <Items>
                                                                    <%--<dxe:ListEditItem Text="-Select-" Value="0" />--%>
                                                                    <dxe:ListEditItem Text="Our" Value="O" />
                                                                    <dxe:ListEditItem Text="Self" Value="S" />
                                                                    <dxe:ListEditItem Text="Already Delivered" Value="D" />
                                                                    <%--<dxe:ListEditItem Text="Intimation Approx" Value="I" />--%>
                                                                </Items>
                                                                <ClientSideEvents SelectedIndexChanged="isDeliveryTypeChanged" GotFocus="function(s,e){ccmbDeliveryType.ShowDropDown();}" />
                                                            </dxe:ASPxComboBox>

                                                            <span id="mandetorydeliveryType" style="display: none;" class="errorField">
                                                                <img id="mandetorydelivery" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                            </span>
                                                        </td>


                                                        <td class="relative">
                                                            <dxe:ASPxLabel ID="ASPxLabel10" runat="server" Text="Delivery Date">
                                                            </dxe:ASPxLabel>
                                                            <dxe:ASPxDateEdit ID="deliveryDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cdeliveryDate" Width="92%">
                                                                <ButtonStyle Width="13px">
                                                                </ButtonStyle>
                                                                <ClientSideEvents GotFocus="function(s,e){cdeliveryDate.ShowDropDown();}" />
                                                            </dxe:ASPxDateEdit>
                                                            <span id="MandatorysdeliveryDate" style="display: none" class="errorField">
                                                                <img id="MandatorysdeliveryDateid" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"> </img>
                                                            </span><span id="duplicateQuoteno" class="validclass" style="display: none">
                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Duplicate number"> </img>
                                                            </span></td>
                                                        </td>



                                                     <td class="relative">
                                                         <dxe:ASPxLabel ID="lbl_Customer" runat="server" Text="Customer">
                                                         </dxe:ASPxLabel>
                                                         <% if (rights.CanAdd && hdAddOrEdit.Value != "Edit")
                                                            { %>
                                                         <a href="#" onclick="AddcustomerClick()" style="position: absolute; top: 4px; margin-left: 5px;"><i id="openlink" class="fa fa-plus-circle" aria-hidden="true"></i></a>
                                                         <% } %>

                                                         <dxe:ASPxCallbackPanel runat="server" ID="CustomerCallBackPanel" ClientInstanceName="cCustomerCallBackPanel" OnCallback="CustomerCallBackPanel_Callback">
                                                             <PanelCollection>
                                                                 <dxe:PanelContent runat="server">

                                                                     <dxe:ASPxGridLookup ID="lookup_Customer" runat="server" ClientInstanceName="gridLookup"
                                                                         KeyFieldName="cnt_internalid" Width="92%" TextFormatString="{1}" AutoGenerateColumns="False" DataSourceID="dsCustomer">
                                                                         <Columns>

                                                                             <dxe:GridViewDataColumn FieldName="uniquename" Visible="true" VisibleIndex="0" Caption="Unique ID" Settings-AutoFilterCondition="Contains" Width="200px">
                                                                                 <Settings AutoFilterCondition="Contains" />
                                                                             </dxe:GridViewDataColumn>

                                                                             <dxe:GridViewDataColumn FieldName="Name" Visible="true" VisibleIndex="1" Caption="Name" Settings-AutoFilterCondition="Contains" Width="200px">
                                                                                 <Settings AutoFilterCondition="Contains" />
                                                                             </dxe:GridViewDataColumn>
                                                                             <dxe:GridViewDataColumn FieldName="phf_phoneNumber" Visible="true" VisibleIndex="1" Caption="Phone" Settings-AutoFilterCondition="Contains" Width="150px">
                                                                                 <Settings AutoFilterCondition="Contains" />
                                                                             </dxe:GridViewDataColumn>


                                                                             <dxe:GridViewDataColumn FieldName="Billing" Visible="true" VisibleIndex="1" Caption="Billing" Settings-AutoFilterCondition="Contains" Width="200px">
                                                                                 <Settings AutoFilterCondition="Contains" />
                                                                             </dxe:GridViewDataColumn>

                                                                             <dxe:GridViewDataColumn FieldName="Shipping" Visible="true" VisibleIndex="1" Caption="Shipping" Settings-AutoFilterCondition="Contains" Width="200px">
                                                                                 <Settings AutoFilterCondition="Contains" />
                                                                             </dxe:GridViewDataColumn>

                                                                             <dxe:GridViewDataColumn FieldName="Type" Visible="true" VisibleIndex="2" Caption="Type" Settings-AutoFilterCondition="Contains" Width="80px">
                                                                                 <Settings AutoFilterCondition="Contains" />
                                                                             </dxe:GridViewDataColumn>
                                                                         </Columns>
                                                                         <GridViewProperties Settings-VerticalScrollBarMode="Auto">
                                                                             <Templates>
                                                                                 <StatusBar>
                                                                                     <table class="OptionsTable" style="float: right">
                                                                                         <tr>
                                                                                             <td>
                                                                                                 <dxe:ASPxButton ID="ASPxButton6" runat="server" AutoPostBack="false" UseSubmitBehavior="False" Text="Close" ClientSideEvents-Click="CloseGridLookup" />
                                                                                             </td>
                                                                                         </tr>
                                                                                     </table>
                                                                                 </StatusBar>
                                                                             </Templates>
                                                                             <SettingsPager NumericButtonCount="10" PageSize="10" ShowSeparators="True" Mode="ShowPager">
                                                                                 <FirstPageButton Visible="True">
                                                                                 </FirstPageButton>
                                                                                 <LastPageButton Visible="True">
                                                                                 </LastPageButton>
                                                                             </SettingsPager>
                                                                             <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                             <SettingsLoadingPanel Text="Please Wait..." />
                                                                             <Settings ShowFilterRow="True" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                                                                         </GridViewProperties>
                                                                         <ClientSideEvents TextChanged="function(s, e) { GetContactPerson(e)}" GotFocus="function(s,e){gridLookup.ShowDropDown();}" />
                                                                         <ClearButton DisplayMode="Auto">
                                                                         </ClearButton>
                                                                     </dxe:ASPxGridLookup>
                                                                 </dxe:PanelContent>
                                                             </PanelCollection>
                                                             <ClientSideEvents EndCallback="CustomerCallBackPanelEndCallBack" />
                                                         </dxe:ASPxCallbackPanel>

                                                         <span id="MandatorysCustomer" style="display: none" class="errorField">
                                                             <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>



                                                     </td>
                                                        <td style="width: 180px">
                                                            <dxe:ASPxLabel ID="ASPxLabel3" runat="server" Text="Salesman(ISD)">
                                                            </dxe:ASPxLabel>
                                                            <dxe:ASPxComboBox ID="ddl_SalesAgent" ClientInstanceName="cddl_SalesAgent" runat="server" ValueType="System.String" Width="92%" EnableSynchronization="True"
                                                                OnCallback="ddl_SalesAgent_Callback" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                                <ClientSideEvents GotFocus="function(s,e){cddl_SalesAgent.ShowDropDown();}" />
                                                            </dxe:ASPxComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>

                                                        <td colspan="2">
                                                            <dxe:ASPxLabel ID="lbl_Refference" runat="server" Text="Reference">
                                                            </dxe:ASPxLabel>
                                                            <dxe:ASPxTextBox ID="txt_Refference" ClientInstanceName="ctxt_Refference" runat="server" Width="100%">
                                                            </dxe:ASPxTextBox>

                                                        </td>


                                                        <td id="challanNoSchemedd" runat="server">
                                                            <dxe:ASPxLabel ID="ASPxLabel9" runat="server" Text="Challan Numbering Scheme">
                                                            </dxe:ASPxLabel>
                                                            <div>
                                                                <dxe:ASPxComboBox ID="challanNoScheme" runat="server" ClientEnabled="false" ClientInstanceName="cchallanNoScheme" OnCallback="challanNoScheme_Callback" Width="100%">
                                                                    <ClientSideEvents EndCallback="challanNoSchemeEndCallback" SelectedIndexChanged="challanNoSchemeSelectedIndexChanged"
                                                                        GotFocus="function(s,e){cchallanNoScheme.ShowDropDown();}" />
                                                                </dxe:ASPxComboBox>
                                                            </div>
                                                            <span>
                                                                <img id="mandetorydchallanNoScheme" style="display: none" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                            </span>
                                                        </td>

                                                        <td>
                                                            <label>Challan No </label>
                                                            <dxe:ASPxTextBox ID="txtChallanNo" ClientInstanceName="ctxtChallanNo" runat="server" Width="100%" ClientEnabled="false">
                                                            </dxe:ASPxTextBox>
                                                            <span>
                                                                <img id="mandetorydtxtChallanNo" style="display: none" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <label>Challan Date</label>
                                                            <dxe:ASPxDateEdit ID="dtChallandate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cdtChallandate" ClientEnabled="false" Width="100%">
                                                                <ButtonStyle Width="13px">
                                                                </ButtonStyle>
                                                            </dxe:ASPxDateEdit>
                                                        </td>


                                                        <td>
                                                            <asp:RadioButtonList ID="rdl_SaleInvoice" runat="server" RepeatDirection="Horizontal" onchange="return selectValue();">
                                                                <asp:ListItem Text="PI/Quotation" Value="QO"></asp:ListItem>
                                                                <asp:ListItem Text="Order" Value="SO"></asp:ListItem>
                                                                <%--  <asp:ListItem Text="Challan" Value="SC"></asp:ListItem>--%>
                                                            </asp:RadioButtonList>
                                                            <dxe:ASPxCallbackPanel runat="server" ID="ComponentQuotationPanel" ClientInstanceName="cQuotationComponentPanel" OnCallback="ComponentQuotation_Callback">
                                                                <PanelCollection>
                                                                    <dxe:PanelContent runat="server">
                                                                        <dxe:ASPxGridLookup ID="lookup_quotation" SelectionMode="Multiple" runat="server" ClientInstanceName="gridquotationLookup"
                                                                            OnDataBinding="lookup_quotation_DataBinding"
                                                                            KeyFieldName="ComponentID" Width="100%" TextFormatString="{0}" AutoGenerateColumns="False" MultiTextSeparator=", ">
                                                                            <Columns>
                                                                                <dxe:GridViewCommandColumn VisibleIndex="0" Width="60" Caption=" " />
                                                                                <dxe:GridViewDataColumn FieldName="ComponentNumber" Visible="true" VisibleIndex="1" Caption="Number" Width="180" Settings-AutoFilterCondition="Contains">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dxe:GridViewDataColumn>
                                                                                <dxe:GridViewDataColumn FieldName="ComponentDate" Visible="true" VisibleIndex="2" Caption="Date" Width="100" Settings-AutoFilterCondition="Contains">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dxe:GridViewDataColumn>
                                                                                <dxe:GridViewDataColumn FieldName="CustomerName" Visible="true" VisibleIndex="3" Caption="Customer Name" Width="150" Settings-AutoFilterCondition="Contains">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dxe:GridViewDataColumn>
                                                                            </Columns>
                                                                            <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                                                                                <Templates>
                                                                                    <StatusBar>
                                                                                        <table class="OptionsTable" style="float: right">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <dxe:ASPxButton ID="ASPxButton9" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridQuotationLookup" UseSubmitBehavior="False" />
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
                                                                            <ClientSideEvents ValueChanged="function(s, e) { QuotationNumberChanged();}" GotFocus="function(s,e){gridquotationLookup.ShowDropDown();}" />
                                                                        </dxe:ASPxGridLookup>
                                                                    </dxe:PanelContent>
                                                                </PanelCollection>
                                                                <ClientSideEvents EndCallback="componentEndCallBack" />
                                                            </dxe:ASPxCallbackPanel>
                                                        </td>





                                                        <td>
                                                            <dxe:ASPxLabel ID="lblVatGstCst" runat="server" Text="Select GST" ClientVisible="false">
                                                            </dxe:ASPxLabel>
                                                            <dxe:ASPxComboBox ID="ddl_VatGstCst" runat="server" ClientInstanceName="cddlVatGstCst" ClientVisible="false" OnCallback="ddl_VatGstCst_Callback" Width="100%">
                                                                <ClientSideEvents EndCallback="Onddl_VatGstCstEndCallback" />
                                                            </dxe:ASPxComboBox>
                                                            <span id="Mandatorytaxcode" style="display: none" class="validclass">
                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                                                        </td>

                                                        <%--  <td>
                                                         <select class="form-control">
                                                             <option>Select Barcode</option>
                                                             <option>Select Model</option>
                                                             <option>Select Serial</option>
                                                         </select>
                                                     </td>
                                                     <td>
                                                         <div class="input-group">
                                                             <input type="text" class="form-control" placeholder="Username" aria-describedby="basic-addon1">
                                                             <span class="input-group-addon btn-primary" style="padding: 5px;"><i class="fa fa-plus-circle" aria-hidden="true"></i></span>
                                                        </div>
                                                     </td>--%>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <table class="bod-table " style="margin-top: 5px" id="FinancerTable" runat="server">
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <label>Financer</label>
                                                        <dxe:ASPxComboBox ID="cmbFinancer" runat="server" ClientInstanceName="ccmbFinancer" Width="100%" OnCallback="cmbFinancer_Callback">
                                                            <ClientSideEvents SelectedIndexChanged="financerIndexChange" GotFocus="function(s,e){ccmbFinancer.ShowDropDown();}" />
                                                        </dxe:ASPxComboBox>
                                                    </td>
                                                    <td>
                                                        <label>Exec. Name</label>
                                                        <dxe:ASPxComboBox ID="cmbExecName" runat="server" ClientInstanceName="ccmbExecName" OnCallback="cmbExecName_Callback" Width="100%">
                                                            <ClientSideEvents GotFocus="function(s,e){ccmbExecName.ShowDropDown();}" EndCallback="ccmbExecNameEndCallBack" />
                                                        </dxe:ASPxComboBox>
                                                    </td>
                                                    <td>
                                                        <label>EMI Det.</label>
                                                        <dxe:ASPxTextBox ID="txtEmiDetails" ClientInstanceName="ctxtEmiDetails" runat="server" Width="100%" MaxLength="100">
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                    <td>
                                                        <label>Scheme</label>
                                                        <dxe:ASPxTextBox ID="txtScheme" ClientInstanceName="ctxtScheme" runat="server" Width="100%" MaxLength="200">
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                    <td>
                                                        <label>SF Code</label>
                                                        <dxe:ASPxTextBox ID="txtSfCode" ClientInstanceName="ctxtSfCode" runat="server" Width="100%">
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                    <td>
                                                        <label>DBD</label>
                                                        <dxe:ASPxTextBox ID="txtDBD" ClientInstanceName="ctxtDBD" runat="server" Width="100%">
                                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                    <td>
                                                        <label>DBD %</label>
                                                        <dxe:ASPxTextBox ID="txtDbdPercen" ClientInstanceName="ctxtDbdPercen" runat="server" Width="100%">
                                                            <MaskSettings Mask="<0..100>.<0..99>" AllowMouseWheel="false" />
                                                        </dxe:ASPxTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label>Downpayment</label>
                                                        <dxe:ASPxTextBox ID="txtdownPayment" ClientInstanceName="ctxtdownPayment" runat="server" Width="100%">
                                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                            <ClientSideEvents LostFocus="SetRunningBalance"></ClientSideEvents>
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                    <td>
                                                        <label>Proc. Fee</label>
                                                        <dxe:ASPxTextBox ID="txtprocFee" ClientInstanceName="ctxtprocFee" runat="server" Width="100%">
                                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                            <ClientSideEvents LostFocus="SetRunningBalance"></ClientSideEvents>
                                                        </dxe:ASPxTextBox>
                                                    </td>


                                                    <td>
                                                        <label>EMI Card/Other Charges</label>
                                                        <dxe:ASPxTextBox ID="txtEmiOtherCharges" ClientInstanceName="ctxtEmiOtherCharges" runat="server" Width="100%">
                                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                            <ClientSideEvents LostFocus="SetRunningBalance"></ClientSideEvents>
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                    <td>
                                                        <label>Total DP Amt.</label>
                                                        <dxe:ASPxTextBox ID="txtTotDpAmt" ClientInstanceName="ctxtTotDpAmt" runat="server" Width="100%" ClientEnabled="false">
                                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                        </dxe:ASPxTextBox>
                                                    </td>


                                                    <td>
                                                        <label>Financer Due</label>
                                                        <dxe:ASPxTextBox ID="txtFinanceAmt" ClientInstanceName="ctxtFinanceAmt" runat="server" Width="100%" ClientEnabled="false">
                                                            <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                            <ClientSideEvents LostFocus="SetRunningBalance"></ClientSideEvents>
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                       <td>
                                                        <label>Finance Challan No</label>
                                                        <dxe:ASPxTextBox ID="txtfinChallanNo" ClientInstanceName="ctxtfinChallanNo" runat="server" Width="100%"  MaxLength="10"> 
                                                        </dxe:ASPxTextBox>
                                                    </td>

                                                    
                                                       <td>
                                                        <label>Finance Challan Date</label>
                                                              <dxe:ASPxDateEdit ID="finChallandate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cfinChallandate"   Width="100%">
                                                                <ButtonStyle Width="13px">
                                                                </ButtonStyle>
                                                            </dxe:ASPxDateEdit>
                                                    </td>
                                              

                                                </tr>

                                            </tbody>


                                        </table>

                                        <div style="margin-top: 8px;">
                                            <dxe:ASPxGridView runat="server" KeyFieldName="QuotationID" OnCustomUnboundColumnData="grid_CustomUnboundColumnData" ClientInstanceName="grid" ID="grid"
                                                Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" Settings-ShowFooter="false"
                                                OnBatchUpdate="grid_BatchUpdate"
                                                OnCustomCallback="grid_CustomCallback"
                                                OnDataBinding="grid_DataBinding"
                                                OnCellEditorInitialize="grid_CellEditorInitialize"
                                                OnRowInserting="Grid_RowInserting"
                                                OnRowUpdating="Grid_RowUpdating"
                                                OnRowDeleting="Grid_RowDeleting"
                                                OnHtmlRowPrepared="grid_HtmlRowPrepared" 
                                                SettingsPager-Mode="ShowAllRecords" Settings-VerticalScrollBarMode="auto" Settings-VerticalScrollableHeight="120">
                                                <SettingsPager Visible="false"></SettingsPager>
                                                <Columns>
                                                    <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="3%" VisibleIndex="0" Caption="#">
                                                        <CustomButtons>
                                                            <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomDelete" Image-Url="/assests/images/crs.png">
                                                                <Image Url="/assests/images/crs.png">
                                                                </Image>
                                                            </dxe:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                        <%-- <HeaderCaptionTemplate>
                                                            <dxe:ASPxHyperLink ID="btnNew" runat="server" Text="New" ForeColor="White">
                                                                <ClientSideEvents Click="function (s, e) { OnAddNewClick();}" />
                                                            </dxe:ASPxHyperLink>
                                                        </HeaderCaptionTemplate>--%>
                                                    </dxe:GridViewCommandColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="SrlNo" Caption="Sl" ReadOnly="true" VisibleIndex="1" Width="2%">
                                                        <PropertiesTextEdit>
                                                        </PropertiesTextEdit>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="ComponentNumber" Caption="Doc No." VisibleIndex="2" ReadOnly="True" Width="9%">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataButtonEditColumn FieldName="ProductName" Caption="Product" VisibleIndex="3" Width="14%">
                                                        <PropertiesButtonEdit>
                                                            <ClientSideEvents ButtonClick="ProductButnClick" KeyDown="ProductKeyDown" GotFocus="ProductsGotFocusFromID" />
                                                            <Buttons>
                                                                <dxe:EditButton Text="..." Width="20px">
                                                                </dxe:EditButton>
                                                            </Buttons>
                                                        </PropertiesButtonEdit>
                                                    </dxe:GridViewDataButtonEditColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="Description" Caption="Description" VisibleIndex="4" ReadOnly="True" Width="18%">
                                                        <CellStyle Wrap="True"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="Quantity" Caption="Qty." VisibleIndex="5" Width="3%" PropertiesTextEdit-MaxLength="14" HeaderStyle-HorizontalAlign="Right">
                                                        <PropertiesTextEdit DisplayFormatString="0" Style-HorizontalAlign="Right">
                                                            <ClientSideEvents GotFocus="ProductsGotFocus" LostFocus="QuantityTextChange"></ClientSideEvents>
                                                            <Style HorizontalAlign="Right"></Style>
                                                        </PropertiesTextEdit>
                                                        <PropertiesTextEdit>
                                                            <MaskSettings Mask="<0..999999999>" AllowMouseWheel="false" />
                                                            <ClientSideEvents />
                                                        </PropertiesTextEdit>
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <CellStyle HorizontalAlign="Right"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="UOM" Caption="UOM" VisibleIndex="6" ReadOnly="true" Width="3%">
                                                        <PropertiesTextEdit>
                                                        </PropertiesTextEdit>
                                                    </dxe:GridViewDataTextColumn>
                                                    <%--Caption="Warehouse"--%>
                                                    <dxe:GridViewCommandColumn VisibleIndex="7" Caption="Stock" Width="4%">
                                                        <CustomButtons>
                                                            <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomWarehouse" Image-Url="/assests/images/warehouse.png" Image-ToolTip="Warehouse">
                                                                <Image ToolTip="Warehouse" Url="/assests/images/warehouse.png">
                                                                </Image>
                                                            </dxe:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                    </dxe:GridViewCommandColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="StockQuantity" Caption="Stock Qty" VisibleIndex="8" Visible="false">
                                                        <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                                        <PropertiesTextEdit>
                                                        </PropertiesTextEdit>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="StockUOM" Caption="Stock UOM" VisibleIndex="9" ReadOnly="true" Visible="false">
                                                        <PropertiesTextEdit>
                                                        </PropertiesTextEdit>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="SalePrice" Caption="Sale Price" VisibleIndex="10" Width="6%" HeaderStyle-HorizontalAlign="Right">
                                                        <PropertiesTextEdit>
                                                            <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                            <ClientSideEvents LostFocus="SalePriceTextChange" GotFocus="ProductsGotFocus" />
                                                        </PropertiesTextEdit>
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <CellStyle HorizontalAlign="Right"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataSpinEditColumn FieldName="Discount" Caption="Disc(%)" VisibleIndex="11" Width="5%" HeaderStyle-HorizontalAlign="Right">
                                                        <PropertiesSpinEdit MinValue="0" MaxValue="100" AllowMouseWheel="false" DisplayFormatString="0.00" MaxLength="6" Style-HorizontalAlign="Right">
                                                            <SpinButtons ShowIncrementButtons="false"></SpinButtons>
                                                            <ClientSideEvents LostFocus="DiscountTextChange" GotFocus="DiscountGotChange" />
                                                            <Style HorizontalAlign="Right"></Style>
                                                        </PropertiesSpinEdit>
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <CellStyle HorizontalAlign="Right"></CellStyle>
                                                    </dxe:GridViewDataSpinEditColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="Amount" Caption="Amount" VisibleIndex="12" Width="6%" ReadOnly="true" HeaderStyle-HorizontalAlign="Right">
                                                        <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                            <MaskSettings AllowMouseWheel="False" Mask="&lt;0..999999999&gt;.&lt;00..99&gt;"></MaskSettings>
                                                            <Style HorizontalAlign="Right"></Style>
                                                        </PropertiesTextEdit>
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <CellStyle HorizontalAlign="Right"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataButtonEditColumn FieldName="TaxAmount" Caption="Tax/Charges" VisibleIndex="13" Width="6%" HeaderStyle-HorizontalAlign="Right">
                                                        <PropertiesButtonEdit>
                                                            <ClientSideEvents ButtonClick="taxAmtButnClick" GotFocus="taxAmtButnClick1" KeyDown="TaxAmountKeyDown" />

                                                            <Buttons>
                                                                <dxe:EditButton Text="..." Width="20px">
                                                                </dxe:EditButton>
                                                            </Buttons>
                                                        </PropertiesButtonEdit>

                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <CellStyle HorizontalAlign="Right"></CellStyle>
                                                    </dxe:GridViewDataButtonEditColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="TotalAmount" Caption="Net Amount" VisibleIndex="14" Width="6%" ReadOnly="true" HeaderStyle-HorizontalAlign="Right">
                                                        <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                                            <MaskSettings AllowMouseWheel="False" Mask="&lt;0..999999999999&gt;.&lt;0..99&gt;"></MaskSettings>

                                                            <Style HorizontalAlign="Right"></Style>
                                                        </PropertiesTextEdit>
                                                         
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <CellStyle HorizontalAlign="Right"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="2.5%" VisibleIndex="15" Caption=" ">
                                                        <CustomButtons>
                                                            <dxe:GridViewCommandColumnCustomButton Text=" " ID="AddNew" Image-Url="/assests/images/add.png">
                                                                <Image Url="/assests/images/add.png">
                                                                </Image>
                                                            </dxe:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                    </dxe:GridViewCommandColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="ComponentID" Caption="Component ID" VisibleIndex="16" ReadOnly="True" Width="0">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="TotalQty" Caption="Total Qty" VisibleIndex="18" ReadOnly="True" Width="0">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="BalanceQty" Caption="Balance Qty" VisibleIndex="17" ReadOnly="True" Width="0">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="IsComponentProduct" Caption="IsComponentProduct" VisibleIndex="19" ReadOnly="True" Width="0">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="IsLinkedProduct" Caption="IsLinkedProduct" VisibleIndex="20" ReadOnly="True" Width="0">
                                                    </dxe:GridViewDataTextColumn>
                                                    <dxe:GridViewDataTextColumn FieldName="ProductID" PropertiesTextEdit-ValidationSettings-ErrorImage-IconID="ghg" Caption="hidden Field Id" VisibleIndex="20" ReadOnly="True" Width="0" PropertiesTextEdit-Height="15px" PropertiesTextEdit-Style-CssClass="abcd">
                                                        <PropertiesTextEdit Height="15px">
                                                            <ValidationSettings>
                                                                <ErrorImage IconID="ghg"></ErrorImage>
                                                            </ValidationSettings>

                                                            <Style CssClass="abcd"></Style>
                                                        </PropertiesTextEdit>
                                                        <CellStyle Wrap="True" CssClass="abcd"></CellStyle>
                                                    </dxe:GridViewDataTextColumn>
                                                </Columns>
                                                <ClientSideEvents EndCallback="OnEndCallback" CustomButtonClick="OnCustomButtonClick" RowClick="GetVisibleIndex"
                                                    BatchEditStartEditing="gridFocusedRowChanged" />
                                                <SettingsDataSecurity AllowEdit="true" />
                                                <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                                                    <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="row" />
                                                </SettingsEditing>
                                                <Settings VerticalScrollableHeight="120" VerticalScrollBarMode="Auto" />
                                                <SettingsBehavior ColumnResizeMode="Disabled" />
                                            </dxe:ASPxGridView>
                                        </div>
                                        <div style="background: #f5f4f3; padding: 8px 0; margin-bottom: 0px; border-radius: 4px; border: 1px solid #ccc;" class="clearfix col-md-12 hide">


                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="lbl_Branch" runat="server" Text="Branch">
                                                </dxe:ASPxLabel>
                                                <asp:DropDownList ID="ddl_Branch" runat="server" Width="100%">
                                                </asp:DropDownList>
                                            </div>




                                            <div class="col-md-2 hide">
                                                <dxe:ASPxLabel ID="ASPxLabel8" runat="server" Text="Delivered From">
                                                </dxe:ASPxLabel>
                                                <asp:DropDownList ID="ddDeliveredFrom" runat="server" Width="100%">
                                                </asp:DropDownList>
                                            </div>

                                            <div style="clear: both">
                                            </div>

                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="lbl_ContactPerson" runat="server" Text="Contact Person">
                                                </dxe:ASPxLabel>
                                                <dxe:ASPxComboBox ID="cmbContactPerson" runat="server" OnCallback="cmbContactPerson_Callback" ClientSideEvents-EndCallback="cmbContactPersonEndCall" Width="100%" ClientInstanceName="cContactPerson" Font-Size="12px">
                                                    <ClientSideEvents EndCallback="cmbContactPersonEndCall" />
                                                </dxe:ASPxComboBox>
                                            </div>

                                            <div class="col-md-3">
                                                <%-- <dxe:ASPxLabel ID="ASPxLabel3" runat="server" Text="Salesman/Agents">
                                                </dxe:ASPxLabel>
                                                <asp:DropDownList ID="ddl_SalesAgent" runat="server" Width="100%" >
                                                </asp:DropDownList>--%>
                                            </div>
                                            <div style="clear: both">
                                            </div>
                                            <div class="col-md-3 ">
                                            </div>
                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="lbl_InvoiceNO" ClientInstanceName="clbl_InvoiceNO" runat="server" Text="Date">
                                                </dxe:ASPxLabel>
                                                <div style="width: 100%; height: 23px; border: 1px solid #e6e6e6;">
                                                    <dxe:ASPxCallbackPanel runat="server" ID="ComponentDatePanel" ClientInstanceName="cComponentDatePanel" OnCallback="ComponentDatePanel_Callback">
                                                        <PanelCollection>
                                                            <dxe:PanelContent runat="server">
                                                                <dxe:ASPxTextBox ID="txt_InvoiceDate" ClientInstanceName="ctxt_InvoiceDate" runat="server" Width="100%" ClientEnabled="false">
                                                                </dxe:ASPxTextBox>
                                                            </dxe:PanelContent>
                                                        </PanelCollection>
                                                    </dxe:ASPxCallbackPanel>
                                                </div>
                                            </div>
                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="ASPxLabel2" runat="server" Text="Cash/Bank">
                                                </dxe:ASPxLabel>
                                                <dxe:ASPxComboBox ID="ddlCashBank" runat="server" ClientIDMode="Static" ClientInstanceName="cddlCashBank" Width="100%">
                                                    <%-- <ClientSideEvents TextChanged="ShowReceiptPayment" />--%>
                                                </dxe:ASPxComboBox>
                                            </div>
                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="lbl_DueDate" runat="server" Text="Due Date">
                                                </dxe:ASPxLabel>
                                                <dxe:ASPxDateEdit ID="dt_SaleInvoiceDue" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cdt_SaleInvoiceDue" Width="100%">
                                                    <ButtonStyle Width="13px">
                                                    </ButtonStyle>
                                                </dxe:ASPxDateEdit>
                                            </div>
                                            <div style="clear: both;"></div>
                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="lbl_Currency" runat="server" Text="Currency">
                                                </dxe:ASPxLabel>
                                                <asp:DropDownList ID="ddl_Currency" runat="server" Width="100%">
                                                </asp:DropDownList>
                                            </div>
                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="lbl_Rate" runat="server" Text="Rate">
                                                </dxe:ASPxLabel>
                                                <dxe:ASPxTextBox ID="txt_Rate" ClientInstanceName="ctxt_Rate" runat="server" Width="100%" Height="28px">
                                                    <MaskSettings Mask="<0..999999999>.<0..9999>" AllowMouseWheel="false" />
                                                    <ClientSideEvents LostFocus="ReBindGrid_Currency" />
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <div class="col-md-3 hide">
                                                <dxe:ASPxLabel ID="lbl_AmountAre" runat="server" Text="Amounts are">
                                                </dxe:ASPxLabel>
                                                <dxe:ASPxComboBox ID="ddl_AmountAre" runat="server" ClientIDMode="Static" ClientInstanceName="cddl_AmountAre" Width="100%">
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) { PopulateGSTCSTVAT(e)}" />
                                                    <ClientSideEvents LostFocus="function(s, e) { SetFocusonDemand(e)}" />
                                                </dxe:ASPxComboBox>
                                            </div>

                                        </div>
                                        <div style="clear: both;"></div>



                                        <div class="greyd">
                                            <table class="bod-table none">
                                                <tbody>
                                                    <tr>
                                                        <td class="hd" width="80px" id="unitValueID" runat="server">Old unit</td>
                                                        <td style="width: 100px" id="UnitValueCombo" runat="server">
                                                            <dxe:ASPxComboBox ID="cmbOldUnit" runat="server" ClientIDMode="Static" ClientInstanceName="ccmbOldUnit" SelectedIndex="1" Width="100%">
                                                                <Items>
                                                                    <dxe:ListEditItem Text="Yes" Value="1" />
                                                                    <dxe:ListEditItem Text="No" Value="0" />
                                                                </Items>
                                                                <ClientSideEvents TextChanged="ccmbOldUnitTextChanged"></ClientSideEvents>
                                                            </dxe:ASPxComboBox>

                                                        </td>
                                                        <td id="oldunitButton" runat="server">
                                                            <input type="button" value="Old Unit Selection" onclick="OldUnitButtonOnClick()" class="btn btn-small btn-primary" style="display: none" id="OldUnitSelectionButton" />
                                                        </td>
                                                        <td class="hd" id="unitvaluelbl" runat="server">Unit Value</td>
                                                        <td id="unitValueText" runat="server">
                                                            <dxe:ASPxTextBox ID="txtunitValue" MaxLength="80" ClientInstanceName="ctxtunitValue" ClientEnabled="false" runat="server" Width="100%">
                                                                <MaskSettings Mask="<0..999999999999>.<0..99>" AllowMouseWheel="false" />
                                                            </dxe:ASPxTextBox>
                                                        </td>
                                                        <td class="hd">Remarks</td>
                                                        <td style="width: 500px">
                                                            <dxe:ASPxTextBox ID="txtRemarks" MaxLength="300" ClientInstanceName="ctxtRemarks" runat="server" Width="100%">
                                                            </dxe:ASPxTextBox>
                                                        </td>

                                                        <td class="hd" id="lblAdvnceRecptNo" runat="server">
                                                            <input type="button" value="Advance / Return" onclick="AdvanceReceiptOnClick()" class="btn btn-small btn-primary" />

                                                        </td>
                                                        <td id="lblAdvnceRecptNovalue" runat="server">
                                                            <dxe:ASPxTextBox ID="txtAdvnceReceipt" MaxLength="80" ClientInstanceName="ctxtAdvnceReceipt" ClientEnabled="False" runat="server" Width="100%">
                                                                <MaskSettings Mask="<0..999999999999>.<0..99>" AllowMouseWheel="false" />
                                                            </dxe:ASPxTextBox>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>




                                        <div class="content reverse horizontal-images clearfix" style="width: 100%; margin-right: 0; padding: 8px; height: auto; border-top: 1px solid #ccc; border-bottom: 1px solid #ccc; border-radius: 0;">
                                            <ul>
                                                <li class="clsbnrLblTaxableAmt">
                                                    <div class="horizontallblHolder">
                                                        <table>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblTaxableAmt" runat="server" Text="Taxable Amt" ClientInstanceName="cbnrLblTaxableAmt" />
                                                                    </td>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblTaxableAmtval" runat="server" Text="0.00" ClientInstanceName="cbnrLblTaxableAmtval" />
                                                                    </td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </li>
                                                <li class="clsbnrLblTaxAmt">
                                                    <div class="horizontallblHolder" id="">
                                                        <table>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblTaxAmt" runat="server" Text="Tax Amt" ClientInstanceName="cbnrLblTaxAmt" />
                                                                    </td>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblTaxAmtval" runat="server" Text="0.00" ClientInstanceName="cbnrLblTaxAmtval" />
                                                                    </td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </li>
                                                <li class="clsbnrLblAmtWithTax" runat="server" id="oldUnitBanerLbl">
                                                    <div class="horizontallblHolder">
                                                        <table>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblAmtWithTax" runat="server" Text="Amount With Tax" ClientInstanceName="cbnrLblAmtWithTax" />
                                                                    </td>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrlblAmountWithTaxValue" runat="server" Text="0.00" ClientInstanceName="cbnrlblAmountWithTaxValue" />
                                                                    </td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </li>
                                                <li class="clsbnrLblLessOldVal">
                                                    <div class="horizontallblHolder" id="">
                                                        <table>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblLessOldVal" runat="server" Text="Less Old Unit Value" ClientInstanceName="cbnrLblLessOldVal" />
                                                                    </td>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblLessOldMainVal" runat="server" Text=" 0.00" ClientInstanceName="cbnrLblLessOldMainVal"></dxe:ASPxLabel>
                                                                    </td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </li>
                                                <li class="clsbnrLblLessAdvance" id="idclsbnrLblLessAdvance" runat="server">
                                                    <div class="horizontallblHolder">
                                                        <table>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblLessAdvance" runat="server" Text="Advance Adjusted" ClientInstanceName="cbnrLblLessAdvance" />
                                                                    </td>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblLessAdvanceValue" runat="server" Text="0.00" ClientInstanceName="cbnrLblLessAdvanceValue" />
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
                                                                        <dxe:ASPxLabel ID="bnrLblInvVal" runat="server" Text="Invoice Value" ClientInstanceName="cbnrLblInvVal" />
                                                                    </td>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrLblInvValue" runat="server" Text="0.00" ClientInstanceName="cbnrLblInvValue" />
                                                                    </td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </li>

                                                <li class="clsbnrLblInvVal" id="otherChargesId">
                                                    <div class="horizontallblHolder">
                                                        <table>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="cbnrOtherCharges" runat="server" Text="Other Charges" ClientInstanceName="cbnrOtherCharges" />
                                                                    </td>
                                                                    <td>
                                                                        <dxe:ASPxLabel ID="bnrOtherChargesvalue" runat="server" Text="0.00" ClientInstanceName="cbnrOtherChargesvalue" />
                                                                    </td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </li>


                                                <li class="clsbnrLblInvVal">
                                                    <div class="horizontallblHolder" style="border-color: #f14327;">
                                                        <table>
                                                            <tbody>
                                                                <tr>
                                                                    <td style="background: #f14327;">
                                                                        <dxe:ASPxLabel ID="ASPxLabel11" runat="server" Text="Running Balance" ClientInstanceName="cbnrLblInvVal" />
                                                                    </td>
                                                                    <td>
                                                                        <strong>
                                                                            <dxe:ASPxLabel ID="lblRunningBalanceCapsul" runat="server" Text="0.00" ClientInstanceName="clblRunningBalanceCapsul" />
                                                                        </strong>
                                                                    </td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </li>

                                            </ul>

                                        </div>







                                        <%--    <section class="rds">
                     <div class="clearfix">
                         <span class="fieldsettype">Cash Invoice Payment Details</span>
                         <table class="pull-right pad">
                             <tbody><tr>
                                 <td><strong>Select cash Amt</strong></td>
                                 <td><select class="form-control"><option>Select</option></select></td>
                                 <td class="hd"><strong>Enter cash Amt</strong></td>
                                 <td><input type="text"></td>
                             </tr>
                         </tbody></table>
                     </div>


                     <table class="table-duplicate">
                         <tbody id="paymentDetails">
                             <tr>
                             <td width="10%">
                                 <label>Payment Type</label>
                                 <select class="form-control" onchange="paymentTypeChange(event)">
                                      <option>-Select-</option>
                                     <option>Card</option>
                                     <option>Cheque</option>
                                     <option>Coupon</option>
                                     <option>E Transfer</option>
                                 </select>
                             </td>
                             
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            
                         </tr>

                         
                         
                     </tbody></table>
                 </section>--%>



                                        <uc1:ucPaymentDetails runat="server" ID="PaymentDetails" />

















                                        <div class="">
                                            <div style="display: none;">
                                                <a href="javascript:void(0);" onclick="OnAddNewClick()" class="btn btn-primary"><span>Add New</span> </a>
                                            </div>
                                            <div>
                                                <br />
                                            </div>

                                        </div>
                                        <div style="clear: both;"></div>
                                        <br />
                                        <div class="col-md-12" id="divSubmitButton">
                                            <asp:Label ID="lbl_quotestatusmsg" runat="server" Text="" Font-Bold="true" ForeColor="Red" Font-Size="Medium"></asp:Label>
                                            <dxe:ASPxButton ID="btn_SaveRecords" ClientInstanceName="cbtn_SaveRecords" runat="server" AutoPostBack="False" Text="Save & N&#818;ew" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                                <ClientSideEvents Click="function(s, e) {Save_ButtonClick();}" />
                                            </dxe:ASPxButton>
                                            <dxe:ASPxButton ID="ASPxButton1" ClientInstanceName="cbtn_SaveRecords" runat="server" AutoPostBack="False" Text="Save & Ex&#818;it" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                                <ClientSideEvents Click="function(s, e) {SaveExit_ButtonClick(s,e);}" />
                                            </dxe:ASPxButton>

                                           

                                            <%--   <asp:Button ID="ASPxButton2" runat="server" Text="UDF" CssClass="btn btn-primary" OnClientClick="if(OpenUdf()){ return false;}" />--%>
                                            <dxe:ASPxButton ID="ASPxButton2" ClientInstanceName="cbtn_SaveRecords" runat="server" AutoPostBack="False" Text="U&#818;DF" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                                <ClientSideEvents Click="function(s, e) {if(OpenUdf()){ return false}}" />
                                            </dxe:ASPxButton>
                                            <%--  Text="T&#818;axes"--%>
                                            <dxe:ASPxButton ID="ASPxButton3" ClientInstanceName="cbtn_SaveRecords" runat="server" AutoPostBack="False" Text="T&#818;ax & Charges" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                                <ClientSideEvents Click="function(s, e) {Save_TaxesClick();}" />
                                            </dxe:ASPxButton>
                                            <%-- onclick=""--%>
                                            <%--<a href="javascript:void(0);" id="btnAddNew" runat="server" class="btn btn-primary"><span>[A]ttachment(s)</span></a>--%>
                                            <%--<dxe:ASPxButton ID="ASPxButton4" ClientInstanceName="cbtn_SaveRecords" runat="server" AccessKey="X" AutoPostBack="False" Text="[A]ttachment(s)" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1">
                            <ClientSideEvents Click="function(s, e) {Save_ButtonClick();}" />
                        </dxe:ASPxButton>--%>
                                            <%--<a class="btn btn-primary" href="javascript:void(0);" onclick="fn_PopOpen()"><span>[B]illing/Shipping</span> </a>--%>
                                        </div>
                                    </div>
                                </dxe:ContentControl>
                            </ContentCollection>
                            <%--test generel--%>
                        </dxe:TabPage>
                        <%--<dxe:TabPage Name="[A]ttachment(s)" Visible="false" Text="[A]ttachment(s)">
                            <ContentCollection>
                                <dxe:ContentControl runat="server">
                                </dxe:ContentControl>
                            </ContentCollection>
                        </dxe:TabPage>--%>
                        <dxe:TabPage Name="[B]illing/Shipping" Text="Billing/Shipping">
                            <ContentCollection>
                                <dxe:ContentControl runat="server">



                                    <dxe:ASPxPopupControl ID="ASPXPopupControl1" runat="server" ContentUrl="AddArea_PopUp.aspx"
                                        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupan" Height="250px"
                                        Width="300px" HeaderText="Add New Area" AllowResize="true" ResizingMode="Postponed" Modal="true">
                                        <ContentCollection>
                                            <dxe:PopupControlContentControl runat="server">
                                            </dxe:PopupControlContentControl>
                                        </ContentCollection>
                                        <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
                                    </dxe:ASPxPopupControl>



                                    <%--Subhra Changes-----------01-02-2017--%>
                                    <dxe:ASPxCallbackPanel runat="server" ID="ComponentPanel" ClientInstanceName="cComponentPanel" OnCallback="ComponentPanel_Callback">
                                        <PanelCollection>
                                            <dxe:PanelContent runat="server">
                                                <div>
                                                    <table>
                                                        <tr>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                    </table>
                                                    <div class="row">
                                                        <div class="col-md-5 mbot5" id="DivBilling">
                                                            <div class="clearfix" style="background: #fff; border: 1px solid #ccc; padding: 0px 0 10px 0;">
                                                                <h5 class="headText" style="margin: 0; padding: 10px 15px 10px; background: #ececec; margin-bottom: 10px">Billing Address</h5>
                                                                <div style="padding-right: 8px">
                                                                    <div class="col-md-4" style="height: auto;">

                                                                        <%--// Sandip Latest  Addres Section Start--%>
                                                                        <%--Type--%>
                                                                        <asp:Label ID="LblType" runat="server" Text="Select Address:" CssClass="newLbl"></asp:Label>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <%--/////////////////--%>
                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxGridLookup ID="billingAddress" runat="server" ClientInstanceName="billingLookup"
                                                                                KeyFieldName="add_id" Width="100%" TextFormatString="{0}" AutoGenerateColumns="False" SelectionMode="Single">
                                                                                <Columns>
                                                                                    <%--<dxe:GridViewCommandColumn ShowSelectCheckbox="True" Width="60" Caption=" " VisibleIndex="0"/>--%>
                                                                                    <dxe:GridViewDataColumn FieldName="address" Visible="true" VisibleIndex="1" Caption="Address" Width="250" Settings-AutoFilterCondition="Contains">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="City_Name" Visible="true" VisibleIndex="2" Caption="City" Settings-AllowAutoFilter="False" Width="100">

                                                                                        <%--<Settings AllowAutoFilter="False"></Settings>--%>
                                                                                        <Settings AllowAutoFilter="False" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="State" Visible="true" VisibleIndex="3" Caption="State" Width="100" Settings-AutoFilterCondition="Contains">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="pin_code" Visible="true" VisibleIndex="4" Caption="Zip" Width="80" Settings-AutoFilterCondition="Contains">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="Country_Name" Visible="true" VisibleIndex="5" Caption="Country" Width="100" Settings-AutoFilterCondition="Contains">

                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>

                                                                                </Columns>
                                                                                <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                                                                                    <Templates>
                                                                                        <StatusBar>
                                                                                            <table class="OptionsTable" style="float: right">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="ClosebillingLookup" />
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </StatusBar>
                                                                                    </Templates>

                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>

                                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                                    </SettingsPager>

                                                                                    <Settings ShowStatusBar="Visible" UseFixedTableLayout="true" />
                                                                                </GridViewProperties>
                                                                                <ClientSideEvents TextChanged="function(s, e) { GetBillingAddressDetailByAddressId(e)}" />
                                                                                <ClearButton DisplayMode="Auto">
                                                                                </ClearButton>
                                                                            </dxe:ASPxGridLookup>
                                                                            <%--// Sandip Latest  Addres Section End--%>
                                                                            <%-- <dxe:ASPxComboBox ID="CmbAddressType" ClientInstanceName="CmbAddressType" runat="server" TabIndex="1"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                                                 
                                                                                <Items>
                                                                                    <dxe:ListEditItem Text="Billing" Value="Billing" Selected="true"></dxe:ListEditItem>
                                                                                     
                                                                                </Items>
                                                                            </dxe:ASPxComboBox>--%>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        <%--Code--%>
                                                                        Address1:
                                                                         <%-- <asp:Label ID="LblCode" runat="server" Text="Short Name (Unique)" CssClass="newLbl"></asp:Label>--%><span style="color: red;"> *</span>

                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxTextBox ID="txtAddress1" MaxLength="80" ClientInstanceName="ctxtAddress1"
                                                                                runat="server" Width="100%">
                                                                                <%-- <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                                <%-- <ClientSideEvents TextChanged="function(s,e){fn_ctxtPro_Name_TextChanged()}" />--%>
                                                                            </dxe:ASPxTextBox>
                                                                            <span id="badd1" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        <%--Code--%>
                                                                            Address2:
                                                                           

                                                                    </div>
                                                                    <%--Start of Address2 --%>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxTextBox ID="txtAddress2" MaxLength="80" ClientInstanceName="ctxtAddress2"
                                                                                runat="server" Width="100%">
                                                                            </dxe:ASPxTextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        <%--Code--%>
                                                                        Address3:
                                                                       <%-- <asp:Label ID="LblCode" runat="server" Text="Short Name (Unique)" CssClass="newLbl"></asp:Label>--%>
                                                                    </div>
                                                                    <%--Start of Address3 --%>

                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxTextBox ID="txtAddress3" MaxLength="80" ClientInstanceName="ctxtAddress3"
                                                                                runat="server" Width="100%">
                                                                                <%--<ValidationSettings    ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                            </ValidationSettings>--%>
                                                                                <%-- <ClientSideEvents TextChanged="function(s,e){fn_ctxtPro_Name_TextChanged()}" />--%>
                                                                            </dxe:ASPxTextBox>
                                                                        </div>
                                                                    </div>
                                                                    <%--Start of Landmark --%>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        <%--Code--%>
                                                                            Landmark:
                                                                             

                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxTextBox ID="txtlandmark" MaxLength="80" ClientInstanceName="ctxtlandmark"
                                                                                runat="server" Width="100%">
                                                                                <%--<ValidationSettings    ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                            </ValidationSettings>--%>
                                                                                <%-- <ClientSideEvents TextChanged="function(s,e){fn_ctxtPro_Name_TextChanged()}" />--%>
                                                                            </dxe:ASPxTextBox>
                                                                        </div>
                                                                    </div>
                                                                    <%--End of Country--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label2" runat="server" Text="Country:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbCountry" ClientInstanceName="CmbCountry" runat="server" ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                                                <%--<ClearButton DisplayMode="Always"></ClearButton>--%>
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCountryChanged(s); }"></ClientSideEvents>
                                                                                <%--<ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="bcountry" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <%--End of State--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label4" runat="server" Text="State:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbState" ClientInstanceName="CmbState" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0"
                                                                                OnCallback="cmbState_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnStateChanged(s); }" EndCallback="cmbstate_endcallback"></ClientSideEvents>
                                                                                <%-- <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="bstate" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <%--start of City/district.--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label6" runat="server" Text="City/District:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbCity" ClientInstanceName="CmbCity" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True"
                                                                                EnableIncrementalFiltering="True" SelectedIndex="0" OnCallback="cmbCity_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCityChanged(s); }" EndCallback="cmbcity_endcallback"></ClientSideEvents>
                                                                                <%--<ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="bcity" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <%--start of Pin/Zip.--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label8" runat="server" Text="Pin/Zip:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbPin" ClientInstanceName="CmbPin" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0" OnCallback="cmbPin_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents EndCallback="cmbPin_endcallback"></ClientSideEvents>
                                                                                <%--<ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="bpin" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>

                                                                        </div>
                                                                    </div>
                                                                    <%--start of Area--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label10" runat="server" Text="Area:" CssClass="newLbl"></asp:Label>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content">
                                                                            <dxe:ASPxComboBox ID="CmbArea" ClientInstanceName="CmbArea" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0" OnCallback="cmbArea_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents EndCallback="cmbArea_endcallback"></ClientSideEvents>
                                                                            </dxe:ASPxComboBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="clear"></div>
                                                                    <div class="col-md-12" style="height: auto;">
                                                                        <dxe:ASPxCheckBox ID="chkBilling" runat="server" ClientInstanceName="cchkBilling" Text="Shipping to be in the same location of Billing. ">
                                                                            <ClientSideEvents CheckedChanged="function(s,e){CopyBillingAddresstoShipping(s);}"></ClientSideEvents>
                                                                        </dxe:ASPxCheckBox>
                                                                    </div>

                                                                    <%-- <div class="col-md-offset-4 col-md-8">
                                                                        <a href="#" onclick="javascript:openAreaPage();"><span class="Ecoheadtxt" style="color: Blue">
                                                                            <strong>Add New Area</strong></span></a>
                                                                    </div>--%>
                                                                </div>
                                                            </div>
                                                        </div>


                                                        <div class="col-md-5 mbot5" id="DivShipping">
                                                            <div class="clearfix" style="background: #fff; border: 1px solid #ccc; padding: 0px 0 10px 0;">

                                                                <h5 class="headText" style="margin: 0; padding: 10px 15px 10px; background: #ececec; margin-bottom: 10px">Shipping Address</h5>
                                                                <div style="padding-right: 8px">
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>

                                                                        <%--// Sandip Latest  Addres Section Start--%>
                                                                        <asp:Label ID="Label1" runat="server" Text="Select Address:" CssClass="newLbl"></asp:Label>
                                                                    </div>
                                                                    <div class="col-md-8">


                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxGridLookup ID="shippingAddress" runat="server" ClientInstanceName="shippingLookup"
                                                                                KeyFieldName="add_id" Width="100%" TextFormatString="{0}" AutoGenerateColumns="False" SelectionMode="Single">
                                                                                <Columns>
                                                                                    <%--<dxe:GridViewCommandColumn ShowSelectCheckbox="True" Width="60" Caption=" " VisibleIndex="0"/>--%>
                                                                                    <dxe:GridViewDataColumn FieldName="address" Visible="true" VisibleIndex="1" Caption="Address" Width="250" Settings-AutoFilterCondition="Contains">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="City_Name" Visible="true" VisibleIndex="2" Caption="City" Settings-AllowAutoFilter="False" Width="100">

                                                                                        <%--<Settings AllowAutoFilter="False"></Settings>--%>
                                                                                        <Settings AllowAutoFilter="False" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="State" Visible="true" VisibleIndex="3" Caption="State" Width="100" Settings-AutoFilterCondition="Contains">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="pin_code" Visible="true" VisibleIndex="4" Caption="Zip" Width="80" Settings-AutoFilterCondition="Contains">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>
                                                                                    <dxe:GridViewDataColumn FieldName="Country_Name" Visible="true" VisibleIndex="5" Caption="Country" Width="100" Settings-AutoFilterCondition="Contains">

                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dxe:GridViewDataColumn>

                                                                                </Columns>
                                                                                <GridViewProperties Settings-VerticalScrollBarMode="Auto" SettingsPager-Mode="ShowAllRecords">
                                                                                    <Templates>
                                                                                        <StatusBar>
                                                                                            <table class="OptionsTable" style="float: right">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <dxe:ASPxButton ID="Close1" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseshippingLookup" />
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </StatusBar>
                                                                                    </Templates>

                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>

                                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                                    </SettingsPager>

                                                                                    <Settings ShowStatusBar="Visible" UseFixedTableLayout="true" />
                                                                                </GridViewProperties>
                                                                                <ClientSideEvents TextChanged="function(s, e) { GetShippingAddressDetailByAddressId(e)}" />
                                                                                <ClearButton DisplayMode="Auto">
                                                                                </ClearButton>
                                                                            </dxe:ASPxGridLookup>
                                                                            <%--// Sandip Latest  Addres Section End--%>
                                                                            <%--<dxe:ASPxComboBox ID="CmbAddressType1" ClientInstanceName="CmbAddressType1" runat="server" TabIndex="11"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                                                <Items>
                                                                                    <dxe:ListEditItem Text="Shipping" Value="Shipping"  Selected="true"></dxe:ListEditItem>
                                                                                </Items>
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                            </dxe:ASPxComboBox>--%>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        Address1: <span style="color: red;">*</span>

                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxTextBox ID="txtsAddress1" MaxLength="80" ClientInstanceName="ctxtsAddress1"
                                                                                runat="server" Width="100%">
                                                                                <%--<ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxTextBox>
                                                                            <span id="sadd1" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        Address2:
                                                                           
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content">
                                                                            <dxe:ASPxTextBox ID="txtsAddress2" MaxLength="80" ClientInstanceName="ctxtsAddress2"
                                                                                runat="server" Width="100%">
                                                                            </dxe:ASPxTextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        Address3: 
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content">
                                                                            <dxe:ASPxTextBox ID="txtsAddress3" MaxLength="80" ClientInstanceName="ctxtsAddress3"
                                                                                runat="server" Width="100%">
                                                                            </dxe:ASPxTextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto; margin-bottom: 5px;">
                                                                        Landmark: 
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content">
                                                                            <dxe:ASPxTextBox ID="txtslandmark" MaxLength="80" ClientInstanceName="ctxtslandmark"
                                                                                runat="server" Width="100%">
                                                                            </dxe:ASPxTextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-md-4" style="height: auto;">

                                                                        <asp:Label ID="Label3" runat="server" Text="Country:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbCountry1" ClientInstanceName="CmbCountry1" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True"
                                                                                SelectedIndex="0">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCountryChanged1(s); }"></ClientSideEvents>
                                                                                <%-- <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="scountry" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <%--End of Country--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label5" runat="server" Text="State:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbState1" ClientInstanceName="CmbState1" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True"
                                                                                SelectedIndex="0" OnCallback="cmbState1_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnStateChanged1(s); }" EndCallback="cmbshipstate_endcallback"></ClientSideEvents>
                                                                                <%--<ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="sstate" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <%--End of State--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label7" runat="server" Text="City/District:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbCity1" ClientInstanceName="CmbCity1" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0" OnCallback="cmbCity1_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCityChanged1(s); }" EndCallback="cmbshipcity_endcallback"></ClientSideEvents>
                                                                                <%-- <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="scity" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <%--End of City/District--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label9" runat="server" Text="Pin/Zip:" CssClass="newLbl"></asp:Label><span style="color: red;">*</span>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content relative">
                                                                            <dxe:ASPxComboBox ID="CmbPin1" ClientInstanceName="CmbPin1" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0" OnCallback="cmbPin_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents EndCallback="cmbshipPin_endcallback"></ClientSideEvents>
                                                                                <%--<ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Address" ErrorTextPosition="Right" ErrorImage-ToolTip="Mandatory" SetFocusOnError="True">
                                                                                    <ErrorImage ToolTip="Mandatory"></ErrorImage>

                                                                                    <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                                                </ValidationSettings>--%>
                                                                            </dxe:ASPxComboBox>
                                                                            <span id="spin" style="display: none" class="mandt">
                                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <%--End of Pin/Zip.--%>
                                                                    <div class="col-md-4" style="height: auto;">
                                                                        <%--Type--%>
                                                                        <asp:Label ID="Label11" runat="server" Text="Area:" CssClass="newLbl"></asp:Label>
                                                                    </div>
                                                                    <div class="col-md-8">

                                                                        <div class="Left_Content">
                                                                            <dxe:ASPxComboBox ID="CmbArea1" ClientInstanceName="CmbArea1" runat="server"
                                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0" OnCallback="cmbArea1_OnCallback">
                                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                                <ClientSideEvents EndCallback="cmbshipArea_endcallback"></ClientSideEvents>
                                                                            </dxe:ASPxComboBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="clear"></div>
                                                                    <div class="col-md-12" style="height: auto;">
                                                                        <dxe:ASPxCheckBox ID="chkShipping" runat="server" ClientInstanceName="cchkShipping" Text="Billing to be in the same location of Shipping">
                                                                            <ClientSideEvents CheckedChanged="function(s,e){CopyShippingAddresstoBilling(s);}"></ClientSideEvents>
                                                                        </dxe:ASPxCheckBox>
                                                                    </div>
                                                                    <%--<div class="col-md-offset-4 col-md-8">
                                                                        <a href="#" onclick="javascript:openAreaPageShip();"><span class="Ecoheadtxt" style="color: Blue">
                                                                            <strong>Add New Area</strong></span></a>
                                                                    </div>--%>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>
                                                    <%--End of Address Type--%>




                                                    <%--End of Area--%>


                                                    <div class="clear"></div>
                                                    <div class="col-md-12 pdLeft0" style="padding-top: 10px">
                                                        <%--   <button class="btn btn-primary">OK</button> ValidationGroup="Address"--%>

                                                        <dxe:ASPxButton ID="btnSave_citys" CausesValidation="true" ClientInstanceName="cbtnSave_citys" runat="server"
                                                            AutoPostBack="False" Text="OK" CssClass="btn btn-primary">
                                                            <ClientSideEvents Click="function (s, e) {btnSave_QuoteAddress();}" />
                                                        </dxe:ASPxButton>

                                                    </div>
                                                </div>
                                            </dxe:PanelContent>
                                        </PanelCollection>
                                        <%--      <ClientSideEvents EndCallback="Panel_endcallback" />--%>
                                    </dxe:ASPxCallbackPanel>



                                    <%--         <dxe:ASPxPopupControl ID="Popup_SalesQuote" runat="server" ClientInstanceName="Popup_SalesQuote"
                Width="550px" HeaderText="Add/Modify Address" PopupHorizontalAlign="WindowCenter" HeaderStyle-CssClass="wht"
                PopupVerticalAlign="WindowCenter" CloseAction="CloseButton" OnWindowCallback="Popup_SalesQuote_WindowCallback"
                Modal="True" EnableHierarchyRecreation="True">
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                      
                    </dxe:PopupControlContentControl>
                </ContentCollection>
                <ContentStyle VerticalAlign="Top" CssClass="pad"></ContentStyle>

                <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                <ClientSideEvents EndCallback="function (s, e) {Popup_SalesQuote_EndCallBack();}" />
            </dxe:ASPxPopupControl>--%>
                                </dxe:ContentControl>
                            </ContentCollection>
                        </dxe:TabPage>

                    </TabPages>
                    <ClientSideEvents ActiveTabChanged="function(s, e) {
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


	                                            }"></ClientSideEvents>

                </dxe:ASPxPageControl>
            </div>
            <%--SelectCommand="SELECT s.id as ID,s.state as State from tbl_master_state s where (s.countryId = @State) ORDER BY s.state">--%>
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
            <asp:SqlDataSource ID="sqltaxDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                SelectCommand="select Taxes_ID,Taxes_Name from dbo.Master_Taxes"></asp:SqlDataSource>

            <dxe:ASPxPopupControl ID="ASPXPopupControl" runat="server" ContentUrl="AddArea_PopUp.aspx"
                CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupan" Height="250px"
                Width="300px" HeaderText="Add New Area" AllowResize="true" ResizingMode="Postponed" Modal="true">
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                    </dxe:PopupControlContentControl>
                </ContentCollection>
                <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
            </dxe:ASPxPopupControl>

            <%--Sudip--%>
            <div class="PopUpArea">
                <asp:HiddenField ID="HdChargeProdAmt" runat="server" />
                <asp:HiddenField ID="HdChargeProdNetAmt" runat="server" />
                <%--ChargesTax--%>
                <dxe:ASPxPopupControl ID="Popup_Taxes" runat="server" ClientInstanceName="cPopup_Taxes"
                    Width="900px" Height="300px" HeaderText="Other Charges" PopupHorizontalAlign="WindowCenter"
                    BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <ContentStyle VerticalAlign="Top" CssClass="pad">
                    </ContentStyle>
                    <ContentCollection>
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
                                                                <dxe:ASPxLabel ID="ASPxLabel6" runat="server" Text="ASPxLabel" ClientInstanceName="clblChargesTaxableGross"></dxe:ASPxLabel>
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
                                                                <dxe:ASPxLabel ID="ASPxLabel7" runat="server" Text="ASPxLabel" ClientInstanceName="clblChargesTaxableNet"></dxe:ASPxLabel>
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
                                                    <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                    <ClientSideEvents LostFocus="PercentageTextChange" />
                                                    <ClientSideEvents />
                                                </PropertiesTextEdit>
                                                <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn FieldName="Amount" Caption="Amount" VisibleIndex="2" Width="20%">
                                                <PropertiesTextEdit Style-HorizontalAlign="Right" DisplayFormatString="0.00">
                                                    <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
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
                                        <dxe:ASPxButton ID="btn_SaveTax" ClientInstanceName="cbtn_SaveTax" runat="server" AutoPostBack="False" Text="Save" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1">
                                            <ClientSideEvents Click="function(s, e) {Save_TaxClick();}" />
                                        </dxe:ASPxButton>
                                        <dxe:ASPxButton ID="ASPxButton5" ClientInstanceName="cbtn_tax_cancel" runat="server" AutoPostBack="False" Text="Cancel" CssClass="btn btn-danger">
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
                                                        <MaskSettings Mask="&lt;-999999999..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
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
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                </dxe:ASPxPopupControl>
                <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A3" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
                </dxe:ASPxGridViewExporter>
                <dxe:ASPxPopupControl ID="Popup_Warehouse" runat="server" ClientInstanceName="cPopup_Warehouse"
                    Width="900px" HeaderText="Warehouse Details" PopupHorizontalAlign="WindowCenter"
                    BackColor="white" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                    Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True"
                    ContentStyle-CssClass="pad">
                    <ClientSideEvents Closing="function(s, e) {
	closeWarehouse(s, e);}" />
                    <ContentStyle VerticalAlign="Top" CssClass="pad">
                    </ContentStyle>
                    <ContentCollection>
                        <dxe:PopupControlContentControl runat="server">
                            <div class="Top clearfix">
                                <div id="content-5" class="pull-right wrapHolder content horizontal-images" style="width: 100%; margin-right: 0px;">
                                    <ul>
                                        <li>
                                            <div class="lblHolder">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>Selected Product</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblProductName" runat="server"></asp:Label></td>
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
                                                            <td>Entered Quantity </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="txt_SalesAmount" runat="server"></asp:Label>
                                                                <asp:Label ID="txt_SalesUOM" runat="server"></asp:Label>

                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="lblHolder" id="divpopupAvailableStock" style="display: none;">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>Available Stock</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="lblAvailableStock" runat="server"></asp:Label>
                                                                <asp:Label ID="lblAvailableStockUOM" runat="server"></asp:Label>

                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>
                                       
                                          
 

                                        <li style="display: none;">
                                            <div class="lblHolder">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td>Stock Quantity </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="txt_StockAmount" runat="server"></asp:Label>
                                                                <asp:Label ID="txt_StockUOM" runat="server"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </li>

                                    </ul>
                                </div>

                                <div class="clear">
                                    <br />
                                </div>
                                <div class="clearfix col-md-12" style="background: #f5f4f3; padding: 8px 0; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ccc;">
                                    <div>
                                        <div class="col-md-3" id="div_Warehouse">
                                            <div style="margin-bottom: 5px;">
                                                Warehouse
                                            </div>
                                            <div class="Left_Content" style="">
                                                <dxe:ASPxComboBox ID="CmbWarehouse" EnableIncrementalFiltering="True" ClientInstanceName="cCmbWarehouse" SelectedIndex="0"
                                                    TextField="WarehouseName" ValueField="WarehouseID" runat="server" Width="100%" OnCallback="CmbWarehouse_Callback">
                                                    <ClientSideEvents ValueChanged="function(s,e){CmbWarehouse_ValueChange()}" EndCallback="CmbWarehouseEndCallback"></ClientSideEvents>
                                                </dxe:ASPxComboBox>
                                                <span id="spnCmbWarehouse" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                            </div>
                                        </div>
                                        <div class="col-md-3" id="div_Batch">
                                            <div style="margin-bottom: 5px;">
                                                Batch
                                            </div>
                                            <div class="Left_Content" style="">
                                                <dxe:ASPxComboBox ID="CmbBatch" EnableIncrementalFiltering="True" ClientInstanceName="cCmbBatch"
                                                    TextField="BatchName" ValueField="BatchID" runat="server" Width="100%" OnCallback="CmbBatch_Callback">
                                                    <ClientSideEvents ValueChanged="function(s,e){CmbBatch_ValueChange()}" EndCallback="CmbBatchEndCall"></ClientSideEvents>
                                                </dxe:ASPxComboBox>
                                                <span id="spnCmbBatch" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                            </div>
                                        </div>
                                        <div class="col-md-4" id="div_Serial">
                                            <div style="margin-bottom: 5px;">
                                                Serial No  (
                                                <input type="checkbox" id="myCheck" name="BarCode" onchange="AutoCalculateMandateOnChange(this)">Barcode )
                                            </div>
                                            <div class="" id="divMultipleCombo">
                                                <%--<dxe:ASPxComboBox ID="CmbSerial" EnableIncrementalFiltering="True" ClientInstanceName="cCmbSerial"
                                                    TextField="SerialName" ValueField="SerialID" runat="server" Width="100%" OnCallback="CmbSerial_Callback">
                                                </dxe:ASPxComboBox>--%>
                                                <dxe:ASPxDropDownEdit ClientInstanceName="checkComboBox" ID="ASPxDropDownEdit1" Width="85%" CssClass="pull-left" runat="server" AnimationType="None">
                                                    <DropDownWindowStyle BackColor="#EDEDED" />
                                                    <DropDownWindowTemplate>
                                                        <dxe:ASPxListBox Width="100%" ID="listBox" ClientInstanceName="checkListBox" SelectionMode="CheckColumn" OnCallback="CmbSerial_Callback"
                                                            runat="server">
                                                            <Border BorderStyle="None" />
                                                            <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />

                                                            <ClientSideEvents SelectedIndexChanged="OnListBoxSelectionChanged" EndCallback="listBoxEndCall" />
                                                        </dxe:ASPxListBox>
                                                        <table style="width: 100%">
                                                            <tr>
                                                                <td style="padding: 4px">
                                                                    <dxe:ASPxButton ID="ASPxButton4" AutoPostBack="False" runat="server" Text="Close" Style="float: right">
                                                                        <ClientSideEvents Click="function(s, e){ checkComboBox.HideDropDown(); }" />
                                                                    </dxe:ASPxButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </DropDownWindowTemplate>
                                                    <ClientSideEvents TextChanged="SynchronizeListBoxValues" DropDown="SynchronizeListBoxValues" GotFocus="function(s, e){ s.ShowDropDown(); }" />
                                                </dxe:ASPxDropDownEdit>
                                                <span id="spncheckComboBox" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                                <div class="pull-left">
                                                    <i class="fa fa-commenting" id="abpl" aria-hidden="true" style="font-size: 16px; cursor: pointer; margin: 3px 0 0 5px;" title="Serial No " data-container="body" data-toggle="popover" data-placement="right" data-content=""></i>
                                                </div>
                                            </div>
                                            <div class="" id="divSingleCombo" style="display: none;">
                                                <dxe:ASPxTextBox ID="txtserial" runat="server" Width="85%" ClientInstanceName="ctxtserial" HorizontalAlign="Left" Font-Size="12px" MaxLength="49">
                                                    <ClientSideEvents TextChanged="txtserialTextChanged" />
                                                </dxe:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-3" id="div_Quantity">
                                            <div style="margin-bottom: 2px;">
                                                Quantity
                                            </div>
                                            <div class="Left_Content" style="">
                                                <dxe:ASPxTextBox ID="txtQuantity" runat="server" ClientInstanceName="ctxtQuantity" HorizontalAlign="Right" Font-Size="12px" Width="100%" Height="15px">
                                                    <MaskSettings Mask="<0..999999999999>.<0..99>" IncludeLiterals="DecimalSymbol" />
                                                    <ClientSideEvents TextChanged="function(s, e) {SaveWarehouse();}" />
                                                </dxe:ASPxTextBox>
                                                <span id="spntxtQuantity" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div>
                                            </div>
                                            <div class="Left_Content" style="padding-top: 14px">
                                                <dxe:ASPxButton ID="btnWarehouse" ClientInstanceName="cbtnWarehouse" Width="50px" runat="server" AutoPostBack="False" Text="Add" CssClass="btn btn-primary">
                                                    <ClientSideEvents Click="function(s, e) {SaveWarehouse();}" />
                                                </dxe:ASPxButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="clearfix">
                                    <dxe:ASPxGridView ID="GrdWarehouse" runat="server" KeyFieldName="SrlNo" AutoGenerateColumns="False"
                                        Width="100%" ClientInstanceName="cGrdWarehouse" OnCustomCallback="GrdWarehouse_CustomCallback" OnDataBinding="GrdWarehouse_DataBinding"
                                        SettingsPager-Mode="ShowAllRecords" Settings-VerticalScrollBarMode="auto" Settings-VerticalScrollableHeight="200" SettingsBehavior-AllowSort="false">
                                        <Columns>
                                            <dxe:GridViewDataTextColumn Caption="Warehouse Name" FieldName="WarehouseName"
                                                VisibleIndex="0">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Available Quantity" FieldName="AvailableQty" Visible="false"
                                                VisibleIndex="1">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Quantity" FieldName="SalesQuantity"
                                                VisibleIndex="2">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Conversion Foctor" FieldName="ConversionMultiplier" Visible="false"
                                                VisibleIndex="3">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Stock Quantity" FieldName="StkQuantity" Visible="false"
                                                VisibleIndex="4">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Balance Stock" FieldName="BalancrStk" Visible="false"
                                                VisibleIndex="5">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Batch Number" FieldName="BatchNo"
                                                VisibleIndex="6">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Mfg Date" FieldName="MfgDate"
                                                VisibleIndex="7">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Expiry Date" FieldName="ExpiryDate"
                                                VisibleIndex="8">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Caption="Serial Number" FieldName="SerialNo"
                                                VisibleIndex="9">
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="10" Width="80px">
                                                <DataItemTemplate>
                                                    <a href="javascript:void(0);" onclick="fn_Edit('<%# Container.KeyValue %>')" title="Delete">
                                                        <img src="../../../assests/images/Edit.png" /></a>

                                                    <a href="javascript:void(0);" onclick="fn_Deletecity('<%# Container.KeyValue %>')" title="Delete">
                                                        <img src="/assests/images/crs.png" /></a>
                                                </DataItemTemplate>
                                            </dxe:GridViewDataTextColumn>
                                        </Columns>
                                        <ClientSideEvents EndCallback="OnWarehouseEndCallback" />
                                        <SettingsPager Visible="false"></SettingsPager>
                                        <SettingsLoadingPanel Text="Please Wait..." />
                                    </dxe:ASPxGridView>
                                </div>
                                <div class="clearfix">
                                    <br />
                                    <div style="align-content: center">
                                        <dxe:ASPxButton ID="btnWarehouseSave" ClientInstanceName="cbtnWarehouseSave" Width="50px" runat="server" AutoPostBack="False" Text="OK" CssClass="btn btn-primary">
                                            <ClientSideEvents Click="function(s, e) {FinalWarehouse();}" />
                                        </dxe:ASPxButton>
                                    </div>
                                </div>
                            </div>
                        </dxe:PopupControlContentControl>
                    </ContentCollection>
                    <HeaderStyle BackColor="LightGray" ForeColor="Black" />
                </dxe:ASPxPopupControl>
            </div>
            <div>
                <asp:HiddenField ID="HdUpdateMainGrid" runat="server" />
                <asp:HiddenField ID="hdfIsDelete" runat="server" />
                <asp:HiddenField ID="hdfLookupCustomer" runat="server" />
                <asp:HiddenField ID="hdfProductID" runat="server" />
                <asp:HiddenField ID="hdfProductType" runat="server" />
                <asp:HiddenField ID="hdfProductSerialID" runat="server" />
                <asp:HiddenField ID="hdnProductQuantity" runat="server" />
                <asp:HiddenField ID="hdnRefreshType" runat="server" />
                <asp:HiddenField ID="hdnPageStatus" runat="server" />
                <asp:HiddenField ID="hdnDeleteSrlNo" runat="server" />
                <asp:HiddenField ID="hdAddOrEdit" runat="server" />
                <%--Subhra--%>
                <asp:HiddenField ID="hdntab2" runat="server"></asp:HiddenField>
            </div>

            <dxe:ASPxCallbackPanel runat="server" ID="CallbackPanel" ClientInstanceName="cCallbackPanel" OnCallback="CallbackPanel_Callback">
                <PanelCollection>
                    <dxe:PanelContent runat="server">
                    </dxe:PanelContent>
                </PanelCollection>
                <ClientSideEvents EndCallback="CallbackPanelEndCall" />
            </dxe:ASPxCallbackPanel>

            <dxe:ASPxCallbackPanel runat="server" ID="acpAvailableStock" ClientInstanceName="cacpAvailableStock" OnCallback="acpAvailableStock_Callback">
                <PanelCollection>
                    <dxe:PanelContent runat="server">
                    </dxe:PanelContent>
                </PanelCollection>
                <ClientSideEvents EndCallback="acpAvailableStockEndCall" />
            </dxe:ASPxCallbackPanel>

            <%--End Sudip--%>

            <asp:HiddenField ID="hdnCustomerId" runat="server" />
            <asp:HiddenField ID="hdnAddressDtl" runat="server" />
            <%--Debu Section--%>

            <%--Batch Product Popup Start--%>

            <dxe:ASPxPopupControl ID="ProductpopUp" runat="server" ClientInstanceName="cProductpopUp"
                CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Height="400"
                Width="700" HeaderText="Select Product" AllowResize="true" ResizingMode="Postponed" Modal="true">
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                        <label><strong>Search By product Name</strong></label>
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
                SelectCommand="prc_PosSalesCRM_Details" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:Parameter Type="String" Name="Action" DefaultValue="ProductDetails" />
                </SelectParameters>
            </asp:SqlDataSource>

            <%--Batch Product Popup End--%>


            <%--InlineTax--%>

            <dxe:ASPxPopupControl ID="aspxTaxpopUp" runat="server" ClientInstanceName="caspxTaxpopUp"
                Width="850px" HeaderText="Select Tax" PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
                <HeaderTemplate>
                    <span style="color: #fff"><strong>Select Tax</strong></span>
                    <dxe:ASPxImage ID="ASPxImage31" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                        <ClientSideEvents Click="function(s, e){ 
                                                            cgridTax.CancelEdit();
                                                            caspxTaxpopUp.Hide();
                                                        }" />
                    </dxe:ASPxImage>
                </HeaderTemplate>
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                        <asp:HiddenField runat="server" ID="setCurrentProdCode" />
                        <asp:HiddenField runat="server" ID="HdSerialNo" />
                        <asp:HiddenField runat="server" ID="HdProdGrossAmt" />
                        <asp:HiddenField runat="server" ID="HdProdNetAmt" />
                        <div id="content-6">
                            <div class="col-sm-3">
                                <div class="lblHolder">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>Gross Amount
                                                    <dxe:ASPxLabel ID="ASPxLabel1" runat="server" Text="(Taxable)" ClientInstanceName="clblTaxableGross"></dxe:ASPxLabel>
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

                            <div class="col-sm-3 gstGrossAmount">
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
                                                    <dxe:ASPxLabel ID="ASPxLabel5" runat="server" Text="(Taxable)" ClientInstanceName="clblTaxableNet"></dxe:ASPxLabel>
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

                            <div class="col-sm-2 gstNetAmount">
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
                                                    <MaskSettings Mask="<0..999999999999>.<0..99>" AllowMouseWheel="false" />
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
                                    <table class="InlineTaxClass">
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
                                        <asp:Button ID="Button1" runat="server" Text="Ok" CssClass="btn btn-primary mTop" OnClientClick="return BatchUpdate();" Width="85px" />
                                        <asp:Button ID="Button2" runat="server" Text="Cancel" CssClass="btn btn-danger mTop" Width="85px" OnClientClick="cgridTax.CancelEdit(); caspxTaxpopUp.Hide(); return false;" />
                                        <span id="taxroundedOf"></span>
                                    </div>
                                    <table class="pull-right">
                                        <tr>
                                            <td style="padding-top: 10px; padding-right: 5px"><strong>Total Charges</strong></td>
                                            <td>
                                                <dxe:ASPxTextBox ID="txtTaxTotAmt" MaxLength="80" ClientInstanceName="ctxtTaxTotAmt" Text="0.00" ReadOnly="true"
                                                    runat="server" Width="100%" CssClass="pull-left mTop">
                                                    <MaskSettings Mask="<-999999999..999999999>.<0..99>" AllowMouseWheel="false" />
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
                </ContentCollection>
                <ContentStyle VerticalAlign="Top" CssClass="pad"></ContentStyle>
                <HeaderStyle BackColor="LightGray" ForeColor="Black" />
            </dxe:ASPxPopupControl>
            <%--End debjyoti 22-12-2016--%>
            <dxe:ASPxCallbackPanel runat="server" ID="taxUpdatePanel" ClientInstanceName="ctaxUpdatePanel" OnCallback="taxUpdatePanel_Callback">
                <PanelCollection>
                    <dxe:PanelContent runat="server">
                    </dxe:PanelContent>
                </PanelCollection>
                <ClientSideEvents EndCallback="ctaxUpdatePanelEndCall" />
            </dxe:ASPxCallbackPanel>

            <%--Debu Section End--%>
        </asp:Panel>
    </div>
    <div style="display: none">
        <dxe:ASPxDateEdit ID="dt_PlQuoteExpiry" runat="server" Date="" Width="100%" EditFormatString="dd-MM-yyyy" ClientInstanceName="tenddate">
            <ClientSideEvents DateChanged="Enddate" />
        </dxe:ASPxDateEdit>
    </div>
    <%--Compnent Tag Start--%>

    <dxe:ASPxPopupControl ID="ASPxProductsPopup" runat="server" ClientInstanceName="cProductsPopup"
        Width="900px" HeaderText="Select Tax" PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
        Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
        <HeaderTemplate>
            <strong><span style="color: #fff">Select Products</span></strong>

            <dxe:ASPxImage ID="closeAspxImg" runnat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                <ClientSideEvents Click="function(s, e){ 
                                                            cProductsPopup.Hide();
                                                        }" />

                <%-- <dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                <ClientSideEvents Click="function(s, e){ 
                                                            cProductsPopup.Hide();
                                                        }" />--%>
            </dxe:ASPxImage>
        </HeaderTemplate>
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
                <div style="padding: 7px 0;">
                    <input type="button" value="Select All Products" onclick="ChangeState('SelectAll')" class="btn btn-primary"></input>
                    <input type="button" value="De-select All Products" onclick="ChangeState('UnSelectAll')" class="btn btn-primary"></input>
                    <input type="button" value="Revert" onclick="ChangeState('Revart')" class="btn btn-primary"></input>
                </div>
                <dxe:ASPxGridView runat="server" KeyFieldName="ComponentDetailsID" ClientInstanceName="cgridproducts" ID="grid_Products"
                    Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" SettingsPager-Mode="ShowAllRecords" OnCustomCallback="cgridProducts_CustomCallback"
                    Settings-ShowFooter="false" AutoGenerateColumns="False" Settings-VerticalScrollableHeight="300" Settings-VerticalScrollBarMode="Visible">
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
                        <dxe:GridViewDataTextColumn Caption="Bal Quantity" FieldName="Quantity" Width="70" VisibleIndex="6">
                            <PropertiesTextEdit>
                                <MaskSettings Mask="<0..999999999999>.<0..99>" AllowMouseWheel="false" />
                            </PropertiesTextEdit>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="7" FieldName="ComponentID" ReadOnly="true" Caption="ComponentID" Width="0">
                        </dxe:GridViewDataTextColumn>
                    </Columns>
                    <SettingsDataSecurity AllowEdit="true" />
                </dxe:ASPxGridView>
                <div class="text-center">
                    <asp:Button ID="Button3" runat="server" Text="OK" CssClass="btn btn-primary  mLeft mTop" OnClientClick="return PerformCallToGridBind();" />
                </div>
            </dxe:PopupControlContentControl>
        </ContentCollection>
        <ContentStyle VerticalAlign="Top" CssClass="pad"></ContentStyle>
        <HeaderStyle BackColor="LightGray" ForeColor="Black" />
    </dxe:ASPxPopupControl>

    <%--Compnent Tag End--%>

    <%-- Customer Payment & Recipt --%>

    <dxe:ASPxPopupControl ID="apcReciptPopup" runat="server"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="capcReciptPopup" Height="630px"
        Width="1200px" HeaderText="Customer Receipt/Payment" Modal="true" AllowResize="true" ResizingMode="Postponed">
        <HeaderTemplate>
            <span>Customer Receipt/Payment</span>
        </HeaderTemplate>
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
            </dxe:PopupControlContentControl>
        </ContentCollection>
    </dxe:ASPxPopupControl>

    <%-- Customer Payment & Recipt --%>

    <asp:SqlDataSource runat="server" ID="dsCustomer" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="prc_POSCRMSalesInvoice_Details" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Type="String" Name="Action" DefaultValue="PopulateCustomerDetail" />
        </SelectParameters>
    </asp:SqlDataSource>

    <%-- Customer Payment & Recipt --%>

    <%-- UDF Module Start --%>
    <dxe:ASPxPopupControl ID="ASPXPopupControl2" runat="server"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popup" Height="630px"
        Width="600px" HeaderText="Add/Modify UDF" Modal="true" AllowResize="true" ResizingMode="Postponed">
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
            </dxe:PopupControlContentControl>
        </ContentCollection>
    </dxe:ASPxPopupControl>

    <%--Customer Popup--%>
    <dxe:ASPxPopupControl ID="DirectAddCustPopup" runat="server"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="AspxDirectAddCustPopup" Height="750px"
        Width="1020px" HeaderText="Add New Customer" Modal="true" AllowResize="true" ResizingMode="Postponed">
        <HeaderTemplate>
            <span>Add New Customer</span>
        </HeaderTemplate>
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
            </dxe:PopupControlContentControl>
        </ContentCollection>
    </dxe:ASPxPopupControl>


    <asp:HiddenField runat="server" ID="IsUdfpresent" />
    <asp:HiddenField runat="server" ID="Keyval_internalId" />
    <asp:HiddenField runat="server" ID="sessionBranch" />
    <asp:HiddenField runat="server" ID="HdPosType" />
    <asp:HiddenField runat="server" ID="HdViewmode" />
    <asp:HiddenField runat="server" ID="hdAddvanceReceiptNo" />
    <asp:HiddenField runat="server" ID="hdBasketId" />
    <asp:HiddenField runat="server" ID="HdDiscountAmount" />
    <asp:HiddenField runat="server" ID="isBasketContainComponent" />
    <%-- UDF Module End--%>

    <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
        <ClientSideEvents ControlsInitialized="AllControlInitilize" />
    </dxe:ASPxGlobalEvents>



    <dxe:ASPxPopupControl ID="OldUnitPopUpControl" runat="server" Width="1100"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="cOldUnitPopUpControl"
        HeaderText="Old Unit Details" AllowResize="false" ResizingMode="Postponed" Modal="true">
        <ContentCollection>

            <dxe:PopupControlContentControl runat="server">

                <dxe:ASPxCallbackPanel runat="server" ID="oldUnitUpdatePanel" ClientInstanceName="coldUnitUpdatePanel" OnCallback="oldUnitUpdatePanel_Callback">
                    <PanelCollection>
                        <dxe:PanelContent runat="server">
                            <div class="row">
                                <div class="col-md-3">
                                    <label style="margin-top: 0px !important">Select Old Unit</label>

                                    <dxe:ASPxGridLookup ID="oldUnitProductLookUp" runat="server" DataSourceID="oldUnitDataSource" ClientInstanceName="coldUnitProductLookUp"
                                        KeyFieldName="sProducts_ID" Width="100%" TextFormatString="{0}+{1}" MultiTextSeparator=", ">
                                        <Columns>

                                            <dxe:GridViewDataColumn FieldName="sProducts_Code" Caption="Name" Width="100">
                                                <Settings AutoFilterCondition="Contains" />
                                            </dxe:GridViewDataColumn>

                                            <dxe:GridViewDataColumn FieldName="sProducts_Name" Caption="Description" Width="180">
                                                <Settings AutoFilterCondition="Contains" />
                                            </dxe:GridViewDataColumn>

                                            <dxe:GridViewDataColumn FieldName="sProduct_IsInventory" Caption="Inventory" Width="50">
                                                <Settings AutoFilterCondition="Contains" />
                                            </dxe:GridViewDataColumn>
                                            <dxe:GridViewDataColumn FieldName="hsnCode" Caption="HSN/SAC" Width="80">
                                                <Settings AutoFilterCondition="Contains" />
                                            </dxe:GridViewDataColumn>
                                            <dxe:GridViewDataColumn FieldName="ProductClass_Code" Caption="Class" Width="200">
                                                <Settings AutoFilterCondition="Contains" />
                                            </dxe:GridViewDataColumn>
                                            <dxe:GridViewDataColumn FieldName="MRP" Caption="MRP" Width="0">
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
                                        <ClientSideEvents TextChanged="oldUnitProductTextChanged" />
                                    </dxe:ASPxGridLookup>
                                    <span id="mandetoryOldUnit" style="display: none; top: -18px; left: -95px;">
                                        <img id="mandetoryOldUnitimg" style="position: absolute; right: -2px; top: 24px;" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                    </span>
                                </div>
                                <div class="col-md-1">
                                    <label>UOM</label>
                                    <dxe:ASPxTextBox ID="txtOldUnitUom" runat="server" ClientInstanceName="ctxtOldUnitUom" Width="100%" ClientEnabled="False">
                                    </dxe:ASPxTextBox>
                                </div>
                                <div class="col-md-1">
                                    <label>Quantity</label>
                                    <dxe:ASPxTextBox ID="txtOldUnitqty" runat="server" ClientInstanceName="ctxtOldUnitqty" Width="100%">
                                        <MaskSettings Mask="<1..9999999>" AllowMouseWheel="false" />
                                    </dxe:ASPxTextBox>
                                </div>
                                <div class="col-md-2">
                                    <label>Value</label>
                                    <dxe:ASPxTextBox ID="txtoldUnitValue" runat="server" ClientInstanceName="ctxtoldUnitValue" Width="100%">
                                        <MaskSettings Mask="<0..9999999>.<0..99>" AllowMouseWheel="false" />
                                    </dxe:ASPxTextBox>
                                </div>





                                <div class="col-md-5 pdTop15">

                                    <dxe:ASPxButton ID="oldUnitGridAdd" runat="server" Text="Add" AutoPostBack="false" CssClass="btn btn-primary mTop16">
                                        <ClientSideEvents Click="oldUnitGridAddClick" />
                                    </dxe:ASPxButton>

                                    <dxe:ASPxButton ID="ASPxButton8" runat="server" Text="Clear" AutoPostBack="false" CssClass="btn btn-danger mTop16">
                                        <ClientSideEvents Click="oldUnitGridClearClick" />
                                    </dxe:ASPxButton>
                                </div>
                            </div>
                            <div class="clear"></div>


                            <asp:SqlDataSource runat="server" ID="oldUnitDataSource" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                                SelectCommand="prc_PosSalesInvoice" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Type="String" Name="action" DefaultValue="OldUnitProductDetails" />
                                </SelectParameters>
                            </asp:SqlDataSource>


                        </dxe:PanelContent>
                    </PanelCollection>
                </dxe:ASPxCallbackPanel>


                <div class="GridViewArea">
                    <dxe:ASPxGridView ID="OldUnitGrid" runat="server" AutoGenerateColumns="False" ClientInstanceName="cOldUnitGrid"
                        Width="100%" OnCustomCallback="OldUnitGrid_CustomCallback" CssClass="pull-left" KeyFieldName="oldUnit_id">
                        <Columns>

                            <dxe:GridViewDataTextColumn Caption="Product Details" FieldName="Product_Des" ReadOnly="True"
                                Visible="True" FixedStyle="Left" VisibleIndex="0">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="UOM" FieldName="oldUnit_Uom" ReadOnly="True"
                                Visible="True" FixedStyle="Left" VisibleIndex="0">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Quantity" FieldName="oldUnit_qty" ReadOnly="True"
                                Visible="True" FixedStyle="Left" VisibleIndex="0">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Value" FieldName="oldUnit_value" ReadOnly="True"
                                Visible="True" FixedStyle="Left" VisibleIndex="0">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataTextColumn>



                            <dxe:GridViewDataTextColumn ReadOnly="False" Width="12%" CellStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                <HeaderTemplate>
                                    Actions
                                </HeaderTemplate>
                                <DataItemTemplate>

                                    <a href="javascript:void(0);" onclick="fn_EditOldUnit('<%# Container.KeyValue %>')" title="Edit" class="pad">
                                        <img src="/assests/images/Edit.png" /></a>

                                    <a href="javascript:void(0);" onclick="fn_removeOldUnit('<%# Container.KeyValue %>')" title="Delete" class="pad">
                                        <img src="/assests/images/Delete.png" /></a>
                                   
                                </DataItemTemplate>
                            </dxe:GridViewDataTextColumn>
                        </Columns>
                        <ClientSideEvents EndCallback="OldUnitGridEndCallback"></ClientSideEvents>
                    </dxe:ASPxGridView>
                </div>
                <div class="clear"></div>
                <div style="padding-top: 5px;">
                    <dxe:ASPxButton ID="oldunitPopupSaveAndClickClick" ClientInstanceName="coldunitPopupSaveAndClickClick" runat="server" Text="Ok" AutoPostBack="false" CssClass="btn btn-primary mTop16">
                        <ClientSideEvents Click="oldunitPopupSaveAndEXitClick" />
                    </dxe:ASPxButton>
                </div>


            </dxe:PopupControlContentControl>
        </ContentCollection>
    </dxe:ASPxPopupControl>









    <dxe:ASPxPopupControl ID="popupCustomerRecipt" runat="server" Width="1100"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="cpopupCustomerRecipt"
        HeaderText="Customer Receipt / Return" AllowResize="false" ResizingMode="Postponed" Modal="true">
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">

                <dxe:ASPxGridView ID="aspxCustomerReceiptGridview" runat="server" AutoGenerateColumns="False" ClientInstanceName="caspxCustomerReceiptGridview"
                    Width="100%" OnCustomCallback="aspxCustomerReceiptGridview_CustomCallback" CssClass="pull-left" KeyFieldName="ReceiptPayment_ID"
                    SettingsPager-Mode="ShowAllRecords" OnDataBinding="aspxCustomerReceiptGridview_DataBinding">
                    <Columns>

                        <dxe:GridViewCommandColumn ShowSelectCheckbox="true" Width="50" Caption="Select" />

                        <dxe:GridViewDataTextColumn Caption="Type" FieldName="Vc_type" ReadOnly="True"
                            Visible="True" FixedStyle="Left" VisibleIndex="0">
                            <EditFormSettings Visible="True" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>


                        <dxe:GridViewDataTextColumn Caption="Customer Name" FieldName="CustomerName" ReadOnly="True"
                            Visible="True" FixedStyle="Left" VisibleIndex="0">
                            <EditFormSettings Visible="True" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="Voucher / Return Number" FieldName="ReceiptPayment_VoucherNumber" ReadOnly="True"
                            Visible="True" FixedStyle="Left" VisibleIndex="0">
                            <EditFormSettings Visible="True" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="Transaction Date" FieldName="ReceiptPayment_TransactionDate" ReadOnly="True"
                            Visible="True" FixedStyle="Left" VisibleIndex="0">
                            <EditFormSettings Visible="True" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>


                        <dxe:GridViewDataTextColumn Caption="Amount" FieldName="Curent_Available_Amount" ReadOnly="True"
                            Visible="True" FixedStyle="Left" VisibleIndex="0">
                            <HeaderStyle HorizontalAlign="Right" />
                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                            <EditFormSettings Visible="True" />
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>


                    </Columns>
                    <ClientSideEvents EndCallback="CustomerReceiptEndCallback"></ClientSideEvents>
                </dxe:ASPxGridView>
                <div id="customerReceiptButtonSet">
                    <input type="button" value="Select All" onclick="SelectAllCustomerReceipt()" style="margin-top: 10px;" class="btn  btn-primary" />
                    <input type="button" value="Un-Select All" onclick="UnSelectAllCustomerReceipt()" style="margin-top: 10px;" class="btn  btn-primary" />
                    <input type="button" value="Revert" onclick="RevertCustomerReceipt()" style="margin-top: 10px;" class="btn  btn-primary" />

                    <input type="button" value="Save & Exit" onclick="CustomerReceiptSaveandExitClick()" style="margin-top: 10px;" class="btn btn-success" />
                </div>

            </dxe:PopupControlContentControl>
        </ContentCollection>
    </dxe:ASPxPopupControl>



      <dxe:ASPxPopupControl ID="ShowAvailableStock" runat="server" Width="1000"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="cShowAvailableStock" Height="500"
        HeaderText="Show Available Stock" AllowResize="false" ResizingMode="Postponed">
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server"> 

                <dxe:ASPxGridView ID="AvailableStockgrid" runat="server" KeyFieldName="branch_id" AutoGenerateColumns="False"
                    Width="100%" ClientInstanceName="cAvailableStockgrid" OnCustomCallback="AvailableStockgrid_CustomCallback" KeyboardSupport="true"
                    SettingsBehavior-AllowSelectSingleRowOnly="true" OnDataBinding="AvailableStockgrid_DataBinding" SettingsBehavior-AllowFocusedRow="true"
                    OnHtmlRowPrepared="AvailableStockgrid_HtmlRowPrepared">
                    <Columns>


                        <dxe:GridViewDataTextColumn Caption="Branch Code" FieldName="branch_code"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="Name" FieldName="branch_description"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="Opening" FieldName="IN_QTY_OP"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="In Quantity" FieldName="IN_QTY"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="Out Quantity" FieldName="OUT_QTY"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                         <dxe:GridViewDataTextColumn Caption="Display" FieldName="DisplayCount"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                              <dxe:GridViewDataTextColumn Caption="Dent" FieldName="dentCount"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                          <%--    <dxe:GridViewDataTextColumn Caption="Stolen" FieldName="stolenCount"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>--%>


                        <dxe:GridViewDataTextColumn Caption="Available Quantity" FieldName="Available"
                            VisibleIndex="0" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                    </Columns>
                     


                    <SettingsSearchPanel Visible="True" />
                    <Settings ShowGroupPanel="False" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsLoadingPanel Text="Please Wait..." />



                       <SettingsPager PageSize="15">
                        <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                    </SettingsPager>
                </dxe:ASPxGridView>




            </dxe:PopupControlContentControl>
        </ContentCollection>
    </dxe:ASPxPopupControl>
     <asp:HiddenField runat="server" ID="HDSelectedProduct" />


     <dxe:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" ContainerElementID="divSubmitButton"
        Modal="True">
    </dxe:ASPxLoadingPanel>



     <asp:HiddenField runat="server" ID="uniqueId" />




    <asp:HiddenField runat="server" ID="HDItemLevelTaxDetails" />
    <asp:HiddenField runat="server" ID="HDHSNCodewisetaxSchemid" />
    <asp:HiddenField runat="server" ID="HDBranchWiseStateTax" />
    <asp:HiddenField runat="server" ID="HDStateCodeWiseStateIDTax" />

    <asp:HiddenField runat="server" ID="hdHsnList" />

</asp:Content>
