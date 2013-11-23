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
# @version      $Id$
################################################################################

loadClassOnce 'Bashor_Reflection_Class';

##
# Constructor
#
# $1    string|object   class name/object
# $2    string          method name
CLASS_Bashor_Reflection_Method___construct()
{    
    requireObject
    requireParams RR "$@"
    
    local className=
    local objectPointer=
    local methodName="$2"
    if [[ "$1" =~ ^_BASHOR_POINTER_ ]]; then
        isObject "$1" || error 'Pointer is not a object!'
        eval 'className="$'"${!1}"'_CLASS"'
        objectPointer="$1"
    else
        className="$1"
        eval 'objectPointer=$_BASHOR_CLASS_'"$className"'_POINTER'
    fi
    classExists "$className" || error 'Class "'"$className"'" not found!'
    issetFunction CLASS_"$className"_"$methodName" \
        || error 'Class "'"$className"'" has no method "'"$methodName"'"!'
    
    this set className "$className"
    this set objectPointer "$objectPointer"
    this set methodName "$methodName"
    
    return 0
}

##
# Get the reflaction class of the class from the property.
#
# $1    string                       var name
# &1    Bashor_Reflection_Class      class
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Method_getDeclaringClass()
{
    requireParams R "$@"
    
    local objectPointer
    objectPointer="`this get objectPointer`"
    
    new Bashor_Reflection_Class "$1" "$objectPointer";
    return $?
}

##
# Get the property name.
#
# &1    string      property name
# $?    0:OK
# $?    1:ERROR
CLASS_Bashor_Reflection_Method_getName()
{    
    this get methodName
    return $?
}

##
# Check if the method is the Constructor.
#
# $?    0:TRUE
# $?    1:FALSE
CLASS_Bashor_Reflection_Method_isConstructor()
{
    [ "`this get methodName`" = '__construct' ]
    return $?
}

##
# Check if the method is the Destructor.
#
# $?    0:TRUE
# $?    1:FALSE
CLASS_Bashor_Reflection_Method_isDestructor()
{
    [ "`this get methodName`" = '__destruct' ]
    return $?
}
