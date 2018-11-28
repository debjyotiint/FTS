<%@ Page Title="Contra Voucher" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="ContraVoucher.aspx.cs" Inherits="ERP.OMS.Management.DailyTask.ContraVoucher" %>


<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        ActiveCurrencySymbol = "";
        function AllControlInitilize() {
            if (localStorage.getItem('ContraVoucherFromDate')) {
                var fromdatearray = localStorage.getItem('ContraVoucherFromDate').split('-');
                var fromdate = new Date(fromdatearray[0], parseFloat(fromdatearray[1]) - 1, fromdatearray[2], 0, 0, 0, 0);
                cFormDate.SetDate(fromdate);
            }

            if (localStorage.getItem('ContraVoucherToDate')) {
                var todatearray = localStorage.getItem('ContraVoucherToDate').split('-');
                var todate = new Date(todatearray[0], parseFloat(todatearray[1]) - 1, todatearray[2], 0, 0, 0, 0);
                ctoDate.SetDate(todate);
            }
            if (localStorage.getItem('ContraVoucherBranch')) {
                if (ccmbBranchfilter.FindItemByValue(localStorage.getItem('ContraVoucherBranch'))) {
                    ccmbBranchfilter.SetValue(localStorage.getItem('ContraVoucherBranch'));
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
                localStorage.setItem("ContraVoucherFromDate", cFormDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("ContraVoucherToDate", ctoDate.GetDate().format('yyyy-MM-dd'));
                localStorage.setItem("ContraVoucherBranch", ccmbBranchfilter.GetValue());

                $("#hfFromDate").val(cFormDate.GetDate().format('yyyy-MM-dd'));
                $("#hfToDate").val(ctoDate.GetDate().format('yyyy-MM-dd'));
                $("#hfBranchID").val(ccmbBranchfilter.GetValue());
                $("#hfIsFilter").val("Y");

                gvContraVoucherInstance.Refresh();

                //gvContraVoucherInstance.PerformCallback('FilterGridByDate~' + cFormDate.GetDate().format('yyyy-MM-dd') + '~' + ctoDate.GetDate().format('yyyy-MM-dd') + '~' + ccmbBranchfilter.GetValue())
            }
        }
        $(function () {

            var IsEdit = false;
        });
        function PageLoad() {
            var ActiveCurrency = '<%=Session["ActiveCurrency"]%>'

            ActiveCurrencySymbol = ActiveCurrency.split('~')[2];
        }
        function showExitMsg(obj) {

            var JV_Msg = "Cash/Bank Voucher No. " + obj + " generated.";
            var strconfirm = confirm(JV_Msg);
            if (strconfirm == true) {
                window.location.href = "ContraVoucher.aspx";
            }
            else {
                window.location.href = "ContraVoucher.aspx";
            }

        }


        function NextFocus(s, e) {
            var str = $('#<%=hdn_Mode.ClientID %>').val();
            var Campany_ID = '<%=Session["LastCompany"]%>';
            var LocalCurrency = '<%=Session["LocalCurrency"]%>';
            var basedCurrency = LocalCurrency.split("~");
            var setCurrency = grid.GetEditor('Currency_ID').GetValue();
            if (basedCurrency[0] == setCurrency) {
                if (str == "EDIT") {
                    grid.batchEditApi.StartEdit(0, 5);
                }
                else {
                    grid.batchEditApi.StartEdit(-1, 5);
                }


            }
            else {
                var str = $('#<%=hdn_Mode.ClientID %>').val();

                if (str == "EDIT") {
                    grid.batchEditApi.StartEdit(0, 3);
                }
                else {
                    grid.batchEditApi.StartEdit(-1, 3);
                }

            }
        }
        function txtBillNo_TextChanged() {
            var VoucherNo = document.getElementById("txtVoucherNo").value;

            $.ajax({
                type: "POST",
                url: "ContraVoucher.aspx/CheckUniqueName",
                data: JSON.stringify({ VoucherNo: VoucherNo }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;

                    if (data == true) {
                        $("#MandatoryBillNoDUPLICALE").show();
                        //jAlert('Duplicate Voucher No.');
                        document.getElementById("txtVoucherNo").value = '';
                        document.getElementById("txtVoucherNo").focus();
                    }
                    else {
                        $("#MandatoryBillNoDUPLICALE").hide();
                    }
                }
            });
        }
        function RateOnKeyDown(s, e) {
            if (e.htmlEvent.keyCode == 40 || e.htmlEvent.keyCode == 38)
                return ASPxClientUtils.PreventEvent(e.htmlEvent);
        }
        function HomeCurrencyOnKeyDown(s, e) {
            if (e.htmlEvent.keyCode == 40 || e.htmlEvent.keyCode == 38)
                return ASPxClientUtils.PreventEvent(e.htmlEvent);
        }
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
                jAlert('Enter Date Is Outside Of Financial Year !!');
                if (SelectedDateNumericValue < FinYearStartDateNumericValue) {
                    cInstDate.SetDate(new Date(FinYearStartDate));
                }
                if (SelectedDateNumericValue > FinYearEndDatNumbericValue) {
                    cInstDate.SetDate(new Date(FinYearEndDate));
                }
            }
            ///End OF Date Should Between Current Fin Year StartDate and EndDate
        }
        function TDateChange() {
            var SelectedDate = new Date(tDate.GetDate());
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
                tDate.SetDate(MaxLockDate);
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
                jAlert('Enter Date Is Outside Of Financial Year !!');
                if (SelectedDateNumericValue < FinYearStartDateNumericValue) {
                    tDate.SetDate(new Date(FinYearStartDate));
                }
                if (SelectedDateNumericValue > FinYearEndDatNumbericValue) {
                    tDate.SetDate(new Date(FinYearEndDate));
                }
            }
            ///End OF Date Should Between Current Fin Year StartDate and EndDate
        }
        //function DeletebtnOkClick() {
        //    gvContraVoucherInstance.PerformCallback('PCB_DeleteBtnOkE~' + VisibleIndexE + "~#~~");
        //}
        function SetVisibility() {
            var Currency_ID = (grid.GetEditor('Currency_ID').GetValue() != null) ? parseFloat(grid.GetEditor('Currency_ID').GetValue()) : "0";
            //  var Currency_ID = (grid.GetEditor('Currency_ID').GetValue() != null) ? parseFloat(grid.GetEditor('Currency_ID').GetValue()) : "0";
            var Campany_ID = '<%=Session["LastCompany"]%>';
            var LocalCurrency = '<%=Session["LocalCurrency"]%>';
            var basedCurrency = LocalCurrency.split("~");
            var tdRate = grid.GetEditor('Rate');
            var tdHomeCurrency = grid.GetEditor('CashBankDetail_PaymentAmount');
            var tdAmount = grid.GetEditor('Amount');
            $.ajax({
                type: "POST",
                url: "ContraVoucher.aspx/GetRate",
                data: JSON.stringify({ Currency_ID: Currency_ID, Campany_ID: Campany_ID, basedCurrency: basedCurrency[0] }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;
                    tdRate.SetValue(data);
                    tdHomeCurrency.SetValue(tdRate.GetValue() * tdAmount.GetValue());

                }
            });
            if (Currency_ID == "0") {
                grid.GetEditor('Amount').SetEnabled(false);
                grid.GetEditor('Rate').SetEnabled(false);
            }
            else {
                grid.GetEditor('Amount').SetEnabled(true);
                grid.GetEditor('Rate').SetEnabled(true);
            }
        }
        function OnGetRowValuesOnDelete(values, TransactionDate, BankValueDate, ref) {

            var ValueDate = new Date(BankValueDate);
            var monthnumber = ValueDate.getMonth();
            var monthday = ValueDate.getDate();
            var year = ValueDate.getYear();
            var ValueDateNumeric = new Date(year, monthnumber, monthday).getTime();

            var TransactionDate = new Date(TransactionDate);
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

            if (BankValueDate == "") {
                jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                    if (r == true) {
                        gvContraVoucherInstance.PerformCallback('Delete~' + values + "~" + ref);
                    }
                });


            }
            else {
                jAlert('Voucher is Reconciled.Cannot Delete');
            }
        }
        function BranchFrom_SelectedIndexChanged() {
            var branchfrom = $("#ddlBranch").val();
            $("#hddn_BranchID").val(branchfrom);

            // var strWithDrawFrom = (grid.GetEditor('WithDrawFrom').GetValue() != null) ? grid.GetEditor('WithDrawFrom').GetValue() : "";
            var strWithDrawFrom = grid.GetEditor('WithDrawFrom').GetValue();
            if (strWithDrawFrom != null) {
                jConfirm('You have changed Branch. All the entries of ledger in this voucher to be reset to blank. \n You have to select and re-enter.Want to continue?', 'Confirmation Dialog', function (r) {

                    if (r == true) {
                        grid.DeleteRow(0);
                        grid.DeleteRow(-1);
                        grid.AddNewRow();
                        // $("#hddn_BranchID").val(document.getElementById('ddlBranch').value);
                    }
                    else {
                        // document.getElementById('ddlBranch').value = $("#hddn_BranchID").val();
                    }
                });
            }

            WithDrawFrom.PerformCallback(branchfrom);
            //DepositInto.PerformCallback(document.getElementById('ddlBranchIDTo').value);
            grid.batchEditApi.StartEdit(-1, 0);
        }

        function batchgridFocus() {

            var branchTo = $("#ddlBranchTo").val();
            $("#hdnBranchIdTo").val(branchTo);
            var strDepositInto = grid.GetEditor('DepositInto').GetValue();
            if (strDepositInto != null) {
                jConfirm('You have changed Branch. All the entries of ledger in this voucher to be reset to blank. \n You have to select and re-enter.Want to continue?', 'Confirmation Dialog', function (r) {

                    if (r == true) {
                        grid.DeleteRow(0);
                        grid.DeleteRow(-1);
                        grid.AddNewRow();
                        // $("#hddn_BranchID").val(document.getElementById('ddlBranch').value);
                    }
                    else {
                        // document.getElementById('ddlBranch').value = $("#hddn_BranchID").val();
                    }
                });
            }

            // WithDrawFrom.PerformCallback(document.getElementById('ddlBranch').value);
            DepositInto.PerformCallback(document.getElementById('ddlBranchTo').value);
            grid.batchEditApi.StartEdit(-1, 0);
        }

        $(document).ready(function () {

            IsEdit = false;
            $('#ddlBranch').blur(function () {
                grid.batchEditApi.StartEdit(-1, 0);
            })
        });

        function OnAddButtonClick() {
            IsEdit = false;
            grid.GetEditor('Amount').SetEnabled(false);
            grid.GetEditor('Rate').SetEnabled(false);
            document.getElementById('divAddNew').style.display = 'block';
            TblSearch.style.display = "none";
            btncross.style.display = "block";

            cCmbScheme.SetValue("0");
            document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
            document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
            document.getElementById('gridFilter').style.display = 'none';
            $('#<%= lblHeading.ClientID %>').text("Add Contra Voucher");


            grid.AddNewRow();
            cCmbScheme.Focus();

        }
        function AddExitMsgShow() {
            if (hdnBtnValue.value == "Exit") {
                if (grid.cprtnVoucherNo != null) {
                    var strconfirm = confirm(grid.cprtnVoucherNo);

                    jAlert(strconfirm, 'Alert Dialog: [ContraVoucher]', function (r) {
                        if (r == true) {
                            grid.cprtnVoucherNo = null;
                            hdnBtnValue.value == "";
                            window.location.reload();
                        }
                    });
                }
            }
        }
        function AddNewRowGrid() {

            if (grid.cprtnVoucherNo != null) {
                jAlert(grid.cprtnVoucherNo);
                grid.cprtnVoucherNo = null;
            }
            document.getElementById('divAddNew').style.display = 'block';
            TblSearch.style.display = "none";
            btncross.style.display = "block";
            $('#<%= lblHeading.ClientID %>').text("Add Contra Voucher");
            grid.AddNewRow();
            $("#hddn_BranchID").val(document.getElementById('ddlBranch').value);
            $("#hdnBranchIdTo").val(document.getElementById('ddlBranchTo').value);

        }
        function AddNewRowGridModify() {
            document.getElementById('divAddNew').style.display = 'block';
            TblSearch.style.display = "none";
            btncross.style.display = "block";
            var numbering = cCmbScheme.GetText();
            cCmbScheme.SetValue("0");
            document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
            document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";

            $('#<%= lblHeading.ClientID %>').text("Add Contra Voucher");
            grid.AddNewRow();
            cCmbScheme.Focus();


        }

        ////##### coded by Samrat Roy - 14/04/2017 - ref IssueLog(Contra - 77) 
        ////This method calls on View Request Only.
        function OnView(obj, BankValueDate) {

            if (BankValueDate != "") {
                jAlert("Voucher is Reconciled.Cannot View");
            }
            else {
                IsView = true;
                document.getElementById('hdnType').value = "E";
                document.getElementById('divAddNew').style.display = 'block';
                TblSearch.style.display = "none";
                btncross.style.display = "block";

                document.getElementById('divNumberingScheme').style.display = 'none';
                $('#<%= lblHeading.ClientID %>').text("View Contra Voucher");
                grid.AddNewRow();
                document.getElementById('gridFilter').style.display = 'none';
                var mode = obj.split("~");
                document.getElementById('hdn_Mode').value = "VIEW";
                document.getElementById('hdn_CashBankID').value = mode[1];
                grid.PerformCallback('BEFORE_' + obj);

                document.getElementById('btnSaveExit').style.display = 'none';
            }
        }
        // Coded By Samrat Roy -- 14/04/2017 -- refered by Issue Log Excel 

        function OnEdit(obj, BankValueDate) {

            if (BankValueDate != "") {
                jAlert("Voucher is Reconciled.Cannot Edit");
            }
            else {
                IsEdit = true;
                document.getElementById('hdnType').value = "E";
                document.getElementById('divAddNew').style.display = 'block';
                TblSearch.style.display = "none";
                btncross.style.display = "block";

                document.getElementById('divNumberingScheme').style.display = 'none';
                $('#<%= lblHeading.ClientID %>').text("Modify Contra Voucher");
                grid.AddNewRow();

                grid.PerformCallback('BEFORE_' + obj);
                var mode = obj.split("~");
                document.getElementById('hdn_Mode').value = mode[0];
                document.getElementById('hdn_CashBankID').value = mode[1];
                var txtVoucherNo = document.getElementById('<%= txtVoucherNo.ClientID %>');
                $(txtVoucherNo).attr('disabled', true);
                cCmbScheme.SetEnabled(false);
                document.getElementById('gridFilter').style.display = 'none';
                cCmbScheme.SetValue("0");
                document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";


            }
        }

        function OnAddNewClick() {
            grid.AddNewRow();
            document.getElementById("btnAddNew").style.display = 'none';
        }
        function OnComboInstTypeSelectedIndexChanged() {
            $('#MandatoryInstrumentType').hide();
            var InstType = cComboInstType.GetValue();
            if (InstType == "0") {
                document.getElementById("tdINoDiv").style.display = 'none';
                document.getElementById("tdIDateDiv").style.display = 'none';
            }
            else {

                document.getElementById("tdINoDiv").style.display = 'block';
                document.getElementById("tdIDateDiv").style.display = 'block';
            }
        }
        function AutoCalValue() {

            var Rate = (grid.GetEditor('Rate').GetValue() != null) ? grid.GetEditor('Rate').GetValue() : "0";
            var Amount = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            if (Rate != "0" && Amount != "0") {
                var stramount = Rate * Amount;
                var PaymentAmount = grid.GetEditor("CashBankDetail_PaymentAmount");
                PaymentAmount.SetValue(stramount);
            }
            if (Rate == 0 && Amount != 0) {
                grid.GetEditor('CashBankDetail_PaymentAmount').SetValue(Amount)
            }

        }
        function ReceiptTextChange() {

            var Rate = (grid.GetEditor('Rate').GetValue() != null) ? grid.GetEditor('Rate').GetValue() : "0";
            var Amount = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "0";
            if (Rate != 0 && Amount != 0) {
                grid.SetValue('CashBankDetail_PaymentAmount').SetValue(Rate * Amount)
            }
            if (Rate == 0 && Amount != 0) {
                grid.SetValue('CashBankDetail_PaymentAmount').SetValue(Amount)
            }
        }
        function SaveNewButtonClick(s, e) {
            var WithDrawFrom = (grid.GetEditor('WithDrawFrom').GetValue() != null) ? grid.GetEditor('WithDrawFrom').GetValue() : "";
            var DepositInto = (grid.GetEditor('DepositInto').GetValue() != null) ? grid.GetEditor('DepositInto').GetValue() : "";
            var Currency_ID = (grid.GetEditor('Currency_ID').GetValue() != null) ? grid.GetEditor('Currency_ID').GetValue() : "";
            var AmountInHomeCurrency = (grid.GetEditor('CashBankDetail_PaymentAmount').GetValue() != null) ? grid.GetEditor('CashBankDetail_PaymentAmount').GetValue() : "";

            var Remarks = (grid.GetEditor('Remarks').GetValue() != null) ? grid.GetEditor('Remarks').GetValue() : "";
            var Rate = (grid.GetEditor('Rate').GetValue() != null) ? grid.GetEditor('Rate').GetValue() : "";
            var Amount = (grid.GetEditor('Amount').GetValue() != null) ? grid.GetEditor('Amount').GetValue() : "";

            document.getElementById('hdnWithDrawFrom').value = "";
            document.getElementById('hdnDepositInto').value = "";
            document.getElementById('hdnCurrency_ID').value = "";
            document.getElementById('hdnAmountInHomeCurrency').value = "";
            document.getElementById('hdnRemarks').value = "";
            document.getElementById('hdnRate').value = "";
            document.getElementById('hdnAmount').value = "";


            document.getElementById('hdnWithDrawFrom').value = WithDrawFrom;
            document.getElementById('hdnDepositInto').value = DepositInto;
            document.getElementById('hdnCurrency_ID').value = Currency_ID;
            document.getElementById('hdnAmountInHomeCurrency').value = AmountInHomeCurrency;
            document.getElementById('hdnRemarks').value = Remarks;
            document.getElementById('hdnRate').value = Rate;
            document.getElementById('hdnAmount').value = Amount;//AmountInHomeCurrency;//Amount;

            var type = document.getElementById('hdnType').value;

            var val = cCmbScheme.GetValue();
            var Branchval = $("#ddlBranch").val();
            var BranchvalTo = $("#ddlBranchTo").val();


            var voucherNo = document.getElementById('<%= txtVoucherNo.ClientID %>').value;
            document.getElementById('hdnVoucherNo').value = voucherNo;
            var InstType = cComboInstType.GetValue();
            if (val == "0") {
                // jAlert("Please Select Numbering Scheme");
                $("#MandatoryNumberingScheme").show();
                e.processOnServer = false;
                return false;
            }
            else if (document.getElementById('<%= txtVoucherNo.ClientID %>').value.trim() == "") {
                $("#MandatoryBillNo").show();
                //jAlert("Please Select Voucher No");
                e.processOnServer = false;
                return false;
            }
            else if (Branchval == "0") {
                document.getElementById('<%= ddlBranch.ClientID %>').focus();
                //   jAlert('Enter from Branch');
                $("#MandatoryFromBranch").show();
                e.processOnServer = false;
                return false;
            }
            else if (BranchvalTo == "0") {
                document.getElementById('<%= ddlBranch.ClientID %>').focus();
                //  jAlert('Enter To Branch');
                    $("#MandatoryBranchTo").show();
                    e.processOnServer = false;
                    return false;
                }
                else if (WithDrawFrom == "") {
                    jAlert("Please Fill Withdrawal From");
                    e.processOnServer = false;
                    return false;

                }
                else if (DepositInto == "") {
                    jAlert("Please Fill Deposit Into");
                    e.processOnServer = false;
                    return false;
                }
                else if (AmountInHomeCurrency == "0.0") {
                    jAlert("Please Enter Amount in Home Currency");
                    e.processOnServer = false;
                    return false;
                }
                else if (InstType == "NA") {
                    $("#MandatoryInstrumentType").show();
                    // jAlert("Please Fill Instrument Type");
                    e.processOnServer = false;
                    return false;
                }


}

