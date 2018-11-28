<%@ Page Language="C#" Title="Special Edit" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" CodeBehind="PosSalesinvoiceAdminEdit.aspx.cs" Inherits="ERP.OMS.Management.Activities.PosSalesinvoiceAdminEdit" %>

<%@ Register Src="~/OMS/Management/Activities/UserControls/ucPaymentDetails.ascx" TagPrefix="uc1" TagName="ucPaymentDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="JS/PosSalesinvoiceAdminEdit.js"></script>
     
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="panel-title clearfix" id="myDiv">
        <h3 class="pull-left">
            Special Edit 
        </h3>
        <br />
        <br />
        <div class="col-md-6">
            <label>Sales Invoice</label>
            <input type="text" placeholder="Search By Invoice Number and Press Tab Key" id="SearchInv" style="width:80%" onblur="validateInvoiceNumber()"/>
        </div>
        <div class="col-md-6">
            <label>Customer Receipt/Refund</label>
            <br />
            <input type="button" class="btn btn-primary" value="Update Receipt/Refund Number" onclick="ShowManualReceiptPopup()"/>
            </div>
    </div>

    <div class="row">

         <div class="col-md-3" id="divSelectField" style="display:none;    color: #ab1111;" runat="server">
            <label><b>Select Field To Update</b></label>
               <asp:DropDownList ID="UpdateField" runat="server" >
                   <asp:ListItem Text="-Select-" Value="Select"/>
                   <asp:ListItem Text="Document Number" Value="docNo"/>
                   <asp:ListItem Text="Payment Details" Value="PaymnetDetails"/>
                   <asp:ListItem Text="Billing & Shipping" Value="BillingShipping"/>
                    <asp:ListItem Text="Financer Details" Value="FinanceBlock"/>
                   <asp:ListItem Text="Re-Post" Value="repost"/>
               </asp:DropDownList>
        </div>
         <div class="clear" />

        <div class="col-md-3" id="divInvoiceNumber">
            <label>Enter New Invoice Number</label>
               <asp:TextBox ID="txtInvoiceNumber" runat="server" MaxLength="16"></asp:TextBox>
        </div>

        <div class="clear" />
        
        <div class="col-md-12" id="divPaymentDetails">

              <uc1:ucPaymentDetails runat="server" ID="PaymentDetails" />
        </div>

         <div class="col-md-12" id="divBillingShipping">

             <div class="col-md-6">
                <label>Billing Details</label>
                  <asp:TextBox ID="txtBillingAddress1" runat="server" placeholder="Address1"></asp:TextBox>
                 <asp:TextBox ID="txtBillingAddress2" runat="server" placeholder="Address2"></asp:TextBox>
                 <asp:TextBox ID="txtBillingAddress3" runat="server" placeholder="Address3"></asp:TextBox>
                 <asp:TextBox ID="txtBillingLandMark" runat="server" placeholder="Land Mark"></asp:TextBox>
                 
                 <asp:TextBox ID="txtBillingPin" runat="server" MaxLength="6" placeholder="Pin (Country, State, City to be automatically updated)"></asp:TextBox>
                 <label style="color: blue;font-size: 12px;">Based on PIN Country, State, City to be automatically updated</label>
                 <br />
                 <a href="#" onclick="CopyToshipping()">Copy To Shipping</a>

             </div>

               <div class="col-md-6">
                <label>Shipping Details</label>
                  <asp:TextBox ID="txtShippingAddress1" runat="server" placeholder="Address1"></asp:TextBox>
                 <asp:TextBox ID="txtShippingAddress2" runat="server" placeholder="Address2"></asp:TextBox>
                 <asp:TextBox ID="txtShippingAddress3" runat="server" placeholder="Address3"></asp:TextBox>
                 <asp:TextBox ID="txtShippingLandmark" runat="server" placeholder="Land mark"></asp:TextBox>
                 <asp:TextBox ID="txtShippingPin" runat="server" MaxLength="6" placeholder="Pin (Country, State, City to be automatically updated)"></asp:TextBox>
                   <label style="color: blue;font-size: 12px;">Based on PIN Country, State, City to be automatically updated</label>
                   <br />
                   <a href="#" onclick="CopyToBilling()">Copy To Billing</a>
             </div>

          </div>

            <div class="row" id="divFinanceBlock">
                <div class="col-md-2">
                    <label>Downpayment</label>
                    <asp:TextBox ID="txtDownPayment" runat="server" placeholder="Down Payment" MaxLength="10"></asp:TextBox>   
                </div>
                <div class="col-md-2">
                    <label>Proc. Fee</label>
                    <asp:TextBox ID="txtProcFee" runat="server" placeholder="Proc. Fee" MaxLength="10"></asp:TextBox>   
                </div>
                <div class="col-md-2">
                    <label>EMI Card/Other Charges</label>
                    <asp:TextBox ID="txtEmiCard" runat="server" placeholder="EMI Card/Other Charges" MaxLength="10"></asp:TextBox>   
                </div>

             </div>



        <div class="col-md-3" id="divUpdateButton" runat="server" style="display:none">
            <asp:Button ID="btn_Update" runat="server" Text="Update" OnClick="btn_Update_Click"  CssClass="btn btn-primary" OnClientClick="UpdateClientClick()" UseSubmitBehavior="False"/>
        </div>

    </div>

    <dxe:ASPxPopupControl ID="ManualReceipt" runat="server" ClientInstanceName="cManualReceipt"
            Width="500px" HeaderText="Update ManualReceipt" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True" OnWindowCallback="ManualReceipt_WindowCallback">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                   <div class="row">
                       <div class="col-md-6">
                           <asp:TextBox ID="txtOldReceiptNumber" runat="server" ></asp:TextBox>
                    
                    <asp:Label ID="lblWrongReceipt" runat="server" Text="Invalid Receipt Number" Visible="false"></asp:Label>
                       </div>
                        
                        <div class="col-md-2">
                            <input type="button" onclick="SearchManualReceipt()" value="Search" class="btn btn-primary" />
                        </div>
                       <div class="clear"></div>
                       <div class="col-md-6">
                                 <asp:TextBox ID="txtNewReceiptNumber" runat="server" MaxLength="16"></asp:TextBox>
                            <asp:Button ID="btnmanualReceipt" runat="server" Text="Update"  CssClass="btn btn-primary" OnClientClick="UpdateManualReceipt(); return false;"  UseSubmitBehavior="False"/>
                           </div>
                       </div>

                    <asp:HiddenField ID="hdRecPayType" runat="server"></asp:HiddenField>
                    </dxe:PopupControlContentControl> 
            </ContentCollection>
           
        </dxe:ASPxPopupControl>

</asp:Content>