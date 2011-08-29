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
# Create a file lock
#
# @see flock
# $?    0:OK    1:LOCKED    2:ERROR
CLASS_Bashor_Lock_lock()
{
    requireParams R "$@"
    
    flock "$@"
    return "$?"
}

##
# Get lock filename.
#
# $1    string  Id
# $?    0:OK    1:ERROR
CLASS_Bashor_Lock_filename()
{
    requireParams R "$@"
    
    echo "$1"".lock"
    return 0
}

##
# Delete the lockfile if not locked.
#
# $1    string  file
# $?    0:OK    1:LOCKED    2:ERROR
CLASS_Bashor_Lock_delete()
{
    requireParams R "$@"
    
    if [ -f "$1" ]; then
        flock --nonblock "$1" rm "$1"
        return "$?"
    fi
    
    return 2
}

##
# Check for read lock.
#
# $1    string  file
# $?    0:NOT LOCKED    1:LOCKED    2:ERROR
CLASS_Bashor_Lock_checkRead()
{
    requireParams R "$@"
    
    if [ -f "$1" ]; then
        flock -s --nonblock "$1" "true"
        return "$?"
    fi
    
    return 0
}

##
# Check for write lock.
#
# $1    string  file
# $?    0:NOT LOCKED    1:LOCKED    2:ERROR
CLASS_Bashor_Lock_checkWrite()
{
    requireParams R "$@"
    
    if [ -f "$1" ]; then
        flock --nonblock "$1" "true"
        return "$?"
    fi
    
    return 0
}
