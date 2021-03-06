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
# Load a class.
#
# $1    string  namespace
# $?    0       OK
# $?    1       ERROR
loadClass()
{
    requireParams R "$@"
    
    local _bashor_temp_path _bashor_temp_filename IFS=':'
    for _bashor_temp_path in $BASHOR_PATHS_CLASS; do
        _bashor_temp_filename="$_bashor_temp_path/${1//_//}"'.sh'
        [ -f "$_bashor_temp_filename" ] || continue
        eval _BASHOR_LOADED_CLASS_"$1"='"$_bashor_temp_filename"'
        . "$_bashor_temp_filename"
        unset -v _bashor_temp_filename _bashor_temp_path
        addClass "$1"
        return $?
    done
    
    return 1
}

##
# Load class only once internaly.
#
# $1    string  namespace
# $1    string  name of the loaded class variable
# $?    0       OK
# $?    1       ERROR
_bashor_loadClassOnce()
{
    [ -n "${!2}" ] || loadClass "$1"
    return $?
}


##
# Load class only once.
#
# $1    string  namespace
# $?    0       OK
# $?    1       ERROR
loadClassOnce()
{
    _bashor_loadClassOnce "$1" _BASHOR_LOADED_CLASS_"$1"
    return $?
}

##
# Autoloader for Classes.
#
# This function will be called if a class need to be auto loadet.
#
# $1    string  class
# $?    0       OK
# $?    1       ERROR
__autoloadClass()
{
    _bashor_loadClassOnce "$1" _BASHOR_LOADED_CLASS_"$1"
    return $?
}

##
# Add Class functions.
#
# Add all function with the class name to the class.
#
# $1    string  class
# $@    mixed  params
# $?    0       OK
# $?    1       ERROR
addClass()
{
    requireParams R "$@"
    
    [[ "$1" =~ ^[a-zA-Z_]+$ ]] || error 'No valid class name!'
    
    local namespace=_BASHOR_CLASS_"$1"
    local namespaceExtends=_BASHOR_CLASS_"$1"_EXTENDS
    local pointer
    _bashor_generatePointer pointer "$BASHOR_TYPE_OBJECT"
    [ -z "${!namespaceExtends}" ] && _bashor_addStdClass "$1"   
    eval "$namespace"='"$1"'
    eval "$namespace"_POINTER="$pointer"
    eval "$pointer"_DATA=
    eval "$pointer"'_CLASS="$1"'
    unset -v namespace namespaceExtends pointer
    
    issetFunction CLASS_"$1"___load
    if [ "$?" = 0 ]; then
        class "$1" __load
        return $?
    fi
    
    return 0
}

##
# Add standart class.
#
# Set the basic class to a class as his parent.
#
# $1    string  class name
# $?    0       OK
# $?    1       ERROR
_bashor_addStdClass()
{
    requireParams R "$@"
    [ "$1" = Class ] && return 0
    
    _bashor_createExtendedClassFunctions "$1" Class
    eval _BASHOR_CLASS_"$1"_EXTENDS=Class
    return 0
}

##
# Create class functions for extended class.
#
# Create proxy functions in the child class to have a fast redirect to
# the parent class.
#
# $1    string  child class
# $2    string  parent class
# $?    0       OK
# $?    1       ERROR
_bashor_createExtendedClassFunctions()
{
    requireParams RR "$@"
    
    local fList=$(declare -F | sed -n 's#^declare -f CLASS_'"$2"'_\(_*[^_]\+\)$#\1#p')
    local f fNameParent fNameNew IFS=$'\n\r'
    for f in $fList; do
        fNameParent=CLASS_"$2"_"$f"
        fNameNew=CLASS_"$1"_"$f"
        if ! issetFunction "$fNameNew"; then
            eval "$fNameNew"'() {
                local CLASS_NAME='\'"$2"\'';
                [ -n "$BASHOR_PROFILE" ] && _bashor_profileMethodRematch "$CLASS_NAME"
                '"$fNameParent"' "$@";
                return $?;
            }'
        fi
    done
}

##
# Call a class method
#
# Example: class My_Class doSomthing '123'
#
# $1    string  class name
# $2    string  function name
# $@    mixed   method params
# $?    *       all of class method
class()
{
    requireParams RR "$@"
    local CLASS_NAME CLASS_TOP_NAME OBJECT=
    
