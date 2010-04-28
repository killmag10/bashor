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
    : ${1:?};
    
    if [ -n "$1" ]; then
        local ns="$1";
        local nsFile=`echo "$ns" | tr '_' '/'`;
        
        local IFS=`echo -e "\n\r"`;
        for dn in $BASHOR_PATHS_CLASS; do
            local filename="$dn/""$nsFile"'.sh';
            if [ -f "$filename" ]; then
                . "$filename";
                addClass "$@";
                return "$?";
            fi
        done;
    fi
    
    return 1;
}

##
# Load class once.
#
# $1    string  namespace
# $@?   mixed  params
# $?    0:OK    1:ERROR
function loadClassOnce()
{
    : ${1:?};
    
    eval '[ -n "$_CLASS_'"$1"'_LOADED" ] && return 0';
    loadClass "$@";
    local res="$?";
    [ "$res" = 0 ] && eval '_CLASS_'"$1"'_LOADED=1';
    return "$res";
}

##
# Add Class functions.
#
# $1    string  namespace
# $@?   mixed  params
# $?    0:OK    1:ERROR
function addClass()
{
    : ${1:?};
    
    local ns="$1";
    shift;
    
    eval '[ -z "_OBJECT_CLASS_'"$ns"'_EXTENDS" ] && export _OBJECT_CLASS_'"$ns"'_EXTENDS'"='';";
    declare -F | grep '^declare -f CLASS_'"$ns"'___load$' > /dev/null;
    if [ "$?" == 0 ]; then
        _staticCall "$ns" '__load';
        return "$?";
    fi
    
    return 0;
}

##
# Create class functions for extended class.
#
# $1    string  new class
# $1    string  parent class
# $?    0:OK    1:ERROR
function _createExtendedClassFunctions()
{
    : ${1:?};
    : ${2:?};
    
    local nsParent="$2";
    local nsNew="$1";
    
    local fList=`declare -F \
        | sed -n 's#^declare -f CLASS_'"$nsParent"'_\(.*\)$#\1#p'`;
    local IFS=`echo -e "\n\r"`;
    for f in $fList; do
        local fNameParent='CLASS_'"$nsParent"'_'"$f";
        local fNameNew='CLASS_'"$nsNew"'_'"$f";
        eval 'function '"$fNameNew"'() { '"$fNameParent"' "$@"; return "$?"; }';
    done;
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
    _staticCall "$@";
    return "$?";
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
    : ${1:?};
    : ${2:?};
        
    local OLD_CLASS_NAME="$CLASS_NAME";
    local OLD_OBJECT_NAME="$OBJECT_NAME";
    local OLD_FUNCTION_NAME="$FUNCTION_NAME";
    local OLD_STATIC="$STATIC";
    local OLD_OBJECT="$OBJECT";
    export CLASS_NAME="$1";
    [ -n "$CLASS_PARENT" ] && export CLASS_NAME="$CLASS_PARENT";
    export CLASS_PARENT="";
    export OBJECT_NAME="";
    export FUNCTION_NAME="$2";
    export STATIC='1';
    export OBJECT='';
    local fName='CLASS_'"$CLASS_NAME"'_'"$FUNCTION_NAME";
    shift 2;
    "$fName" "$@";    
    local res="$?";
    export CLASS_NAME="$OLD_CLASS_NAME";
    export OBJECT_NAME="$OLD_OBJECT_NAME";
    export FUNCTION_NAME="$OLD_FUNCTION_NAME"
    export STATIC="$OLD_STATIC";
    export OBJECT="$OLD_OBJECT";
    return "$res";
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
    _objectCall "$@";
    return "$?";
}

##
# Save object data
#
# $1    string  object name
# $2    mixed   data
# $?    0:OK    1:ERROR
function _objectLoadData()
{
    : ${1:?};
    : ${2?};
    
    if [ -p /dev/stdin ]; then
        local value=`cat -`;
    else
        local value="$2";
    fi
    
    local value=`echo "$value" | tail -n +2 | base64 -d`;
    
    eval 'export '"$1"'="$value";';
    return "$?";
}

##
# load object data
#
# $1    string  object name
# $?    0:OK    1:ERROR
function _objectSaveData()
{
    : ${1:?};
    echo "bashor dump 0.0.0 objectData";    
    eval 'echo "$'"$1"'"' | base64;
    return "$?";
}

