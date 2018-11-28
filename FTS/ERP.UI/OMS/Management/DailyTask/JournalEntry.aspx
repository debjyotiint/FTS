﻿<%@ Page Title="Journal Entry" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="JournalEntry.aspx.cs" Inherits="ERP.OMS.Management.DailyTask.JournalVoucherEntry" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="../Activities/JS/SearchPopup.js"></script>
    <script>

        var globalRowIndex;
        function OnAddButtonClick() {
            $("#divIsPartyJournal").hide();
            document.getElementById('tblBtnSavePanel').style.display = 'block';
            document.getElementById('divAddNew').style.display = 'block';
            document.getElementById('ddl_AmountAre').value = 3;
            TblSearch.style.display = "none";
            btncross.style.display = "block";
            $('#<%=hdnMode.ClientID %>').val('0'); //Entry
            $('#<%= lblHeading.ClientID %>').text("Add Journal Voucher");
            var defaultbranch = '<%=Session["userbranchID"]%>';
            $('#<%=hdnBranchId.ClientID %>').val(defaultbranch);
            var CmbScheme = document.getElementById("<%=CmbScheme.ClientID%>");
            CmbScheme.options[0].selected = true;

            // CountryID.PerformCallback(document.getElementById('ddlBranch').value);

            grid.AddNewRow();
            grid.batchEditApi.EndEdit();
            document.getElementById("<%=CmbScheme.ClientID%>").focus();

            cbtnSaveRecords.SetVisible(false);
            cbtn_SaveRecords.SetVisible(false);
            //loadCurrencyMassage.style.display = "block";

        }


        function GetVisibleIndex(s, e) {
            globalRowIndex = e.visibleIndex;
            // EnableOrDisableTax();
        }
        function OnlyNarration() {

        }
        function CloseSubModal() {
            $('#SubAccountModel').modal('hide');
            grid.batchEditApi.StartEdit(globalRowIndex, 2);

        }
        $(document).ready(function () {
            $('#MainAccountModel').on('shown.bs.modal', function () {
                $('#txtMainAccountSearch').val("");
                $('#txtMainAccountSearch').focus();
            })
            $('#SubAccountModel').on('shown.bs.modal', function () {
                $('#txtSubAccountSearch').val("");
                $('#txtSubAccountSearch').focus();
            })
            $('#SubAccountModel').on('hide.bs.modal', function () {

                //grid.batchEditApi.StartEdit(globalRowIndex, 2);
            })
        });

        function closeModal() {

            var MainAccountID = grid.GetEditor("gvMainAcCode").GetValue();
            if (MainAccountID == 'Customers' || MainAccountID == 'Vendors') {
                if ($("#hdnIsPartyLedger").val() == "") {
                    $("#hdnIsPartyLedger").val('1');
                }
                else {
                    $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) + 1);
                }

            }
            if (parseFloat($("#hdnIsPartyLedger").val()) > 1) {
                $("#divIsPartyJournal").show();
            }
            else {
                $("#divIsPartyJournal").hide();
            }
            $('#MainAccountModel').modal('hide');
            grid.batchEditApi.StartEdit(globalRowIndex, 1);
        }





        ////This Method is Used For Checking Lock Date and Financial Year and Alert User For That if Date OutSide
        function DateChange() {

            var Ctype = $('#<%=hdnMode.ClientID %>').val();
            if (Ctype != 1) {
                var SelectedDate = new Date(tDate.GetDate());
                var monthnumber = SelectedDate.getMonth();
                var monthday = SelectedDate.getDate();
                var year = SelectedDate.getYear();

                var SelectedDateValue = new Date(year, monthnumber, monthday);
                ///Checking of Transaction Date For MaxLockDate
                var MaxLockDate = new Date('<%=Session["LCKJV"]%>');
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
            }

            var FYS = "<%=Session["FinYearStart"]%>";
            var FYE = "<%=Session["FinYearEnd"]%>";
            var LFY = "<%=Session["LastFinYear"]%>";
            var SelectedDate = new Date(tDate.GetDate());
            var FinYearStartDate = new Date(FYS);
            var FinYearEndDate = new Date(FYE);
            var LastFinYearDate = new Date(LFY);

            var monthnumber = SelectedDate.getMonth();
            var monthday = SelectedDate.getDate();
            var year = SelectedDate.getYear();

            var SelectedDateValue = new Date(year, monthnumber, monthday);

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
                if (grid.GetVisibleRowsOnPage() == 1) {
                    //grid.batchEditApi.StartEdit(-1, 1);
                }
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
        }

        //-------------- New for Pop Up -------------------------------------
        var IsSubAccount = '';
        function MainPopUpHide() {

            var MainAccountID = grid.GetEditor("gvMainAcCode").GetValue();
            if (MainAccountID == 'Customers' || MainAccountID == 'Vendors') {
                if ($("#hdnIsPartyLedger").val() == "") {
                    $("#hdnIsPartyLedger").val('1');
                }
                else {
                    $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) + 1);
                }

            }

            cMainAccountpopUp.Hide();
            grid.batchEditApi.StartEdit(globalRowIndex, 1);
        }
        function SubPopUpHide() {
            cSubAccountpopUp.Hide();
            grid.batchEditApi.StartEdit(globalRowIndex, 2);
        }

        var LastCr = 0.00;
        var LastDr = 0.00;

        function MainAccountButnClick(s, e) {

            var txt = "<table border='1' width=\"100%\"><tr class=\"HeaderStyle\"><th>Main Account Name</th><th>Short Name</th><th>Subledger Type</th></tr><table>";
            document.getElementById("MainAccountTable").innerHTML = txt;

            if (e.buttonIndex == 0) {
                $('#mainActMsg').hide();
                var FullName = new Array("", "");

                var MainAccountID = grid.GetEditor("gvMainAcCode").GetValue();
                if (MainAccountID == 'Customers' || MainAccountID == 'Vendors') {
                    if ($("#hdnIsPartyLedger").val() == "") {
                        $("#hdnIsPartyLedger").val('1');
                    }
                    else {
                        $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) - 1);
                    }

                }





                shouldCheck = 1;
                cMainAccountComboBox.AddItem(FullName, "");
                cMainAccountComboBox.SetText("");
                grid.batchEditApi.StartEdit(e.visibleIndex);
                var strMainAccountID = (grid.GetEditor('MainAccount').GetText() != null) ? grid.GetEditor('MainAccount').GetText() : "0";

                LastCr = parseFloat(grid.GetEditor('Receipt').GetText());
                LastDr = parseFloat(grid.GetEditor('WithDrawl').GetText());

                if (strMainAccountID != "") {
                    var strMainAccountID = "PREVIOUS MAIN ACCOUNT :" + strMainAccountID;

                }
                // LabelMainAccount.SetText(strMainAccountID);
                $("#LabelMainAccount").val(strMainAccountID);
                //cMainAccountpopUp.Show();
                $('#MainAccountModel').modal('show');
                cMainAccountComboBox.Focus();

            }
        }
        function SubAccountButnClick(s, e) {


            txt = " <table border='1' width=\"100%\"><tr class=\"HeaderStyle\"><th>Sub Account Name [Unique Id]</th><th>Sub Account Code</th></tr></table>";
            document.getElementById("SubAccountTable").innerHTML = txt;

            $("#mainActMsgSub").hide();
            if (IsSubAccount != 'None') {
                grid.batchEditApi.StartEdit(e.visibleIndex);
                var strMainAccountID = (grid.GetEditor('MainAccount').GetText() != null) ? grid.GetEditor('MainAccount').GetText() : "0";
                var MainAccountID = (grid.GetEditor('gvColMainAccount').GetValue() != null) ? grid.GetEditor('gvColMainAccount').GetValue() : "0";
                if (e.buttonIndex == 0) {
                    if (strMainAccountID.trim() != "") {
                        document.getElementById('hdnMainAccountId').value = MainAccountID;
                        var FullName = new Array("", "");
                        cSubAcountComboBox.AddItem(FullName, "");
                        cSubAcountComboBox.SetValue("");
                        $('#SubAccountModel').modal('show');
                        //cSubAccountpopUp.Show();
                        cSubAcountComboBox.Focus();
                        var strSubLBLAccountID = (grid.GetEditor('bthSubAccount').GetText() != null) ? grid.GetEditor('bthSubAccount').GetText() : "0";
                        if (strSubLBLAccountID != "") {
                            var strSubLBLAccountID = "Previous Sub Account :" + strSubLBLAccountID;

                        }
                        // $("#LabelMainAccount").val(strSubLBLAccountID);
                    }
                }
            }
        }
        function MainAccountKeyDown(s, e) {
            if (e.htmlEvent.key == "Enter") {

                s.OnButtonClick(0);
                //$('#MainAccountModel').modal('show');
            }
            //if (e.htmlEvent.key == "Tab") {

            //    s.OnButtonClick(0);
            //}
        }
        function SubAccountKeyDown(s, e) {
            $("#mainActMsgSub").hide();
            if (e.htmlEvent.key == "Enter") {

                s.OnButtonClick(0);
            }

            // if (e.htmlEvent.key == "Tab") {

            //   s.OnButtonClick(0);
            //}
        }
        function MainAccountComboBoxKeyDown(s, e) {
            if (e.htmlEvent.key == "Escape") {


                var MainAccountID = grid.GetEditor("gvMainAcCode").GetValue();
                if (MainAccountID == 'Customers' || MainAccountID == 'Vendors') {
                    if ($("#hdnIsPartyLedger").val() == "") {
                        $("#hdnIsPartyLedger").val('1');
                    }
                    else {
                        $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) + 1);
                    }

                }


                cMainAccountpopUp.Hide();
                grid.batchEditApi.StartEdit(globalRowIndex, 1);
            }
            //if (e.htmlEvent.key == "Enter") {
            //    var MainAccountText = cMainAccountComboBox.GetText();
            //    console.log(MainAccountText,'next');



            //    //if (!cMainAccountComboBox.FindItemByText(MainAccountText) && MainAccountText != "") {

            //    //    jAlert("Main Account does not Exist.");
            //    //    cMainAccountComboBox.SetText("");
            //    //    return;
            //    //} 

            //}
        }

        function SubAccountComboBoxKeyDown(s, e) {
            if (e.htmlEvent.key == "Escape") {
                cSubAccountpopUp.Hide();
                grid.batchEditApi.StartEdit(globalRowIndex, 2);
            }
            if (e.htmlEvent.key == "Enter") {
                GetSubAcountComboBox(e);
            }
        }

        var shouldCheck = 0;

        function GetMainAcountComboBox(Id, Name, Code, IsSub) {
            $('#mainActMsg').hide();

            //var MainAccountText = cMainAccountComboBox.GetText();
            var MainAccountText = Name;
            console.log(MainAccountText, shouldCheck);

            if (shouldCheck != 1) {
                return;
            }


            //if (!cMainAccountComboBox.FindItemByText(MainAccountText)) {
            //    //  jAlert("Main Account does not Exist.", 'Alert', function () { shouldCheck = 1; cMainAccountComboBox.Focus(); });
            //    $('#mainActMsg').show();
            //    shouldCheck = 1;
            //    //cMainAccountComboBox.SetText("");
            //    //  return;
            //} else {

            //if (e.keyCode == 27)//escape 
            //{
            //    grid.batchEditApi.StartEdit(globalRowIndex, 1);
            //    return;
            //}
            cMainAccountpopUp.Hide();


            var MainAccountID = Id;
            //var ReverseApplicable = cMainAccountComboBox.GetSelectedItem().texts[2];
            //var TaxApplicable = cMainAccountComboBox.GetSelectedItem().texts[3];
            //var MainAcCode = cMainAccountComboBox.GetSelectedItem().texts[4];
            var MainAcCode = Code;
            // IsSubAccount = cMainAccountComboBox.GetSelectedItem().texts[1];
            IsSubAccount = IsSub;
            // grid.batchEditApi.StartEdit(globalRowIndex);
            grid.batchEditApi.StartEdit(globalRowIndex, 2);
            grid.GetEditor("MainAccount").SetText(MainAccountText);
            grid.GetEditor("gvColMainAccount").SetText(MainAccountID);
            grid.GetEditor("gvMainAcCode").SetValue(IsSub);
            // grid.GetEditor("ReverseApplicable").SetValue(ReverseApplicable);
            shouldCheck = 0;//
            grid.GetEditor("bthSubAccount").SetValue("");
            grid.GetEditor("Receipt").SetValue("");
            grid.GetEditor("WithDrawl").SetValue("");
            grid.GetEditor("gvColSubAccount").SetValue("");



            if (LastDr != 0)
                c_txt_Debit.SetValue(c_txt_Debit.GetValue() - LastDr);
            if (LastCr != 0)
                c_txt_Credit.SetValue(c_txt_Credit.GetValue() - LastCr);

            var Debit = parseFloat(c_txt_Debit.GetValue());
            var Credit = parseFloat(c_txt_Credit.GetValue());

            if (Debit == 0 && Credit == 0) {
                cbtnSaveRecords.SetVisible(false);
                cbtn_SaveRecords.SetVisible(false);
                loadCurrencyMassage.style.display = "block";
            }
            else if (Debit == Credit) {
                cbtnSaveRecords.SetVisible(true);
                cbtn_SaveRecords.SetVisible(true);
                loadCurrencyMassage.style.display = "none";
            }
            else if (Debit != Credit) {
                cbtnSaveRecords.SetVisible(false);
                cbtn_SaveRecords.SetVisible(false);
                loadCurrencyMassage.style.display = "block";
            }

            LastDr = 0.00;
            LastCr = 0.00;




            if (IsSub == 'Customers' || IsSub == 'Vendors') {
                if ($("#hdnIsPartyLedger").val() == "") {
                    $("#hdnIsPartyLedger").val('1');
                }
                else {
                    $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) + 1);
                }

            }

            if (parseFloat($("#hdnIsPartyLedger").val()) > 1) {
                $("#divIsPartyJournal").show();
            }
            else {
                $("#divIsPartyJournal").hide();
            }

            grid.batchEditApi.StartEdit(globalRowIndex, 2);
            //cddl_AmountAre.SetEnabled(false);
            //$("#IsTaxApplicable").val(TaxApplicable);
            //var VoucherType = document.getElementById('rbtnType').value;
            //if (ReverseApplicable == "1" && VoucherType == "P") {
            //    $("#chk_reversemechenism").prop("disabled", false);
            //    $("#chk_reversemechenism").prop("checked", true);
            //}
            //else {
            //    if ($("#chk_reversemechenism").prop('checked') == false) {
            //        $("#chk_reversemechenism").prop("checked", false);
            //    }
            //}
            //}
        }



        $(function () {
            $('#MainAccountModel').modal({
                backdrop: 'static',
                keyboard: false
            });
        })


        function GetSubAcountComboBox(Id, Name) {
            //if (cSubAcountComboBox.GetText() != "") {
            //    if (!cSubAcountComboBox.FindItemByValue(cSubAcountComboBox.GetValue())) {
            //        //jAlert("Sub Account does not Exist.", "Alert", function () { cSubAcountComboBox.SetValue(); cSubAcountComboBox.Focus(); });
            //        //return;
            //        $("#mainActMsgSub").show();
            //    }

            //    else {
            //        if (e.keyCode == 27)//escape 
            //        {
            //            grid.batchEditApi.StartEdit(globalRowIndex, 2);
            //            return;
            //        }
            //var subAccountText = cSubAcountComboBox.GetText();
            var subAccountText = Name;
            //var subAccountID = cSubAcountComboBox.GetValue();
            //  grid.batchEditApi.StartEdit(globalRowIndex);
            var subAccountID = Id;
            grid.batchEditApi.StartEdit(globalRowIndex, 3);

            grid.GetEditor("bthSubAccount").SetText(subAccountText);
            grid.GetEditor("gvColSubAccount").SetText(subAccountID);
            cSubAccountpopUp.Hide();
            grid.batchEditApi.StartEdit(globalRowIndex, 3);
            //}
            //}
        }

        //-------------------------------------------------------------------------------
        function CustomButtonClick(s, e) {
            var TransactionDate = new Date(tDate.GetDate());
            monthnumber = TransactionDate.getMonth();
            monthday = TransactionDate.getDate();
            year = TransactionDate.getYear();
            var TransactionDateNumeric = new Date(year, monthnumber, monthday).getTime();

            var MaxLockDate = new Date('<%=Session["LCKJV"]%>');
            monthnumber = MaxLockDate.getMonth();
            monthday = MaxLockDate.getDate();
            year = MaxLockDate.getYear();
            var MaxLockDateNumeric = new Date(year, monthnumber, monthday).getTime();

            if (TransactionDateNumeric <= MaxLockDateNumeric) {
                jAlert('This Entry has been Locked.You Can Only View The Detail');
                return;
                //VisibleIndexE = e.visibleIndex;
                //cGvJvSearch.PerformCallback('PCB_BtnOkE~' + e.visibleIndex);
                //return;
            }

            if (e.buttonID == 'CustomBtnEdit') {
                VisibleIndexE = e.visibleIndex;
                $('#<%= lblHeading.ClientID %>').text("Modify Journal Voucher");
                $('#<%=hdnMode.ClientID %>').val('1');
                document.getElementById('div_Edit').style.display = 'none';
                document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;

                document.getElementById('tblBtnSavePanel').style.display = 'block';
                document.getElementById('divAddNew').style.display = 'block';
                btncross.style.display = "block";
                TblSearch.style.display = "none";
                //cGvJvSearch.GetRowValues(VisibleIndexE, "BranchID", MainAccountCallBack);
                grid.PerformCallback('Edit~' + VisibleIndexE);
                LoadingPanel.Show();
            }

            if (e.buttonID == 'CustomBtnView') {
                VisibleIndexE = e.visibleIndex;
                $('#<%= lblHeading.ClientID %>').text("View Journal Voucher");
                $('#<%=hdnMode.ClientID %>').val('1');
                document.getElementById('div_Edit').style.display = 'none';
                document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;

            document.getElementById('divAddNew').style.display = 'block';
            btncross.style.display = "block";
            TblSearch.style.display = "none";
                //cGvJvSearch.GetRowValues(VisibleIndexE, "BranchID", MainAccountCallBack);
            grid.PerformCallback('Edit~' + VisibleIndexE);
            document.getElementById('tblBtnSavePanel').style.display = 'none';
            LoadingPanel.Show();
        }

        else if (e.buttonID == 'CustomBtnDelete') {
            VisibleIndexE = e.visibleIndex;

            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    cGvJvSearch.PerformCallback('PCB_DeleteBtnOkE~' + VisibleIndexE);
                }
            });
        }
        else if (e.buttonID == 'CustomBtnPrint') {
            var keyValueindex = e.visibleIndex;
            //jConfirm('Do you want to Print?', 'Confirmation Dialog', function (r) {
            //    if (r == true) {
            //cGvJvSearch.GetRowValues(keyValueindex, "JvID", onPrintJv)
            var keyValueindex = s.GetRowKey(e.visibleIndex);
            onPrintJv(keyValueindex);
            //            }
            //        });
            //    }
        }
    }


    function onPrintJv(id) {

        RecPayId = id;
        cDocumentsPopup.Show();
        cSelectPanel.cpSuccess = "";
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

        if (cSelectPanel.cpSuccess != "") {
            var TotDocument = cSelectPanel.cpSuccess.split(',');
            var reportName = cCmbDesignName.GetValue();
            var module = 'JOURNALVOUCHER';
            window.open("../../Reports/REPXReports/RepxReportViewer.aspx?Previewrpt=" + reportName + '&modulename=' + module + '&id=' + RecPayId, '_blank')
        }
        if (cSelectPanel.cpSuccess == "") {
            cCmbDesignName.SetSelectedIndex(0);
        }
    }




    //function onPrintJv(id) {
    //    window.location.href = "../../reports/XtraReports/JournalVoucherReportViewer.aspx?id=" + id;
    //}

    function MainAccountCallBack(branch) {
        // CountryID.PerformCallback(branch);
    }

    function GvJvSearch_EndCallBack() {
        if (cGvJvSearch.cpJVDelete != undefined && cGvJvSearch.cpJVDelete != null) {
            jAlert(cGvJvSearch.cpJVDelete);
            cGvJvSearch.cpJVDelete = null;
            updateGridByDate()
            //cGvJvSearch.PerformCallback('PCB_BindAfterDelete');
        }
    }
    function GridFullInfo_EndCallBack() {
        if (cGvJvSearch.cpJVDelete != undefined && cGvJvSearch.cpJVDelete != null) {
            jAlert(cGvJvSearch.cpJVDelete);
            cGvJvSearch.cpJVDelete = null;
            cGvJvSearch.PerformCallback('PCB_BindAfterDelete');
        }
    }


    var currentEditableVisibleIndex;
    var preventEndEditOnLostFocus = false;
    var lastCountryID;
    var setValueFlag;
    var debitOldValue;
    var debitNewValue;
    var CreditOldValue;
    var CreditNewValue;

    function CountriesCombo_SelectedIndexChanged(s, e) {
        var currentValue = grid.GetEditor('gvColMainAccount').GetValue();
        var Narration = grid.GetEditor('Narration');
        var currentValue = s.GetValue();
        if (lastCountryID == currentValue) {
            Narration.SetValue(NarrationText);
            return;
        }
        lastCountryID = currentValue;
        //CityID.PerformCallback(currentValue + '~' + "");
    }
    function IntializeGlobalVariables(grid) {
        lastCountryID = grid.cplastCountryID;
        currentEditableVisibleIndex = -1;
        setValueFlag = -1;
    }
    function OnInit(s, e) {
        IntializeGlobalVariables(s);
        
    }

    function OnEndCallback(s, e) {
        IntializeGlobalVariables(s);
        LoadingPanel.Hide();

        if (grid.cpEdit != null) {
            //grid.ShowLoadingPanel();
            //LoadingPanel.Show();
            var VoucherNo = grid.cpEdit.split('~')[0];
            var Narration = grid.cpEdit.split('~')[1];
            var BranchID = grid.cpEdit.split('~')[2];
            var Credit = grid.cpEdit.split('~')[3];
            var Debit = grid.cpEdit.split('~')[4];
            var trDate = grid.cpEdit.split('~')[5];
            var PlaceOfSupply = grid.cpEdit.split('~')[6];
            var TaxOption = grid.cpEdit.split('~')[7];
            var IsPartyJournal = grid.cpEdit.split('~')[8];
            var PartyCount = grid.cpEdit.split('~')[9];

            $("#hdnIsPartyLedger").val(PartyCount);
            if (IsPartyJournal == 'True') {
                $("#divIsPartyJournal").show();
            }

            document.getElementById('txtBillNo').value = VoucherNo;
            document.getElementById('txtNarration').value = Narration;
            document.getElementById('ddlSupplyState').value = PlaceOfSupply;
            document.getElementById('ddl_AmountAre').value = TaxOption;
                <%--var ddlBranch = document.getElementById("<%=ddlBranch.ClientID%>");
                ddlBranch.options[BranchID].selected = true;--%>
                <%--var ddlBranch = document.getElementById("<%=ddlBranch.ClientID%>");
                ddlBranch.Items.FindByValue(BranchID).Selected = true;--%>

                //var dropdownlistbox = document.getElementById("ddlBranch")

                //for (var x = 0; x < dropdownlistbox.length - 1 ; x++) {
                //    if (BranchID == dropdownlistbox.options[x].value) {
                //        dropdownlistbox.selectedIndex = x;
                //        break;
                //    }
                //}

                document.getElementById('ddlBranch').value = BranchID;
                document.getElementById('<%= ddlBranch.ClientID %>').disabled = true;
                var Transdt = new Date(trDate);
                tDate.SetDate(Transdt);

                //Bind again the main account with respect to branch
                // CountryID.PerformCallback(BranchID);
                var strSchemaType = document.getElementById('hdnSchemaType').value;
                var RefreshType = document.getElementById('hdnRefreshType').value;

                c_txt_Credit.SetValue(Credit);
                c_txt_Debit.SetValue(Debit);

                if (Debit == Credit) {
                    cbtnSaveRecords.SetVisible(true);
                    cbtn_SaveRecords.SetVisible(true);
                    loadCurrencyMassage.style.display = "none";
                }
                else {
                    cbtnSaveRecords.SetVisible(false);
                    cbtn_SaveRecords.SetVisible(false);
                    loadCurrencyMassage.style.display = "block";
                }
            }

            var value = document.getElementById('hdnRefreshType').value;

            if (grid.cpSaveSuccessOrFail == "outrange") {
                jAlert('Can Not Add More Journal Voucher as Journal Scheme Exausted.<br />Update The Scheme and Try Again');
            }
            else if (grid.cpSaveSuccessOrFail == "duplicate") {
                jAlert('Can Not Save as Duplicate Journal Voucher No. Found');
            }
            else if (grid.cpSaveSuccessOrFail == "errorInsert") {
                jAlert('Try again later.');
            }
            else if (grid.cpSaveSuccessOrFail == "HasError") {
                jAlert('Selected Ledgers are not mapped with RCM Ledger in Masters - Accounts - Tax Component Scheme. Cannot Proceed.');

                for (var i = 0; i <= grid.GetVisibleRowsOnPage() ; i++) {
                    grid.batchEditApi.StartEdit(i, 1);
                }


                grid.AddNewRow();
            }
            else if (grid.cpSaveSuccessOrFail == "successInsert") {
                $("#divIsPartyJournal").hide();
                var JV_Number = grid.cpVouvherNo;
                var JV_Msg = "Journal Voucher No. " + JV_Number + " generated.";
                var strSchemaType = document.getElementById('hdnSchemaType').value;

                if (value == "E") {
                    var IsComplete = "0";

                    if (JV_Number != "") {
                        jAlert(JV_Msg, 'Alert Dialog: [Journal Voucher]', function (r) {
                            if (r == true) {
                                window.location.reload();
                            }
                        });
                    } else {
                        window.location.reload();
                    }
                }
                else if (value == "S") {
                    var IsComp = "0";

                    if (JV_Number != "") {
                        jAlert(JV_Msg, 'Alert Dialog: [Journal Voucher]', function (r) {
                            if (r == true) {
                                IsComp = "1";
                            }
                        });
                    }
                    else {
                        IsComp = "1";
                    }

                    if (IsComp == "1") {
                <%--$('#<%=hdnMode.ClientID %>').val('0');
                    document.getElementById('div_Edit').style.display = 'block';
                    cbtnSaveRecords.SetVisible(false);
                    cbtn_SaveRecords.SetVisible(false);
                    grid.PerformCallback('BlanckEdit');--%>

                        grid.AddNewRow();
                        $('#<%=hdnMode.ClientID %>').val('0');

                        $('#<%= lblHeading.ClientID %>').text("Add Journal Voucher");

                        cbtnSaveRecords.SetVisible(false);
                        cbtn_SaveRecords.SetVisible(false);
                        loadCurrencyMassage.style.display = "block";

                        document.getElementById('div_Edit').style.display = 'block';
                        document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
                        //cCmbScheme.SetValue("0");
                        document.getElementById('<%= txtBillNo.ClientID %>').value = "";
                        document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
                        c_txt_Debit.SetValue("0");
                        c_txt_Credit.SetValue("0");
                        document.getElementById('<%= txtNarration.ClientID %>').value = "";
                        //cCmbScheme.Focus();

                        if (strSchemaType == "0") {
                            document.getElementById('<%= txtBillNo.ClientID %>').disabled = false;
                            document.getElementById('<%= txtBillNo.ClientID %>').value = "";
                            //document.getElementById("txtBillNo").focus();
                            //cCmbScheme.Focus();

                            document.getElementById("CmbScheme").focus();
                        }
                        else if (strSchemaType == "1") {
                            document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
                            document.getElementById('<%= txtBillNo.ClientID %>').value = "Auto";
                            grid.batchEditApi.StartEdit(-1, 1);
                        }
                        else if (strSchemaType == "2") {
                            document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
                            document.getElementById('<%= txtBillNo.ClientID %>').value = "Datewise";
                            grid.batchEditApi.StartEdit(-1, 1);
                        }
                        else {
                            //cCmbScheme.SetValue("0");
                            //cCmbScheme.Focus();

                            document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
                            document.getElementById('<%= txtBillNo.ClientID %>').value = "";

                            var CmbScheme = document.getElementById("<%=CmbScheme.ClientID%>");
                            CmbScheme.options[0].selected = true;
                            document.getElementById("CmbScheme").focus();
                        }
            }
            else {
                grid.AddNewRow();
            }
        }
}
else {
    grid.AddNewRow();
}

}
var NarrationText;
function CitiesCombo_EndCallback(s, e) {
    //if (setValueFlag == -1)
    //    s.SetSelectedIndex(0);
    //else if (setValueFlag > -1) {
    //    CityID.SetSelectedItem(CityID.FindItemByValue(setValueFlag));
    //    setValueFlag = -1;
    //}

    if (CityID.cpIsRCM != null) {
        //grid.ShowLoadingPanel();
        //LoadingPanel.Show();
        var Narration = grid.GetEditor('Narration');
        var IsRcm = CityID.cpIsRCM;
        var TaxOption = document.getElementById('ddl_AmountAre').value;
        if (TaxOption == 1) {
            if (IsRcm == 1) {
                Narration.SetValue('RCM');
                NarrationText = 'RCM';
            }
            else if (IsRcm == 0) {
                Narration.SetValue('');
                NarrationText = '';
            }
        }
    }

    if (setValueFlag == null || setValueFlag == "0" || setValueFlag == "") {
        s.SetSelectedIndex(-1);
    }
    else {
        if (CityID.FindItemByValue(setValueFlag) != null) {
            CityID.SetValue(setValueFlag);
            setValueFlag = null;
        }
    }

    LoadingPanel.Hide();
    //LoadingPanel.Hide();
    //grid.HideLoadingPanel();
}
function OnBatchEditStartEditing(s, e) {
    currentEditableVisibleIndex = e.visibleIndex;
    globalRowIndex = e.visibleIndex;
    var currentCountryID = grid.batchEditApi.GetCellValue(currentEditableVisibleIndex, "gvColMainAccount");
    var cityIDColumn = s.GetColumnByField("CityID");




    //if (!e.rowValues.hasOwnProperty(cityIDColumn.index))
    //    return;
    //var cellInfo = e.rowValues[cityIDColumn.index];

    //if (lastCountryID == currentCountryID) {
    //    if (CityID.FindItemByValue(cellInfo.value) != null) {
    //        CityID.SetValue(cellInfo.value);
    //    }
    //    else {
    //        RefreshData(cellInfo, lastCountryID);
    //        LoadingPanel.Show();
    //    }
    //}
    //else {
    //    if (currentCountryID == null) {
    //        CityID.SetSelectedIndex(-1);
    //        return;
    //    }
    //    lastCountryID = currentCountryID;
    //    RefreshData(cellInfo, lastCountryID);
    //    LoadingPanel.Show();
    //}

    //setValueFlag = cellInfo.value;
    //CityID.PerformCallback(currentCountryID);
    //LoadingPanel.Show();
}
function RefreshData(cellInfo, countryID) {
    setValueFlag = cellInfo.value;
    CityID.PerformCallback(countryID + '~' + setValueFlag);

    //setTimeout(function () {
    //    CityID.PerformCallback(countryID);
    //}, 0);
}
//Debjyoti 
function OnCustomButtonClick(s, e) {
    if (e.buttonID == 'CustomDelete') {
        grid.batchEditApi.EndEdit();
        var noofvisiblerows = grid.GetVisibleRowsOnPage();

        if (noofvisiblerows != "1") {
            var debit = grid.batchEditApi.GetCellValue(e.visibleIndex, "WithDrawl");
            var credit = grid.batchEditApi.GetCellValue(e.visibleIndex, "Receipt");
            if (debit != 0)
                c_txt_Debit.SetValue(c_txt_Debit.GetValue() - debit);
            if (credit != 0)
                c_txt_Credit.SetValue(c_txt_Credit.GetValue() - credit);

            var Debit = parseFloat(c_txt_Debit.GetValue());
            var Credit = parseFloat(c_txt_Credit.GetValue());

            if (Debit == 0 && Credit == 0) {
                cbtnSaveRecords.SetVisible(false);
                cbtn_SaveRecords.SetVisible(false);
                loadCurrencyMassage.style.display = "block";
            }
            else if (Debit == Credit) {
                cbtnSaveRecords.SetVisible(true);
                cbtn_SaveRecords.SetVisible(true);
                loadCurrencyMassage.style.display = "none";
            }
            else {
                cbtnSaveRecords.SetVisible(false);
                cbtn_SaveRecords.SetVisible(false);
                loadCurrencyMassage.style.display = "block";
            }
            
            var MainAccountID = grid.batchEditApi.GetCellValue(e.visibleIndex, "gvMainAcCode"); //grid.GetEditor("gvColMainAccount").GetValue();

            //	Customers //	Vendors
            if (MainAccountID == 'Customers' || MainAccountID == 'Vendors') {
                if ($("#hdnIsPartyLedger").val() == "") {
                    $("#hdnIsPartyLedger").val('1');
                }
                else {
                    $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) - 1);
                }

            }



            grid.DeleteRow(e.visibleIndex);

            if (parseFloat($("#hdnIsPartyLedger").val()) > 1) {
                $("#divIsPartyJournal").show();
            }
            else {
                $("#divIsPartyJournal").hide();
            }

            var type = $('#<%=hdnMode.ClientID %>').val();
            if (type == '1') {
                var IsJournal = "";
                for (var i = 0; i < grid.GetVisibleRowsOnPage() ; i++) {
                    var frontProduct = (grid.batchEditApi.GetCellValue(i, 'gvColMainAccount') != null) ? (grid.batchEditApi.GetCellValue(i, 'gvColMainAccount')) : "";

                    if (frontProduct == "") {
                        IsJournal = "N";
                        break;
                    }
                }

                if (IsJournal == "") {
                    grid.StartEditRow(0);
                }
            }
        }
    }
}


