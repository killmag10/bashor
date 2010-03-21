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
# @version      $Id: cache.sh 17 2010-03-13 00:12:19Z lars $
################################################################################

##
# Constructor
#
# $1    string  cache dir
function CLASS_Cache___construct()
{
    : ${1?};
    : ${OBJECT:?};
    
    this set dir "$1";
}

##
# Generate the cache filename.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &1    string filename 
function CLASS_Cache_filename()
{
    : ${1?};
    : ${OBJECT:?};
    
    loadClass 'Hash';
    
    local hashMd5=`CLASS_Hash_md5 "$1"`;
    local hashCrc32=`echo "$1" | cksum | tr ' ' '_'`;
    echo `this get dir`"/CACHE_${hashMd5}_${hashCrc32}";
    return 0;
}

##
# Save in cache.
#
# $1    string  Id
# $2    string  Cachetime in seconds.
# $3    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
function CLASS_Cache_set()
{
    : ${1:?};
    : ${2:?};
    : ${OBJECT:?};
    
    local filename=`this call filename "$1"`;
    local time=`date +%s`;
    ((time="$time"+"$2"));
    {
        echo "$time";
        echo "`echo '$1' | tr '\n\r' ' '`";
        if [ -p /dev/stdin ]; then
            cat /dev/stdin;
        else
            echo -n "$3";
        fi
    } > "$filename";
    
    return "$?"
}

##
# Read from cache.
#
# $1    string  Id
# $?    0:CACHED    1:NOT CACHED
# &1    string Data 
function CLASS_Cache_get()
{
    : ${1:?};
    : ${OBJECT:?};
    
    local filename=`this call filename "$1"`;
    local curTime=`date +%s`;
    if [ -f "$filename" ]; then
        local time=`cat "$filename" | head -n 1`;
        if [ -n "$time" ] && [ "$time" -gt "$curTime" ]; then
            cat "$filename" | tail -n +3;
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
function CLASS_Cache_check()
{
    : ${1:?};
    : ${OBJECT:?};
    
    local filename=`this call filename "$1"`;
    cacheCheckByFilename "$filename";	
    return "$?";
}

##
# Check if data cached.
#
# $1    string  filename
# $?    0:CACHED    1:NOT CACHED
function CLASS_Cache_checkByFilename()
{
    : ${1?};
    : ${OBJECT:?};
    
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
# $?    0:OK    1:ERROR
function CLASS_Cache_removeOld()
{
    : ${OBJECT:?};
    
    local files=`ls -1 "$BASHOR_DIR_CACHE/file/"`;
    local IFS=`echo -e "\n\r"`;
    for file in $files; do
        cacheCheckByFilename "$BASHOR_FUNCTION_CACHE_DIR/$file";
        if [ "$?" != 0 ]; then
            rm "$BASHOR_FUNCTION_CACHE_DIR/$file";
        fi
    done;
    return 0;
}

