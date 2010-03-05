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
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

export BASHOR_FUNCTION_LOG_FILE="$BASHOR_LOG_FILE";
if [ -n "$1" ]; then
    export BASHOR_FUNCTION_LOG_FILE="$1";
fi

##
# Write a message to log
#
# $1    string  Text
# &0    string  Text
function log()
{
    if [ -p "/dev/stdin" ]; then
        cat - >> "$BASHOR_FUNCTION_LOG_FILE";
    else
        echo "$1" >> "$BASHOR_FUNCTION_LOG_FILE";
    fi
}

##
# Log a error message
#
# $1    string  Text
# &0    string  Text
function log_error()
{
    datestring=`date +'%Y-%m-%d %H:%M:%S'`;
    if [ -p "/dev/stdin" ]; then
        nl | sed "s#^#$datestring ERROR: #" | log;
    else
        echo "$datestring ERROR: $1" | log;
    fi
}

##
# Log a debug message
#
# $1    string  Text
# &0    string  Text
function log_debug()
{
    datestring=`date +'%Y-%m-%d %H:%M:%S'`;
    if [ -p "/dev/stdin" ]; then
        nl | sed "s#^#$datestring DEBUG: #" | log;
    else
        echo "$datestring DEBUG: $1" | log;
    fi

}