function CreditGotFocus(s, e) {
    CreditOldValue = s.GetText();
    var indx = CreditOldValue.indexOf(',');
    if (indx != -1) {
        CreditOldValue = CreditOldValue.replace(/,/g, '');
    }
}

function CreditLostFocus(s, e) {
    CreditNewValue = s.GetText();
    var indx = CreditNewValue.indexOf(',');
    if (indx != -1) {
        CreditNewValue = CreditNewValue.replace(/,/g, '');
    }

    if (CreditOldValue != CreditNewValue) {
        changeCreditTotalSummary();
    }
}
function changeCreditTotalSummary() {
    var newDif = CreditOldValue - CreditNewValue;
    var CurrentSum = c_txt_Credit.GetText();
    var indx = CurrentSum.indexOf(',');
    if (indx != -1) {
        CurrentSum = CurrentSum.replace(/,/g, '');
    }

    c_txt_Credit.SetValue(parseFloat(DecimalRoundoff((CurrentSum - newDif), 2)));
}
function recalculateCredit(oldVal) {
    if (oldVal != 0) {
        CreditNewValue = 0;
        CreditOldValue = oldVal;
        changeCreditTotalSummary();
    }
}

function DebitGotFocus(s, e) {
    debitOldValue = s.GetText();
    var indx = debitOldValue.indexOf(',');
    if (indx != -1) {
        debitOldValue = debitOldValue.replace(/,/g, '');
    }
}

