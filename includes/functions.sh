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
# $?    0       OK
# $?    1       ERROR
copyFunction()
{
    requireParams RR "$@"
    
    eval "$(echo "$2"(); declare -f "$1" | tail -n +2;)"
    return $?
}

##
# Rename a function
#
# $1    string  current function name
# $2    string  new function name
# $?    0       OK
# $?    1       ERROR
renameFunction()
{
    requireParams RR "$@"
    
    copyFunction "$1" "$2" && unset -f "$1"
    return $?
}

##
# Add a prefix for each line.
#
# $1    string  prefix
# &0    string  input
# &1    string  prepared input
# $?    0       OK
# $?    1       ERROR
prepareOutput()
{
    requireParams R "$@"
    
    local msg
    while read msg; do echo "$1$msg"; done
    return 0
}

##
# Get a baacktrace to the current file.
#
# &1    string  files with line number per line
# $?    0       OK
# $?    1       ERROR
getBacktrace()
{    
    local res='1'
    local pos=0
    while [ -n "$res" ]; do
        res=$(caller "$pos")
        [ -n "$res" ] && echo "$pos: $res"
        ((pos++))
    done
    return 0
}

##
# Handle Errors
#
# exec 101>&1; (
#       COMANDS
# ) 2>&1 >&101 | handleError
#
# &0    string  error stream
handleError()
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
# &1    string  files with line number per line
signalErrBacktrace()
{
    [ "$BASHOR_ERROR_BACKTRACE" == 1 ] && \
        getBacktrace | tail -n +2  | sed 's#^#    #'
}
#trap 'signalErrBacktrace' ERR

##
# Error handler call
#
# $1    string  message
# $2    integer|null return value for exit default=1
# &3    string  error messages
# $?    0       OK
# $?    1       Use internal error handler
__handleError()
{
    return 1
}


##
# Internal error handler
#
# $1    string  message
# $2    integer|null return value for exit default=1
# &3    string  error messages
_bashor_handleError()
{
    : ${1:?}
    if [ -n "$BASHOR_ERROR" ]; then
        echo 'Error in error handling!' >&2
        exit 1
    fi
    local BASHOR_ERROR=ERROR;
    local BASHOR_BACKTRACE_REMOVE=$((BASHOR_BACKTRACE_REMOVE+2))
    
    __handleError "$@"
    [ "$?" = 0 ] && return 0
    
    local type="$1"
    local message="$2"
    local exit="${3-1}"
    local prefix=
    local backtrace=
    local showBacktrace=
    local showOutput=
    local doLog=
    local colorFG='red'
    local colorFGStyle='bold'
    
    case "$type" in
        error)
            prefix='ERROR: '
            showOutput="$BASHOR_ERROR_OUTPUT"
            showBacktrace="$BASHOR_ERROR_BACKTRACE"
            doLog="$BASHOR_ERROR_LOG"
            ;;
        warning)
            prefix='WARNING: '
            showOutput="$BASHOR_WARNING_OUTPUT"
            showBacktrace="$BASHOR_WARNING_BACKTRACE"
            doLog="$BASHOR_WARNING_LOG"
            colorFG='yellow'
            exit=
            ;;
        debug)
            prefix='DEBUG: '
            showOutput="$BASHOR_DEBUG_OUTPUT"
            showBacktrace="$BASHOR_DEBUG_BACKTRACE"
            doLog="$BASHOR_DEBUG_LOG"
            colorFG='white'
            exit=
            ;;
        *)
            prefix='ERROR: '
            showOutput="$BASHOR_ERROR_OUTPUT"
            showBacktrace="$BASHOR_ERROR_BACKTRACE"
            doLog="$BASHOR_ERROR_LOG"
            ;;
    esac
        
    [ "$showBacktrace" = 1 ] && backtrace=$(
        getBacktrace | tail -n +"$BASHOR_BACKTRACE_REMOVE"  | sed 's#^#    #'
    )
    
    if [ "$showOutput" = 1 ]; then
        loadClassOnce 'Bashor_Color'
        {
            echo "$message" | sed "s/^/$prefix/g"
            [ -n "$backtrace" ] && echo "$backtrace"
        } | class Bashor_Color fg '' "$colorFG" "$colorFGStyle" 1>&3
    fi
    
    if [ "$doLog" = 1 ]; then
        loadClassOnce "Bashor_Log"
        {
            echo "$message" | sed "s/^/$prefix/g"
            [ -n "$backtrace" ] && echo "$backtrace"
        } | class Bashor_Log error
    fi
    
    if [ -n "$exit" ]; then
        if [ "$BASHOR_ERROR_EXIT" = 1 ]; then
            exit "$exit"
        else
            trap '
                if ! [[ "$BASH_COMMAND" =~ ^return ]]; then
                    trap DEBUG;
                    return 1;
                fi
            ' DEBUG;
        fi
    else
        return 0
    fi
}

