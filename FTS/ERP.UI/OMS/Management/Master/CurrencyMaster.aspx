<%@ Page Title="Currency Master" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" CodeBehind="CurrencyMaster.aspx.cs" Inherits="ERP.OMS.Management.Master.CurrencyMaster" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    

    <script language="javascript" type="text/javascript">

        function OnEditButtonClick(keyValue) {
            debugger;
            var url = 'frm_currency_master.aspx?id=' + keyValue;
            window.location.href = url;
        }

        function EndCall(obj) {
            if (grid.cpDelmsg != null) {
                jAlert(grid.cpDelmsg);
                grid.cpDelmsg = null;
            }
        }

        function OnAddButtonClick() {
            var url = 'frm_currency_master.aspx?id=ADD';
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
            <h3>Currency Master</h3>
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
                                <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true"  >
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
                <td class="gridcellright" style="float: right; vertical-align: top">
              
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; text-align: left" colspan="2">
                    <dxe:ASPxGridView ID="gridFinancer" ClientInstanceName="grid" Width="100%"
                        KeyFieldName="CRID" DataSourceID="gridFinancerDataSource" runat="server"
                        AutoGenerateColumns="False" OnCustomCallback="gridStatus_CustomCallback" >
                                    <clientsideevents endcallback="function(s, e) {
	                              EndCall(s.cpEND);
                            }" />
                        <Columns>
                            <dxe:GridViewDataTextColumn Visible="True" FieldName="cmp_name" Caption="Company Name">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                             <dxe:GridViewDataTextColumn Visible="True" FieldName="currency_name" Caption="Base Currency" VisibleIndex="2">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>


                            <dxe:GridViewDataTextColumn Visible="False" FieldName="ConversionCurrency_ID" Caption="Conversion Currency" VisibleIndex="4">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Visible="True" FieldName="ConversionCurrency_Name" Caption="Conversion Currency" VisibleIndex="4">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn VisibleIndex="10" CellStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" Width="6%">
                                

                                <DataItemTemplate>
                                    <% if (rights.CanEdit)
                                        { %>
                                <%--    <a href="javascript:void(0);" onclick="OnEditButtonClick('<%# Eval("cmp_id") %>','<%# Eval("BaseCurrency_ID") %>','<%# Eval("ConversionDate") %>','<%# Eval("SalesRate") %>','<%# Eval("PurchaseRate") %>')" title="More Info" class="pad">
                                        <img src="../../../assests/images/info.png" />
                                    </a>--%>
                                    <a href="javascript:void(0);" onclick="OnEditButtonClick('<%# Container.KeyValue %>')" title="More Info" class="pad">
                                        <img src="../../../assests/images/info.png" />
                                    </a>
                                       <% } %>
                                     <% if (rights.CanDelete)
                                       { %>
                                     <a href="javascript:void(0);" onclick="DeleteRow('<%# Container.KeyValue %>')" title="Delete">
                                        <img src="../../../assests/images/Delete.png" /></a>
                                       <% } %>
                                </DataItemTemplate>

<HeaderStyle HorizontalAlign="Center"></HeaderStyle>

<CellStyle HorizontalAlign="Center"></CellStyle>
                                <HeaderTemplate>Actions</HeaderTemplate> 
                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn FieldName="SalesRate" VisibleIndex="5" Caption="Sale Rate">
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Purchase Rate" FieldName="PurchaseRate" VisibleIndex="6">
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Conversion Date" FieldName="ConversionDate" VisibleIndex="7">
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="comp_id" FieldName="cmp_id" Visible="False" VisibleIndex="1">
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="curr_id" FieldName="BaseCurrency_ID" Visible="False" VisibleIndex="3">
                            </dxe:GridViewDataTextColumn>

                        </Columns>

                        <SettingsText ConfirmDelete="Confirm delete?" />
                        <StylesEditors>
                            <ProgressBar Height="25px">
                            </ProgressBar>
                        </StylesEditors>
                        <SettingsSearchPanel Visible="True" />
                        <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowFilterRow="true" ShowFilterRowMenu = "True" /> 
                        <SettingsBehavior ColumnResizeMode="NextColumn" ConfirmDelete="True" />
                    </dxe:ASPxGridView>
                </td>
            </tr>
        </table>
        <dxe:ASPxGridViewExporter ID="exporter" runat="server">
        </dxe:ASPxGridViewExporter>
        <asp:SqlDataSource ID="gridFinancerDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
          
            SelectCommand="select CRID,(select cmp_id from tbl_master_company where cmp_internalid=h.cmp_internalid) as cmp_id,(select cmp_name from tbl_master_company where cmp_internalid=h.cmp_internalid) as cmp_name,h.BaseCurrency_ID,(select Currency_AlphaCode from Master_Currency where Currency_ID=h.BaseCurrency_ID) as currency_name,h.ConversionCurrency_ID,(select Currency_AlphaCode from Master_Currency where Currency_ID=h.ConversionCurrency_ID) as ConversionCurrency_Name,h.SalesRate,h.PurchaseRate,CONVERT(CHAR(23),CONVERT(DATETIME,cast(h.ConversionDate as datetime),101),121) as 'ConversionDate' from tbl_Master_CurrencyRateDateWise h where h.cmp_internalid=@session_cmpintrid">
         
             <SelectParameters>
                <asp:SessionParameter Name="session_cmpintrid" SessionField="LastCompany" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>

