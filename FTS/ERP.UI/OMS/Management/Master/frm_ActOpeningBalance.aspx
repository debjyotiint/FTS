<%@ Page Title="Opening Balance" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/Erp.Master"
    Inherits="ERP.OMS.Management.Master.management_master_frm_ActOpeningBalance" CodeBehind="frm_ActOpeningBalance.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        var status = "Add";
        var ReturnData = ""; 
         $(document).ready(function () {
          finalSaveButtonState();
        }); 

        function BranchIndexChange(s, e) {
          //  ccmbAccount.PerformCallback(s.GetValue());
          //  ccmbSubAccount.PerformCallback('');
        }

        function AccountIndexChange(s, e) {
            ccmbSubAccount.PerformCallback(s.GetValue());
            cAmountPanel.PerformCallback("MainAccount~" + s.GetValue() + "~" + cmbBranch.GetValue());
        }
        function SubAccountIndexChange(s, e) { 
            cAmountPanel.PerformCallback("SubMainAccount~" + ccmbAccount.GetValue()+"~" + s.GetValue() + "~" + cmbBranch.GetValue());
        }

        function saveClientClick(s, e) {
            if (validAllData()) {
                cOpeningGrid.PerformCallback(status);
                status = "Add";
                SetEnable(true);
                ClearClientClick();
            }
        }
        function OpeningGridEndCallBack(s, e) {
            if (cOpeningGrid.cpTotalAmount) {
                ctotalDebit.SetText(cOpeningGrid.cpTotalAmount.split('~')[1]);
                clblTotDebit.SetText(cOpeningGrid.cpTotalAmount.split('~')[1]);
                totalCredit.SetText(cOpeningGrid.cpTotalAmount.split('~')[3]);
clblTotCredit.SetText(cOpeningGrid.cpTotalAmount.split('~')[3]);
                cOpeningGrid.cpTotalAmount = null;
            }
            if (status == "Edit") {
                if (cOpeningGrid.cpBeforeEdit) {
                    if (cOpeningGrid.cpBeforeEdit != "") {
                        ReturnData = cOpeningGrid.cpBeforeEdit;
                        cmbBranch.SetValue(ReturnData.split('~')[1]);
                        ccmbAccount.PerformCallback(cmbBranch.GetValue());
                        cOpeningGrid.cpBeforeEdit = null;
                    }
                }
            }

            if (cOpeningGrid.cpClientMsg) {
                if (cOpeningGrid.cpClientMsg != "") {
                    jAlert(cOpeningGrid.cpClientMsg);
                    cOpeningGrid.cpClientMsg = null;
                }
            }

            finalSaveButtonState();
          //  cmbBranch.Focus();
        }
       
        function finalSaveButtonState() {
            if (parseFloat(ctotalDebit.GetValue()) == parseFloat(totalCredit.GetValue())) {
                cFinalSave.SetVisible(true);
                $('#ErrorText').hide();
            }
            else {
               // cFinalSave.SetVisible(false);
               // $('#ErrorText').show();
                var totcredit = parseFloat(clblTotCredit.GetText());
                var totDebit = parseFloat(clblTotDebit.GetText());

                var totalDiff = totcredit - totDebit;
                cdiffAmt.SetText(parseFloat(Math.round(Math.abs(totalDiff) * 100) / 100).toFixed(2));
                
                

            }
        }

        function onOpeningEdit(obj) {
            status = "Edit";
            SetEnable(false);
            cOpeningGrid.PerformCallback(status + "~" + obj);
        }

        function SetEnable(state) {
            cmbBranch.SetEnabled(state);
            ccmbAccount.SetEnabled(state);
            ccmbSubAccount.SetEnabled(state);
        }

        function cmbAccountEndCallBack(s, e) {
            if (status == "Edit") {
                ccmbAccount.SetValue(ReturnData.split('~')[2]);
                ccmbSubAccount.PerformCallback(ccmbAccount.GetValue());
            }
        }
        function cmbSubAccountEndCallBack(s, e) {
            if (status == "Edit") {
                ccmbSubAccount.SetValue(ReturnData.split('~')[3]);
                ccmbDrorCr.SetValue(ReturnData.split('~')[4]);
                cAmmount.SetValue(ReturnData.split('~')[5]);
                status = "EditDone~" + ReturnData.split('~')[0];
                ccmbDrorCr.Focus();
            }
        }
        function FinalSaveClientClick(s, e) {
            cOpeningGrid.PerformCallback('SaveAllRecord');
        }
        function ClearClientClick(s,e) {
  $('#MandatoryBranch').css({ 'display': 'none' });
            $('#MandatoryAccount').css({ 'display': 'none' });
            cmbBranch.SetSelectedIndex(-1);
            ccmbAccount.PerformCallback('0');
            ccmbSubAccount.PerformCallback('0');
            cAmmount.SetValue(0);
            status = "Add";
            SetEnable(true);
            cmbBranch.Focus();
        }
        function validAllData() {
            var retdata = true;
            $('#MandatoryBranch').css({ 'display': 'none' });
            $('#MandatoryAccount').css({ 'display': 'none' });

            if (cmbBranch.GetValue() == null) {
                $('#MandatoryBranch').css({ 'display': 'block' });
                retdata = false;
            }
            if (ccmbAccount.GetValue() == null) {
                $('#MandatoryAccount').css({ 'display': 'block' });
                retdata = false;
            }
            return retdata;

        }

        function AmountPanelEndCallBack(s, e) {
            //  alert(cAmountPanel.cpAmount);
            if (cAmountPanel.cpAmount) {
                var panelRetData = cAmountPanel.cpAmount;
                ccmbDrorCr.SetValue(panelRetData.split('~')[0]);
                cAmmount.SetValue(panelRetData.split('~')[1]);
            }
        }


        $(function () {
            var vAnotherKeyWasPressed = false;
            var ALT_CODE = 18;
             
            $(window).keydown(function (event) {
                var vKey = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
                vAnotherKeyWasPressed = vKey != ALT_CODE;
                if (event.altKey && (event.key == 's' || event.key == 'S')) {
                    if (parseFloat(ctotalDebit.GetValue()) == parseFloat(totalCredit.GetValue())) {
                        if (cFinalSave) {
                            FinalSaveClientClick();
                            return false;
                        }
                    }
                }
                  
            });
             
            $(window).keyup(function (event) {

                var vKey = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;

            });
        });


    </script>
    <style>
        .dxeErrorFrameSys.dxeErrorCellSys,
        .pullleftClass {
            position:absolute;
            right: 6px;
            top: 8px;
        }
        .lead {
    font-size: 18px;
}
        #diffAmt {
        
        }
        #OpeningGrid, #OpeningGrid .dxgvHSDC>div,
        #OpeningGrid .dxgvHSDC + div {
            width:100% !important;
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="pull-left">Opening Balance  </h3>
            <div id="pageheaderContent" class=" pull-left wrapHolder content horizontal-images" style="">
            <ul>
                <li>
        <div class="lblHolder">
            <table>
                <tbody>
                    <tr>
                        <td>Total Debit</td>
                    </tr>
                    <tr>
                        <td>
                            <dxe:ASPxLabel ID="lblTotDebit" runat="server" Text="ASPxLabel" ClientInstanceName="clblTotDebit"></dxe:ASPxLabel>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
