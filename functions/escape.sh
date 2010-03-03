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

##
# escape string for regex
#
# $1    string  To escape
# $2    string  Expression limiter
# $?    0:OK    1:ERROR
function escape_RegEx ()
{
    if [ -n "$2" ]; then
        replacement=`echo "$2" | sed 's#/#\\/#g'`;
    else
        replacement='\/';
    fi

    echo "$1" \
        | sed 's#\([.^$]\)#\\\1#g' \
        | sed 's#\([]]\|[[]\)#[\1]#g' \
        | sed 's/'"$replacement"'/\\'"$replacement"'/g';
        
    return 0;
}

##
# escape string for regex replacement
#
# $1    string  To escape
# $2    string  Expression limiter
# $?    0:OK    1:ERROR
function escape_RegExReplacement ()
{
    if [ -n "$2" ]; then
        replacement=`echo "$2" | sed 's#/#\\/#g'`;
    else
        replacement='\/';
    fi

    echo "$1" | sed 's/'"$replacement"'/\\'"$replacement"'/g';
}
