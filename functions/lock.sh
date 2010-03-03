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
# Get lock filename.
#
# $1    string  Id
# $?    0:OK    1:ERROR
function lock_filename {
    echo "$1"".lock";
    return 0
}

##
# Delete the lockfile if not locked.
#
# $1    string  file
# $?    0:OK    1:LOCKED    2:ERROR
function lock_delete {
    if [ -f "$1" ]; then
        flock --nonblock "$1" rm "$1";
        return "$?";
    fi
    
    return 2;
}

##
# Check for read lock.
#
# $1    string  file
# $?    0:NOT LOCKED    1:LOCKED    2:ERROR
function lock_checkRead {
    if [ -f "$1" ]; then
        flock -s --nonblock "$1" "";
        return "$?";
    fi
    
    return 2;
}

##
# Check for write lock.
#
# $1    string  file
# $?    0:NOT LOCKED    1:LOCKED    2:ERROR
function lock_checkWrite {
    if [ -f "$1" ]; then
        flock --nonblock "$1" "";
        return "$?";
    fi
    
    return 2;
}
