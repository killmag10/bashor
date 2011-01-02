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
# @subpackage   Includes
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Load function files.
#
# $1    string  namespace
# $?    0:OK    1:ERROR
function loadFunctions()
{
    : ${1:?}
    
    if [ -n "$1" ]; then
        local nsFile=`echo "$1" | tr '_' '/'`
        local IFS=`echo -e "\r\n"`
        local filename
        for dn in $BASHOR_PATHS_FUNCTIONS; do
            filename="$dn/""$nsFile"'.sh'
            if [ -f "$filename" ]; then
                . "$filename"
                return $?
            fi
        done
    fi
    
    return 1
}

##
# Copy a function
#
# $1    string  current function name
# $2    string  new function name
# $?    0:OK    1:ERROR
function copyFunction()
{
    : ${1:?}
    : ${2:?}
    
    local tmp=`echo "function $2"; declare -f "$1" | tail -n +2;`
    eval "$tmp"
    return 0
}

##
# Rename a function
#
# $1    string  current function name
# $2    string  new function name
# $?    0:OK    1:ERROR
function renameFunction()
{
    : ${1:?}
    : ${2:?}
    
    copyFunction "$1" "$2"
    unset "$1"
    return 0
}

##
# Check if function exists.
#
# $1    string  function name
# $?    0:TRUE  1:FALSE
function functionExists()
{
    declare -f "$1" > /dev/null
    return $?
}

##
# Add a prefix for each line.
#
# $1    string  prefix
function prepareOutput()
{
    : ${1:?}
    
    local IFS=$'\n\r'
    local msg
    while read msg; do echo "$1$msg"; done
}

##
# Get the backtrace.
#
function getBacktrace()
{    
    local res='1'
    local pos=0
    while [ -n "$res" ]; do
        local res=`caller "$pos"`
        [ -n "$res" ] && echo "$pos: $res"
        ((pos++))
    done
    [ -n "$res" ]
    return $?
}

##
# Handle Errors
#
# exec 102>&1; (
#       COMANDS
# ) 2>&1 >&102 | handleError
#
# &0    string  error stream
function handleError()
{    
    [ $BASHOR_ERROR_OUTPUT == 1 ] && loadClass "Bashor_Color"
    [ $BASHOR_ERROR_LOG == 1 ] && loadClass "Bashor_Log"
    local pre='ERROR: '
    while read msg; do
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`
        if [ $BASHOR_ERROR_OUTPUT == 1 ]; then
            msgOut=`echo "$msg" | sed "s/^/$pre/g"`
            [ $BASHOR_ERROR_BACKTRACE == 1 ] \
                && local msgOut="$msgOut""$nl""$trace"
            echo "$msgOut" | class Bashor_Color fg '' 'red' 'bold'
        fi
        if [ $BASHOR_ERROR_LOG == 1 ]; then
            msgLog="$msg"
            [ $BASHOR_ERROR_BACKTRACE == 1 ] \
                && local msgLog="$msgOut""$nl""$trace"
            echo "$msgLog" | class Bashor_Log error
        fi
        [ -n "$1" ] && exit "$1"
    done
}

##
# Backtrace for error signal
function signalErrBacktrace()
{
    [ "$BASHOR_ERROR_BACKTRACE" == 1 ] && \
        getBacktrace | tail -n +2  | sed 's#^#    #'
}
trap 'signalErrBacktrace' ERR

##
# error message
#
# $1    message
# $2?   status
function error()
{
    : ${1:?}
    
    local pre='ERROR: '
    local msg="$1"
    [ $BASHOR_ERROR_BACKTRACE == 1 ] \
        && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`
    if [ $BASHOR_ERROR_OUTPUT == 1 ]; then
        loadClassOnce "Bashor_Color"
        msgOut=`echo "$msg" | sed "s/^/$pre/g"`
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$nl""$trace"
        echo "$msgOut" | class Bashor_Color fg '' 'red' 'bold' 1>&3
    fi
    if [ $BASHOR_ERROR_LOG == 1 ]; then
        loadClassOnce "Bashor_Log"
        msgLog="$msg"
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$nl""$trace"
        echo "$msgLog" | class Bashor_Log error
    fi
    exit ${2:-1}
}

##
# warning message
#
# $1    message
function warning()
{
    : ${1:?}
    
    local pre='WARNING: '
    local msg="$1"
    [ $BASHOR_WARNING_BACKTRACE == 1 ] \
        && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`
    if [ $BASHOR_WARNING_OUTPUT == 1 ]; then
        loadClassOnce "Bashor_Color"
        
        msgOut=`echo "$msg" | sed "s/^/$pre/g"`
        [ $BASHOR_WARNING_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$nl""$trace"
        echo "$msgOut" | class Bashor_Color fg '' 'yellow' 'bold' 1>&3
    fi
    if [ $BASHOR_WARNING_LOG == 1 ]; then
        loadClassOnce "Bashor_Log"
        msgLog="$msg"
        [ $BASHOR_WARNING_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$nl""$trace"
        echo "$msgLog" | class Bashor_Log warning
    fi
}

##
# debug message
#
# $1    message
function debug()
{
    : ${1:?}
    
    local pre='DEBUG: '
    local msg="$1"
    [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
        && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`
    if [ $BASHOR_DEBUG_OUTPUT == 1 ]; then
        loadClassOnce "Bashor_Color"
        msgOut=`echo "$msg" | sed "s/^/$pre/g"`
        [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$nl""$trace"
        echo "$msgOut" | class Bashor_Color fg '' 'white' 'bold' 1>&3
    fi
    if [ $BASHOR_DEBUG_LOG == 1 ]; then
        loadClassOnce "Bashor_Log"
        msgLog="$msg"
        [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$nl""$trace"
        echo "$msgLog" | class Bashor_Log debug
    fi
}

function bufferStream()
{
    local tmp=`cat -`
    echo -n "$tmp"
    return $?
}

. "$BASHOR_PATH_INCLUDES/functions/class.sh"

# load opt function
if [ "$BASHOR_USE_GETOPT" == 1 ]; then
    . "$BASHOR_PATH_INCLUDES/functions/getopt.sh"
else
    . "$BASHOR_PATH_INCLUDES/functions/getopts.sh"
fi
