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
# @subpackage   Classes
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

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
    
    local key current
    object "$1" rewind
    while object "$1" valid; do
        key="`object "$1" key`"
        current="`object "$1" current`"
        if this call isset "$key"; then
            if isObject "$current" && isObject "`this call get "$key"`"; then
                object "`this call get "$key"`" mergeParent "$current"
            fi
        else
            this call set "$key" "$current"
        fi
        object "$1" next
    done
    
    return $?
}
