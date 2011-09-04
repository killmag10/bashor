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
# @subpackage   Class
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

loadClassOnce Bashor_Cache
extends Bashor_Cache_File Bashor_Cache

##
# Constructor
#
# $1    string  cache dir
CLASS_Bashor_Cache_File___construct()
{
    requireObject
    requireParams R "$@"
    
    parent call __construct
    
    this set dir "$1"
    mkdir -p "$1"
}

##
# Generate the cache filename.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &1    string filename 
CLASS_Bashor_Cache_File_filename()
{
    requireObject
    requireParams S "$@"
    
    loadClassOnce Bashor_Hash
    
    local hashMd5=`class Bashor_Hash md5 "$1"`
    local hashCrc32=`printf '%s' "$1" | cksum | tr ' ' '_'`
    printf '%s' "`this get dir`""/CACHE_${hashMd5}_${hashCrc32}"
    return 0
}

##
# Save in cache.
#
# $1    string  Id
# $2    string  Cachetime in seconds.
# $3    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
CLASS_Bashor_Cache_File_set()
{
    requireObject
    requireParams RR "$@"
    
    local filename=`this call filename "$1"`
    local time=`date +%s`
    ((time="$time"+"$2"))
    {
        printf '%s\n' "$time"
        printf '%s' "$1" | tr '\n\r' ' '
        echo
        if [ -p /dev/stdin ]; then
            cat /dev/stdin
        else
            printf '%s' "$3"
        fi
    } > "$filename"
    
    return "$?"
}

##
# Read from cache.
#
# $1    string  Id
# $?    0:CACHED    1:NOT CACHED
# &1    string Data 
CLASS_Bashor_Cache_File_get()
{
    requireObject
    requireParams R "$@"
    
    local filename=`this call filename "$1"`
    local curTime=`date +%s`
    if [ -f "$filename" ]; then
        local time=`cat "$filename" | head -n 1`
        if [ -n "$time" ] && [ "$time" -gt "$curTime" ]; then
            cat "$filename" | tail -n +3
            return 0
        fi
    fi
    
    return 1
}

##
# Check if data cached.
#
# $1    string  Id
# $?    0:CACHED    1:NOT CACHED
CLASS_Bashor_Cache_File_check()
{
    requireObject
    requireParams R "$@"
    
    local filename=`this call filename "$1"`
    local curTime=`date +%s`
    if [ -f "$filename" ]; then
        local head=`cat "$filename" | head -n 1`
        if [ -n "$head" ] && [ "$head" -gt "$curTime" ]; then
            return 0
        fi
    fi

    return 1
}

##
# Remove old cache files.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Cache_File_removeOutdated()
{
    requireObject
    
    local dir="`this get dir`"
    local files="`ls -1 "$dir"`"
    local IFS=$'\n\r'
    for file in $files; do
        this call check "$dir/$file"
        if [ "$?" != 0 ]; then
            rm "$dir/$file"
        fi
    done
    return 0
}

