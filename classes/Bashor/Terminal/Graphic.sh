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
# @version      $Id$
################################################################################

loadClassOnce Bashor_Terminal

##
# set one pixel
#
# $1    integer x
# $2    integer y
# $3    char    a char
# $4    integer background color
# $5    integer forderground color
# -B    -       Bold
# -U    -       Underline
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_Graphic_setPixel()
{
    requireParams RR "$@"

    class Bashor_Terminal moveCurserBy "$1" "$2"
    [ -n "$4" ] && class Bashor_Terminal setBackgroundColorAnsi "$4"
    [ -n "$5" ] && class Bashor_Terminal setFordergroundColorAnsi "$5"
    if [ -n "$6" ]; then
        [[ "$6" =~ B ]] && class Bashor_Terminal setStyleBold 1
        [[ "$6" =~ U ]] && class Bashor_Terminal setStyleUnderline 1
        [[ "$6" =~ X ]] && class Bashor_Terminal setExtendedCharacters 1
    fi    
    local char="${3:- }"
    echo -n "${char:0:1}"
    [[ "$6" =~ X ]] && class Bashor_Terminal setExtendedCharacters 0
    class Bashor_Terminal resetStyle
    class Bashor_Terminal moveCurserBy "$((-1+$1*-1))" "$(($2*-1))"
    
    return 0
}

##
# print a text
#
# $1    integer x
# $2    integer y
# $3    char    a char
# $4    integer background color
# $5    integer forderground color
# -B    -       Bold
# -U    -       Underline
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_Graphic_printText()
{
    requireParams RRR "$@"

    class Bashor_Terminal saveCurser
    class Bashor_Terminal moveCurserBy "$1" "$2"
    [ -n "$4" ] && class Bashor_Terminal setBackgroundColorAnsi "$4"
    [ -n "$5" ] && class Bashor_Terminal setFordergroundColorAnsi "$5"
    if [ -n "$6" ]; then
        [[ "$6" =~ B ]] && class Bashor_Terminal setStyleBold 1
        [[ "$6" =~ U ]] && class Bashor_Terminal setStyleUnderline 1
        [[ "$6" =~ X ]] && class Bashor_Terminal setExtendedCharacters 1
    fi    
    echo -n "$3"
    [[ "$6" =~ X ]] && class Bashor_Terminal setExtendedCharacters 0
    class Bashor_Terminal resetStyle
    class Bashor_Terminal restoreCurser
    return 0
}

##
# print a filled rectangle
#
# $1    integer x
# $2    integer y
# $3    integer columns
# $4    integer lines
# $5    char    a char
# $6    integer background color
# $7    integer forderground color
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_Graphic_printRectangleFilled()
{
    requireParams RRRR "$@"
    loadClassOnce Bashor_Escape

	local char="${5:- }"
	char=`class Bashor_Escape regExReplacement "${char:0:1}" '/'`
	class Bashor_Terminal saveCurser
	[ -n "$6" ] && class Bashor_Terminal setBackgroundColorAnsi "$6"
	[ -n "$7" ] && class Bashor_Terminal setFordergroundColorAnsi "$7"
	if [ -n "$8" ]; then
		[[ "$8" =~ B ]] && class Bashor_Terminal setStyleBold 1
        [[ "$8" =~ U ]] && class Bashor_Terminal setStyleUnderline 1
        [[ "$8" =~ X ]] && class Bashor_Terminal setExtendedCharacters 1
	fi        
	class Bashor_Terminal moveCurserBy "$1" "$2"
	local tmp=`
		printf "%${3}s" | sed 's/ /'"$char"'/g'
        class Bashor_Terminal moveCurserReversedBy "$3" -1
	`
	local i out=
    for i in `seq "$4"`; do out="${out}${tmp}"; done
	echo -n "$out"
	[[ "$8" =~ X ]] && class Bashor_Terminal setExtendedCharacters 0
	class Bashor_Terminal resetStyle
	class Bashor_Terminal restoreCurser

    return 0
}
