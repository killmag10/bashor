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
# @subpackage   Tests
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

loadFunctions 'color';

right=`echo -en '\033[1;31mtest\033[0m'`;
res=`color_fg 'test' 'red' 'bold'`;
checkSimple "fg" "$res" "$right";

right=`echo -en '\033[41mtest\033[0m'`;
res=`color_bg 'test' 'red'`;
checkSimple "bg" "$res" "$right";

