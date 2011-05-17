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
# $?    0       OK
# $?    1       ERROR
function loadClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    local dn filename IFS=$'\n\r'
    for dn in $BASHOR_PATHS_CLASS; do
        filename="$dn/""${1//_//}"'.sh'
        [ -f "$filename" ] || continue
        . "$filename"
        addClass "$1"
        return $?
    done
    
    return 1
}

##
# Load class once.
#
# $1    string  namespace
# $?    0       OK
# $?    1       ERROR
function loadClassOnce()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    eval '[ -n "$_BASHOR_CLASS_'"$1"'_LOADED" ]' || loadClass "$1"
    return $?
}

##
# Autoloader for Classes
#
# $1    string  class
# $?    0       OK
# $?    1       ERROR
function __autoloadClass()
{
    loadClassOnce "$1"
    return $?
}

##
# Hook for class routing.
#
# $CLASS_NAME   string  class name what will be call
# $?    0       OK
# $?    1       ERROR
function __hookClassRouter()
{    
    return 0
}

##
# Add Class functions.
#
# $1    string  class
# $@    mixed  params
# $?    0       OK
# $?    1       ERROR
function addClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    eval _BASHOR_CLASS_"$1"_LOADED=1
    local namespace='_BASHOR_CLASS_'"$1"  
    local pointer="$(_bashor_generatePointer)"
    eval '[ -z "$'"$namespace"'_EXTENDS" ] && _bashor_addStdClass '"$1"   
    eval "$namespace"='"$1"'
    eval "$namespace"'_POINTER='"$pointer"
    eval "$pointer"_DATA=
    unset -v namespace pointer
    
    issetFunction CLASS_"$1"___load
    if [ "$?" == 0 ]; then
        class "$1" __load
        return $?
    fi
    
    return 0
}

##
# Add standart class.
#
# $1    string  class
# $?    0       OK
# $?    1       ERROR
function _bashor_addStdClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    _bashor_createExtendedClassFunctions "$1" Class 1
    eval '_BASHOR_CLASS_'"$1"'_EXTENDS=Class'
    return 0
}

##
# Create class functions for extended class.
#
# $1    string  new class
# $2    string  parent class
# $?    0       OK
# $?    1       ERROR
function _bashor_createExtendedClassFunctions()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    local fList=$(declare -F | sed -n 's#^declare -f CLASS_'"$2"'_\(.*\)$#\1#p')
    local f fNameParent fNameNew IFS=$'\n\r'
    for f in $fList; do
        fNameParent=CLASS_"$2"_"$f"
        fNameNew=CLASS_"$1"_"$f"
        if [ -z "$3" ] || ! issetFunction "$fNameNew"; then
            eval 'function '"$fNameNew"'() { '"$fNameParent"' "$@"; return $?;}'
        fi
    done
}

##
# Call a class method
#
# $1    string  class name
# $2    string  function name
# $@    mixed   method params
# $?    *       all of class method
function class()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    local CLASS_NAME="$1"    
    __hookClassRouter || return 1
    local CLASS_TOP_NAME="$CLASS_NAME"
    local OBJECT_NAME= OBJECT= OBJECT_POINTER= STATIC=1
    shift
    _bashor_call "$@"
    return $?
}

##
# Load object data
#
# $1    string  var name
# $2    mixed   data
# $?    0       OK
# $?    1       ERROR
function _bashor_objectLoadData()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ "$#" -lt 2 ] && error '2: Parameter not set'
    
    local value="$2"
    local dataLine=$(echo "$value" | grep '^DATA=' -n | sed 's/:.*$//')
    ((dataLine++))
    value=$(echo "$value" | tail -n +$dataLine | decodeData)   
    eval "$1"'="$value"'
    return $?
}

##
# save object data
#
# $1    string  var name
# $?    0       OK
# $?    1       ERROR
function _bashor_objectSaveData()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    echo 'bashor dump 1.0.0 objectData'
    echo "CLASS_NAME=$CLASS_NAME"
    echo 'DATA='
    echo "${!1}" | encodeData
    return $?
}

