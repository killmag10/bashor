#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3 version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

loadClass 'Bashor_String';

oldText="sfjadöasjfdösfFINDdsfsdfd
dsfdsfdsf
FINDdsfsdffds
dfdfgfdglpv._FIND
FIND";

newText="sfjadöasjfdösfREPLACEDdsfsdfd
dsfdsfdsf
REPLACEDdsfsdffds
dfdfgfdglpv._REPLACED
REPLACED";

tmp=`echo "$oldText" | class Bashor_String replace "FIND" "REPLACED"`;
checkSimple "replace return" "$?" "0";
checkSimple "replace text" "$tmp" "$newText";

tmp=`class Bashor_String repeat "abc" 3`;
checkSimple "repeat return" "$?" "0";
checkSimple "repeat text" "$tmp" "abcabcabc";

