/**
*******************************************************************************
* functions.js
***************
Version: 0.10.9
Date:    09/05/2008
Author:  Alexis Dereeper, Valentin Guignon
Contains various helper functions.

*******************************************************************************
*/


/**
*******************************************************************************
* Variables
************
*/
// array of functions to run when the document is loaded
var _g_onload_functions = _g_onload_functions || new Array();
// tells if the page has already been loaded
var _g_is_loaded = false;
// handle to the refresh callback
var _g_refresh_timeout = 0;
// reference to a function to call once a task is done
// the function can have on parameter: the tracking ID of the done task.
var OnDone = 0;




/**
*******************************************************************************
* Functions
************
*/


/**
GetElementByTitle
*****************
Return the first element with the given title.
Only check element which tag is in the list of tags to check.

Parameters:
 title: title of the element to find
 tag_types: array of tags to check. By default (no array or empty array),
            use 'DIV' tags.

*/
function GetElementByTitle(title, tag_types)
{
    if (!tag_types || (0 == tag_types.length))
    {
        tag_types = new Array('DIV');
    }

    if (!title)
    {
        return;
    }

    // find the corresponding element
    for (var i = 0; tag_types.length > i; ++i)
    {
        var objects = document.getElementsByTagName(tag_types[i]);
        var j = 0;
        while (j < objects.length)
        {
            if (title == objects[j].title)
            {
                return objects[j];
            }
            ++j;
        }
    }
}


/**
ShowObject
**********
Changes the "display" style of an object of ID object_id.

Parameters:
 object_id: id or name or title (for div, span and anchors) of the object

 display_mode: new display style (default: "block").

*/
function ShowObject(object_id, display_mode)
{
    // get by ID
    var obj = document.getElementById(object_id);
    // if not found, get by name
    if (!obj)
    {
        var objects = document.getElementsByName(object_id);
        if (objects.length)
        {
            // use the first one of the array
            obj = objects[0];
        }
        else
        {
            // not found, try title...
            var i = 0;
            // ... in divs
            objects = document.getElementsByTagName('div');
            while ((!obj) && (i < objects.length))
            {
                if (object_id == objects[i].title)
                {
                    obj = objects[i];
                }
                ++i;
            }
            if (!obj)
            {
                // ... now in spans
                objects = document.getElementsByTagName('span');
                while ((!obj) && (i < objects.length))
                {
                    if (object_id == objects[i].title)
                    {
                        obj = objects[i];
                    }
                    ++i;
                }
                if (!obj)
                {
                    // ... and finally in anchors
                    objects = document.getElementsByTagName('a');
                    while ((!obj) && (i < objects.length))
                    {
                        if (object_id == objects[i].title)
                        {
                            obj = objects[i];
                        }
                        ++i;
                    }
                }
            }
        }
    }
    if (!display_mode)
    {
        display_mode = "block";
    }
    if ((obj) && (obj.style))
    {
        obj.style.display = display_mode;
    }
}


/**
ShowTooltip
***********
Shows a tooltip (items with class "tooltip") inside a given object.

Parameters:
 object: object containing the tooltip.

 show: (boolean) true to display the tooltip, false to hide it.
  Default: true

*/
function ShowTooltip(object, show)
{
    if (object)
    {
        if ((null == show) || show)
        {
            // show tooltip
            // get tooltip sub-object
            for (var i=0; i < object.childNodes.length; ++i)
            {
                if ((1 == object.childNodes[i].nodeType) && ("tooltip" == object.childNodes[i].className))
                {
                    object.childNodes[i].className = "tooltip_visible";
                }
            }
        }
        else
        {
            // hide tooltip
            // get tooltip sub-object
            for (var i=0; i < object.childNodes.length; ++i)
            {
                if ((1 == object.childNodes[i].nodeType) && ("tooltip_visible" == object.childNodes[i].className))
                {
                    object.childNodes[i].className = "tooltip";
                }
            }
        }
    }
}


