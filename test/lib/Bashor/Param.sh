#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

nl=`echo -e '\n\r'`;

function test_getopts()
{   
    loadClassOnce Bashor_Param;
    local Param
    new Bashor_Param Param "abc:df:" "eins:,zwei:,drei";
    
    object "$Param" set "$@";
    res=`object "$Param" get`;
    checkSimple "Param get" "$res" " -d -c '123' --zwei 'test' -f '456 789' -b -- 'aaa bbb' 'ccc' '--' 'gg'";

    object "$Param" issetOpt "-b";
    checkSimple "Param issetOpt is set" "$?" "0";
    
    object "$Param" issetOpt "-a";    
    checkSimple "Param issetOpt not set" "$?" "1";
    
    object "$Param" notEmptyOpt "-f";    
    checkSimple "Param notEmptyOpt not Empty" "$?" "0";    
    
    object "$Param" issetOpt "--zwei";    
    checkSimple "Param issetOpt long set" "$?" "0";
    object "$Param" issetOpt "--aaa";    
    checkSimple "Param issetOpt long not set" "$?" "1";
    
    res=`object "$Param" getOpt "-c"`;
    checkSimple "Param getOpt 1" "$?" "0";
    checkSimple "Param getOpt data 1" "$res" "123";
    
    res=`object "$Param" getOpt "-f"`;
    checkSimple "Param getOpt 2" "$?" "0";
    checkSimple "Param getOpt data 2" "$res" "456 789";
    
	res=`object "$Param" getOpt "--zwei"`;
    checkSimple "Param getOpt long" "$?" "0";
    checkSimple "Param getOpt data long" "$res" "test";
    
    res=`object "$Param" getOptKeys`;
    checkSimple "Param getOptKeys" "$res" "-d
-c
--zwei
-f
-b";

    res=`object "$Param" listOpt`;
    checkSimple "Param listOpt" "$res" "-d
-c 123
--zwei test
-f 456 789
-b";

    res=`object "$Param" listArg`;
    checkSimple "Param listArg" "$res" "aaa bbb
ccc
--
gg";

    res=`object "$Param" getArg 2`;    
    checkSimple "Param getArg" "$?" "0";
    checkSimple "Param getArg data" "$res" "ccc";

    object "$Param" issetArg 4;    
    checkSimple "Param issetArg is set" "$?" "0";
    
    object "$Param" issetArg 5;    
    checkSimple "Param issetArg not set" "$?" "1";
    
    object "$Param" notEmptyArg "2";    
    checkSimple "Param notEmptyArg not Empty" "$?" "0";
    
    res=`object "$Param" get "-c"`;
    checkSimple "Param get -c" "$?" "0";
    checkSimple "Param get data -c" "$res" "123";
    
    res=`object "$Param" get "2"`;
    checkSimple "Param get 2" "$?" "0";
    checkSimple "Param get data 2" "$res" "ccc";
    
    res=`object "$Param" isset "-c"`;
    checkSimple "Param isset -c" "$?" "0";
    
    res=`object "$Param" isset "2"`;
    checkSimple "Param isset 2" "$?" "0";
    
    res=`object "$Param" isset "-k"`;
    checkSimple "Param isset not -c" "$?" "1";
    
    res=`object "$Param" isset "9"`;
    checkSimple "Param isset not 2" "$?" "1";
    
}

test_getopts "aaa bbb" "ccc" -d -c "123" --zwei test -f "456 789" -b -- -- gg
