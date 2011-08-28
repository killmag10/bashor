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

##
# Loader
function CLASS_Class___load()
{
    requireStatic
    return 0
}

##
# Constructor
function CLASS_Class___construct()
{
    requireObject
    return 0
}

##
# Destructor
function CLASS_Class___destruct()
{
    requireObject
    return 0
}

##
# Get the class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
function CLASS_Class_getClass()
{
    [ -z "$CLASS_NAME" ] && error 'Not in a Class'
    echo "$CLASS_NAME"
    return 0
}

##
# Get the parent class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
function CLASS_Class_getClassTrace()
{
    [ -z "$CLASS_NAME" ] && error 'Not in a Class'
    echo "$CLASS_NAME"
    parent exists || return 1
    parent call getClassTrace
    return 0
}

##
# Check if the class has a parent.
#
# $?    0:TRUE   1:FALSE
function CLASS_Class_hasParentClass()
{
    [ -z "$CLASS_NAME" ] && error 'Not in a Class'
    parent exists
    return $?
}

##
# Check if class is a instance of.
#
# $?    0:TRUE    1:FALSE
function CLASS_Class_isA()
{
    [ -z "$CLASS_NAME" ] && error 'Not in a Class'
    requireParams R "$@"
    [ "$CLASS_NAME" == "$1" ] && return 0
    parent exists || return 1
    parent call isA "$1"
    return $?
}

##
# Check if class is a instance of.
#
# $?    0:TRUE    1:FALSE
function CLASS_Class_debug()
{
    # @todo
    return 0
}
