<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" Inherits="ERP.OMS.Management.management_testlist" CodeBehind="testlist.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">

        function validate_number() {
            alert('Hii');
            var telephone = document.getElementById("TextBox2");
            alert(telephone.value)
            if (telephone.value.search(/^[0-9]*$/) == -1) {
                alert('Telephone field contains invalid\n' +
                      'characters please correct.');
                telephone.focus();
                return false;
            } else {
                return true;
            }
        }
    </script>
    <div id="test">
        <table style="width: 416px; background-color: Aqua">
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="txtname" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox2" runat="server" Text="ddd"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox3" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox4" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px; height: 26px;">
                    <asp:TextBox ID="TextBox5" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox6" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox7" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox8" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox9" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <asp:TextBox ID="TextBox10" runat="server" Text="aaa"></asp:TextBox></td>
            </tr>

        </table>
    </div>

    <input id="Button2" type="button" value="dddd" onclick="validate_number()" />
</asp:Content>
