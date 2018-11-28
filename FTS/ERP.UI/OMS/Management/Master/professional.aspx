<%@ Page Title="Professions" Language="C#" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" Inherits="ERP.OMS.Management.Master.management_master_professional" CodeBehind="professional.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <script type="text/javascript">
       
        function ShowHideFilter(obj) {
            grid.PerformCallback(obj);

        }
        function fn_PopUpOpen() {
            document.getElementById("profreq").style.visibility = "hidden";
            chfProfId.Set('hfProfId', '');
            ctxtProfession.SetText('');
            cPopupProfession.Show();
            cPopupProfession.SetHeaderText("Add Profession Details");
            
        }
        function fn_EditProfession(keyValue) {
            document.getElementById("profreq").style.visibility = "hidden";
            grid.PerformCallback('Edit~' + keyValue);
            cPopupProfession.SetHeaderText("Modify Profession Details");
        }
        function fn_btnProfession() {
            document.getElementById("profreq").style.visibility = "hidden";
            cPopupProfession.Hide();
        }
        function grid_EndCallBack() {
            if (grid.cpEdit != null) {
                ctxtProfession.SetText(grid.cpEdit.split('~')[0]);
                var hfId = grid.cpEdit.split('~')[1];
                chfProfId.Set('hfProfId', hfId);
                cPopupProfession.Show();

            }
         

            if (grid.cpinsert != null) {
                if (grid.cpinsert == 'Success') {
                    alert('Saved Successfully');
                    cPopupProfession.Hide();
                }
                else {
                    alert("Error On Insertion\n'Please Try Again!!'");
                }
            }

            if (grid.cpUpdate != null) {
                if (grid.cpUpdate == 'Success') {
                    alert('Updated Successfully');
                    cPopupProfession.Hide();
                }
                else {
                    alert("Error On Updatio\n'Please Try Again!!'");
                }
            }

            if (grid.cpDelete != null) {
                if (grid.cpDelete == 'Success')
                    alert('Deleted Successfully');
                else if (grid.cpDelete == 'datalinked')
                    alert('Used in other module. Cannot delete.');
                else
                    alert("Error on deletion\n'Please Try again!!'")
            }

            if (grid.cpExists != null) {
                if (grid.cpExists == 'Exists') {
                    alert('Record Already Exists');
                    cPopupProfession.Hide();
                }

            }

        }
        function fn_DeleteProfession(keyValue) {

            if (confirm("Confirm Delete?")) {
                grid.PerformCallback('Delete~' + keyValue);
            }
        }

        function btnSave_Profession() {
          
            if (ctxtProfession.GetText() == '') {
                //alert('Please Enter Profession Name');
                document.getElementById("profreq").style.visibility = "visible";
                ctxtProfession.Focus();

            }
            else {
                var hfpid = chfProfId.Get('hfProfId');
                if (hfpid == '') {
                    document.getElementById("profreq").style.visibility = "hidden";
                    grid.PerformCallback('SaveProfession~' + ctxtProfession.GetText());
                }
                else {
                    document.getElementById("profreq").style.visibility = "hidden";
                    grid.PerformCallback('UpdateProfession~' + chfProfId.Get('hfProfId'));
                }
            }


        }
    </script>
    <style type="text/css">
        .profDiv {
            height: 25px;
            width: 100px;
            float: left;
            margin-left: 10px;
        }

        .StateTextbox {
            height: 25px;
            width: 50px;
        }

        .Top {
            height: 30px;
            width: 400px;
            padding-top: 5px;
        }

        .Footer {
            height: 30px;
            width: 400px;
            padding-top: 10px;
        }

        .dxpc-headerText.dx-vam {
            color: #fff;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Professions</h3>
        </div>
    </div>
    <div class="form_main">
        <table class="TableMain100">
            <%--<tr>
                <td class="EHEADER" style="text-align: center;">
                    <strong><span style="color: #000099">Profession List</span></strong></td>
            </tr>--%>
            <tr>
                <td>
                    <table width="100%">
                        <tr>
                            <td style="text-align: left; vertical-align: top">
                                <table>
                                    <tr>
                                        <td id="ShowFilter">
                                            <% if (rights.CanAdd)
                                               { %>
                                            <a href="javascript:void(0);" onclick="fn_PopUpOpen()" class="btn btn-primary"><span>Add New</span> </a>
                                            <% } %>
                                             <asp:DropDownList ID="cmbExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Value="0">Export to</asp:ListItem>
                                    <asp:ListItem Value="1">PDF</asp:ListItem>
                                    <asp:ListItem Value="2">XLS</asp:ListItem>
                                    <asp:ListItem Value="3">RTF</asp:ListItem>
                                    <asp:ListItem Value="4">CSV</asp:ListItem>

                                </asp:DropDownList>
                                            
                                            <%--<a href="javascript:ShowHideFilter('s');" class="btn btn-success"><span>Show Filter</span></a>--%>
                                        </td>
                                        <td id="Td1">
                                            <%--<a href="javascript:ShowHideFilter('All');" class="btn btn-primary"><span>All Records</span></a>--%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td></td>
                            <td class="gridcellright pull-right">
                             <%--   <dxe:ASPxComboBox ID="cmbExport" runat="server" AutoPostBack="true"
                                    Font-Bold="False" ForeColor="black" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged"
                                    ValueType="System.Int32" Width="130px">
                                    <items>
                                        <dxe:ListEditItem Text="Select" Value="0" />
                                        <dxe:ListEditItem Text="PDF" Value="1" />
                                        <dxe:ListEditItem Text="XLS" Value="2" />
                                        <dxe:ListEditItem Text="RTF" Value="3" />
                                        <dxe:ListEditItem Text="CSV" Value="4" />
                                    </items>
                                    <buttonstyle>
                                    </buttonstyle>
                                    <itemstyle>
                                        <HoverStyle>
                                        </HoverStyle>
                                    </itemstyle>
                                    <border bordercolor="black" />
                                    <dropdownbutton text="Export">
                                    </dropdownbutton>
                                </dxe:ASPxComboBox>--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <dxe:ASPxGridView ID="ProfQualGrid" ClientInstanceName="grid" runat="server" AutoGenerateColumns="False"
                        KeyFieldName="pro_id" Width="100%" OnHtmlEditFormCreated="ProfQualGrid_HtmlEditFormCreated"
                        OnHtmlRowCreated="ProfQualGrid_HtmlRowCreated" OnCustomCallback="ProfQualGrid_CustomCallback" OnRowDeleting="ProfQualGrid_RowDeleting">
                          <ClientSideEvents EndCallback="function (s, e) {;
                              grid_EndCallBack();}" />
                        <columns>
                            <dxe:GridViewDataTextColumn FieldName="pro_id" ReadOnly="True" Visible="False"
                                VisibleIndex="0" Width="20%">
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Profession" FieldName="pro_professionName"
                                VisibleIndex="0" Width="80%">
                                <PropertiesTextEdit Width="300px">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorText="" ErrorTextPosition="Right"
                                        SetFocusOnError="True" ValidateOnLeave="False" >
                                        <RequiredField ErrorText="" IsRequired="True" />
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <EditFormSettings Visible="True" />
                                <EditCellStyle HorizontalAlign="Left" Wrap="False">
                                    <Paddings PaddingTop="15px" />
                                </EditCellStyle>
                                <CellStyle Wrap="False">
                                </CellStyle>
                                <EditFormCaptionStyle Wrap="False" HorizontalAlign="Right">
                                </EditFormCaptionStyle>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Width="6%">
                                <HeaderStyle HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    Actions
                                    <%--<a href="javascript:void(0);" onclick="fn_PopUpOpen()"><span>Add New</span> </a>--%>
                                </HeaderTemplate>
                                <DataItemTemplate>
                                    <% if (rights.CanEdit)
                                       {  %>
                                    <a href="javascript:void(0);" onclick="fn_EditProfession('<%#Container.KeyValue %>')" class="pad">
                                        <img src="../../../assests/images/Edit.png" alt="Edit"></a>
                                    <%  } %>
                                    <% if (rights.CanDelete)
                                       {  %>
                                    <a href="javascript:void(0);" onclick="fn_DeleteProfession('<%#Container.KeyValue %>')">
                                        <img src="../../../assests/images/Delete.png" alt="Delete"></a>
                                    <% } %>
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Center">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>



                            <%-- <dxe:GridViewCommandColumn VisibleIndex="1">
                                <DeleteButton Visible="True">
                                </DeleteButton>
                                <EditButton Visible="True">
                                </EditButton>
                                <HeaderStyle HorizontalAlign="Center" />
                                <HeaderTemplate>
                                    <%if (Session["PageAccess"].ToString().Trim() == "All" || Session["PageAccess"].ToString().Trim() == "Add" || Session["PageAccess"].ToString().Trim() == "DelAdd")
                      { %>
                                    <a href="javascript:void(0);" onclick="fn_PopUpOpen()"><span style="color: #000099;
                                        text-decoration: underline">Add New</span> </a>
                                    <%} %>
                                </HeaderTemplate>
                            </dxe:GridViewCommandColumn>--%>
                        </columns>
                        <settingscommandbutton>                           
                            <EditButton Image-Url="../../../assests/images/Edit.png" ButtonType="Image" Image-AlternateText="Edit" Styles-Style-CssClass="pad">
                            </EditButton>
                             <DeleteButton Image-Url="../../../assests/images/Delete.png" ButtonType="Image" Image-AlternateText="Delete">
                            </DeleteButton>
                            <UpdateButton Text="Update" ButtonType="Button" Styles-Style-CssClass="btn btn-primary "></UpdateButton>
                            <CancelButton Text="Cancel" ButtonType="Button" Styles-Style-CssClass="btn btn-danger "></CancelButton>
                        </settingscommandbutton>
                        <styles>
                            <Cell CssClass="gridcellleft">
                            </Cell>
                            <Header ImageSpacing="5px" SortingImageSpacing="5px">
                            </Header>
                            <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                        </styles>
                        <SettingsSearchPanel Visible="True" />
                        <settings showgrouppanel="True" showstatusbar="Visible" showfilterrow="true" showfilterrowmenu="true" />
                        <settingstext commandnew="Add" popupeditformcaption="Add/Modify Profession" confirmdelete="Confirm delete?" />
                        <settingsbehavior columnresizemode="NextColumn" confirmdelete="True" />
                        <settingsediting mode="PopupEditForm" popupeditformheight="200px" popupeditformhorizontalalign="Center"
                            popupeditformmodal="True" popupeditformverticalalign="Above" popupeditformwidth="600px"
                            editformcolumncount="1" />
                        <settingspager numericbuttoncount="20" pagesize="20" alwaysshowpager="True" showseparators="True">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                        </settingspager>
                        <templates>
                            <EditForm>
                                <table style="width: 100%">
                                    <tr>
                                        <td style="width: 100%">
                                            <controls>
                                                <dxe:ASPxGridViewTemplateReplacement runat="server" ReplacementType="EditFormEditors" ColumnID="" ID="Editors">
                                                </dxe:ASPxGridViewTemplateReplacement>                                                           
                                            </controls>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center">
                                            <dxe:ASPxGridViewTemplateReplacement ID="UpdateButton" ReplacementType="EditFormUpdateButton"
                                                runat="server"></dxe:ASPxGridViewTemplateReplacement>
                                            <dxe:ASPxGridViewTemplateReplacement ID="CancelButton" ReplacementType="EditFormCancelButton"
                                                runat="server"></dxe:ASPxGridViewTemplateReplacement>
                                        </td>
                                    </tr>
                                </table>
                            </EditForm>
                        </templates>
                      <%--  <clientsideevents endcallback="function (s, e) {grid_EndCallBack();}" />--%>
                    </dxe:ASPxGridView>
                    <dxe:ASPxPopupControl ID="PopupProfession" runat="server" ClientInstanceName="cPopupProfession"
                        Width="400px" Height="120px" HeaderText="" PopupHorizontalAlign="Windowcenter"
                        PopupVerticalAlign="WindowCenter" CloseAction="closeButton" Modal="true">
                        <contentcollection>
                            <dxe:PopupControlContentControl ID="countryPopup" runat="server">
                                <div class="Top">
                                    <div>
                                        <div class="profDiv">
                                            Profession &nbsp; <span style="color:red;"> *</span>
                                        </div>
                                        <div style="position:relative">
                                            <dxe:ASPxTextBox ID="txtProfession" ClientInstanceName="ctxtProfession" ClientEnabled="true"
                                                runat="server" Height="25px" Width="240px" MaxLength="50">
                                            </dxe:ASPxTextBox>
           
                                            <span id="profreq" class="pullrightClass fa fa-exclamation-circle abs" style="color:red;visibility:hidden; position:absolute;right: 30px;top: 5px;"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="ContentDiv">
                                    <div class="Footer">
                                        <div style="margin-left: 110px; width: 70px; float: left; padding-top:12px;">
                                            <dxe:ASPxButton ID="btnSave_Profession" ClientInstanceName="cbtnSave_Profession" runat="server" CssClass="btn btn-primary"
                                                AutoPostBack="False" Text="Save">
                                                <ClientSideEvents Click="function (s, e) {btnSave_Profession();}" />
                                            </dxe:ASPxButton>
                                        </div>
                                        <div style="width: 200px; float: right; padding-top:12px;">
                                            <dxe:ASPxButton ID="btnCancel_Profession" CssClass="btn btn-danger" runat="server" AutoPostBack="False" Text="Cancel">
                                                <ClientSideEvents Click="function (s, e) {fn_btnProfession();}" />
                                            </dxe:ASPxButton>
                                        </div>
                                        <br style="clear: both;" />
                                    </div>
                                    <br style="clear: both;" />
                                </div>
                            </dxe:PopupControlContentControl>
                        </contentcollection>
                        <headerstyle backcolor="LightGray" forecolor="Black" />
                    </dxe:ASPxPopupControl>
                </td>
            </tr>
            <tr>
                <td>
                    <dxe:ASPxHiddenField runat="server" ClientInstanceName="chfProfId" ID="hfProfId"></dxe:ASPxHiddenField>
                </td>
            </tr>
        </table>
    </div>
    <%--<asp:SqlDataSource ID="Professional" runat="server" ConflictDetection="CompareAllValues"
            ConnectionString="<%$ ConnectionStrings:CRMConnectionString %>" DeleteCommand="DELETE FROM [tbl_master_profession] WHERE [pro_id] = @original_pro_id"
            InsertCommand="INSERT INTO [tbl_master_profession] ([pro_professionName], [CreateDate], [CreateUser]) VALUES (@pro_professionName, getdate(), @CreateUser)"
            OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT [pro_id],[pro_professionName] FROM [tbl_master_profession]"
            UpdateCommand="UPDATE [tbl_master_profession] SET [pro_professionName] = @pro_professionName ,[LastModifyDate]=getdate(),[LastModifyUser]= @CreateUser WHERE [pro_id] = @original_pro_id">
            <DeleteParameters>
                <asp:Parameter Name="original_pro_id" Type="Decimal" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="pro_professionName" Type="String" />
                <asp:SessionParameter Name="CreateUser" Type="Decimal" SessionField="userid" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="pro_professionName" Type="String" />
                <asp:SessionParameter Name="CreateUser" Type="Decimal" SessionField="userid" />
            </InsertParameters>
        </asp:SqlDataSource>--%>
    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>
    <br />
</asp:Content>
