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

loadFunctions 'cache' "$TEST_TEMP_DIR";

res=`cache_filename 'test'`;
checkSimple "filename" "$res" "$TEST_TEMP_DIR/CACHE_d8e8fca2dc0f896fd7cb4cb0031ba249_935282863_5";

cache_set 'test' '1234567890' '2';
checkSimple "set" "$?" "0";

res=`cache_get 'test'`;
checkSimple "get cached" "$?" "0";
checkSimple "get cached data" "$res" "1234567890";
sleep 2;
res=`cache_get 'test'`;
checkSimple "get no cached" "$?" "1";
checkSimple "get no cached data" "$res" "";

