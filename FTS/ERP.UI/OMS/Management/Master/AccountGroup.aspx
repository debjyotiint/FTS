<%@ Page Title="Account Group" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" Inherits="ERP.OMS.Management.Master.management_master_AccountGroup" CodeBehind="AccountGroup.aspx.cs" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .dxgvEditFormCaption {
            text-align: right !important;
        }
    </style>
    
    <script language="javascript" type="text/javascript">
        function UniqueCodeCheck() {

            var uniqueid = '0';
            var id = '<%= Convert.ToString(Session["id"]) %>';

            var uniqueCode = grid.GetEditor('AccountGroupCode').GetValue();

            if ((id != null) && (id != '')) {
                uniqueid = id;
                '<%=Session["id"]=null %>'
            }
            var CheckUniqueCodee = false;
            $.ajax({
                type: "POST",
                url: "AccountGroup.aspx/CheckUniqueCode",
                data: JSON.stringify({ uniqueCode: uniqueCode, uniqueid: uniqueid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    CheckUniqueCodee = msg.d;
                    if (CheckUniqueCodee == true) {
                        jAlert('Please enter unique short name');
                        grid.GetEditor('AccountGroupCode').SetValue('');
                        grid.GetEditor('AccountGroupCode').Focus();
                    }
                }
            });
        }
        function UniqueNameCheck() {

            var uniqueid = '0';
            var id = '<%= Convert.ToString(Session["id"]) %>';

            var uniqueCode = grid.GetEditor('AccountGroupName').GetValue();

            if ((id != null) && (id != '')) {
                uniqueid = id;
                '<%=Session["id"]=null %>'
            }
            var CheckUniqueCodee = false;
            $.ajax({
                type: "POST",
                url: "AccountGroup.aspx/CheckUniqueName",
                data: JSON.stringify({ uniqueName: uniqueCode, uniqueid: uniqueid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    CheckUniqueCodee = msg.d;
                    if (CheckUniqueCodee == true) {
                        jAlert('Please enter unique name');
                        grid.GetEditor('AccountGroupName').SetValue('');
                        grid.GetEditor('AccountGroupName').Focus();
                    }
                }
            });
        }
        function ShowHideFilter(obj) {
            grid.PerformCallback(obj);
        }
        function EndCall(obj) {
           
            if (grid.cpDelmsg != null)
                jAlert(grid.cpDelmsg);
        }
        function OnCountryChanged(cmbParent) {
            grid.GetEditor("ParentIDWithName").PerformCallback(cmbParent.GetValue().toString());
        }

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Account Group</h3>
        </div>
    </div>
    <div class="form_main">
        <div class="SearchArea">
            <div class="FilterSide">
                <div style="float: left; padding-right: 5px;">
                    <% if (rights.CanAdd)
                       { %>
                    <a href="javascript:void(0);" onclick="grid.AddNewRow()" class="btn btn-primary"><span>Add New</span> </a>

                    <% } %>
                </div>

                <div class="pull-left">
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
                </div>
            </div>

        </div>
     

        <%--#a20102016 - 0011279--%>
        <dxe:ASPxGridView ID="AccountGroup" runat="server" ClientInstanceName="grid" AutoGenerateColumns="False"
            DataSourceID="SqlDsAccountGroup" Width="100%" KeyFieldName="AccountGroupID" OnHtmlEditFormCreated="AccountGroup_HtmlEditFormCreated"
            OnCellEditorInitialize="AccountGroup_CellEditorInitialize" OnRowValidating="AccountGroup_OnRowValidating" OnInitNewRow="AccountGroup_InitNewRow"
            OnRowUpdating="AccountGroup_OnRowUpdating" OnCustomCallback="AccountGroup_CustomCallback" OnStartRowEditing="AccountGroup_StartRowEditing"
            OnCustomJSProperties="AccountGroup_CustomJSProperties" OnRowDeleting="AccountGroup_RowDeleting" OnCommandButtonInitialize="AccountGroup_CommandButtonInitialize">
            <ClientSideEvents EndCallback="function(s, e) {
	  EndCall(s.cpInsertError);
}" />
            <Templates>
                <EditForm>
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 10%"></td>
                            <td style="width: 90%">
                                <controls>
                                <dxe:ASPxGridViewTemplateReplacement runat="server" ReplacementType="EditFormEditors"  ID="Editors">
                                </dxe:ASPxGridViewTemplateReplacement>                                                           
                            </controls>
                                <div style="text-align: left; padding: 2px 2px 2px 102px; width: 90%">
                                    <dxe:ASPxGridViewTemplateReplacement ID="UpdateButton" ReplacementType="EditFormUpdateButton" class="btn btn-primary"
                                        runat="server"></dxe:ASPxGridViewTemplateReplacement>
                                    <dxe:ASPxGridViewTemplateReplacement ID="CancelButton" ReplacementType="EditFormCancelButton"
                                        runat="server"></dxe:ASPxGridViewTemplateReplacement>
                                </div>
                            </td>
                            <%--<td style="width: 25%"></td>--%>
                        </tr>
                    </table>
                </EditForm>
            </Templates>
            <SettingsBehavior ConfirmDelete="True" AllowFocusedRow="true" />
            <SettingsPager NumericButtonCount="20" PageSize="20" AlwaysShowPager="True" ShowSeparators="True">
                <FirstPageButton Visible="True">
                </FirstPageButton>
                <LastPageButton Visible="True">
                </LastPageButton>
            </SettingsPager>
            <%-- <Styles>
                <Header CssClass="gridheader" SortingImageSpacing="5px" ImageSpacing="5px">
                </Header>
                <FocusedRow CssClass="gridselectrow">
                </FocusedRow>
                <LoadingPanel ImageSpacing="10px">
                </LoadingPanel>
                <FocusedGroupRow CssClass="gridselectrow">
                </FocusedGroupRow>
            </Styles>--%>
            <%--    <SettingsPager NumericButtonCount="20" PageSize="20" AlwaysShowPager="True" ShowSeparators="True">
                <FirstPageButton Visible="True">
                </FirstPageButton>
                <LastPageButton Visible="True">
                </LastPageButton>
            </SettingsPager>--%>
            <Columns>
                <dxe:GridViewDataComboBoxColumn Visible="False" FieldName="AccountGroupType" Caption="Account Type"
                    VisibleIndex="1" Width="50px">
                    <PropertiesComboBox ValueType="System.String" Width="200px">
                        <Items>
                            <dxe:ListEditItem Value="Asset" Text="Asset"></dxe:ListEditItem>
                            <dxe:ListEditItem Value="Liability" Text="Liability"></dxe:ListEditItem>
                            <dxe:ListEditItem Value="Income" Text="Income"></dxe:ListEditItem>
                            <dxe:ListEditItem Value="Expenses" Text="Expenses"></dxe:ListEditItem>
                            <%--#ag18102016 - 0011279--%>
                        </Items>
                    </PropertiesComboBox>
                    <CellStyle CssClass="gridcellleft">
                    </CellStyle>
                    <EditFormSettings Visible="True" VisibleIndex="1"></EditFormSettings>
                </dxe:GridViewDataComboBoxColumn>
                <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="3" FieldName="AccountGroupCode"
                    Caption="Short Name">
                    <CellStyle CssClass="gridcellleft">
                    </CellStyle>
                    <PropertiesTextEdit Width="200px" MaxLength="50">

                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right"  >
                            <RequiredField IsRequired="True" ErrorText="Mandatory"></RequiredField>
                            <%--#ag18102016 - 0011279--%>
                        </ValidationSettings>
                        <ClientSideEvents TextChanged="function(s,e){UniqueCodeCheck()}" />
                    </PropertiesTextEdit>
                    <EditFormSettings Visible="True" VisibleIndex="2"></EditFormSettings>

                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn VisibleIndex="0" FieldName="AccountGroupName" Caption="Name">
                    <CellStyle CssClass="gridcellleft">
                    </CellStyle>
                    <PropertiesTextEdit Width="200px" MaxLength="50">
                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right">
                            <RequiredField IsRequired="True" ErrorText="Mandatory"></RequiredField>
                            <%--#ag18102016 - 0011279--%>
                        </ValidationSettings>
                         <ClientSideEvents TextChanged="function(s,e){UniqueNameCheck()}" />
                    </PropertiesTextEdit>
                    <EditFormCaptionStyle Wrap="False" HorizontalAlign="Right">
                    </EditFormCaptionStyle>
                    <EditFormSettings Visible="True" VisibleIndex="3"></EditFormSettings>
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataComboBoxColumn FieldName="AccountGroupParentID" Caption="Parent ID"
                    VisibleIndex="2">
                    <PropertiesComboBox ValueType="System.Int64" TextField="ParentIDWithName" ValueField="AccountGroupParentID" Width="200px"
                        DataSourceID="SqlDs1AccountGroupParentID">
                        <%--  <ClientSideEvents SelectedIndexChanged="function(s,e){OnParentChanged(s); }" ></ClientSideEvents>--%>
                    </PropertiesComboBox>
                    <Settings FilterMode="DisplayText"></Settings>
                    <CellStyle CssClass="gridcellleft">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False" HorizontalAlign="Right" VerticalAlign="Top">
                    </EditFormCaptionStyle>
                    <EditFormSettings Visible="True" VisibleIndex="4"></EditFormSettings>
                </dxe:GridViewDataComboBoxColumn>
                <dxe:GridViewCommandColumn VisibleIndex="4" ShowDeleteButton="true" ShowEditButton="true" HeaderStyle-HorizontalAlign="Center" Width="6%">
                    <%-- <DeleteButton Visible="True">
                </DeleteButton>--%>
                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                    <HeaderTemplate>
                        <span>Actions</span>
                        <%-- <a href="javascript:void(0);" onclick="grid.AddNewRow()"><span>Add New</span> </a>--%>
                    </HeaderTemplate>
                    <%--  <EditButton Visible="True">
                </EditButton>--%>
                </dxe:GridViewCommandColumn>
            </Columns>
            <SettingsCommandButton>
                <EditButton Image-Url="../../../assests/images/Edit.png" ButtonType="Image" Image-AlternateText="Edit" Styles-Style-CssClass="pad">
                    <Image AlternateText="Edit" Url="../../../assests/images/Edit.png"></Image>

                    <Styles>
                        <Style CssClass="pad"></Style>
                    </Styles>
                </EditButton>
                <DeleteButton Image-Url="../../../assests/images/Delete.png" ButtonType="Image" Image-AlternateText="Delete">
                    <Image AlternateText="Delete" Url="../../../assests/images/Delete.png"></Image>
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
            </SettingsCommandButton>
            <SettingsEditing Mode="PopupEditForm" PopupEditFormHorizontalAlign="WindowCenter"
                PopupEditFormModal="True" PopupEditFormVerticalAlign="WindowCenter" PopupEditFormWidth="500px"
                EditFormColumnCount="1" />
            <SettingsText PopupEditFormCaption="Add/Modify Account Group" ConfirmDelete="Confirm Delete?" />
            <SettingsSearchPanel Visible="True" />
            <settings showgrouppanel="True" showstatusbar="Visible" showfilterrow="true" showfilterrowmenu="True" />
        </dxe:ASPxGridView>
        <asp:SqlDataSource ID="SqlDsAccountGroup" runat="server"
            DeleteCommand="DELETE FROM [Master_AccountGroup] WHERE [AccountGroup_ReferenceID] = @AccountGroupID"
            InsertCommand="InsertInAccountGroup"
            InsertCommandType="StoredProcedure" SelectCommand="SELECT a.[AccountGroup_ReferenceID] as AccountGroupID,a.[AccountGroup_Type] as AccountGroupType ,a.[AccountGroup_Code] as AccountGroupCode ,a.[AccountGroup_Name] as AccountGroupName,a.[AccountGroup_ParentGroupID]as AccountGroupParentID1,b.AccountGroup_Name as AccountGroupParentID FROM [Master_AccountGroup] AS a LEFT OUTER JOIN [Master_AccountGroup] AS B on a.AccountGroup_ParentGroupID=b.AccountGroup_ReferenceID order by AccountGroupID Desc"
            UpdateCommand="UPDATE [Master_AccountGroup] SET [AccountGroup_Type] = @AccountGroupType, AccountGroup_Code = @AccountGroupCode, AccountGroup_Name = @AccountGroupName, [AccountGroup_ParentGroupID] = @AccountGroupParentID WHERE [AccountGroup_ReferenceID] = @AccountGroupID">
            <DeleteParameters>
                <asp:Parameter Name="AccountGroupID" Type="int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="AccountGroupID" Type="int32" />
                <asp:Parameter Name="AccountGroupType" Type="String" />
                <asp:Parameter Name="AccountGroupCode" Type="String" />
                <asp:Parameter Name="AccountGroupName" Type="String" />
                <asp:Parameter Name="AccountGroupParentID" Type="Int32" />
                <asp:Parameter Name="CreateUser" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="AccountGroupType" Type="String" />
                <asp:Parameter Name="AccountGroupCode" Type="String" />
                <asp:Parameter Name="AccountGroupName" Type="String" />
                <asp:Parameter Name="AccountGroupParentID" Type="Int32" />
                <asp:SessionParameter Name="CreateUser" SessionField="userid" Type="int32" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDs1AccountGroupParentID" runat="server" ConflictDetection="CompareAllValues"
            ConnectionString="<%$ ConnectionStrings:crmConnectionString %>" SelectCommand=""></asp:SqlDataSource>
        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
    </div>
</asp:Content>


