#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

##
# Error handler
#
# $1    string  type
# $2    string  message
# $3    integer|null return value for exit default=1
# $4    string      Backtrace
# &3    string  error messages
CLASS_Bashor_ErrorHandler_handle()
{
    requireParams SSSS "$@"

    local type="$1"
    local message="$2"
    local exit="${3-1}"
    local backtrace="$4"
    local prefix=
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
    
    if [ "$showBacktrace" = 1 ]; then
        backtrace=$(
            printf '%s' "$backtrace" | sed 's#^#    #'
        )
    else
        backtrace=
    fi

    if [ "$showOutput" = 1 ]; then
        loadClassOnce 'Bashor_Color'
        {
            printf '%s\n' "$message" | sed "s/^/$prefix/g"
            [ -n "$backtrace" ] && printf '%s\n' "$backtrace"
        } | class Bashor_Color fg '' "$colorFG" "$colorFGStyle" 1>&3
    fi
    
    if [ "$doLog" = 1 ]; then
        loadClassOnce "Bashor_Log"
        local log
        class Bashor_Log getDefault log
        {
            printf '%s\n' "$message" | sed "s/^/$prefix/g"
            [ -n "$backtrace" ] && printf '%s\n' "$backtrace"
        } | object "$log" error
    fi
    
    if [ -n "$exit" ]; then
        if [ "$BASHOR_INTERACTIVE" = 1 ]; then
            trap '
                while [ "${#FUNCNAME[@]}" -gt 0 ]; do
                    return '\'"$exit"\'';
                done                
                trap DEBUG;
                '"$(trap -p DEBUG)"'
            ' DEBUG;
        else
            exit "$exit"
        fi
    else
        return 0
    fi
}

##
# Handle errors from error stream
#
# exec 101>&1; (
#       COMANDS
# ) 2>&1 >&101 | handleError
#
# $1    integer|null return value for exit, null no exit
# &0    string  error stream
CLASS_Bashor_ErrorHandler_handleStream()
{    
    [ "$BASHOR_ERROR_OUTPUT" = 1 ] && loadClassOnce "Bashor_Color"
    [ "$BASHOR_ERROR_LOG" = 1 ] && loadClassOnce "Bashor_Log"
    local pre='ERROR: '
    while read msg; do
        [ "$BASHOR_ERROR_BACKTRACE" = 1 ] \
            && local trace=$(getBacktrace | tail -n +2  | sed 's#^#    #')
        if [ "$BASHOR_ERROR_OUTPUT" = 1 ]; then
            msgOut=$(printf '%s' "$msg" | sed "s/^/$pre/g")
            [ "$BASHOR_ERROR_BACKTRACE" = 1 ] \
                && local msgOut="$msgOut""$NL""$trace"
            printf '%s' "$msgOut" | class Bashor_Color fg '' 'red' 'bold'
        fi
        if [ "$BASHOR_ERROR_LOG" = 1 ]; then
            local log
            class Bashor_Log getDefault log
            msgLog="$msg"
            [ "$BASHOR_ERROR_BACKTRACE" = 1 ] \
                && local msgLog="$msgOut""$NL""$trace"
            printf '%s' "$msgLog" | object "$log" error
        fi
        [ -n "$1" ] && exit "$1"
    done
}


##
# Set error handler
CLASS_Bashor_ErrorHandler_setHandler()
{
    eval '
        __handleError(){
            class Bashor_ErrorHandler handle "$@"
            return $?
        }
    '
}
