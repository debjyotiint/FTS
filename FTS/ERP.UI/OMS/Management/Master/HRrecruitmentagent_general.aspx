<%@ Page Title="Vendors/Service Providers" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master"
    Inherits="ERP.OMS.Management.Master.management_master_HRrecruitmentagent_general" CodeBehind="HRrecruitmentagent_general.aspx.cs" EnableEventValidation="false" %>

<%@ Register Src="~/OMS/Management/Master/UserControls/GSTINSettings.ascx" TagPrefix="GSTIN" TagName="gstinSettings" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="/assests/pluggins/choosen/choosen.min.js"></script>

    <script>
        $(document).ready(function () {
            //Subhabrata
            $("#<%=ddlAssetLiability.ClientID%>").change(function () {
                debugger;
                var varddlAssetLiability = $("#<%=ddlAssetLiability.ClientID%>").val();
                if (varddlAssetLiability === "0") {
                    $('#lstTaxRates_MainAccount').prop('disabled', false).trigger("chosen:updated");
                }
                else {
                    $('#lstTaxRates_MainAccount').prop('disabled', true).trigger("chosen:updated");
                }

            });//End



            var type = ($("[id$='radioregistercheck']").find(":checked").val() != null) ? $("[id$='radioregistercheck']").find(":checked").val() : "";
            if (type == '1') {
                $("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('disabled', false);
                $('#DivVendorType').removeClass('hide');
                // $('#<%=rdl_VendorType.ClientID %>').find("input[value='R']").prop("checked", true);
                //$("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('checked', false);
            }
            else if (type == '0') {
                $("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('disabled', true);
                   $("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('checked', false);
                   $('#DivVendorType').addClass('hide');
               }

            $('#radioregistercheck').change(function () {
                debugger;
                var type = ($("[id$='radioregistercheck']").find(":checked").val() != null) ? $("[id$='radioregistercheck']").find(":checked").val() : "";
                if (type == '1') {
                    $("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('disabled', false);
                   $('#<%=rdl_VendorType.ClientID %>').find("input[value='R']").prop("checked", true);
                   $('#DivVendorType').removeClass('hide');
                   //$("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('checked', false);
               }
               else if (type == '0') {
                   $("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('disabled', true);
                   $("#<%= rdl_VendorType.ClientID %> input[type=radio]").prop('checked', false);
                   $('#DivVendorType').addClass('hide');
               }
           })
        }
       )
    </script>
    <script language="javascript" type="text/javascript">

        function InvalidUDF() {
            jAlert("Udf is mandatory.", "Alert", function () { OpenUdf(); });

        }

        function branchGridEndCallBack() {

            if (cbranchGrid.cpReceviedString) {
                if (cbranchGrid.cpReceviedString == 'SetAllRecordToDataTable') {
                    cBranchSelectPopup.Hide();
                }
            }

            if (cbranchGrid.cpBrselected) {

                if (cbranchGrid.cpBrselected == '1') {
                    jAlert("Individual branch selection not allowed when all branch option is checked.");
                    cbranchGrid.cpBrselected = null;
                    cBranchSelectPopup.Show();
                }
                else { cbranchGrid.cpBrselected = null; }
            }

            if (cbranchGrid.cpBrChecked) {
                if (cbranchGrid.cpBrChecked == '1') {
                    $('#<%= lblBranch.ClientID %>').attr('style', 'display:inline');
                    $('#<%=chkAllBranch.ClientID %>').prop('checked', true)
                    cbranchGrid.cpBrChecked = null;
                    $('#<%= hdnBranchAllSelected.ClientID %>').val('0');
                }
                else {
                    $('#<%= lblBranch.ClientID %>').attr('style', 'display:none');
                    $('#<%=chkAllBranch.ClientID %>').prop('checked', false)
                    cbranchGrid.cpBrChecked = null;
                    $('#<%= hdnBranchAllSelected.ClientID %>').val('1');
                }
            }
        }

        function ClearSelectedBranch() {
            cbranchGrid.PerformCallback('ClearSelectedBranch');
        }

        function SelectAllBranches(e) {

            if (e.checked == true) {

                ClearSelectedBranch();
                $('#<%= hdnBranchAllSelected.ClientID %>').val('0');
                $('#<%= lblBranch.ClientID %>').attr('style', 'display:inline');

            }
            else {
                $('#<%= hdnBranchAllSelected.ClientID %>').val('1');
                $('#<%= lblBranch.ClientID %>').attr('style', 'display:none');

            }
        }




        function CmbBranchChanged() {
            var branchCode = CmbBranch.GetValue();
            if (branchCode == 0) {
                $('#MultiBranchButton').show();
            }
            else {
                $('#MultiBranchButton').hide();
            }
        }

        function MultiBranchClick() {
            cbranchGrid.PerformCallback('SetAllSelectedRecord');
            cBranchSelectPopup.Show();
        }

        function SaveSelectedBranch() {
            cbranchGrid.PerformCallback('SetAllRecordToDataTable');
        }

        function selectAll() {

            cbranchGrid.PerformCallback('SelectAllBranchesFromList');
            cBranchSelectPopup.Show();
        }
        function unselectAll() {
            cbranchGrid.PerformCallback('ClearSelectedBranch');
            cBranchSelectPopup.Show();
        }



        //Gstin settings




        function changeFunc() {
            //debugger;
            var MainAccount_val2 = document.getElementById("lstTaxRates_MainAccount").value;
            if (MainAccount_val2 === "0") {
                //$("#<%=ddlAssetLiability.ClientID%>").prop('disabled', false);
            }
            else {
                //$("#<%=ddlAssetLiability.ClientID%>").prop('disabled', true);
                if (document.getElementById('hdIsMainAccountInUse').value == "IsInUse") {
                    jAlert("Transaction exists for the selected Ledger. Cannot proceed.");
                    Changeselectedvalue();
                } else {

                    document.getElementById("hndTaxRates_MainAccount_hidden").value = document.getElementById("lstTaxRates_MainAccount").value;
                    ChangeSubSource();
                }
            }



        }

        function changeSubFunc() {
            document.getElementById("hndTaxRates_SubAccount_hidden").value = document.getElementById("lstTaxRates_SubAccount").value;
        }
        function ListBind() {

            var config = {
                '.chsn': {},
                '.chsn-deselect': { allow_single_deselect: true },
                '.chsn-no-single': { disable_search_threshold: 10 },
                '.chsn-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chsn-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }

        }

        function ChangeSubSource() {
            var fname = "%";
            var mainAccount = document.getElementById("hndTaxRates_MainAccount_hidden").value;;
            var lReportTo = $('select[id$=lstTaxRates_SubAccount]');
            lReportTo.empty();

            $.ajax({
                type: "POST",
                url: "HRrecruitmentagent_general.aspx/GetSubAccountList",
                data: JSON.stringify({ reqStr: fname, mainreqStr: mainAccount }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var list = msg.d;
                    var listItems = [];
                    if (list.length > 0) {

                        for (var i = 0; i < list.length; i++) {
                            var id = '';
                            var name = '';
                            id = list[i].split('|')[1];
                            name = list[i].split('|')[0];
                            $('#lstTaxRates_SubAccount').append($('<option>').text(name).val(id));
                        }

                        $(lReportTo).append(listItems.join(''));
                        ListBind();
                        $('#lstTaxRates_SubAccount').trigger("chosen:updated");
                        $('#lstTaxRates_SubAccount').trigger("chosen:updated");
                    }
                    else {
                        $('#lstTaxRates_SubAccount').trigger("chosen:updated");
                    }
                }
            });
        }

        function Changeselectedvalue() {
            var lstTaxRates_MainAccount = document.getElementById("lstTaxRates_MainAccount");
            if (document.getElementById("hndTaxRates_MainAccount_hidden").value != '') {
                for (var i = 0; i < lstTaxRates_MainAccount.options.length; i++) {
                    if (lstTaxRates_MainAccount.options[i].value == document.getElementById("hndTaxRates_MainAccount_hidden").value) {
                        lstTaxRates_MainAccount.options[i].selected = true;
                    }
                }
                $('#lstTaxRates_MainAccount').trigger("chosen:updated");
            }
        }
        function ChangeSourceMainAccount() {
            var fname = "%";
            var lReportTo = $('select[id$=lstTaxRates_MainAccount]');
            lReportTo.empty();

            $.ajax({
                type: "POST",
                url: "HRrecruitmentagent_general.aspx/GetMainAccountList",
                data: JSON.stringify({ reqStr: fname }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var list = msg.d;
                    var listItems = [];
                    if (list.length > 0) {
                        $('#lstTaxRates_MainAccount').empty().append('<option selected="selected" value="0">None</option>');//Subhabrata
                        for (var i = 0; i < list.length; i++) {
                            var id = '';
                            var name = '';
                            id = list[i].split('|')[1];
                            name = list[i].split('|')[0];

                            $('#lstTaxRates_MainAccount').append($('<option>').text(name).val(id));
                        }

                        $(lReportTo).append(listItems.join(''));

                        $('#lstTaxRates_MainAccount').trigger("chosen:updated");
                        Changeselectedvalue();
                    }
                    else {
                        $('#lstTaxRates_MainAccount').trigger("chosen:updated");
                    }
                }
            });
        }




        //Debjyoti Code for UDF
        function OpenUdf() {
            if (document.getElementById('IsUdfpresent').value == '0') {
                jAlert("UDF not define.");
            }
            else {
                var keyVal = document.getElementById('Keyval_internalId').value;
                var url = '/OMS/management/Master/frm_BranchUdfPopUp.aspx?Type=DV&&KeyVal_InternalID=' + keyVal;
                popup.SetContentUrl(url);
                popup.Show();
            }
            return true;
        }


        //Debjyoti Code for GSTIN 060217
        function fn_AllowonlyNumeric(s, e) {
            var theEvent = e.htmlEvent || window.event;
            var key = theEvent.keyCode || theEvent.which;
            var keychar = String.fromCharCode(key);
            if (key == 9 || key == 37 || key == 38 || key == 39 || key == 40 || key == 8) { //tab/ Left / Up / Right / Down Arrow, Backspace, Delete keys
                return;
            }
            var regex = /[0-9]/;

            if (!regex.test(keychar)) {
                theEvent.returnValue = false;
                if (theEvent.preventDefault)
                    theEvent.preventDefault();
            }
        }
        function Gstin2TextChanged(s, e) {

            if (!e.htmlEvent.ctrlKey) {
                if (e.htmlEvent.key != 'Control') {
                    s.SetText(s.GetText().toUpperCase());
                }
            }

        }

        $(document).ready(function () {

            $('#<%= lblBranch.ClientID %>').attr('style', 'display:none');

            <%--if (e.checked == true) {
             
                $('#<%= hdnBranchAllSelected.ClientID %>').val('0');
              

             }
             else {
                 $('#<%= hdnBranchAllSelected.ClientID %>').val('1');               

             }--%>





            if ($("#radioregistercheck").find(":checked").val() == '1') {

                // alert(1);
                ctxtGSTIN111.SetEnabled(true);
                ctxtGSTIN222.SetEnabled(true);
                ctxtGSTIN333.SetEnabled(true);
                cApplicableFrom.SetEnabled(true);
            }
            else {
                // alert(2);
                ctxtGSTIN111.SetText('');
                ctxtGSTIN222.SetText('');
                ctxtGSTIN333.SetText('');

                ctxtGSTIN111.SetEnabled(false);
                ctxtGSTIN222.SetEnabled(false);
                ctxtGSTIN333.SetEnabled(false);
                cApplicableFrom.SetEnabled(false);

            }



            ListBind();
            ChangeSource();
            ChangeSourceMainAccount();

            $('body').on('click', '#radioregistercheck', function () {
                var optionText = $('#<%=radioregistercheck.ClientID %> input:checked').val();
                if (optionText == '1') {
                    // $("#spanmandategstn").attr('style', 'display:inline;color:red');
                    //alert(1);
                    ctxtGSTIN111.SetEnabled(true);
                    ctxtGSTIN222.SetEnabled(true);
                    ctxtGSTIN333.SetEnabled(true);
                    cApplicableFrom.SetEnabled(true);
                }
                else {
                    //alert(2);
                    ctxtGSTIN111.SetText('');
                    ctxtGSTIN222.SetText('');
                    ctxtGSTIN333.SetText('');

                    ctxtGSTIN111.SetEnabled(false);
                    ctxtGSTIN222.SetEnabled(false);
                    ctxtGSTIN333.SetEnabled(false);
                    cApplicableFrom.SetEnabled(false);
                    // $("#spanmandategstn").attr('style', 'display:none;');
                }
            });

             


        });
        function validate() {
            debugger;
            var fName = ctxtFirstName.GetText();
            var sName = ctxtCode.GetText();
            var retValue = true;
            var validateFlag = true;
            if (fName.trim() == "") {
                $('#MandatoryName').css({ 'display': 'block' });
                retValue = false;
            }
            else {
                $('#MandatoryName').css({ 'display': 'none' });
            }
            if (sName.trim() == "") {
                $('#MandatoryShortName').css({ 'display': 'block' });
                retValue = false;
            } else {
                $('#MandatoryShortName').css({ 'display': 'none' });
            }

            //Debjyoti 060217
            $('#invalidGst').css({ 'display': 'none' });
            var gst1 = ctxtGSTIN111.GetText().trim();
            var gst2 = ctxtGSTIN222.GetText().trim();
            var gst3 = ctxtGSTIN333.GetText().trim();

            if (gst1.length == 0 && gst2.length == 0 && gst3.length == 0) {
                var isregistered = $('#<%=radioregistercheck.ClientID %> input:checked').val();
                if (isregistered == 1) {
                    jAlert('GSTIN is mandatory.');
                    retValue = false;
                }

            }
            else {


                if (gst1.length != 2 || gst2.length != 10 || gst3.length != 3) {
                    $('#invalidGst').css({ 'display': 'block' });
                    retValue = false;
                }


                var panPat = /^([a-zA-Z]{5})(\d{4})([a-zA-Z]{1})$/;
                var code = /([C,P,H,F,A,T,B,L,J,G])/;
                var code_chk = gst2.substring(3, 4);
                if (gst2.search(panPat) == -1) {
                    $('#invalidGst').css({ 'display': 'block' });
                    retValue = false;
                }
                if (code.test(code_chk) == false) {
                    $('#invalidGst').css({ 'display': 'block' });
                    retValue = false;
                }


                //Subhabrata
                var isregisteredCheck = $('#<%=radioregistercheck.ClientID %> input:checked').val();
                var finalGST = (gst1 + gst2 + gst3);
                var GSTINOldval = $("#<%=hddnGSTIN2Val.ClientID%>").val();

             

                if (cApplicableFrom.GetDate() === null && $("#<%=hddnApplicationMode.ClientID%>").val() === "Edit" && GSTINOldval.trim() !== finalGST.trim()) {
                    if (isregisteredCheck == "1") {

                        jAlert("Please enter Applicable from.");
                        retValue = false;
                        validateFlag = false;
                    }
                }
               <%-- else if (cApplicableFrom.GetDate() === null && $("#<%=hddnApplicationMode.ClientID%>").val() === "Edit") {
                    if (isregisteredCheck == "1") {

                        jAlert("Please enter Applicable from.");
                        retValue = false;
                        validateFlag = false;
                    }
                }--%>


                if (GSTINOldval.trim() !== finalGST.trim() && validateFlag == true && $("#<%=hddnApplicationMode.ClientID%>").val() === "Edit") {
                    if (isregisteredCheck == "1") {
                        var r = confirm("You have entered GSTIN Applicable date.Based on the applicable date all the transaction will be updated with entered GSTIN.\nAre you sure?");
                        if (r == true) {
                            retValue = true;
                        }
                        else {
                            retValue = false;
                        }
                        $("#<%=hddnGSTINFlag.ClientID%>").val("UPDATE");
                    }
                }
                else {
                    $("#<%=hddnGSTINFlag.ClientID%>").val("NotUPDATE");
                   }

               


                //End



            }






            //End Here Debjyoti 060217
            return retValue;
        }

        function disp_prompt(name) {
            //console.log(name);
            if (name == "tab0") {
                //alert(name);
                document.location.href = "HRrecruitmentagent_general.aspx";
            }
            if (name == "tab1") {
                //alert(name);
                document.location.href = "HRrecruitmentagent_ContactPerson.aspx";
            }
            else if (name == "tab2") {
                //alert(name);
                document.location.href = "HRrecruitmentagent_Correspondence.aspx";
            }
            else if (name == "tab3") {
                //alert(name);
                document.location.href = "HRrecruitmentagent_BankDetails.aspx";
            }

            else if (name == "tab4") {
                document.location.href = "HRrecruitmentagent_Document.aspx";
            }
            else if (name == "tab6") {
                document.location.href = "HRrecruitmentagent_GroupMember.aspx";

            }
            else if (name == "tab5") {
                //alert(name);
                document.location.href = "HRrecruitmentagent_Registration.aspx";
            }
            else if (name == "tab7") {
                document.location.href = "vendors_tds.aspx";
            }

        }

        function UniqueCheck() {
            var code = 0;
            if (GetObjectID('HdId').value != '') {
                code = GetObjectID('HdId').value;
            }
            var reminderShortName = ctxtCode.GetText();
            if (reminderShortName.trim() == '')
                return;
            var CheckUniqueCode = false;
            $.ajax({
                type: "POST",
                url: "HRrecruitmentagent_general.aspx/CheckUniqueCode",
                data: JSON.stringify({ CategoriesShortCode: reminderShortName, Code: code }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    CheckUniqueCode = msg.d;
                    if (CheckUniqueCode != true) {
                        jAlert('Unique ID already exists.');
                        ctxtCode.SetText('');
                        ctxCode.Focus();
                    }
                }
            });
        }

        function CallList(obj1, obj2, obj3) {
            if (obj1.value == "") {
                obj1.value = "%";
            }

            var obj4 = document.getElementById('<%=cmbSource.ClientID %>');
            var obj5 = obj4.value;


            if (obj5 != '18') {
                ajax_showOptionsTEST(obj1, obj2, obj3, obj5);
                if (obj1.value == "%") {
                    obj1.value = "";
                }
            }
        }
        function ListBind() {

            var config = {
                '.chsn': {},
                '.chsn-deselect': { allow_single_deselect: true },
                '.chsn-no-single': { disable_search_threshold: 10 },
                '.chsn-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chsn-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }

        }
        function lstReferedBy() {

            // $('#lstReferedBy').chosen();
            $('#lstReferedBy').fadeIn();
        }

        function switchRefferedControl(obj) {
            switch (obj) {
                case "1":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "2":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "5":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "6":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "7":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "9":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "11":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "12":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "13":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "15":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "16":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;

                case "17":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "18":
                    document.getElementById("refferByDD").value = false;
                    $('#txtReferedBy').css({ 'display': 'block' });
                    $('#lstReferedBy_chosen').css({ 'display': 'none' });
                    return false;
                    break;
                case "0":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "3":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "4":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "8":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "10":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "14":
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "20":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "24":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                case "25":
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
                default:
                    //dd
                    document.getElementById("refferByDD").value = true;
                    $('#txtReferedBy').css({ 'display': 'none' });
                    $('#lstReferedBy_chosen').css({ 'display': 'block' });
                    return true;
                    break;
            }
        }

        function ChangeSource() {
            var InterId = "";
            if (document.getElementById("cmbSource").value) {
                InterId = document.getElementById("cmbSource").value;
            }
            var id = document.getElementById("cmbSource").value;
            if (switchRefferedControl(id)) {
                var lReferBy = $('select[id$=lstReferedBy]');
                lReferBy.empty();
                $.ajax({
                    type: "POST",
                    url: "HRrecruitmentagent_general.aspx/GetReffer",
                    data: JSON.stringify({ sourceId: id, hdKeyValIntId: InterId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var list = msg.d;
                        var listItems = [];
                        if (list.length > 0) {

                            for (var i = 0; i < list.length; i++) {
                                var id = '';
                                var name = '';
                                id = list[i].split('|')[1];
                                name = list[i].split('|')[0];

                                listItems.push('<option value="' +
                                name + '">' + name
                                + '</option>');
                            }

                            $(lReferBy).append(listItems.join(''));

                            lstReferedBy();
                            $('#lstReferedBy').trigger("chosen:updated");

                            if (switchRefferedControl(document.getElementById("cmbSource").value)) {
                                var valRefferBy = document.getElementById('RefferedByValue').value;

                                if (valRefferBy) {
                                    var refferByChosen = document.getElementById("lstReferedBy");

                                    for (var i = 0; i < refferByChosen.options.length; i++) {
                                        if (refferByChosen.options[i].value == valRefferBy) {
                                            refferByChosen.options[i].selected = true;
                                        }
                                    }
                                    $('#lstReferedBy').trigger("chosen:updated");
                                    document.getElementById('RefferedByValue').value = null;
                                }
                            }

                        }
                        else {
                            jAlert("No records found");
                            lstReferedBy();
                            $('#lstReferedBy').trigger("chosen:updated");
                        }
                    }
                });
            }
        }

        FieldName = 'cmbLegalStatus';
    </script>

    <style>
        .vehiclecls {
            display: inline;
            color: red;
            font-size: 14px;
            padding-left: 15px;
        }

        .abs {
            position: absolute;
            right: -19px;
            top: 4px;
        }

        .chosen-container.chosen-container-single {
            width: 100% !important;
        }

        .chosen-choices {
            width: 100% !important;
        }

        #lstReferedBy {
            width: 200px;
        }

        #lstReferedBy {
            display: none !important;
        }

        #lstReferedBy_chosen {
            width: 100% !important;
        }

        .dxtcLite_PlasticBlue > .dxtc-content {
            overflow: visible !important;
        }

        .nestedinput li {
            list-style-type: none;
            display: inline-block;
            float: left;
        }

            .nestedinput li.dash {
                width: 26px;
                text-align: center;
                padding: 6px;
            }

            .nestedinput li .iconRed {
                position: absolute;
                right: -10px;
                top: 5px;
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Vendors/Service Providers</h3>
            <div class="crossBtn"><a href="HRrecruitmentagent.aspx"><i class="fa fa-times"></i></a></div>
        </div>
    </div>
    <div class="form_main">
        <%--debjyoti 21-03-2016--%>
        <dxe:ASPxPopupControl ID="ASPXPopupControl" runat="server"
            CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popup" Height="630px"
            Width="600px" HeaderText="Add/Modify UDF" Modal="true" AllowResize="true" ResizingMode="Postponed">
            <contentcollection>
                                                <dxe:PopupControlContentControl runat="server">
                                                </dxe:PopupControlContentControl>
                                            </contentcollection>
        </dxe:ASPxPopupControl>
        <asp:HiddenField runat="server" ID="IsUdfpresent" />
        <asp:HiddenField runat="server" ID="Keyval_internalId" />
        <asp:HiddenField ID="hidAssociatedEmp" runat="server" />
        <asp:HiddenField ID="hddnApplicationMode" runat="server" />
        <asp:HiddenField ID="hddnGSTIN2Val" runat="server" />
        <asp:HiddenField ID="hddnGSTINFlag" runat="server" />
        <%--End debjyoti 21-03-2016--%>



        <%-- <div class="crossBtn" style="right: 28px;top: 14px;"><a href="HRrecruitmentagent.aspx"><i class="fa fa-times"></i></a></div>--%>
        <table class="TableMain100">
            <tr>
                <td style="text-align: center">
                    <asp:Label ID="lblHeader" runat="server" Font-Bold="True" Font-Size="15px" ForeColor="Navy"
                        Width="819px" Height="18px"></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0" ClientInstanceName="page" Width="100%">
                        <tabpages>
                            <dxe:TabPage Text="General" Name="General">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                        <div class="row">
                                            <div class="col-md-3 hide">
                                                <label>
                                                    <dxe:ASPxLabel ID="ASPxLabel1" runat="server" Text="Salutation">
                                                    </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                    <asp:DropDownList ID="CmbSalutation" runat="server" Width="100%" TabIndex="1">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label>
                                                    <dxe:ASPxLabel ID="ASPxLabel5" runat="server" Text="Name">
                                                    </dxe:ASPxLabel>
                                                    <span style="color:red"> *</span>
                                                </label>
                                                <div style="position:relative">
                                                    <dxe:ASPxTextBox ID="txtFirstName" runat="server" Width="100%" TabIndex="2"  MaxLength="150" clientInstanceName="ctxtFirstName" CssClass="upper">
                                                       <%-- <ValidationSettings ValidationGroup="a">
                                                        </ValidationSettings>--%>
                                                    </dxe:ASPxTextBox> 
                                                   
                                                    <span id="MandatoryName" class="pullleftClass fa fa-exclamation-circle iconRed " style="color:red;display:none;position:absolute;    right: -20px;
    top: 5px;" title="Mandatory"></span>
                                                       
                                                    <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtFirstName"
                                                        Display="Dynamic" ErrorMessage="Mandatory." SetFocusOnError="True" ValidationGroup="a"
                                                         ForeColor="Red"></asp:RequiredFieldValidator>--%>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label><dxe:ASPxLabel ID="ASPxLabel4" runat="server" Text="Unique ID" >
                                                </dxe:ASPxLabel>
                                                    <span style="color:red"> *</span>
                                                </label>
                                                <div style="position:relative">
                                                    <dxe:ASPxTextBox ID="txtCode" runat="server" Width="100%" TabIndex="3" MaxLength="80" clientInstanceName="ctxtCode" CssClass="upper">
                                                        <clientsideevents lostfocus="function(s, e) {
	                                                            UniqueCheck();
                                                            }" />
                                                     </dxe:ASPxTextBox>
                                                    <span id="MandatoryShortName" class="pullleftClass fa fa-exclamation-circle iconRed " style="color:red;display:none;position:absolute;    right: -20px;
    top: 5px;" title="Mandatory"></span>

                                                    <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCode"
                                                        Display="Dynamic" ErrorMessage="Mandatory."  ForeColor="Red" ValidationGroup="a"></asp:RequiredFieldValidator>--%>
                                                </div>
                                            </div>
                                            <div class="col-md-3" style="display:none;">
                                                 <label>&nbsp;<dxe:ASPxLabel ID="ASPxLabel10" runat="server" Text="Branch" Width="59px">
                                                    </dxe:ASPxLabel>
                                                 </label>
                                                <div>
                                                    <asp:DropDownList ID="cmbBranch" runat="server" Width="100%" TabIndex="4">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-3 hide">
                                                <label><dxe:ASPxLabel ID="ASPxLabel13" runat="server" Text="Source">
                                                </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                    <asp:DropDownList ID="cmbSource" runat="server" Width="100%" TabIndex="5" onchange="ChangeSource()">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label><dxe:ASPxLabel ID="ASPxLabel17" runat="server" Text="Referred By" Width="73px">
                                                </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                    <asp:TextBox ID="txtReferedBy" runat="server"  Width="100%" MaxLength="100" style="display:none" TabIndex="6"></asp:TextBox>
                                                  <%--  <asp:TextBox ID="txtReferedBy_hidden" runat="server" Visible="False"></asp:TextBox>--%>
                                                    <asp:ListBox ID="lstReferedBy" CssClass="chsn"   runat="server" Font-Size="12px" Width="100%" TabIndex="6"  data-placeholder="Select..."></asp:ListBox>
                                                      
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label><dxe:ASPxLabel ID="ASPxLabel19" runat="server" Text="Status" Width="95px">
                                                </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                    <asp:DropDownList ID="cmbContactStatus" runat="server" Width="100%" TabIndex="7">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label>
                                                    <dxe:ASPxLabel ID="ASPxLabel20" runat="server" Text="Legal Status" Width="70px">
                                                    </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                    <asp:DropDownList ID="cmbLegalStatus" runat="server" Width="100%" TabIndex="8">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-3 lblmTop8">
                                                <label style="margin-top:0">
                                                    <dxe:ASPxLabel ID="ASPxLabel2" runat="server" Text="Date Of Incorporation">
                                                    </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                   <%-- <dxe:ASPxDateEdit ID="DateOfIncoorporation" runat="server" DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd"
                                                        TabIndex="9">
                                                    </dxe:ASPxDateEdit>  --%>   
                                                    <dxe:ASPxDateEdit ID="DateOfIncoorporation" runat="server" DisplayFormatString="dd-MM-yyyy"  EditFormatString="dd-MM-yyyy"
                                                        TabIndex="9"  clientInstanceName="cDateOfIncoorporation" Width="100%">                                       
                                                    </dxe:ASPxDateEdit>                                             
                                                </div>
                                            </div>
                                          
                                              <div class="col-md-3 lblmTop8">
                                                <div class="padBot5 lblmTop8" style="display: block;">
                                                    <span>Main Account</span> 
                                                </div>
                                                <div class="Left_Content"> 
                                                      <asp:ListBox ID="lstTaxRates_MainAccount" CssClass="chsn" runat="server" Font-Size="12px" Width="100%" data-placeholder="Select..." TabIndex="10"  onchange="changeFunc();"></asp:ListBox>
                                                    <asp:HiddenField ID="hndTaxRates_MainAccount_hidden" runat="server" />
                                                </div>
                                              </div>


                                          <div class="col-md-3" id="divBranch" style="display:block;">
                                            <label>
                                                Branch :<%--<span style="color: Red;">*</span>  --%>                                            
                                            </label>
                                            <div>
                                                 <div><asp:Label ID="lblSelectedBranch" runat="server"></asp:Label></div>  

                                                <dxe:ASPxComboBox ID="cmbMultiBranches" ClientInstanceName="CmbBranch" runat="server"   Visible="false"
                                                    ValueType="System.String" DataSourceID="branchdtl" ValueField="branch_id"
                                                    TextField="branch_description" EnableIncrementalFiltering="true"
                                                    Width="90%" AutoPostBack="false">
                                                    <ClientSideEvents SelectedIndexChanged="CmbBranchChanged" Init="CmbBranchChanged" />
                                                </dxe:ASPxComboBox>
                                                <input type="button" onclick="MultiBranchClick()" class="btn btn-small btn-primary" value="Select Branch(s)" id="MultiBranchButton" ></input>
                                            </div>                                          
                                        </div>




                                               <div class="col-md-3 hide" id="divtxtTaxRates_SubAccount"  >
                                                    <div class="padBot5" style="display: block; height: auto;">
                                                        Sub Account
                                                    </div>
                                                    <div class="Left_Content"> 
                                                        <asp:ListBox ID="lstTaxRates_SubAccount" CssClass="chsn" runat="server" Font-Size="12px" Width="100%" data-placeholder="Select..." onchange="changeSubFunc();"></asp:ListBox>
                                                        <asp:HiddenField ID="hndTaxRates_SubAccount_hidden" runat="server" />
                                                    </div>
                                                </div>

                                              <div class="clear"></div>
                                            <%--Debjyoti GSTIN in Vendor--%>
                                             <div id="td_registered" class="labelt col-md-3" runat="server">
                                                            <div class="visF">

                                                                <label>Registered?</label>
                                                                <asp:RadioButtonList runat="server" ID="radioregistercheck" RepeatDirection="Horizontal" Width="130px">
                                                                    <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                                                    <asp:ListItem Text="No" Value="0"  Selected="True"></asp:ListItem>
                                                                </asp:RadioButtonList>
                                                            </div>
                                                </div>
                                                <div class="col-md-6 lblmTop8">
                                                <label >GSTIN   </label>
                                                <div class="relative"> 
                                                      <ul class="nestedinput">
                                                        <li>
                                                            <dxe:ASPxTextBox ID="txtGSTIN1" ClientInstanceName="ctxtGSTIN111"  MaxLength="2"  TabIndex="10"  runat="server" Width="50px">
                                                              <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                                                            </dxe:ASPxTextBox>
                                                        </li>
                                                        <li class="dash"> - </li>
                                                        <li>
                                                            <dxe:ASPxTextBox ID="txtGSTIN2" ClientInstanceName="ctxtGSTIN222"  MaxLength="10"  TabIndex="11"  runat="server" Width="150px"> 
                                                          <ClientSideEvents KeyUp="Gstin2TextChanged" />
                                                                   </dxe:ASPxTextBox>
                                                        </li>
                                                        <li class="dash"> - </li>
                                                        <li>
                                                            <dxe:ASPxTextBox ID="txtGSTIN3" ClientInstanceName="ctxtGSTIN333"  MaxLength="3"  TabIndex="12"  runat="server" Width="50px"> 
                                                            </dxe:ASPxTextBox>
                                                            <span id="invalidGst" class="pullleftClass fa fa-exclamation-circle iconRed " style="color:red;display:none;padding-left: 9px;left:304px" title="Invalid GSTIN"></span>
                                                        </li>
                                                    </ul>  
                                                      <a href="https://services.gst.gov.in/services/searchtp" target="_blank"  style="padding-left:10px" >Validate GST</a>  
                                                 </div>
                                                 </div>
                                                <div class="clear"></div>
                                                <div class="col-md-3 visF" id="td_Applicablefrom"> 
                                                        <div class="labelt">
                                                            <dxe:ASPxLabel ID="lbl_Applicablefrom" runat="server" Text="Applicable From">
                                                            </dxe:ASPxLabel>
                                                        </div>
                                                        <div class="visF">
                                                            <dxe:ASPxDateEdit ID="dt_ApplicableFrom" TabIndex="13" runat="server" Width="100%" EditFormat="Custom" ClientInstanceName="cApplicableFrom"
                                                                EditFormatString="dd-MM-yyyy" UseMaskBehavior="True">
                                                                <ButtonStyle Width="13px">
                                                                </ButtonStyle>
                                                            </dxe:ASPxDateEdit>

                                                        </div>
                                                </div>
                                            <%--Debjyoti GSTIN in Vendor--%>
                                            <div class="col-md-3">
                                                <label><dxe:ASPxLabel ID="ASPxLabel3" runat="server" Text="Name To Print in Cheque" Width="273px">
                                                </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                    <asp:TextBox ID="txtNameInCheque" runat="server"  Width="100%" MaxLength="200"  TabIndex="14"></asp:TextBox>
                                                 
                                                      
                                                </div>
                                            </div>
                                            
                                             <div class="col-md-3 ">
                                                <label>
                                                    <dxe:ASPxLabel ID="ASPxLabel6" runat="server" Text="Accounts Group">
                                                    </dxe:ASPxLabel>
                                                </label>
                                                <div>
                                                    <asp:DropDownList ID="ddlAssetLiability" runat="server" Width="100%" TabIndex="1">
                                                    </asp:DropDownList>
                                            </div>
                                        </div>
                                             <div  class="labelt col-md-3" >
                                                            <div id="DivVendorType" class="visF hide">

                                                                <label>Vendor Type</label>
                                                                <asp:RadioButtonList runat="server" ID="rdl_VendorType" RepeatDirection="Horizontal" Width="210px">
                                                                    <asp:ListItem Text="Regular" Value="R" ></asp:ListItem>
                                                                    <asp:ListItem Text="Composition" Value="C"  ></asp:ListItem>
                                                                </asp:RadioButtonList>
                                                            </div>
                                                </div>

                                            <div class="clear"></div>
                                            <div class="col-md-12" style="padding-top:15px">
                                                <dxe:ASPxButton ID="btnSave" runat="server" Text="Save" ValidationGroup="a" TabIndex="13"
                                                    OnClick="btnSave_Click"  CssClass="btn btn-primary">
                                                    <clientsideevents Click="function(s, e) {
                                                                if(document.getElementById('lstReferedBy').value){
                                                                document.getElementById('RefferedByValue').value= document.getElementById('lstReferedBy').value;
                                                                }
	                                                            var valid= validate();
                                                                e.processOnServer = valid;

                                                        }" />
                                                </dxe:ASPxButton>
                                                     <asp:Button ID="btnUdf" runat="server" Text="UDF"  CssClass="btn btn-primary dxbButton"  OnClientClick="if(OpenUdf()){ return false;}"/>

                                               <%-- <asp:Button ID="GstinSettingsButton" runat="server" Text="GSTIN Settings Branchwise"  CssClass="btn btn-primary dxbButton"  OnClientClick="openGstin();return false;"/>--%>
                                                <GSTIN:gstinSettings runat="server" ID="GstinSettingsButton" />
                                            </div>
                                            
                                        </div>
                                        
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Text="Contact Person" Name="ContactPreson">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Text="Correspondence" Name="CorresPondence">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Name="BankDetails" Text="Bank Details">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                           <%-- <dxe:TabPage Name="DPDetails" Text="DP Details">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>--%>
                            <dxe:TabPage Name="Documents" Text="Documents">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                             <dxe:TabPage Name="Registration" Text="Registration">
                                <contentcollection>
                                                            <dxe:ContentControl runat="server">
                                                            </dxe:ContentControl>
                                                        </contentcollection>
                            </dxe:TabPage>
                            <dxe:TabPage Name="GroupMember" Text="Group Member">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>

                             <dxe:TabPage Name="TDS" Text="TDS">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>


                        </tabpages>
                        <clientsideevents activetabchanged="function(s, e) {
	                                            var activeTab   = page.GetActiveTab();
	                                            var Tab0 = page.GetTab(0);
	                                            var Tab1 = page.GetTab(1);
	                                            var Tab2 = page.GetTab(2);
	                                            var Tab3 = page.GetTab(3);
	                                            var Tab4 = page.GetTab(4);
	                                            var Tab5 = page.GetTab(5);
	                                            var Tab6 = page.GetTab(6);
	                                            var Tab7 = page.GetTab(7);
                                                var Tab8 = page.GetTab(8);
	                                            
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
	                                            else if(activeTab == Tab3)
	                                            {
	                                                disp_prompt('tab3');
	                                            }
	                                            else if(activeTab == Tab4)
	                                            {
	                                                disp_prompt('tab4');
	                                            }
	                                            else if(activeTab == Tab5)
	                                            {
	                                                disp_prompt('tab5');
	                                            }
	                                            else if(activeTab == Tab6)
	                                            {
	                                                disp_prompt('tab6');
	                                            }
	                                            else if(activeTab == Tab7)
	                                            {
	                                                disp_prompt('tab7');
	                                            }
                                                else if(activeTab == Tab8)
	                                            {
	                                                disp_prompt('tab8');
	                                            }
	                                            
	                                            }"></clientsideevents>
                        <contentstyle>
                            <Border BorderColor="#002D96" BorderStyle="Solid" BorderWidth="1px" />
                        </contentstyle>
                        <loadingpanelstyle imagespacing="6px">
                        </loadingpanelstyle>
                    </dxe:ASPxPageControl>
                </td>
            </tr>
            <tr>
                <td style="height: 8px">
                    <table style="width: 100%;">
                        <tr>
                            <td align="right" style="width: 843px">
                                <asp:HiddenField ID="hdReferenceBy" runat="server" />
                                <asp:HiddenField ID="refferByDD" runat="server" />
                                <asp:HiddenField ID="RefferedByValue" runat="server" />
                                <asp:HiddenField ID="hdKeyVal_InternalID" runat="server" />
                                <asp:HiddenField ID="HdId" runat="server" />
                                <asp:HiddenField ID="hdIsMainAccountInUse" runat="server" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <asp:SqlDataSource ID="branchdtl" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select '0' as branch_id ,  'Select' as branch_description union all   select branch_id,branch_description from tbl_master_branch order by branch_description"></asp:SqlDataSource>

        <asp:SqlDataSource ID="BranchdataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select branch_id,branch_code,branch_description from tbl_master_branch"></asp:SqlDataSource>


        <asp:HiddenField ID="hdnBranchAllSelected" runat="server" />
    </div>

    <dxe:ASPxPopupControl ID="BranchSelectPopup" runat="server" Width="700"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="cBranchSelectPopup"
        HeaderText="Select Branch" AllowResize="false" ResizingMode="Postponed" Modal="true">
        <contentcollection>
            <dxe:PopupControlContentControl runat="server">

                 <div style="margin-bottom:10px;margin-top:10px;"> Apply for All Branch &nbsp; 
                     <asp:CheckBox ID="chkAllBranch" runat="server" OnClick="SelectAllBranches(this);" />
                     <asp:Label ID="lblBranch"  runat="server" Text="All Branch Selected, No need to select individual Branch"  CssClass="vehiclecls"></asp:Label>
                 </div>



                <dxe:ASPxGridView ID="branchGrid" runat="server" KeyFieldName="branch_id" AutoGenerateColumns="False" DataSourceID="BranchdataSource"
                    Width="100%" ClientInstanceName="cbranchGrid" OnCustomCallback="branchGrid_CustomCallback"
                    SelectionMode="Multiple" SettingsBehavior-AllowFocusedRow="true">
                    <Columns>

                        <dxe:GridViewCommandColumn ShowSelectCheckbox="true" VisibleIndex="0" Width="60" Caption="Select" />


                        <dxe:GridViewDataTextColumn Caption="Branch Code" FieldName="branch_code"
                            VisibleIndex="1" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>

                        <dxe:GridViewDataTextColumn Caption="Branch Description" FieldName="branch_description"
                            VisibleIndex="1" FixedStyle="Left">
                            <CellStyle CssClass="gridcellleft" Wrap="true">
                            </CellStyle>
                            <Settings AutoFilterCondition="Contains" />
                        </dxe:GridViewDataTextColumn>





                    </Columns>
                    
                    <SettingsPager NumericButtonCount="20" PageSize="10" ShowSeparators="True" Mode="ShowPager">
                        <FirstPageButton Visible="True">
                        </FirstPageButton>
                        <LastPageButton Visible="True">
                        </LastPageButton>
                    </SettingsPager>
                    <SettingsSearchPanel Visible="True" />
                    <Settings ShowGroupPanel="False" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsLoadingPanel Text="Please Wait..." />
                    <ClientSideEvents EndCallback="branchGridEndCallBack" />
                </dxe:ASPxGridView>
                <br />
                <input type="button" value="Ok" class="btn btn-primary" onclick="SaveSelectedBranch()" />
                <div style="float:right;">
                <input type="button" runat="server"  value="Select All" onclick="selectAll()" />
                 <input type="button" runat="server"    value="Deselect All" onclick="unselectAll()" />
                </div>
            </dxe:PopupControlContentControl>
        </contentcollection>
    </dxe:ASPxPopupControl>


</asp:Content>
