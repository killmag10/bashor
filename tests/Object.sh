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

local Data
new Bashor_Data Data;
checkSimple "new" "$?" "0";

object "$Data" set "test" "global";
checkSimple "object 1 set" "$?" "0";

local Data2
new Bashor_Data Data2;
checkSimple "new 2" "$?" "0";

object "$Data2" set "test" "local";
checkSimple "object 3 set" "$?" "0";

res=`object "$Data" get "test"`;
checkSimple "object 1 get" "$res" "global";

res=`object "$Data2" get "test"`;
checkSimple "object local 1 get" "$res" "local";

local DataClone
clone "$Data2" "DataClone";
checkSimple "clone local" "$?" "0";

remove "$Data";
checkSimple "remove object 1" "$?" "0";

res=`object "$Data2" get "test"`;
checkSimple "object local 1 get" "$res" "local";

remove "$Data2";
checkSimple "remove local object 1" "$?" "0";

res=`object "$DataClone" get "test"`;
checkSimple "object local clone 1 get" "$res" "local";

remove "$DataClone";
checkSimple "remove local clone object 1" "$?" "0";


loadClassOnce 'Include';
checkSimple "loadClassOnce Include" "$?" "0";

local Include
new Include Include 'abc123' 'def456';
checkSimple "new Include" "$?" "0";

res=`object "$Include" get`;
checkSimple "object local Include get" "$res" "abc123";

res=`object "$Include" getInclude`;
checkSimple "object local Include getInclude" "$res" "def456";
