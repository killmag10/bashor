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
# @version      $Id: class.sh 171 2011-08-23 19:45:55Z lars $
################################################################################

# classExists
loadClass 'Bashor_Session';
class Bashor_Session isA 'Bashor_Session'
checkSimple "isA Bashor_Session true" "$?" '0';

class Bashor_Session isA 'Bashor_Registry'
checkSimple "isA Bashor_Registry true" "$?" '0';

class Bashor_Session isA 'Null'
checkSimple "isA Null false" "$?" '1';
