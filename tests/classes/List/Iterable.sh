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

loadClass 'Bashor_List_Iterable';
local Data
new Bashor_List_Iterable Data;

nl=`echo -e '\n\r'`;

object "$Data" set "test" "blub 123blub";
checkSimple "set 1" "$?" "0";

object "$Data" set "bli" "`dd if=\"$TEST_RESOURCE_DIR/random.dat\" bs=32K count=1 2>/dev/null`";
checkSimple "set 2" "$?" "0";

res=`object "$Data" get "test"`;
checkSimple "get 1" "$res" "blub 123blub";

res=`object "$Data" get "bli"`;
checkSimple "get 2" "$res" "`dd if=\"$TEST_RESOURCE_DIR/random.dat\" bs=32K count=1 2>/dev/null`";

object "$Data" isset "test";
checkSimple "isset isset 1" "$?" "0";

res=`object "$Data" key 0`;
checkSimple "key 0 return 2" "$?" "0";
checkSimple "key 0" "$res" "test";

res=`object "$Data" key 1`;
checkSimple "key 1 return 2" "$?" "0";
checkSimple "key 1" "$res" "bli";

res=`object "$Data" key 2`;
checkSimple "key 2 return 2" "$?" "1";
checkSimple "key 2" "$res" "";

res=`object "$Data" count`;
checkSimple "count 2" "$res" "2";

object "$Data" rewind;

res=`object "$Data" current`;
checkSimple "current return" "$?" "0";
checkSimple "current" "$res" "blub 123blub";

res=`object "$Data" key`;
checkSimple "current key 1 return" "$?" "0";
checkSimple "current key 1" "$res" "test";

object "$Data" valid;
checkSimple "valid return" "$?" "0";

object "$Data" next;

res=`object "$Data" current`;
checkSimple "current 2 return" "$?" "0";
checkSimple "current 2" "$res" "`dd if=\"$TEST_RESOURCE_DIR/random.dat\" bs=32K count=1 2>/dev/null`";

res=`object "$Data" key`;
checkSimple "current key 2 return" "$?" "0";
checkSimple "current key 2" "$res" "bli";

object "$Data" valid;
checkSimple "valid 2 return" "$?" "0";

object "$Data" next;

object "$Data" valid;
checkSimple "valid 3 return" "$?" "1";

object "$Data" rewind;

res=`object "$Data" current`;
checkSimple "current 3 return" "$?" "0";
checkSimple "current 3" "$res" "blub 123blub";

object "$Data" valid;
checkSimple "valid 4 return" "$?" "0";


object "$Data" unset "test";
checkSimple "remove 1" "$?" "0";

object "$Data" isset "test";
checkSimple "isset notset 1" "$?" "1";

res=`object "$Data" count`;
checkSimple "count 1" "$res" "1";

object "$Data" unset "bli";

res=`object "$Data" count`;
checkSimple "count 0" "$res" "0";

remove "$Data";
checkSimple "remove object" "$?" "0";