function OnInit(s, e) {
    //IntializeGlobalVariables(s);
}
function OnEndCallback(s, e) {
    //IntializeGlobalVariables(s);
}

function CmbScheme_ValueChange() {
    $("#MandatoryNumberingScheme").hide();
    var val = cCmbScheme.GetValue();

    if (val != "0") {
        $.ajax({
            type: "POST",
            url: 'ContraVoucher.aspx/getSchemeType',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: "{sel_scheme_id:\"" + val + "\"}",
            success: function (type) {
                var schemetypeValue = type.d;
                var schemetype = schemetypeValue.toString().split('~')[0];
                var schemelength = schemetypeValue.toString().split('~')[1];
                $('#txtVoucherNo').attr('maxLength', schemelength);
                var branchID = schemetypeValue.toString().split('~')[2];
                WithDrawFrom.PerformCallback(branchID);
                //DepositInto.PerformCallback(branchID);
                if (schemetypeValue != "") {

                    document.getElementById('ddlBranch').value = branchID;
                    //document.getElementById('<%= ddlBranch.ClientID %>').disabled = true;
                    $("#hddn_BranchID").val(branchID);
                    calWithdrawalBal();
                }
                if (schemetype == '0') {
                    document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = false;
                    document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
                }
                else if (schemetype == '1') {

                    document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                    document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Auto";
                    $("#MandatoryBillNo").hide();
                }
                else {
                    document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
                    document.getElementById('<%= txtVoucherNo.ClientID %>').value = "Datewise";
                }
            }
        });
}
else {
    document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
        document.getElementById('<%= txtVoucherNo.ClientID %>').value = "";
    }

}

