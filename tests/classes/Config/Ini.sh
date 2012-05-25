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
# @version      $Id: Escape.sh 171 2011-08-23 19:45:55Z lars $
################################################################################

loadClass 'Bashor_Config_Ini';
nl=$'\n';

new Bashor_Config_Ini Ini "$TEST_RESOURCE_DIR/test.ini"
checkSimple "new" "$?" "0";

show()
{
    object "$1" rewind
    while object "$1" valid; do
        local value="`object "$1" current`"
        echo "$2 [""`object "$1" key`""] = \"$value\""
        if isObject "$value"; then
            show "$value" "$2+++"
        fi
        object "$1" next
    done
}

show "$Ini" "+++"

#res=`class Bashor_Escape regEx "$testString"`;
#checkSimple "regEx" "$?" "0";
#checkSimple "regEx data" "$res" "`cat \"$TEST_RESOURCE_DIR/escape.esc.dat\"`";

