﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ActivityClosedSales.aspx.cs" EnableEventValidation="false"  MasterPageFile="~/OMS/MasterPage/ERP.Master"  Inherits="ERP.OMS.Management.ActivityManagement.ActivityClosedSales" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <script src="/assests/pluggins/choosen/choosen.min.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
        BindAssignSupervisor();
          
            $("#lstAssignTo").chosen().change(function () {
                var assignId = $(this).val();
                $('#<%=hdnAssign.ClientID %>').val(assignId);
            })
        })

        function ShowDetailReassign(slsid, assignedToId) {

            assignto = assignedToId;
         //   BindAssignSupervisor(assignto);
         //   BindAssignSupervisor();
            $('#MandatoryRemarks').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');
            $('#MandatoryAssign').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');
            reassignvar = slsid;

            cPopup_Reassign.Show();
            txtRemarks.SetValue();
            $('#chkMail').prop('checked', false);
        }
        function ShowDetailFeedback(slsid) {
            $('#MandatoryRemarksFeedback').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');
            txtFeedback.SetValue();
            $('#chkmailfeedback').prop('checked', false);

            refeedbackvar = slsid;
            cPopup_Feedback.Show();
        }


        function ShowDetails(ProductType) {
            document.getElementById('GridDiv').style.display = 'none';
            document.getElementById('FrameDiv').style.display = '';
            document.getElementById("ctl00_ContentPlaceHolder3_ASPxPageControl1_ShowDetails_").src = ProductType;

        }
        function ShowHistory(sls_id) {
            document.location.href = "../Master/ShowHistory_Phonecall.aspx?id1=" + sls_id;
        }
        //function ShowHistory(LeadId) {
        //    url = "ShowHistory_Phonecall.aspx?id1=" + LeadId;
        //    OnMoreInfoClick(url, 'History', '900px', '450px', 'N');
        //}

        function ShowDetailProduct(actid) {

            cPopup_Product.Show();
            cAspxProductGrid.PerformCallback(actid);
            // cComponentPanel.PerformCallback(slsid);
        }
        function ShowDetailProductClass(actid) {

            cPopup_Product_Class.Show();
            cAspxProductClassGrid.PerformCallback(actid);
            // cComponentPanel.PerformCallback(slsid);
        }

        function disp_prompt(name) {
            var id = $('#<%=hdnSalesAc.ClientID %>').val();
            if (name == "tab0") {
                //document.location.href="crm_sales.aspx"; 
                document.location.href = "ActivityNewSales.aspx?id1=" + id;
            }
            if (name == "tab1") {
                document.location.href = "ActivityDocumentSales.aspx?id1=" + id;
            }
            else if (name == "tab2") {
                document.location.href = "ActivityFutureSales.aspx?id1=" + id;
            }
          
            else if (name == "tab3") {
                document.location.href = "ActivityClarificationSales.aspx?id1=" + id;
            }
            else if (name == "tab4") {

            }
        }
        function All_CheckedChanged() {
            grid.PerformCallback()
        }
        function Specific_CheckedChanged() {
            grid.PerformCallback()
        }


        function BindAssignSupervisor() {

            var lAssignTo = $('select[id$=lstAssignTo]');
            lAssignTo.empty();

            $.ajax({
                type: "POST",
                url: 'ActivityClosedSales.aspx/GetAllUserListBeforeSelect',
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

                            listItems.push('<option value="' +
                            id + '">' + name
                            + '</option>');
                        }

                        $(lAssignTo).append(listItems.join(''));


                        ListAssignTo();
                        $('#lstAssignTo').trigger("chosen:updated");


                    }
                    else {
                        $('#lstAssignTo').trigger("chosen:updated");
                        $('#lstAssignTo').prop('disabled', true).trigger("chosen:updated");
                        // alert("No records found");
                    }
                    //else {
                    //    alert("No records found");
                    //}
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(textStatus);
                }
            });


        }
        //function BindAssignSupervisor(UserId) {

        //    var lAssignTo = $('select[id$=lstAssignTo]');
        //    lAssignTo.empty();

        //    $.ajax({
        //        type: "POST",
        //        url: 'ActivityClosedSales.aspx/GetAllUserListBeforeSelect',
        //        contentType: "application/json; charset=utf-8",
        //        data: JSON.stringify({ UserId: UserId }),
        //        dataType: "json",
        //        success: function (msg) {
        //            var list = msg.d;
        //            var listItems = [];
        //            if (list.length > 0) {

        //                for (var i = 0; i < list.length; i++) {

        //                    var id = '';
        //                    var name = '';
        //                    id = list[i].split('|')[1];
        //                    name = list[i].split('|')[0];

        //                    listItems.push('<option value="' +
        //                    id + '">' + name
        //                    + '</option>');
        //                }

        //                $(lAssignTo).append(listItems.join(''));


        //                ListAssignTo();
        //                $('#lstAssignTo').trigger("chosen:updated");


        //            }
        //            else {
        //                $('#lstAssignTo').trigger("chosen:updated");
        //                $('#lstAssignTo').prop('disabled', true).trigger("chosen:updated");
        //                // alert("No records found");
        //            }
        //            //else {
        //            //    alert("No records found");
        //            //}
        //        },
        //        error: function (XMLHttpRequest, textStatus, errorThrown) {
        //            alert(textStatus);
        //        }
        //    });


        //}
        function ListAssignTo() {

            $('#lstAssignTo').chosen();
            $('#lstAssignTo').fadeIn();

            var config = {
                '.chsnProduct': {},
                '.chsnProduct-deselect': { allow_single_deselect: true },
                '.chsnProduct-no-single': { disable_search_threshold: 10 },
                '.chsnProduct-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chsnProduct-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        }
        //Reassign

        function CancelReassign_save() {
            txtRemarks.SetValue();
            $('#chkMail').prop('checked', false);
            $('#<%=hdnAssign.ClientID %>').val('');
            cPopup_Reassign.Hide();
        }
        function Call_save() {
         
            var flag = true;
            var uid = $('#<%=hdnAssign.ClientID %>').val();
              //  debugger;
            var Remarks = txtRemarks.GetValue();
            if (uid == "" || uid == null) {
                $('#MandatoryAssign').attr('style', 'display:block;position: absolute; right: -20px; top: 8px;');
                flag = false;
            }
            else {

                $('#MandatoryAssign').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');
                flag = true;
            }

            if (Remarks == "" || Remarks == null) {
                $('#MandatoryRemarks').attr('style', 'display:block;position: absolute; right: -20px; top: 8px;');
                flag = false;
            }
            else {
                $('#MandatoryRemarks').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');

                grid.PerformCallback('Reassign~' + reassignvar + '~' + uid + '~' + Remarks);
            }
            return flag;

        }


        //Feedback

        function CancelFeedback_save() {


            txtFeedback.SetValue();
            cPopup_Feedback.Hide();
            $('#chkmailfeedback').prop('checked', false);
        }
        function CallFeedback_save() {

            var flag = true;

            //  debugger;
            var Remarks = txtFeedback.GetValue();

            if (Remarks == "" || Remarks == null) {

                $('#MandatoryRemarksFeedback').attr('style', 'display:block;position: absolute; right: -20px; top: 8px;');
                flag = false;
            }
            else {
                $('#MandatoryRemarksFeedback').attr('style', 'display:none;position: absolute; right: -20px; top: 8px;');

                grid.PerformCallback('Feedback~' + refeedbackvar + '~' + Remarks);
            }
            return flag;

        }
        function LastActivityDetailsCall(obj) {
            if (grid.cpSave != null) {
                if (grid.cpSave == 'Y') {
                    grid.cpSave = '';
                    jAlert("Reassign Successfully");
                    cPopup_Reassign.Hide();
                //    BindAssignSupervisor();

                    // $("#lstAssignTo").empty();
                    txtRemarks.SetValue();
                    $('#chkMail').prop('checked', false);
                    $('#<%=hdnAssign.ClientID %>').val('');
                    $('#lstAssignTo').trigger("chosen:updated");
                }
                else {
                    grid.cpSave = '';
                    txtRemarks.SetValue();
                    $('#chkMail').prop('checked', false);
                    $('#<%=hdnAssign.ClientID %>').val('');
                    jAlert("Activity already done ,cannot reassign.");
                    cPopup_Reassign.Hide();
                }
            }

            if (grid.cpFeedSave != null) {
                if (grid.cpFeedSave == 'Y') {
                    grid.cpFeedSave = '';
                    cPopup_Feedback.Hide();
                    txtFeedback.SetValue();
                    $('#chkmailfeedback').prop('checked', false);
                    jAlert("Feedback Send Successfully");
                }
                else {
                    grid.cpFeedSave = '';
                    txtFeedback.SetValue();
                    cPopup_Feedback.Hide();
                    $('#chkmailfeedback').prop('checked', false);
                    jAlert("Failed");
                }
            }
        }
    </script>
     <style>
        .chosen-container.chosen-container-multi,
        .chosen-container.chosen-container-single {
            width: 100% !important;
        }

        .chosen-choices {
            width: 100% !important;
        }

        #lstAssignTo {
            width: 200px;
        }

        .hide {
            display: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="panel-heading">
        <div class="panel-title">
            <h3>Sales Activity Details - Closed Sales
            </h3>
           <div id="btncross" class="crossBtn" style="margin-left: 50px;"><a href="Sales_List.aspx"><i class="fa fa-times"></i></a></div>

        </div>
    </div>
    <div class="form_main">

         <div class="" id="divdetails">
            <div class="clearfix">
                <div style="float: left; padding-right: 5px;">

                    <asp:DropDownList ID="drdSalesActivityDetails" runat="server" Height="34px" CssClass="btn btn-sm btn-primary expad" OnSelectedIndexChanged="drdSalesActivityDetails_SelectedIndexChanged" AutoPostBack="true">
                        <asp:ListItem Value="0">Export to</asp:ListItem>
                        <asp:ListItem Value="1">PDF</asp:ListItem>
                        <asp:ListItem Value="2">XLS</asp:ListItem>
                        <asp:ListItem Value="3">RTF</asp:ListItem>
                        <asp:ListItem Value="4">CSV</asp:ListItem>
                    </asp:DropDownList>

                  
                </div>
            </div>
        </div>
        <table class="TableMain100">
            <tr>
                <td>
                    <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="4" ClientInstanceName="page"
                        Width="100%">
                        <TabPages>
                            <dxe:TabPage Text="Open Activities" Name="Assigned Sales Activity" TabStyle-CssClass="tabOrg">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Text="Document Collection" Name="Document Collection" TabStyle-CssClass="tabSk">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Text="Future Sales" Name="Future Sales" TabStyle-CssClass="tabSg">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                              <dxe:TabPage Text="Clarification Required" Name="Clarification Required" TabStyle-CssClass="tabG">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                            <dxe:TabPage Text="Closed Sales" Name="Closed Sales">
                                <ContentCollection>
                                    <dxe:ContentControl runat="server">
                                        <div id="GridDiv">
                                            <table width="100%">
                                                <tr>
                                                    <td colspan="2" style="text-align: left">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:RadioButton ID="Lrd" runat="server" GroupName="a" Visible="false" />
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="Label4" runat="server" Text="From Lead Data" Font-Size="X-Small" ForeColor="Blue" Visible="false"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:RadioButton ID="Erd" runat="server" GroupName="a" Checked="True" Visible="false" />
                                                                </td>
                                                                <td visible="false">
                                                                    <asp:Label ID="Label5" runat="server" Text="From Existing Customer Data" Font-Size="X-Small" ForeColor="Blue" Visible="false"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                       <dxe:ASPxGridView ID="SalesDetailsGrid" runat="server" KeyFieldName="act_id"  AutoGenerateColumns="False" ClientInstanceName="grid"
                                                           SettingsCookies-Enabled="true" SettingsCookies-StorePaging="true" SettingsCookies-StoreFiltering="true" SettingsCookies-StoreGroupingAndSorting="true" SettingsBehavior-AllowFocusedRow="true" 
                                                            Width="100%" DataSourceID="SalesDetailsGridDataSource"  OnCustomCallback="SalesDetailsGrid_CustomCallback" OnHtmlRowCreated="SalesDetailsGrid_HtmlRowCreated">
                                                            <Columns>
                                                                <%--  <dxe:GridViewCommandColumn VisibleIndex="0">
                                                                </dxe:GridViewCommandColumn>--%>
                                                                <dxe:GridViewDataTextColumn Caption="Activity" VisibleIndex="0" FieldName="LeadId" Visible="false">
                                                                    <DataItemTemplate>
                                                                        <dxe:ASPxCheckBox ID="chkDetail" runat="server">
                                                                        </dxe:ASPxCheckBox>

                                                                        <dxe:ASPxTextBox ID="lblActNo" runat="server" Width="100%" Visible="false"
                                                                            NullText="0" Value='<%# Eval("LeadId") %>'>
                                                                        </dxe:ASPxTextBox>


                                                                        <dxe:ASPxTextBox ID="lblSalesId" runat="server" Width="100%" Visible="false"
                                                                            NullText="0" Value='<%# Eval("sls_id") %>'>
                                                                        </dxe:ASPxTextBox>

                                                                        <dxe:ASPxTextBox ID="lblact_id" runat="server" Width="100%" Visible="false"
                                                                            NullText="0" Value='<%# Eval("sls_activity_id") %>'>
                                                                        </dxe:ASPxTextBox>
                                                                        <dxe:ASPxTextBox ID="lblAssignedTaskId" runat="server" Width="100%" Visible="false"
                                                                            NullText="0" Value='<%# Eval("act_assignedTo") %>'>
                                                                        </dxe:ASPxTextBox>

                                                                    </DataItemTemplate>
                                                                </dxe:GridViewDataTextColumn>
                                                                <dxe:GridViewDataTextColumn FieldName="Assigned To" VisibleIndex="1" Caption="Assigned To" Visible="false">
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn FieldName="Assigned By" VisibleIndex="2" Caption="Assigned By" Visible="false">
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn FieldName="Industry" VisibleIndex="3"  Caption="Industry">
                                                                </dxe:GridViewDataTextColumn>
                                                                <dxe:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="4"  Caption="Customer/Lead Name" Settings-AllowAutoFilterTextInputTimer="False">
                                                                </dxe:GridViewDataTextColumn>
                                                              
                                                                <%--   <dxe:GridViewDataTextColumn FieldName="ProductType" ReadOnly="True" Visible="False"
                                                                    VisibleIndex="4"  Width="18%">
                                                                </dxe:GridViewDataTextColumn>--%>
                                                                <dxe:GridViewDataTextColumn FieldName="Id" ReadOnly="True" Visible="False" VisibleIndex="7">
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>
                                                                <dxe:GridViewDataTextColumn FieldName="Amount" Visible="False" VisibleIndex="8">
                                                                </dxe:GridViewDataTextColumn>
                                                                <dxe:GridViewDataTextColumn FieldName="Product" ReadOnly="True" Visible="False"
                                                                    VisibleIndex="9">
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn FieldName="ProductType" VisibleIndex="10" Caption="Product Type" Visible="false">
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn FieldName="ProductName" VisibleIndex="12"  Caption="Product(s)" Settings-AllowAutoFilterTextInputTimer="False">

                                                                    <DataItemTemplate>
                                                                           <asp:Label ID="lblProduct" runat="server" Text=""></asp:Label>

                                                                        <asp:LinkButton  runat="server" ID="lnkProduct"  OnClientClick='<%# string.Format("ShowDetailProduct(\"{0}\"); return false", Eval("act_id")) %>' ><img  src="/assests/images/Info.png"/  title="Details"></asp:LinkButton>
                                                                        </DataItemTemplate>
                                                                     <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                </dxe:GridViewDataTextColumn>


                                                                  <dxe:GridViewDataTextColumn FieldName="ProductClasName" VisibleIndex="11" Caption="Product Class" Settings-AllowAutoFilterTextInputTimer="False">
                                                                    <DataItemTemplate>
                                                                        <asp:Label ID="lblProductClass" runat="server" Text=""></asp:Label>
                                                                        <asp:LinkButton runat="server" ID="lnkProductClass" OnClientClick='<%# string.Format("ShowDetailProduct(\"{0}\"); return false", Eval("act_id")) %>'><img  src="/assests/images/Viewt1.png"/  title="Details"></asp:LinkButton>
                                                                    </DataItemTemplate>
                                                                    <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                </dxe:GridViewDataTextColumn>



                                                                <dxe:GridViewDataTextColumn FieldName="ExpectedTime" VisibleIndex="12" Caption="Date Of Completion" Settings-AllowAutoFilterTextInputTimer="False">
                                                                     <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                </dxe:GridViewDataTextColumn>


                                                                <dxe:GridViewDataTextColumn Visible="false" VisibleIndex="13" Caption="Reassign">
                                                                    <DataItemTemplate>
                                                                        <a href="javascript:void(0)" onclick="ShowDetailReassign('<%#Eval("sls_id") %>')">Reassign</a>
                                                                    </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>


                                                                <dxe:GridViewDataTextColumn Visible="false" VisibleIndex="14" Caption="Create Activity">
                                                                    <DataItemTemplate>
                                                                        <a href="javascript:void(0)" onclick="ShowCreateActivity('<%#Eval("LeadId") %>','<%#Eval("sls_id") %>','<%#Eval("sls_activity_id") %>','<%#Eval("act_assignedTo") %>','<%#Eval("act_activityNo") %>','<%#Eval("act_assign_task") %>')">Create Activity</a>
                                                                    </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>
                                                                <dxe:GridViewDataTextColumn VisibleIndex="15" Caption="History" Width="100px">
                                                                     <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                    <DataItemTemplate>

                                                                         <a href="javascript:void(0)" onclick="ShowHistory('<%#Eval("sls_id") %>')">
                                                                            <img  src="/assests/images/history.png" width="16" height="16" title="History"></a>
                                                                    </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>
                                                                    <dxe:GridViewDataTextColumn VisibleIndex="16" Caption="Actions">
                                                                      <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                    <DataItemTemplate>
                                                                           <asp:LinkButton  runat="server" ID="lnkReassign"  OnClientClick='<%# string.Format("ShowDetailReassign(\"{0}\", \"{1}\"); return false", Eval("sls_id"), Eval("sls_assignedTo")) %>' ><img  src="/assests/images/reassign.png"  title="Reassign"></asp:LinkButton>
                                                                        
                                                                  
                                                                        <a href="javascript:void(0)" style="display:none" onclick="ShowDetailReassign('<%#Eval("sls_id") %>')" class="pad">

                                                                             <img  src="/assests/images/reassign.png"  title="Reassign"></a>
                                                                        </a>
                                                                        <span style="display:none;">
                                                                          <a href="javascript:void(0)" onclick="ShowDetailFeedback('<%#Eval("sls_id") %>')" class="pad">
                                                                                     
                                                                             <img  src="/assests/images/feedback.png"  title="Feedback" width="20" height="20"></a>
                                                                        </span>
                                                                    </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>
                                                            </Columns>
                                                              <SettingsPager PageSize="10">
                                                                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                                                            </SettingsPager>
                                                            <Styles>
                                                                <LoadingPanel ImageSpacing="10px">
                                                                </LoadingPanel>
                                                                <Header ImageSpacing="5px" SortingImageSpacing="5px">
                                                                </Header>
                                                                <Cell CssClass="gridcellleft">
                                                                </Cell>
                                                            </Styles>
                                                           <%-- <SettingsPager NumericButtonCount="20" ShowSeparators="True">
                                                                <FirstPageButton Visible="True">
                                                                </FirstPageButton>
                                                                <LastPageButton Visible="True">
                                                                </LastPageButton>
                                                            </SettingsPager>--%>
                                                            <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu = "True" />
                                                           <SettingsSearchPanel Visible="True" />
                                                            <ClientSideEvents EndCallback="function(s, e) {
	LastActivityDetailsCall(s.cpHeight);
}" />
                                                        </dxe:ASPxGridView>
                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                        <div id="FrameDiv" style="display: none;">
                                            <iframe width="100%" id="ShowDetails_" runat="server" height="800px" scrolling="no"></iframe>
                                        </div>
                                    </dxe:ContentControl>
                                </ContentCollection>
                            </dxe:TabPage>
                        </TabPages>
                        <ClientSideEvents ActiveTabChanged="function(s, e) {
	                                            var activeTab   = page.GetActiveTab();
	                                            var Tab0 = page.GetTab(0);
	                                            var Tab1 = page.GetTab(1);
	                                            var Tab2 = page.GetTab(2);
	                                            var Tab3 = page.GetTab(3);
	                                             var Tab4 = page.GetTab(4);
	                                            if(activeTab == Tab0)
	                                            {
	                                                disp_prompt('tab0');
	                                            }
	                                            if(activeTab == Tab1)
	                                            {
	                                                disp_prompt('tab1');
	                                            }
	                                            else if(activeTab == Tab2)
	                                            {
	                                                disp_prompt('tab2');
	                                            }
	                                            else if(activeTab == Tab3)
	                                            {
	                                                disp_prompt('tab3');
	                                            }
                                                else if(activeTab == Tab4)
	                                            {
	                                                disp_prompt('tab4');
	                                            }
	                                            }"></ClientSideEvents>
                        <ContentStyle>
                            <Border BorderColor="#002D96" BorderStyle="Solid" BorderWidth="1px" />
                        </ContentStyle>
                        <LoadingPanelStyle ImageSpacing="6px">
                        </LoadingPanelStyle>
                        <TabStyle Font-Size="12px">
                        </TabStyle>
                    </dxe:ASPxPageControl>
                </td>
            </tr>
        </table>
           <asp:SqlDataSource ID="SalesDetailsGridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:CRMConnectionString %>"></asp:SqlDataSource>

         <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>

          <asp:HiddenField ID="hdnSalesAc" runat="server" />

        <dxe:ASPxPopupControl ID="Popup_Reassign" runat="server" ClientInstanceName="cPopup_Reassign"
            Width="400px" HeaderText="Reassign User" PopupHorizontalAlign="WindowCenter"
            BackColor="white" Height="100px" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <%--<div style="Width:400px;background-color:#FFFFFF;margin:0px;border:1px solid red;">--%>
                    <div class="Top clearfix">

                       <table style="width:94%">
                            <tr>
                                <td>Select User<span style="color: red">*</span></td>
                                
                                <td class="relative">
                                    <asp:ListBox ID="lstAssignTo" CssClass="hide" runat="server" Font-Size="12px" TabIndex="0" Height="90px" Width="100%" data-placeholder="Select..."></asp:ListBox>

                                    <asp:TextBox ID="txtAssign" runat="server" Width="100%" Style="display: none"></asp:TextBox>
                                    <span id="MandatoryAssign" style="display: none">
                                        <img id="gridHistory_DXPEForm_efnew_DXEFL_DXEditor2_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                                    <asp:HiddenField ID="hdnAssign" runat="server" />
                                    <asp:HiddenField ID="hdnAssignText" runat="server" />
                                </td>
                            </tr>
                           <tr style="padding-top:30px;"><td>Remarks<span style="color: red">*</span></td>
                                <td class="relative"   style="padding-top:5px;">
                                     <dxe:ASPxMemo ID="txtInstNote" runat="server" Width="100%" Height="50px" ClientInstanceName="txtRemarks"></dxe:ASPxMemo>
                                                                        <span id="MandatoryRemarks" style="display: none">
                                        <img id="gridHistory_DXPEForm_efnew_DXEFL_DXEditor12_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                                </td></tr>
                              <tr>    <td >
                                      <asp:CheckBox ID="chkMail" runat="server"  ClientIDMode="Static"  /> Send Mail
                                     </td> <td colspan="2" style="padding-left: 121px;"></td></tr>
                            <tr style="padding-top:30px;">
                                <td colspan="3" style="padding-left: 121px;">
                                    <input id="btnSave" class="btn btn-primary" onclick="Call_save()" type="button" value="Save" />
                                    <input id="btnCancel" class="btn btn-danger" onclick="CancelReassign_save()" type="button" value="Cancel" />
                                </td>

                            </tr>
                        </table>


                    </div>

                </dxe:PopupControlContentControl>
            </ContentCollection>
            <HeaderStyle BackColor="LightGray" ForeColor="Black" />

          
        </dxe:ASPxPopupControl>

         <dxe:ASPxPopupControl ID="Popup_Feedback" runat="server" ClientInstanceName="cPopup_Feedback"
            Width="400px" HeaderText="Feedback" PopupHorizontalAlign="WindowCenter"
            BackColor="white" Height="100px" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <%--<div style="Width:400px;background-color:#FFFFFF;margin:0px;border:1px solid red;">--%>
                    <div class="Top clearfix">

                        <table style="width:94%">
                           
                            <tr><td>Feedback<span style="color: red">*</span></td>
                                <td class="relative">
                                     <dxe:ASPxMemo ID="txtInstFeedback" runat="server" Width="100%" Height="50px" ClientInstanceName="txtFeedback"></dxe:ASPxMemo>
                                                                        <span id="MandatoryRemarksFeedback" style="display: none">
                                        <img id="gridHistory_DXPEForm_efnew_DXEFL_DXEditor1234_EI" class="dxEditors_edtError_PlasticBlue" src="/DXR.axd?r=1_36-tyKfc" title="Mandatory"></span>
                                </td></tr>
                            <tr>
                                <td >
                                      <asp:CheckBox ID="chkmailfeedback" runat="server"  ClientIDMode="Static"  /> Send Mail
                                     </td> <td colspan="2" style="padding-left: 121px;"></td>

                            </tr>
                            <tr>
                                <td colspan="3" style="padding-left: 121px;">
                                    <input id="btnFeedbackSave" class="btn btn-primary" onclick="CallFeedback_save()" type="button" value="Save" />
                                    <input id="btnFeedbackCancel" class="btn btn-danger" onclick="CancelFeedback_save()" type="button" value="Cancel" />
                                </td>

                            </tr>
                             
                        </table>


                    </div>

                </dxe:PopupControlContentControl>
            </ContentCollection>
            <HeaderStyle BackColor="LightGray" ForeColor="Black" />

          
        </dxe:ASPxPopupControl>

           <dxe:ASPxPopupControl ID="Popup_Product" runat="server" ClientInstanceName="cPopup_Product"
            Width="400px" HeaderText="Product List" PopupHorizontalAlign="WindowCenter"
            BackColor="white" Height="100px" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">

                      
                                                       <dxe:PanelContent runat="server">

                                                            <dxe:ASPxGridView ID="AspxProductGrid" ClientInstanceName="cAspxProductGrid" Width="100%"  runat="server" OnCustomCallback="AspxProductGrid_CustomCallback"
                        AutoGenerateColumns="False"  >

                                      <Columns>
                                            <dxe:GridViewDataTextColumn Visible="True" FieldName="sProducts_Name"   Caption="Product Name">
                                                <CellStyle CssClass="gridcellleft">
                                                </CellStyle>
                                                <EditFormSettings Visible="False"></EditFormSettings>
                                            </dxe:GridViewDataTextColumn>
                       
                        
                                         

                                     </Columns>
 <SettingsBehavior AllowSort="false" AllowGroup="false" />
                        </dxe:ASPxGridView>
          

                                                              </dxe:PanelContent>
                                              
                        </dxe:PopupControlContentControl>
               
            </ContentCollection>
            <HeaderStyle BackColor="LightGray" ForeColor="Black" />

          
        </dxe:ASPxPopupControl>

        <dxe:ASPxPopupControl ID="Popup_ProductClass" runat="server" ClientInstanceName="cPopup_Product_Class"
            Width="400px" HeaderText="Product Class List" PopupHorizontalAlign="WindowCenter"
            BackColor="white" Height="100px" PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">


                    <dxe:PanelContent runat="server">

                        <dxe:ASPxGridView ID="ASPxGridProductClass" ClientInstanceName="cAspxProductClassGrid" Width="100%" runat="server" OnCustomCallback="AspxProductclassGrid_CustomCallback"
                            AutoGenerateColumns="False">

                            <Columns>
                                <dxe:GridViewDataTextColumn Visible="True" FieldName="ProductClass_Code" Caption="Product Class">
                                    <CellStyle CssClass="gridcellleft">
                                    </CellStyle>
                                    <EditFormSettings Visible="False"></EditFormSettings>
                                </dxe:GridViewDataTextColumn>



                            </Columns>

                            <SettingsBehavior AllowSort="false" AllowGroup="false" />
                        </dxe:ASPxGridView>


                    </dxe:PanelContent>

                </dxe:PopupControlContentControl>

            </ContentCollection>
            <HeaderStyle BackColor="LightGray" ForeColor="Black" />


        </dxe:ASPxPopupControl>
    </div>
        
</asp:Content>
