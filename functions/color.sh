#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

function color_fg()
{
    color=`color_getFGColorByName "$2" "$3"`
    echo -en "\033$color";
    echo -n "$1";
    echo -en "\033[0m"
}

function color_bg()
{
    color=`color_getBGColorByName "$2"`
    echo -en "\033$color";
    echo -n "$1";
    echo -en "\033[0m"
}

function color_fgStream()
{
    local IFS_BAK=$IFS;
    local IFS=`echo -e "\n\r"`;
    while read msg; do color_fg "$msg" "$1" "$2"; echo ''; done
    local IFS=$IFS_BAK;
}

function color_bgStream()
{
    local IFS_BAK=$IFS;
    local IFS=`echo -e "\n\r"`;
    while read msg; do color_bg "$msg" "$1"; echo ''; done
    local IFS=$IFS_BAK;
} 

function color_getFGColorByName()
{
    if [ -n "$2" ]; then
        local style=`color_getStyleByName "$2"`;
    fi
   
    local FG_NAME[1]='black'
    local FG_NAME[2]='red'
    local FG_NAME[3]='green'
    local FG_NAME[4]='yellow'
    local FG_NAME[5]='blue'
    local FG_NAME[6]='purple'
    local FG_NAME[7]='cyan'
    local FG_NAME[8]='white'

    local FG_NUMBER[1]='30m'
    local FG_NUMBER[2]='31m'
    local FG_NUMBER[3]='32m'
    local FG_NUMBER[4]='33m'
    local FG_NUMBER[5]='34m'
    local FG_NUMBER[6]='35m'
    local FG_NUMBER[7]='36m'
    local FG_NUMBER[8]='37m'
    
    i=1;
    for item in "${FG_NUMBER[@]}"; do
        if [ "$1" == "${FG_NAME[$i]}" ]; then
            echo "[$style""$item";
        fi
        ((i++));        
    done
}

function color_getBGColorByName()
{
    local BG_NAME[1]='black'
    local BG_NAME[2]='red'
    local BG_NAME[3]='green'
    local BG_NAME[4]='brown'
    local BG_NAME[5]='blue'
    local BG_NAME[6]='purple'
    local BG_NAME[7]='cyan'
    local BG_NAME[8]='grey'

    local BG_NUMBER[1]='[40m'
    local BG_NUMBER[2]='[41m'
    local BG_NUMBER[3]='[42m'
    local BG_NUMBER[4]='[43m'
    local BG_NUMBER[5]='[44m'
    local BG_NUMBER[6]='[45m'
    local BG_NUMBER[7]='[46m'
    local BG_NUMBER[8]='[47m'
    
    i=1;
    for item in "${BG_NUMBER[@]}"; do
        if [ "$1" == "${BG_NAME[$i]}" ]; then
            echo $item;
        fi        
        ((i++));
    done
}

function color_getStyleByName()
{
    local IFS_BAK=$IFS;
    local IFS=" ";
    for word in $1; do
        local ST_NAME[1]='normal'
        local ST_NAME[2]='bold'
        local ST_NAME[3]='underscore'
        local ST_NAME[4]='blink'
        local ST_NAME[5]='concealed'
        local ST_NAME[6]='inverse'

        local ST_NUMBER[1]='0'
        local ST_NUMBER[2]='1'
        local ST_NUMBER[3]='4'
        local ST_NUMBER[4]='5'
        local ST_NUMBER[5]='6'
        local ST_NUMBER[6]='7'
        
        i=1;
        for item in "${ST_NUMBER[@]}"; do
            if [ "$word" == "${ST_NAME[$i]}" ]; then
                echo -n "$item"';';
            fi        
            ((i++));
        done
    done
    local IFS=$IFS_BAK;
    echo '';
}