##
# Call a object method
#
# $1    string  pointer
# $2    string  function name
# $@    mixed   method params
# $?    *       all of class method
function object()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    [ -z "$1"'_CLASS' ] && error 'Pointer "'"$1"'" is not a Object!'
    
    local OBJECT_NAME OBJECT_POINTER CLASS_TOP_NAME CLASS_NAME STATIC= OBJECT=1
    OBJECT_NAME="$2"
    OBJECT_POINTER="$1"
    eval 'CLASS_NAME="$'"$1"'_CLASS"'
    CLASS_TOP_NAME="$CLASS_NAME"
    
    shift 1;
    _bashor_call "$@"
    return $?
}

##
# Serialize a object.
#
# $1    string  pointer
# &1    string  serialized data
# $?    0       OK
# $?    1       ERROR
function serialize()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    issetVar "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
    
    eval 'local CLASS_NAME="$'"$1"'_CLASS"'
    local OBJECT_POINTER="$1"
    
    if issetFunction CLASS_"$CLASS_NAME"___sleep; then
        object "$OBJECT_POINTER" __sleep
    fi
    
    _bashor_objectSaveData "$OBJECT_POINTER"_DATA
    return $?
}

##
# Unserialize a object.
#
# $1    string  var name
# $2    string  serialized data
# $?    0       OK
# $?    1       ERROR
function unserialize()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    if [ "$#" -lt 2 ] && [ -p /dev/stdin ]; then
        local data=$(cat -)
    else
        local data="$2"
    fi
    
    local dataLine=$(echo "$data" | grep '^DATA=' -n | sed 's/:.*$//')
    ((dataLine--))
    local header="$(echo "$data" | head -n $dataLine)"
    
    local CLASS_NAME=$(echo "$header" | sed -n 's/^CLASS_NAME=//1p')
    local OBJECT_POINTER="$(_bashor_generatePointer)"
    eval "$OBJECT_POINTER"'_CLASS='"$CLASS_NAME"
    eval "$OBJECT_POINTER"_DATA=
    eval "$1"="$OBJECT_POINTER"

    _bashor_objectLoadData "$OBJECT_POINTER"_DATA "$data";
    local res="$?"
    
    if issetFunction CLASS_"$CLASS_NAME"___wakeup; then
        object "$OBJECT_POINTER" __wakeup
    fi
    
    return $res
}

##
# Call a object / static method
#
# $1    string  function name
# $@    mixed   method params
# $?    0       OK
# $?    1       ERROR
function _bashor_call()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'    
    [ "$BASHOR_CLASS_AUTOLOAD" == 1 ] && __autoloadClass "$CLASS_NAME"
      
    eval '[ -z "$_BASHOR_CLASS_'"$CLASS_NAME"'" ]' \
         && error "No class $CLASS_NAME found!"
    
    local FUNCTION_NAME="$1"
    
    if issetFunction CLASS_"$CLASS_NAME"_"$FUNCTION_NAME"; then
        shift
        CLASS_"$CLASS_NAME"_"$FUNCTION_NAME" "$@"
        return $?
    fi

    if issetFunction CLASS_"$CLASS_NAME"___bashor_call; then
        CLASS_"$CLASS_NAME"___bashor_call "$@"
        return $?
    fi
    
    error "No method \"$FUNCTION_NAME\" in \"$CLASS_NAME\"!"
    return 1
}

##
# Create a new object from class.
#
# $1    string  class name
# $2    string  var name
# $@    mixed   method params
# $?    0       OK
# $?    1       ERROR
function new()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    local CLASS_NAME="$1"
    __hookClassRouter || return 1
    [ "$BASHOR_CLASS_AUTOLOAD" == 1 ] && __autoloadClass "$CLASS_NAME"
    local OBJECT_POINTER="$(_bashor_generatePointer)"
    eval "$OBJECT_POINTER"'_CLASS='"$CLASS_NAME"
    eval "$OBJECT_POINTER"_DATA=
    eval "$2"="$OBJECT_POINTER"
    if issetFunction CLASS_"$CLASS_NAME"___construct; then
        shift 2
        object "$OBJECT_POINTER" __construct "$@"
    fi

    return 0
}