</li>
                <li>
        <div class="lblHolder">
            <table>
                <tbody>
                    <tr>
                        <td>Total Credit</td>
                    </tr>
                    <tr>
                        <td>
                            <dxe:ASPxLabel ID="lblTotCredit" runat="server" Text="ASPxLabel" ClientInstanceName="clblTotCredit"></dxe:ASPxLabel>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
                    </li>
            </ul>
        </div>
        </div>
        <div class="crossBtn"><a href="../ProjectMainPage.aspx"><i class="fa fa-times"></i></a></div>
    </div>
    <div class="form_main"  >
        

       <table width="100%">
           <tr>
               <td>Branch</td>
               <td>Account</td>
               <td>Sub Account</td>
               <td>DR/CR</td>
               <td>Amount</td>
               <td style="width:230px"></td>
           </tr>
           <tr>
                
               <td style="padding-right:25px" class="relative">
                   <dxe:ASPxComboBox ID="cmbBranch" ClientInstanceName="cmbBranch" runat="server" DataSourceID="dsBranch"  Width="100%"
                                                ValueType="System.String" AutoPostBack="false" ValueField="BANKBRANCH_ID" TextField="BANKBRANCH_NAME"
                                                EnableIncrementalFiltering="true" EnableSynchronization="False"  > 
                          <ClientSideEvents SelectedIndexChanged="BranchIndexChange" />
                                            </dxe:ASPxComboBox>
                    <span id="MandatoryBranch" class="pullleftClass fa fa-exclamation-circle iconRed " style="color:red;display:none;padding-left: 9px;" title="Mandatory"></span>
               </td>

                
               <td style="padding-right:25px" class="relative">
                    <dxe:ASPxComboBox ID="cmbAccount" ClientInstanceName="ccmbAccount" runat="server" Width="100%" OnCallback="cmbAccount_CustomCallback"  ValueType="System.String" AutoPostBack="false"    > 
                        <ClientSideEvents SelectedIndexChanged="AccountIndexChange" EndCallback="cmbAccountEndCallBack" />                 
                           </dxe:ASPxComboBox>
                   <span id="MandatoryAccount" class="pullleftClass fa fa-exclamation-circle iconRed " style="color:red;display:none;padding-left: 9px;" title="Mandatory"></span>
               </td>

                
               <td style="padding-right:25px" class="relative">
                    <dxe:ASPxComboBox ID="cmbSubAccount" ClientInstanceName="ccmbSubAccount" runat="server" Width="100%"  ValueType="System.String" AutoPostBack="false" OnCallback="cmbSubAccount_CustomCallback"   EnableCallbackMode="true"  > 
                         <ClientSideEvents SelectedIndexChanged="SubAccountIndexChange"  EndCallback="cmbSubAccountEndCallBack" />                        
                           </dxe:ASPxComboBox>
               </td>

               <td style="padding-right:25px" class="relative">
                    <dxe:ASPxComboBox ID="cmbDrorCr" ClientInstanceName="ccmbDrorCr" runat="server" Width="100%"
                                                ValueType="System.String" AutoPostBack="false" SelectedIndex="0"   > 
                                        <Items>
                                            <dxe:ListEditItem Text="Debit" Value="D" />
                                            <dxe:ListEditItem Text="Credit" Value="C" />
                                        </Items>
                                            </dxe:ASPxComboBox>
               </td>

               <td style="padding-right:25px;vertical-align: top;padding-top:3px;width:180px " class="relative">
                    <dxe:ASPxCallbackPanel runat="server" id="AmountPanel" ClientInstanceName="cAmountPanel" OnCallback="AmountPanel_Callback">
                                                  <PanelCollection>
                                                       <dxe:PanelContent runat="server">
                                                                <dxe:ASPxTextBox ID="txtAmmount" runat="server" Width="100%" ClientInstanceName="cAmmount"> 
                                                                    <MaskSettings Mask="<0..99999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" AllowMouseWheel="false"
                                                                        ErrorText="None" /> 
                                                                </dxe:ASPxTextBox>
                                                           </dxe:PanelContent>
                                                  </PanelCollection> 
                               <ClientSideEvents EndCallback="AmountPanelEndCallBack" />
                    </dxe:ASPxCallbackPanel>

               </td>
                <td class="relative">
                    <dxe:ASPxButton ID="Button1" runat="server" AutoPostBack="false" CssClass="btn btn-primary" Text="Add to Row"  ClientInstanceName="cButton1"
                        VerticalAlign="Bottom">
                        <ClientSideEvents Click="saveClientClick" />  
                    </dxe:ASPxButton>
                    <dxe:ASPxButton ID="ASPxButton1" runat="server" CssClass="btn btn-danger" Text="Clear" VerticalAlign="Bottom" AutoPostBack="false"> 
                        <ClientSideEvents Click="ClearClientClick" /> 
                    </dxe:ASPxButton>
                </td>
                
           </tr>

       </table>


         <div class="GridViewArea">
            <dxe:ASPxGridView ID="OpeningGrid" runat="server" AutoGenerateColumns="False" ClientInstanceName="cOpeningGrid" SettingsPager-Mode="ShowAllRecords" Settings-VerticalScrollBarMode="Auto"  Settings-VerticalScrollableHeight="350" 
                  Width="100%"  OnCustomCallback="OpeningGrid_CustomCallback"  OnDataBinding="grid_DataBinding">
                
                <Settings ShowGroupPanel="false" ShowStatusBar="Hidden" ShowFilterRow="true"  ShowFilterRowMenu="True" />
                <Columns>

                    <dxe:GridViewDataTextColumn Caption="Branch" FieldName="Branch"  ReadOnly="True" Visible="True" FixedStyle="Left" VisibleIndex="0"> 
                          <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>
                    
                     <dxe:GridViewDataTextColumn Caption="Account" FieldName="Account" ReadOnly="True" Visible="True" FixedStyle="Left" VisibleIndex="0"> 
                          <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                     <dxe:GridViewDataTextColumn Caption="Sub Account" FieldName="SubAccount"  ReadOnly="True" Visible="True" FixedStyle="Left" VisibleIndex="0"> 
                          <Settings AutoFilterCondition="Contains" />
                    </dxe:GridViewDataTextColumn>

                      <dxe:GridViewDataTextColumn Caption="Debit" FieldName="DebitAmount" ReadOnly="True" Visible="True" FixedStyle="Left" VisibleIndex="0">  
                          <Settings AutoFilterCondition="Contains" />
                          <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle> 
                            <propertiestextedit displayformatstring="{0:0.00}">
                                     <MaskSettings Mask="<0..999999999999>.<0..99>" AllowMouseWheel="false" /> 
                           </propertiestextedit>  
                    </dxe:GridViewDataTextColumn>

                      <dxe:GridViewDataTextColumn Caption="Credit" FieldName="CreditAmount" ReadOnly="True" Visible="True" FixedStyle="Left" VisibleIndex="0">  
                          <Settings AutoFilterCondition="Contains" />
                          <CellStyle Wrap="False" HorizontalAlign="Right" CssClass="gridcellleft"></CellStyle> 
                           <propertiestextedit displayformatstring="{0:0.00}">
                                     <MaskSettings Mask="<0..999999999999>.<0..99>" AllowMouseWheel="false" /> 
                           </propertiestextedit>  
                    </dxe:GridViewDataTextColumn>

                    <dxe:GridViewDataTextColumn ReadOnly="True" Width="12%" CellStyle-HorizontalAlign="Center">
                        <HeaderStyle HorizontalAlign="Center" />

