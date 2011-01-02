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
# @version      $Id: cache.sh 17 2010-03-13 00:12:19Z lars $
################################################################################

##
# Loader
function CLASS_Class___load()
{
    : ${STATIC:?}
    return 0
}

##
# Constructor
function CLASS_Class___construct()
{
    : ${OBJECT:?}
    return 0
}

##
# Destructor
function CLASS_Class___destruct()
{
    : ${OBJECT:?}
    return 0
}

##
# Get the class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
function CLASS_Class_getClass()
{
    : ${CLASS_NAME:?}
    echo "$CLASS_NAME"
    return 0
}

##
# Get the parent class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
function CLASS_Class_getParentClass()
{
    : ${CLASS_NAME:?}
    this call hasParentClass || return 1
    parent call getClass
    return $?
}

##
# Get the parent class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
function CLASS_Class_getClassTrace()
{
    : ${CLASS_NAME:?}
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
    : ${CLASS_NAME:?}
    parent exists
    return $?
}

##
# Check if class is a instance of.
#
# $?    0:TRUE    1:FALSE
function CLASS_Class_isA()
{
    : ${CLASS_NAME:?}
    : ${1:?}
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
