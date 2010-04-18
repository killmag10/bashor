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

loadClass 'Escape';
nl=`echo -e '\n\r'`;

testString=`cat "$TEST_RESOURCE_DIR/escape.raw.dat"`

#class Escape regEx "$testString" > "$TEST_RESOURCE_DIR/escape.esc.dat";

res=`class Escape regEx "$testString"`;
checkSimple "regEx" "$?" "0";
checkSimple "regEx data" "$res" "`cat \"$TEST_RESOURCE_DIR/escape.esc.dat\"`";

res=`class Escape regEx "123#/#/#456" -d '#'`;
checkSimple "regEx -d" "$?" "0";
checkSimple "regEx data -d" "$res" '123\#/\#/\#456';

#class Escape regExReplacement "$testString" > "$TEST_RESOURCE_DIR/escape.rpl.dat";

res=`class Escape regExReplacement "$testString"`;
checkSimple "regExReplacement" "$?" "0";
checkSimple "regExReplacement data" "$res" "`cat \"$TEST_RESOURCE_DIR/escape.rpl.dat\"`";

res=`class Escape regExReplacement "123#/#/#456" -d '#'`;
checkSimple "regExReplacement -d" "$?" "0";
checkSimple "regExReplacement -d data" "$res" '123\#/\#/\#456';