function DebitLostFocus(s, e) {
    debitNewValue = s.GetText();
    var indx = debitNewValue.indexOf(',');

    if (indx != -1) {
        debitNewValue = debitNewValue.replace(/,/g, '');
    }
    if (debitOldValue != debitNewValue) {
        changeDebitTotalSummary();
    }
}
function recalculateDebit(oldVal) {
    if (oldVal != 0) {
        debitNewValue = 0;
        debitOldValue = oldVal;
        changeDebitTotalSummary();
    }
}

function changeDebitTotalSummary() {
    var newDif = debitOldValue - debitNewValue;
    var CurrentSum = c_txt_Debit.GetText();
    var indx = CurrentSum.indexOf(',');
    if (indx != -1) {
        CurrentSum = CurrentSum.replace(/,/g, '');
    }

    c_txt_Debit.SetValue(parseFloat(CurrentSum - newDif));
}
function CalculateSummary(grid, rowValues, visibleIndex, isDeleting) {
    //ctxtTDebit
    var originalValue = grid.batchEditApi.GetCellValue(visibleIndex, "WithDrawl");
    var newValue = rowValues[(grid.GetColumnByField("WithDrawl").index)].value;
    var dif = isDeleting ? -newValue : newValue - originalValue;
    c_txt_Debit.SetValue((parseFloat(c_txt_Debit.GetValue()) + dif).toFixed(1));
    //ctxtTCredit
    var CoriginalValue = grid.batchEditApi.GetCellValue(visibleIndex, "Receipt");
    var CnewValue = rowValues[(grid.GetColumnByField("Receipt").index)].value;
    var Cdif = isDeleting ? -CnewValue : CnewValue - CoriginalValue;
    c_txt_Credit.SetValue((parseFloat(c_txt_Credit.GetValue()) + Cdif).toFixed(1));

    var Debit = parseFloat(c_txt_Debit.GetValue());
    var Credit = parseFloat(c_txt_Credit.GetValue());

    if (Debit == 0 && Credit == 0) {
        cbtnSaveRecords.SetVisible(false);
        cbtn_SaveRecords.SetVisible(false);
        loadCurrencyMassage.style.display = "block";
    }
    else if (Debit == Credit) {
        cbtnSaveRecords.SetVisible(true);
        cbtn_SaveRecords.SetVisible(true);
        loadCurrencyMassage.style.display = "none";
    }
    else {
        cbtnSaveRecords.SetVisible(false);
        cbtn_SaveRecords.SetVisible(false);
        loadCurrencyMassage.style.display = "block";
    }
}
//End here

