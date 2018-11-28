﻿<%@ Page Title="Tax Code" Language="C#" AutoEventWireup="true" EnableEventValidation="false" Inherits="ERP.OMS.Management.Master.Management_Accounts_Master_TaxesLevies" MasterPageFile="~/OMS/MasterPage/ERP.Master" CodeBehind="TaxesLevies.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="/assests/pluggins/choosen/choosen.min.js"></script>

    <script type="text/javascript">
        //function is called on changing country
        //        function OnCountryChanged(cmbCountry) 
        //        {
        //            grid.GetEditor("cou_country").PerformCallback(cmbCountry.GetValue().toString());
        //        }
        $(document).ready(function () {
            // Tooltip only Text
            calculationmethodsrdp.SetEnabled(true);
            itemlevelrdp.SetEnabled(true);

            $("#txtTaxes_Code_EI").hover(
            function () {
                $(this).append($("<span> Mandatory </span>"));
            });
        });


        function ShowHideFilter(obj) {
            grid.PerformCallback(obj);
        }
        function Oncmbtaxtype_ValueChange(obje) {

            var value = obje.GetValue();
            if (value == "V" || value == "G" || value == "C" || value == "CGST" || value == "IGST" || value == "SGST" || value == "O") {

                itemlevelrdp.SetEnabled(true);
                calculationmethodsrdp.SetEnabled(true);

            }
            else {

                $.ajax({
                    type: "POST",
                    url: "TaxesLevies.aspx/GetExistingValu",
                    data: "{'reqStr':'" + value + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {

                        if (msg.d != "|") {
                            var TaxItemlevel = msg.d.split('|')[0];
                            var TaxCalculateMethods = msg.d.split('|')[1];

                            if (TaxCalculateMethods != "" && TaxCalculateMethods != null) {

                                calculationmethodsrdp.SetValue(TaxCalculateMethods);
                                calculationmethodsrdp.SetEnabled(false);
                            } else {
                                calculationmethodsrdp.SetValue("A");
                                calculationmethodsrdp.SetEnabled(true);
                            }
                            if (TaxItemlevel != "" && TaxItemlevel != null) {

                                itemlevelrdp.SetValue(TaxItemlevel);
                                itemlevelrdp.SetEnabled(false);
                            } else {
                                itemlevelrdp.SetValue("Y");
                                itemlevelrdp.SetEnabled(true);
                            }
                        } else {


                            calculationmethodsrdp.SetValue("A");
                            calculationmethodsrdp.SetEnabled(false);
                            if (value == "V") {

                                itemlevelrdp.SetValue("Y");
                                itemlevelrdp.SetEnabled(false);
                            } else {

                                itemlevelrdp.SetValue("Y");
                                itemlevelrdp.SetEnabled(true);
                            }


                        }
                    }

                });




            }

        }
    </script>

    <script type="text/javascript">


        function fn_PopOpen() {
            document.getElementById("hndTaxes_OtherTax_hidden").value = '';
            ListBind();
            ChangeSource();

            document.getElementById('hiddenedit').value = "";
            ctxtTaxes_Code.SetText('');
            ctxtTaxes_Name.SetText('');
            ctxtTaxes_Description.SetText('');
            cCmbTaxes_ApplicableFor.SetSelectedIndex(0);
            cCmbTaxes_ApplicableOn.SetSelectedIndex(0);

            rediotypes.SetEnabled(true);
            itemlevelrdp.SetEnabled(true);
            calculationmethodsrdp.SetEnabled(true);

            calculationmethodsrdp.SetSelectedIndex(0);
            itemlevelrdp.SetSelectedIndex(0);
            rediotypes.SetSelectedIndex(-1);

            //ctxtTaxes_OtherTax.SetText('');

            //document.getElementById('txtTaxes_OtherTax').value = '';
            //document.getElementById('txtTaxes_OtherTax_hidden').value = '';

            document.getElementById('divtxtTaxes_OtherTax').style.display = 'none';

            cPopup_Empcitys.Show();
            document.getElementById("txtTaxes_Code").focus();
        }

        function FunCallAjaxList(objID, objEvent, ObjType) {
            var strQuery_Table = '';
            var strQuery_FieldName = '';
            var strQuery_WhereClause = '';
            var strQuery_OrderBy = '';
            var strQuery_GroupBy = '';
            var CombinedQuery = '';

            if (ObjType == 'Digital') {


                var txtTaxRates_MainAccount = document.getElementById('txtTaxes_OtherTax').value;


                strQuery_Table = "Master_Taxes";
                strQuery_FieldName = "Taxes_Name,Taxes_ID";
                strQuery_WhereClause = "Taxes_Name like '" + txtTaxRates_MainAccount + "%'";

                // strQuery_WhereClause = " user_group not IN (\%52%') and ( USER_NAME like (\'%RequestLetter%') or user_loginId like (\'%RequestLetter%'))";

            }
            CombinedQuery = new String(strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_OrderBy + "$" + strQuery_GroupBy);

            //ajax_showOptions(objID, 'GenericAjaxList', objEvent, replaceChars(CombinedQuery));
            ajax_showOptions(objID, 'GenericAjaxList', objEvent, replaceChars(CombinedQuery), "Main");

        }

        function replaceChars(entry) {
            out = "+"; // replace this
            add = "--"; // with this
            temp = "" + entry; // temporary holder

            while (temp.indexOf(out) > -1) {
                pos = temp.indexOf(out);
                temp = "" + (temp.substring(0, pos) + add +
            temp.substring((pos + out.length), temp.length));
            }

            return temp;
        }

        function btnSave_citys() {

            //ajax call for unique code check
            var taxtype = rediotypes.GetValue();

            if (taxtype = "" && taxtype == null) {

                return false
            }

            var TaxLaviesCode = ctxtTaxes_Code.GetText();

            var CheckUniqueCode = false;
            $.ajax({
                type: "POST",
                url: "TaxesLevies.aspx/CheckUniqueCode",
                data: "{'TaxLaviesCode':'" + TaxLaviesCode + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (document.getElementById('hiddenedit').value == '') {
                        CheckUniqueCode = msg.d;
                    }
                    else {
                        CheckUniqueCode = false;
                    }


                    if (CheckUniqueCode == false && ctxtTaxes_Name.GetText() != '' && ctxtTaxes_Code.GetText() != '') {
                        if (document.getElementById('hiddenedit').value == '')
                            grid.PerformCallback('savecity~');
                        else
                            grid.PerformCallback('updatecity~' + GetObjectID('hiddenedit').value);
                    }
                    else if (CheckUniqueCode == true) {
                        jAlert('Please Enter Unique code for Taxes Code');
                        ctxtTaxes_Code.Focus();
                    }
                    else if (ctxtTaxes_Code.GetText() == '') {
                        ctxtTaxes_Code.Focus();
                    }
                    else if (ctxtTaxes_Name.GetText() == '') {
                        ctxtTaxes_Code.Focus();
                    }

                    //if (CheckUniqueCode == false && ctxtTaxes_Name.GetText() != '' && ctxtTaxes_Code.GetText() != '') {
                    //    if (document.getElementById('hiddenedit').value == '')
                    //        grid.PerformCallback('savecity~');
                    //    else
                    //        grid.PerformCallback('updatecity~' + GetObjectID('hiddenedit').value);
                    //}
                    //else if (CheckUniqueCode == true) {
                    //    jAlert('Please Enter Unique code for Taxes Code');
                    //    ctxtTaxes_Code.Focus();
                    //}
                    //else if (ctxtTaxes_Code.GetText() == '') {
                    //    jAlert('Please Enter Taxes Code');
                    //    ctxtTaxes_Code.Focus();
                    //}
                    //else if (ctxtTaxes_Name.GetText() == '') {
                    //    jAlert('Please Enter Taxes Name');
                    //    ctxtTaxes_Name.Focus();
                    //}

                }

            });


        }
        function fn_btnCancel() {
            cPopup_Empcitys.Hide();
        }
        function fn_Editcity(keyValue) {
            grid.PerformCallback('Edit~' + keyValue);
        }

        function fn_Copycity(keyValue) {
            grid.PerformCallback('copy~' + keyValue);
        }
        function fn_Deletecity(keyValue) {

            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {

                    grid.PerformCallback('Delete~' + keyValue);
                }
            });


        }
        function changedchecbox() {
            //var dtd = grid.GetValue("Taxes_Code");
            //var dtd = grid.GetEditor("Taxes_ID");
            var currentValue = grid.GetEditor('Taxes_ID').GetText();
            alert(currentValue);
        }
        function fn_Deletecityall() {

            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {

                    //grid.PerformCallback('Deleteall~' + keyValue);
                }
            });
        }

        function grid_EndCallBack() {
            if (grid.cpinsert != null) {
                if (grid.cpinsert == 'Success') {
                    jAlert('Saved Successfully');
                    cPopup_Empcitys.Hide();
                    rediotypes.PerformCallback();
                }
                else {
                    jAlert("Error found while saving the data.");
                    cPopup_Empcitys.Hide();
                }
            }
            if (grid.cpEdit != null) {

                ctxtTaxes_Code.SetText(grid.cpEdit.split('~')[0]);

                ctxtTaxes_Name.SetText(grid.cpEdit.split('~')[1]);

                ctxtTaxes_Description.SetText(grid.cpEdit.split('~')[2]);
                cCmbTaxes_ApplicableFor.SetValue(grid.cpEdit.split('~')[3]);
                cCmbTaxes_ApplicableOn.SetValue(grid.cpEdit.split('~')[4]);




                if (grid.cpEdit.split('~')[8] == "L") {
                    calculationmethodsrdp.SetSelectedIndex(1);
                } else {

                    calculationmethodsrdp.SetSelectedIndex(0);

                }

                if (grid.cpEdit.split('~')[9] == "Y") {
                    itemlevelrdp.SetSelectedIndex(0);
                } else if (grid.cpEdit.split('~')[9] == "N")
                { itemlevelrdp.SetSelectedIndex(1); }
                else {
                    itemlevelrdp.SetSelectedIndex(0);
                }
                if (grid.cpEdit.split('~')[10] != "") {
                    rediotypes.SetValue(grid.cpEdit.split('~')[10]);
                } else {

                    rediotypes.SetSelectedIndex(0);
                }
                //ctxtTaxes_OtherTax.SetText(grid.cpEdit.split('~')[5]);


                //document.getElementById('txtTaxes_OtherTax').value = grid.cpEdit.split('~')[7];
                //document.getElementById('txtTaxes_OtherTax_hidden').value = grid.cpEdit.split('~')[5];

                var otherTaxvalue = grid.cpEdit.split('~')[5];

                GetObjectID('hiddenedit').value = grid.cpEdit.split('~')[6];

                var val = cCmbTaxes_ApplicableOn.GetValue();

                if (val == 'O') {
                    //ctxtTaxes_OtherTax.SetText('');
                    //                    document.getElementById('Popup_Empcitys_txtTaxes_OtherTax').value = '';
                    //                    document.getElementById('Popup_Empcitys_txtTaxes_OtherTax_hidden').value = '';
                    document.getElementById('divtxtTaxes_OtherTax').style.display = 'block';
                }
                else {
                    // ctxtTaxes_OtherTax.SetText('');
                    //document.getElementById('txtTaxes_OtherTax').value = '';
                    //document.getElementById('txtTaxes_OtherTax_hidden').value = '';
                    document.getElementById("hndTaxes_OtherTax_hidden").value = grid.cpEdit.split('~')[5];
                    ListBind();
                    ChangeSource();
                    document.getElementById('divtxtTaxes_OtherTax').style.display = 'none';
                }

                rediotypes.SetEnabled(false);
                itemlevelrdp.SetEnabled(false);
                calculationmethodsrdp.SetEnabled(false);
                cCmbTaxes_ApplicableFor.SetEnabled(false);
                cPopup_Empcitys.Show();
            }
            if (grid.cpUpdate != null) {
                if (grid.cpUpdate == 'Success') {
                    jAlert('Updated Successfully');
                    cPopup_Empcitys.Hide();
                }
                else {
                    jAlert("Error found while saving the data.'")
                    cPopup_Empcitys.Hide();
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
                if (grid.cpDelete == 'Success') {
                    jAlert('Deleted Successfully');
                    rediotypes.PerformCallback();
                }
                else if (grid.cpDelete == 'FK') {
                    jAlert(grid.cpMsg);
                }
                else
                    jAlert("Error found while deleting the data.")
            }
            if (grid.cpExists != null) {
                if (grid.cpExists == "Exists") {
                    jAlert('Record already Exists');
                    cPopup_Empcitys.Hide();
                }
                else {
                    jAlert("Error found.'")
                    cPopup_Empcitys.Hide();
                }
            }
        }
        function CmbTaxes_ApplicableOn_ValueChange() {
            var val = cCmbTaxes_ApplicableOn.GetValue();

            if (val == 'O') {
                document.getElementById('divtxtTaxes_OtherTax').style.display = 'block';
            }
            else {
                //ctxtTaxes_OtherTax.SetText('');

                //document.getElementById('txtTaxes_OtherTax').value = '';
                //document.getElementById('txtTaxes_OtherTax_hidden').value = '';
                document.getElementById("hndTaxes_OtherTax_hidden").value = '';
                ListBind();
                ChangeSource();

                document.getElementById('divtxtTaxes_OtherTax').style.display = 'none';
            }
        }

    </script>

    <script type="text/javascript">
        /*Code  Added  By Sudip on 14122016 to use jquery Choosen*/

        //$(document).ready(function () {
        //    ListBind();
        //    //ChangeSource();
        //});
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
        function lstTaxes_OtherTax() {
            $('#lstTaxes_OtherTax').fadeIn();
        }
        function Changeselectedvalue() {
            var lstTaxes_OtherTax = document.getElementById("lstTaxes_OtherTax");
            if (document.getElementById("hndTaxes_OtherTax_hidden").value != '') {
                for (var i = 0; i < lstTaxes_OtherTax.options.length; i++) {
                    if (lstTaxes_OtherTax.options[i].value == document.getElementById("hndTaxes_OtherTax_hidden").value) {
                        lstTaxes_OtherTax.options[i].selected = true;
                    }
                }
                $('#lstTaxes_OtherTax').trigger("chosen:updated");
            }
        }
        function ChangeSource() {
            var fname = "%";
            var lReportTo = $('select[id$=lstTaxes_OtherTax]');
            lReportTo.empty();

            $.ajax({
                type: "POST",
                url: "TaxesLevies.aspx/GetOtherTaxList",
                data: JSON.stringify({ reqStr: fname }),
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

                            $('#lstTaxes_OtherTax').append($('<option>').text(name).val(id));
                        }

                        $(lReportTo).append(listItems.join(''));
                        lstTaxes_OtherTax();
                        $('#lstTaxes_OtherTax').trigger("chosen:updated");
                        Changeselectedvalue();
                    }
                    else {
                        $('#lstTaxes_OtherTax').trigger("chosen:updated");
                    }
                }
            });
        }
        function changeFunc() {
            document.getElementById("hndTaxes_OtherTax_hidden").value = document.getElementById("lstTaxes_OtherTax").value;
        }
    </script>

    <style type="text/css">
        #lstTaxes_OtherTax {
            width: 180px;
        }

        #lstTaxes_OtherTax {
            display: none !important;
        }

        #lstTaxes_OtherTax_chosen {
            width: 180px !important;
        }
    </style>

    <style type="text/css">
        .tp2 {
            right: 10px;
            top: 9px;
            position: absolute;
        }

        .Left_Content {
            position: relative;
        }

        .dxeErrorFrameSys.dxeErrorCellSys td:last-child {
            display: none;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Tax Code(s)</h3>
        </div>
    </div>

    <div class="form_main">
        <%--  <div class="Main">
            
            <div class="SearchArea">
             
                <div class="ExportSide">
                    <div style="margin-left: 90%;">
                        <dxe:ASPxComboBox ID="cmbExport" runat="server" AutoPostBack="true" BackColor="Navy"
                            Font-Bold="False" ForeColor="White" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged"
                            ValueType="System.Int32" Width="130px">
                            <Items>
                                <dxe:ListEditItem Text="Select" Value="0" />
                                <dxe:ListEditItem Text="PDF" Value="1" />
                                <dxe:ListEditItem Text="XLS" Value="2" />
                                <dxe:ListEditItem Text="RTF" Value="3" />
                                <dxe:ListEditItem Text="CSV" Value="4" />
                            </Items>
                            <ButtonStyle BackColor="#C0C0FF" ForeColor="Black">
                            </ButtonStyle>
                            <ItemStyle BackColor="Navy" ForeColor="White">
                                <HoverStyle BackColor="#8080FF" ForeColor="White">
                                </HoverStyle>
                            </ItemStyle>
                            <Border BorderColor="White" />
                            <DropDownButton Text="Export">
                            </DropDownButton>
                        </dxe:ASPxComboBox>
                    </div>
                </div>
            </div>
        </div>--%>

        <table class="TableMain100">

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
                                            <a href="javascript:void(0);" onclick="fn_PopOpen()" class="btn btn-primary"><span>Add New</span></a><%} %>
                                            <%--   <a href="javascript:ShowHideFilter('s');" class="btn btn-success"><span >
                                                Show Filter</span></a>--%>
                                            <%-- <% if (rights.CanDelete)
                                               { %>
                                            <a href="javascript:void(0);" onclick="fn_Deletecityall()" title="Delete" class="btn btn-primary" id="deleteall">Delete</a>
                                            <%} %>--%>
                                            <span id="Td1" style="display: none"><a href="javascript:ShowHideFilter('All');" class="btn btn-primary"><span>All Records</span></a></span>

                                            <% if (rights.CanExport)
                                               { %>
                                            <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true" OnChange="if(!AvailableExportOption()){return false;}">
                                                <asp:ListItem Value="0">Export to</asp:ListItem>
                                                <asp:ListItem Value="1">PDF</asp:ListItem>
                                                <asp:ListItem Value="2">XLS</asp:ListItem>
                                                <asp:ListItem Value="3">RTF</asp:ListItem>
                                                <asp:ListItem Value="4">CSV</asp:ListItem>
                                            </asp:DropDownList>
                                            <%} %>
                                            <%--<asp:CheckBox ID="chkSysAccount" runat="server" Checked="True" /><span>Hide
                                            System Accounts</span>--%>
                                        </td>

                                    </tr>
                                </table>
                            </td>


                            <%--<td class="gridcellright pull-right">
                                <dxe:ASPxComboBox ID="cmbExport" runat="server" AutoPostBack="true"
                                    Font-Bold="False" ForeColor="black" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged"
                                    ValueType="System.Int32" Width="130px">
                                    <Items>
                                        <dxe:ListEditItem Text="Select" Value="0" />
                                        <dxe:ListEditItem Text="PDF" Value="1" />
                                        <dxe:ListEditItem Text="XLS" Value="2" />
                                        <dxe:ListEditItem Text="RTF" Value="3" />
                                        <dxe:ListEditItem Text="CSV" Value="4" />
                                    </Items>
                                    <ButtonStyle>
                                    </ButtonStyle>
                                    <ItemStyle>
                                        <HoverStyle>
                                        </HoverStyle>
                                    </ItemStyle>
                                    <Border BorderColor="black" />
                                    <DropDownButton Text="Export">
                                    </DropDownButton>
                                </dxe:ASPxComboBox>
                            </td>--%>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <dxe:ASPxGridView ID="TaxLeviesGrid" runat="server" AutoGenerateColumns="False" ClientInstanceName="grid"
                        KeyFieldName="Taxes_ID" Width="100%" OnHtmlRowCreated="TaxLeviesGrid_HtmlRowCreated"
                        OnHtmlEditFormCreated="TaxLeviesGrid_HtmlEditFormCreated" OnCustomCallback="TaxLeviesGrid_CustomCallback" CssClass="wordWrap">
                        <SettingsSearchPanel Visible="True" />
                        <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="True" ShowFilterRowMenu="True" />
                        <SettingsBehavior AllowFocusedRow="true" />
                        <SettingsPager ShowSeparators="True" AlwaysShowPager="True" NumericButtonCount="20"
                            PageSize="20">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                        </SettingsPager>
                        <Columns>
                            <%--<dxe:GridViewDataCheckColumn FieldName="Taxes_ID" Visible="true" FixedStyle="Left" VisibleIndex="0" Name="checkboxs">
                                <EditFormSettings Visible="False"/>
                                <PropertiesCheckEdit >
                                    <ClientSideEvents CheckedChanged="function(s, e) {changedchecbox();}" />
                                </PropertiesCheckEdit>
                            </dxe:GridViewDataCheckColumn>--%>

                            <%--<dxe:GridViewDataTextColumn Caption=" " Width="15%"  FixedStyle="None" FieldName="Taxes_ID"
                                VisibleIndex="0">
                                  <DataItemTemplate>
                                  <dxe:ASPxCheckBox runat="server" ID="checkboxs" >
                                      <ClientSideEvents CheckedChanged="function(s, e) {changedchecbox();}" />
                                  </dxe:ASPxCheckBox>
                                      </DataItemTemplate>
                                <EditFormSettings Visible="false" />
                                  <Settings ShowInFilterControl="False"  AllowHeaderFilter="False" />
                                  
                            </dxe:GridViewDataTextColumn>--%>

                            <dxe:GridViewDataTextColumn Caption="Taxes_ID" FieldName="Taxes_ID" ReadOnly="True"
                                Visible="False" FixedStyle="Left" VisibleIndex="2">
                                <EditFormSettings Visible="False" />
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Tax Code" FieldName="Taxes_Code" FixedStyle="Left"
                                Visible="True" VisibleIndex="3">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                                <CellStyle Wrap="True">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Name" FieldName="Taxes_Name" FixedStyle="Left"
                                Visible="True" VisibleIndex="4">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                                <CellStyle Wrap="True">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Description" FieldName="Taxes_Description"
                                Width="30%" FixedStyle="Left" Visible="True" VisibleIndex="5">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                                <CellStyle Wrap="True">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="TAX Type" FieldName="TaxTypeCodeG"
                                FixedStyle="Left" Visible="True" VisibleIndex="6">
                                <EditFormSettings Visible="True" />
                                <Settings AutoFilterCondition="Contains" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Item level" FieldName="TaxItemlevelG"
                                FixedStyle="Left" Visible="True" VisibleIndex="7">
                                <EditFormSettings Visible="True" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Calculation Method" FieldName="TaxCalculateMethodsG"
                                FixedStyle="Left" Visible="True" VisibleIndex="8">
                                <EditFormSettings Visible="True" />
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Applicable For" FieldName="Taxes_ApplicableFortxt"
                                Visible="True" VisibleIndex="9">
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn ReadOnly="True" Width="150px" CellStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" VisibleIndex="10">
                                <%-- <HeaderTemplate>
                            <a href="javascript:void(0);" onclick="fn_PopOpen()"><span style="color: #000099;
                                text-decoration: underline">Add New</span> </a>
                        </HeaderTemplate>--%>

                                <DataItemTemplate>
                                    <% if (rights.CanEdit)
                                       { %>
                                    <a href="javascript:void(0);" onclick="fn_Editcity('<%# Container.KeyValue %>')" title="Edit" class="pad">
                                        <img src="../../../assests/images/Edit.png" /></a><%} %>
                                    <% if (rights.CanDelete)
                                       { %>
                                    <a href="javascript:void(0);" onclick="fn_Deletecity('<%# Container.KeyValue %>')" title="Delete" class="pad">
                                        <img src="../../../assests/images/Delete.png" /></a><%} %>
                                    <%--  <% if (rights.CanEdit)
                                       { %>
                                    <a href="javascript:void(0);" onclick="fn_Copycity('<%# Container.KeyValue %>')" title="Copy" class="pad">
                                        <img src="/assests/images/Add.png" /></a><%} %>--%>
                                </DataItemTemplate>

                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>

                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                <HeaderTemplate>Actions</HeaderTemplate>
                            </dxe:GridViewDataTextColumn>
                        </Columns>
                        <ClientSideEvents EndCallback="function (s, e) {grid_EndCallBack();}" />
                    </dxe:ASPxGridView>
                    <asp:HiddenField ID="delallids" runat="server" Value="0" />
                </td>
            </tr>
            <tr>
                <td>
                    <div class="PopUpArea">
                        <dxe:ASPxPopupControl ID="Popup_Empcitys" runat="server" ClientInstanceName="cPopup_Empcitys"
                            Width="400px" HeaderText="Add/Modify Tax Code" BackColor="white"
                            CloseAction="CloseButton" Modal="True" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                            ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True" ContentStyle-CssClass="pad">
                            <ContentCollection>
                                <dxe:PopupControlContentControl ID="PopupControlContentControl1" runat="server">
                                    <%--<div style="Width:400px;background-color:#FFFFFF;margin:0px;border:1px solid red;">--%>
                                    <div class="Top">
                                        <%-- <span style="color:red;">* Fields are mandatory</span><br />--%>
                                        <div class="clearfix" style="margin-top: 10px;">
                                            <div class="cityDiv col-md-4 " style="margin-top: 7px">
                                                Tax Code <span style="color: red;">*</span>
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">
                                                <dxe:ASPxTextBox ID="txtTaxes_Code" ClientInstanceName="ctxtTaxes_Code" runat="server"
                                                    MaxLength="50" Width="180px">
                                                    <ValidationSettings ErrorTextPosition="right" SetFocusOnError="True" ErrorImage-ToolTip="Mandatory" ErrorDisplayMode="ImageWithText">
                                                        <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                        <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                    </ValidationSettings>
                                                </dxe:ASPxTextBox>
                                            </div>

                                        </div>
                                        <div class="clearfix">
                                            <div class="cityDiv col-md-4" style="margin-top: 7px">
                                                Name <span style="color: red;">*</span>
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">
                                                <dxe:ASPxTextBox ID="txtTaxes_Name" ClientInstanceName="ctxtTaxes_Name" runat="server" MaxLength="100"
                                                    Width="180px">
                                                    <ValidationSettings Display="Static" ErrorTextPosition="right" ErrorImage-ToolTip="Mandatory" ErrorDisplayMode="ImageWithText" SetFocusOnError="True">
                                                        <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                        <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                    </ValidationSettings>
                                                </dxe:ASPxTextBox>
                                                <%--<span id="MandatorylstName" class="pullleftClass fa fa-exclamation-circle iconRed " style="color: red; position: absolute; right: 26px; top: 39px; display: block" title="Mandatory"></span>--%>
                                            </div>
                                        </div>
                                        <div class="clearfix">
                                            <div class="cityDiv col-md-4">
                                                Description
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">
                                                <dxe:ASPxMemo ID="txtTaxes_Description" ClientInstanceName="ctxtTaxes_Description" MaxLength="300"
                                                    runat="server" Width="180px" Height="60px" Text='<%# Bind("txtTaxes_Description") %>'>
                                                </dxe:ASPxMemo>


                                            </div>
                                        </div>
                                        <div class="clearfix">
                                            <div class="cityDiv col-md-4" style="margin-top: 7px">
                                                Type <span style="color: red;">*</span>
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">

                                                <dxe:ASPxComboBox ID="cmbtaxtype" EnableIncrementalFiltering="True" ClientInstanceName="rediotypes"
                                                    runat="server" ValueType="System.String" Width="180px" EnableSynchronization="True" ValueField="tax_Code" TextField="tax_Description" OnCallback="cmbtaxtype_CustomCallback">
                                                    <ClientSideEvents ValueChanged="function(s,e){Oncmbtaxtype_ValueChange(s)}" />
                                                    <ValidationSettings Display="Dynamic" ErrorTextPosition="right" ErrorImage-ToolTip="Mandatory" ErrorDisplayMode="ImageWithText" SetFocusOnError="True">
                                                        <ErrorImage ToolTip="Mandatory"></ErrorImage>
                                                        <RequiredField IsRequired="True" ErrorText="Mandatory" />
                                                    </ValidationSettings>
                                                </dxe:ASPxComboBox>
                                                <%--  <dxe:ASPxRadioButtonList ID="Rediotype" ClientInstanceName="rediotypes" runat="server" ValueType="System.String">

                                                    <Items>
                                                        <dxe:ListEditItem Text="VAT/GST/CST" Value="1" />
                                                        <dxe:ListEditItem Text="Other" Value="2" />
                                                    </Items>
                                                    <%--<ValidationSettings>
                                                        <RequiredField ErrorText="Mandatory Field" IsRequired="true" />
                                                    </ValidationSettings>--%>
                                                <%--  </dxe:ASPxRadioButtonList>--%>
                                            </div>
                                        </div>
                                        <div class="clearfix">
                                            <div class="cityDiv col-md-4" style="margin-top: 7px">
                                                Applicable For
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">
                                                <dxe:ASPxComboBox ID="CmbTaxes_ApplicableFor" EnableIncrementalFiltering="True" ClientInstanceName="cCmbTaxes_ApplicableFor"
                                                    runat="server" ValueType="System.String" Width="180px" EnableSynchronization="True">
                                                    <%--<ClientSideEvents ValueChanged="function(s,e){OnCmbCountryName_ValueChange()}"></ClientSideEvents>--%>
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="clearfix">
                                            <div class="cityDiv col-md-4" style="margin-top: 7px">
                                                Item Level ?
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">

                                                <dxe:ASPxRadioButtonList ID="Itemlevelrdp" ClientInstanceName="itemlevelrdp" runat="server" ValueType="System.String" Width="180px" RepeatDirection="Horizontal">

                                                    <Items>
                                                        <dxe:ListEditItem Text="Yes" Value="Y" />
                                                        <dxe:ListEditItem Text="No" Value="N" />
                                                    </Items>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                        <RequiredField ErrorText="Mandatory" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dxe:ASPxRadioButtonList>

                                            </div>
                                        </div>
                                        <div class="clearfix">
                                            <div class="cityDiv col-md-4" style="margin-top: 7px">
                                                Calculation Method
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">

                                                <dxe:ASPxRadioButtonList ID="Calculationmethodsrdp" ClientInstanceName="calculationmethodsrdp" Width="180px" runat="server" ValueType="System.String" RepeatDirection="Horizontal">

                                                    <Items>
                                                        <dxe:ListEditItem Text="Add" Value="A" />
                                                        <dxe:ListEditItem Text="Less" Value="L" />


                                                    </Items>
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                        <RequiredField ErrorText="Mandatory" IsRequired="true" />
                                                    </ValidationSettings>
                                                </dxe:ASPxRadioButtonList>

                                            </div>
                                        </div>
                                        <div class="clearfix">
                                            <div class="cityDiv col-md-4" style="margin-top: 7px">
                                                Applicable On
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">
                                                <dxe:ASPxComboBox ID="CmbTaxes_ApplicableOn" EnableIncrementalFiltering="True" ClientInstanceName="cCmbTaxes_ApplicableOn"
                                                    runat="server" ValueType="System.String" Width="180px" EnableSynchronization="True">
                                                    <ClientSideEvents ValueChanged="function(s,e){CmbTaxes_ApplicableOn_ValueChange()}"></ClientSideEvents>
                                                    <%--  <ClientSideEvents ValueChanged="function(s,e){OnCmbCountryName_ValueChange()}"></ClientSideEvents>--%>
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div id="divtxtTaxes_OtherTax" class="clearfix">
                                            <div class="cityDiv col-md-4" style="margin-top: 7px">
                                                Other Tax
                                            </div>
                                            <div class="Left_Content col-md-8 mBot10">
                                                <%-- <dxe:ASPxTextBox ID="txtTaxes_OtherTax" ClientInstanceName="ctxtTaxes_OtherTax" runat="server"
                                        onkeyup="FunCallAjaxList(this,event,'Digital')" Width="180px">
                                    </dxe:ASPxTextBox>--%>
                                                <%--<asp:TextBox ID="txtTaxes_OtherTax" Width="176px" runat="server" onkeyup="FunCallAjaxList(this,event,'Digital');"></asp:TextBox>
                                                <asp:TextBox ID="txtTaxes_OtherTax_hidden" runat="server" Width="100px" Style="display: none"></asp:TextBox>--%>
                                                <asp:ListBox ID="lstTaxes_OtherTax" CssClass="chsn" runat="server" Font-Size="12px" Width="180px" data-placeholder="Select..." onchange="changeFunc();"></asp:ListBox>
                                                <asp:HiddenField ID="hndTaxes_OtherTax_hidden" runat="server" />

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
                                        <div class="Footer text-center" style="padding-left: 70px;">

                                            <dxe:ASPxButton ID="btnSave_citys" ClientInstanceName="cbtnSave_citys" runat="server"
                                                Text="Save" CssClass="btn btn-primary" AutoPostBack="false">
                                                <ClientSideEvents Click="function (s, e) {btnSave_citys();}" />
                                            </dxe:ASPxButton>


                                            <dxe:ASPxButton ID="btnCancel_citys" runat="server" AutoPostBack="False" Text="Cancel" CssClass="btn btn-danger">
                                                <ClientSideEvents Click="function (s, e) {fn_btnCancel();}" />
                                            </dxe:ASPxButton>

                                            <br style="clear: both;" />
                                        </div>
                                        <br style="clear: both;" />
                                    </div>
                                    <%-- </div>--%>
                                </dxe:PopupControlContentControl>
                            </ContentCollection>
                            <HeaderStyle BackColor="LightGray" ForeColor="white" />
                        </dxe:ASPxPopupControl>
                        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
                        </dxe:ASPxGridViewExporter>
                    </div>
                </td>
            </tr>
            <div class="HiddenFieldArea" style="display: none;">
                <asp:HiddenField runat="server" ID="hiddenedit" />
            </div>
        </table>
    </div>
</asp:Content>