##
# Extends a class.
#
# $1    string  class name
# $2    string  parent class name
# $?    0       OK
# $?    1       ERROR
function extends()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    eval '_BASHOR_CLASS_'"$1"'_EXTENDS'"='$2'"
    _bashor_createExtendedClassFunctions "$1" "$2"    
    return 0
}

##
# Clone object.
#
# $1    string  object name
# $2    string  object name
# $?    *       all of class method __clone
function clone()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    issetVar "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
        
    local varname="$2"
    local pointer1="$1"
    local pointer2="$(_bashor_generatePointer)"
    shift 2
        
    eval 'local CLASS_NAME="$'"$pointer1"'_CLASS"'
    eval "$pointer2"'_CLASS="$'"$pointer1"'_CLASS"'
    eval "$pointer2"'_DATA="$'"$pointer1"'_DATA"'
    eval "$varname"="$pointer2";
    
    local OBJECT_POINTER="$pointer2"
    unset -v pointer1 pointer2 varname
        
    issetFunction CLASS_"$CLASS_NAME"___clone
    if [ "$?" == 0 ]; then
        object "$OBJECT_POINTER" __clone
        return $?
    fi
    
    return 0
}

##
# Remove a object.
#
# $1    tring  pointer
# $?    0       OK
# $?    1       ERROR
function remove()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$1"_CLASS ] && error 'Pointer "'"$1"'" is not a Object!'

    local CLASS_NAME res=0
    local OBJECT_POINTER="$1"
    eval 'CLASS_NAME="$'"$OBJECT_POINTER"'_CLASS"'
        
    if issetFunction CLASS_"$CLASS_NAME"___destruct; then
        object "$OBJECT_POINTER" __destruct
        res=$?
    fi
    
    unset -v "$OBJECT_POINTER"_DATA "$OBJECT_POINTER"_ID
    unset -v "$OBJECT_POINTER"_CLASS "$OBJECT_POINTER"
    
    return "$res"
}

##
# Generate a pointer id.
#
# &1    pointer pointer id
# $?    0       OK
# $?    1       ERROR
function _bashor_generatePointer()
{
    local pointer
    while true; do
        pointer="$(date +_BASHOR_POINTER_%s%N)"
        issetVar "$pointer" || break
    done;
    eval "$pointer"=
    echo "$pointer"
    return 0
}

##
# Access to the object.
#
# $1    string  action (call,pointer,get,set,unset,isset)
# $@    mixed   params
# $?    *       all of class method
function this()
{
    [ -z "$1" ] && error '1: Parameter empty or not set' 
    [ -z "$CLASS_NAME" ] && error 'CLASS_NAME: Parameter empty or not set' 
    
    case "$1" in
        call)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            shift
            _bashor_call "$@"
            return $?
            ;;
        pointer)
            [ -z "$OBJECT" ] && error 'Not a Object'
            [ -z "$OBJECT_POINTER" ] && error 'No pointer found'
            echo "$OBJECT_POINTER"
            return 0
            ;;
    esac
    
    if [ -z "$OBJECT" ]; then
        eval 'local OBJECT_POINTER=$_BASHOR_CLASS_'"$CLASS_NAME"'_POINTER'
    fi
    local dataVarName="$OBJECT_POINTER"_DATA
    
    case "$1" in
        get)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _bashor_objectGet "$dataVarName" "$2"
            return $?
            ;;
        set)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            [ "$#" -lt 3 ] && error '3: Parameter not set'
            _bashor_objectSet "$dataVarName" "$2" "$3"
            return $?
            ;;
        unset)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _bashor_objectUnset "$dataVarName" "$2"
            return $?
            ;;
        isset)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _bashor_objectIsset "$dataVarName" "$2"
            return $?
            ;;
        count)
            _bashor_objectCount "$dataVarName"
            return $?
            ;;
        key)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            _bashor_objectKey "$dataVarName" "$2"
            return $?
            ;;
        *)
            error "\"$1\" is not a option of this!"
            ;;
    esac
    
    return 1
}