function OnBatchEditEndEditing(s, e) {
    //Debjyoti
    //  CalculateSummary(s, e.rowValues, e.visibleIndex, false);
    //End here
    currentEditableVisibleIndex = -1;
    var cityIDColumn = s.GetColumnByField("CityID");
    //if (!e.rowValues.hasOwnProperty(cityIDColumn.index))
    //    return;
    // var cellInfo = e.rowValues[cityIDColumn.index];
    //if (CityID.GetSelectedIndex() > -1 || cellInfo.text != CityID.GetText()) {
    //    cellInfo.value = CityID.GetValue();
    //    cellInfo.text = CityID.GetText();
    //    CityID.SetValue(null);
    //}
}
function OnBatchEditRowValidating(s, e) {
    var cityIDColumn = s.GetColumnByField("CityID");
    var cellValidationInfo = e.validationInfo[cityIDColumn.index];
    if (!cellValidationInfo) return;
    var value = cellValidationInfo.value;
    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) === "") {
        cellValidationInfo.isValid = false;
        cellValidationInfo.errorText = "City is required";
    }
}
function CitiesCombo_KeyDown(s, e) {
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== ASPxKey.Tab && keyCode !== ASPxKey.Enter) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (grid.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        preventEndEditOnLostFocus = true;
    }
}
function CitiesCombo_LostFocus(s, e) {
    if (!preventEndEditOnLostFocus)
        grid.batchEditApi.EndEdit();
    preventEndEditOnLostFocus = false;
}
function AddBatchNew(s, e) {
    console.log(e);
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    var noofvisiblerows = grid.GetVisibleRowsOnPage();
    // var row = grid.GetVisibleIndex();
    if ((keyCode === 13)) {
        var mainAccountValue = (grid.GetEditor('MainAccount').GetValue() != null) ? grid.GetEditor('MainAccount').GetValue() : "";
        if (mainAccountValue != "") {
            grid.AddNewRow();
            //grid.SetFocusedRowIndex(globalRowIndex,1);
            //grid.GetEditor("MainAccount").Focus(); // grid.SetFocusedRowIndex();
            // return;
            
            setTimeout(function () { grid.batchEditApi.StartEdit(globalRowIndex, 1); }, 500);

        }
    }
    else if (keyCode === 9) {
        // setTimeout(function () { grid.batchEditApi.StartEdit(globalRowIndex, 1); }, 500);
        document.getElementById("txtNarration").focus();
    }
}
function OnAddNewClick() {
    //  $('#ddlBranch').attr('Disabled', false);
    var gridcount = grid.GetVisibleRowsOnPage();
    var mainAccountValue = grid.batchEditApi.GetCellValue(0, "CountryID");
    if (gridcount == 0) {
        grid.AddNewRow();
    }
    else if (gridcount > 0 && mainAccountValue != "") {
        grid.AddNewRow();
    }
}
function WithDrawlTextChange(s, e) {
    var mainAccountValue = (grid.GetEditor('MainAccount').GetValue() != null) ? grid.GetEditor('MainAccount').GetValue() : "";

    if (mainAccountValue != "") {
        DebitLostFocus(s, e);
        var withDrawlValue = (grid.GetEditor('WithDrawl').GetValue() != null) ? parseFloat(grid.GetEditor('WithDrawl').GetValue()) : "0";
        var receiptValue = (grid.GetEditor('Receipt').GetValue() != null) ? grid.GetEditor('Receipt').GetValue() : "0";

        if (withDrawlValue > 0) {
            recalculateCredit(grid.GetEditor('Receipt').GetValue());
            grid.GetEditor('Receipt').SetValue("0");
            //grid.GetEditor('Receipt').SetEnabled(false);
        }

        var Debit = parseFloat(c_txt_Debit.GetValue());
        var Credit = parseFloat(c_txt_Credit.GetValue());

        if (Debit == 0 && Credit == 0) {
            cbtnSaveRecords.SetVisible(false);
            cbtn_SaveRecords.SetVisible(false);
            loadCurrencyMassage.style.display = "block";
        }
        else if (Debit == Credit) {
            cbtnSaveRecords.SetVisible(true);
            cbtn_SaveRecords.SetVisible(true);
            loadCurrencyMassage.style.display = "none";
        }
        else {
            cbtnSaveRecords.SetVisible(false);
            cbtn_SaveRecords.SetVisible(false);
            loadCurrencyMassage.style.display = "block";
        }
    }
    else {
        grid.GetEditor('WithDrawl').SetValue("0");
    }
}
function ReceiptTextChange(s, e) {
    var mainAccountValue = (grid.GetEditor('MainAccount').GetValue() != null) ? grid.GetEditor('MainAccount').GetValue() : "";

    if (mainAccountValue != "") {
        CreditLostFocus(s, e);
        var receiptValue = (grid.GetEditor('Receipt').GetValue() != null) ? grid.GetEditor('Receipt').GetValue() : "0";
        var withDrawlValue = (grid.GetEditor('WithDrawl').GetValue() != null) ? parseFloat(grid.GetEditor('WithDrawl').GetValue()) : "0";

        if (receiptValue > 0) {
            recalculateDebit(grid.GetEditor('WithDrawl').GetValue());
            grid.GetEditor('WithDrawl').SetValue("0");

            //grid.GetEditor('WithDrawl').SetEnabled(false);
        }

        var Debit = parseFloat(c_txt_Debit.GetValue());
        var Credit = parseFloat(c_txt_Credit.GetValue());

        if (Debit == 0 && Credit == 0) {
            cbtnSaveRecords.SetVisible(false);
            cbtn_SaveRecords.SetVisible(false);
            loadCurrencyMassage.style.display = "block";
        }
        else if (Debit == Credit) {
            cbtnSaveRecords.SetVisible(true);
            cbtn_SaveRecords.SetVisible(true);
            loadCurrencyMassage.style.display = "none";
        }
        else {
            cbtnSaveRecords.SetVisible(false);
            cbtn_SaveRecords.SetVisible(false);
            loadCurrencyMassage.style.display = "block";
        }
    }
    else {
        grid.GetEditor('Receipt').SetValue("0");
    }
}


function deleteAllRows() {
    var frontRow = 0;
    var backRow = -1;
    for (var i = 0; i <= grid.GetVisibleRowsOnPage() + 100 ; i++) {
        grid.DeleteRow(frontRow);
        grid.DeleteRow(backRow);
        backRow--;
        frontRow++;
    }
    grid.AddNewRow();

    ctxtTotalPayment.SetValue(0);
    c_txt_Debit.SetValue(0);

}


function CmbScheme_ValueChange() {
    //var val = cCmbScheme.GetValue();
    deleteAllRows();
    //InsgridBatch.AddNewRow();
    var val = document.getElementById("CmbScheme").value;
    $("#MandatoryBillNo").hide();

    if (val != "0") {
        $.ajax({
            type: "POST",
            url: 'JournalEntry.aspx/getSchemeType',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: "{sel_scheme_id:\"" + val + "\"}",
            success: function (type) {
                console.log(type);

                var schemetypeValue = type.d;
                var schemetype = schemetypeValue.toString().split('~')[0];
                var schemelength = schemetypeValue.toString().split('~')[1];
                $('#txtBillNo').attr('maxLength', schemelength);
                var branchID = schemetypeValue.toString().split('~')[2];
                var branchStateID = schemetypeValue.toString().split('~')[3];
                document.getElementById('ddlSupplyState').value = branchStateID;
                $('#<%=hdnBranchId.ClientID %>').val(branchID);
                $('#<%=hfIsFilter.ClientID %>').val(branchID);
                if (schemetypeValue != "") {
                    document.getElementById('ddlBranch').value = branchID;
                    document.getElementById('<%= ddlBranch.ClientID %>').disabled = true;
                    // CountryID.PerformCallback(branchID);
                }
                if (schemetype == '0') {
                    $('#<%=hdnSchemaType.ClientID %>').val('0');
                    document.getElementById('<%= txtBillNo.ClientID %>').disabled = false;
                    document.getElementById('<%= txtBillNo.ClientID %>').value = "";
                    //document.getElementById("txtBillNo").focus();
                    setTimeout(function () { $("#txtBillNo").focus(); }, 200);
                    
                }
                else if (schemetype == '1') {
                    $('#<%=hdnSchemaType.ClientID %>').val('1');
                    document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
                    document.getElementById('<%= txtBillNo.ClientID %>').value = "Auto";
                    tDate.Focus();
                }
                else if (schemetype == '2') {
                    $('#<%=hdnSchemaType.ClientID %>').val('2');
                    document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
                    document.getElementById('<%= txtBillNo.ClientID %>').value = "Datewise";
                }
            }
        });
}
else {
    document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
        document.getElementById('<%= txtBillNo.ClientID %>').value = "";
    }
}

function GoToNextRow() {
    var gridcount = grid.GetVisibleRowsOnPage();
    grid.batchEditApi.StartEdit(gridcount - 2, 2);
    grid.GetEditor('CountryID').Focus();
}

function deleteAllRows() {
    var frontRow = 0;
    var backRow = -1;
    for (var i = 0; i <= grid.GetVisibleRowsOnPage() + 100 ; i++) {
        grid.DeleteRow(frontRow);
        grid.DeleteRow(backRow);
        backRow--;
        frontRow++;
    }
    grid.AddNewRow();

    c_txt_Debit.SetValue(0);
    c_txt_Credit.SetValue(0);

}

var oldBranchdata;
function BranchGotFocus() {
    oldBranchdata = document.getElementById('ddlBranch').value;
}

function ddlBranch_ChangeIndex() {
    if (oldBranchdata != document.getElementById('ddlBranch').value) {

        //get the first row accounting value debjyoti 
        grid.batchEditApi.StartEdit(-1, 1);
        var accountingDataMin = grid.GetEditor('CountryID').GetValue();
        grid.batchEditApi.EndEdit();

        grid.batchEditApi.StartEdit(0, 1);
        var accountingDataplus = grid.GetEditor('CountryID').GetValue();
        grid.batchEditApi.EndEdit();



        if (accountingDataMin != null || accountingDataplus != null) {
            jConfirm('You have changed Branch. All the entries of ledger in this voucher to be reset to blank. \n You have to select and re-enter. Continue?', 'Confirmation Dialog', function (r) {

                if (r == true) {
                    deleteAllRows();
                    CountryID.PerformCallback(document.getElementById('ddlBranch').value);
                    if (grid.GetVisibleRowsOnPage() == 1) {
                        grid.batchEditApi.StartEdit(-1, 1);
                    }
                } else {
                    document.getElementById('ddlBranch').value = oldBranchdata;
                }
            });
        }
        else {
            CountryID.PerformCallback(document.getElementById('ddlBranch').value);
        }
    }
}

function SaveButtonClick() {
    if (cbtnSaveRecords.IsVisible() == true) {
        var val = document.getElementById("CmbScheme").value;
        var Branchval = $("#ddlBranch").val();
        $("#MandatoryBillNo").hide();

        if (document.getElementById('<%= txtBillNo.ClientID %>').value == "") {
            //jAlert('Enter Journal No');
            $("#MandatoryBillNo").show();
            document.getElementById('<%= txtBillNo.ClientID %>').focus();
        }
        else if (Branchval == "0") {
            document.getElementById('<%= ddlBranch.ClientID %>').focus();
            jAlert('Enter Branch');
        }
        else {
            grid.batchEditApi.EndEdit();

            var frontRow = 0;
            var backRow = -1;
            var IsJournal = "";
            for (var i = 0; i <= grid.GetVisibleRowsOnPage() ; i++) {
                var frontProduct = (grid.batchEditApi.GetCellValue(backRow, 'gvColMainAccount') != null) ? (grid.batchEditApi.GetCellValue(backRow, 'gvColMainAccount')) : "";
                var backProduct = (grid.batchEditApi.GetCellValue(frontRow, 'gvColMainAccount') != null) ? (grid.batchEditApi.GetCellValue(frontRow, 'gvColMainAccount')) : "";

                if (frontProduct != "" || backProduct != "") {
                    IsJournal = "Y";
                    break;
                }

                backRow--;
                frontRow++;
            }

            if (IsJournal == "Y") {
                $('#<%=hdnRefreshType.ClientID %>').val('S');
                grid.UpdateEdit();
                $("#ddl_AmountAre").focus();
                c_txt_Debit.SetValue("0");
                c_txt_Credit.SetValue("0");
                // grid.batchEditApi.StartEdit(globalRowIndex, 1);
            }
            else {
                jAlert('Please add atleast single record first');
            }
        }
}
}
function SaveExitButtonClick() {
    if (cbtn_SaveRecords.IsVisible() == true) {
        var val = document.getElementById("CmbScheme").value;
        var Branchval = $("#ddlBranch").val();
        $("#MandatoryBillNo").hide();

        if (document.getElementById('<%= txtBillNo.ClientID %>').value == "") {
            //jAlert('Enter Journal No');
            $("#MandatoryBillNo").show();
            document.getElementById('<%= txtBillNo.ClientID %>').focus();
        }
        else if (Branchval == "0") {
            document.getElementById('<%= ddlBranch.ClientID %>').focus();
            jAlert('Enter Branch');
        }
        else {
            grid.batchEditApi.EndEdit();

            var frontRow = 0;
            var backRow = -1;
            var IsJournal = "";
            for (var i = 0; i <= grid.GetVisibleRowsOnPage() ; i++) {
                var frontProduct = (grid.batchEditApi.GetCellValue(backRow, 'MainAccount') != null) ? (grid.batchEditApi.GetCellValue(backRow, 'MainAccount')) : "";
                var backProduct = (grid.batchEditApi.GetCellValue(frontRow, 'MainAccount') != null) ? (grid.batchEditApi.GetCellValue(frontRow, 'MainAccount')) : "";

                if (frontProduct != "" || backProduct != "") {
                    IsJournal = "Y";
                    break;
                }

                backRow--;
                frontRow++;
            }

            if (IsJournal == "Y") {
                $('#<%=hdnRefreshType.ClientID %>').val('E');
                grid.UpdateEdit();
            }
            else {
                jAlert('Please add atleast single record first');
            }
        }
}
}

