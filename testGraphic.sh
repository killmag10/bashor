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
# @version      $Id: test.sh 23 2010-03-14 19:36:03Z lars $
################################################################################

BASE_DIR=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASE_DIR" =~ ^/ ]]; then
    BASE_DIR=`echo "$PWD/$BASE_DIR" | sed 's#/\.\?$##'`;
fi
TEST_DIR="$BASE_DIR/tests";
TEST_TEMP_DIR="$TEST_DIR/temp";
TEST_RESOURCE_DIR="$TEST_DIR/resources";
TESTS_FAIL='0';

. "$BASE_DIR/loader.sh"

loadClass 'Terminal';
loadClass 'Terminal_Graphic';

function toPrint() {
    class Terminal_Graphic printRectangleFilled -- 1 3 38 28 ' ' 7
    class Terminal_Graphic printRectangleFilled -- 2 4 36 26 ' ' 0
    class Terminal_Graphic printRectangleFilled -- 1 13 38 8 ' ' 7

    lines=24;
    class Terminal_Graphic printRectangleFilled -- 5 5 1 $lines 'a' 0
    class Terminal_Graphic printRectangleFilled -- 6 5 1 $lines 'b' 1
    class Terminal_Graphic printRectangleFilled -- 7 5 1 $lines 'c' 2
    class Terminal_Graphic printRectangleFilled -- 8 5 1 $lines 'd' 3
    class Terminal_Graphic printRectangleFilled -- 9 5 1 $lines 'e' 4
    class Terminal_Graphic printRectangleFilled -- 10 5 1 $lines 'f' 5
    class Terminal_Graphic printRectangleFilled -- 11 5 1 $lines 'g' 6
    class Terminal_Graphic printRectangleFilled -- 12 5 1 $lines 'h' 7

    lines=1;
    class Terminal_Graphic printRectangleFilled -- 25 5 10 $lines ' ' 0
    class Terminal_Graphic printRectangleFilled -- 25 6 10 $lines ' ' 1
    class Terminal_Graphic printRectangleFilled -- 25 7 10 $lines ' ' 2
    class Terminal_Graphic printRectangleFilled -- 25 8 10 $lines ' ' 3
    class Terminal_Graphic printRectangleFilled -- 25 9 10 $lines ' ' 4
    class Terminal_Graphic printRectangleFilled -- 25 10 10 $lines ' ' 5
    class Terminal_Graphic printRectangleFilled -- 25 11 10 $lines ' ' 6
    class Terminal_Graphic printRectangleFilled -- 25 12 10 $lines ' ' 7

    class Terminal_Graphic printText -- 15 5 'a text' 0
    class Terminal_Graphic printText -- 15 6 'a text' 1
    class Terminal_Graphic printText -- 15 7 'a text' 2
    class Terminal_Graphic printText -- 15 8 'a text' 3
    class Terminal_Graphic printText -- 15 9 'a text' 4
    class Terminal_Graphic printText -- 15 10 'a text' 5
    class Terminal_Graphic printText -- 15 11 'a text' 7
    class Terminal_Graphic printText -- 15 12 'a text' 6

    class Terminal_Graphic printText -- 15 13 'a text' 7 0
    class Terminal_Graphic printText -- 15 14 'a text' 0 1
    class Terminal_Graphic printText -- 15 15 'a text' 0 2
    class Terminal_Graphic printText -- 15 16 'a text' 0 3
    class Terminal_Graphic printText -- 15 17 'a text' 0 4
    class Terminal_Graphic printText -- 15 18 'a text' 0 5
    class Terminal_Graphic printText -- 15 19 'a text' 0 6
    class Terminal_Graphic printText -- 15 20 'a text' 0 7

    class Terminal_Graphic printText -B -- 15 21 'a text' 7 0
    class Terminal_Graphic printText -B -- 15 22 'a text' 0 1
    class Terminal_Graphic printText -B -- 15 23 'a text' 0 2
    class Terminal_Graphic printText -B -- 15 24 'a text' 0 3
    class Terminal_Graphic printText -B -- 15 25 'a text' 0 4
    class Terminal_Graphic printText -B -- 15 26 'a text' 0 5
    class Terminal_Graphic printText -B -- 15 27 'a text' 0 6
    class Terminal_Graphic printText -B -- 15 28 'a text' 0 7

    class Terminal_Graphic setPixel -- 25 13 '' 0
    class Terminal_Graphic setPixel -- 25 14 '' 1
    class Terminal_Graphic setPixel -- 25 15 '' 2
    class Terminal_Graphic setPixel -- 25 16 '' 3
    class Terminal_Graphic setPixel -- 25 17 '' 4
    class Terminal_Graphic setPixel -- 25 18 '' 5
    class Terminal_Graphic setPixel -- 25 19 '' 6
    class Terminal_Graphic setPixel -- 25 20 '' 7
    
    class Terminal_Graphic setPixel -- 25 21 '' 0
    class Terminal_Graphic setPixel -- 25 22 '' 1
    class Terminal_Graphic setPixel -- 25 23 '' 2
    class Terminal_Graphic setPixel -- 25 24 '' 3
    class Terminal_Graphic setPixel -- 25 25 '' 4
    class Terminal_Graphic setPixel -- 25 26 '' 5
    class Terminal_Graphic setPixel -- 25 27 '' 6
    class Terminal_Graphic setPixel -- 25 28 '' 7
    
    class Terminal_Graphic setPixel -- 30 28 '' 6
    class Terminal_Graphic setPixel -- 31 28 '' 6
    class Terminal_Graphic setPixel -- 32 28 '' 6
    class Terminal_Graphic setPixel -- 33 28 '' 6
    
    class Terminal_Graphic setPixel -- 29 27 '' 6
    class Terminal_Graphic setPixel -B -- 30 27 '\\' 6
    class Terminal_Graphic setPixel -B -- 31 27 '_' 6
    class Terminal_Graphic setPixel -B -- 32 27 '_' 6
    class Terminal_Graphic setPixel -B -- 33 27 '/' 6
    class Terminal_Graphic setPixel -- 34 27 '' 6
    
    class Terminal_Graphic setPixel -- 29 26 '' 6
    class Terminal_Graphic setPixel -- 30 26 '' 6
    class Terminal_Graphic setPixel -- 33 26 '' 6
    class Terminal_Graphic setPixel -- 34 26 '' 6

    class Terminal_Graphic setPixel -B -- 30 25 '"' 6 0
    class Terminal_Graphic setPixel -B -- 31 25 '"' 6 0
    class Terminal_Graphic setPixel -B -- 32 25 '"' 6 0
    class Terminal_Graphic setPixel -B -- 33 25 '"' 6 0

    class Terminal_Graphic setPixel -B -- 31 26 'o' 6 3
    class Terminal_Graphic setPixel -B -- 32 26 'o' 6 3    
    class Terminal_Graphic setPixel -B -- 28 26 'q' 0 6
    class Terminal_Graphic setPixel -B -- 35 26 'p' 0 6
    
    class Terminal_Graphic setPixel -B -- 29 23 'H' '' 1
    class Terminal_Graphic setPixel -B -- 30 23 'e' '' 2
    class Terminal_Graphic setPixel -B -- 31 23 'l' '' 3
    class Terminal_Graphic setPixel -B -- 32 23 'l' '' 4
    class Terminal_Graphic setPixel -B -- 33 23 'o' '' 5
    class Terminal_Graphic setPixel -B -- 34 23 '!' '' 6
}

clear;
echo $SECONDS;
toPrint
#temp="`toPrint`";
echo $SECONDS;

#echo "$temp";
