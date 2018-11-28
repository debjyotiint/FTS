/************************************************************************************************************
(C) www.dhtmlgoodies.com, April 2006

This is a script from www.dhtmlgoodies.com. You will find this and a lot of other scripts at our website.	

Terms of use:
You are free to use this script as long as the copyright message is kept intact. However, you may not
redistribute, sell or repost it without our permission.

Thank you!

www.dhtmlgoodies.com
Alf Magne Kalleland

************************************************************************************************************/

var ajaxBox_offsetX = 0;
var ajaxBox_offsetY = 0;
//	var ajax_list_externalFile = '../management/ajax_list.aspx'; // Path to external file  //Comment On 30.07.2015
var ajax_list_externalFile = '../ajax_list.aspx'; // Path to external file

var minimumLettersBeforeLookup = 1;	// Number of letters entered before a lookup is performed.

var ajax_list_objects = new Array();
var ajax_list_cachedLists = new Array();
var ajax_list_activeInput = false;
var ajax_list_activeItem;
var ajax_list_optionDivFirstItem = false;
var ajax_list_currentLetters = new Array();
var ajax_optionDiv = false;
var ajax_optionDiv_iframe = false;

var ajax_list_MSIE = false;
if (navigator.userAgent.indexOf('MSIE') >= 0 && navigator.userAgent.indexOf('Opera') < 0) ajax_list_MSIE = true;

var currentListIndex = 0;


function ajax_getTopPos(inputObj) {

    var returnValue = inputObj.offsetTop;
    while ((inputObj = inputObj.offsetParent) != null) {
        returnValue += inputObj.offsetTop;
    }
    return returnValue;
}
function ajax_list_cancelEvent() {
    return false;
}

function ajax_getLeftPos(inputObj) {
    var returnValue = inputObj.offsetLeft;
    while ((inputObj = inputObj.offsetParent) != null) returnValue += inputObj.offsetLeft;

    return returnValue;
}

function ajax_option_setValue(e, inputObj) {
    if (FieldName != '') {
        //______This if to hide cdropdown list if FieldName is assigned__//
        if (document.getElementById(FieldName)) document.getElementById(FieldName).style.display = '';

        if (!inputObj) inputObj = this;
        var tmpValue = inputObj.innerHTML;
        if (ajax_list_MSIE) tmpValue = inputObj.innerText; else tmpValue = inputObj.textContent;
        if (!tmpValue) tmpValue = inputObj.innerHTML;
        ajax_list_activeInput.value = tmpValue;
        //document.getElementById(search_param).value=inputObj.id;

        //	if (document.getElementById(ajax_list_activeInput.name + '_hidden')) document.getElementById(ajax_list_activeInput.name + '_hidden').value = inputObj.id;
        if (document.getElementById(ajax_list_activeInput.id + '_hidden')) document.getElementById(ajax_list_activeInput.id + '_hidden').value = inputObj.id;
        // alert(ajax_list_activeInput.id);
        ajax_options_hide();
    }
}

function ajax_options_hide() {
    if (FieldName != '') {
        if (document.getElementById(FieldName)) document.getElementById(FieldName).style.display = '';

        if (ajax_optionDiv) ajax_optionDiv.style.display = 'none';
        if (ajax_optionDiv_iframe) ajax_optionDiv_iframe.style.display = 'none';
    }
}

function ajax_options_rollOverActiveItem(item, fromKeyBoard) {
    if (ajax_list_activeItem) ajax_list_activeItem.className = 'optionDiv';
    item.className = 'optionDivSelected';
    ajax_list_activeItem = item;

    if (fromKeyBoard) {
        if (ajax_list_activeItem.offsetTop > ajax_optionDiv.offsetHeight) {
            ajax_optionDiv.scrollTop = ajax_list_activeItem.offsetTop - ajax_optionDiv.offsetHeight + ajax_list_activeItem.offsetHeight + 2;
        }
        if (ajax_list_activeItem.offsetTop < ajax_optionDiv.scrollTop) {
            ajax_optionDiv.scrollTop = 0;
        }
    }
}

