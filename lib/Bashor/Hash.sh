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
# Get the md5 hash
#
# $1    string  Text
# $?    0:OK    1:ERROR
CLASS_Bashor_Hash_md5()
{
    requireParams S "$@"
    
    printf '%s' "$1" | md5sum | sed 's/^\(\S\+\).*/\1/'
    return $?
}
