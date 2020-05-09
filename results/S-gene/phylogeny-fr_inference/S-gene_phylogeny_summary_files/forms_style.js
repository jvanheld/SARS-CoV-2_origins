/**
*******************************************************************************
* forms_style.js
*****************
Version: 0.10.6
Date:    18/06/2008
Author:  Alexis Dereeper, Valentin Guignon
Handles custom radio and checkbox form elements.
A radio or checkbox element to customize should be defined in the HTML
document like this (with span tags):

<span class="radio">
  <input type="radio" value="1" name="radio_group"/> Radio Label
</span><br/>

<span class="checkbox">
  <input type="checkbox" value="1"/> Checkbox Label
</span><br/>

or like this (with div tags):

<div class="radio">
  <input type="radio" value="1" name="radio_group"/> Radio Label
</div>

<div class="checkbox">
  <input type="checkbox" value="1"/> Checkbox Label
</div>


OnClick event on checkbox/radio (not on div or span tag) is supported.

*******************************************************************************
*/


/**
*******************************************************************************
* Functions
************
*/


/**
UpdateFormElements
******************
Update status of customized form elements.

Parameters:
 form_doc: document containing the form elements to update.
           Default: current document.

*/
function UpdateFormElements(form_doc)
{
    var j = 0;
    if (!form_doc)
    {
        form_doc = document;
    }
    while (form_doc.forms.length > j)
    {
        var elements = form_doc.forms[j++].elements;
        var i = 0;
        while (elements.length > i)
        {
            UpdateFormElement(elements[i++]);
        }
    }
}




/**
UpdateFormElement
*****************
Update status of a single customized form element.

Parameters:
 element: the form element to update.

*/
function UpdateFormElement(element)
{
    if (!element)
    {
        return;
    }
    var block;
    if ("radio" == element.type)
    {
        if (block = GetInputBlock(element))
        {
            // get input status
            if (element.disabled)
            {
                if (element.checked)
                {
                    block.className = "radio radio_disabled_checked";
                }
                else
                {
                    block.className = "radio radio_disabled";
                }
            }
            else
            {
                if (element.checked)
                {
                    block.className = "radio radio_checked";
                }
                else
                {
                    block.className = "radio radio_unchecked";
                }
            }
            element.className = "hidden"; // Konqueror does not support "display" style on radios and checkboxes
            element.style.display = "none";
        }
    }
    else if ("checkbox" == element.type)
    {
        if (block = GetInputBlock(element))
        {
            // get input status
            if (element.disabled)
            {
                if (element.checked)
                {
                    block.className = "checkbox checkbox_disabled_checked";
                }
                else
                {
                    block.className = "checkbox checkbox_disabled";
                }
            }
            else
            {
                if (element.checked)
                {
                    block.className = "checkbox checkbox_checked";
                }
                else
                {
                    block.className = "checkbox checkbox_unchecked";
                }
            }
            element.className = "hidden"; // Konqueror does not support "display" style on radios and checkboxes
            element.style.display = "none";
        }
    }
}




