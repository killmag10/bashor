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
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function optIsset()
{    
    local OPTIND='1';    
    local pArgs=`echo $ARGS | sed 's#^[^-]*##'`;
    while getopts "$OPTS" key $pArgs
    do
        if [ "$key" == "$1" ]; then
            return 0;
        fi
    done
    
    return 1;
}

##
# Get argument value
#
# $OPTS string  getopts expression
# $OPTS_LONG string  getopts expression
# $ARGS string  getopts expression
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function optValue()
{    
    local OPTIND='1'; 
    local key="$1";
    local pos=0;
    local args=`echo "$ARGS" | sed 's#"#\\\\\\"#'`;
    local res=`getopt -o "$OPTS" --long "$OPTS_LONG" -- $args`
    eval set -- "$res";    

    while shift; do
        ((pos++));
        echo "$1" | grep -q '^-';
        if [ "$?" != "0" ]; then
            echo "$1: continue"
            shift;
            continue;
        fi
        echo "$1"
        local res=`echo "$1" | sed 's#^-##'`;
        echo "$res"
        echo "$res" | grep -q '^-';
        if [ "$?" == 0 ]; then
            local opt=`echo "$OPTS_LONG" | cut -f "$pos" -d "," | rev | cut -b -1`;
        else
            local opt=`echo "$OPTS" | cut -f 2 -d "$key" | cut -b 1`;
        fi
        if [ ":" == "$opt" ]; then
            if [ "$res" == "$key" ]; then
                echo "FOUND $1: $2"
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
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $?    0:OK    1:ERROR
function optKeys()
{
    local OPTIND='1';    
    local pArgs=`echo $ARGS | sed 's#^[^-]*##'`;
    while getopts "$OPTS" key $pArgs
    do
        echo "$key";
    done
    
    return 0;
}

##
# Get argument keys and valus seperate by :
#
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $?    0:OK    1:ERROR
function optList()
{
    local OPTIND='1';    
    local pArgs=`echo $ARGS | sed 's#^[^-]*##'`;
    while getopts "$OPTS" key $pArgs
    do
        echo "$key=$OPTARG";
    done
    
    return 0;
}
