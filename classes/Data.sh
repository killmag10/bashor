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
# @subpackage   Class
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

##
# On Load
function CLASS_Data__load()
{
    this set data '';
}

##
# Constructor
function CLASS_Data__construct()
{
    this set data '';
}

##
# Set data.
#
# $1    string  Id
# $2    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
function CLASS_Data_set()
{
    : ${1:?};
    : ${2?};
    
    if [ -p /dev/stdin ]; then
        local value=`cat -`;
    else
        local value="$2";
    fi
            
    local key=`echo "$1" | base64 -w 0`;
    local value=`echo "$value" | base64 -w 0`;
    local data=`this get data`;
    local data=`echo "$data" | sed "s#^${key}\s\+.*##"`;
    local data=`echo "$key $value"; echo -n "$data";`;
    local data=`echo "$data" | sort -u;`;
    this set data "$data";

    return "$?"
}

##
# Remove data.
#
# $1    string  Id
# $?    0:OK    1:ERROR
function CLASS_Data_remove()
{
    : ${1:?};
    
    local key=`echo "$1" | base64 -w 0`;
    local data=`this get data`;
    local data=`echo "$data" \
        | sed "s#^${key}\s\+.*##" \
        | sort -u`;
    this set data "$data";
    
    return "$?"
}

##
# Get data.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Data_get()
{
    : ${1:?};
    
    local key=`echo "$1" | base64`;
    local data=`this get data`;
    local res=`echo "$data" | grep "^$key "`;
    if [ -n "$res" ]; then
        echo "$res" | sed 's#\S\+\s\+##' | base64 -d;
        return 0;
    fi
    
    return 1;
}

##
# Isset data.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Data_isset()
{
    : ${1:?};
    
    local key=`echo "$1" | base64`;
    local data=`this get data`;
    local res=`echo "$data" | grep "^$key "`;
    if [ -n "$res" ]; then
        return 0;
    fi
    
    return 1;
}
