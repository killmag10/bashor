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
CLASS_Bashor_List_Data___construct()
{    
    requireObject
    
    return 0
}

##
# Set item in list.
#
# $1    string  key
# $2    string  data
# $?    0:OK    1:ERROR
# &0    string  Data
CLASS_Bashor_List_Data_set()
{
    requireObject
    requireParams RS "$@"

    this set "$1" "$2"
    return $?
}

##
# Remove item from list.
#
# $1    string  key
# $?    0:OK    1:ERROR
CLASS_Bashor_List_Data_unset()
{
    requireObject
    requireParams R "$@"
    
    this unset "$1"
    return $?
}

##
# Get item from list.
#
# $1    string  key
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_Data_get()
{
    requireObject
    requireParams R "$@"
    
    this get "$1"
    return $?
}

##
# Isset item in list.
#
# $1    string  key
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_Data_isset()
{
    requireObject
    requireParams R "$@"
    
    this isset "$1"
    return $?
}

##
# Get the key of a item.
#
# $1    integer  pos of item in list
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_Data_key()
{
    requireObject
    requireParams R "$@"
    
    this key "$1"
    return $?
}

##
# Get the value of a item.
#
# $1    integer  pos of item in list
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
CLASS_Bashor_List_Data_value()
{
    requireObject
    requireParams R "$@"
    
    this value "$1"
    return $?
}

##
# Get count of items.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_List_Data_count()
{
    requireObject

    this count
    return "$?"
}

##
# Remove all items.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_List_Data_clear()
{
    requireObject

    this clear
    return "$?"
}

