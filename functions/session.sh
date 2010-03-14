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
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

if [ -z "$BASHOR_FUNCTION_SESSION_DATA" ]; then
    export BASHOR_FUNCTION_SESSION_DATA="";
fi

export BASHOR_FUNCTION_SESSION_SIZE="$BASHOR_SESSION_SIZE";
if [ -n "$2" ]; then
    export BASHOR_FUNCTION_SESSION_SIZE="$2";
fi

##
# Save in registry.
#
# $1    string  Id
# $2    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
function session_set()
{
    : ${1:?};
    
    if [ -p /dev/stdin ]; then
        local value=`cat -`;
    else
        local value="$2";
    fi
            
    local key=`echo "$1" | base64 -w 0`;
    if [ "$BASHOR_SESSION_COMPRESS" == 1 ]; then
        local value=`echo "$value" | gzip | base64 -w 0`;
    else
        local value=`echo "$value" | base64 -w 0`;
    fi
    local data="$BASHOR_FUNCTION_SESSION_DATA";
    local data=`echo "$data" | sed "s#^${key}\s\+.*##"`;
    local data=`echo "$key $value"; echo -n "$data";`;
    if [ "${#data}" -gt "$BASHOR_FUNCTION_SESSION_SIZE" ]; then
        warning "Max session memory overrun of $BASHOR_FUNCTION_SESSION_SIZE with ${#data}";
        return 1;
    fi
    local data=`echo "$data" | sort -u;`;
    export BASHOR_FUNCTION_SESSION_DATA="$data";

    return "$?"
}

##
# Remove data from registry.
#
# $1    string  Id
# $?    0:OK    1:ERROR
function session_remove()
{
    : ${1:?};
    
    local key=`echo "$1" | base64 -w 0`;
    export BASHOR_FUNCTION_SESSION_DATA=`echo "$BASHOR_FUNCTION_SESSION_DATA" \
        | sed "s#^${key}\s\+.*##" \
        | sort -u`;
    
    return "$?"
}

##
# Read from registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function session_get()
{
    : ${1:?};
    
    local key=`echo "$1" | base64`;
    local res=`echo "$BASHOR_FUNCTION_SESSION_DATA" | grep "^$key "`;
    if [ -n "$res" ]; then
        if [ "$BASHOR_SESSION_COMPRESS" == 1 ]; then
            echo "$res" | sed 's#\S\+\s\+##' | base64 -d | gzip -d;
        else
            echo "$res" | sed 's#\S\+\s\+##' | base64 -d;
        fi
        return 0;
    fi
    
    return 1;
}

##
# Isset in registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function session_isset()
{
    : ${1:?};
    
    local key=`echo "$1" | base64`;
    local res=`echo "$BASHOR_FUNCTION_SESSION_DATA" | grep "^$key "`
    if [ -n "$res" ]; then
        return 0;
    fi
    
    return 1;
}
