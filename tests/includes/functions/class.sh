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
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3 version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

# classExists
classExists 'Null'
checkSimple "classExists false" "$?" '1';

loadClass 'Null';

classExists 'Null'
checkSimple "classExists true" "$?" '0';

# isObject
Null='astring'
isObject "$Null"
checkSimple "isObject false" "$?" '1';

new Null Null
isObject "$Null"
checkSimple "isObject true" "$?" '0';
remove Null