##
# Access to the parent class.
#
# $1    string  action (call,exists)
# $@    mixed   params
# $?    *       all of class method
function parent()
{
    [ -z "$1" ] && error '1: Parameter empty or not set' 
    [ -z "$CLASS_NAME" ] && error 'CLASS_NAME: Parameter empty or not set' 
    
    eval 'local CLASS_NAME="$_BASHOR_CLASS_'"$CLASS_NAME"'_EXTENDS"'
    case "$1" in
        call)
            [ -z "$CLASS_NAME" ] && error 'parent: Parameter empty or not set' 
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            shift
			_bashor_call "$@"
			return $?
            ;;
        exists)
            [ -n "$CLASS_NAME" ]
            return $?
            ;;
        *)
            error "\"$1\" is not a option of parent!"
            ;;
    esac
    
    return 1
}

##
# Save in object var.
#
# $1    string  var name
# $2    string  key
# $3    string  data
# $?    0       OK
# $?    1       ERROR
# &0    string  Data
function _bashor_objectSet()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'  

    if [ "$#" -lt 3 ] && [ -p /dev/stdin ]; then
        local value=$(cat - | encodeData)
    else
        local value=$(echo "$3" | encodeData)
    fi
    local key=$(echo "$2" | encodeData)
    
    local data="${!1}"
    data=$(echo -n "$data" | grep -v "^${key}[[:space:]]\+.*$"; echo "$key $value";)
    eval "$1"'="$data"'
    
    return $?
}

##
# Remove object var.
#
# $1    string  var name
# $2    string  key
# $?    0       OK
# $?    1       ERROR
function _bashor_objectUnset()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'  
    
    local data="${!1}"
    local key=$(echo "$2" | encodeData)
    data=$(echo "$data" | grep -v "^${key}[[:space:]]\+.*$")
    eval "$1"'="$data"'
    
    return $?
}

##
# Get object var.
#
# $1    string  var name
# $2    string  key
# $?    0       OK
# $?    1       ERROR
# &0    string  Data
function _bashor_objectGet()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set' 
    
    local data="${!1}"
    local key=$(echo "$2" | encodeData)
    data=$(echo "$data" | grep "^$key ")    
    if [ $? == 0 ]; then
        echo "$data" | sed 's#[^[:space:]]\+[[:space:]]\+##' | decodeData
        return 0
    fi
    
    return 1
}

##
# Get the count of the object vars.
#
# $1    string  var name
# $?    0       OK
# $?    1       ERROR
# &0    integer count
function _bashor_objectCount()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    if [ -z "${!1}" ]; then
        echo 0 
        return 0
    fi
    
    echo "${!1}" | wc -l    
    return 0
}

##
# Get the keys of the object vars.
#
# $1    string  var name
# $?    0       OK
# $?    1       ERROR
# &0    integer count
function _bashor_objectKey()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    local IFS=$'\n'
    local data=(`echo "${!1}"`);
    [ "$2" -ge "${#data[@]}" ] && return 1;
    echo "${data[$2]}" | sed 's#^\([^[:space:]]\+\).\+$#\1#' | decodeData
    return $?
}

##
# Check if is set in object var.
#
# $1    string  var name
# $2    string  key
# $?    0       OK
# $?    1       ERROR
function _bashor_objectIsset()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'  
    
    local data="${!1}"
    local key=$(echo "$2" | encodeData)
    data=$(echo "$data" | grep "^$key ")
    return $?
}

. "$BASHOR_PATH_INCLUDES/Class.sh"
