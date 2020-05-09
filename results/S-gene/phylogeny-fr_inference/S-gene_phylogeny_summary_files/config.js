/**
*******************************************************************************
* config.js
***************
Version: 0.10.8
Date:    07/04/2008
Author:  Alexis Dereeper, Valentin Guignon

Contains configuration constants.

*******************************************************************************
*/


/**
*******************************************************************************
* Global Constants
*******************
*/


/**
* ATV
******
*/
// applet URL
var ATV_URL                  = APPLETS_PATH + "/atv/";
var ATV_ARCHIVE              = "forester.jar";
// config url
var CONF_FILE_URL            = APPLETS_PATH + "/atv/ATVconfig.conf";
var CONF_FILE_NO_LENGTH_URL  = APPLETS_PATH + "/atv/ATVconfigNoLength.conf";


/**
* Dynamic Tree Editing
***********************
*/
var DYNAMIC_TREE_RESULT_URL      = CGI_PATH + "/get_result.cgi";
var DYNAMIC_TREE_EDITING_URL     = CGI_PATH + "/get_dynamic_tree.cgi";
var INTERACTIVE_TREE_EDITING_URL = CGI_PATH + "/displayRearrangedTree.cgi";


/**
* BLAST
********
*/
var BLAST_GUIDE_TREE_URL     = CGI_PATH + "/get_blast_guide_tree.cgi";
var ONECLICK_URL             = CGI_PATH + "/simple_phylogeny.cgi";
var ADVANCED_URL             = CGI_PATH + "/advanced.cgi";

/**
* ALIGNMENT
********
*/
var ALIGNMENT_GUIDE_TREE_URL     = CGI_PATH + "/get_alignment_guide_tree.cgi";



