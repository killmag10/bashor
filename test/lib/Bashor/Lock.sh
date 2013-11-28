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

loadClass 'Bashor_Lock';

res=`class Bashor_Lock filename 'abc'`;
checkSimple "filename" "$res" "abc.lock";

lockfile="$TEST_TEMP_DIR/$res";
{
    class Bashor_Lock lock 200;
    
    class Bashor_Lock checkRead "$lockfile";
    checkSimple "checkRead locked" "$?" "1";
    
    class Bashor_Lock checkWrite "$lockfile";
    checkSimple "checkWrite locked" "$?" "1";
    
} 200>"$lockfile";

class Bashor_Lock checkRead "$lockfile";
checkSimple "checkRead unlocked" "$?" "0";

class Bashor_Lock checkWrite "$lockfile";
checkSimple "checkWrite unlocked" "$?" "0";
