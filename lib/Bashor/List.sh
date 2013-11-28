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

loadClassOnce Bashor_List_Data

##
# Constructor
#
CLASS_Bashor_List___construct()
{    
    requireObject
    
    local data
    new Bashor_List_Data data
    this set data "$data"
}

##
# Destructor
#
CLASS_Bashor_List___destruct()
{    
    requireObject
    
    remove "`this get data`"
}

##
# Add item to list.
#
# $1    string  data
# $?    0:OK    1:ERROR
# &0    string  Data
CLASS_Bashor_List_add()
{
    requireObject
    requireParams R "$@"

    local data="`this get data`"    
    local count="`object "$data" count`"
    while object "$data" isset "$count"; do
        ((count++))
    done

    object "$data" set "$count" "$1"
    return $?
}

##
# Clear the list.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_List_clear()
{
    requireObject

    object "`this get 'data'`" clear
    return $?
}


##
# Set item in list.
#
# $1    string  key
# $2    string  data
# $?    0:OK    1:ERROR
# &0    string  Data
CLASS_Bashor_List_set()
{
    requireObject
    requireParams RS "$@"

    object "`this get 'data'`" set "$1" "$2"
    return $?
}

##
# Remove item from list.
#
# $1    string  key
# $?    0:OK    1:ERROR
CLASS_Bashor_List_unset()
{
    requireObject
    requireParams R "$@"
    
    object "`this get 'data'`" unset "$1"
    return $?
}

##
# Get item from list.
#
# $1    string  key
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_get()
{
    requireObject
    requireParams R "$@"
    
    object "`this get 'data'`" get "$1"
    return $?
}

##
# Isset item in list.
#
# $1    string  key
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_isset()
{
    requireObject
    requireParams R "$@"
    
    object "`this get 'data'`" isset "$1"
    return $?
}

##
# Get the key of a item.
#
# $1    integer  pos of item in list
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_key()
{
    requireObject
    requireParams R "$@"
    
    object "`this get 'data'`" key "$1"
    return $?
}

##
# Get the value of a item.
#
# $1    integer  pos of item in list
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_value()
{
    requireObject
    requireParams R "$@"
    
    object "`this get 'data'`" value "$1"
    return $?
}

##
# Get count of items
#
# $?    0:OK    1:ERROR
CLASS_Bashor_List_count()
{
    requireObject

    object "`this get 'data'`" count
    return $?
}

##
# On sleep
#
# $?    0:OK    1:ERROR
CLASS_Bashor_List___sleep()
{
    requireObject

    local data="`this get data`"
    this set serializedData "`serialize $data`"
    return $?
}

##
# On wakeup
#
# $?    0:OK    1:ERROR
CLASS_Bashor_List___wakeup()
{
    requireObject

    local data
    unserialize data "`this get serializedData`"
    this set data "$data"
    return $?
}