/**
ToggleElementDisplay
********************
Toggles the "display" style of an object of ID object_id.

Parameters:
 object_id: id of the object

*/
function ToggleElementDisplay(object_id, event)
{
    // display/hide the field associated to the toggler
    var obj = document.getElementById(object_id);
    if ((obj) && (obj.style))
    {
        if ("block" == obj.style.display)
        {
            obj.style.display = "none";
        }
        else
        {
            obj.style.display = "block";
        }
    }

    //
    var element = null;
    if (window.event) // IE
    {
        element = window.event.srcElement;
    }
    else // W3C
    {
        element = this;
        // check if event was fired by the window
        if (window == element)
        {
            element = event.target;
        }
    }

    // check if the function was called from javascript link
    // work on toggler with no diplayed/hidden descriptions first
    if (element && ("reduced" == element.className))
    {
        element.className = "expanded";
    }
    else if (element && ("expanded" == element.className))
    {
        element.className = "reduced";
    }
    else if (element) // work on toggler containing diplayed/hidden descriptions
    {
        if (element.parentNode) // W3C
        {
            element = element.parentNode;
        }
        else if (element.parentElement) // IE
        {
            element = element.parentElement;
        }
        else
        {
            element = null;
        }
        if (element && ("reduced" == element.className))
        {
            element.className = "expanded";
        }
        else if (element && ("expanded" == element.className))
        {
            element.className = "reduced";
        }
    }
}


/**
SetFieldDisabled
****************
Changes the state (enable/disable) of the given field id.

Parameters:
 field_id: ID or name of the field

 disabled_state: true if the field should be disabled, false otherwise

*/
function SetFieldDisabled(field_id, disabled_state)
{
    var field = document.getElementById(field_id);
    if (!field)
    {
        // id not found, check for name
        field = document.getElementsByName(field_id);
        if (field)
        {
            field = field[0];
        }
    }
    if (field)
    {
        field.disabled = disabled_state;
    }
}


/**
ShowHideUsers
****************
Show/hide registered users list given in parameter

Parameters:
 list_users: list of users in HTML


*/
function ShowHideUsers(list_users)
{
  document.getElementById('registered').innerHTML = "list_users";
}




/**
AlertBootstrap
****************
Alert with a message when user is going to use bootstrap.

*/
function AlertBootstrap()
{
  alert("You are going to use the bootstrapping procedure which may take a long time to compute.\nNotice that the ALRT statistic test is much faster to compute and will return the exact same tree with statistical evaluation of branch support values very close to bootstrap ones.\nWe strongly recommend to use the ALRT test for the explorative phase, and only use bootstrap for the final publishing tree.");
}


/**
SetFieldChecked
***************
Changes the checked state of the given field id.

Parameters:
 field_id: ID or name of the field

 checked_state: true if the field should be checked, false otherwise

*/
function SetFieldChecked(field_id, checked_state)
{
    var field;
    // note: we don't use "document.getElementById" because of ".checked" member that wouldn't be available that way on Safari
    var j = 0;
    while (document.forms.length > j)
    {
        var elements = document.forms[j++].elements;
        var i = 0;
        while ((elements.length > i) && !field)
        {
            if ((elements[i].id == field_id) || (elements[i].name == field_id))
            {
                field = elements[i];
            }
            ++i;
        }
    }

    if (field)
    {
        field.checked = checked_state;
        UpdateFormElements(); // from forms_style.js
    }
}


/**
ClearField
**********
Function used to clear the value of a field.

Parameters:
 field_id_or_name: field id or name if given id is not found.

*/
function ClearField(field_id_or_name)
{
    var field = document.getElementById(field_id_or_name);
    if (field)
    {
        field.value = "";
    }
    else
    {
        field = document.getElementsByName(field_id_or_name);
        if (field && field[0])
    {
            field[0].value = "";
        }
    }
}


/**
SetURLParameter
***************
Function used to set or change the value of a parameter in current URL.
If the parameter is not in the URL it is added otherwise its value is changed.

Parameters:
 param_name: name of the parameter to set or change.
 param_value: new value for that parameter.
 url: the url string to check (optional). If not specified,
    window.location.href will be used as default.

Return: (string)
 the new URL.

*/
function SetURLParameter(param_name, param_value, url)
{
    if (!url)
    {
        url = window.location.href;
    }
    var new_url = "";
    // find the parameter is in the URL
    var param_pos = url.indexOf("?" + param_name + "=");
    if (0 > param_pos)
    {
        param_pos = url.indexOf("&" + param_name + "=");
    }
    if (0 > param_pos)
    {
        param_pos = url.indexOf("&amp;" + param_name + "=");
    }
    // check if the parameter was found
    if (0 > param_pos)
    {
        // param_name field not found
        new_url = url + "&" + param_name + "=" + param_value;
    }
    else
    {
        // param_name field found, update the parameter
        ++param_pos;
        // check if other parameters follow
        var next_param_pos = url.indexOf("&", param_pos);
        if (0 > next_param_pos)
        {
            // nothing follows
            new_url = url.substr(0, param_pos) + param_name + "=" + param_value;
        }
        else
        {
            // other parameters follow
            new_url = url.substr(0, param_pos) + url.substr(next_param_pos + 1) + "&" + param_name + "=" + param_value;
        }
    }
    return new_url;
}


