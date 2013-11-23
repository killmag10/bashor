#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3 version 3.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Tests
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3 version 3 version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
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

