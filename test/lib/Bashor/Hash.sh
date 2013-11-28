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

loadClass 'Bashor_Hash';

res=`class Bashor_Hash md5 'abc123'`;
checkSimple "md5" "$res" "e99a18c428cb38d5f260853678922e03";
