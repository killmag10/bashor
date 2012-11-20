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

loadClass 'Bashor_Data';
local Data
new Bashor_Data Data -c;

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

object "$Data" remove "test";
checkSimple "remove 1" "$?" "0";

object "$Data" isset "test";
checkSimple "isset notset 1" "$?" "1";

object "$Data" isCompressed;
checkSimple "isCompressed" "$?" "0";

res=`object "$Data" size`;
case "$BASHOR_CODEING_METHOD" in
hex)
    checkSimple "size" "$res" "43186";
    ;;
*)
    checkSimple "size" "$res" "28794";
    ;;
esac
remove "$Data";
checkSimple "remove object" "$?" "0";
