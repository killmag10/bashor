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

BASE_DIR=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASE_DIR" =~ ^/ ]]; then
    BASE_DIR=`echo "$PWD/$BASE_DIR" | sed 's#/\.\?$##'`;
fi
TEST_DIR="$BASE_DIR/tests";
TEST_TEMP_DIR="$TEST_DIR/temp";
TEST_RESOURCE_DIR="$TEST_DIR/resources";
TESTS_FAIL='0';

. "$BASE_DIR/loader.sh"

loadClass 'Bashor_Terminal';
loadClass 'Bashor_Terminal_Graphic';

function toPrint() {
    class Bashor_Terminal_Graphic printRectangleFilled "1" "3" "72" "28" ' ' "7"
    class Bashor_Terminal_Graphic printRectangleFilled "2" "4" "70" "26" ' ' "0"
    class Bashor_Terminal_Graphic printRectangleFilled "1" "13" "72" "8" ' ' "7"
    
    chars='abcdefgh';
    for i in {0..7}; do
        class Bashor_Terminal_Graphic printRectangleFilled $(( $i + 4 )) 5 1 16 "${chars:$i:1}" $i
    done;
    chars='jklmnopq';
    for i in {0..7}; do
        class Bashor_Terminal_Graphic printRectangleFilled $(( $i + 4 )) 21 1 8 "${chars:$i:1}" $i '' 'X'
    done;

    for i in {0..7}; do
        class Bashor_Terminal_Graphic printRectangleFilled 20 $(( $i + 5 )) 4 1 'a' $i 0 'X'
        class Bashor_Terminal_Graphic printRectangleFilled 24 $(( $i + 5 )) 9 1 ' ' $i
        class Bashor_Terminal_Graphic printRectangleFilled 33 $(( $i + 5 )) 4 1 'a' $i 7 'X'
    done;
    
    for i in {0..7}; do
        class Bashor_Terminal_Graphic printText 13 $(( $i + 5 )) 'a text' $i
    done;
    for i in {0..7}; do
        class Bashor_Terminal_Graphic printText 13 $(( $i + 13 )) 'a text' 7 $i
    done;
    for i in {0..7}; do
        class Bashor_Terminal_Graphic printText 13 $(( $i + 21 )) 'a text' 0 $i 'B'
    done;
    
    for i in {0..7}; do
        class Bashor_Terminal_Graphic setPixel 20 $(( $i + 13 )) '' $i
    done;
    for i in {0..7}; do
        for c in {0..7}; do
            class Bashor_Terminal_Graphic setPixel $(( $c * 2 + 21 )) $(( $i + 13 )) 'a' $i $c 'X'
            class Bashor_Terminal_Graphic setPixel $(( $c * 2 + 22 )) $(( $i + 13 )) 'a' $i $c 'XB'
        done;
    done;
    
    function colorStrip () {
        for c in {0..7}; do
            class Bashor_Terminal_Graphic printText $(( $1 + 0 )) $(( $c + $2 )) '█▓▒░ ' $c "$3"
            class Bashor_Terminal_Graphic printText $(( $1 + 5 )) $(( $c + $2 )) ' ░▒▓█' $c "$3" 'B'         
        done;
    }
    
    colorStrip 40 5 0;
    colorStrip 50 5 1;
    colorStrip 60 5 2;
    colorStrip 40 13 3;
    colorStrip 50 13 4;
    colorStrip 60 13 5;
    colorStrip 40 21 6;
    colorStrip 50 21 7;
    colorStrip 60 21 '';
    
    class Bashor_Terminal_Graphic setPixel 30 28 '' 6 '' 'U'
    class Bashor_Terminal_Graphic setPixel 31 28 '' 6 '' 'U'
    class Bashor_Terminal_Graphic setPixel 32 28 '' 6 '' 'U'
    class Bashor_Terminal_Graphic setPixel 33 28 '' 6 '' 'U'
    
    class Bashor_Terminal_Graphic setPixel 29 27 '' 6
    class Bashor_Terminal_Graphic setPixel 30 27 '\\' 6 '' 'B'
    class Bashor_Terminal_Graphic setPixel 31 27 '_' 6 '' 'B'
    class Bashor_Terminal_Graphic setPixel 32 27 '_' 6 '' 'B'
    class Bashor_Terminal_Graphic setPixel 33 27 '/' 6 '' 'B'
    class Bashor_Terminal_Graphic setPixel 34 27 '' 6
    
    class Bashor_Terminal_Graphic setPixel 29 26 '' 6
    class Bashor_Terminal_Graphic setPixel 30 26 '' 6
    class Bashor_Terminal_Graphic setPixel 33 26 '' 6
    class Bashor_Terminal_Graphic setPixel 34 26 '' 6

    class Bashor_Terminal_Graphic setPixel 30 25 '"' 6 0 'B'
    class Bashor_Terminal_Graphic setPixel 31 25 '"' 6 0 'B'
    class Bashor_Terminal_Graphic setPixel 32 25 '"' 6 0 'B'
    class Bashor_Terminal_Graphic setPixel 33 25 '"' 6 0 'B'

    class Bashor_Terminal_Graphic setPixel 31 26 'o' 6 3 'B'
    class Bashor_Terminal_Graphic setPixel 32 26 'o' 6 3 'B'
    class Bashor_Terminal_Graphic setPixel 28 26 'q' 0 6 'B'
    class Bashor_Terminal_Graphic setPixel 35 26 'p' 0 6 'B'
    
    class Bashor_Terminal_Graphic setPixel 29 23 'H' '' 1 'B'
    class Bashor_Terminal_Graphic setPixel 30 23 'e' '' 2 'B'
    class Bashor_Terminal_Graphic setPixel 31 23 'l' '' 3 'B'
    class Bashor_Terminal_Graphic setPixel 32 23 'l' '' 4 'B'
    class Bashor_Terminal_Graphic setPixel 33 23 'o' '' 5 'B'
    class Bashor_Terminal_Graphic setPixel 34 23 '!' '' 6 'B'
    
    class Bashor_Terminal_Graphic printText 20 22 'EEEEEE' 0 7
    class Bashor_Terminal_Graphic printText 20 23 'E' 0 7
    class Bashor_Terminal_Graphic printText 20 24 'E' 0 7
    class Bashor_Terminal_Graphic printText 20 25 'EEEEEE' 0 7
    class Bashor_Terminal_Graphic printText 20 26 'E' 0 7
    class Bashor_Terminal_Graphic printText 20 27 'E' 0 7
    class Bashor_Terminal_Graphic printText 20 28 'EEEEEE' 0 7
    
    class Bashor_Terminal_Graphic printText 21 23 'aaaaa' 0 7 'X'
    class Bashor_Terminal_Graphic printText 21 24 'aaaaa' 0 7 'X'
    class Bashor_Terminal_Graphic printText 21 26 'aaaaa' 0 7 'X'
    class Bashor_Terminal_Graphic printText 21 27 'aaaaa' 0 7 'X'
}

clear;
echo $SECONDS;
toPrint
#temp="`toPrint`";
echo $SECONDS;

#echo "$temp";
