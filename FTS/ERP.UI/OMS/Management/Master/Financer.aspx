<%@ Page Title="Financer" Language="C#" AutoEventWireup="True" MasterPageFile="~/OMS/MasterPage/ERP.Master" Inherits="ERP.OMS.Management.Master.management_master_Financer" CodeBehind="Financer.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">



    <script language="javascript" type="text/javascript">
        function OnViewExecutive(keyValue) {
            cPopup_ViewExecutive.Show();
            cAspxExecutiveGrid.PerformCallback(keyValue);
        }

        function OnEditButtonClick(keyValue) {
            var url = 'FinancerAddEdit.aspx?id=' + keyValue;
            window.location.href = url;
        }

        function EndCall(obj) {
            if (grid.cpDelmsg != null) {
                jAlert(grid.cpDelmsg);
                grid.cpDelmsg = null;
            }
        }

        function OnAddButtonClick() {
            var url = 'FinancerAddEdit.aspx?id=ADD';
            window.location.href = url;
        }

        function DeleteRow(keyValue) {

            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    grid.PerformCallback('Delete~' + keyValue);
                }
            });

        }


    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Financer</h3>
        </div>
    </div>
    
    <div class="form_main">
        <table class="TableMain100" style="width: 100%">
            <tr>
                <td style="text-align: left; vertical-align: top">
                    <table>
                        <tr>
                            <td id="ShowFilter">
                                <% if (rights.CanAdd)
                                   { %>
                                <a href="javascript:void(0);" onclick="javascript:OnAddButtonClick();" class="btn btn-primary">Add New</a>
                                <% } %>
                                <% if (rights.CanExport)
                                   { %>
                                <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Value="0">Export to</asp:ListItem>
                                    <asp:ListItem Value="1">PDF</asp:ListItem>
                                    <asp:ListItem Value="2">XLS</asp:ListItem>
                                    <asp:ListItem Value="3">RTF</asp:ListItem>
                                    <asp:ListItem Value="4">CSV</asp:ListItem>

                                </asp:DropDownList>
                                <% } %>
                            </td>

                        </tr>
                    </table>
                </td>
                <td class="gridcellright" style="float: right; vertical-align: top"></td>
            </tr>
            <tr>
                <td style="vertical-align: top; text-align: left" colspan="2">
                    <dxe:ASPxGridView ID="gridFinancer" ClientInstanceName="grid" Width="100%"
                        KeyFieldName="cnt_id" runat="server"
                        AutoGenerateColumns="False" OnCustomCallback="gridStatus_CustomCallback"><%--DataSourceID="gridFinancerDataSource" --%>
                        <clientsideevents endcallback="function(s, e) {
	                              EndCall(s.cpEND);
                            }" />
                        <columns>
                            <dxe:GridViewDataTextColumn Visible="True" FieldName="cnt_ucc" Caption="Financer ID">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                             <dxe:GridViewDataTextColumn Visible="True" FieldName="cnt_firstName" Caption="Financer Name">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>


                            <dxe:GridViewDataTextColumn Visible="True" FieldName="branch" Caption="Branch">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>


                            <dxe:GridViewDataTextColumn VisibleIndex="10" CellStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" Width="150px">
                                

                                <DataItemTemplate>
                                    <% if (rights.CanEdit)
                                       { %>
                                    <a href="javascript:void(0);" onclick="OnEditButtonClick('<%# Container.KeyValue %>')" title="More Info" class="pad">
                                        <img src="../../../assests/images/info.png" />
                                    </a>
                                       <% } %>
                                     <% if (rights.CanDelete)
                                        { %>
                                     <a href="javascript:void(0);" onclick="DeleteRow('<%# Container.KeyValue %>')" title="Delete" class="pad">
                                        <img src="../../../assests/images/Delete.png" /></a>
                                       <% } %>

                                    <a href="javascript:void(0);" onclick="OnViewExecutive('<%# Container.KeyValue %>')" title="Executive" class="pad">
                                        <img src="../../../assests/images/icoaccts.gif" />
                                    </a>

                                </DataItemTemplate>
                                <HeaderTemplate>Actions</HeaderTemplate> 
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                        </columns>

                        <settingstext confirmdelete="Confirm delete?" />
                        <styleseditors>
                            <ProgressBar Height="25px">
                            </ProgressBar>
                        </styleseditors>
                        <settingssearchpanel visible="True" />
                        <settings showgrouppanel="True" showstatusbar="Hidden" showfilterrow="true" showfilterrowmenu="True" />
                        <settingsbehavior columnresizemode="NextColumn" confirmdelete="True" />
                    </dxe:ASPxGridView>
                </td>
                <td>
                    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
                    </dxe:ASPxGridViewExporter>
                </td>
            </tr>
        </table>
        <%--<dxe:ASPxGridViewExporter ID="exporter" runat="server">
        </dxe:ASPxGridViewExporter>--%>
        <%--<asp:SqlDataSource ID="gridFinancerDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="select h.cnt_id,h.cnt_ucc,h.cnt_firstName,(select branch_description from tbl_master_branch d where d.branch_id=h.cnt_branchId) as branch,* from tbl_master_contact h where cnt_contactType='FI'"></asp:SqlDataSource>--%>
    </div>
</asp:Content>