##
# Call a object method
#
# $1    string  object name
# $2    string  function name
# $PARENT?   string  child class name
# $@    params
# $?    0:OK    1:ERROR
function _objectCall()
{
    : ${1:?};
    : ${2:?};
        
    local OLD_CLASS_NAME="$CLASS_NAME";
    local OLD_OBJECT_NAME="$OBJECT_NAME";
    local OLD_FUNCTION_NAME="$FUNCTION_NAME";
    local OLD_STATIC="$STATIC";
    local OLD_OBJECT="$OBJECT";
    eval 'export CLASS_NAME="$_OBJECT_CLASS_'"$1"'";';
    [ -n "$CLASS_PARENT" ] && export CLASS_NAME="$CLASS_PARENT";
    export CLASS_PARENT="";
    export OBJECT_NAME="$1";
    export FUNCTION_NAME="$2";
    export STATIC='';
    export OBJECT='1';
    local fName='CLASS_'"$CLASS_NAME"'_'"$FUNCTION_NAME";
    shift 2;
    "$fName" "$@";
    local res="$?"
    export CLASS_NAME="$OLD_CLASS_NAME";
    export OBJECT_NAME="$OLD_OBJECT_NAME";
    export FUNCTION_NAME="$OLD_FUNCTION_NAME";
    export STATIC="$OLD_STATIC";
    export OBJECT="$OLD_OBJECT";
    return "$res";
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
    : ${1:?};
    : ${2:?};
    
    local ns="$1";
    local nsObj="$2";    
    shift 2;
    
    eval 'export _OBJECT_CLASS_'"$nsObj""='$ns';";
    eval 'export _OBJECT_DATA_'"$nsObj"'="";';
    declare -F | grep '^declare -f CLASS_'"$ns"'___construct$' > /dev/null;
    if [ "$?" == 0 ]; then
        _objectCall "$nsObj" '__construct' "$@";
        local res="$?";
        [ "$res" != 0 ] && 
        return "$res";
    fi
    
    return 0;
}

##
# Create a new object from class.
#
# $1    string  class name
# $2    string  object name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function extends()
{
    : ${1:?};
    : ${2:?};
    
    eval 'export _OBJECT_CLASS_'"$1"_EXTENDS"='$2';";
    _createExtendedClassFunctions "$1" "$2";
    
    return 0;
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
    : ${1:?};
    : ${2:?};
    
    local nsObjOld="$1";
    local nsObjNew="$2";
    local nsObjVarOld='_OBJECT_DATA_'"$1";
    local nsObjVarNew='_OBJECT_DATA_'"$2";

    eval 'local ns="$_OBJECT_CLASS_'"$1"'";';
    shift 2;
    
    new "$ns" "$nsObjNew" "$@";
    eval 'export '"$nsObjVarNew"'="$'"$nsObjVarOld"'";';
    
    declare -F | grep '^declare -f CLASS_'"$ns"'___clone$' > /dev/null;
    if [ "$?" == 0 ]; then
        _objectCall "$nsObj" '__clone';
        local res="$?";
        [ "$res" != 0 ] && 
        return "$res";
    fi
    
    return 0;    
}

##
# Remove a object.
#
# $1    string  object name
# $@?   mixed  params
# $?    0:OK    1:ERROR
function remove()
{
    : ${1:?};

    _objectRemove "$1" "1";    
    return "$?";
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
    : ${1:?};
    : ${2:?};

    local res="0";
    local nsObj="$1";
    local doCall="$2";
    local nsObjVarOld='_OBJECT_DATA_'"$1";
    local nsObjClassOld='_OBJECT_CLASS_'"$1";
    eval 'local ns="$'"$nsObjClassOld"'";';
        
    if [ "$2" == 1 ]; then
        declare -F | grep '^declare -f CLASS_'"$ns"'___destruct$' > /dev/null;
        [ "$?" == 0 ] && _objectCall "$ns" "$nsObj" '__destruct';
        local res="$?";
    fi
        
    #_removeObjectAliases "$ns" "$nsObj";
    eval 'unset -v '"$nsObjVarOld";
    eval 'unset -v '"$nsObjClassOld";
    return "$res";
}

