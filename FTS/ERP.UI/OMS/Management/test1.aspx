<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" Inherits="ERP.OMS.Management.management_test1" CodeBehind="test1.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        (function ($) {
            // call setMask function on the document.ready event
            $(function () {
                $('input:text').setMask();
            }
          );
        })(jQuery);
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <table>
            <tr>
                <td>
                    <asp:TextBox ID="TextBox1" runat="server" alt="date"></asp:TextBox>
                </td>
            </tr>
        </table>
        <asp:GridView ID="gvUsers" runat="server">
            <Columns>
                <asp:TemplateField HeaderText="User ID">
                    <ItemTemplate>
                        <asp:Label ID="lblUserID" runat="server" Text='<%# Eval("cashbank_id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="First Name">
                    <ItemTemplate>
                        <asp:Label ID="lblFirstName" runat="server" Text='<%# Eval("cashbank_id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Test Name">
                    <ItemTemplate>
                        <asp:Label ID="lblLastName" Visible='<%# !(bool) IsInEditMode %>' runat="server" Text='<%# Eval("cashbank_vouchernumber") %>' />
                        <asp:TextBox ID="txtLastName" Visible="true" runat="server" alt="date" />
                        <input id="Text1" type="text" alt="date" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" /><asp:Button
            ID="Button2" runat="server" Text="Button" />
    </div>
</asp:Content>
