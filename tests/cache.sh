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

nl=`echo -e '\n\r'`;

loadClass 'Cache';
new 'Cache' 'Cache' "$TEST_TEMP_DIR";

res=`object Cache filename 'test'`;
checkSimple "filename" "$res" "$TEST_TEMP_DIR/CACHE_d8e8fca2dc0f896fd7cb4cb0031ba249_935282863_5";

object Cache set 'test' '2' "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
checkSimple "set var" "$?" "0";

res=`object Cache get 'test'`;
checkSimple "get cached" "$?" "0";
checkSimple "get cached data" "$res" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
sleep 2;
res=`object Cache get 'test'`;
checkSimple "get no cached" "$?" "1";
checkSimple "get no cached data" "$res" "";

cat "$TEST_RESOURCE_DIR/random.dat" | object Cache set 'test' '3';
checkSimple "set stream" "$?" "0";

res=`object Cache get 'test'`;
checkSimple "get cached stream" "$?" "0";
checkSimple "get cached stream data" "$res" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
