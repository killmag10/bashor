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
# $1    string|object   class name/object
# $2    string          property name
CLASS_Bashor_Reflection_Property___construct()
{    
    requireObject
    requireParams RR "$@"
    
    local className=
    local objectPointer=
    local propertyName="$2"
    if [[ "$1" =~ ^_BASHOR_POINTER_ ]]; then
        isObject "$1" || error 'Pointer is not a object!'
        eval 'className="$'"$1"'_CLASS"'
        objectPointer="$1"
    else
        className="$1"
        eval 'objectPointer=$_BASHOR_CLASS_'"$className"'_POINTER'
    fi
    classExists "$className" || error 'Class "'"$className"'" not found!'
    _bashor_objectIsset "$objectPointer"_DATA "$1" \
        || error 'Class "'"$className"'" has no property "'"$propertyName"'"!'
    
    this set className "$className"
    this set objectPointer "$objectPointer"
    this set propertyName "$propertyName"
    
    return 0
}

##
# Get the class name of the class from the property.
#
# &1    string      class name
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Property_getDeclaringClass()
{    
    this get className
    return $?
}

##
# Get the property name.
#
# &1    string      property name
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Property_getName()
{    
    this get propertyName
    return $?
}

##
# Get the property value.
#
# &1    mixed      property value
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Property_getValue()
{
    local objectPointer propertyName
    objectPointer="`this get objectPointer`"
    propertyName="`this get propertyName`"

    _bashor_objectGet "$objectPointer"_DATA "$propertyName"   
    return $?
}
