#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Tests
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3 version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

loadClass 'Log';
nl=`echo -e '\n\r'`;

class Log remove;
class Log remove;
checkSimple "remove false" "$?" "1";

class Log log "zeile1";
checkSimple "log string" "$?" "0";
echo "zeile2" | class Log log;
checkSimple "log stream" "$?" "0";

testString="zeile1
zeile2";
res=`class Log get`;
checkSimple "get" "$?" "0";
checkSimple "get data" "`class Log get`" "$testString";

class Log remove;
checkSimple "remove true" "$?" "0";

class Log error "blab";
checkSimple "error string" "$?" "0";
echo "blub" | class Log error;
checkSimple "error stream" "$?" "0";

checkRegexLines "error data" "`cat \"$TEST_TEMP_DIR/log.log\"`" \
    "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ERROR:      1	bl.b" "2";

class Log debug "blab";
checkSimple "debug string" "$?" "0";
echo "blub" | class Log debug;
checkSimple "debug stream" "$?" "0";

checkRegexLines "debug data" "`cat \"$TEST_TEMP_DIR/log.log\"`" \
     "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ERROR:      1	bl.b" "2";

