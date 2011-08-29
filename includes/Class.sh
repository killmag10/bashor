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
CLASS_Class___load()
{
    requireStatic
    return 0
}

##
# Constructor
CLASS_Class___construct()
{
    requireObject
    return 0
}

##
# Destructor
CLASS_Class___destruct()
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
    echo "$CLASS_TOP_NAME"
    return 0
}

##
# Get the parent class name.
#
# $?    0:OK    1:ERROR
# &0    string  class name
CLASS_Class_getClassTrace()
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
# Check if class is a instance of.
#
# $?    0:TRUE    1:FALSE
CLASS_Class_dumpPropertys()
{
    if [ -n "$OBJECT" ]; then
        local count=$(this count)
        local key current=0
        while [ "$count" -gt "$current" ]; do
            key="$(this key "$current")"
            echo "$key"' : '"$(this get "$key")"
            ((current++))
        done
        return 0
    fi
    if [ -n "$STATIC" ]; then
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