/**
InitFormDisplay
***************
Replace standard radios and checkboxes by cutsomized ones.
To be customized, an input radio or an input checkbox element must be inside
a div or a span block with a classname set to "radio" or "checkbox".

*/
function InitFormDisplay()
{
    var input_tags = document.getElementsByTagName("input");
    var i = 0;
    while (input_tags.length > i)
    {
        if (("checkbox" == input_tags.item(i).type) || ("radio" == input_tags.item(i).type))
        {
            var input_block = GetInputBlock(input_tags.item(i));
            // check if element is a checkbox or a radio and has not already been initialized
            if (input_block && (input_block.onclick != OnClickInput))
            {
                input_block.style.padding = "3px 0px 0px 24px";
                input_block.mousetrack  = false;
                input_block.onclick     = OnClickInput;
                input_block.ondblclick  = OnClickInput;
                input_block.onmousedown = OnMouseDownInput;
                input_block.onmouseup   = OnMouseUpInput;
                input_block.onmouseout  = OnMouseOutInput;
                input_block.onmouseover = OnMouseOverInput;
                input_block.onkeypress  = OnKeyPressInput;
                input_block.onkeydown   = OnKeyDownInput;
                input_block.onkeyup     = OnKeyUpInput;
                input_tags.item(i).className = "hidden"; // Konqueror does not support "display" style on radios and checkboxes
                input_tags.item(i).style.display = "none";
                // get input type
                if ("radio" == input_tags.item(i).type)
                {
                    // get input status
                    if (input_tags.item(i).disabled)
                    {
                        if (input_tags.item(i).checked)
                        {
                            input_block.className = "radio radio_disabled_checked";
                        }
                        else
                        {
                            input_block.className = "radio radio_disabled";
                        }
                    }
                    else
                    {
                        if (input_tags.item(i).checked)
                        {
                            input_block.className = "radio radio_checked";
                        }
                        else
                        {
                            input_block.className = "radio radio_unchecked";
                        }
                    }
                }
                else if ("checkbox" == input_tags.item(i).type)
                {
                    // get input status
                    if (input_tags.item(i).disabled)
                    {
                        if (input_tags.item(i).checked)
                        {
                            input_block.className = "checkbox checkbox_disabled_checked";
                        }
                        else
                        {
                            input_block.className = "checkbox checkbox_disabled";
                        }
                    }
                    else
                    {
                        if (input_tags.item(i).checked)
                        {
                            input_block.className = "checkbox checkbox_checked";
                        }
                        else
                        {
                            input_block.className = "checkbox checkbox_unchecked";
                        }
                    }
                }
                // wrap span/div content within an anchor to be able to click on the text for checking using the keyboard (if the mouse is not available)
                //OLD STYLE: input_block.innerHTML = "<a href=\"#.\">" + tags.item(i).innerHTML + "</a>"; replaced by new style below:
                var anchor = document.createElement('a');
                anchor.href = "#.";
                var j = 0;
                while (input_block.hasChildNodes())
                {
                    var clone = input_block.firstChild.cloneNode(true);
                    anchor.appendChild(clone);
                    input_block.removeChild(input_block.firstChild);
                }
                input_block.appendChild(anchor);
            }
        }
        ++i;
    }
    var forms = document.forms;
    i = 0;
    while (forms.length > i)
    {
        if (!forms[i].onreset)
        {
            forms[i].onreset = function() {setTimeout("UpdateFormElements();", 10);};
        }
        ++i;
    }
}


/**
GetInputBlock
*************
Returns the div or span block containing the input element.
div or span block classname must contain "checkbox" or "radio".

Parameters:
 element: the element inside a customized radio or checkbox block.

*/
function GetInputBlock(element)
{
    if (!element)
    {return null;}
    if (element.parentNode) // W3C
    {
        while (element
               && ((("DIV" != element.nodeName)
                    && ("SPAN" != element.nodeName))
                   || (element.className
                       && ((0 > element.className.indexOf("checkbox"))
                       && (0 > element.className.indexOf("radio"))))))
        {
            element = element.parentNode;
        }
    }
    else if (element.parentElement) // IE
    {
        while (element
               && ((("DIV" != element.nodeName)
                    && ("SPAN" != element.nodeName))
                   || (element.className
                       && ((0 > element.className.indexOf("checkbox"))
                       && (0 > element.className.indexOf("radio"))))))
        {
            element = element.parentElement;
        }
    }
    // check we got the correct element
    if ((!element)
        || (!element.className)
        || ((0 > element.className.indexOf("checkbox")) && (0 > element.className.indexOf("radio"))))
    {
      element = null;
    }
    return element;
}


/**
GetEventTarget
**************
Returns the element on wich an event occured.

Parameters:
 event: a DOM event object.

*/
function GetEventTarget(event)
{
    var element = null;
    if (window.event) // IE
    {
        element = window.event.srcElement;
        element = GetInputBlock(element);
    }
    else // W3C
    {
        element = this;
        // check if event was fired by the window
        if (window == element)
        {
            element = event.target;
            element = GetInputBlock(element);
        }
    }
    return element;
}


