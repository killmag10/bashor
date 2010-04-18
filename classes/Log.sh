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
# @version      $Id: log.sh 10 2010-03-11 21:38:44Z lars $
################################################################################

##
# Constructor
#
# $1    string  log file
function CLASS_Log___load()
{
    if [ -n "$1" ]; then
        this set file "$1";
    else
        this set file "$BASHOR_LOG_FILE";
    fi
}

##
# Constructor
#
# $1    string  cache dir
function CLASS_Log___construct()
{
    : ${1?};
    
    this set file "$1";
}

##
# Write a message to log
#
# $1    string  Text
# &0    string  Text
function CLASS_Log_log()
{
    local logFile=`this get file`;
    
    if [ -p "/dev/stdin" ]; then
        cat - >> "$logFile";
    else
        echo "$1" >> "$logFile";
    fi
}

##
# Get the log content.
#
# $1    string  Text
# &0    string  Text
function CLASS_Log_get()
{
    local logFile=`this get file`;
    
    if [ -f "$logFile" ]; then
        cat "$logFile";
        return "$?";
    fi
    
    return 1;
}

##
# Remove the log.
#
# $1    string  Text
# &0    string  Text
function CLASS_Log_remove()
{
    local logFile=`this get file`;
    
    if [ -f "$logFile" ]; then
        rm "$logFile";
        return "$?";
    fi
    
    return 1;
}

##
# Log a error message
#
# $1    string  Text
# &0    string  Text
function CLASS_Log_error()
{
    datestring=`date +'%Y-%m-%d %H:%M:%S'`;
    if [ -p "/dev/stdin" ]; then
        nl | sed "s#^#$datestring ERROR: #" | this call log;
    else
        echo "$1" | nl | sed "s#^#$datestring ERROR: #" | this call log;
    fi
}

##
# Log a warning message
#
# $1    string  Text
# &0    string  Text
function CLASS_Log_warning()
{
    datestring=`date +'%Y-%m-%d %H:%M:%S'`;
    if [ -p "/dev/stdin" ]; then
        nl | sed "s#^#$datestring WARNING: #" | this call log;
    else
        echo "$1" | nl | sed "s#^#$datestring WARNING: #" | this call log;
    fi
}

##
# Log a debug message
#
# $1    string  Text
# &0    string  Text
function CLASS_Log_debug()
{
    datestring=`date +'%Y-%m-%d %H:%M:%S'`;
    if [ -p "/dev/stdin" ]; then
        nl | sed "s#^#$datestring DEBUG: #" | this call log;
    else
        echo "$1" | nl | sed "s#^#$datestring DEBUG: #" | this call log;
    fi

}
