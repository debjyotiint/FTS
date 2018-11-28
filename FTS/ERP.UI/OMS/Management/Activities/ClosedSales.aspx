<%@ Page Title="Closed Sales" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" 
    Inherits="ERP.OMS.Management.Activities.management_Activities_ClosedSales" CodeBehind="ClosedSales.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
       
        function ShowDetails(ProductType) {
            document.getElementById('GridDiv').style.display = 'none';
            document.getElementById('FrameDiv').style.display = '';
            document.getElementById("ctl00_ContentPlaceHolder3_ASPxPageControl1_ShowDetails_").src = ProductType;

        }

        //function ShowHistory(LeadId) {
        //    url = "ShowHistory_Phonecall.aspx?id1=" + LeadId;
        //    OnMoreInfoClick(url, 'History', '900px', '450px', 'N');
        //}

        function Showhistory(slsid) {

            var frmdate = cxdeFromDate.GetText();
            var todate = cxdeToDate.GetText();
            var stract = slsid + "&frmdate=" + frmdate + "&todate=" + todate;
            //  alert(stract)
            //   alert(stract)
            //    window.open("ShowHistory_Phonecall.aspx?id1=" + stract);
            document.location.href = "../Master/ShowHistory_Phonecall.aspx?id1=" + slsid + "&frmdate=" + frmdate + "&todate=" + todate;

        }


        function disp_prompt(name) {
            if (name == "tab0") {
                document.location.href = "crm_sales.aspx";
            }
            if (name == "tab1") {
                document.location.href = "frmDocument.aspx";
            }
            else if (name == "tab2") {
                document.location.href = "futuresale.aspx";
            }
            else if (name == "tab3") {
                //document.location.href="ClosedSales.aspx";
                document.location.href = "ClarificationSales.aspx";
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

        function Budget_open() {
            var SMid = '';
            var url = '/OMS/Management/Activities/SalesmanBudget.aspx?tid=1';
            popupbudget.SetContentUrl(url);
            popupbudget.Show();

            return false;
            //return true;
        }
        function BudgetAfterHide(s, e) {
            popupbudget.Hide();
        }

        function btn_ShowRecordsClick() {
            //CallServer(data, "");
            grid.PerformCallback('');
        }

        function OnBudgetCopen(Cusid, productclassid, slsid) {
            //    if (document.getElementById('IsUdfpresent').value == '0') {
            //        jAlert("UDF not define.");
            //    }
            //    else {
            //        // var url = '../master/frm_BranchUdfPopUp.aspx?Type=SQO';

            //        var keyVal = document.getElementById('Keyval_internalId').value;
            var url = '/OMS/Management/Master/BudgetAdd.aspx?Cusid=' + Cusid + '&productclassid=' + productclassid + '&slsid=' + slsid;
            popupCbudget.SetContentUrl(url);
            popupCbudget.Show();

            //}
            return true;
        }

        function BudgetCAfterHide(s, e) {
            popupCbudget.Hide();
        }
    </script>  <style>
 .mtop3 {
            margin-top:3px;
        }
         .pull-right {
            float:right !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="panel-heading">
        <div class="panel-title">
            <h3>Sales Activity - Closed Sales
            </h3>
          
            <div id="btncross" class="crossBtn" style="margin-left:50px;"><a href="crm_sales.aspx"><i class="fa fa-times"></i></a></div>
        </div>
    </div>
    <div class="form_main">

         <div class="" id="divdetails">
            <div class="clearfix">
                <div style=" padding-right: 5px;">
                    


                   <table class="pull-left">
                        <tr>
                            <td>
                                 <span id="spanBudget" >
                                      <a href="javascript:void(0);" onclick="Budget_open()" title="Budget"  class="btn btn-primary">
                                           Target Sale Of Product</a>
                                </span>
                                <span id="spanMyactivities" visible="false">
                                    <asp:Button ID="btn_myactivity" Style="padding: 0px 0px;"  Text="My Activities" runat="server" CssClass="btn btn-primary" OnClick="btMyactivities_Click" />
                                </span>

                                 <asp:Button ID="btn_PendingTask" Style="padding: 0px 0px;"  Text="Pending Task" runat="server" CssClass="btn btn-primary" OnClick="btMyPendingTask_Click" />
                           <asp:Button ID="btn_PendingActivity" Style="padding: 0px 0px;"  Text="My Today's Task" runat="server" CssClass="btn btn-primary" OnClick="btMyPendingActivity_Click" />
                     
                                
                                 </td>
                            <td>
                                <div style="color: #b5285f; font-weight: bold;" class="clsFrom">
                                    <asp:Label ID="lblFromDate" runat="Server" Text="Next Activity From : " CssClass="mylabel1"
                                        Width="120px"></asp:Label>
                                </div>
                            </td>
                            <td>
                                <dxe:ASPxDateEdit ID="ASPxFromDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                                    UseMaskBehavior="True" Width="100%" ClientInstanceName="cxdeFromDate">
                                    <ButtonStyle Width="13px">
                                    </ButtonStyle>
                                </dxe:ASPxDateEdit>
                            </td>
                            <td style="padding-left: 1px">
                                <div style="color: #b5285f; font-weight: bold;" class="clsTo">
                                       <asp:Label ID="lblToDate" runat="Server" Text="To : " CssClass="mylabel1"
                                        Width="25px"></asp:Label>
                                </div>
                            </td>
                            <td>
                                <dxe:ASPxDateEdit ID="ASPxToDate" runat="server" EditFormat="custom" DisplayFormatString="dd-MM-yyyy" EditFormatString="dd-MM-yyyy"
                                    UseMaskBehavior="True" Width="100%" ClientInstanceName="cxdeToDate">
                                    <ButtonStyle Width="13px">
                                    </ButtonStyle>
                                    <%-- <ClientSideEvents DateChanged="cxdeToDate_OnChaged"></ClientSideEvents>--%>
                                </dxe:ASPxDateEdit>
                            </td>
                            <td style="padding-left: 5px; padding-top: 3px">
                                <button class="btn btn-primary" onclick="btn_ShowRecordsClick()" type="button">Show</button>
                             
                            </td>
                        </tr>

                    </table>

                        <% if (rights.CanExport)
                           { %>
                      <asp:DropDownList ID="drdSalesActivityDetails" runat="server" Height="34px" CssClass="btn btn-sm btn-primary  expad pull-right   mtop3" OnSelectedIndexChanged="drdSalesActivityDetails_SelectedIndexChanged" AutoPostBack="true">
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
                                                       <dxe:ASPxGridView  KeyFieldName="sls_id" ID="SalesDetailsGrid"  SettingsCookies-Enabled="true" SettingsCookies-StorePaging="true" SettingsCookies-StoreFiltering="true" SettingsCookies-StoreGroupingAndSorting="true" SettingsBehavior-AllowFocusedRow="true"  runat="server" AutoGenerateColumns="False" ClientInstanceName="grid"
                                                            Width="100%" DataSourceID="SalesDetailsGridDataSource" 
                                                           
                                                              OnCustomCallback="SalesDetailsGrid_CustomCallback" 
                                                           OnHtmlRowCreated="SalesDetailsGrid_HtmlRowCreated">
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

                                                          <%--        <dxe:GridViewDataTextColumn FieldName="Address" Caption="Address" VisibleIndex="1" Width="18%">
                                                                </dxe:GridViewDataTextColumn>--%>


                                                                 <dxe:GridViewDataTextColumn FieldName="ContactNumber" Caption="Contact Number" VisibleIndex="2" Width="18%">
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn FieldName="Assigned To" VisibleIndex="3" Caption="Salesman" Settings-AllowAutoFilterTextInputTimer="False" >
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn FieldName="Assigned By" VisibleIndex="4" Caption="Assigned By" Visible="false">
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn FieldName="Industry" VisibleIndex="5"  Caption="Industry" Settings-AllowAutoFilterTextInputTimer="False">
                                                                </dxe:GridViewDataTextColumn>
                                                                <dxe:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="6"  Caption="Customer/Lead Name" Settings-AllowAutoFilterTextInputTimer="False">
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

                                                                <dxe:GridViewDataTextColumn FieldName="ProductName" VisibleIndex="12"  Caption="Product(s)"  Settings-AllowAutoFilterTextInputTimer="False">
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
                                                                        <asp:LinkButton runat="server" ID="lnkProductClass" OnClientClick='<%# string.Format("ShowDetailProductClass(\"{0}\"); return false", Eval("sls_id")) %>'><img  src="/assests/images/Viewt1.png"/  title="Details"></asp:LinkButton>
                                                                    </DataItemTemplate>
                                                                    <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                </dxe:GridViewDataTextColumn>



                                                                <dxe:GridViewDataTextColumn FieldName="ExpectedTime" VisibleIndex="13" Caption="Date Of Completion" Settings-AllowAutoFilterTextInputTimer="False">
                                                                     <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                </dxe:GridViewDataTextColumn>
                                                                 <dxe:GridViewDataTextColumn FieldName="PriorityName" VisibleIndex="14" Caption="Priority" >
                                                                    <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                </dxe:GridViewDataTextColumn>
                                                                 <dxe:GridViewDataTextColumn FieldName="NextVisit" VisibleIndex="15" Caption="Next Activity Date" Settings-AllowAutoFilterTextInputTimer="False" >
                                                                    <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                </dxe:GridViewDataTextColumn>

                                                                <dxe:GridViewDataTextColumn Visible="false" VisibleIndex="16" Caption="Reassign">
                                                                    <DataItemTemplate>
                                                                        <a href="javascript:void(0)" onclick="ShowDetailReassign('<%#Eval("sls_id") %>')">Reassign</a>
                                                                    </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>


                                                                <dxe:GridViewDataTextColumn Visible="false" VisibleIndex="17" Caption="Create Activity">
                                                                    <DataItemTemplate>
                                                                        <a href="javascript:void(0)" onclick="ShowCreateActivity('<%#Eval("LeadId") %>','<%#Eval("sls_id") %>','<%#Eval("sls_activity_id") %>','<%#Eval("act_assignedTo") %>','<%#Eval("act_activityNo") %>','<%#Eval("act_assign_task") %>')">Create Activity</a>
                                                                    </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>
                                                                <dxe:GridViewDataTextColumn VisibleIndex="18" Caption="History" Width="100px">
                                                                     <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                    <HeaderStyle HorizontalAlign="Center" />
                                                                    <DataItemTemplate>
                                                                        <% if (rights.CanHistory)
                                                                           { %>

                                                                      <%--   <asp:HyperLink runat="server" ID="hpnhis" CssClass="pad"><img  src="/assests/images/history.png" width="16" height="16" title="History"></asp:HyperLink>
                                                                       --%>
                                                                          <a href="javascript:void(0)" onclick="Showhistory('<%#Eval("sls_id") %>')">
                                                                              
                                                                            <img src="../../../assests/images/history.png" />


                                                                          </a>

                                                                          <% } %>
                                                                    </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>



                                                                 <dxe:GridViewDataTextColumn VisibleIndex="19" Caption="Actions"  Width="160px">
                                                                     <CellStyle HorizontalAlign="Center">
                                                                    </CellStyle>
                                                                    <HeaderStyle HorizontalAlign="Center"  />
                                                                    <DataItemTemplate>
                                                                         

                                                                          <%  if (rights.CanBudget)
                                           { %>
                                                                          <a href="javascript:void(0);" onclick="OnBudgetCopen('<%# Eval("cnt_Id") %>','<%# Eval("ProductClass_ID") %>','<%#Eval("sls_id") %>')" title="Budget"  class="pad">
                                                                            <img src="/assests/images/cashbudget.png" width="16" height="16"/>
                                                                          </a>

                                                                           <%   }%>
                                                                          </DataItemTemplate>
                                                                    <EditFormSettings Visible="False" />
                                                                </dxe:GridViewDataTextColumn>
                                                            </Columns>
                                                            <Styles>
                                                                <LoadingPanel ImageSpacing="10px">
                                                                </LoadingPanel>
                                                                <Header ImageSpacing="5px" SortingImageSpacing="5px">
                                                                </Header>
                                                                <Cell CssClass="gridcellleft">
                                                                </Cell>
                                                            </Styles>

                                                           <settingspager pagesize="10">
                                                            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200"/>
                                                            </settingspager>
                                                          <%--  <SettingsPager NumericButtonCount="20" ShowSeparators="True">
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

              <dxe:ASPxPopupControl ID="ASPXPopupControl2" runat="server"
                CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupbudget" Height="500px"
                Width="1310px" HeaderText="Budget" Modal="true" AllowResize="true" ResizingMode="Postponed">
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                    </dxe:PopupControlContentControl>
                </ContentCollection>
                
                 <ClientSideEvents CloseUp="BudgetAfterHide" />
            </dxe:ASPxPopupControl>
         <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>
          <dxe:ASPxPopupControl ID="ASPXPopupControl1" runat="server"
                CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupCbudget" Height="300px"
                Width="350px" HeaderText="Budget" Modal="true" AllowResize="true" ResizingMode="Postponed">
                <ContentCollection>
                    <dxe:PopupControlContentControl runat="server">
                    </dxe:PopupControlContentControl>
                </ContentCollection>
                
                 <ClientSideEvents CloseUp="BudgetCAfterHide" />
            </dxe:ASPxPopupControl>
    </div>
        
</asp:Content>
