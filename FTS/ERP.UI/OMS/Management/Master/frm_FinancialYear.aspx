<%@ Page Title="Financial Year" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" Inherits="ERP.OMS.Management.Master.management_master_frm_FinancialYear" CodeBehind="frm_FinancialYear.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        function DeleteRow(keyValue) {
            if (confirm('Confirm Delete')) {
                grid.PerformCallback('DeleteFinancialYear~' + keyValue);
                grid.Refresh();
            }
            else {

            }


        }
        function ClickOnMoreInfo(keyValue) {
            var ss = document.getElementById('dtTo_hidden').value;
            if (ss != null) {
                var dat = ss;
                var url = 'Master/frmClosingRatesAdd.aspx?id=' + keyValue + '&dtfor=' + dat;
                OnMoreInfoClick(url, "Edit Closing Rates", '700px', '350px', "Y");
            }


        }
        function ShowHideFilter(obj) {
            grid.PerformCallback(obj);
        }

        function EditBranch(bgid) {
            var url = 'frm_FinancialYearAdd.aspx?FinYearID=' + bgid;
            //window.open(url,'aa'); 
            //OnMoreInfoClick(url, "Edit BranchGroup", '940px', '450px', 'Y');
            window.location.href = url;

        }

        function OnAddButtonClick(FinYearID) {
            var url = 'frm_FinancialYearAdd.aspx?FinYearID=' + FinYearID;
            //OnMoreInfoClick(url, "Add New Financial Year", '700px', '350px', "Y");
            window.location.href = url;
        }
        function callback() {
            grid.PerformCallback();

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Financial Year</h3>
        </div>
    </div>
    <div class="form_main">
         <div class="SearchArea">
            <div class="FilterSide">
                <div style="float: left; padding-right: 5px;">
                    <% if (rights.CanAdd)
                       { %>
                    <a href="javascript:void(0);" onclick="javascript:OnAddButtonClick();" class="btn btn-primary"><span>Add New</span> </a>

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
        <table class="TableMain100">
            <%--<tr>
                <td class="EHEADER" style="text-align: center;">
                    <strong><span style="color: #000099">Financial Year</span></strong>
                </td>
            </tr>--%>
          
            <tr>
                <td>
                    <dxe:ASPxGridView ID="gridStatus" ClientInstanceName="grid" Width="100%"
                        KeyFieldName="FinYear_ID" DataSourceID="gridStatusDataSource" runat="server"
                        AutoGenerateColumns="False" OnCustomCallback="gridStatus_CustomCallback">
                        <settingsbehavior allowfocusedrow="True" confirmdelete="True" />
                        <styles>
                            <%--   <Header CssClass="gridheader">
                                </Header>--%>
                            <%-- <FocusedRow CssClass="gridselectrow" BackColor="#FCA977">
                            </FocusedRow>--%>
                            <FocusedGroupRow CssClass="gridselectrow" BackColor="#FCA977">
                            </FocusedGroupRow>
                        </styles>
                        <%--                        <SettingsPager NumericButtonCount="20" PageSize="20" ShowSeparators="True" AlwaysShowPager="True">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                        </SettingsPager>--%>
                        <columns>
                            <dxe:GridViewDataTextColumn Visible="false" FieldName="FinYear_ID" Caption="ID">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="FinYear_Code"
                                Caption="Financial Year">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="FinYear_StartDate"
                                Caption="Start Date">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="FinYear_EndDate"
                                Caption="End Date" Visible="true">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="FinYear_Remarks"
                                Caption="Remarks">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <%--  <DataItemTemplate>
                                    <a href="javascript:void(0);" onclick="javascript:OnAddButtonClick();"><span style="text-decoration: underline">Edit</span> </a>
                                </DataItemTemplate>--%>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>


                           <dxe:GridViewDataTextColumn FieldName="Actions" VisibleIndex="4" HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="Center" Width="5%">
                                <Settings AllowAutoFilter="False"></Settings>
                                <DataItemTemplate>
                                      <% if (rights.CanEdit)
                                       { %>
                                    <a href="javascript:void(0);" onclick="EditBranch('<%# Container.KeyValue %>')" title="Status"><img src="../../../assests/images/Edit.png" />                                                              
                                    </a><%} %>
                                </DataItemTemplate>
                                <EditFormSettings Visible="False" />
                                <CellStyle Wrap="False">
                                </CellStyle>
                                <HeaderStyle Wrap="False" />
                            </dxe:GridViewDataTextColumn>
                             </columns>
                        <%-- <dxe:GridViewDataTextColumn VisibleIndex="5" Width="60px" Caption="Details">
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <HeaderTemplate>
                                    <a href="javascript:void(0);" onclick="javascript:OnAddButtonClick();"><span style="color: #000099; text-decoration: underline">Add New</span> </a>
                                </HeaderTemplate>
                                <DataItemTemplate>
                                    <a href="javascript:void(0);" onclick="DeleteRow('<%# Container.KeyValue %>')">
                                        <img src="../../../assests/images/Delete.png" /></a>
                                </DataItemTemplate>
                                <CellStyle Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>--%>
                        <%--  <dxe:GridViewCommandColumn ShowEditButton="true" VisibleIndex="4" ShowDeleteButton="false" ButtonType="Button">
                                 <HeaderTemplate>
                                     <span>Action</span>
                                 </HeaderTemplate>
                             </dxe:GridViewCommandColumn>
                        </columns>
                        <settingscommandbutton>

                            <EditButton Image-ToolTip="Delete" ButtonType="Image" Image-Url="../../../assests/images/Edit.png" Text="Edit"></EditButton>
                            <DeleteButton Image-ToolTip="Delete"  ButtonType="Image" Image-Url="../../../assests/images/Delete.png" Text="Delete"></DeleteButton>
                            <UpdateButton Text="Save" ButtonType="Button" Image-Width="25px"></UpdateButton>
                            <CancelButton Text="Cancel" ButtonType="Button" Image-Width="25px"></CancelButton>
                        </settingscommandbutton>--%>
                        <settingstext confirmdelete="Confirm delete?" />
                        <SettingsSearchPanel Visible="True" />
                        <settings showfilterrow="true" showgrouppanel="true" ShowFilterRowMenu="true" />
                        <settingsbehavior allowfocusedrow="false" columnresizemode="NextColumn" />
                        <styleseditors>
                            <ProgressBar Height="25px">
                            </ProgressBar>
                        </styleseditors>
                    </dxe:ASPxGridView>
                    <asp:SqlDataSource ID="gridStatusDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
                        SelectCommand="">
                        <SelectParameters>
                            <asp:SessionParameter Name="userlist" SessionField="userchildHierarchy" Type="string" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
            </tr>
        </table>
    </div>
     <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
</asp:Content>
