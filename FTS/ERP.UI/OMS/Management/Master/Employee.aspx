<%@ Page Title="Employee" Language="C#" AutoEventWireup="True" Inherits="ERP.OMS.Management.Master.management_master_Employee" CodeBehind="Employee.aspx.cs" MasterPageFile="~/OMS/MasterPage/ERP.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">

        function Pageload() {

            document.getElementById('td1').style.display = "inline";
            document.getElementById('td1').style.display = "tablee-cell";
            document.getElementById('td2').style.display = "inline";
            document.getElementById('td2').style.display = "table-cell";
            document.getElementById('td3').style.display = "inline";
            document.getElementById('td3').style.display = "table-cell";
            document.getElementById('td4').style.display = "inline";
            document.getElementById('td4').style.display = "table-cell";
            HideTrTd("Tr_EmployeeName");
            HideTrTd("Tr_EmployeeCode");

            cGrdEmployee.PerformCallback("Show~~~");
        }
        function PerformCallToGridBind() {
            var EmpId=document.getElementById('hdnContactId').value;
            cSelectPanel.PerformCallback('SaveDetails~' + EmpId);
            cActivationPopup.Hide();
            return false;
        }

        function SelectPanel_EndCallBack(s,e)
        {
            if (cSelectPanel.cpResult == "Success") {
                jAlert('Employee Updated Sucessfully');
            }
            else if (cSelectPanel.cpResult == "Problem") {
                jAlert('Some Problem Occur. Please Try Again Later');
            }
            else {
                
            }
        }


        function OnChangeSuperVisor() {
          
            cActivationPopupsupervisor.Show();
           
        }
        function OnserverCallSupervisorchanged() {
            var otherDetails = {};
            otherDetails.fromsuper = $("#fromsuper").val();
            otherDetails.tosuper = $("#tosupervisor").val();

            //{ 'fromsuper': $("#fromsuper").val(), 'tosuper': $("#tosupervisor").val() }

            $.ajax({
                type: "POST",
                url: "Employee.aspx/Submitsupervisor",
                data: JSON.stringify(otherDetails),
                contentType: "application/json; charset=utf-8",
                datatype: "json",
                success: function (responseFromServer) {
                  //  alert(responseFromServer.d)
                    cGrdEmployee.PerformCallback("Show~~~");
                    jAlert('Supervisor Changed Successfully.');
                    cActivationPopupsupervisor.Hide();
                }
            });

        }



        var GlobalCheckOption='';
        function ActivateDeactivateTxtReason(s, e) {
         
        var value = s.GetChecked();





        if (GlobalCheckOption == "") {
            if (value) {
                GlobalCheckOption = false;
            }
            else {
                GlobalCheckOption = true;
            }
            alert(value);
        }


        if (GlobalCheckOption != value)
        {
            $("#btnOK").attr("disabled", false);
        }else
        {
            $("#btnOK").attr("disabled", true);
        }

        }


        function fn_DeleteEmp(keyValue) {
            //var result=confirm('Confirm delete?');
            //if(result)
            //{
            //    grid.PerformCallback('Delete~' + keyValue);
            //}

            if (keyValue != "EMV0000001") {
                jConfirm('Confirm delete?', 'Confirmation Dialog', function (r) {
                    if (r == true) {
                        cGrdEmployee.PerformCallback('Delete~' + keyValue);
                    }
                    else {
                        return false;
                    }
                });
            } else {
                jAlert("Sorry, you can not delete the Admin.");
            }


        }

        function fn_DeActivateEmp(keyValue) {

            

            if (keyValue) {

                cSelectPanel.PerformCallback('Bindalldesignes~' + keyValue)
            }
            cActivationPopup.Show();
            document.getElementById('hdnContactId').value = keyValue;

        }


        function ShowTrTd(obj) {
            document.getElementById(obj).style.display = 'inline';
        }
        function HideTrTd(obj) {
            //document.getElementById(obj).style.display = 'none';
        }

        function OnMoreInfoClick(keyValue) {

            if (keyValue != '') {
                var url = 'employee_general.aspx?id=' + keyValue;
                //parent.OnMoreInfoClick(url, "Modify Employee Details", '980px', '500px', "Y");
                window.location.href = url;
            }
        }
        function OnAddButtonClick() {
            var url = 'Employee_AddNew.aspx?id=' + 'ADD';
            //parent.OnMoreInfoClick(url,"Add Employee Details",'980px','400px',"Y");
            window.location.href = url;
        }
        function OnAddBusinessClick(keyValue, CompName) {
            var url = 'AssignIndustry.aspx?id1=' + keyValue + '&EntType=Employee';
            window.location.href = url;
        }
        function OnLeftNav_Click() {
            var i = document.getElementById("A1").innerText;
            document.getElementById("hdn_GridBindOrNotBind").value = "False"; //To Stop Bind On Page Load
            if (parseInt(i) > 1) {
                if (crbDOJ_Specific_All.GetValue() == "S")
                    cGrdEmployee.PerformCallback("SearchByNavigation~" + cDtFrom.GetValue() + '~' + cDtTo.GetValue() + "~" + document.getElementById("A1").innerText + "~LeftNav");
                else
                    cGrdEmployee.PerformCallback("SearchByNavigation~~~" + document.getElementById("A1").innerText + "~LeftNav");
            }
            else {
                alert('No More Pages.');
            }
        }
        function OnRightNav_Click() {
            var TestEnd = document.getElementById("A10").innerText;
            document.getElementById("hdn_GridBindOrNotBind").value = "False"; //To Stop Bind On Page Load
            var TotalPage = document.getElementById("B_TotalPage").innerText;
            if (TestEnd == "" || TestEnd == TotalPage) {
                alert('No More Records.');
                return;
            }
            var i = document.getElementById("A1").innerText;
            if (parseInt(i) < TotalPage) {
                if (crbDOJ_Specific_All.GetValue() == "S")
                    cGrdEmployee.PerformCallback("SearchByNavigation~" + cDtFrom.GetValue() + '~' + cDtTo.GetValue() + "~" + document.getElementById("A1").innerText + "~RightNav");
                else
                    cGrdEmployee.PerformCallback("SearchByNavigation~~~" + document.getElementById("A1").innerText + "~RightNav");
            }
            else {
                alert('You are at the End');
            }
        }
        function OnPageNo_Click(obj) {
            var i = document.getElementById(obj).innerText;
            document.getElementById("hdn_GridBindOrNotBind").value = "False"; //To Stop Bind On Page Load
            if (crbDOJ_Specific_All.GetValue() == "S")
                cGrdEmployee.PerformCallback("SearchByNavigation~" + cDtFrom.GetValue() + '~' + cDtTo.GetValue() + "~" + i + "~PageNav");
            else
                cGrdEmployee.PerformCallback("SearchByNavigation~~~" + i + "~PageNav");

        }
        function BtnShow_Click() {
            document.getElementById("hdn_GridBindOrNotBind").value = "False"; //To Stop Bind On Page Load
            if (crbDOJ_Specific_All.GetValue() == "S") {

                cGrdEmployee.PerformCallback("Show~" + cDtFrom.GetValue() + '~' + cDtTo.GetValue());
            }
            else {

                cGrdEmployee.PerformCallback("Show~~~");
            }
        }

        function GrdEmployee_EndCallBack() {
            if (cGrdEmployee.cpExcelExport != undefined) {
                document.getElementById('BtnForExportEvent').click();
            }
            if (cGrdEmployee.cpRefreshNavPanel != undefined) {
                document.getElementById("B_PageNo").innerText = '';
                document.getElementById("B_TotalPage").innerText = '';
                document.getElementById("B_TotalRows").innerText = '';

                var NavDirection = cGrdEmployee.cpRefreshNavPanel.split('~')[0];
                var PageNum = cGrdEmployee.cpRefreshNavPanel.split('~')[1];
                var TotalPage = cGrdEmployee.cpRefreshNavPanel.split('~')[2];
                var TotalRows = cGrdEmployee.cpRefreshNavPanel.split('~')[3];

                if (NavDirection == "RightNav") {
                    PageNum = parseInt(PageNum) + 10;
                    document.getElementById("B_PageNo").innerText = PageNum;
                    document.getElementById("B_TotalPage").innerText = TotalPage;
                    document.getElementById("B_TotalRows").innerText = TotalRows;
                    var n = parseInt(TotalPage) - parseInt(PageNum) > 10 ? parseInt(11) : parseInt(TotalPage) - parseInt(PageNum) + 2;
                    for (r = 1; r < n; r++) {
                        var obj = "A" + r;
                        document.getElementById(obj).innerText = PageNum++;
                    }
                    for (r = n; r < 11; r++) {
                        var obj = "A" + r;
                        document.getElementById(obj).innerText = "";
                    }
                }
                if (NavDirection == "LeftNav") {
                    if (parseInt(PageNum) > 1) {
                        PageNum = parseInt(PageNum) - 10;
                        document.getElementById("B_PageNo").innerText = PageNum;
                        document.getElementById("B_TotalPage").innerText = TotalPage;
                        document.getElementById("B_TotalRows").innerText = TotalRows;
                        for (l = 1; l < 11; l++) {
                            var obj = "A" + l;
                            document.getElementById(obj).innerText = PageNum++;
                        }
                    }
                    else {
                        alert('No More Pages.');
                    }
                }
                if (NavDirection == "PageNav") {
                    document.getElementById("B_PageNo").innerText = PageNum;
                    document.getElementById("B_TotalPage").innerText = TotalPage;
                    document.getElementById("B_TotalRows").innerText = TotalRows;
                }
                if (NavDirection == "ShowBtnClick") {
                    document.getElementById("B_PageNo").innerText = PageNum;
                    document.getElementById("B_TotalPage").innerText = TotalPage;
                    document.getElementById("B_TotalRows").innerText = TotalRows;
                    var n = parseInt(TotalPage) - parseInt(PageNum) > 10 ? parseInt(11) : parseInt(TotalPage) - parseInt(PageNum) + 2;

                    for (r = 1; r < n; r++) {
                        var obj = "A" + r;
                        document.getElementById(obj).innerText = PageNum++;
                    }

                    for (r = n; r < 11; r++) {
                        var obj = "A" + r;
                        document.getElementById(obj).innerText = "";
                    }

                }
            }
            if (cGrdEmployee.cpCallOtherWhichCallCondition != undefined) {
                if (cGrdEmployee.cpCallOtherWhichCallCondition == "Show") {
                    if (crbDOJ_Specific_All.GetValue() == "S")
                        cGrdEmployee.PerformCallback("Show~" + cDtFrom.GetValue() + '~' + cDtTo.GetValue());
                    else
                        cGrdEmployee.PerformCallback("Show~~~");
                }
            }
            //Now Reset GridBindOrNotBind to True for Next Page Load
            document.getElementById("hdn_GridBindOrNotBind").value = "True";
            //height();
            if (cGrdEmployee.cpDelete != null) {
                if (cGrdEmployee.cpDelete == 'Success')
                    jAlert('Record deleted successfully');
                else
                    jAlert('Error on deletio/n Please Try again!!')
            }
        }
        function selecttion() {
            var combo = document.getElementById('cmbExport');
            combo.value = 'Ex';
        }

        function OnContactInfoClick(keyValue, CompName) {
            var url = 'insurance_contactPerson.aspx?id=' + keyValue;
            // OnMoreInfoClick(url, "Employee Name : " + CompName + "", '980px', '550px', "Y");
            window.location.href = url;
        }
        function Callheight() {
            //height();
        }

        function ShowEmployeeFilterForm(obj) {
            if (obj == 'A') {
                document.getElementById('td1').style.display = "none";
                document.getElementById('td2').style.display = "none";
                document.getElementById('td3').style.display = "none";
                document.getElementById('td4').style.display = "none";
            }
            if (obj == 'S') {

                document.getElementById('td1').style.display = "inline";
                document.getElementById('td1').style.display = "table-cell";

                document.getElementById('td2').style.display = "inline";
                document.getElementById('td2').style.display = "table-cell";

                document.getElementById('td3').style.display = "inline";
                document.getElementById('td3').style.display = "table-cell";

                document.getElementById('td4').style.display = "inline";
                document.getElementById('td4').style.display = "table-cell";
            }

        }
        function ShowFindOption() {
            if (cRb_SearchBy.GetValue() == "N") {
                HideTrTd("Tr_EmployeeName")
                HideTrTd("Tr_EmployeeCode")
            }
            else if (cRb_SearchBy.GetValue() == "EN") {
                ShowTrTd("Tr_EmployeeName")
                HideTrTd("Tr_EmployeeCode")
            }
            else if (cRb_SearchBy.GetValue() == "EC") {
                HideTrTd("Tr_EmployeeName")
                ShowTrTd("Tr_EmployeeCode")
            }
        }
      <%--  function ddlExport_OnChange() {
            var ddlExport = document.getElementById("<%=ddlExport.ClientID%>");
            if (crbDOJ_Specific_All.GetValue() == "S")
                cGrdEmployee.PerformCallback("ExcelExport~" + cDtFrom.GetValue() + '~' + cDtTo.GetValue());
            else
                cGrdEmployee.PerformCallback("ExcelExport~~~");
            ddlExport.options[0].selected = true;
        }--%>

        function ShowHideFilter(obj) {
            document.getElementById("hdn_GridBindOrNotBind").value = "False"; //To Stop Bind On Page Load
            cGrdEmployee.PerformCallback("ShowHideFilter~" + cDtFrom.GetValue() + '~' + cDtTo.GetValue() + '~' + obj);
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel-heading">
        <div class="panel-title">
            <h3>Employees</h3>
        </div>
    </div>
    <div class="form_main">
        <table class="TableMain100">
            <%--            <tr>
                <td class="EHEADER" style="text-align: center; height: 20px;">
                    <strong><span style="color: #000099">Employee Details</span></strong></td>
            </tr>--%>

            <tr>
                <td style="text-align: left; vertical-align: top">
                    <table>
                        <tr>
                            <td id="ShowFilter">
                                <% if (rights.CanAdd)
                                   { %>
                                <a href="javascript:void(0);" onclick="OnAddButtonClick()" class="btn btn-primary"><span>Add New</span> </a>
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

                                    <% if (rights.CanExport)
                                   { %>
                                 <a href="javascript:void(0);" onclick="OnChangeSuperVisor()" class="btn btn-primary"><span>Change Supervisor</span> </a>
                                <% } %>


                            </td>
                            <td id="Td1"></td>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="display: none">
                <td>
                    <div style="padding: 15px; background: #f9f9f9; border-radius: 3px; margin-bottom: 12px;">
                        <table cellpadding="1" cellspacing="1" style="display: none">
                            <tr id="trSpecific">
                                <td class="gridcellleft" style="vertical-align: top">Date Of Joining :</td>
                                <td valign="top" style="vertical-align: top">
                                    <dxe:ASPxRadioButtonList ID="rbDOJ_Specific_All" runat="server" SelectedIndex="0" ItemSpacing="10px"
                                        ClientInstanceName="crbDOJ_Specific_All" RepeatDirection="Horizontal" TextWrap="False">
                                        <Items>

                                            <dxe:ListEditItem Text="Specific" Value="S" />
                                            <dxe:ListEditItem Text="All" Value="A" />
                                        </Items>
                                        <ClientSideEvents ValueChanged="function(s, e) {ShowEmployeeFilterForm(s.GetValue());}" />
                                        <Border BorderWidth="0px" />
                                    </dxe:ASPxRadioButtonList>
                                </td>
                                <td align="right" valign="middle" id="td1" class="gridcellleft" style="vertical-align: top">&nbsp;From :</td>
                                <td valign="middle" class="gridcellleft" id="td2" style="vertical-align: top">
                                    <dxe:ASPxDateEdit ID="DtFrom" ClientInstanceName="cDtFrom" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" UseMaskBehavior="True">
                                        <ButtonStyle Width="13px"></ButtonStyle>
                                    </dxe:ASPxDateEdit>
                                </td>
                                <td valign="middle" align="right" id="td3" class="gridcellleft" style="vertical-align: top">To:</td>
                                <td valign="middle" class="gridcellleft" id="td4" style="vertical-align: top">
                                    <dxe:ASPxDateEdit ID="DtTo" ClientInstanceName="cDtTo" runat="server" EditFormat="Custom" EditFormatString="dd-MM-yyyy" UseMaskBehavior="True">
                                        <ButtonStyle Width="13px"></ButtonStyle>
                                    </dxe:ASPxDateEdit>
                                </td>
                            </tr>
                            <tr>
                                <td class="gridcellleft" style="vertical-align: top">Search By :</td>
                                <td style="vertical-align: top" valign="top">
                                    <dxe:ASPxRadioButtonList ID="Rb_SearchBy" runat="server" ItemSpacing="10px" RepeatDirection="Horizontal"
                                        TextWrap="False" ClientInstanceName="cRb_SearchBy" SelectedIndex="0">
                                        <Border BorderWidth="0px" />
                                        <ClientSideEvents ValueChanged="function(s, e) {ShowFindOption();}" />
                                        <Items>
                                            <dxe:ListEditItem Text="None" Value="N"></dxe:ListEditItem>
                                            <dxe:ListEditItem Text="Employee Name" Value="EN"></dxe:ListEditItem>
                                            <dxe:ListEditItem Text="Employee Code" Value="EC"></dxe:ListEditItem>
                                        </Items>
                                    </dxe:ASPxRadioButtonList>
                                </td>
                                <td align="right" class="gridcellleft" style="vertical-align: top"
                                    valign="middle"></td>
                                <td class="gridcellleft" style="vertical-align: top" valign="middle">
                                    <dxe:ASPxButton ID="BtnShow" runat="server" AutoPostBack="False" Text="Show" CssClass="btn btn-primary">
                                        <ClientSideEvents Click="function (s, e) {BtnShow_Click();}" />
                                    </dxe:ASPxButton>
                                </td>
                                <td align="right" class="gridcellleft" style="vertical-align: top"
                                    valign="middle"></td>
                                <td class="gridcellleft" style="vertical-align: top" valign="middle"></td>
                            </tr>
                            <tr id="tr_EmployeeName">
                                <td class="gridcellleft" style="vertical-align: top">Employee Name :</td>
                                <td style="vertical-align: top" valign="top">
                                    <asp:TextBox ID="txtEmpName" onFocus="this.select()" runat="server"></asp:TextBox></td>
                                <td align="right" class="gridcellleft" style="vertical-align: top"
                                    valign="middle">Find Option</td>
                                <td class="gridcellleft" style="vertical-align: top" valign="middle">
                                    <dxe:ASPxComboBox ID="cmbEmpNameFindOption" runat="server"
                                        ClientInstanceName="exp" Font-Bold="False" ForeColor="black"
                                        SelectedIndex="0" ValueType="System.Int32" Width="170px">
                                        <Items>
                                            <dxe:ListEditItem Value="0" Text="Like"></dxe:ListEditItem>
                                            <dxe:ListEditItem Value="1" Text="Whole Word"></dxe:ListEditItem>
                                        </Items>
                                        <ButtonStyle>
                                        </ButtonStyle>
                                        <ItemStyle>
                                            <HoverStyle>
                                            </HoverStyle>
                                        </ItemStyle>
                                        <Border BorderColor="black"></Border>

                                    </dxe:ASPxComboBox>
                                </td>
                                <td align="right" class="gridcellleft" style="vertical-align: top"
                                    valign="middle"></td>
                                <td class="gridcellleft" style="vertical-align: top" valign="middle"></td>
                            </tr>
                            <tr id="tr_EmployeeCode">
                                <td class="gridcellleft" style="vertical-align: top">Employee Code :</td>
                                <td style="vertical-align: top" valign="top">
                                    <asp:TextBox ID="txtEmpCode" onFocus="this.select()" runat="server"></asp:TextBox></td>
                                <td align="right" class="gridcellleft" style="vertical-align: top"
                                    valign="middle">Find Option</td>
                                <td class="gridcellleft" style="vertical-align: top" valign="middle">
                                    <dxe:ASPxComboBox ID="cmbEmpCodeFindOption" runat="server"
                                        ClientInstanceName="exp" Font-Bold="False" ForeColor="black"
                                        SelectedIndex="0" ValueType="System.Int32" Width="170px">
                                        <Items>
                                            <dxe:ListEditItem Value="0" Text="Like"></dxe:ListEditItem>
                                            <dxe:ListEditItem Value="1" Text="Whole Word"></dxe:ListEditItem>
                                        </Items>
                                        <ButtonStyle>
                                        </ButtonStyle>
                                        <ItemStyle>
                                            <HoverStyle>
                                            </HoverStyle>
                                        </ItemStyle>
                                        <Border BorderColor="black"></Border>

                                    </dxe:ASPxComboBox>
                                </td>
                                <td align="right" class="gridcellleft" style="vertical-align: top"
                                    valign="middle"></td>
                                <td class="gridcellleft" style="vertical-align: top" valign="middle"></td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td id="Td5">
                                    <% if (rights.CanAdd)
                                       { %>
                                    <a href="javascript:void(0);" onclick="OnAddButtonClick()" class="btn btn-primary"><span>Add New</span> </a><% } %>
                                    <%-- <a href="javascript:ShowHideFilter('s');"><span style="color: #000099; text-decoration: underline">Show Filter</span></a>--%>
                                </td>
                                <td id="Td6">
                                    <%-- <a href="javascript:ShowHideFilter('All');" class="btn btn-primary"><span>All Records</span></a>--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr style="display: none">
                <td>


                    <table style="width: 100%" border="0">
                        <tr>
                            <td valign="top" style="vertical-align: top; width: 34px; text-align: left">Page </td>
                            <td valign="top" style="width: 4px">
                                <b style="text-align: right" id="B_PageNo" runat="server"></b>
                            </td>
                            <td valign="top" style="vertical-align: top; text-align: left;">Of
                            </td>
                            <td valign="top">
                                <b style="text-align: right" id="B_TotalPage" runat="server"></b>
                            </td>
                            <td valign="top" style="vertical-align: top; text-align: left">( <b style="text-align: right" id="B_TotalRows" runat="server"></b>&nbsp;items )
                            </td>
                            <td valign="top">
                                <table width="100%">
                                    <tr>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A_LeftNav" runat="server" href="javascript:void(0);" onclick="OnLeftNav_Click()">
                                                <img src="/assests/images/LeftNav.gif" width="10" />
                                            </a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A1" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A1')">1</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A2" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A2')">2</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A3" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A3')">3</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A4" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A4')">4</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A5" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A5')">5</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A6" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A6')">6</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A7" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A7')">7</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A8" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A8')">8</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A9" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A9')">9</a>
                                        </td>
                                        <td valign="top" style="vertical-align: top; text-align: left">
                                            <a id="A10" runat="server" href="javascript:void(0);" onclick="OnPageNo_Click('A10')">10</a>
                                        </td>
                                        <td style="text-align: right; vertical-align: top;" valign="top">
                                            <a id="A_RightNav" runat="server" href="javascript:void(0);" onclick="OnRightNav_Click()">
                                                <img src="../images/RightNav.gif" width="10" />
                                            </a>
                                        </td>
                                        <td style="vertical-align: top; text-align: right" valign="top">
                                            <%--<asp:DropDownList ID="ddlExport" Onchange="ddlExport_OnChange()" runat="server"
                                                Width="100px">
                                                <asp:ListItem Selected="True" Value="Ex">Export</asp:ListItem>
                                                <asp:ListItem Value="1">Excel</asp:ListItem>
                                            </asp:DropDownList>--%></td>

                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <dxe:ASPxGridView ID="GrdEmployee" runat="server" KeyFieldName="cnt_id" AutoGenerateColumns="False"
                        Width="100%" ClientInstanceName="cGrdEmployee" OnCustomCallback="GrdEmployee_CustomCallback" SettingsBehavior-AllowFocusedRow="true">
                        <%--<ClientSideEvents EndCallback="function(s, e) {GrdEmployee_EndCallBack();}" />--%>
                        <SettingsBehavior AllowFocusedRow="true" ConfirmDelete="True" ColumnResizeMode="NextColumn" />
                        <Styles>
                            <Header SortingImageSpacing="5px" ImageSpacing="5px">
                            </Header>
                            <LoadingPanel ImageSpacing="10px">
                            </LoadingPanel>
                            <Row Wrap="true">
                            </Row>
                            <%-- <FocusedRow HorizontalAlign="Left" VerticalAlign="Top" ></FocusedRow>
                            <AlternatingRow Enabled="True"></AlternatingRow>--%>
                        </Styles>

                        <Columns>
                            <dxe:GridViewDataTextColumn Caption="Code" Visible="False" FieldName="ContactID"
                                VisibleIndex="0" FixedStyle="Left">
                                <PropertiesTextEdit DisplayFormatInEditMode="True">
                                </PropertiesTextEdit>
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Name" FieldName="Name"
                                VisibleIndex="2" FixedStyle="Left">
                                <CellStyle CssClass="gridcellleft" Wrap="true">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataDateColumn Caption="Joining On" FieldName="DOJ"
                                VisibleIndex="7" Width="100px" ReadOnly="True">
                            </dxe:GridViewDataDateColumn>

                            <dxe:GridViewDataTextColumn Caption="Department" FieldName="Department"
                                VisibleIndex="5" Width="120px">
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Branch" FieldName="BranchName"
                                VisibleIndex="4" Width="75px">
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="CTC" FieldName="CTC"
                                VisibleIndex="6" Width="75px" Visible="false">
                                <CellStyle CssClass="gridcellleft" Wrap="False" HorizontalAlign="Left">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Report To" FieldName="ReportTo"
                                VisibleIndex="8" Width="150px">
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Designation" FieldName="Designation"
                                VisibleIndex="6" Width="150px">
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>
                            <dxe:GridViewDataTextColumn Caption="Company" FieldName="Company"
                                VisibleIndex="3" Width="150px">
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewCommandColumn Visible="False" ShowDeleteButton="true" VisibleIndex="16">
                                <%--<DeleteButton Visible="True" Text="Delete">
                                </DeleteButton>--%>
                            </dxe:GridViewCommandColumn>
                            <dxe:GridViewDataTextColumn HeaderStyle-HorizontalAlign="Center" CellStyle-HorizontalAlign="center" VisibleIndex="17" Width="12%">
                                <DataItemTemplate>
                                    <% if (rights.CanContactPerson)
                                       { %>
                                    <a href="javascript:void(0);" onclick="OnContactInfoClick('<%#Eval("ContactID") %>','<%#Eval("Name") %>')" title="show contact person" class="pad">
                                        <img src="../../../assests/images/show.png" style="padding-right: 8px" />
                                    </a><% } %>
                                    <% if (rights.CanEdit)
                                       { %>
                                    <a href="javascript:void(0);" onclick="OnMoreInfoClick('<%# Container.KeyValue %>')" class="pad" title="More Info">
                                        <img src="../../../assests/images/info.png" /></a><% } %>
                                    <% if (rights.CanIndustry)
                                       { %>
                                    <a href="javascript:void(0);" onclick="OnAddBusinessClick('<%#Eval("ContactID") %>','<%#Eval("Name") %>')" title="Add Industry" class="pad" style="text-decoration: none;">
                                        <img src="../../../assests/images/icoaccts.gif" /><% } %>
                                        <% if (rights.CanDelete)
                                           { %>

                                        <a href="javascript:void(0);" onclick="fn_DeleteEmp('<%#Eval("ContactID") %>')" title="Delete">
                                            <img src="../../../assests/images/Delete.png" /></a>
                                        <% } %>

                                        <% if (rights.CanDelete)
                                           { %>

                                        <a href="javascript:void(0);" onclick="fn_DeActivateEmp('<%#Eval("ContactID") %>')" title="Activate/Deactivate">
                                            <img src="../../../assests/images/activate_icon.png" /></a>
                                        <% } %>





                                        <%-- <asp:LinkButton ID="btn_delete" runat="server" OnClientClick="return confirm('Confirm delete?');" CommandArgument='<%# Container.KeyValue %>' CommandName="delete" ToolTip="Delete" Font-Underline="false">
                                        <img src="/assests/images/Delete.png" />
                                    </asp:LinkButton>--%>
                                </DataItemTemplate>

                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>

                                <CellStyle HorizontalAlign="Center"></CellStyle>

                                <HeaderTemplate><span>Actions</span></HeaderTemplate>

                                <EditFormSettings Visible="False"></EditFormSettings>
                            </dxe:GridViewDataTextColumn>

                            <dxe:GridViewDataTextColumn Caption="Employee Code" FieldName="Code"
                                VisibleIndex="1" FixedStyle="Left" Width="150px">
                                <CellStyle CssClass="gridcellleft" Wrap="False">
                                </CellStyle>
                            </dxe:GridViewDataTextColumn>

                        </Columns>
                        <SettingsPager PageSize="10" ShowSeparators="True">
                            <FirstPageButton Visible="True">
                            </FirstPageButton>
                            <LastPageButton Visible="True">
                            </LastPageButton>
                            <PageSizeItemSettings Visible="true" ShowAllItem="false" Items="10,50,100,150,200" />
                        </SettingsPager>
                        <SettingsCommandButton>
                            <DeleteButton ButtonType="Image" Image-Url="/assests/images/Delete.png">
                            </DeleteButton>
                        </SettingsCommandButton>
                        <SettingsEditing Mode="PopupEditForm" PopupEditFormHorizontalAlign="Center" PopupEditFormModal="True"
                            PopupEditFormVerticalAlign="WindowCenter" PopupEditFormWidth="900px" EditFormColumnCount="3" />
                        <SettingsText PopupEditFormCaption="Add/ Modify Employee" ConfirmDelete="Are you sure to delete?" />
                        <SettingsSearchPanel Visible="True" />
                        <Settings ShowGroupPanel="True" ShowStatusBar="Hidden" ShowHorizontalScrollBar="False" ShowFilterRow="true" ShowFilterRowMenu="true" />
                        <SettingsLoadingPanel Text="Please Wait..." />
                    </dxe:ASPxGridView>

                </td>
            </tr>
        </table>
        <br />
        <asp:HiddenField ID="hdn_GridBindOrNotBind" runat="server" />
        <asp:Button ID="BtnForExportEvent" runat="server" OnClick="cmbExport_SelectedIndexChanged" BackColor="#DDECFE" BorderStyle="None" Visible="false" />
        <dxe:ASPxGridViewExporter ID="exporter" runat="server" GridViewID="GrdEmployee" Landscape="true" PaperKind="A4" PageHeader-Font-Size="Larger" PageHeader-Font-Bold="true">
        </dxe:ASPxGridViewExporter>

    </div>
    <div class="PopUpArea">
        <dxe:ASPxPopupControl ID="ASPxActivationPopup" runat="server" ClientInstanceName="cActivationPopup"
            Width="350px" HeaderText="Activate/Deactivate" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <dxe:ASPxCallbackPanel runat="server" ID="SelectPanel" ClientInstanceName="cSelectPanel" OnCallback="SelectPanel_Callback" >
                        <ClientSideEvents EndCallback="function(s, e) {SelectPanel_EndCallBack();}" />
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <div>De-Activate</div>
                                <div>
                                    <dxe:ASPxCheckBox ID="CmbDesignName" ClientInstanceName="cCmbDesignName" runat="server" ValueType="System.String" Width="100%" EnableSynchronization="True">
                                        <ClientSideEvents CheckedChanged="function(s, e) {return ActivateDeactivateTxtReason(s, e); }" />
                                    </dxe:ASPxCheckBox>
                                </div>
                                <div id="DivVisible" ">
                                <div>Reason Of Deactivate</div>
                                
                                    <dxe:ASPxMemo ID="TxtReason" ClientInstanceName="cTxtReason" runat="server" ValueType="System.String" Width="100%" Height="200px" >
                                         <ValidationSettings RequiredField-IsRequired="true" Display="None"></ValidationSettings>
                                    </dxe:ASPxMemo>
                                </div>
                                <div class="text-center pTop10">
                                    <dxe:ASPxButton ID="btnOK" ClientInstanceName="cbtnOK" runat="server" AutoPostBack="False" Text="OK" CssClass="btn btn-primary" meta:resourcekey="btnSaveRecordsResource1" UseSubmitBehavior="False">
                                    <ClientSideEvents Click="function(s, e) {return PerformCallToGridBind(); }" />
                                       
                                    </dxe:ASPxButton>
                                </div>
                                
                            </dxe:PanelContent>
                        </PanelCollection>
                    </dxe:ASPxCallbackPanel>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            
        </dxe:ASPxPopupControl>
    </div>
    <input type="hidden" runat="server" id="hdnContactId" value="" />


    <div class="PopUpArea">
        <dxe:ASPxPopupControl ID="popupsupervisorchange" runat="server" ClientInstanceName="cActivationPopupsupervisor"
            Width="350px" HeaderText="Supervisor Change" PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter" CloseAction="CloseButton"
            Modal="True" ContentStyle-VerticalAlign="Top" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dxe:PopupControlContentControl runat="server">
                    <dxe:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel1" ClientInstanceName="cSelectPanel" OnCallback="SelectPanel_Callback" >
                        <ClientSideEvents EndCallback="function(s, e) {SelectPanel_EndCallBack();}" />
                        <PanelCollection>
                            <dxe:PanelContent runat="server">
                                <div>Past Supervisor</div>
                                <div>
                                   <asp:DropDownList ID="fromsuper" runat="server"></asp:DropDownList>
                                </div>
                                <div id="" >


                                <div>New Supervisor</div>
                                
                                       <asp:DropDownList ID="tosupervisor" runat="server"></asp:DropDownList>
                                </div>
                                <div class="text-center pTop10">
                                   <a href="javascript:void(0);" onclick="OnserverCallSupervisorchanged()" class="btn btn-primary"><span>Change Supervisor</span> </a>
                                </div>
                                
                            </dxe:PanelContent>
                        </PanelCollection>
                    </dxe:ASPxCallbackPanel>
                </dxe:PopupControlContentControl>
            </ContentCollection>
            
        </dxe:ASPxPopupControl>
    </div>


</asp:Content>
