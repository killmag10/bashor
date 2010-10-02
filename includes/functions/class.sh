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
    
    eval '[ -z "$_OBJECT_CLASS_'"$ns"'_EXTENDS" ] && _addStdClass '"$ns"';';
    declare -F | grep '^declare -f CLASS_'"$ns"'___load$' > /dev/null;
    if [ "$?" == 0 ]; then
        _staticCall "$ns" '__load';
        return "$?";
    fi
    
    return 0;
}

##
# Add standart class.
#
# $1    string  namespace
# $?    0:OK    1:ERROR
function _addStdClass()
{
    : ${1:?};
    
    _createExtendedClassFunctions "$1" 'Class' '1';
    eval 'export _OBJECT_CLASS_'"$1"'_EXTENDS=Class;';
    return 0;
}

##
# Create class functions for extended class.
#
# $1    string  new class
# $2    string  parent class
# $?    0:OK    1:ERROR
function _createExtendedClassFunctions()
{
    : ${1:?};
    : ${2:?};
    
    local nsParent="$2";
    local nsNew="$1";
    local noOverwrite="$3";
    
    local fList=`declare -F \
        | sed -n 's#^declare -f CLASS_'"$nsParent"'_\(.*\)$#\1#p'`;
    local IFS=`echo -e "\n\r"`;
    for f in $fList; do
        local fNameParent='CLASS_'"$nsParent"'_'"$f";
        local fNameNew='CLASS_'"$nsNew"'_'"$f";
        if [ -z "$noOverwrite" ] || ! functionExists "$fNameNew"; then
            eval 'function '"$fNameNew"'() { '"$fNameParent"' "$@"; return "$?"; }';
        fi
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
    local OLD_CLASS_PARENT="$CLASS_PARENT";
    export CLASS_PARENT='';
    _staticCall "$@";
    local res="$?";
    export CLASS_PARENT="$OLD_CLASS_PARENT";
    return "$res";
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
    local _OLD_OBJECT_PATH="$_OBJECT_PATH"; 
    local _OLD_OBJECT_PATH_OLD="$_OBJECT_PATH_OLD"; 
    export CLASS_NAME="$1";
    [ -n "$CLASS_PARENT" ] && export CLASS_NAME="$CLASS_PARENT";
    export CLASS_PARENT="";
    export OBJECT_NAME="";
    export FUNCTION_NAME="$2";
    export STATIC='1';
    export OBJECT='';
    export _OBJECT_PATH_OLD='';
    export _OBJECT_PATH='___'"$CLASS_NAME";
    local fName='CLASS_'"$CLASS_NAME"'_'"$FUNCTION_NAME";
    shift 2;
    if declare -f "$fName" > /dev/null; then
        "$fName" "$@";
        local res="$?"
    else
        error "No method \"$FUNCTION_NAME\" in \"$CLASS_NAME\"!";
        local res="1"
    fi
    export CLASS_NAME="$OLD_CLASS_NAME";
    export OBJECT_NAME="$OLD_OBJECT_NAME";
    export FUNCTION_NAME="$OLD_FUNCTION_NAME"
    export STATIC="$OLD_STATIC";
    export OBJECT="$OLD_OBJECT";
    export _OBJECT_PATH="$_OLD_OBJECT_PATH";
    export _OBJECT_PATH_OLD="$_OLD_OBJECT_PATH_OLD";
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
    : ${1:?};
    : ${2:?};
    
    local OLD_OBJECT_VISIBILITY="$OBJECT_VISIBILITY";
    if [ "$1" == 'local' ]; then
        : ${3:?};
        export OBJECT_VISIBILITY='local';
        shift 1;
    else
        export OBJECT_VISIBILITY='global';
    fi
 
    local OLD_CLASS_PARENT="$CLASS_PARENT";
    export CLASS_PARENT='';
    _objectCall '' "$@";
    local res="$?";
    export CLASS_PARENT="$OLD_CLASS_PARENT";
    export OBJECT_VISIBILITY="$OLD_OBJECT_VISIBILITY";
    return "$res";
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
# $1    boolean internal call '':FALSE '1':TRUE
# $2    string  object name
# $3    string  function name
# $PARENT?   string  child class name
# $@    params
# $?    0:OK    1:ERROR
function _objectCall()
{    
    : ${1?};
    : ${2:?};
    : ${3:?};
        
    local OLD_CLASS_NAME="$CLASS_NAME";
    local OLD_OBJECT_NAME="$OBJECT_NAME";
    local OLD_FUNCTION_NAME="$FUNCTION_NAME";
    local OLD_STATIC="$STATIC";
    local OLD_OBJECT="$OBJECT";
    local _OLD_OBJECT_PATH_OLD="$_OBJECT_PATH_OLD";
    local _OLD_OBJECT_PATH="$_OBJECT_PATH";
    export OBJECT_NAME="$2";
    export FUNCTION_NAME="$3";
    export STATIC='';
    export OBJECT='1';
    
    local namespace=`_objectNamespace "" "$2" "$1"`;
    eval 'export CLASS_NAME="$'"$namespace"'_CLASS";';
    eval 'export OBJECT_ID="$'"$namespace"'_ID";';   
    if [ -z "$1" ]; then
        if [ "$OBJECT_VISIBILITY" == 'global' ]; then
            export _OBJECT_PATH_OLD=''; 
            export _OBJECT_PATH='__'"$OBJECT_ID";        
        else    
            export _OBJECT_PATH_OLD="$_OBJECT_PATH";
            export _OBJECT_PATH="$_OBJECT_PATH"'__'"$OBJECT_ID";
        fi
    fi
    [ -n "$CLASS_PARENT" ] && export CLASS_NAME="$CLASS_PARENT";
    export CLASS_PARENT="";
    local fName='CLASS_'"$CLASS_NAME"'_'"$FUNCTION_NAME";
    shift 3;
    if declare -f "$fName" > /dev/null; then
        "$fName" "$@";
        local res="$?"
    else
        error "No method \"$FUNCTION_NAME\" in \"$CLASS_NAME\"!";
        local res="1"
    fi
    export CLASS_NAME="$OLD_CLASS_NAME";
    export OBJECT_NAME="$OLD_OBJECT_NAME";
    export FUNCTION_NAME="$OLD_FUNCTION_NAME";
    export STATIC="$OLD_STATIC";
    export OBJECT="$OLD_OBJECT";
    export _OBJECT_PATH_OLD="$_OLD_OBJECT_PATH_OLD";
    export _OBJECT_PATH="$_OLD_OBJECT_PATH";
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
    : ${1:?No class name set};
    : ${2:?No object name set};
    
    local OLD_OBJECT_VISIBILITY="$OBJECT_VISIBILITY";
    if [ "$1" == 'local' ]; then
        : ${3:?};
        export OBJECT_VISIBILITY='local';
        shift 1;
    else
        export OBJECT_VISIBILITY='global';
    fi
    
    local ns="$1";
    local nsObj="$2";    
    local res="0";
    shift 2;
    
    local namespace=`_objectNamespace "$ns" "$nsObj" ''`; 
    local dataVarName=`_objectVarNameData "$ns" "$nsObj" ''`;    
    
    local callLine="`caller | sed -n 's#^\([0-9]\+\).*$#\1#p';`";
    eval 'export '"$namespace"'_CLASS='"$ns"';';
    eval 'export '"$namespace"'_ID='"${ns}${callLine}"';';
    eval 'export '"$dataVarName"'="";';
    declare -F | grep '^declare -f CLASS_'"$ns"'___construct$' > /dev/null;
    if [ "$?" == 0 ]; then
        _objectCall '' "$nsObj" '__construct' "$@";
        local res="$?";
    fi
        
    export OBJECT_VISIBILITY="$OLD_OBJECT_VISIBILITY";    
    return "$res";
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
    : ${1:?};
    : ${2:?};
    
    local namespace=`_objectNamespace "$1" "" ''`;     
    eval 'export '"$namespace"'_EXTENDS'"='$2';";
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
    
    local OLD_OBJECT_VISIBILITY="$OBJECT_VISIBILITY";
    if [ "$1" == 'local' ]; then
        : ${2:?};
        export OBJECT_VISIBILITY="$1";
        shift 1;
    else
        export OBJECT_VISIBILITY='global';
    fi
    local name1="$1";
    local namespace1=`_objectNamespace "" "$name1" ''`;
    export OBJECT_VISIBILITY="$OLD_OBJECT_VISIBILITY";
    shift 1;
    
    local OLD_OBJECT_VISIBILITY="$OBJECT_VISIBILITY";
    if [ "$1" == 'local' ]; then
        : ${2:?};
        export OBJECT_VISIBILITY="$1";
        shift 1;
    else
        export OBJECT_VISIBILITY='global';
    fi
    local name2="$1";
    local namespace2=`_objectNamespace "" "$name2" ''`;
    export OBJECT_VISIBILITY="$OLD_OBJECT_VISIBILITY";
    shift 1;
    
    eval 'local class1="$'"$namespace1"'_CLASS";';
    eval 'export '"$namespace2"'_CLASS="$'"$namespace1"'_CLASS";';
    eval 'export '"$namespace2"'_DATA="$'"$namespace1"'_DATA";';
        
    declare -F | grep '^declare -f CLASS_'"$class1"'___clone$' > /dev/null;
    if [ "$?" == 0 ]; then
        _objectCall '' "$name2" '__clone';
        return "$?";
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
    
    local OLD_OBJECT_VISIBILITY="$OBJECT_VISIBILITY";
    if [ "$1" == 'local' ]; then
        : ${2:?};
        export OBJECT_VISIBILITY="$1";
        shift 1;
    else
        export OBJECT_VISIBILITY='global';
    fi

    _objectRemove "$1" "1";
    local res="$?";
    export OBJECT_VISIBILITY="$OLD_OBJECT_VISIBILITY";   
    return "$res";
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
    local nsObjVarOld=`_objectVarNameData '' "$1" ''`;
    local namespace=`_objectNamespace "$ns" "$nsObj" ''`;
    eval 'local ns="$'"$nsObjClassOld"'";';
        
    if [ "$2" == 1 ]; then
        declare -F | grep '^declare -f CLASS_'"$ns"'___destruct$' > /dev/null;
        if [ "$?" == 0 ]; then
            _objectCall '' "$ns" "$nsObj" '__destruct';
            local res="$?";
        fi
    fi
    
    eval 'unset -v '"$namespace"'_CLASS';
    eval 'unset -v '"$nsObjVarOld";
    
    return "$res";
}

##
# Get object var name.
#
# $1   string  class name
# $2   string  class name
# $3    boolean internal call '':FALSE '1':TRUE
# &1    string var name
# $?    0:OK    1:ERROR
function _objectVarNameData()
{
    : ${1?};
    : ${2?};
    
    local namespace=`_objectNamespace "$1" "$2" "$3"`;
    echo "$namespace"'_DATA';
    return 0;
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
    : ${1?};
    : ${2?};
    : ${3?};
       
    if [ -n "$2" ]; then
        if [ "$OBJECT_VISIBILITY" == 'global' ]; then
            local namespace='OBJECT_GLOBAL_'"$2";
        else
            [ -n "$3" ] && local _OBJECT_PATH="$_OBJECT_PATH_OLD";
            local namespace='OBJECT_LOCAL'"$_OBJECT_PATH"'_'"$2";
        fi
    else
        local namespace='CLASS_'"$1"; 
    fi
    echo '_'"$namespace";
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
    
    local dataVarName=`_objectVarNameData "$CLASS_NAME" "$OBJECT_NAME" '1'`;
    
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
                _objectCall '1' "$OBJECT_NAME" "$fName" "$@";
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
        *)
            error "\"$1\" is not a option of this!";
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
        local namespace=`_objectNamespace "$CLASS_PARENT" "" '1'`;
    else
        local namespace=`_objectNamespace "$CLASS_NAME" "" '1'`;
    fi    
    eval 'local CLASS_PARENT="$'"$namespace"'_EXTENDS";';
        
    local return=1;
    case "$1" in
        call)
            : ${CLASS_PARENT:?};
            export CLASS_PARENT;
            : ${2:?};
            local fName="$2"
            shift 2;
            if [ -z "$OBJECT_NAME" ]; then
                _staticCall "$CLASS_NAME" "$fName" "$@";
                local return="$?";
            fi
            if [ -n "$OBJECT_NAME" ]; then
                _objectCall '1' "$OBJECT_NAME" "$fName" "$@";
                local return="$?";
            fi
            ;;
        exists)
            [ -n "$CLASS_PARENT" ];
            local return="$?"
            ;;
        *)
            error "\"$1\" is not a option of parent!";
            ;;
    esac
    
    export CLASS_PARENT="$OLD_CLASS_PARENT";
    return "$return";
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

    if [ -p /dev/stdin ] && [ -z "$3" ] && [ "$3" !=  "${3-null}"]; then
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

_OBJECT_PATH="";

. "$BASHOR_PATH_INCLUDES/Class.sh";
