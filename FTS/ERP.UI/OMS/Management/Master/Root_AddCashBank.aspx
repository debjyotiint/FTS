<%@ Page Title="" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true" CodeBehind="Root_AddCashBank.aspx.cs" Inherits="ERP.OMS.Management.Master.Root_AddCashBank" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="pull-left">
                <asp:Label ID="lblHeadTitle" Text="Add Cash/Bank" runat="server"></asp:Label>
            </h3>
            
            <div id="CashBankCross" runat="server">
                <div id="divcross" class="crossBtn" style="margin-left: 100px;"><a href="root_user.aspx"><i class="fa fa-times"></i></a></div>
            </div>
            
        </div>
    </div>
    
</asp:Content>
