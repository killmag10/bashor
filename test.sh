#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Tests
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

BASE_DIR=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASE_DIR" =~ ^/ ]]; then
    BASE_DIR=`echo "$PWD/$BASE_DIR" | sed 's#/\.\?$##'`;
fi
export TEST_DIR="$BASE_DIR/tests";
export TEST_TEMP_DIR="$TEST_DIR/temp";
export TEST_RESOURCE_DIR="$TEST_DIR/resources";
export TESTS_FAIL='0';

. "$BASE_DIR/loader.sh";

export BASHOR_LOG_FILE="$TEST_TEMP_DIR/log.log";

function doTest()
{
    echo "##### Test: $1 #####";
    . ${TEST_DIR}/${1}.sh;

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
    local res="$2";
    if [ -n "$3" ]; then
        local res=`echo "$res" | tr '01' '10'`;
    fi
    if [ 0 == "$res" ]; then
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
    printResult "$1" "$?" "$4";
}

function checkRegex()
{
    echo "$2" | grep "$3" > /dev/null;
    printResult "$1" "$?" "$4";
}

function checkRegexLines()
{
    local res=`echo "$2" | grep "$3" | wc -l`;
    [ "$res" == "$4" ];
    printResult "$1" "$?";
}

doTest 'getopt';
doTest 'getopts';
doTest 'cache';
doTest 'color';
doTest 'lock';
doTest 'hash';
doTest 'registry';
doTest 'data';
doTest 'session';
doTest 'log';
doTest 'escape';
doTest 'temp';
doTest 'terminal';

printFinalResult;