<CellStyle HorizontalAlign="Center"></CellStyle>
                        <HeaderTemplate>
                            Actions
                        </HeaderTemplate>
                        <DataItemTemplate>
                             
                              <%if (rights.CanEdit)
                              { %>
                            <a href="javascript:void(0);" onclick="onOpeningEdit('<%#Eval("UniqueId")%>')" title="Edit" class="pad">
                                <img src="/assests/images/Edit.png" /></a>
                               <%} %>
                        </DataItemTemplate>
                    </dxe:GridViewDataTextColumn>
                    
                </Columns>
                 <settingspager pagesize="10">
                            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200"/>
                              </settingspager>
                <SettingsBehavior ColumnResizeMode="NextColumn" />
                <ClientSideEvents EndCallback="OpeningGridEndCallBack" />
            </dxe:ASPxGridView>
        </div>
        <div class="clear"></div>
        <div style="padding-top:10px;">
            <table width="100%" style="    margin-left: 50px;" >
                <tr>
                    <td><span id="ErrorText" style="color:red;display:none" class="lead"> Mismatch detected for Debit and Credit Total of the selected Branch is :   <dxe:ASPxLabel ID="diffAmt" runat="server" Text="" cssclass="lead" ClientInstanceName="cdiffAmt"></dxe:ASPxLabel> </span> </td>
                    <td>&nbsp</td>                
                    <td style="width: 250px; display:none"><span class="pull-left" style="margin: 5px 15px 0 0;"> Total Dr.</span>
                        <dxe:ASPxTextBox ID="totalDebit" runat="server"  ClientEnable="false"  ClientInstanceName="ctotalDebit" Width="150"> 
                            <MaskSettings Mask="<0..99999999999>.<00..99>" IncludeLiterals="DecimalSymbol"  ErrorText="None" /> 
                        </dxe:ASPxTextBox>
                    </td>
                    <td style="width: 250px; display:none"><span class="pull-left" style="margin: 5px 15px 0 0;"> Total Cr.</span>
                        <dxe:ASPxTextBox ID="totalCredit" runat="server" ClientEnable="false"  ClientInstanceName="totalCredit" Width="150"> 
                            <MaskSettings Mask="<0..99999999999>.<00..99>" IncludeLiterals="DecimalSymbol"  ErrorText="None" /> 
                        </dxe:ASPxTextBox>
                    </td>
                    <td>&nbsp</td>
                </tr>
            </table>
        </div>
        

        <div class="clear"></div>
        <div class="">
             <%if (rights.CanAdd)
                              { %>
            <dxe:ASPxButton ID="FinalSave" runat="server" AutoPostBack="false" CssClass="btn btn-primary" Text="<u>S</u>ave" ClientInstanceName="cFinalSave" VerticalAlign="Bottom" EncodeHtml="false">
                <clientsideevents click="FinalSaveClientClick" />
            </dxe:ASPxButton>
            <%} %>

        </div>


    </div>
    <asp:SqlDataSource ID="dsBranch" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>" ConflictDetection="CompareAllValues"
        SelectCommand=""></asp:SqlDataSource>
</asp:Content>

