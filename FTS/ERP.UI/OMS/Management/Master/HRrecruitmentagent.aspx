<%@ Page Title="Vendors/Service Providers" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master"
    Inherits="ERP.OMS.Management.Master.management_master_HRrecruitmentagent" CodeBehind="HRrecruitmentagent.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        
        #EmployeeGrid_DXPagerBottom {
            min-width:100% !important;
        }
    </style>
    <script type="text/javascript">
        function OnContactInfoClick(keyValue) {
            var url = 'insurance_contactPerson.aspx?id=' + keyValue;
            //OnMoreInfoClick(url, "Name : " + name + "", '940px', '450px', 'Y');
            window.location.href = url;
        }

        function ClickOnMoreInfo(keyValue) {
            var url = 'HRrecruitmentagent_general.aspx?id=' + keyValue;
            //OnMoreInfoClick(url, 'Modify Agent Details', '940px', '450px', 'Y');
            window.location.href = url;
        }
        function callback() {
            grid.PerformCallback();
        }
        function OnAddButtonClick() {
            //var url = 'HRrecruitmentagent_general.aspx?id=' + 'ADD';            
            //window.location.href = url;

            var isLighterPage = $("#hidIsLigherContactPage").val();
            // alert(isLighterPage);
            if (isLighterPage == 1) {
                var url = '/OMS/management/Master/VendorMasterPagePopup.html?var=1.6';
                // alert(url);
                AspxDirectAddCustPopup.SetContentUrl(url);
                AspxDirectAddCustPopup.RefreshContentUrl();
                AspxDirectAddCustPopup.Show();
            }
            else {
                var url = 'HRrecruitmentagent_general.aspx?id=' + 'ADD';
                window.location.href = url;

            }



        }

        function ParentCustomerOnClose(newCustId, CustomerName, CustUniqueName, BillingStateText, BillingStateCode, ShippingStateText, ShippingStateCode) {
            AspxDirectAddCustPopup.Hide();
            var url = 'HRrecruitmentagent.aspx?requesttype=VendorService';
            window.location.href = url;

        }

        function ShowHideFilter(obj) {
            grid.PerformCallback(obj);
        }

        function OnDelete(keyValue) {
            jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                if (r == true) {
                    grid.PerformCallback('Delete~' + keyValue);
                }
            });
        }
        function ShowError(obj) {
            if (grid.cpDelete != null) {
                if (grid.cpDelete == 'Success') {
                    jAlert('Deleted Successfully');
                    grid.cpDelete = null;
                }
                else {
                    jAlert('Used in other module.Can not delete');
                    grid.cpDelete = null;
                }

            }
        }

      

       


    </script>




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Vendors/Service Providers</h3>
        </div>

    </div>
    <div class="form_main">

        <table class="TableMain100">

            <tr>
                <td>
                    <table width="100%">
                        <tr>
                            <td style="text-align: left; vertical-align: top">
                                <table>
                                    <tr>
                                        <td id="ShowFilter">
                                            <% if (rights.CanAdd)
                                               { %>
                                            <a href="javascript:void(0);" onclick="OnAddButtonClick()" class="btn btn-primary">Add New </a>
                                            <%} %>
                                            <%--<a href="javascript:ShowHideFilter('s');" class="btn btn-primary"><span>Show Filter</span></a>--%>
                                           <% if (rights.CanExport)
                                               { %>
                                             <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
                                                <asp:ListItem Value="0">Export to</asp:ListItem>
                                                <asp:ListItem Value="1">PDF</asp:ListItem>
                                                <asp:ListItem Value="2">XLS</asp:ListItem>
                                                <asp:ListItem Value="3">RTF</asp:ListItem>
                                                <asp:ListItem Value="4">CSV</asp:ListItem>

                                            </asp:DropDownList>
                                             <%} %>
                                        </td>
                                        <td id="Td1">
                                            <%--<a href="javascript:ShowHideFilter('All');" class="btn btn-primary"><span>All Records</span></a>--%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td></td>
                            <td class="gridcellright pull-right">
                                <%--<dxe:ASPxComboBox ID="cmbExport" runat="server" AutoPostBack="true"
                                    Font-Bold="False" ForeColor="black" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged"
                                    ValueType="System.Int32" Width="130px">
                                    <Items>
                                        <dxe:ListEditItem Text="Select" Value="0" />
                                        <dxe:ListEditItem Text="PDF" Value="1" />
                                        <dxe:ListEditItem Text="XLS" Value="2" />
                                        <dxe:ListEditItem Text="RTF" Value="3" />
                                        <dxe:ListEditItem Text="CSV" Value="4" />
                                    </Items>
                                    <ButtonStyle>
                                    </ButtonStyle>
                                    <ItemStyle>
                                        <HoverStyle>
                                        </HoverStyle>
                                    </ItemStyle>
                                    <Border BorderColor="black" />
                                    <DropDownButton Text="Export">
                                    </DropDownButton>
                                </dxe:ASPxComboBox>--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="gridcellcenter">
                    <dxe:ASPxGridView ID="EmployeeGrid" runat="server" KeyFieldName="cnt_Id" AutoGenerateColumns="False"
                        DataSourceID="EmployeeDataSource" Width="100%" ClientInstanceName="grid" OnCustomCallback="EmployeeGrid_CustomCallback"
                        SettingsCookies-Enabled="true" SettingsCookies-StorePaging="true" SettingsCookies-StoreFiltering="true" SettingsCookies-StoreGroupingAndSorting="true" >
                        <clientsideevents endcallback="function(s,e) { ShowError(s.cpInsertError); }" />
                        <SettingsSearchPanel Visible="True" />
                        <settings showtitlepanel="True"  showstatusbar="Visible" showfilterrow="true" ShowFilterRowMenu="true" />
                        <settingspager   pagesize="10" showseparators="True" alwaysshowpager="True">
                            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200"/>
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                        </settingspager>
                        <settingsediting mode="PopupEditForm" popupeditformhorizontalalign="Center" popupeditformmodal="True"
                            popupeditformverticalalign="WindowCenter" popupeditformwidth="900px" editformcolumncount="3" />
                        <SettingsSearchPanel Visible="True" />
                        <settings showgrouppanel="True" showfilterrow="true" ShowFilterRowMenu="true" />
                        <settingsbehavior allowfocusedrow="True" confirmdelete="True" columnresizemode="NextColumn" />
                        <settingstext popupeditformcaption="Add/ Modify Employee" />
                        <columns>
                            <dxe:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Width="240">
                                <CellStyle CssClass="gridcellleft" wrap="True">
                                </CellStyle>
                                <editcellstyle wrap="True">
                                </editcellstyle>
                                <EditFormCaptionStyle HorizontalAlign="Right">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="Unique_ID" Caption="Unique ID" VisibleIndex="0" Width="240">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormCaptionStyle HorizontalAlign="Right">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Phone" FieldName="phone" VisibleIndex="2" width="100">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormCaptionStyle HorizontalAlign="Right">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                             <dxe:GridViewDataTextColumn Caption="Status" FieldName="Status" VisibleIndex="3" width="60">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormCaptionStyle HorizontalAlign="Right">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                             <dxe:GridViewDataTextColumn Caption="GSTIN" FieldName="gstin" VisibleIndex="4" width="120">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormCaptionStyle HorizontalAlign="left">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>

                             <dxe:GridViewDataTextColumn Caption="Account Group" FieldName="AccountGroup_Name" VisibleIndex="5"  Width="120">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormCaptionStyle HorizontalAlign="left">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Name To Print In Cheque" FieldName="cnt_PrintNameToCheque" VisibleIndex="6" Width="150">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormCaptionStyle HorizontalAlign="Right">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                            <%--<dxe:GridViewDataTextColumn Caption="Details" VisibleIndex="3" Width="5%">
                                <DataItemTemplate>
                                    <a href="javascript:void(0);" onclick="ClickOnMoreInfo('<%# Container.KeyValue %>')">More Info...</a>
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Left" Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False" />
                                <HeaderStyle HorizontalAlign="Center" />

                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Cont.Person" VisibleIndex="4" Width="5%">
                                <DataItemTemplate>
                                    <a href="javascript:void(0);" onclick="OnContactInfoClick('<%#Eval("Id") %>','<%#Eval("Name") %>')">Show</a>
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Left" Wrap="False">
                                </CellStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>--%>
                            <dxe:GridViewDataTextColumn  VisibleIndex="7" Width="60">
                                <DataItemTemplate>
                                    <% if(rights.CanEdit)
                                       { %>
                                    <a href="javascript:void(0);" onclick="ClickOnMoreInfo('<%# Container.KeyValue %>')" title="More Info" class="pad" style="text-decoration:none;">
                                        <img src="../../../assests/images/info.png" />
                                    </a>
                                    <% } %>
                                    <a href="javascript:void(0);" onclick="OnContactInfoClick('<%#Eval("Id") %>','<%#Eval("Name") %>')" title="Show" style="text-decoration:none;display:none">
                                        <img src="../../../assests/images/show.png" />
                                    </a>
                                     <% if(rights.CanDelete)
                                       { %>
                                    <a href="javascript:void(0);" onclick="OnDelete('<%# Eval("Id") %>')" title="Delete"  class="pad">
                                <img src="/assests/images/Delete.png" /></a>
                                     <% } %>
                                </DataItemTemplate>
                                <HeaderTemplate>Actions</HeaderTemplate>
                                <CellStyle HorizontalAlign="Center" Wrap="False">
                                </CellStyle>
                                <HeaderStyle HorizontalAlign="Center" />
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                           <%-- <dxe:GridViewDataTextColumn Caption="Created User" FieldName="user_name" Visible="False"
                                VisibleIndex="7">
                                <CellStyle CssClass="gridcellleft">
                                </CellStyle>
                                <EditFormCaptionStyle HorizontalAlign="Right">
                                </EditFormCaptionStyle>
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>--%>
                        </columns>
                        <styles>
                            <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                            <Header ImageSpacing="5px" SortingImageSpacing="5px">
                            </Header>
                        </styles>
                    </dxe:ASPxGridView>
                </td>
            </tr>
        </table>
        <asp:SqlDataSource ID="EmployeeDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand=""></asp:SqlDataSource>
        <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
        <br />



         <dxe:ASPxPopupControl ID="DirectAddCustPopup" runat="server"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="AspxDirectAddCustPopup" Height="650px"
        Width="1020px" HeaderText="Add New Vendor" Modal="true" AllowResize="true" ResizingMode="Postponed">
         
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
            </dxe:PopupControlContentControl>
        </ContentCollection>
    </dxe:ASPxPopupControl>

        <asp:HiddenField id="hidIsLigherContactPage" runat="server" />
    </div>
</asp:Content>