$(document).ready(function () {
    $('#CmbScheme_I').blur(function () {
        $("#MandatoryNumberingScheme").hide();
        var val = cCmbScheme.GetValue();

        if (val != "0") {
            $("#MandatoryNumberingScheme").hide();
        }
        else {
            cCmbScheme.Focus();
            $("#MandatoryNumberingScheme").show();
        }
    })

});


function ShowMsgLastCall() {

    if (gvContraVoucherInstance.cpCBDelete != null) {
        jAlert(gvContraVoucherInstance.cpCBDelete);
        gvContraVoucherInstance.cpCBDelete = null;
        updateGridByDate();

        //gvContraVoucherInstance.PerformCallback();
    }

}
function LastCall(obj) {
    if (grid.cpEdit != null) {

        var date = grid.cpEdit.split('~')[0];
        var VoucherNo = grid.cpEdit.split('~')[1];
        var Narration = grid.cpEdit.split('~')[2];
        var CashBank_BranchID = grid.cpEdit.split('~')[4];
        $("#hddn_BranchID").val(CashBank_BranchID);
        var CashBank_Currency = grid.cpEdit.split('~')[5];
        var CashBankDetail_InstrumentType = grid.cpEdit.split('~')[6];

        var CashBankDetail_InstrumentNumber = grid.cpEdit.split('~')[7];
        var Remarks = grid.cpEdit.split('~')[8];
        var CashBankDetail_InstrumentDate = grid.cpEdit.split('~')[9];
        var CashBank_IBRef = grid.cpEdit.split('~')[10];
        var CashBank_FinYear = grid.cpEdit.split('~')[11];
        var CashBank_CompanyID = grid.cpEdit.split('~')[12];
        var CashBank_ExchangeSegmentID = grid.cpEdit.split('~')[13];
        var CaskBank_NumberingScheme = grid.cpEdit.split('~')[14];

        var BranchIDTo = grid.cpEdit.split('~')[17];


        var Transdt = new Date(date);
        tDate.SetDate(Transdt);
        document.getElementById('ddlBranch').value = CashBank_BranchID;
        document.getElementById('txtVoucherNo').value = VoucherNo;
        document.getElementById('hdnCashBank_IBRef').value = CashBank_IBRef;
        document.getElementById('hdnCashBank_FinYear').value = CashBank_FinYear;
        document.getElementById('hdnCashBank_CompanyID').value = CashBank_CompanyID;
        document.getElementById('hdnCashBank_ExchangeSegmentID').value = CashBank_ExchangeSegmentID;
        document.getElementById('hdnDbSaveCurrenct').value = CashBank_Currency;
        WithDrawFrom.PerformCallback(document.getElementById('ddlBranch').value);
        document.getElementById('ddlBranchTo').value = BranchIDTo;

        $("#hdnBranchIdTo").val(BranchIDTo);
        //DepositInto.PerformCallback(document.getElementById('ddlBranchTo').value);
        DepositInto.PerformCallback(document.getElementById('hdnBranchIdTo').value);

        var instDate = new Date(CashBankDetail_InstrumentDate);
        cInstDate.SetDate(instDate);
        if (CashBankDetail_InstrumentType == "0") {

            document.getElementById("tdINoDiv").style.display = 'none';
            document.getElementById("tdIDateDiv").style.display = 'none';
        }
        var setCurr = '<%=Session["LocalCurrency"]%>';
        var localCurrency = setCurr.split('~')[0];
        if (CashBank_Currency == localCurrency) {
            grid.GetEditor('Amount').SetEnabled(false);
            grid.GetEditor('Rate').SetEnabled(false);
        }


        var WithdrawalType = "";
        if (CashBankDetail_InstrumentType == "0") {
            WithdrawalType = "Cash";
        }

        WithdrawalChanged(WithdrawalType);
        cComboInstType.SetValue(CashBankDetail_InstrumentType);
        OnComboInstTypeSelectedIndexChanged();

        ctxtInstNo.SetText(CashBankDetail_InstrumentNumber);
        ctxtNarration.SetText(Narration);
        cCmbScheme.SetEnabled(false);
        cCmbScheme.SetValue(CaskBank_NumberingScheme);



        document.getElementById('<%= txtVoucherNo.ClientID %>').disabled = true;
        grid.StartEditRow(0);

        ////##### coded by Samrat Roy - 14/04/2017 - ref IssueLog(Contra - 77) 
        ////This condition is working on View Request Only.
        if ($('#hdn_Mode').val().toUpperCase() == 'VIEW') {
            viewOnly();
        }
    }
    // alert($("#hdnBtnValue").val());
    Discard_dipositinto();
}
////##### coded by Samrat Roy - 14/04/2017 - ref IssueLog(Contra - 77) 
////This method is for disable all the attributes.
function viewOnly() {
    $('#<%= txtVoucherNo.ClientID %>').attr('disabled', true);
    $('#<%= ddlBranch.ClientID %>').attr('disabled', true);
    $('#<%= txtNarration.ClientID %>').attr('disabled', true);

    grid.SetEnabled(false);
    tDate.SetEnabled(false);

    cComboInstType.SetEnabled(false);
    cInstDate.SetEnabled(false);
    ctxtNarration.SetEnabled(false);
    ctxtInstNo.SetEnabled(false);

    cbtnnew.SetVisible(false);
    cbtnexit.SetVisible(false);
    calWithdrawalBal();
}

