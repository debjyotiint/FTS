﻿<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="ConsolidatedVendor.aspx.cs" Inherits="OpeningEntry.ERP.ConsolidatedVendor" EnableEventValidation="false" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .inline {
            display: inline !important;
        }

        .dxtcLite_PlasticBlue.dxtc-top > .dxtc-content {
            overflow: visible !important;
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

        #gridReplacement_DXStatus span > a {
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

        #DivBilling [class^="col-md"], #DivShipping [class^="col-md"] {
            padding-top: 5px;
            padding-bottom: 5px;
        }

        #tbldescripion > tbody > tr > td, #tbldescripion2 > tbody > tr > td {
            padding-right: 15px;
        }

        .dxeErrorFrameSys.dxeErrorCellSys {
            position: absolute;
        }
    </style>

    <script>


        function Callback_EndCallback() {

            // alert('');
            $("#ddldetails").val(0);
        }


        function GetContactPerson(e) {

            var key = gridLookup.GetGridView().GetRowKey(gridLookup.GetGridView().GetFocusedRowIndex());
            if (key != null && key != '') {

                //     cContactPerson.PerformCallback('BindContactPerson~' + key);

            }
        }
        $(function () {


            $("#ddl_Branch").focus();
            TypeCheck();

            if ($("#hdncus").val() == "1") {

                $("#divgrid").attr('style', 'display:block');
            }

            else {
                $("#divgrid").attr('style', 'display:none');

            }

            $("#ddltype").on('change', function () {
                TypeCheck();

            })

            if ($("#hiddnmodid").val() != "0") {

                $("#tbldescripion").attr('style', 'display:none');
                $("#tbldescripion2").attr('style', 'display:none');
            }
        });
        function TypeCheck() {

            if ($("#ddltype").val() == "PB" || $("#ddltype").val() == "RET") {
                $("#tbldescripion").removeAttr('style');
                $("#tblconsolidatevendor").attr('style', 'display:none');
                $("#tbldescripion2").attr('style', 'display:none');

            }
            else if ($("#ddltype").val() == "CDB" || $("#ddltype").val() == "CCR") {

                $("#tbldescripion").attr('style', 'display:none');
                $("#tbldescripion2").attr('style', 'display:none');
                $("#tblconsolidatevendor").removeAttr('style');

            }


            else {
                $("#tbldescripion").attr('style', 'display:none');
                $("#tblconsolidatevendor").attr('style', 'display:none');
                $("#tbldescripion2").removeAttr('style');
            }


        }



        function saveClientClick(s, e) {

            if (gridLookup.GetValue() == null) {

                jAlert('Vendor is mandatory', "Alert", function () {


                    gridLookup.Focus();
                    gridLookup.ShowDropDown();
                });
            }

            else {

                if ($("#ddltype").val() == "PB" || $("#ddltype").val() == "RET") {

                    if (ctxt_doccno.GetText() == '') {

                        jAlert('Doc Number is mandatory', "Alert", function () {


                            ctxt_doccno.Focus();
                        });
                    }
                    else if (tsdate.GetText() == '') {

                        jAlert('Doc Date is mandatory', "Alert", function () {

                            tsdate.Focus();

                        });
                    }
                    else if (ctxt_docamt.GetText() == '' || ctxt_docamt.GetText() == '0.00') {

                        jAlert('O/S Amount is mandatory', "Alert", function () {

                            ctxt_docamt.Focus();

                        });
                    }
                        //else {
                        //    submitFunc();
                        //}

                    else {
                        if (ctxt_disamt.GetText() == '' || ctxt_disamt.GetText() == '0.00') {

                            submitFunc();
                        }
                        else if (parseFloat(ctxt_docamt.GetText()) > parseFloat(ctxt_disamt.GetText())) {

                            jAlert('O/S must be less than or equal than Document amount', "Alert", function () {

                                ctxt_disamt.Focus();

                            });

                        }

                        else {
                            submitFunc();

                        }

                    }
                }

                else if ($("#ddltype").val() == "CDB" || $("#ddltype").val() == "CCR") {

                    if (dt_vendor.GetText() == '') {

                        jAlert('Date is mandatory', "Alert", function () {
                            dt_vendor.Focus();

                        });
                    }
                    else if (ctxt_vendor_amt.GetText() == '' || ctxt_vendor_amt.GetText() == '0.00') {

                        jAlert('Amount is mandatory', "Alert", function () {

                            ctxt_vendor_amt.Focus();
                        });
                    }
                    else {
                        submitFunc();

                    }
                }

                else {

                    if (ctxt_doccno2.GetText() == '') {

                        jAlert('Doc Number is mandatory', "Alert", function () {
                            ctxt_doccno2.Focus();
                        });
                    }
                    else if (tsdate2.GetText() == '') {

                        jAlert('Doc Date is mandatory', "Alert", function () {
                            tsdate2.Focus();


                        });
                    }
                    else if (ctxt_docamt2.GetText() == '' || ctxt_docamt2.GetText() == '0.00') {

                        jAlert('Amount is mandatory', "Alert", function () {


                            ctxt_docamt2.Focus();
                        });
                    }
                    else {
                        submitFunc();

                    }

                }
            }
        }


        function submitFunc() {

            if ($("#hiddnmodid").val() == "0") {
                cOpeningGrid.PerformCallback('TemporaryData~' + 0);
            }
            else {
                var mod = $("#hiddnmodid").val();
                cOpeningGrid.PerformCallback('ModifyData~' + mod);

                cOpeningGrid.PerformCallback('Display~' + 0);
            }
        }



        function OnClickDelete(keyValue, OSAmount, Unpaidamt) {
            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    if (parseFloat(OSAmount) != parseFloat(Unpaidamt)) {
                        // alert();
                        jAlert('Already this document was used');

                    }
                    else {
                        cOpeningGrid.PerformCallback('Delete~' + keyValue);
                        cOpeningGrid.PerformCallback('Display~' + 0);
                    }

                }
            });
        }

        function ClearData(s, e) {

            $("#tbldescripion").attr('style', 'display:none');
            $("#tbldescripion2").attr('style', 'display:none');
            if (cOpeningGrid.cpSaveSuccessOrFail == "Success") {

                ctxt_doccno.SetText('');
                tsdate.SetText('');

                tstartdate.SetText('');
                ctxt_fullbill.SetText('');
                trefdate.SetText('');
                ctxt_docamt.SetText('');
                ctxt_disamt.SetText('');
                ctxt_commprcntg.SetText('');
                ctxt_commAmt.SetText('');


                ctxt_doccno2.SetText('');
                tsdate2.SetText('');
                ctxt_docamt2.SetText('');
                ctxt_commprcntg2.SetText('');
                ctxt_commAmt2.SetText('');



                dt_vendor.SetText('');
                ctxt_vendor_amt.SetText('');

                jAlert('Saved Successfully');
                TypeCheck();

            }
            else if (cOpeningGrid.cpSaveSuccessOrFail == "Duplicate") {

                ctxt_doccno.SetText('');
                ctxt_doccno2.SetText('');
                jAlert('Duplicate Document Number');
                TypeCheck();
            }
            // cOpeningGrid.Refrsh();


            //  alert();




        }
        function fn_AllowonlyNumeric(s, e) {
            var theEvent = e.htmlEvent || window.event;
            var key = theEvent.keyCode || theEvent.which;

            var txt = s.GetText();

            if (key != 8 || key != 13) txt += String.fromCharCode(key);

            var regex = /^[0-9]*\.?[0-9]*$/;
            if (!regex.test(txt)) {
                theEvent.returnValue = false;
                if (theEvent.preventDefault) theEvent.preventDefault();
            }
        }

        function onOpeningEdit(mod, cus, type, brnch, DocNumber, Date, FullBill, DueDate, RefDate, DocAmount, OSAmount, Commper, Commamount, Unpaidamt) {

            $("#hiddnmodid").val(mod);
            $("#ddl_Branch").val(brnch);
            $("#ddltype").val(type);

            // gridLookup.SetValue(cus)

            cQuotationComponentPanel.PerformCallback('Fetch~' + cus);

            if ($("#ddltype").val() == "PB" || $("#ddltype").val() == "RET") {
                $("#tbldescripion").removeAttr('style');
                $("#tbldescripion2").attr('style', 'display:none');

                ctxt_doccno.SetText(DocNumber);
                tsdate.SetText(Date);

                tstartdate.SetText(DueDate);
                ctxt_fullbill.SetText(FullBill);
                trefdate.SetText(RefDate);
                ctxt_docamt.SetText(OSAmount);
                ctxt_disamt.SetText(DocAmount);
                ctxt_commprcntg.SetText(Commper);
                ctxt_commAmt.SetText(Commamount);


            }

            else if ($("#ddltype").val() == "CDB" || $("#ddltype").val() == "CCR")  {

                $("#tbldescripion").attr('style', 'display:none');
                $("#tbldescripion2").attr('style', 'display:none');
                $("#tblconsolidatevendor").removeAttr('style');
                
               
                dt_vendor.SetText(Date);
                ctxt_vendor_amt.SetText(OSAmount);
              
            }



            else {

                $("#tbldescripion").attr('style', 'display:none');
                $("#tbldescripion2").removeAttr('style');


                ctxt_doccno2.SetText(DocNumber);
                tsdate2.SetText(Date);
                ctxt_docamt2.SetText(OSAmount);
                ctxt_commprcntg2.SetText(Commper);
                ctxt_commAmt2.SetText(Commamount);
            }


            if (parseFloat(OSAmount) != parseFloat(Unpaidamt)) {
                $("#FinalSave").attr('style', 'display:none;');

            }
            else {
                $("#FinalSave").attr('style', 'display:inline-block;');

            }
        }

        function CloseGridLookup() {
            gridLookup.ConfirmCurrentSelection();
            gridLookup.HideDropDown();
            gridLookup.Focus();
        }


        $(function ()
        {
            cQuotationComponentPanel.PerformCallback('Fetch' + '~' + $("#ddl_Branch").val());

            $('body').on('change', '#ddl_Branch', function () {

                cQuotationComponentPanel.PerformCallback('Fetch' + '~' + $("#ddl_Branch").val());
            });
            
        });

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="pull-left">Consolidated  Vendor</h3>
            <div id="pageheaderContent" class=" pull-right wrapHolder content horizontal-images" style="display: none;">
                <ul>
                    <li>
                        <div class="lblHolder">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>Total Debit</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dxe:ASPxLabel ID="lblTotDebit" runat="server" Text="ASPxLabel" ClientInstanceName="clblTotDebit"></dxe:ASPxLabel>
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
                                        <td>Total Credit</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dxe:ASPxLabel ID="lblTotCredit" runat="server" Text="ASPxLabel" ClientInstanceName="clblTotCredit"></dxe:ASPxLabel>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="crossBtn"><a href="./ConsolidatedVendorList.aspx"><i class="fa fa-times"></i></a></div>
    </div>
    <div class="form_main">



        <table id="salepurchaseret">


            <tr>
                <td>Branch <span class="red">*</span></td>
                <td>Vendor <span class="red">*</span></td>
                <td>Type <span class="red">*</span></td>


            </tr>



            <tr>

                <td style="padding-right: 25px; min-width: 250px" class="relative">
                    <asp:DropDownList ID="ddl_Branch" runat="server" Width="100%" TabIndex="1">
                    </asp:DropDownList>
                    <span id="MandatoryBranch" class="pullleftClass fa fa-exclamation-circle iconRed " style="color: red; display: none; padding-left: 9px;"
                        title="Mandatory"></span>
                </td>


                <td style="padding-right: 25px; width: 271px" class="relative">

                    <dxe:ASPxCallbackPanel runat="server" ID="ComponentQuotationPanel" ClientInstanceName="cQuotationComponentPanel" OnCallback="ComponentQuotation_Callback">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <dxe:ASPxGridLookup ID="lookup_Customer" runat="server" TabIndex="2" ClientInstanceName="gridLookup"     OnDataBinding="lookup_vendor_DataBinding"
                                    KeyFieldName="cnt_internalid" Width="100%" TextFormatString="{1}" AutoGenerateColumns="False" >
                                    <Columns>
                                        <dxe:GridViewDataColumn FieldName="shortname" Visible="true" VisibleIndex="0" Caption="Short Name" Width="200px" Settings-AutoFilterCondition="Contains">
                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>
                                        <dxe:GridViewDataColumn FieldName="Name" Visible="true" VisibleIndex="1" Caption="Name" Settings-AutoFilterCondition="Contains" Width="200px">

                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>
                                        <dxe:GridViewDataColumn FieldName="Type" Visible="true" VisibleIndex="2" Caption="Type" Settings-AutoFilterCondition="Contains" Width="200px">

                                            <Settings AutoFilterCondition="Contains" />
                                        </dxe:GridViewDataColumn>
                                        <dxe:GridViewDataColumn FieldName="cnt_internalid" Visible="false" VisibleIndex="3" Settings-AllowAutoFilter="False" Width="200px">
                                            <Settings AllowAutoFilter="False"></Settings>
                                        </dxe:GridViewDataColumn>
                                    </Columns>
                                    <GridViewProperties Settings-VerticalScrollBarMode="Auto">
                                        <Templates>
                                            <StatusBar>
                                                <table class="OptionsTable" style="float: right">
                                                    <tr>
                                                        <td>
                                                            <dxe:ASPxButton ID="Close" runat="server" AutoPostBack="false" Text="Close" ClientSideEvents-Click="CloseGridLookup" UseSubmitBehavior="False" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </StatusBar>
                                        </Templates>
                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                        <SettingsLoadingPanel Text="Please Wait..." />
                                        <Settings ShowFilterRow="True" ShowStatusBar="Visible" UseFixedTableLayout="true" />
                                    </GridViewProperties>
                                    <ClientSideEvents TextChanged="function(s, e) { GetContactPerson(e)}" />
                                    <ClearButton DisplayMode="Auto">
                                    </ClearButton>
                                </dxe:ASPxGridLookup>
                            </dxe:PanelContent>
                        </PanelCollection>
                    </dxe:ASPxCallbackPanel>

                    <span id="MandatoryAccount" class="pullleftClass fa fa-exclamation-circle iconRed " style="color: red; display: none; padding-left: 9px;" title="Mandatory"></span>
                </td>


                <td style="padding-right: 25px; min-width: 250px" class="relative">
                    <asp:DropDownList ID="ddltype" runat="server" Width="100%" TabIndex="3">
                        <asp:ListItem Text="Purchase Bill" Value="PB"></asp:ListItem>
                        <asp:ListItem Text="Advance" Value="ADV"></asp:ListItem>
                        <asp:ListItem Text="Debit Note" Value="DN"></asp:ListItem>
                        <asp:ListItem Text="Credit Note" Value="CN"></asp:ListItem>
                        <asp:ListItem Text="Return" Value="RET"></asp:ListItem>
                        <asp:ListItem Text="Consolidated Debit" Value="CDB"></asp:ListItem>
                        <asp:ListItem Text="Consolidated Credit" Value="CCR"></asp:ListItem>
                    </asp:DropDownList>
                </td>


            </tr>

            <tr>
            </tr>

        </table>
        <div id="divsaleretu" runat="server">
            <table id="tbldescripion" style="display: none;">

                <tr>
                    <td>Doc Number <span class="red">*</span></td>
                    <td>Date <span class="red">*</span></td>

                    <td>Due Date</td>
                    <td>Ref Date</td>

                </tr>
                <tr>
                    <td>
                        <dxe:ASPxTextBox ID="txt_Docno" runat="server" ClientInstanceName="ctxt_doccno" TabIndex="4" Width="100%">
                        </dxe:ASPxTextBox>

                    </td>
                    <td>
                        <dxe:ASPxDateEdit ID="dt_date" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="tsdate" TabIndex="5" Width="100%">
                            <ButtonStyle Width="13px">
                            </ButtonStyle>

                        </dxe:ASPxDateEdit>


                    </td>
                    <td class="hide">
                        <dxe:ASPxTextBox ID="txt_fullbill" runat="server" ClientInstanceName="ctxt_fullbill" Width="100%">
                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>


                    </td>
                    <td>
                        <dxe:ASPxDateEdit ID="dtdate_Due" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="tstartdate" TabIndex="7" Width="100%">
                            <ButtonStyle Width="13px">
                            </ButtonStyle>

                        </dxe:ASPxDateEdit>


                    </td>
                    <td>
                        <dxe:ASPxDateEdit ID="dtdate_Ref" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="trefdate" TabIndex="8" Width="100%">
                            <ButtonStyle Width="13px">
                            </ButtonStyle>

                        </dxe:ASPxDateEdit>


                    </td>

                </tr>


                <tr>


                    <td>Doc Amount</td>
                    <td>O/S Amount <span class="red">*</span> </td>
                    <td></td>

                </tr>

                <tr>
                    <td>
                        <dxe:ASPxTextBox ID="txt_disamt" runat="server" ClientInstanceName="ctxt_disamt" TabIndex="9" Width="100%">

                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>


                    </td>

                    <td>


                        <dxe:ASPxTextBox ID="txt_docamt" runat="server" ClientInstanceName="ctxt_docamt" TabIndex="10" Width="100%">

                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>


                    </td>

                    <td></td>

                </tr>

                <tr>

                    <td>Comm%</td>
                    <td>Commm Amount</td>

                </tr>

                <tr>

                    <td>
                        <dxe:ASPxTextBox ID="txt_commprcntg" runat="server" ClientInstanceName="ctxt_commprcntg" TabIndex="11" Width="100%">

                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>

                    </td>
                    <td>

                        <dxe:ASPxTextBox ID="txt_commAmt" runat="server" ClientInstanceName="ctxt_commAmt" TabIndex="12" Width="100%">
                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>

                    </td>
                    <td style="width: 230px"></td>
                </tr>

            </table>

        </div>

        <div id="divadvanddebitcredit" runat="server">
            <table id="tbldescripion2" style="display: none;">

                <tr>
                    <td>Doc Number <span class="red">*</span> </td>
                    <td>Date <span class="red">*</span> </td>
                    <td>Amount <span class="red">*</span> </td>
                    <td>Comm %</td>
                    <td>Comm Amount</td>

                </tr>
                <tr>
                    <td>
                        <dxe:ASPxTextBox ID="txt_Docno2" runat="server" ClientInstanceName="ctxt_doccno2" TabIndex="13" Width="100%">
                        </dxe:ASPxTextBox>

                    </td>

                    <td>

                        <dxe:ASPxDateEdit ID="dt_date2" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="tsdate2" TabIndex="14" Width="100%">
                            <ButtonStyle Width="13px">
                            </ButtonStyle>

                        </dxe:ASPxDateEdit>
                    </td>

                    <td>

                        <dxe:ASPxTextBox ID="txt_docamt2" runat="server" ClientInstanceName="ctxt_docamt2" TabIndex="15" Width="100%">

                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>
                    </td>
                    <td>
                        <dxe:ASPxTextBox ID="txt_commprcntg2" runat="server" ClientInstanceName="ctxt_commprcntg2" TabIndex="16" Width="100%">

                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>

                    </td>
                    <td>

                        <dxe:ASPxTextBox ID="txt_commAmt2" runat="server" ClientInstanceName="ctxt_commAmt2" TabIndex="17" Width="100%">

                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>

                    </td>

                </tr>
            </table>

        </div>


        <div id="divconsolidate" runat="server">
            <table id="tblconsolidatevendor" style="display: none;">

                <tr>

                    <td>Date <span class="red">*</span> </td>
                    <td>Amount <span class="red">*</span> </td>

                </tr>
                <tr>

                    <td>

                        <dxe:ASPxDateEdit ID="dt_vendor" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="dt_vendor" Width="100%">
                            <ButtonStyle Width="13px">
                            </ButtonStyle>
                        </dxe:ASPxDateEdit>
                    </td>

                    <td>

                        <dxe:ASPxTextBox ID="txt_vendor_amt" runat="server" ClientInstanceName="ctxt_vendor_amt" Width="100%">
                            <ClientSideEvents KeyPress="function(s,e){ fn_AllowonlyNumeric(s,e);}" />
                            <MaskSettings Mask="<0..999999999>.<00..99>" AllowMouseWheel="false" />
                        </dxe:ASPxTextBox>

                    </td>


                </tr>
            </table>
        </div>


        <div style="padding-top: 15px;">
            <dxe:ASPxButton ID="FinalSave" runat="server" AutoPostBack="false" CssClass="btn btn-primary"
                Text="<u>S</u>ave" ClientInstanceName="cFinalSave" VerticalAlign="Bottom" EncodeHtml="false" TabIndex="18">
                <ClientSideEvents Click="saveClientClick" />
            </dxe:ASPxButton>
        </div>
        <div class="GridViewArea" id="divgrid">


            <asp:DropDownList ID="ddldetails" runat="server" CssClass="btn btn-sm btn-primary" Style="float: right; margin-right: 2px !important;"
                OnSelectedIndexChanged="cmbExport2_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem Value="0">Export to</asp:ListItem>
                <asp:ListItem Value="1">PDF</asp:ListItem>
                <asp:ListItem Value="2">XLS</asp:ListItem>
                <asp:ListItem Value="3">RTF</asp:ListItem>
                <asp:ListItem Value="4">CSV</asp:ListItem>
            </asp:DropDownList>



            <dxe:ASPxGridView ID="OpeningGrid" runat="server" AutoGenerateColumns="False" ClientInstanceName="cOpeningGrid"
                OnCustomCallback="OpeningGrid_CustomCallback" OnDataBinding="grid_DataBinding" KeyField="ModId" ClientSideEvents-BeginCallback="Callback_EndCallback"
                SettingsPager-Mode="ShowAllRecords" Settings-VerticalScrollBarMode="Auto" Settings-VerticalScrollableHeight="350"
                Width="100%" Settings-HorizontalScrollBarMode="Visible">

                <Settings ShowGroupPanel="false" ShowStatusBar="Hidden" ShowFilterRow="true" ShowFilterRowMenu="True" />
                <Columns>

                    <dxe:GridViewDataTextColumn Caption="Branch" FieldName="Branch" ReadOnly="True" Visible="True" VisibleIndex="0">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                    <dxe:GridViewDataTextColumn Caption="Vendor Name" FieldName="Customer" ReadOnly="True" Visible="True" VisibleIndex="1">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                    <dxe:GridViewDataTextColumn Caption="Type" FieldName="TypeName" ReadOnly="True" Visible="True" VisibleIndex="2">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                    <dxe:GridViewDataTextColumn Caption="Document Number" FieldName="DocNumber" ReadOnly="True" Visible="True" VisibleIndex="3">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="Date" FieldName="Date" ReadOnly="True" Visible="True" VisibleIndex="4">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="Full Bill Amount" FieldName="FullBill" ReadOnly="True" Visible="False" VisibleIndex="5">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                    <dxe:GridViewDataTextColumn Caption="Due Date" FieldName="DueDate" ReadOnly="True" Visible="True" VisibleIndex="6">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                    <dxe:GridViewDataTextColumn Caption="Ref Date" FieldName="RefDate" ReadOnly="True" Visible="True" VisibleIndex="7">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="Doc Amount" FieldName="DocAmount" ReadOnly="True" Visible="True" VisibleIndex="8">
                        <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="OS Amount" FieldName="OSAmount" ReadOnly="True" Visible="True" VisibleIndex="9">
                        <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>






                    <dxe:GridViewDataTextColumn Caption="Comm %" FieldName="Commper" ReadOnly="True" Visible="True" VisibleIndex="10">
                        <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="Comm Amount" FieldName="Commamount" ReadOnly="True" Visible="True" VisibleIndex="11">
                        <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="Type" FieldName="Type" ReadOnly="True" Visible="False" VisibleIndex="11">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="Unpaid Amount" FieldName="Unpaidamt" ReadOnly="True" Visible="True" VisibleIndex="13">
                        <PropertiesTextEdit DisplayFormatString="0.00"></PropertiesTextEdit>
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>


                    <dxe:GridViewDataTextColumn Caption="Type" FieldName="Branch" ReadOnly="True" Visible="False" VisibleIndex="14">
                        <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                    <dxe:GridViewDataTextColumn ReadOnly="True" CellStyle-HorizontalAlign="Center" VisibleIndex="15">
                        <HeaderStyle HorizontalAlign="Center" />


                        <CellStyle HorizontalAlign="Center"></CellStyle>
                        <HeaderTemplate>
                            Actions
                        </HeaderTemplate>
                        <DataItemTemplate>

                            <% if (rights.CanEdit)
                               { %>
                            <a href="javascript:void(0);" onclick="onOpeningEdit('<%#Eval("ModId")%>','<%#Eval("CustomerId")%>',
                                '<%#Eval("Type")%>','<%#Eval("branch_id")%>','<%#Eval("DocNumber")%>','<%#Eval("Date")%>',
                                '<%#Eval("FullBill")%>','<%#Eval("DueDate")%>','<%#Eval("RefDate")%>','<%#Eval("DocAmount")%>','<%#Eval("OSAmount")%>','<%#Eval("Commper")%>','<%#Eval("Commamount")%>','<%#Eval("Unpaidamt")%>'
                                )"
                                title="Edit" class="pad">
                                <img src="/assests/images/Edit.png" /></a>



                            <% } %>
                            <% if (rights.CanDelete)
                               { %>
                            <a href="javascript:void(0);" onclick="OnClickDelete('<%#Eval("ModId")%>','<%#Eval("OSAmount")%>','<%#Eval("Unpaidamt")%>')" title="Edit" class="pad">
                                <img src="/assests/images/Delete.png" /></a>

                            <% } %>
                        </DataItemTemplate>
                    </dxe:GridViewDataTextColumn>

                </Columns>
                <SettingsPager PageSize="10">
                    <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                </SettingsPager>
                <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                <SettingsBehavior ColumnResizeMode="NextColumn" />
                <ClientSideEvents EndCallback="ClearData" />
            </dxe:ASPxGridView>
        </div>
        <div class="clear"></div>
        <div style="padding-top: 10px;">
        </div>


        <div class="clear"></div>
        <div class="">
        </div>


    </div>



    <asp:SqlDataSource runat="server" ID="dsCustomer" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="Proc_Opening_VendorConsolidate" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter Type="String" Name="Action" DefaultValue="Customerbind" />
        </SelectParameters>
    </asp:SqlDataSource>

    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>
    <asp:HiddenField runat="server" ID="hdncus" />
    <asp:HiddenField runat="server" ID="hiddnmodid" />
</asp:Content>
