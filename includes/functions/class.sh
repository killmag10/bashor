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
# $1    string  namespace
# $@?   mixed  params
# $?    0:OK    1:ERROR
function addClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    eval '[ -z "$_OBJECT_CLASS_'"$1"'_EXTENDS" ] && _addStdClass '"$1"
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
# $1    string  namespace
# $?    0:OK    1:ERROR
function _addStdClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    _createExtendedClassFunctions "$1" Class 1
    eval '_OBJECT_CLASS_'"$1"'_EXTENDS=Class'
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
    local _OBJECT_PATH_OLD=
    local _OBJECT_PATH=___"$CLASS_NAME"
	
	shift
	_call "$@"
    return $?
}

##
# Call a object method
#
# $1    string  object name
# $2    string  function name
# $@    params
# $?    0:OK    1:ERROR
function object()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    if [ "$1" == local ]; then
        [ -z "$3" ] && error '3: Parameter empty or not set'
        local OBJECT_VISIBILITY=local
        shift
    else
        local OBJECT_VISIBILITY=global
    fi

    _objectCall '' "$@"
    return $?
}

##
# Save object data
#
# $1    string  object name
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
# $1    string  object name
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
# $1    boolean internal call '':FALSE '1':TRUE
# $2    string  object name
# $3    string  function name
# $@    params
# $?    0:OK    1:ERROR
function _objectCall()
{    
    [ "$#" -lt 1 ] && error '1: Parameter not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    [ -z "$3" ] && error '3: Parameter empty or not set'

    local OBJECT_NAME="$2"
    local STATIC=
    local OBJECT=1
    local namespace=`_objectNamespace "" "$2" "$1"`
    eval 'local CLASS_NAME="$'"$namespace"'_CLASS"'
    local CLASS_TOP_NAME="$CLASS_NAME"
    eval 'local OBJECT_ID="$'"$namespace"'_ID"'
    if [ -z "$1" ]; then
        if [ "$OBJECT_VISIBILITY" == 'global' ]; then
            local _OBJECT_PATH_OLD=
            local _OBJECT_PATH=__"$OBJECT_ID"
        else    
            local _OBJECT_PATH_OLD="$_OBJECT_PATH"
            local _OBJECT_PATH="$_OBJECT_PATH"__"$OBJECT_ID"
        fi
    fi
    
    shift 2;
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
# $1    string  class name
# $2    string  object name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function new()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    if [ "$1" == local ]; then
        [ -z "$3" ] && error '3: Parameter empty or not set'
        local OBJECT_VISIBILITY=local
        shift
    else
        local OBJECT_VISIBILITY=global
    fi
    
    local ns="$1"
    local nsObj="$2"
    shift 2
    
    local namespace=`_objectNamespace "$ns" "$nsObj" ''`
    
    local callLine="`caller | sed -n 's#^\([0-9]\+\).*$#\1#p';`"
    eval "$namespace"'_CLASS='"$ns"
    eval "$namespace"'_ID='"${ns}${callLine}"
    eval "$namespace"'_DATA=""'
    declare -F | grep '^declare -f CLASS_'"$ns"'___construct$' > /dev/null
    if [ "$?" == 0 ]; then
        _objectCall '' "$nsObj" __construct "$@"
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
    
    local namespace=`_objectNamespace "$1" '' ''`
    eval "$namespace"'_EXTENDS'"='$2'"
    _createExtendedClassFunctions "$1" "$2"
    
    return 0
}

