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
# @version      $Id: hash.sh 16 2010-03-12 23:35:45Z lars $
################################################################################


##
# Get the md5 hash
#
# $1    char    one char
# $2    integer count
# $3    lines
# $?    0:OK    1:ERROR
function CLASS_Bashor_String_repeat()
{
    : ${1:?};
    : ${2:?};
    
    dd if=/dev/zero bs=1 count="$2" 2>/dev/null | tr '\0' "$1";
    return $?
}
