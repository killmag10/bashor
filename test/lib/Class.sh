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

# classExists
loadClass 'Bashor_Session';
class Bashor_Session isA 'Bashor_Session'
checkSimple "isA Bashor_Session true" "$?" '0';

class Bashor_Session isA 'Bashor_Registry'
checkSimple "isA Bashor_Registry true" "$?" '0';

class Bashor_Session isA 'Null'
checkSimple "isA Null false" "$?" '1';

class Bashor_Session hasMethod 'remove'
checkSimple "hasMethod remove true" "$?" '0';

class Bashor_Session hasMethod 'noMethod'
checkSimple "hasMethod noMethod false" "$?" '1';
