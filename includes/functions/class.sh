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
# @subpackage   Includes
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Load class.
#
# $1    string  namespace
# $@?   mixed  params
# $?    0:OK    1:ERROR
function loadClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    local IFS=$'\n\r'
    local dn
    local filename
    for dn in $BASHOR_PATHS_CLASS; do
        filename="$dn/""`echo "$1" | tr '_' '/'`"'.sh'
        if [ -f "$filename" ]; then
            . "$filename"
            eval _BASHOR_CLASS_"$1"_LOADED=1
            addClass "$@"
            return $?
        fi
    done
    
    return 1
}

##
# Load class once.
#
# $1    string  namespace
# $@?   mixed  params
# $?    0:OK    1:ERROR
function loadClassOnce()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    eval '[ -n "$_BASHOR_CLASS_'"$1"'_LOADED" ] && return 0'
    loadClass "$@"
    return $?
}

##
# Add Class functions.
#
# $1    string  class
# $@?   mixed  params
# $?    0:OK    1:ERROR
function addClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    local namespace=`_objectNamespace "$1"`   
    eval '[ -z "$'"$namespace"'_EXTENDS" ] && _addStdClass '"$1"    
    eval "$namespace"'_POINTER='"`_generatePointer`"    
    local pointer="`eval 'echo $'"$namespace"'_POINTER'`"
    eval "$pointer"_DATA=
    
    declare -F | grep '^declare -f CLASS_'"$1"'___load$' > /dev/null
    if [ "$?" == 0 ]; then
        _staticCall "$1" __load
        return $?
    fi
    
    return 0
}

##
# Add standart class.
#
# $1    string  class
# $?    0:OK    1:ERROR
function _addStdClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    local namespace=`_objectNamespace "$1"` 
    
    _createExtendedClassFunctions "$1" Class 1
    eval "$namespace"'_EXTENDS=Class'
    return 0
}

##
# Create class functions for extended class.
#
# $1    string  new class
# $2    string  parent class
# $?    0:OK    1:ERROR
function _createExtendedClassFunctions()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    local fList=`declare -F \
        | sed -n 's#^declare -f CLASS_'"$2"'_\(.*\)$#\1#p'`
    local IFS=$'\n\r'
    local f
    local fNameParent
    local fNameNew
    for f in $fList; do
        fNameParent=CLASS_"$2"_"$f"
        fNameNew=CLASS_"$1"_"$f"
        if [ -z "$3" ] || ! functionExists "$fNameNew"; then
            eval 'function '"$fNameNew"'() { '"$fNameParent"' "$@"; return $?; }'
        fi
    done
}

##
# Call a class method
#
# $1    string  class name
# $2    string  function name
# $@    params
# $?    0:OK    1:ERROR
function class()
{
    _staticCall "$@"
    return $?
}

##
# Call a class method
#
# $1    string  class name
# $2    string  function name
# $PARENT?   string  child class name
# $@    params
# $?    0:OK    1:ERROR
function _staticCall()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
	local CLASS_NAME="$1"
	local CLASS_TOP_NAME="$1"
    local OBJECT_NAME=
    local STATIC=1
    local OBJECT=
    local OBJECT_POINTER=
	
	shift
	_call "$@"
    return $?
}

##
# Call a object method
#
# $1    string  pointer
# $2    string  function name
# $@    params
# $?    0:OK    1:ERROR
function object()
{
    _objectCall "$@"
    return $?
}

##
# Save object data
#
# $1    string  var name
# $2    mixed   data
# $?    0:OK    1:ERROR
function _objectLoadData()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ "$#" -lt 2 ] && error '2: Parameter not set'
    
    if [ -p /dev/stdin ]; then
        local value=`cat -`
    else
        local value="$2"
    fi
    
    value=`echo "$value" | tail -n +2 | base64 -d`    
    eval "$1"'="$value"'
    return $?
}

##
# load object data
#
# $1    string  var name
# $?    0:OK    1:ERROR
function _objectSaveData()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    echo 'bashor dump 0.0.0 objectData'
    eval 'echo "$'"$1"'"' | base64
    return $?
}

##
# Call a object method
#
# $1    string  pointer
# $2    string  function name
# $@    params
# $?    0:OK    1:ERROR
function _objectCall()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    isset var "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
    
    local OBJECT_NAME="$2"
    local STATIC=
    local OBJECT=1
    eval 'local CLASS_NAME="$'"$1"'_CLASS"'
    eval 'local OBJECT_POINTER='"$1"    
    local CLASS_TOP_NAME="$CLASS_NAME"
    eval 'local OBJECT_ID="$'"$1"'_ID"'
    
    shift 1;
    _call "$@"
    return $?
}

