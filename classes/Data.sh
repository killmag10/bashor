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
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

##
# Constructor
#
# -s   integer session size (Default:65536)
# -c   compress
function CLASS_Data___load()
{
    this call __construct "$@";
}

##
# Constructor
#
# -s   integer session size (Default:65536)
# -c   compress
function CLASS_Data___construct()
{    
    optSetOpts 'cs:';
    optSetArgs "$@";
    
    this set data '';
    this set maxSize "65536"; # Default: 64K
    optIsset 's' && this set maxSize "`optValue 's'`";
    
    this set compress "0";
    optIsset 'c' && this set compress "1";
}

##
# Save in registry.
#
# $1    string  Id
# $2    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
function CLASS_Data_set()
{
    : ${1:?};
    
    if [ -p /dev/stdin ]; then
        local value=`cat -`;
    else
        local value="$2";
    fi
                
    local key=`echo "$1" | base64 -w 0`;
    local value=`echo "$value" | this call _compress 'c' | base64 -w 0`;
    local data="`this get data`";
    local data=`echo "$data" | sed "s#^${key}\s\+.*##"`;
    local data=`echo "$key $value"; echo -n "$data";`;
    if [ "${#data}" -gt "`this get maxSize`" ]; then
        warning "Max session memory overrun of `this get maxSize` with ${#data}";
        return 1;
    fi
    local data=`echo "$data" | sort -u;`;
    this set data "$data";

    return "$?"
}

##
# Remove data from registry.
#
# $1    string  Id
# $?    0:OK    1:ERROR
function CLASS_Data_remove()
{
    : ${1:?};
    
    local key=`echo "$1" | base64 -w 0`;
    local data=`this get data`;
    data=`echo "$data" \
        | sed "s#^${key}\s\+.*##" \
        | sort -u`;
    this set data "$data";
    
    return "$?"
}

##
# Read from registry.
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
        echo "$res" | sed 's#\S\+\s\+##' | base64 -d | this call _compress 'd';
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
function CLASS_Data_isset()
{
    : ${1:?};
    
    local key=`echo "$1" | base64`;
    local data=`this get data`;
    local res=`echo "$data" | grep "^$key "`
    if [ -n "$res" ]; then
        return 0;
    fi
    
    return 1;
}

##
# Compress/Decompress a string if -c is set
#
# $1    mode c:compress d:decompress
# &0    string Data
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Data__compress()
{
    : ${1:?};
    
    local compress=`this get compress`;
    
    if [ "$compress" == 1 ]; then
        [ "$1" == 'c' ] && gzip;
        [ "$1" == 'd' ] && gzip -d;
    else
        cat -;
    fi
}

##
# Check if registry is compressed.
#
# $?    0:YES   1:NO
function CLASS_Data_isCompressed()
{    
    local compress=`this get compress`;
    [ "$compress" == 1 ];
    return "$?";
}

##
# Get current size
#
# $?    0:OK    1:ERROR
function CLASS_Data_size()
{    
    this get data | wc -c;
    return "$?";
}
