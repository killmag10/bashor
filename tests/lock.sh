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

loadClass 'Bashor_Lock';

res=`class Bashor_Lock filename 'abc'`;
checkSimple "filename" "$res" "abc.lock";

lockfile="$TEST_TEMP_DIR/$res";
{
    flock 200;
    
    class Bashor_Lock checkRead "$lockfile";
    checkSimple "checkRead locked" "$?" "1";
    
    class Bashor_Lock checkWrite "$lockfile";
    checkSimple "checkWrite locked" "$?" "1";
    
} 200>"$lockfile";

class Bashor_Lock checkRead "$lockfile";
checkSimple "checkRead unlocked" "$?" "0";

class Bashor_Lock checkWrite "$lockfile";
checkSimple "checkWrite unlocked" "$?" "0";
