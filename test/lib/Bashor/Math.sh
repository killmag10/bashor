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
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3 version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

loadClass 'Bashor_Math';

res=`class Bashor_Math random 3 5`;
[ "$res" -ge 3 ] && [ "$res" -le 5 ];
checkSimple "random 1" "$?" "0";

res=`class Bashor_Math random -3 5`;
[ "$res" -ge -3 ] && [ "$res" -le 5 ];
checkSimple "random 2" "$?" "0";

res=`class Bashor_Math random -3 -1`;
[ "$res" -ge -3 ] && [ "$res" -le -1 ];
checkSimple "random 3" "$?" "0";

res=`class Bashor_Math random 0 32767`;
[ "$res" -ge 0 ] && [ "$res" -le 32767 ];
checkSimple "random 4" "$?" "0";
