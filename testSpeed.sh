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
# @version      $Id: test.sh 143 2011-04-07 23:57:20Z lars $
################################################################################

BASE_DIR=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASE_DIR" =~ ^/ ]]; then
    BASE_DIR=`echo "$PWD/$BASE_DIR" | sed 's#/\.\?$##'`;
fi
export TEST_DIR="$BASE_DIR/tests";
export TEST_TEMP_DIR="$TEST_DIR/temp";
export TEST_RESOURCE_DIR="$TEST_DIR/resources";

. "$BASE_DIR/loader.sh";

export BASHOR_LOG_FILE="$TEST_TEMP_DIR/log.log";
export BASHOR_PATHS_CLASS="${BASHOR_PATHS_CLASS}${NL}${TEST_DIR}/lib";

loadClassOnce 'Null';
echo -n 'CLASS: ';
SECONDS=0;
for i in `seq 10000`; do
    class Null null
done
echo $SECONDS;

echo -n 'OBJ CALL: ';
new Null Null
SECONDS=0;
for i in `seq 10000`; do
    object $Null null
done
echo $SECONDS;
remove $Null

echo -n 'OBJ NEW/REMOVE: ';
SECONDS=0;
for i in `seq 1000`; do
    new Null Null
    remove $Null
done
echo $SECONDS;

