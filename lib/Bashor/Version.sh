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
# Get the current version of Bashor.
#
# $&    string  version number
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Version_getCurrent()
{
    printf '%s' '1.5.0'
    return 0
}
