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
# @subpackage   Reflection
# @copyright    Copyright (c) 2012 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: Data.sh 185 2011-08-29 22:09:38Z lars $
################################################################################

##
# Constructor
#
# $1    string|object  class name/object
CLASS_Bashor_Reflection_Class___construct()
{    
    requireObject
    requireParams R "$@"
    
    local className=
    local objectPointer=
    if [[ "$1" =~ ^_BASHOR_POINTER_ ]]; then
        isObject "$1" || error 'Pointer is not a object!'
        eval 'className="$'"$1"'_CLASS"'
        objectPointer="$1"
    else
        className="$1"
        eval 'objectPointer=$_BASHOR_CLASS_'"$className"'_POINTER'
    fi
    classExists "$className" || error 'Class "'"$className"'" not found!'
    this set className "$className"
    this set objectPointer "$objectPointer"
    
    return 0
}

##
# Get the class name.
#
# &1    string  class name
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Class_getName()
{    
    this get className
    return $?
}

##
# Get the parent class as Reflection Class.
#
# $1    string  var name
# &1    Bashor_Reflection_Class parent class
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Class_getParentClass()
{    
    local parentClassName=_BASHOR_CLASS_"$CLASS_NAME"_EXTENDS
    parentClassName="${!parentClassName}"
    [ -z "$parentClassName" ] && return 1
    
    new Bashor_Reflection_Class "$1" "$parentClassName"
    return $?
}

##
# Check if the class has the method.
#
# $1    string  method name
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Class_hasMethod()
{
    requireParams R "$@"

    issetFunction CLASS_"`this get className`"_"$1"    
    return $?
}

##
# Checks whether the specified property is defined.
#
# $1    string  property name
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Class_hasProperty()
{
    requireParams R "$@"
    
    local objectPointer
    objectPointer="`this get objectPointer`"

    _bashor_objectIsset "$objectPointer"_DATA "$1"   
    return $?
}

