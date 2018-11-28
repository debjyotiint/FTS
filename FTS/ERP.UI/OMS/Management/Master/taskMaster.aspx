﻿<%@ Page Language="C#" Title="Task Master" AutoEventWireup="true" MasterPageFile="~/OMS/MasterPage/ERP.Master" CodeBehind="taskMaster.aspx.cs" Inherits="ERP.OMS.Management.Master.taskMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
      <style>
        /*.chosen-container.chosen-container-multi,
        .chosen-container.chosen-container-single {
            width:100% !important;
        }
        .chosen-choices {
            width:100% !important;
        }
       #ListBoxActivityType {
            width:200px;
        }
        .hide {
            display:none;
        }
        .dxtc-activeTab .dxtc-link  {
            color:#fff !important;
        }*/
    </style>
    <script type="text/javascript">
    /*$(document).ready(function () {
        BindActivityType();
    });

    function BindActivityType() {
        var lBox = $('select[id$=ListBoxActivityType]');
        var listItems = [];

        lBox.empty();
        $.ajax({
            type: "POST",
            url: 'taskMaster.aspx/GetActivityTypeList',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var list = msg.d;
                if (list.length > 0) {
                    for (var i = 0; i < list.length; i++) {
                        var id = '';
                        var name = '';
                        id = list[i].split('|')[1];
                        name = list[i].split('|')[0];
                        listItems.push('<option value="' +
                        id + '">' + name
                        + '</option>');
                    }
                    $(lBox).append(listItems.join(''));
                    ListActivityType();
                    $('#ListBoxActivityType').trigger("chosen:updated");
                    $('#ListBoxActivityType').prop('disabled', false).trigger("chosen:updated");
                }
                else {
                    lBox.empty();
                    $('#ListBoxActivityType').trigger("chosen:updated");
                    $('#ListBoxActivityType').prop('disabled', true).trigger("chosen:updated");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log(textStatus);
            }
        });
    }

    function ListActivityType() {
        $('#ListBoxActivityType').chosen();
        $('#ListBoxActivityType').fadeIn();
        var config = {
            '.chsnProduct': {},
            '.chsnProduct-deselect': { allow_single_deselect: true },
            '.chsnProduct-no-single': { disable_search_threshold: 10 },
            '.chsnProduct-no-results': { no_results_text: 'Oops, nothing found!' },
            '.chsnProduct-width': { width: "100%" }
        }
        for (var selector in config) {
            $(selector).chosen(config[selector]);
        }
    }*/
        function LastCall() {
            if (grid.cpErrorMsg != null) {
                jAlert(grid.cpErrorMsg);
                grid.cpErrorMsg = null;
            }
        }

        function checkBoxList_Init()
        {
            ccheckBoxList_callBack.PerformCallback('');
           
        }
        function OnUpdateClick(editor) {
            if (ASPxClientEdit.ValidateGroup("editForm"))
                grid.UpdateEdit();
        }
    </script>
    <style>
        .dxeErrorFrameSys.dxeErrorCellSys {
            position:absolute;
        }
        
        .dxgvControl_PlasticBlue a.btn {
            color:#fff !important;
        }
        .dxbButton_PlasticBlue  div.dxb {
            padding:0px;
        }
    </style>
</asp:Content>

