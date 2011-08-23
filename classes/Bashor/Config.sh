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

##
# Constructor
function CLASS_Bashor_Config___construct()
{
    requireObject
    
    local Data
    new Bashor_Data Data
    this set data "$Data"
    this set 'readonly' ''    
}

##
# Set a value.
#
# $1    string  key
# $2    mixed   data
# $?    0:OK    1:ERROR
function CLASS_Bashor_Config_set()
{
    requireObject
    requireParams RS "$@"
    
    if [ -n "`this get readonly`" ]; then
        warning 'is set readonly'
        return 1
    fi
    
    local Data   
    Data=`this get data`
    
    object $Data set "$1" "$2"
    return $?
}

##
# Get a value.
#
# $1    string  key
# &1    mixed   data
# $?    0:OK    1:ERROR
function CLASS_Bashor_Config_get()
{
    requireObject
    requireParams R "$@"
        
    local Data   
    Data=`this get data`
    
    object $Data get "$1"
    return $?
}

##
# Isset a value.
#
# $1    string  Id
# $?    0:EXISTS    1:NOT FOUND
# &1    string Data 
function CLASS_Bashor_Config_isset()
{
    requireObject
    requireParams R "$@"
    
    local Data   
    Data=`this get data`
    
    object $Data get "$1"
    return $?
}

##
# Remove a value.
#
# $1    string  Id
# $?    0:OK    1:ERROR
function CLASS_Bashor_Config_remove()
{
    requireObject
    requireParams R "$@"
    
    if [ -n "`this get readonly`" ]; then
        warning 'is set readonly'
        return 1
    fi
    
    local Data   
    Data=`this get data`
    
    object $Data remove "$1"
    return $?
}

##
# Set readonly.
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Config_setReadonly()
{
    requireObject
    
    this set 'readonly' '1'
    return 0
}
