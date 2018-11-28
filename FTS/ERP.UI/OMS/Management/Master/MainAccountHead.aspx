<%@ Page Title="Account Head" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master"
    Inherits="ERP.OMS.Management.Master.management_master_MainAccountHead" CodeBehind="MainAccountHead.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
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
    </script>
    <style>
        .truncated {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        #MainAccountGrid_DXPEForm_efnew_ASPxComboBox1_ETC {
            display: none;
        }
    </style>

    <script type="text/javascript">


        //Code for UDF Control 
        function unSelectAllBranch() {
            cbranchGrid.UnselectRows();
        }

        function SelectAllBranch() {
            cbranchGrid.SelectRows();
        }

        function OpenUdf() {
            if (document.getElementById('IsUdfpresent').value == '0') {
                jAlert("UDF not define.");
            }
            else {
                var keyVal = document.getElementById('Keyval_internalId').value;
                var url = '/OMS/management/Master/frm_BranchUdfPopUp.aspx?Type=AH&&KeyVal_InternalID=' + keyVal;
                popup.SetContentUrl(url);
                popup.Show();
            }
            return true;
        }

        // End Udf Code
        function branchGridEndCallBack() {
            if (cbranchGrid.cpReceviedString) {
                if (cbranchGrid.cpReceviedString == 'SetAllRecordToDataTable') {
                    cBranchSelectPopup.Hide();
                }
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

        //$(document).ready(function () {
        //    var acval = $('#ASPxComboBox1').val();
        //    alert(acval);

        //});
        //function SignOff()
        // {
        //     window.parent.SignOff();
        // }
        // function height()
        // {
        //     if(document.body.scrollHeight>=900)
        //         window.frameElement.height = document.body.scrollHeight+200;
        //     else
        //         window.frameElement.height = '900px';
        //     window.frameElement.Width = document.body.scrollWidth;
        // }

        function DisablePaymentType(s, e) {
            if (cPaymenttype.GetValue() == null) {
                cPaymenttype.SetValue('None');
            }
            cPaymenttype.SetEnabled(false);
        }


        function changeControlState(state) {

            txtAccountCode.SetEnabled(state);
            ASPxComboBox1.SetEnabled(state);
            //    combAccountGroup.SetEnabled(state);
            ASPxComboBox2.SetEnabled(state);
            txtBankAccountNo.SetEnabled(state);
            comboCompanyName.SetEnabled(state);
            CmbBranch.SetEnabled(state);
            CmbSubLedgerType.SetEnabled(state);
            txtRateofIntrest.SetEnabled(state);
            cmb_tdstcs.SetEnabled(state);

        }

        function OntxtAccountCodeInit(s, e) {



            if (txtAccountCode.GetText().length > 0) {
                if (s.GetText().toLowerCase().indexOf("systm") >= 0) {
                    changeControlState(false);
                } else {
                    changeControlState(true);
                    txtAccountCode.SetEnabled(false);
                }
            } else {
                changeControlState(true);
            }
        }
        $('#MainAccountGrid_tccell1_18').attr('style', 'text-align: center !important');
        function EndCall(obj) {

        }
        function CallList(obj1, obj2, obj3) {
            FieldName = 'Label1';
            ajax_showOptions(obj1, obj2, obj3);
        }

        function Load(obj) {

            document.getElementById("tdsrate").style.display = 'none';
            document.getElementById("tdsrate1").style.display = 'none';
            document.getElementById("fbtrate").style.display = 'none';
            document.getElementById("fbtrate1").style.display = 'none';
        }

        function LoadSubledger(obj, obj1, obj2, obj3) {
            if (obj1 != 'None') {
                var aaaa = obj;
                url1 = "frm_Subledger.aspx?id=" + aaaa + "&name=" + obj1 + "&accountType=" + obj2 + "&accountcode=" + obj3;
                window.location.href = url1;
                //OnMoreInfoClick(url1, "Modify Sub Ledger", '990px', '520px', "Y");
            }

        }

        function AccopuntType(obj) {
            //if (obj != "-1") {

            //    combAccountGroup.PerformCallback(obj);
            //}
            if (obj == '0') {
                //ASPxComboBox2.SetSelectedIndex(0);

                document.getElementById("trBankCashType").style.display = 'block';
                //ASPxComboBox2.SetSelectedIndex(0);
                //document.getElementById("tdBankCashType").style.display = 'inline';
                //document.getElementById("tdBankCashType").style.display = 'block';

                //document.getElementById("tdBankCashType1").style.display = 'inline';
                //document.getElementById("tdBankCashType1").style.display = 'block';

                //document.getElementById("tdBankAccountNo").style.display = 'inline';
                document.getElementById("tdBankAccountNo").style.display = 'block';
                document.getElementById("clsPaymentType").style.display = 'block';

                //document.getElementById("tdBankAccountNo1").style.display = 'inline';
                //document.getElementById("tdBankAccountNo1").style.display = 'block';

                document.getElementById("tdBankAccountType").style.display = 'inline';
                document.getElementById("tdBankAccountType").style.display = 'none';// modified by atish from table-cell to none for not showing for asset account type

                document.getElementById("tdBankAccountType1").style.display = 'inline';
                document.getElementById("tdBankAccountType1").style.display = 'none';// modified by atish from table-cell to none for not showing for asset account type

                document.getElementById("tdSubledgertype").style.display = 'none';
                //document.getElementById("tdSubledgertype1").style.display = 'none';
                //document.getElementById("tdExchangeSeg").style.display = 'inline';
                //document.getElementById("tdExchangeSeg").style.display = 'table-cell';

                //document.getElementById("tdExchangeSeg1").style.display = 'inline';
                //document.getElementById("tdExchangeSeg1").style.display = 'table-cell';
                document.getElementById("tddepretion").style.display = 'none';
                document.getElementById("tdroi").style.display = 'none';
                document.getElementById("tdroi1").style.display = 'none';
                document.getElementById("tdtdsapprate").style.display = 'none';
                document.getElementById("tdtdsapprate1").style.display = 'none';
                var asettypeindex = ASPxComboBox2.GetSelectedIndex();
                BankCashType(asettypeindex);
                combAccountGroup.PerformCallback(obj);
            }
            else {

                //ASPxComboBox2.SetSelectedIndex(0);
                //document.getElementById("tdBankCashType").style.display = 'none';
                //document.getElementById("tdBankCashType1").style.display = 'none';
                document.getElementById("trBankCashType").style.display = 'none';
                document.getElementById("tdBankAccountNo").style.display = 'none';
                // document.getElementById("clsPaymentType").style.display = 'none';
                //document.getElementById("tdBankAccountNo1").style.display = 'none';
                document.getElementById("tdBankAccountType").style.display = 'none';
                document.getElementById("tdBankAccountType1").style.display = 'none';
                document.getElementById("tdSubledgertype").style.display = 'inline';
                document.getElementById("tdSubledgertype").style.display = 'table-cell';

                //document.getElementById("tdSubledgertype1").style.display = 'block';
                //document.getElementById("tdSubledgertype1").style.display = 'block';

                //document.getElementById("tdExchangeSeg").style.display = 'none';
                //document.getElementById("tdExchangeSeg1").style.display = 'none';
                document.getElementById("tddepretion").style.display = 'none';
                $("#trBankCashType").addClass("classname");
                document.getElementById("tdroi").style.display = 'inline';
                document.getElementById("tdroi1").style.display = 'inline';
                document.getElementById("tdtdsapprate").style.display = 'block';
                document.getElementById("tdtdsapprate1").style.display = 'block';
                var asettypeindex = ASPxComboBox2.GetSelectedIndex();
                BankCashType(asettypeindex);
                combAccountGroup.PerformCallback(obj);

                // document.getElementById("clsPaymentType").style.display = 'block';
                ItemaOther();
            }
        }
        function ItemsBank() {

            var comboitem = cPaymenttype.FindItemByValue('None');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('Card');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('Coupon');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('Etransfer');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('LedgOut');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('LedgIn');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('PrcFee');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('EmiCharge');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            cPaymenttype.AddItem("None", "None");
            cPaymenttype.AddItem("Card", "Card");
            cPaymenttype.AddItem("Coupon", "Coupon");
            cPaymenttype.AddItem("Etransfer", "Etransfer");
        }
        function ItemaOther() {
            //<dxe:ListEditItem Text="None" Value="None" Selected="true" />
            //<dxe:ListEditItem Text="Card" Value="Card" />
            //<dxe:ListEditItem Text="Coupon" Value="Coupon" />
            //<dxe:ListEditItem Text="Etransfer" Value="Etransfer" />
            //<dxe:ListEditItem Text="Ledger for Interstate Stk-Out" Value="LedgOut" />
            //<dxe:ListEditItem Text="Ledger for Interstate Stk-In" Value="LedgIn" />

            //<dxe:ListEditItem Text="Finance Processing Fee" Value="PrcFee" />
            //<dxe:ListEditItem Text="Finance Other Charges Emi" Value="EmiCharge" />

            var comboitem = cPaymenttype.FindItemByValue('None');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('Card');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('Coupon');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('Etransfer');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('Etransfer');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('LedgOut');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('LedgIn');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('PrcFee');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            var comboitem = cPaymenttype.FindItemByValue('EmiCharge');
            if (comboitem != undefined && comboitem != null) {
                cPaymenttype.RemoveItem(comboitem.index);
            }
            cPaymenttype.AddItem("Ledger for Interstate Stk-Out", "LedgOut");
            cPaymenttype.AddItem("Ledger for Interstate Stk-In", "LedgIn");
            cPaymenttype.AddItem("Finance Processing Fee", "PrcFee");
            cPaymenttype.AddItem("Finance Other Charges Emi", "EmiCharge");
        }



        function BankCashType(obj) {
            var actype = ASPxComboBox1.GetText();
            var asettype = '';




            if (actype == 'Asset') {
                if (obj == '0') {
                    //$(function () {

                    <%-- asettype = '<%=Session["AssetType"]%>';--%>
                    //asettype = document.getElementById('hdneditassettype').value;
                    //if(asettype=='')
                    //{
                    //    asettype = obj;
                    //}
                    //});
                    //document.getElementById('hdneditassettype').value = '';
                   <%-- '<%Session["AssetType"] = null; %>';--%>
                    document.getElementById("tdBankAccountType").style.display = 'none';
                    document.getElementById("tdBankAccountType").style.display = 'none';
                    document.getElementById("tdBankAccountType1").style.display = 'none';
                    document.getElementById("tdBankAccountType1").style.display = 'none';
                    document.getElementById("tdBankAccountNo").style.display = 'block';
                    document.getElementById("clsPaymentType").style.display = 'block';
                    document.getElementById("tdSubledgertype").style.display = 'none';
                    ItemsBank();
                    if (asettype == '0') {
                        document.getElementById("tdtdsapprate").style.display = 'none';
                        document.getElementById("tdtdsapprate1").style.display = 'none';
                        $('#tdfbtapprate').closest('div.col-md-6').css({ 'display': 'none' });
                        document.getElementById("tdfbtapprate").style.display = 'none';
                        document.getElementById("tdfbtapprate1").style.display = 'none';
                        document.getElementById("tdroi").style.display = 'none';
                        document.getElementById("tdroi1").style.display = 'none';
                        document.getElementById("tddepretion").style.display = 'none';
                    }
                    else if (asettype == '1') {
                        document.getElementById("tdtdsapprate").style.display = 'none';
                        document.getElementById("tdtdsapprate1").style.display = 'none';
                        $('#tdfbtapprate').closest('div.col-md-6').css({ 'display': 'none' });
                        document.getElementById("tdfbtapprate").style.display = 'none';
                        document.getElementById("tdfbtapprate1").style.display = 'none';
                        document.getElementById("tdroi").style.display = 'none';
                        document.getElementById("tdroi1").style.display = 'none';
                        document.getElementById("tddepretion").style.display = 'none';
                        document.getElementById("tdBankAccountNo").style.display = 'none';
                        // document.getElementById("clsPaymentType").style.display = 'none';//Priti
                        // ItemaOther();
                    }
                    else if (asettype == '2') {

                        document.getElementById("tddepretion").style.display = 'inline';
                        document.getElementById("tdSubledgertype").style.display = 'block';
                        // ItemaOther();
                    }
                    else if (asettype == '3') {
                        document.getElementById("tdtdsapprate").style.display = 'block';
                        document.getElementById("tdtdsapprate1").style.display = 'block';
                        $('#tdfbtapprate').closest('div.col-md-6').css({ 'display': 'block' });
                        document.getElementById("tdfbtapprate").style.display = 'block';
                        document.getElementById("tdfbtapprate1").style.display = 'block';
                        document.getElementById("tdroi").style.display = 'block';
                        document.getElementById("tdroi1").style.display = 'block';
                        document.getElementById("tddepretion").style.display = 'block';
                    }
                    document.getElementById("trCompanyName").style.display = 'block';
                    // ItemaOther();
                    //GetObjectID('hdnAssetType').value = '';
                }
                else {
                    ItemaOther();
                    if (obj == '1') {
                        document.getElementById("tdBankAccountType").style.display = 'none';
                        document.getElementById("tdBankAccountType1").style.display = 'none';
                        document.getElementById("tdBankAccountNo").style.display = 'none';
                        // document.getElementById("clsPaymentType").style.display = 'none';//Priti
                        //document.getElementById("tdBankAccountNo1").style.display = 'none';
                        document.getElementById("tdSubledgertype").style.display = 'none';
                        //document.getElementById("tdSubledgertype1").style.display = 'none';
                        //Added Later
                        document.getElementById("tdtdsapprate").style.display = 'none';
                        document.getElementById("tdtdsapprate1").style.display = 'none';
                        $('#tdfbtapprate').closest('div.col-md-6').css({ 'display': 'none' });
                        document.getElementById("tdfbtapprate").style.display = 'none';
                        document.getElementById("tdfbtapprate1").style.display = 'none';
                        document.getElementById("tdroi").style.display = 'none';
                        document.getElementById("tdroi1").style.display = 'none';

                        //document.getElementById("tdExchangeSeg").style.display = 'none';
                        //document.getElementById("tdExchangeSeg1").style.display = 'none';
                        document.getElementById("tddepretion").style.display = 'none';
                        document.getElementById("trCompanyName").style.display = 'block';
                        //ItemaOther();
                    }
                    else if (obj == '2') {

                        $('#tddepretion').removeClass('hide');
                        document.getElementById("tdBankAccountType").style.display = 'table-cell';// modified by atish for showing depreciation
                        document.getElementById("tdBankAccountType1").style.display = 'table-cell';// modified by atish for showing depreciation
                        document.getElementById("tdBankAccountNo").style.display = 'none';
                        // document.getElementById("clsPaymentType").style.display = 'none';//Priti

                        document.getElementById("tdSubledgertype").style.display = 'none';// modified by atish for not showing subledger type
                        document.getElementById("tdtdsapprate").style.display = 'none';
                        document.getElementById("tdtdsapprate1").style.display = 'none';
                        $('#tdfbtapprate').closest('div.col-md-6').css({ 'display': 'none' });
                        document.getElementById("tdfbtapprate").style.display = 'none';
                        document.getElementById("tdfbtapprate1").style.display = 'none';
                        document.getElementById("tdroi").style.display = 'none';
                        document.getElementById("tdroi1").style.display = 'none';
                        document.getElementById("tddepretion").style.display = 'inline';
                        document.getElementById("trCompanyName").style.display = 'block';
                        document.getElementById("tdSubledgertype").style.display = 'block';
                        //ItemaOther();
                    }
                    else {
                        document.getElementById("tdBankAccountType").style.display = 'none';
                        document.getElementById("tdBankAccountType1").style.display = 'none';
                        document.getElementById("tdBankAccountNo").style.display = 'none';
                        //  document.getElementById("clsPaymentType").style.display = 'none';//Priti
                        //document.getElementById("tdBankAccountNo1").style.display = 'none';
                        document.getElementById("tdSubledgertype").style.display = 'inline';
                        //document.getElementById("tdSubledgertype1").style.display = 'block';
                        //Added Later
                        document.getElementById("tdtdsapprate").style.display = 'inline';
                        document.getElementById("tdtdsapprate1").style.display = 'inline';
                        $('#tdfbtapprate').closest('div.col-md-6').css({ 'display': 'none' });
                        document.getElementById("tdfbtapprate").style.display = 'inline';
                        document.getElementById("tdfbtapprate1").style.display = 'inline';
                        document.getElementById("tdroi").style.display = 'inline';
                        document.getElementById("tdroi1").style.display = 'inline';
                        //document.getElementById("tdExchangeSeg").style.display = 'none';
                        //document.getElementById("tdExchangeSeg1").style.display = 'none';
                        document.getElementById("tddepretion").style.display = 'none';
                        document.getElementById("trCompanyName").style.display = 'block';
                        // ItemaOther();
                    }

                }
            }

        }

        function BankAccountType(obj) {
            if (obj == '2') {

                document.getElementById("tdExchangeSeg").style.display = 'none';
                document.getElementById("tdExchangeSeg1").style.display = 'none';

            }
            else if (obj == 'A') {
                document.getElementById("tdExchangeSeg").style.display = 'none';
                document.getElementById("tdExchangeSeg1").style.display = 'none';
            }
            else {

                document.getElementById("tdExchangeSeg").style.display = 'block';


                document.getElementById("tdExchangeSeg1").style.display = 'block';

            }
        }

        //function ExchangeSegment(obj) {

        //    if (obj == 'A') {
        //        document.getElementById("trExchange").style.display = 'none';
        //        document.getElementById("trExchange1").style.display = 'none';
        //    }
        //    else if (obj == 'S') {
        //        document.getElementById("trExchange").style.display = 'block';


        //        document.getElementById("trExchange1").style.display = 'block';

        //        comboSegment.PerformCallback();

        //    }
        //    else {

        //        document.getElementById("trExchange").style.display = 'block';


        //        document.getElementById("trExchange1").style.display = 'block';

        //        comboSegment.SetValue(obj);
        //        document.getElementById('hdSegment').value = obj
        //    }
        //}

        function TDSApplicableFun(obj) {
            if (obj == 1) {
                document.getElementById("tdsrate").style.display = 'block';

                //document.getElementById("tdsrate1").style.display = 'inline'; 
            }
            else {
                document.getElementById("tdsrate").style.display = 'none';
                //document.getElementById("tdsrate1").style.display = 'none'; 
            }
        }

        function FBTApplicableFun(obj) {
            if (obj == 1) {
                document.getElementById("fbtrate").style.display = 'block';
                document.getElementById("fbtrate1").style.display = 'block';

            }
            else {
                document.getElementById("fbtrate").style.display = 'none';
                document.getElementById("fbtrate1").style.display = 'none';
            }
        }

        //function SubLedgerTypeFun(obj) {
        //    if (obj == '11') {
        //        document.getElementById("addCustomLedger").style.display = 'inline';
        //    }
        //    else {
        //        document.getElementById("addCustomLedger").style.display = 'none';
        //    }
        //}
        function aaa(obj) {
            document.getElementById("Subledger").style.display = 'inline';
            document.getElementById("main").style.display = 'none';
        }
        function ShowHideFilter(obj) {
            var chk = document.getElementById("chkSysAccount");
            if (chk.checked == true)
                grid.PerformCallback(obj + '~T');
            else
                grid.PerformCallback(obj + '~F');
        }

        function Show(Keyvalue) {

            var url = "frm_OpeningBalance.aspx?id=" + Keyvalue + "";
            window.location.href = url;
            //popup.SetContentUrl(url);
            //popup.Show();
        }
        function showhistory(obj) {
            //var URL = 'Account_Document.aspx?idbldng=' + obj;

            //editwin = dhtmlmodal.open("Editbox", "iframe", URL, "Document", "width=1000px,height=400px,center=0,resize=1,top=-1", "recal");
            //editwin.onclose = function () {
            //    grid.PerformCallback();
            //}

            //var url = 'Contact_Document.aspx?idbldng=' + obj;
            //popup.SetContentUrl(url);
            //popup.Show();
            // .............................Code Commented and Added by Sam on 02122016. to use page instead of popup ..................................... 

            //var URL = "Account_Document.aspx?idbldng=" + obj + ""; 
            //popupdoc.SetContentUrl(URL); 
            //popupdoc.Show();
            //popupdoc.SetHeaderText('Add Document');

            var URL = "Contact_Document.aspx?idbldng=" + obj + "";
            window.location.href = URL;

            // .............................Code Above Commented and Added by Sam on 29112016...................................... 
        }
        function ShowAssetDetail(KeyVal, Val) {


            // .............................Code Commented and Added by Sam on 02122016. to use page instead of popup due to generate iframe ..................................... 
            var url = "AssetDetail.aspx?id=" + Val + "";
            window.location.href = url;
            //popup.SetContentUrl(url);
            //popup.Show();
            //popup.SetHeaderText('Asset Details');

            // .............................Code Above Commented and Added by Sam on 02122016...................................... 

            //............................. Previous old Comment ......................
            //var url = "AssetDetail.aspx?id=" + Val + "";
            //OnMoreInfoClick(url, "Asset Details", '990px', '510px', "Y"); 
            //        editwin=dhtmlmodal.open("Editbox", "iframe", url,"Add/Modify AssetDetail" , "width=900px,height=500px,center=1,resize=1,scrolling=2,top=500", "recal")
            //        document.getElementById('ctl00_ContentPlaceHolder1_Headermain1_cmbSegment').style.visibility='hidden';
            //        editwin.onclose=function()
            //         {
            //         document.getElementById('ctl00_ContentPlaceHolder1_Headermain1_cmbSegment').style.visibility='visible';
            //         }
            //         return false;
            //.............................Above Previous old Comment ......................
        }
        function Validations(obj) {
            if (obj == "SubLedger Type Can Only Custom or None") {
                var k = $('#valid');
                //$('#valid').css({ 'display': 'block' });
                $('#valid').removeClass('hide');

                return false;
            }
            else if (obj == "Mandatory Account name") {
                //var k1 = $('#valid');
                $('#valid').removeClass('hide');
                $('.dxgvEditingErrorRow_PlasticBlue').attr('style', 'background-color:#EDF3F4 !important');
                $('#txtAccountCode').focus();
                //$('#valid').css({ 'display': 'block' });
                return;
            }
            else if (obj == "Mandatory Account Code") {
                $('#validaccode').removeClass('hide');
                $('.dxgvEditingErrorRow_PlasticBlue').attr('style', 'background-color:#EDF3F4 !important');
                //$('#txtAccountCode').focus();

            }
            else if (obj == "This AccountCode Already Exists") {
                $('#validaccode').removeClass('hide');
                $('.dxgvEditingErrorRow_PlasticBlue').attr('style', 'background-color:#EDF3F4 !important');
                //$('#txtAccountCode').focus();

            }
            else if (obj == "Bank Account Number Already Exists.") {
                $('#validbankaccno').removeClass('hide');
                $('.dxgvEditingErrorRow_PlasticBlue').attr('style', 'background-color:#EDF3F4 !important');
            }
            else if (obj == "Sub Ledger Type Can Not Be Blank") {
                $('#validsubledgtyp').removeClass('hide');
                $('.dxgvEditingErrorRow_PlasticBlue').attr('style', 'background-color:#EDF3F4 !important');
            }
            else if (obj == "SubLedger Type Can Only Custom or None") {
                $('#validsubledgtyp').removeClass('hide');
                $('.dxgvEditingErrorRow_PlasticBlue').attr('style', 'background-color:#EDF3F4 !important');
            }
        }
        function ShowError(obj) {
            if (!Validations(obj)) {
                return false;
            }


            if (obj != "a" && obj != "b") {
                var objVal = obj.split('~')
                AccopuntType(objVal[0]);
                BankCashType(objVal[1]);
                BankAccountType(objVal[2]);
                var code = objVal[3].toUpperCase();
                if (code == 'SYSTM') {
                    // txtAccountNo.SetEnabled(false);
                    txtAccountCode.SetEnabled(false);
                    ASPxComboBox1.SetEnabled(false);
                    ASPxComboBox2.SetEnabled(false);
                    txtBankAccountNo.SetEnabled(false);
                    ASPxComboBox3.SetEnabled(false);
                    CmbSubLedgerType.SetEnabled(false);
                    rbSegment.SetEnabled(false);
                    //txtRateofIntrest.SetEnabled(false);

                    FBTApplicable.SetEnabled(false);
                    txtFBTRate.SetEnabled(false);
                    TDSApplicable.SetEnabled(false);
                    txtTDSRate.SetEnabled(false);
                }
                txtAccountCode.SetEnabled(false);
                if (objVal[4] != "" && objVal[4] != "0") {
                    rbSegment.SetValue('S');
                    ExchangeSegment(objVal[4]);
                }
            }

        }
        function updateEditorText() {
            var code = txtAccountCode.GetText().toUpperCase();
            if (code == 'SYSTM') {
                alert('You Can not Enter This Code,This is Reserve Code ');
                txtAccountCode.SetText('');
            }
        }
        //function GridDelete(obj1, obj2,obj3,obj4) {
        //   if (obj4=='Delete')
        //   {
        //        if (confirm("Are You Sure You Want To Delete ?")) {
        //        var obj5 = obj1 + '~' + obj2+ '~' +obj3+ '~' +obj4;
        //        combo.PerformCallback(obj5);

        //    }
        //    else {
        //        return false;
        //    }

        //   }
        //    else if(obj4=='Edit')
        //    {
        //         var obj5 = obj1 + '~' + obj2+ '~' +obj3+ '~' +obj4;
        //        combo.PerformCallback(obj5);
        //    }

        //}
        function GridDelete(obj1, obj2) {
            if (confirm("Confirm delete ?")) {
                var obj3 = obj1 + '~' + obj2;
                combo.PerformCallback(obj3);

            }
            else {
                return false;
            }

        }
        function ShowError1(obj) {
            if (obj == "b") {
                alert('Transaction Exists for this Code. Deletion Not Allowed !!');
                return false;
            }
            else {
                var chk = document.getElementById("chkSysAccount");
                if (chk.checked == true)
                    grid.PerformCallback('T');
                else
                    grid.PerformCallback('F');
            }
        }
        //function CompanyExchange(obj) {
        //  comboSegment.PerformCallback();
        //}
        function SegmentID1(obj) {

            document.getElementById("hdSegment").value = obj;
        }
        function CallTdsAccount(objid, objfunc, objevant) {
            FieldName = 'Label1';
            // alert(objid);
            ajax_showOptions(objid, objfunc, objevant);
        }
        function checkChange(obj) {
            if (obj == true)
                grid.PerformCallback('T');
            else
                grid.PerformCallback('F');
        }
        function SetSegValue(segval) {

            document.getElementById("hdSegment").value = segval;

        }
        function lost() {
            alert('lost focus');
        }

        function OnGridEndCallback(s, e) {
            if (grid.cpValidating != null) {

                jAlert(grid.cpValidating);

            }
            if (grid.cpUDF != null) {
                jAlert("UDF is set as Mandatory. Please enter values.", "Alert", function () { OpenUdf(); });

                grid.cpUDF = null;
            }
            if (grid.cpUDFKey != null) {
                document.getElementById("Keyval_internalId").value = grid.cpUDFKey;
                grid.cpUDFKey == null
            }
            //debugger;
            if (grid.cpDelete != null) {
                if (grid.cpDelete == 's') {
                    jAlert('Deleted successfully');
                    grid.cpDelete = null;
                }
                else if (grid.cpDelete == 'f') {
                    jAlert('Used in other module.Cannot delete.')
                    grid.cpDelete = null;
                }
                else if (grid.cpDelete == 'syscode') {
                    jAlert('System generated code. Cannot Delete.')
                    grid.cpDelete = null;
                }
            }
            else if (grid.cpValidating != null) {
                //alert(grid.cpValidating);
                if (grid.cpValidating == 'Bank Account Number already exists.') {
                    txtBankAccountNo.Focus();
                    txtBankAccountNo.SetText();
                }

                //jAlert(grid.cpValidating);
                grid.cpValidating = null;
            }
            else if (grid.cpUpdate != null) {
                jAlert(grid.cpUpdate);
                grid.cpUpdate = null;
            }
            else if (grid.cpinsert != null) {
                jAlert(grid.cpinsert);
                grid.cpinsert = null;
            }
            //MainAccountGrid.JSProperties["cpUpdate"] = "Saved successfully";

        }

    </script>


    <script type="text/javascript">
        $(document).ready(function () {
            $('#chkSysAccount + label').addClass('emph');
            $('#chkSysAccount').click(function () {
                if ($('#chkSysAccount').prop('checked')) {
                    $('#chkSysAccount + label').addClass('emph');

                } else {
                    $('#chkSysAccount + label').removeClass('emph');

                }
            });
            //$("#chkSysAccount").bootstrapSwitch();
        });


        function UniqueCodeCheck() {
            var strAccountCode = txtAccountCode.GetText()
            if (strAccountCode != null && strAccountCode != '') {
                if (strAccountCode.toLowerCase().indexOf("systm") > 0) {
                    txtAccountCode.Focus();
                    txtAccountCode.SetText();
                    alert('SYSTM can not use in unique short name');

                }
                else {
                    var Accountid = '0';
                    var id = '<%= Convert.ToString(Session["id"]) %>';
                    //var strAccountCode = grid.GetEditor('AccountCode').GetValue();

                    if ((id != null) && (id != '')) {
                        Accountid = id;
                        '<%=Session["id"]=null %>'
                    }
                    var CheckUniqueCode = false;
                    $.ajax({
                        type: "POST",
                        url: "MainAccountHead.Aspx/CheckUniqueCode",
                        data: JSON.stringify({ strAccountCode: strAccountCode, Accountid: Accountid }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg) {
                            CheckUniqueCode = msg.d;
                            if (CheckUniqueCode == true) {
                                txtAccountCode.Focus();
                                txtAccountCode.SetText();
                                alert('Please enter unique short name');
                                //jAlert('Please enter unique short name');

                            }
                        }
                    });
                }
            }
        }
        function AddButtonClick() {
            grid.AddNewRow();
            document.getElementById("Keyval_internalId").value = "Add";
        }
    </script>

     <script>
         function OpenMappingLedgerPopup(s, e) {
             var keyValue = grid.GetRowKey(e.visibleIndex);
             $("#hfLedgerID").val(keyValue);
             GetMappedHSNSCA(keyValue);
             cMappingLedgerPopup.Show();
         }

         function CloseMappingPopup() {
             cMappingLedgerPopup.Hide();
         }

         function GetMappedHSNSCA(keyValue) {
             $.ajax({
                 type: "POST",
                 url: "MainAccountHead.aspx/GetMappedHSNSCAData",
                 data: JSON.stringify({ LedgerID: $("#hfLedgerID").val() }),
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (msg) {
                     debugger;
                     data = msg.d;
                     if (data.length > 0) {
                         if (data[1] == "HSN") {
                             cHsnLookUp.SetText(data[3]);
                             cHsnLookUp.SetValue(data[3]);
                         }
                         else if (data[1] == "SAC") {
                             cScaLookUp.SetText(data[3]);
                             cScaLookUp.SetValue(data[3]);
                         }
                         cchbFurtherenceOfBusiness.SetValue(data[2]);
                         if (data[4] != null && data[4]!='')
                         {
                             var gstin = data[4]; 
                             if (gstin.length > 0) {
                                 ctxtGSTIN111.SetText(gstin.substring(0, 2));
                                 ctxtGSTIN222.SetText(gstin.substring(2, 12));
                                 ctxtGSTIN333.SetText(gstin.substring(12, 15));
                             }
                         }
                         else
                         {
                             ctxtGSTIN111.SetText('');
                             ctxtGSTIN222.SetText('');
                             ctxtGSTIN333.SetText('');
                         }
                     }
                     else {
                         cScaLookUp.SetValue('');
                         cScaLookUp.SetText('');
                         cHsnLookUp.SetValue('');
                         cHsnLookUp.SetText('');
                         cchbFurtherenceOfBusiness.SetValue(false);
                         ctxtGSTIN111.SetText('');
                         ctxtGSTIN222.SetText('');
                         ctxtGSTIN333.SetText('');
                     }

                     
                     
                 
                 }
             });
         }

         function HsnLookUp_SelectedChange(e) {
             var hsnkey = cHsnLookUp.GetGridView().GetRowKey(cHsnLookUp.GetGridView().GetFocusedRowIndex());
             $('#hfHSNSCAkey').val(hsnkey);
             $('#hfHSNSCAType').val('HSN');
             if (hsnkey != null && hsnkey != '') {
                 cScaLookUp.SetValue('');
                 cScaLookUp.SetText('');
             }
         }

         function ScaLookUp_SelectedChange(e) {
             var scakey = cScaLookUp.GetGridView().GetRowKey(cScaLookUp.GetGridView().GetFocusedRowIndex());
             $('#hfHSNSCAkey').val(scakey);
             $('#hfHSNSCAType').val('SAC');
             if (scakey != null && scakey != '') {
                 cHsnLookUp.SetValue('');
                 cHsnLookUp.SetText('');
             }
         }

         function MappingLedgerSaveClick() {
             var flag = true;
             $('#invalidGst').css({ 'display': 'none' });
             var gst1 = ctxtGSTIN111.GetText().trim();
             var gst2 = ctxtGSTIN222.GetText().trim();
             var gst3 = ctxtGSTIN333.GetText().trim();

             if (gst1.length == 0 && gst2.length == 0 && gst3.length == 0) {
                <%-- var isregistered = $('#<%=radioregistercheck.ClientID %> input:checked').val();
                if (isregistered == 1) {
                    jAlert('GSTIN is mandatory.');
                    retValue = false;--%>
                //}
                 flag = true;
            }
            else {
                if (gst1.length != 2 || gst2.length != 10 || gst3.length != 3) {
                    $('#invalidGst').css({ 'display': 'block' });
                    flag = false;
                } 
                var panPat = /^([a-zA-Z]{5})(\d{4})([a-zA-Z]{1})$/;
                var code = /([C,P,H,F,A,T,B,L,J,G])/;
                var code_chk = gst2.substring(3, 4);
                if (gst2.search(panPat) == -1) {
                    $('#invalidGst').css({ 'display': 'block' });
                    flag = false;
                }
                if (code.test(code_chk) == false) {
                    $('#invalidGst').css({ 'display': 'block' });
                    flag = false;
                }

             }
             if ($('#hfHSNSCAkey').val() == '' && cchbFurtherenceOfBusiness.GetChecked() == false && gst1 == '')
             {
                 jAlert('Values not entered. Can not saved.')
                 return;
                 flag == false;
             }
             if (flag == true) {
                 var GSTIN=gst1+gst2+gst3;
                 $.ajax({
                     type: "POST",
                     url: "MainAccountHead.aspx/MapLedgerToHSNSCA",
                     //data: JSON.stringify({ LedgerID: $("#hfLedgerID").val() }),
                     data: JSON.stringify({ LedgerID: $("#hfLedgerID").val(), HSNSCACode: $('#hfHSNSCAkey').val(), HSNSCAType: $('#hfHSNSCAType').val(), FOBFlag: cchbFurtherenceOfBusiness.GetChecked(), GSTIN: GSTIN }),
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     success: function (msg) {
                         CheckFlag = msg.d;
                         if (CheckFlag == true) {
                             CloseMappingPopup();
                             jAlert("HSN/SAC/GSTIN Successfully Mapped With Ledger", "Alert");
                             //jAlert('Please enter unique short name');
                         }
                     }
                 });
             }
         }
    </script>

    <style>
        #MainAccountGrid_DXPEForm_DXEditingErrorRow {
            display: none;
        }

        #MainAccountGrid_DXPEForm_efnew_ASPxComboBox1_EC {
            position: absolute;
        }

        #mylay {
            background: red;
            width: 500px;
            height: 500px;
        }

        .hide {
            display: none;
        }

        #chkSysAccount + label.emph {
            font-weight: 600 !important;
        }

        #trAccountGroup .dxeErrorCellSys {
            position: absolute;
        }

        #MainAccountGrid_DXPEForm_efnew_txtRateofIntrest_EC, #MainAccountGrid_DXPEForm_efnew_txtDepreciation_EC,
        #tdroi .dxeErrorCellSys, #tddepretion .dxeErrorCellSys {
            display: none;
        }

        #cmb_tdstcs .dxeListBoxItem {
            height: 50px;
        }

        .dxgvSelectedRow_PlasticBlue td.dxgvCommandColumn_PlasticBlue a, .dxgvFocusedRow_PlasticBlue td.dxgvCommandColumn_PlasticBlue a, .dxgvPreviewRow_PlasticBlue td.dxgvCommandColumn_PlasticBlue a {
            color: #5A83D0 !important;
        }

        a.dxbButton_PlasticBlue {
            text-decoration: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="mylay" class="hide"></div>
    <div class="panel-heading">
        <div class="panel-title">
            <%--<h3>&nbsp;&nbsp;Main Account Details</h3>--%>
            <h3>Account Head</h3>
        </div>
    </div>
    <div class="form_main">

        <table class="TableMain100">
            <%--   <tr>
                <td class="EHEADER" style="text-align: center;">
                    <strong><span style="color: #000099;">Main Account Details</span></strong>
                </td>
            </tr>--%>
            <tr>
                <td>
                    <table width="100%">
                        <tr>
                            <td style="text-align: left; vertical-align: top">
                                <table>
                                    <tr>
                                        <td id="ShowFilter">
                                            <% if (rights.CanAdd)
                                               { %>
                                            <a href="javascript:void(0);" id="btnAddNew" runat="server" onclick="AddButtonClick()" class="btn btn-primary"><span>Add New</span></a><%} %>
                                            <%--   <a href="javascript:ShowHideFilter('s');" class="btn btn-success"><span >
                                                Show Filter</span></a>--%>
                                            <% if (rights.CanExport)
                                               { %>
                                            <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnChange="if(!AvailableExportOption()){return false;}"
                                                OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true" ClientIDMode="Static">
                                                <asp:ListItem Value="0">Export to</asp:ListItem>
                                                <asp:ListItem Value="1">PDF</asp:ListItem>
                                                <asp:ListItem Value="2">XLS</asp:ListItem>
                                                <asp:ListItem Value="3">RTF</asp:ListItem>
                                                <asp:ListItem Value="4">CSV</asp:ListItem>
                                            </asp:DropDownList>
                                            <% } %>
                                            <div id="Td1" style="display: none">
                                                <a href="javascript:ShowHideFilter('All');" class="btn btn-primary"><span>All Records</span></a>
                                            </div>
                                            <asp:CheckBox ID="chkSysAccount" runat="server" Checked="True" Text="Hide System Accounts" Font-Bold="True" ForeColor="Blue" /><span>
                                            </span>
                                        </td>

                                    </tr>
                                </table>
                            </td>
                            <td></td>
                            <%--<td class="gridcellright pull-right">
                                <dxe:ASPxComboBox ID="cmbExport" runat="server" AutoPostBack="true"
                                    Font-Bold="False" ForeColor="black" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged"
                                    ValueType="System.Int32" Width="130px">
                                    <items>
                                        <dxe:ListEditItem Text="Select" Value="0" />
                                        <dxe:ListEditItem Text="PDF" Value="1" />
                                        <dxe:ListEditItem Text="XLS" Value="2" />
                                        <dxe:ListEditItem Text="RTF" Value="3" />
                                        <dxe:ListEditItem Text="CSV" Value="4" />
                                    </items>
                                    <buttonstyle>
                                    </buttonstyle>
                                    <itemstyle>
                                        <HoverStyle>
                                        </HoverStyle>
                                    </itemstyle>
                                    <border bordercolor="black" />
                                    <dropdownbutton text="Export">
                                    </dropdownbutton>
                                </dxe:ASPxComboBox>
                            </td>--%>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <%--   <dxe:ASPxCallbackPanel ID="ASPxCallbackPanel1" ClientInstanceName="panel" runat="server" Width="411px">
                        <PanelCollection>
                            <dxe:PanelContent runat="server" SupportsDisabledAttribute="True">&nbsp;<br /> &nbsp;<br /> &nbsp;<br /> &nbsp;<br /> &nbsp;<br />
    <br />>

                            </dxe:PanelContent>

                        </PanelCollection>
                    </dxe:ASPxCallbackPanel>--%>
                    <dxe:ASPxGridView ID="MainAccountGrid" runat="server" AutoGenerateColumns="False" Images-ContextMenuShowFooter-AlternateText=""
                        KeyFieldName="MainAccount_ReferenceID" ClientInstanceName="grid" DataSourceID="MainAccount" OnInitNewRow="MainAccountGrid_InitNewRow"
                        Width="100%" OnRowUpdating="MainAccountGrid_OnRowUpdating" OnCustomCallback="MainAccountGrid_CustomCallback"
                        OnRowValidating="MainAccountGrid_OnRowValidating" OnHtmlDataCellPrepared="MainAccountGrid_OnHtmlDataCellPrepared"
                        OnRowInserting="MainAccountGrid_OnRowInserting" OnHtmlEditFormCreated="MainAccountGrid_HtmlEditFormCreated"
                        OnStartRowEditing="MainAccountGrid_StartRowEditing" OnHtmlRowCreated="MainAccountGrid_HtmlRowCreated"
                        OnCustomJSProperties="MainAccountGrid_CustomJSProperties" OnRowCommand="MainAccountGrid_RowCommand"
                        OnCommandButtonInitialize="MainAccountGrid_CommandButtonInitialize"
                        OnRowDeleting="MainAccountGrid_RowDeleting">
                        <%-- <Settings ShowHorizontalScrollBar="true" />
                        <SettingsPager NumericButtonCount="20" PageSize="10" ShowSeparators="True">
                        </SettingsPager>--%>
                        


                        <clientsideevents endcallback="function(s,e) { OnGridEndCallback(s,e);}" custombuttonclick="function(s,e) {OpenMappingLedgerPopup(s,e);}" />



                        <settings showgroupedcolumns="True" showgrouppanel="True" />
                        <settingsbehavior columnresizemode="NextColumn" confirmdelete="true" />
                        <settingstext popupeditformcaption="Add Main Account" confirmdelete="Confirm delete?" />
                        <settingssearchpanel visible="True" />
                        <settings showgrouppanel="True" showstatusbar="Visible" showfilterrow="true" showfilterrowmenu="True" />

                        <styles>
                            <Header ImageSpacing="5px" SortingImageSpacing="5px">
                            </Header>

                            <FocusedGroupRow CssClass="gridselectrow"></FocusedGroupRow>

                            <FocusedRow CssClass="gridselectrow"></FocusedRow>

                            <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                        </styles>

                        <templates>
                            <EditForm>
                                <div id="main">
                                    <div style="padding: 10px;"></div>

                                    <%--Account Name and Account Code or Short Name--%>
                                    <div class="col-md-12 clearfix" id="trAccountName">
                                        <div class="col-md-6" style="margin-bottom: 5px">
                                            <label>Account Name :<span style="color: Red;">*</span></label>
                                            <dxe:ASPxTextBox ID="txtAccountNo" ClientInstanceName="txtAccountNo" runat="server"
                                                Text='<%#Bind("AccountName") %>' Width="100%" MaxLength="50" ValidationSettings-ValidationGroup="<%# Container.ValidationGroup %>">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right">
                                                    <RequiredField IsRequired="true" ErrorText="Mandatory" />
                                                </ValidationSettings>
                                            </dxe:ASPxTextBox>

                                            <%--<div id="valid" style="position: absolute; right: -4px; top: 30px;" class="hide">
                                                <img id="grid_DXPEForm_DXEFL_DXEditor2_EI" title="Mandatory" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-YRohc" alt="Required" />
                                            </div>--%>
                                        </div>



                                        <div class="col-md-6" style="margin-bottom: 5px">
                                            <label>Short Name:<span style="color: Red;">*</span></label>
                                            <dxe:ASPxTextBox ID="txtAccountCode" ClientInstanceName="txtAccountCode" runat="server"
                                                Text='<%#Bind("AccountCode") %>' Width="100%" MaxLength="50" CssClass="gridcellleft" ValidationSettings-ValidationGroup="<%# Container.ValidationGroup %>">
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right">
                                                    <RequiredField IsRequired="true" ErrorText="Mandatory" />
                                                </ValidationSettings>

                                                <ClientSideEvents TextChanged="function(s, e) {UniqueCodeCheck();}" />
                                                <ClientSideEvents KeyPress="function(s,e){window.setTimeout('updateEditorText()', 10);}" />
                                                <ClientSideEvents Init="OntxtAccountCodeInit" />
                                            </dxe:ASPxTextBox>
                                            <%--<div id="validaccode" style="position: absolute; right: -4px; top: 30px;" class="hide">
                                                <img id="grid_DXPEForm_DXEFL_DXEditor2_EI" title="Mandatory" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-YRohc" alt="Required" />
                                            </div>--%>
                                        </div>
                                    </div>


                                    <div class="col-md-12 clearfix" id="trAccountGroup">
                                        <div class="col-md-6">
                                            <label>Account Type :<span style="color: Red;">*</span></label>
                                            <dxe:ASPxComboBox ID="ASPxComboBox1" ClientInstanceName="ASPxComboBox1" runat="server"
                                                ValueType="System.String" Value='<%#Bind("AccountType") %>' Width="90%" EnableIncrementalFiltering="true"
                                                ValidationSettings-ValidationGroup='<%# Container.ValidationGroup %>' ValidationSettings-RequiredField-ErrorText="Mandatory">
                                                <Items>

                                                    <dxe:ListEditItem Text="Asset" Value="Asset" Selected="true"></dxe:ListEditItem>
                                                    <dxe:ListEditItem Text="Liability" Value="Liability"></dxe:ListEditItem>
                                                    <dxe:ListEditItem Text="Income" Value="Income"></dxe:ListEditItem>
                                                    <%-- <dxe:ListEditItem Text="Expenses" Value="Expences"></dxe:ListEditItem>--%>
                                                    <dxe:ListEditItem Text="Expense" Value="Expense"></dxe:ListEditItem>
                                                </Items>
                                                <ValidationSettings ErrorImage-ToolTip="Mandatory">
                                                    <RequiredField IsRequired="true" />
                                                </ValidationSettings>
                                                <%--<ValidationSettings CausesValidation="True" SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right">
                                                                                        <RequiredField IsRequired="True" ErrorText="Select category"  />
                                                                                    </ValidationSettings>--%>
                                                <ClientSideEvents ValueChanged="function(s,e){
                                                                                          var indexr = s.GetSelectedIndex();
                                                                                          AccopuntType(indexr)
                                                                                         }" />
                                                <ClientSideEvents Init="function(s,e){
                                                                                           var indexr = s.GetSelectedIndex();
                                                                                           AccopuntType(indexr);
                                                      }" />
                                            </dxe:ASPxComboBox>
                                        </div>
                                        <div class="col-md-6">
                                            <label>Account Group :</label>
                                            <dxe:ASPxComboBox ID="combAccountGroup" ClientInstanceName="combAccountGroup" runat="server" OnCallback="combAccountGroup_Callback"
                                                ValueType="System.String" EnableIncrementalFiltering="true" Width="90%" DataSourceID="AllAccountGroup"
                                                TextField="AccountGroup" ValueField="ID" Value='<%#Bind("AccountGroup") %>'>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div style="clear: both"></div>
                                    <div class="col-md-12 clearfix" id="trBankCashType">
                                        <div class="col-md-6">
                                            <label>
                                                Asset Type :
                                                <span style="color: Red;">*</span>
                                            </label>
                                            <div>
                                                <dxe:ASPxComboBox ID="ASPxComboBox2" ClientInstanceName="ASPxComboBox2" runat="server"
                                                    ValueType="System.String" Value='<%#Bind("BankCashType") %>' EnableIncrementalFiltering="true"
                                                    Width="90%" SelectedIndex="0">

                                                    <Items>
                                                        <dxe:ListEditItem Text="Bank" Value="Bank" Selected="true" />
                                                        <dxe:ListEditItem Text="Cash" Value="Cash" />
                                                        <dxe:ListEditItem Text="Fixed Asset" Value="Fixed Asset" />
                                                        <dxe:ListEditItem Text="Other" Value="Other" />
                                                    </Items>

                                                    <ClientSideEvents Init="function(s,e){
                                                                                           var indexr = s.GetSelectedIndex();
                                                                                           BankCashType(indexr);
                                                   }" />
                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                                           var indexr = s.GetSelectedIndex();
                                                                                           BankCashType(indexr);
                                                                                        
                                                   }" />
                                                    <%--Init="function(s,e){
                                                    
                                                            if(s.GetText()=='')
                                                                {
                                                    
                                                                    $('#tdBankAccountType').attr('style','display:none');
                                                                    $('#tdBankAccountType1').attr('style','display:none');
                                                                }
                                                            else
                                                                {
                                                                     $('#tdBankAccountType').attr('style','display:block');
                                                                     $('#tdBankAccountType1').attr('style','display:block');
                                                                }
                                                            }" />--%>
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-md-6" id="tdBankAccountNo">
                                            <label>Bank Account No :</label>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtBankAccountNo" ClientInstanceName="txtBankAccountNo" runat="server"
                                                    Text='<%#Bind("BankAccountNo") %>' Width="90%" MaxLength="20">
                                                </dxe:ASPxTextBox>
                                            </div>
                                            <%-- <div id="validbankaccno" style="position: absolute; right: -4px; top: 30px;" class="hide">
                                                <img id="grid_DXPEForm_DXEFL_DXEditor2_EI" title="Mandatory" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-YRohc" alt="Required" />
                                            </div>--%>
                                        </div>
                                    </div>
                                    <div class="col-md-12 clearfix" id="trCompanyName">
                                        <div class="col-md-6">
                                            <label>
                                                Company Name :<span style="color: Red;">*</span>
                                                <%-- <span style="color: Red;">*</span>--%>
                                            </label>
                                            <div>
                                                <dxe:ASPxComboBox ID="comboCompanyName" ClientInstanceName="comboCompanyName" runat="server"
                                                    ValueType="System.String" DataSourceID="SqlCompany" ValueField="cmp_internalId"
                                                    TextField="cmp_name" EnableIncrementalFiltering="true" Width="90%">
                                                    <%--<ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right"     >
                                                  <RequiredField IsRequired="true" ErrorText="Mandatory"  />
                                                  </ValidationSettings>--%>

                                                    <%--<ClientSideEvents ValueChanged="function(s,e){CompanyExchange(s.GetValue());
                                                                                          }" />--%>
                                                </dxe:ASPxComboBox>
                                                <span id="MandatoryProduct" style="display: none" class="validclass">
                                                    <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                                            </div>
                                        </div>







                                        <div class="col-md-6" id="divBranch">
                                            <label>
                                                Branch :<span style="color: Red;">*</span>
                                                <%-- <span style="color: Red;">*</span>--%>
                                            </label>
                                            <div>
                                                <dxe:ASPxComboBox ID="CmbBranch" ClientInstanceName="CmbBranch" runat="server"
                                                    ValueType="System.String" DataSourceID="branchdtl" ValueField="branch_id"
                                                    TextField="branch_description" EnableIncrementalFiltering="true"
                                                    Width="90%" AutoPostBack="false">
                                                    <ClientSideEvents SelectedIndexChanged="CmbBranchChanged" Init="CmbBranchChanged" />
                                                </dxe:ASPxComboBox>
                                                <input type="button" onclick="MultiBranchClick()" class="btn btn-small btn-primary" value="Select Specific Branch" id="MultiBranchButton"></input>
                                            </div>
                                            <%-- Value='<%#Bind("branchname") %>'--%>
                                            <%--<div id="validsubledgtyp" style="position: absolute; right: -4px; top: 30px;" class="hide">
                                                <img id="grid_DXPEForm_DXEFL_DXEditor2_EI" title="Mandatory" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-YRohc" alt="Required" />
                                            </div>--%>
                                        </div>
                                        <%--<div class="col-md-6">
                                            <div style="text-align: left;" id="td4"></div>
                                            <div style="text-align: left;" id="td5"></div>
                                        </div>--%>
                                        <div class="col-md-6" id="tdSubledgertype" style="display: none">
                                            <label>
                                                Sub-Ledger Type :
                                               <%-- <span style="color: Red;">*</span>--%>
                                            </label>
                                            <div>
                                                <dxe:ASPxComboBox ID="CmbSubLedgerType" ClientInstanceName="CmbSubLedgerType" runat="server"
                                                    ValueType="System.String" EnableIncrementalFiltering="true" Value='<%#Bind("SubLedgerType") %>'
                                                    Width="90%" AutoPostBack="false">
                                                    <Items>
                                                        <dxe:ListEditItem Text="None" Value="None"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Customers" Value="Customers "></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Employees" Value="Employees"></dxe:ListEditItem>
                                                        <%-- <dxe:ListEditItem Text="Sub Brokers" Value="Sub Brokers "></dxe:ListEditItem>--%>
                                                        <%--  <dxe:ListEditItem Text="Relationship Partners" Value="Relationship Partners"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Business Partners" Value="Business Partners"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Franchisees" Value="Franchisees"></dxe:ListEditItem>--%>
                                                        <dxe:ListEditItem Text="Vendors" Value="Vendors "></dxe:ListEditItem>
                                                        <%-- <dxe:ListEditItem Text="Data Vendors" Value="Data Vendors"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Recruitment Agents" Value="Recruitment Agents "></dxe:ListEditItem>--%>
                                                        <dxe:ListEditItem Text="Agents" Value="Agents"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Custom" Value="Custom"></dxe:ListEditItem>
                                                        <%-- <dxe:ListEditItem Text="Products-Equity" Value="Products-Equity"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Products-Commodity " Value="Products-Commodity  "></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Products-MF" Value="Products-MF"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Products-Insurance" Value="Products-Insurance "></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Products-ConsumerFinance" Value="Products-ConsumerFinance"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="RTAs" Value="RTAs "></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="MFs" Value="MFs"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="AMCs" Value="AMCs "></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Insurance Cos" Value=" Insurance Cos"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Consumer Finance Cos " Value="Consumer Finance Cos  "></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Custodians" Value="Custodians "></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="NSDL Clients" Value="NSDL Clients"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="CDSL Clients" Value="CDSL Clients"></dxe:ListEditItem>--%>
                                                        <%--<dxe:ListEditItem Text="Consultants" Value="Consultants"></dxe:ListEditItem>--%>
                                                        <dxe:ListEditItem Text="Driver/Transporter" Value="DriverTransporter"></dxe:ListEditItem>
                                                        <%--<dxe:ListEditItem Text="Share Holder" Value="Share Holder"></dxe:ListEditItem>--%>
                                                        <%-- <dxe:ListEditItem Text="Debtors" Value="Debtors"></dxe:ListEditItem>
                                                        <dxe:ListEditItem Text="Creditors" Value="Creditors"></dxe:ListEditItem>--%>
                                                        <%--<dxe:ListEditItem Text="Brokers" Value="Brokers"></dxe:ListEditItem>--%>
                                                    </Items>

                                                    <%--<ClientSideEvents ValueChanged="function(s,e){
                                                                                                                    var indexr = s.GetSelectedIndex();
                                                                                                                    SubLedgerTypeFun(indexr)
                                                                                                                    }" />--%>
                                                </dxe:ASPxComboBox>
                                            </div>
                                            <%--<div id="validsubledgtyp" style="position: absolute; right: -4px; top: 30px;" class="hide">
                                                <img id="grid_DXPEForm_DXEFL_DXEditor2_EI" title="Mandatory" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-YRohc" alt="Required" />
                                            </div>--%>
                                        </div>
                                    </div>
                                    <div class="col-md-12" id="trBaAccountType" style="display: none">
                                        <div class="col-md-6">
                                            <label id="tdBankAccountType">
                                                Depreciation :<div class="hidden">Bank Account Type :</div>
                                                <%-- <span style="color: Red;">*</span>--%>
                                            </label>
                                            <div id="tdBankAccountType1">
                                                <div class="hidden">
                                                    <dxe:ASPxComboBox ID="ASPxComboBox3" ClientInstanceName="ASPxComboBox3" runat="server"
                                                        ValueType="System.String" Value='<%#Bind("BankAccountType") %>' Width="90%"
                                                        SelectedIndex="0" EnableIncrementalFiltering="true">
                                                        <Items>
                                                            <dxe:ListEditItem Text="Clearing" Value="Clearing"></dxe:ListEditItem>
                                                            <dxe:ListEditItem Text="Client" Value="Client"></dxe:ListEditItem>
                                                            <dxe:ListEditItem Text="Own" Value="Own"></dxe:ListEditItem>
                                                        </Items>

                                                        <ClientSideEvents ValueChanged="function(s,e){
                                                                                            var indexr = s.GetSelectedIndex();
                                                                                            BankAccountType(indexr)
                                                                                          }" />
                                                    </dxe:ASPxComboBox>
                                                </div>
                                                <%-- <table>--%>
                                                <%--<tr id="trDepreciationtext">
                                                        <td>
                                                            <dxe:ASPxTextBox ID="txtDepreciation" ClientInstanceName="txtDepreciation" runat="server"
                                                                Text='<%#Bind("Depreciation") %>' Width="100%" MaskSettings-Mask="<0..9999g>.<00..99>"
                                                                ValidationSettings-ErrorDisplayMode="None" MaskSettings-IncludeLiterals="DecimalSymbol">
                                                            </dxe:ASPxTextBox>
                                                        </td>
                                                        <td>%
                                                        </td>
                                                    </tr>--%>
                                                <%-- </table>--%>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="clear: both"></div>
                                    <div class="col-md-12" id="trsubledgertype">
                                        <%--// .............................Code Commented and Added by Sam on 15122016.due to unnecessary Code because segment id is always 1 .....................................--%>
                                        <%-- <div class="col-md-6">
                                            <label style="text-align: left;" id="tdExchangeSeg">
                                                <div class="hidden">Exchange Segment :</div>
                                            </label>
                                            <div id="tdExchangeSeg1">
                                                <dxe:ASPxRadioButtonList ID="rbSegment" ClientInstanceName="rbSegment" runat="server"
                                                    SelectedIndex="0" ItemSpacing="0px" RepeatDirection="Horizontal" TextWrap="False"
                                                    Font-Size="12px" ValueField='<%#Bind("ExchengSegment")%>' ValueType="System.String">
                                                    <Items>
                                                        <dxe:ListEditItem Text="All" Value="A" />
                                                        <dxe:ListEditItem Text="Specific" Value="S" />
                                                    </Items>
                                                    <ClientSideEvents ValueChanged="function(s,e){   var indexr = s.GetValue();
                                                                                                       ExchangeSegment(indexr)
                                                                                                     }" />
                                                    <Border BorderWidth="0px" />
                                                </dxe:ASPxRadioButtonList>
                                            </div>
                                        </div>--%>
                                        <%--// .............................Code Above Commented and Added by Sam on 15122016...................................... --%>
                                        <div class="col-md-6" id="tdroi">
                                            <label style="text-align: left;">Rate Of Interest (P/a) :</label>
                                            <div style="text-align: left;" id="tdroi1">
                                                <dxe:ASPxTextBox ID="txtRateofIntrest" ClientInstanceName="txtRateofIntrest" runat="server"
                                                    Text='<%#Bind("RateOfIntrest") %>' Width="90%">
                                                    <MaskSettings Mask="<0..9999g>.<00..99>" ErrorText="None" IncludeLiterals="DecimalSymbol" />
                                                </dxe:ASPxTextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <%--// .............................Code Commented and Added by Sam on 15122016.due to unnecessary Code because segment id is always 1 .....................................--%>
                                        <%--<div class="col-md-6" id="trExchengSegment11">
                                            <label style="display: none; margin-top: 5px;" id="trExchange">Segment Name :
                                             <span style="color: Red;">*</span> 

                                            </label>
                                            <div style="display: none;" id="trExchange1">
                                                <dxe:ASPxComboBox ID="comboSegment" ClientInstanceName="comboSegment" runat="server"
                                                    ValueType="System.String" DataSourceID="SqlSegment" ValueField="exch_internalId"
                                                    TextField="Exchange" EnableIncrementalFiltering="true" Width="100%" OnCallback="comboSegment_Callback">

                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                                            SegmentID1(s.GetValue());
                                                                                          }"
                                                        EndCallback="function(s,e){SetSegValue(s.GetValue());}" />

                                                </dxe:ASPxComboBox>
                                                <asp:TextBox ID="txtSpefificExchange_hidden" runat="server" Visible="false"></asp:TextBox>
                                            </div>
                                        </div>--%>
                                        <%--// .............................Code Above Commented and Added by Sam on 15122016......................................--%>
                                        <div class="col-md-6">
                                            <label id="tdfbtapprate" style="display: none">
                                                <div class="hidden">FBT Applicable :</div>
                                            </label>
                                            <div id="tdfbtapprate1" style="display: none">
                                                <div style="display: none">
                                                    <dxe:ASPxCheckBox ID="FBTApplicable" ClientInstanceName="FBTApplicable" runat="server"
                                                        Width="50px" Checked='<%# Container.Grid.IsNewRowEditing ? false : Container.Grid.GetRowValues(Container.VisibleIndex, "FBTApplicable") %>' />
                                                </div>
                                                <label id="fbtrate1">
                                                    <div style="display: none">FBT Rate :</div>
                                                </label>
                                                <div id="fbtrate2">
                                                    <%--ValidationSettings-ErrorDisplayMode="None"--%>
                                                    <div style="display: none">
                                                        <dxe:ASPxTextBox ID="txtFBTRate" ClientInstanceName="txtFBTRate" runat="server" Text='<%#Bind("FBTRate") %>'
                                                            Width="90%" MaskSettings-Mask="<0..9999g>.<00..99>"
                                                            MaskSettings-IncludeLiterals="DecimalSymbol">
                                                        </dxe:ASPxTextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6" id="tdtdsapprate">
                                            <label style="margin-top: 5px;">TDS Section:</label>
                                            <div id="tdtdsapprate1">


                                                <%-- <asp:TextBox ID="txtTdsType" runat="server" CssClass="form-control" Text='<%#Bind("TDSApplicable") %>'
                                                    onkeyup="CallTdsAccount(this,'SearchTdsTcsCode',event)" Width="100%"></asp:TextBox>
                                                <asp:HiddenField ID="txtTdsType_hidden" runat="server" Value='<%#Bind("TDSRate") %>' />--%>

                                                <%--// .............................Code Commented and Added by Sam on 09122016. ..................................... --%>

                                                <dxe:ASPxComboBox ID="cmb_tdstcs" ClientInstanceName="cmb_tdstcs" DataSourceID="tdstcs" Width="90%" Value='<%#Bind("TDSRate") %>' ItemStyle-Wrap="True"
                                                    ClearButton-DisplayMode="Always" runat="server" TextField="tdsdescription" ValueField="tdscode">
                                                </dxe:ASPxComboBox>


                                                <%--// .............................Code Above Commented and Added by Sam on 09122016...................................... --%>
                                            </div>
                                        </div>
                                        <div class="col-md-6 hide" id="tddepretion">
                                            <label style="text-align: left;">Depreciation :</label>
                                            <%--ValidationSettings-ErrorDisplayMode="None"--%>
                                            <div>
                                                <dxe:ASPxTextBox ID="txtDepreciation" ClientInstanceName="txtDepreciation" runat="server"
                                                    Text='<%#Bind("Depreciation") %>' Width="90%" MaskSettings-Mask="<0..9999g>.<00..99>"
                                                    MaskSettings-IncludeLiterals="DecimalSymbol">
                                                </dxe:ASPxTextBox>
                                            </div>
                                        </div>

                                        <div class=" clear"></div>
                                        <div class="col-md-6" id="clsPaymentType">
                                            <label style="text-align: left;">Select Posting Type</label>
                                            <div>
                                                <dxe:ASPxComboBox ID="cPaymenttype" ClientInstanceName="cPaymenttype" runat="server"
                                                    ValueType="System.String" Value='<%#Bind("MainAccount_PaymentType") %>' EnableIncrementalFiltering="true"
                                                    Width="90%" SelectedIndex="0">

                                                    <Items>
                                                        <dxe:ListEditItem Text="None" Value="None" Selected="true" />
                                                        <dxe:ListEditItem Text="Card" Value="Card" />
                                                        <dxe:ListEditItem Text="Coupon" Value="Coupon" />
                                                        <dxe:ListEditItem Text="Etransfer" Value="Etransfer" />
                                                        <dxe:ListEditItem Text="Ledger for Interstate Stk-Out" Value="LedgOut" />
                                                        <dxe:ListEditItem Text="Ledger for Interstate Stk-In" Value="LedgIn" />

                                                        <dxe:ListEditItem Text="Finance Processing Fee" Value="PrcFee" />
                                                        <dxe:ListEditItem Text="Finance Other Charges Emi" Value="EmiCharge" />
                                                    </Items>
                                                    <ClientSideEvents Init="function(s,e){ 
                                                          if(s.GetValue() ==null){
                                                                s.SetValue('None');
                                                          }
                                                          
                                                   }" />
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <label style="text-align: left;">Old Unit Ledger</label>
                                            <div>
                                                <dxe:ASPxComboBox ID="cmbOldUnitLedger" ClientInstanceName="ccmbOldUnitLedger" runat="server"
                                                    ValueType="System.String" Value='<%#Bind("MainAccount_OldUnitLedger")%>' EnableIncrementalFiltering="true"
                                                    Width="90%">

                                                    <Items>
                                                        <dxe:ListEditItem Text="Yes" Value="1" Selected="true" />
                                                        <dxe:ListEditItem Text="No" Value="0" />


                                                    </Items>
                                                    <ClientSideEvents Init="function(s,e){ 
                                                           if(s.GetText()==''){
                                                           s.SetValue(0);
                                                          }else{
                                                          s.SetValue(s.GetText());
                                                          }
                                                   }" />
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>

                                        <div class=" clear"></div>
                                        <div class="col-md-3">
                                            <label style="text-align: left;">Reverse Applicable</label>
                                            <div>
                                                <dxe:ASPxComboBox ID="cmbReverseApplicable" ClientInstanceName="ccmbReverseApplicable" runat="server"
                                                    ValueType="System.String" Value='<%#Bind("MainAccount_ReverseApplicable")%>' EnableIncrementalFiltering="true"
                                                    Width="90%">

                                                    <Items>
                                                        <dxe:ListEditItem Text="Yes" Value="1" Selected="true" />
                                                        <dxe:ListEditItem Text="No" Value="0" />


                                                    </Items>
                                                    <ClientSideEvents Init="function(s,e){ 
                                                           if(s.GetText()==''){
                                                           s.SetValue(0);
                                                          }else{
                                                          s.SetValue(s.GetText());
                                                          }
                                                   }" />
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>


                                    </div>
                                </div>
                                <%--main end--%>
                                <table style="text-align: left; width: 100%;" border="0" id="main">

                                    <tr>
                                    </tr>

                                </table>
                                <div class="col-md-12">
                                    <div class="col-md-12">
                                        <controls></controls>
                                        <dxe:ASPxGridViewTemplateReplacement ID="Editors" runat="server" ColumnID="" ReplacementType="EditFormEditors"></dxe:ASPxGridViewTemplateReplacement>
                                        <div style="padding: 2px 2px 2px 2px; font-weight: bold;">
                                            <dxe:ASPxGridViewTemplateReplacement ID="UpdateButton" ReplacementType="EditFormUpdateButton" class="btn btn-primary"
                                                runat="server"></dxe:ASPxGridViewTemplateReplacement>
                                            <dxe:ASPxGridViewTemplateReplacement ID="CancelButton" ReplacementType="EditFormCancelButton" class="btn btn-danger"
                                                runat="server"></dxe:ASPxGridViewTemplateReplacement>
                                            <dxe:ASPxButton ID="btnSaveUdf" ClientInstanceName="cbtn_SaveUdf" runat="server" AutoPostBack="False" Text="UDF" UseSubmitBehavior="False"
                                                CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1">
                                                <ClientSideEvents Click="function(s, e) {OpenUdf();}" />
                                            </dxe:ASPxButton>
                                        </div>
                                    </div>
                                </div>

                            </EditForm>
                        </templates>
                        <settingspager numericbuttoncount="10" pagesize="10" showseparators="True" alwaysshowpager="True">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                             <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                        </settingspager>
                        <settingsediting mode="PopupEditForm" popupeditformheight="450px" popupeditformhorizontalalign="WindowCenter"
                            popupeditformmodal="False" popupeditformverticalalign="WindowCenter" popupeditformwidth="600px" />


                        <%--<settingsbehavior confirmdelete="True" allowfocusedrow="False" />--%>
                        <settingsbehavior allowfocusedrow="true" />


                        <settingscommandbutton>
                            <EditButton Image-Url="/assests/images/Edit.png" ButtonType="Image" Image-AlternateText="Edit" Styles-Style-CssClass="pad">
                                <Image AlternateText="Edit" Url="/assests/images/Edit.png"></Image>
                                
                            </EditButton>

                            <DeleteButton Image-Url="/assests/images/Delete.png" ButtonType="Image" Image-AlternateText="Delete" Styles-Style-CssClass="pad">
                                <Image AlternateText="Edit" Url="/assests/images/Delete.png"></Image>

                            </DeleteButton>

                            <UpdateButton Text="Save" ButtonType="Button" Styles-Style-CssClass="btn btn-primary">
                                <Styles>
                                    <Style CssClass="btn btn-primary"></Style>
                                </Styles>
                            </UpdateButton>
                            <CancelButton Text="Cancel" ButtonType="Button" Styles-Style-CssClass="btn btn-danger">
                                <Styles>
                                    <Style CssClass="btn btn-danger"></Style>
                                </Styles>
                            </CancelButton>
                        </settingscommandbutton>


                        <styleseditors>
                            <ProgressBar Height="25px">
                            </ProgressBar>
                        </styleseditors>

                        <columns>
                            <dxe:GridViewDataComboBoxColumn FieldName="AccountType" VisibleIndex="1" ShowInCustomizationForm="True">


                                <PropertiesComboBox ValueType="System.String" EnableIncrementalFiltering="True">
                                    <Items>

                                        <dxe:ListEditItem Text="Asset" Value="Asset" Selected="true"></dxe:ListEditItem>
                                        <dxe:ListEditItem Text="Liability" Value="Liability"></dxe:ListEditItem>
                                        <dxe:ListEditItem Text="Income" Value="Income"></dxe:ListEditItem>
                                        <dxe:ListEditItem Text="Expense" Value="Expense"></dxe:ListEditItem>

                                    </Items>
                                </PropertiesComboBox>
                                <CellStyle CssClass="gridcellright">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="7"></EditFormSettings>
                            </dxe:GridViewDataComboBoxColumn>

                            <dxe:GridViewDataComboBoxColumn Visible="False" FieldName="BankCashType" VisibleIndex="3" ShowInCustomizationForm="True">
                                <PropertiesComboBox ValueType="System.String" EnableIncrementalFiltering="True">
                                </PropertiesComboBox>
                                <CellStyle CssClass="gridcellright">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="9"></EditFormSettings>
                            </dxe:GridViewDataComboBoxColumn>
                            <dxe:GridViewDataComboBoxColumn Visible="False" FieldName="BankAccountType" VisibleIndex="7" ShowInCustomizationForm="True">
                                <PropertiesComboBox ValueType="System.String" EnableIncrementalFiltering="True">
                                </PropertiesComboBox>
                                <CellStyle CssClass="gridcellright">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="11"></EditFormSettings>
                            </dxe:GridViewDataComboBoxColumn>
                            <dxe:GridViewDataComboBoxColumn Visible="False" FieldName="ExchengSegment" VisibleIndex="10" ShowInCustomizationForm="True">
                                <PropertiesComboBox ValueType="System.String" EnableIncrementalFiltering="True">
                                </PropertiesComboBox>
                                <EditFormSettings Visible="False" VisibleIndex="4"></EditFormSettings>
                            </dxe:GridViewDataComboBoxColumn>


                            <%-- Account Code Section--%>
                            <dxe:GridViewDataTextColumn VisibleIndex="0" FieldName="AccountCode"
                                Caption="Short Name" ShowInCustomizationForm="True">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="3"></EditFormSettings>

                            </dxe:GridViewDataTextColumn>


                            <dxe:GridViewDataComboBoxColumn FieldName="branchname" Caption="Branch"
                                VisibleIndex="2" ShowInCustomizationForm="True">
                                <PropertiesComboBox ValueType="System.String" TextField="branch_description" ValueField="branch_id"
                                    EnableIncrementalFiltering="True" DataSourceID="branchdtl">
                                </PropertiesComboBox>
                                <Settings FilterMode="DisplayText"></Settings>
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="5"></EditFormSettings>
                            </dxe:GridViewDataComboBoxColumn>




                            <dxe:GridViewDataComboBoxColumn FieldName="AccountGroup" Caption="Account Group"
                                VisibleIndex="2" ShowInCustomizationForm="True">
                                <PropertiesComboBox ValueType="System.String" TextField="AccountGroup" ValueField="ID"
                                    EnableIncrementalFiltering="True" DataSourceID="AllAccountGroup">
                                </PropertiesComboBox>
                                <Settings FilterMode="DisplayText"></Settings>
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="5"></EditFormSettings>
                            </dxe:GridViewDataComboBoxColumn>

                            <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="AccountName" ShowInCustomizationForm="True" Caption="Account Name">
                                <CellStyle Wrap="true" CssClass="gridcellleft">
                                </CellStyle>
                                <PropertiesTextEdit Width="200px" MaxLength="50">
                                </PropertiesTextEdit>
                                <EditFormSettings Visible="False" VisibleIndex="1"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="BankAccountNo"
                                Caption="Bank Account No" ShowInCustomizationForm="True">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="13"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>


                            <dxe:GridViewDataComboBoxColumn FieldName="SubLedgerType" VisibleIndex="8" ShowInCustomizationForm="True">
                                <PropertiesComboBox ValueType="System.String" EnableIncrementalFiltering="True">
                                </PropertiesComboBox>
                                <Settings FilterMode="DisplayText"></Settings>
                                <CellStyle Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="2"></EditFormSettings>
                            </dxe:GridViewDataComboBoxColumn>

                            <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="6" FieldName="TDSApplicable" ShowInCustomizationForm="True">
                                <EditFormSettings Visible="False" VisibleIndex="6"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="9" FieldName="TDSRate"
                                Caption="TDS Rate" ShowInCustomizationForm="True">
                                <EditFormSettings Visible="False" VisibleIndex="10"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataCheckColumn Visible="False" VisibleIndex="12" FieldName="FBTApplicable" ShowInCustomizationForm="True">
                                <EditFormSettings Visible="False" VisibleIndex="8"></EditFormSettings>
                            </dxe:GridViewDataCheckColumn>

                            <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="14" FieldName="FBTRate"
                                Caption="FBT Rate" ShowInCustomizationForm="True">
                                <EditFormSettings Visible="False" VisibleIndex="12"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>
                            <%-- ShowInCustomizationForm="True"--%>
                            <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="18" FieldName="RateOfIntrest"
                                Caption="Rate Of Interest (P/a)">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="15"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="19" FieldName="Depreciation"
                                Caption="Depretiation" ShowInCustomizationForm="True">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="15"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="20" FieldName="BankCompany"
                                Caption="BankCompany" ShowInCustomizationForm="True">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False" VisibleIndex="15"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>
                            <%--ShowInCustomizationForm="True"--%>
                            <dxe:GridViewCommandColumn ShowEditButton="True" Width="110px" ShowDeleteButton="true" VisibleIndex="17">
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <HeaderTemplate>
                                    <span>Actions</span>
                                </HeaderTemplate>

                            </dxe:GridViewCommandColumn>

                            <%-- <dxe:GridViewDataTextColumn VisibleIndex="7" FieldName="openingBalance" Caption="Action" HeaderStyle-HorizontalAlign="Center"  CellStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                              
                                 <DataItemTemplate>
                                        <a href="javascript:void(0);" title="Edit" onclick="Show('<%#Eval("MainAccount_ReferenceID") %>')">
                                       <img src="/assests/images/Edit.png" /></a>
                                  
                                    <a href="javascript:void(0);"  title="Delete" onclick="GridDelete('<%#Eval("AccountCode") %>','<%#Eval("SubLedgerType") %>')">
                                       <img src="/assests/images/Delete.png" /></a>
                                </DataItemTemplate>
                                <CellStyle Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>
                             
                             <dxe:GridViewDataTextColumn VisibleIndex="8" Visible="false"  CellStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                               
                                <DataItemTemplate>
                                    <a href="javascript:void(0);"  title="Delete" onclick="GridDelete('<%#Eval("AccountCode") %>','<%#Eval("SubLedgerType") %>')">
                                       <img src="/assests/images/Delete.png" /></a>
                                </DataItemTemplate>
                                <CellStyle Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>--%>


                            <dxe:GridViewDataTextColumn VisibleIndex="11" Visible="false" CellStyle-HorizontalAlign="Center" ShowInCustomizationForm="True">
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <HeaderTemplate>
                                    <span>Opening DR/CR</span>
                                </HeaderTemplate>
                                <DataItemTemplate>
                                    <%-- onclick="Show('<%#Eval("MainAccount_ReferenceID") %>')"--%>
                                    <% if (rights.CanAdd && rights.CanEdit)
                                       { %>
                                    <a href="javascript:void(0);" title="Edit Opening DR/CR">
                                        <label title="Add/Edit" style="cursor: pointer !important;">Add/Edit</label>
                                        <% } %>
                                </DataItemTemplate>
                                <CellStyle Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>


                            <%--<dxe:GridViewDataTextColumn VisibleIndex="16" HeaderStyle-HorizontalAlign="Center" Width="50px" CellStyle-HorizontalAlign="left" ShowInCustomizationForm="True">
                                <HeaderTemplate>
                                    Delete
                                </HeaderTemplate>
                                  <DataItemTemplate>
                                    <% if (rights.CanDelete)
                                       { %>
                                    <a href="javascript:void(0);" title="Delete" onclick="GridDelete('<%#Eval("AccountCode") %>','<%#Eval("SubLedgerType") %>')">
                                        <img src="/assests/images/Delete.png" /></a><%} %>
                                </DataItemTemplate>
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>

                                <CellStyle Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>--%>


                            <dxe:GridViewDataTextColumn VisibleIndex="13" FieldName="openingBalance" Caption="Asset Detail" ShowInCustomizationForm="True">
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <EditCellStyle HorizontalAlign="Center">
                                </EditCellStyle>
                                <Settings ShowFilterRowMenu="False" AllowAutoFilter="False" />
                                <DataItemTemplate>
                                    <%-- <a href="javascript:void(0);" id="aaa" style="color:#000099;" runat="server">Add/Edit </a>--%>
                                    <dxe:ASPxHyperLink ID="AviewLink" runat="server" Text="Asset Detail">
                                    </dxe:ASPxHyperLink>
                                </DataItemTemplate>
                                <CellStyle Wrap="False" CssClass="gridcellright" HorizontalAlign="Center">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn VisibleIndex="15" FieldName="openingBalance" Caption="Document" ShowInCustomizationForm="True">
                                <Settings ShowFilterRowMenu="False" AllowAutoFilter="False" />
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <EditCellStyle HorizontalAlign="Center">
                                </EditCellStyle>
                                <DataItemTemplate>

                                    <dxe:ASPxHyperLink ID="hlink2" runat="server" Text="Document" CommandName="DocSelect">
                                    </dxe:ASPxHyperLink>
                                    <%--   <a href="javascript:void(0);" title="Document" onclick="showhistory('<%#Eval("MainAccount_ReferenceID")+ "^" + Eval("AccountCode") %>')">
                                     <label title="Document"  style="cursor:pointer !important; color:#000099; text-align:left">Document</label>   
                                       </a>--%>
                                </DataItemTemplate>
                                <CellStyle Wrap="False" CssClass="gridcellright" HorizontalAlign="Center">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewCommandColumn ShowNewButton="false" ShowEditButton="false" Caption="HSN/SAC Mapping" ShowInCustomizationForm="True" width="130">
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                 <CustomButtons>
                                    <dxe:GridViewCommandColumnCustomButton ID="MapLedger" Text="HSN/SAC Mapping">
                                    </dxe:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                                 <CellStyle Wrap="False" CssClass="gridcellright" HorizontalAlign="Center">
                                </CellStyle>
                            </dxe:GridViewCommandColumn>
                        </columns>


                        <styles>
                            <Header CssClass="gridheader" SortingImageSpacing="5px" ImageSpacing="5px">
                            </Header>
                            <FocusedRow CssClass="gridselectrow">
                            </FocusedRow>
                            <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                            <FocusedGroupRow CssClass="gridselectrow">
                            </FocusedGroupRow>
                        </styles>

                    </dxe:ASPxGridView>
                    &nbsp;
                     <dxe:ASPxPopupControl ID="ASPXPopupControl" runat="server" ContentUrl="AssetDetail.aspx"
                         CloseAction="CloseButton" Top="120" Left="300" ClientInstanceName="popup" Height="680px"
                         Width="1050px" HeaderText="Asset Details" AllowResize="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ContentStyle-Wrap="True" ResizingMode="Live" Modal="true">
                         <contentcollection>
                             <dxe:PopupControlContentControl runat="server">
                             </dxe:PopupControlContentControl>
                         </contentcollection>
                         <headerstyle backcolor="Blue" font-bold="True" forecolor="White" />
                     </dxe:ASPxPopupControl>

                    <dxe:ASPxPopupControl ID="ASPXPopupControl2" runat="server" ContentUrl="Account_Document.aspx"
                        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupdoc" Height="560px"
                        Width="1000px" HeaderText="Add/Modify Document" AllowResize="false" ContentStyle-Wrap="True" ResizingMode="Live" Modal="true">
                        <contentcollection>
                            <dxe:PopupControlContentControl runat="server">
                            </dxe:PopupControlContentControl>
                        </contentcollection>
                        <headerstyle backcolor="Blue" font-bold="True" forecolor="White" />
                    </dxe:ASPxPopupControl>
                    <%-- <dxe:ASPxPopupControl ID="ASPxPopupControl1" runat="server" ContentUrl="frm_OpeningBalance.aspx"
                        CloseAction="CloseButton" Top="100" Left="250" ClientInstanceName="popup" Height="350px"
                        Width="430px" HeaderText="Add Opening Balance">
                    </dxe:ASPxPopupControl>--%>
                    <asp:HiddenField ID="hdSegment" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="display: none">
                    <dxe:ASPxComboBox ID="ASPxComboBox4" ClientInstanceName="combo" runat="server" OnCallback="ASPxComboBox4_Callback"
                        OnCustomJSProperties="ASPxComboBox4_CustomJSProperties">
                        <clientsideevents endcallback="function(s,e) { ShowError1(s.cpInsertError1); }" />
                    </dxe:ASPxComboBox>
                </td>
                <asp:HiddenField ID="hdnAssetType" runat="server" />
                <asp:HiddenField ID="hdneditassettype" runat="server" />
            </tr>
        </table>


        <asp:SqlDataSource ID="MainAccount" runat="server" ConflictDetection="CompareAllValues"
            DeleteCommand=""
            ConnectionString="<%$ ConnectionStrings:CRMConnectionString %>"
            SelectCommand=""></asp:SqlDataSource>

        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>


        <%--        <asp:SqlDataSource ID="AllAccountGroup" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select AccountGroup_Name as Name, cast([AccountGroup_ReferenceID]  as varchar(100)) as ID ,AccountGroup_Name as AccountGroup  from Master_AccountGroup"></asp:SqlDataSource>--%>
        <%--kaushik 16-2-2017 initially account group will be populated with respect to selected account type start --%>

        <asp:SqlDataSource ID="AllAccountGroup" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select AccountGroup_Name as Name, cast([AccountGroup_ReferenceID]  as varchar(100)) as ID ,AccountGroup_Name as AccountGroup  from Master_AccountGroup "></asp:SqlDataSource>
        <%--kaushik 16-2-2017 initially account group will be populated with respect to selected account type end --%>
        <asp:SqlDataSource ID="branchdtl" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select '0' as branch_id ,  'Select' as branch_description union all   select branch_id,branch_description from tbl_master_branch order by branch_description"></asp:SqlDataSource>
        <%--     <asp:SqlDataSource ID="SqlCompany" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select cmp_internalId,cmp_name from tbl_master_company where cmp_internalId in(select distinct exch_compId from tbl_master_companyExchange)">
        </asp:SqlDataSource>--%>

        <asp:SqlDataSource ID="SqlCompany" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand=""></asp:SqlDataSource>


        <asp:SqlDataSource ID="SqlSegment" runat="server" ConflictDetection="CompareAllValues"
            ConnectionString="<%$ ConnectionStrings:crmConnectionString %>" SelectCommand=""></asp:SqlDataSource>

        <asp:SqlDataSource ID="tdstcs" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="prc_Subledger" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="action" DefaultValue="PopulateDropDownFortdstcs" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="BranchdataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select branch_id,branch_code,branch_description from tbl_master_branch"></asp:SqlDataSource>
    </div>

    <dxe:ASPxPopupControl ID="BranchSelectPopup" runat="server" Width="700"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="cBranchSelectPopup"
        HeaderText="Select Branch" AllowResize="false" ResizingMode="Postponed" Modal="true">
        <contentcollection>
            <dxe:PopupControlContentControl runat="server">

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

                <input type="button" value="Deselect All" class="btn btn-primary pull-right" onclick="unSelectAllBranch()" />
                <input type="button" value="Select All" class="btn btn-primary pull-right" onclick="SelectAllBranch()" />

            </dxe:PopupControlContentControl>
        </contentcollection>
    </dxe:ASPxPopupControl>
    <%--UDF Popup --%>
    <dxe:ASPxPopupControl ID="ASPXPopupControl1" runat="server"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popup" Height="630px"
        Width="600px" HeaderText="Add/Modify UDF" Modal="true" AllowResize="true" ResizingMode="Postponed">

        <contentcollection>
                <dxe:PopupControlContentControl runat="server">
                </dxe:PopupControlContentControl>
            </contentcollection>
    </dxe:ASPxPopupControl>
    <asp:HiddenField runat="server" ID="IsUdfpresent" />
    <asp:HiddenField runat="server" ID="Keyval_internalId" />
    <%--UDF Popup End--%>


    <%--HSN/SAC Mapping To Ledger Popup --%>

    <dxe:ASPxPopupControl ID="MappingLedgerPopup" runat="server" ClientInstanceName="cMappingLedgerPopup"
        Width="400px" HeaderText="Ledger Mapping" PopupHorizontalAlign="WindowCenter"
        BackColor="white" Height="100px" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
        Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">

        <contentcollection>
            <dxe:PopupControlContentControl runat="server">
                <div style="clear: both"></div>
                <asp:HiddenField runat="server" ID="hfLedgerID" />
                <asp:HiddenField runat="server" ID="hfHSNSCAkey" />
                <asp:HiddenField runat="server" ID="hfHSNSCAType" />
                <div class="cityDiv" style="height: auto;">
                    <asp:Label ID="Label1" runat="server" Text="HSN Code" CssClass="newLbl"></asp:Label>
                </div>
                <div class="Left_Content">
                   <dxe:ASPxGridLookup ID="HsnLookUp" runat="server" ClientInstanceName="cHsnLookUp"
                        KeyFieldName="HSN_id" Width="100%" TextFormatString="{0}" MultiTextSeparator=", "
                       OnDataBinding="HsnLookUp_DataBinding">
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
                                                <%--<dxe:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseMappingPopup" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </StatusBar>
                            </Templates>

                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>

                            <Settings ShowStatusBar="Visible" UseFixedTableLayout="true" />
                        </GridViewProperties>
                        <ClientSideEvents TextChanged="function(s, e) { HsnLookUp_SelectedChange(e)}" />
                        <ClearButton DisplayMode="Auto">
                        </ClearButton>
                    </dxe:ASPxGridLookup>
                </div>
                <div class="clear"></div>
                <div class="cityDiv" style="height: auto;">
                    <asp:Label ID="Label4" runat="server" Text="Service Category" CssClass="newLbl"></asp:Label>
                </div>
                <div class="Left_Content">
                     <dxe:ASPxGridLookup ID="ScaLookUp" runat="server" ClientInstanceName="cScaLookUp"
                        KeyFieldName="TAX_ID" Width="100%" TextFormatString="{0}" MultiTextSeparator=", "
                       OnDataBinding="ScaLookUp_DataBinding">
                        <Columns>
                            <dxe:GridViewDataColumn FieldName="SERVICE_CATEGORY_CODE" Caption="Code" Width="50" />
                            <dxe:GridViewDataColumn FieldName="SERVICE_TAX_NAME" Caption="Name" Width="250" />
                            <dxe:GridViewDataColumn FieldName="ACCOUNT_HEAD_TAX_RECEIPTS" Caption="Receipts" Width="0" />
                            <dxe:GridViewDataColumn FieldName="ACCOUNT_HEAD_OTHERS_RECEIPTS" Caption="Oth Receipts" Width="0" />
                            <dxe:GridViewDataColumn FieldName="ACCOUNT_HEAD_PENALTIES" Caption="Penalties" Width="0" />
                            <dxe:GridViewDataColumn FieldName="ACCOUNT_HEAD_DeductRefund" Caption="A/C Head (Deduct Refund)" Width="0" />
                        </Columns>
                        <GridViewProperties Settings-VerticalScrollBarMode="Auto">
                            <Templates>
                                <StatusBar>
                                    <table class="OptionsTable" style="float: right">
                                        <tr>
                                            <td>
                                                <%--<dxe:ASPxButton ID="ASPxButton7" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseMappingPopup" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </StatusBar>
                            </Templates>

                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>

                            <Settings ShowStatusBar="Visible" UseFixedTableLayout="true" />
                        </GridViewProperties>
                        <ClientSideEvents TextChanged="function(s, e) { ScaLookUp_SelectedChange(e)}" />
                       <ClearButton DisplayMode="Auto">
                        </ClearButton>
                    </dxe:ASPxGridLookup>
                </div>
                <div class="clear"></div>
                <div class="cityDiv" style="height: auto;">
                                                <label >GSTIN   </label>
                                                <div class="Left_Content"> 
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
                                                        <li class="relative">
                                                            <dxe:ASPxTextBox ID="txtGSTIN3" ClientInstanceName="ctxtGSTIN333"  MaxLength="3"  TabIndex="12"  runat="server" Width="50px"> 
                                                            </dxe:ASPxTextBox>
                                                            <span id="invalidGst" class="pullleftClass fa fa-exclamation-circle iconRed " style="color:red;display:none;padding-left: 9px;right:-22px" title="Invalid GSTIN"></span>
                                                        </li>
                                                    </ul>   
                                                 </div>
                                                 </div>
                <div class="clear"></div>
                 <div class="cityDiv" style="height: auto;">
                    <asp:Label ID="Label2" runat="server" Text="Furtherence of Business" CssClass="newLbl"></asp:Label>
                </div>
                <div>
                    <dxe:ASPxCheckBox ID="chbFurtherenceOfBusiness" ClientInstanceName="cchbFurtherenceOfBusiness" runat="server"></dxe:ASPxCheckBox>
                </div>
                
                <div style="clear: both"></div>
                <div class="" style="margin-top: 5px">
                    <div class="cityDiv" style="height: auto;">
                    </div>
                    <div class="Left_Content">
                        <button type="button" class="btn btn-primary" onclick="MappingLedgerSaveClick()">Save</button>
                         <button type="button" class="btn btn-primary" onclick="CloseMappingPopup()">Cancel</button>

                    </div>
                </div>

            </dxe:PopupControlContentControl>
        </contentcollection>
        <headerstyle backcolor="LightGray" forecolor="Black" />
    </dxe:ASPxPopupControl>
    <%--HSN/SAC Mapping To Ledger Popup End--%>
</asp:Content>