##
# error message
#
# $1    string  message
# $2    integer|null return value for exit default=1
# &3    string  error messages
error()
{
    requireParams R "$@"
    
    local BASHOR_BACKTRACE_REMOVE
    ((BASHOR_BACKTRACE_REMOVE++))
    _bashor_handleError error "$@"
}

##
# warning message
#
# $1    string  message
# &3    string  warning messages
warning()
{
    requireParams R "$@"
    
    local BASHOR_BACKTRACE_REMOVE
    ((BASHOR_BACKTRACE_REMOVE++))
    _bashor_handleError warning "$@"
}

##
# debug message
#
# $1    string  message
# &3    string  debug messages
debug()
{
    requireParams R "$@"
    
    local BASHOR_BACKTRACE_REMOVE
    ((BASHOR_BACKTRACE_REMOVE++))
    _bashor_handleError debug "$@"
}

##
# Isset a var | function
#
# $1    string  the type (var|function)
# $2    string  name
# $?    0       set
# $?    1       not set
isset()
{
    requireParams R "$@"
    
    case "$1" in
        var)
            requireParams RR "$@"
            issetVar "$2"
            return $?
            ;;
        function)
            requireParams RR "$@"
            issetFunction "$2"
            return $?
            ;;           
        *)
            error "\"$1\" is not a option of isset!"
            return 1
            ;;
    esac    
}

##
# Isset a var
#
# $1    string  name
# $?    0       set
# $?    1       not set
issetVar()
{   
    declare -p "$1" &>/dev/null
    return $? 
}

##
# Isset a function
#
# $1    string  name
# $?    0       set
# $?    1       not set
issetFunction()
{  
    declare -F "$1" &> /dev/null
    return $? 
}

##
# Check if's a value is in the array.
#
# $1    mixed   search
# $@    mixed   list of values
# $?    0       in list
# $?    1       not in list
inList()
{
    local value IFS=$'\n' search="$1"
    shift
    for value in "$@"; do
        [ "$search" == "$value" ] && return 0
    done
    return 1
}

encodeData()
{
    case "$BASHOR_BASE64_USE" in
        openssl)
            openssl enc -a -A
            ;;
        perl)
            local -x DATAIN
            local IFS=
            while read -d '' -r -n 300 DATAIN; do
                perl -MMIME::Base64 -e 'print encode_base64($ENV{"DATAIN"},"")'
            done
            if [ -n "$DATAIN" ]; then
                perl -MMIME::Base64 -e 'print encode_base64($ENV{"DATAIN"},"")'
            fi
            ;;
        *) #base64
            base64 -w 0
            ;;
    esac
}

decodeData()
{
    case "$BASHOR_BASE64_USE" in
        openssl)
            openssl enc -a -A -d
            ;;
        perl)
            perl -MMIME::Base64 -e 'print decode_base64(<stdin>)'
            ;;
        *) #base64
            base64 -d
            ;;
    esac
}

##
# Buffer a stream completly otherwise it will trow a error.
#
# &0    mixed   input
# &1    mixed   output
# $?    0       OK
# $?    1       ERROR
bufferStream()
{
    echo -n "$(cat -)"
    return $?
}

##
# Check if the Params are correct otherwise it will trow a error.
#
# Config String:
# R     Is set and not empty
# S     Is set
#
# Example: needParamCount 4 $#
#
# $1    string  Config String
# $@    mixed   All Params
# $?    0       OK
# $?    1       ERROR
requireParams()
{
    local config="$1"    
    if [ "$#" -le "${#config}" ]; then
        local paramCount="$#"
        error "$((++paramCount)): Parameter not set"
        return 1
    fi
    
    local current=0
    while shift; do
        case "${config:$current:1}" in
            R)
                if [ -z "$1" ]; then
                    ((current+1))
                    error "$current: Parameter empty but required"
                    return 1
                fi
                ;;
            S)
                ;;
            '')
                ;;
            *)
                local configSegment="${config:$current:1}"
                error "$configSegment = $current not allowd in config \"${config}\""
                return 1
                ;;
        esac
        ((current++))
    done
}

##
# Check if the Params are correct.
#
# Config String:
# R     Is set and not empty
# S     Is set
#
# Example: needParamCount 4 $#
#
# $1    string  Config String
# $@    mixed   All Params
# $?    0       OK
# $?    1       ERROR
checkParams()
{
    local config="$1"    
    if [ "$#" -le "${#config}" ]; then
        return 1
    fi
    
    local current=0
    while shift; do
        case "${config:$current:1}" in
            R)
                [ -z "$1" ] && return 1
                ;;
            S)
                ;;
            '')
                ;;
            *)
                return 1
                ;;
        esac
        ((current++))
    done
    
    return 0
}

. "$BASHOR_PATH_INCLUDES/functions/class.sh"

# load opt function
if [ "$BASHOR_USE_GETOPT" == 1 ]; then
    . "$BASHOR_PATH_INCLUDES/functions/getopt.sh"
else
    . "$BASHOR_PATH_INCLUDES/functions/getopts.sh"
fi
