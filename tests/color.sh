#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Tests
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3 version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

loadClass 'Color';

right=`echo -en '\033[1;31mtest\033[0m'`;
res=`class Color fg 'test' 'red' 'bold'`;
checkSimple "fg" "$res" "$right";

right=`echo -en '\033[41mtest\033[0m'`;
res=`class Color bg 'test' 'red'`;
checkSimple "bg" "$res" "$right";

