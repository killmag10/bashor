#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Includes
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: functions.sh 56 2010-04-25 22:49:54Z lars $
################################################################################

function printHex() {
    local string="$1";
    local list="$2";
    if shift 2; then
        (
            for i in $list; do
                printHex "${string}\x${i}" "$@";
            done;
        )
    else
        echo -n "${string} ";
        echo -e "${string}"; 
    fi
}

[ "$1" -lt "1" ] && exit 0;

# (0 to 127)
h1=`echo -n {0,1,2,3,4,5,6,7}{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}`;
printHex "" "$h1";

[ "$1" -lt "2" ] && exit 0;

# (128 to 2,047)
h1=`echo -n {C,D}{2,3,4,5,6,7,8,9,A,B,C,D,E,F}`;
h2=`echo -n {8,9,A,B}{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}`;
printHex "" "$h1" "$h2";

[ "$1" -lt "3" ] && exit 0;

# (2,048 to 65,535)
h1=`echo -n E{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}`;
h2=`echo -n {8,9,A,B}{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}`;
printHex "" "$h1" "$h2" "$h2";

[ "$1" -lt "4" ] && exit 0;

# (65,536 to 1,114,111)
h1=`echo -n F{0,1,2,3,4,5,6,7}`;
h2=`echo -n {8,9,A,B}{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}`;
printHex "" "$h1" "$h2" "$h2" "$h2";

exit 0;
