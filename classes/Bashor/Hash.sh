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
