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


##
# Generate the cache filename.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &1    string filename 
function cache_filename()
{
    loadFunction 'hash';
    mkdir -p "$BASHOR_DIR_CACHE/";
    
    local hashMd5=`hashMd5 "$1"`;
    local hashCrc32=`echo "$1" | cksum | tr ' ' '_'`;
    echo "$BASHOR_DIR_CACHE/CACHE_${md5}_${cksum}";
    return 0;
}

##
# Save in cache.
#
# $1    string  Id
# $2    string  Data
# $3    string  Cachetime in seconds.
# $?    0:OK    1:ERROR
function cache_set()
{
    local filename=`cacheFilename "$1"`;
    local time=`date +%s`;
    ((endTime= "$time" + "$3"))
    {
        echo "$time";
        echo -n "$2";
    } > "$filename";
    
    return "$?"
}

##
# Read from cache.
#
# $1    string  Id
# $?    0:CACHED    1:NOT CACHED
# &1    string Data 
function cache_get()
{
    local filename=`cacheFilename "$1"`;
    local curTime=`date +%s`;
    if [ -f "$filename" ]; then
        local time=`cat "$filename" | head -n 1`;
        if [ -n "$time" ] && [ "$time" -gt "$curTime" ]; then
            cat "$filename" | tail -n +2;
            return 0;
        fi
    fi
    
    return 1;
}

##
# Check if data cached.
#
# $1    string  Id
# $?    0:CACHED    1:NOT CACHED
function cache_check()
{
    local filename=`cacheFilename "$1"`;
    cacheCheckByFilename "$filename";	
    return "$?";
}

##
# Check if data cached.
#
# $1    string  filename
# $?    0:CACHED    1:NOT CACHED
function cache_checkByFilename()
{
    local filename="$1";
    local curTime=`date +%s`;
    if [ -f "$filename" ]; then
        local head=`cat "$filename" | head -n 1`;
        if [ -n "$head" ] && [ "$head" -gt "$curTime" ]; then
            return 0;
        fi
    fi

    return 1;
}

##
# Remove old cache files.
#
# $1    string  filename
# $?    0:CACHED    1:NOT CACHED
function cache_removeOld()
{
    local files=`ls -1 "$BASHOR_DIR_CACHE/file/"`;
    for file in $files; do
        cacheCheckByFilename "$BASHOR_DIR_CACHE/$file";
        if [ "$?" != 0 ]; then
            rm "$BASHOR_DIR_CACHE/$file";
        fi
    done;
    return 0;
}

