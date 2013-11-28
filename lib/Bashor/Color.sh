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
# Print text with forderground color.
#
# $1    string Text
# $2    string Color
# $3?   string Style
# $?    0:OK    1:ERROR
# &1    string Text
CLASS_Bashor_Color_fg()
{
    requireParams SR "$@"
        
    if [ -p /dev/stdin ] && [ -z "$1" ]; then
        local IFS=$'\n'
        while read msg; do static call fg "$msg" "$2" "$3"; echo; done
        return 0
    fi
    
    local color=`static call getFGColorByName "$2" "$3"`
    printf "\033$color%s\033[0m" "$1"
    return 0
}

##
# Print text with background color.
#
# $1    string Text
# $2    string Color
# $?    0:OK    1:ERROR
# &1    string Text
CLASS_Bashor_Color_bg()
{
    requireParams SR "$@"
    
    if [ -p /dev/stdin ] && [ -z "$1" ]; then
        local IFS=$'\n'
        while read msg; do static call bg "$msg" "$2"; echo; done
        return 0
    fi
    
    local color=`static call getBGColorByName "$2"`    
    printf "\033$color%s\033[0m" "$1"
    return 0
}

##
# Get binary forderground color.
#
# $1    string Color
# $?    0:OK    1:ERROR
# &1    string binary color
CLASS_Bashor_Color_getFGColorByName()
{
    requireParams R "$@"

    if [ -n "$2" ]; then
        local style=`static call getStyleByName "$2"`
    else
        local style=
    fi
    
    local -a FG_NAME=()
    FG_NAME[1]=black
    FG_NAME[2]=red
    FG_NAME[3]=green
    FG_NAME[4]=yellow
    FG_NAME[5]=blue
    FG_NAME[6]=purple
    FG_NAME[7]=cyan
    FG_NAME[8]=white

    local -a FG_NUMBER=()
    FG_NUMBER[1]=30m
    FG_NUMBER[2]=31m
    FG_NUMBER[3]=32m
    FG_NUMBER[4]=33m
    FG_NUMBER[5]=34m
    FG_NUMBER[6]=35m
    FG_NUMBER[7]=36m
    FG_NUMBER[8]=37m
    
    local item i=1 IFS=' '
    for item in "${FG_NUMBER[@]}"; do
        if [ "$1" == "${FG_NAME[$i]}" ]; then
            printf '%s' "[$style""$item"
        fi
        ((i++))
    done
}

##
# Get binary background color.
#
# $1    string Color
# $?    0:OK    1:ERROR
# &1    string binary color
CLASS_Bashor_Color_getBGColorByName()
{
    requireParams R "$@"
    
    local -a BG_NAME=()
    BG_NAME[1]=black
    BG_NAME[2]=red
    BG_NAME[3]=green
    BG_NAME[4]=brown
    BG_NAME[5]=blue
    BG_NAME[6]=purple
    BG_NAME[7]=cyan
    BG_NAME[8]=grey

    local -a BG_NUMBER=()
    BG_NUMBER[1]=40m
    BG_NUMBER[2]=41m
    BG_NUMBER[3]=42m
    BG_NUMBER[4]=43m
    BG_NUMBER[5]=44m
    BG_NUMBER[6]=45m
    BG_NUMBER[7]=46m
    BG_NUMBER[8]=47m
    
    local item i=1 IFS=' '
    for item in "${BG_NUMBER[@]}"; do
        if [ "$1" == "${BG_NAME[$i]}" ]; then
            printf '%s' "[$item"
        fi        
        ((i++))
    done
}

##
# Get binary style color.
#
# $1    string Style
# $?    0:OK    1:ERROR
# &1    string binary color
CLASS_Bashor_Color_getStyleByName()
{
    requireParams R "$@"
    
    local item word i IFS=' '
    for word in $1; do
        local -a ST_NAME=()
        ST_NAME[1]=normal
        ST_NAME[2]=bold
        ST_NAME[3]=underscore
        ST_NAME[4]=blink
        ST_NAME[5]=concealed
        ST_NAME[6]=inverse

        local -a ST_NUMBER=()
        ST_NUMBER[1]=0
        ST_NUMBER[2]=1
        ST_NUMBER[3]=4
        ST_NUMBER[4]=5
        ST_NUMBER[5]=6
        ST_NUMBER[6]=7
        
        i=1
        for item in "${ST_NUMBER[@]}"; do
            if [ "$word" == "${ST_NAME[$i]}" ]; then
                printf '%s' "$item"';'
            fi        
            ((i++))
        done
    done
}
