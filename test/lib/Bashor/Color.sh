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

loadClass 'Bashor_Color';

right=`echo -en '\033[1;31mtest\033[0m'`;
res=`class Bashor_Color fg 'test' 'red' 'bold'`;
checkSimple "fg" "$res" "$right";

right=`echo -en '\033[41mtest\033[0m'`;
res=`class Bashor_Color bg 'test' 'red'`;
checkSimple "bg" "$res" "$right";

