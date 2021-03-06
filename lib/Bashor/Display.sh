#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

##
# Draw a simple progressbar
#
# -     string  lines (per line one step)
# $1?   string bar
# $2?   string pre
# $3?   string post
CLASS_Bashor_Display_simpleRotateBar()
{    
    local bar="${1:-#         }"
    local barPre="${2:-[}"
    local barPost="${3:-]}"
    
    local barLength=`echo -n "$bar" | wc -m`
    echo "$barPre""$bar""$barPost"
    echo -n -e "\e[1A"
    local value barLast bar
    while read value; do
        barLast=`echo "$bar" | cut -b "$barLength"`
        bar=`echo "$barLast""$bar" | cut -b 1-"$barLength"`
        printf '%s\n\e[1A' "$barPre""$bar""$barPost"
    done
    echo
}
