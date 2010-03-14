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
# @version      $Id: hash.sh 16 2010-03-12 23:35:45Z lars $
################################################################################


##
# Get the md5 hash
#
# $1    string  Text
# $?    0:OK    1:ERROR
function terminal_getColumns()
{
    stty size | sed -n 's#^\S\+\s\+\(\S\+\)$#\1#p'
    return $?
}

##
# Get the md5 hash
#
# $1    string  Text
# $?    0:OK    1:ERROR
function terminal_getRows()
{
    stty size | sed -n 's#^\(\S\+\)\s\+\S\+$#\1#p'
    return $?
}