    CLASS_NAME="$1"
    CLASS_TOP_NAME="$CLASS_NAME"
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
    
    local dataLine="$(printf '%s' "$2" | grep '^DATA=' -n | sed 's/:.*$//')"
    local value="$(printf '%s' "$2" | tail -n +$((++dataLine)) | decodeData)"
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
    printf 'CLASS_NAME=%s\n' "$CLASS_NAME"
    printf 'DATA_FORMAT=%s\n' "$BASHOR_CODEING_METHOD"
    printf 'DATA=\n'
    printf '%s' "${!1}" | encodeData
    return $?
}

##
# Call a object method
#
# Example: object "$pointerVar" doSomthing '123'
#
# $1    string  pointer
# $2    string  function name
# $@    mixed   method params
# $?    *       all of class method
object()
{    
    requireParams RR "$@" 
    if [ "${!1}" != "$BASHOR_TYPE_OBJECT" ] || [[ ! "$1" =~ ^_BASHOR_POINTER_ ]]; then
        error 'Pointer "'"$1"'" is not a Object!'
    fi
    
    local OBJECT CLASS_TOP_NAME CLASS_NAME
    OBJECT="$1"
    CLASS_NAME="$1"_CLASS
    CLASS_NAME="${!CLASS_NAME}"
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
        issetVar "$1"_CLASS || error 'Pointer "'"$1"'" is not a Object!'
        
        local OBJECT CLASS_NAME
        clone "$1" OBJECT
        CLASS_NAME="$OBJECT"_CLASS
        CLASS_NAME="${!CLASS_NAME}"
        
        if issetFunction CLASS_"$CLASS_NAME"___sleep; then
            object "$OBJECT" __sleep
        fi
    } 1>/dev/null
    
    _bashor_objectSaveData "$OBJECT"_DATA
    local result=$?
    remove "$OBJECT"
    return $result
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
    
    if [ "$#" -lt 2 -a -p /dev/stdin ]; then
        local _bashor_temp_data="$(cat -)"
    else
        local _bashor_temp_data="$2"
    fi

    _bashor_temp_dataLine=$(
        printf '%s' "$_bashor_temp_data" | grep -n -m 1 '^DATA=' | sed 's/:.*$//'
    )
    ((_bashor_temp_dataLine--))
    _bashor_temp_header="$(printf '%s' "$_bashor_temp_data" | head -n $_bashor_temp_dataLine)"
    
    CLASS_NAME=$(printf '%s' "$_bashor_temp_header" | sed -n 's/^CLASS_NAME=//1p')
    _bashor_generatePointer "${1}" "$BASHOR_TYPE_OBJECT"
    eval "${!1}"'_CLASS="$CLASS_NAME"'
    eval "${!1}"_DATA=

    _bashor_objectLoadData "${!1}"_DATA "$_bashor_temp_data";
    local _bashor_temp_res="$?"
    
    if issetFunction CLASS_"$CLASS_NAME"___wakeup; then
        object "${!1}" __wakeup 1>/dev/null
    fi
    
    return $_bashor_temp_res
}

##
# Call a object / static method.
#
# Internal function to call methods.
#
# $1    string  function name
# $@    mixed   method params
# $?    0       OK
# $?    1       ERROR
_bashor_call()
{
    requireParams R "$@"
    [ "$BASHOR_CLASS_AUTOLOAD" = 1 ] && __autoloadClass "$CLASS_NAME"
    
    local FUNCTION_NAME="$1"
    if issetFunction CLASS_"$CLASS_NAME"_"$FUNCTION_NAME"; then
        shift
        _bashor_profileMethodHelper "$CLASS_NAME" "$FUNCTION_NAME" 2 CLASS_"$CLASS_NAME"_"$FUNCTION_NAME" "$@"
        return $?
    fi

    if issetFunction CLASS_"$CLASS_NAME"___call; then
        _bashor_profileMethodHelper "$CLASS_NAME" __call 2 CLASS_"$CLASS_NAME"___call "$@"
        return $?
    fi
    
    local className=_BASHOR_CLASS_"$CLASS_NAME"
    [ -z "${!className}" ] \
         && error "No class $CLASS_NAME found!"
    
    error "No method \"${FUNCTION_NAME}\" in \"${CLASS_NAME}\"!"
    return 1
}

