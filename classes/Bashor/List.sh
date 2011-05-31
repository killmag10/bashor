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
    
    local data;
    new Bashor_List_Data data
    this set 'data' "$data"
    this set 'iterator' 0
    
    return 0
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

    local data="`this get 'data'`"
    object "$data" set "$1" "$2"
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
    
    local data="`this get 'data'`"
    object "$data" unset "$1"
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
    
    local data="`this get 'data'`"
    object "$data" get "$1"
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
    
    local data="`this get 'data'`"
    object "$data" isset "$1"
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
    
    local data="`this get 'data'`"
    object "$data" key "$1"
    return $?
}

##
# Get count of items
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_List_count()
{
    : ${OBJECT:?}

    local data="`this get 'data'`"
    object "$data" count
    return $?
}

##
# Get count of items
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_List_current()
{
    : ${OBJECT:?}

    local data="`this get 'data'`"
    local key="`this get 'iterator'`"
    object "$data" get "`object "$data" key 'iterator'`"
    return $?
}