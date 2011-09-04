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
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Constructor
#
# $1    string  temp dir
CLASS_Bashor_Temp___construct()
{
    requireObject
    requireParams R "$@"
    
    this set dir "$1"
}


##
# Get a temp dir path.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &0    string  path
CLASS_Bashor_Temp_dir()
{
    requireObject
    requireParams R "$@"
    
    local dir=`this get dir`
    mkdir -p "$dir/"
    printf '%s' "$dir/"`this call generateFilename "$1"`
    return "$?"
}

##
# Get a temp file path.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &0    string  path
CLASS_Bashor_Temp_file()
{
    requireObject
    requireParams R "$@"

    printf '%s' "`this call dir \"$1\"`"'.tmp'
    return "$?"
}

##
# Get a temp file name.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &0    string  name
CLASS_Bashor_Temp_generateFilename()
{
    requireParams R "$@"

    printf '%s' 'temp_'`date +'%Y%m%dT%H%M%S'`"_""$$""_""$1""_""$RANDOM"
    return 0
}

##
# Clear the temp dir.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Temp_clear()
{
    requireObject
    
    local dir=`this get dir`
    if [ -n "$dir" ] && [ -d "$dir" ]; then
        rm -r "$dir/"*
        return "$?"
    fi
}
