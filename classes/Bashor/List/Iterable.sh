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
# @subpackage   Class
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

loadClassOnce 'Bashor_List'
extends Bashor_List_Iterable Bashor_List

##
# Constructor
function CLASS_Bashor_List_Iterable___construct()
{
    requireObject
    
    parent call __construct "$@"
    local return=$?
    this set iterator 0
    
    return $return
}

##
# Return the current element.
function CLASS_Bashor_List_Iterable_current()
{
    requireObject
    
    local iterator=`this get iterator`
    local data="`this get 'data'`"
    object "$data" get "`object "$data" key "$iterator"`"
    return $?
}

##
# Move forward to next element
function CLASS_Bashor_List_Iterable_next()
{
    requireObject

    local iterator=`this get iterator`
    this set iterator $((++iterator))
}

##
# Rewind the Iterator to the first element
function CLASS_Bashor_List_Iterable_rewind()
{
    requireObject
    
    this set iterator 0
}


##
# Checks if current position is valid
function CLASS_Bashor_List_Iterable_valid()
{
    requireObject
    
    [ "`this get iterator`" -lt "`parent call count`" ]
    return $?
}

##
# Return the key of the current element
function CLASS_Bashor_List_Iterable_key()
{
    requireObject
    
    if [ "$#" -gt 0 ]; then
        parent call key "$1"
        return $?
    fi    
    
    object "`this get 'data'`" key "`this get iterator`"
    return $?
}
