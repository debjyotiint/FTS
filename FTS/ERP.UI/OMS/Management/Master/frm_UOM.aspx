<%@ Page Title="UOM" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" Inherits="ERP.OMS.Management.Master.management_master_frm_UOM" CodeBehind="frm_UOM.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">

        function PopulateGrid(obj) {

            grid.PerformCallback(obj);
        }
        function Changestatus(obj,obj2) {
           
            //alert(obj);
            //alert(obj2);
            var URL = "changeunit.aspx?id=" + obj + "(" + obj2;
            window.location.href = URL;
            //editwin = dhtmlmodal.open("Editbox", "iframe", URL, "Change Unit", "width=995px,height=300px,center=0,resize=1,top=-1", "recal");
            //editwin.onclose = function () {
            //    grid.PerformCallback();
            //}
        }
        function ShowHideFilter(obj) {
            grid.PerformCallback(obj);
        }
        function callback() {
            grid.PerformCallback();
        }
        function callheight(obj) {
            //height();
            // parent.CallMessage();
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Units Of Measurement [UOM]</h3>
        </div>

    </div>
    <div class="form_main">
        <table class="TableMain100">
            <%-- <tr>
                    <td class="EHEADER" style="text-align: center;">
                        <strong><span style="color: #000099">Units Of Measurement [UOM] </span></strong>
                    </td>
                </tr>--%>
            <tr>
                <td style="text-align: left; vertical-align: top">
                    <table width="100%">
                        <tr>
                            <td id="ShowFilter" class="pull-left">
                                <%-- <a href="javascript:ShowHideFilter('s');" class="btn btn-success"><span>Show Filter</span></a>--%>
                                <% if (rights.CanExport)
                                               { %>
                                <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true"  OnChange="if(!AvailableExportOption()){return false;}">
                                    <asp:ListItem Value="0">Export to</asp:ListItem>
                                    <asp:ListItem Value="1">PDF</asp:ListItem>
                                        <asp:ListItem Value="2">XLS</asp:ListItem>
                                        <asp:ListItem Value="3">RTF</asp:ListItem>
                                        <asp:ListItem Value="4">CSV</asp:ListItem>
                                </asp:DropDownList>
                                <% } %>
                            </td>
                            <td id="Td1" class="pull-left">
                               <%-- <a href="javascript:ShowHideFilter('All');" class="btn btn-primary"><span>All Records</span></a>--%>
                            </td>

                           
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <dxe:ASPxGridView ID="grdDocuments" runat="server" AutoGenerateColumns="False"
                        KeyFieldName="tmp_id" Width="100%" OnRowDeleting="grdDocuments_RowDeleting" ClientInstanceName="grid"
                        OnCustomCallback="grdDocuments_CustomCallback" OnHtmlRowCreated="grdDocuments_HtmlRowCreated">
                        <%--<SettingsBehavior AllowFocusedRow="True" ColumnResizeMode="NextColumn" />--%>
                        <Settings ShowGroupPanel="True" ShowStatusBar="Visible" />
                        <%-- <ClientSideEvents EndCallback="function(s, e) {
	callheight(s.cpHeight);
}" />--%>
                        <%-- <Templates>
                            <EditForm>
                                <table style="width: 100%">
                                    <tr>
                                        <td style="width: 25%">
                                        </td>
                                        <td style="width: 50%">
                                            <controls>
                                <dxe:ASPxGridViewTemplateReplacement runat="server" ReplacementType="EditFormEditors" ColumnID="" ID="Editors">
                                </dxe:ASPxGridViewTemplateReplacement>                                                           
                            </controls>
                                            <div style="text-align: right; padding: 2px 2px 2px 2px">
                                                <dxe:ASPxGridViewTemplateReplacement ID="UpdateButton" ReplacementType="EditFormUpdateButton"
                                                    runat="server">
                                                </dxe:ASPxGridViewTemplateReplacement>
                                                <dxe:ASPxGridViewTemplateReplacement ID="CancelButton" ReplacementType="EditFormCancelButton"
                                                    runat="server">
                                                </dxe:ASPxGridViewTemplateReplacement>
                                            </div>
                                        </td>
                                        <td style="width: 25%">
                                        </td>
                                    </tr>
                                </table>
                            </EditForm>
                        </Templates>--%>
                        <Templates>
                            <TitlePanel>
                                <table style="width: 100%">
                                    <tr>
                                        <td align="right">
                                            <table width="200px">
                                                <tr>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </TitlePanel>
                            <EditForm>
                            </EditForm>
                        </Templates>
                        <SettingsPager NumericButtonCount="20" PageSize="20" ShowSeparators="True" AlwaysShowPager="True">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                        </SettingsPager>
                        <SettingsEditing Mode="PopupEditForm" PopupEditFormHeight="200px" PopupEditFormHorizontalAlign="Center" 
                            PopupEditFormModal="True" PopupEditFormVerticalAlign="WindowCenter" PopupEditFormWidth="600px"
                            EditFormColumnCount="1" />
                        <SettingsSearchPanel Visible="True" />
                        <Settings ShowGroupPanel="True" ShowFilterRow="true" ShowFilterRowMenu="True" />
                        <SettingsBehavior ConfirmDelete="True" AllowFocusedRow="true" />
                        <SettingsText PopupEditFormCaption="Add/Modify " ConfirmDelete="Confirm delete?" />
                        <Columns>
                            <dxe:GridViewDataTextColumn FieldName="tmp_id" ReadOnly="True" VisibleIndex="0"
                                Visible="false">
                                <CellStyle HorizontalAlign="Left">
                                </CellStyle>
                                <HeaderStyle HorizontalAlign="Center" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="tmp_name" Caption="Name" Width="25%" ReadOnly="True"
                                VisibleIndex="0">
                                <CellStyle HorizontalAlign="left">
                                </CellStyle>
                                <HeaderStyle HorizontalAlign="left" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="tmp_usedfor" Caption="Used For" Width="22%"
                                VisibleIndex="1" Visible="true">
                                <CellStyle HorizontalAlign="left">
                                </CellStyle>
                                <HeaderStyle HorizontalAlign="left" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="tmp_shortname" Caption="Short Name" Width="22%"
                                VisibleIndex="2">
                                <CellStyle HorizontalAlign="left">
                                </CellStyle>
                                <HeaderStyle HorizontalAlign="left" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="tmp_convuomname" Caption="Converted To"
                                Width="22%" VisibleIndex="3">
                                <CellStyle HorizontalAlign="left">
                                </CellStyle>
                                <HeaderStyle HorizontalAlign="left" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Width="6%" VisibleIndex="4">
                                <HeaderTemplate>
                                    <span>Actions</span>
                                </HeaderTemplate>
                                <DataItemTemplate>
                                     <% if (rights.CanEdit)
                                               { %>
                                    <a href="javascript:void(0);" onclick="Changestatus('<%# Container.KeyValue %>',<%#Eval("tmp_convuom") %>)" title="Edit" class="pad" style="cursor:pointer;">
                                <img src="../../../assests/images/Edit.png" /></a>
                                   <%} %>
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Center">
                                </CellStyle>
                                <HeaderStyle HorizontalAlign="Center" />
                            </dxe:GridViewDataTextColumn>
                            <%--<dxe:GridViewCommandColumn VisibleIndex="4">
                                <EditButton Visible="True">
                                </EditButton>
                                <DeleteButton Visible="True">
                                </DeleteButton>
                                <HeaderStyle HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    <%if (Session["PageAccess"].ToString().Trim() == "All" || Session["PageAccess"].ToString().Trim() == "Add" || Session["PageAccess"].ToString().Trim() == "DelAdd")
                      { %>
                                    <a href="javascript:void(0);" onclick="grid.AddNewRow()"><span style="color: #000099;
                                        text-decoration: underline">Add New</span> </a>
                                    <%} %>
                                </HeaderTemplate>
                            </dxe:GridViewCommandColumn>--%>
                        </Columns>
                        <Styles>
                            <Header SortingImageSpacing="5px" ImageSpacing="5px" CssClass="gridheader"></Header>
                            <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                            <Header ImageSpacing="5px" SortingImageSpacing="5px">
                            </Header>
                            <FocusedGroupRow CssClass="gridselectrow">
                            </FocusedGroupRow>
                            <FocusedRow CssClass="gridselectrow">
                            </FocusedRow>
                        </Styles>
                    </dxe:ASPxGridView>
                    <%--   <asp:SqlDataSource ID="grddoc" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                            SelectCommand="" DeleteCommand="DELETE FROM [tbl_master_forms] WHERE [frm_id] = @formID">
                            <DeleteParameters>
                                <asp:Parameter Name="formID" Type="int32" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:SessionParameter Name="userlist" SessionField="userchildHierarchy" Type="string" />
                            </SelectParameters>
                        </asp:SqlDataSource>--%>
                </td>
            </tr>
            <tr>
                <td style="display: none;">
                    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox></td>
            </tr>
        </table>
        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
    </div>
</asp:Content>