##
# Call a object / static method
#
# $1    string  function name
# $@    params
# $?    0:OK    1:ERROR
function _call()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    local FUNCTION_NAME="$1"
    local fName=CLASS_"$CLASS_NAME"_"$FUNCTION_NAME"
    if declare -f "$fName" > /dev/null; then
        shift
        "$fName" "$@"
        return $?
    fi

    local fName=CLASS_"$CLASS_NAME"___call
    if declare -f "$fName" > /dev/null; then
        "$fName" "$@"
        return $?
    fi
    
    error "No method \"$FUNCTION_NAME\" in \"$CLASS_NAME\"!"
    return 1
}

##
# Create a new object from class.
#
# $1    string  var name
# $2    string  class name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function new()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'    
    local varname="$2"
    local class="$1"
    shift 2
    
    local pointer="`_generatePointer`";    
    local callLine="`caller | sed -n 's#^\([0-9]\+\).*$#\1#p';`"
    eval "$pointer"'_CLASS='"$class"
    eval "$pointer"=    
    eval "$pointer"_DATA=
    
    eval "$varname"="$pointer";
    
    declare -F | grep '^declare -f CLASS_'"$class"'___construct$' > /dev/null
    if [ "$?" == 0 ]; then
        _objectCall "$pointer" __construct "$@"
        return 0
    fi

    return 0
}

##
# Extends a class.
#
# $1    string  class name
# $2    string  object name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function extends()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    local namespace=`_objectNamespace "$1"`
    eval "$namespace"'_EXTENDS'"='$2'"
    _createExtendedClassFunctions "$1" "$2"
    
    return 0
}

##
# Clone object.
#
# $1    string  object name
# $2    string  object name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function clone()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    isset var "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
        
    local varname="$2";
    local pointer1="$1";
    local pointer2="`_generatePointer`"; 
    shift
        
    eval 'local class1="$'"$pointer1"'_CLASS"'
    eval "$pointer2"=
    eval "$pointer2"'_CLASS="$'"$pointer1"'_CLASS"'
    eval "$pointer2"'_DATA="$'"$pointer1"'_DATA"'        
    
    eval "$varname"="$pointer2";
        
    declare -F | grep '^declare -f CLASS_'"$class1"'___clone$' > /dev/null
    if [ "$?" == 0 ]; then
        _objectCall "$pointer2" __clone
        return $?
    fi
    
    return 0
}

##
# Remove a object.
#
# $1    string  object name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function remove()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    isset var "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
    _objectRemove "$1"
    return $?
}

##
# Remove a object.
#
# $1    string  pointer
# $@?   mixed  params
# $?    0:OK    1:ERROR
function _objectRemove()
{
    [ -z "$1" ] && error '1: Parameter empty or not set' 

    local res=0
    local pointer="$1"
    eval 'local ns="$'"$nsObjClassOld"'"'
        
    declare -F | grep '^declare -f CLASS_'"$ns"'___destruct$' > /dev/null
    if [ "$?" == 0 ]; then
        _objectCall "$pointer" __destruct
        res=$?
    fi
    
    eval 'unset -v '"$pointer"_DATA    
    eval 'unset -v '"$pointer"_ID
    eval 'unset -v '"$pointer"_CLASS
    eval 'unset -v '"$pointer"
    
    return "$res"
}

##
# Get object namespace.
#
# $1   string  class name
# &1    string var name
# $?    0:OK    1:ERROR
function _objectNamespace()
{
    [ "$#" -lt 1 ] && error '1: Parameter empty or not set'   

    local namespace=CLASS_"$1"
    echo _BASHOR_"$namespace"
    return 0
}

##
# Generate a pointer id.
#
# &1    string  pointer id
# $?    0:OK    1:ERROR
function _generatePointer()
{
    local uniq=
    local pointer
    while true; do
        pointer="`date +_BASHOR_POINTER_%s%N_$RANDOM`"
        isset var "$pointer" || break
    done;
    echo "$pointer"
    return 0
}

