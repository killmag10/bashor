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
# @version      $Id: registry.sh 22 2010-03-14 04:16:22Z lars $
################################################################################

##
# Constructor
#
# $1    string  registry file
function CLASS_Registry___construct()
{
    : ${1?};
    : ${OBJECT:?};
    
    optSetOpts 'c';
    optSetArgs "$@";
    
    this set compress "0";
    optIsset 'c' && this set compress "1";
  
    argIsset "1" || error "registry file not set";
    local registryDir=`argValue "1"`;
    
    this set file "$registryDir";
}

##
# Save in registry.
#
# $1    string  Id
# $2    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
function CLASS_Registry_set()
{
    : ${1:?};
    : ${OBJECT:?};
    
    if [ -p /dev/stdin ]; then
        local value=`cat -`;
    else
        local value="$2";
    fi
    
    loadClass 'Lock';
    local file=`this get file`;
    local lockFile=`class Lock filename "$file"`;
    
    {
        flock 200;
        
        local key=`echo "$1" | base64 -w 0`;
        local value=`echo "$value" | base64 -w 0`;
        [ ! -f "$file" ] \
            && echo "" | this call _compress 'c' > "$file";   
        local data=`cat "$file" | this call _compress 'd'`;
        local data=`echo "$data" | sed "s#^${key}\s\+.*##"`;
        local data=`echo "$key $value"; echo -n "$data";`;
        echo "$data" | sort -u | this call _compress 'c' > "$file";
    } 200>"$lockFile";
    class Lock delete "$lockFile";
    
    return "$?"
}

##
# Remove data from registry.
#
# $1    string  Id
# $?    0:OK    1:ERROR
function CLASS_Registry_remove()
{
    : ${1:?};
    : ${OBJECT:?};
    
    loadClass 'Lock';
    local file=`this get file`;
    local lockFile=`class Lock filename "$file"`;
    local key=`echo "$1" | base64 -w 0`;
    
    if [ -f "$file" ]; then
        {
            flock 200;
            
            local data=`cat "$file" | this call _compress 'd'`;
            echo "$data" | sed "s#^${key}\s\+.*##" \
                | sort -u \
                | this call _compress 'c' > "$file";
        } 200>"$lockFile";
        class Lock delete "$lockFile";
        
        return "$?"
    fi
}

##
# Read from registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Registry_get()
{
    : ${1:?};
    : ${OBJECT:?};
    
    local file=`this get file`;
    
    if [ -f "$file" ]; then
        local key=`echo "$1" | base64`;
        local res=`cat "$file" \
            | this call _compress 'd' | grep "^$key "`;
        if [ -n "$res" ]; then
            echo "$res" | sed 's#\S\+\s\+##' | base64 -d;
            return 0;
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
function CLASS_Registry_isset()
{
    : ${1:?};
    : ${OBJECT:?};
    
    local file=`this get file`;
    
    if [ -f "$file" ]; then
        local key=`echo "$1" | base64`;
        local res=`cat "$file" \
            | this call _compress 'd' | grep "^$key "`;
        if [ -n "$res" ]; then
            return 0;
        fi
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
function CLASS_Registry__compress()
{
    : ${1:?};
    : ${OBJECT:?};
    
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
function CLASS_Registry_isCompressed()
{
    : ${OBJECT:?};
    
    local compress=`this get compress`;
    [ "$compress" == 1 ];
    return "$?";
}

##
# Get the registry filename.
#
# &1    string  filename
# $?    0:YES   1:NO
function CLASS_Registry_getFilename()
{
    : ${OBJECT:?};
    
    echo "`this get file`";
    return "$?";
}