<asp:content id="Content2" contentplaceholderid="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Task Master</h3>
        </div>
    </div>
    <div class="form_main">
        <table class="TableMain100">
            <tr>
                <td>
                    <div class="SearchArea">
                        <div class="FilterSide pull-left">
                            <% if (rights.CanAdd) { %>
                            <a href="javascript:void(0);" onclick="grid.AddNewRow();" class="btn btn-primary"><span style="color: white;">Add New</span></a>
                            <% } %>
                           <% if (rights.CanExport)
                                               { %>
                             <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary" OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Value="0">Export to</asp:ListItem>
                                <asp:ListItem Value="1">PDF</asp:ListItem>
                                <asp:ListItem Value="2">XLS</asp:ListItem>
                                <asp:ListItem Value="3">RTF</asp:ListItem>
                                <asp:ListItem Value="4">CSV</asp:ListItem>
                            </asp:DropDownList>
                              <% } %>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>

                    <dxe:ASPxGridView ID="TaskGridView" runat="server" ClientInstanceName="grid" Width="100%" AutoGenerateColumns="False" DataSourceID="TaskDataSrc" KeyFieldName="task_id" OnRowInserting="TaskGridView_RowInserting" OnRowUpdating="TaskGridView_RowUpdating" OnStartRowEditing="TaskGridView_StartRowEditing" OnRowDeleting="TaskGridView_RowDeleting">
                        <SettingsPager NumericButtonCount="15" PageSize="50" ShowSeparators="True">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                            <PageSizeItemSettings Items="50, 100, 150, 200" Visible="True">
                            </PageSizeItemSettings>
                        </SettingsPager>
                        <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="1"></SettingsEditing>

                        <Settings ShowFilterRow="True" ShowFilterRowMenu="True" ShowGroupPanel="True" ShowStatusBar="Visible" />
                        <SettingsBehavior ColumnResizeMode="NextColumn" ConfirmDelete="True" />
                        <SettingsCommandButton>
                            <UpdateButton ButtonType="Button" Text="Save">
                                <Styles>
                                    <Style CssClass="btn btn-primary">
                                    </Style>
                                </Styles>
                            </UpdateButton>
                            <CancelButton ButtonType="Button" Text="Cancel">
                                <Styles>
                                    <Style CssClass="btn btn-danger">
                                    </Style>
                                </Styles>
                            </CancelButton>
                            <EditButton ButtonType="Image" Styles-Style-CssClass="pad">
                                <Image AlternateText="Edit" Url="../../../assests/images/Edit.png">
                                </Image>
                            </EditButton>
                            <DeleteButton ButtonType="Image" Styles-Style-CssClass="pad">
                                <Image Url="../../../assests/images/Delete.png">
                                </Image>
                            </DeleteButton>
                        </SettingsCommandButton>
                        <SettingsPopup>
                            <EditForm Width="350px"  HorizontalAlign="Center" VerticalAlign="WindowCenter" />
                        </SettingsPopup>
                        <SettingsSearchPanel Visible="True" />
                        <SettingsText ConfirmDelete="Confirm delete ?" PopupEditFormCaption="Add/Modify Task Details" />

                        <Columns>
                            <dxe:GridViewDataTextColumn FieldName="task_title" VisibleIndex="0" Caption="Task Title">
                                <PropertiesTextEdit>
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right" SetFocusOnError="True">
                                        <RequiredField ErrorText="Mandatory." IsRequired="True" />
                                    </ValidationSettings>
                                </PropertiesTextEdit>
                                <EditFormSettings Caption="Title" Visible="True" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn FieldName="task_id" ReadOnly="True" VisibleIndex="1" Visible="False">
                                <EditFormSettings Visible="False" />
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataColumn FieldName="chk_actvt" ReadOnly="True" VisibleIndex="2" Visible="False">
                                <EditFormSettings Caption="Activities" Visible="True" />
                            </dxe:GridViewDataColumn>

                            <dxe:GridViewCommandColumn Caption="Actions" VisibleIndex="5" ShowEditButton="true" ShowDeleteButton="true" Width="108px">
                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                <HeaderTemplate>
                                    Actions
                                </HeaderTemplate>
                                <CellStyle HorizontalAlign="Center"></CellStyle>
                            </dxe:GridViewCommandColumn>
                        </Columns>

                        <Templates>
                            <EditForm>
                                <div class="">
                                    <div class="col-md-12">
                                        <label style="margin-top: 18px;">Task Title<span style="font-size: 7.5pt; color: red"><strong>*</strong></span></label>
                                        <div>
                                            <dxe:ASPxTextBox ID="ASPxTextBox1" Text='<%#Bind("task_title") %>' runat="server" Width="100%" MaxLength="255">
                                              <%--  <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right" SetFocusOnError="True">
                                                    <RequiredField ErrorText="Mandatory." IsRequired="True" />
                                                </ValidationSettings>--%>
                                                
                                                 <ValidationSettings ValidationGroup="editForm" ErrorDisplayMode="ImageWithTooltip" ErrorTextPosition="Right">
                                                  <RequiredField IsRequired="True" ErrorText="Mandatory." />
                                                 </ValidationSettings>
                                            </dxe:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-md-12 datalis">
                                        <div>
                                            <dxe:ASPxCallbackPanel runat="server" id="checkBoxList_callBack" ClientInstanceName="ccheckBoxList_callBack" OnCallback="checkBoxList_Callback">
                                                  <PanelCollection>
                                                       <dxe:PanelContent runat="server">
                                                            <dxe:ASPxCheckBoxList id="checkBoxList" onCallBack="" ClientInstanceName="CcheckBoxList" runat="server" datasourceid="SqlDataSrcActivity"
                                                                        valuefield="aty_id" textfield="aty_activityType" repeatcolumns="4" repeatlayout="Table" caption="Select Required Activities">
                                                                        <CaptionSettings Position="Top" /> 
                                                             </dxe:ASPxCheckBoxList>
                                                      </dxe:PanelContent>
                                                  </PanelCollection>
                                                <ClientSideEvents Init="checkBoxList_Init" />
                                                </dxe:ASPxCallbackPanel>
                                        </div>
                                    </div>
                                    <div class="clear"></div>
                                    <div class="col-md-12" style="margin-top:15px;margin-bottom:25px;">
                                        <a href="javascript:void(0);" onclick="OnUpdateClick(this)" class="btn btn-primary">Save</a>
                                           <%-- <dxe:aspxgridviewtemplatereplacement id="btnUpdate" runat="server" replacementtype="EditFormUpdateButton"></dxe:aspxgridviewtemplatereplacement>--%>
                                            <dxe:aspxgridviewtemplatereplacement id="btnCancel" runat="server" replacementtype="EditFormCancelButton"></dxe:aspxgridviewtemplatereplacement>
                                    </div>
                                  
                                </div>
                                
                            </EditForm>
                        </Templates>

                        <%--<EditFormLayoutProperties ColCount="1">
                            <Items>
                                <dxe:GridViewColumnLayoutItem ColumnName="task_title">
                                </dxe:GridViewColumnLayoutItem>
                                <dxe:GridViewColumnLayoutItem ColumnName="chk_actvt">
                                    <Template>
                                        <dxe:ASPxCheckBoxList  id="checkBoxList" runat="server" datasourceid="SqlDataSrcActivity"
                                            valuefield="aty_id" textfield="aty_activityType" repeatcolumns="4" repeatlayout="Table" caption="Select Required Activities">
                                            <CaptionSettings Position="Top" />
                                        </dxe:ASPxCheckBoxList>
                                    </Template>
                                </dxe:GridViewColumnLayoutItem>
                                <dxe:EditModeCommandLayoutItem ColSpan="1" />
                            </Items>
                        </EditFormLayoutProperties>--%>
                          <clientsideevents endcallback="function(s, e) {	LastCall( );}" />
                    </dxe:ASPxGridView>

                </td>
            </tr>
        </table>
    </div>
    <asp:SqlDataSource ID="TaskDataSrc" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>"
        InsertCommand="SELECT NULL"
        SelectCommand="SELECT task_title, task_id FROM tbl_master_task"  
        UpdateCommand="SELECT NULL" 
        DeleteCommand="SELECT NULL">
        <DeleteParameters>
            <asp:Parameter Name="task_id" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="task_id" />
            <asp:Parameter Name="task_title" />
            <asp:Parameter Name="task_description" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSrcActivity" runat="server" ConnectionString="<%$ ConnectionStrings:crmConnectionString %>" 
        SelectCommand="sp_Sales" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:Parameter DefaultValue="GetActivityTypeList" Name="Mode" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>
</asp:content>


