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

loadClassOnce 'Bashor_Reflection_Property';

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
    requireParams R "$@"
    
    local parentClassName=_BASHOR_CLASS_"$CLASS_NAME"_EXTENDS
    parentClassName="${!parentClassName}"
    [ -z "$parentClassName" ] && return 1
    
    new Bashor_Reflection_Class "$1" "$parentClassName"
    return $?
}

##
# Get the parent class as Reflection Class.
#
# $1    string  var name
# &1    Bashor_Reflection_Class parent class
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Class_getProperty()
{    
    requireParams R "$@"
    
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

