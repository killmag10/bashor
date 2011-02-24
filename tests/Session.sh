#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3 version 3.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Tests
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3 version 3 version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

loadClass 'Bashor_Registry';
loadClass 'Bashor_Session';
local Session
new 'Bashor_Session' 'Session' "$TEST_TEMP_DIR/" -c
nl=`echo -e '\n\r'`;

object "$Session" set "test" "blub 123blub";
checkSimple "set 1" "$?" "0";

object "$Session" set "bli" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
checkSimple "set 2" "$?" "0";

res=`object "$Session" get "test"`;
checkSimple "get 1" "$res" "blub 123blub";

res=`object "$Session" get "bli"`;
checkSimple "get 2" "$res" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";

object "$Session" isset "test";
checkSimple "isset isset 1" "$?" "0";

object "$Session" remove "test";
checkSimple "remove 1" "$?" "0";

object "$Session" isset "test";
checkSimple "isset notset 1" "$?" "1";

object "$Session" isCompressed;
checkSimple "isCompressed" "$?" "0";

object "$Session" isset "bli";
checkSimple "isset isset 2" "$?" "0";

res=`object "$Session" getFilename`;
checkSimple "getFilename" "$?" "0";
checkRegex "getFilename data" "$res" "$TEST_TEMP_DIR/$$";