function OnKeyDown(s, e) {
    if (e.htmlEvent.keyCode == 40 || e.htmlEvent.keyCode == 38)
        return ASPxClientUtils.PreventEvent(e.htmlEvent);
}
function txtBillNo_TextChanged() {
    var VoucherNo = document.getElementById("txtBillNo").value;
    var type = $('#<%=hdnMode.ClientID %>').val();

    if (VoucherNo != "") {
        $("#MandatoryBillNo").hide();
    }

    $.ajax({
        type: "POST",
        url: "JournalEntry.aspx/CheckUniqueName",
        data: JSON.stringify({ VoucherNo: VoucherNo, Type: type }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            var data = msg.d;

            if (data == true) {
                $("#duplicateMandatoryBillNo").show();
                document.getElementById("txtBillNo").value = '';
                document.getElementById("<%=txtBillNo.ClientID%>").focus();
            }
            else {
                $("#duplicateMandatoryBillNo").hide();
            }
        }
    });
}

$(document).ready(function () {
    $("#divIsPartyJournal").hide();
    $('#MainAccountModel').modal('hide');
    $('#ddlBranch').blur(function () {
        if (grid.GetVisibleRowsOnPage() == 1) {
            grid.batchEditApi.StartEdit(-1, 1);
        }
    })
});

function SignOff() {
    window.parent.SignOff();
}

var isCtrl = false;
document.onkeydown = function (e) {
    if (event.keyCode == 83 && event.altKey == true) { //run code for Ctrl+S -- ie, Save & New  
        StopDefaultAction(e);
        var debit = parseFloat(c_txt_Debit.GetValue());
        var credit = parseFloat(c_txt_Credit.GetValue());
        if ((debit == credit) && (debit != 0) && (credit != 0)) {
            //SaveButtonClick();
            document.getElementById('btnSaveRecords').click();
            return false;
        }
    }
    else if (event.keyCode == 88 && event.altKey == true) { //run code for Ctrl+X -- ie, Save & Exit!   
        console.log(event);
        StopDefaultAction(e);
        var debit = parseFloat(c_txt_Debit.GetValue());
        var credit = parseFloat(c_txt_Credit.GetValue());
        if ((debit == credit) && (debit != 0) && (credit != 0)) {
            document.getElementById('btn_SaveRecords').click();
            //SaveExitButtonClick();
            return false;
        }
    }
    else if (event.keyCode == 65 && event.altKey == true) {
        StopDefaultAction(e);
        if (document.getElementById('divAddNew').style.display != 'block') {
            OnAddButtonClick();
        }
    }
}

function StopDefaultAction(e) {
    if (e.preventDefault) { e.preventDefault() }
    else { e.stop() };

    e.returnValue = false;
    e.stopPropagation();
}

function ReloadPage() {
    window.location.reload();
}

var isFirstTime = true;
function AllControlInitilize() {
    //document.getElementById('AddButton').style.display = 'inline-block';
    if (isFirstTime) {

        if (localStorage.getItem('FromDateJournal')) {
            var fromdatearray = localStorage.getItem('FromDateJournal').split('-');
            var fromdate = new Date(fromdatearray[0], parseFloat(fromdatearray[1]) - 1, fromdatearray[2], 0, 0, 0, 0);
            cFormDate.SetDate(fromdate);
        }

        if (localStorage.getItem('ToDateJournal')) {
            var todatearray = localStorage.getItem('ToDateJournal').split('-');
            var todate = new Date(todatearray[0], parseFloat(todatearray[1]) - 1, todatearray[2], 0, 0, 0, 0);
            ctoDate.SetDate(todate);
        }
        if (localStorage.getItem('BranchJournal')) {
            if (ccmbBranchfilter.FindItemByValue(localStorage.getItem('BranchJournal'))) {
                ccmbBranchfilter.SetValue(localStorage.getItem('BranchJournal'));
            }

        }
        //updateGridByDate();

        isFirstTime = false;
    }
}

//Function for Date wise filteration
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
        localStorage.setItem("FromDateJournal", cFormDate.GetDate().format('yyyy-MM-dd'));
        localStorage.setItem("ToDateJournal", ctoDate.GetDate().format('yyyy-MM-dd'));
        localStorage.setItem("BranchJournal", ccmbBranchfilter.GetValue());

        $("#hfFromDate").val(cFormDate.GetDate().format('yyyy-MM-dd'));
        $("#hfToDate").val(ctoDate.GetDate().format('yyyy-MM-dd'));
        $("#hfBranchID").val(ccmbBranchfilter.GetValue());
        $("#hfIsFilter").val("Y");

        if (page.activeTabIndex == 0) {
            cGvJvSearch.Refresh();
            //cGvJvSearch.PerformCallback('FilterGridByDate~' + cFormDate.GetDate().format('yyyy-MM-dd') + '~' + ctoDate.GetDate().format('yyyy-MM-dd') + '~' + ccmbBranchfilter.GetValue());
        }
        else if (page.activeTabIndex == 1) {
            cGvJvSearchFullInfo.PerformCallback('FilterGridByDate~' + cFormDate.GetDate().format('yyyy-MM-dd') + '~' + ctoDate.GetDate().format('yyyy-MM-dd') + '~' + ccmbBranchfilter.GetValue());
        }
    }
}

//// Pop Up /////

function MainAccountNewkeydown(e) {
    var OtherDetails = {}
    OtherDetails.SearchKey = $("#txtMainAccountSearch").val();
    OtherDetails.branchId = $("#ddlBranch").val();
    if (e.code == "Enter" || e.code == "NumpadEnter") {
        if ($("#txtMainAccountSearch").val() == "")
            return;
        var HeaderCaption = [];
        HeaderCaption.push("Main Account Name");
        HeaderCaption.push("Short Name");

        HeaderCaption.push("Subledger Type");

        callonServer("/OMS/Management/Activities/Services/Master.asmx/GetMainAccountJournal", OtherDetails, "MainAccountTable", HeaderCaption, "MainAccountIndex", "SetMainAccount");
    }
    else if (e.code == "ArrowDown") {
        if ($("input[MainAccountIndex=0]"))
            $("input[MainAccountIndex=0]").focus();
    }
    else if (e.code == "Escape") {
        //  
        $('#MainAccountModel').modal('hide');
        grid.batchEditApi.StartEdit(globalRowIndex, 1);
        var MainAccountID = grid.GetEditor("gvMainAcCode").GetValue();
        if (MainAccountID == 'Customers' || MainAccountID == 'Vendors') {
            if ($("#hdnIsPartyLedger").val() == "") {
                $("#hdnIsPartyLedger").val('1');
            }
            else {
                $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) + 1);
            }

        }
        
    }
}

function SubAccountNewkeydown(e) {
    grid.batchEditApi.StartEdit(e.visibleIndex);
    var strMainAccountID = (grid.GetEditor('MainAccount').GetText() != null) ? grid.GetEditor('MainAccount').GetText() : "0";
    var MainAccountID = (grid.GetEditor('gvColMainAccount').GetValue() != null) ? grid.GetEditor('gvColMainAccount').GetValue() : "0";

    var OtherDetails = {}
    OtherDetails.SearchKey = $("#txtSubAccountSearch").val();
    OtherDetails.MainAccountCode = MainAccountID;
    if (e.code == "Enter" || e.code == "NumpadEnter") {
        if ($("#txtSubAccountSearch").val() == "")
            return;
        var HeaderCaption = [];
        HeaderCaption.push("Sub Account Name [Unique Id]");
        HeaderCaption.push("Subledger Type");

        callonServer("/OMS/Management/Activities/Services/Master.asmx/GetSubAccountJournal", OtherDetails, "SubAccountTable", HeaderCaption, "SubAccountIndex", "SetSubAccount");
    }
    else if (e.code == "ArrowDown") {
        if ($("input[SubAccountIndex=0]"))
            $("input[SubAccountIndex=0]").focus();
    }
    else if (e.code == "Escape") {
        $('#SubAccountModel').modal('hide');
        grid.batchEditApi.StartEdit(globalRowIndex, 2);
    }
}

function SetMainAccount(Id,name,e) {

    $('#MainAccountModel').modal('hide');
    var Code = e.target.parentElement.parentElement.children[2].innerText;
    var IsSub = e.target.parentElement.parentElement.children[3].innerText;

    GetMainAcountComboBox(Id, name, Code, IsSub);
    grid.batchEditApi.StartEdit(globalRowIndex, 2);

}
function SetSubAccount(Id,name) {
    $('#SubAccountModel').modal('hide');
    GetSubAcountComboBox(Id, name);
    grid.batchEditApi.StartEdit(globalRowIndex, 3);
}


function ValueSelected(e, indexName) {
    if (e.code == "Enter") {
        var Id = e.target.parentElement.parentElement.cells[0].innerText;
        var name = e.target.parentElement.parentElement.cells[1].children[0].value;
        if (Id) {
            if (indexName == "MainAccountIndex") {
               $('#MainAccountModel').modal('hide');
                var Code = e.target.parentElement.parentElement.children[2].innerText;
                var IsSub = e.target.parentElement.parentElement.children[3].innerText;
               
                GetMainAcountComboBox(Id, name, Code, IsSub);
                grid.batchEditApi.StartEdit(globalRowIndex, 2);
            }
            else if (indexName == "SubAccountIndex") {
                $('#SubAccountModel').modal('hide');
                GetSubAcountComboBox(Id, name);
                grid.batchEditApi.StartEdit(globalRowIndex, 3);
            }
        }

    }
    else if (e.code == "ArrowDown") {
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
            if (indexName == "MainAccountIndex")
                $('#txtMainAccountSearch').focus();
            else if (indexName == "SubAccountIndex")
                $('#txtSubAccountSearch').focus();
        }
    }
    else if (e.code == "Escape") {
        if (indexName == "MainAccountIndex") {
            $('#MainAccountModel').modal('hide');
            grid.batchEditApi.StartEdit(globalRowIndex, 1);
            var MainAccountID = grid.GetEditor("gvMainAcCode").GetValue();
            if (MainAccountID == 'Customers' || MainAccountID == 'Vendors') {
                if ($("#hdnIsPartyLedger").val() == "") {
                    $("#hdnIsPartyLedger").val('1');
                }
                else {
                    $("#hdnIsPartyLedger").val(parseFloat($("#hdnIsPartyLedger").val()) + 1);
                }

            }
            
        }
        else if (indexName == "SubAccountIndex") {
            $('#SubAccountModel').modal('hide');
            grid.batchEditApi.StartEdit(globalRowIndex, 2);
        }
    }


}



