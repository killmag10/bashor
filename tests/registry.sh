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

loadFunctions 'registry' "$TEST_TEMP_DIR/registry";
nl=`echo -e '\n\r'`;

registry_set "test" "blub 123blub";
checkSimple "set 1" "$?" "0";

registry_set "bli" "blub zzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blubzzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blubzzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blubzzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blub";
checkSimple "set 2" "$?" "0";

res=`registry_get "test"`;
checkSimple "get 1" "$res" "blub 123blub";

res=`registry_get "bli"`;
checkSimple "get 2" "$res" "blub zzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blubzzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blubzzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blubzzzzzzzzzzzzzzzzz123${nl}${nl}${nl}blub";

registry_isset "test";
checkSimple "isset isset 1" "$?" "0";

registry_remove "test";
checkSimple "remove 1" "$?" "0";

registry_isset "test";
checkSimple "isset notset 1" "$?" "1";
