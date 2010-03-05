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

. "$BASE_DIR/loader.sh"

function doTest()
{
    echo "##### Test: $1 #####";
    . ${TEST_DIR}/${1}.sh
    if [ -d "$TEST_TEMP_DIR/" ]; then
        rm -rf "$TEST_TEMP_DIR/"*
    fi
}

function checkSimple()
{
    if [ "$2" == "$3" ]; then
        local res=`echo -en '\033[1;32mOK   \033[0m'`
    else
        local res=`echo -en '\033[1;31mERROR\033[0m'`;
    fi
    printf '%s : %s\n' "$res" "$1";
}

doTest 'cache';
doTest 'color';
doTest 'lock';
doTest 'hash';
doTest 'registry';
