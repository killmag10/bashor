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
            createClassAliases "$filename" "$ns";
            return 0;
        fi
    fi
    
    return 1;
}

##
# Get functions of a file.
#
# $1    string  file
# $2?    string  namespace
# $?    0:OK    1:ERROR
function createClassAliases()
{
    : ${1:?};
    : ${2:?};
    
    local ns='';
    [ -n "$2" ] && local ns="$2"'_';
    
    local fList=`cat "$1" | \
        sed -n 's#^\s*function\s\+\('"$ns"'[^(){} ]\+\)\(()\)\?.*$#\1#p'`;
    local IFS=`echo -e "\n\r"`;
    for f in $fList; do
        fAlias=`echo "$f" | sed 's#_#::#'`;
        eval "alias class_""$f"'='"'_classCall \"$2\" \"$f\"'";
        [ 0 == "$BASHOR_MODE_COMPATIBLE" ] \
            && eval "alias $fAlias"'='"'_classCall \"$2\" \"$f\"'";
    done;
}

##
# Call a class function
#
# $1    string  class name
# $2    string  function name
# $@    params
# $?    0:OK    1:ERROR
function _classCall()
{
    : ${1:?};
    : ${2:?};
    
    CLASS_NAME="$1";
    OBJECT_NAME="";
    FUNCTION_NAME="$2";
    shift 2;
    "$FUNCTION_NAME" "$@";
    return "$?";
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
    
    CLASS_NAME="$1";
    OBJECT_NAME="$2";
    FUNCTION_NAME="$3"
    shift 3;
    "$FUNCTION_NAME" "$@";
    return "$?";
}

function this()
{
    : ${1:?};
    : ${2:?};
    
    local dataVarName='_CLASS_DATA_'"$CLASS_NAME";    
    [ -n "$OBJECT_NAME" ] && local dataVarName='_OBJECT_DATA_'"$OBJECT_NAME";
    
    case "$1" in
        set)
            : ${3:?};
            _object_set "$dataVarName" "$2" "$3";
            return "$?";
            ;;
        get)
            _object_get "$dataVarName" "$2";
            return "$?";
            ;;
        unset)
            _object_unset "$dataVarName" "$2";
            return "$?";
            ;;
        isset)
            _object_isset "$dataVarName" "$2";
            return "$?";
            ;;
    esac
}

##
# Save in object var.
#
# $1    string  var name
# $2    string  key
# $3    string  data
# $?    0:OK    1:ERROR
# &0    string  Data
function _object_set()
{
    : ${1:?};
    : ${2:?};
    : ${3:?};
    
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
function _object_unset()
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
function _object_get()
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
function _object_isset()
{
    : ${1:?};
    
    eval 'local data="$'"$1"'";'
    local key=`echo "$1" | base64`;
    local res=`echo "$data" | grep "^$key "`
    if [ -n "$res" ]; then
        return 0;
    fi
    
    return 1;
}
