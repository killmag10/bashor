#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

##
# Constructor
#
# $1    string  registry file
CLASS_Bashor_Registry___construct()
{
    requireObject
    requireParams R "$@"
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    local Param
    new Bashor_Param Param 'c'
    object $Param set "$@"
    
    this set compress "0"
    object $Param isset '-c' && this set compress "1"
  
    object $Param notEmpty "1" || error "registry file not set"
    local file="`object $Param get "1"`"
    
    this set file "$file"
    local lockFile=`this call _getLockFileByFile "$file"`
    
    if [ ! -f "$file" ]; then
        loadClassOnce 'Bashor_Lock'
        {
            class Bashor_Lock lock 200
            printf '%s' '' | this call _compress 'c' > "$file"    
        } 200>"$lockFile"
        class Bashor_Lock delete "$lockFile"
    fi
}

##
# Save in registry.
#
# $1    string  Id
# $2    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
CLASS_Bashor_Registry_set()
{
    requireObject
    requireParams R "$@"
    
    if [ -p /dev/stdin ] && [ -z "$2" ] && [ "$2" !=  "${2-null}" ]; then
        local value="$(cat - | encodeData)"
    else
        local value="$(echo "$2" | encodeData)"
    fi
        
    loadClassOnce Bashor_Lock
    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`
       
    {
        class Bashor_Lock lock 200
        
        [ ! -f "$file" ] && echo "" | this call _compress 'c' > "$file"        
        local data="$(this call _compress 'd' < $file)"    
        local key="$(printf '%s' "$1" | encodeData)"
        printf '%s' "$data" \
            | ( grep -v "^${key}[[:space:]]\+.*$"; printf '%s\n' "$key $value"; ) \
            | this call _compress 'c' > "$file";
    } 200>"$lockFile"
    class Bashor_Lock delete "$lockFile"
    
    return 0
}

##
# Remove data from registry.
#
# $1    string  Id
# $?    0:OK    1:ERROR
CLASS_Bashor_Registry_remove()
{
    requireObject
    requireParams R "$@"
    
    loadClassOnce Bashor_Lock
    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`
    
    if [ -f "$file" ]; then
        {
            class Bashor_Lock lock 200
                 
            local data="$(this call _compress 'd' < $file)"    
            local key="$(printf '%s' "$1" | encodeData)"
            printf '%s' "$data" \
                | ( grep -v "^${key}[[:space:]]\+.*$";) \
                | this call _compress 'c' > "$file";
        } 200>"$lockFile"
        class Bashor_Lock delete "$lockFile"
        
        return 0
    fi
}

##
# Read from registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Registry_get()
{
    requireObject
    requireParams R "$@"
    
    loadClassOnce Bashor_Lock
    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`
    
    if [ -f "$file" ]; then
        {
            class Bashor_Lock lock -s 200
            
            local data
            data="$( this call _compress 'd' < "$file" \
                | grep "^$(printf '%s' "$1" | encodeData)[[:space:]]\+.*$")" 
            [ $? == 0 ] || return 1    
            printf '%s' "$data" | cut -d ' ' -f 2 | decodeData
        } 200>"$lockFile"
        class Bashor_Lock delete "$lockFile"
    fi
    
    return 0
}

##
# Isset in registry.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Registry_isset()
{
    requireObject
    requireParams R "$@"
    
    loadClassOnce Bashor_Lock
    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`
    
    if [ -f "$file" ]; then
        {
            class Bashor_Lock lock -s 200
            
            local data
            this call _compress 'd' < "$file" \
                | grep "$(printf '%s' "$1" | encodeData)[[:space:]]\+.*$" >/dev/null 
            [ $? == 0 ] && return 0 
        } 200>"$lockFile"
        class Bashor_Lock delete "$lockFile"
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
CLASS_Bashor_Registry__compress()
{
    requireObject
    requireParams R "$@"
    
    local compress=`this get compress`
    
    if [ "$compress" == 1 ]; then
        [ "$1" == c ] && gzip
        [ "$1" == d ] && gzip -d
    else
        cat -
    fi
}

##
# Check if registry is compressed.
#
# $?    0:YES   1:NO
CLASS_Bashor_Registry_isCompressed()
{
    requireObject
    
    local compress=`this get compress`
    [ "$compress" == 1 ]
    return "$?"
}

##
# Get the registry filename.
#
# &1    string  filename
# $?    0:YES   1:NO
CLASS_Bashor_Registry_getFilename()
{
    requireObject
    
    echo "`this get file`"
    return "$?"
}

##
# Get all keys from registry.
#
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Registry_getKeys()
{
    requireObject
    
    loadClassOnce Bashor_Lock
    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`
    
    if [ -f "$file" ]; then
        {
            class Bashor_Lock lock -s 200
            
            local res="$(this call _compress 'd' < "$file")"
            if [ -n "$res" ]; then
                local IFS=$'\n'
                local line
                for line in $res; do
                    printf '%s' "$line" | sed 's#^\([^[:space:]]\+\).\+$#\1#' | decodeData
                    echo
                done
                return 0
            fi
        } 200>"$lockFile"
        class Bashor_Lock delete "$lockFile"
    fi
    
    return 1
}

##
# Get all keys and values from registry.
#
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_Registry_getValues()
{
    requireObject
    
    loadClassOnce Bashor_Lock
    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`
    
    if [ -f "$file" ]; then
        {
            class Bashor_Lock lock -s 200
            
            local res="$(this call _compress 'd' < "$file")"
            if [ -n "$res" ]; then
                local IFS=$'\n\r'
                local key value line
                for line in $res; do
                    key=`printf '%s' "$line" | sed 's#^\([^[:space:]]\+\).\+$#\1#' | decodeData`
                    value=`printf '%s' "$line" | sed 's#^[^[:space:]]\+[[:space:]]\+##' | decodeData`
                    printf '%s\n' "$key : $value"
                done
                return 0
            fi
        } 200>"$lockFile"
        class Bashor_Lock delete "$lockFile"
    fi
    
    return 1
}

##
# Clear the registry.
#
CLASS_Bashor_Registry_clear()
{
    requireObject

    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`    

    loadClassOnce Bashor_Lock
    {
        class Bashor_Lock lock 200
        echo | this call _compress 'c' > "$file"    
    } 200>"$lockFile"
    class Bashor_Lock delete "$lockFile"
}

##
# Clear the registry.
#
CLASS_Bashor_Registry_removeFile()
{
    requireObject

    local file=`this get file`
    local lockFile=`this call _getLockFileByFile "$file"`
    [ -f "$file" ] || return 1
    
    loadClassOnce Bashor_Lock
    {
        class Bashor_Lock lock 200
        rm "$file"    
    } 200>"$lockFile"
    class Bashor_Lock delete "$lockFile"
}

##
# Get the lock file name.
#
# $1    string  file path
# &1    string  lock file path
CLASS_Bashor_Registry__getLockFileByFile()
{
    requireObject
    requireParams R "$@"
    
    printf '%s' "$1"'.lock'
    return 0
}
