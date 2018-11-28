<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RepxReportViewer.aspx.cs" Inherits="ERP.OMS.Reports.REPXReports.RepxReportViewer" %>

<%@ Register assembly="DevExpress.XtraReports.v15.1.Web, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraReports.Web" tagprefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div class="crossBtn" style="top: 41px;color:#ccc"><a href=" ../OMS/Reports/REPXReports/RepxReportMain.aspx"><i class="fa fa-times"></i></a></div>
    </div>
        <dx:ASPxDocumentViewer ID="ASPxDocumentViewer1" runat="server">
            <ClientSideEvents Init="function(s, e) { 
                s.Print();
            }" />            
        </dx:ASPxDocumentViewer>
        <asp:HiddenField ID ="StartDate" runat="server" />
        <asp:HiddenField ID ="EndDate" runat="server" />    
        <asp:HiddenField ID ="HDRepornName" runat="server" />  
    </form>
</body>
</html>
