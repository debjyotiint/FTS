<%@ Page Title="Cash/Bank Voucher" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" EnableEventValidation="false" AutoEventWireup="true" Inherits="ERP.OMS.Management.DailyTask.management_DailyTask_CashBankEntry" CodeBehind="CashBankEntry.aspx.cs" %>

<%@ Register Src="~/OMS/Management/Activities/UserControls/BillingShippingControl.ascx" TagPrefix="ucBS" TagName="BillingShippingControl" %>
<%--<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="/assests/pluggins/choosen/choosen.min.js"></script>
    <style type="text/css">
        #gridBatch_DXEmptyRow {
            display: none;
        }

        .dxtcSys.dxtc-init > .dxtc-content {
            border-color: #CCCCCC !important;
        }

        .iconInstrumentType {
            position: absolute;
            right: -1px;
            top: 27px;
        }

        .iconInstNo {
            position: absolute;
            right: -1px;
            top: 27px;
        }

        .iconNumberScheme {
            position: absolute;
            right: 3px;
            top: 44px;
        }

        .voucherno {
            position: absolute;
            right: -2px;
            top: 36px;
        }

        .iconBranch {
            position: absolute;
            right: 1px;
            top: 36px;
        }

        .iconCashBank {
            position: absolute;
            right: -1px;
            top: 27px;
        }

        #gridBatch_DXFooterRow, #gridBatch_DXStatus, #aspxGridTax_DXStatus {
            display: none;
        }

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

        /*#GvCBSearch_DXMainTable .dxgv {
            display: table-cell !important;
        }

        #GvCBSearch_DXFilterRow .dxgv {
            display: table-cell !important;
        }*/
        /* Big box with list of options */
        #ajax_listOfOptions {
            position: absolute; /* Never change this one */
            width: 50px; /* Width of box */
            height: auto; /* Height of box */
            overflow: auto; /* Scrolling features */
            border: 1px solid Blue; /* Blue border */
            background-color: #FFF; /* White background color */
            text-align: left;
            font-size: 0.9em;
            z-index: 32761;
        }

            #ajax_listOfOptions div { /* General rule for both .optionDiv and .optionDivSelected */
                margin: 1px;
                padding: 1px;
                cursor: pointer;
                font-size: 0.9em;
            }

            #ajax_listOfOptions .optionDiv { /* Div for each item in list */
            }

            #ajax_listOfOptions .optionDivSelected { /* Selected item in the list */
                background-color: #DDECFE;
                color: Blue;
            }

        #ajax_listOfOptions_iframe {
            background-color: #F00;
            position: absolute;
            z-index: 3000;
        }

        form {
            display: inline;
        }

        #txtIssuingBank {
            z-index: 10000;
        }

        .bubblewrap {
            list-style-type: none;
            margin: 0;
            padding: 0;
        }

            .bubblewrap li {
                display: inline;
                width: 65px;
                height: 60px;
            }

                .bubblewrap li img {
                    width: 30px; /* width of each image.*/
                    height: 35px; /* height of each image.*/
                    border: 0;
                    margin-right: 12px; /*spacing between each image*/
                    -webkit-transition: -webkit-transform 0.1s ease-in; /*animate transform property */
                    -o-transition: -o-transform 0.1s ease-in; /*animate transform property in Opera */
                }

                    .bubblewrap li img:hover {
                        -moz-transform: scale(1.8); /*scale up image 1.8x*/
                        -webkit-transform: scale(1.8);
                        -o-transform: scale(1.8);
                    }


        .chosen-container.chosen-container-single {
            width: 100% !important;
        }

        .chosen-choices {
            width: 100% !important;
        }

        #lstIssueBankItems {
            width: 200px;
        }

        #lstIssueBankItems_chosen {
            width: 200px !important;
        }


        #lstWithFromItems {
            width: 200px;
        }

        #lstWithFromItems_chosen {
            width: 200px !important;
        }

        #lstDepositIntoItems {
            width: 200px;
        }

        #lstDepositIntoItems_chosen {
            width: 200px !important;
        }

        #gridBatch_DXEditingErrorRow-1 {
            display: none;
        }

        #txtRecieve_ET td {
            padding-left: 0 !important;
            padding-right: 0 !important;
        }

        .expad {
            height: 32px;
        }

        .cngtbl {
            border: 1px solid #525252;
            margin-bottom: 15px;
        }

            .cngtbl th {
                background: #656565;
                color: #fff !important;
                border: 1px solid #525252;
                padding: 6px 10px;
            }

            .cngtbl td {
                padding: 6px 10px;
            }

        .gridfooter {
            text-align: right;
        }

        .dxbButton_PlasticBlue div.dxb {
            padding: 0 !important;
        }

        #tblDetailE .dxgvControl_PlasticBlue a {
            color: #fff !important;
        }

        .mRight2 {
            margin-right: 2%;
        }

        .dxeErrorFrameSys.dxeErrorCellSys {
            position: absolute;
        }

        #DivBilling [class^="col-md"], #DivShipping [class^="col-md"] {
            padding-top: 5px;
            padding-bottom: 5px;
        }

        .dxtcSys.dxtc-init > .dxtc-stripContainer {
            visibility: visible;
        }

        #ASPxPageControl1_TC, #gridBatch, #gridBatch .dxgvHSDC > div, .dxgvCSD {
            width: 100% !important;
            max-width: 100% !important;
        }
    </style>

     <script language="javascript" type="text/javascript">
         var globalRowIndex;
         var shouldCheck = 0;
         function MainAccountClose(s, e) {
             cMainAccountpopUp.Hide();
             InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 2);

         }
         function SubAccountClose(s, e) {
             cSubAccountpopUp.Hide();
             InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 3);

         }
         function MainAccountKeyDown(s, e) {
             if (e.htmlEvent.key == "Enter") {
                 shouldCheck = 0;
                 s.OnButtonClick(0);
             }
             //if (e.htmlEvent.key == "Tab") {

             //    s.OnButtonClick(0);
             //}
         }
         function SubAccountKeyDown(s, e) {
             if (e.htmlEvent.key == "Enter") {
                 s.OnButtonClick(0);
             }
             // if (e.htmlEvent.key == "Tab") {

             //   s.OnButtonClick(0);
             //}
         }

         function MainAccountComboBoxKeyDown(s, e) {
             if (e.htmlEvent.key == "Escape") {
                 cMainAccountpopUp.Hide();
                 InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 3);
             }
             //if (e.htmlEvent.key == "Enter") {
             //    var MainAccountText = cMainAccountComboBox.GetText();                
             //    if (MainAccountText != "") {
             //        if (!cMainAccountComboBox.FindItemByText(MainAccountText)) {
             //            jAlert("Main Account does not Exist.");
             //            cMainAccountComboBox.SetText("");
             //            shouldCheck = 0;
             //            return;
             //        }
             //    }               

             //}
         }
         function SubAccountComboBoxKeyDown(s, e) {
             if (e.htmlEvent.key == "Escape") {
                 cSubAccountpopUp.Hide();
                 InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 4);
             }
             if (e.htmlEvent.key == "Enter") {
                 GetSubAcountComboBox(e);
             }
         }
         function GetMainAcountComboBox(e) {
             var MainAccountText = cMainAccountComboBox.GetText();

             if (shouldCheck != 1) {
                 return;
             }
             if (!cMainAccountComboBox.FindItemByText(MainAccountText)) {
                 //jAlert("Main Account does not Exist.");
                 //shouldCheck = 0;   
                 $('#mainActMsg').show();
                 shouldCheck = 1;
                 return;
             }
             else {
                 if (e.keyCode == 27)//escape 
                 {
                     InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 2);
                     return;
                 }
                 cMainAccountpopUp.Hide();
                 var MainAccountID = cMainAccountComboBox.GetValue();
                 var ReverseApplicable = cMainAccountComboBox.GetSelectedItem().texts[2];
                 var TaxApplicable = cMainAccountComboBox.GetSelectedItem().texts[3];
                 // InsgridBatch.batchEditApi.StartEdit(globalRowIndex);
                 InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 3);
                 InsgridBatch.GetEditor("MainAccount").SetText(MainAccountText);
                 InsgridBatch.GetEditor("gvColMainAccount").SetText(MainAccountID);
                 InsgridBatch.GetEditor("ReverseApplicable").SetValue(ReverseApplicable);
                 shouldCheck = 0;
                 InsgridBatch.GetEditor("bthSubAccount").SetValue("");
                 InsgridBatch.GetEditor("btnRecieve").SetValue("");
                 InsgridBatch.GetEditor("btnPayment").SetValue("");
                 InsgridBatch.GetEditor("TaxAmount").SetValue("0.00");
                 InsgridBatch.GetEditor("NetAmount").SetValue("0.00");
                 InsgridBatch.GetEditor("gvColSubAccount").SetValue("");
                 cddl_AmountAre.SetEnabled(false);
                 $("#rbtnType").attr("disabled", "disabled");
                 $("#IsTaxApplicable").val(TaxApplicable);
                 var VoucherType = document.getElementById('rbtnType').value;
                 if (ReverseApplicable == "1" && VoucherType == "P") {
                     $("#chk_reversemechenism").prop("disabled", false);
                     $("#chk_reversemechenism").prop("checked", true);
                 }
                 else {
                     if ($("#chk_reversemechenism").prop('checked') == false) {
                         $("#chk_reversemechenism").prop("checked", false);
                     }
                 }
             }


         }
         function GetSubAcountComboBox(e) {
             var SubAcountText = cSubAcountComboBox.GetText();
             //if (cSubAcountComboBox.GetText() != "") {
             //if (!cSubAcountComboBox.FindItemByValue(cSubAcountComboBox.GetValue())) {
             if (!cSubAcountComboBox.FindItemByText(SubAcountText)) {
                 //jAlert("Sub Account does not Exist.", "Alert", function () { cSubAcountComboBox.SetValue(); cSubAcountComboBox.Focus(); });
                 $('#subActMsg').show();
                 return;
             }
             else {
                 if (e.keyCode == 27)//escape 
                 {
                     InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 3);
                     return;
                 }
                 var subAccountText = cSubAcountComboBox.GetText();
                 var subAccountID = cSubAcountComboBox.GetValue();
                 //  InsgridBatch.batchEditApi.StartEdit(globalRowIndex);
                 var VoucherType = document.getElementById('rbtnType').value;
                 if (VoucherType == "P") {
                     InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 5);
                 }
                 else {
                     InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 4);
                 }

                 InsgridBatch.GetEditor("bthSubAccount").SetText(subAccountText);
                 InsgridBatch.GetEditor("gvColSubAccount").SetText(subAccountID);
                 cSubAccountpopUp.Hide();
             }

             // }
         }
         function SubAccountButnClick(s, e) {
             InsgridBatch.batchEditApi.StartEdit(e.visibleIndex);
             var strMainAccountID = (InsgridBatch.GetEditor('MainAccount').GetText() != null) ? InsgridBatch.GetEditor('MainAccount').GetText() : "0";
             var MainAccountID = (InsgridBatch.GetEditor('gvColMainAccount').GetValue() != null) ? InsgridBatch.GetEditor('gvColMainAccount').GetValue() : "0";
             if (e.buttonIndex == 0) {
                 $('#subActMsg').hide();
                 if (strMainAccountID.trim() != "") {
                     document.getElementById('hdnMainAccountId').value = MainAccountID;
                     var FullName = new Array("", "");
                     cSubAcountComboBox.AddItem(FullName, "");
                     cSubAcountComboBox.SetValue("");
                     cSubAccountpopUp.Show();
                     cSubAcountComboBox.Focus();
                 }
             }
         }

         function MainAccountButnClick(s, e) {
             if (e.buttonIndex == 0) {
                 $('#mainActMsg').hide();
                 var FullName = new Array("", "");
                 shouldCheck = 1;
                 cMainAccountComboBox.AddItem(FullName, "");
                 cMainAccountComboBox.SetText("");
                 cMainAccountpopUp.Show();
                 cMainAccountComboBox.Focus();

             }
         }
         //function MainAccountSelected(s, e) {

         //    var LookUpData = cMainAccountLookUp.GetGridView().GetRowKey(cMainAccountLookUp.GetGridView().GetFocusedRowIndex());
         //    var MainAccountCode = cMainAccountLookUp.GetValue();
         //    if (!MainAccountCode) {
         //        LookUpData = null;
         //    }
         //    cMainAccountpopUp.Hide();
         //    InsgridBatch.batchEditApi.StartEdit(globalRowIndex);
         //    InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 5);
         //    InsgridBatch.GetEditor("MainAccount").SetText(MainAccountCode);
         //    InsgridBatch.GetEditor("gvColMainAccount").SetText(LookUpData);

         //}
           </script>
    <script language="javascript" type="text/javascript">



        var chkAccount = 0;
        var ReciptOldValue;
        var ReciptNewValue;
        var PaymentOldValue;
        var PaymentNewValue;

        var GlobargotRecpt = null;
        var GlobargotPayMent = null;
        var oldBranchdata;
        var globalNetAmount = 0;
        var isCtrl = false;
        var SrlNo = 0;

        var NetAmountOldValue;
        var NetAmountNewValue;

        //------------------------------------------------Tax-------------------------------------
        var taxJson;
        var ChargegstcstvatGlobalName;
        var taxAmountGlobal;
        var globalTaxRowIndex;
        var gstcstvatGlobalName;
        var GlobalCurTaxAmt = 0;


        function GlobalBillingShippingEndCallBack() {
            var NoSchemeTypedtl = cCmbScheme.GetValue();
            if (NoSchemeTypedtl != null && NoSchemeTypedtl != '') {
                var branchID = (NoSchemeTypedtl.toString().split('~')[3] != null) ? NoSchemeTypedtl.toString().split('~')[3] : "";
            }
        }  /// this emplty function required for billing/Shipping

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
            ctxtTaxTotAmt.SetValue(totalInlineTaxAmount, 2);
        }
        function taxAmountLostFocus(s, e) {
            var finalTaxAmt = parseFloat(s.GetValue());
            var totAmt = parseFloat(ctxtTaxTotAmt.GetText());
            var totLength = cgridTax.GetEditor("Taxes_Name").GetText().length;
            var sign = cgridTax.GetEditor("Taxes_Name").GetText().substring(totLength - 3);
            if (sign == '(+)') {
                ctxtTaxTotAmt.SetValue(((totAmt + finalTaxAmt - taxAmountGlobal), 2));
            } else {
                ctxtTaxTotAmt.SetValue(((totAmt + (finalTaxAmt * -1) - (taxAmountGlobal * -1)), 2));
            }
            SetOtherTaxValueOnRespectiveRow(0, cgridTax.GetEditor("Amount").GetValue(), cgridTax.GetEditor("Taxes_Name").GetText().replace('(+)', '').replace('(-)', ''));
            //Set Running Total
            SetRunningTotal();
            RecalCulateTaxTotalAmountInline();
        }
        function txtPercentageLostFocus(s, e) {

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
                        ctxtTaxTotAmt.SetValue((parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt), 2);
                        GlobalCurTaxAmt = 0;
                    }
                    else {

                        GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                        cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * s.GetText()) / 100) * -1);
                        ctxtTaxTotAmt.SetValue((parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) * -1) - (GlobalCurTaxAmt * -1), 2));
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
        function CmbtaxClick(s, e) {
            GlobalCurTaxAmt = parseFloat(ctxtGstCstVat.GetText());
            gstcstvatGlobalName = s.GetText();
        }
        function GetTaxVisibleIndex(s, e) {
            globalTaxRowIndex = e.visibleIndex;
        }
        function taxAmountGotFocus(s, e) {
            taxAmountGlobal = parseFloat(s.GetValue());
        }
        function chargeCmbtaxClick(s, e) {
            GlobalCurChargeTaxAmt = parseFloat(ctxtGstCstVatCharge.GetText());
            ChargegstcstvatGlobalName = s.GetText();
        }
        function ShowTaxPopUp(type) {
            if (type == "IY") {
                $('#ContentErrorMsg').hide();
                $('#content-6').show();
                document.getElementById('calculateTotalAmountOK').style.display = 'block';
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
                    document.getElementById('calculateTotalAmountOK').style.display = 'none';

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
        function cgridTax_EndCallBack(s, e) {
            $("#TaxAmountOngrid").val("");
            $("#VisibleIndexForTax").val("");


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
                ctxtTaxTotAmt.SetValue(cgridTax.cpUpdated.split('~')[1]);
                var gridValue = parseFloat(cgridTax.cpUpdated.split('~')[1]);
                var ddValue = parseFloat(ctxtGstCstVat.GetValue());
                ctxtTaxTotAmt.SetValue(gridValue + ddValue);
                cgridTax.cpUpdated = "";
                RecalCulateTaxTotalAmountInline();
            }
            else {
                var totAmt = ctxtTaxTotAmt.GetValue();
                caspxTaxpopUp.Hide();
                cgridTax.CancelEdit();
            }
            if (cgridTax.GetVisibleRowsOnPage() == 0) {
                $('.cgridTaxClass').hide();
                ccmbGstCstVat.Focus();
            }
            //Debjyoti Check where any Gst Present or not
            // If Not then hide the hole section
            SetRunningTotal();
            ShowTaxPopUp("IY");
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

                        ctxtTaxTotAmt.SetValue(Math.round((parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(cgridTax.GetEditor("TaxField").GetValue())) / 100) - GlobalCurTaxAmt), 2));
                        GlobalCurTaxAmt = 0;
                    }
                    else {

                        GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                        cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * cgridTax.GetEditor("TaxField").GetValue()) / 100) * -1);

                        ctxtTaxTotAmt.SetValue(Math.round((parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(cgridTax.GetEditor("TaxField").GetValue())) / 100) * -1) - (GlobalCurTaxAmt * -1)), 2));
                        GlobalCurTaxAmt = 0;
                    }
                    SetOtherTaxValueOnRespectiveRow(0, cgridTax.GetEditor("Amount").GetValue(), cgridTax.GetEditor("Taxes_Name").GetText().replace('(+)', '').replace('(-)', ''));
                }
                runningTot = runningTot + parseFloat(cgridTax.GetEditor("Amount").GetValue());
                cgridTax.batchEditApi.EndEdit();
            }
        }
        function recalculateTax() {
            cmbGstCstVatChange(ccmbGstCstVat);
        }
        function recalculateTaxCharge() {
            ChargecmbGstCstVatChange(ccmbGstCstVatcharge);
        }
        function chargeCmbtaxClick(s, e) {
            GlobalCurChargeTaxAmt = parseFloat(ctxtGstCstVatCharge.GetText());
            ChargegstcstvatGlobalName = s.GetText();
        }
        function showTax() {
            //var strMainAccountID = (InsgridBatch.GetEditor('MainAccount').GetText() != null) ? InsgridBatch.GetEditor('MainAccount').GetText() : "0";
            //var MainAccountID = (InsgridBatch.GetEditor('MainAccount').GetValue() != null) ? InsgridBatch.GetEditor('MainAccount').GetValue() : "0";
            var strMainAccountID = (InsgridBatch.GetEditor('MainAccount').GetText() != null) ? InsgridBatch.GetEditor('MainAccount').GetText() : "0";
            var MainAccountID = (InsgridBatch.GetEditor('gvColMainAccount').GetValue() != null) ? InsgridBatch.GetEditor('gvColMainAccount').GetValue() : "0";
            var StrAmount = "0";

            var VoucherType = document.getElementById('rbtnType').value;

            //if (cComboType.GetValue() == "R") {
            if (VoucherType == "R") {
                var ReceiptValue = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('btnRecieve').GetValue()) : "0";
                StrAmount = ReceiptValue;
            }
            else {
                var PaymentValue = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "0";
                StrAmount = PaymentValue;
            }
            if (strMainAccountID.trim() != "") {
                globalNetAmount = parseFloat(StrAmount);
                document.getElementById('setCurrentProdCode').value = MainAccountID;
                document.getElementById('HdSerialNo').value = SrlNo + 1;
                var strSrlNo = SrlNo + 1;
                SrlNo = strSrlNo;
                ctxtTaxTotAmt.SetValue(0);
                ccmbGstCstVat.SetSelectedIndex(0);
                $('.RecalculateInline').hide();
                caspxTaxpopUp.Show();
                //  var Amount = Math.round(QuantityValue * strFactor * (strSalePrice / strRate)).toFixed(2);
                var Amount = (Math.round(StrAmount * 100) / 100).toFixed(2);
                clblTaxProdGrossAmt.SetText(Amount);
                clblProdNetAmt.SetText(Amount);
                document.getElementById('HdProdGrossAmt').value = Amount;
                document.getElementById('HdProdNetAmt').value = Amount;
                clblTaxDiscount.SetText('0.00');
                //Checking is gstcstvat will be hidden or not
                if (cddl_AmountAre.GetValue() == "2") {
                    $('.GstCstvatClass').hide();
                    $('.gstGrossAmount').show();
                    clblTaxableGross.SetText("(Taxable)");
                    clblTaxableNet.SetText("(Taxable)");
                    $('.gstNetAmount').show();

                    $('.gstGrossAmount').hide();
                    $('.gstNetAmount').hide();
                    clblTaxableGross.SetText("");
                    clblTaxableNet.SetText("");
                    //}
                }
                else if (cddl_AmountAre.GetValue() == "1") {
                    $('.GstCstvatClass').show();
                    $('.gstGrossAmount').hide();
                    $('.gstNetAmount').hide();
                    clblTaxableGross.SetText("");
                    clblTaxableNet.SetText("");
                    //Get Customer Shipping StateCode
                    var shippingStCode = '';
                    shippingStCode = cbsSCmbState.GetText();
                    shippingStCode = shippingStCode.substring(shippingStCode.lastIndexOf('(')).replace('(State Code:', '').replace(')', '').trim();
                    //Debjyoti 09032017
                    if (shippingStCode.trim() != '') {
                        for (var cmbCount = 1; cmbCount < ccmbGstCstVat.GetItemCount() ; cmbCount++) {
                            //Check if gstin is blank then delete all tax
                            if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[5] != "") {
                                if (ccmbGstCstVat.GetItem(cmbCount).value.split('~')[5] == shippingStCode) {
                                    //if its state is union territories then only UTGST will apply
                                    if (shippingStCode == "4" || shippingStCode == "35" || shippingStCode == "26" || shippingStCode == "25" || shippingStCode == "7" || shippingStCode == "31" || shippingStCode == "34") {
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
                    cgridTax.PerformCallback('New~' + cddl_AmountAre.GetValue());
                }
                else {
                    cgridTax.PerformCallback('New~' + cddl_AmountAre.GetValue());
                    //Set default combo
                    // cgridTax.cpComboCode = grid.GetEditor('ProductID').GetValue().split('||@||')[9];
                }
                ctxtprodBasicAmt.SetValue(Amount);
            } else {

            }
        }
        function calculateTotalAmount() {

            var TaxAmount = ctxtTaxTotAmt.GetValue();
            var Receipt = InsgridBatch.GetEditor("btnRecieve").GetValue();
            var payment = InsgridBatch.GetEditor("btnPayment").GetValue();

            if (cddl_AmountAre.GetValue() == "1") { /// Exclusive Tax Calculation
                if (Receipt != "0.0" && Receipt != "0.00") {
                    var TotalReceipt = parseFloat(TaxAmount) + parseFloat(Receipt);
                    InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 7);
                    var cashBankGridTaxAmount = InsgridBatch.GetEditor("TaxAmount");
                    cashBankGridTaxAmount.SetValue(TaxAmount);
                    var cashBankGrid = InsgridBatch.GetEditor("NetAmount");
                    cashBankGrid.SetValue(TotalReceipt.toFixed(2));
                    var CuurentNetAmount = InsgridBatch.GetEditor("NetAmount").GetValue();
                    c_txtTotalNetAmount.SetValue(CuurentNetAmount + TotalReceipt.toFixed(2));
                }
                if (payment != "0.0" && payment != "0.00") {
                    var TotalPayment = parseFloat(TaxAmount) + parseFloat(payment);
                    InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 7);
                    var cashBankGridTaxAmount = InsgridBatch.GetEditor("TaxAmount");
                    cashBankGridTaxAmount.SetValue(TaxAmount);
                    var cashBankGridNetAmount = InsgridBatch.GetEditor("NetAmount");
                    cashBankGridNetAmount.SetValue(TotalPayment.toFixed(2));
                    var CuurentNetAmount = InsgridBatch.GetEditor("NetAmount").GetValue();
                    c_txtTotalNetAmount.SetValue(CuurentNetAmount + TotalPayment.toFixed(2));
                }
            }
            else if (cddl_AmountAre.GetValue() == "2") {  /// Inclusive Calculation
                InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 7);
                var cashBankGridTaxAmount = InsgridBatch.GetEditor("TaxAmount");
                cashBankGridTaxAmount.SetValue(TaxAmount);
            }
            document.getElementById('HdSerialNo').val = InsgridBatch;
            if (cgridTax.GetVisibleRowsOnPage() > 0) {
                document.getElementById('HdSerialNo1').value = InsgridBatch.GetEditor('SrlNo').GetText();
                cgridTax.UpdateEdit();
            }
            else {
                cgridTax.PerformCallback('SaveGst');
            }
            LoadingPanel.Hide();
            return false;
        }
        //....................................................End Tax........................................

        function CashBank_GotFocus() {
            cddlCashBank.ShowDropDown();
        }
        function CashBank_SelectedIndexChanged() {
            //var VoucherType = cComboType.GetValue();
            var VoucherType = document.getElementById('rbtnType').value;
            //if (VoucherType == "P") {
            //    LoadCustomerAddress('', $('#ddlBranch').val(), 'PO');
            //}
            LoadCustomerAddress('', $('#ddlBranch').val(), 'PO');
            var CashBankId = cddlCashBank.GetValue();

            var CashBankText = cddlCashBank.GetText();
            var arr = CashBankText.split('|');
            var strbranch = $('#<%=hdnBranchId.ClientID %>').val();
            PopulateCurrentBankBalance(arr[0], strbranch);
            $('#MandatoryCashBank').hide();
            var CashBankText = cddlCashBank.GetText();
            var SpliteDetails = CashBankText.split(']');
            var WithDrawType = SpliteDetails[1].trim();
            if (WithDrawType == "Cash") {
                var comboitem = cComboInstrumentTypee.FindItemByValue('C');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('D');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('E');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);

                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('CH');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("Cash", "CH");
                }
                cComboInstrumentTypee.SetValue("CH");
                InstrumentTypeSelectedIndexChanged();
            }
            else {
                var comboitem = cComboInstrumentTypee.FindItemByValue('C');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("Cheque", "C");
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('D');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("Draft", "D");
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('E');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("E.Transfer", "E");
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('CH');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);
                    cComboInstrumentTypee.SetValue("C");
                    InstrumentTypeSelectedIndexChanged();
                }
            }
        }
        function CashBank_EndCallback() {

            var CashBankId = $('#<%=hdnCashBankId.ClientID %>').val();
            cddlCashBank.SetValue(CashBankId);
            var CashBankText = cddlCashBank.GetText();
            var arr = CashBankText.split('|');
            var strbranch = $('#<%=hdnBranchId.ClientID %>').val();
            PopulateCurrentBankBalance(arr[0], strbranch);
        }
        function VoucherType_GotFocus() {
            cComboType.ShowDropDown();
        }
        function NumberingScheme_GotFocus() {
            cCmbScheme.ShowDropDown();
        }
        function ReloadPage() {
            //sessionStorage.removeItem('CashBankDetails');
            $('#<%=hdnEditRfid.ClientID %>').val('');
            window.location.assign("CashBankEntryList.aspx");
            // cacpCrossBtn.PerformCallback();
        }
        function acpCrossBtnEndCall() {
            window.location.reload();
        }
        var isFirstTime = true;
        function AllControlInitilize() {
            // document.getElementById('AddButton').style.display = 'inline-block';
            if (isFirstTime) {
                $("#TaxAmountOngrid").val("");
                $("#VisibleIndexForTax").val("");
                if ($('#hdn_Mode').val() != "Edit") {
                    //document.getElementById('rbtnType').value = 'P';
                    AddButtonClick();
                }

                //OnAddNewClick();
                //if (localStorage.getItem('FromDateCashBank')) {
                //    var fromdatearray = localStorage.getItem('FromDateCashBank').split('-');
                //    var fromdate = new Date(fromdatearray[0], parseFloat(fromdatearray[1]) - 1, fromdatearray[2], 0, 0, 0, 0);
                //    cFormDate.SetDate(fromdate);
                //}

                //if (localStorage.getItem('ToDateCashBank')) {
                //    var todatearray = localStorage.getItem('ToDateCashBank').split('-');
                //    var todate = new Date(todatearray[0], parseFloat(todatearray[1]) - 1, todatearray[2], 0, 0, 0, 0);
                //    ctoDate.SetDate(todate);
                //}
                //if (localStorage.getItem('BranchCashBank')) {
                //    if (ccmbBranchfilter.FindItemByValue(localStorage.getItem('BranchCashBank'))) {
                //        ccmbBranchfilter.SetValue(localStorage.getItem('BranchCashBank'));
                //    }

                //}


                isFirstTime = false;
            }
        }

        function EnableOrDisableTax() {
            if (cddl_AmountAre.GetValue() == '3') {
                var TaxAmt = InsgridBatch.GetEditor('TaxAmount');
                TaxAmt.SetEnabled(false);
            }
            else {
                var TaxAmt = InsgridBatch.GetEditor('TaxAmount');
                TaxAmt.SetEnabled(true);
            }
        }
        function GetVisibleIndex(s, e) {
            globalRowIndex = e.visibleIndex;
            EnableOrDisableTax();
        }
        function ddlBranch_SelectedIndexChanged() {
            var branch = $("#ddlBranch").val();
            InsgridBatch.batchEditApi.StartEdit(-1, 1);
            var accountingDataMin = InsgridBatch.GetEditor('MainAccount').GetValue();
            InsgridBatch.batchEditApi.EndEdit();

            InsgridBatch.batchEditApi.StartEdit(0, 1);
            var accountingDataplus = InsgridBatch.GetEditor('MainAccount').GetValue();
            InsgridBatch.batchEditApi.EndEdit();

            if (accountingDataMin != null || accountingDataplus != null) {
                jConfirm('You have changed Branch. All the entries of ledger in this voucher to be reset to blank. \n You have to select and re-enter. Continue?', 'Confirmation Dialog', function (r) {

                    if (r == true) {
                        deleteAllRows();
                        InsgridBatch.AddNewRow();
                        InsgridBatch.GetEditor('SrlNo').SetValue('1');
                        MainAccount.PerformCallback(branch)
                    }
                });
            }
            else {
                MainAccount.PerformCallback(branch)
            }
        }
        //function chkValidConta(contano_status) {
        //    if (contano_status == "outrange") {
        //        jAlert('Can Not Add More Cash/Bank Voucher as Contra Scheme Exausted.<br />Update The Scheme and Try Again');
        //    } else if (contano_status == "duplicate") {
        //        jAlert('Can Not Save as Duplicate Contra Voucher No. Found');
        //    }
        //    return false;
        //}
        function OnKeyDown(s, e) {
            if (e.htmlEvent.keyCode == 40 || e.htmlEvent.keyCode == 38)
                return ASPxClientUtils.PreventEvent(e.htmlEvent);
        }
        function cddl_AmountAre_LostFocus() {
            if (InsgridBatch.GetVisibleRowsOnPage() == 1) {
                InsgridBatch.batchEditApi.StartEdit(-1, 2);
            }
        }
        function CreditGotFocus(s, e) {
            PaymentOldValue = s.GetText();
            NetAmountOldValue = InsgridBatch.GetEditor("NetAmount").GetValue();
            var indx = PaymentOldValue.indexOf(',');
            if (indx != -1) {
                PaymentOldValue = PaymentOldValue.replace(/,/g, '');
            }
        }
        function Payment_Lost_Focus(s, e) {
            PaymentNewValue = s.GetText();
            var indx = PaymentNewValue.indexOf(',');
            if (indx != -1) {
                PaymentNewValue = PaymentNewValue.replace(/,/g, '');
            }

            if (PaymentOldValue != PaymentNewValue) {
                changePaymentTotalSummary();
            }
        }
        function recalculateReceipt(oldVal) {
            if (oldVal != 0) {
                ReciptNewValue = 0;
                ReciptOldValue = oldVal;
                changeReciptTotalSummary();
            }
        }
        function PaymentTextChange(s, e) {
            Payment_Lost_Focus(s, e);
            var PaymentValue = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "0";
            var ReceiptValue = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('btnRecieve').GetValue()) : "0";

            if (PaymentValue > 0) {
                recalculateReceipt(InsgridBatch.GetEditor('btnRecieve').GetValue());
                InsgridBatch.GetEditor('btnRecieve').SetValue("0");
                if (PaymentValue != PaymentOldValue) {
                    InsgridBatch.GetEditor('TaxAmount').SetValue("0");
                }
                InsgridBatch.GetEditor('NetAmount').SetValue(PaymentValue);
            }
            $("#HdProdGrossAmt").val(PaymentValue);
            // caspxTaxpopUp.Show();
            // showTax();
        <%--    if (document.getElementById('<%= hdnPayment.ClientID %>').value == "YES") {
                jConfirm('Wish to deduct TDS?', 'Confirmation Dialog', function (r) {
                    if (r == true) {

                        InsgridBatch.UpdateEdit();
                        InsgridBatch.PerformCallback('Display');
                        InsgridBatch.batchEditApi.EndEdit;
                        InsgridBatch.batchEditApi.StartEdit(-1, 1);
                        InsgridBatch.batchEditApi.StartEdit(0, 2);
                    }
                    else {
                        InsgridBatch.batchEditApi.EndEdit;
                        InsgridBatch.batchEditApi.StartEdit(-1, 1);
                    }
                });
            }--%>
            //else
            //{
            //    InsgridBatch.batchEditApi.StartEdit(-1, 1);
            //}

        }
        function DebitGotFocus(s, e) {
            ReciptOldValue = s.GetText();
            var indx = ReciptOldValue.indexOf(',');
            if (indx != -1) {
                ReciptOldValue = ReciptOldValue.replace(/,/g, '');
            }
        }
        function changePaymentTotalSummary() {
            var newDif = PaymentOldValue - PaymentNewValue;
            var CurrentSum = ctxtTotalPayment.GetText();
            var indx = CurrentSum.indexOf(',');
            if (indx != -1) {
                CurrentSum = CurrentSum.replace(/,/g, '');
            }
            ctxtTotalPayment.SetValue(parseFloat(CurrentSum - newDif));
            var newNetAmountDiff = NetAmountOldValue - PaymentNewValue;
            var CurrentNetSum = c_txtTotalNetAmount.GetText();
            c_txtTotalNetAmount.SetValue(parseFloat(CurrentNetSum - newNetAmountDiff));

        }

        //New By Indranil
        function txtPercentageLostFocus(s, e) {
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
                        ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + (parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) - GlobalCurTaxAmt);
                        GlobalCurTaxAmt = 0;
                    }
                    else {

                        GlobalCurTaxAmt = parseFloat(cgridTax.GetEditor("Amount").GetValue());
                        cgridTax.GetEditor("Amount").SetValue((parseFloat(ProdAmt * s.GetText()) / 100) * -1);
                        ctxtTaxTotAmt.SetValue(parseFloat(ctxtTaxTotAmt.GetValue()) + ((parseFloat(ProdAmt * parseFloat(s.GetText())) / 100) * -1) - (GlobalCurTaxAmt * -1));
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
        function CmbtaxClick(s, e) {
            GlobalCurTaxAmt = parseFloat(ctxtGstCstVat.GetText());
            gstcstvatGlobalName = s.GetText();
        }
        function taxAmountLostFocus(s, e) {
            var finalTaxAmt = parseFloat(s.GetValue());
            var totAmt = parseFloat(ctxtTaxTotAmt.GetText());
            var totLength = cgridTax.GetEditor("Taxes_Name").GetText().length;
            var sign = cgridTax.GetEditor("Taxes_Name").GetText().substring(totLength - 3);
            if (sign == '(+)') {
                ctxtTaxTotAmt.SetValue(totAmt + finalTaxAmt - taxAmountGlobal);
            } else {
                ctxtTaxTotAmt.SetValue(totAmt + (finalTaxAmt * -1) - (taxAmountGlobal * -1));
            }
            SetOtherTaxValueOnRespectiveRow(0, cgridTax.GetEditor("Amount").GetValue(), cgridTax.GetEditor("Taxes_Name").GetText().replace('(+)', '').replace('(-)', ''));
            //Set Running Total
            SetRunningTotal();
            RecalCulateTaxTotalAmountInline();
        }
        function QuotationTaxAmountGotFocus(s, e) {
            taxAmountGlobalCharges = parseFloat(s.GetValue());
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

        //-----------------------------------------------------------------------------------------------------

        function recalculatePayment(oldVal) {
            if (oldVal != 0) {
                PaymentNewValue = 0;
                PaymentOldValue = oldVal;
                changePaymentTotalSummary();
            }
        }
        function changeReciptTotalSummary() {
            var newDif = ReciptOldValue - ReciptNewValue;
            var CurrentSum = c_txt_Debit.GetText();
            var indx = CurrentSum.indexOf(',');
            if (indx != -1) {
                CurrentSum = CurrentSum.replace(/,/g, '');
            }

            c_txt_Debit.SetValue(parseFloat(CurrentSum - newDif));
        }
        function ReceiptLostFocus(s, e) {
            ReciptNewValue = s.GetText();
            var indx = ReciptNewValue.indexOf(',');

            if (indx != -1) {
                ReciptNewValue = ReciptNewValue.replace(/,/g, '');
            }
            if (ReciptOldValue != ReciptNewValue) {
                changeReciptTotalSummary();
            }
        }
        function ReceiptTextChange(s, e) {
            ReceiptLostFocus(s, e);
            var RecieveValue = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('btnRecieve').GetValue()) : "0";
            var receiptValue = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "0";

            if (RecieveValue > 0) {
                recalculatePayment(InsgridBatch.GetEditor('btnPayment').GetValue());
                InsgridBatch.GetEditor('btnPayment').SetValue("0");
                if (RecieveValue != ReciptOldValue) {
                    InsgridBatch.GetEditor('TaxAmount').SetValue("0");
                }
                InsgridBatch.GetEditor('NetAmount').SetValue(RecieveValue);
            }


        }
        function Receipt_TextChange(s, e) {
            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage();
            var RecieveValue = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('btnRecieve').GetValue()) : "0";
            var PaymentValue = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "0";

            if (parseFloat(RecieveValue) > 0) {
                var tbPayment = InsgridBatch.GetEditor("btnPayment");
                tbPayment.SetValue("0");
            }

            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var i, cnt = 1;
            var sumPayment = 0, sumRecieve = 0;
            for (i = -1 ; cnt <= noofvisiblerows ; i--) {
                var Payment = (InsgridBatch.batchEditApi.GetCellValue(i, 'btnPayment') != null) ? (InsgridBatch.batchEditApi.GetCellValue(i, 'btnPayment')) : "0";
                var Recieve = (InsgridBatch.batchEditApi.GetCellValue(i, 'btnRecieve') != null) ? (InsgridBatch.batchEditApi.GetCellValue(i, 'btnRecieve')) : "0";

                sumPayment = sumPayment + parseFloat(Payment);
                sumRecieve = sumRecieve + parseFloat(Recieve);

                cnt++;
            }

            if (parseFloat(RecieveValue) > 0) {
                c_txt_Debit.SetValue(sumRecieve + parseFloat(RecieveValue));
                ctxtTotalPayment.SetValue(sumPayment - parseFloat(PaymentValue));
            }
            else {
                c_txt_Debit.SetValue(sumRecieve + parseFloat(RecieveValue));
                ctxtTotalPayment.SetValue(sumPayment + parseFloat(PaymentValue));
            }
        }
        function Payment_TextChange(s, e) {
            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage();
            var RecieveValue = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('btnRecieve').GetValue()) : "0";
            var PaymentValue = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "0";

            if (parseFloat(PaymentValue) > 0) {
                var tbRecieve = InsgridBatch.GetEditor("btnRecieve");
                tbRecieve.SetValue("0");
            }

            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var i, cnt = 1;
            var sumPayment = 0, sumRecieve = 0;
            for (i = -1 ; cnt <= noofvisiblerows ; i--) {
                var Payment = (InsgridBatch.batchEditApi.GetCellValue(i, 'btnPayment') != null) ? (InsgridBatch.batchEditApi.GetCellValue(i, 'btnPayment')) : "0";
                var Recieve = (InsgridBatch.batchEditApi.GetCellValue(i, 'btnRecieve') != null) ? (InsgridBatch.batchEditApi.GetCellValue(i, 'btnRecieve')) : "0";

                sumPayment = sumPayment + parseFloat(Payment);
                sumRecieve = sumRecieve + parseFloat(Recieve);

                cnt++;
            }

            if (parseFloat(PaymentValue) > 0) {
                c_txt_Debit.SetValue(sumRecieve - parseFloat(RecieveValue));
                ctxtTotalPayment.SetValue(sumPayment + parseFloat(PaymentValue));
            }
            else {
                c_txt_Debit.SetValue(sumRecieve + parseFloat(RecieveValue));
                ctxtTotalPayment.SetValue(sumPayment + parseFloat(PaymentValue));
            }
        }
        function Calculate() {
            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var i, cnt = 1;
            var sumPayment = 0, sumRecieve = 0;
            for (i = -1 ; cnt <= noofvisiblerows ; i--) {
                var Payment = (InsgridBatch.batchEditApi.GetCellValue(i, 'btnPayment') != null) ? (InsgridBatch.batchEditApi.GetCellValue(i, 'btnPayment')) : "0";
                var Recieve = (InsgridBatch.batchEditApi.GetCellValue(i, 'btnRecieve') != null) ? (InsgridBatch.batchEditApi.GetCellValue(i, 'btnRecieve')) : "0";

                sumPayment = sumPayment + parseFloat(Payment);
                sumRecieve = sumRecieve + parseFloat(Recieve);

                cnt++;
            }

            c_txt_Debit.SetValue(sumRecieve);
            ctxtTotalPayment.SetValue(sumPayment);
        }
        var lastCRP = null;
        function rbtnType_SelectedIndexChanged() {
            document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
            // var VoucherType = cComboType.GetValue();
            var VoucherType = document.getElementById('rbtnType').value;

            if (cCmbScheme.InCallback()) {
                lastCRP = VoucherType;
            }
            else {
                cCmbScheme.PerformCallback(VoucherType);
            }
            if (VoucherType == "P") {
                document.getElementById('divPaidTo').style.display = 'block';
                document.getElementById('divReceivedfrom').style.display = 'none';
                LoadCustomerAddress('', $('#ddlBranch').val(), 'PO');
            }
            else {
                document.getElementById('divReceivedfrom').style.display = 'block';
                document.getElementById('divPaidTo').style.display = 'none';
                ClearBillingShipping('all');
            }
            //cComboType.SetEnabled(false);
            //$("#rbtnType").attr("disabled", "disabled");
        }
        function CmbSchemeEndCallback() {
            if (lastCRP) {
                cCmbScheme.PerformCallback(lastCRP);
                lastCRP = null;
            }

        }
        function OnAddNewClick() {

            InsgridBatch.AddNewRow();
            var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage(); // all newly created rows have -ve index -1 , -2 etc
            var i;
            var cnt = 1;
            for (i = -1 ; cnt <= noofvisiblerows ; i--) {
                var tbQuotation = InsgridBatch.GetEditor("SrlNo");
                tbQuotation.SetValue(cnt);
                cnt++;
            }
        }
        var CustomDeleteID = "";
        function OnCustomButtonClick(s, e) {

            if (e.buttonID == 'AddNew') {
                InsgridBatch.batchEditApi.StartEdit(e.visibleIndex);
                var mainAccountValue = (InsgridBatch.GetEditor('MainAccount').GetValue() != null) ? InsgridBatch.GetEditor('MainAccount').GetValue() : "";
                var btnRecieve = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? InsgridBatch.GetEditor('btnRecieve').GetValue() : "";
                var btnPayment = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "";
                if (mainAccountValue != "" && (btnRecieve != "0.0" || btnPayment != "0.0")) {
                    document.getElementById('hdnTaxGridBind').value = 'YES';
                    InsgridBatch.SetFocusedRowIndex();
                    //document.getElementById('hdnCheckAdd').value = 'YES';
                    OnAddNewClick();
                }
            }
            if (e.buttonID == 'CustomDelete') {

                var SrlNo = InsgridBatch.batchEditApi.GetCellValue(e.visibleIndex, 'SrlNo');

                $('#<%=hdnRefreshType.ClientID %>').val('');
                $('#<%=hdnDeleteSrlNo.ClientID %>').val(SrlNo);
                CustomDeleteID = "1";
                var noofvisiblerows = InsgridBatch.GetVisibleRowsOnPage();
                if (noofvisiblerows != "1") {
                    InsgridBatch.batchEditApi.StartEdit(e.visibleIndex, 1);
                    InsgridBatch.DeleteRow(e.visibleIndex);

                    $('#<%=hdfIsDelete.ClientID %>').val('D');
                    InsgridBatch.UpdateEdit();

                    InsgridBatch.PerformCallback('Display');
                    $('#<%=hdnPageStatus.ClientID %>').val('delete');


                    var PaymentValue = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "0";
                    var ReceiptValue = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? parseFloat(InsgridBatch.GetEditor('btnRecieve').GetValue()) : "0";

                    var receiptTotValue = c_txt_Debit.GetValue();
                    var paymentTotValue = ctxtTotalPayment.GetValue();

                    c_txt_Debit.SetValue(parseFloat(receiptTotValue) - parseFloat(ReceiptValue));
                    ctxtTotalPayment.SetValue(parseFloat(paymentTotValue) - parseFloat(PaymentValue));


                    //document.getElementById('btnSaveNew').style.display = 'block';
                    //document.getElementById('btnSaveRecords').style.display = 'block';
                    cbtnSaveNew.SetVisible(false);
                    cbtnSaveRecords.SetVisible(false);


                }
            }
        }

        function PaymentgotFocus(s, e) {
            GlobargotPayMent = s.GetValue();

        }
        function PaymentLostFocus(s, e) {

            var PayVal = parseFloat((s.GetValue() != null) ? s.GetValue() : "0");
            if (GlobargotPayMent != null) {
                if (parseFloat(GlobargotPayMent) != PayVal) {
                    var Curval = parseFloat(ctxtTotalPayment.GetText());
                    var Totalval = PayVal + Curval - GlobargotPayMent;
                    ctxtTotalPayment.SetValue(Totalval);
                    GlobargotPayMent = null;
                }
            }

        }
        function RecptgotFocus(s, e) {
            GlobargotRecpt = s.GetValue();

        }
        function SumReceipt(s, e) {

            var recptVal = parseFloat((s.GetValue() != null) ? s.GetValue() : "0");
            if (GlobargotRecpt != null) {
                if (parseFloat(GlobargotRecpt) != recptVal) {
                    var Curval = parseFloat(c_txt_Debit.GetText());
                    var Totalval = recptVal + Curval - GlobargotRecpt;
                    c_txt_Debit.SetValue(Totalval);
                    GlobargotRecpt = null;
                }
            }

        }
        function ChangeVoucherType() {
            var colName;
            var val = "0";
            var AspRadio = document.getElementById("rbtnType");
            var AspRadio_ListItem = AspRadio.getElementsByTagName('input');
            for (var i = 0; i < AspRadio_ListItem.length; i++) {
                if (AspRadio_ListItem[i].checked) {
                    val = AspRadio_ListItem[i].value;
                }
            }

            if (val == "R") {

                InsgridBatch.GetEditor('btnPayment').SetEnabled(false);

            }
            else {
                InsgridBatch.GetEditor('btnPayment').SetEnabled(true);
            }
            if (val == "P") {

                InsgridBatch.GetEditor('btnRecieve').SetEnabled(false);
            }
            else {
                InsgridBatch.GetEditor('btnRecieve').SetEnabled(true);
            }
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
            InsgridBatch.AddNewRow();

            ctxtTotalPayment.SetValue(0);
            c_txt_Debit.SetValue(0);

        }
        //function onBranchItems(e) {

        //    //get the first row accounting value debjyoti 
        //    InsgridBatch.batchEditApi.StartEdit(-1, 1);
        //    var accountingDataMin = InsgridBatch.GetEditor('MainAccount').GetValue();
        //    InsgridBatch.batchEditApi.EndEdit();

        //    InsgridBatch.batchEditApi.StartEdit(0, 1);
        //    var accountingDataplus = InsgridBatch.GetEditor('MainAccount').GetValue();
        //    InsgridBatch.batchEditApi.EndEdit();


        //    if (accountingDataMin != null || accountingDataplus != null) {
        //        jConfirm('You have changed Branch. All the entries of ledger in this voucher to be reset to blank. \n You have to select and re-enter. Continue?', 'Confirmation Dialog', function (r) {

        //            if (r == true) {
        //                deleteAllRows();

        //                MainAccount.PerformCallback(document.getElementById('ddlBranch').value);
        //                oldBranchdata = document.getElementById('lstBranchItems').value;
        //                $('#MandatoryBranch').hide();
        //                BindCashBankAccountListByBranch(document.getElementById('lstBranchItems').value);
        //            } else {
        //                Bind_Branch_Edit(oldBranchdata);
        //            }
        //        });

        //    }
        //    else {
        //        BindCashBankAccountListByBranch(document.getElementById('lstBranchItems').value);
        //        //MainAccount.PerformCallback(document.getElementById('lstBranchItems').value);
        //        MainAccount.PerformCallback(document.getElementById('ddlBranch').value);
        //    }

        //}
        function AddBatchNew(s, e) {
            InsgridBatch.batchEditApi.StartEdit(e.visibleIndex);
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode === 13) {
                var mainAccountValue = (InsgridBatch.GetEditor('MainAccount').GetValue() != null) ? InsgridBatch.GetEditor('MainAccount').GetValue() : "";
                var btnRecieve = (InsgridBatch.GetEditor('btnRecieve').GetValue() != null) ? InsgridBatch.GetEditor('btnRecieve').GetValue() : "";
                var btnPayment = (InsgridBatch.GetEditor('btnPayment').GetValue() != null) ? InsgridBatch.GetEditor('btnPayment').GetValue() : "";
                if (mainAccountValue != "" && (btnRecieve != "0.0" || btnPayment != "0.0")) {
                    InsgridBatch.AddNewRow();
                    InsgridBatch.SetFocusedRowIndex();
                }
            }
            else if (keyCode === 9) {
                cbtnSaveNew.Focus();
            }
            else {
                return false;
            }

        }
        //...................Shortcut keys.................

        document.onkeydown = function (e) {
            if (event.keyCode == 83 && event.altKey == true) {
                //run code for Alt+S -- ie, save!   
                StopDefaultAction(e);

                if (CustomDeleteID == "1") {

                }
                else {
                    document.getElementById('btnSaveNew').click();
                }

            }
            else if ((event.keyCode == 120 || event.keyCode == 88) && event.altKey == true) {
                //run code for Alt+X -- ie, Save & Exit! 
                StopDefaultAction(e);
                if (CustomDeleteID == "1") {

                }
                else {
                    document.getElementById('btnSaveRecords').click();
                }


                //return false;
            }
                //else if ((event.keyCode == 120 || event.keyCode == 65) && event.altKey == true) {

                //    if (document.getElementById('DivEntry').style.display != 'block') {
                //        if (document.getElementById('AddButton').style.display != 'none') {
                //            AddButtonClick();
                //        }
                //    }
                //}
            else if (event.keyCode == 79 && event.altKey == true) {
                //run code for Alt+X -- ie, Billing/Shipping Ok button! 
                StopDefaultAction(e);
                if (page.GetActiveTabIndex() == 1) {
                    fnSaveBillingShipping();
                }
                return false;
            }
        }
        function StopDefaultAction(e) {
            if (e.preventDefault) { e.preventDefault() }
            else { e.stop() };

            e.returnValue = false;
            e.stopPropagation();
        }
        //...................end............................
        var currentEditableVisibleIndex;
        var lastMainAccountID;
        var setValueFlag;
        function InstrumentDateChange() {
            var SelectedDate = new Date(cInstDate.GetDate());
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
                cInstDate.SetDate(MaxLockDate);
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
                //                   alert('Between');
            }
            else {
                // jAlert('Enter Date Is Outside Of Financial Year !!');
                jAlert('Enter Date Is Outside Of Financial Year !!', 'Alert Dialog: [CashBank]', function (r) {
                    if (r == true) {
                        //cdtTDate.Focus();
                    }
                });
                if (SelectedDateNumericValue < FinYearStartDateNumericValue) {
                    cInstDate.SetDate(new Date(FinYearStartDate));
                }
                if (SelectedDateNumericValue > FinYearEndDatNumbericValue) {
                    cInstDate.SetDate(new Date(FinYearEndDate));
                }
            }
            ///End OF Date Should Between Current Fin Year StartDate and EndDate
        }
        function InstrumentTypeSelectedIndexChanged() {
            $("#MandatoryInstrumentType").hide();
            $("#MandatoryInstNo").hide();

            var InstType = cComboInstrumentTypee.GetValue();

            if (InstType == "CH") {
                $('#<%=hdnInstrumentType.ClientID %>').val(0);
                document.getElementById("divInstrumentNo").style.display = 'none';
                document.getElementById("tdIDateDiv").style.display = 'none';
                document.getElementById("divDraweeBank").style.display = 'none';
            }
            else {
                $('#<%=hdnInstrumentType.ClientID %>').val(InstType);
                document.getElementById("divInstrumentNo").style.display = 'block';
                document.getElementById("tdIDateDiv").style.display = 'block';
                document.getElementById("divDraweeBank").style.display = 'block';
            }
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
                    url: "ContraVoucher.aspx/GetRate",
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

        function CmbScheme_ValueChange() {

            var NoSchemeTypedtl = (cCmbScheme.GetValue() == null ? "" : cCmbScheme.GetValue());
            var schemetype = NoSchemeTypedtl.toString().split('~')[1];
            var schemelength = NoSchemeTypedtl.toString().split('~')[2];
            var branchID = (NoSchemeTypedtl.toString().split('~')[3] != null) ? NoSchemeTypedtl.toString().split('~')[3] : "";
            cddlCashBank.PerformCallback(branchID);
            //MainAccount.PerformCallback(branchID);
            $('#txtVoucherNo').attr('maxLength', schemelength);
            $('#<%=hdnBranchId.ClientID %>').val(branchID);
            $('#<%=hfIsFilter.ClientID %>').val(branchID);

            document.getElementById('ddlBranch').value = branchID;
            document.getElementById('ddlEnterBranch').value = branchID;
            //var VoucherType = cComboType.GetValue();
            var VoucherType = document.getElementById('rbtnType').value;
            ClearBillingShipping('all');

            var CashBankText = cddlCashBank.GetText();
            if (CashBankText != "") {
                var arr = CashBankText.split('|');
                var strbranch = $('#<%=hdnBranchId.ClientID %>').val();
            }
            else {
                document.getElementById("pageheaderContent").style.display = 'none';
            }

            deleteAllRows();
            InsgridBatch.AddNewRow();
            InsgridBatch.GetEditor('SrlNo').SetValue('1');
            InsgridBatch.batchEditApi.EndEdit();
            c_txt_Debit.SetValue("0.00");
            ctxtTotalPayment.SetValue("0.00");

            if (schemetype == '0') {
                $('#<%=hdnSchemaType.ClientID %>').val('0');
                document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = false;
                document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";

            }
            else if (schemetype == '1') {
                $('#<%=hdnSchemaType.ClientID %>').val('1');
                document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Auto";
                $("#MandatoryBillNo").hide();
                cdtTDate.Focus();
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
            //$("#ddlBranch").attr("disabled", "disabled");

        <%--var val = cCmbScheme.GetValue();
        $.ajax({
            type: "POST",
            url: 'CashBankEntry.aspx/getSchemeType',
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
                  
                    $('#<%=hdnBranchId.ClientID %>').val(branchID);
                        document.getElementById('ddlBranch').value = branchID;
                        var VoucherType = cComboType.GetValue();
                        ClearBillingShipping('all');
                        if (VoucherType == "P") {
                            LoadCustomerAddress('', $('#ddlBranch').val(), 'PO');
                        }


                        $("#ddlBranch").attr("disabled", "disabled");
                       
                        cddlCashBank.PerformCallback(branchID);
                        
                        MainAccount.PerformCallback(branchID);
                   
                        var CashBankText = cddlCashBank.GetText();
                        if (CashBankText != "") {
                            var arr = CashBankText.split('|');
                            var strbranch = $('#<%=hdnBranchId.ClientID %>').val();
                            PopulateCurrentBankBalance(arr[0], strbranch);
                        }
                        else {

                            document.getElementById("pageheaderContent").style.display = 'none';
                        }

                    }
                    if (schemetype == '0') {
                        $('#<%=hdnSchemaType.ClientID %>').val('0');
                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = false;
                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
                       
                    }
                    else if (schemetype == '1') {
                        $('#<%=hdnSchemaType.ClientID %>').val('1');
                        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Auto";
                        $("#MandatoryBillNo").hide();
                        cdtTDate.Focus();
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
            });--%>


            if (schemetype == '0') {
                document.getElementById("txtVoucherNo").focus();
            } else {
                cCmbScheme.Focus();
            }
        }

        function CountriesCombo_SelectedIndexChanged() {

            var currentValue = MainAccount.GetValue();
            ///  Numering Scheme Disable after selection of ledger
            if (currentValue != null && currentValue != '' && currentValue != '0' && cCmbScheme.GetValue() != null) {
                cCmbScheme.SetEnabled(false);
            }
            chkAccount = 1;
            if (lastMainAccountID == currentValue) {
                if (SubAccount_ReferenceID.GetSelectedIndex() < 0)
                    SubAccount_ReferenceID.SetSelectedIndex(0);
                return;
            }
            lastMainAccountID = currentValue;
            LoadingPanel.Show();
            if (currentValue != null) {
                SubAccount_ReferenceID.PerformCallback(currentValue + '~' + "");
            }
            else {
                LoadingPanel.Hide();
            }
           <%-- $.ajax({
                type: "POST",
                url: "CashBankEntry.aspx/CheckTdsByMainAccountID",
                data: JSON.stringify({ MainAccountID: currentValue }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;

                    if (data == "NO") {
                        $('#<%=hdnPayment.ClientID %>').val(data);
                        InsgridBatch.GetEditor('TDS').SetValue(" ");
                    }
                    else {
                        $('#<%=hdnPayment.ClientID %>').val(data);
                        InsgridBatch.GetEditor('TDS').SetValue("Y");
                    }
                    
                }
            });--%>

            if (currentValue != "") {
                cddl_AmountAre.SetEnabled(false);
                $("#rbtnType").attr("disabled", "disabled");
            }

        }
        function IntializeGlobalVariables(grid) {
            lastMainAccountID = grid.cplastMainAccountID;
            currentEditableVisibleIndex = -1;
            setValueFlag = -1;

        }

        //function Bind_Branch_Edit(obj) {
        //    var dropdownlistbox = document.getElementById("lstBranchItems")

        //    for (var i = 0; i < dropdownlistbox.options.length; i++) {
        //        if (dropdownlistbox.options[i].value == obj) {
        //            dropdownlistbox.options[i].selected = true;
        //        }
        //    }
        //    $('#lstBranchItems').trigger("chosen:updated");

        //    MainAccount.PerformCallback(document.getElementById('lstBranchItems').value);

        //}
        //function Bind_Cash_Bank_Edit(obj) {
        //    var dropdownlistbox = document.getElementById("lstCashItems")

        //    for (var i = 0; i < dropdownlistbox.options.length; i++) {
        //        if (dropdownlistbox.options[i].value == obj) {
        //            dropdownlistbox.options[i].selected = true;
        //        }
        //    }
        //    $('#lstCashItems').trigger("chosen:updated");
        //}
        function WithdrawalChangedNew(WithDrawType) {

            if (WithDrawType == "Cash") {
                var comboitem = cComboInstrumentTypee.FindItemByValue('C');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('D');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('E');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('CH');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("Cash", "CH");
                }
                cComboInstrumentTypee.SetValue("CH");
                InstrumentTypeSelectedIndexChanged();
            }
            else {
                var comboitem = cComboInstrumentTypee.FindItemByValue('C');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("Cheque", "C");
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('D');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("Draft", "D");
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('E');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstrumentTypee.AddItem("E.Transfer", "E");
                }
                var comboitem = cComboInstrumentTypee.FindItemByValue('CH');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstrumentTypee.RemoveItem(comboitem.index);
                    cComboInstrumentTypee.SetValue("C");
                    InstrumentTypeSelectedIndexChanged();
                }
            }
        }
      <%--  function acpEndCallbackGeneral(s, e) {
            LoadingPanel.Hide();
            if (cASPxCallbackGeneral.cpCBEdit != null) {
                var VoucherType = cASPxCallbackGeneral.cpCBEdit.split('*')[0];
                var CashBank_ID = cASPxCallbackGeneral.cpCBEdit.split('*')[1];
                var Currency = cASPxCallbackGeneral.cpCBEdit.split('*')[2];
                var InstrumentType = cASPxCallbackGeneral.cpCBEdit.split('*')[3];
                EditAddressSinglePage(CashBank_ID, 'CBE');
                if (VoucherType == "P") {
                    document.getElementById('divPaidTo').style.display = 'block';
                    document.getElementById('divReceivedfrom').style.display = 'none';
                }
                else {
                    document.getElementById('divReceivedfrom').style.display = 'block';
                    document.getElementById('divPaidTo').style.display = 'none';
                }
                $("#txtVoucherNo").attr("disabled", "disabled");
                $("#ddlBranch").attr("disabled", "disabled");
                $("#ddlEnterBranch").attr("disabled", "disabled");
                var setCurr = '<%=Session["LocalCurrency"]%>';
                var localCurrency = setCurr.split('~')[0];
                if (Currency != localCurrency) {
                    $('#<%=hdnCurrenctId.ClientID %>').val(Currency);
                    ctxtRate.SetEnabled(true);
                }
                else {
                    ctxtRate.SetEnabled(false);
                    $('#<%=hdnCurrenctId.ClientID %>').val("");
                }
                var WithdrawalType = "";
                if (InstrumentType == "CH") {
                    WithdrawalType = "Cash";
                    $('#<%=hdnInstrumentType.ClientID %>').val(0);
                    document.getElementById("divInstrumentNo").style.display = 'none';
                    document.getElementById("tdIDateDiv").style.display = 'none';
                }
                else {
                    $('#<%=hdnInstrumentType.ClientID %>').val(InstrumentType);
                }
                WithdrawalChangedNew(WithdrawalType);
                InsgridBatch.batchEditApi.StartEdit(-1, 1);
                if ($('#<%=hdnEditClick.ClientID %>').val() == 'T') {
                    OnAddNewClick();
                    $('#<%=hdnEditClick.ClientID %>').val("");
                }
                // cComboType.SetEnabled(false);
                $("#rbtnType").attr("disabled", "disabled");
                cddl_AmountAre.SetEnabled(false);
                var CashBankText = cddlCashBank.GetText();
                var arr = CashBankText.split('|');
                var strbranch = $("#ddlBranch").val();
                PopulateCurrentBankBalance(arr[0], strbranch);
                document.getElementById('hdnEditCBID').value = CashBank_ID;
                document.getElementById('divNumberingScheme').style.display = 'none';
                document.getElementById('divEnterBranch').style.display = 'Block';
                cASPxCallbackGeneral.cpCBEdit = null;
            }
            if (cASPxCallbackGeneral.cpView == "1") {
                viewOnly();
                cASPxCallbackGeneral.cpView = null;
            }

        }--%>
        function OnEndCallback(s, e) {
            IntializeGlobalVariables(s);
            LoadingPanel.Hide();
            $('#<%=hdnDeleteSrlNo.ClientID %>').val('0');
            var pageStatus = document.getElementById('hdnPageStatus').value;

            var ViewStatus = document.getElementById('hdnView').value;

            if ($('#<%=hdnPayment.ClientID %>').val() == "YES") {
                $('#<%=hdnPayment.ClientID %>').val("NO");
                OnAddNewClick();
            }
            if (InsgridBatch.cpTotalAmount != null) {
                var total_receipt = InsgridBatch.cpTotalAmount.split('~')[0];
                var total_payment = InsgridBatch.cpTotalAmount.split('~')[1];
                c_txt_Debit.SetValue(total_receipt);
                ctxtTotalPayment.SetValue(total_payment);
                InsgridBatch.cpTotalAmount = null;
            }

            <%--if (InsgridBatch.cpEdit != null) {                
                var VoucherType = InsgridBatch.cpEdit.split('*')[0];
                var VoucherNo = InsgridBatch.cpEdit.split('*')[1];
                var trnsDate = InsgridBatch.cpEdit.split('*')[2];
                var Branch = InsgridBatch.cpEdit.split('*')[3];
                var Cash_Bank = InsgridBatch.cpEdit.split('*')[4];
                var Currency = InsgridBatch.cpEdit.split('*')[5];
                var InstrumentType = InsgridBatch.cpEdit.split('*')[6];
                var InstrumentNo = InsgridBatch.cpEdit.split('*')[7];
                var Narration = InsgridBatch.cpEdit.split('*')[8];
                var receipt = InsgridBatch.cpEdit.split('*')[9];
                var payment = InsgridBatch.cpEdit.split('*')[10];
                var CashBank_ID = InsgridBatch.cpEdit.split('*')[11];
                var ReceivedFrom = InsgridBatch.cpEdit.split('*')[12];
                var PaidTo = InsgridBatch.cpEdit.split('*')[13];
                var Tax_Code = InsgridBatch.cpEdit.split('*')[14];
                var ContactNo = InsgridBatch.cpEdit.split('*')[15];
                var ReverseCharge = InsgridBatch.cpEdit.split('*')[16];
                var InstrumentDate = InsgridBatch.cpEdit.split('*')[17];
                var DraweeBank = InsgridBatch.cpEdit.split('*')[18];
                var EnteredBranchID = InsgridBatch.cpEdit.split('*')[19];
                var CashBankName = InsgridBatch.cpEdit.split('*')[20];

                document.getElementById('hdnEditCBID').value = CashBank_ID;
                var Transdt = new Date(trnsDate);
                EditAddressSinglePage(CashBank_ID, 'CBE');
                cdtTDate.SetDate(Transdt);
                var insDate = new Date(InstrumentDate);
                cInstDate.SetDate(insDate);
                if (VoucherType == "P") {
                    document.getElementById('divPaidTo').style.display = 'block';
                    document.getElementById('divReceivedfrom').style.display = 'none';
                    ctxtPaidTo.SetValue(PaidTo);
                }
                else {
                    document.getElementById('divReceivedfrom').style.display = 'block';
                    document.getElementById('divPaidTo').style.display = 'none';
                    ctxtReceivedFrom.SetValue(ReceivedFrom);
                }
                document.getElementById('txtVoucherNo').value = VoucherNo;
                $("#txtVoucherNo").attr("disabled", "disabled");
                $("#ddlBranch").attr("disabled", "disabled");
                $("#ddlEnterBranch").attr("disabled", "disabled");
                ctxtInstNobth.SetValue(InstrumentNo.trim());
                document.getElementById('txtNarration').value = Narration;
                ctxtReceivedFrom.SetValue(ReceivedFrom);
                ctxtPaidTo.SetValue(PaidTo);
                cddl_AmountAre.SetValue(Tax_Code);
                document.getElementById('rbtnType').value = VoucherType
                $("#rbtnType").attr("disabled", "disabled");
               // cComboType.SetValue(VoucherType);
               // cComboType.SetEnabled(false);
                cddl_AmountAre.SetEnabled(true);
                $("#txtContact").val(ContactNo);
                $("#txtDraweeBank").val(DraweeBank);
                $("#chk_reversemechenism").prop("checked", parseInt(ReverseCharge));
                var setCurr = '<%=Session["LocalCurrency"]%>';
                var localCurrency = setCurr.split('~')[0];
                if (Currency != localCurrency) {
                    cCmbCurrency.SetValue(Currency);
                    $('#<%=hdnCurrenctId.ClientID %>').val(Currency);
                    ctxtRate.SetEnabled(true);
                }
                else {
                    ctxtRate.SetEnabled(false);
                    $('#<%=hdnCurrenctId.ClientID %>').val("");
                }
                var WithdrawalType = "";
                if (InstrumentType == "CH") {
                    WithdrawalType = "Cash";
                    $('#<%=hdnInstrumentType.ClientID %>').val(0);
                    document.getElementById("divInstrumentNo").style.display = 'none';
                    document.getElementById("tdIDateDiv").style.display = 'none';
                }
                else {
                    $('#<%=hdnInstrumentType.ClientID %>').val(InstrumentType);
                }
                WithdrawalChangedNew(WithdrawalType);
                cComboInstrumentTypee.SetValue(InstrumentType);
                oldBranchdata = Branch;
                $('#<%=hdnInstrumentNo.ClientID %>').val(InstrumentNo.trim());
                $('#<%=hdnBranchId.ClientID %>').val(Branch);
                $('#<%=hdnCashBankId.ClientID %>').val(Cash_Bank);
                c_txt_Debit.SetValue(receipt);
                ctxtTotalPayment.SetValue(payment);
                $("#ddlBranch").val(Branch);
                $("#ddlEnterBranch").val(EnteredBranchID);
                cddlCashBank.PerformCallback(EnteredBranchID);

                InsgridBatch.batchEditApi.StartEdit(-1, 1);
                if ($('#<%=hdnEditClick.ClientID %>').val() == 'T') {
                    OnAddNewClick();
                    $('#<%=hdnEditClick.ClientID %>').val("");
                }
                InsgridBatch.cpEdit = null;
            }--%>
            if (InsgridBatch.cpSaveSuccessOrFail == "outrange") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('The Numbering Scheme has exhausted, please update the Scheme and try adding the Voucher');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "duplicate") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('Can not save as duplicate Voucher No.');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "zeroAmount") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('Cannot save with ZERO Amount.');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "errorInsert") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('Try again later.');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "mixedvalue") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('Either select all ledger(s) mapped with Reverse Charge or vice-versa.');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';

            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "reverserequired") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('Selected Ledger(s) are mapped with Reverse Charge, please check Reverse Charge option.');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "reversenotrequired") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('Selected Ledger(s) are not mapped with Reverse Charge, please un-check Reverse Charge option.');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "reversetaxledgermissing") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('reversetaxledgermissing');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "addressrequired") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;

                jAlert("Please Enter Billing/Shipping and GSTIN Details to Calculate GST.", "Alert !!", function () {
                    page.SetActiveTabIndex(1);
                    cbsSave_BillingShipping.Focus();
                    page.tabs[0].SetEnabled(false);
                    $("#divcross").hide();
                });
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';

            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "taxREquired") {
                InsgridBatch.cpSaveSuccessOrFail = null;
                OnAddNewClick();
                chkAccount = 1;
                jAlert('Selected Ledger is tagged for GST calculation. Click on Charges to calculate GST and Proceed.');
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);
                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';
            }
            else if (InsgridBatch.cpSaveSuccessOrFail == "successInsert") {

                if (InsgridBatch.cpVouvherNo != null) {
                    var JV_Number = InsgridBatch.cpVouvherNo;
                    var value = document.getElementById('hdnRefreshType').value;
                    var JV_Msg = "Cash/Bank Voucher No. " + JV_Number + " generated.";
                    var strSchemaType = document.getElementById('hdnSchemaType').value;

                    if (value == "E") {
                        if (JV_Number != "") {
                            var Type = InsgridBatch.cpType;
                            var newInvoiceId = InsgridBatch.cpAutoID;

                            //if (newInvoiceId == "-20")
                            //{
                            //    var mismatch_Msg = 'Mismatch in Debit & Credit Posting.';
                            //    jAlert(mismatch_Msg, 'Alert Dialog: [CashBank]', function (r) {
                            //        if (r == true) {                                       
                            //        }
                            //    });
                            //}
                            //else
                            //{
                            var AutoPrint = document.getElementById('hdnAutoPrint').value;
                            if (AutoPrint == "Yes") {
                                if (Type == "P") {
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=PaymentVoucher~D&modulename=CBVUCHR&id=" + newInvoiceId, '_blank');
                                }
                                else {
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=ReceiptVoucher~D&modulename=CBVUCHR&id=" + newInvoiceId, '_blank');
                                }
                            }
                            if (strSchemaType == '1') {
                                jAlert(JV_Msg, 'Alert Dialog: [CashBank]', function (r) {
                                    if (r == true) {
                                        window.location.assign("CashBankEntryList.aspx");
                                    }
                                });
                            }
                            else {
                                window.location.assign("CashBankEntryList.aspx");
                            }
                            //}                           

                        }
                        else {
                            // window.location.reload();
                            window.location.assign("CashBankEntryList.aspx");
                        }
                    }
                    else if (value == "S") {
                        if (JV_Number != "") {
                            var Type = InsgridBatch.cpType;
                            var newInvoiceId = InsgridBatch.cpAutoID;
                            var AutoPrint = document.getElementById('hdnAutoPrint').value;
                            if (AutoPrint == "Yes") {
                                if (Type == "P") {
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=PaymentVoucher~D&modulename=CBVUCHR&id=" + newInvoiceId, '_blank');
                                }
                                else {
                                    window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=ReceiptVoucher~D&modulename=CBVUCHR&id=" + newInvoiceId, '_blank');
                                }
                            }

                            // if (strSchemaType == '1') {
                            jAlert(JV_Msg, 'Alert Dialog: [CashBank]', function (r) {
                                if (r == true) {
                                    window.location.assign("CashBankEntry.aspx?key=ADD");
                                }
                            });
                            //jAlert(JV_Msg, "Alert!!", function () {
                            //});
                            // }
                        }
                        else {
                            // window.location.reload();
                            window.location.assign("CashBankEntry.aspx?key=ADD");
                        }
                    }
                    // InsgridBatch.cpVouvherNo = null;
                }
                if ($('#<%=hdnBtnClick.ClientID %>').val() == "Save_Exit") {
                    if (InsgridBatch.cpExitNew == "YES") {
                        //window.location.reload();
                        //window.location.assign("CashBankEntryList.aspx");
                    }
                    else {
                        OnAddNewClick();
                    }
                    InsgridBatch.cpType = null;
                    InsgridBatch.cpAutoID = null;
                }
                if ($('#<%=hdnBtnClick.ClientID %>').val() == "Save_New") {

                    //'''''''''''''''''''''''''''Commented for New Page
                    $("#divNumberingScheme").show();
                    $("#divEnterBranch").hide();
                    var Campany_ID = '<%=Session["LastCompany"]%>';
                    var LocalCurrency = '<%=Session["LocalCurrency"]%>';
                    var basedCurrency = LocalCurrency.split("~");
                    cCmbCurrency.SetValue(basedCurrency[0]);
                    c_txt_Debit.SetValue("0.0");
                    ctxtTotalPayment.SetValue("0.0");
                    ctxtRate.SetValue("");
                    cddl_AmountAre.SetEnabled(true);
                    //window.location.assign("CashBankEntry.aspx?key=ADD");

                    //'''''''''''''''''''''''end''''''''''''''''''''''''''''''''''''''''''''''

                    //if (cComboInstrumentTypee.GetValue() == "CH") {
                    //    document.getElementById("divInstrumentNo").style.display = 'none';
                    //    document.getElementById("tdIDateDiv").style.display = 'none';
                    //}
                    //else {
                    //    document.getElementById("divInstrumentNo").style.display = 'block';
                    //    document.getElementById("tdIDateDiv").style.display = 'block';
                    //}

                    <%--$('#<%=lblHeading.ClientID %>').text("");
                    $('#<%=lblHeading.ClientID %>').text("Add Cash/Bank Voucher");

                    deleteAllRows();
                    OnAddNewClick();
                    if (document.getElementById('txtVoucherNo').value == "Auto") {
                        document.getElementById('txtVoucherNo').value = "Auto";
                        cComboInstrumentTypee.Focus();
                    }
                    else {
                        document.getElementById('txtVoucherNo').value = "";
                        InsgridBatch.batchEditApi.EndEdit();
                        $('#txtVoucherNo').focus();
                    }

                    var CashBankId = cddlCashBank.GetValue();
                    var CashBankText = cddlCashBank.GetText();
                    var strbranch = $('#<%=hdnBranchId.ClientID %>').val();
                    var arr = CashBankText.split('|');
                    PopulateCurrentBankBalance(arr[0], strbranch);
                    // cComboType.Focus();


                    InsgridBatch.cpType = null;
                    InsgridBatch.cpAutoID = null;--%>
                }
            }
            ////##### coded by Samrat Roy - 14/04/2017 - ref IssueLog(Voucher - 110) 
            ////This method is called when request is for View Only .
            // if (InsgridBatch.cpView == "1") {
            if (ViewStatus == "1") {
                viewOnly();
            }
            else if (pageStatus == "delete") {
                $('#<%=hdnPageStatus.ClientID %>').val('');
                CustomDeleteID = "";
                cbtnSaveNew.SetVisible(true);
                cbtnSaveRecords.SetVisible(true);

                //document.getElementById('btnSaveNew').style.display = 'none';
                //document.getElementById('btnSaveRecords').style.display = 'none';

                OnAddNewClick();
            }
            else if (pageStatus == "update") {
                $('#<%=hdnPageStatus.ClientID %>').val('');
                    AddButtonClick();
                    var VoucherType = $('#rbtnType').val();
                    if (VoucherType == "P") {
                        InsgridBatch.GetEditor('btnRecieve').SetEnabled(false);
                    }
                    else {
                        InsgridBatch.GetEditor('btnPayment').SetEnabled(false);
                    }
                }
            //else if (pageStatus == "first") {
            //    AddButtonClick();
            //}

    }
    function GridADD() {
        // AddButtonClick();
        // InsgridBatch.PerformCallback('Display');
    }

    function Gridupdate() {
        var VoucherType = $("#rbtnType").val();

        var CashBank_ID = getParameterByName('key');
        //var CashBank_ID = document.getElementById('hdnEditRfid').Value;
        var Currency = cCmbCurrency.GetValue();
        var InstrumentType = cComboInstrumentTypee.GetValue();
        // EditAddressSinglePage(CashBank_ID, 'CBE');
        if (VoucherType == "P") {
            document.getElementById('divPaidTo').style.display = 'block';
            document.getElementById('divReceivedfrom').style.display = 'none';
        }
        else {
            document.getElementById('divReceivedfrom').style.display = 'block';
            document.getElementById('divPaidTo').style.display = 'none';
        }
        $("#txtVoucherNo").attr("disabled", "disabled");
        $("#ddlBranch").attr("disabled", "disabled");
        $("#ddlEnterBranch").attr("disabled", "disabled");
        $("#ddl_AmountAre").attr("disabled", "disabled");
        var setCurr = '<%=Session["LocalCurrency"]%>';
        var localCurrency = setCurr.split('~')[0];
        if (Currency != localCurrency) {
            $('#<%=hdnCurrenctId.ClientID %>').val(Currency);
             ctxtRate.SetEnabled(true);
         }
         else {
             ctxtRate.SetEnabled(false);
             $('#<%=hdnCurrenctId.ClientID %>').val("");
        }

        var WithdrawalType = "";
        if (InstrumentType == "C") {
            WithdrawalType = "Cheque";
        }
        else if (InstrumentType == "E") {
            WithdrawalType = "E.Transfer";
        }
        else if (InstrumentType == "D") {
            WithdrawalType = "Draft";
        }
        else if (InstrumentType == "CH") {
            WithdrawalType = "Cash";
            $('#<%=hdnInstrumentType.ClientID %>').val(0);
                document.getElementById("divInstrumentNo").style.display = 'none';
                document.getElementById("tdIDateDiv").style.display = 'none';
            }
            else {
                $('#<%=hdnInstrumentType.ClientID %>').val(InstrumentType);
            }

    WithdrawalChangedNew(WithdrawalType);
    cComboInstrumentTypee.SetValue(InstrumentType);

    InsgridBatch.batchEditApi.StartEdit(-1, 1);
    if ($('#<%=hdnEditClick.ClientID %>').val() == 'T') {
        OnAddNewClick();
        $('#<%=hdnEditClick.ClientID %>').val("");
                }
                $("#rbtnType").attr("disabled", "disabled");
                cddl_AmountAre.SetEnabled(false);
                var CashBankText = cddlCashBank.GetText();
                var arr = CashBankText.split('|');
                var strbranch = $("#ddlBranch").val();
                PopulateCurrentBankBalance(arr[0], strbranch);
                document.getElementById('hdnEditCBID').value = CashBank_ID;
                document.getElementById('divNumberingScheme').style.display = 'none';
                document.getElementById('divEnterBranch').style.display = 'Block';
                InsgridBatch.PerformCallback('Display');


            }

            function OnBatchEditStartEditing(s, e) {

                currentEditableVisibleIndex = e.visibleIndex;
                globalRowIndex = e.visibleIndex;
                //var currentMainAccount = InsgridBatch.batchEditApi.GetCellValue(currentEditableVisibleIndex, "MainAccount");
                //var SubAccountIDColumn = s.GetColumnByField("bthSubAccount");
                //if (!e.rowValues.hasOwnProperty(SubAccountIDColumn.index))
                //    return;
                //var cellInfo = e.rowValues[SubAccountIDColumn.index];


                //if (lastMainAccountID == currentMainAccount)
                //    if (SubAccount_ReferenceID.FindItemByValue(cellInfo.value) != null)
                //        SubAccount_ReferenceID.SetValue(cellInfo.value);
                //    else {

                //        if (e.focusedColumn.fieldName != "TaxAmount") {
                //            LoadingPanel.Show();
                //        }
                //        RefreshData(cellInfo, lastMainAccountID);

                //    }

                //else {
                //    if (currentMainAccount == null) {
                //        SubAccount_ReferenceID.SetSelectedIndex(-1);
                //        return;
                //    }
                //    lastMainAccountID = currentMainAccount;


                //    if (e.focusedColumn.fieldName != "TaxAmount") {
                //        LoadingPanel.Show();
                //    }
                //    RefreshData(cellInfo, lastMainAccountID);

                //}
            }
            //function RefreshData(cellInfo, MainAccountID) {
            //    setValueFlag = cellInfo.value;

            //    if (setValueFlag != null) {
            //        SubAccount_ReferenceID.PerformCallback(MainAccountID + '~' + setValueFlag);
            //    }
            //        // SubAccount_ReferenceID.PerformCallback(MainAccountID + '~' + setValueFlag);            
            //        //else if(document.getElementById('hdnCheckAdd').value == 'YES')
            //        //{
            //        //    document.getElementById('hdnCheckAdd').value = "";
            //        //    SubAccount_ReferenceID.PerformCallback(MainAccountID + '~' + setValueFlag);
            //        //}
            //    else {
            //        LoadingPanel.Hide();
            //    }
            //}
            //function OnBatchEditEndEditing(s, e) {

            //    currentEditableVisibleIndex = -1;
            //    var SubAccountIDColumn = s.GetColumnByField("bthSubAccount");
            //    if (!e.rowValues.hasOwnProperty(SubAccountIDColumn.index))
            //        return;
            //    var cellInfo = e.rowValues[SubAccountIDColumn.index];
            //    if (SubAccount_ReferenceID.GetSelectedIndex() > -1 || cellInfo.text != SubAccount_ReferenceID.GetText()) {
            //        cellInfo.value = SubAccount_ReferenceID.GetValue();
            //        cellInfo.text = SubAccount_ReferenceID.GetText();
            //        SubAccount_ReferenceID.SetValue(null);
            //    }
            //}
            //function SubAccountCombo_EndCallback(s, e) {
            //    if (setValueFlag == null || setValueFlag == "0" || setValueFlag == "") {
            //        s.SetSelectedIndex(-1);
            //    }
            //    else {
            //        if (SubAccount_ReferenceID.FindItemByValue(setValueFlag) != null) {
            //            SubAccount_ReferenceID.SetValue(setValueFlag);
            //            setValueFlag = null;
            //        }
            //    }
            //    var reverseApplicable = InsgridBatch.GetEditor("ReverseApplicable");
            //    reverseApplicable.SetValue(SubAccount_ReferenceID.cpReverseApplicable);                
            //    $("#IsTaxApplicable").val(SubAccount_ReferenceID.cpIsTaxable);
            //    var VoucherType = document.getElementById('rbtnType').value;
            //    if (SubAccount_ReferenceID.cpReverseApplicable == "1" && VoucherType == "P") {
            //        $("#chk_reversemechenism").prop("disabled", false);
            //        $("#chk_reversemechenism").prop("checked", true);
            //    }
            //    else {
            //        if ($("#chk_reversemechenism").prop('checked') == false) {
            //            $("#chk_reversemechenism").prop("checked", false);
            //        }
            //    }
            //    SubAccount_ReferenceID.cpReverseApplicable = null;
            //    LoadingPanel.Hide();
            //}
            function OnInit(s, e) {
                IntializeGlobalVariables(s);
            }
            //....end....
            function AddButtonClick() {
                cCmbScheme.SetEnabled(true);
                ctxtRate.SetEnabled(false);
                // document.getElementById('rbtnType').value = 'P';
                var VoucherType = document.getElementById('rbtnType').value;
                $('#<%=hdnPayment.ClientID %>').val('NO');
                             $('#<%=hdnTaxGridBind.ClientID %>').val('NO');
               <%-- document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;--%>
                             OnAddNewClick();
                             var defaultbranch = '<%=Session["userbranchID"]%>';
                $('#<%=hdnBranchId.ClientID %>').val(defaultbranch);
                             var SaveModeCB = '<%=Session["SaveModeCB"]%>';
                             if (SaveModeCB == "") {
                                 cCmbScheme.Focus();
                                 if ($('#hdn_Mode').val() != "Edit") {
                                     cddl_AmountAre.SetEnabled(true);
                                     cddl_AmountAre.SetValue(1);
                                 }
                                 document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                }
                else {
                    if (SaveModeCB == 'A') {
                        cdtTDate.Focus();
                    }
                    if (SaveModeCB == 'M') {
                        document.getElementById("txtVoucherNo").focus();
                    }
                    <%--var InstrumentType = cComboInstrumentTypee.GetValue();
                    var WithdrawalType = "";
                    if (InstrumentType == "C") {
                        WithdrawalType = "Cheque";
                    }
                    else if (InstrumentType == "E") {
                        WithdrawalType = "E.Transfer";
                    }
                    else if (InstrumentType == "D") {
                        WithdrawalType = "Draft";
                    }
                    else if (InstrumentType == "CH") {
                        WithdrawalType = "Cash";
                        $('#<%=hdnInstrumentType.ClientID %>').val(0);
                        document.getElementById("divInstrumentNo").style.display = 'none';
                        document.getElementById("tdIDateDiv").style.display = 'none';

                    }
                    else {
                        $('#<%=hdnInstrumentType.ClientID %>').val(InstrumentType);

                    }
                    WithdrawalChangedNew(WithdrawalType);
                    cComboInstrumentTypee.SetValue(InstrumentType);--%>

                }

                             //LoadCustomerAddress('', $('#ddlBranch').val(), 'PO');
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
        //function focusval(obj) {

        //}

        $(function () {

            // BindCashBankAccountList();
            //BindBranchList();
            // ListBranchBind();
            // ListAccountBind();

            // ListMainAccountBind();
            //  ListSubAccountBind();


            //BindWithFromList();

            //ListWithFromBind();
            // BindDepositIntoList();
            //ListDepositIntoBind();
            <%--$("#lstCashItems").chosen().change(function () {
        $('#MandatoryCashBank').hide();
        var CashBankId = $("#lstCashItems").val()
        var CashBankText = $("#lstCashItems").find("option:selected").text()
        var strbranch = $('#<%=hdnBranchId.ClientID %>').val();
        var arr = CashBankText.split('|');
        PopulateCurrentBankBalance(arr[0], strbranch);
        $('#<%=hdnCashBankId.ClientID %>').val(CashBankId);
        $('#<%=hdnCashBankText.ClientID %>').val(CashBankText);
        var SpliteDetails = CashBankText.split(']');
        var WithDrawType = SpliteDetails[1].trim();
        if (WithDrawType == "Cash") {
            var comboitem = cComboInstrumentTypee.FindItemByValue('C');
            if (comboitem != undefined && comboitem != null) {
                cComboInstrumentTypee.RemoveItem(comboitem.index);
            }
            var comboitem = cComboInstrumentTypee.FindItemByValue('D');
            if (comboitem != undefined && comboitem != null) {
                cComboInstrumentTypee.RemoveItem(comboitem.index);
            }
            var comboitem = cComboInstrumentTypee.FindItemByValue('E');
            if (comboitem != undefined && comboitem != null) {
                cComboInstrumentTypee.RemoveItem(comboitem.index);
            }
            var comboitem = cComboInstrumentTypee.FindItemByValue('CH');
            if (comboitem == undefined || comboitem == null) {
                cComboInstrumentTypee.AddItem("Cash", "CH");
            }
            cComboInstrumentTypee.SetValue("CH");
            InstrumentTypeSelectedIndexChanged();
        }
        else {
            var comboitem = cComboInstrumentTypee.FindItemByValue('C');
            if (comboitem == undefined || comboitem == null) {
                cComboInstrumentTypee.AddItem("Cheque", "C");
            }
            var comboitem = cComboInstrumentTypee.FindItemByValue('D');
            if (comboitem == undefined || comboitem == null) {
                cComboInstrumentTypee.AddItem("Draft", "D");
            }
            var comboitem = cComboInstrumentTypee.FindItemByValue('E');
            if (comboitem == undefined || comboitem == null) {
                cComboInstrumentTypee.AddItem("E.Transfer", "E");
            }
            var comboitem = cComboInstrumentTypee.FindItemByValue('CH');
            if (comboitem != undefined && comboitem != null) {
                cComboInstrumentTypee.RemoveItem(comboitem.index);
                cComboInstrumentTypee.SetValue("C");
                InstrumentTypeSelectedIndexChanged();
            }
        }
    })--%>
            <%--$("#lstMainAccount").chosen().change(function () {
        var MainAccountId = $("#lstMainAccount").val();
        var MainAccountText = $("#lstMainAccount").find("option:selected").text()
        $('#<%=hdnMainAccountId.ClientID %>').val(MainAccountId);
        $('#<%=hdnMainAccountText.ClientID %>').val(MainAccountText);

        BindSubAccountList();

        keyVal(MainAccountId);
    })--%>


            <%-- $("#lstMainAccountE").chosen().change(function () {
        var MainAccountEId = $("#lstMainAccountE").val();
        var MainAccountEText = $("#lstMainAccountE").find("option:selected").text()
        $('#<%=hdnMainAccountEId.ClientID %>').val(MainAccountEId);
        $('#<%=hdnMainAccountEText.ClientID %>').val(MainAccountEText);
    })--%>
            <%-- $("#lstSubAccount").chosen().change(function () {
        var SubAccountId = $("#lstSubAccount").val();
        var SubAccountText = $("#lstSubAccount").find("option:selected").text()
        $('#<%=hdnSubAccountId.ClientID %>').val(SubAccountId);
        $('#<%=hdnSubAccountText.ClientID %>').val(SubAccountText);
    })--%>
  <%--  $("#lstBranchItems").chosen().change(function () {
        var BranchId = $("#lstBranchItems").val();
        var BranchText = $("#lstBranchItems").find("option:selected").text()
        $('#<%=hdnBranchId.ClientID %>').val(BranchId);
        var a = $('#<%=hdnBranchId.ClientID %>').val();
        $('#<%=hdnBranchText.ClientID %>').val(BranchText);
    })--%>
        });
        //ProtoType
        String.prototype.trim = function () {
            return this.replace(/^\s+|\s+$/g, "");
        }
        String.prototype.ltrim = function () {
            return this.replace(/^\s+/, "");
        }
        String.prototype.rtrim = function () {
            return this.replace(/\s+$/, "");
        }
        //Global Variable
        FieldName = 'txtVoucherNo';
        IsSubAccountChange = "False";
        Param_SubAccountID = '';
        SubLedgerType = "";
        ActiveCurrencyID = "";
        ActiveCurrencyName = "";
        ActiveCurrencySymbol = "";

       <%-- function PageLoad() {
            var val = "0";
            var AspRadio = document.getElementById("rbtnType");
            var AspRadio_ListItem = AspRadio.getElementsByTagName('input');
            for (var i = 0; i < AspRadio_ListItem.length; i++) {
                if (AspRadio_ListItem[i].checked) {
                    val = AspRadio_ListItem[i].value;
                }
            }
            if (val == "R") {
            }
            else {

            }
            var ActiveCurrency = '<%=Session["ActiveCurrency"]%>'
            ActiveCurrencyID = ActiveCurrency.split('~')[0];
            ActiveCurrencyName = ActiveCurrency.split('~')[1];
            ActiveCurrencySymbol = ActiveCurrency.split('~')[2];
            FinYearCheckOnPageLoad();
        }--%>
        function checkTextAreaMaxLength(textBox, e, length) {

            var mLen = textBox["MaxLength"];
            if (null == mLen)
                mLen = length;
            var maxLength = parseInt(mLen);
            if (!checkSpecialKeys(e)) {
                if (textBox.value.length > maxLength - 1) {
                    if (window.event)//IE
                        e.returnValue = false;
                    else//Firefox
                        e.preventDefault();
                }
            }
        }

        function checkSpecialKeys(e) {
            if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
                return false;
            else
                return true;
        }

       <%-- function OnComboInstTypeSelectedIndexChanged() {

            SetAllDisplayNone();
            //kaushik
            var txtSubAccountText = $('#<%=hdnSubAccountText.ClientID %>').val();
            var Mode = document.getElementById("hdn_Mode").value;
            var VoucherType;
            var InstType;
            if (Mode == "Entry") {
                //VoucherType = cComboType.GetValue();
                VoucherType = document.getElementById('rbtnType').value;
                InstType = cComboInstType.GetValue();
            }
            else {
                VoucherType = cSCmb_Type.GetValue();
                InstType = cComboInstType.GetValue();
            }
            AccountType = document.getElementById('hdnAccountType').value;
            if (VoucherType == "P") {
                if (AccountType == 'EXPENCES' && InstType != "CH") {
                    document.getElementById("tdPayeeLable").style.visibility = 'visible';
                    document.getElementById("tdPayeeValue").style.visibility = 'visible';
                }
                document.getElementById("tdpayment").style.display = 'inline'
                document.getElementById("tdpaymentValue").style.display = 'inline'
                document.getElementById("tdpaymentDiv").style.display = 'block'
                if (InstType == "E") {
                    ctxtInstNo.SetText('E - Net');
                }
                else {
                    CmbClientBankCI.PerformCallback("SetFocusOnInstType~");
                }
                if (InstType != "CH") {
                    document.getElementById("tdINoLable").style.visibility = 'inherit'
                    document.getElementById("tdINoDiv").style.display = 'block'
                    document.getElementById("tdINoValue").style.visibility = 'inherit'
                    document.getElementById("tdIDateLable").style.visibility = 'inherit'
                    document.getElementById("tdIDateDiv").style.display = 'block'
                    document.getElementById("tdIDateValue").style.visibility = 'inherit'
                }

            }
            if (VoucherType == "R") {
                if (InstType == "C" || InstType == "E") {
                    if (SubLedgerType.toUpperCase() == 'CUSTOMERS') {
                        document.getElementById("tdCBankLable").style.display = 'inline';
                        document.getElementById("tdCBankValue").style.visibility = 'visible';
                        var SubAccountID = $('#<%=hdnSubAccountId.ClientID %>').val();
                if (SubAccountID != '') {
                    SubAccountID = SubAccountID.split('~')[0];
                    CmbClientBankCI.PerformCallback("ClientBankBind~" + SubAccountID);
                }
                else {
                    SubAccountID = document.getElementById('hdn_SubAccountIDE').value;
                    CmbClientBankCI.PerformCallback("ClientBankBind~" + SubAccountID);
                }
            }
        }
        else {
            if (InstType != "CH") {
                document.getElementById("tdIBankLable").style.display = 'block';
                document.getElementById("tdIBankValue").style.display = 'block';

            }
        }
        document.getElementById("tdRecieveDiv").style.display = 'block'
        document.getElementById("tdRecieve").style.display = 'block'
        document.getElementById("tdRecieveValue").style.display = 'block'


        //kaushik

        if (InstType == "E") {
            ctxtInstNo.SetText('E - Net');
        }
        else {
            ctxtInstNo.SetText('');
        }
        if (InstType != "CH") {
            document.getElementById("tdINoLable").style.visibility = 'inherit'
            document.getElementById("tdINoDiv").style.display = 'block'
            document.getElementById("tdINoValue").style.visibility = 'inherit'
            document.getElementById("tdIDateLable").style.visibility = 'inherit'
            document.getElementById("tdIDateDiv").style.display = 'block'
            document.getElementById("tdIDateValue").style.visibility = 'inherit'
        }


    }
    if (VoucherType == "C") {
        //Contra Change
        document.getElementById("tdContraEntry").style.display = 'block'
        if (InstType != "CH") {
            document.getElementById("tdINoLable").style.visibility = 'inherit'
            document.getElementById("tdINoDiv").style.display = 'block'
            document.getElementById("tdINoValue").style.visibility = 'inherit'
            document.getElementById("tdIDateLable").style.visibility = 'inherit'
            document.getElementById("tdIDateDiv").style.display = 'block'
            document.getElementById("tdIDateValue").style.visibility = 'inherit'
        }
        else {
            document.getElementById("tdINoLable").style.visibility = 'hidden'
            document.getElementById("tdINoDiv").style.display = 'none'
            document.getElementById("tdINoValue").style.visibility = 'hidden'
            document.getElementById("tdIDateLable").style.visibility = 'hidden'
            document.getElementById("tdIDateDiv").style.display = 'none'
            document.getElementById("tdIDateValue").style.visibility = 'hidden'

        }

        if (InstType == "E") {
            ctxtInstNo.SetText('E - Net');
        }
        else {
            ctxtInstNo.SetText('');
        }
    }
}--%>
        function SetAllDisplayNone() {
            document.getElementById("tdIBankLable").style.display = 'none';
            document.getElementById("tdIBankValue").style.display = 'none';
            document.getElementById("tdCBankLable").style.display = 'none';
            document.getElementById("tdCBankValue").style.visibility = 'hidden'
            document.getElementById("tdAuthLable").style.display = 'none';
            document.getElementById("tdAuthValue").style.display = 'none';
            document.getElementById("tdPayeeLable").style.visibility = 'hidden';
            document.getElementById("tdPayeeValue").style.visibility = 'hidden';
            document.getElementById("tdContraEntry").style.display = 'none';
            document.getElementById("tdpayment").style.display = 'none';
            document.getElementById("tdpaymentValue").style.display = 'none';
            document.getElementById("tdpaymentDiv").style.display = 'none'
            document.getElementById("tdRecieve").style.display = 'none';
            document.getElementById("tdRecieveValue").style.display = 'none';
            document.getElementById("tdRecieveDiv").style.display = 'none'
            document.getElementById("tdINoLable").style.visibility = 'hidden'
            document.getElementById("tdINoDiv").style.display = 'none'
            document.getElementById("tdINoValue").style.visibility = 'hidden'
            document.getElementById("tdIDateLable").style.visibility = 'hidden'
            document.getElementById("tdIDateDiv").style.display = 'none'
            document.getElementById("tdIDateValue").style.visibility = 'hidden'

        }
<%--function CallBankAccount(obj1, obj2, obj3) {
    var CurrentSegment = document.getElementById('hdn_CurrentSegment').value;
    var Mode = document.getElementById("hdn_Mode").value;
    var strPutSegment = " and (MainAccount_ExchangeSegment=" + CurrentSegment + " or MainAccount_ExchangeSegment=0)";
    var strQuery_Table = "(Select MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\'+\' ~ \'+MainAccount_BankCashType as IntegrateMainAccount,MainAccount_AccountCode+\'~\'+MainAccount_BankCashType+\'~CASHBANK\' as MainAccount_AccountCode,MainAccount_Name,MainAccount_BankAcNumber from Master_MainAccount where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\') and (MainAccount_BankCompany=\'" + '<%=Session["LastCompany"] %>' + "\' Or IsNull(MainAccount_BankCompany,'')='')" + strPutSegment + ") as t1";
    var strQuery_FieldName = " Top 10 * ";
    var strQuery_WhereClause = "MainAccount_AccountCode like (\'%RequestLetter%\') or MainAccount_Name like (\'%RequestLetter%\') or MainAccount_BankAcNumber like (\'%RequestLetter%\')";
    var strQuery_OrderBy = '';
    var strQuery_GroupBy = '';
    var CombinedQuery = new String(strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_OrderBy + "$" + strQuery_GroupBy);
    //kaushik
    ajax_showOptions(obj1, obj2, obj3, replaceChars(CombinedQuery), 'Main');
}--%>
        //function ListBranchBind() {

        //    var config = {
        //        '.chsn': {},
        //        '.chsn-deselect': { allow_single_deselect: true },
        //        '.chsn-no-single': { disable_search_threshold: 10 },
        //        '.chsn-no-results': { no_results_text: 'Oops, nothing found!' },
        //        '.chsn-width': { width: "100%" }
        //    }
        //    for (var selector in config) {
        //        $(selector).chosen(config[selector]);
        //    }
        //}
        //function ListMainAccountBind() {

        //    var config = {
        //        '.chsn': {},
        //        '.chsn-deselect': { allow_single_deselect: true },
        //        '.chsn-no-single': { disable_search_threshold: 10 },
        //        '.chsn-no-results': { no_results_text: 'Oops, nothing found!' },
        //        '.chsn-width': { width: "100%" }
        //    }
        //    for (var selector in config) {
        //        $(selector).chosen(config[selector]);
        //    }

        //}
        //function ListMainAccountEBind() {
        //    $('#lstMainAccountE').chosen();
        //}
        //function ListSubAccountBind() {
        //    var config = {
        //        '.chsn': {},
        //        '.chsn-deselect': { allow_single_deselect: true },
        //        '.chsn-no-single': { disable_search_threshold: 10 },
        //        '.chsn-no-results': { no_results_text: 'Oops, nothing found!' },
        //        '.chsn-width': { width: "100%" }
        //    }
        //    for (var selector in config) {
        //        $(selector).chosen(config[selector]);
        //    }
        //}
        function PopulateCurrentBankBalance(MainAccountID, BranchId) {
            if (MainAccountID.trim() == "" || BranchId.trim() == "") {
                return;
            }
            else {
                $.ajax({
                    type: "POST",
                    url: 'CashBankEntry.aspx/GetCurrentBankBalance',
                    data: "{MainAccountID:\"" + MainAccountID + "\",BranchID:\"" + BranchId + "\"}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var list = msg.d;

                        if (msg.d.length > 0) {
                            document.getElementById("pageheaderContent").style.display = 'block';
                            if (msg.d.split('~')[0] != '') {
                                document.getElementById('<%=B_ImgSymbolBankBal.ClientID %>').innerHTML = ActiveCurrencySymbol;
                                document.getElementById('<%=B_BankBalance.ClientID %>').innerHTML = msg.d.split('~')[0];
                                document.getElementById('<%=B_BankBalance.ClientID %>').style.color = "Black";
                            }
                            else {
                                document.getElementById('<%=B_ImgSymbolBankBal.ClientID %>').innerHTML = '';
                                document.getElementById('<%=B_BankBalance.ClientID %>').innerHTML = '0.0';
                                document.getElementById('<%=B_BankBalance.ClientID %>').style.color = "Black";
                            }
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        jAlert(textStatus);
                    }
                });
            }
        }
        //function setDepositIntoBind(obj) {
        //    if (obj) {
        //        var lstDepositInto = document.getElementById("lstDepositIntoItems");
        //        for (var i = 0; i < lstDepositInto.options.length; i++) {

        //            var DepositIntoval = lstDepositInto.options[i].value;
        //            var n = DepositIntoval.indexOf("~");
        //            var res = DepositIntoval.substr(0, n);
        //            if (res == obj) {
        //                lstDepositInto.options[i].selected = true;
        //            }
        //        }
        //    }
        //}
        //........Bind Branch......
        //function BindBranchList() {
        //    var lBox = $('select[id$=lstBranchItems]');
        //    var lstBranchItems = [];
        //    //Customer or Lead radio button is clicked kaushik 21-11-2016
        //    lBox.empty();
        //    $.ajax({
        //        type: "POST",
        //        url: 'CashBankEntry.aspx/GetBranchList',
        //        contentType: "application/json; charset=utf-8",
        //        dataType: "json",
        //        success: function (msg) {
        //            var list = msg.d;
        //            if (list.length > 0) {

        //                for (var i = 0; i < list.length; i++) {

        //                    var id = '';
        //                    var name = '';
        //                    id = list[i].split('|')[1];
        //                    name = list[i].split('|')[0];

        //                    lstBranchItems.push('<option value="' +
        //                    id + '">' + name
        //                    + '</option>');
        //                }

        //                $(lBox).append(lstBranchItems.join(''));
        //                ListBranchBind();
        //                $('#lstBranchItems').trigger("chosen:updated");
        //                $('#lstBranchItems').prop('disabled', false).trigger("chosen:updated");

        //            }
        //            else {
        //                lBox.empty();
        //                ListBranchBind();
        //                $('#lstBranchItems').trigger("chosen:updated");
        //                $('#lstBranchItems').prop('disabled', true).trigger("chosen:updated");

        //            }
        //        },
        //        error: function (XMLHttpRequest, textStatus, errorThrown) {
        //            jAlert(textStatus);
        //        }
        //    });
        //}
        //......end....

        function FinYearCheckOnPageLoad() {
            var SelectedDate = new Date(cdtTDate.GetDate());
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

            }
            else {
                if (SelectedDateNumericValue < FinYearStartDateNumericValue) {
                    cdtTDate.SetDate(new Date(FinYearStartDate));
                }
                if (SelectedDateNumericValue > FinYearEndDatNumbericValue) {
                    cdtTDate.SetDate(new Date(FinYearEndDate));
                }
            }
        }
        function TDateChange() {
            var SelectedDate = new Date(cdtTDate.GetDate());
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
                cdtTDate.SetDate(MaxLockDate);
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
                //                   alert('Between');
            }
            else {
                // jAlert('Enter Date Is Outside Of Financial Year !!');
                jAlert('Enter Date Is Outside Of Financial Year !!', 'Alert Dialog: [CashBank]', function (r) {
                    if (r == true) {
                        cdtTDate.Focus();
                    }
                });
                if (SelectedDateNumericValue < FinYearStartDateNumericValue) {
                    cdtTDate.SetDate(new Date(FinYearStartDate));
                }
                if (SelectedDateNumericValue > FinYearEndDatNumbericValue) {
                    cdtTDate.SetDate(new Date(FinYearEndDate));
                }
            }
            cInstDate.SetDate(SelectedDate);
            ///End OF Date Should Between Current Fin Year StartDate and EndDate
        }
        function SaveButtonClick() {

            $('#<%=hdnBtnClick.ClientID %>').val("Save_Exit");
            $('#<%=hdnJNMode.ClientID %>').val('0'); //Entry     
            $('#<%=hdnRefreshType.ClientID %>').val('E');
            $('#<%=hdfIsDelete.ClientID %>').val('I');
            $('#<%=hdnPayment.ClientID %>').val('NO');
            $('#<%=hdnTaxGridBind.ClientID %>').val('NO');
            var Branch = $('#ddlBranch').val();
            var CashBank = cddlCashBank.GetValue();
            var InstrumentType = cComboInstrumentTypee.GetValue();
            var InstrumentNo = ctxtInstNobth.GetValue();
            var InstType = document.getElementById('hdn_CashBankType_InstType').value;
            if (document.getElementById('<%= txtVoucherNo.ClientID %>').value.trim() == "") {
                $("#MandatoryBillNo").show();
                return false;
            }
            else if (Branch == null) {
                $("#MandatoryBranch").show();
                return false;
            }
            else if (CashBank == null) {
                $("#MandatoryCashBank").show();
                return false;
            }
            else if (InstrumentType == "NA") {
                $("#MandatoryInstrumentType").show();
                return false;
            }
            else if (InstType == "Yes" && InstrumentType == "C") {
                if (InstrumentNo == null) {
                    $("#MandatoryInstNo").show();
                    return false;
                }
            }
            if ($('#<%=hdnInstrumentNo.ClientID %>').val() == "") {
                $('#<%=hdnInstrumentNo.ClientID %>').val(InstrumentNo);
            }
            //InsgridBatch.UpdateEdit();
            InsgridBatch.batchEditApi.EndEdit();
            var gridCount = InsgridBatch.GetVisibleRowsOnPage();
            //var VoucherType = cComboType.GetValue();
            var VoucherType = document.getElementById('rbtnType').value;
            var txtTotalAmount = c_txt_Debit.GetValue() != null ? c_txt_Debit.GetValue() : 0;
            var txtTotalPayment = ctxtTotalPayment.GetValue() != null ? ctxtTotalPayment.GetValue() : 0;
            var IsType = "";
            var frontRow = 0;
            var backRow = -1;

            for (var i = 0; i <= InsgridBatch.GetVisibleRowsOnPage() ; i++) {
                var frontProduct = (InsgridBatch.batchEditApi.GetCellValue(backRow, 'MainAccount') != null) ? (InsgridBatch.batchEditApi.GetCellValue(backRow, 'MainAccount')) : "";
                var backProduct = (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'MainAccount') != null) ? (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'MainAccount')) : "";
                if (frontProduct != "" || backProduct != "") {
                    IsType = "Y";
                    break;
                }
                backRow--;
                frontRow++;
            }
            if (gridCount > 0) {
                // if (chkAccount == 1) {
                if (IsType == "Y") {
                    if (VoucherType == "P") {
                        if (parseFloat(txtTotalAmount) <= parseFloat(txtTotalPayment)) {
                            OnAddNewClick();
                            cbtnSaveNew.SetVisible(false);
                            cbtnSaveRecords.SetVisible(false);
                            //document.getElementById('btnSaveNew').style.display = 'block';
                            // document.getElementById('btnSaveRecords').style.display = 'block';
                            InsgridBatch.UpdateEdit();
                            chkAccount = 0;
                        }
                        else {
                            chkAccount = 1;
                            jAlert('As per the selcted Voucher type, Payment column amount should be greater than Receipt column amount.');
                        }
                    }
                    if (VoucherType == "R") {
                        if (parseFloat(txtTotalAmount) >= parseFloat(txtTotalPayment)) {
                            OnAddNewClick();
                            cbtnSaveNew.SetVisible(false);
                            cbtnSaveRecords.SetVisible(false);
                            //document.getElementById('btnSaveNew').style.display = 'block';
                            // document.getElementById('btnSaveRecords').style.display = 'block';
                            InsgridBatch.UpdateEdit();
                            chkAccount = 0;
                        }
                        else {
                            chkAccount = 1;
                            jAlert('As per the selcted Voucher type, Receipt column amount should be greater than Payment column amount.');
                        }
                    }
                }
                else {
                    //chkAccount = 0;
                    jAlert('Cannot Save. You must enter atleast one Record to save this entry.');
                }
            }
            else {
                //chkAccount = 0;
                jAlert('Cannot Save. You must enter atleast one Record to save this entry.');
            }
        }
        function txtBillNo_TextChanged() {
            var VoucherNo = document.getElementById("txtVoucherNo").value;
            $.ajax({
                type: "POST",
                url: "CashBankEntry.aspx/CheckUniqueName",
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
        function SaveButtonClickNew() {

            $('#<%=hdnBtnClick.ClientID %>').val("Save_New");
            $('#<%=hdnJNMode.ClientID %>').val('0'); //Entry  
            $('#<%=hdnRefreshType.ClientID %>').val('S');
            $('#<%=hdfIsDelete.ClientID %>').val('I');
            $('#<%=hdnPayment.ClientID %>').val('NO');
            $('#<%=hdnTaxGridBind.ClientID %>').val('NO');


            var Branch = $('#ddlBranch').val();
            var CashBank = cddlCashBank.GetValue();
            var InstrumentType = cComboInstrumentTypee.GetValue();
            var InstrumentNo = ctxtInstNobth.GetValue();
            var CashBankId = cddlCashBank.GetValue();
            var InstType = document.getElementById('hdn_CashBankType_InstType').value;

            if (document.getElementById('<%= txtVoucherNo.ClientID %>').value.trim() == "") {
                $("#MandatoryBillNo").show();

                return false;
            }
            else if (Branch == null) {
                $("#MandatoryBranch").show();
                return false;
            }
            else if (CashBank == null) {
                $("#MandatoryCashBank").show();
                return false;
            }
            else if (InstrumentType == "NA") {
                $("#MandatoryInstrumentType").show();
                return false;
            }
            else if (InstType == "Yes" && InstrumentType == "C") {
                if (InstrumentNo == null) {
                    $("#MandatoryInstNo").show();
                    return false;
                }
            }
            if ($('#<%=hdnInstrumentNo.ClientID %>').val() == "") {
                $('#<%=hdnInstrumentNo.ClientID %>').val(InstrumentNo);
            }
            var CashBankText = cddlCashBank.GetText();
            // var SpliteDetails = CashBankText.split(']');
            // var WithDrawType = SpliteDetails[1].trim();
            var WithDrawType = "";
            if (InstrumentType == "C") {
                WithDrawType = "Cheque";
            }
            else if (InstrumentType == "E") {
                WithDrawType = "E.Transfer";
            }
            else if (InstrumentType == "D") {
                WithDrawType = "Draft";
            }
            else if (InstrumentType == "CH") {
                WithDrawType = "Cash";
            }
            WithdrawalChangedNew(WithDrawType);
            cComboInstrumentTypee.SetValue(InstrumentType);
            InstrumentTypeSelectedIndexChanged();
            //Code added by Sudip
            InsgridBatch.batchEditApi.EndEdit();
            var gridCount = InsgridBatch.GetVisibleRowsOnPage();

            var txtTotalAmount = c_txt_Debit.GetValue() != null ? c_txt_Debit.GetValue() : 0;
            var txtTotalPayment = ctxtTotalPayment.GetValue() != null ? ctxtTotalPayment.GetValue() : 0;
            // var VoucherType = cComboType.GetValue();
            var VoucherType = document.getElementById('rbtnType').value;
            var IsType = "";
            var frontRow = 0;
            var backRow = -1;

            for (var i = 0; i <= InsgridBatch.GetVisibleRowsOnPage() ; i++) {
                var frontProduct = (InsgridBatch.batchEditApi.GetCellValue(backRow, 'MainAccount') != null) ? (InsgridBatch.batchEditApi.GetCellValue(backRow, 'MainAccount')) : "";
                var backProduct = (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'MainAccount') != null) ? (InsgridBatch.batchEditApi.GetCellValue(frontRow, 'MainAccount')) : "";
                if (frontProduct != "" || backProduct != "") {
                    IsType = "Y";
                    break;
                }
                backRow--;
                frontRow++;
            }
            if (gridCount > 0) {
                // if (chkAccount == 1) {
                if (IsType == "Y") {
                    if (VoucherType == "P") {
                        if (parseFloat(txtTotalAmount) <= parseFloat(txtTotalPayment)) {
                            OnAddNewClick();
                            cbtnSaveNew.SetVisible(false);
                            cbtnSaveRecords.SetVisible(false);
                            //document.getElementById('btnSaveNew').style.display = 'block';
                            //document.getElementById('btnSaveRecords').style.display = 'block';
                            InsgridBatch.UpdateEdit();
                            chkAccount = 0;
                        }
                        else {
                            chkAccount = 1;
                            jAlert('Payment amount can not be less than receipt amount ');

                        }
                    }


                    if (VoucherType == "R") {
                        if (parseFloat(txtTotalAmount) >= parseFloat(txtTotalPayment)) {
                            OnAddNewClick();
                            cbtnSaveNew.SetVisible(false);
                            cbtnSaveRecords.SetVisible(false);
                            //document.getElementById('btnSaveNew').style.display = 'block';
                            //document.getElementById('btnSaveRecords').style.display = 'block';
                            InsgridBatch.UpdateEdit();
                            chkAccount = 0;
                        }
                        else {
                            chkAccount = 1;
                            jAlert('Receipt amount can not be less than payment amount');

                        }
                    }
                }
                else {
                    // chkAccount = 0;
                    jAlert('Cannot Save. You must enter atleast one Record to save this entry.');
                }
            }
            else {
                //chkAccount = 0;
                jAlert('Cannot Save. You must enter atleast one Record to save this entry.');
            }
        }

        function GvCBSearch_EndCallBack() {
            if (cGvCBSearch.cpDelete != null) {
                jAlert(cGvCBSearch.cpDelete);
                cGvCBSearch.cpDelete = null;
            }
        }
        function CustomButtonClick(s, e) {
            if (e.buttonID == 'CustomBtnEdit') {
                s.GetRowValues(e.visibleIndex, 'ValueDate', function (value) {
                    if (value != null)
                    { jAlert("Voucher is Reconciled.Cannot Edit"); }
                    else {
                        $('#<%=hdnEditClick.ClientID %>').val('T'); //Edit
                $('#<%=hdnJNMode.ClientID %>').val('1');//Edit
                VisibleIndexE = e.visibleIndex;
                $('#<%= lblHeading.ClientID %>').text("Modify Cash/Bank Voucher");
                        document.getElementById('DivEntry').style.display = 'block';
                        document.getElementById('divExportto').style.display = 'none';
                        document.getElementById('divAddButton').style.display = 'none';
                        document.getElementById('gridFilter').style.display = 'none';
                        document.getElementById('DivEdit').style.display = 'none';
                        btncross.style.display = "block";
                        $('#<%=hdn_Mode.ClientID %>').val('Edit');
                //InsgridBatch.PerformCallback("Edit~" + VisibleIndexE);
                cASPxCallbackGeneral.PerformCallback("Edit~" + VisibleIndexE);
                LoadingPanel.Show();
                chkAccount = 1;
                document.getElementById('divNumberingScheme').style.display = 'none';
                document.getElementById('divEnterBranch').style.display = 'Block';
            }
        });
    }
    else if (e.buttonID == 'CustomBtnView') {
        $('#<%=hdnEditClick.ClientID %>').val('T'); //Edit
        $('#<%=hdnJNMode.ClientID %>').val('1');//Edit
        VisibleIndexE = e.visibleIndex;
        $('#<%= lblHeading.ClientID %>').text("View Cash/Bank Voucher");
        document.getElementById('DivEntry').style.display = 'block';
        document.getElementById('divExportto').style.display = 'none';
        document.getElementById('divAddButton').style.display = 'none';
        document.getElementById('gridFilter').style.display = 'none';
        document.getElementById('DivEdit').style.display = 'none';
        btncross.style.display = "block";
        $('#<%=hdn_Mode.ClientID %>').val('View');
        //InsgridBatch.PerformCallback("View~" + VisibleIndexE);
        cASPxCallbackGeneral.PerformCallback("View~" + VisibleIndexE);
        LoadingPanel.Show();
        chkAccount = 1;
        document.getElementById('divNumberingScheme').style.display = 'none';
    }
    else if (e.buttonID == 'CustomBtnDelete') {
        jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
            if (r == true) {
                VisibleIndexE = e.visibleIndex;
                cGvCBSearch.PerformCallback("Delete~" + VisibleIndexE);
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
}

//function onPrintJv(id) {

//    RecPayId = id;
//    cDocumentsPopup.Show();
//    cCmbDesignName.SetSelectedIndex(0);
//    cSelectPanel.PerformCallback('Bindalldesignes');
//    $('#btnOK').focus();
//}

//function PerformCallToGridBind() {
//    cSelectPanel.PerformCallback('Bindsingledesign');
//    cDocumentsPopup.Hide();
//    return false;
//}

//function cSelectPanelEndCall(s, e) {

//    if (cSelectPanel.cpSuccess != "") {
//        var TotDocument = cSelectPanel.cpSuccess.split(',');
//        var reportName = cCmbDesignName.GetValue();
//        var module = 'CBVUCHR';
//        window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=' + module + '&id=' + RecPayId, '_blank')
//    }
//    if (cSelectPanel.cpSuccess == "") {
//        cCmbDesignName.SetSelectedIndex(0);
//    }
//}

////##### coded by Samrat Roy - 14/04/2017 - ref IssueLog(Voucher - 110) 
////This method is for disable all the attributes.
function viewOnly() {
    if ($('#<%=hdn_Mode.ClientID %>').val().toUpperCase() == 'VIEW') {
        $('#DivEntry').find('input, textarea, button, select').attr('disabled', 'disabled');
        InsgridBatch.SetEnabled(false);
        cddlCashBank.SetEnabled(false);
        // cComboType.SetEnabled(false);
        $("#rbtnType").attr("disabled", "disabled");
        cdtTDate.SetEnabled(false);
        cCmbCurrency.SetEnabled(false);
        ctxtRate.SetEnabled(false);
        cComboInstrumentTypee.SetEnabled(false);
        ctxtInstNobth.SetEnabled(false);
        cInstDate.SetEnabled(false);
        ctxtReceivedFrom.SetEnabled(false);
        ctxtPaidTo.SetEnabled(false);
        cddl_AmountAre.SetEnabled(false);
        cbtnSaveNew.SetVisible(false);
        cbtnSaveRecords.SetVisible(false);
        //document.getElementById('btnSaveNew').style.display = 'block';
        //document.getElementById('btnSaveRecords').style.display = 'block';
    }
    LoadingPanel.Hide();
}
<%--function OnGetRowValuesOnDelete(values) {
    var ValueDate = new Date(values[0]);
    var monthnumber = ValueDate.getMonth();
    var monthday = ValueDate.getDate();
    var year = ValueDate.getYear();
    var ValueDateNumeric = new Date(year, monthnumber, monthday).getTime();
    var TransactionDate = new Date(values[1]);
    monthnumber = TransactionDate.getMonth();
    monthday = TransactionDate.getDate();
    year = TransactionDate.getYear();
    var TransactionDateNumeric = new Date(year, monthnumber, monthday).getTime();
    var MaxLockDate = new Date('<%=Session["LCKBNK"] %>');
    monthnumber = MaxLockDate.getMonth();
    monthday = MaxLockDate.getDate();
    year = MaxLockDate.getYear();
    var MaxLockDateNumeric = new Date(year, monthnumber, monthday).getTime();
    if (TransactionDateNumeric <= MaxLockDateNumeric) {
        jAlert('This Entry has been Locked.Contact Your System Administrator!!!.');
        return;
    }
    if (ValueDateNumeric == -2209008600000) {
        cDeleteMsgPopUp.Show();
    }
    else {
        jAlert('Entry Already Been Tagged.Please Remove Tag To Delete Entry!!!.');
    }
}--%>
        function RecieveTextChange(s, e) {
            var RecieveValue = (grid.GetEditor('btnRecieve').GetValue() != null) ? parseFloat(grid.GetEditor('btnRecieve').GetValue()) : "0";
            var PaymentValue = (grid.GetEditor('btnPayment').GetValue() != null) ? grid.GetEditor('btnPayment').GetValue() : "0";
            if (RecieveValue > 0) {
                recalculateCredit(grid.GetEditor('btnPayment').GetValue());
                grid.GetEditor('btnPayment').SetValue("0");
            }
        }
        <%--function BindCashBankAccountList() {

    var CurrentSegment = document.getElementById('hdn_CurrentSegment').value;
    var Mode = document.getElementById("hdn_Mode").value;
    var strPutSegment = " and (MainAccount_ExchangeSegment=" + CurrentSegment + " or MainAccount_ExchangeSegment=0)";
    var strQuery_Table = "(Select MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ] \'+MainAccount_BankCashType as IntegrateMainAccount,MainAccount_AccountCode+\'~\'+MainAccount_BankCashType+\'~CASHBANK\' as MainAccount_AccountCode,MainAccount_Name,MainAccount_BankAcNumber from Master_MainAccount where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\') and (MainAccount_BankCompany=\'" + '<%=Session["LastCompany"] %>' + "\' Or IsNull(MainAccount_BankCompany,'')='') and (MainAccount_branchId=\'" + '<%=Session["userbranchID"] %>' + "\' Or IsNull(MainAccount_branchId,'')='0')" + strPutSegment + ") as t1";
    var strQuery_FieldName = " * ";
    var strQuery_WhereClause = "MainAccount_AccountCode like (\'%RequestLetter%\') or MainAccount_Name like (\'%RequestLetter%\') or MainAccount_BankAcNumber like (\'%RequestLetter%\')";
    var strQuery_OrderBy = '';
    var strQuery_GroupBy = '';
    var CombinedQuery = new String(strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_OrderBy + "$" + strQuery_GroupBy);
    var lBox = $('select[id$=lstCashItems]');
    var lstCashItems = [];
    //Customer or Lead radio button is clicked kaushik 21-11-2016
    lBox.empty();
    $.ajax({
        type: "POST",
        url: 'CashBankEntry.aspx/GetCashBankAccountList',
        data: "{CombinedQuery:\"" + CombinedQuery + "\",BranchID:0}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            var list = msg.d;
            if (list.length > 0) {

                for (var i = 0; i < list.length; i++) {
                    var id = '';
                    var name = '';
                    id = list[i].split('|')[1];
                    name = list[i].split('|')[0];
                    lstCashItems.push('<option value="' +
                    id + '">' + name
                    + '</option>');
                }
                $(lBox).append(lstCashItems.join(''));
                ListAccountBind();
                $('#lstCashItems').trigger("chosen:updated");
                $('#lstCashItems').prop('disabled', false).trigger("chosen:updated");

            }
            else {
                lBox.empty();
                //$(lBox).append(listItems.join(''));
                //ListBind();

                $('#lstCashItems').trigger("chosen:updated");
                $('#lstCashItems').prop('disabled', true).trigger("chosen:updated");

            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            jAlert(textStatus);
        }
    });
}--%>

        <%-- function CashBankTagged(key) {
            $('#<%=hdnEditClick.ClientID %>').val('T'); //Edit
            $('#<%=hdnJNMode.ClientID %>').val('1');//Edit            
            $('#<%= lblHeading.ClientID %>').text("View Cash/Bank Voucher");
            document.getElementById('DivEntry').style.display = 'block';
            document.getElementById('divExportto').style.display = 'none';
            document.getElementById('divAddButton').style.display = 'none';
            document.getElementById('gridFilter').style.display = 'none';
            document.getElementById('DivEdit').style.display = 'none';        
            $('#<%=hdn_Mode.ClientID %>').val('View');
            InsgridBatch.PerformCallback("ViewTagged~" + key);
            LoadingPanel.Show();
            chkAccount = 1;
            document.getElementById('divNumberingScheme').style.display = 'none';

            }--%>



        <%--function BindCashBankAccountListByBranch(BranchID) {

    var CurrentSegment = document.getElementById('hdn_CurrentSegment').value;
    var Mode = document.getElementById("hdn_Mode").value;
    var strPutSegment = " and (MainAccount_ExchangeSegment=" + CurrentSegment + " or MainAccount_ExchangeSegment=0)";
    var strQuery_Table = "(Select MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ] \'+MainAccount_BankCashType as IntegrateMainAccount,MainAccount_ReferenceID,MainAccount_AccountCode+\'~\'+MainAccount_BankCashType+\'~CASHBANK\' as MainAccount_AccountCode,MainAccount_Name,MainAccount_BankAcNumber from Master_MainAccount where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\') and (MainAccount_BankCompany=\'" + '<%=Session["LastCompany"] %>' + "\' Or IsNull(MainAccount_BankCompany,'')='') and (MainAccount_branchId=\'" + BranchID + "\' Or IsNull(MainAccount_branchId,'')='0')" + strPutSegment + ") as t1";
    var strQuery_FieldName = " * ";
    var strQuery_WhereClause = "MainAccount_AccountCode like (\'%RequestLetter%\') or MainAccount_Name like (\'%RequestLetter%\') or MainAccount_BankAcNumber like (\'%RequestLetter%\')";
    var strQuery_OrderBy = '';
    var strQuery_GroupBy = '';
    var CombinedQuery = new String(strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_OrderBy + "$" + strQuery_GroupBy);
    var lBox = $('select[id$=lstCashItems]');
    var lstCashItems = [];
    //Customer or Lead radio button is clicked kaushik 21-11-2016
    lBox.empty();
    $.ajax({
        type: "POST",
        url: 'CashBankEntry.aspx/GetCashBankAccountList',
        data: "{CombinedQuery:\"" + CombinedQuery + "\",BranchID:" + BranchID + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            var list = msg.d;
            if (list.length > 0) {
                for (var i = 0; i < list.length; i++) {

                    var id = '';
                    var name = '';
                    id = list[i].split('|')[1];
                    name = list[i].split('|')[0];

                    lstCashItems.push('<option value="' +
                    id + '">' + name
                    + '</option>');
                }
                $(lBox).append(lstCashItems.join(''));
                ListAccountBind();
                $('#lstCashItems').trigger("chosen:updated");
                $('#lstCashItems').prop('disabled', false).trigger("chosen:updated");

            }
            else {
                lBox.empty();
                $('#lstCashItems').trigger("chosen:updated");
                $('#lstCashItems').prop('disabled', true).trigger("chosen:updated");
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            jAlert(textStatus);
        }
    });
}--%>
        //function ListAccountBind() {
        //    var config = {
        //        '.chsn': {},
        //        '.chsn-deselect': { allow_single_deselect: true },
        //        '.chsn-no-single': { disable_search_threshold: 10 },
        //        '.chsn-no-results': { no_results_text: 'Oops, nothing found!' },
        //        '.chsn-width': { width: "100%" }
        //    }
        //    for (var selector in config) {
        //        $(selector).chosen(config[selector]);
        //    }
        //}
    </script>
    <%--Added By : Samrat Roy -- New Billing/Shipping Section--%>
    <script>
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
        function disp_prompt(name) {


            if (name == "tab0") {
                // gridLookup.Focus();
            }
            if (name == "tab1") {

            }
        }
        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }
    </script>
    <%--Added By : Samrat Roy -- New Billing/Shipping Section End--%>

    <script>
        function TaxAmountKeyDown(s, e) {
            if (e.htmlEvent.key == "Enter") {
                s.OnButtonClick(0);
            }
        }
        function taxAmtButnClick1(s, e) {
            rowEditCtrl = s;
        }
        function taxAmtButnClick(s, e) {
            var TaxAmountOngrid = InsgridBatch.GetEditor("TaxAmount").GetValue();
            $("#TaxAmountOngrid").val(TaxAmountOngrid);
            $("#VisibleIndexForTax").val(globalRowIndex);
            if (e.buttonIndex == 0) {
                InsgridBatch.batchEditApi.StartEdit(e.visibleIndex);
                var shippingStCode = '';
                shippingStCode = cbsSCmbState.GetText();
                var VoucherType = document.getElementById('rbtnType').value;
                document.getElementById('HdSerialNo1').value = InsgridBatch.GetEditor('SrlNo').GetText();
                if (cddl_AmountAre.GetValue() != '3') {
                    if (shippingStCode != '') {
                        //if (cComboType.GetValue() == "P") {
                        if (VoucherType == "P") {
                            if (InsgridBatch.GetEditor("ReverseApplicable").GetValue() == "0") {
                                showTax();
                            }
                            else {
                                if (cddl_AmountAre.GetValue() == '1') {
                                    jAlert("GST is applicable under Reverse Charge.", "Alert!!", function () {
                                        InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 7);
                                    });
                                }
                                else if (cddl_AmountAre.GetValue() == '2') {
                                    showTax();
                                }
                            }
                        }
                            //else if (cComboType.GetValue() == "R") {
                        else if (VoucherType == "R") {
                            showTax();
                        }
                    }
                    else {
                        //if (cComboType.GetValue() == "P") {
                        if (VoucherType == "P") {
                            if (InsgridBatch.GetEditor("ReverseApplicable").GetValue() == "0" && $("#IsTaxApplicable").val() != "" && $("#IsTaxApplicable").val() != null) {
                                jAlert("Please Enter Billing/Shipping Details to Calculate GST.", "Alert !!", function () {
                                    page.SetActiveTabIndex(1);
                                    cbsSave_BillingShipping.Focus();
                                    page.tabs[0].SetEnabled(false);
                                    $("#divcross").hide();
                                });
                            }
                        }
                            //else if (cComboType.GetValue() == "R") {
                        else if (VoucherType == "R") {
                            if ($("#IsTaxApplicable").val() != "" && $("#IsTaxApplicable").val() != null) {
                                jAlert("Please Enter Billing/Shipping Details to Calculate GST.", "Alert !!", function () {
                                    page.SetActiveTabIndex(1);
                                    cbsSave_BillingShipping.Focus();
                                    page.tabs[0].SetEnabled(false);
                                    $("#divcross").hide();
                                });
                            }
                            else {
                                showTax();
                            }

                        }
                    }
                }
                else {
                    jAlert("No Tax is applicable.", "Alert!!", function () {
                        InsgridBatch.batchEditApi.StartEdit(globalRowIndex, 7);
                    });
                }
            }
        }

        $(function () {
            $("#chk_reversemechenism").prop("disabled", false);
            $("#chk_reversemechenism").on("change", function () {
                if ($("#chk_reversemechenism").prop("checked") == true) {

                }
                else {

                }
            })
        });

        //Function for Date wise filteration
        //function updateGridByDate() {

        //    if (cFormDate.GetDate() == null) {
        //        jAlert('Please select from date.', 'Alert', function () { cFormDate.Focus(); });
        //    }
        //    else if (ctoDate.GetDate() == null) {
        //        jAlert('Please select to date.', 'Alert', function () { ctoDate.Focus(); });
        //    }
        //    else if (ccmbBranchfilter.GetValue() == null) {
        //        jAlert('Please select Branch.', 'Alert', function () { ccmbBranchfilter.Focus(); });
        //    }
        //    else {
        //        localStorage.setItem("FromDateCashBank", cFormDate.GetDate().format('yyyy-MM-dd'));
        //        localStorage.setItem("ToDateCashBank", ctoDate.GetDate().format('yyyy-MM-dd'));
        //        localStorage.setItem("BranchCashBank", ccmbBranchfilter.GetValue());
        //        cGvCBSearch.PerformCallback('FilterGridByDate~' + cFormDate.GetDate().format('yyyy-MM-dd') + '~' + ctoDate.GetDate().format('yyyy-MM-dd') + '~' + ccmbBranchfilter.GetValue());
        //    }
        //}
    </script>

    <style>
        #DivBilling [class^="col-md"], #DivShipping [class^="col-md"] {
            padding-top: 5px;
            padding-bottom: 5px;
        }

        .padTabtype2 > tbody > tr > td {
            padding: 0px 5px;
        }

            .padTabtype2 > tbody > tr > td > label {
                margin-bottom: 0 !important;
                margin-right: 15px;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfVSFileName" runat="server" />
    

    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="pull-left">
                <asp:Label ID="lblHeading" runat="server" Text="Cash/Bank Voucher Add"></asp:Label>

            </h3>
            <div id="pageheaderContent" class="pull-right wrapHolder reverse content horizontal-images" style="display: none;">
                <ul>
                    <li>
                        <div class="lblHolder">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Current Balance </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="width: 100%;">
                                                <b style="text-align: left" id="B_ImgSymbolBankBal" runat="server"></b>
                                                <b style="text-align: center" id="B_BankBalance" runat="server"></b>
                                            </div>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>

                    
                </ul>
            </div>
            <div id="btncross" runat="server" class="crossBtn" style="margin-left: 50px;"><a href="javascript:void(0);" onclick="ReloadPage()"</a><i class="fa fa-times"></i></a></div>
        </div>
    </div>
    <div class="form_main  clearfix">

        <div class="rgth pull-left full">
            <%--<div class="clearfix" id="btnAddNew">
                <div style="padding-right: 5px;">
                    <span id="divAddButton">
                        <% if (rights.CanAdd)
                           { %>

                        <a id="AddButton" style="display: none;" href="javascript:void(0);" onclick="AddButtonClick()" class="btn btn-primary"><span><u>A</u>dd New</span> </a>


                        <% } %>
                    </span>
                    <span id="divExportto">
                        <% if (rights.CanExport)
                           { %>

                        <asp:DropDownList ID="drdCashBank" runat="server" CssClass="btn btn-sm btn-primary expad" OnSelectedIndexChanged="drdCashBankExport_SelectedIndexChanged" AutoPostBack="true">
                            <asp:ListItem Value="0">Export to</asp:ListItem>
                            <asp:ListItem Value="1">PDF</asp:ListItem>
                            <asp:ListItem Value="2">XLS</asp:ListItem>
                            <asp:ListItem Value="3">RTF</asp:ListItem>
                            <asp:ListItem Value="4">CSV</asp:ListItem>
                        </asp:DropDownList>

                        <% } %>
                    </span>
                    <table class="padTabtype2 pull-right" id="gridFilter">
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

            </div>--%>
            <%--  <div id="DivEdit">
                <dxe:ASPxGridView ID="GvCBSearch" ClientInstanceName="cGvCBSearch" runat="server" AutoGenerateColumns="False"
                    KeyFieldName="CBID" Width="100%" SettingsBehavior-AllowFocusedRow="true"
                    OnCustomCallback="GvCBSearch_CustomCallback" OnCustomButtonInitialize="GvCBSearch_CustomButtonInitialize" OnDataBinding="GvCBSearch_DataBinding"
                    OnSummaryDisplayText="GvCBSearch_SummaryDisplayText"
                    Settings-HorizontalScrollBarMode="Auto"
                    SettingsCookies-Enabled="true" SettingsCookies-StorePaging="true" 
                    SettingsCookies-StoreFiltering="true" SettingsCookies-StoreGroupingAndSorting="true">
                    <SettingsBehavior ColumnResizeMode="NextColumn" />
                    <Columns>
                        <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="CashBank_TransactionType" Caption="Type" Settings-AllowAutoFilter="False">
                            <CellStyle CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="TransactionDate"
                            Caption="Date">
                            <CellStyle CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="VoucherNumber"
                            Caption="Voucher No." Width="300px">
                            <CellStyle CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="CashBank_Currency" Settings-AllowAutoFilter="False"
                            Caption="Currency" Width="6%">
                            <CellStyle CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="CashBankID" Settings-AllowAutoFilter="False"
                            Caption="Bank/Cash">
                            <CellStyle CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="6" FieldName="Amount" HeaderStyle-HorizontalAlign="Right" 
                            Caption="Amount">
                            <CellStyle HorizontalAlign="Right" CssClass="gridcellleft">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="7" FieldName="Total_taxable_amount" HeaderStyle-HorizontalAlign="Right" Settings-AllowAutoFilter="False"
                            Caption="Taxable Amount">
                            <CellStyle Wrap="true" CssClass="gridcellleft">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="8" FieldName="Total_CGST" Settings-AllowAutoFilter="False"
                            Caption="CGST">
                            <CellStyle Wrap="true" CssClass="gridcellleft">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="9" FieldName="Total_SGST" Settings-AllowAutoFilter="False"
                            Caption="SGST">
                            <CellStyle Wrap="true" CssClass="gridcellleft">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="10" FieldName="Total_UTGST" Settings-AllowAutoFilter="False"
                            Caption="UTGST">
                            <CellStyle Wrap="true" CssClass="gridcellleft">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="11" FieldName="Total_IGST" Settings-AllowAutoFilter="False"
                            Caption="IGST">
                            <CellStyle Wrap="true" CssClass="gridcellleft">
                            </CellStyle>
                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="12" FieldName="EnteredBranchName" Settings-AllowAutoFilter="False"
                            Caption="Entered Branch">
                            <CellStyle Wrap="true" CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="13" FieldName="ForBranchName" Settings-AllowAutoFilter="False"
                            Caption="For Branch">
                            <CellStyle Wrap="true" CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="14" FieldName="CashBank_CreateUser" Settings-AllowAutoFilter="False"
                            Caption="Entered By">
                            <CellStyle HorizontalAlign="left" CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="15" FieldName="CashBank_CreateDateTime" Settings-AllowAutoFilter="False"
                            Caption="Last Update On">
                            <CellStyle HorizontalAlign="Right" CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="16" FieldName="CashBank_ModifyUser" Settings-AllowAutoFilter="False"
                            Caption="Updated By">
                            <CellStyle HorizontalAlign="left" CssClass="gridcellleft">
                            </CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewCommandColumn VisibleIndex="17" Caption="Actions" ButtonType="Image" HeaderStyle-HorizontalAlign="Center" Width="100px">
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
                            </CustomButtons>
                        </dxe:GridViewCommandColumn>
                        <dxe:GridViewDataTextColumn Visible="False" FieldName="CBID">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Visible="False" FieldName="IBRef">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Visible="False" FieldName="ExchangeSegmentID">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Visible="False" FieldName="MaxLockDate">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Visible="False" FieldName="ValueDate">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn Visible="False" FieldName="BankStatementDate">
                        </dxe:GridViewDataTextColumn>
                    </Columns>
                    <TotalSummary>
                        <dxe:ASPxSummaryItem FieldName="Amount" SummaryType="Sum" />
                        <dxe:ASPxSummaryItem FieldName="Total_taxable_amount" SummaryType="Sum" />
                        <dxe:ASPxSummaryItem FieldName="Total_CGST" SummaryType="Sum" />
                        <dxe:ASPxSummaryItem FieldName="Total_SGST" SummaryType="Sum" />
                        <dxe:ASPxSummaryItem FieldName="Total_UTGST" SummaryType="Sum" />
                        <dxe:ASPxSummaryItem FieldName="Total_IGST" SummaryType="Sum" />
                    </TotalSummary>
                    <Settings ShowGroupPanel="True" HorizontalScrollBarMode="Visible" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" ShowFooter="true"
                        ShowGroupFooter="VisibleIfExpanded" />
                    <SettingsPager NumericButtonCount="10" PageSize="10" ShowSeparators="True" Mode="ShowPager">
                        <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                    </SettingsPager>

                 
                    <ClientSideEvents CustomButtonClick="CustomButtonClick" EndCallback="function(s, e) {GvCBSearch_EndCallBack();}" />
                </dxe:ASPxGridView>

            </div>--%>
            <div id="DivEntry">
                <dxe:PanelContent runat="server">
                    <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ClientInstanceName="page" Width="100%">
                        <TabPages>
                            <dxe:TabPage Name="General" Text="General">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                        <dxe:ASPxCallbackPanel runat="server" ID="ASPxCallbackGeneral" ClientInstanceName="cASPxCallbackGeneral">
                                            <PanelCollection>
                                                <dxe:PanelContent runat="server">
                                                    <div id="divChangable" runat="server" style="background: #f5f4f3; padding: 5px 0 5px 0; margin-bottom: 0px; border-radius: 4px; border: 1px solid #ccc; margin-bottom: 15px;">
                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <div class="col-md-2">
                                                                    <label for="exampleInputName2" style="margin-top: 8px">
                                                                        Voucher Type <b id="bTypeText" runat="server" style="width: 20%; display: none; font-size: 12px"></b>
                                                                    </label>
                                                                    <div>
                                                                        <asp:DropDownList ID="rbtnType" runat="server" Width="100%" onchange="rbtnType_SelectedIndexChanged()">
                                                                            <asp:ListItem Text="Receipt" Value="R" />
                                                                            <asp:ListItem Text="Payment" Value="P" />
                                                                        </asp:DropDownList>
                                                                        <%--  <dxe:ASPxComboBox ID="rbtnType" runat="server" ClientInstanceName="cComboType" Font-Size="12px"
                                                                            ValueType="System.String" Width="100%" EnableIncrementalFiltering="True">
                                                                            <Items>
                                                                                <dxe:ListEditItem Value="R" Text="Receipt"></dxe:ListEditItem>
                                                                                <dxe:ListEditItem Value="P" Text="Payment"></dxe:ListEditItem>
                                                                            </Items>
                                                                            <ClientSideEvents SelectedIndexChanged="rbtnType_SelectedIndexChanged" GotFocus="VoucherType_GotFocus" />
                                                                        </dxe:ASPxComboBox>--%>
                                                                        <%--  <div style="display: none">
                                                                            <asp:RadioButtonList ID="ComboType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" Width="100%">
                                                                                <asp:ListItem Value="R" Text="Receipt" Selected></asp:ListItem>
                                                                                <asp:ListItem Value="P" Text="Payment"></asp:ListItem>
                                                                            </asp:RadioButtonList>
                                                                        </div>--%>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2" id="divNumberingScheme" runat="server">
                                                                    <label style="margin-top: 8px">Numbering Scheme</label>
                                                                    <label>
                                                                        <dxe:ASPxComboBox ID="CmbScheme" EnableIncrementalFiltering="True" ClientInstanceName="cCmbScheme"
                                                                            SelectedIndex="0" EnableCallbackMode="false"
                                                                            TextField="SchemaName" ValueField="ID"
                                                                            runat="server" ValueType="System.String" Width="100%" EnableSynchronization="True" OnCallback="CmbScheme_Callback">
                                                                            <ClientSideEvents ValueChanged="function(s,e){CmbScheme_ValueChange()}"  EndCallback="CmbSchemeEndCallback"></ClientSideEvents>
                                                                        </dxe:ASPxComboBox>
                                                                      <%--  GotFocus="NumberingScheme_GotFocus"--%>
                                                                        <span id="MandatoryNumberingScheme" class="iconNumberScheme pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                                                    </label>
                                                                </div>
                                                                <div class="col-md-2 lblmTop8" style="display: none" id="divEnterBranch" runat="server">

                                                                    <label>Branch <span style="color: red">*</span></label>
                                                                    <div>
                                                                        <asp:DropDownList ID="ddlEnterBranch" runat="server" DataSourceID="dsBranch"
                                                                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%">
                                                                        </asp:DropDownList>

                                                                    </div>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <label style="margin-top: 8px">Voucher No.</label>
                                                                    <div>
                                                                        <asp:TextBox ID="txtVoucherNo" runat="server" Width="100%" MaxLength="30" onchange="txtBillNo_TextChanged()">                             
                                                                        </asp:TextBox>
                                                                        <span id="MandatoryBillNo" class="voucherno  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                                                    </div>
                                                                </div>

                                                                <div class="col-md-2">
                                                                    <label style="margin-top: 8px">Voucher Date  </label>
                                                                    <div>
                                                                        <dxe:ASPxDateEdit ID="dtTDate" runat="server" ClientInstanceName="cdtTDate" EditFormat="Custom"
                                                                            Font-Size="12px" UseMaskBehavior="True" Width="100%" EditFormatString="dd-MM-yyyy" CssClass="pull-left">
                                                                            <ButtonStyle Width="13px"></ButtonStyle>
                                                                            <ClientSideEvents DateChanged="function(s,e){TDateChange();}" GotFocus="function(s,e){cdtTDate.ShowDropDown();}"></ClientSideEvents>
                                                                        </dxe:ASPxDateEdit>
                                                                    </div>
                                                                </div>

                                                                <div class="col-md-2 lblmTop8">
                                                                    <label>For Branch <span style="color: red">*</span></label>
                                                                    <div>
                                                                        <asp:DropDownList ID="ddlBranch" runat="server" onchange="ddlBranch_SelectedIndexChanged()"
                                                                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%">
                                                                        </asp:DropDownList>
                                                                        <span id="MandatoryBranch" class="iconBranch pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>

                                                                    </div>
                                                                </div>
                                                                <div class="clear"></div>
                                                                <div style="border-top: 1px solid #ccc; margin-top: 8px; height: 10px;">
                                                                </div>
                                                                <div class="clear"></div>
                                                                <div class="col-md-2" id="tdCashBankLabel">
                                                                    <label>Cash/Bank</label>
                                                                    <div>
                                                                        <dxe:ASPxComboBox ID="ddlCashBank" runat="server" ClientInstanceName="cddlCashBank" Width="100%" OnCallback="ddlCashBank_Callback">
                                                                            <ClientSideEvents EndCallback="CashBank_EndCallback" SelectedIndexChanged="CashBank_SelectedIndexChanged" GotFocus="CashBank_GotFocus" KeyDown="CashBank_GotFocus" />
                                                                        </dxe:ASPxComboBox>
                                                                        <span id="MandatoryCashBank" class="iconCashBank pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>

                                                                    </div>
                                                                </div>
                                                                <div class="col-md-1">
                                                                    <label>Currency  </label>
                                                                    <div>
                                                                        <dxe:ASPxComboBox ID="CmbCurrency" EnableIncrementalFiltering="True" ClientInstanceName="cCmbCurrency"
                                                                            TextField="Currency_AlphaCode" ValueField="Currency_ID" SelectedIndex="0" Native="true"
                                                                            runat="server" ValueType="System.String" EnableSynchronization="True" Width="100%" CssClass="pull-left">
                                                                            <ClientSideEvents ValueChanged="function(s,e){Currency_Rate()}" GotFocus="function(s,e){cCmbCurrency.ShowDropDown();}"></ClientSideEvents>
                                                                        </dxe:ASPxComboBox>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-1">
                                                                    <label>Rate  </label>
                                                                    <div>
                                                                        <dxe:ASPxTextBox runat="server" ID="txtRate" HorizontalAlign="Right" ClientInstanceName="ctxtRate" Width="100%" CssClass="pull-left">
                                                                            <MaskSettings Mask="<0..9999>.<0..99999>" IncludeLiterals="DecimalSymbol" />
                                                                        </dxe:ASPxTextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2">
                                                                    <label style="">Instrument Type</label>
                                                                    <div style="">
                                                                        <dxe:ASPxComboBox ID="cmbInstrumentType" runat="server" ClientInstanceName="cComboInstrumentTypee" Font-Size="12px"
                                                                            ValueType="System.String" Width="100%" EnableIncrementalFiltering="True" Native="true">
                                                                            <Items>
                                                                                <dxe:ListEditItem Text="Cheque" Value="C" Selected />
                                                                                <dxe:ListEditItem Text="Draft" Value="D" />
                                                                                <dxe:ListEditItem Text="E.Transfer" Value="E" />
                                                                                <dxe:ListEditItem Text="Cash" Value="CH" />
                                                                            </Items>
                                                                            <ClientSideEvents SelectedIndexChanged="InstrumentTypeSelectedIndexChanged" GotFocus="function(s,e){cComboInstrumentTypee.ShowDropDown();}" />
                                                                        </dxe:ASPxComboBox>
                                                                        <span id="MandatoryInstrumentType" class="iconInstrumentType pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2" id="divInstrumentNo" style="">
                                                                    <label id="" style="">Instrument No</label>
                                                                    <div id="">
                                                                        <dxe:ASPxTextBox runat="server" ID="txtInstNobth" ClientInstanceName="ctxtInstNobth" Width="100%" MaxLength="30" CssClass="pull-left">
                                                                        </dxe:ASPxTextBox>
                                                                        <span id="MandatoryInstNo" class="iconInstNo pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2" id="tdIDateDiv" style="">
                                                                    <label id="tdIDateLable" style="">Instrument Date</label>
                                                                    <div id="tdIDateValue" style="">
                                                                        <dxe:ASPxDateEdit ID="InstDate" runat="server" EditFormat="Custom" ClientInstanceName="cInstDate"
                                                                            UseMaskBehavior="True" Font-Size="12px" Width="100%" EditFormatString="dd-MM-yyyy">
                                                                            <%--<ClientSideEvents DateChanged="function(s,e){InstrumentDateChange();}" GotFocus="function(s,e){cInstDate.ShowDropDown();}"></ClientSideEvents>--%>
                                                                            <ClientSideEvents DateChanged="function(s,e){InstrumentDateChange();}"></ClientSideEvents>
                                                                            <ButtonStyle Width="13px">
                                                                            </ButtonStyle>
                                                                        </dxe:ASPxDateEdit>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2" id="divDraweeBank">
                                                                    <label>Drawee Bank</label>
                                                                    <div>
                                                                        <asp:TextBox ID="txtDraweeBank" runat="server" Width="100%">                             
                                                                        </asp:TextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="clear"></div>
                                                                <div class="col-md-3 lblmTop8" id="divReceivedfrom" style="display: none;">
                                                                    <label id="" style="">Received From</label>
                                                                    <div id="">
                                                                        <dxe:ASPxTextBox runat="server" ID="txtReceivedFrom" ClientInstanceName="ctxtReceivedFrom" Width="100%" MaxLength="30">
                                                                        </dxe:ASPxTextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-3 lblmTop8" id="divPaidTo" style="">
                                                                    <label id="" style="">Paid To</label>
                                                                    <div id="">
                                                                        <dxe:ASPxTextBox runat="server" ID="txtPaidTo" ClientInstanceName="ctxtPaidTo" Width="100%" MaxLength="30">
                                                                        </dxe:ASPxTextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2 lblmTop8">
                                                                    <label>Contact </label>
                                                                    <div>
                                                                        <asp:TextBox ID="txtContact" runat="server" MaxLength="20"
                                                                            Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-3 lblmTop8">
                                                                    <label>Narration </label>
                                                                    <div>
                                                                        <asp:TextBox ID="txtNarration" runat="server" MaxLength="500" onkeydown="checkTextAreaMaxLength(this,event,'500');"
                                                                            TextMode="MultiLine"
                                                                            Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2 lblmTop8" style="display: none;">
                                                                    <label>Reverse Charge </label>
                                                                    <div>
                                                                        <asp:CheckBox ID="chk_reversemechenism" runat="server"></asp:CheckBox>
                                                                    </div>
                                                                </div>
                                                                <div class="col-md-2 lblmTop8">
                                                                    <label><dxe:ASPxLabel ID="lbl_AmountAre" runat="server" Text="Amounts are">
                                                                    </dxe:ASPxLabel></label>
                                                                    <dxe:ASPxComboBox ID="ddl_AmountAre" runat="server" ClientIDMode="Static" ClientInstanceName="cddl_AmountAre"
                                                                        Width="100%" Native="true">

                                                                        <ClientSideEvents LostFocus="function(s, e) { cddl_AmountAre_LostFocus()}" />
                                                                    </dxe:ASPxComboBox>
                                                                </div>
                                                                <div class="clear"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <dxe:ASPxGridView runat="server" ClientInstanceName="InsgridBatch" ID="gridBatch" KeyFieldName="CashBankID"
                                                        OnBatchUpdate="gridBatch_BatchUpdate"
                                                        OnCellEditorInitialize="gridBatch_CellEditorInitialize"
                                                        OnDataBinding="gridBatch_DataBinding"
                                                        Width="100%" Settings-ShowFooter="true"
                                                        SettingsBehavior-AllowSort="false"
                                                        SettingsBehavior-AllowDragDrop="false"
                                                        OnCustomCallback="gridBatch_CustomCallback"
                                                        SettingsPager-Mode="ShowAllRecords"
                                                        Settings-VerticalScrollBarMode="auto"
                                                        Settings-VerticalScrollableHeight="170"
                                                        OnRowInserting="Grid_RowInserting"
                                                        OnRowUpdating="Grid_RowUpdating"
                                                        OnRowDeleting="Grid_RowDeleting"
                                                        OnHtmlRowPrepared="gridBatch_HtmlRowPrepared">
                                                        <SettingsPager Visible="false"></SettingsPager>
                                                        <Columns>
                                                            <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="4%" VisibleIndex="0" Caption="">
                                                                <CustomButtons>
                                                                    <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomDelete" Image-Url="/assests/images/crs.png">
                                                                    </dxe:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dxe:GridViewCommandColumn>
                                                            <dxe:GridViewDataTextColumn FieldName="SrlNo" Caption="Sl" ReadOnly="true" VisibleIndex="1" Width="5%">
                                                                <PropertiesTextEdit>
                                                                </PropertiesTextEdit>
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataButtonEditColumn FieldName="MainAccount" Caption="Main Account" VisibleIndex="2">
                                                            <PropertiesButtonEdit>
                                                                <ClientSideEvents ButtonClick="MainAccountButnClick" KeyDown="MainAccountKeyDown" />
                                                                <Buttons>
                                                                    <dxe:EditButton Text="..." Width="20px">
                                                                    </dxe:EditButton>
                                                                </Buttons>
                                                            </PropertiesButtonEdit>
                                                        </dxe:GridViewDataButtonEditColumn>
                                                           

                                                         <%--   <dxe:GridViewDataComboBoxColumn Caption="Main Account" FieldName="MainAccount" VisibleIndex="2" Width="220">
                                                                <PropertiesComboBox ClientInstanceName="MainAccount" ValueField="AccountCode" TextField="IntegrateMainAccount"
                                                                    ClearButton-DisplayMode="Always" AllowMouseWheel="false">
                                                                    <ClientSideEvents ValueChanged="CountriesCombo_SelectedIndexChanged" GotFocus="EnableOrDisableTax" />
                                                                    <ValidationSettings RequiredField-IsRequired="false" Display="None"></ValidationSettings>
                                                                </PropertiesComboBox>
                                                            </dxe:GridViewDataComboBoxColumn>--%>
                                                            <dxe:GridViewDataButtonEditColumn FieldName="bthSubAccount" Caption="Sub Account" VisibleIndex="3">
                                                            <PropertiesButtonEdit>
                                                                <ClientSideEvents ButtonClick="SubAccountButnClick" KeyDown="SubAccountKeyDown" />
                                                                <Buttons>
                                                                    <dxe:EditButton Text="..." Width="20px">
                                                                    </dxe:EditButton>
                                                                </Buttons>
                                                            </PropertiesButtonEdit>
                                                        </dxe:GridViewDataButtonEditColumn>
                                                      
                                                         <%--   <dxe:GridViewDataComboBoxColumn Caption="Sub Account" VisibleIndex="3" FieldName="bthSubAccount" Width="220">
                                                                <PropertiesComboBox ValueField="SubAccount_ReferenceID" TextField="SubAccount_Name"  FilterMinLength="4">
                                                                </PropertiesComboBox>
                                                                <EditItemTemplate>
                                                                    <dxe:ASPxComboBox runat="server" Width="100%" EnableIncrementalFiltering="true" ClearButton-DisplayMode="Always" TextField="SubAccount_Name" OnCallback="SubAccount_Callback"
                                                                        EnableCallbackMode="true" OnInit="SubAccount_Init" AllowMouseWheel="false"
                                                                        ValueField="SubAccount_ReferenceID" ID="SubAccountCmb" ClientInstanceName="SubAccount_ReferenceID">
                                                                        <ClientSideEvents EndCallback="SubAccountCombo_EndCallback" />
                                                                        <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>
                                                                    </dxe:ASPxComboBox>
                                                                </EditItemTemplate>
                                                            </dxe:GridViewDataComboBoxColumn>--%>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="4" Caption="Receipt" FieldName="btnRecieve" Width="130" HeaderStyle-HorizontalAlign="Right">
                                                                <PropertiesTextEdit Style-HorizontalAlign="Right">
                                                                    <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" />
                                                                    <ClientSideEvents KeyDown="OnKeyDown" LostFocus="ReceiptTextChange"
                                                                        GotFocus="function(s,e){
                                                                        DebitGotFocus(s,e); 
                                                                        }" />
                                                                    <ClientSideEvents />
                                                                </PropertiesTextEdit>
                                                                <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="5" Caption="Payment" FieldName="btnPayment" Width="130" HeaderStyle-HorizontalAlign="Right">
                                                                <PropertiesTextEdit Style-HorizontalAlign="Right">
                                                                    <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" />
                                                                    <ClientSideEvents KeyDown="OnKeyDown" LostFocus="PaymentTextChange"
                                                                        GotFocus="function(s,e){
                                                        CreditGotFocus(s,e);
                                                        }" />
                                                                    <ClientSideEvents />

                                                                </PropertiesTextEdit>
                                                                <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>

                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataButtonEditColumn FieldName="TaxAmount" Caption="Charges" VisibleIndex="6" Width="10%" HeaderStyle-HorizontalAlign="Right">
                                                                <PropertiesButtonEdit Style-HorizontalAlign="Right">
                                                                    <ClientSideEvents ButtonClick="taxAmtButnClick" GotFocus="taxAmtButnClick1" KeyDown="TaxAmountKeyDown" />
                                                                    <Buttons>
                                                                        <dxe:EditButton Text="..." Width="20px">
                                                                        </dxe:EditButton>
                                                                    </Buttons>
                                                                    <MaskSettings Mask="&lt;-999999999999..999999999999&gt;.&lt;00..99&gt;" />
                                                                </PropertiesButtonEdit>
                                                                <CellStyle HorizontalAlign="Right"></CellStyle>
                                                            </dxe:GridViewDataButtonEditColumn>
                                                            <dxe:GridViewDataTextColumn FieldName="NetAmount" Caption="Net Amount" VisibleIndex="7" Width="12%" HeaderStyle-HorizontalAlign="Right">
                                                                <PropertiesTextEdit Style-HorizontalAlign="Right">
                                                                    <MaskSettings Mask="&lt;-999999999999..999999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                                                                </PropertiesTextEdit>
                                                                <CellStyle HorizontalAlign="Right"></CellStyle>
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn VisibleIndex="8" Caption="Remarks" FieldName="btnLineNarration" Width="160">
                                                                <PropertiesTextEdit>
                                                                </PropertiesTextEdit>
                                                                <CellStyle Wrap="False" HorizontalAlign="Left" CssClass="gridcellleft"></CellStyle>
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="30" VisibleIndex="9" Caption=" ">
                                                                <CustomButtons>
                                                                    <dxe:GridViewCommandColumnCustomButton Text=" " ID="AddNew" Image-Url="/assests/images/add.png">
                                                                        <Image Url="/assests/images/add.png">
                                                                        </Image>
                                                                    </dxe:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dxe:GridViewCommandColumn>
                                                            <dxe:GridViewDataTextColumn FieldName="CashBankID" Caption="Srl No" ReadOnly="true" HeaderStyle-CssClass="hide" Width="0">
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn FieldName="ReverseApplicable" Caption="Srl No" ReadOnly="true" HeaderStyle-CssClass="hide" Width="0">
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn FieldName="TDS" Caption="TDS" ReadOnly="true" HeaderStyle-CssClass="hide" Width="0">
                                                            </dxe:GridViewDataTextColumn>
                                                             <dxe:GridViewDataTextColumn FieldName="gvColMainAccount" Caption="hidden Field Id"   Width="0" HeaderStyle-CssClass="hide">                                                               
                                                            </dxe:GridViewDataTextColumn>
                                                            <dxe:GridViewDataTextColumn FieldName="gvColSubAccount" Caption="hidden Field Id"  Width="0" HeaderStyle-CssClass="hide" >                                                            
                                                            </dxe:GridViewDataTextColumn>
                                                        </Columns>
                                                         <ClientSideEvents Init="OnInit" EndCallback="OnEndCallback" BatchEditStartEditing="OnBatchEditStartEditing"
                                                            CustomButtonClick="OnCustomButtonClick" RowClick="GetVisibleIndex" />
                                                       <%-- <ClientSideEvents Init="OnInit" EndCallback="OnEndCallback" BatchEditStartEditing="OnBatchEditStartEditing" BatchEditEndEditing="OnBatchEditEndEditing"
                                                            CustomButtonClick="OnCustomButtonClick" RowClick="GetVisibleIndex" />--%>
                                                        <SettingsDataSecurity AllowEdit="true" />
                                                        <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                                                            <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="Row" />
                                                        </SettingsEditing>
                                                        <Styles>
                                                            <StatusBar CssClass="statusBar">
                                                            </StatusBar>
                                                        </Styles>
                                                    </dxe:ASPxGridView>
                                                    <div class="text-center">
                                                        <table style="margin-left: 354px; margin-top: 10px">
                                                            <tr>
                                                                <td style="padding-right: 50px"><b>Total Amount</b></td>
                                                                <td style="width: 203px;">
                                                                    <dxe:ASPxTextBox ID="txtTotalAmount" runat="server" Width="105px" ClientInstanceName="c_txt_Debit" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">

                                                                        <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                                                                    </dxe:ASPxTextBox>
                                                                </td>
                                                                <td>
                                                                    <dxe:ASPxTextBox ID="txtTotalPayment" runat="server" Width="105px" ClientInstanceName="ctxtTotalPayment" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">

                                                                        <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                                                                    </dxe:ASPxTextBox>
                                                                </td>
                                                                <td style="padding-right: 50px; padding-left: 44px; display: none;"><b>Total Net Amount</b></td>
                                                                <td style="width: 203px; display: none;">
                                                                    <dxe:ASPxTextBox ID="txtTotalNetAmount" runat="server" Width="105px" ClientInstanceName="c_txtTotalNetAmount" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">

                                                                        <MaskSettings Mask="&lt;-999999999999..999999999999&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                                                                    </dxe:ASPxTextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <table style="width: 100%;" id="BtnTable">
                                                        <tr>
                                                            <td style="padding: 15px 0;">
                                                                <span>
                                                                      <%-- <% if (rights.CanAdd)
                                                                        { %>
                                                                    <a>--%>
                                                                    <dxe:ASPxButton ID="btnSaveNew" ClientInstanceName="cbtnSaveNew" runat="server"
                                                                        AutoPostBack="false" CssClass="btn btn-primary" TabIndex="0" Text="S&#818;ave & New"
                                                                        UseSubmitBehavior="False">
                                                                        <ClientSideEvents Click="function(s, e) {SaveButtonClickNew();}" />
                                                                    </dxe:ASPxButton>
                                                                     <%--   </a>
                                                                      <% } %>--%>
                                                                </span>
                                                                <span id="tdSaveButton">
                                                                    <dxe:ASPxButton ID="btnSaveRecords" ClientInstanceName="cbtnSaveRecords" runat="server"
                                                                        AutoPostBack="false" CssClass="btn btn-primary" TabIndex="0" Text="Save & Ex&#818;it"
                                                                        UseSubmitBehavior="False">
                                                                        <ClientSideEvents Click="function(s, e) {SaveButtonClick();}" />
                                                                    </dxe:ASPxButton>

                                                                </span>

                                                            </td>
                                                        </tr>
                                                    </table>
                                                </dxe:PanelContent>
                                            </PanelCollection>
                                            <%--  <ClientSideEvents EndCallback="acpEndCallbackGeneral" />--%>
                                        </dxe:ASPxCallbackPanel>
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Name="Billing/Shipping" Text="Billing/Shipping">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                        <ucBS:BillingShippingControl runat="server" ID="BillingShippingControl" />
                                        <asp:HiddenField runat="server" ID="hfTermsConditionDocType" Value="CBE" />
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                        </TabPages>
                        <ClientSideEvents ActiveTabChanged="function(s, e) {
	                                            var activeTab = page.GetActiveTab();
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
                </dxe:PanelContent>

            </div>

            <div id="HiddenField">
              <%--  <asp:HiddenField ID="hdnDefaultBranch" runat="server" />
                <asp:HiddenField ID="hdnType" runat="server" />
                <asp:HiddenField ID="hdnAccountType" runat="server" />
                <asp:HiddenField ID="txtMainAccount_hidden" runat="server" />
                <asp:HiddenField ID="txtSubAccount_hidden" runat="server" />
                <asp:HiddenField ID="hdn_Brch_NonBrch" runat="server" />
                <asp:HiddenField ID="hdn_SubLedgerType" runat="server" />
                <asp:HiddenField ID="hdn_MainAcc_Type" runat="server" />
                <asp:HiddenField ID="hdn_SubAccountIDE" runat="server" />
                <asp:HiddenField ID="txtBankAccounts_hidden" runat="server" />--%>
                <input type="hidden" id="IsTaxApplicable" value="" />
                <asp:HiddenField ID="hdn_Mode" runat="server" Value="Edit" />
               <%-- <asp:HiddenField ID="hdn_PayeeIDOnUpdate" runat="server" />
                <asp:HiddenField ID="hdn_Brch_NonBrchE" runat="server" />
                <asp:HiddenField ID="hdn_CurrentSegment" runat="server" />--%>
                <asp:HiddenField ID="hdn_CashBankType_InstType" runat="server" />
                <asp:HiddenField ID="hdn_SegID_SegmentName" runat="server" />
              <%--  <asp:HiddenField ID="hdn_EditVoucher_SegmentID_Name" runat="server" />
                <asp:HiddenField ID="hdn_OriginalTDate" runat="server" />--%>
                <asp:HiddenField ID="hdnCashBankId" runat="server" />
                <asp:HiddenField ID="hdnCashBankText" runat="server" />
                <asp:HiddenField ID="hdnMainAccountId" runat="server" />
                <%--<asp:HiddenField ID="hdnMainAccountText" runat="server" />--%>
             <%--   <asp:HiddenField ID="hdnSubAccountId" runat="server" />--%>
              <%--  <asp:HiddenField ID="hdnSubAccountText" runat="server" />--%>
                <asp:HiddenField ID="hdnBranchId" runat="server" />
                <asp:HiddenField ID="hfIsFilter" runat="server" />
                <asp:HiddenField ID="TaxAmountOngrid" runat="server" />
                <asp:HiddenField ID="VisibleIndexForTax" runat="server" />

                
              <%--  <asp:HiddenField ID="hdnBranchText" runat="server" />--%>
              <%--  <asp:HiddenField ID="hdnIssueBankId" runat="server" />--%>
              <%--  <asp:HiddenField ID="hdnIssueBankText" runat="server" />--%>
                <asp:HiddenField ID="hdnJNMode" runat="server" />
              <%--  <asp:HiddenField ID="hdnReceive" runat="server" />--%>
            <%--    <asp:HiddenField ID="hdnMainAccountEId" runat="server" />--%>
               <%-- <asp:HiddenField ID="hdnMainAccountEText" runat="server" />--%>
              <%--  <asp:HiddenField ID="hdnMainAccountChange" runat="server" />--%>
                <asp:HiddenField ID="hdnBtnClick" runat="server" />
              <%--  <asp:HiddenField ID="hdnSegmentid" runat="server" />--%>
                <asp:HiddenField ID="hdnRefreshType" runat="server" />
                <asp:HiddenField ID="hdnSchemaType" runat="server" />

                <asp:HiddenField ID="hdnInstrumentType" runat="server" />
                <asp:HiddenField ID="hdnInstrumentNo" runat="server" />
                <asp:HiddenField ID="hdnCurrenctId" runat="server" />
                <asp:HiddenField ID="hdnEditClick" runat="server" />
              <%--  <asp:HiddenField ID="HdnbranchIDSession" runat="server" />--%>
                <asp:HiddenField ID="hdfIsDelete" runat="server" />
                <asp:HiddenField ID="hdnEditCBID" runat="server" />
                <asp:HiddenField ID="hdnEditRfid" runat="server" />
                <asp:HiddenField ID="hdnPayment" runat="server" />
                <asp:HiddenField ID="hdnTaxGridBind" runat="server" />
                <asp:HiddenField ID="hdnPageStatus" runat="server" />
                <asp:HiddenField ID="hdnAutoPrint" runat="server" />
                <asp:HiddenField ID="hdnView" runat="server" />
                <%-- <asp:HiddenField ID="hdnCheckAdd" runat="server" />
               --%>
            </div>
            <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
                <ClientSideEvents ControlsInitialized="AllControlInitilize" />
            </dxe:ASPxGlobalEvents>
            <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
            </dxe:ASPxGridViewExporter>
              <asp:SqlDataSource ID="SqlDataSourceMainAccount" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                SelectCommand=""></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSourceSubAccount" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                SelectCommand=""></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlSchematype" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                SelectCommand=""></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                SelectCommand="Select * From ((Select '0' as Currency_ID , 'Select' as Currency_AlphaCode) Union select Currency_ID,Currency_AlphaCode from Master_Currency )tbl Order By Currency_ID"></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlCurrencyBind" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"></asp:SqlDataSource>

           <%-- -------------------POPUPControl   FOR Main & Sub Account-------------------------------------%>
             <dxe:ASPxPopupControl ID="MainAccountpopUp" runat="server" ClientInstanceName="cMainAccountpopUp"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Height="400"
        Width="700" HeaderText="Select Main Account" AllowResize="true" ResizingMode="Postponed" Modal="true">
                  <HeaderTemplate>
                         <span style="color: #fff"><strong>Search By Main Account (4 Char)</strong></span>
                        <dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                                            <ClientSideEvents Click="function(s, e){ 
                                                                       MainAccountClose();
                                                                    }" />
                                        </dxe:ASPxImage>
                    </HeaderTemplate>
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
                <label><strong>Search By Main Account(4 Char)</strong> <span style="color:red"> [Press Esc to Cancel]</span></label>
                 <div id="mainActMsg">
                   <span style="color: red;  right: 46px;"  ><strong>* Invalid Main Account</strong> </span>
                       </div>
                  <dxe:ASPxComboBox ID="MainAccountComboBox" runat="server" EnableCallbackMode="true" CallbackPageSize="10" Width="100%"                    
                    ValueType="System.String" ValueField="MainAccount_ReferenceID" ClientInstanceName="cMainAccountComboBox"
                    OnItemsRequestedByFilterCondition="ASPxMainAccountComboBox_OnItemsRequestedByFilterCondition_SQL" 
                      OnItemRequestedByValue="ASPxMainComboBox_OnItemRequestedByValue_SQL"
                      FilterMinLength="4" 
                     TextFormatString="{0}"
                    DropDownStyle="DropDown" >
                   
                    <Columns>
                        <dxe:ListBoxColumn FieldName="MainAccount_Name" Caption="Main Account Name" Width="320px" />
                        <dxe:ListBoxColumn FieldName="MainAccount_SubLedgerType" Caption="Sub Account Type" Width="150px" />
                        <dxe:ListBoxColumn FieldName="MainAccount_ReverseApplicable" Caption="ReverseApplicable" Width="0"  />
                        <dxe:ListBoxColumn FieldName="TAXable" Caption="TAXable" Width="0"  />          
                    </Columns>
                    <ClientSideEvents ValueChanged="function(s, e) {GetMainAcountComboBox(e)}"  KeyDown="MainAccountComboBoxKeyDown" />
                </dxe:ASPxComboBox>
              <%--  <dxe:ASPxGridLookup ID="MainAccountLookUp" runat="server" DataSourceID="EntityServerMainDataSource" ClientInstanceName="cMainAccountLookUp"
                    KeyFieldName="MainAccount_ReferenceID" Width="800" TextFormatString="{0}" ClientSideEvents-TextChanged="MainAccountSelected" 
                    ClientSideEvents-KeyDown="MainAccountlookUpKeyDown">
                    <Columns>
                        <dxe:GridViewDataColumn FieldName="MainAccount_Name" Caption="Main Account Name" Width="220">
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataColumn>
                        <dxe:GridViewDataColumn FieldName="MainAccount_SubLedgerType" Caption="Type" Width="80">
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataColumn>

                    </Columns>
                    <GridViewProperties Settings-VerticalScrollBarMode="Auto">

                        <Templates>
                            <StatusBar>
                                <table class="OptionsTable" style="float: right">
                                    <tr>
                                        <td>
                                            
                                        </td>
                                    </tr>
                                </table>
                            </StatusBar>
                        </Templates>
                        <Settings ShowFilterRow="True" ShowFilterRowMenu="true" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                    </GridViewProperties>
                </dxe:ASPxGridLookup>--%>

            </dxe:PopupControlContentControl>
        </ContentCollection>
        <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
    </dxe:ASPxPopupControl>
    <dxe:ASPxPopupControl ID="SubAccountpopUp" runat="server" ClientInstanceName="cSubAccountpopUp"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Height="200"
        Width="700" HeaderText="Select Sub Account" AllowResize="true" ResizingMode="Postponed" Modal="true">
         <HeaderTemplate>
                         <span style="color: #fff"><strong>Search By Sub Account (4 Char)</strong></span>
                         <dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                                            <ClientSideEvents Click="function(s, e){ 
                                                                       SubAccountClose();
                                                                    }" />
                                        </dxe:ASPxImage>
                    </HeaderTemplate>
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
                <label><strong>Search By Sub Account(4 Char)</strong><span style="color:red"> [Press Esc to Cancel]</span></label>
                  <div id="subActMsg">
                   <span style="color: red;  right: 46px;"  ><strong>* Invalid Sub Account</strong> </span>
                       </div>
                <dxe:ASPxComboBox ID="SubAcountComboBox" runat="server" EnableCallbackMode="true" CallbackPageSize="10" Width="95%"                    
                    ValueType="System.String" ValueField="SubAccount_ReferenceID" ClientInstanceName="cSubAcountComboBox"
                    OnItemsRequestedByFilterCondition="ASPxComboBox_OnItemsRequestedByFilterCondition_SQL" FilterMinLength="4"
                    OnItemRequestedByValue="ASPxComboBox_OnItemRequestedByValue_SQL" TextFormatString="{0}"
                    DropDownStyle="DropDown" DropDownRows="7">
                    <Columns>
                        <dxe:ListBoxColumn FieldName="Contact_Name" Caption="Sub Account Name" Width="320px" />                                        
                    </Columns>
                    <ClientSideEvents ValueChanged="function(s, e) {GetSubAcountComboBox(e)}" KeyDown="SubAccountComboBoxKeyDown"  />
                </dxe:ASPxComboBox>
                <%--  <dxe:ASPxGridLookup ID="SubAccountLookup" runat="server" ClientInstanceName="cSubAccountLookUp"
                    KeyFieldName="SubAccount_ReferenceID" Width="800" TextFormatString="{0}" ClientSideEvents-TextChanged="SubAccountSelected"
                    ClientSideEvents-KeyDown="SubAccountlookUpKeyDown">
                    <Columns>
                        <dxe:GridViewDataColumn FieldName="Contact_Name" Caption="Sub Account Name" Width="220">
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataColumn>

                    </Columns>
                    <GridViewProperties Settings-VerticalScrollBarMode="Auto">

                        <Templates>
                            <StatusBar>
                                <table class="OptionsTable" style="float: right">
                                    <tr>
                                        <td>
                                            
                                        </td>
                                    </tr>
                                </table>
                            </StatusBar>
                        </Templates>
                        <Settings ShowFilterRow="True" ShowFilterRowMenu="true" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                    </GridViewProperties>
                </dxe:ASPxGridLookup>--%>
            </dxe:PopupControlContentControl>
        </ContentCollection>
        <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
    </dxe:ASPxPopupControl>
  <%--  <dx:LinqServerModeDataSource ID="EntityServerMainDataSource" runat="server" OnSelecting="EntityServerMainDataSource_Selecting"
        ContextTypeName="ERPDataClassesDataContext" TableName="v_MainAccountList" />--%>

  

             <%-- -------------------End   POPUPControl   FOR Main & Sub Account-------------------------------------%>
        </div>

    </div>
    <dxe:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" ContainerElementID="gridBatch"
        Modal="True">
    </dxe:ASPxLoadingPanel>
    <dxe:ASPxCallbackPanel runat="server" ID="acpPaymentTDS" ClientInstanceName="cacpPaymentTDS">
        <PanelCollection>
            <dxe:PanelContent runat="server">
            </dxe:PanelContent>
        </PanelCollection>
    </dxe:ASPxCallbackPanel>
    <dxe:ASPxCallbackPanel runat="server" ID="acpCrossBtn" ClientInstanceName="cacpCrossBtn" OnCallback="acpCrossBtn_Callback">
        <PanelCollection>
            <dxe:PanelContent runat="server">
            </dxe:PanelContent>
        </PanelCollection>
        <ClientSideEvents EndCallback="acpCrossBtnEndCall" />
    </dxe:ASPxCallbackPanel>
    <asp:SqlDataSource ID="dsBranch" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        ConflictDetection="CompareAllValues"
        SelectCommand=""></asp:SqlDataSource>

    <%--Tax PopUp Start--%>
    <dxe:ASPxPopupControl ID="aspxTaxpopUp" runat="server" ClientInstanceName="caspxTaxpopUp"
        Width="850px" HeaderText="Select Tax" PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
        Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
        <HeaderTemplate>
            <span style="color: #fff"><strong>Select Tax</strong></span>
            <dxe:ASPxImage ID="ASPxImage31" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                <ClientSideEvents Click="function(s, e){ 
                                                            caspxTaxpopUp.Hide();
                                                        }" />
            </dxe:ASPxImage>
        </HeaderTemplate>
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
                <asp:HiddenField runat="server" ID="setCurrentProdCode" />
                <asp:HiddenField runat="server" ID="HdSerialNo" />
                <asp:HiddenField runat="server" ID="HdSerialNo1" />
                <asp:HiddenField runat="server" ID="hdnDeleteSrlNo" Value="0" />
                <asp:HiddenField runat="server" ID="HdProdGrossAmt" />
                <asp:HiddenField runat="server" ID="HdProdNetAmt" />
                <div id="content-6">
                    <div class="col-sm-3">
                        <div class="lblHolder" style="margin-bottom: 8px">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Gross Amount
                                                    <dxe:ASPxLabel ID="ASPxLabel1" runat="server" Text="(Taxable)" ClientInstanceName="clblTaxableGross"></dxe:ASPxLabel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 28px">
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
                                        <td style="height: 28px">
                                            <dxe:ASPxLabel ID="lblGstForGross" runat="server" Text="" ClientInstanceName="clblGstForGross"></dxe:ASPxLabel>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="col-sm-3" style="display: none">
                        <div class="lblHolder">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Discount</td>
                                    </tr>
                                    <tr>
                                        <td style="height: 28px">
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
                                        <td style="height: 28px">
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
                                        <td style="height: 28px">
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
                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
                            </dxe:ASPxTextBox>
                        </td>
                    </tr>
                    <tr class="cgridTaxClass">
                        <td colspan="3">

                            <dxe:ASPxGridView runat="server" OnBatchUpdate="taxgrid_BatchUpdate" KeyFieldName="Taxes_ID" ClientInstanceName="cgridTax" ID="aspxGridTax"
                                Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" SettingsPager-Mode="ShowAllRecords"
                                OnCustomCallback="cgridTax_CustomCallback"
                                Settings-ShowFooter="false" AutoGenerateColumns="False"
                                OnCellEditorInitialize="aspxGridTax_CellEditorInitialize"
                                OnRowInserting="taxgrid_RowInserting" OnRowUpdating="taxgrid_RowUpdating" OnRowDeleting="taxgrid_RowDeleting">
                                <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto"></Settings>
                                <SettingsBehavior AllowDragDrop="False" AllowSort="False"></SettingsBehavior>
                                <SettingsPager Visible="false"></SettingsPager>
                                <%-- indranil--%>
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
                                <SettingsDataSecurity AllowEdit="true" />
                                <SettingsEditing Mode="Batch">
                                    <BatchEditSettings EditMode="row" ShowConfirmOnLosingChanges="false" />
                                </SettingsEditing>
                                <ClientSideEvents EndCallback="cgridTax_EndCallBack " RowClick="GetTaxVisibleIndex" />
                                <%-- <ClientSideEvents  RowClick="GetTaxVisibleIndex" />--%>
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
                                        </dxe:ASPxComboBox>
                                    </td>
                                    <td style="padding-left: 15px; padding-top: 10px; padding-bottom: 15px; padding-right: 25px">
                                        <dxe:ASPxTextBox ID="txtGstCstVat" MaxLength="80" ClientInstanceName="ctxtGstCstVat" ReadOnly="true" Text="0.00"
                                            runat="server" Width="100%">
                                            <MaskSettings Mask="&lt;-999999999999..999999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
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
                        <td colspan="3" style="padding-top: 5px">
                            <div class="pull-left" id="calculateTotalAmountOK">
                                <input type="button" onclick="calculateTotalAmount()" class="btn btn-primary" value="Ok" />
                            </div>
                            <table class="pull-right">
                                <tr>
                                    <td style="padding-right: 5px"><strong>Total Charges</strong></td>
                                    <td>
                                        <dxe:ASPxTextBox ID="txtTaxTotAmt" MaxLength="80" ClientInstanceName="ctxtTaxTotAmt" Text="0.00" ReadOnly="true"
                                            runat="server" Width="100%" CssClass="pull-left mTop">
                                            <MaskSettings Mask="&lt;-999999999999..999999999999&gt;.&lt;00..99&gt;" AllowMouseWheel="false" />
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

    <%--Tax PopUp End--%>

    <%--DEBASHIS--%>
    <%--<div class="PopUpArea">
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
    </div>--%>
    <%--DEBASHIS--%>
</asp:Content>