##
# Create a new object from class.
#
# Example: new My_Class myPointer '123'
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
    [ "$BASHOR_CLASS_AUTOLOAD" = 1 ] && __autoloadClass "$CLASS_NAME"
    local OBJECT
    _bashor_generatePointer OBJECT "$BASHOR_TYPE_OBJECT"
    eval "$OBJECT"'_CLASS="$CLASS_NAME"'
    eval "$OBJECT"_DATA=
    eval "$2"'="$OBJECT"'
    if issetFunction CLASS_"$CLASS_NAME"___construct; then
        shift 2
        object "$OBJECT" __construct "$@"
    fi

    return 0
}

##
# Extends a class.
#
# Write extends in the top, before the first method of the class will be
# defined.
#
# $1    string  class name
# $2    string  parent class name
# $?    0       OK
# $?    1       ERROR
extends()
{
    requireParams RR "$@"
    
    [ "$BASHOR_CLASS_AUTOLOAD" = 1 ] && __autoloadClass "$2"
    eval _BASHOR_CLASS_"$1"'_EXTENDS="$2"'
    _bashor_createExtendedClassFunctions "$1" "$2"    
    return 0
}

##
# Clone a object.
#
# $1    string  object pointer
# $2    string  object variable name
# $?    *       all of class method __clone
clone()
{    
    requireParams RR "$@"
    isObject "$1" || error 'Pointer "'"$1"'" is not a Object!'
    
    _bashor_generatePointer "$2" "$BASHOR_TYPE_OBJECT"        
    local CLASS_NAME="$1"_CLASS
    CLASS_NAME="${!CLASS_NAME}"
    eval "${!2}"'_CLASS="$CLASS_NAME"'
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
# $1    string  pointer
# $?    0       OK
# $?    1       ERROR
remove()
{
    requireParams R "$@"
    [ -z "$1"_CLASS ] && error 'Pointer "'"$1"'" is not a Object!'

    local CLASS_NAME
    local -i res=0
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
# Generate a pointer id.
#
# Internal function to generate a pointer.
#
# $1    string  output var name
# $2    string  pointer type
# &1    pointer pointer id
# $?    0       OK
# $?    1       ERROR
_bashor_generatePointer()
{
    requireParams RR "$@"
    
    local _bashor_temp_pointer
    while true; do
        _bashor_temp_pointer=_BASHOR_POINTER_"$(date +%s%N)"
        issetVar "$_bashor_temp_pointer" || break
    done;
    eval "$_bashor_temp_pointer"='"$2"'
    eval "$1"='"$_bashor_temp_pointer"'
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
    if [ -n "$BASHOR_COMPATIBILITY_THIS" -a -z "$OBJECT" ]; then
        static "$@"
        return $?
    fi
    requireObject
    requireParams R "$@"
    
    case "$1" in
        call)
            [ -z "$CLASS_TOP_NAME" ] && error 'CLASS_TOP_NAME: Parameter empty or not set' 
            local CLASS_NAME="$CLASS_TOP_NAME";
            shift
            _bashor_call "$@"
            return $?
            ;;
        pointer)
            printf '%s' "$OBJECT"
            return 0
            ;;
        get)
            shift
            _bashor_objectGet "$OBJECT"_DATA "$@"
            return $?
            ;;
        set)
            shift
            _bashor_objectSet "$OBJECT"_DATA "$@"
            return $?
            ;;
        unset)
            shift
            _bashor_objectUnset "$OBJECT"_DATA "$@"
            return $?
            ;;
        isset)
            shift
            _bashor_objectIsset "$OBJECT"_DATA "$@"
            return $?
            ;;
        count)
            _bashor_objectCount "$OBJECT"_DATA
            return $?
            ;;
        key)
            shift
            _bashor_objectKey "$OBJECT"_DATA "$@"
            return $?
            ;;
        value)
            shift
            _bashor_objectValue "$OBJECT"_DATA "$@"
            return $?
            ;;
        size)
            printf '%s' "$OBJECT"_DATA | wc -c
            return $?
            ;;
        clear)
             _bashor_objectClear "$OBJECT"_DATA
            return $?
            ;;
        *)
            error "\"$1\" is not a option of this!"
            ;;
    esac
    
    return 1
}

