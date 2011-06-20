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
# @subpackage   List
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

loadClassOnce Bashor_List_Data

##
# Constructor
#
function CLASS_Bashor_List___construct()
{    
    : ${OBJECT:?}
    
    local data
    new Bashor_List_Data data
    this set data "$data"
    
    return 0
}

##
# Add item to list.
#
# $1    string  data
# $?    0:OK    1:ERROR
# &0    string  Data
function CLASS_Bashor_List_add()
{
    : ${OBJECT:?}
    : ${1?}

    local data="`this get data`"    
    local count="`object "$data" count`"
    while object "$data" isset "$count"; do
        ((count++))
    done

    object "$data" set "$count" "$1"
    return $?
}

##
# Get the list in Lines.
#
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Bashor_List_asLines()
{
    : ${OBJECT:?}
    
    this call rewind
    while this call valid; do
        this call current        
        this call next
    done
    return 0
}


##
# Clear the list.
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_List_clear()
{
    : ${OBJECT:?}

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
function CLASS_Bashor_List_set()
{
    : ${OBJECT:?}
    : ${1:?}
    : ${2?}

    object "`this get 'data'`" set "$1" "$2"
    return $?
}

##
# Remove item from list.
#
# $1    string  key
# $?    0:OK    1:ERROR
function CLASS_Bashor_List_unset()
{
    : ${OBJECT:?}
    : ${1:?}
    
    object "`this get 'data'`" unset "$1"
    return $?
}

##
# Get item from list.
#
# $1    string  key
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Bashor_List_get()
{
    : ${OBJECT:?}
    : ${1:?}
    
    object "`this get 'data'`" get "$1"
    return $?
}

##
# Isset item in list.
#
# $1    string  key
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Bashor_List_isset()
{
    : ${OBJECT:?}
    : ${1:?}
    
    object "`this get 'data'`" isset "$1"
    return $?
}

##
# Get the key of a item.
#
# $1    integer  pos of item in list
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Bashor_List_key()
{
    : ${OBJECT:?}
    : ${1:?}
    
    object "`this get 'data'`" key "$1"
    return $?
}

##
# Get count of items
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_List_count()
{
    : ${OBJECT:?}

    object "`this get 'data'`" count
    return $?
}

##
# On sleep
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_List___sleep()
{
    : ${OBJECT:?}

    local data="`this get data`"
    this set serializedData "`serialize $data`"
    return $?
}

##
# On wakeup
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_List___wakeup()
{
    : ${OBJECT:?}

    local data
    unserialize data "`this get serializedData`"
    this set data "$data"
    return $?
}

