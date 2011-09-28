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
# @version      $Id: testGraphic.sh 171 2011-08-23 19:45:55Z lars $
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

function toPrint()
{
    echo
    echo "System Colors:"
    for i in {0..7}; do
        class Bashor_Terminal setExtendedBackgroundColorSystem "$i"
        printf ' '        
        class Bashor_Terminal resetStyle
    done;
    echo -n ' '
    for i in {0..7}; do
        class Bashor_Terminal setExtendedFordergroundColorSystem "$i"
        printf '#'        
        class Bashor_Terminal resetStyle
    done;    
    
    echo
    for i in {8..15}; do
        class Bashor_Terminal setExtendedBackgroundColorSystem "$i"
        printf ' '        
        class Bashor_Terminal resetStyle
    done;
    echo -n ' '
    for i in {8..15}; do
        class Bashor_Terminal setExtendedFordergroundColorSystem "$i"
        printf '#'        
        class Bashor_Terminal resetStyle
    done;
    echo
    echo
    echo "Colors:"
    for g in {0..5}; do
        for r in {0..5}; do
            for b in {0..5}; do
                class Bashor_Terminal setExtendedBackgroundColor "$r" "$g" "$b"
                printf ' '        
                class Bashor_Terminal resetStyle
            done;
            echo -n ' '
        done;
        echo
    done;
    for g in {0..5}; do
        for r in {0..5}; do
            for b in {0..5}; do
                class Bashor_Terminal setStyleBold 1
                class Bashor_Terminal setExtendedFordergroundColor "$r" "$g" "$b"
                printf '#'        
                class Bashor_Terminal resetStyle
            done;
            echo -n ' '
        done;
        echo
    done;
    for g in {0..5}; do
        for r in {0..5}; do
            for b in {0..5}; do
                class Bashor_Terminal setExtendedFordergroundColor "$r" "$g" "$b"
                printf '#'        
                class Bashor_Terminal resetStyle
            done;
            echo -n ' '
        done;
        echo
    done;    
    
    echo
    echo "Grayscale:"
    for i in {0..23}; do
        class Bashor_Terminal setExtendedBackgroundColorGrayscale "$i"
        printf ' '        
        class Bashor_Terminal resetStyle
    done;
    echo
    for i in {0..23}; do
        class Bashor_Terminal setStyleBold 1
        class Bashor_Terminal setExtendedFordergroundColorGrayscale "$i"
        printf '#'        
        class Bashor_Terminal resetStyle
    done; 
    echo
    for i in {0..23}; do
        class Bashor_Terminal setExtendedFordergroundColorGrayscale "$i"
        printf '#'        
        class Bashor_Terminal resetStyle
    done;
    
    echo
}

clear;
echo $SECONDS;
toPrint
#temp="`toPrint`";
echo $SECONDS;

#echo "$temp";
