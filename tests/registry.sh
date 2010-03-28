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

loadClass 'Registry';
new 'Registry' 'Registry' "$TEST_TEMP_DIR/registry" -c
nl=`echo -e '\n\r'`;

object Registry set "test" "blub 123blub";
checkSimple "set 1" "$?" "0";

object Registry set "bli" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";
checkSimple "set 2" "$?" "0";

res=`object Registry get "test"`;
checkSimple "get 1" "$res" "blub 123blub";

res=`object Registry get "bli"`;
checkSimple "get 2" "$res" "`cat \"$TEST_RESOURCE_DIR/random.dat\"`";

object Registry isset "test";
checkSimple "isset isset 1" "$?" "0";

object Registry remove "test";
checkSimple "remove 1" "$?" "0";

object Registry isset "test";
checkSimple "isset notset 1" "$?" "1";

object Registry isCompressed;
checkSimple "isCompressed" "$?" "0";

object Registry isset "bli";
checkSimple "isset isset 2" "$?" "0";

res=`object Registry getFilename`;
checkSimple "getFilename" "$?" "0";
checkRegex "getFilename data" "$res" '/registry$';
