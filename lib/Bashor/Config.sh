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

loadClassOnce 'Bashor_List_Iterable'
extends Bashor_Config Bashor_List_Iterable

##
# Constructor
CLASS_Bashor_Config___construct()
{
    requireObject
    
    parent call __construct;
    this set 'readonly' ''    
}

##
# Set a value.
#
# $1    string  key
# $2    mixed   data
# $?    0:OK    1:ERROR
CLASS_Bashor_Config_set()
{
    requireObject
    requireParams RS "$@"
    
    if [ -n "`this get readonly`" ]; then
        warning 'is set readonly'
        return 1
    fi
    
    this call _set "$1" "$2"
    return $?
}

##
# Internal call for set a value.
#
# $1    string  key
# $2    mixed   data
# $?    0:OK    1:ERROR
CLASS_Bashor_Config__set()
{   
    parent call set "$1" "$2"
    return $?
}

##
# Unset a key.
#
# $1    string  Id
# $?    0:OK    1:ERROR
CLASS_Bashor_Config_unset()
{
    requireObject
    requireParams R "$@"
    
    if [ -n "`this get readonly`" ]; then
        warning 'is set readonly'
        return 1
    fi
    
    parent call _unset "$1"
    return $?
}

##
# Internal call for unset a key.
#
# $1    string  Id
# $?    0:OK    1:ERROR
CLASS_Bashor_Config__unset()
{
    parent call unset "$1"
    return $?
}

##
# Set readonly.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Config_setReadonly()
{
    requireObject
    
    this set 'readonly' '1'
    return 0
}

##
# Merge config objects.
#
# $1    Bashor_Config   
# $?    0:OK    1:ERROR
CLASS_Bashor_Config_mergeParent()
{
    requireObject
    requireParams R "$@"
    isObject "$1" || error 'Param 1 is not an object!'
    
    if [ -n "`this get readonly`" ]; then
        warning 'is set readonly'
        return 1
    fi
    
    this call _mergeParent "$1"
    return $?
}

##
# Merge config objects (internal).
#
# $1    Bashor_Config   
# $?    0:OK    1:ERROR
CLASS_Bashor_Config__mergeParent()
{       
    local key current
    object "$1" rewind
    while object "$1" valid; do
        key="`object "$1" key`"
        if this call isset "$key"; then
            current="`object "$1" current`"
            if isObject "$current" && isObject "`this call get "$key"`"; then
                object "`this call get "$key"`" _mergeParent "$current"
            fi
        else
            this call _set "$key" "`object "$1" current`"
        fi
        object "$1" next
    done
    
    return $?
}
