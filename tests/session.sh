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

loadClass 'Session' "$TEST_TEMP_DIR/registry" -c;
nl=`echo -e '\n\r'`;

class Session set "test" "blub 123blub";
checkSimple "set 1" "$?" "0";

class Session set "bli" "`dd if=\"$TEST_RESOURCE_DIR/random.dat\" bs=32K count=1 2>/dev/null`";
checkSimple "set 2" "$?" "0";

res=`class Session get "test"`;
checkSimple "get 1" "$res" "blub 123blub";

res=`class Session get "bli"`;
checkSimple "get 2" "$res" "`dd if=\"$TEST_RESOURCE_DIR/random.dat\" bs=32K count=1 2>/dev/null`";

class Session isset "test";
checkSimple "isset isset 1" "$?" "0";

class Session remove "test";
checkSimple "remove 1" "$?" "0";

class Session isset "test";
checkSimple "isset notset 1" "$?" "1";

class Session isCompressed;
checkSimple "isCompressed" "$?" "0";

res=`class Session size`;
checkSimple "size" "$res" "28795";
