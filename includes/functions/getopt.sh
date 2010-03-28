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
# Check if argument exists
#
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function optIsset()
{
    : ${1:?};
    
    local key="$1";
    eval set -- "$OPT_ARGS";    

    local first=0;
    while shift "$first"; do
        local first=1;
        [ "$1" == "--" ] && break;
        echo "$1" | grep -q '^-' || continue;
        
        local res=`echo "$1" | sed 's#^-##'`;
        echo "$res" | grep -q '^-';
        if [ "$?" == 0 ]; then
            local res="${res:1}";
            local opt=`optGetOptLongExtension "$res"`;
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`;
        fi
        if [ "$res" == "$key" ]; then
            return 0;
        fi
        if [ ":" == "$opt" ]; then
            shift;
        fi    
    done
        
    return 1;
}

##
# Get argument value
#
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function optValue()
{
    : ${1:?};
        
    local key="$1";
    eval set -- "$OPT_ARGS";    

    local first=0;
    while shift "$first"; do
        local first=1;
        [ "$1" == "--" ] && break;
        echo "$1" | grep -q '^-' || continue;
        
        local res=`echo "$1" | sed 's#^-##'`;
        echo "$res" | grep -q '^-';
        if [ "$?" == 0 ]; then
            local res="${res:1}";
            local opt=`optGetOptLongExtension "$res"`;
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`;
        fi
        if [ ":" == "$opt" ]; then
            if [ "$res" == "$key" ]; then
                echo "$2"
                return 0;
            fi
            shift;
        fi    
    done
        
    return 1;
}

##
# Get argument keys
#
# $?    0:OK    1:ERROR
function optKeys()
{
    local key="$1";
    local return=1;
    eval set -- "$OPT_ARGS";    

    local first=0;
    while shift "$first"; do
        local first=1;
        [ "$1" == "--" ] && break;
        echo "$1" | grep -q '^-' || continue;
        
        local res=`echo "$1" | sed 's#^-##'`;
        echo "$res" | grep -q '^-';
        if [ "$?" == 0 ]; then
                local res="${res:1}";
            local opt=`optGetOptLongExtension "$res"`;
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`;
        fi
        echo "$res";
        local return=0;
        if [ ":" == "$opt" ]; then
            shift;
        fi    
    done
        
    return "$return";
}

##
# Get argument keys and valus seperate by :
#
# $?    0:OK    1:ERROR
function optList()
{
    local key="$1";
    local return=1;
    eval set -- "$OPT_ARGS";    

    local first=0;
    while shift "$first"; do
        local first=1;
        [ "$1" == "--" ] && break;
        echo "$1" | grep -q '^-' || continue;
        
        local res=`echo "$1" | sed 's#^-##'`;
        echo "$res" | grep -q '^-';
        if [ "$?" == 0 ]; then
            local res="${res:1}";
            local opt=`optGetOptLongExtension "$res"`;
        else
            local opt=`echo "$OPT_OPTS" | cut -f 2 -d "$res" | cut -b 1`;
        fi
        echo -n "$res=";
        local return=0;
        if [ ":" == "$opt" ]; then
            echo -n "$2";
            shift;
        fi
        echo "";  
    done
        
    return "$return";
}

##
# Set expressions
#
# $1    string  getopts expression
# $2    string  long getopts expression
# $?    0:FOUND 1:NOT FOUND
function optSetOpts()
{
    : ${1:?};
    
    OPT_OPTS="$1";
    OPT_OPTS_LONG="$2";
    return 0;
}

##
# Set arguments
#
# $@    arguments
# $?    0:FOUND 1:NOT FOUND
function optSetArgs()
{    
    OPT_ARGS=`getopt -o "$OPT_OPTS" --long "$OPT_OPTS_LONG" -- "$@"`;
    return "$?";
}

##
# Set expressions (long not supported)
#
# 1:Short 2:Long
#
# $?    0:OK 1:ERROR
function optGetOpts()
{    
    echo "$OPT_OPTS";
    echo "$OPT_OPTS_LONG";
    return 0;
}

##
# Get arguments
#
# $?    0:OK 1:ERROR
function optGetArgs()
{        
    echo "$OPT_ARGS";
    return "0";
}

##
# Get long expression Extension
#
# $1    string  long getopts expression value
# $?    0:FOUND 1:NOT FOUND
function optGetOptLongExtension()
{
    local IFS=",";
    for value in $OPT_OPTS_LONG; do
        local key=`echo "$value" | sed 's#:##g'`;
        if [ "$key" == "$1" ]; then
            echo "$value" | sed 's#[^:]##g';
            return 0;
        fi
    done;
    return 1;
}
