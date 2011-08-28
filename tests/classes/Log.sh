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

loadClass 'Bashor_Log';
nl=`echo -e '\n\r'`;

class Bashor_Log getDefault log
object "$log" remove;
object "$log" remove;
checkSimple "remove false" "$?" "1";

object "$log" log "zeile1";
checkSimple "log string" "$?" "0";
echo "zeile2" | object "$log" log;
checkSimple "log stream" "$?" "0";

testString="zeile1
zeile2";
res=`object "$log" get`;
checkSimple "get" "$?" "0";
checkSimple "get data" "`object \"$log\" get`" "$testString";

object "$log" remove;
checkSimple "remove true" "$?" "0";

object "$log" error "blab";
checkSimple "error string" "$?" "0";
echo "blub" | object "$log" error;
checkSimple "error stream" "$?" "0";

checkRegexLines "error data" "`cat \"$TEST_TEMP_DIR/log.log\"`" \
    "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ERROR:      1	bl.b" "2";

object "$log" debug "blab";
checkSimple "debug string" "$?" "0";
echo "blub" | object "$log" debug;
checkSimple "debug stream" "$?" "0";

checkRegexLines "debug data" "`cat \"$TEST_TEMP_DIR/log.log\"`" \
     "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ERROR:      1	bl.b" "2";

