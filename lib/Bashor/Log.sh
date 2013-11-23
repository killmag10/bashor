#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Get the default logger.
#
# $1    string  instance var name
CLASS_Bashor_Log_getDefault()
{   
    if ! static isset instance; then
        local instanceDefault
        new "$CLASS_NAME" instanceDefault "$BASHOR_LOG_FILE"
        static set instanceDefault "$instanceDefault";
    fi
    eval "$1"'="$(static get instanceDefault)"';
    return $?;
}

##
# Constructor
#
# $1    string  cache dir
CLASS_Bashor_Log___construct()
{
    requireObject
    requireParams R "$@"
    
    this set file "$1"
}

##
# Write a message to log
#
# $1    string  Text
# &0    string  Text
CLASS_Bashor_Log_log()
{
    requireObject
    local logFile=`this get file`
    
    if [ -p "/dev/stdin" ] && [ -z "$1" ] && [ "$1" !=  "${1-null}" ]; then
        cat - >> "$logFile"
    else
        printf '%s\n' "$1" >> "$logFile"
    fi
}

##
# Get the log content.
#
# $1    string  Text
# &0    string  Text
CLASS_Bashor_Log_get()
{
    requireObject
    local logFile=`this get file`
    
    if [ -f "$logFile" ]; then
        cat "$logFile"
        return "$?"
    fi
    
    return 1
}

##
# Remove the log.
CLASS_Bashor_Log_remove()
{
    requireObject
    local logFile=`this get file`
    
    if [ -f "$logFile" ]; then
        rm "$logFile"
        return "$?"
    fi
    
    return 1
}

##
# Log a error message
#
# $1    string  Text
# &0    string  Text
CLASS_Bashor_Log_error()
{
    requireObject
    local datestring=`date +'%Y-%m-%d %H:%M:%S'`
    if [ -p "/dev/stdin" ] && [ -z "$1" ] && [ "$1" !=  "${1-null}" ]; then
        nl | sed "s#^#$datestring ERROR: #" | this call log
    else
        printf '%s' "$1" | nl | sed "s#^#$datestring ERROR: #" | this call log
    fi
}

##
# Log a warning message
#
# $1    string  Text
# &0    string  Text
CLASS_Bashor_Log_warning()
{    
    requireObject
    local datestring=`date +'%Y-%m-%d %H:%M:%S'`
    if [ -p "/dev/stdin" ] && [ -z "$1" ] && [ "$1" !=  "${1-null}" ]; then
        nl | sed "s#^#$datestring WARNING: #" | this call log
    else
        printf '%s' "$1" | nl | sed "s#^#$datestring WARNING: #" | this call log
    fi
}

##
# Log a debug message
#
# $1    string  Text
# &0    string  Text
CLASS_Bashor_Log_debug()
{   
    requireObject
    local datestring=`date +'%Y-%m-%d %H:%M:%S'`
    if [ -p "/dev/stdin" ] && [ -z "$1" ] && [ "$1" !=  "${1-null}" ]; then
        nl | sed "s#^#$datestring DEBUG: #" | this call log
    else
        printf '%s' | nl | sed "s#^#$datestring DEBUG: #" | this call log
    fi

}
