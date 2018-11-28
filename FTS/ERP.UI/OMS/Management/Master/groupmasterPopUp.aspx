<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" EnableEventValidation="false"
    Inherits="ERP.OMS.Management.Master.management_master_groupmasterPopUp" CodeBehind="groupmasterPopUp.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--<%@ Register Assembly="DevExpress.Web.v10.2.Export, Version=10.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.Export" TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe000001" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dxe" %>
<%@ Register assembly="DevExpress.Web.v10.2" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.v10.2" namespace="DevExpress.Web" tagprefix="dx" %>--%>



    <link href="../../css/choosen.min.css" rel="stylesheet" />
    <script src="/assests/pluggins/choosen/choosen.min.js"></script>

    <style type="text/css">
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
            z-index: 32767;
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
        
        .chosen-container.chosen-container-single {
            width:220px !important;
        }
        .chosen-choices {
            width:100% !important;
        }
        .chosen-single {
        width:200px !important;
        }
        #lstContactBy {
            width:200px  ;
        }
        #lstContactBy {
            display:none !important;
            
        }
        #lstContactBy_chosen{
            width:200px !important;
        }
        
    </style>
     
    <script language="javascript" type="text/javascript">

        function callOnLoad() {
            $(".chzn-select").chosen();
            $(".chzn-select-deselect").chosen({ allow_single_deselect: true });
            ListBind();
        }

        $(document).ready(function () {
            callOnLoad();
            //ChangeSource();

        });
        function Changeselectedvalue() {
            var lstContactBy = document.getElementById("lstContactBy");
            if (document.getElementById("hdContactBy").value != '') {
                for (var i = 0; i < lstContactBy.options.length; i++) {
                    if (lstContactBy.options[i].value == document.getElementById("hdContactBy").value) {
                        lstContactBy.options[i].selected = true;
                    }
                }
                $('#lstContactBy').trigger("chosen:updated");
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
        function lstContactBy() {

            // $('#lstReferedBy').chosen();
            $('#lstContactBy').fadeIn();
        }
        function setvalue() {
            document.getElementById("txtContact_hidden").value = document.getElementById("lstContactBy").value;
        }
        function ChangeSource() {

            var InterId = "";
            var fname = "%";
            var a = document.getElementById("txtID").value;
            var b = document.getElementById("MType").value;
            if (document.getElementById("DDLAddData").value) {
                InterId = document.getElementById("DDLAddData").value;
            }
            var c = document.getElementById("DDLAddData").value;
          //  var d = document.getElementById("ddlValue").value;
           // var obj4 = a + '~' + b + '~' + c + '~' + d;
            var obj4 = a + '~' + b + '~' + c ;
          
            var lReferBy = $('select[id$=lstContactBy]');
            lReferBy.empty();

            $.ajax({
                type: "POST",
                url: "groupmasterPopUp.aspx/GetgroupmasterPopUp",
                data: JSON.stringify({ reqStr: fname, obj4: obj4 }),
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
                            $('#lstContactBy').append($('<option>').text(name).val(id));
                        }

                        $(lReferBy).append(listItems.join(''));

                        lstContactBy();
                        $('#lstContactBy').trigger("chosen:updated");
                        Changeselectedvalue();
                    }
                    else {
                        alert("No records found");
                      //  lstReportTo();
                        $('#lstContactBy').trigger("chosen:updated");
                    }
                }
            });

        }
        function showOptions(objID, objType, objEvent) {
            if (objID.value == "") {
                objID.value = "%";
            }
            var a = document.getElementById("txtID").value;
            var b = document.getElementById("MType").value;
            var c = document.getElementById("ddlText").value;
            var d = document.getElementById("ddlValue").value;
            var obj4 = a + '~' + b + '~' + c + '~' + d;
            if (c != '' && d != '') {
                if (objType == 'NSDLClientsGroupMember') {
                    strQuery_Table = " Master_NsdlClients";/*Session["usersegid"]='IN304004'//////select gpm_Type,gpm_code from tbl_master_groupMaster where gpm_id="+a+*/
                    strQuery_FieldName = " distinct Top 10 (LTRIM(rtrim(NsdlClients_BenFirstHolderName))+' ['+cast(ltrim(rtrim(NsdlClients_BenAccountID)) as varchar(10))+']') as Name,(NsdlClients_DPID+cast(NsdlClients_BenAccountID as varchar(10))) as ID ";
                    strQuery_WhereClause = " NsdlClients_DPID='" + '<%=Session["usersegid"] %>' + "' and NsdlClients_DPID+cast(NsdlClients_BenAccountID as varchar(10)) not in (Select grp_contactId from tbl_master_groupMaster,tbl_trans_group Where gpm_code=(select gpm_code from tbl_master_groupMaster where gpm_id=" + a + ") and gpm_Type=(select gpm_Type from tbl_master_groupMaster where gpm_id=" + a + ") and grp_groupMaster=gpm_id and Left(grp_contactId,2)='IN') and (NsdlClients_BenFirstHolderName like \'RequestLetter%' Or NsdlClients_BenAccountID  like \'RequestLetter%')";
                    strQuery_OrderBy = " Name";
                    strQuery_GroupBy = "";
                    CombinedQuery = new String(strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_GroupBy + "$" + strQuery_OrderBy);
                    ajax_showOptions(objID, 'GenericAjaxList', objEvent, replaceChars(CombinedQuery), 'Main');
                }
                else if (objType == 'CDSLClientsGroupMember') {
                    strQuery_Table = " Master_CdslClients";
                    strQuery_FieldName = " distinct Top 10 (LTRIM(rtrim(CdslClients_FirstHolderName))+' '+LTRIM(rtrim(CdslClients_FirstHolderMiddleName))+' '+LTRIM(rtrim(CdslClients_FirstHolderLastName))+' ['+cast(ltrim(rtrim(right(CdslClients_BOID,8))) as varchar(10))+']') as Name,cast(RIGHT(CdslClients_BOID,8) as varchar(10)) as ID ";
                    strQuery_WhereClause = " CdslClients_DPID='" + '<%=Session["usersegid"] %>' + "' and CdslClients_BOID  not in (Select grp_contactId from tbl_master_groupMaster,tbl_trans_group Where gpm_code=(select gpm_code from tbl_master_groupMaster where gpm_id=" + a + ") and gpm_Type=(select gpm_Type from tbl_master_groupMaster where gpm_id=" + a + ") and grp_groupMaster=gpm_id and Left(grp_contactId,2)='12') and (CdslClients_FirstHolderName like \'RequestLetter%' Or right(CdslClients_BOID,8)  like \'RequestLetter%')";
                    strQuery_OrderBy = " Name";
                    strQuery_GroupBy = "";
                    CombinedQuery = new String(strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_GroupBy + "$" + strQuery_OrderBy);
                    ajax_showOptions(objID, 'GenericAjaxList', objEvent, replaceChars(CombinedQuery), 'Main');
                }
                else {
                    ajax_showOptionsTEST(objID, objType, objEvent, obj4);
                    if (objID.value == "%") {
                        objID.value = "";
                    }
                }
        }
        else {
            alert('Please Select Contact Type...!!')
        }
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
    function CallGrid() {
        // editwin.close();
        grid.PerformCallback();
    }
    FieldName = 'BtnSave';
    function GridName_EndCallBack() {
     <%--   document.getElementById('<%=txtContact.ClientID%>').focus();
       document.getElementById('<%=txtContact.ClientID%>').select();--%>
    }
    function Page_Load() {
     <%--   document.getElementById('<%=txtContact.ClientID%>').focus();
        document.getElementById('<%=txtContact.ClientID%>').select();--%>
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Add Member</h3>

            <div class="crossBtn">
                <asp:LinkButton ID="goBackCrossBtn" runat="server" OnClick="goBackCrossBtn_Click"><i class="fa fa-times"></i></asp:LinkButton>
                <%--<a href="frmContactMain.aspx" id="goBackCrossBtn"><i class="fa fa-times"></i></a>--%>
                <%--<asp:HiddenField ID="hidbackPagerequesttype" runat="server" />--%>
            </div>
        </div>
    </div>
    <div class="form_main">
        <table class="TableMain100">

            <tr>
                <td>
                    <div style="width: 125px; display: inline-block;"><strong>Group Name:</strong></div>
                    <span>
                        <asp:Literal ID="litGpName" runat="server"></asp:Literal></span>
                </td>

            </tr>
            <tr>
                <td>
                    <%-- <div style="clear:both">--%>



                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <%--  <asp:Panel ID="Panel1" runat="server" Width="99%" Visible="False">--%>
                            <table width="100%">
                                <tr>
                                    <td style="text-align: left; width: 127px;">
                                        <asp:Label ID="Label1" runat="server" Text="Choose By" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td style="text-align: left">
                                       <%-- <asp:DropDownList ID="DDLAddData" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLAddData_SelectedIndexChanged"
                                            Width="200px">
                                        </asp:DropDownList>--%>
                                        <asp:DropDownList ID="DDLAddData" runat="server"  onchange="ChangeSource()" 
                                            Width="200px">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr style="padding-top: 9px">
                                    <td><asp:Label ID="Label2" runat="server" Text="Select Contact" Font-Bold="True"></asp:Label>
                                    </td>

                                    <td>
                                      
                                        <asp:ListBox ID="lstContactBy" CssClass="chsn" runat="server" Font-Size="12px" Width="150px" data-placeholder="Select..."></asp:ListBox>
                                     <%--   <asp:TextBox ID="txtContact" runat="server" Width="200px" autocomplete="off"></asp:TextBox>--%>
                                        <asp:HiddenField ID="txtContact_hidden" runat="server" />
                                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" 
                                            ControlToValidate="lstContactBy" ValidationGroup="a" ForeColor="Red" SetFocusOnError="true">

                                        </asp:RequiredFieldValidator>--%>
                                    </td>
                                </tr>
                                <tr style="padding-top: 9px;">
                                    <td colspan="2" style="padding-left: 126px">
                                        <asp:Button ID="BtnSave" runat="server" Text="Save" CssClass="btn btn-danger" OnClick="BtnSave_Click" OnClientClick="setvalue()" ValidationGroup="a" />
                                        <asp:Button ID="BtnCancel" runat="server" CssClass="btn btn-danger" Text="Cancel" OnClick="BtnCancel_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: left" visible="false">
                                        <asp:HiddenField ID="hdContactBy" runat="server" />
                                        <asp:HiddenField ID="txtID" runat="server" />
                                        <asp:HiddenField ID="MType" runat="server" />
                                        <asp:HiddenField ID="ddlValue" runat="server" />
                                        <asp:HiddenField ID="ddlText" runat="server" />
                                        <%-- <asp:ListBox ID="LLbAddData" runat="server" Width="100%" Height="266px" SelectionMode="Multiple" Visible="false"></asp:ListBox>--%>
                                        <br />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                  
                    <%--     </asp:Panel>--%>
                    <%--</div>--%>
                </td>
            </tr>
            <tr>
                <td>
                    <%-- <asp:Panel ID="GridPanel" runat="server" Visible="false" Width="99%">--%>
                    <dxe:ASPxGridView ID="GridName" runat="server" KeyFieldName="grp_id" AutoGenerateColumns="False"
                        DataSourceID="SelectName" ClientInstanceName="grid" Width="100%" OnCustomCallback="GridName_CustomCallback"
                        OnRowDeleting="GridName_RowDeleting">
                     <%--   <ClientSideEvents EndCallback="function(s, e) {GridName_EndCallBack();}" />--%>
                        <Columns>
                            <dxe:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="0" Width="80%">
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="Id" Visible="False">
                            </dxe:GridViewDataTextColumn>
                            <%--<dxe:GridViewCommandColumn VisibleIndex="1">
                                    <DeleteButton Visible="True">
                                    </DeleteButton>
                                </dxe:GridViewCommandColumn>--%>
                            <dxe:GridViewCommandColumn VisibleIndex="8" ShowDeleteButton="True">
                                <HeaderTemplate>
                                    <span style="color: #fffff; text-align: center;">Action</span>
                                </HeaderTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                            </dxe:GridViewCommandColumn>
                        </Columns>
                        <Styles>
                           <%-- <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                            <Header ImageSpacing="5px" SortingImageSpacing="5px">
                            </Header>--%>
                        </Styles>
                        <SettingsText ConfirmDelete="Are You Sure To Delete This Record ???" />
                        <SettingsBehavior ColumnResizeMode="NextColumn" ConfirmDelete="True" />
                        <SettingsSearchPanel Visible="True" />
                        <settings showgrouppanel="True" showstatusbar="Hidden" showhorizontalscrollbar="False" showfilterrow="true" showfilterrowmenu="true" />
                    </dxe:ASPxGridView>
                    <%--  <asp:Button ID="AddMember" runat="server" Text="Add Member" OnClick="AddMember_Click" />--%>
                    <%-- </asp:Panel> --%>
                </td>
            </tr>
        </table>
        <%-- DeleteCommand="Delete from tbl_trans_group where grp_id=@grp_id">
                <DeleteParameters>
                    <asp:Parameter Name="grp_id" Type="decimal" />
                </DeleteParameters>
        --%>
        <asp:SqlDataSource ID="SelectName" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>">
            <SelectParameters>
                <asp:QueryStringParameter Name="RId" QueryStringField="id" Type="decimal" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
