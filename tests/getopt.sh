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

. "$BASHOR_PATH_INCLUDES/functions/getopt.sh";

nl=`echo -e '\n\r'`;

function test_getopts()
{   
    optSetOpts "abc:df:" "eins:,zwei:,drei";
    optSetArgs "$@";
    res=`optGetArgs`;
    checkSimple "optGetArgs" "$res" " -d -c '123' --zwei 'test' -f '456 789' -b -- 'aaa bbb' 'ccc' '--' 'gg'";

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

    res=`argList`;
    checkSimple "argList" "$res" "aaa bbb
ccc
--
gg";

    res=`argValue 2`;    
    checkSimple "argValue" "$?" "0";
    checkSimple "argValue data" "$res" "ccc";

    argIsset 4;    
    checkSimple "argIsset is set" "$?" "0";
    
    argIsset 5;    
    checkSimple "argIsset not set" "$?" "1";
}

test_getopts "aaa bbb" "ccc" -d -c "123" --zwei test -f "456 789" -b -- -- gg
