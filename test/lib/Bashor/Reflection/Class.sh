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
# @version      $Id: Temp.sh 171 2011-08-23 19:45:55Z lars $
################################################################################

loadClass 'Bashor_Reflection_Class';
loadClass 'Include_Class';

local Reflection
new Bashor_Reflection_Class Reflection 'Include_Class';
checkSimple "new Bashor_Reflection_Class" "$?" "0";

temp="`object "$Reflection" getName`"
checkSimple "class getName return" "$?" "0";
checkSimple "class getName output" "$temp" "Include_Class";

object "$Reflection" getParentClass tempParent
object "$tempParent" isA 'Bashor_Reflection_Class'
checkSimple "class getParentClass isA Bashor_Reflection_Class" "$?" "0";

temp="`object "$tempParent" getName`"
checkSimple "class parent getName return" "$?" "0";
checkSimple "class parent getName output" "$temp" "Class";

temp="`object "$Reflection" hasMethod 'get'`"
checkSimple "class hasMethod return 0" "$?" "0";

temp="`object "$Reflection" hasMethod 'noMethod'`"
checkSimple "class hasMethod return 1" "$?" "1";

temp="`object "$Reflection" hasProperty 'staticData'`"
checkSimple "class hasProperty return 0" "$?" "0";

temp="`object "$Reflection" hasProperty 'objectData'`"
checkSimple "class hasProperty return 1" "$?" "1";
