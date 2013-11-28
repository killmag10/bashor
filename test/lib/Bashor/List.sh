#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

loadClass 'Bashor_List';
local Data
new Bashor_List Data;

nl=`echo -e '\n\r'`;

object "$Data" set "test" "blub 123blub";
checkSimple "set 1" "$?" "0";

object "$Data" set "bli" "`dd if=\"$TEST_RESOURCE_DIR/random.dat\" bs=32K count=1 2>/dev/null`";
checkSimple "set 2" "$?" "0";

SData="`serialize $Data`";
checkSimple "serialize" "$?" "0";

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


unserialize Data "$SData";
checkSimple "unserialize" "$?" "0";

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

object "$Data" add 'a add';
checkSimple "add" "$?" "0";

res=`object "$Data" count`;
checkSimple "count 3" "$res" "3";

res=`object "$Data" key 2`;
checkSimple "key 2 return" "$?" "0";
checkSimple "key 2" "$res" '2';

res=`object "$Data" get 2`;
checkSimple "get 2 return" "$?" "0";
checkSimple "get 2" "$res" 'a add';

remove "$Data";
checkSimple "remove object" "$?" "0";
