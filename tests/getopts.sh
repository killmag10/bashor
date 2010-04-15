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

. "$BASHOR_DIR_INCLUDES/functions/getopts.sh";

nl=`echo -e '\n\r'`;

function test_getopts()
{   
    optSetOpts "abc:df:";
    optSetArgs "$@";

    optIsset "b";    
    checkSimple "optIsset is set" "$?" "0";
    
    optIsset "a";    
    checkSimple "optIsset not set" "$?" "1";
    
    res=`optValue "c"`;    
    checkSimple "optValue" "$?" "0";
    checkSimple "optValue data" "$res" "123";
    
    res=`optKeys`;
    checkSimple "optKeys" "$res" "d
c
f
b";

    res=`optList`;
    checkSimple "optList" "$res" "d=
c=123
f=456
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

test_getopts "aaa bbb" "ccc" -d -c "123" -f "456" -b -- -- gg
