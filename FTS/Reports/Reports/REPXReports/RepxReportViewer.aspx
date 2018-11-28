<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RepxReportViewer.aspx.cs" Inherits="Reports.Reports.REPXReports.RepxReportViewer" %>

<%@ Register assembly="DevExpress.XtraReports.v15.1.Web, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraReports.Web" tagprefix="dx" %>
<%@ Register Assembly="DevExpress.XtraCharts.v15.1.Web, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraCharts.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dxe" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <link rel="stylesheet" href="/assests/css/custom/main.css" />
    <link rel="stylesheet" type="text/css" href="/assests/fonts/font-awesome/css/font-awesome.min.css" />
    <title></title>
    <script type="text/javascript">
        function closeOnClick() {
            window.location.href = '/Reports/REPXReports/RepxReportMain.aspx?reportname=' + document.getElementById('HDRepornName').value;
        }

        <%--function OnClickEmail(s, e) {
            if (e.item != null) {
                <%--if (e.item.name == 'CustomPrn')
            {
                //alert(e.item.name);
                ASPxDocumentViewer1.Print();
            }
            else if (e.item.name == 'CustomExp')
                //ReportViewer1.SaveToWindow('pdf');
                ASPxCallback1.PerformCallback(e.item.name);
            }--%>
        //if (e.item.name == 'CustomEmail') {
        //ReportViewer1.SaveToWindow('pdf');
        //        cbtnEmail.PerformCallback(e.item.name);
        //    }
        //}
        //}
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div class="crossBtn" style="top: 41px;color:#ccc"><a href="#" onclick="closeOnClick()"><i class="fa fa-times"></i></a></div>
    </div>
        <%--<dx:ASPxDocumentToolbar runat="server" ID="aspxDocumentToolbar1" ReportViewerID="ASPxDocumentViewer1"></dx:ASPxDocumentToolbar>--%>
        <dx:ASPxDocumentViewer ID="ASPxDocumentViewer1" runat="server">
            <%--<ToolbarItems>--%>
                <%--<dx:ReportToolbarButton ItemKind="Search" />
                <dx:ReportToolbarSeparator />
                <dx:ReportToolbarButton ItemKind="PrintReport" />
                <dx:ReportToolbarButton ItemKind="PrintPage" />
                <dx:ReportToolbarSeparator />
                <dx:ReportToolbarButton Enabled="False" ItemKind="FirstPage" />
                <dx:ReportToolbarButton Enabled="False" ItemKind="PreviousPage" />
                <dx:ReportToolbarLabel ItemKind="PageLabel" />
                <dx:ReportToolbarComboBox ItemKind="PageNumber" Width="65px">
                </dx:ReportToolbarComboBox>
                <dx:ReportToolbarLabel ItemKind="OfLabel" />
                <dx:ReportToolbarTextBox IsReadOnly="True" ItemKind="PageCount" />
                <dx:ReportToolbarButton ItemKind="NextPage" />
                <dx:ReportToolbarButton ItemKind="LastPage" />
                <dx:ReportToolbarSeparator />
                <dx:ReportToolbarButton ItemKind="SaveToDisk" />
                <dx:ReportToolbarButton ItemKind="SaveToWindow" />
                <dx:ReportToolbarComboBox ItemKind="SaveFormat" Width="70px">--%>
                    <%--<Elements>
                        <dx:ListElement Value="pdf" />
                        <dx:ListElement Value="xls" />
                        <dx:ListElement Value="xlsx" />
                        <dx:ListElement Value="rtf" />
                        <dx:ListElement Value="mht" />
                        <dx:ListElement Value="html" />
                        <dx:ListElement Value="txt" />
                        <dx:ListElement Value="csv" />
                        <dx:ListElement Value="png" />
                    </Elements>
                </dx:ReportToolbarComboBox>--%>
                <%--<dx:ReportToolbarButton IconID="mail_mail_16x16" Name="Email" ToolTip="Email" />--%>
                <%--<dx:ReportToolbarButton ItemKind="Custom" Name="CustomEmail" ToolTip="Email" Text="Email" Enabled="true"/>--%>                
            <%--</ToolbarItems>--%>
        </dx:ASPxDocumentViewer>
        <%--<dx:ASPxButton ID="btnEmail" runat="server" OnCallback="btnEmail_Callback"></dx:ASPxButton>--%>
        <%--<dxe:ASPxButton ID="btnEmail" ClientInstanceName="cbtnEmail" runat="server" OnCallback="btnEmail_Callback">
            <ClientSideEvents Click="function(s, e) {
                                    debugger;
                                    OnClickEmail();
                            }"
                </ClientSideEvents>
        </dxe:ASPxButton>--%>
        <asp:HiddenField ID ="StartDate" runat="server" />
        <asp:HiddenField ID ="EndDate" runat="server" />        
        <asp:HiddenField ID ="HDRepornName" runat="server" />      
    </form>
</body>
</html>
