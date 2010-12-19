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
# @subpackage   Class
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: color.sh 19 2010-03-13 19:27:45Z lars $
################################################################################

##
# Print text with forderground color.
#
# $1    string Text
# $2    string Color
# $3?   string Style
# $?    0:OK    1:ERROR
# &1    string Text
function CLASS_Bashor_Color_fg()
{
    : ${1?};
    : ${2:?};
        
    if [ -p /dev/stdin ] && [ -z "$1" ]; then
        local IFS=$'\n\r';
        while read msg; do this call fg "$msg" "$2" "$3"; echo; done
        return 0;
    fi
    
    local color=`this call getFGColorByName "$2" "$3"`
    echo -en "\033$color";
    echo -n "$1";
    echo -en "\033[0m"
    return 0;
}

##
# Print text with background color.
#
# $1    string Text
# $2    string Color
# $?    0:OK    1:ERROR
# &1    string Text
function CLASS_Bashor_Color_bg()
{    
    : ${1?};
    : ${2:?};
    
    if [ -p /dev/stdin ] && [ -z "$1" ]; then
        local IFS=`echo -e "\n\r"`;
        while read msg; do this call bg "$msg" "$2"; echo; done
        return 0;
    fi
    
    local color=`this call getBGColorByName "$2"`
    echo -en "\033$color";
    echo -n "$1";
    echo -en "\033[0m"
    return 0;
}

##
# Get binary forderground color.
#
# $1    string Color
# $?    0:OK    1:ERROR
# &1    string binary color
function CLASS_Bashor_Color_getFGColorByName()
{
    : ${1:?};

    if [ -n "$2" ]; then
        local style=`this call getStyleByName "$2"`;
    else
        local style=;
    fi
   
    local FG_NAME[1]=black;
    local FG_NAME[2]=red;
    local FG_NAME[3]=green;
    local FG_NAME[4]=yellow;
    local FG_NAME[5]=blue;
    local FG_NAME[6]=purple;
    local FG_NAME[7]=cyan;
    local FG_NAME[8]=white;

    local FG_NUMBER[1]=30m;
    local FG_NUMBER[2]=31m;
    local FG_NUMBER[3]=32m;
    local FG_NUMBER[4]=33m;
    local FG_NUMBER[5]=34m;
    local FG_NUMBER[6]=35m;
    local FG_NUMBER[7]=36m;
    local FG_NUMBER[8]=37m;
    
    i=1;
    local IFS=' ';
    for item in "${FG_NUMBER[@]}"; do
        if [ "$1" == "${FG_NAME[$i]}" ]; then
            echo "[$style""$item";
        fi
        ((i++));        
    done
}

##
# Get binary background color.
#
# $1    string Color
# $?    0:OK    1:ERROR
# &1    string binary color
function CLASS_Bashor_Color_getBGColorByName()
{
    : ${1:?};
    
    local BG_NAME[1]=black;
    local BG_NAME[2]=red;
    local BG_NAME[3]=green;
    local BG_NAME[4]=brown;
    local BG_NAME[5]=blue;
    local BG_NAME[6]=purple;
    local BG_NAME[7]=cyan;
    local BG_NAME[8]=grey;

    local BG_NUMBER[1]=40m;
    local BG_NUMBER[2]=41m;
    local BG_NUMBER[3]=42m;
    local BG_NUMBER[4]=43m;
    local BG_NUMBER[5]=44m;
    local BG_NUMBER[6]=45m;
    local BG_NUMBER[7]=46m;
    local BG_NUMBER[8]=47m;
    
    i=1;
    local IFS=' ';
    for item in "${BG_NUMBER[@]}"; do
        if [ "$1" == "${BG_NAME[$i]}" ]; then
            echo "[$item";
        fi        
        ((i++));
    done
}

##
# Get binary style color.
#
# $1    string Style
# $?    0:OK    1:ERROR
# &1    string binary color
function CLASS_Bashor_Color_getStyleByName()
{
    : ${1:?};
    
    local IFS=' ';
    for word in $1; do
        local ST_NAME[1]=normal;
        local ST_NAME[2]=bold;
        local ST_NAME[3]=underscore;
        local ST_NAME[4]=blink;
        local ST_NAME[5]=concealed;
        local ST_NAME[6]=inverse;

        local ST_NUMBER[1]=0;
        local ST_NUMBER[2]=1;
        local ST_NUMBER[3]=4;
        local ST_NUMBER[4]=5;
        local ST_NUMBER[5]=6;
        local ST_NUMBER[6]=7;
        
        i=1;
        for item in "${ST_NUMBER[@]}"; do
            if [ "$word" == "${ST_NAME[$i]}" ]; then
                echo -n "$item"';';
            fi        
            ((i++));
        done
    done
    echo;
}
