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
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################


##
# Get a random number between 0 and 32767
#
# $1    integer min
# $2    integer max
# &1    integer random number
# $?    0:OK    1:ERROR
function CLASS_Bashor_Math_random()
{
    requireParams RR "$@"
    [ "$1" -gt "$2" ] && error "Min can't greater than max."

    echo "$(((RANDOM)/(32768/($2-$1))+$1))"        
    return $?
}
