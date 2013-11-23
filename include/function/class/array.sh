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
# @version      $Id: class.sh 215 2012-06-27 19:32:32Z lars $
################################################################################

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
    
    local dataLine="$(printf '%s' "$2" | grep -n -m 1 '^DATA=' | sed 's/:.*$//')"
    local value="`printf '%s' "$2" | tail -n +$((++dataLine))`"
    eval 'declare -g -A '"$1"="$value"
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
    echo 'bashor dump 1.1.0 objectData'
    printf '%s\n' "CLASS_NAME=$CLASS_NAME"
    printf '%s\n' "DATA_TYPE=AssociativeArray"
    printf '%s\n' 'DATA='
    varExport "${1}"
    return $?
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
    [ "$BASHOR_CLASS_AUTOLOAD" = 1 ] && __autoloadClass "$CLASS_NAME"
    local OBJECT
    _bashor_generatePointer OBJECT "$BASHOR_TYPE_OBJECT"
    declare -g "$OBJECT"'_CLASS'="$CLASS_NAME"
    declare -g -A "$OBJECT"'_DATA=()'
    declare -g "$2"="$OBJECT"
    if issetFunction CLASS_"$CLASS_NAME"___construct; then
        shift 2
        object "$OBJECT" __construct "$@"
    fi

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
    local CLASS_NAME="$1"_CLASS
    CLASS_NAME="${!CLASS_NAME}"
    declare -g "${!2}"'_CLASS'="$CLASS_NAME"
    declare -g -A "${!2}"'_DATA='
    copyArray "$1"'_DATA' "${!2}"'_DATA'
    #eval 'declare -g -A "${!2}"_DATA='"`varExport "$1"_DATA`"

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
    local OBJECT="$1"
    CLASS_NAME="$OBJECT"_CLASS
    CLASS_NAME="${!CLASS_NAME}"
        
    if issetFunction CLASS_"$CLASS_NAME"___destruct; then
        object "$OBJECT" __destruct
        res=$?
    fi
    
    unset -v "$OBJECT"_DATA
    unset -v "$OBJECT"_CLASS "$OBJECT"
    
    return "$res"
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

    if [ "$#" -lt 3 -a -p /dev/stdin ]; then
        local value=$(cat -)
    else
        local value=$(printf '%s' "$3")
    fi
    
    eval "$1"'["$2"]="$value"'    
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
    
    unset "$1"[$2]
    
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

    local IFS=$'\n'    
    if _bashor_objectIsset "$1" "$2"; then
        eval 'printf '%s' "${'"$1"'["$2"]}"'
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
_bashor_objectCount()
{
    requireParams R "$@"
    
    eval 'printf '%s' "${#'"$1"'[@]}"'   
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
    eval "$1"'=()'
    return 0
}

##
# Get the keys of the object vars.
#
# $1    string  var name
# $2    integer pos in list
# $?    0       OK
# $?    1       ERROR
# &1    string  key
_bashor_objectKey()
{
    requireParams RR "$@"
    
    local IFS=$'\n'
    local -a data
    local IFS='|'
    eval 'data=(${!'"$1"'[@]})'
    [ "$2" -ge "${#data[@]}" ] && return 1;
    printf '%s' "${data[$2]}"
    return $?
}

##
# Get the values of the object vars.
#
# $1    string  var name
# $2    integer pos in list
# $?    0       OK
# $?    1       ERROR
# &1    string  key
_bashor_objectValue()
{
    requireParams RR "$@"
    
    local IFS=$'\n'
    local -a data
    local IFS='|'
    eval 'data=(${'"$1"'[@]})'
    [ "$2" -ge "${#data[@]}" ] && return 1;
    printf '%s' "${data[$2]}"
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

    eval '[ "${'"$1"'["$2"]}" = "${'"$1"'["$2"]-1}" ]'
    return $?
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
    
    [[ "$1" =~ ^[a-zA-Z_]+$ ]] || error 'No valid class name!'
    
    local namespace='_BASHOR_CLASS_'"$1"
    local namespaceExtends='_BASHOR_CLASS_'"$1"'_EXTENDS'
    local pointer
    _bashor_generatePointer pointer "$BASHOR_TYPE_OBJECT"
    [ -z "${!namespaceExtends}" ] && _bashor_addStdClass "$1"   
    declare -g "$namespace"="$1"
    declare -g "$namespace"'_POINTER'="$pointer"
    declare -g -A "$pointer"'_DATA=()'
    unset -v namespace namespaceExtends pointer
    
    issetFunction CLASS_"$1"___load
    if [ "$?" = 0 ]; then
        class "$1" __load
        return $?
    fi
    
    return 0
}
