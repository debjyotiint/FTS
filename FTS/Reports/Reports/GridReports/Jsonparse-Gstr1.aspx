<%@ Page Title="JSON Parse GSTR1" Language="C#" MasterPageFile="~/OMS/MasterPage/ERP.Master" AutoEventWireup="true"
    CodeBehind="Jsonparse-Gstr1.aspx.cs" Inherits="Reports.Reports.GridReports.Jsonparse_Gstr1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>

        function Callback_BeginCallback() {


            $("#drdExport").val(0);

        }


        function OpenPOSDetails(invoice, type) {

            
            popupjsonrconcile.SetContentUrl('');

            if (type == 'POS') {

                url = '/OMS/Management/Activities/posSalesInvoice.aspx?key=' + invoice + '&IsTagged=1&Viemode=1';

                popupjsonrconcile.SetContentUrl(url);
                popupjsonrconcile.Show();


            }
            if (type == 'SI') {

                url = '/OMS/Management/Activities/SalesInvoice.aspx?key=' + invoice + '&IsTagged=1&req=V&type=' + type;

                popupjsonrconcile.SetContentUrl(url);
                popupjsonrconcile.Show();


            }
            
           

        }

        function checkFileSize(element) {
            var val = $(element).val(); //get file value

            var ext = val.substring(val.lastIndexOf('.') + 1).toLowerCase(); // get file extention 
            // alert(ext);
            if (ext == "json") {

            }

            else {
                jAlert('Only Json file to be allowed');
                $(element).val('');

            }


        }
        function JsonHide(s, e) {
            popupjsonrconcile.Hide();
        }

        function Callback_BeginCallbacks() {
            $("#drdExport").val(0);

            return true;
        }


        $(document).ready(function () {
            $('#btn_Conversion').click(function () {
                if ($("#<%= fileuploadjson.ClientID %>").val() == "") {
                    $("#error").html("File is required");

                    return false;
                }

                return true;
            });

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="panel-heading">
        <div class="panel-title clearfix">
            <h3 class="pull-left">GSTR-1 Reconciliation [With JSON]</h3>
        </div>
    </div>
    <div id="pageheaderContent">
        <div>
            <h4>JSON File</h4>

            <asp:FileUpload ID="fileuploadjson" runat="server" accept=".json" onchange="checkFileSize(this)" />
        </div>
        <br />
        <asp:Button ID="btn_Conversion" runat="server" Text="Reconcile" OnClick="Button_Click" CssClass="btn btn-sm btn-primary" OnClientClick="return Callback_BeginCallbacks()" />
        <%--   <% if (rights.CanExport)
                                               { %>--%>
        <asp:DropDownList ID="drdExport" runat="server" CssClass="btn btn-sm btn-primary"
            OnSelectedIndexChanged="cmbExport_SelectedIndexChanged" AutoPostBack="true">
            <asp:ListItem Value="0">Export to</asp:ListItem>
            <asp:ListItem Value="1">PDF</asp:ListItem>
            <asp:ListItem Value="2">XLSX</asp:ListItem>
            <asp:ListItem Value="3">RTF</asp:ListItem>
            <asp:ListItem Value="4">CSV</asp:ListItem>

        </asp:DropDownList>
             <%--     <% } %>--%>


        <dxe:ASPxGridView runat="server" ID="ShowGrid" ClientInstanceName="Grid" Width="100%" EnableRowsCache="false" AutoGenerateColumns="false"
            Settings-HorizontalScrollBarMode="Auto" OnDataBinding="grid_DataBinding"  OnSummaryDisplayText="ShowGrid_SummaryDisplayText"
            ClientSideEvents-BeginCallback="Callback_BeginCallback">


            <Columns>
          <%--      <dxe:GridViewDataTextColumn FieldName="idt" Caption="Invoice Date" VisibleIndex="1" Width="200px">
                </dxe:GridViewDataTextColumn>


                <dxe:GridViewDataTextColumn FieldName="inum" Caption="Invoice Number" VisibleIndex="2" Width="130px">
                </dxe:GridViewDataTextColumn>--%>


                    <dxe:GridViewDataTextColumn VisibleIndex="1" FieldName="Bill Number" Width="200px" Caption="Invoice No.">
                    <CellStyle>
                    </CellStyle>
                    <HeaderStyle/>
                    <DataItemTemplate>

                        <a href="javascript:void(0)" target="_blank" onclick="OpenPOSDetails('<%#Eval("Invoice_Id") %>','<%#Eval("type") %>')">
                            <%#Eval("Bill Number")%>
                        </a>
                    </DataItemTemplate>

                    <EditFormSettings Visible="False" />
                </dxe:GridViewDataTextColumn>


                <dxe:GridViewDataTextColumn FieldName="Bill Date" Caption="Invoice Date" VisibleIndex="2" Width="150px">
                </dxe:GridViewDataTextColumn>

                <dxe:GridViewDataTextColumn FieldName="txval" Caption="Taxable Amount" VisibleIndex="3" Width="100px" PropertiesTextEdit-DisplayFormatString="0.00">
                </dxe:GridViewDataTextColumn>

                <dxe:GridViewDataTextColumn FieldName="rt" Caption="Rate" VisibleIndex="4" Width="100px" PropertiesTextEdit-DisplayFormatString="0.00" HeaderStyle-HorizontalAlign="Center" CellStyle-VerticalAlign="Middle" CellStyle-HorizontalAlign="Center">
                </dxe:GridViewDataTextColumn>




                <dxe:GridViewDataTextColumn FieldName="val" Caption="Total Amount" VisibleIndex="8" Width="100px" PropertiesTextEdit-DisplayFormatString="0.00">
                </dxe:GridViewDataTextColumn>

                <dxe:GridViewDataTextColumn FieldName="rchrg" Caption="Reverse Charge" VisibleIndex="9" Width="100px"  HeaderStyle-HorizontalAlign="Center" CellStyle-VerticalAlign="Middle" CellStyle-HorizontalAlign="Center">
                </dxe:GridViewDataTextColumn>




                <%--    <dxe:GridViewDataTextColumn FieldName="Bill Number" Caption="Our Invoice No." VisibleIndex="11" Width="20%">
                </dxe:GridViewDataTextColumn>--%>


            


                <dxe:GridViewDataTextColumn FieldName="Name" Caption="Party Name" VisibleIndex="13" Width="300px">
                </dxe:GridViewDataTextColumn>
                <dxe:GridViewDataTextColumn FieldName="Partytype" Caption="Party Type" VisibleIndex="14" Width="100px"  HeaderStyle-HorizontalAlign="Center" CellStyle-VerticalAlign="Middle" CellStyle-HorizontalAlign="Center">
                </dxe:GridViewDataTextColumn>


                <dxe:GridViewDataTextColumn FieldName="CNT_GSTIN" Caption="GSTIN" VisibleIndex="15" Width="200px">
                </dxe:GridViewDataTextColumn>



                 <dxe:GridViewDataTextColumn FieldName="BranchCompanyGSTIN" Caption="Branch GSTIN" VisibleIndex="16" Width="200px">
                </dxe:GridViewDataTextColumn>



                <dxe:GridViewDataTextColumn FieldName="excess" Caption="Difference" VisibleIndex="17" Width="100px" PropertiesTextEdit-DisplayFormatString="0.00">
                </dxe:GridViewDataTextColumn>

                <dxe:GridViewDataTextColumn FieldName="Data status" Caption="Matched?" VisibleIndex="18" Width="100px"  HeaderStyle-HorizontalAlign="Center" CellStyle-VerticalAlign="Middle" CellStyle-HorizontalAlign="Center">
                </dxe:GridViewDataTextColumn>


                
                <dxe:GridViewDataTextColumn FieldName="Reason" Caption="Reason" VisibleIndex="19" Width="100px"  HeaderStyle-HorizontalAlign="Center" CellStyle-VerticalAlign="Middle" CellStyle-HorizontalAlign="Center">
                </dxe:GridViewDataTextColumn>


            </Columns>

            <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" EnableRowHotTrack="true" ColumnResizeMode="Control" />
            <Settings ShowFooter="true" ShowGroupPanel="true" ShowGroupFooter="VisibleIfExpanded" />
            <SettingsEditing Mode="EditForm" />
            <SettingsContextMenu Enabled="true" />
            <SettingsBehavior AutoExpandAllGroups="true" />
            <Settings ShowGroupPanel="True" ShowStatusBar="Visible" ShowFilterRow="true" />
            <SettingsSearchPanel Visible="false" />
            <SettingsPager PageSize="10">
                <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
            </SettingsPager>
            <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
            <TotalSummary>
                <dxe:ASPxSummaryItem FieldName="txval" SummaryType="Sum" />
                <dxe:ASPxSummaryItem FieldName="val" SummaryType="Sum" />
              
             
            </TotalSummary>

        </dxe:ASPxGridView>

    </div>


    <dxe:ASPxGridViewExporter ID="exporter" runat="server" Landscape="false" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
    </dxe:ASPxGridViewExporter>


    <dxe:ASPxPopupControl ID="ASPXPopupControl2" runat="server"
        CloseAction="CloseButton" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="popupjsonrconcile" Height="500px"
        Width="1200px" HeaderText="Details" Modal="true" AllowResize="true" ResizingMode="Postponed">
        <ContentCollection>
            <dxe:PopupControlContentControl runat="server">
            </dxe:PopupControlContentControl>
        </ContentCollection>

        <ClientSideEvents CloseUp="JsonHide" />
    </dxe:ASPxPopupControl>
</asp:Content>
