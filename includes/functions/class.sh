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
# $?    0:OK    1:ERROR
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
# $?    0:OK    1:ERROR
function loadClassOnce()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    eval '[ -n "$_BASHOR_CLASS_'"$1"'_LOADED" ] && return 0'
    loadClass "$1"
    return $?
}

##
# Autoloader for Classes
#
# $1    string  class
# $?    0:OK    1:ERROR
function __autoloadClass()
{
    loadClassOnce "$1"
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
    
    eval _BASHOR_CLASS_"$1"_LOADED=1
    local namespace='_BASHOR_CLASS_'"$1"  
    local pointer="$(_generatePointer)"
    eval '[ -z "$'"$namespace"'_EXTENDS" ] && _addStdClass '"$1"   
    eval "$namespace"='"$1"'
    eval "$namespace"'_POINTER='"$pointer"
    eval "$pointer"_DATA=
    unset -v namespace pointer
    
    declare -F CLASS_"$1"___load > /dev/null
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
# $?    0:OK    1:ERROR
function _addStdClass()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    
    _createExtendedClassFunctions "$1" Class 1
    eval '_BASHOR_CLASS_'"$1"'_EXTENDS=Class'
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
    
    local fList=$(declare -F | sed -n 's#^declare -f CLASS_'"$2"'_\(.*\)$#\1#p')
    local f fNameParent fNameNew IFS=$'\n\r'
    for f in $fList; do
        fNameParent=CLASS_"$2"_"$f"
        fNameNew=CLASS_"$1"_"$f"
        if [ -z "$3" ] || ! isset function "$fNameNew"; then
            eval 'function '"$fNameNew"'() { '"$fNameParent"' "$@"; return $?;}'
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
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
        
    local CLASS_NAME="$1"    
    local CLASS_TOP_NAME="$CLASS_NAME"
    local OBJECT_NAME= OBJECT= OBJECT_POINTER= STATIC=1

    shift
    _call "$@"
    return $?
}

##
# Load object data
#
# $1    string  var name
# $2    mixed   data
# $?    0:OK    1:ERROR
function _objectLoadData()
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
# load object data
#
# $1    string  var name
# $?    0:OK    1:ERROR
function _objectSaveData()
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
# $@    params
# $?    0:OK    1:ERROR
function object()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    isset var "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
    
    local OBJECT_NAME="$2"
    local STATIC= OBJECT=1
    eval 'local CLASS_NAME="$'"$1"'_CLASS"'
    local OBJECT_POINTER="$1"
    local CLASS_TOP_NAME="$CLASS_NAME"
    
    shift 1;
    _call "$@"
    return $?
}

##
# Serialize a object.
#
# $1    string  pointer
# &1    string  serialized data
# $?    0:OK    1:ERROR
function serialize()
{    
    [ -z "$1" ] && error '1: Parameter empty or not set'
    isset var "$1"'_CLASS' || error 'Pointer "'"$1"'" is not a Object!'
    
    eval 'local CLASS_NAME="$'"$1"'_CLASS"'
    local OBJECT_POINTER="$1"
    
    if isset function CLASS_"$CLASS_NAME"___sleep; then
        object "$OBJECT_POINTER" __sleep
    fi
    
    _objectSaveData "$OBJECT_POINTER"_DATA
    return $?
}

