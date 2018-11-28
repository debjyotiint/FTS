<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="IndustryMapReport.aspx.cs" Inherits="ERP.OMS.Management.Master.IndustryMapReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function OnContextMenuItemClick(sender, args) {
            if (args.item.name == "ExportToPDF" || args.item.name == "ExportToXLS") {
                args.processOnServer = true;
                args.usePostBack = true;
            } else if (args.item.name == "SumSelected")
                args.processOnServer = true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="panel-heading">
        <div class="panel-title">
            <%-- <h3>Contact Bank List</h3>--%>
            <h3>Industry Report </h3>
            <div class="crossBtn"><a href="ProjectMainPage.aspx"><i class="fa fa-times"></i></a></div>
        </div>

    </div>
    <div class="form_main">
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
        <table class="TableMain100">
            <tr>
                <td>
                    <dxe:ASPxGridView runat="server" ID="GridIndustryMap" ClientInstanceName="Grid" Width="100%" EnableRowsCache="false"
                        DataSourceID="IndustryDataSource" SettingsPager-Mode="ShowAllRecords"  Settings-VerticalScrollBarMode="auto" Settings-VerticalScrollableHeight="323" >
                        <columns>
               <dxe:GridViewDataComboBoxColumn FieldName="EntityType" Caption="Entity Name" GroupIndex="0" SortOrder="Descending">
                <PropertiesComboBox DataSourceID="EntityDataSource" 
                    ValueField="EntityType" TextField="EntityName" />
            </dxe:GridViewDataComboBoxColumn>
            <dxe:GridViewDataTextColumn FieldName="EntityName" Caption="EntityType" Visible="false" />

             

         <%--     <dxe:GridViewDataTextColumn FieldName="EntityName" Caption="Entity" />--%>
                <dxe:GridViewDataTextColumn FieldName="IndustryName" Caption="Industry" VisibleIndex="2" />
              <dxe:GridViewDataTextColumn FieldName="IndustryMap_EntityName"  Caption="Name" VisibleIndex="1"/>
        </columns>
                        
                        <settingsediting mode="EditForm" />
                        <settingscontextmenu enabled="true" />
                        <settingsbehavior autoexpandallgroups="true" />
                        <SettingsSearchPanel Visible="True" />
                        <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowFilterRow="true" ShowFilterRowMenu = "True" />
                       <SettingsPager Mode="ShowAllRecords"  ></SettingsPager>
                    </dxe:ASPxGridView>
                </td>
            </tr>
        </table>
      
    </div>

    <asp:SqlDataSource ID="IndustryDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="sp_IndustryMap_Report" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
    <asp:SqlDataSource ID="EntityDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        SelectCommand="SELECT Id EntityType,EntityName FROM tbl_Entity order by Id"></asp:SqlDataSource>
    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>
</asp:Content>
