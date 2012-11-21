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
# @version      $Id$
################################################################################

loadClassOnce 'Bashor_List'
extends Bashor_List_Iterable Bashor_List

##
# Constructor
CLASS_Bashor_List_Iterable___construct()
{
    requireObject
    
    parent call __construct
    eval "$OBJECT"_Iterator=0
}

##
# Destructor
CLASS_Bashor_List_Iterable___destruct()
{
    requireObject
    
    parent call __destruct
    unset -v "$OBJECT"_Iterator
}

##
# Clone
CLASS_Bashor_List_Iterable___clone()
{
    requireObject
    
    parent call __clone
    (("$OBJECT"_Iterator=0))
}

##
# Return the current element.
CLASS_Bashor_List_Iterable_current()
{
    requireObject
    
    object "`this get 'data'`" value "$((${OBJECT}_Iterator))"
    return $?
}

##
# Move forward to next element
CLASS_Bashor_List_Iterable_next()
{
    requireObject

    (("$OBJECT"_Iterator++))
}

##
# Rewind the Iterator to the first element
CLASS_Bashor_List_Iterable_rewind()
{
    requireObject
    
    (("$OBJECT"_Iterator=0))
}


##
# Checks if current position is valid
CLASS_Bashor_List_Iterable_valid()
{
    requireObject
    
    local iterator="$OBJECT"_Iterator
    [ "${!iterator}" -lt "`parent call count`" ]
    return $?
}

##
# Return the key of the current element
CLASS_Bashor_List_Iterable_key()
{
    requireObject
    
    if [ "$#" -gt 0 ]; then
        parent call key "$1"
        return $?
    fi
    
    local iterator="$OBJECT"_Iterator
    object "`this get 'data'`" key "${!iterator}"
    return $?
}
