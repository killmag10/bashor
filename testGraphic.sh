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

    chars='abcdefgh';
    for i in {0..7}; do
        class Terminal_Graphic printRectangleFilled -- $(( $i + 5 )) 5 1 16 "${chars:$i:1}" $i
    done;
    chars='jklmnopq';
    for i in {0..7}; do
        class Terminal_Graphic printRectangleFilled -X -- $(( $i + 5 )) 21 1 8 "${chars:$i:1}" $i
    done;

    for i in {0..7}; do
        class Terminal_Graphic printRectangleFilled -- 25 $(( $i + 5 )) 10 1 ' ' $i
    done;

    for i in {0..7}; do
        class Terminal_Graphic printText -- 15 $(( $i + 5 )) 'a text' $i
    done;
    for i in {0..7}; do
        class Terminal_Graphic printText -- 15 $(( $i + 13 )) 'a text' 7 $i
    done;
    for i in {0..7}; do
        class Terminal_Graphic printText -B -- 15 $(( $i + 21 )) 'a text' 0 $i
    done;
    
    for i in {0..7}; do
        class Terminal_Graphic setPixel -- 25 $(( $i + 21 )) '' $i
    done;
    for i in {0..7}; do
        class Terminal_Graphic setPixel -X -B -- 25 $(( $i + 13 )) 'a' $i 0
        for c in {0..7}; do
            class Terminal_Graphic setPixel -X -- $(( $c + 26 )) $(( $i + 13 )) 'a' $i $c
        done;
        class Terminal_Graphic setPixel -X -B -- 34 $(( $i + 13 )) 'a' $i 7
    done;
    
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
