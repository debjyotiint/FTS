<%@ Page Title="TDS/TCS" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/Erp.Master" EnableEventValidation="false"
    Inherits="ERP.OMS.Management.Master.management_master_frm_TdsTcsPopUp" CodeBehind="frm_TdsTcsPopUp.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <script src="/assests/pluggins/choosen/choosen.min.js"></script>
    <%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.5.8/angular.min.js"></script>--%>
    <%--chosen.css--%>

    <style type="text/css">
          .chosen-container.chosen-container-single {
           width:100% !important;
       }
       
        .chosen-choices {
            width:100% !important;
        }
        #lstMainAccount, #lstSubAccount {
            width:200px;
        }
        .mandtry {
            position: absolute;
            right: -19px;
            top: 7px;
        }
        .dxflHARSys > table, .dxflHARSys > div {
     margin-left: 0px !important;
    margin-right: 0px !important;
    padding-left: 74px !important;
}
        </style>

    <script type="text/javascript">
        //function call_ajax(obj1, obj2, obj3) {

        //    ajax_showOptions(obj1, obj2, obj3, 'a', 'Main');
        //}
        function CheckLength() {
          // var textbox = document.getElementById('txtDescription').value;
           // alert(textbox.length);
           /* if (textbox.length >= 150) {
                alert("Here");
               return false;
           }
            else {
               return true;
            }*/
          
        }
        function TdsSectionChanged(s,e) {
            document.getElementById('txtCode').value = s.GetValue();



            if ($('#txtCode').val() != '') {
                $('#tdsshortname').attr('style', 'display:none');
                var TDSTCSId = 0;
                if (GetObjectID('hddnVal').value != '') {
                    TDSTCSId = GetObjectID('hddnVal').value;
                }

                var TDSTCSCode = $('#txtCode').val();
                $.ajax({
                    type: "POST",
                    url: "frm_TdsTcsPopUp.aspx/CheckUniqueName",
                    data: JSON.stringify({ TDSTCSId: TDSTCSId, TDSTCSCode: TDSTCSCode }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var data = msg.d;
                        if (data == true) {
                            //jjAlert("Please enter unique name"); 
                            jAlert("Section already exists");
                            cTdsSection.SetValue('0');
                            $('#txtCode').val('');
                            $('#txtCode').focus();
                            //document.getElementById("Popup_Empcitys_ctxtPro_Code_I").focus();
                            //document.getElementById("txtPro_Code_I").focus();
                            return false;
                        }
                    }

                });

            }
        }


        //function keyVal(obj) {
        //    var mainSubLedger = obj.split('~')
        //    SubledgerType = mainSubLedger[0, 2];
        //    if (mainSubLedger[0, 1].toUpperCase() != 'NONE') {
        //        document.getElementById('Label1').style.display = 'inline';
        //        document.getElementById('lstSubAccount').style.display = 'inline';
        //    }
        //    else {
        //        document.getElementById('Label1').style.display = 'none';
        //        document.getElementById('lstSubAccount').style.display = 'none';
        //    }
        //}





        function myFunction() {
            //if (document.getElementById('ddlType').value == 'TCS') {
            if (document.getElementById('ddlType').value == '1') {
                $('#divsubAC').css({ 'display': 'block' });
                var tdstype = $('#ddlType option:selected').val();
                var mainacvalue = $("#<%=lstMainAccount.ClientID%>").val();
                if (mainacvalue != '' && mainacvalue != null && mainacvalue != '0') {
                    BindSubAccountList(mainacvalue);
                }
            }
            else {
                //document.getElementById('Label1').style.display = 'none';
                //document.getElementById('lstSubAccount').style.display = 'none';
                $('#divsubAC').css({ 'display': 'none' });
            }
        }


        //function Page_Load() {
        //    document.getElementById('Label1').style.display = 'none';
        //    $('#lstSubAccount').prop('visible', false).trigger("chosen:updated");
        //    //document.getElementById('lstSubAccount').style.display = 'none';
        //}


        function call_ajax1(obj1, obj2, obj3) {
            ajax_showOptions(obj1, obj2, obj3, 'Employees', 'Sub');
        }
        //function call_ajax1(obj1, obj2, obj3) {
        //     var mainSubLedger = obj.split('~')
        //    SubledgerType = mainSubLedger[0, 2];
        //    ajax_showOptions(obj1, obj2, obj3, 'Employees', 'Sub');
        //}
        function ShowInsert(obj) {
            var objInser = obj.split('~')
            if (objInser[0, 0] == 'Insert') {
                jAlert('Saved Successfully');
                document.getElementById('hddnVal').value = objInser[0, 1];
                //window.location.href = "IframeTdsTcs.aspx";
            }
            else if (objInser[0, 0] == 'Error')
                jAlert('This Code Already Exists');
            else if (objInser[0, 0] == 'Update') {
                jAlert('Saved Successfully');
                //window.location.href = "IframeTdsTcs.aspx";
            }
        }
        function btnSave_Click() {
            var Mainacdtl = "";
            Mainacdtl = $("#<%=lstMainAccount.ClientID%>").val();

            var MainAcType = "";
            if ($("#<%=txtCode.ClientID%>").val().trim() != "") {
                if ($("#<%=lstMainAccount.ClientID%>").val() != null && $("#<%=lstMainAccount.ClientID%>").val() != '0') {
                    MainAcType = Mainacdtl.split('~')[1];
                    $('#tdsshortname').attr('style', 'display:none');
                    $('#mainacname').attr('style', 'display:none');
                    if ($("#<%=ddlType.ClientID%>").val() == '0') {
                        comboInsert.PerformCallback();
                    }
                    else if (MainAcType != 'None') {
                        if ($("#<%=lstSubAccount.ClientID%>").val() != '0' && $("#<%=lstSubAccount.ClientID%>").val() != null) {
                            comboInsert.PerformCallback();
                        }
                        else {
                            $('#subacname').attr('style', 'display:block');
                            return false;
                        }
                    }
                    //mainSubLedger[0, 2];


            }
            else {
                $('#mainacname').attr('style', 'display:block');
                return false;
                    //jAlert("Please enter Main Account name");
            }
                //comboInsert.PerformCallback();
        }
        else {
            $('#tdsshortname').attr('style', 'display:block');
            return false;
        }


    }
    function ForEdit() {

        $('#divsubAC').css({ 'display': 'block' });
        //document.getElementById('Label1').style.display = 'inline';
        //document.getElementById('txtSubAccount').style.display = 'inline';
        //document.getElementById('lstSubAccount').style.display = 'inline';

    }
    function OnAddButtonClick() {
        var Hddata = document.getElementById('hddnVal').value;
        if (Hddata != '') {
            gridTdsTcs.SetEnabled(true);
            gridTdsTcs.AddNewRow();
        }
        else
            jAlert('Cannot Proceed. Enter TDS/TCS details first to proceed with this entry.');
    }
    function ShowDateEn(obj) {

        var today = new Date();
        var tomorrow = new Date(today);

        var objShow = obj.split('~');
        if (objShow[0, 1] == '1') {

            gridTdsTcs.GetEditor("TDSTCSRates_DateFrom").SetEnabled(false);
        }
        else if (objShow[0, 1] == '2') {
            // var date = new Date();
            // var newDate = new Date(date.getYear(), date.getMonth(), date.getDate() + 1, 10, 0, 0);

            gridTdsTcs.GetEditor("TDSTCSRates_DateFrom").SetValue(today);
        }
    }
    function Back(path) {

        window.location.href = path;
    }
    FieldName = 'btnCancel';


    // For Chosen DropDown by sam on 20122016
    $(document).ready(function () {
        $('#lstMainAccount').chosen({ allow_single_deselect: true });
        //$('#lstMainAccount').trigger("chosen:updated");
        $('#lstSubAccount').chosen({ allow_single_deselect: true });

        //end  For Chosen DropDown by sam on 20122016
    });
    </script>
    
    <%--    <script type="text/javascript">
        var app = angular.module("lsApp", []);
        app.controller("lsCtrl", function ($scope) {
           /// $scope.code = "";
           /// $scope.mainaccount = "";
        });
    </script>--%>

    <%--// .............................Code Commented and Added by Sam on 21122016 to check . ..................................... --%> 
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtCode').blur(function () {
                if ($('#txtCode').val() != '') {
                    $('#tdsshortname').attr('style', 'display:none');
                    var TDSTCSId = 0;
                    if (GetObjectID('hddnVal').value != '') {
                        TDSTCSId = GetObjectID('hddnVal').value;
                    }

                    var TDSTCSCode = $('#txtCode').val();
                    $.ajax({
                        type: "POST",
                        url: "frm_TdsTcsPopUp.aspx/CheckUniqueName",
                        data: JSON.stringify({ TDSTCSId: TDSTCSId, TDSTCSCode: TDSTCSCode }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg) {
                            var data = msg.d;
                            if (data == true) {
                                //jjAlert("Please enter unique name"); 
                                jAlert("Please enter unique name");
                                $('#txtCode').val('');
                                $('#txtCode').focus();
                                //document.getElementById("Popup_Empcitys_ctxtPro_Code_I").focus();
                                //document.getElementById("txtPro_Code_I").focus();
                                return false;
                            }
                        }

                    });

                }
            })
        })
        <%--// .............................Code Above Commented and Added by Sam on 21122016...................................... --%>


        $(function () {
            $('#lstMainAccount').change(function () {

                var values = "";
                var MainAcType = "";
                values = $('#lstMainAccount option:selected').val();
                MainAcType = values.split('~')[1];
                if (values != '0') {
                    $('#mainacname').attr('style', 'display:none');
                }
                else {
                    BindSubAccountList(0);
                    $('#mainacname').attr('style', 'display:block');
                    return false;
                }

                var tdstype = $('#ddlType option:selected').val();
                if (tdstype == '1') {
                    var mainacvalue = $("#<%=lstMainAccount.ClientID%>").val();
                    if (mainacvalue != '' && mainacvalue != null && MainAcType != 'None') {
                        BindSubAccountList(mainacvalue);
                    } else {

                        var lBox = $('select[id$=lstSubAccount]');
                        lBox.empty();
                        ListSubAccountBind();
                        $('#lstSubAccount').trigger("chosen:updated");
                        $('#lstSubAccount').prop('disabled', true).trigger("chosen:updated");
                    }
                }
            });
        });

        $(function () {
            $('#lstSubAccount').change(function () {
                var ddltype = "";

                ddltype = $('#ddlType option:selected').val();
                if (ddltype != '0') {
                    var values = "";
                    values = $('#lstSubAccount option:selected').val();
                    if (values != '0') {
                        $('#subacname').attr('style', 'display:none');
                    }
                    else {
                        $('#subacname').attr('style', 'display:block');
                        return false;
                    }
                }

                <%--var tdstype = $('#ddlType option:selected').val();
                if (tdstype == '1') {
                    var mainacvalue = $("#<%=lstMainAccount.ClientID%>").val();
                if (mainacvalue != '' && mainacvalue != null) {
                    BindSubAccountList(mainacvalue);
                }--%>


            });
        });

        function BindSubAccountList(mainacvalue) {
            var ProcedureName = "SubAccountSelect";
            var InputName = "MainAccountID";
            var InputType = "V";
            <%-- var InputValue = MainAccountCode.split('~')[0] + "|RequestLetter|" + '<%=Session["userbranchHierarchy"] %>' + "|'" + '<%=Session["ExchangeSegmentID"] %>' + "'|'" + SegmentName + "'";--%>
            var InputValue = mainacvalue;
            var CombinedQuery = ProcedureName + "$" + InputName + "$" + InputType + "$" + InputValue;
            var lBox = $('select[id$=lstSubAccount]');
            var lstSubAccountItems = [];
            //Customer or Lead radio button is clicked kaushik 21-11-2016

            lBox.empty();

            if (mainacvalue != '0') {
                $.ajax({
                    type: "POST",
                    url: 'frm_TdsTcsPopUp.aspx/GetSubAccountList',
                    data: "{CombinedQuery:\"" + CombinedQuery + "\"}",
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

                                lstSubAccountItems.push('<option value="' +
                                id + '">' + name
                                + '</option>');
                            }

                            $(lBox).append(lstSubAccountItems.join(''));
                            ListSubAccountBind();
                            $('#lstSubAccount').trigger("chosen:updated");
                            $('#lstSubAccount').prop('disabled', false).trigger("chosen:updated");
                        }
                        else {
                            lBox.empty();
                            ListSubAccountBind();
                            $('#lstSubAccount').trigger("chosen:updated");
                            $('#lstSubAccount').prop('disabled', true).trigger("chosen:updated");

                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        jAlert(textStatus);
                    }
                });
            } else {

                lBox.empty();
                ListSubAccountBind();
                $('#lstSubAccount').trigger("chosen:updated");
                $('#lstSubAccount').prop('disabled', true).trigger("chosen:updated");
            }


        }

        function ListSubAccountBind() {

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

        $(document).ready(function () {
            $("#lstSubAccount").chosen().change(function () {
                var productId = $(this).val();

                $('#<%=hdnSubACCode.ClientID %>').val(productId);
                //jAlert(productId);


            })
        })


    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Add TDS / TCS</h3>
        </div>
        <div class="crossBtn"><a href="IframeTdsTcs.aspx"><i class="fa fa-times"></i></a></div>
    </div>
    <div class="form_main">
        <div class="row">
            <div class="col-md-3">
                <label>Type </label>
                <div>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control" onchange="myFunction();">
                        <asp:ListItem Text="TDS" Value="0" > </asp:ListItem> 
                        <asp:ListItem Text="TCS" Value="1"></asp:ListItem>
                        <%--<asp:ListItem>TDS

                        </asp:ListItem>
                        <asp:ListItem>TCS</asp:ListItem>--%>
                    </asp:DropDownList>
                </div>
            </div>
             
                    
           
            <div class="col-md-3"> 
                <label>TDS/TCS Section: <em>*</em></label>
                  
                <div class="relative">
                    <asp:TextBox ID="txtCode" runat="server" style="display:none"  CssClass="form-control" MaxLength="80"></asp:TextBox> 
                    
                    
                    <dxe:ASPxComboBox ID="TdsSection" ClientInstanceName="cTdsSection" runat="server" SelectedIndex="0"   
                                        ValueType="System.String" Width="100%" EnableSynchronization="True" EnableIncrementalFiltering="True">
                     <ClientSideEvents SelectedIndexChanged="TdsSectionChanged" />
                                        </dxe:ASPxComboBox>
                    
                    <span id="tdsshortname" style="display:none" class="mandtry"><img id="gridHistory1_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"</span>
                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCode" ValidationGroup="contact" SetFocusOnError="true" ErrorMessage="Required" ForeColor="red"></asp:RequiredFieldValidator>--%>
                     <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCode" ValidationGroup="contact" SetFocusOnError="true" ToolTip="Mandatory" class="pullrightClass fa fa-exclamation-circle abs iconRed" ErrorMessage=""></asp:RequiredFieldValidator>--%>


                </div>
            </div>
            <div class="col-md-3">
                <label>TDS Posting Ledger: <em>*</em></label>
                <div class="relative">
                   <%-- <asp:TextBox ID="txtMainAccount" runat="server" CssClass="form-control" OnTextChanged="txtMainAccount_TextChanged"></asp:TextBox>--%>
                   <asp:ListBox ID="lstMainAccount"  runat="server" Font-Size="12px"  ClientIDMode="Static"  Width="253px" ></asp:ListBox>
                
                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="lstMainAccount" InitialValue="0" ValidationGroup="contact" SetFocusOnError="true" ErrorMessage="Required" ForeColor="red"></asp:RequiredFieldValidator>--%>
                     <span id="mainacname" style="display:none" class="mandtry"><img id="gridHistory1_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"</span>
                </div>
            </div>
            <div class="col-md-3" style="display:none" id="divsubAC">
                <label>
                    <%--<asp:Label ID="Label1" runat="server" Text=" :"></asp:Label>--%>
                    Sub Account
                </label>


                <div class="relative">
                    <asp:ListBox ID="lstSubAccount" CssClass="hide"  runat="server" Font-Size="12px"  ClientIDMode="Static"  Width="253px" ></asp:ListBox>
                    <span id="subacname" style="display:none" class="mandtry"><img id="gridHistory1_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"</span>
                    <%--<asp:TextBox ID="txtSubAccount" runat="server" CssClass="form-control"></asp:TextBox>--%>
                </div>
                <span class="EcoheadCon_" id="tdSub1" style="display:none">&nbsp;</span>
            </div>
            <div class="clear"></div>
            <div class="col-md-6">
                <label class="EcoheadCon_">Description 
                </label>
                <div>
                   <%-- <asp:TextBox ID="txtDescription12" TextMode="MultiLine" runat="server"  CssClass="form-control" Height="62px" onkeypress="return CheckLength();"></asp:TextBox>--%>
                    <dxe:ASPxMemo ID="txtDescription" runat="server" Height="62px"  CssClass="form-control" MaxLength="150"></dxe:ASPxMemo>
                    
                </div>
            </div>
            <div class="clear"> </div>
            <div class="col-md-12" style="margin-top:4px">
                
                    <input id="btnSave" type="button" value="Save" onclick="btnSave_Click()" class="btnUpdate btn btn-primary"  />
                    <input id="btnCancel" type="button" value="Cancel" class="btnUpdate btn btn-danger" onclick="Back('IframeTdsTcs.aspx')" />
                
            </div>
        </div>
       
        <table>
            <tr>
                <td class="EHEADER" colspan="2" style="text-align: left">
                    <h4>Add/Modify Rates</h4>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <%if (Session["PageAccess"].ToString().Trim() == "All" || Session["PageAccess"].ToString().Trim() == "Add" || Session["PageAccess"].ToString().Trim() == "DelAdd")
                      { %>
                    <a class="btn btn-primary" href="javascript:void(0);" onclick="OnAddButtonClick()"><span>Add New</span> </a>
                    <%} %>
                      <% if (rights.CanExport)
                                               { %>
                    <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnChange="if(!AvailableExportOption()){return false;}" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
                        <asp:ListItem Value="0">Export to</asp:ListItem>
                        <asp:ListItem Value="1">PDF</asp:ListItem>
                        <asp:ListItem Value="2">XLS</asp:ListItem>
                        <asp:ListItem Value="3">RTF</asp:ListItem>
                        <asp:ListItem Value="4">CSV</asp:ListItem>

                    </asp:DropDownList>
                    <% } %>
                
                    <dxe:ASPxGridView ID="gridTdsTcs" runat="server" AutoGenerateColumns="False" Width="100%"
                        ClientInstanceName="gridTdsTcs" DataSourceID="SqlTscTcsRate" KeyFieldName="TDSTCSRates_ID"
                        OnRowInserting="gridTdsTcs_RowInserting" OnCustomJSProperties="gridTdsTcs_CustomJSProperties"
                        OnStartRowEditing="gridTdsTcs_StartRowEditing" OnInitNewRow="gridTdsTcs_InitNewRow" OnCellEditorInitialize="gridTdsTcs_CellEditorInitialize">
                        <styles>
                            <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                            <Header ImageSpacing="5px" SortingImageSpacing="5px">
                            </Header>
                        </styles>
                        <SettingsSearchPanel Visible="True" />
                        <settings showtitlepanel="True" showstatusbar="Visible" showgrouppanel="True" showfilterrow="true" ShowFilterRowMenu ="true" />
                        <settingsbehavior allowfocusedrow="false" confirmdelete="True" />
                        <settingstext popupeditformcaption="Add/Modify Rates" confirmdelete="Are You Want To Delete This Record?" />
                        <settingsediting mode="PopupEditForm" popupeditformheight="250px" popupeditformhorizontalalign="Center"
                            popupeditformmodal="True" popupeditformverticalalign="WindowCenter" popupeditformwidth="600px" />
                        <settingspager showseparators="True" alwaysshowpager="True" numericbuttoncount="8"
                            pagesize="20">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                        </settingspager>
                        <columns>
                            <dxe:GridViewDataTextColumn FieldName="TDSTCSRates_ID" Visible="False">
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Short Name" FieldName="TDSTCSRates_Code" VisibleIndex="0">
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataDateColumn Caption="From" FieldName="TDSTCSRates_DateFrom" VisibleIndex="1" ReadOnly="false">
                                <EditFormSettings Visible="True" />
                                <PropertiesDateEdit EditFormatString="dd-MM-yyyy" DisplayFormatString="dd MMM yyyy">
                                    <ValidationSettings ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" SetFocusOnError="True">
                                        <RequiredField IsRequired="true" ErrorText="*" />
                                    </ValidationSettings>
                                </PropertiesDateEdit>
                            </dxe:GridViewDataDateColumn>
                            <dxe:GridViewDataDateColumn Caption="To" FieldName="TDSTCSRates_DateTo" 
                                VisibleIndex="2">
                                <PropertiesDateEdit EditFormatString="dd-MM-yyyy" DisplayFormatString="dd MMM yyyy"></PropertiesDateEdit>

                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataDateColumn>
                            <dxe:GridViewDataTextColumn Caption="Rate" FieldName="TDSTCSRates_Rate" VisibleIndex="3" ReadOnly="false">
                                <EditFormSettings Visible="True" />
                                <PropertiesTextEdit MaskSettings-Mask="&lt;0..99g&gt;.&lt;00..99&gt;" MaskSettings-IncludeLiterals="DecimalSymbol"
                                    ValidationSettings-ErrorDisplayMode="None">
<MaskSettings Mask="&lt;0..99g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>

                                      <ValidationSettings ErrorDisplayMode="ImageWithText" ErrorTextPosition="Bottom" SetFocusOnError="True">
                                        <RequiredField IsRequired="true" ErrorText="*" />
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Surcharge" Visible="true" FieldName="TDSTCSRates_Surcharge"
                                VisibleIndex="4" ReadOnly="false">
                                <EditFormSettings Visible="True" />
                                <PropertiesTextEdit MaskSettings-Mask="&lt;0..99g&gt;.&lt;00..99&gt;" MaskSettings-IncludeLiterals="DecimalSymbol"
                                    ValidationSettings-ErrorDisplayMode="None">
<MaskSettings Mask="&lt;0..99g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>

<ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                </PropertiesTextEdit>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="EduCess" Visible="true" FieldName="TDSTCSRates_EduCess"
                                VisibleIndex="5">
                                <EditFormSettings Visible="True" />
                                <PropertiesTextEdit MaskSettings-Mask="&lt;0..99g&gt;.&lt;00..99&gt;" MaskSettings-IncludeLiterals="DecimalSymbol"
                                    ValidationSettings-ErrorDisplayMode="None">
<MaskSettings Mask="&lt;0..99g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>

<ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                </PropertiesTextEdit>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="HgrEduCess" Visible="true" FieldName="TDSTCSRates_HgrEduCess"
                                VisibleIndex="6">
                                <EditFormSettings Visible="True" />
                                <PropertiesTextEdit MaskSettings-Mask="&lt;0..99g&gt;.&lt;00..99&gt;" MaskSettings-IncludeLiterals="DecimalSymbol"
                                    ValidationSettings-ErrorDisplayMode="None">
<MaskSettings Mask="&lt;0..99g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>

<ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                </PropertiesTextEdit>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Applicable Amount" Visible="true" FieldName="TDSTCSRates_ApplicableAmount"
                                VisibleIndex="7">
                                <EditFormSettings Visible="True" />
                                <PropertiesTextEdit MaskSettings-Mask="&lt;0..99999999999g&gt;.&lt;00..99&gt;" MaskSettings-IncludeLiterals="DecimalSymbol"
                                    ValidationSettings-ErrorDisplayMode="None">
<MaskSettings Mask="&lt;0..99999999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>

<ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                </PropertiesTextEdit>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewCommandColumn VisibleIndex="8" ShowDeleteButton="true" ShowEditButton="true" ShowUpdateButton="true" ShowCancelButton="true" Width="60px">
                                <%-- <DeleteButton Visible="True">
                                    </DeleteButton>
                                    <EditButton Visible="True">
                                    </EditButton>--%>
                                <HeaderStyle HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    <span style="width:auto">Actions</span>
                                </HeaderTemplate>
                            </dxe:GridViewCommandColumn>
                        </columns>
                        <settingscommandbutton>

                            <EditButton ButtonType="Image" Image-Url="/assests/images/Edit.png">
<Image Url="/assests/images/Edit.png"></Image>
                            </EditButton>
                            <DeleteButton ButtonType="Image" Image-Url="/assests/images/Delete.png">
<Image Url="/assests/images/Delete.png"></Image>
                            </DeleteButton>
                            <UpdateButton ButtonType="Button" Text="Update" Styles-Style-CssClass="btn btn-primary"></UpdateButton>
                            <CancelButton ButtonType="Button" Text="Cancel" Styles-Style-CssClass="btn btn-danger"></CancelButton>
                        </settingscommandbutton>
                        <clientsideevents endcallback="function(s,e){ShowDateEn(s.cpInsertEna);}" />
                    </dxe:ASPxGridView>
                    <asp:SqlDataSource ID="SqlTscTcsRate" runat="server"
                        SelectCommand="SELECT * FROM [Config_TDSTCSRates] where TDSTCSRates_Code=@TDSTCSRates_Code"
                        DeleteCommand="DELETE FROM [Config_TDSTCSRates] WHERE [TDSTCSRates_ID] = @TDSTCSRates_ID"
                        InsertCommand="TdsTcsRate_Insert" InsertCommandType="StoredProcedure" UpdateCommand="UPDATE [Config_TDSTCSRates] SET  [TDSTCSRates_DateFrom] = @TDSTCSRates_DateFrom, [TDSTCSRates_Rate] = @TDSTCSRates_Rate, [TDSTCSRates_Surcharge] = @TDSTCSRates_Surcharge, [TDSTCSRates_EduCess] = @TDSTCSRates_EduCess, [TDSTCSRates_HgrEduCess] = @TDSTCSRates_HgrEduCess, [TDSTCSRates_ModifyUser] = @TDSTCSRates_ModifyUser, [TDSTCSRates_ModifyDateTime] = getdate(), [TDSTCSRates_ApplicableAmount] = @TDSTCSRates_ApplicableAmount WHERE [TDSTCSRates_ID] = @TDSTCSRates_ID">
                        <SelectParameters>
                            <asp:SessionParameter Name="TDSTCSRates_Code" SessionField="KeyVal" Type="string" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="TDSTCSRates_ID" Type="Int64" />
                        </DeleteParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="TDSTCSRates_DateFrom" Type="DateTime" />
                            <asp:Parameter Name="TDSTCSRates_Rate" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_Surcharge" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_EduCess" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_HgrEduCess" Type="Decimal" />
                            <asp:SessionParameter Name="TDSTCSRates_ModifyUser" SessionField="userid" Type="Int32" />
                            <asp:Parameter Name="TDSTCSRates_ApplicableAmount" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_ID" Type="Int64" />
                        </UpdateParameters>
                        <InsertParameters>
                            <asp:Parameter Name="TDSTCSRates_Code" Type="String" />
                            <asp:Parameter Name="TDSTCSRates_DateFrom" Type="DateTime" />
                            <asp:Parameter Name="TDSTCSRates_Rate" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_Surcharge" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_EduCess" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_HgrEduCess" Type="Decimal" />
                            <asp:Parameter Name="TDSTCSRates_ApplicableAmount" Type="Decimal" />
                            <asp:SessionParameter Name="TDSTCSRates_CreateUser" SessionField="userid" Type="Int32" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr style="display: none">
                <td style="height: 102px">
                    <asp:HiddenField ID="txtMainAccount_hidden" runat="server" />
                    <asp:HiddenField ID="txtSubAccount_hidden" runat="server" />
                    <dxe:ASPxComboBox ID="comboInsert" runat="server" ClientInstanceName="comboInsert"
                        ValueType="System.String" OnCallback="ASPxComboBox1_Callback" OnCustomJSProperties="ASPxComboBox1_CustomJSProperties">
                        <clientsideevents endcallback="function(s,e) {ShowInsert(comboInsert.cpInsert);}" />
                    </dxe:ASPxComboBox>
                    <asp:HiddenField ID="hddnVal" runat="server" />
                    <asp:HiddenField ID="hdnSubACCode" runat="server" />
                </td>
            </tr>
        </table>
    </div>

     <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
    </span></span></span>
</asp:Content>
