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
# @version      $Id: escape.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

##
# Get the process id.
#
# &1 pid
# $?    0:OK    1:ERROR
function CLASS_Bashor_Process_pid()
{
    echo "$$";
    return 0;
}

##
# Get the parent process id.
#
# &1 pid
# $?    0:OK    1:ERROR
function CLASS_Bashor_Process_ppid()
{
    echo "$PPID";
    return 0;
}
