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
# @version      $Id$
################################################################################

##
# Constructor
#
# -s   integer session size (Default:65536)
# -c   compress
CLASS_Bashor_Data___construct()
{    
    requireObject
    
    local Param
    new Bashor_Param Param 'cs:'

    object $Param set "$@"
    
    this set data ''
    this set maxSize ''
    object $Param isset '-s' && this set maxSize "`object $Param get '-s'`"
    
    this set compress "0"
    object $Param isset '-c' && this set compress "1"
    remove $Param
    
    return 0
}

##
# Save in registry.
#
# $1    string  Id
# $2    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
CLASS_Bashor_Data_set()
{
    requireObject
    requireParams R "$@"
    
    if [ -p /dev/stdin ]; then
        local value=`cat -`
    else
        local value="$2"
    fi
    
    local key=`printf '%s\n' "$1" | encodeData`
    value=`printf '%s\n' "$value" | this call _compress 'c' | encodeData`
    local data="`this get data`"
    data=`printf '%s\n' "$data" | sed "s#^${key}[[:space:]]\+.*##"`
    data=`printf '%s\n' "$key $value"; printf '%s' "$data";`
    local maxSize="`this get maxSize`"
    if [ -n "$maxSize" ] && [ "${#data}" -gt "$maxSize" ]; then
        warning "Max session memory overrun of `this get maxSize` with ${#data}"
        return 1
    fi
    data=`printf '%s\n' "$data" | sort -u;`
    this set data "$data"

    return "$?"
}

##
# Remove data from registry.
#
# $1    string  Id
# $?    0:OK    1:ERROR
CLASS_Bashor_Data_remove()
{
    requireObject
    requireParams R "$@"
    
    local key=`printf '%s\n' "$1" | encodeData`
    local data=`this get data`
    data=`printf '%s\n' "$data" \
        | sed "s#^${key}[[:space:]]\+.*##" \
        | sort -u`
    this set data "$data"
    
    return "$?"
}

##
# Read from registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Data_get()
{
    requireObject
    requireParams R "$@"
    
    local key=`printf '%s\n' "$1" | encodeData`
    local data=`this get data`
    local res=`printf '%s\n' "$data" | grep "^$key "`
    if [ -n "$res" ]; then
        printf '%s\n' "$res" | sed 's#[^[:space:]]\+[[:space:]]\+##' | decodeData | this call _compress 'd'
        return 0
    fi
    
    return 1
}

##
# Isset in registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Data_isset()
{
    requireObject
    requireParams R "$@"
    
    local key=`printf '%s\n' "$1" | encodeData`
    local data=`this get data`
    local res=`printf '%s\n' "$data" | grep "^$key "`
    if [ -n "$res" ]; then
        return 0
    fi
    
    return 1
}

##
# Compress/Decompress a string if -c is set
#
# $1    mode c:compress d:decompress
# &0    string Data
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Data__compress()
{
    requireObject
    requireParams R "$@"
    
    local compress=`this get compress`
    
    if [ "$compress" == 1 ]; then
        [ "$1" == 'c' ] && gzip
        [ "$1" == 'd' ] && gzip -d
    else
        cat -
    fi
}

##
# Check if registry is compressed.
#
# $?    0:YES   1:NO
CLASS_Bashor_Data_isCompressed()
{
    requireObject
    
    local compress=`this get compress`
    [ "$compress" == 1 ]
    return "$?"
}

##
# Get current size
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Data_size()
{
    requireObject
    
    this get data | wc -c
    return "$?"
}

##
# Get all keys from registry.
#
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Data_getKeys()
{
    requireObject
    
    local data=`this get data`
    if [ -n "$data" ]; then
        local line IFS=$'\n'
        for line in $data; do
            printf '%s\n' "$line" | sed 's#^\([^[:space:]]\+\).\+$#\1#' | decodeData
        done
        return 0
    fi
    
    return 1
}

##
# Get all keys and values from registry.
#
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Data_getValues()
{
    requireObject
    
    local data=`this get data`
    if [ -n "$data" ]; then
        local key value
        local line IFS=$'\n'
        for line in $data; do
            key=`printf '%s\n' "$line" -n | sed 's#^\([^[:space:]]\+\).\+$#\1#' | decodeData`
            value=`printf '%s' "$line" | sed 's#^[^[:space:]]\+[[:space:]]\+##' | decodeData | this call _compress 'd'`
            printf '%s\n' "$key : $value"
        done
        return 0
    fi
    
    return 1
}

##
# Get count of items
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Data_count()
{
    requireObject
    
    this get data | wc -l    
    return "$?"
}

##
# Clear data.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Data_clear()
{
    requireObject

    this set data ''
    
    return "$?"
}

