<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TermsConditionsControl.ascx.cs" Inherits="ERP.OMS.Management.Activities.UserControls.TermsConditionsControl" %>

<head>
    <script src="/assests/pluggins/choosen/choosen.min.js"></script>
    <script type="text/javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode           
            if (charCode == 46)
                return true;
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
        function callTCControl(docID, docType) {
            ccallBackuserControlPanelMainTC.PerformCallback('TCtagging~' + docID + '~' + docType);
        }
        function callTCspecefiFields_PO(add_cntId) {
            ccallBackuserControlPanelMainTC.PerformCallback('TCspecefiFields_PO~' + add_cntId);
        }
        function componentEndCallBack(s, e) {

            SaveTermsConditionDataForTagging();
            //SaveTermsConditionData();
        }
        function SaveTermsConditionData() {

            //doctype, DeliveryDate, Delremarks, insuranceType, FreightCharges, FreightRemarks, PermitValue, Remarks, DelDetails, otherlocation, CertReq, trnsprtrname,
            //Discntrcv, Discntrcvdtls, CommissionRcv, CommissionRcvdtls
        

            if (($("#pnl_TCspecefiFields_Not_PO").is(":visible")) && cdtDeliveryDate.GetDate() == null) {
                jAlert("Delivery Schedule / Date is mandatory.");
                TermsConditionmodalShowHide(1);
                cdtDeliveryDate.SetFocus();
            }
            else if (($("#pnl_TCspecefiFields_Not_PO").is(":visible")) && ccmbDelDetails.GetValue() == 1 && ccmbtrnsprtrname.GetValue() == 0) {
                jAlert("Transporter Name(General) is mandatory.");
                TermsConditionmodalShowHide(1);
                ccmbtrnsprtrname.SetFocus();
            }
            else if (($("#pnl_TCspecefiFields_Not_PO").is(":visible")) && ccmbInsuranceType.GetValue() == null) {
                jAlert("Insurance Coverage is mandatory.");
                TermsConditionmodalShowHide(1);
                ccmbInsuranceType.SetFocus();
            }
            else if (($("#pnl_TCspecefiFields_Not_PO").is(":visible")) && ccmbFreightCharges.GetValue() == null) {
                jAlert("Freight Charges is mandatory.");
                TermsConditionmodalShowHide(1);
                ccmbFreightCharges.SetFocus();
            }
            else if (($("#pnl_TCspecefiFields_Not_PO").is(":visible")) && ccmbDelDetails.GetValue() == null) {
                jAlert("Delivery Details is mandatory.");
                TermsConditionmodalShowHide(1);
                ccmbDelDetails.SetFocus();
            }
            else {
                var jsDate = cdtDeliveryDate.GetDate();
                var myDate = new Date();
                if (jsDate != null) {
                    var year = jsDate.getFullYear(); // where getFullYear returns the year (four digits)
                    var month = jsDate.getMonth(); // where getMonth returns the month (from 0-11)
                    var day = jsDate.getDate();   // where getDate returns the day of the month (from 1-31)
                    myDate = new Date(year, month, day).toLocaleDateString('en-GB');
                }

                var jsDate1 = cdtValidityOfOrder.GetDate();
                var myDate1 = new Date();
                if (jsDate1 != null) {
                    var year = jsDate1.getFullYear(); // where getFullYear returns the year (four digits)
                    var month = jsDate1.getMonth(); // where getMonth returns the month (from 0-11)
                    var day = jsDate1.getDate();   // where getDate returns the day of the month (from 1-31)
                    myDate1 = new Date(year, month, day).toLocaleDateString('en-GB');
                }

                var data = $("#hfTermsConditionDocType").val() + '|'; //'SO|';1
                data += cdtDeliveryDate.GetDate() == null ? '@' + '|' : myDate + '|';//2
                data += $("#txtDelremarks").val() == null || $("#txtDelremarks").val() == '' ? '@' + '|' : $("#txtDelremarks").val() + '|';//3
                data += ccmbInsuranceType.GetValue() == null || ccmbInsuranceType.GetValue() == '' ? '@' + '|' : ccmbInsuranceType.GetValue() + '|';//4
                data += ccmbFreightCharges.GetValue() == null || ccmbFreightCharges.GetValue() == '' ? '@' + '|' : ccmbFreightCharges.GetValue() + '|';//5
                data += $("#txtFreightRemarks").val() == null || $("#txtFreightRemarks").val() == '' ? '@' + '|' : $("#txtFreightRemarks").val() + '|';//6
                data += ctxtPermitValue.GetText() == null || ctxtPermitValue.GetText() == '' ? '@' + '|' : ctxtPermitValue.GetText() + '|';//7
                data += $("#txtRemarks").val() == null || $("#txtRemarks").val() == '' ? '@' + '|' : $("#txtRemarks").val() + '|';//8
                data += ccmbDelDetails.GetValue() == null || ccmbDelDetails.GetValue() == '' ? '@' + '|' : ccmbDelDetails.GetValue() + '|';//9
                data += $("#txtotherlocation").val() == null || $("#txtotherlocation").val() == '' ? '@' + '|' : $("#txtotherlocation").val() + '|';//10
                data += ccmbCertReq.GetValue() == null || ccmbCertReq.GetValue() == '' ? '@' + '|' : ccmbCertReq.GetValue() + '|';//11
                data += ccmbtrnsprtrname.GetValue() == null || ccmbtrnsprtrname.GetValue() == '' ? '@' + '|' : ccmbtrnsprtrname.GetValue() + '|';//12
                data += ccmbDiscntrcv.GetValue() == null || ccmbDiscntrcv.GetValue() == '' ? '@' + '|' : ccmbDiscntrcv.GetValue() + '|';//13
                data += $("#txtDiscntrcv").val() == null || $("#txtDiscntrcv").val() == '' ? '@' + '|' : $("#txtDiscntrcv").val() + '|';//14
                data += ccmbCommissionRcv.GetValue() == null || ccmbCommissionRcv.GetValue() == '' ? '@' + '|' : ccmbCommissionRcv.GetValue() + '|';//15
                data += $("#txtCommissionRcv").val() == null || $("#txtCommissionRcv").val() == '' ? '@' + '|' : $("#txtCommissionRcv").val() + '|';//16

                data += cddlTypeOfImport.GetValue() == null || cddlTypeOfImport.GetValue() == '' ? '@' + '|' : cddlTypeOfImport.GetValue() + '|';//17
                data += $("#txtPaymentTrmRemarks").val() == null || $("#txtPaymentTrmRemarks").val() == '' ? '@' + '|' : $("#txtPaymentTrmRemarks").val() + '|';//18
                data += cddlIncoDVTerms.GetValue() == null || cddlIncoDVTerms.GetValue() == '' ? '@' + '|' : cddlIncoDVTerms.GetValue() + '|';//19
                data += $("#txtIncoDVTermsRemarks").val() == null || $("#txtIncoDVTermsRemarks").val() == '' ? '@' + '|' : $("#txtIncoDVTermsRemarks").val() + '|';//20
                data += $("#txtShippmentSchedule").val() == null || $("#txtShippmentSchedule").val() == '' ? '@' + '|' : $("#txtShippmentSchedule").val() + '|';//21
                data += $("#txtPortOfShippment").val() == null || $("#txtPortOfShippment").val() == '' ? '@' + '|' : $("#txtPortOfShippment").val() + '|';//22
                data += $("#txtPortOfDestination").val() == null || $("#txtPortOfDestination").val() == '' ? '@' + '|' : $("#txtPortOfDestination").val() + '|';//23
                data += cddlPartialShippment.GetValue() == null || cddlPartialShippment.GetValue() == '' ? '@' + '|' : cddlPartialShippment.GetValue() + '|';//24
                data += cddlTransshipment.GetValue() == null || cddlTransshipment.GetValue() == '' ? '@' + '|' : cddlTransshipment.GetValue() + '|';//25
                data += $("#txtPackingSpec").val() == null || $("#txtPackingSpec").val() == '' ? '@' + '|' : $("#txtPackingSpec").val() + '|';//26
                data += cdtValidityOfOrder.GetValue() == null ? '@' + '|' : myDate1 + '|';//27
                data += $("#txtValidityOfOrderRemarks").val() == null || $("#txtValidityOfOrderRemarks").val() == '' ? '@' + '|' : $("#txtValidityOfOrderRemarks").val() + '|';//28
                data += cddlCountryOfOrigin.GetValue() == null || cddlCountryOfOrigin.GetValue() == '' ? '@' + '|' : cddlCountryOfOrigin.GetValue() + '|';//29
                data += $("#txtFreeDetentionPeriod").val() == null || $("#txtFreeDetentionPeriod").val() == '' ? '@' + '|' : $("#txtFreeDetentionPeriod").val() + '|';//30
                data += $("#txtFreeDetentionPeriodRemark").val() == null || $("#txtFreeDetentionPeriodRemark").val() == '' ? '@' + '|' : $("#txtFreeDetentionPeriodRemark").val() + '|';//31
               
                data += $("#txtCommissionRate").val() == null || $("#txtCommissionRate").val() == '' ? '@' : $("#txtCommissionRate").val();//32
                $("#hfTermsConditionData").val(data);
                TermsConditionmodalShowHide(0);
            }
        }

        function SaveTermsConditionDataForTagging() {
            debugger;
            //doctype, DeliveryDate, Delremarks, insuranceType, FreightCharges, FreightRemarks, PermitValue, Remarks, DelDetails, otherlocation, CertReq, trnsprtrname,
            //Discntrcv, Discntrcvdtls, CommissionRcv, CommissionRcvdtls

            //if (cdtDeliveryDate.GetDate() == null) {
            //    jAlert("Delivery Schedule / Date is mandatory.");
            //    TermsConditionmodalShowHide(1);
            //}
            //else if (ccmbDelDetails.GetValue() == 1 && ccmbtrnsprtrname.GetValue() == 0) {
            //    jAlert("Transporter Name(General) is mandatory.");
            //    TermsConditionmodalShowHide(1);
            //}
            //else {
            if (cdtDeliveryDate.GetDate() != null) {
                var jsDate = cdtDeliveryDate.GetDate();
                var year = jsDate.getFullYear(); // where getFullYear returns the year (four digits)
                var month = jsDate.getMonth(); // where getMonth returns the month (from 0-11)
                var day = jsDate.getDate();   // where getDate returns the day of the month (from 1-31)
                var myDate = new Date(year, month, day).toLocaleDateString('en-GB');

                var data = $("#hfTermsConditionDocType").val() + '|'; //'SO|';
                data += cdtDeliveryDate.GetDate() == null ? '@' + '|' : myDate + '|';
                data += $("#txtDelremarks").val() == null || $("#txtDelremarks").val() == '' ? '@' + '|' : $("#txtDelremarks").val() + '|';
                data += ccmbInsuranceType.GetValue() == null || ccmbInsuranceType.GetValue() == '' ? '@' + '|' : ccmbInsuranceType.GetValue() + '|';
                data += ccmbFreightCharges.GetValue() == null || ccmbFreightCharges.GetValue() == '' ? '@' + '|' : ccmbFreightCharges.GetValue() + '|';
                data += $("#txtFreightRemarks").val() == null || $("#txtFreightRemarks").val() == '' ? '@' + '|' : $("#txtFreightRemarks").val() + '|';
                data += ctxtPermitValue.GetText() == null || ctxtPermitValue.GetText() == '' ? '@' + '|' : ctxtPermitValue.GetText() + '|';
                data += $("#txtRemarks").val() == null || $("#txtRemarks").val() == '' ? '@' + '|' : $("#txtRemarks").val() + '|';
                data += ccmbDelDetails.GetValue() == null || ccmbDelDetails.GetValue() == '' ? '@' + '|' : ccmbDelDetails.GetValue() + '|';
                data += $("#txtotherlocation").val() == null || $("#txtotherlocation").val() == '' ? '@' + '|' : $("#txtotherlocation").val() + '|';
                data += ccmbCertReq.GetValue() == null || ccmbCertReq.GetValue() == '' ? '@' + '|' : ccmbCertReq.GetValue() + '|';
                data += ccmbtrnsprtrname.GetValue() == null || ccmbtrnsprtrname.GetValue() == '' ? '@' + '|' : ccmbtrnsprtrname.GetValue() + '|';
                data += ccmbDiscntrcv.GetValue() == null || ccmbDiscntrcv.GetValue() == '' ? '@' + '|' : ccmbDiscntrcv.GetValue() + '|';
                data += $("#txtDiscntrcv").val() == null || $("#txtDiscntrcv").val() == '' ? '@' + '|' : $("#txtDiscntrcv").val() + '|';
                data += ccmbCommissionRcv.GetValue() == null || ccmbCommissionRcv.GetValue() == '' ? '@' + '|' : ccmbCommissionRcv.GetValue() + '|';
                data += $("#txtCommissionRcv").val() == null || $("#txtCommissionRcv").val() == '' ? '@' : $("#txtCommissionRcv").val();

                $("#hfTermsConditionData").val(data);
            }

            //TermsConditionmodalShowHide(0);
            //grid.batchEditApi.StartEdit(0, 5);
            //}
        }
        function calcelbuttonclick() {
            TermsConditionmodalShowHide(0);
            //clearTermsCondition();
        }
        function TermsConditionmodalShowHide(param) {

            switch (param) {
                case 0:
                    $('#TermsConditionseModal').modal('toggle');
                    break;
                case 1:
                    $('#TermsConditionseModal').modal({
                        show: 'true'
                    });
                    break;
            }

        }
        function clearTermsCondition() {

            cdtDeliveryDate.SetText('');
            $("#txtDelremarks").val('');
            ccmbInsuranceType.SetText('0');
            ccmbFreightCharges.SetText('0');
            $("#txtFreightRemarks").val('');
            ctxtPermitValue.SetText('');
            $("#txtRemarks").val('');
            ccmbDelDetails.SetText('');
            $("#txtotherlocation").val('');
            ccmbCertReq.SetText('');
            ccmbDiscntrcv.SetText('');
            $("#txtDiscntrcv").val('');
            ccmbCommissionRcv.SetText('');
            $("#txtCommissionRcv").val('');

            //New PO fields
            cddlTypeOfImport.SetText('');
            $("#txtPaymentTrmRemarks").val('');
            cddlIncoDVTerms.SetText('');
            $("#txtIncoDVTermsRemarks").val('');
            $("#txtShippmentSchedule").val('');
            $("#txtPortOfShippment").val('');
            $("#txtPortOfDestination").val('');
            cddlPartialShippment.SetText('');
            cddlTransshipment.SetText('');
            $("#txtPackingSpec").val('');
            cdtValidityOfOrder.SetText('');
            $("#txtValidityOfOrderRemarks").val('');
            cddlCountryOfOrigin.SetText('');
            $("#txtFreeDetentionPeriod").val('');
            $("#txtFreeDetentionPeriodRemark").val('');

        }
        function DiscountChanged(s) {
            var value = ccmbDiscntrcv.GetValue();

            if (value == 0) {
                $("#<%= pnlDiscntrcv.ClientID %>").show();
            }
            else {
                $("#<%= pnlDiscntrcv.ClientID %>").hide();
                $("#txtDiscntrcv").val('');
            }
        }
        function commissionChanged(s) {
            var value = ccmbCommissionRcv.GetValue();

            if (value == 0) {
                $("#<%= pnlCommissionRcv.ClientID %>").show();
            }
            else {
                $("#<%= pnlCommissionRcv.ClientID %>").hide();
                $("#txtCommissionRcv").val('');
            }
        }
        function DelivaryDetailsChanged(s) {
            var OL = ccmbDelDetails.GetValue();

            if (OL == 2) {
                ccmbInsuranceType.SetValue(1);
            }
            else {
                //ccmbInsuranceType.SetText('');
            }

            if (OL == 3) {
                $("#<%= pnlotherlocation.ClientID %>").show();
            }
            else {
                $("#<%= pnlotherlocation.ClientID %>").hide();
                $("#txtotherlocation").val('');
            }

            if (OL == 1) {
                $("#<%= pnlTransporter.ClientID %>").show();
                ccmbtrnsprtrname.SetValue(0);
            }
            else {
                $("#<%= pnlTransporter.ClientID %>").hide();
                ccmbtrnsprtrname.SetText('');
            }
        }

    </script>
