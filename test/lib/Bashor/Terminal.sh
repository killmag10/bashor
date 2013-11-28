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

loadClass 'Bashor_Terminal';

res=`class Bashor_Terminal getColumns`;
checkRegex "getColumns" "$res" '[1-9][0-9]*';
res=`class Bashor_Terminal getLines`;
checkRegex "getLines" "$res" '[1-9][0-9]*';
