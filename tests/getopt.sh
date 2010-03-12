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

. "$BASHOR_DIR_INCLUDES/functions/getopt.sh";

nl=`echo -e '\n\r'`;

function test_getopts()
{   
    optSetOpts "abc:df:" "eins:,zwei:,drei";
    optSetArgs "$@";
    res=`optGetArgs`;
    checkSimple "optGetArgs" "$res" " -d -c '123' --zwei 'test' -f '456 789' -b -- 'aaa bbb' 'ccc'";

    optIsset "b";
    checkSimple "optIsset is set" "$?" "0";
    
    optIsset "a";    
    checkSimple "optIsset not set" "$?" "1";
    
    res=`optValue "c"`;
    checkSimple "optValue 1" "$?" "0";
    checkSimple "optValue data 1" "$res" "123";
    
    res=`optValue "f"`;
    checkSimple "optValue 2" "$?" "0";
    checkSimple "optValue data 2" "$res" "456 789";
    
	res=`optValue "zwei"`;
    checkSimple "optValue long" "$?" "0";
    checkSimple "optValue data long" "$res" "test";
    
    res=`optKeys`;
    checkSimple "optKeys" "$res" "d
c
zwei
f
b";

    res=`optList`;
    checkSimple "optList" "$res" "d=
c=123
zwei=test
f=456 789
b=";
}

test_getopts "aaa bbb" "ccc" -d -c "123" --zwei test -f "456 789" -b
