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
# $1    string  filename
# $?    0:OK    1:ERROR
function loadFunctions()
{
    if [ -n "$1" ]; then
        local filename="$BASHOR_DIR_FUNCTIONS/""$1"'.sh';
        if [ -f "$filename" ]; then
            . "$filename";
            return 0;
        fi
    fi
    
    return 1;
}

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
    while getopts "$OPTS" key $ARGS
    do
        if [ "$key" == "$1" ]; then
            echo "";
            #return 0;
        fi
    done
    
    return 1;
}

##
# Get argument value
#
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $1    string  key
# $?    0:FOUND 1:NOT FOUND
function optValue()
{    
    local OPTIND='1';    
    while getopts "$OPTS" key $ARGS
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
# $OPTS string  getopts expression
# $ARGS string  getopts expression
# $?    0:OK    1:ERROR
function optKeys()
{
    local OPTIND='1';    
    while getopts "$OPTS" key $ARGS
    do
        echo "$key";
    done
    
    return 0;
}