/**
GetCookie
*********
Returns the value of a cookie.

Parameters:
 cookie_name: name of the cookie to retrieve.

Return:
 the value of the cookie if the cookie exists, null otherwise.

*/
function GetCookie(cookie_name)
{
    var start = document.cookie.indexOf(cookie_name + "=");
    var data_offset = start + cookie_name.length + 1;
    // check if we found the cookie
    if (0 > start)
    {
        // cookie not found
        return null;
    }
    var end = document.cookie.indexOf(";", data_offset);
    if (0 > end)
    {
        end = document.cookie.length;
    }
    return unescape(document.cookie.substring(data_offset, end));
}


/**
SetCookie
*********
Sets the value of a cookie.

Parameters:
 cookie_name: name of the cookie to save
 value: content of the cookie
 expiration: expiration delay (in days)
 path: cookie path
 domain: cookie domain
 secure: secure status

*/
function SetCookie(cookie_name, value, expiration, path, domain, secure)
{
    if (!cookie_name)
    {
        return;
    }

    // set time, it's in milliseconds
    var now = new Date();
    now.setTime(now.getTime());

    if (expiration)
    {
        expiration = expiration * 86400000;
    }
    var expires_date = new Date(now.getTime() + (expiration));

    var cookie_data = escape(value);
    if (expiration)
    {
        cookie_data += ";expires=" + expires_date.toGMTString();
    }
    if (path)
    {
        cookie_data += ";path=" + path;
    }
    if (domain)
    {
        cookie_data += ";domain=" + domain;
    }
    if (secure)
    {
        cookie_data += ";secure";
    }

    document.cookie = cookie_name + "=" + cookie_data;
}


/**
RemoveCookie
************
Removes a cookie.

Parameters:
 cookie_name: name of the cookie to remove
 path: cookie path
 domain: cookie domain

*/
function RemoveCookie(cookie_name, path, domain)
{
    if (GetCookie(cookie_name))
    {
        var cookie_data = "";
        if (path)
        {
            cookie_data += ";path=" + path;
        }
        if (domain)
        {
            cookie_data += ";domain=" + domain;
        }
        document.cookie = cookie_name + "=" + cookie_data + ";expires=Thu, 01-Jan-1970 00:00:01 GMT";
    }
}


/**
AddOnLoadFunction
*****************
Add a function to the run-list when document is loaded.

Parameters:
 func: a function.

Example:
    function myFunc() {}
    AddOnLoadFunction(myFunc);

*/
function AddOnLoadFunction(func)
{
    _g_onload_functions.push(func);
}


/**
DoLoad
******
Called when the document is loaded. This function calls any function
registered with AddOnLoadFunction().

*/
function DoLoad()
{
    for (var i = 0; i < _g_onload_functions.length; ++i)
    {
      if ("function" == typeof(_g_onload_functions[i]))
      {
        _g_onload_functions[i]();
      }
    }
    _g_is_loaded = true;
}


/**
ImportScript
************
Imports the content of another script.

*/
function ImportScript(url)
{
    // check if the document has already been loaded
    if (_g_is_loaded)
    {
        // document already loaded, directly do the import
        var script_element = document.createElement("script");
        script_element.type = "text/javascript";
        script_element.src = url;
        document.body.appendChild(script_element);
    }
    else
    {
        // document not loaded yet, wait loading before importing
        var import_func = function () {};
        eval("import_func = function ()\n{\n    var script_element = document.createElement(\"script\");\n    script_element.type = \"text/javascript\";\n    script_element.src = \"" + url + "\";\n    document.body.appendChild(script_element);\n}\n");
        AddOnLoadFunction(import_func);
    }
}


