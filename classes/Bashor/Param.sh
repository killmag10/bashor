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

function CLASS_Bashor_Param___construct()
{
    requireObject
    
    this call setOpts "$1" "$2"
    return $?
}

##
# Check if option exists
#
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function CLASS_Bashor_Param_issetOpt()
{
    requireObject
    requireParams R "$@"
    
    local key="$1"
    eval set -- "`this get optsArgs`"  

    local first=0
    while shift "$first"; do
        local first=1
        [ "$1" == "--" ] && break        
        [ "${1:0:1}" = '-' ] || continue
        
        if [ "${1:0:2}" = '--' ]; then
            local opt=`this call getOptLongExtension "${1:2}"`
        else
            local opt=`echo "\`this get opts\`" | cut -f 2 -d "${1:1}" | cut -b 1`
        fi
        [ "$1" == "$key" ] && return 0
        [ ":" == "$opt" ] && shift    
    done
        
    return 1
}

##
# Is option not empty
#
# $1    string  key
# $?    0:OK    1:ERROR
function CLASS_Bashor_Param_notEmptyOpt()
{
    requireObject
    requireParams R "$@"
    
    this call issetOpt "$1" || return 1
    local tmp=`this call getOpt "$@"`
    [ "$tmp" != '' ]
    return "$?"
}

##
# Is argument set
#
# $1    string  key
# $?    0:OK    1:ERROR
function CLASS_Bashor_Param_issetArg()
{
    requireObject
    requireParams R "$@"
    
    local key="$1"
    eval set -- "`this get optsArgs`"
    while [ "$1" != "--" ]; do shift 1; done
    [ "$#" -gt "$key" ] && [ "0" -lt "$key" ]
    return "$?"
}

##
# Is argument / option not empty
#
# $?    0:OK 1:ERROR
function CLASS_Bashor_Param_notEmpty()
{
    requireObject
    requireParams R "$@"
    
    if [ "${1:0:1}" == '-' ]; then    
        this call notEmptyOpt "$1"
        return $?
    fi
    
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        this call notEmptyArg "$1"
        return $?
    fi
    
    return 1
}

##
# Is argument not empty
#
# $1    string  key
# $?    0:OK    1:ERROR
function CLASS_Bashor_Param_notEmptyArg()
{
    requireObject
    requireParams R "$@"
    
    this call issetArg "$1" || return 1
    local tmp=`this call getArg "$1"`
    [ "$tmp" != '' ]
    return "$?"
}

##
# Get option value
#
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function CLASS_Bashor_Param_getOpt()
{
    requireObject
    requireParams R "$@"
    
    local key="$1"
    eval set -- "`this get optsArgs`" 

    local first=0
    while shift "$first"; do
        local first=1
        [ "$1" == "--" ] && break
        [ "${1:0:1}" = '-' ] || continue
        
        if [ "${1:0:2}" = '--' ]; then
            local opt=`this call getOptLongExtension "${1:2}"`
        else
            local opt=`echo "\`this get opts\`" | cut -f 2 -d "${1:1}" | cut -b 1`
        fi
        if [ ":" == "$opt" ]; then
            if [ "$1" == "$key" ]; then
                echo "$2"
                return 0;
            fi
            shift
        fi
    done
    
    return 1
}

##
# Get a argument value
#
# $1    string  key
# $?    0:OK    1:ERROR
function CLASS_Bashor_Param_getArg()
{
    requireObject
    requireParams R "$@"
    
    local key="$1"
    eval set -- "`this get optsArgs`"
    while [ "$1" != "--" ]; do shift 1; done

    shift $key
    if [ "$?" = 0 ]; then
        echo "$1"
        return 0
    fi    
    return "1"
}

##
# Get option keys
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Param_getOptKeys()
{
    requireObject
    
    local return=1
    eval set -- "`this get optsArgs`"

    local first=0
    while shift "$first"; do
        local first=1
        [ "$1" == "--" ] && break
        [ "${1:0:1}" = '-' ] || continue
        
        if [ "${1:0:2}" = '--' ]; then
            local opt=`this call getOptLongExtension "${1:2}"`
        else
            local opt=`echo "\`this get opts\`" | cut -f 2 -d "${1:1}" | cut -b 1`
        fi
        echo "$1"
        local return=0
        if [ ":" == "$opt" ]; then
            shift
        fi    
    done
        
    return "$return"
}

##
# Get option keys and valus seperate by :
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Param_listOpt()
{
    requireObject
    
    local return=1
    eval set -- "`this get optsArgs`" 
    
    local first=0
    while shift "$first"; do
        local first=1
        [ "$1" == "--" ] && break
        [ "${1:0:1}" = '-' ] || continue
        
        if [ "${1:0:2}" = '--' ]; then
            local opt=`this call getOptLongExtension "${1:2}"`
        else
            local opt=`echo "\`this get opts\`" | cut -f 2 -d "${1:1}" | cut -b 1`
        fi
        echo -n "$1"
        local return=0
        if [ ":" == "$opt" ]; then
            echo -n " $2"
            shift
        fi
        echo ""
    done
        
    return "$return"
}

##
# Get argument list
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Param_listArg()
{
    requireObject
    
    (
        eval set -- "`this get optsArgs`"

        local first=0;
        while shift "$first"; do
            first=1
            [ "$1" == "--" ] && break
        done

        while shift "$first"; do
            echo "$1"
        done;
        
        return 0
    ) | head -n -1

    return $?
}

##
# Set expressions
#
# $1    string  getopts expression
# $2    string  long getopts expression
# $?    0:FOUND 1:NOT FOUND
function CLASS_Bashor_Param_setOpts()
{
    requireObject
    
    this set opts "$1"
    this set optsLong "$2"
    return 0
}

##
# Set arguments
#
# $@    arguments
# $?    0:FOUND 1:NOT FOUND
function CLASS_Bashor_Param_set()
{    
    requireObject
    
    local opts="`this get opts`"
    local optsLong="`this get optsLong`"
    
    this set optsArgs "`getopt -q -o "$opts" --long "$optsLong" -- "$@"`"
    return "$?"
}

##
# Set expressions (long not supported)
#
# 1:Short 2:Long
#
# $?    0:OK 1:ERROR
function CLASS_Bashor_Param_getOpts()
{    
    requireObject

    this get opts
    this get optsLong
    return 0
}

##
# Get arguments / options
#
# $?    0:OK 1:ERROR
function CLASS_Bashor_Param_get()
{
    requireObject
    
    if [ -z "$1" ]; then    
        this get optsArgs
        return $?
    fi
    
    if [ "${1:0:1}" == '-' ]; then    
        this call getOpt "$1"
        return $?
    fi
    
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        this call getArg "$1"
        return $?
    fi
    
    return 1
}

##
# Isset arguments / options
#
# $?    0:OK 1:ERROR
function CLASS_Bashor_Param_isset()
{
    requireObject
    requireParams R "$@"
        
    if [ "${1:0:1}" == '-' ]; then    
        this call issetOpt "$1"
        return $?
    fi
    
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        this call issetArg "$1"
        return $?
    fi
    
    return 1
}

##
# Get long expression Extension
#
# $1    string  long getopts expression value
# $?    0:FOUND 1:NOT FOUND
function CLASS_Bashor_Param_getOptLongExtension()
{
    requireObject
    
    local IFS=","
    local value
    for value in `this get optsLong`; do
        local key=`echo "$value" | sed 's#:##g'`
        if [ "$key" == "$1" ]; then
            echo "$value" | sed 's#[^:]##g'
            return 0
        fi
    done
    return 1
}
