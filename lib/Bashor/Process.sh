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
# Get the process id.
#
# &1 pid
# $?    0:OK    1:ERROR
CLASS_Bashor_Process_pid()
{
    printf '%s' "$$"
    return 0
}

##
# Get the parent process id.
#
# &1 pid
# $?    0:OK    1:ERROR
CLASS_Bashor_Process_ppid()
{
    printf '%s' "$PPID"
    return 0
}

