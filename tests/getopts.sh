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
    OPTS="abc:d";
    ARGS="$@";

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
b";

    res=`optList`;
    checkSimple "optList" "$res" "d=
c=123
b=";
}

test_getopts "aaa bbb" "ccc" -d -c "123" -b
