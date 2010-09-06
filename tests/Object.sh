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
checkSimple "loadClass" "$?" "0";

new Bashor_Data Data;
checkSimple "new" "$?" "0";

object Data set "test" "global";
checkSimple "object 1 set" "$?" "0";

new local Bashor_Data Data;
checkSimple "new local" "$?" "0";

object local Data set "test" "local";
checkSimple "object local 1 set" "$?" "0";

res=`object Data get "test"`;
checkSimple "object 1 get" "$res" "global";

res=`object local Data get "test"`;
checkSimple "object local 1 get" "$res" "local";

clone local Data local DataClone;
checkSimple "clone local" "$?" "0";

remove Data;
checkSimple "remove object 1" "$?" "0";

res=`object local Data get "test"`;
checkSimple "object local 1 get" "$res" "local";

remove local Data;
checkSimple "remove local object 1" "$?" "0";

res=`object local DataClone get "test"`;
checkSimple "object local clone 1 get" "$res" "local";

remove local DataClone;
checkSimple "remove local clone object 1" "$?" "0";
