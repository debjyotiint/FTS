<%@ Page Title="Imports Bank Statement" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" EnableEventValidation="false" Inherits="ERP.OMS.Management.DailyTask.management_DailyTask_frmBankStatement_" CodeBehind="frmBankStatement.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        groupvalue = "";
        function ShowHideFilter(obj1, obj2) {
            if (obj1 == 'sum')
                gridMatched.PerformCallback(obj1 + '~' + obj2);
            else
                gridUnMatched.PerformCallback(obj1 + '~' + obj2);

        }

        function OnMoreInfoClick(obj1) {
            var url = 'frmBankStatementIndividual.aspx?Id=' + obj1 + '&TransactionDate=' + obj2 + '&ValueDate=' + obj3 + '&InstrumentNumber=' + obj4 + '&Transactionamount=' + obj5 + '&Description=' + obj6 + '&RunningAmount=' + obj7 + '&Receipt=' + obj8;
            OnMoreInfoClick(url, "Rectify Summary", '940px', '450px', "Y");
        }

        function SignOff() {
            window.parent.SignOff();
        }
        function height() {
            //if (document.body.scrollHeight >= 400)
            //    window.frameElement.height = document.body.scrollHeight;
            //else
            //    window.frameElement.height = '400px';

            //window.frameElement.Width = document.body.scrollWidth;
        }
        function callback() {
            gridUnMatched.PerformCallback();
        }
        function gridrefresh(obj) {
            alert(obj);
            gridUnMatched.PerformCallback(obj);
        }
        function CallAjax(obj1, obj2, obj3) {
            ajax_showOptions(obj1, obj2, obj3);
        }
        function showOptions(obj1, obj2, obj3) {
            FieldName = 'ddlBankList';
            ajax_showOptions(obj1, obj2, obj3);
        }
        FieldName = 'ddlBankList';
        function CallBankAccount(obj1, obj2, obj3) {
            var CurrentSegment = '<%=Session["usersegid"]%>'
            var strPutSegment = " and (MainAccount_ExchangeSegment=" + CurrentSegment + " or MainAccount_ExchangeSegment=0)";
            var strQuery_Table = "(Select MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\' as IntegrateMainAccount,MainAccount_AccountCode as MainAccount_AccountCode,MainAccount_Name,MainAccount_BankAcNumber from Master_MainAccount where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\') and (MainAccount_BankCompany=\'" + '<%=Session["LastCompany"] %>' + "\' Or IsNull(MainAccount_BankCompany,'')='')" + strPutSegment + ") as t1";
            var strQuery_FieldName = " Top 10 * ";
            var strQuery_WhereClause = "MainAccount_AccountCode like (\'%RequestLetter%\') or MainAccount_Name like (\'%RequestLetter%\') or MainAccount_BankAcNumber like (\'%RequestLetter%\')";
            var strQuery_OrderBy = '';
            var strQuery_GroupBy = '';
            var CombinedQuery = new String(strQuery_Table + "$" + strQuery_FieldName + "$" + strQuery_WhereClause + "$" + strQuery_OrderBy + "$" + strQuery_GroupBy);
            ajax_showOptions(obj1, obj2, obj3, replaceChars(CombinedQuery), 'Main');
        }
        function replaceChars(entry) {
            out = "+"; // replace this
            add = "--"; // with this
            temp = "" + entry; // temporary holder

            while (temp.indexOf(out) > -1) {
                pos = temp.indexOf(out);
                temp = "" + (temp.substring(0, pos) + add +
                temp.substring((pos + out.length), temp.length));
            }
            return temp;

        }

    </script>
    <style>
        #ghhhtbl td {
            padding-right: 15px;
        }
    </style>
    <script src="/assests/pluggins/choosen/choosen.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            ListBind();
            ChangeSource();
        });
        function ListBind() {
            var config = {
                '.chsn': {},
                '.chsn-deselect': { allow_single_deselect: true },
                '.chsn-no-single': { disable_search_threshold: 10 },
                '.chsn-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chsn-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        }
        function ChangeSource() {
            var fname = "%";
            var lBankList = $('select[id$=lstBankList]');
            lBankList.empty();

            var CurrentSegment = '<%=Session["usersegid"]%>'
            var strPutSegment = " and (MainAccount_ExchangeSegment=" + CurrentSegment + " or MainAccount_ExchangeSegment=0)";
            var strQuery_Table = "(Select MainAccount_AccountCode+\'-\'+MainAccount_Name+\' [ \'+MainAccount_BankAcNumber+\' ]\' as IntegrateMainAccount,MainAccount_AccountCode as MainAccount_AccountCode,MainAccount_Name,MainAccount_BankAcNumber from Master_MainAccount where (MainAccount_BankCashType=\'Bank\' or MainAccount_BankCashType=\'Cash\') and (MainAccount_BankCompany=\'" + '<%=Session["LastCompany"] %>' + "\' Or IsNull(MainAccount_BankCompany,'')='')" + strPutSegment + ") as t1";
            var strQuery_FieldName = "  * ";

            $.ajax({
                type: "POST",
                url: "frmBankStatement.aspx/GetBankList",
                data: JSON.stringify({ reqTable: strQuery_Table, reqFieldName: strQuery_FieldName }),
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

                            $('#lstBankList').append($('<option>').text(name).val(id));
                        }

                        $(lBankList).append(listItems.join(''));
                        lstBankList();
                        $('#lstBankList').trigger("chosen:updated");
                    }
                    else {
                        $('#lstBankList').trigger("chosen:updated");
                    }
                }
            });
        }
        function lstBankList() {
            $('#lstBankList').fadeIn();
        }
        function changeBankList() {
            var lstBankList = document.getElementById("lstBankList").value;
            document.getElementById("txtBank_hidden").value = lstBankList;
        }
    </script>
    <style>
        #lstBankList + .chosen-container-single {
            width: 100% !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Imports Bank Statement</h3>
        </div>

    </div>
    <div class="form_main" style="align-items: center;">
        <asp:Panel ID="Panelmain" runat="server" Visible="true">
            <div style="background: #f5f4f3; padding: 8px 0; margin-bottom: 15px; border-radius: 4px; border: 1px solid #ccc;" class="clearfix">
                <div class="col-md-3">
                    <label>Bank</label>
                    <div>
                        <%--<asp:TextBox ID="txtBank" runat="server" Font-Size="11px" Width="200px"  onkeyup="CallBankAccount(this,'GenericAjaxList',event)"></asp:TextBox>--%>
                        <asp:ListBox ID="lstBankList" CssClass="chsn hide" runat="server" Width="100%" TabIndex="8" data-placeholder="Select..." onchange="changeBankList();"></asp:ListBox>
                    </div>
                </div>
                <div class="col-md-3">
                    <label>File Format</label>
                    <div>
                        <asp:DropDownList ID="ddlBankList" runat="server" Width="100%">
                            <asp:ListItem Value="HDFC BANK">HDFC-Enet</asp:ListItem>
                            <asp:ListItem Value="HDFC BANK EASY VIEW">HDFC-EasyView</asp:ListItem>
                            <asp:ListItem Value="ICICI">ICICI-Bank</asp:ListItem>
                            <asp:ListItem Value="Axis Bank CSV">Axis Bank</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-md-3">
                    <label>Choose File</label>
                    <div>
                        <asp:FileUpload ID="OFDBankSelect" runat="server" Width="100%" />
                    </div>
                </div>
                <div class="col-md-3">
                    <label>&nbsp;</label>
                    <div>
                        <asp:Button ID="BtnSave" runat="server" Text="Import File" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                        <asp:LinkButton ID="lnlDownloader" runat="server" OnClick="lnlDownloader_Click" CssClass="btn btn-info">Download Format</asp:LinkButton>
                    </div>
                </div>

                <div style="display: none">
                    <asp:TextBox ID="txtBank_hidden" runat="server" Width="14px"></asp:TextBox>
                </div>
            </div>
            <table>
                <tr>
                    <td>
                        <asp:DropDownList ID="ddlExport" AutoPostBack="true" CssClass="btn btn-sm btn-primary" runat="server" OnSelectedIndexChanged="ddlExport_SelectedIndexChanged">
                            <asp:ListItem Value="0">Export to</asp:ListItem>
                            <asp:ListItem Value="1">Excel</asp:ListItem>
                            <asp:ListItem Value="2">PDF</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            <div id="divSummary">
                <table width="100%">
                    <tr>
                        <td>
                            <dxe:ASPxPageControl ID="ASPxPageControl1" runat="server"
                                ActiveTabIndex="1" ClientInstanceName="page"
                                Font-Size="12px" Width="100%">
                                <ClientSideEvents ActiveTabChanged="function(s, e) {
	height();
}" />
                                <TabPages>
                                    <dxe:TabPage Text="Matched Records">
                                        <TabStyle Font-Bold="True"></TabStyle>
                                        <ContentCollection>
                                            <dxe:ContentControl runat="server">
                                                <table style="display: none">
                                                    <tbody>
                                                        <tr>
                                                            <td><a href="javascript:ShowHideFilter('sum','s');" class="btn btn-success">Show Filter</span></a> </td>
                                                            <td><a href="javascript:ShowHideFilter('sum','All');" class="btn btn-primary">All Records</span></a> </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <dxe:ASPxGridView runat="server" Width="100%" ID="gridMatchedSummary" KeyFieldName="BANKSTATEMENT_ID" AutoGenerateColumns="False" ClientInstanceName="gridMatched" __designer:wfdid="w9" OnPageIndexChanged="gridMatchedSummary_PageIndexChanged" OnCustomCallback="grid_CustomCallback">
                                                    <SettingsPager Mode="ShowAllRecords" Visible="False"></SettingsPager>
                                                    <SettingsSearchPanel Visible="True" />
                                                    <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                                    <Columns>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="0" FieldName="BANKSTATEMENT_Debit/Credit" Caption="Type">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="BANKSTATEMENT_TransactionDate" Caption="Transaction Date">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="BANKSTATEMENT_ValueDate" Caption="Value Date">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="BANKSTATEMENT_ReferenceNo" Caption="Instrument Number">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="BANKSTATEMENT_TransactionAmount" Caption="Transaction Amount">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                            <PropertiesTextEdit DisplayFormatString="{0:0.00}" Width="100%">
                                                                <MaskSettings Mask="<0..999999999>.<0..99>" IncludeLiterals="DecimalSymbol" />

                                                            </PropertiesTextEdit>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="BANKSTATEMENT_TransactionDescription" Caption="Transaction Description">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="6" FieldName="BANKSTATEMENT_RunningBalance" Caption="Transaction RunningBalance">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                    </Columns>
                                                </dxe:ASPxGridView>
                                            </dxe:ContentControl>
                                        </ContentCollection>
                                    </dxe:TabPage>
                                    <dxe:TabPage Text="Unmatched/Already Tagged Records">
                                        <TabStyle Font-Bold="True"></TabStyle>
                                        <ContentCollection>
                                            <dxe:ContentControl runat="server">
                                                <table style="display: none">
                                                    <tbody>
                                                        <tr>
                                                            <td><a href="javascript:ShowHideFilter('usum','s');" class="btn btn-success"><span>Show Filter</span></a> </td>
                                                            <td><a href="javascript:ShowHideFilter('usum','All');" class="btn btn-primary"><span>All Records</span></a> </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <dxe:ASPxGridView runat="server" Width="100%" ID="gridUnMatchedSummary" KeyFieldName="BANKSTATEMENT_ID" AutoGenerateColumns="False" ClientInstanceName="gridUnMatched" __designer:wfdid="w10" OnCustomCallback="grid_CustomCallback">
                                                    <SettingsPager Mode="ShowAllRecords" Visible="False"></SettingsPager>
                                                    <SettingsSearchPanel Visible="True" />
                                                    <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" ShowFilterRowMenu="true" />
                                                    <Columns>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="0" FieldName="DebitCredit" Caption="Type">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="BANKSTATEMENT_TransactionDate" Caption="Transaction Date">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="2" FieldName="BANKSTATEMENT_ValueDate" Caption="Value Date">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="3" FieldName="BANKSTATEMENT_ReferenceNo" Caption="Instrument Number">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="4" FieldName="BANKSTATEMENT_TransactionAmount" Caption="Transaction Amount">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="5" FieldName="BANKSTATEMENT_TransactionDescription" Caption="Transaction Description">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn Visible="False" VisibleIndex="6" FieldName="BANKSTATEMENT_RunningBalance" Caption="Transaction RunningBalance">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                        <dxe:GridViewDataTextColumn VisibleIndex="6" FieldName="ShowStatus" Caption="Status">
                                                            <Settings AutoFilterCondition="Contains"></Settings>
                                                        </dxe:GridViewDataTextColumn>
                                                    </Columns>
                                                </dxe:ASPxGridView>
                                            </dxe:ContentControl>
                                        </ContentCollection>
                                    </dxe:TabPage>
                                </TabPages>
                            </dxe:ASPxPageControl>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </div>
</asp:Content>



