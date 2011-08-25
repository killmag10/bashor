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
loadClass()
{
    requireParams R "$@"
    
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
loadClassOnce()
{
    requireParams R "$@"
    
    eval '[ -n "$_BASHOR_CLASS_'"$1"'_LOADED" ]' || loadClass "$1"
    return $?
}

##
# Autoloader for Classes
#
# $1    string  class
# $?    0       OK
# $?    1       ERROR
__autoloadClass()
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
__hookClassRouter()
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
addClass()
{
    requireParams R "$@"
    
    eval _BASHOR_CLASS_"$1"_LOADED=1
    local namespace='_BASHOR_CLASS_'"$1"  
    local pointer
    _bashor_generatePointer pointer "$BASHOR_TYPE_OBJECT"
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
_bashor_addStdClass()
{
    requireParams R "$@"
    
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
_bashor_createExtendedClassFunctions()
{
    requireParams RR "$@"
    
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
class()
{
    requireParams RR "$@"
    
    local CLASS_NAME="$1"    
    __hookClassRouter || return 1
    local CLASS_TOP_NAME="$CLASS_NAME"
    local OBJECT_NAME= OBJECT= OBJECT_POINTER= STATIC=1
    shift
    _bashor_call "$@"
    return $?
}

##
# Check if a class exists.
#
# $1    string  class name
# $?    0       FOUND
# $?    1       NOT FOUND
classExists()
{
    requireParams R "$@"
    
    local classVarName=_BASHOR_CLASS_"$1"
    [ -n "${!classVarName}" ]
    return $?
}

##
# Load object data
#
# $1    string  var name
# $2    mixed   data
# $?    0       OK
# $?    1       ERROR
_bashor_objectLoadData()
{
    requireParams RS "$@"
    
    local dataLine="$(echo "$2" | grep '^DATA=' -n | sed 's/:.*$//')"
    local value="$(echo "$2" | tail -n +$((++dataLine)) | decodeData)"
    eval "$1"'="$value"'
    return $?
}

##
# save object data
#
# $1    string  var name
# $?    0       OK
# $?    1       ERROR
_bashor_objectSaveData()
{
    requireParams R "$@"
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
object()
{    
    requireParams RR "$@" 
    if [ ! "${!1}" == "$BASHOR_TYPE_OBJECT" ] || [[ ! "$1" =~ ^_BASHOR_POINTER_ ]]; then
        error 'Pointer "'"$1"'" is not a Object!'
    fi
    
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
serialize()
{    
    {
        requireParams R "$@"
        issetVar "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
        
        local OBJECT_POINTER CLASS_NAME
        clone "$1" OBJECT_POINTER
        CLASS_NAME="$OBJECT_POINTER"_CLASS
        CLASS_NAME="${!CLASS_NAME}"
        
        if issetFunction CLASS_"$CLASS_NAME"___sleep; then
            object "$OBJECT_POINTER" __sleep
        fi
    } 1>/dev/null
    
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
unserialize()
{
    requireParams R "$@"
    local _bashor_temp_dataLine _bashor_temp_header CLASS_NAME
    
    if [ "$#" -lt 2 ] && [ -p /dev/stdin ]; then
        local _bashor_temp_data=$(cat -)
    else
        local _bashor_temp_data="$2"
    fi
    
    _bashor_temp_dataLine=$(
        echo "$_bashor_temp_data" | grep '^DATA=' -n | sed 's/:.*$//'
    )
    ((_bashor_temp_dataLine--))
    _bashor_temp_header="$(echo "$_bashor_temp_data" | head -n $_bashor_temp_dataLine)"
    
    CLASS_NAME=$(echo "$_bashor_temp_header" | sed -n 's/^CLASS_NAME=//1p')
    _bashor_generatePointer "${1}" "$BASHOR_TYPE_OBJECT"
    eval "${!1}"'_CLASS='"$CLASS_NAME"
    eval "${!1}"_DATA=

    _bashor_objectLoadData "${!1}"_DATA "$_bashor_temp_data";
    local _bashor_temp_res="$?"
    
    if issetFunction CLASS_"$CLASS_NAME"___wakeup; then
        object "${!1}" __wakeup 1>/dev/null
    fi
    
    return $_bashor_temp_res
}

##
# Call a object / static method
#
# $1    string  function name
# $@    mixed   method params
# $?    0       OK
# $?    1       ERROR
_bashor_call()
{    
    requireParams R "$@" 
    [ "$BASHOR_CLASS_AUTOLOAD" == 1 ] && __autoloadClass "$CLASS_NAME"
      
    eval '[ -z "$_BASHOR_CLASS_'"$CLASS_NAME"'" ]' \
         && error "No class $CLASS_NAME found!"
    
    local FUNCTION_NAME="$1"
    
    if issetFunction CLASS_"$CLASS_NAME"_"$FUNCTION_NAME"; then
        shift
        CLASS_"$CLASS_NAME"_"$FUNCTION_NAME" "$@"
        return $?
    fi

    if issetFunction CLASS_"$CLASS_NAME"___call; then
        CLASS_"$CLASS_NAME"___call "$@"
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
new()
{
    requireParams RR "$@"
    
    local CLASS_NAME="$1"
    __hookClassRouter || return 1
    [ "$BASHOR_CLASS_AUTOLOAD" == 1 ] && __autoloadClass "$CLASS_NAME"
    local OBJECT_POINTER
    _bashor_generatePointer OBJECT_POINTER "$BASHOR_TYPE_OBJECT"
    eval "$OBJECT_POINTER"'_CLASS="$CLASS_NAME"'
    eval "$OBJECT_POINTER"_DATA=
    eval "$2"'="$OBJECT_POINTER"'
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
extends()
{
    requireParams RR "$@"
    
    [ "$BASHOR_CLASS_AUTOLOAD" == 1 ] && __autoloadClass "$2"
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
clone()
{    
    requireParams RR "$@"
    isObject "$1" || error 'Pointer "'"$1"'" is not a Object!'
    
    _bashor_generatePointer "$2" "$BASHOR_TYPE_OBJECT"        
    eval 'local CLASS_NAME="$'"$1"'_CLASS"'
    eval "${!2}"'_CLASS="$'"$1"'_CLASS"'
    eval "${!2}"'_DATA="$'"$1"'_DATA"'
    
    if issetFunction CLASS_"$CLASS_NAME"___clone; then
        object "${!2}" __clone
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
remove()
{
    requireParams R "$@"
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
# $1    string  output var name
# $2    string  pointer type
# &1    pointer pointer id
# $?    0       OK
# $?    1       ERROR
_bashor_generatePointer()
{
    requireParams R "$@"
    
    local _bashor_temp_pointer
    while true; do
        _bashor_temp_pointer=_BASHOR_POINTER_"$(date +%s%N)"
        issetVar "$_bashor_temp_pointer" || break
    done;
    eval "$_bashor_temp_pointer"="$2"
    eval "$1"="$_bashor_temp_pointer"
    return 0
}

##
# Access to the object.
#
# call [method]:    call a method of the current class/object
# pointer:          get the pointer of the object
# get [key]:        get the contend of a var from the object/class
# set [key]:        set the contend of a var from the object/class
# unset [key]:      remove a var from the object/class
# isset [key]:      check if a var from the object/class is set
# count:            get the count of vars from the object/class
# key:              get the key of a var from the object/class var list
# clear:            remove all vars from a object/class
#
# $1    string  action (call,pointer,get,set,unset,isset)
# $@    mixed   params
# $?    *       all of class method
this()
{
    requireParams R "$@"
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
        clear)
             _bashor_objectClear "$dataVarName"
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
parent()
{
    requireParams R "$@"
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
_bashor_objectSet()
{
    requireParams RR "$@"  

    if [ "$#" -lt 3 ] && [ -p /dev/stdin ]; then
        local value=$(cat - | encodeData)
    else
        local value=$(echo "$3" | encodeData)
    fi
    
    local key=$(echo "$2" | encodeData)
    local data=$(echo -n "${!1}" \
        | grep -v "^${key}[[:space:]]\+.*$"; echo "$key $value";)
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
_bashor_objectUnset()
{
    requireParams RR "$@"
    
    local key=$(echo "$2" | encodeData)
    local data=$(echo "${!1}" | grep -v "^${key}[[:space:]]\+.*$")
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
_bashor_objectGet()
{
    requireParams RR "$@"
    
    data=$(echo "${!1}" | grep "$(echo "$2" | encodeData)")    
    [ $? == 0 ] || return 1
    
    echo "$data" | cut -d ' ' -f 2 | decodeData
    return 0
}

##
# Get the count of the object vars.
#
# $1    string  var name
# $?    0       OK
# $?    1       ERROR
# &0    integer count
_bashor_objectCount()
{
    requireParams R "$@"
    
    if [ -z "${!1}" ]; then
        echo 0 
        return 0
    fi
    
    echo "${!1}" | wc -l    
    return 0
}

##
# Remove all vars of the object.
#
# $1    string  var name
# $?    0       OK
# $?    1       ERROR
_bashor_objectClear()
{
    eval "$1"'='  
    return 0
}

##
# Get the keys of the object vars.
#
# $1    string  var name
# $?    0       OK
# $?    1       ERROR
# &0    integer count
_bashor_objectKey()
{
    requireParams RR "$@"
    
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
_bashor_objectIsset()
{
    requireParams RR "$@"
    
    local key=$(echo "$2" | encodeData)
    echo "${!1}" | grep "^$key " >/dev/null
    return $?
}

##
# Check if it is a Pointer of a object.
#
# $1    mixed   string to check
# $?    0       OK
# $?    1       ERROR
isObject()
{
    requireParams S "$@"
    
    [ "${!1}" == "$BASHOR_TYPE_OBJECT" ] && [[ "$1" =~ ^_BASHOR_POINTER_ ]]
    return $?
}

##
# Check if you are in a object call otherwise it will trow a error.
#
# $?    0       OK
# $?    1       ERROR
requireObject()
{
    [ -z "$OBJECT" ] && error 'Not a object call!'
}

##
# Check if you are in a static call otherwise it will trow a error.
#
# $?    0       OK
# $?    1       ERROR
requireStatic()
{
    [ -z "$Static" ] && error 'Not a static call!'
}

. "$BASHOR_PATH_INCLUDES/Class.sh"
