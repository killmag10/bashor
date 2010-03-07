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

function doTest()
{
    echo "##### Test: $1 #####";
    . ${TEST_DIR}/${1}.sh
    if [ -d "$TEST_TEMP_DIR/" ]; then
        rm -rf "$TEST_TEMP_DIR/"*
    fi
}

function printFinalResult()
{
    if [ 0 == "$TESTS_FAIL" ]; then
        local res=`echo -en '\033[1;32mOK   \033[0m'`
    else
        local res=`echo -en '\033[1;31mTESTS FAIL ('"$TESTS_FAIL"')\033[0m'`;
        ((TESTS_FAIL++));
    fi
    printf '\nRESULT: %s\n' "$res";
}

function printResult()
{
    if [ 0 == "$2" ]; then
        local res=`echo -en '\033[1;32mOK   \033[0m'`
    else
        local res=`echo -en '\033[1;31mERROR\033[0m'`;
        ((TESTS_FAIL++));
    fi
    printf '%s : %s\n' "$res" "$1";
}

function checkSimple()
{
    [ "$2" == "$3" ];
    printResult "$1" "$?";
}

function checkRegex()
{
    local res=`echo "$2" | grep "$3"`;
    printResult "$1" "$?";
}

function checkRegexLines()
{
    local res=`echo "$2" | grep "$3" | wc -l`;
    [ "$res" == "$4" ];
    printResult "$1" "$?";
}

doTest 'cache';
doTest 'color';
doTest 'lock';
doTest 'hash';
doTest 'registry';
doTest 'log';
doTest 'escape';


printFinalResult;
