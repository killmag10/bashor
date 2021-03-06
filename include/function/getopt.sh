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
# Check if option exists
#
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
optIsset()
{
    : ${1:?}
    
    local key="$1"
    eval set -- "$OPT_ARGS"

    local first=0
    while shift "$first"; do
        local first=1
        [ "$1" == "--" ] && break
        
        [ "${1:0:1}" = '-' ] || continue
        
        local res=`echo "$1" | sed 's#^-##'`
        if [ "${res:0:1}" = '-' ]; then
            res="${res:1}"
            local opt=`optGetOptLongExtension "$res"`
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`
        fi
        if [ "$res" == "$key" ]; then
            return 0
        fi
        if [ ":" == "$opt" ]; then
            shift
        fi    
    done
        
    return 1
}

##
# Is option not empty
#
# $1    string  key
# $?    0:OK    1:ERROR
optIsNotEmpty()
{
    : ${1:?}
    optIsset "$1" || return 1
    local tmp=`optValue "$@"`
    [ -n "$tmp" ]
    return "$?"
}

##
# Is argument set
#
# $1    string  key
# $?    0:OK    1:ERROR
argIsset()
{
    : ${1:?}
    local key="$1"
    eval set -- "$OPT_ARGS"
    while [ "$1" != "--" ]; do shift 1; done
    [ "$#" -gt "$key" ] && [ "0" -lt "$key" ]
    return "$?"
}

##
# Is argument not empty
#
# $1    string  key
# $?    0:OK    1:ERROR
argIsNotEmpty()
{
    : ${1:?}
    argIsset "$1" || return 1
    local tmp=`argValue "$1"`
    [ -n "$tmp" ]
    return "$?"
}

##
# Get option value
#
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
optValue()
{
    : ${1:?}
    local key="$1"
    eval set -- "$OPT_ARGS"

    local first=0
    while shift "$first"; do
        first=1
        [ "$1" == "--" ] && break
        [ "${1:0:1}" = '-' ] || continue
        
        local res=`echo "$1" | sed 's#^-##'`
        if [ "${res:0:1}" = '-' ]; then
            res="${res:1}"
            local opt=`optGetOptLongExtension "$res"`
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`
        fi
        if [ ":" == "$opt" ]; then
            if [ "$res" == "$key" ]; then
                echo "$2"
                return 0
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
argValue()
{
    : ${1:?}

    local key="$1"
    eval set -- "$OPT_ARGS"
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
optKeys()
{
    local return=1
    eval set -- "$OPT_ARGS"

    local first=0
    while shift "$first"; do
        local first=1
        [ "$1" == "--" ] && break
        [ "${1:0:1}" = '-' ] || continue
        
        local res=`echo "$1" | sed 's#^-##'`
        if [ "${res:0:1}" = '-' ]; then
            res="${res:1}"
            local opt=`optGetOptLongExtension "$res"`
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`
        fi
        echo "$res"
        return=0
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
optList()
{
    local return=1
    eval set -- "$OPT_ARGS"

    local first=0
    while shift "$first"; do
        local first=1
        [ "$1" == "--" ] && break
        [ "${1:0:1}" = '-' ] || continue
        
        local res=`echo "$1" | sed 's#^-##'`
        if [ "${res:0:1}" = '-' ]; then
            res="${res:1}"
            local opt=`optGetOptLongExtension "$res"`
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`
        fi
        echo -n "$res="
        return=0
        if [ ":" == "$opt" ]; then
            echo -n "$2"
            shift
        fi
        echo
    done
        
    return "$return"
}

##
# Get argument list
#
# $?    0:OK    1:ERROR
argList()
{
    (
        local return=1
        eval set -- "$OPT_ARGS"

        local first=0
        while shift "$first"; do
            local first=1
            [ "$1" == "--" ] && break
        done

        while shift "$first"; do
            echo "$1"
            return=0
        done
        
        return "$return"
    ) | head -n -1

    return "$?"
}

##
# Set expressions
#
# $1    string  getopts expression
# $2    string  long getopts expression
# $?    0:FOUND 1:NOT FOUND
optSetOpts()
{    
    OPT_OPTS="$1"
    OPT_OPTS_LONG="$2"
    return 0
}

##
# Set arguments
#
# $@    arguments
# $?    0:FOUND 1:NOT FOUND
optSetArgs()
{    
    OPT_ARGS=`getopt -q -o "$OPT_OPTS" --long "$OPT_OPTS_LONG" -- "$@"`
    return "$?"
}

##
# Set expressions (long not supported)
#
# 1:Short 2:Long
#
# $?    0:OK 1:ERROR
optGetOpts()
{    
    echo "$OPT_OPTS"
    echo "$OPT_OPTS_LONG"
    return 0
}

##
# Get arguments
#
# $?    0:OK 1:ERROR
optGetArgs()
{        
    echo "$OPT_ARGS"
    return 0
}

##
# Get long expression Extension
#
# $1    string  long getopts expression value
# $?    0:FOUND 1:NOT FOUND
optGetOptLongExtension()
{
    local IFS=','
    for value in $OPT_OPTS_LONG; do
        local key=`echo "$value" | sed 's#:##g'`
        if [ "$key" == "$1" ]; then
            echo "$value" | sed 's#[^:]##g'
            return 0
        fi
    done
    return 1
}
