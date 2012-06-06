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
# @version      $Id$
################################################################################

##
# escape string for regex
#
# $1    string  To escape
# $2    string  Expression limiter
# $?    0:OK    1:ERROR
CLASS_Bashor_Escape_regEx()
{
    requireParams S "$@"
    local replacement=`printf '%s' "${2:-/}" | sed 's#/#\\\\/#g'`

    printf '%s' "$1" \
        | sed 's#\([.^$*\\]\)#\\\1#g' \
        | sed 's#\([]]\|[[]\)#[\1]#g' \
        | sed 's/'"$replacement"'/\\'"$replacement"'/g'
        
    return "$?"
}

##
# escape string for regex replacement
#
# $1    string  To escape
# $2    string  Expression limiter
# $?    0:OK    1:ERROR
CLASS_Bashor_Escape_regExReplacement()
{
    requireParams S "$@"
    local replacement=`printf '%s' "${2:-/}" | sed 's#/#\\\\/#g'`

    printf '%s' "$1" \
        | sed 's#\([\\]\)#\\\1#g' \
        | sed 's/'"$replacement"'/\\'"$replacement"'/g'
    
    return "$?"
}