/**
OnMouseDownInput
****************
Capture onmousedown events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnMouseDownInput(event)
{
    var element = GetEventTarget(event);
    if (window.event) // IE
    {
        event = window.event;
        event.returnValue = false;
    }

    // find associated checkbox
    var input_checkboxes = element.getElementsByTagName("input");
    // check if we found it
    if (input_checkboxes && (0 < input_checkboxes.length))
    {
        // check if not disabled
        if (false == input_checkboxes.item(0).disabled)
        {
            // not disabled
            // check if checked
            if (input_checkboxes.item(0).checked)
            {
                // checked
                if ("radio" == input_checkboxes.item(0).type)
                {
                    element.className = "radio radio_active_checked";
                }
                else if ("checkbox" == input_checkboxes.item(0).type)
                {
                    element.className = "checkbox checkbox_active_checked";
                }
            }
            else
            {
                // not checked
                if ("radio" == input_checkboxes.item(0).type)
                {
                    element.className = "radio radio_active";
                }
                else if ("checkbox" == input_checkboxes.item(0).type)
                {
                    element.className = "checkbox checkbox_active";
                }
            }
            element.mousetrack = true;
        }
    }
}


/**
OnMouseUpInput
****************
Capture onmouseup events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnMouseUpInput(event)
{
    var element = GetEventTarget(event);
    if (window.event) // IE
    {
        event = window.event;
        event.returnValue = false;
    }
    // find associated checkbox
    var input_checkboxes = element.getElementsByTagName("input");
    // check if we found it
    if (input_checkboxes && (0 < input_checkboxes.length))
    {
        // check if not disabled
        if (false == input_checkboxes.item(0).disabled)
        {
            // not disabled
            // check if checked
            if (input_checkboxes.item(0).checked)
            {
                // checked
                if ("radio" == input_checkboxes.item(0).type)
                {
                    element.className = "radio radio_checked";
                }
                else if ("checkbox" == input_checkboxes.item(0).type)
                {
                    element.className = "checkbox checkbox_checked";
                }
            }
            else
            {
                // not checked
                if ("radio" == input_checkboxes.item(0).type)
                {
                    element.className = "radio radio_unchecked";
                }
                else if ("checkbox" == input_checkboxes.item(0).type)
                {
                    element.className = "checkbox checkbox_unchecked";
                }
            }
            element.mousetrack = false;
        }
    }
}


/**
OnMouseOverInput
****************
Capture onmouseover events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnMouseOverInput(event)
{
    var element = GetEventTarget(event);
    if (window.event) // IE
    {
        event = window.event;
        // event.returnValue = false;
    }
    if (element.mousetrack)
    {
        // find associated checkbox
        var input_checkboxes = element.getElementsByTagName("input");
        // check if we found it
        if (input_checkboxes && (0 < input_checkboxes.length))
        {
            // check if not disabled
            if (false == input_checkboxes.item(0).disabled)
            {
                // not disabled
                // check if checked
                if (input_checkboxes.item(0).checked)
                {
                    // checked
                    if ("radio" == input_checkboxes.item(0).type)
                    {
                        element.className = "radio radio_active_checked";
                    }
                    else if ("checkbox" == input_checkboxes.item(0).type)
                    {
                        element.className = "checkbox checkbox_active_checked";
                    }
                }
                else
                {
                    // not checked
                    if ("radio" == input_checkboxes.item(0).type)
                    {
                        element.className = "radio radio_active";
                    }
                    else if ("checkbox" == input_checkboxes.item(0).type)
                    {
                        element.className = "checkbox checkbox_active";
                    }
                }
            }
        }
    }
}


/**
OnMouseOutInput
****************
Capture onmouseout events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnMouseOutInput(event)
{
    var element = GetEventTarget(event);
    if (window.event) // IE
    {
        event = window.event;
        // event.returnValue = false;
    }
    if (element.mousetrack)
    {
        // find associated checkbox
        var input_checkboxes = element.getElementsByTagName("input");
        // check if we found it
        if (input_checkboxes && (0 < input_checkboxes.length))
        {
            // check if not disabled
            if (false == input_checkboxes.item(0).disabled)
            {
                // not disabled
                // check if checked
                if (input_checkboxes.item(0).checked)
                {
                    // checked
                    if ("radio" == input_checkboxes.item(0).type)
                    {
                        element.className = "radio radio_checked";
                    }
                    else if ("checkbox" == input_checkboxes.item(0).type)
                    {
                        element.className = "checkbox checkbox_checked";
                    }
                }
                else
                {
                    // not checked
                    if ("radio" == input_checkboxes.item(0).type)
                    {
                        element.className = "radio radio_unchecked";
                    }
                    else if ("checkbox" == input_checkboxes.item(0).type)
                    {
                        element.className = "checkbox checkbox_unchecked";
                    }
                }
            }
        }
    }
}


/**
OnClickInput
************
Capture onclick events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnClickInput(event)
{
    var element = GetEventTarget(event);
    if (window.event) // IE
    {
        event = window.event;
        event.returnValue = false;
    }
    // find associated checkbox
    var input_checkboxes = element.getElementsByTagName("input");
    // check if we found it
    if (input_checkboxes && (0 < input_checkboxes.length))
    {
        // check if not disabled
        if (false == input_checkboxes.item(0).disabled)
        {
            // not disabled
            // check if checked
            if ("radio" == input_checkboxes.item(0).type)
            {
                element.className = "radio";
                // check radio element
                input_checkboxes.item(0).checked = true;
                // uncheck others
                var radios_of_group = document.getElementsByName(input_checkboxes.item(0).name);
                for (var i = 0; radios_of_group.length > i; ++i)
                {
                    var input_block = GetInputBlock(radios_of_group[i]);
                    if (false == radios_of_group[i].disabled)
                    {
                          if (input_checkboxes.item(0) == radios_of_group[i])
                          {
                              radios_of_group[i].checked = true;
                              input_block.className = "radio radio_checked";
                          }
                          else
                          {
                              radios_of_group[i].checked = false;
                              input_block.className = "radio radio_unchecked";
                          }
                     }
                     else
             {
                          radios_of_group[i].checked = false;
                          input_block.className = "radio radio_disabled";
                     }
                }
            }
            else if ("checkbox" == input_checkboxes.item(0).type)
            {
                if (input_checkboxes.item(0).checked)
                {
                    // checked, uncheck!
                    input_checkboxes.item(0).checked = false;
                    element.className = "checkbox checkbox_unchecked";
                }
                else
                {
                    // not checked, check!
                    input_checkboxes.item(0).checked = true;
                    element.className = "checkbox checkbox_checked";
                }
            }
            element.mousetrack = false;
            // perform onclick event
            if (input_checkboxes.item(0).onclick)
            {
                input_checkboxes.item(0).onclick(event);
            }
        }
    }
    UpdateFormElements(); // requiered by IE 6
    return false;
}


/**
OnKeyDownInput
**************
Capture onkeydown events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnKeyDownInput(event)
{
    var keynum = 0;
    if (window.event) // IE
    {
        keynum = window.event.keyCode;
        event = window.event;
    }
    else if (event.which) // Netscape/Firefox/Opera
    {
        keynum = event.which;
    }
    // check for space
    if (32 == keynum)
    {
        OnMouseDownInput(event);
    }
}


/**
OnKeyUpInput
************
Capture onkeyup events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnKeyUpInput(event)
{
    var keynum = 0;
    if (window.event) // IE
    {
        keynum = window.event.keyCode;
        event = window.event;
    }
    else if (event.which) // Netscape/Firefox/Opera
    {
        keynum = event.which;
    }
    // check for space
    if (32 == keynum)
    {
        OnClickInput(event);
    }
}


/**
OnKeyPressInput
***************
Capture onkeypress events on custom radios and checkboxes.

Parameters:
 event: a DOM event object.

*/
function OnKeyPressInput(event)
{
    var keynum = 0;
    if (window.event) // IE
    {
        keynum = window.event.keyCode;
        event = window.event;
    }
    else if (event.which) // Netscape/Firefox/Opera
    {
        keynum = event.which;
    }
    // check for space
    if (32 == keynum)
    {
        return false;
    }
    return true;
}

AddOnLoadFunction(InitFormDisplay);
