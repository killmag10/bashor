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
# -d    string  Expression limiter
# $?    0:OK    1:ERROR
function escape_regEx ()
{
    : ${1?};
    
    optSetOpts 'd:';
    optSetArgs "$@";
    
    if optIsset 'd'; then
        local replacement=`optValue 'd'`;
        local replacement=`echo "$replacement" | sed 's#/#\\/#g'`;
    else
        local replacement='\/';
    fi

    echo "$1" \
        | sed 's#\([.^$\\]\)#\\\1#g' \
        | sed 's#\([]]\|[[]\)#[\1]#g' \
        | sed 's/'"$replacement"'/\\'"$replacement"'/g';
        
    return "$?";
}

##
# escape string for regex replacement
#
# $1    string  To escape
# -d    string  Expression limiter
# $?    0:OK    1:ERROR
function escape_regExReplacement ()
{
    : ${1?};
    
    optSetOpts 'd:';
    optSetArgs "$@";
    
    if optIsset 'd'; then
        local replacement=`optValue 'd'`;
        local replacement=`echo "$replacement" | sed 's#/#\\/#g'`;
    else
        local replacement='\/';
    fi

    echo "$1" \
        | sed 's#\([\\]\)#\\\1#g' \
        | sed 's/'"$replacement"'/\\'"$replacement"'/g';
    
    return "$?";
}
