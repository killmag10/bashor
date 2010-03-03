#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Write a message to log
#
# -     string  Text
function log_Stream()
{
	cat - >> "$BASHOR_FILE_LOG";
}

##
# Log a error message
#
# -     string  Text
function log_ErrorStream()
{
	datestring=`date +'%Y-%m-%d %H:%M:%S'`;
	nl | sed "s#^#$datestring ERROR: #" | log_Stream;
}

##
# Log a debug message
#
# -     string  Text
function log_DebugStream()
{
	datestring=`date +'%Y-%m-%d %H:%M:%S'`;
	nl | sed "s#^#$datestring DEBUG: #" | log_Stream;
}

##
# Log a error message
#
# $1    string  Text
function log_Error()
{
	echo "$1" | log_ErrorStream;
}

##
# Log a debug message
#
# $1    string  Text
function log_Debug()
{
	echo "$1" | log_DebugStream;
}
