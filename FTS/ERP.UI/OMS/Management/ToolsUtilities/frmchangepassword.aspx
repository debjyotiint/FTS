<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master"
    Inherits="ERP.OMS.Management.ToolsUtilities.management_utilities_frmchangepassword" CodeBehind="frmchangepassword.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">




    <script language="javascript" type="text/javascript">
        //function goBack() {
        //    window.history.back();
        //}
        function BtnCancel_Click() {
            location.href = '/OMS/Management/ProjectMainPage.aspx';
            //var old = document.getElementById("TxtOldPassword");
            //var newP = document.getElementById("TxtNewPassword");
            //var confirmP = document.getElementById("TxtConfirmPassword");
            //old.value = "";
            //newP.value = "";
            //confirmP.value = "";
        }
        //function SignOff()
        //{
        //    window.parent.SignOff();
        //}
        //function height()
        //{
        //    if(document.body.scrollHeight>=500)
        //        window.frameElement.height = document.body.scrollHeight;
        //    else
        //        window.frameElement.height = '500px';
        //    window.frameElement.Width = document.body.scrollWidth;
        //}
    </script>
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Change Password</h3>
        </div>

    </div>
    <div class="form_main">
        <table class="TableMain100" style="text-align: left;">

            <tr>
                <td style="text-align: left;">
                    <br />
                    <asp:Panel ID="panel1" BorderColor="white" BorderWidth="1px" runat="server" Width="400px">
                        <table>
                            <tr>
                                <td class="Ecoheadtxt" width="200px">Old Password :
                                </td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="TxtOldPassword" runat="server" CssClass="EcoheadCon" TextMode="Password" MaxLength="20"
                                        Width="160px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="Ecoheadtxt">New Password :
                                </td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="TxtNewPassword" runat="server" CssClass="EcoheadCon" TextMode="Password" MaxLength="20"
                                        Width="160px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="Ecoheadtxt">Confirm Password :
                                </td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="TxtConfirmPassword" runat="server" CssClass="EcoheadCon" TextMode="Password" MaxLength="20"
                                        Width="160px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="BtnSave" runat="server" Text="Update" class="btn btn-primary" OnClick="BtnSave_Click"
                                        ValidationGroup="a" />
                                    <input id="BtnCancel" type="button" value="Cancel" class="btn btn-danger" onclick="BtnCancel_Click()" />

                                <%--    <a href='javascript:history.back()' class="btn btn-danger">Go Back to Previous Page</a>--%>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TxtOldPassword"
                                        Display="None" ErrorMessage="Old PassWord Can Not Be Blank" SetFocusOnError="True"
                                        ValidationGroup="a"></asp:RequiredFieldValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TxtNewPassword"
                                        Display="None" ErrorMessage="New PassWord Can Not Be Blank" SetFocusOnError="True"
                                        ValidationGroup="a"></asp:RequiredFieldValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TxtConfirmPassword"
                                        Display="None" ErrorMessage="Confirm PassWord Can Not Be Blank" SetFocusOnError="True"
                                        ValidationGroup="a"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="TxtNewPassword"
                                        ControlToValidate="TxtConfirmPassword" Display="None" ErrorMessage="New Password And Confirm Password Must Be Same"
                                        SetFocusOnError="True" ValidationGroup="a"></asp:CompareValidator>
                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                                        ShowSummary="False" ValidationGroup="a" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <br />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

<%--<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="form_main">
        


            <div class="row">
  <div class="col-sm-4"></div>
  <div class="col-sm-4">

                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Old Password :</label> 
                        <div class="col-md-9 col-sm-9 col-xs-12">
                          <input type="password" class="form-control EcoheadCon" placeholder="Default Input" id="TxtOldPassword"/>
                        </div>
                      </div>
                      
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">New Password :</label> 
                        <div class="col-md-9 col-sm-9 col-xs-12">
                          <input type="password" class="form-control EcoheadCon" placeholder="Default Input" id="TxtNewPassword"/> 
                        </div>
                      </div>
                      
                      <div class="form-group">
                        <label class="control-label col-md-3 col-sm-3 col-xs-12">Confirm Password :</label> 
                        <div class="col-md-9 col-sm-9 col-xs-12">
                          <input type="password" class="form-control EcoheadCon" placeholder="Default Input" id="TxtConfirmPassword"/>
                        </div>
                      </div>



  </div>
  <div class="col-sm-4"></div>
</div>
            <div class="col-md-12" style="text-align: center;">
                <div class="form-group">
                    <div>
                      <button type="submit" id="BtnSave" class="btn btn-danger" onclick="BtnCancel_Click()">Cancel</button>

                      <button type="submit" id="Button1" class="btn btn-primary">Submit</button>

                    </div>
                  </div>
            </div>
    </div>
</asp:Content>--%>