##
# Access to the object.
#
# $1    string  action
# $CLASS_NAME   string  class name
# $@?   mixed   params
# &1    mixed
# $?    0:OK    1:ERROR
function this()
{
    [ -z "$1" ] && error '1: Parameter empty or not set' 
    [ -z "$CLASS_NAME" ] && error 'CLASS_NAME: Parameter empty or not set' 
    
    if [ -n "$OBJECT" ]; then
        local dataVarName="$OBJECT_POINTER"_DATA
    else
        local namespace=`_objectNamespace "$1"`  
        local OBJECT_POINTER="`eval 'echo $'"$namespace"'_POINTER'`"
        local dataVarName="$OBJECT_POINTER"_DATA
    fi
    
    case "$1" in
        get)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _objectGet "$dataVarName" "$2"
            return $?
            ;;
        set)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            [ "$#" -lt 3 ] && error '3: Parameter not set'
            _objectSet "$dataVarName" "$2" "$3"
            return $?
            ;;
        unset)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _objectUnset "$dataVarName" "$2"
            return $?
            ;;
        isset)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _objectIsset "$dataVarName" "$2"
            return $?
            ;;
        call)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            shift
			_call "$@"
			return $?
            ;;
        save)
            _objectSaveData "$dataVarName"
            return $?
            ;;
        load)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _objectLoadData "$dataVarName" "$2"
            return $?
            ;;
        *)
            error "\"$1\" is not a option of this!"
            ;;
    esac
    
    return 1
}

##
# Access to the parent object.
#
# $1    string  action
# $CLASS_NAME   string  class name
# $@?   mixed   params
# &1    mixed
# $?    0:OK    1:ERROR
function parent()
{
    [ -z "$1" ] && error '1: Parameter empty or not set' 
    [ -z "$CLASS_NAME" ] && error 'CLASS_NAME: Parameter empty or not set' 
    
	local namespace=`_objectNamespace "$CLASS_NAME"` 
    eval 'local parent="$'"$namespace"'_EXTENDS"'

    case "$1" in
        call)
            [ -z "$parent" ] && error 'parent: Parameter empty or not set' 
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            shift
            local CLASS_NAME="$parent";
			_call "$@"
			return=$?
            ;;
        exists)
            [ -n "$parent" ]
            return=$?
            ;;
        *)
            error "\"$1\" is not a option of parent!"
            ;;
    esac
    
    return 1
}

##
# Access to the object.
#
# $CLASS_NAME   string  class name
# $OBJECT_NAME  string  object name
# $?    0:OK    1:ERROR
function isStatic()
{   
    [ -z "$CLASS_NAME" ] && error 'CLASS_NAME: Parameter empty or not set'
    isset var 'OBJECT_NAME' || error 'OBJECT_NAME: Parameter not set' 
    return $?
}

##
# Save in object var.
#
# $1    string  var name
# $2    string  key
# $3    string  data
# $?    0:OK    1:ERROR
# &0    string  Data
function _objectSet()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'  

    if [ "$#" -lt 3 ] && [ -p /dev/stdin ]; then
        local value=`cat - | base64 -w 0`
    else
        local value=`echo "$3" | base64 -w 0`
    fi
                
    local key=`echo "$2" | base64 -w 0`
        
    eval 'local data="$'"$1"'"'
    data=`echo "$key $value"; echo -n "$data" | grep -v "^${key}\s\+.*$"`
    eval "$1"'="$data"'
    
    return $?
}

##
# Remove object var.
#
# $1    string  var name
# $2    string  key
# $?    0:OK    1:ERROR
function _objectUnset()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'  
    
    eval 'local data="$'"$1"'"' 
    local key=`echo "$2" | base64 -w 0`
    data=`echo "$data" | grep -v "^${key}\s\+.*$"`
    eval "$1"'="$data"'
    
    return $?
}

##
# Get object var.
#
# $1    string  var name
# $2    string  key
# $?    0:OK    1:ERROR
# &0    string  Data
function _objectGet()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set' 
    
    eval 'local data="$'"$1"'"' 
    local key=`echo "$2" | base64`
    data=`echo "$data" | grep "^$key "`    
    if [ $? == 0 ]; then
        echo "$data" | sed 's#\S\+\s\+##' | base64 -d
        return 0
    fi
    
    return 1
}

##
# Check if is set in object var.
#
# $1    string  var name
# $2    string  key
# $?    0:OK    1:ERROR
function _objectIsset()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'  
    
    eval 'local data="$'"$1"'"'
    local key=`echo "$2" | base64`
    data="`echo "$data" | grep "^$key "`"
    return $?
}

. "$BASHOR_PATH_INCLUDES/Class.sh"