##
# Get object var name.
#
# $1   string  class name
# $2   string  class name
# &1    string var name
# $?    0:OK    1:ERROR
function _objectVarName()
{
    : ${1?};
    : ${2?};
    
    local dataVarName='_CLASS_DATA_'"$1";    
    [ -n "$2" ] && local dataVarName='_OBJECT_DATA_'"$2";
    echo "$dataVarName";
    return 0;
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
    : ${1:?};
    : ${CLASS_NAME:?};
    
    local dataVarName=`_objectVarName "$CLASS_NAME" "$OBJECT_NAME"`;
    
    case "$1" in
        set)
            : ${2:?};
            : ${3?};
            _objectSet "$dataVarName" "$2" "$3";
            return "$?";
            ;;
        get)
            : ${2:?};
            _objectGet "$dataVarName" "$2";
            return "$?";
            ;;
        unset)
            : ${2:?};
            _objectUnset "$dataVarName" "$2";
            return "$?";
            ;;
        isset)
            : ${2:?};
            _objectIsset "$dataVarName" "$2";
            return "$?";
            ;;
        call)
            : ${2:?};
            local fName="$2"
            shift 2;
            if [ -z "$OBJECT_NAME" ]; then
                _staticCall "$CLASS_NAME" "$fName" "$@";
                return "$?";
            fi
            if [ -n "$OBJECT_NAME" ]; then
                _objectCall "$OBJECT_NAME" "$fName" "$@";
                return "$?";
            fi
            ;;
        save)
            _objectSaveData "$dataVarName";
            return "$?";
            ;;
        load)
            _objectLoadData "$dataVarName" "$2";
            return "$?";
            ;;
    esac
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
    : ${1:?};
    : ${CLASS_NAME:?};
    
    local OLD_CLASS_PARENT="$CLASS_PARENT";
    if [ -n "$CLASS_PARENT" ]; then
        eval 'export CLASS_PARENT="$_OBJECT_CLASS_'"$CLASS_PARENT"'_EXTENDS";';
    else
        eval 'export CLASS_PARENT="$_OBJECT_CLASS_'"$CLASS_NAME"'_EXTENDS";';
    fi
    
    case "$1" in
        call)
            : ${2:?};
            local fName="$2"
            shift 2;
            if [ -z "$OBJECT_NAME" ]; then
                _staticCall "$CLASS_NAME" "$fName" "$@";
                return "$?";
            fi
            if [ -n "$OBJECT_NAME" ]; then
                _objectCall "$OBJECT_NAME" "$fName" "$@";
                return "$?";
            fi
            ;;
        *)
            this "$@";
            ;;
    esac
    
    export CLASS_PARENT="$OLD_CLASS_PARENT";
}

##
# Access to the object.
#
# $CLASS_NAME   string  class name
# $OBJECT_NAME  string  object name
# $?    0:OK    1:ERROR
function isStatic()
{
    : ${CLASS_NAME:?};   
    : ${OBJECT_NAME?};
    [ -z "$OBJECT_NAME" ];
    return "$?";
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
    : ${1:?};
    : ${2:?};
    : ${3?};

    if [ -p /dev/stdin ]; then
        local value=`cat -`;
    else
        local value="$3";
    fi
                
    local key=`echo "$2" | base64 -w 0`;
    local value=`echo "$value" | base64 -w 0`;
    
    eval 'local data="$'"$1"'";'
    local data=`echo "$data" | sed "s#^${key}\s\+.*##"`;
    local data=`echo "$key $value"; echo -n "$data";`;
    local data=`echo "$data" | sort -u;`;
    eval 'export '"$1"'="$data";';

    return "$?"
}

##
# Remove object var.
#
# $1    string  var name
# $2    string  key
# $?    0:OK    1:ERROR
function _objectUnset()
{
    : ${1:?};
    : ${2:?};
    
    eval 'local data="$'"$1"'";' 
    local key=`echo "$2" | base64 -w 0`;
    local data=`echo "$data" \
        | sed "s#^${key}\s\+.*##" \
        | sort -u`;
    eval 'export '"$1"'="$data";';
    
    return "$?"
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
    : ${1:?};
    : ${2:?};
    
    eval 'local data="$'"$1"'";' 
    local key=`echo "$2" | base64`;
    local res=`echo "$data" | grep "^$key "`;
    if [ -n "$res" ]; then
        echo "$res" | sed 's#\S\+\s\+##' | base64 -d;
        return 0;
    fi
    
    return 1;
}

##
# Check if is set in object var.
#
# $1    string  var name
# $2    string  key
# $?    0:OK    1:ERROR
function _objectIsset()
{
    : ${1:?};
    : ${2:?};
    
    eval 'local data="$'"$1"'";'
    local key=`echo "$2" | base64`;
    local res=`echo "$data" | grep "^$key "`
    if [ -n "$res" ]; then
        return 0;
    fi
    
    return 1;
}
