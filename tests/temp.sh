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

loadFunctions 'temp' "$TEST_TEMP_DIR";
nl=`echo -e '\n\r'`;

dir1=`temp_dir "test"`;
dir2=`temp_dir "test"`;
checkSimple "temp_dir" "$dir1" "$dir2" "1";

mkdir "$dir1";
checkSimple "temp_dir mkdir" "$?" "0";

file1=`temp_file "test"`;
file2=`temp_file "test"`;
checkSimple "temp_file" "$file1" "$file2" "1";

echo "123" > "$file1";
checkSimple "temp_dir mkdir" "$?" "0";

res1=`temp_generateFilename "test"`;
res2=`temp_generateFilename "test"`;
checkSimple "temp_generateFilename" "$res1" "$res2" "1";

temp_clear;
checkSimple "temp_clear" "$?" "0";
[ -d "$dir1" ]
checkSimple "temp_clear dir" "$?" "1";
[ -f "$file1" ]
checkSimple "temp_clear file" "$?" "1";

