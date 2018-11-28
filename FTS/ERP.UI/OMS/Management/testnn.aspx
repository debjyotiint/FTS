<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" Inherits="ERP.OMS.Management.management_testnn" CodeBehind="testnn.aspx.cs" %>

<%--<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dxe" %>

<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dxe000001" %>
<%@ Register assembly="DevExpress.Web.v15.1" namespace="DevExpress.Web" tagprefix="dx" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">

        //function is called on changing MainAccount
        function OnCashBankReportMainAcChange(cmbRptMainAccount) {
            //alert(cmbRptMainAccount.GetValue().toString());
            gridCashbankReportCI.GetEditor("SubAccountID").PerformCallback(cmbRptMainAccount.GetValue().toString());
        }
        function onGotFocusLineNarration(s, e) {
            if (confirm("Are you sure you want to create the row?")) {
                gridCashbankReportCI.AddNewRow();
            }

        }
    </script>
    <div>
        <dxe:ASPxGridView ID="grdCashbankReport" runat="server" AutoGenerateColumns="False"
            KeyFieldName="CashBank_ID" ClientInstanceName="gridCashbankReportCI" ForeColor="White"
            CssFilePath="~/App_Themes/Office2003 Blue/{0}/styles.css" CssPostfix="Office2003_Blue"
            DataSourceID="dsCashBankReport" Width="98%" OnCellEditorInitialize="grdCashbankReport_CellEditorInitialize"
            OnHtmlRowCreated="grdCashbankReport_HtmlRowCreated" OnRowInserting="grdCashbankReport_RowInserting"
            OnRowInserted="grdCashbankReport_RowInserted" OnBeforeGetCallbackResult="grdCashbankReport_BeforeGetCallbackResult"
            OnRowUpdating="grdCashbankReport_RowUpdating"
            OnRowValidating="grdCashbankReport_RowValidating">
            <Styles CssFilePath="~/App_Themes/Office2003 Blue/{0}/styles.css" CssPostfix="Office2003_Blue">
            </Styles>
            <SettingsPager NumericButtonCount="20" PageSize="20" ShowSeparators="True">
            </SettingsPager>
            <Images ImageFolder="~/App_Themes/Office2003 Blue/{0}/">
                <ExpandedButton Height="12px" Url="~/App_Themes/Office2003 Blue/GridView/gvExpandedButton.png"
                    Width="11px" />
                <CollapsedButton Height="12px" Url="~/App_Themes/Office2003 Blue/GridView/gvCollapsedButton.png"
                    Width="11px" />
                <DetailCollapsedButton Height="12px" Url="~/App_Themes/Office2003 Blue/GridView/gvCollapsedButton.png"
                    Width="11px" />
                <DetailExpandedButton Height="12px" Url="~/App_Themes/Office2003 Blue/GridView/gvExpandedButton.png"
                    Width="11px" />
                <FilterRowButton Height="13px" Width="13px" />
            </Images>
            <SettingsEditing EditFormColumnCount="4" />
            <Columns>
                <dxe:GridViewDataComboBoxColumn Caption="Main A/C" VisibleIndex="1" Width="15%"
                    FieldName="CashBank_MainAccountID">
                    <PropertiesComboBox DataSourceID="MainAccountReport" TextField="MainAccount_Name"
                        EnableIncrementalFiltering="True" ValueField="CashBank_MainAccountID" ValueType="System.String">
                        <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCashBankReportMainAcChange(s); }"></ClientSideEvents>
                    </PropertiesComboBox>
                    <CellStyle CssClass="gridcellleft">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataComboBoxColumn>
                <dxe:GridViewDataComboBoxColumn Caption="Sub A/c" VisibleIndex="2" Width="15%"
                    FieldName="SubAccountID">
                    <PropertiesComboBox DataSourceID="SelectSubaccountReport" TextField="SubAccountName"
                        ValueField="SubAccountID" ValueType="System.String" EnableIncrementalFiltering="True">
                        <ClientSideEvents GotFocus="function(s, e) { OnCashBankReportSubAcChange(s); }" SelectedIndexChanged="function(s, e) { OnCashBankReportSubAcChange(s); }"></ClientSideEvents>
                    </PropertiesComboBox>
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataComboBoxColumn>
                <dxe:GridViewDataComboBoxColumn Caption="Inst. type" FieldName="CashBank_InstrumentType"
                    VisibleIndex="3" Width="10%">
                    <PropertiesComboBox ValueType="System.String" EnableIncrementalFiltering="True">
                        <Items>
                            <dxe:ListEditItem Text="Draft[D]" Value="D"></dxe:ListEditItem>
                            <dxe:ListEditItem Text="Cheque[C]" Value="C"></dxe:ListEditItem>
                            <dxe:ListEditItem Text="Electronic Transfer[E]" Value="E"></dxe:ListEditItem>
                        </Items>
                        <ClientSideEvents SelectedIndexChanged="function(s, e) { OnInstmentTypeChange(s); }"></ClientSideEvents>
                    </PropertiesComboBox>
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataComboBoxColumn>
                <dxe:GridViewDataTextColumn Caption="Instrument No" FieldName="CashBank_InstrumentNumber"
                    VisibleIndex="4" Width="10%" PropertiesTextEdit-MaxLength="20">
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataDateColumn Caption="Date" FieldName="CashBank_InstrumentDate"
                    VisibleIndex="5" Width="10%">
                    <PropertiesDateEdit EditFormat="Custom" EditFormatString="dd MMMM yyyy" UseMaskBehavior="True">
                    </PropertiesDateEdit>
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataDateColumn>
                <dxe:GridViewDataComboBoxColumn Caption="Payee" FieldName="CashBank_PayeeAccountID"
                    VisibleIndex="6" Width="10%">
                    <PropertiesComboBox ValueType="System.String" EnableIncrementalFiltering="True">
                        <Items>
                            <dxe:ListEditItem Text="Amit Kumar" Value="0"></dxe:ListEditItem>
                            <dxe:ListEditItem Text="Mr.Abhishek" Value="1"></dxe:ListEditItem>
                            <dxe:ListEditItem Text="Mr. Asit Kumar" Value="2"></dxe:ListEditItem>
                        </Items>
                    </PropertiesComboBox>
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataComboBoxColumn>
                <dxe:GridViewDataTextColumn Caption="Payment" FieldName="CashBank_AmountWithdrawl"
                    VisibleIndex="7" Width="10%">
                    <PropertiesTextEdit>
                        <MaskSettings Mask="&lt;0..999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                        <ValidationSettings ErrorDisplayMode="None">
                        </ValidationSettings>
                    </PropertiesTextEdit>
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn Caption="Receipt" FieldName="CashBank_AmountDeposit"
                    VisibleIndex="8" Width="10%">
                    <PropertiesTextEdit>
                        <MaskSettings Mask="&lt;0..999999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                        <ValidationSettings ErrorDisplayMode="None">
                        </ValidationSettings>
                    </PropertiesTextEdit>
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataMemoColumn Caption="Line Narration" FieldName="CASHBANK_LINENARRATION"
                    VisibleIndex="9" Width="10%" Visible="false">
                    <PropertiesMemoEdit>
                        <ClientSideEvents Init="function(s, e) { return setMaxLength(s.GetInputElement(), 20); }" />
                    </PropertiesMemoEdit>
                    <CellStyle CssClass="gridcellleft" Wrap="False">
                    </CellStyle>
                    <EditFormCaptionStyle Wrap="False">
                    </EditFormCaptionStyle>
                    <EditFormSettings ColumnSpan="2" Visible="True" CaptionLocation="Near" />
                </dxe:GridViewDataMemoColumn>
                <dxe:GridViewCommandColumn VisibleIndex="0" ShowEditButton="True">
                    <HeaderStyle HorizontalAlign="Center"/>
                    <HeaderTemplate>
                        <a href="javascript:void(0);" onclick="grid.AddNewRow()">
                            <span style="color: #000099; text-decoration: underline">Add New</span>
                        </a>
                    </HeaderTemplate>
                </dxe:GridViewCommandColumn>
            </Columns>
            <SettingsPager NumericButtonCount="5" PageSize="5" ShowSeparators="True">
            </SettingsPager>
        </dxe:ASPxGridView>
        <table style="width: 100%; background-color: #ffff66; display: none;" border="0"
            id="tblClientBank">
            <tr id="tr1">
                <td style="text-align: center; width: 20%">Bank Name</td>
                <td style="text-align: center; width: 25%">Bank Account Name</td>
                <td style="text-align: center; width: 30%">Account No</td>
                <td style="text-align: center; width: 20%">MICR No</td>
                <td style="text-align: center; width: 5%">Select</td>
            </tr>
            <tr id="tr2">
                <td style="text-align: left; width: 20%">
                    <dxe:ASPxLabel ID="ASPxLabel1" runat="server" Text="State Bank Of India">
                    </dxe:ASPxLabel>
                </td>
                <td style="text-align: left; width: 25%">
                    <dxe:ASPxLabel ID="ASPxLabel2" runat="server" Text="Mr. Amit Kumar">
                    </dxe:ASPxLabel>
                </td>
                <td style="text-align: left; width: 30%">
                    <dxe:ASPxLabel ID="ASPxLabel3" runat="server" Text="69696969696">
                    </dxe:ASPxLabel>
                </td>
                <td style="text-align: left; width: 20%">
                    <dxe:ASPxLabel ID="ASPxLabel4" runat="server" Text="154241">
                    </dxe:ASPxLabel>
                </td>
                <td style="text-align: left; width: 5%">
                    <dxe:ASPxCheckBox ID="ASPxCheckBox1" runat="server" Wrap="False">
                    </dxe:ASPxCheckBox>
                </td>
            </tr>
        </table>
        <asp:SqlDataSource ID="MainAccountReport" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select MainAccount_ReferenceID as CashBank_MainAccountID, MainAccount_Name as MainAccount_Name from Master_MainAccount where MainAccount_BankCashType='Other'"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SelectSubaccountReport" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
            SelectCommand="Select SubAccount_ReferenceID as SubAccountID, SubAccount_Name as SubAccountName from Master_SubAccount where SubAccount_MainAcReferenceID=@ID">
            <SelectParameters>
                <asp:Parameter Name="ID" Type="string" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="dsCashBankReport" runat="server" ConflictDetection="CompareAllValues"
            InsertCommand="insert into table1 (temp123) values('11')"
            SelectCommand="select a.*,a.CashBank_MainAccountID as MainAccount_Name , a.CashBank_SubAccountID as SubAccountID from dbo.Trans_CashBankVouchers as a "
            UpdateCommand="update table1 set temp123='123'">
            <InsertParameters>
                <asp:Parameter Name="CashBank_MainAccountID" Type="String" />
                <asp:Parameter Name="SubAccountID" Type="String" />
                <asp:Parameter Name="CashBank_InstrumentType" Type="String" />
                <asp:Parameter Name="CashBank_InstrumentNumber" Type="String" />
                <asp:Parameter Name="CashBank_InstrumentDate" Type="string" />
                <asp:Parameter Name="CashBank_PayeeAccountID" Type="String" />
                <asp:Parameter Name="CashBank_AmountWithdrawl" Type="Decimal" />
                <asp:Parameter Name="CashBank_AmountDeposit" Type="Decimal" />
                <asp:Parameter Name="AccountType" Type="Char" />
                <asp:Parameter Name="Date" Type="DateTime" />
                <asp:Parameter Name="Company" Type="Char" />
                <asp:Parameter Name="Segment" Type="Char" />
                <asp:Parameter Name="Branch" Type="Char" />
                <asp:Parameter Name="CashBankAc" Type="Char" />
                <asp:Parameter Name="Narration" Type="String" />
                <asp:Parameter Name="Settlementno" Type="Char" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="CashBank_ID" Type="Int64" />
                <asp:Parameter Name="CashBank_MainAccountID" Type="String" />
                <asp:Parameter Name="SubAccountID" Type="String" />
                <asp:Parameter Name="CashBank_InstrumentType" Type="String" />
                <asp:Parameter Name="CashBank_InstrumentNumber" Type="String" />
                <asp:Parameter Name="CashBank_InstrumentDate" Type="string" />
                <asp:Parameter Name="CashBank_PayeeAccountID" Type="String" />
                <asp:Parameter Name="CashBank_AmountWithdrawl" Type="Decimal" />
                <asp:Parameter Name="CashBank_AmountDeposit" Type="Decimal" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
