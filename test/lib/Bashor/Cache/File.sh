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

nl=`echo -e '\n\r'`;

loadClass 'Bashor_Cache_File';
local Cache
new 'Bashor_Cache_File' 'Cache' "$TEST_TEMP_DIR";

res=`object "$Cache" filename 'test'`;
checkSimple "filename" "$res" "$TEST_TEMP_DIR/CACHE_098f6bcd4621d373cade4e832627b4f6_3076352578_4";

object "$Cache" set 'test' '2' "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
checkSimple "set var" "$?" "0";

res=`object "$Cache" get 'test'`;
checkSimple "get cached" "$?" "0";
checkSimple "get cached data" "$res" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
sleep 2;
res=`object "$Cache" get 'test'`;
checkSimple "get no cached" "$?" "1";
checkSimple "get no cached data" "$res" "";

cat "$TEST_RESOURCE_DIR/random.dat" | object "$Cache" set 'test' '3';
checkSimple "set stream" "$?" "0";

res=`object "$Cache" get 'test'`;
checkSimple "get cached stream" "$?" "0";
checkSimple "get cached stream data" "$res" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
