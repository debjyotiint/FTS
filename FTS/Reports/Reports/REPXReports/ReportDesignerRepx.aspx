<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportDesignerRepx.aspx.cs" Inherits="Reports.Reports.REPXReports.ReportDesignerRepx" %>

<%@ Register assembly="DevExpress.XtraReports.v15.1.Web, Version=15.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraReports.Web" tagprefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="/assests/css/custom/main.css" />
    <link rel="stylesheet" type="text/css" href="/assests/fonts/font-awesome/css/font-awesome.min.css" />
    <title></title>
    <script type="text/javascript">
        var isReportSavingCallback = false;
        function ReportDesigner_SaveCommandExecute(s, e) {
            debugger;
            isReportSavingCallback = true;
        }

        function ReportDesigner_EndCallback(s, e) {
            debugger;
            if (isReportSavingCallback) {
                isReportSavingCallback = false;
                alert(s.cpSaveResult);
                //jAlert("Report saved successfully.");
            }
        }

    </script>
</head>
<body>    
    <form id="form1" runat="server">
    <div>        
        <div class="crossBtn" style="top: 41px;color:#ccc"><a href="/Reports/REPXReports/RepxReportMain.aspx"><i class="fa fa-times"></i></a></div>
        
    </div>
        <dx:ASPxReportDesigner ID="ASPxReportDesigner1" runat="server" OnSaveReportLayout="ASPxReportDesigner1_SaveReportLayout">            
            <ClientSideEvents SaveCommandExecute="ReportDesigner_SaveCommandExecute" EndCallback="ReportDesigner_EndCallback"  />
        </dx:ASPxReportDesigner>
          <asp:HiddenField ID ="RptName" runat="server" />
          <asp:HiddenField ID ="StartDate" runat="server" />
          <asp:HiddenField ID ="EndDate" runat="server" />
    </form>
</body>
</html>
