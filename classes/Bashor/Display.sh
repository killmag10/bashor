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
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: display.sh 17 2010-03-13 00:12:19Z lars $
################################################################################

##
# Draw a simple progressbar
#
# -     string  lines (per line one step)
# $1?   string bar
# $2?   string pre
# $3?   string post
function CLASS_Bashor_Display_simpleRotateBar()
{
    : ${1:?};
    
    local bar="${1:-'#         '}";
    local pbar_pre="${2:-'['}";
    local pbar_post="${3:-']'}";
    
    local barLength=`echo -n "$pbar" | wc -m`;
    echo "$barPre""$bar""$barPost";
    echo -n -e "\e[1A";
    while read value; do
        local barLast=`echo "$pbar" | cut -b "$barLength"`;
        local bar=`echo "$barLast""$pbar" | cut -b 1-"$barLength"`;
        echo "$barPre""$bar""$barPost";
        echo -n -e "\e[1A";
    done;
    echo "";
}
