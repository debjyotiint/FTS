﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerDelivery.aspx.cs" MasterPageFile="~/OMS/MasterPage/ERP.Master"
    Inherits="ERP.OMS.Management.Activities.CustomerDelivery" EnableEventValidation="false" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style type="text/css">
        .inline {
            display: inline !important;
        }

        .dxtcLite_PlasticBlue.dxtc-top > .dxtc-content {
            overflow: visible !important;
        }

        .dxeDisabled_PlasticBlue, .aspNetDisabled {
            opacity: 1.5;
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

        .validclass {
            position: absolute;
            right: -4px;
            top: 24px;
        }

        .mandt {
            position: absolute;
            right: -18px;
            top: 4px;
        }
    </style>

    <style>
        .dxeErrorFrameSys.dxeErrorCellSys {
            position: absolute;
        }

        .dxeButtonEditClearButton_PlasticBlue {
            display: none;
        }

        #txt_Rate {
            min-height: 24px;
        }

        .col-md-3 > label {
            margin-bottom: 3px;
            margin-top: 0;
            display: block;
        }

        .mTop {
            margin-top: 10px;
            padding: 5px 20px;
        }

        #DivBilling [class^="col-md"], #DivShipping [class^="col-md"] {
            padding-top: 5px;
            padding-bottom: 5px;
        }

        #grid_DXMainTable > tbody > tr > td:last-child {
            display: none !important;
        }
    </style>


    <%--Added By : Samrat Roy --%>
    <script>

        $(document).ready(function () {
           
           
        });

        $(function () {
            ccdDeliveryDate.SetDate(new Date());

              

        });



        var CheckUniqueCode = false;
        var AllControlInitilizeFlag = true;
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

        function AllControlInitilize() {
            
            $("#<%=ddl_DriverName.ClientID%>").change(function () {
                debugger;
                var ddl_Driver = $("#<%=ddl_DriverName.ClientID%>").val();
                $.ajax({
                    type: "POST",
                    url: "CustomerDelivery.aspx/GetPhoneNumberByDriver",
                    data: JSON.stringify({ ddl_driver: ddl_Driver }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (msg) {
                        debugger;
                        var phoneNo = msg.d;
                        ctxtDriverPhoneNo.SetText(phoneNo);
                    }
                });

            });
            $("#<%=ddl_vehicleNo.ClientID%>").change(function () {
                debugger;
                var ddlVehicleVal = $("#<%=ddl_vehicleNo.ClientID%>").val();
                var ddl_branch = ccdCmbBranch.GetValue();
                 //Subhabrata to Bind Vehicle from master accordingly
                $.ajax({
                    type: "POST",
                    url: "CustomerDelivery.aspx/GetVehicles",
                    data: JSON.stringify({ ddl_vehicle: ddlVehicleVal, BranchId: ddl_branch }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (r) {
                        var ddl_DriverName = $("[id*=ddl_DriverName]");
                        ddl_DriverName.empty().append('<option selected="selected" value="0">Please select</option>');
                        $.each(r.d, function () {
                            ddl_DriverName.append($("<option></option>").val(this['InternalID']).html(this['Name']));
                        });
                    }
                });
                 //End

             });

            if (AllControlInitilizeFlag == true) {
                var urlKeys = getUrlVars();
                ccdtxtDeliveryNumber.SetEnabled(false);
                if (urlKeys.key != 'ADD') {
                    ccdCmbBranch.SetEnabled(false);
                    if (ctxtByHand.GetText() != "") {
                        $("#DivDDLVehicle").hide();
                        $("#DivByHand").show();
                    }
                    else {
                        $("#DivDDLVehicle").show();
                        $("#DivByHand").hide();
                    }
                    // var param = "EditDetails";
                    //ccallBackCustDeliveryHeader.PerformCallback(param);
                    //grid.PerformCallback("BindMainGrid");
                }
                //else {
                //    //ccallBackCustDeliveryHeader.PerformCallback();
                //}

                


                $("#ddl_numberingScheme").change(function () {
                    debugger;
                    CheckUniqueCode = false;
                    var val = $("#ddl_numberingScheme").val();

                    var param = "BindAreaPin~" + val;
                    ccallBackCustDeliveryHeader.PerformCallback(param);
                });
                AllControlInitilizeFlag = false;
            }
        }

        function ChangeState(value) {

            cgridproducts.PerformCallback('SelectAndDeSelectProducts' + '~' + value);
        }

        function UniqueCodeCheck(s, e) {
            $.ajax({
                type: "POST",
                url: "CustomerDelivery.aspx/CheckUniqueCode",
                data: JSON.stringify({ GCHNo: ccdtxtDeliveryNumber.GetText() }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    CheckUniqueCode = msg.d;
                    if (CheckUniqueCode == true) {
                        alert('Please enter unique GCH No');
                        ccdtxtDeliveryNumber.SetValue('');
                        ccdtxtDeliveryNumber.Focus();
                        ccdDeliveryDate.HideDropDown();
                    }
                    else {
                        CheckUniqueCode = false;
                        $('#MandatorySlOrderNo').attr('style', 'display:none');
                    }
                }

            });
        }

        function CustomDelete(s, e) {
            if (e.buttonID == 'customDelete') {
                var rowKeyValue = s.GetRowKey(e.visibleIndex);
                grid.PerformCallback("Delete~" + rowKeyValue);
            }
        }

        function LoadChallan(s, e) {
            debugger;
            //if (ccdDeliveryDate.GetDate() == '' || ccdDeliveryDate.GetDate() == null) {
            //    flag = false;
            //    jAlert('Date is Mandatory', "Alert Message!!!", function () {
            //        ccdDeliveryDate.Focus();
            //    });
            //}
            if (ccdCmbBranch.GetValue() == '' || ccdCmbBranch.GetValue() == null) {
                flag = false;
                jAlert('Branch is Mandatory', "Alert Message!!!", function () {
                    ccdCmbBranch.Focus();
                });
            }
            else {
                cgridproducts.PerformCallback("LoadChallan");
                cProductsPopup.Show();
                cgridproducts.Focus();
            }

        }

        function gridOnEndCallback(s, e) {

            if (grid.cp_DataFlag == "0") {
                jAlert("There are no products to deliver in selected Area/Pincode!!", "Alert Message !!!", function () { });
            }
            grid.StartEditRow(0);
        }

        function gridFocusedRowChanged(s, e) {
            globalRowIndex = e.visibleIndex;
        }

        function cdCmbVehicleOnStateChanged(s, e) {
            var param = "LoadDriver";
            ccallBackCustDeliveryHeader.PerformCallback(param);
        }

        function cdCmbDriverOnStateChanged(s, e) {
            //ccdCmbDriver.PerformCallback(ccdCmbDriver.GetValue());
        }

        function PerformCallToGridBind() {
            cgridproducts.PerformCallback("BindGrid");
        }

        function cgridproductsOnEndCallback() {

            if (cgridproducts.cpEndCallBackReq == 1) {
                grid.PerformCallback("BindMainGrid");
                cProductsPopup.Hide();
                cbtn_SaveExitRecords.Focus();
            }
        }

        function cdCmbDriverOnEndCallback() {
            //ccdCmbDriver.SetValue(ccdCmbDriver.cpDriverID);
            //ctxtDriverPhoneNo.SetText(ccdCmbDriver.cpDriverPhoneNo);
        }

        function DateCheck() {
            var startDate = ccdDeliveryDate.GetValueString();
            ccdCmbBranch.Focus();
        }


        function GetVisibleIndex(s, e) {
            globalRowIndex = e.visibleIndex;
        }

        function Save_ButtonClick() {
            LoadingPanel.Show();
            var flag = Validation();
            if (flag != false) {
                if (grid.GetVisibleRowsOnPage() > 0) {
                    var param = "SaveData~SaveNew";
                    ccallBackCustDeliveryHeader.PerformCallback(param);
                }
                else {
                    jAlert('Please add atleast single record first');
                }
            }
            else {
                LoadingPanel.Hide();
            }
        }

        function SaveExit_ButtonClick() {
            debugger;
            var flag = Validation();
            LoadingPanel.Show();
            if (flag != false) {
                if (grid.GetVisibleRowsOnPage() > 0) {
                    var param = "SaveData~SaveExit";
                    ccallBackCustDeliveryHeader.PerformCallback(param);
                }
                else {
                    jAlert('Please add atleast single record first !!!', 'Alert Dialog', function (r) {
                        if (r == true) {
                            cbtnLoadChallan.Focus();
                        }
                    });
                }
            }
            else {
                LoadingPanel.Hide();
            }
        }

        function ccallBackCustDeliveryHeader_EndCallback() {
            debugger;
            LoadingPanel.Hide();
            if ($("#ddl_numberingScheme").val() == "") {
                ccdtxtDeliveryNumber.SetEnabled(false);
                ccdtxtDeliveryNumber.SetText('');
                $("#ddl_numberingScheme").focus();
            }
            if (getUrlVars().key != 'ADD') {
                $("#ddl_numbering").hide();
                ccdtxtDeliveryNumber.SetEnabled(false);
                ccdCmbBranch.SetEnabled(false);
            }

            if (ccallBackCustDeliveryHeader.cpDriverFoccus == 1) {
                ccallBackCustDeliveryHeader.cpDriverFoccus = null;
                //ccdCmbVehicle.Focus();
                ccdCmbBranch.SetEnabled(false);
                //ccdCmbDriver.SetValue('');
                ctxtDriverPhoneNo.SetText('');
                if (ccallBackCustDeliveryHeader.cpByHandFlag == 1) {
                    ccallBackCustDeliveryHeader.cpByHandFlag = 0;
                    $("#DivDDLVehicle").hide();
                    $("#DivByHand").show();
                }
                else {
                    $("#DivDDLVehicle").show();
                    $("#DivByHand").hide();
                }

                if (ccdtxtDeliveryNumber.GetText() == "Auto") {
                    ccdtxtDeliveryNumber.SetEnabled(false);
                }

            }
            if (ccallBackCustDeliveryHeader.cpNumberingScheme == 1) {
                if (ccallBackCustDeliveryHeader.cpNumberingSchemeType != "") {
                    ccdDeliveryDate.Focus();
                }
                else {
                    ccdtxtDeliveryNumber.Focus();
                }
                //ccdCmbDriver.SetValue('');
                ctxtDriverPhoneNo.SetText('');
            }
            if (ccallBackCustDeliveryHeader.cpEndCallBackReqFlag == 1) {
                var returnList = ccallBackCustDeliveryHeader.cpCheckFlag;
                if (returnList[0] == 1) {  // process : add
                    if (returnList[2] != "") {
                        jAlert("[GCH No.] : " + returnList[2] + ", Succesfully Saved.", 'Alert Dialog', function (r) {
                            if (r == true) {
                                if (returnList[3] == "SaveNew")
                                    window.location.assign("CustomerDelivery.aspx?key=ADD");
                                else {
                                    window.location.assign("CustomerDeliveryList.aspx");
                                }
                            }
                        });
                    }
                    else {
                        window.location.assign("CustomerDelivery.aspx?key=ADD");
                        jAlert('Please try again later !!!', 'Alert Dialog', function (r) {
                            if (r == true) { }
                        });
                    }
                }
                else if (returnList[0] == 2) {  // process : edit
                    if (returnList[2] != "") {
                        jAlert("[GCH No.] : " + returnList[2] + ", Succesfully Updated.", 'Alert Dialog', function (r) {
                            if (r == true) {
                                if (returnList[3] == "SaveNew")
                                    window.location.assign("CustomerDelivery.aspx?key=ADD");
                                else {
                                    window.location.assign("CustomerDeliveryList.aspx");
                                }
                            }
                        });
                    }
                    else {
                        window.location.assign("CustomerDelivery.aspx?key=ADD");
                        jAlert('Please try again later !!!', 'Alert Dialog', function (r) {
                            if (r == true) { }
                        });
                    }
                }
                else {
                    jAlert('Please try again later !!!', 'Alert Dialog', function (r) {
                        if (r == true) { }
                    });
                }
            }

        }

        function Validation() {
            flag = true;
            if (ccdtxtDeliveryNumber.GetText().trim() == '' || ccdtxtDeliveryNumber.GetText() == null) {
                flag = false;
                jAlert('GCH No. is Mandatory', "Alert Message!!!", function () {
                    // ccdtxtDeliveryNumber.Focus();
                    //$("#ddl_numberingScheme").focus();
                    // $("<%=ddl_numberingScheme.ClientID%>").focus();
                    ccdtxtDeliveryNumber.Focus();

                });
            }
            else if (ccdDeliveryDate.GetDate() == '' || ccdDeliveryDate.GetDate() == null) {
                flag = false;
                jAlert('Date is Mandatory', "Alert Message!!!", function () {
                    ccdDeliveryDate.Focus();
                });
            }
                //else if (ccdCmbVehicle.GetValue() == '0' || ccdCmbVehicle.GetValue() == null) {
                //    flag = false;
                //    jAlert('Vehicle number is Mandatory', "Alert Message!!!", function () {
                //        ccdCmbVehicle.Focus();
                //    });
                //}
            //else if (ccdCmbDriver.GetValue() == '0' || ccdCmbDriver.GetValue() == null) {

            //    flag = false;
            //    jAlert('Driver Name is Mandatory', "Alert Message!!!", function () {
            //        ccdCmbDriver.Focus();
            //    });

            //}
            return flag;
        }

    </script>

    <%--End: Samrat Roy :End--%>


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
        var isCtrl = false;
        document.onkeyup = function (e) {
            if (event.keyCode == 17) {
                isCtrl = false;
            }
            else if (event.keyCode == 27) {
                btnCancel_Click();
            }
        }

        document.onkeyup = function (e) {
            if (event.keyCode == 18) isCtrl = true;
            if (event.keyCode == 78 && event.altKey == true && getUrlVars().req != "V") { //run code for alt+N -- ie, Save & New  
                StopDefaultAction(e);
                Save_ButtonClick();
            }
            else if ((event.keyCode == 88) && event.altKey == true && getUrlVars().req != "V") { //run code for Alt+X -- ie, Save & Exit!     
                StopDefaultAction(e);
                SaveExit_ButtonClick();
            }
            else if ((event.keyCode == 80) && event.altKey == true && getUrlVars().req != "V") { //run code for alt+l -- ie, Load Challan  
                StopDefaultAction(e);
                LoadChallan();
            }
            else if ((event.keyCode == 79) && event.altKey == true && getUrlVars().req != "V") { //run code for alt+l -- ie, Load Challan  
                StopDefaultAction(e);
                PerformCallToGridBind();
            }

        }

        function StopDefaultAction(e) {
            if (e.preventDefault) { e.preventDefault() }
            else { e.stop() };

            e.returnValue = false;
            e.stopPropagation();
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <dxe:ASPxGlobalEvents ID="GlobalEvents" runat="server">
        <clientsideevents controlsinitialized="AllControlInitilize" />
    </dxe:ASPxGlobalEvents>

    <div class="panel-title clearfix">

        <h3 class="pull-left">
            <label>
                <asp:Literal ID="ltrTitle" Text="Add Customer Delivery (Route)" runat="server"></asp:Literal>
            </label>
        </h3>

        <div id="pageheaderContent" class="pull-right wrapHolder reverse content horizontal-images" style="display: none;">
            <ul>
                <li>
                    <div class="lblHolder">
                        <table>
                            <tr>
                                <td>Available Stock</td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblAvailableSStk" runat="server" Text="0.0"></asp:Label>
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
                                    <asp:Label ID="lblStkQty" runat="server" Text="0.00"></asp:Label></td>
                            </tr>
                        </table>
                    </div>
                </li>
                <li>
                    <div class="lblHolder" id="divPacking" style="display: none">
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
                <li>
                    <div class="lblHolder" style="display: none;">
                        <table>
                            <tr>
                                <td>Stock UOM</td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblStkUOM" runat="server" Text=" "></asp:Label></td>
                            </tr>
                        </table>
                    </div>
                </li>

            </ul>
        </div>

        <div class="crossBtn"><a href="CustomerDeliveryList.aspx"><i class="fa fa-times"></i></a></div>

    </div>

    <div class="form_main">
        <asp:Panel ID="pnl_CustomerDelivery" runat="server">
            <div class="row">

                <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ClientInstanceName="page" Width="98%">
                    <tabpages>
                        <dxe:TabPage Name="General" Text="General" TabStyle-CssClass="generalTab">
                            <ContentCollection>
                                <dxe:ContentControl runat="server">
                                    <div class="row">
                                        <div id="ddl_numbering" class="col-md-2" runat="server">
                                        <label>
                                            <dxe:ASPxLabel ID="lbl_NumberingScheme" Width="120px" runat="server" Text="Numbering Scheme">
                                            </dxe:ASPxLabel>
                                        </label>
                                        <asp:DropDownList ID="ddl_numberingScheme" runat="server" Width="100%">
                                        </asp:DropDownList>
                                        </div>
                                         <dxe:ASPxCallbackPanel runat="server" ID="callBackCustDeliveryHeader" ClientInstanceName="ccallBackCustDeliveryHeader" OnCallback="CallBackCustDeliveryHeader_Callback">
                                             <panelcollection>
                                                <dxe:PanelContent runat="server">
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="lbl_SlOrderNo" runat="server" Text="GCH No" Width="">
                                                            </dxe:ASPxLabel>
                                                            <span style="color: red">*</span>
                                                        </label>

                                                        <dxe:ASPxTextBox ID="cdtxtDeliveryNumber" runat="server" ClientInstanceName="ccdtxtDeliveryNumber" Width="100%" MaxLength="30">
                                                            <ClientSideEvents TextChanged="function(s, e) {UniqueCodeCheck();}" />
                                                        </dxe:ASPxTextBox>
                                                        <span id="MandatorySlOrderNo" style="display: none" class="validclass">
                                                            <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>

                                                    </div>

                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="ASPxLabel2" runat="server" Text="Date" Width="120px" CssClass="inline">
                                                            </dxe:ASPxLabel>
                                                            <span style="color: red">*</span>
                                                        </label>
                                                        <dxe:ASPxDateEdit ID="cdDeliveryDate" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" ClientInstanceName="ccdDeliveryDate" Width="100%">
                                                            <ButtonStyle Width="13px">
                                                            </ButtonStyle>
                                                            <ClientSideEvents DateChanged="function(s, e) {DateCheck();}" /> 
                                                            <ClientSideEvents GotFocus="function(s,e){if(CheckUniqueCode == false){ccdDeliveryDate.ShowDropDown();}}" />
                                                        </dxe:ASPxDateEdit>

                                                        <span id="MandatorySlDate" style="display: none" class="validclass">
                                                            <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor211_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                                                        <span id="MandatoryEgSDate" style="display: none" class="validclass">
                                                            <img id="3gridHistory_DXPEForm_efnew_DXEFL_DXEditor2114_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Sales Order date must not be prior date than quotation date"></span>

                                                    </div>
                                  
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="lbl_transferFrom_Branch" runat="server" Text="Branch">
                                                            </dxe:ASPxLabel>
                                                             <span style="color: red">*</span>
                                                        </label>
                                                          <dxe:ASPxComboBox ID="cdCmbBranch" ClientInstanceName="ccdCmbBranch" runat="server"
                                                            ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                            <ClearButton DisplayMode="Always"></ClearButton>
                                                        </dxe:ASPxComboBox>
                                                    </div>

                                                    <div class="col-md-2">
                                                        <span style="margin: 3px 0; display: block">
                                                            <dxe:ASPxLabel ID="lbl_Refference" runat="server" Text="Reference">
                                                            </dxe:ASPxLabel>
                                                        </span>
                                                        <dxe:ASPxTextBox ID="txt_Refference" runat="server" Width="100%" MaxLength="50">
                                           
                                                        </dxe:ASPxTextBox>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="ASPxLabel1" runat="server" Text="E-Way Bill No">
                                                            </dxe:ASPxLabel>
                                                             
                                                        </label>
                                                          <dxe:ASPxTextBox ID="txtEWayBillNo" runat="server" Width="100%" MaxLength="50">
                                                        </dxe:ASPxTextBox>
                                                    </div>
                                                    <div class="clear"></div>
                                            
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="lbl_Vehicle_No" runat="server" Text="Vehicle No">
                                                            </dxe:ASPxLabel>
                                                             <span style="color: red">*</span>
                                                        </label>
                                                           
                                                       <%-- <dxe:ASPxComboBox ID="cdCmbVehicle" ClientInstanceName="ccdCmbVehicle" runat="server"
                                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                        <ClearButton DisplayMode="Always"></ClearButton>
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { cdCmbVehicleOnStateChanged(s); }" ></ClientSideEvents>
                                                        </dxe:ASPxComboBox>--%>

                                                         <asp:DropDownList ID="ddl_vehicleNo" runat="server" Width="100%" TabIndex="8">
                                                          </asp:DropDownList>

                                                        <span id="cdMVehicle" style="display: none" class="mandt">
                                                            <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                        </span>
                                                    </div>
                                                    <div class="col-md-2">
                                                        
                                                        <div id="DivDDLVehicle">
                                                            <label>
                                                            <dxe:ASPxLabel ID="lbl_Driver_name" runat="server" Text="Driver Name">
                                                            </dxe:ASPxLabel>
                                                             <span style="color: red">*</span>
                                                        </label>
                                                            <%--<dxe:ASPxComboBox ID="cdCmbDriver" ClientInstanceName="ccdCmbDriver" runat="server" OnCallback="cdCmbDriver_Callback"
                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { cdCmbDriverOnStateChanged(s); }" endcallback="cdCmbDriverOnEndCallback" ></ClientSideEvents>
                                                            </dxe:ASPxComboBox>--%>
                                                              <asp:DropDownList ID="ddl_DriverName" runat="server" Width="100%" TabIndex="8">
                                                             </asp:DropDownList>

                                                            <span id="cdMDriver" style="display: none" class="mandt">
                                                                <img id="1gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory">
                                                            </span>
                                                        </div>
                                                        <div id="DivByHand" style="display:none;"> 
                                                            <label>
                                                                <dxe:ASPxLabel ID="lblByHand" runat="server" Text="By Hand">
                                                                </dxe:ASPxLabel>
                                                            </label>
                                                            <dxe:ASPxTextBox ID="txtByHand" ClientInstanceName="ctxtByHand" runat="server" Width="100%">
                                                            </dxe:ASPxTextBox>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="lblDriverPhone" runat="server" Text="Phone No">
                                                            </dxe:ASPxLabel>
                                                        </label>
                                                        <dxe:ASPxTextBox ID="txtDriverPhoneNo" ClientInstanceName="ctxtDriverPhoneNo" runat="server" Width="100%" MaxLength="15">
                                                        </dxe:ASPxTextBox>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="lblRouteNo" runat="server" Text="Route No">
                                                            </dxe:ASPxLabel>
                                                        </label>
                                                        <dxe:ASPxTextBox ID="txtRouteNo" runat="server" Width="100%" MaxLength="50">
                                                        </dxe:ASPxTextBox>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="lblArea" runat="server" Text="Area">
                                                            </dxe:ASPxLabel>
                                                        </label>
                                                        <dxe:ASPxComboBox ID="cdCmbArea" ClientInstanceName="ccdCmbArea" runat="server"
                                                            ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                            <ClearButton DisplayMode="Always"></ClearButton>
                                                        </dxe:ASPxComboBox>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <label>
                                                            <dxe:ASPxLabel ID="lblPinNo" runat="server" Text="Pin">
                                                            </dxe:ASPxLabel>
                                                        </label>
                                                         <dxe:ASPxComboBox ID="cdCmbPin" ClientInstanceName="ccdCmbPin" runat="server"
                                                                ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True" SelectedIndex="0">
                                                                <ClearButton DisplayMode="Always"></ClearButton>
                                                            </dxe:ASPxComboBox>
                                                    </div>                                          
                                                    
                                                    <div style="clear: both;"></div>
                                                    <div class="col-md-3" style="padding-top: 5px;">
                                                    <dxe:ASPxButton ID="btnLoadChallan" ClientInstanceName="cbtnLoadChallan" runat="server"
                                                                AutoPostBack="False" Text="Show P&#818;roducts for Delivery" CssClass="btn btn-primary" meta:resourcekey="btnLoadChallan">
                                                        <ClientSideEvents Click="function(s, e) {LoadChallan();e.processOnServer=false;}" />
                                                    </dxe:ASPxButton>
                                                </dxe:PanelContent>
                                              </panelcollection>
                                                <clientsideevents endcallback="ccallBackCustDeliveryHeader_EndCallback"/>
                                            </dxe:ASPxCallbackPanel>
                                            </div>

                                    <div class="clear"></div>
                                    <div class="col-md-12">
                                        <dxe:ASPxGridView runat="server" KeyFieldName="UniqueID"
                                            ClientInstanceName="grid" ID="grid"
                                            Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" Settings-ShowFooter="false"
                                            OnCustomCallback="grid_CustomCallback" AutoGenerateColumns="False"
                                            OnDataBinding="grid_DataBinding"
                                           Settings-VerticalScrollableHeight="300" Settings-VerticalScrollBarMode="Visible" SettingsBehavior-ColumnResizeMode="Control">
                                            <SettingsPager Visible="false"></SettingsPager>
                                            <ClientSideEvents CustomButtonClick="function(s, e) {
	                                                CustomDelete(s,e);
                                                }" />
                                            <Columns>
                                                <dxe:GridViewCommandColumn ShowDeleteButton="false" ShowNewButtonInHeader="false" Width="35" Caption=" ">
                                                    <CustomButtons>
                                                        <dxe:GridViewCommandColumnCustomButton Text=" " ID="customDelete" Image-Url="/assests/images/crs.png">
                                                        </dxe:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                    <HeaderCaptionTemplate>
                                                        
                                                    </HeaderCaptionTemplate>
                                                </dxe:GridViewCommandColumn>
                                               
                                                <dxe:GridViewDataTextColumn FieldName="DocNo" Caption="Doc No." ReadOnly="true"  Width="160">
                                                </dxe:GridViewDataTextColumn>

                                                 <dxe:GridViewDataTextColumn FieldName="DocDate" Caption="Date" ReadOnly="true" Width="75">
                                                 </dxe:GridViewDataTextColumn>
                                                    
                                                 <dxe:GridViewDataTextColumn FieldName="Brand_Name" Caption="Brand" ReadOnly="true">
                                                    </dxe:GridViewDataTextColumn>
                                                   
                                                 <dxe:GridViewDataTextColumn FieldName="ProductClass_Description" Caption="Class" ReadOnly="true" > 
                                                    </dxe:GridViewDataTextColumn>
                                                   
                                                 <dxe:GridViewDataTextColumn FieldName="ProductDesc" Caption="Product Name" Width="120" >  
                                                 </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="Qty" Caption="Quantity" CellStyle-HorizontalAlign="Right">
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="UOM_Name" Caption="UOM(Sale)" ReadOnly="true" >
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="CustomerName" Caption="Customer" ReadOnly="true" >
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="state" Caption="State" ReadOnly="true" Width="80">
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="pin_code" Caption="Pin" ReadOnly="true" Width="60" >
                                                </dxe:GridViewDataTextColumn>

                                                 <dxe:GridViewDataTextColumn FieldName="ProductSerials" Caption="Product Serial" ReadOnly="True" >
                                                   
                                                </dxe:GridViewDataTextColumn>

                                                 <dxe:GridViewDataTextColumn FieldName="SrlNo" Caption="Sl" ReadOnly="true" Width="0">
                                                    <PropertiesTextEdit>
                                                    </PropertiesTextEdit>
                                                </dxe:GridViewDataTextColumn>

                                                 <dxe:GridViewDataTextColumn FieldName="DocDetID" Caption="Doc Details ID" Width="0" ReadOnly="true">
                                                </dxe:GridViewDataTextColumn>

                                               

                                                    <%--Batch Product Popup End--%>
                                            </Columns>

                                            <SettingsDataSecurity AllowEdit="true" />
                                        </dxe:ASPxGridView>
                                    </div>
                                    <div style="clear: both;"></div>
                                    <br />
                                    <div class="col-md-12">
                                        <asp:Label ID="lbl_quotestatusmsg" runat="server" Text="" Font-Bold="true" ForeColor="Red" Font-Size="Medium"></asp:Label>
                                        <dxe:ASPxButton ID="btn_SaveRecords" ClientInstanceName="cbtn_SaveRecords" runat="server" AutoPostBack="False" Text="Save & N&#818;ew" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1">
                                            <ClientSideEvents Click="function(s, e) {Save_ButtonClick();}" />
                                        </dxe:ASPxButton>

                                        <dxe:ASPxButton ID="ASPxButton12" ClientInstanceName="cbtn_SaveExitRecords" runat="server" AutoPostBack="False" Text="Save & Ex&#818;it" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1">
                                            <ClientSideEvents Click="function(s, e) {SaveExit_ButtonClick();}" />
                                        </dxe:ASPxButton>
                                    </div>


                                    <dxe:ASPxPopupControl ID="ProductsPopup" runat="server" ClientInstanceName="cProductsPopup"
                                        Width="1200px" HeaderText="Select Products" PopupHorizontalAlign="WindowCenter"
                                        PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
                                        Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
                                        <headertemplate>
                                            <strong><span style="color: #fff">Select Products</span></strong>
                                            <dxe:ASPxImage ID="ASPxImage1" runat="server" ImageUrl="/assests/images/closePop.png" Cursor="pointer" CssClass="popUpHeader pull-right">
                                                <ClientSideEvents Click="function(s, e){ 
                                                                                    cProductsPopup.Hide();
                                                                                }" />
                                            </dxe:ASPxImage>
                                        </headertemplate>
                                        <contentcollection>
                                            <dxe:PopupControlContentControl runat="server">
                                                <div style="padding: 7px 0;">
                                                    <input type="button" value="Select All Products" onclick="ChangeState('SelectAll')" class="btn btn-primary"></input>
                                                    <input type="button" value="De-select All Products" onclick="ChangeState('UnSelectAll')" class="btn btn-primary"></input>
                                                    <input type="button" value="Revert" onclick="ChangeState('Revart')" class="btn btn-primary"></input>
                                                </div>
                                                <dxe:ASPxGridView runat="server" KeyFieldName="UniqueID" ClientInstanceName="cgridproducts" ID="grid_Products"
                                                    Width="100%" SettingsBehavior-AllowSort="false" SettingsBehavior-AllowDragDrop="false" OnDataBinding="grid_Products_DataBinding" 
                                                    SettingsPager-Mode="ShowAllRecords" OnCustomCallback="cgridProducts_CustomCallback"
                                                    Settings-ShowFooter="false" AutoGenerateColumns="False"
                                                    Settings-VerticalScrollableHeight="300" Settings-VerticalScrollBarMode="Visible" SettingsBehavior-ColumnResizeMode="Control">
                                                    <%-- <Settings VerticalScrollableHeight="450" VerticalScrollBarMode="Auto"></Settings>--%>
                                                    <SettingsBehavior AllowDragDrop="False" AllowSort="False"></SettingsBehavior>
                                                    <SettingsPager Visible="false"></SettingsPager>
                                                    <Columns>
                                                        <dxe:GridViewCommandColumn ShowSelectCheckbox="True" Caption=" " Width="35"/>
                                                       <dxe:GridViewDataTextColumn FieldName="SrlNo" Caption="Sl No" ReadOnly="true" Width="40" CellStyle-HorizontalAlign="Center" >
                                                    <PropertiesTextEdit>
                                                    </PropertiesTextEdit>
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="DocNo" Caption="Doc No." ReadOnly="true"  Width="160" >
                                                </dxe:GridViewDataTextColumn>

                                                 <dxe:GridViewDataTextColumn FieldName="DocDate" Caption="Date" ReadOnly="true"  PropertiesTextEdit-Height="15px" Width="75">
                                                 </dxe:GridViewDataTextColumn>
                                                    
                                                 <dxe:GridViewDataTextColumn FieldName="Brand_Name" Caption="Brand" ReadOnly="True"  >
                                                    </dxe:GridViewDataTextColumn>
                                                   
                                                 <dxe:GridViewDataTextColumn FieldName="ProductClass_Description" Caption="Class" ReadOnly="True"  >
                                                       
                                                    </dxe:GridViewDataTextColumn>
                                                   
                                                 <dxe:GridViewDataTextColumn FieldName="ProductDesc" Caption="Product Name"  Width="120">    
                                                 </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="Qty" Caption="Quantity"  CellStyle-HorizontalAlign="Right">
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="UOM_Name" Caption="UOM(Sale)" ReadOnly="True"  >
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="CustomerName" Caption="Customer" ReadOnly="True" >
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="state" Caption="State" ReadOnly="True" Width="80">
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="pin_code" Caption="Pin" ReadOnly="True" Width="60">
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="DeliveryDate" Caption="Delivery Date" ReadOnly="True" >
                                                </dxe:GridViewDataTextColumn>

                                                 <dxe:GridViewDataTextColumn FieldName="ProductSerials" Caption="Product Serial" ReadOnly="True" >
                                                   
                                                </dxe:GridViewDataTextColumn>

                                                <dxe:GridViewDataTextColumn FieldName="DocType" Caption="Doc Type" ReadOnly="True" Width="0">
                                                </dxe:GridViewDataTextColumn>
                                                    </Columns>
                                                     <ClientSideEvents EndCallback="cgridproductsOnEndCallback" />
                                                    <%--  <SettingsPager Mode="ShowAllRecords"></SettingsPager>--%>
                                                    <SettingsDataSecurity AllowEdit="true" />
                                                    <%--<SettingsSearchPanel Visible="True" />--%>
                                                    <Settings ShowGroupPanel="True"  ShowFooter="true"  ShowGroupFooter="VisibleIfExpanded" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                                </dxe:ASPxGridView>
                                                <div class="text-center">
                                                    <dxe:ASPxButton ID="cdbtnBindGrid" ClientInstanceName="ccdbtnBindGrid" runat="server"
                                                                AutoPostBack="False" Text="O&#818;k" CssClass="btn btn-primary mLeft mTop">
                                                        <ClientSideEvents Click="function(s, e) {PerformCallToGridBind(); e.processOnServer=false;}" />
                                                    </dxe:ASPxButton>
                                                </div>
                                            </dxe:PopupControlContentControl>
                                        </contentcollection>
                                        <contentstyle verticalalign="Top" cssclass="pad"></contentstyle>
                                        <headerstyle backcolor="LightGray" forecolor="Black" />
                                    </dxe:ASPxPopupControl>
            </div>
            </dxe:ContentControl>
        </ContentCollection>                  
     <%--test generel--%>
        </dxe:TabPage>
      </tabpages>
      </dxe:ASPxPageControl>
    </div>

    </asp:Panel>

      <dxe:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" ContainerElementID="divSubmitButton"
          Modal="True">
      </dxe:ASPxLoadingPanel>

</asp:Content>