##
# Clone object.
#
# $1    string  object name
# $2    string  cloned object name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function clone()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'    
    if [ "$1" == 'local' ]; then
        [ -z "$2" ] && error '2: Parameter empty or not set'
        local OBJECT_VISIBILITY="$1"
        shift
    else
        local OBJECT_VISIBILITY=global
    fi
    local name1="$1"
    local namespace1=`_objectNamespace "" "$name1" ''`
    shift
    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    if [ "$1" == 'local' ]; then
        [ -z "$2" ] && error '2: Parameter empty or not set'
        local OBJECT_VISIBILITY="$1"
        shift
    else
        local OBJECT_VISIBILITY=global
    fi
    local name2="$1"
    local namespace2=`_objectNamespace "" "$name2" ''`
    shift
    
    eval 'local class1="$'"$namespace1"'_CLASS"'
    eval "$namespace2"'_CLASS="$'"$namespace1"'_CLASS"'
    eval "$namespace2"'_DATA="$'"$namespace1"'_DATA"'
        
    declare -F | grep '^declare -f CLASS_'"$class1"'___clone$' > /dev/null
    if [ "$?" == 0 ]; then
        _objectCall '' "$name2" __clone
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
    if [ "$1" == local ]; then
        [ -z "$2" ] && error '2: Parameter empty or not set'
        local OBJECT_VISIBILITY="$1"
        shift
    else
        local OBJECT_VISIBILITY=global
    fi

    _objectRemove "$1" "1"
    return $?
}

##
# Remove a object.
#
# $1    string  object name
# $2    integer call _destruct 1:true 0:false
# $@?   mixed  params
# $?    0:OK    1:ERROR
function _objectRemove()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'   

    local res=0
    local nsObj="$1"
    local doCall="$2"
    local namespace=`_objectNamespace "$ns" "$nsObj" ''`
    eval 'local ns="$'"$nsObjClassOld"'"'
        
    if [ "$2" == 1 ]; then
        declare -F | grep '^declare -f CLASS_'"$ns"'___destruct$' > /dev/null
        if [ "$?" == 0 ]; then
            _objectCall '' "$ns" "$nsObj" __destruct
            res=$?
        fi
    fi
    
    eval 'unset -v '"$namespace"'_ID'
    eval 'unset -v '"$namespace"'_CLASS'
    eval 'unset -v '"$namespace"'_DATA'
    
    return "$res"
}

##
# Get object namespace.
#
# $1   string  class name
# $2   string  class name
# $3    boolean internal call '':FALSE '1':TRUE
# &1    string var name
# $?    0:OK    1:ERROR
function _objectNamespace()
{
    [ "$#" -lt 1 ] && error '1: Parameter empty or not set'   
    [ "$#" -lt 2 ] && error '2: Parameter empty or not set'   
    [ "$#" -lt 3 ] && error '3: Parameter empty or not set' 
       
    if [ -n "$2" ]; then
        if [ "$OBJECT_VISIBILITY" == global ]; then
            local namespace=OBJECT_GLOBAL_"$2"
        else
            if [ -n "$3" ]; then
				local namespace=OBJECT_LOCAL"$_OBJECT_PATH_OLD"_"$2"
			else
				local namespace=OBJECT_LOCAL"$_OBJECT_PATH"_"$2"
			fi
        fi
    else
        local namespace=CLASS_"$1"
    fi
    echo _BASHOR_"$namespace"
    return 0
}

##
# Access to the object.
#
# $1    string  object name
# $CLASS_NAME   string  class name
# $@?   mixed   params
# &1    mixed
# $?    0:OK    1:ERROR
function this()
{
    [ -z "$1" ] && error '1: Parameter empty or not set' 
    [ -z "$CLASS_NAME" ] && error 'CLASS_NAME: Parameter empty or not set' 
    
    local dataVarName="`_objectNamespace "$CLASS_TOP_NAME" "$OBJECT_NAME" '1'`"_DATA
    
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
# $1    string  object name
# $CLASS_NAME   string  class name
# $@?   mixed   params
# &1    mixed
# $?    0:OK    1:ERROR
function parent()
{
    [ -z "$1" ] && error '1: Parameter empty or not set' 
    [ -z "$CLASS_NAME" ] && error 'CLASS_NAME: Parameter empty or not set' 
    
	local namespace=`_objectNamespace "$CLASS_NAME" "" '1'` 
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

_OBJECT_PATH=

. "$BASHOR_PATH_INCLUDES/Class.sh"
