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

loadClass 'Bashor_Temp';
local Temp
new Bashor_Temp Temp "$TEST_TEMP_DIR";
nl=`echo -e '\n\r'`;

dir1=`object "$Temp" dir "test"`;
dir2=`object "$Temp" dir "test"`;
checkSimple "object Temp dir" "$dir1" "$dir2" "1";

mkdir "$dir1";
checkSimple "object Temp dir mkdir" "$?" "0";

file1=`object "$Temp" file "test"`;
file2=`object "$Temp" file "test"`;
checkSimple "object Temp file" "$file1" "$file2" "1";

echo "123" > "$file1";
checkSimple "object Temp dir mkdir" "$?" "0";

res1=`object "$Temp" generateFilename "test"`;
res2=`object "$Temp" generateFilename "test"`;
checkSimple "object Temp generateFilename" "$res1" "$res2" "1";

object "$Temp" clear;
checkSimple "object Temp clear" "$?" "0";
[ -d "$dir1" ]
checkSimple "object Temp clear dir" "$?" "1";
[ -f "$file1" ]
checkSimple "object Temp clear file" "$?" "1";

