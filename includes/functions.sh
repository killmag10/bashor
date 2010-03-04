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
# $1    string  filename
# $?    0:OK    1:ERROR
function loadFunctions()
{
    if [ -n "$1" ]; then
        local filename="$BASHOR_DIR_FUNCTIONS/""$1"'.sh';
        if [ -f "$filename" ]; then
            shift;
            . "$filename" $*;
            return 0;
        fi
    fi
    
    return 1;
}

##
# Check if argument exists
#
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function optIsset()
{    
    local OPTIND='1';    
    local pArgs=`echo $ARGS | sed 's#^[^-]*##'`;
    while getopts "$OPTS" key $pArgs
    do
        if [ "$key" == "$1" ]; then
            echo "";
            #return 0;
        fi
    done
    
    return 1;
}

##
# Get argument value
#
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function optValue()
{    
    local OPTIND='1';    
    local pArgs=`echo $ARGS | sed 's#^[^-]*##'`;
    while getopts "$OPTS" key $pArgs
    do
        if [ "$key" == "$1" ]; then
            echo "$OPTARG";
            return 0;
        fi
    done
    
    return 1;
}

##
# Get argument keys
#
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $?    0:OK    1:ERROR
function optKeys()
{
    local OPTIND='1';    
    local pArgs=`echo $ARGS | sed 's#^[^-]*##'`;
    while getopts "$OPTS" key $pArgs
    do
        echo "$key";
    done
    
    return 0;
}

##
# Get argument keys and valus seperate by :
#
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $?    0:OK    1:ERROR
function optList()
{
    local OPTIND='1';    
    local pArgs=`echo $ARGS | sed 's#^[^-]*##'`;
    while getopts "$OPTS" key $pArgs
    do
        echo "$key:$OPTARG";
    done
    
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
    local tmp=`echo "function $2"; declare -f "$1" | tail -n +2;`;
    eval "$tmp";
    unset "$1";
    return 0;
}

##
# Add a prefix for each line.
#
# $1    string  prefix
function prepareOutput()
{
    IFS_BAK=$IFS;
    IFS="
";
    while read msg; do echo "$1$msg"; done
    IFS="$IFS_BAK";
}

##
# Add a prefix for each line.
#
# exec 3>&1; (
#       COMANDS
# ) 2>&1 >&3 | handleError;
#
# -     string  error stream
function handleError()
{
    loadFunctions "format";
    loadFunctions "log";
    local pre='ERROR: ';
    if [ -n "$1" ]; then
        local pre="$1";
    fi
    while read msg; do
        echo "$msg" | sed "s/^/$pre/g" | color_FGText 'red';
        echo "$msg" | log_ErrorStream;
    done
}