</head>

<body>

    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#TermsConditionseModal" id="btn_TermsCondition">Term&#818;s and Conditions</button>

    <div class="modal fade" id="TermsConditionseModal" role="dialog" aria-labelledby="TermsConditionsModalLabel" data-backdrop="static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="TermsConditionsModalLabel">Terms and Conditions Details</h4>
                </div>
                <div class="modal-body">
                    <dxe:ASPxCallbackPanel runat="server" ID="callBackuserControlPanelMainTC" ClientInstanceName="ccallBackuserControlPanelMainTC" OnCallback="callBackuserControlPanelMainTC_Callback">
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <asp:HiddenField ID="hfTCspecefiFieldsVisibilityCheck" runat="server" Value="1" />  <%--if PO then 1 otherwise 0--%>
                                <asp:Panel runat="server" ID="pnl_TCspecefiFields_Not_PO">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Delivery Schedule / Date</label>
                                            <span style="color: red;">*</span>
                                            <dxe:ASPxDateEdit ID="dtDeliveryDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cdtDeliveryDate" Width="100%">
                                                <ButtonStyle Width="13px">
                                                </ButtonStyle>
                                            </dxe:ASPxDateEdit>
                                        </div>
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Delivery Remarks</label>
                                            <asp:TextBox runat="server" Width="100%" TextMode="MultiLine" ID="txtDelremarks">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Insurance Coverage</label>
                                            <span style="color: red;">*</span>
                                            <dxe:ASPxComboBox ID="cmbInsuranceType" runat="server" ClientInstanceName="ccmbInsuranceType" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="By us" Value="0" />
                                                    <dxe:ListEditItem Text="By Party" Value="1" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Freight Charges</label>
                                            <span style="color: red;">*</span>
                                            <dxe:ASPxComboBox ID="cmbFreightCharges" runat="server" ClientInstanceName="ccmbFreightCharges" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="By Us" Value="0" />
                                                    <dxe:ListEditItem Text="By Party" Value="1" />
                                                    <dxe:ListEditItem Text="Extra" Value="2" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Freight Remarks</label>
                                            <asp:TextBox ID="txtFreightRemarks" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">E-Permit/Way bill / Road Permit</label>
                                            <dxe:ASPxTextBox ID="txtPermitValue" runat="server" ClientInstanceName="ctxtPermitValue" Width="100%" Text="Not applicable">
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Other Remarks </label>
                                            <asp:TextBox ID="txtRemarks" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Test Certificate Required ?</label>
                                            <dxe:ASPxComboBox ID="cmbCertReq" runat="server" ClientInstanceName="ccmbCertReq" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="Yes" Value="0" />
                                                    <dxe:ListEditItem Text="No" Value="1" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Delivery Details</label>
                                            <span style="color: red;">*</span>
                                            <dxe:ASPxComboBox ID="cmbDelDetails" runat="server" ClientInstanceName="ccmbDelDetails" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="Local Delivery" Value="0" />
                                                    <dxe:ListEditItem Text="Nominated Transporter" Value="1" />
                                                    <dxe:ListEditItem Text="Material Collected by Party" Value="2" />
                                                    <dxe:ListEditItem Text="Other Location" Value="3" />
                                                </Items>
                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { DelivaryDetailsChanged(s); }"></ClientSideEvents>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <asp:Panel runat="server" ID="pnlotherlocation" Style="display: none;">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="recipient-name" class="control-label">Details</label>
                                                <asp:TextBox ID="txtotherlocation" runat="server" Width="100%" TextMode="MultiLine">
                                                </asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel runat="server" ID="pnlTransporter" Style="display: none;">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="recipient-name" class="control-label">Transporter Name(General)</label>
                                                <dxe:ASPxComboBox ID="cmbtrnsprtrname" runat="server" ClientInstanceName="ccmbtrnsprtrname" Width="100%" TextField="tr_name" ValueField="id">
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <div class="clear"></div>
                                    <asp:Panel runat="server" ID="pnlpurchasemodulefields" Style="display: none;">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="recipient-name" class="control-label">Any Discount Receivable</label>
                                                <dxe:ASPxComboBox ID="cmbDiscntrcv" runat="server" ClientInstanceName="ccmbDiscntrcv" Width="100%">
                                                    <ClearButton DisplayMode="Always"></ClearButton>
                                                    <Items>
                                                        <dxe:ListEditItem Text="Yes" Value="0" />
                                                        <dxe:ListEditItem Text="No" Value="1" />
                                                    </Items>
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) { DiscountChanged(s); }"></ClientSideEvents>
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>
                                        <asp:Panel runat="server" ID="pnlDiscntrcv" Style="display: none;">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="recipient-name" class="control-label">Discount Details</label>
                                                    <asp:TextBox ID="txtDiscntrcv" runat="server" Width="100%" TextMode="MultiLine">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                        <div class="clear"></div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="recipient-name" class="control-label">Any commission Receivable</label>
                                                <dxe:ASPxComboBox ID="cmbCommissionRcv" runat="server" ClientInstanceName="ccmbCommissionRcv" Width="100%">
                                                    <ClearButton DisplayMode="Always"></ClearButton>
                                                    <Items>
                                                        <dxe:ListEditItem Text="Yes" Value="0" />
                                                        <dxe:ListEditItem Text="No" Value="1" />
                                                    </Items>
                                                    <ClientSideEvents SelectedIndexChanged="function(s, e) { commissionChanged(s); }"></ClientSideEvents>
                                                </dxe:ASPxComboBox>
                                            </div>
                                        </div>
                                        <asp:Panel runat="server" ID="pnlCommissionRcv" Style="display: none;">
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="recipient-name" class="control-label">commission Details</label>
                                                    <asp:TextBox ID="txtCommissionRcv" runat="server" Width="100%" TextMode="MultiLine">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                             <div class="col-md-4">
                                                <div class="form-group">
                                                    <label for="commission-rate" class="control-label">commission Rate</label>
                                                    <asp:TextBox ID="txtCommissionRate" runat="server" Width="100%" Text="0.0"  onkeypress="return isNumberKey(event)" >
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </asp:Panel>
                                    <div class="clear"></div>
                                </asp:Panel>
                                <asp:Panel runat="server" ID="pnl_TCspecefiFields_PO" Style="display: none;">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Type of Import</label>
                                            <dxe:ASPxComboBox ID="ddlTypeOfImport" runat="server" ClientInstanceName="cddlTypeOfImport" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="Direct Import" Value="0" />
                                                    <dxe:ListEditItem Text="Import DA –Bank through" Value="1" />
                                                    <dxe:ListEditItem Text="Import against LC/SBLC" Value="2" />
                                                    <dxe:ListEditItem Text="Import HSS" Value="3" />
                                                    <dxe:ListEditItem Text="Import for Direct Sale" Value="4" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Payment Term Remarks</label>
                                            <asp:TextBox ID="txtPaymentTrmRemarks" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Inco term (Delivery Term)</label>
                                            <dxe:ASPxComboBox ID="ddlIncoDVTerms" runat="server" ClientInstanceName="cddlIncoDVTerms" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="EXW (‘Ex Works’)" Value="0" />
                                                    <dxe:ListEditItem Text="FCA (‘Free Carrier’)" Value="1" />
                                                    <dxe:ListEditItem Text="CPT (‘Carriage Paid To’)" Value="2" />
                                                    <dxe:ListEditItem Text="CIP (‘Carriage and Insurance Paid’)" Value="3" />
                                                    <dxe:ListEditItem Text="DAT (‘Delivered at Terminal’)" Value="4" />
                                                    <dxe:ListEditItem Text="DAP (‘Delivered at Place’)" Value="5" />
                                                    <dxe:ListEditItem Text="DDP/DTP (‘Delivered Duty Paid’)" Value="6" />
                                                    <dxe:ListEditItem Text="FAS (‘Free Alongside Ship’)" Value="7" />
                                                    <dxe:ListEditItem Text="FOB (‘Free on Board’)" Value="8" />
                                                    <dxe:ListEditItem Text="CFR (‘Cost and Freight’)" Value="9" />
                                                    <dxe:ListEditItem Text="CIF (‘Cost, Insurance and Freight’)" Value="10" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Inco term (Delivery Term) Remarks</label>
                                            <asp:TextBox ID="txtIncoDVTermsRemarks" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Shipment Schedule</label>
                                            <asp:TextBox ID="txtShippmentSchedule" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Port of Shipment</label>
                                            <asp:TextBox ID="txtPortOfShippment" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Port of Destination</label>
                                            <asp:TextBox ID="txtPortOfDestination" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Partial Shipment</label>
                                            <dxe:ASPxComboBox ID="ddlPartialShippment" runat="server" ClientInstanceName="cddlPartialShippment" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="Allowed" Value="1" />
                                                    <dxe:ListEditItem Text=" Not Allowed" Value="0" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Trans Shipment</label>
                                            <dxe:ASPxComboBox ID="ddlTransshipment" runat="server" ClientInstanceName="cddlTransshipment" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                <Items>
                                                    <dxe:ListEditItem Text="Allowed" Value="1" />
                                                    <dxe:ListEditItem Text=" Not Allowed" Value="0" />
                                                </Items>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Packing Specification</label>
                                            <asp:TextBox ID="txtPackingSpec" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Validity of Order</label>
                                            <dxe:ASPxDateEdit ID="dtValidityOfOrder" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="cdtValidityOfOrder" Width="100%">
                                                <ButtonStyle Width="13px">
                                                </ButtonStyle>
                                            </dxe:ASPxDateEdit>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Validity of Order Remarks</label>
                                            <asp:TextBox ID="txtValidityOfOrderRemarks" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Country of Origin</label>
                                            <dxe:ASPxComboBox ID="ddlCountryOfOrigin" runat="server" ClientInstanceName="cddlCountryOfOrigin" Width="100%">
                                                <ClearButton DisplayMode="Always"></ClearButton>
                                            </dxe:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Free Detention Period</label>
                                            <asp:TextBox ID="txtFreeDetentionPeriod" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="recipient-name" class="control-label">Free Detention Period Remarks</label>
                                            <asp:TextBox ID="txtFreeDetentionPeriodRemark" runat="server" Width="100%" TextMode="MultiLine">
                                            </asp:TextBox>
                                        </div>
                                    </div>
                                </asp:Panel>
                                <div class="clear"></div>
                                <div class="text-center" style="text-align: center !important">
                                    <dxe:ASPxButton ID="btnTCsave" ClientInstanceName="cbtnTCsave" runat="server" AutoPostBack="False" Text="Save&#818;" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                        <ClientSideEvents Click="function(s, e) {SaveTermsConditionData();}" />
                                    </dxe:ASPxButton>
                                    <dxe:ASPxButton ID="btnTCcancel" ClientInstanceName="cbtnTCcancel" runat="server" AutoPostBack="False" Text="Cancel&#818;" CssClass="btn btn-danger" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                        <ClientSideEvents Click="function(s, e) {calcelbuttonclick();}" />
                                    </dxe:ASPxButton>
                                </div>
                            </dxe:PanelContent>
                        </PanelCollection>
                        <ClientSideEvents EndCallback="componentEndCallBack" />
                    </dxe:ASPxCallbackPanel>
                </div>
            </div>
        </div>
    </div>

</body>
