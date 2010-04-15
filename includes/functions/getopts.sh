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
    
    local OPTIND='1';    
    local pArgs=`echo "$OPT_ARGS" | sed 's#^[^-]*##'`;
    while getopts "$OPT_OPTS" key $pArgs
    do
        [ "$key" == "$1" ] && return 0;
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
       
    local OPTIND='1';    
    local pArgs=`echo "$OPT_ARGS" | sed 's#^[^-]*##'`;
    while getopts "$OPT_OPTS" key $pArgs
    do
        if [ "$key" == "$1" ]; then
            echo "$OPTARG";
            return 0;
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
    local OPTIND='1';    
    local pArgs=`echo "$OPT_ARGS" | sed 's#^[^-]*##'`;
    while getopts "$OPT_OPTS" key $pArgs
    do
        echo "$key";
    done
    
    return 0;
}

##
# Get argument keys and valus seperate by :
#
# $?    0:OK    1:ERROR
function optList()
{
    local OPTIND='1';    
    local pArgs=`echo "$OPT_ARGS" | sed 's#^[^-]*##'`;
    while getopts "$OPT_OPTS" key $pArgs
    do
        echo "$key=$OPTARG";
    done
    
    return 0;
}

##
# Set expressions (long not supported)
#
# $1    string  getopts expression
# $2    string  long getopts expression
# $?    0:OK 1:ERROR
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
# $?    0:OK 1:ERROR
function optSetArgs()
{        
    OPT_ARGS="$@";
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
