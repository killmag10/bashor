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
# $?    0:OK    1:ERROR
function loadClass()
{
    : ${1:?};
    
    if [ -n "$1" ]; then
        local filename="$BASHOR_DIR_CLASS/""$1"'.sh';
        local ns="$1";
        if [ -f "$filename" ]; then
            shift;
            . "$filename" "$@";
            _createClassAliases "$ns";
            
            declare -F | grep '^declare -f CLASS_'"$ns"'__load$' > /dev/null;
            [ "$?" == 0 ] && _staticCall "$ns" '_load' "$@";
            
            return 0;
        fi
    fi
    
    return 1;
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
# Call a class function
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
    local OLD_FUNCTION_NAME="$FUNCTION_NAME"
    export CLASS_NAME="$1";
    export OBJECT_NAME="";
    export FUNCTION_NAME="$2"
    local fName='CLASS_'"$CLASS_NAME"'_'"$FUNCTION_NAME";
    shift 2;
    "$fName" "$@";    
    local res="$?";
    export CLASS_NAME="$OLD_CLASS_NAME";
    export OBJECT_NAME="$OLD_OBJECT_NAME";
    export FUNCTION_NAME="$OLD_FUNCTION_NAME"
    return "$res";
}

##
# Call a class function
#
# $1    string  class name
# $2    string  object name
# $3    string  function name
# $@    params
# $?    0:OK    1:ERROR
function _objectCall()
{
    : ${1:?};
    : ${2:?};
    : ${3:?};
    
    local OLD_CLASS_NAME="$CLASS_NAME";
    local OLD_OBJECT_NAME="$OBJECT_NAME";
    local OLD_FUNCTION_NAME="$FUNCTION_NAME"
    export CLASS_NAME="$1";
    export OBJECT_NAME="$2";
    export FUNCTION_NAME="$3"
    local fName='CLASS_'"$CLASS_NAME"'_'"$FUNCTION_NAME";
    shift 3;
    "$fName" "$@";
    local res="$?"
    export CLASS_NAME="$OLD_CLASS_NAME";
    export OBJECT_NAME="$OLD_OBJECT_NAME";
    export FUNCTION_NAME="$OLD_FUNCTION_NAME"
    return "$res";
}

function new()
{
    : ${1:?};
    : ${2:?};
    
    local ns="$1";
    local nsObj="$2";    
    local dataVarName=`_objectVarName`;
    
    shift 2;
    
    _createObjectAliases "$ns" "$nsObj";

    eval 'export '"$dataVarName"'="";';

    declare -F | grep '^declare -f CLASS_'"$ns"'__construct$' > /dev/null;
    [ "$?" == 0 ] && _objectCall "$ns" "$nsObj" '_construct' "$@";
}

function clone()
{
    : ${1:?};
    : ${2:?};
    
    local nsObjOld="$1";
    local nsObjNew="$2";
    local nsObjVarOld='_OBJECT_DATA_'"$1";
    local nsObjVarNew='_OBJECT_DATA_'"$2";
    
    local ns=`alias \
        | sed -n 's#^alias OBJECT_'"$nsObjOld"'_[^=]\+='\''_objectCall "\([^"]\+\).*#\1#p' \
        | head -n 1`;
    
    shift 2;
    
    new "$ns" "$nsObjNew" "$@";
    eval 'export '"$nsObjVarNew"'="$'"$nsObjVarOld"'";';
    
}

function remove()
{
    : ${1:?};
    
    local nsObj="$1";
    local nsObjVarOld='_OBJECT_DATA_'"$1";
    local ns=`alias \
        | sed -n 's#^alias OBJECT_'"$nsObjOld"'_[^=]\+='\''_objectCall "\([^"]\+\).*#\1#p' \
        | head -n 1`;
    
    shift 1;
        
    declare -F | grep '^declare -f CLASS_'"$ns"'__destruct$' > /dev/null;
    [ "$?" == 0 ] && _objectCall "$ns" "$nsObj" '_destruct' "$@";
    
    _removeObjectAliases "$ns" "$nsObj";
    eval 'unset -v '"$nsObjVarOld"; 
}

function _objectVarName()
{
    : ${CLASS_NAME:?};
    
    local dataVarName='_CLASS_DATA_'"$CLASS_NAME";    
    [ -n "$OBJECT_NAME" ] && local dataVarName='_OBJECT_DATA_'"$OBJECT_NAME";
    echo "$dataVarName";
    return 0;
}

function this()
{
    : ${1:?};
    : ${2:?};
    : ${CLASS_NAME:?};
    
    local dataVarName=`_objectVarName`;
    
    case "$1" in
        set)
            : ${3?};
            _objectSet "$dataVarName" "$2" "$3";
            return "$?";
            ;;
        get)
            _objectGet "$dataVarName" "$2";
            return "$?";
            ;;
        unset)
            _objectUnset "$dataVarName" "$2";
            return "$?";
            ;;
        isset)
            _objectIsset "$dataVarName" "$2";
            return "$?";
            ;;
        call)
            local fName="$2"
            shift 2;
            [ -z "$OBJECT_NAME" ] && _staticCall "$CLASS_NAME" "$fName" "$@";
            [ -n "$OBJECT_NAME" ] && _objectCall "$CLASS_NAME" "$OBJECT_NAME" "$fName" "$@";
            return "$?";
            ;;
    esac
}

function isStatic()
{
    : ${CLASS_NAME:?};   
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