function ajax_option_list_buildList(letters, paramToExternalFile) {

    ajax_optionDiv.innerHTML = '';
    ajax_list_activeItem = false;
    if (ajax_list_cachedLists[paramToExternalFile][letters.toLowerCase()].length <= 1) {
        ajax_options_hide();
        return;
    }



    ajax_list_optionDivFirstItem = false;
    var optionsAdded = false;
    for (var no = 0; no < ajax_list_cachedLists[paramToExternalFile][letters.toLowerCase()].length; no++) {
        if (ajax_list_cachedLists[paramToExternalFile][letters.toLowerCase()][no].length == 0) continue;
        optionsAdded = true;
        var div = document.createElement('DIV');
        var items = ajax_list_cachedLists[paramToExternalFile][letters.toLowerCase()][no].split(/###/gi);
        if (ajax_list_cachedLists[paramToExternalFile][letters.toLowerCase()].length == 1 && ajax_list_activeInput.value == items[0]) {
            ajax_options_hide();
            return;
        }


        div.innerHTML = items[items.length - 1];
        div.id = items[0];
        //alert(div.innerHTML);
        //alert(items[0]);

        div.className = 'optionDiv';
        div.onmouseover = function () { ajax_options_rollOverActiveItem(this, false) }
        div.onclick = ajax_option_setValue;
        if (!ajax_list_optionDivFirstItem) ajax_list_optionDivFirstItem = div;
        ajax_optionDiv.appendChild(div);
    }
    if (optionsAdded) {
        ajax_optionDiv.style.display = 'block';
        if (ajax_optionDiv_iframe) ajax_optionDiv_iframe.style.display = '';
        ajax_options_rollOverActiveItem(ajax_list_optionDivFirstItem, true);
    }

    if (FieldName != '') {
        if (document.getElementById(FieldName)) document.getElementById(FieldName).style.display = 'none';
    }

}

function ajax_option_list_showContent(ajaxIndex, inputObj, paramToExternalFile, whichIndex) {
    if (whichIndex != currentListIndex) return;
    var letters = inputObj.value;
    var content = ajax_list_objects[ajaxIndex].response;
    var elements = content.split('|');
    ajax_list_cachedLists[paramToExternalFile][letters.toLowerCase()] = elements;
    ajax_option_list_buildList(letters, paramToExternalFile);

}

function ajax_option_resize(inputObj) {
    ajax_optionDiv.style.top = (ajax_getTopPos(inputObj) + inputObj.offsetHeight + ajaxBox_offsetY) + 'px';
    ajax_optionDiv.style.left = (ajax_getLeftPos(inputObj) + ajaxBox_offsetX) + 'px';
    if (ajax_optionDiv_iframe) {
        ajax_optionDiv_iframe.style.left = ajax_optionDiv.style.left;
        ajax_optionDiv_iframe.style.top = ajax_optionDiv.style.top;
    }

}

function ajax_showOptions(inputObj, paramToExternalFile, e, obj_search, searchStart) {
   
   
    //	if (searchStart)
    //	{
    //	    alert('test');
    //	    minimumLettersBeforeLookup=3;
    //	
    //	}
    //alert(obj_search);
    //alert(document.getElementsByName(obj_search).value);
var search_par;
    search_par = obj_search; //document.getElementsByName(obj_search).value;

    //alert(FieldName);
    //alert(inputObj.value);
    //alert(paramToExternalFile);

    //	//select
    //	var search_param
    //	
    //	  if (obj_lst.options[obj_lst.selectedIndex].text=='')
    //	  {
    //	  }
    //	  if 
    //	  
    //	
    //	
    //	//alert(document.getElementById('ctl00_ContentPlaceHolder1_H_GrdTable.value').value);	
    //    alert(document.getElementById(obj_lst));
    //	//alert(document.getElementById('drpProducttype').options[document.getElementById('drpProducttype').selectedIndex].value);	
    //	//alert(document.getElementById(obj_lst).options[document.getElementById(obj_lst).selectedIndex].text);


    if (e.keyCode == 13 || e.keyCode == 9) return;
    if (ajax_list_currentLetters[inputObj.name] == inputObj.value) return;
    if (!ajax_list_cachedLists[paramToExternalFile]) ajax_list_cachedLists[paramToExternalFile] = new Array();
    ajax_list_currentLetters[inputObj.name] = inputObj.value;
    if (!ajax_optionDiv) {
        ajax_optionDiv = document.createElement('DIV');
        ajax_optionDiv.id = 'ajax_listOfOptions';
        document.body.appendChild(ajax_optionDiv);
        //alert('currentListIndex');
        if (ajax_list_MSIE) {
            ajax_optionDiv_iframe = document.createElement('IFRAME');
            ajax_optionDiv_iframe.border = '0';
            ajax_optionDiv_iframe.style.width = ajax_optionDiv.clientWidth + 'px';
            //ajax_optionDiv_iframe.style.width = '500px';
            ajax_optionDiv_iframe.style.height = ajax_optionDiv.clientHeight + 'px';
            ajax_optionDiv_iframe.id = 'ajax_listOfOptions_iframe';
            document.body.appendChild(ajax_optionDiv_iframe);
        }

        var allInputs = document.getElementsByTagName('INPUT');
        for (var no = 0; no < allInputs.length; no++) {
            if (!allInputs[no].onkeyup) allInputs[no].onfocus = ajax_options_hide;
        }
        var allSelects = document.getElementsByTagName('SELECT');
        for (var no = 0; no < allSelects.length; no++) {
            allSelects[no].onfocus = ajax_options_hide;
        }

        var oldonkeydown = document.body.onkeydown;
        if (typeof oldonkeydown != 'function') {
            document.body.onkeydown = ajax_option_keyNavigation;
        } else {
            document.body.onkeydown = function () {
                oldonkeydown();
                ajax_option_keyNavigation();
            }
        }
        var oldonresize = document.body.onresize;
        if (typeof oldonresize != 'function') {
            document.body.onresize = function () { ajax_option_resize(inputObj); };
        } else {
            document.body.onresize = function () {
                oldonresize();
                ajax_option_resize(inputObj);
            }
        }

    }

    if (inputObj.value.length < minimumLettersBeforeLookup) {
        ajax_options_hide();
        //alert('currentListIndex');
        return;
    }


    ajax_optionDiv.style.top = (ajax_getTopPos(inputObj) + inputObj.offsetHeight + ajaxBox_offsetY) + 'px';
    ajax_optionDiv.style.left = (ajax_getLeftPos(inputObj) + ajaxBox_offsetX) + 'px';
    ajax_optionDiv.style.width = '50%';
    ajax_optionDiv.style.backgroundcolor = "transparent";
    if (ajax_optionDiv_iframe) {
        ajax_optionDiv_iframe.style.left = ajax_optionDiv.style.left;
        ajax_optionDiv_iframe.style.top = ajax_optionDiv.style.top;
    }

    ajax_list_activeInput = inputObj;
    ajax_optionDiv.onselectstart = ajax_list_cancelEvent;
    currentListIndex++;

    //		if(ajax_list_cachedLists[paramToExternalFile][inputObj.value.toLowerCase()]){
    //			ajax_option_list_buildList(inputObj.value,paramToExternalFile,currentListIndex);
    //			//alert('url');			
    //		}else{
    var tmpIndex = currentListIndex / 1;
    ajax_optionDiv.innerHTML = '';
    var ajaxIndex = ajax_list_objects.length;
    ajax_list_objects[ajaxIndex] = new sack();
    //alert('url1');
    //var abc =new Date 		
    //ajax_list_externalFile=ajax_list_externalFile+'&abc='+abc
    var InputObj1 = inputObj.value.replace(" ", "+");
    var InputObjUpdate = InputObj1.replace("&", "_");

 
    
    var url = ajax_list_externalFile + '?' + paramToExternalFile + '=1&search_param=' + search_par + '&letters=' + InputObjUpdate;
   
    ajax_list_objects[ajaxIndex].requestFile = url;	// Specifying which file to get
    ajax_list_objects[ajaxIndex].onCompletion = function () { ajax_option_list_showContent(ajaxIndex, inputObj, paramToExternalFile, tmpIndex); };	// Specify function that will be executed after file has been found
    ajax_list_objects[ajaxIndex].runAJAX();		// Execute AJAX function		
    //		}

    //alert(url);	
}


function ajax_showOptionsTEST(inputObj, paramToExternalFile, e, obj_search, searchStart) {

   
 
    //	if (searchStart)
    //	{
    //	    alert('test');
    //	    minimumLettersBeforeLookup=3;
    //	
    //	}
    //alert(obj_search);
    //alert(document.getElementsByName(obj_search).value);
    var search_par
    search_par = obj_search; //document.getElementsByName(obj_search).value;

    //alert(FieldName);
    //alert(inputObj.value);
    //alert(paramToExternalFile);

    //	//select
    //	var search_param
    //	
    //	  if (obj_lst.options[obj_lst.selectedIndex].text=='')
    //	  {
    //	  }
    //	  if 
    //	  
    //	
    //	
    //	//alert(document.getElementById('ctl00_ContentPlaceHolder1_H_GrdTable.value').value);	
    //    alert(document.getElementById(obj_lst));
    //	//alert(document.getElementById('drpProducttype').options[document.getElementById('drpProducttype').selectedIndex].value);	
    //	//alert(document.getElementById(obj_lst).options[document.getElementById(obj_lst).selectedIndex].text);


    if (e.keyCode == 13 || e.keyCode == 9) return;
    if (ajax_list_currentLetters[inputObj.name] != "undefined") {
        ajax_list_currentLetters[inputObj.name] = "undefined";
    }
    if (ajax_list_currentLetters[inputObj.name] == inputObj.value) return;
    if (!ajax_list_cachedLists[paramToExternalFile]) ajax_list_cachedLists[paramToExternalFile] = new Array();
    ajax_list_currentLetters[inputObj.name] = inputObj.value;
    if (!ajax_optionDiv) {
        ajax_optionDiv = document.createElement('DIV');
        ajax_optionDiv.id = 'ajax_listOfOptions';
        document.body.appendChild(ajax_optionDiv);
        //alert('currentListIndex');
        if (ajax_list_MSIE) {
            ajax_optionDiv_iframe = document.createElement('IFRAME');
            ajax_optionDiv_iframe.border = '0';
            ajax_optionDiv_iframe.style.width = ajax_optionDiv.clientWidth + 'px';
            //ajax_optionDiv_iframe.style.width = '500px';
            ajax_optionDiv_iframe.style.height = ajax_optionDiv.clientHeight + 'px';
            ajax_optionDiv_iframe.id = 'ajax_listOfOptions_iframe';
            document.body.appendChild(ajax_optionDiv_iframe);
        }

        var allInputs = document.getElementsByTagName('INPUT');
        for (var no = 0; no < allInputs.length; no++) {
            if (!allInputs[no].onkeyup) allInputs[no].onfocus = ajax_options_hide;
        }
        var allSelects = document.getElementsByTagName('SELECT');
        for (var no = 0; no < allSelects.length; no++) {
            allSelects[no].onfocus = ajax_options_hide;
        }

        var oldonkeydown = document.body.onkeydown;
        if (typeof oldonkeydown != 'function') {
            document.body.onkeydown = ajax_option_keyNavigation;
        } else {
            document.body.onkeydown = function () {
                oldonkeydown();
                ajax_option_keyNavigation();
            }
        }
        var oldonresize = document.body.onresize;
        if (typeof oldonresize != 'function') {
            document.body.onresize = function () { ajax_option_resize(inputObj); };
        } else {
            document.body.onresize = function () {
                oldonresize();
                ajax_option_resize(inputObj);
            }
        }

    }

    if (inputObj.value.length < minimumLettersBeforeLookup) {
        ajax_options_hide();
        //alert('currentListIndex');
        return;
    }


    ajax_optionDiv.style.top = (ajax_getTopPos(inputObj) + inputObj.offsetHeight + ajaxBox_offsetY) + 'px';
    ajax_optionDiv.style.left = (ajax_getLeftPos(inputObj) + ajaxBox_offsetX) + 'px';
    ajax_optionDiv.style.width = '50%';
    ajax_optionDiv.style.backgroundcolor = "transparent";
    if (ajax_optionDiv_iframe) {
        ajax_optionDiv_iframe.style.left = ajax_optionDiv.style.left;
        ajax_optionDiv_iframe.style.top = ajax_optionDiv.style.top;
    }

    ajax_list_activeInput = inputObj;
    ajax_optionDiv.onselectstart = ajax_list_cancelEvent;
    currentListIndex++;

    //		if(ajax_list_cachedLists[paramToExternalFile][inputObj.value.toLowerCase()]){
    //			ajax_option_list_buildList(inputObj.value,paramToExternalFile,currentListIndex);
    //			//alert('url');			
    //		}else{
    var tmpIndex = currentListIndex / 1;
    ajax_optionDiv.innerHTML = '';
    var ajaxIndex = ajax_list_objects.length;
    ajax_list_objects[ajaxIndex] = new sack();
    //alert('url1');
    //var abc =new Date 		
    //ajax_list_externalFile=ajax_list_externalFile+'&abc='+abc
    var InputObj1 = inputObj.value.replace(" ", "+");
    var InputObjUpdate = InputObj1.replace("&", "_");

    var url = ajax_list_externalFile + '?' + paramToExternalFile + '=1&search_param=' + search_par + '&letters=' + InputObjUpdate;
    //alert(url);
    ajax_list_objects[ajaxIndex].requestFile = url;	// Specifying which file to get
    ajax_list_objects[ajaxIndex].onCompletion = function () { ajax_option_list_showContent(ajaxIndex, inputObj, paramToExternalFile, tmpIndex); };	// Specify function that will be executed after file has been found
    ajax_list_objects[ajaxIndex].runAJAX();		// Execute AJAX function		
    //		}

    //alert(url);	
}

function ajax_option_keyNavigation(e) {
    if (document.all) e = event;

    if (!ajax_optionDiv) return;
    if (ajax_optionDiv.style.display == 'none') return;

    if (e.keyCode == 38) {	// Up arrow
        if (!ajax_list_activeItem) return;
        if (ajax_list_activeItem && !ajax_list_activeItem.previousSibling) return;
        ajax_options_rollOverActiveItem(ajax_list_activeItem.previousSibling, true);
    }

    if (e.keyCode == 40) {	// Down arrow
        if (!ajax_list_activeItem) {
            ajax_options_rollOverActiveItem(ajax_list_optionDivFirstItem, true);
        } else {
            if (!ajax_list_activeItem.nextSibling) return;
            ajax_options_rollOverActiveItem(ajax_list_activeItem.nextSibling, true);
        }
    }

    if (e.keyCode == 13 || e.keyCode == 9) {	// Enter key or tab key
        if (ajax_list_activeItem && ajax_list_activeItem.className == 'optionDivSelected') ajax_option_setValue(false, ajax_list_activeItem);
        if (e.keyCode == 13) return false; else return true;
    }
    if (e.keyCode == 27) {	// Escape key
        ajax_options_hide();
    }
}


document.documentElement.onclick = autoHideList;

function autoHideList(e) {
    if (FieldName != '') {
        if (document.getElementById(FieldName)) document.getElementById(FieldName).style.display = '';

        if (document.all) e = event;

        if (e.target) source = e.target;
        else if (e.srcElement) source = e.srcElement;
        if (source.nodeType == 3) // defeat Safari bug
            source = source.parentNode;
        if (source.tagName.toLowerCase() != 'input' && source.tagName.toLowerCase() != 'textarea') ajax_options_hide();
    }
}
