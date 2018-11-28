----------------Central Data Changes
----------------------------------------External Script------------------------------------
---After Naming Change 

<!--External Styles-->
    <link type="text/css" href="../../../../CentralData/CSS/GenericCss.css" rel="Stylesheet" />
    <!--External Scripts file-->
    <!-- Ajax List Requierd-->
    <link type="text/css" href="../../../../CentralData/CSS/GenericAjaxStyle.css" rel="Stylesheet" />
    <script type="text/javascript" src="../../../../CentralData/JSScript/GenericAjaxList.js"></script>
    <script type="text/javascript" src="../../../../CentralData/JSScript/init.js"></script>
    <!--Other Script-->
    <script type="text/javascript" src="../../../../CentralData/JSScript/GenericJScript.js"></script>
    

----------------------------------------Inline Script-----------------------------------
//How To Call Ajax List Using Central Data
 function CallGenericAjaxJS(e)
        {
            var AjaxList_TextBox=GetObjectID('txtSelectionID');
            AjaxList_TextBox.focus();
            AjaxComQuery=AjaxComQuery.replace("\'","'");
            var GenericAjaxListAspxPath = '../../../../CentralData/Pages/GenericAjaxList.aspx';
            ajax_showOptions(AjaxList_TextBox,'GenericAjaxList',e,replaceChars(AjaxComQuery),'Main',GenericAjaxListAspxPath);
        }