function journalledger(keyid, docno) {

      <%--      $('#<%= lblHeading.ClientID %>').text("VIew Journal Voucher");
            $('#<%=hdnMode.ClientID %>').val('1');
            document.getElementById('div_Edit').style.display = 'none';
            document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;
            document.getElementById('hdnMode').value = "VIEW";
            document.getElementById('divAddNew').style.display = 'block';
            //   btncross.style.display = "block";
            TblSearch.style.display = "none";
            cbtnSaveRecords.SetVisible(false);
            cbtn_SaveRecords.SetVisible(false);
            grid.PerformCallback('ViewLeger~' + keyid);--%>



    ///  VisibleIndexE = e.visibleIndex;
    $('#<%= lblHeading.ClientID %>').text("View Journal Voucher");
    $('#<%=hdnMode.ClientID %>').val('1');
    document.getElementById('div_Edit').style.display = 'none';
    document.getElementById('<%= txtBillNo.ClientID %>').disabled = true;

    document.getElementById('divAddNew').style.display = 'block';
    //  btncross.style.display = "block";
    TblSearch.style.display = "none";
    //cGvJvSearch.GetRowValues(VisibleIndexE, "BranchID", MainAccountCallBack);
    grid.PerformCallback('View~' + keyid);
    document.getElementById('tblBtnSavePanel').style.display = 'none';
    LoadingPanel.Show();


}
    </script>
    <style>
        /*.dxgv {
            display: block;
        }*/
   .dynamicPopupTbl>tbody>tr>td {
                    padding:0px 3px !important;
                    font-size:14px;
                }
                .dynamicPopupTbl > tr > th {
                    height:28px;
                 }

                .dynamicPopupTbl > tbody > tr > td {
                   cursor:pointer;
                }
                .dynamicPopupTbl>tbody>tr>td input {
                    border:none !important;
                     cursor:pointer;
                     background: transparent !important;
                }
                .focusrow {
                    background-color: #3CA5DF;
                    color: #ffffff;
                }
                .focusrow>td input {
                   color:white
                }

        .HeaderStyle {
            background-color: #180771d9;
            color: #f5f5f5;
        }

        .itcShow {
            display: block !important;
        }

        .dxgv.dx-al, .dxgv.dx-ar, .dx-nowrap.dxgv, .gridcellleft.dxgv, .dxgv.dx-ac, .dxgvCommandColumn_PlasticBlue.dxgv.dx-ac {
            display: table-cell !important;
        }

        #grid_DXMainTable tr td:first-child {
            display: table-cell !important;
        }

        .dxgvControl_PlasticBlue td.dxgvBatchEditModifiedCell_PlasticBlue {
            background: #fff !important;
        }

        #GvJvSearch_DXMainTable .dxgv {
            display: table-cell !important;
        }

        #GvJvSearch_DXFilterRow .dxgv {
            display: table-cell !important;
        }

        .pullleftClass {
            position: absolute;
            right: 10px;
            top: 32px;
        }

        .crossBtn.CloseBtn {
            border: none;
            margin-right: 10px;
        }

            .crossBtn.CloseBtn input {
                padding: 0;
                border: none;
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
    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="clearfix" style="padding: 0;">
                <span class="pull-left" style="margin-top: 8px;">
                    <asp:Label ID="lblHeading" runat="server" Text="Journal Voucher"></asp:Label></span>
                <div id="pageheaderContent" class="pull-right reverse wrapHolder content horizontal-images">
                    <div class="Top clearfix">
                        <ul>
                            <li>
                                <div id="divContactPhone" class="lblHolder" style="display: none;">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>Contact Person's Phone</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="lblContactPhone" class="classout">N/A</span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </li>
                            <li>
                                <div id="divIsPartyJournal" class="lblHolder" style="display: none">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>Is Party Journal?</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span id="lblGSTIN">Yes</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </h3>

            <div id="btncross" class="crossBtn" runat="server" style="display: none; margin-left: 50px;"><a href="javascript:ReloadPage()"><i class="fa fa-times"></i></a></div>
            <%-- <div id="btncross" style="display: none; margin-left: 50px;" class="crossBtn CloseBtn">
                <asp:ImageButton ID="imgClose" runat="server" ImageUrl="/assests/images/CrIcon.png" OnClick="imgClose_Click" />
            </div>--%>
        </div>
    </div>
    <div class="form_main">
        <div id="TblSearch" class="clearfix">
            <div class="clearfix">
                <div style="padding-right: 5px;">
                    <% if (rights.CanAdd)
                       { %>
                    <a href="javascript:void(0);" onclick="OnAddButtonClick()" class="btn btn-primary"><span><u>A</u>dd New</span> </a>
                    <% } %>
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
            </div>
            <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" ClientInstanceName="page"
                Font-Size="12px" Width="100%">
                <TabPages>
                    <dxe:TabPage Name="AdvanceRec" Text="Journal Summary">
                        <ContentCollection>
                            <dxe:ContentControl runat="server">
                                <div class="clearfix">
                                    <dxe:ASPxGridView ID="GvJvSearch" runat="server" AutoGenerateColumns="False" SettingsBehavior-AllowSort="true"
                                        ClientInstanceName="cGvJvSearch" KeyFieldName="VoucherNumber" Width="100%"
                                        OnCustomCallback="GvJvSearch_CustomCallback" OnCustomButtonInitialize="GvJvSearch_CustomButtonInitialize" DataSourceID="EntityServerModeDataSource">
                                        <ClientSideEvents CustomButtonClick="CustomButtonClick" EndCallback="function(s, e) {GvJvSearch_EndCallBack();}" />
                                        <SettingsBehavior ConfirmDelete="True" ColumnResizeMode="NextColumn" />
                                        <Styles>
                                            <Header SortingImageSpacing="5px" ImageSpacing="5px"></Header>
                                            <FocusedRow HorizontalAlign="Left" VerticalAlign="Top" CssClass="gridselectrow"></FocusedRow>
                                            <LoadingPanel ImageSpacing="10px"></LoadingPanel>
                                            <FocusedGroupRow CssClass="gridselectrow"></FocusedGroupRow>
                                            <Footer CssClass="gridfooter"></Footer>
                                        </Styles>
                                        <Columns>
                                            <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="0" FieldName="JvID" Caption="JvID" SortOrder="Descending">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="JournalVoucher_TransactionDate" Caption="Date" Width="10%">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                                <%-- <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy"></PropertiesTextEdit>--%>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="BillNumber" Caption="Journal No." Width="15%">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="VoucherNumber" Caption="JV Number" Visible="false">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="BranchNameCode" Width="20%" Caption="Branch" Visible="false">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="Narration" Caption="Narration" Width="27%" Settings-AllowAutoFilter="False">
                                                <CellStyle CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="JournalVoucher_CreateUser" Caption="Entered By" Width="10%" Settings-AllowAutoFilter="False">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="6" FieldName="JournalVoucher_ModifyDateTime" Caption="Last Update On" Width="15%" Settings-AllowAutoFilter="False">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                                <PropertiesTextEdit DisplayFormatString="dd-MM-yyyy hh:mm:ss"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="7" FieldName="JournalVoucher_ModifyUser" Caption="Updated By" Width="10%" Settings-AllowAutoFilter="False">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Visible="False" FieldName="IBRef"></dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Visible="False" FieldName="BranchID"></dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Visible="False" FieldName="WhichTypeItem"></dxe:GridViewDataTextColumn>
                                            <dxe:GridViewCommandColumn VisibleIndex="8" Width="13%" ButtonType="Image" Caption="Actions">
                                                <CustomButtons>
                                                    <dxe:GridViewCommandColumnCustomButton ID="CustomBtnView" Image-ToolTip="View" Styles-Style-CssClass="pad">
                                                        <Image Url="/assests/images/viewIcon.png"></Image>
                                                    </dxe:GridViewCommandColumnCustomButton>
                                                    <dxe:GridViewCommandColumnCustomButton ID="CustomBtnEdit" Image-ToolTip="Edit" Styles-Style-CssClass="pad">
                                                        <Image Url="/assests/images/Edit.png"></Image>
                                                    </dxe:GridViewCommandColumnCustomButton>
                                                    <dxe:GridViewCommandColumnCustomButton ID="CustomBtnDelete" Image-ToolTip="Delete" Styles-Style-CssClass="pad">
                                                        <Image Url="/assests/images/Delete.png"></Image>
                                                    </dxe:GridViewCommandColumnCustomButton>
                                                    <%--Print Journal Voucher--%>
                                                    <dxe:GridViewCommandColumnCustomButton ID="CustomBtnPrint" Image-ToolTip="Print" Styles-Style-CssClass="pad">
                                                        <Image Url="/assests/images/Print.png"></Image>
                                                    </dxe:GridViewCommandColumnCustomButton>
                                                    <%--End Print Journal Voucher--%>
                                                </CustomButtons>
                                            </dxe:GridViewCommandColumn>
                                        </Columns>
                                        <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                        <SettingsSearchPanel Visible="false" />
                                        <SettingsPager NumericButtonCount="10" PageSize="10" ShowSeparators="True" Mode="ShowPager">
                                            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                            <FirstPageButton Visible="True">
                                            </FirstPageButton>
                                            <LastPageButton Visible="True">
                                            </LastPageButton>
                                        </SettingsPager>
                                    </dxe:ASPxGridView>
                                    <dx:LinqServerModeDataSource ID="EntityServerModeDataSource" runat="server" OnSelecting="EntityServerModeDataSource_Selecting"
                                        ContextTypeName="ERPDataClassesDataContext" TableName="v_JournalEntryList" />
                                </div>
                            </dxe:ContentControl>
                        </ContentCollection>
                    </dxe:TabPage>

                    <dxe:TabPage Name="FullJournalRecord" Text="Journal Details">
                        <ContentCollection>
                            <dxe:ContentControl runat="server">
                                <div class="clearfix">
                                    <dxe:ASPxGridView ID="GridFullInfo" runat="server" AutoGenerateColumns="False" SettingsBehavior-AllowSort="true"
                                        ClientInstanceName="cGvJvSearchFullInfo" KeyFieldName="JvID" Width="100%"
                                        OnCustomCallback="GridFullInfo_CustomCallback" OnCustomButtonInitialize="GridFullInfo_CustomButtonInitialize" OnDataBinding="GridFullInfo_DataBinding" OnSummaryDisplayText="GridFullInfo_SummaryDisplayText">
                                        <ClientSideEvents EndCallback="function(s, e) {GridFullInfo_EndCallBack();}" />
                                        <SettingsBehavior ConfirmDelete="True" ColumnResizeMode="NextColumn" />

                                        <Styles>
                                            <Header SortingImageSpacing="5px" ImageSpacing="5px"></Header>
                                            <FocusedRow HorizontalAlign="Left" VerticalAlign="Top" CssClass="gridselectrow"></FocusedRow>
                                            <LoadingPanel ImageSpacing="10px"></LoadingPanel>
                                            <FocusedGroupRow CssClass="gridselectrow"></FocusedGroupRow>
                                            <Footer CssClass="gridfooter"></Footer>
                                        </Styles>
                                        <SettingsPager NumericButtonCount="10" PageSize="10" ShowSeparators="True" Mode="ShowPager">
                                            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                            <FirstPageButton Visible="True">
                                            </FirstPageButton>
                                            <LastPageButton Visible="True">
                                            </LastPageButton>
                                        </SettingsPager>
                                        <Columns>

                                            <dxe:GridViewDataTextColumn VisibleIndex="0" FieldName="JV_DATE" Caption="Date">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="JV_NO" Width="150px" Caption="Journal No">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>

                                            <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="MainAccount" Width="150px" Caption="Ledger Desc.">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="SubAccount" Width="150px" Caption="Subledger Desc.">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>


                                            <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="JV_NARRATION" Width="300px" Caption="NARRATION">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="JV_DR_AMT" Caption="Debit Amount">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="6" FieldName="JV_CR_AMT" Caption="Credit Amount">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>

                                            <dxe:GridViewDataTextColumn VisibleIndex="7" Visible="true" FieldName="CGSTRate" Caption="CGST Rate">
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Visible="true" VisibleIndex="8" FieldName="CGSTRate" Caption="CGST Rate">
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn Visible="true" VisibleIndex="9" FieldName="IGSTRate" Caption="IGST Rate">
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>

                                            <dxe:GridViewDataTextColumn Visible="true" VisibleIndex="10" FieldName="UTGSTRate" Caption="UTGST Rate">
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>



                                            <dxe:GridViewDataTextColumn VisibleIndex="11" FieldName="CGSTAmount" Caption="CGST Amt">
                                                <CellStyle CssClass="gridcellleft"></CellStyle>
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="12" FieldName="SGSTAmount" Caption="SGST Amt">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="13" FieldName="IGSTAmount" Caption="IGST Amt">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>
                                            <dxe:GridViewDataTextColumn VisibleIndex="14" FieldName="UTGSTAmount" Caption="UTGST Amt">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                                <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                                            </dxe:GridViewDataTextColumn>

                                            <dxe:GridViewDataTextColumn VisibleIndex="15" FieldName="RCM" Caption="RCM">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>

                                            <dxe:GridViewDataTextColumn VisibleIndex="16" FieldName="ITC" Caption="ITC">
                                                <CellStyle Wrap="False" CssClass="gridcellleft"></CellStyle>
                                            </dxe:GridViewDataTextColumn>

                                        </Columns>
                                        <Settings ShowFooter="true" ShowColumnHeaders="true" ShowFilterRow="true" ShowGroupFooter="VisibleIfExpanded" />
                                        <TotalSummary>
                                            <dxe:ASPxSummaryItem FieldName="JV_DR_AMT" SummaryType="Sum" />
                                            <dxe:ASPxSummaryItem FieldName="JV_CR_AMT" SummaryType="Sum" />
                                            <dxe:ASPxSummaryItem FieldName="CGSTAmount" SummaryType="Sum" />
                                            <dxe:ASPxSummaryItem FieldName="SGSTAmount" SummaryType="Sum" />
                                            <dxe:ASPxSummaryItem FieldName="IGSTAmount" SummaryType="Sum" />
                                            <dxe:ASPxSummaryItem FieldName="UTGSTAmount" SummaryType="Sum" />
                                        </TotalSummary>
                                        <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" HorizontalScrollBarMode="Visible" />
                                        <SettingsSearchPanel Visible="True" />
                                    </dxe:ASPxGridView>
                                </div>
                            </dxe:ContentControl>
                        </ContentCollection>
                    </dxe:TabPage>
                </TabPages>
            </dxe:ASPxPageControl>




        </div>
        <div id="divAddNew" class="clearfix" style="display: none">
            <div class="clearfix">
            </div>
            <div style="background: #f5f4f3; padding: 8px 0; margin-bottom: 0px; border-radius: 4px; border: 1px solid #ccc;" class="clearfix">
                <div class="col-md-3" id="div_Edit">
                    <label>Select Numbering Scheme</label>
                    <div>
                        <%-- <dxe:ASPxComboBox ID="CmbScheme" EnableIncrementalFiltering="True" ClientInstanceName="cCmbScheme" DataSourceID="SqlSchematype"
                            TextField="SchemaName" ValueField="ID" TabIndex="1" SelectedIndex="0"
                            runat="server" ValueType="System.String" Width="100%" EnableSynchronization="True">
                            <ClientSideEvents ValueChanged="function(s,e){CmbScheme_ValueChange()}"></ClientSideEvents>
                        </dxe:ASPxComboBox>--%>
                        <asp:DropDownList ID="CmbScheme" runat="server" DataSourceID="SqlSchematype"
                            DataTextField="SchemaName" DataValueField="ID" Width="100%"
                            onchange="CmbScheme_ValueChange()">
                        </asp:DropDownList>
                        <%-- <asp:RadioButtonList ID="rblScheme" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" Width="100%"
                            onclick="rblScheme_ValueChange()">
                        </asp:RadioButtonList>--%>
                    </div>
                </div>
                <div class="col-md-3">
                    <label>Journal No.</label>
                    <div>
                        <asp:TextBox ID="txtBillNo" runat="server" Width="95%" meta:resourcekey="txtBillNoResource1" MaxLength="30" onchange="txtBillNo_TextChanged()"></asp:TextBox>
                        <span id="MandatoryBillNo" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Mandatory"></span>
                        <span id="duplicateMandatoryBillNo" class="pullleftClass fa fa-exclamation-circle iconRed" style="color: red; position: absolute; display: none" title="Duplicate Journal No."></span>
                    </div>
                </div>
                <div class="col-md-3">
                    <label style="">Date</label>
                    <div>
                        <dxe:ASPxDateEdit ID="tDate" runat="server" EditFormat="Custom" ClientInstanceName="tDate"
                            UseMaskBehavior="True" Width="100%" meta:resourcekey="tDateResource1">
                            <ClientSideEvents DateChanged="function(s,e){DateChange()}" />
                        </dxe:ASPxDateEdit>
                    </div>
                </div>
                <div class="col-md-3">
                    <label>Branch</label>
                    <div>
                        <asp:DropDownList ID="ddlBranch" runat="server" DataSourceID="dsBranch" Enabled="false"
                            DataTextField="BANKBRANCH_NAME" DataValueField="BANKBRANCH_ID" Width="100%"
                            meta:resourcekey="ddlBranchResource1" onchange="ddlBranch_ChangeIndex()" onfocus="BranchGotFocus()">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <label>Place Of Supply</label>
                    <div>
                        <asp:DropDownList ID="ddlSupplyState" runat="server" DataSourceID="dsSupplyState"
                            DataTextField="state_name" DataValueField="state_id" Width="100%">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <label>Amounts are</label>
                    <div>
                        <asp:DropDownList ID="ddl_AmountAre" runat="server" DataSourceID="dsTaxType"
                            DataTextField="taxGrp_Description" DataValueField="taxGrp_Id" Width="100%">
                        </asp:DropDownList>
                    </div>
                </div>

            </div>
            <div class="clearfix">
                <br />
                <dxe:ASPxGridView runat="server" OnBatchUpdate="grid_BatchUpdate" KeyFieldName="CashReportID" ClientInstanceName="grid" ID="grid"
                    Width="100%" OnCellEditorInitialize="grid_CellEditorInitialize" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false"
                    Settings-ShowFooter="false" OnCustomCallback="grid_CustomCallback" OnDataBinding="grid_DataBinding"
                    OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting" 
                    SettingsPager-Mode="ShowAllRecords" Settings-VerticalScrollBarMode="auto" Settings-VerticalScrollableHeight="200" CommandButtonInitialize="false" EnableCallBacks="true">
                    <SettingsPager Visible="false"></SettingsPager>
                    <Styles>
                        <Cell Wrap="False"></Cell>
                    </Styles>
                    <Columns>
                        <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="true" Width="50" VisibleIndex="0" Caption="Action">
                            <HeaderTemplate>
                                Delete
                            </HeaderTemplate>
                            <CustomButtons>
                                <dxe:GridViewCommandColumnCustomButton Text=" " ID="CustomDelete" Image-Url="/assests/images/crs.png">
                                </dxe:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dxe:GridViewCommandColumn>

                        <dxe:GridViewDataButtonEditColumn FieldName="MainAccount" Caption="Main Account" VisibleIndex="1">

                            <PropertiesButtonEdit>

                                <ClientSideEvents ButtonClick="MainAccountButnClick" KeyDown="MainAccountKeyDown" />
                                <Buttons>

                                    <dxe:EditButton Text="..." Width="20px">
                                    </dxe:EditButton>
                                </Buttons>
                            </PropertiesButtonEdit>
                        </dxe:GridViewDataButtonEditColumn>

                        <%--                    <dxe:GridViewDataComboBoxColumn Caption="Main Account" FieldName="CountryID" VisibleIndex="1" Width="250">
                        <PropertiesComboBox ValueField="CountryID" ClientInstanceName="CountryID" TextField="CountryName" ClearButton-DisplayMode="Always" AllowMouseWheel="false">
                            <%-- <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>
                            <ClientSideEvents SelectedIndexChanged="CountriesCombo_SelectedIndexChanged" />
                        </PropertiesComboBox>
                    </dxe:GridViewDataComboBoxColumn>--%>



                        <dxe:GridViewDataButtonEditColumn FieldName="bthSubAccount" Caption="Sub Account" VisibleIndex="2">
                            <PropertiesButtonEdit>
                                <ClientSideEvents ButtonClick="SubAccountButnClick" KeyDown="SubAccountKeyDown" />
                                <Buttons>
                                    <dxe:EditButton Text="..." Width="20px">
                                    </dxe:EditButton>
                                </Buttons>
                            </PropertiesButtonEdit>
                        </dxe:GridViewDataButtonEditColumn>


                        <%--                    <dxe:GridViewDataComboBoxColumn FieldName="CityID" Caption="Sub Account" VisibleIndex="2" Width="250">
                        <PropertiesComboBox TextField="CityName" ValueField="CityID">
                        </PropertiesComboBox>
                        <EditItemTemplate>
                            <dxe:ASPxComboBox runat="server" OnInit="CityCmb_Init" Width="100%" EnableIncrementalFiltering="true" TextField="CityName" ClearButton-DisplayMode="Always"
                                OnCallback="CityCmb_Callback" ValueField="CityID" ID="CityCmb" ClientInstanceName="CityID" EnableCallbackMode="true" AllowMouseWheel="false">
                                <ClientSideEvents EndCallback="CitiesCombo_EndCallback" />
                                <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>
                            </dxe:ASPxComboBox>
                            <%--EnableCallbackMode="true"  OnInit="CityCmb_Init" 
                        </EditItemTemplate>
                    </dxe:GridViewDataComboBoxColumn>--%>




                        <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="WithDrawl" Caption="Debit" Width="120" EditCellStyle-HorizontalAlign="Right">
                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" />
                                <ClientSideEvents KeyDown="OnKeyDown" LostFocus="WithDrawlTextChange"
                                    GotFocus="function(s,e){
                                    DebitGotFocus(s,e);
                                    }" />
                                <ClientSideEvents />
                                <ValidationSettings Display="None"></ValidationSettings>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="Receipt" Caption="Credit" Width="120">
                            <PropertiesTextEdit DisplayFormatString="0.00" Style-HorizontalAlign="Right">
                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" />
                                <ClientSideEvents KeyDown="OnKeyDown" LostFocus="ReceiptTextChange"
                                    GotFocus="function(s,e){
                                    CreditGotFocus(s,e);
                                    }" />
                                <ClientSideEvents />
                                <ValidationSettings Display="None"></ValidationSettings>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Right"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="Narration" Caption="Narration">
                            <PropertiesTextEdit>
                                <ClientSideEvents KeyDown="AddBatchNew"></ClientSideEvents>
                            </PropertiesTextEdit>
                            <CellStyle Wrap="False" HorizontalAlign="Left" CssClass="gridcellleft"></CellStyle>
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn FieldName="CashReportID" Caption="Srl No" ReadOnly="true" HeaderStyle-CssClass="hide" Width="0">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn FieldName="gvColMainAccount" Caption="hidden Field Id" Width="0" HeaderStyle-CssClass="hide">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn FieldName="gvColSubAccount" Caption="hidden Field Id" Width="0" HeaderStyle-CssClass="hide">
                        </dxe:GridViewDataTextColumn>
                        <dxe:GridViewDataTextColumn FieldName="gvMainAcCode" Caption="hidden Field Id" Width="0" HeaderStyle-CssClass="hide">
                        </dxe:GridViewDataTextColumn>
                    </Columns>
                    <TotalSummary>
                        <dxe:ASPxSummaryItem SummaryType="Sum" FieldName="C2" Tag="C2_Sum" />
                    </TotalSummary>
                    <Settings ShowStatusBar="Hidden" />
                    <ClientSideEvents Init="OnInit" EndCallback="OnEndCallback" BatchEditStartEditing="OnBatchEditStartEditing" BatchEditEndEditing="OnBatchEditEndEditing"
                        CustomButtonClick="OnCustomButtonClick" RowClick="GetVisibleIndex" />
                    <SettingsDataSecurity AllowEdit="true" />


                    <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom">
                        <BatchEditSettings ShowConfirmOnLosingChanges="false" EditMode="row" />
                    </SettingsEditing>
                </dxe:ASPxGridView>
            </div>
            <div class="text-center">
                <table class="padTabtype2 pull-right" id="TotalAmount" style="margin-right: 12px; margin-top: 5px;">
                    <tr>
                        <td style="padding-right: 5px">Total Debit</td>
                        <td style="padding-right: 30px">
                            <dxe:ASPxTextBox ID="txt_Debit" runat="server" Width="105px" ClientInstanceName="c_txt_Debit" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">
                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                            </dxe:ASPxTextBox>
                        </td>
                        <td style="padding-right: 5px">Total Credit</td>
                        <td>
                            <dxe:ASPxTextBox ID="txt_Credit" runat="server" Width="105px" ClientInstanceName="c_txt_Credit" HorizontalAlign="Right" Font-Size="12px" ReadOnly="true">
                                <MaskSettings Mask="&lt;0..999999999&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                            </dxe:ASPxTextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="clearfix" style="background: #f5f4f3; padding: 8px 0; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ccc;">
                <div class="col-md-12">
                    <label>Main Narration</label>
                    <div>
                        <asp:TextBox ID="txtNarration" Font-Names="Arial" runat="server" TextMode="MultiLine"
                            Width="100%" onkeyup="OnlyNarration(this,'Narration',event)" meta:resourcekey="txtNarrationResource1" Height="40px"></asp:TextBox>
                    </div>
                </div>
            </div>
            <table style="float: left;" id="tblBtnSavePanel">
                <tr>
                    <td style="width: 100px;" id="tdSaveButton" runat="Server">
                        <dxe:ASPxButton ID="btnSaveRecords" ClientInstanceName="cbtnSaveRecords" runat="server" AutoPostBack="False" Text="S&#818;ave & New" CssClass="btn btn-primary" UseSubmitBehavior="False">
                            <ClientSideEvents Click="function(s, e) {SaveButtonClick();}" />
                        </dxe:ASPxButton>
                    </td>
                    <td style="width: 100px;" id="td_SaveButton" runat="Server">
                        <dxe:ASPxButton ID="btn_SaveRecords" ClientInstanceName="cbtn_SaveRecords" runat="server" AutoPostBack="False" Text="Save & Ex&#818;it" CssClass="btn btn-primary" UseSubmitBehavior="False">
                            <ClientSideEvents Click="function(s, e) {SaveExitButtonClick();}" />
                        </dxe:ASPxButton>
                    </td>
                    <td style="width: 100px">
                        <dxe:ASPxButton ID="btnDiscardEntry" runat="server" AccessKey="D" AllowFocus="False" Visible="false"
                            AutoPostBack="False" Text="D&#818;iscard Entered Records" CssClass="btn btn-primary" meta:resourcekey="btnDiscardEntryResource1" UseSubmitBehavior="False">
                            <ClientSideEvents Click="function(s, e) {DiscardButtonClick();}" />
                        </dxe:ASPxButton>
                    </td>
                    <td id="tdadd" style="width: 100px">
                        <dxe:ASPxButton ID="btnadd" ClientInstanceName="cbtnadd" runat="server" AccessKey="L" AutoPostBack="False" ClientVisible="false"
                            Text="Add Entry To L&#818;ist" CssClass="btn btn-primary" meta:resourcekey="btnaddResource1" Visible="false" UseSubmitBehavior="False">
                            <ClientSideEvents Click="function(s, e) {SubAccountCheck();}" />
                        </dxe:ASPxButton>
                    </td>
                    <td id="tdnew" style="width: 100px; height: 16px; display: none">
                        <dxe:ASPxButton ID="btnnew" ClientInstanceName="cbtnnew" runat="server" AutoPostBack="False" Text="N&#818;ew Entry" ClientVisible="false"
                            CssClass="btn btn-primary" AccessKey="N" Font-Bold="False" Font-Underline="False" BackColor="Tan" meta:resourcekey="btnnewResource1" UseSubmitBehavior="False">
                            <ClientSideEvents Click="function(s, e) {NewButtonClick();}" />
                        </dxe:ASPxButton>
                    </td>
                    <td style="width: 100px">
                        <dxe:ASPxButton ID="btnCancelEntry" runat="server" AccessKey="C" AutoPostBack="False" Text="C&#818;ancel Entry" CssClass="btn btn-primary" meta:resourcekey="btnCancelEntryResource1" ClientVisible="false" UseSubmitBehavior="False">
                            <ClientSideEvents Click="function(s, e) {CancelButtonClick();}" />
                        </dxe:ASPxButton>
                    </td>

                    <td style="width: 100px">
                        <dxe:ASPxButton ID="btnUnsaveData" runat="server" AccessKey="R" AutoPostBack="False" Text="R&#818;efresh" CssClass="btn btn-primary" meta:resourcekey="btnUnsaveDataResource1" ClientVisible="false" UseSubmitBehavior="False">
                            <ClientSideEvents Click="function(s, e) {RefreshButtonClick();}" />
                        </dxe:ASPxButton>
                    </td>

                </tr>
            </table>
            <div id="loadCurrencyMassage" style="display: none;">
                <label><span style="color: red; font-weight: bold; font-size: medium;">**  Mismatch detected in Total of Debit & Credit Amount.</span></label>
            </div>
        </div>
    </div>
    <div id="DvDataSource">
        <asp:SqlDataSource ID="dsBranch" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>" ConflictDetection="CompareAllValues"
            SelectCommand="SELECT BRANCH_id AS BANKBRANCH_ID , RTRIM(BRANCH_DESCRIPTION)+' ['+ISNULL(RTRIM(BRANCH_CODE),'')+']' AS BANKBRANCH_NAME  FROM TBL_MASTER_BRANCH"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsSupplyState" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>" ConflictDetection="CompareAllValues"
            SelectCommand="select id as state_id,state+' (State Code:'+StateCode+')' as state_name   from tbl_master_state where ISNULL(state+' (State Code:'+StateCode+')','')<>''  order by state_name"></asp:SqlDataSource>
        <asp:SqlDataSource ID="dsTaxType" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>" ConflictDetection="CompareAllValues"
            SelectCommand="select taxGrp_Id,taxGrp_Description from tbl_master_taxgrouptype  order by taxGrp_Description"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSourceMainAccount" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand=""></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSourceSubAccount" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand=""></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlSchematype" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select * From ((Select '0' as ID,'Select' as SchemaName) Union (Select ID,SchemaName  + 
            (Case When (SELECT Isnull(branch_description,'') FROM tbl_master_branch where branch_id=Branch) Is Null Then '' 
            Else ' ('+(SELECT Isnull(branch_description,'') FROM tbl_master_branch where branch_id=Branch)+')' End) From tbl_master_Idschema  Where TYPE_ID='1' AND IsActive=1 AND Isnull(Branch,'') in (select s FROM dbo.GetSplit(',',@userbranchHierarchy)) AND Isnull(comapanyInt,'')=@LastCompany AND financial_year_id=(Select Top 1 FinYear_ID FROM Master_FinYear WHERE FinYear_Code=@LastFinYear))) as x Order By ID asc">
            <SelectParameters>
                <asp:SessionParameter Name="LastCompany" SessionField="LastCompany" />
                <asp:SessionParameter Name="LastFinYear" SessionField="LastFinYear" />
                <asp:SessionParameter Name="userbranchHierarchy" SessionField="userbranchHierarchy" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <div id="HiddenFeild">
        <asp:HiddenField ID="hdnSegmentid" runat="server" />
        <asp:HiddenField ID="hdnMode" runat="server" />
        <asp:HiddenField ID="hdnSchemaType" runat="server" />
        <asp:HiddenField ID="hdnRefreshType" runat="server" />
        <asp:HiddenField ID="hdnJournalNo" runat="server" />
        <asp:HiddenField ID="hdnIBRef" runat="server" />
        <asp:HiddenField ID="hdnBranchId" runat="server" />
        <asp:HiddenField ID="hdnMainAccountId" runat="server" />
    </div>
    <div id="DvPopup">
        <%-- -------------------POPUPControl   FOR Main & Sub Account-------------------------------------%>
        <dxe:ASPxPopupControl ID="MainAccountpopUp" runat="server" ClientInstanceName="cMainAccountpopUp"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Height="200"
            Width="700" HeaderText="Select Main Account" AllowResize="true" ResizingMode="Postponed" Modal="true">
            <HeaderTemplate>
                <span style="color: #fff"><strong>Search Ledger(Min 4 Chars.)</strong></span>
            </HeaderTemplate>
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">

                    <div>
                        <dxe:ASPxLabel ID="ASPxLabel1" ClientInstanceName="LabelMainAccount" runat="server"></dxe:ASPxLabel>
                    </div>

                    <label><strong>Search Ledger(Min 4 Chars.)</strong> <span style="color: red">[Press Esc to Cancel]</span></label>
                    <div id="mainActMsg">
                        <span style="color: red; right: 46px;"><strong>* Invalid Main Account</strong> </span>
                    </div>
                    <dxe:ASPxComboBox ID="MainAccountComboBox" runat="server" EnableCallbackMode="true" CallbackPageSize="10" Width="95%"
                        ValueType="System.String" ValueField="MainAccount_ReferenceID" ClientInstanceName="cMainAccountComboBox"
                        OnItemsRequestedByFilterCondition="ASPxMainAccountComboBox_OnItemsRequestedByFilterCondition_SQL"
                        OnItemRequestedByValue="ASPxMainComboBox_OnItemRequestedByValue_SQL"
                        FilterMinLength="4"
                        TextFormatString="{0}"
                        DropDownStyle="DropDown" DropDownRows="7">
                        <Columns>
                            <dxe:ListBoxColumn FieldName="MainAccount_Name" Caption="Main Account Name" Width="320px" />
                            <dxe:ListBoxColumn FieldName="MainAccount_SubLedgerType" Caption="Sub Account Type" Width="320px" />
                            <dxe:ListBoxColumn FieldName="MainAccount_ReverseApplicable" Caption="ReverseApplicable" Width="0" />
                            <dxe:ListBoxColumn FieldName="TAXable" Caption="TAXable" Width="0" />
                            <dxe:ListBoxColumn FieldName="MainAccount_AccountCode" Caption="MainAccount_AccountCode" Width="0" />
                        </Columns>
                        <ClientSideEvents ValueChanged="function(s, e) {GetMainAcountComboBox(e)}" KeyDown="MainAccountComboBoxKeyDown" />
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
                    <div class="text-center">
                        <button type="button" style="margin-top: 50px;" class="btn-danger" onclick="MainPopUpHide();">Cancel</button>
                    </div>

                </dxe:PopupControlContentControl>
            </ContentCollection>
            <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
        </dxe:ASPxPopupControl>
        <dxe:ASPxPopupControl ID="SubAccountpopUp" runat="server" ClientInstanceName="cSubAccountpopUp"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Height="200"
            Width="700" HeaderText="Select Sub Account" AllowResize="true" ResizingMode="Postponed" Modal="true">

            <HeaderTemplate>
                <span style="color: #fff"><strong>Search Sub-Ledger(Min 4 Chars.)</strong></span>
                <%--<dxe:ASPxImage ID="ASPxImage3" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader">
                        <ClientSideEvents Click="function(s, e){ 
                                                           SubPopUpHide();
                                                        }" />
                    </dxe:ASPxImage>--%>
            </HeaderTemplate>

            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <div>
                        <dxe:ASPxLabel ID="labelSubAccount" runat="server"></dxe:ASPxLabel>
                    </div>
                    <label><strong>Search Sub-Ledger(Min 4 Chars.)</strong> <span style="color: red">[Press Esc to Cancel]</span></label>
                    <div id="mainActMsgSub">
                        <span style="color: red; right: 46px;"><strong>* Invalid Sub Account</strong> </span>
                    </div>
                    <dxe:ASPxComboBox ID="SubAcountComboBox" runat="server" EnableCallbackMode="true" CallbackPageSize="10" Width="95%"
                        ValueType="System.String" ValueField="SubAccount_ReferenceID" ClientInstanceName="cSubAcountComboBox"
                        OnItemsRequestedByFilterCondition="ASPxComboBox_OnItemsRequestedByFilterCondition_SQL" FilterMinLength="4"
                        OnItemRequestedByValue="ASPxComboBox_OnItemRequestedByValue_SQL" TextFormatString="{0}"
                        DropDownStyle="DropDown" DropDownRows="7">
                        <Columns>
                            <dxe:ListBoxColumn FieldName="Contact_Name" Caption="Sub Account Name" Width="320px" />
                            <%--   <dxe:ListBoxColumn FieldName="Name" Caption="Name" Width="320px" />
                        <dxe:ListBoxColumn FieldName="Type" Caption="Type" Width="100px" />  --%>
                        </Columns>
                        <ClientSideEvents ValueChanged="function(s, e) {GetSubAcountComboBox(e)}" KeyDown="SubAccountComboBoxKeyDown" />
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
                    <div class="text-center">
                        <button type="button" style="margin-top: 50px;" class="btn-danger" onclick="SubPopUpHide();">Cancel</button>
                    </div>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            <HeaderStyle BackColor="Blue" Font-Bold="True" ForeColor="White" />
        </dxe:ASPxPopupControl>
        <%--  <dx:LinqServerModeDataSource ID="EntityServerMainDataSource" runat="server" OnSelecting="EntityServerMainDataSource_Selecting"
        ContextTypeName="ERPDataClassesDataContext" TableName="v_MainAccountList" />--%>



        <%-- -------------------End   POPUPControl   FOR Main & Sub Account-------------------------------------%>
    </div>
    <div style="display: none">
        <%-- <asp:Button ID="btnPrint" runat="server" Text="Print" OnClick="btnPrint_Click" meta:resourcekey="btnPrintResource1" />--%>
        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
    </div>
    <dxe:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" ContainerElementID="grid"
        Modal="True">
    </dxe:ASPxLoadingPanel>
    <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
        <ClientSideEvents ControlsInitialized="AllControlInitilize" />
    </dxe:ASPxGlobalEvents>

    <%--DEBASHIS--%>
    <div class="PopUpArea">
        <dxe:ASPxPopupControl ID="ASPxDocumentsPopup" runat="server" ClientInstanceName="cDocumentsPopup"
            Width="350px" HeaderText="Select Design(s)" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentStyle VerticalAlign="Top"></ContentStyle>
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <dxe:ASPxCallbackPanel runat="server" ID="SelectPanel" ClientInstanceName="cSelectPanel" OnCallback="SelectPanel_Callback" ClientSideEvents-EndCallback="cSelectPanelEndCall">
                        <ClientSideEvents EndCallback="cSelectPanelEndCall"></ClientSideEvents>
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

    <div>
        <asp:HiddenField ID="hfIsFilter" runat="server" />
        <asp:HiddenField ID="hfFromDate" runat="server" />
        <asp:HiddenField ID="hfToDate" runat="server" />
        <asp:HiddenField ID="hfBranchID" runat="server" />
        <asp:HiddenField ID="hdnIsPartyLedger" runat="server" />
    </div>


    <div class="modal fade" id="MainAccountModel" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <!-- Modal MainAccount-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" onclick="closeModal();">&times;</button>
                    <h4 class="modal-title">Main Account Search</h4>
                </div>
                <div class="modal-body">
                    <input type="text" onkeydown="MainAccountNewkeydown(event)" id="txtMainAccountSearch" autofocus width="100%" placeholder="Search by Main Account Name or Short Name" />

                    <div id="MainAccountTable">
                        <table border='1' width="100%">
                            <tr class="HeaderStyle">
                                <th>Main Account Name</th>
                                <th>Short Name</th>
                                <th>Subledger Type</th>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="closeModal();">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="SubAccountModel" role="dialog" data-backdrop="static"
   data-keyboard="false">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" onclick="CloseSubModal();">&times;</button>
                    <h4 class="modal-title">Sub Account Search</h4>
                </div>
                <div class="modal-body">
                    <input type="text" onkeydown="SubAccountNewkeydown(event)" id="txtSubAccountSearch" autofocus width="100%" placeholder="Search By Sub Account Name or Code" />

                    <div id="SubAccountTable">
                        <table border='1' width="100%">
                            <tr class="HeaderStyle">
                                <th>Sub Account Name [Unique ID]</th>
                                <th>Sub Account Code</th>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="CloseSubModal();">Close</button>
                </div>
            </div>

        </div>
    </div>


</asp:Content>
