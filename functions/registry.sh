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

export BASHOR_FUNCTION_REGISTRY_FILE="$BASHOR_REGISTRY_FILE";
if [ -n "$1" ]; then
    export BASHOR_FUNCTION_REGISTRY_FILE="$1";
fi

##
# Save in registry.
#
# $1    string  Id
# $2    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
function registry_set()
{
    if [ -p /dev/stdin ]; then
        local value=`cat -`;
    else
        local value="$2";
    fi
    
    loadFunctions 'lock';
    local lockFile=`lock_filename '$BASHOR_FUNCTION_REGISTRY_FILE'`;
    
    {
        flock 200;
        
        local key=`echo "$1" | base64 -w 0`;
        local value=`echo "$value" | base64 -w 0`;
        
        touch "$BASHOR_FUNCTION_REGISTRY_FILE";     
        local data=`cat "$BASHOR_FUNCTION_REGISTRY_FILE"`;
        local data=`echo "$data" | sed "s#^${key}\s\+.*##"`;
        local data=`echo "$key $value"; echo -n "$data";`;
        echo "$data" | sort -u > "$BASHOR_FUNCTION_REGISTRY_FILE";
    } 200>"$lockFile";
    lock_delete "$lockFile";
    
    return "$?"
}

##
# Remove data from registry.
#
# $1    string  Id
# $?    0:OK    1:ERROR
function registry_remove()
{       
    loadFunctions 'lock';
    local lockFile=`lock_filename '$BASHOR_FUNCTION_REGISTRY_FILE'`;
    local key=`echo "$1" | base64 -w 0`;
    
    if [ -f "$BASHOR_FUNCTION_REGISTRY_FILE" ]; then
        {
            flock 200;
            
            cat "$BASHOR_FUNCTION_REGISTRY_FILE" \
                | sed "s#^${key}\s\+.*##" \
                | sort -u > "$BASHOR_FUNCTION_REGISTRY_FILE";
        } 200>"$lockFile";
        lock_delete "$lockFile";
        
        return "$?"
    fi
}

##
# Read from registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function registry_get()
{
    if [ -f "$BASHOR_FUNCTION_REGISTRY_FILE" ]; then
        local key=`echo "$1" | base64`;
        local res=`grep "^$key " "$BASHOR_FUNCTION_REGISTRY_FILE"`;
        if [ -n "$res" ]; then
            echo "$res" | sed 's#\S\+\s\+##' | base64 -d;
            return 0;
        else
            return 1;
        fi
    fi
    
    return 1;
}

##
# Isset in registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function registry_isset()
{
    if [ -f "$BASHOR_FUNCTION_REGISTRY_FILE" ]; then
        local key=`echo "$1" | base64`;
        local res=`grep "^$key " "$BASHOR_FUNCTION_REGISTRY_FILE"`
        if [ -n "$res" ]; then
            return 0;
        else
            return 1;
        fi
    fi
    
    return 1;
}