/**
CheckAutoRefresh
****************
Check if the task status needs to be refreshed each "refresh_checkbox.value" seconds.
If the element of ID "refresh_checkbox" is a checked checkbox, the refresh will
occure. If "refresh_checkbox.value" is below 1, refresh delay is set to 1 second.

Parameters:
 task_trid: tracking ID of the result to check for refresh.

*/
function CheckAutoRefresh(task_trid, output_number)
{
    // get refresh checkbox
    var auto_refresh_checkbox = document.getElementById("refresh_checkbox_" + task_trid);
    // check checkbox status
    if ((!auto_refresh_checkbox) || (auto_refresh_checkbox.type != "checkbox") || (true == auto_refresh_checkbox.checked))
    {
        // get refresh time
        if (auto_refresh_checkbox)
        {
            auto_refresh_time = 1000*parseInt(auto_refresh_checkbox.value);
        }
        else
        {
            auto_refresh_time = 5000;
        }
        if (1000 > auto_refresh_time)
        {
            // minimum of 1 second
            auto_refresh_time = 1000;
        }
        // set a new timeout
        _g_refresh_timeout = setTimeout("CheckStatus('" + task_trid + "', '" + output_number + "');", auto_refresh_time); // miliseconds
    }
    else
    {
        // checkbox is not checked, remove timeout
//        clearTimeout(_g_refresh_timeout);
        _g_refresh_timeout = 0;
    }
}


/**
DoSuccess
*********
Called by Ajax when fetching task status succeeded.

Parameters:
 transport: for Ajax
 task_trid: task tracking ID
 output_number: task output number

*/
function UpdateStatus(transport, task_trid, output_number)
{
    var refresh_message = document.getElementById("refresh_message_" + task_trid);
    var message = document.getElementById(transport.responseText + "_" + task_trid);

    // check if computation is done...
    if ("not_found" == transport.responseText)
    {
        // uncheck
        var auto_refresh_checkbox = document.getElementById("refresh_checkbox_" + task_trid);
        if (auto_refresh_checkbox)
        {
            auto_refresh_checkbox.checked = false;
        }
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
            refresh_message.innerHTML = "Task not found!";
        }
        ShowObject("mailer", "none");
    }
    else if ("waiting" == transport.responseText)
    {
        // check for auto-refresh
        CheckAutoRefresh(task_trid, output_number);
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
           refresh_message.innerHTML = "Task waiting for inputs.";
        }
        ShowObject("mailer", "none");
    }
    else if ("ready" == transport.responseText)
    {
        // check for auto-refresh
        CheckAutoRefresh(task_trid, output_number);
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
            refresh_message.innerHTML = "Task ready to be processed but not launched yet.";
        }
        ShowObject("mailer", "block");
    }
    else if ("processing" == transport.responseText)
    {
        // check for auto-refresh
        CheckAutoRefresh(task_trid, output_number);
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
            refresh_message.innerHTML = "Computing...";
        }
        ShowObject("mailer", "block");
    }
    else if ("pending" == transport.responseText)
    {
        // check for auto-refresh
        CheckAutoRefresh(task_trid, output_number);
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
            refresh_message.innerHTML = "Task paused!";
        }
        ShowObject("mailer", "block");
    }
    else if ("done" == transport.responseText)
    {
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
            refresh_message.innerHTML = "Task done! Results will appear in a few seconds...";
        }
        ShowObject("mailer", "none");
        // call the on_done function
        if (OnDone)
        {
            OnDone(task_trid);
        }
        else
        {
            // by default reload the whole page
            //window.location = window.location;
            window.location.reload();
        }
    }
    else if ("aborted" == transport.responseText)
    {
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
            refresh_message.innerHTML = "Task aborted!";
        }
        // reload the whole page
        //window.location = window.location;
        window.location.reload();
    }
    else if ("lost" == transport.responseText)
    {
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else
        {
            refresh_message.innerHTML = "Task lost on execution server!";
        }
        // reload the whole page
        //window.location = window.location;
        window.location.reload();
    }
    else
    {
        // check for auto-refresh
        // CheckAutoRefresh(task_trid, output_number);
        if ((message) && (refresh_message))
        {
            refresh_message.innerHTML = message.innerHTML;
        }
        else if (transport.responseText)
        {
            refresh_message.innerHTML = "Unknown task status! (" + transport.responseText + ")";
        }
        ShowObject("mailer", "none");
    }
}


