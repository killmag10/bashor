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

##
# Loader
#
# Called on class loding
CLASS_Class___load()
{
    requireStatic
    return 0
}

##
# Constructor
#
# Called on object creation (new)
CLASS_Class___construct()
{
    requireObject
    return 0
}

##
# Destructor
#
# Called on object destruction (remove)
CLASS_Class___destruct()
{
    requireObject
    return 0
}

##
# Make object ready for sleep.
#
# Called on object serialization (serialize)
CLASS_Class___sleep()
{
    requireObject
    return 0
}

##
# Make object ready for wakeup.
#
# Called on object unserialization (unserialize)
CLASS_Class___wakeup()
{
    requireObject
    return 0
}

##
# Get the class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
CLASS_Class_getClass()
{
    [ -z "$CLASS_TOP_NAME" ] && error 'Not in a Class'
    printf '%s' "$CLASS_TOP_NAME"
    return 0
}

##
# Check if the class has the over given method.
#
# $1    string  method name
# $?    0:OK
# $?    1:ERROR
CLASS_Class_hasMethod()
{
    requireParams R "$@"
    
    issetFunction CLASS_"$CLASS_TOP_NAME"_"$1"
    return $?
}

##
# Get the parent class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
CLASS_Class_getClassTrace()
{
    [ -z "$CLASS_NAME" ] && error 'Not in a Class'
    printf '%s' "$CLASS_NAME"
    parent exists || return 1
    parent call getClassTrace
    return 0
}

##
# Check if the class has a parent.
#
# $?    0:TRUE   1:FALSE
CLASS_Class_hasParentClass()
{
    [ -z "$CLASS_NAME" ] && error 'Not in a Class'
    eval 'local CLASS_NAME="$_BASHOR_CLASS_'"$CLASS_NAME"'_EXTENDS"'
    [ -n "$CLASS_NAME" ]
    return $?
}

##
# Check if class is a instance of.
#
# $?    0:TRUE    1:FALSE
CLASS_Class_isA()
{
    [ -z "$CLASS_TOP_NAME" ] && error 'Not in a Class'
    requireParams R "$@"
    local className="$CLASS_TOP_NAME";
    while [ -n "$className" ]; do
        [ "$className" == "$1" ] && return 0
        eval 'local className="$_BASHOR_CLASS_'"$className"'_EXTENDS"'    
    done
    
    return 1
}

##
# Dump propertys of a class/object.
#
# $?    0:TRUE    1:FALSE
CLASS_Class_dumpPropertys()
{
    if inObject; then
        local count=$(this count)
        local key current=0
        while [ "$count" -gt "$current" ]; do
            key="$(this key "$current")"
            echo "$key"' : '"$(this get "$key")"
            ((current++))
        done
        return 0
    fi
    if inStatic; then
        local count=$(static count)
        local key current=0
        while [ "$count" -gt "$current" ]; do
            key="$(static key "$current")"
            echo "$key"' : '"$(static get "$key")"
            ((current++))
        done
        return 0
    fi
    
    return 1
}
