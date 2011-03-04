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
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Copy a function
#
# $1    string  current function name
# $2    string  new function name
# $?    0:OK    1:ERROR
function copyFunction()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    eval "$(echo "function $2"; declare -f "$1" | tail -n +2;)"
    return $?
}

##
# Rename a function
#
# $1    string  current function name
# $2    string  new function name
# $?    0:OK    1:ERROR
function renameFunction()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    copyFunction "$1" "$2" && unset -f "$1"
    return $?
}

##
# Add a prefix for each line.
#
# $1    string  prefix
function prepareOutput()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    local msg IFS=$'\n\r'
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
        res=$(caller "$pos")
        [ -n "$res" ] && echo "$pos: $res"
        ((pos++))
    done
    [ -n "$res" ]
    return $?
}

##
# Handle Errors
#
# exec 101>&1; (
#       COMANDS
# ) 2>&1 >&101 | handleError
#
# &0    string  error stream
function handleError()
{    
    [ $BASHOR_ERROR_OUTPUT == 1 ] && loadClassOnce "Bashor_Color"
    [ $BASHOR_ERROR_LOG == 1 ] && loadClassOnce "Bashor_Log"
    local pre='ERROR: '
    while read msg; do
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local trace=$(getBacktrace | tail -n +2  | sed 's#^#    #')
        if [ $BASHOR_ERROR_OUTPUT == 1 ]; then
            msgOut=$(echo "$msg" | sed "s/^/$pre/g")
            [ $BASHOR_ERROR_BACKTRACE == 1 ] \
                && local msgOut="$msgOut""$NL""$trace"
            echo "$msgOut" | class Bashor_Color fg '' 'red' 'bold'
        fi
        if [ $BASHOR_ERROR_LOG == 1 ]; then
            msgLog="$msg"
            [ $BASHOR_ERROR_BACKTRACE == 1 ] \
                && local msgLog="$msgOut""$NL""$trace"
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
    if [ -n "$BASHOR_ERROR" ]; then
        echo 'Error in error handling!' >&2
        exit 1
    fi
    local BASHOR_ERROR=ERROR;
    
    local pre='ERROR: '
    local msg="$1"
    [ $BASHOR_ERROR_BACKTRACE == 1 ] \
        && local trace=$(getBacktrace | tail -n +2  | sed 's#^#    #')
    if [ $BASHOR_ERROR_OUTPUT == 1 ]; then
        loadClassOnce "Bashor_Color"
        msgOut=$(echo "$msg" | sed "s/^/$pre/g")
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$NL""$trace"
        echo "$msgOut" | class Bashor_Color fg '' 'red' 'bold' 1>&3
    fi
    if [ $BASHOR_ERROR_LOG == 1 ]; then
        loadClassOnce "Bashor_Log"
        msgLog="$msg"
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$NL""$trace"
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
        && local trace=$(getBacktrace | tail -n +2  | sed 's#^#    #')
    if [ $BASHOR_WARNING_OUTPUT == 1 ]; then
        loadClassOnce "Bashor_Color"
        
        msgOut=$(echo "$msg" | sed "s/^/$pre/g")
        [ $BASHOR_WARNING_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$NL""$trace"
        echo "$msgOut" | class Bashor_Color fg '' 'yellow' 'bold' 1>&3
    fi
    if [ $BASHOR_WARNING_LOG == 1 ]; then
        loadClassOnce "Bashor_Log"
        msgLog="$msg"
        [ $BASHOR_WARNING_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$NL""$trace"
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
        && local trace=$(getBacktrace | tail -n +2  | sed 's#^#    #')
    if [ $BASHOR_DEBUG_OUTPUT == 1 ]; then
        loadClassOnce "Bashor_Color"
        msgOut=$(echo "$msg" | sed "s/^/$pre/g")
        [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$NL""$trace"
        echo "$msgOut" | class Bashor_Color fg '' 'white' 'bold' 1>&3
    fi
    if [ $BASHOR_DEBUG_LOG == 1 ]; then
        loadClassOnce "Bashor_Log"
        msgLog="$msg"
        [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$NL""$trace"
        echo "$msgLog" | class Bashor_Log debug
    fi
}

##
# Isset a var | function
#
# $1    type
# $2    name
function isset()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    case "$1" in
        var)
            [ -z "$2" ] && error '2: Parameter empty or not set'
            declare -p "$2" 2>/dev/null > /dev/null
            return $?
            ;;
        function)
            [ -z "$2" ] && error '2: Parameter empty or not set'
            declare -F "$2" > /dev/null
            return $?
            ;;           
        *)
            error "\"$1\" is not a option of isset!"
            return 1
            ;;
    esac    
}

function bufferStream()
{
    echo -n "$(cat -)"
    return $?
}

function getBashorVersion()
{
    echo '1.0.0'
    return 0
}

. "$BASHOR_PATH_INCLUDES/functions/class.sh"

# load opt function
if [ "$BASHOR_USE_GETOPT" == 1 ]; then
    . "$BASHOR_PATH_INCLUDES/functions/getopt.sh"
else
    . "$BASHOR_PATH_INCLUDES/functions/getopts.sh"
fi
