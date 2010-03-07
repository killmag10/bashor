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

loadFunctions 'log' "$TEST_TEMP_DIR/log.log";
nl=`echo -e '\n\r'`;

log_remove;
log_remove;
checkSimple "remove false" "$?" "1";

log "zeile1";
checkSimple "log string" "$?" "0";
echo "zeile2" | log;
checkSimple "log stream" "$?" "0";

testString="zeile1
zeile2";
res=`log_get`;
checkSimple "get" "$?" "0";
checkSimple "get data" "`log_get`" "$testString";

log_remove;
checkSimple "remove true" "$?" "0";

log_error "blab";
checkSimple "error string" "$?" "0";
echo "blub" | log_error;
checkSimple "error stream" "$?" "0";

checkRegexLines "error data" "`cat \"$TEST_TEMP_DIR/log.log\"`" \
    "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ERROR:      1	bl.b" "2";

log_debug "blab";
checkSimple "debug string" "$?" "0";
echo "blub" | log_debug;
checkSimple "debug stream" "$?" "0";

checkRegexLines "debug data" "`cat \"$TEST_TEMP_DIR/log.log\"`" \
     "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} ERROR:      1	bl.b" "2";