##
# Access to the class.
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
static()
{
    [ -z "$CLASS_TOP_NAME" ] && error 'CLASS_TOP_NAME: Parameter empty or not set' 
    local CLASS_NAME="$CLASS_TOP_NAME";
    
    case "$1" in
        call)
            local OBJECT=
            shift
            _bashor_call "$@"            
            return $?
            ;;
    esac
    
    eval 'local OBJECT=$_BASHOR_CLASS_'"$CLASS_NAME"_POINTER
    case "$1" in
        get)
            shift
            _bashor_objectGet "$OBJECT"_DATA "$@"
            return $?
            ;;
        set)
            shift
            _bashor_objectSet "$OBJECT"_DATA "$@"
            return $?
            ;;
        unset)
            shift
            _bashor_objectUnset "$OBJECT"_DATA "$@"
            return $?
            ;;
        isset)
            shift
            _bashor_objectIsset "$OBJECT"_DATA "$@"
            return $?
            ;;
        count)
            _bashor_objectCount "$OBJECT"_DATA
            return $?
            ;;
        key)
            shift
            _bashor_objectKey "$OBJECT"_DATA "$@"
            return $?
            ;;
        value)
            shift
            _bashor_objectValue "$OBJECT"_DATA "$@"
            return $?
            ;;
        size)
            printf '%s' "$OBJECT"_DATA | wc -c
            return $?
            ;;
        clear)
             _bashor_objectClear "$OBJECT"_DATA
            return $?
            ;;
        *)
            requireParams R "$@"
            error "\"$1\" is not a option of static!"
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
    
    local CLASS_NAME=_BASHOR_CLASS_"$CLASS_NAME"_EXTENDS
    CLASS_NAME="${!CLASS_NAME}"
    case "$1" in
        call)
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

    if [ "$#" -lt 3 -a -p /dev/stdin ]; then
        local value=$(cat - | encodeData)
    else
        local value=$(printf '%s' "$3" | encodeData)
    fi
    
    local key=$(printf '%s' "$2" | encodeData)
    value=$(printf '%s' "${!1}" \
        | grep -v "^${key}[[:space:]]\+.*$"; printf '%s\n' "$key $value";)
    eval "$1"'="$value"'
    
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
    
    local key=$(printf '%s' "$2" | encodeData)
    local data=$(printf '%s' "${!1}" | grep -v "^${key}[[:space:]]\+.*$")
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
    
    local data
    data=$(printf '%s' "${!1}" | grep "^$(printf '%s' "$2" | encodeData)[[:space:]]\+.*$")    
    [ $? = 0 ] || return 1
    
    printf '%s' "${data#* }" | decodeData
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
    
    printf '%s\n' "${!1}" | wc -l    
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
    eval "$1"=  
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
    local -a data=(`printf '%s' "${!1}"`);
    [ "$2" -ge "${#data[@]}" ] && return 1;
    printf '%s' "${data[$2]% *}" | decodeData
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
    local -a data=(`printf '%s' "${!1}"`);
    [ "$2" -ge "${#data[@]}" ] && return 1;
    printf '%s' "${data[$2]#* }" | decodeData
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
    
    local key=$(printf '%s' "$2" | encodeData)
    printf '%s' "${!1}" | grep "^$key[[:space:]]\+.*$" >/dev/null
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
    
    [[ "$1" =~ ^_BASHOR_POINTER_ ]] && [ "${!1}" = "$BASHOR_TYPE_OBJECT" ]
    return $?
}

##
# Check if you are in a object call otherwise it will trow a error.
#
# $?    0       OK
# $?    1       ERROR
requireObject()
{
    [ -n "$OBJECT" ] || error 'Not a object call!'
}

##
# Check if you are in a object call.
#
# $?    0       OK
# $?    1       ERROR
inObject()
{
    [ -n "$OBJECT" ]
    return $?
}

##
# Check if you are in a static call otherwise it will trow a error.
#
# $?    0       OK
# $?    1       ERROR
requireStatic()
{
    [ -z "$OBJECT" -a -n "$CLASS_NAME" ] || error 'Not a static call!'
}

##
# Check if you are in a static call.
#
# $?    0       OK
# $?    1       ERROR
inStatic()
{
    [ -z "$OBJECT" -a -n "$CLASS_NAME" ]
    return $?
}