function chkValidConta(contano_status) {
    if (contano_status == "outrange") {
        jAlert('Can Not Add More Contra Voucher as Contra Scheme Exausted.<br />Update The Scheme and Try Again');
    } else if (contano_status == "duplicate") {
        jAlert('Can Not Save as Duplicate Contra Voucher No. Found');
    }
    return false;
}


    </script>
    <style>
        .dxgv {
            display: none;
        }

            .gridcellleft.dx-nowrap.dxgv, .gridcellleft.dxgv, .dxgv.dx-al, .dxgv.dx-ar, .dxgv.dx-ac {
                display: table-cell !important;
            }

            .dxgv.dx-al, .dxgv.dx-ar, .dx-nowrap.dxgv, .gridcellleft.dxgv, .dxgv.dx-ac, .dxgvCommandColumn_PlasticBlue.dxgv.dx-ac {
                display: table-cell !important;
            }

        .dxgvControl_PlasticBlue td.dxgvBatchEditModifiedCell_PlasticBlue {
            background: #fff !important;
        }

        .voucherno {
            position: absolute;
            right: 22px;
            top: 37px;
        }

        .FromBranch {
            position: absolute;
            right: 22px;
            top: 37px;
        }

        .BranchTo {
            position: absolute;
            right: 1px;
            top: 25px;
        }

        .iconInstrumentType {
            position: absolute;
            right: -2px;
            top: 35px;
        }

        .iconNumberScheme {
            position: absolute;
            right: -2px;
            top: 34px;
        }

        #Grid_ContraVoucher_DXFilterRow .dxgv {
            display: table-cell !important;
        }

        #Grid_ContraVoucher_DXGroupRow0.dxgvGroupRow_PlasticBlue td.dxgv {
            display: table-cell !important;
        }

        .padTabtype2 > tbody > tr > td {
            padding: 0px 5px;
        }

            .padTabtype2 > tbody > tr > td > label {
                margin-bottom: 0 !important;
                margin-right: 15px;
            }
    </style>
    <script type="text/javascript">
        var isCtrl = false;
        var currentval = '';
        function NumberingScheme_GotFocus() {
            cCmbScheme.ShowDropDown();
        }
        document.onkeyup = function (e) {
            if (event.keyCode == 17) {
                isCtrl = false;
            }
            else if (event.keyCode == 27) {
                btnCancel_Click();
            }
        }

        document.onkeydown = function (e) {
            // if (event.keyCode == 17) altKey = true;

            if (event.keyCode == 83 && altKey == true) {
                document.getElementById('btnnew').click();
                return false;
            }
            else if ((event.keyCode == 120 || event.keyCode == 88) && altKey == true) {
                document.getElementById('btnSaveExit').click();
                return false;
            }
            else if ((event.keyCode == 120 || event.keyCode == 65) && event.altKey == true) {
                //run code for Ctrl+A -- ie, Add New
                if (document.getElementById('divAddNew').style.display != 'block') {
                    OnAddButtonClick();
                }
            }
        }

        function btnCancel_Click() {
            jConfirm('Do you Want To Close This Window?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    //parent.editwin.close();
                    window.location.reload();
                }
            })
        }
        function Discard_dipositinto() {
            var BranchFor = grid.GetEditor('WithDrawFrom').GetValue();
            var DepositInto = grid.GetEditor('DepositInto').GetValue();

            var i = 0
            for (i = 0; i < grid.GetEditor('DepositInto').GetItemCount() ; i++) {
                var DepositInto = grid.GetEditor('DepositInto').GetItem(i).value;
                if (BranchFor == DepositInto) {
                    grid.GetEditor('DepositInto').RemoveItem(i);
                    break
                }
            }


            if (currentval != '' && currentval != 0) {
                for (i = 0; i < grid.GetEditor('WithDrawFrom').GetItemCount() ; i++) {
                    var BranchForVal = grid.GetEditor('WithDrawFrom').GetItem(i).value;
                    var BranchForText = grid.GetEditor('WithDrawFrom').GetItem(i).text;
                    if (currentval == BranchForVal) {
                        //var option = document.createElement("option");
                        //option.text = BranchForText;
                        //option.value = BranchForVal;
                        grid.GetEditor('DepositInto').AddItem(BranchForText, BranchForVal, null);
                        break
                    }
                }
            }

            currentval = BranchFor;
        }
        function Discard_WithDrawFrom() {
            var BranchFor = grid.GetEditor('WithDrawFrom').GetValue();
            var DepositInto = grid.GetEditor('DepositInto').GetValue();

            var i = 0
            for (i = 0; i < grid.GetEditor('WithDrawFrom').GetItemCount() ; i++) {
                var BranchFor = grid.GetEditor('WithDrawFrom').GetItem(i).value;
                if (BranchFor == DepositInto) {
                    grid.GetEditor('WithDrawFrom').RemoveItem(i);
                    break
                }
            }


            if (currentval != '' && currentval != 0) {
                for (i = 0; i < grid.GetEditor('DepositInto').GetItemCount() ; i++) {
                    var BranchForVal = grid.GetEditor('DepositInto').GetItem(i).value;
                    var BranchForText = grid.GetEditor('DepositInto').GetItem(i).text;
                    if (currentval == BranchForVal) {

                        grid.GetEditor('WithDrawFrom').AddItem(BranchForText, BranchForVal, null);
                        break
                    }
                }
            }

            currentval = DepositInto;
        }
        function PopulateCurrentBankBalance(MainAccountID, BranchId) {
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
                            //  document.getElementById('<%=B2.ClientID %>').innerHTML = '0.0';
                            <%--document.getElementById('<%=B_BankBalance.ClientID %>').style.color = msg.d.split('~')[1];--%>
                            document.getElementById('<%=B_BankBalance.ClientID %>').style.color = "Black";
                        }
                        else {
                            document.getElementById('<%=B_ImgSymbolBankBal.ClientID %>').innerHTML = '';
                            document.getElementById('<%=B_BankBalance.ClientID %>').innerHTML = '0.0';
                            //  document.getElementById('<%=B2.ClientID %>').innerHTML = '0.0';
                            document.getElementById('<%=B_BankBalance.ClientID %>').style.color = "Black";

                        }
                    }

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    jAlert(textStatus);
                }
            });

        }
        function PopulateCurrentBankBalanceForDeposit(MainAccountID, strBranch) {
            $.ajax({
                type: "POST",
                url: 'ContraVoucher.aspx/GetCurrentBankBalance',
                data: "{MainAccountID:\"" + MainAccountID + "\",Branch:\"" + strBranch + "\"}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var list = msg.d;

                    if (msg.d.length > 0) {
                        document.getElementById("pageheaderContentdeposit").style.display = 'block';
                        if (msg.d.split('~')[0] != '') {
                            document.getElementById('<%=B1.ClientID %>').innerHTML = ActiveCurrencySymbol;
                            document.getElementById('<%=B2.ClientID %>').innerHTML = msg.d.split('~')[0];
                            <%--document.getElementById('<%=B_BankBalance.ClientID %>').style.color = msg.d.split('~')[1];--%>
                            document.getElementById('<%=B2.ClientID %>').style.color = "Black";
                        }
                        else {
                            document.getElementById('<%=B1.ClientID %>').innerHTML = '';
                            document.getElementById('<%=B2.ClientID %>').innerHTML = '0.0';
                            document.getElementById('<%=B2.ClientID %>').style.color = "Black";

                        }
                    }

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    jAlert(textStatus);
                }
            });
        }
        function Deposit_SelectedIndexChanged() {
            // var strBranch = document.getElementById('ddlBranch').value;
            // DepositInto.PerformCallback(strBranch);
            Discard_WithDrawFrom();
            var DepositInto = grid.GetEditor('DepositInto').GetValue();
            if (DepositInto != null) {
                var arr = DepositInto.split('-');
                var strBranch = document.getElementById('ddlBranch').value;
                PopulateCurrentBankBalanceForDeposit(arr[0], strBranch);
            }

        }
        function calWithdrawalBal() {
            var WithDrawValue = grid.GetEditor('WithDrawFrom').GetText();
            if (WithDrawValue != "") {
                var strBranch = document.getElementById('ddlBranch').value;
                var arr = WithDrawValue.split('-');
                PopulateCurrentBankBalance(arr[0], strBranch);
                Deposit_SelectedIndexChanged();
            }

        }
        function Withdrawal_SelectedIndexChanged() {
            // var strBranch = document.getElementById('ddlBranch').value;
            // WithDrawFrom.PerformCallback(strBranch);
            Discard_dipositinto();
            var strBranch = document.getElementById('ddlBranch').value;
            var WithDrawValue = grid.GetEditor('WithDrawFrom').GetText();
            var arr = WithDrawValue.split('-');
            PopulateCurrentBankBalance(arr[0], strBranch);


            var SpliteDetails = WithDrawValue.split("]");
            var WithDrawType = String(SpliteDetails[1]).trim();

            if (WithDrawType == "Cash") {
                var comboitem = cComboInstType.FindItemByValue('C');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    //cComboInstType.SetValue("NA");
                    //OnComboInstTypeSelectedIndexChanged();
                }
                var comboitem = cComboInstType.FindItemByValue('D');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    // cComboInstType.SetValue("NA");
                    // OnComboInstTypeSelectedIndexChanged();
                }
                var comboitem = cComboInstType.FindItemByValue('E');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    //cComboInstType.SetValue("NA");
                    // OnComboInstTypeSelectedIndexChanged();
                }
                var comboitem = cComboInstType.FindItemByValue('0');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("Cash", "0");
                }
                cComboInstType.SetValue("0");
                OnComboInstTypeSelectedIndexChanged();
            }
            else {
                var comboitem = cComboInstType.FindItemByValue('C');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("Cheque", "C");
                }
                var comboitem = cComboInstType.FindItemByValue('D');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("Draft", "D");
                }
                var comboitem = cComboInstType.FindItemByValue('E');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("E.Transfer", "E");
                }
                var comboitem = cComboInstType.FindItemByValue('0');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    cComboInstType.SetValue("C");
                    OnComboInstTypeSelectedIndexChanged();
                }
            }
        }
        function WithdrawalChanged(WithDrawType) {

            if (WithDrawType == "Cash") {
                var comboitem = cComboInstType.FindItemByValue('C');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    // cComboInstType.SetValue("NA");
                    // OnComboInstTypeSelectedIndexChanged();
                }
                var comboitem = cComboInstType.FindItemByValue('D');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    // cComboInstType.SetValue("NA");
                    // OnComboInstTypeSelectedIndexChanged();
                }
                var comboitem = cComboInstType.FindItemByValue('E');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    //cComboInstType.SetValue("NA");
                    // OnComboInstTypeSelectedIndexChanged();
                }
                var comboitem = cComboInstType.FindItemByValue('0');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("Cash", "0");
                }
                cComboInstType.SetValue("0");
                OnComboInstTypeSelectedIndexChanged();
            }
            else {
                var comboitem = cComboInstType.FindItemByValue('C');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("Cheque", "C");
                }
                var comboitem = cComboInstType.FindItemByValue('D');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("Draft", "D");
                }
                var comboitem = cComboInstType.FindItemByValue('E');
                if (comboitem == undefined || comboitem == null) {
                    cComboInstType.AddItem("E.Transfer", "E");
                }
                var comboitem = cComboInstType.FindItemByValue('0');
                if (comboitem != undefined && comboitem != null) {
                    cComboInstType.RemoveItem(comboitem.index);

                    cComboInstType.SetValue("C");
                    OnComboInstTypeSelectedIndexChanged();
                }
            }
        }
    </script>
    <style>
        .dxeErrorFrameSys.dxeErrorCellSys {
            position: absolute;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="pull-left"><span class="pull-left">
                <asp:Label ID="lblHeading" runat="server" Text="Contra Voucher"></asp:Label></span>

            </h3>

            <div id="pageheaderContent" class="pull-right wrapHolder reverse content horizontal-images" style="display: none;">
                <ul>
                    <li>
                        <div class="lblHolder">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Current Balance For Withdrawal </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="width: 100%;">
                                                <b style="text-align: left" id="B_ImgSymbolBankBal" runat="server"></b>
                                                <b style="text-align: center" id="B_BankBalance" runat="server">0.0</b>
                                            </div>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>
                    <li>
                        <div class="lblHolder" id="pageheaderContentdeposit">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Current Balance For Deposit </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="width: 100%;">
                                                <b style="text-align: left" id="B1" runat="server"></b>
                                                <b style="text-align: center" id="B2" runat="server">0.0</b>
                                            </div>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>

                </ul>
            </div>

            <div id="btncross" runat="server" class="crossBtn" style="display: none; margin-left: 50px;"><a href="ContraVoucher.aspx"><i class="fa fa-times"></i></a></div>
        </div>
    </div>
    <div class="form_main">
        <div class="clearfix">
            <div style="float: left; padding-right: 5px;">
                <% if (rights.CanAdd)
                   { %>

                <a href="javascript:void(0);" onclick="OnAddButtonClick()" class="btn btn-primary"><span><u>A</u>dd New</span> </a>
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
        <div id="divAddNew" style="display: none" runat="server">
            <div style="background: #f5f4f3; padding: 8px 0; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ccc;" class="clearfix">
                <div class="col-md-2" id="divNumberingScheme">
                    <label style="">Select Numbering Scheme <span style="color: red">*</span></label>
                    <div>
                        <dxe:ASPxComboBox ID="CmbScheme" EnableIncrementalFiltering="true" ClientInstanceName="cCmbScheme"
                            TextField="SchemaName" ValueField="Id"
                            runat="server" ValueType="System.String" Width="100%" EnableSynchronization="True">
                            <ClientSideEvents ValueChanged="function(s,e){CmbScheme_ValueChange()}" GotFocus="NumberingScheme_GotFocus"></ClientSideEvents>
                        </dxe:ASPxComboBox>
                        <span id="MandatoryNumberingScheme" class="iconNumberScheme pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>

                    </div>
                </div>
                <div class="col-md-2">
                    <label>Voucher No <span style="color: red">*</span></label>
                    <div>
                        <asp:TextBox ID="txtVoucherNo" runat="server" Width="100%" MaxLength="30" onchange="txtBillNo_TextChanged()">                             
                        </asp:TextBox>
                        <span id="MandatoryBillNo" class="voucherno  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                        <span id="MandatoryBillNoDUPLICALE" class="voucherno  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Duplicate Voucher No."></span>
                        <%-- <asp:RequiredFieldValidator Display="Dynamic" runat="server" ID="RequiredFieldValidator2" ControlToValidate="txtVoucherNo"
                       SetFocusOnError="true" ErrorMessage="" class="pullrightClass fa fa-exclamation-circle abs iconRed" ToolTip="Mandatory" ValidationGroup="branchgrp" >                                                        
                        </asp:RequiredFieldValidator>--%>
                    </div>
                </div>
                <div class="col-md-2">
                    <label>Date</label>
                    <div>
                        <dxe:ASPxDateEdit ID="tDate" runat="server" EditFormat="Custom" ClientInstanceName="tDate" DisplayFormatString="dd-MM-yyyy"
                            UseMaskBehavior="True" Width="100%" EditFormatString="dd-MM-yyyy">
                            <%-- <ClientSideEvents DateChanged="function(s,e){DateChange()}" />--%>
                            <%-- <ClientSideEvents Init="function(s,e){ s.SetDate(new Date());}" />--%>
                            <ClientSideEvents DateChanged="function(s,e){TDateChange();}" GotFocus="function(s,e){tDate.ShowDropDown();}"></ClientSideEvents>
                            <ValidationSettings RequiredField-IsRequired="true"></ValidationSettings>
                        </dxe:ASPxDateEdit>
                    </div>
                </div>
                <div class="col-md-3">

                    <label style="margin-top: 0">From Branch <span style="color: red">*</span></label>
                    <div>
                        <%-- <asp:DropDownList ID="ddlBranch" runat="server" DataSourceID="dsBranch" onchange="BranchFrom_SelectedIndexChanged()"
                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%">
                        </asp:DropDownList>--%>
                        <asp:DropDownList ID="ddlBranch" runat="server" onchange="BranchFrom_SelectedIndexChanged()"
                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%">
                        </asp:DropDownList>
                        <span id="MandatoryFromBranch" class="FromBranch  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                    </div>
                </div>
                <div class="col-md-3">

                    <label style="margin-top: 0">To Branch <span style="color: red">*</span></label>
                    <div>
                        <%-- <asp:DropDownList ID="ddlBranchTo" runat="server" DataSourceID="dsBranch"
                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%" onchange="batchgridFocus()">
                        </asp:DropDownList>--%>
                        <asp:DropDownList ID="ddlBranchTo" runat="server"
                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%" onchange="batchgridFocus()">
                        </asp:DropDownList>
                        <span id="MandatoryBranchTo" class="BranchTo  pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                    </div>
                </div>
            </div>
            <div>
                <div>
                    <br />
                </div>


                <dxe:ASPxGridView runat="server" ClientInstanceName="grid" ID="grid" KeyFieldName="WithDrawFrom"
                    Width="100%" EnableRowsCache="False" OnCellEditorInitialize="grid_CellEditorInitialize" OnCustomCallback="grid_CustomCallback"
                    OnCustomJSProperties="grid_CustomJSProperties" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" OnInitNewRow="grid_InitNewRow">
                    <SettingsPager Visible="false"></SettingsPager>
                    <Columns>
                        <dxe:GridViewDataComboBoxColumn Caption="Withdrawal From" FieldName="WithDrawFrom" VisibleIndex="1" Width="280px">
                            <PropertiesComboBox ValueField="AccountCode" ClientInstanceName="WithDrawFrom" TextField="IntegrateMainAccount" ClearButton-DisplayMode="Always">
                                <%-- <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>--%>
                                <ClientSideEvents SelectedIndexChanged="Withdrawal_SelectedIndexChanged" GotFocus="calWithdrawalBal" />
                            </PropertiesComboBox>
                        </dxe:GridViewDataComboBoxColumn>
                        <dxe:GridViewDataComboBoxColumn FieldName="DepositInto" Caption="Deposit Into" VisibleIndex="2" Width="280px">
                            <PropertiesComboBox ValueField="AccountCode" ClientInstanceName="DepositInto" TextField="IntegrateMainAccount" ClearButton-DisplayMode="Always">
                                <%-- <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>--%>
                                <ClientSideEvents SelectedIndexChanged="Deposit_SelectedIndexChanged" />
                            </PropertiesComboBox>
                        </dxe:GridViewDataComboBoxColumn>
                        <dxe:GridViewDataComboBoxColumn VisibleIndex="3" FieldName="Currency_ID" Caption="Currency" Width="100px">
                            <PropertiesComboBox ValueField="Currency_ID" ClientInstanceName="CurrencyID" TextField="Currency_AlphaCode">


                                <ClientSideEvents SelectedIndexChanged="SetVisibility" />
                                <ClientSideEvents
                                    LostFocus="function(s,e){
                                    NextFocus(s,e);
                                    }" />
                                <ClientSideEvents />
                            </PropertiesComboBox>
                        </dxe:GridViewDataComboBoxColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="4" Caption="Rate" FieldName="Rate" Width="100px">
                            <PropertiesTextEdit>
                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" />
                                <ClientSideEvents TextChanged="ReceiptTextChange" KeyDown="RateOnKeyDown" />
                                <ClientSideEvents />
                                <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="5" Caption="Amount" FieldName="Amount" Width="100px">
                            <PropertiesTextEdit>
                                <MaskSettings Mask="&lt;0..999999999999999999&gt;.&lt;00..99&gt;" />
                                <ClientSideEvents TextChanged="AutoCalValue" />
                                <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="6" FieldName="CashBankDetail_PaymentAmount" Caption="Amount in Home Currency" Width="100px">
                            <PropertiesTextEdit>
                                <%--  <MaskSettings Mask="<0..999999999999>.<0..9999>" />--%>
                                <MaskSettings Mask="&lt;0..999999999999999999&gt;.&lt;00..99&gt;" />
                                <ClientSideEvents KeyDown="HomeCurrencyOnKeyDown" />
                                <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="7" Caption="Remarks" FieldName="Remarks">
                            <PropertiesTextEdit>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="left" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="8" Caption="Account Group" Visible="false">
                            <PropertiesTextEdit>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                    </Columns>
                    <%--  <ClientSideEvents Init="OnInit" EndCallback="OnEndCallback" />--%>
                    <SettingsDataSecurity AllowEdit="true" />
                    <SettingsEditing Mode="Batch">
                        <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="Row" />
                    </SettingsEditing>
                    <ClientSideEvents EndCallback="function(s, e) {
	                                        LastCall(s.cpHeight);
                                        }" />
                    <Styles>
                        <StatusBar CssClass="statusBar">
                        </StatusBar>
                    </Styles>
                </dxe:ASPxGridView>
                <asp:SqlDataSource ID="batchgrid" runat="server" SelectCommand="Select (select Currency_AlphaCode from Master_Currency where Currency_ID=tc.CashBank_Currency)as Currency_ID,
                (Select top 1 CashBankDetail_PaymentAmount from Trans_CashBankDetail where CashBankDetail_VoucherID=tc.CashBank_ID)as CashBankDetail_PaymentAmount
                from Trans_CashBankVouchers tc  "
                    ConnectionString="<%$ ConnectionStrings:crmConnectionString %>">
                    <SelectParameters>
                        <asp:Parameter Name="CashBank_ID" Type="string" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <div>
                    <br />
                </div>
                <div style="background: #f5f4f3; padding: 8px 0; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ccc;" class="clearfix">
                    <div class="col-md-3">
                        <label id="tdITypeLable" style="">Instrument Type</label>
                        <div style="" id="tdITypeValue">
                            <dxe:ASPxComboBox ID="ComboInstType" runat="server" ClientInstanceName="cComboInstType" Font-Size="12px"
                                ValueType="System.String" Width="100%" EnableIncrementalFiltering="True">
                                <Items>
                                    <%-- <dxe:ListEditItem Text="Select" Value="NA" Selected />--%>
                                    <dxe:ListEditItem Text="Cheque" Value="C" Selected />
                                    <dxe:ListEditItem Text="Draft" Value="D" />
                                    <dxe:ListEditItem Text="E.Transfer" Value="E" />
                                    <%-- <dxe:ListEditItem Text="Cash" Value="CH" />--%>
                                    <dxe:ListEditItem Text="Cash" Value="0" />
                                </Items>
                                <ClientSideEvents SelectedIndexChanged="OnComboInstTypeSelectedIndexChanged" GotFocus="function(s,e){cComboInstType.ShowDropDown();}" />

                            </dxe:ASPxComboBox>
                            <span id="MandatoryInstrumentType" class="iconInstrumentType pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; display: none" title="Mandatory"></span>
                        </div>
                    </div>
                    <div class="col-md-3" id="tdINoDiv" style="">
                        <label id="tdINoLable" style="">Instrument No</label>
                        <div id="tdINoValue">
                            <dxe:ASPxTextBox runat="server" ID="txtInstNo" ClientInstanceName="ctxtInstNo" Width="100%" MaxLength="20">
                                <%--<ClientSideEvents LostFocus="SetInstDate" GotFocus="SetInstDate_OnGotFocus" />--%>
                            </dxe:ASPxTextBox>
                        </div>
                    </div>
                    <div class="col-md-3" id="tdIDateDiv" style="">
                        <label id="tdIDateLable" style="">Instrument Date</label>
                        <div id="tdIDateValue" style="">
                            <dxe:ASPxDateEdit ID="InstDate" runat="server" EditFormat="Custom" ClientInstanceName="cInstDate"
                                UseMaskBehavior="True" Font-Size="12px" Width="100%" EditFormatString="dd-MM-yyyy">
                                <%-- <ClientSideEvents DateChanged="function(s,e){ }" />--%>
                                <%-- <ClientSideEvents Init="function(s,e){ s.SetDate(new Date());}" />--%>
                                <ClientSideEvents DateChanged="function(s,e){InstrumentDateChange();}" GotFocus="function(s,e){cInstDate.ShowDropDown();}"></ClientSideEvents>
                                <ValidationSettings RequiredField-IsRequired="true"></ValidationSettings>
                                <ButtonStyle Width="13px">
                                </ButtonStyle>
                            </dxe:ASPxDateEdit>
                        </div>
                    </div>
                    <div style="clear: both"></div>
                    <div class="col-md-8">
                        <label style="margin-bottom: 5px; display: inline-block">Narration</label>
                        <div>
                            <dxe:ASPxMemo ID="txtNarration" ClientInstanceName="ctxtNarration" runat="server" Height="50px" Width="100%" Font-Names="Arial"></dxe:ASPxMemo>
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>
                <div>
                    <br />
                </div>
                <table style="float: left;">
                    <tr>

                        <td></td>
                        <td>
                            <dxe:ASPxButton ID="btnSaveExit" ClientInstanceName="cbtnexit" runat="server" AutoPostBack="False" Text="Save & Ex&#818;it" OnClick="btnSaveExit_Click"
                                CssClass="btn btn-primary" UseSubmitBehavior="False">
                                <ClientSideEvents Click="function(s, e) {SaveNewButtonClick(s,e);}" />
                            </dxe:ASPxButton>

                        </td>

                    </tr>
                </table>
            </div>

        </div>
        <table class="TableMain100" style="width: 100%">
            <tr>
                <td>
                    <table style="width: 100%;" id="TblSearch" runat="server">
                        <tr>
                            <td>
                                <div class="">
                                </div>


                                <dxe:ASPxGridView ID="Grid_ContraVoucher" runat="server" KeyFieldName="CashBank_ID" AutoGenerateColumns="False"
                                    Width="100%" ClientInstanceName="gvContraVoucherInstance" SettingsBehavior-AllowFocusedRow="true"
                                    SettingsBehavior-AllowSelectSingleRowOnly="false" SettingsBehavior-AllowSelectByRowClick="true" SettingsBehavior-ColumnResizeMode="Control"
                                    DataSourceID="EntityServerModeDataSource" OnCustomJSProperties="Grid_ContraVoucher_CustomJSProperties" 
                                    OnCustomCallback="Grid_ContraVoucher_CustomCallback">
                                    <SettingsSearchPanel Visible="false" />
                                    <Columns>
                                        <dxe:GridViewDataTextColumn FieldName="CashBank_ID" SortOrder="Descending" VisibleIndex="0" Visible="false"></dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="1" Caption="Date" FieldName="CashBank_TransactionDateText" Width="10%">
                                            <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            <%--<PropertiesTextEdit DisplayFormatString="dd/MM/yyyy"></PropertiesTextEdit>--%>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="2" Caption="Voucher No" FieldName="CashBank_VoucherNumber" Width="10%">
                                            <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="3" Caption="Amount" FieldName="CashBankDetail_PaymentAmount" Width="10%">
                                            <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="4" Caption="Narration" FieldName="CashBank_Narration" Settings-AllowAutoFilter="False" Width="20%">
                                            <CellStyle CssClass="gridcellleft"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="5" Caption="Entered By" FieldName="CashBank_CreateUser" Settings-AllowAutoFilter="False" Width="10%">
                                            <CellStyle CssClass="gridcellleft"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="6" Caption="Last Update On" FieldName="CashBank_ModifyDateTime" Settings-AllowAutoFilter="False" Width="15%">
                                            <CellStyle CssClass="gridcellleft"></CellStyle>
                                            <PropertiesTextEdit DisplayFormatString="dd-MM-yyyy hh:mm:ss"></PropertiesTextEdit>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="7" Caption="Updated By" FieldName="CashBank_ModifyUser" Settings-AllowAutoFilter="False" Width="10%">
                                            <CellStyle CssClass="gridcellleft"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn Caption="" VisibleIndex="8" Width="15%">
                                            <CellStyle HorizontalAlign="Center">
                                            </CellStyle>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <HeaderTemplate>
                                                Actions                                   
                                            </HeaderTemplate>
                                            <DataItemTemplate>
                                                <% if (rights.CanView)
                                                   { %>
                                                <a href="javascript:void(0);" onclick="OnView('EDIT~'+'<%# Container.KeyValue %>','<%#Eval("CashBankDetail_BankValueDate") %>')" class="pad">
                                                    <img src="/assests/images/viewIcon.png" alt="View"></a>
                                                <%} %>
                                                <% if (rights.CanEdit)
                                                   { %>
                                                <a href="javascript:void(0);" onclick="OnEdit('EDIT~'+'<%# Container.KeyValue %>','<%#Eval("CashBankDetail_BankValueDate") %>')" class="pad">
                                                    <img src="/assests/images/Edit.png" alt="Edit"></a>
                                                <%} %>
                                                <% if (rights.CanDelete)
                                                   { %>
                                                <a href="javascript:void(0);" onclick="OnGetRowValuesOnDelete('<%# Container.KeyValue %>','<%#Eval("CashBank_TransactionDate") %>','<%#Eval("CashBankDetail_BankValueDate") %>','<%#Eval("CashBank_IBRef") %>')"
                                                    alt="Delete" class="pad">
                                                    <img src="/assests/images/Delete.png" /></a>
                                                <%} %>
                                            </DataItemTemplate>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="9" Caption="" FieldName="CashBankDetail_BankValueDate" Visible="false">
                                            <CellStyle CssClass="gridcellleft"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                        <dxe:GridViewDataTextColumn VisibleIndex="9" Caption="" FieldName="CashBank_IBRef" Visible="false">
                                            <CellStyle CssClass="gridcellleft"></CellStyle>
                                        </dxe:GridViewDataTextColumn>
                                    </Columns>
                                    <SettingsPager PageSize="10">
                                        <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,20,50,100,150,200" />
                                    </SettingsPager>
                                    <Settings ShowGroupPanel="True" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                    <SettingsLoadingPanel Text="Please Wait..." />
                                    <ClientSideEvents EndCallback="function(s,e){ ShowMsgLastCall(s,e);}" />
                                </dxe:ASPxGridView>
                                <dx:LinqServerModeDataSource ID="EntityServerModeDataSource" runat="server" OnSelecting="EntityServerModeDataSource_Selecting"
                                    ContextTypeName="ERPDataClassesDataContext" TableName="v_ContraVoucherList" />
                                <dxe:ASPxGridViewExporter ID="exporter" runat="server">
                                </dxe:ASPxGridViewExporter>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <asp:HiddenField ID="hddn_BranchID" runat="server" />
    <asp:HiddenField ID="hdnBranchIdTo" runat="server" />
    <%--Added BY:Subhabrata--%>
    <asp:HiddenField ID="hdn_CashBankID" runat="server" />
    <asp:HiddenField ID="hdnWithDrawFrom" runat="server" />
    <asp:HiddenField ID="hdnDepositInto" runat="server" />
    <asp:HiddenField ID="hdnCurrency_ID" runat="server" />
    <asp:HiddenField ID="hdnAmountInHomeCurrency" runat="server" />
    <asp:HiddenField ID="hdnRemarks" runat="server" />
    <asp:HiddenField ID="hdnCashBankId" runat="server" />
    <asp:HiddenField ID="hdnCashBankText" runat="server" />
    <asp:HiddenField ID="hdn_CurrentSegment" runat="server" />
    <asp:HiddenField ID="hdn_Mode" runat="server" />
    <asp:HiddenField ID="hdnCashBank_IBRef" runat="server" />
    <asp:HiddenField ID="hdnCashBank_FinYear" runat="server" />
    <asp:HiddenField ID="hdnCashBank_CompanyID" runat="server" />
    <asp:HiddenField ID="hdnCashBank_ExchangeSegmentID" runat="server" />
    <asp:HiddenField ID="hdnVoucherNo" runat="server" />
    <asp:HiddenField ID="hdnType" runat="server" />
    <asp:HiddenField ID="hdnRate" runat="server" />
    <asp:HiddenField ID="hdnAmount" runat="server" />
    <asp:HiddenField ID="hdnBtnValue" runat="server" />
    <asp:HiddenField ID="hdnDbSaveCurrenct" runat="server" />

    <%-- <asp:SqlDataSource ID="dsBranch" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        ConflictDetection="CompareAllValues"
        SelectCommand="SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH where Cast(branch_id as nvarchar(max)) in(@userbranchHierarchy)">
         <SelectParameters>
            <asp:SessionParameter Name="userbranchHierarchy" SessionField="userbranchHierarchy" />
         </SelectParameters>
        </asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="dsBranch" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="Prc_Search_ContraVoucher" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Type="String" Name="Action" DefaultValue="GetbranchListTo" />
            <asp:SessionParameter Name="BranchList" SessionField="userbranchHierarchy" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlSchematype" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="Select * From ((Select '0' as ID,'Select' as SchemaName) Union (Select ID,SchemaName From tbl_master_Idschema  Where TYPE_ID='6' AND Isnull(Branch,'')=@userbranchID AND Isnull(comapanyInt,'')=@LastCompany)) as X Order By ID ASC">
        <SelectParameters>
            <asp:SessionParameter Name="LastCompany" SessionField="LastCompany" />
            <asp:SessionParameter Name="userbranchID" SessionField="userbranchID" />
        </SelectParameters>
    </asp:SqlDataSource>
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
