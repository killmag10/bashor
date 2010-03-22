#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Includes
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Load function files.
#
# $1    string  namespace
# $@?   mixed  params
# $?    0:OK    1:ERROR
function loadClass()
{
    : ${1:?};
    
    if [ -n "$1" ]; then
        local filename="$BASHOR_DIR_CLASS/""$1"'.sh';
        local ns="$1";
        if [ -f "$filename" ]; then
            . "$filename";
            addClass "$@";
            return "$?";
        fi
    fi
    
    return 1;
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
    #_createClassAliases "$ns";
    
    declare -F | grep '^declare -f CLASS_'"$ns"'___load$' > /dev/null;
    if [ "$?" == 0 ]; then
        _staticCall "$ns" '__load' "$@";
        return "$?";
    fi
    
    return 0;
}

##
# Create aliases for class functions.
#
# $1    string  namespace
# $?    0:OK    1:ERROR
function _createClassAliases()
{
    : ${1:?};
    
    local ns="$1";
    
    local fList=`declare -F \
        | sed -n 's#^declare -f CLASS_'"$ns"'_\(.*\)$#\1#p'`;
    local IFS=`echo -e "\n\r"`;
    for f in $fList; do
        local fName='CLASS_'"$ns"'_'"$f";
        eval 'alias '"$fName"'='"'_staticCall \"$ns\" \"$f\"'";
        [ 0 == "$BASHOR_MODE_COMPATIBLE" ] \
            && eval "alias $ns"'::'"$f"'='"'_staticCall \"$ns\" \"$f\"'";
    done;
}

##
# Create class functions for extended class.
#
# $1    string  parent class
# $1    string  new class
# $?    0:OK    1:ERROR
function _createExtendedClassFunctions()
{
    : ${1:?};
    : ${2:?};
    
    local nsParent="$1";
    local nsNew="$2";
    
    local fList=`declare -F \
        | sed -n 's#^declare -f CLASS_'"$nsParent"'_\(.*\)$#\1#p'`;
    local IFS=`echo -e "\n\r"`;
    for f in $fList; do
        local fNameParent='CLASS_'"$nsParent"'_'"$f";
        local fNameNew='CLASS_'"$nsNew"'_'"$f";
        eval 'function '"$fNameParent"'() { '"fNameNew"' "$@"; }';
    done;
}

##
# Create aliases for object functions.
#
# $1    string  namespace class
# $2    string  namespace object
# $?    0:OK    1:ERROR
function _createObjectAliases()
{
    : ${1:?};
    : ${2:?};
    
    local ns="$1";
    local nsObj="$2";
    
    local fList=`declare -F \
        | sed -n 's#^declare -f CLASS_'"$ns"'_\(.*\)$#\1#p'`;
    local IFS=`echo -e "\n\r"`;
    for f in $fList; do
        eval 'alias OBJECT_'"$nsObj"'_'"$f"'='"'_objectCall \"$ns\" \"$nsObj\" \"$f\"'";
        [ 0 == "$BASHOR_MODE_COMPATIBLE" ] \
            && eval "alias $nsObj"'.'"$f"'='"'_objectCall \"$ns\" \"$nsObj\" \"$f\"'";
    done;
}

##
# Remove aliases for object functions.
#
# $1    string  namespace class
# $2    string  namespace object
# $?    0:OK    1:ERROR
function _removeObjectAliases()
{
    : ${1:?};
    : ${2:?};
    
    local ns="$1";
    local nsObj="$2";
    
    local fList=`declare -F \
        | sed -n 's#^declare -f CLASS_'"$ns"'_\(.*\)$#\1#p'`;
    local IFS=`echo -e "\n\r"`;
    for f in $fList; do
        eval 'unalias OBJECT_'"$nsObj"'_'"$f";
        [ 0 == "$BASHOR_MODE_COMPATIBLE" ] \
            && eval "unalias $nsObj"'.'"$f";
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
# $1    string  class name
# $2    string  object name
# $3    string  function name
# $@    params
# $?    0:OK    1:ERROR
function object()
{
    _objectCall "$@";
    return "$?";
}

##
# Call a object method
#
# $1    string  object name
# $2    string  function name
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
    #_createObjectAliases "$ns" "$nsObj";
    
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
# $CLASS_NAME   string  class name
# &1    string var name
# $?    0:OK    1:ERROR
function _objectVarName()
{
    : ${CLASS_NAME:?};
    
    local dataVarName='_CLASS_DATA_'"$CLASS_NAME";    
    [ -n "$OBJECT_NAME" ] && local dataVarName='_OBJECT_DATA_'"$OBJECT_NAME";
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
    
    local dataVarName=`_objectVarName`;
    
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
    esac
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
    
    local value="$3";            
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
