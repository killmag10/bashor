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

loadClass 'Bashor_Reflection_Method';
loadClass 'Include_Class';

local Reflection
new Bashor_Reflection_Method Reflection 'Include_Class' '__construct';
checkSimple "new Bashor_Reflection_Method Reflection __construct" "$?" "0";

temp="`object "$Reflection" getName`"
checkSimple "class getName return" "$?" "0";
checkSimple "class getName output" "$temp" "__construct";

object "$Reflection" getDeclaringClass tempParent
object "$tempParent" isA 'Bashor_Reflection_Class'
checkSimple "class getParentClass isA Bashor_Reflection_Class" "$?" "0";

temp="`object "$tempParent" getName`"
checkSimple "class getDeclaringClass getName return" "$?" "0";
checkSimple "class getDeclaringClass getName output" "$temp" "Include_Class";

object "$Reflection" isConstructor
checkSimple "class isConstructor true" "$?" "0";

object "$Reflection" isDestructor
checkSimple "class isDestructor false" "$?" "1";

new Bashor_Reflection_Method Reflection 'Include_Class' '__destruct';
checkSimple "new Bashor_Reflection_Method Reflection __destruct" "$?" "0";

object "$Reflection" isConstructor
checkSimple "class isConstructor false" "$?" "1";

object "$Reflection" isDestructor
checkSimple "class isDestructor true" "$?" "0";
