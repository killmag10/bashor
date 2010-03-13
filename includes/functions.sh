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
# @subpackage   Includes
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
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
    : ${1:?};
    
    if [ -n "$1" ]; then
        local filename="$BASHOR_DIR_FUNCTIONS/""$1"'.sh';
        if [ -f "$filename" ]; then
            shift;
            . "$filename" "$@";
            return 0;
        fi
    fi
    
    return 1;
}

##
# Copy a function
#
# $1    string  current function name
# $2    string  new function name
# $?    0:OK    1:ERROR
function copyFunction()
{
    : ${1:?};
    : ${2:?};
    
    local tmp=`echo "function $2"; declare -f "$1" | tail -n +2;`;
    eval "$tmp";
    return 0;
}

##
# Rename a function
#
# $1    string  current function name
# $2    string  new function name
# $?    0:OK    1:ERROR
function renameFunction()
{
    : ${1:?};
    : ${2:?};
    
    copyFunction "$1" "$2";
    unset "$1";
    return 0;
}

##
# Add a prefix for each line.
#
# $1    string  prefix
function prepareOutput()
{
    : ${1:?};
    
    local IFS_BAK=$IFS;
    local IFS=`echo -e "\n\r"`;
    while read msg; do echo "$1$msg"; done
    local IFS="$IFS_BAK";
}

##
# Get the backtrace.
#
function getBacktrace()
{    
    local res=1;
    local pos=0;
    while caller "$pos"; do        
        ((pos++));
        local res=0;
    done
    return "$res";
}

##
# Handle Errors
#
# exec 3>&1; (
#       COMANDS
# ) 2>&1 >&3 | handleError;
#
# &0    string  error stream
function handleError()
{    
    [ $BASHOR_ERROR_OUTPUT == 1 ] && loadFunctions "color";
    [ $BASHOR_ERROR_LOG == 1 ] && loadFunctions "log";
    local pre='ERROR: ';
    while read msg; do 
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`;
        if [ $BASHOR_ERROR_OUTPUT == 1 ]; then
            msgOut=`echo "$msg" | sed "s/^/$pre/g"`;
            [ $BASHOR_ERROR_BACKTRACE == 1 ] \
                && local msgOut="$msgOut""$nl""$trace";
            echo "$msgOut" | color_fg '' 'red' 'bold';
        fi
        if [ $BASHOR_ERROR_LOG == 1 ]; then
            msgLog="$msg";
            [ $BASHOR_ERROR_BACKTRACE == 1 ] \
                && local msgLog="$msgOut""$nl""$trace";
            echo "$msgLog" | log_error;
        fi
    done
}

##
# error message
#
# $1    message
function error()
{
    local pre='ERROR: ';
    local msg="$1";
    [ $BASHOR_ERROR_BACKTRACE == 1 ] \
        && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`;
    if [ $BASHOR_ERROR_OUTPUT == 1 ]; then
        loadFunctions "color";
        msgOut=`echo "$msg" | sed "s/^/$pre/g"`;
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$nl""$trace";
        echo "$msgOut" | color_fg '' 'red' 'bold';
    fi
    if [ $BASHOR_ERROR_LOG == 1 ]; then
        loadFunctions "log";
        msgLog="$msg";
        [ $BASHOR_ERROR_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$nl""$trace";
        echo "$msgLog" | log_error;
    fi
}

##
# warning message
#
# $1    message
function warning()
{
    local pre='WARNING: ';
    local msg="$1";
    [ $BASHOR_WARNING_BACKTRACE == 1 ] \
        && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`;
    if [ $BASHOR_WARNING_OUTPUT == 1 ]; then
        loadFunctions "color";
        msgOut=`echo "$msg" | sed "s/^/$pre/g"`;
        [ $BASHOR_WARNING_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$nl""$trace";
        echo "$msgOut" | color_fg '' 'yellow' 'bold';
    fi
    if [ $BASHOR_WARNING_LOG == 1 ]; then
        loadFunctions "log";
        msgLog="$msg";
        [ $BASHOR_WARNING_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$nl""$trace";
        echo "$msgLog" | log_error;
    fi
}

##
# debug message
#
# $1    message
function debug()
{
    local pre='DEBUG: ';
    local msg="$1";
    [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
        && local trace=`getBacktrace | tail -n +2  | sed 's#^#    #'`;
    if [ $BASHOR_DEBUG_OUTPUT == 1 ]; then
        loadFunctions "color";
        msgOut=`echo "$msg" | sed "s/^/$pre/g"`;
        [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
            && local msgOut="$msgOut""$nl""$trace";
        echo "$msgOut" | color_fg '' 'white' 'bold';
    fi
    if [ $BASHOR_DEBUG_LOG == 1 ]; then
        loadFunctions "log";
        msgLog="$msg";
        [ $BASHOR_DEBUG_BACKTRACE == 1 ] \
            && local msgLog="$msgOut""$nl""$trace";
        echo "$msgLog" | log_error;
    fi
}

# load opt function
if [ "$BASHOR_USE_GETOPT" == 1 ]; then
    . "$BASHOR_DIR_INCLUDES/functions/getopt.sh";
else
    . "$BASHOR_DIR_INCLUDES/functions/getopts.sh";
fi
