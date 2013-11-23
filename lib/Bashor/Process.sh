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

