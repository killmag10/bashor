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

loadClassOnce "Bashor_Escape"

##
# Repear a string.
#
# $1    char    one char
# $2    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_String_repeat()
{
    requireParams RR "$@"
    
    local char="`class Bashor_Escape regExReplacement "$1" '#'`"
    printf "%${2}s" | sed "s#.#$char#g"
    return $?
}

##
# Replace a string with a other.
#
# &0    string  text
# $1    string  find
# $2    string  replacement
# &1    string  text
# $?    0:OK    1:ERROR
CLASS_Bashor_String_replace()
{
    requireParams RR "$@"
    
    loadClassOnce Bashor_Escape
    local find="`class Bashor_Escape regEx "$1" '/'`"
    local replacement="`class Bashor_Escape regExReplacement "$2" '/'`"
    
    sed 's/'"$find"'/'"$replacement"'/g'
    return $?
}

