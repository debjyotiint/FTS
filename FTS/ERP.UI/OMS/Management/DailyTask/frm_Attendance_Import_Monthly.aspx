<%@ Page Title="Monthly Attendance Import" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" Inherits="ERP.OMS.Management.DailyTask.management_DailyTask_frm_Attendance_Import_Monthly" CodeBehind="frm_Attendance_Import_Monthly.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    

    <script language="javascript" type="text/javascript">
        function height() {
            if (document.body.scrollHeight >= 350)
                window.frameElement.height = document.body.scrollHeight;
            else
                window.frameElement.height = '350px';
            window.frameElement.Width = document.body.scrollWidth;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Monthly Attendance Import</h3>
        </div>
    </div>
    <div class="form_main">
        <table class="TableMain100">
            <tr>
                <td colspan="2">
                    <asp:FileUpload ID="FLSelectFile" runat="server" Width="250px" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblStatus" runat="server" Width="400px" ForeColor="Blue"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblList" runat="server" Text="" Width="408px" ForeColor="red"></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="btnSubmit" runat="server" Text="Import" CssClass="btnUpdate btn btn-primary" OnClick="btnSubmit_Click" />
                </td>
            </tr>
        </table>
    </div>

</asp:Content>