/**
DoFailedToGetStatus
*******************
Called by Ajax when fetching task status failed.

Parameters:
 transport: for Ajax
 task_trid: task tracking ID
 output_number: task output number

*/
function DoFailedToGetStatus(transport, task_trid, output_number)
{
    if (true == confirm("The server encountered a temporary problem while checking if your job was done. You may try to refresh current page and see whether the problem persists or not. Do you want to refresh the page now?"))
    {
        // reload window
        //window.location = window.location;
        window.location.reload();
    }
}


/**
CheckStatus
***********
Used to check a task output number status (waiting, running, done,...).

Parameters:
 task_trid: task tracking ID
 output_number: task output number

*/
function CheckStatus(task_trid, output_number)
{
    var url = CGI_PATH + "/get_result.cgi?task_id=" + task_trid + "&results_in_list=" + output_number + "&status=1&random=" + Math.random();

    var ajax_object = new Ajax.Request(url, { method:"get", onSuccess:function (transport) { UpdateStatus(transport, task_trid, output_number); }, onFailure:function (transport) { DoFailedToGetStatus(transport, task_trid, output_number); } });
}



/**
NumberLines
***********
Add line numbers in front of each line of a given textarea.

Parameters:
 field: a textarea ID.

*/
function NumberLines(field)
{
    var short_names;
    if (short_names = document.getElementById(field))
    {
        var new_text = "";
        var old_text = short_names.value;
        // remove first number
        old_text = old_text.replace(/^\s*\d+\.[ \t]*/m, "");
        // remove trailing lines
        old_text = old_text.replace(/\s+$/m, "");
        // split by lines (and remove other numbers)
        var lines = old_text.split(/[ \t]*[\r\n]+[ \t]*\d*\.?[ \t]*/);
        // add new numbers
        for (var i = 0; i < lines.length; ++i)
        {
            if (lines[i])
            {
                new_text += (i+1) + "." + lines[i] + "\n";
            }
        }
        short_names.value = new_text;
    }
}


/**
RemoveLineNumbers
*****************
Remove line numbers in front of each line of a given textarea.

Parameters:
 field: a textarea ID.

*/
function RemoveLineNumbers(field)
{
    var short_names;
    if (short_names = document.getElementById(field))
    {
        short_names.value = short_names.value.replace(/^[ \t]*\d+\.[ \t]*/gm, "");
    }
}


/**
InitTooltips
************
Function used to initialize tooltips mouse event handlers for IE6.
Other standard web brothers don't need this function.

*/
function InitTooltips()
{
  var show_tooltips = GetCookie('tooltips');
  if ((null != show_tooltips) && (0 == show_tooltips))
  {
    return;
  }

  // get all spans (tooltip containers)
  var spans = document.getElementsByTagName('SPAN');
  for (var i=0; spans.length > i; ++i)
  {
    // check if current span element is a tooltip container
    if ("with_tooltip" == spans.item(i).className)
    {
      // it contains a tooltip, add mouse event handlers for IE6
      if (spans.item(i).onmouseout)
      {
        var old_onmouseout = spans.item(i).onmouseout;
        spans.item(i).onmouseout = function() {ShowTooltip(this, false); old_onmouseout();};
      }
      else
      {
        spans.item(i).onmouseout = function() {ShowTooltip(this, false);};
      }
      if (spans.item(i).onmouseover)
      {
        var old_onmouseover = spans.item(i).onmouseover;
        spans.item(i).onmouseover = function() {ShowTooltip(this, true); old_onmouseover();};
      }
      else
      {
        spans.item(i).onmouseover = function() {ShowTooltip(this, true);};
      }
    }
  }
  spans = null;
}

function verifyBlastBanks()
{
	var database = document.getElementsByName('database')[0];
	if ((document.getElementById('datatype_NT').checked == true) || (document.getElementById('datatype_AANT').checked == true))
	{
 		database.innerHTML = "<option value=\"nt\"> genbank NT (2009-11-26)</option>\n";
	}
}

AddOnLoadFunction(InitTooltips);
