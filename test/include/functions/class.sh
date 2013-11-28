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
