#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################


##
# Get a random number between 0 and 32767
#
# $1    integer min
# $2    integer max
# &1    integer random number
# $?    0:OK    1:ERROR
CLASS_Bashor_Math_random()
{
    requireParams RR "$@"
    [ "$1" -gt "$2" ] && error "Min can't greater than max."

    printf '%d' "$((RANDOM % ($2-$1+1) + $1))"
    return $?
}