##
# Unserialize a object.
#
# $1    string  var name
# $2    string  serialized data
# $@?   mixed  params
# $?    0:OK    1:ERROR
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
    local OBJECT_POINTER="$(_generatePointer)"
    eval "$OBJECT_POINTER"'_CLASS='"$CLASS_NAME"
    eval "$OBJECT_POINTER"_DATA=
    eval "$1"="$OBJECT_POINTER"

    _objectLoadData "$OBJECT_POINTER"_DATA "$data";
    local res="$?"
    
    if isset function CLASS_"$CLASS_NAME"___wakeup; then
        object "$OBJECT_POINTER" __wakeup
    fi
    
    return $res
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
    
    [ "$BASHOR_CLASS_AUTOLOAD" == 1 ] && __autoloadClass "$CLASS_NAME"
      
    eval '[ -z "$_BASHOR_CLASS_'"$CLASS_NAME"'" ]' \
         && error "No class $CLASS_NAME found!"
    
    local FUNCTION_NAME="$1"
    local fName=CLASS_"$CLASS_NAME"_"$FUNCTION_NAME"
    if declare -f "$fName" > /dev/null; then
        shift
        "$fName" "$@"
        return $?
    fi

    fName=CLASS_"$CLASS_NAME"___call
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
# $2    string  var name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function new()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    local CLASS_NAME="$1"
    
    [ "$BASHOR_CLASS_AUTOLOAD" == 1 ] && __autoloadClass "$CLASS_NAME"
    
    local OBJECT_POINTER="$(_generatePointer)"
    eval "$OBJECT_POINTER"'_CLASS='"$CLASS_NAME"
    eval "$OBJECT_POINTER"_DATA=
    eval "$2"="$OBJECT_POINTER"
    if isset function CLASS_"$CLASS_NAME"___construct; then
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
# $@?   mixed  params
# $?    0:OK    1:ERROR
function extends()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'
    [ -z "$2" ] && error '2: Parameter empty or not set'
    
    eval '_BASHOR_CLASS_'"$1"'_EXTENDS'"='$2'"
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
        
    local varname="$2"
    local pointer1="$1"
    local pointer2="$(_generatePointer)"
    shift 2
        
    eval 'local CLASS_NAME="$'"$pointer1"'_CLASS"'
    eval "$pointer2"'_CLASS="$'"$pointer1"'_CLASS"'
    eval "$pointer2"'_DATA="$'"$pointer1"'_DATA"'
    eval "$varname"="$pointer2";
    
    local OBJECT_POINTER="$pointer2"
    unset -v pointer1 pointer2 varname
        
    declare -F | grep '^declare -f CLASS_'"$CLASS_NAME"'___clone$' > /dev/null
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
    local OBJECT_POINTER="$1"
    eval 'local CLASS_NAME="$'"$OBJECT_POINTER"'_CLASS"'
        
    declare -F | grep '^declare -f CLASS_'"$CLASS_NAME"'___destruct$' > /dev/null
    if [ "$?" == 0 ]; then
        object "$OBJECT_POINTER" __destruct
        res=$?
    fi
    
    unset -v "$OBJECT_POINTER"_DATA    
    unset -v "$OBJECT_POINTER"_ID
    unset -v "$OBJECT_POINTER"_CLASS
    unset -v "$OBJECT_POINTER"
    
    return "$res"
}

##
# Generate a pointer id.
#
# &1    string  pointer id
# $?    0:OK    1:ERROR
function _generatePointer()
{
    local pointer
    while true; do
        pointer="$(date +_BASHOR_POINTER_%s%N_$RANDOM)"
        isset var "$pointer" || break
    done;
    eval "$pointer"=
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
    
    case "$1" in
        call)
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            shift
            _call "$@"
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
    
    eval 'local CLASS_NAME="$_BASHOR_CLASS_'"$CLASS_NAME"'_EXTENDS"'
    case "$1" in
        call)
            [ -z "$CLASS_NAME" ] && error 'parent: Parameter empty or not set' 
            [ -z "$2" ] && error '2: Parameter empty or not set' 
            shift
			_call "$@"
			return=$?
            ;;
        exists)
            [ -n "$CLASS_NAME" ]
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
        local value=$(cat - | encodeData)
    else
        local value=$(echo "$3" | encodeData)
    fi
    local key=$(echo "$2" | encodeData)
    
    local data="${!1}"
    data=$(echo "$key $value"; echo -n "$data" | grep -v "^${key}[[:space:]]\+.*$")
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
# $?    0:OK    1:ERROR
# &0    string  Data
function _objectGet()
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
# Check if is set in object var.
#
# $1    string  var name
# $2    string  key
# $?    0:OK    1:ERROR
function _objectIsset()
{
    [ -z "$1" ] && error '1: Parameter empty or not set'   
    [ -z "$2" ] && error '2: Parameter empty or not set'  
    
    local data="${!1}"
    local key=$(echo "$2" | encodeData)
    data=$(echo "$data" | grep "^$key ")
    return $?
}

. "$BASHOR_PATH_INCLUDES/Class.sh"
