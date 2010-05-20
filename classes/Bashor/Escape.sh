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
# @subpackage   Class
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: escape.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

##
# escape string for regex
#
# $1    string  To escape
# -d    string  Expression limiter
# $?    0:OK    1:ERROR
function CLASS_Bashor_Escape_regEx()
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
        | sed 's#\([.^$*\\]\)#\\\1#g' \
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
function CLASS_Bashor_Escape_regExReplacement()
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
