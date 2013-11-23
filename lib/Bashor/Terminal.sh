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

##
# Set background
#
# 0:black
# 1:blue
# 2:green
# 3:cyan
# 4:red
# 5:lilac
# 6:brown
# 7:white
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setBackgroundColor()
{
    requireParams R "$@"
    tput setb "$1"
    return $?
}

##
# Set background with ANSI escape
#
# 0:black
# 1:red
# 2:green
# 3:brown
# 4:blue
# 5:lilac
# 6:cyan
# 7:white
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setBackgroundColorAnsi()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 7 ] && return 1
    printf '\033[4%dm' "$1"
    return $?
}

##
# Set forderground
#
# 0:black
# 1:blue
# 2:green
# 3:cyan
# 4:red
# 5:lilac
# 6:brown
# 7:white
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setFordergroundColor()
{
    requireParams R "$@"
    tput setf "$1"
    return $?
}

##
# Set forderground with ANSI escape
#
# 0:black
# 1:red
# 2:green
# 3:brown
# 4:blue
# 5:lilac
# 6:cyan
# 7:white
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setFordergroundColorAnsi()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 7 ] && return 1
    printf '\033[3%dm' "$1"
    return $?
}

##
# Set forderground rgb color with extendet color range (support must be on)
#
# $1    integer red     range 0-5
# $2    integer green   range 0-5
# $3    integer blue    range 0-5
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setExtendedFordergroundColor()
{
    requireParams RRR "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 5 ] && return 1
    [ "$2" -lt 0 ] && return 1
    [ "$2" -gt 5 ] && return 1
    [ "$3" -lt 0 ] && return 1
    [ "$3" -gt 5 ] && return 1
    
    printf "\033[38;5;$((16+$3+($2*6)+($1*36)))m"
    return $?
}

##
# Set background rgb color with extendet color range (support must be on)
#
# $1    integer red     range 0-5
# $2    integer green   range 0-5
# $3    integer blue    range 0-5
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setExtendedBackgroundColor()
{
    requireParams RRR "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 5 ] && return 1
    [ "$2" -lt 0 ] && return 1
    [ "$2" -gt 5 ] && return 1
    [ "$3" -lt 0 ] && return 1
    [ "$3" -gt 5 ] && return 1
    
    printf "\033[48;5;$((16+$3+($2*6)+($1*36)))m"
    return $?
}

##
# Set forderground system color with extendet range (support must be on)
#
# $1    integer value     range 0-15
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setExtendedFordergroundColorSystem()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 15 ] && return 1
    
    printf "\033[38;5;${1}m"
    return $?
}

##
# Set background system color with extendet range (support must be on)
#
# $1    integer value     range 0-15
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setExtendedBackgroundColorSystem()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 15 ] && return 1
    
    printf "\033[48;5;${1}m"
    return $?
}

##
# Set forderground grayscale tone with extendet range (support must be on)
#
# $1    integer value     range 0-23
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setExtendedFordergroundColorGrayscale()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 23 ] && return 1
    
    printf "\033[38;5;$((232+$1))m"
    return $?
}

##
# Set background grayscale tone with extendet range (support must be on)
#
# $1    integer value     range 0-23
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setExtendedBackgroundColorGrayscale()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 23 ] && return 1
    
    printf "\033[48;5;$((232+$1))m"
    return $?
}

##
# Set style bold
#
# 0:Off
# 1:On
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setStyleBold()
{
    requireParams R "$@"
    [ "$1" == 1 ] && printf '\033[1m' || printf '\033[21m'
    return $?
}

##
# Set extendet Characters
#
# 0:Off
# 1:On
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setExtendedCharacters()
{
    requireParams R "$@"
    [ "$1" == 1 ] && printf '\033(0' || printf '\033(B'
    return $?
}

##
# Set style underline
#
# 0:Off
# 1:On
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_setStyleUnderline()
{
    requireParams R "$@"
    [ "$1" == 1 ] && printf '\033[4m' || printf '\033[24m'
    return $?
}

##
# reset style
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_resetStyle()
{    
    printf '\033[0m'
    return $?
}

##
# Get the terminal columns
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_getColumns()
{
	if [ -n "$COLUMNS" ]; then
		printf '%d' "$COLUMNS"
		return $?
    fi
    
	stty -a | head -n 1 | sed 's/.*columns \([0-9]\+\).*/\1/'
    return $?
}

##
# Get the terminal lines
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_getLines()
{  
	if [ -n "$LINES" ]; then
		printf '%d' "$LINES"
		return $?
    fi
	
	stty -a | head -n 1 | sed 's/.*rows \([0-9]\+\).*/\1/'
    return $?
}

##
# Restore curser position
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_restoreCurser()
{
    printf '\033[u'
    return $?
}

##
# Save curser position
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_saveCurser()
{
    printf '\033[s'
    return $?
}

##
# Move curser up
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_moveCurserUp()
{
    requireParams R "$@"
    printf '\033[%sA' "$1"
    return $?
}

##
# Move curser down
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_moveCurserDown()
{
    requireParams R "$@"
    printf '\033[%sB' "$1"
    return $?
}

##
# Move curser forward
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_moveCurserForward()
{
    requireParams R "$@"
    printf '\033[%sC' "$1"
    return $?
}

##
# Move curser backward
#
# $1    integer count
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_moveCurserBackward()
{
    requireParams R "$@"
    printf '\033[%sD' "$1"
    return $?
}

##
# Move curser by x y
#
# $1    integer x
# $2    integer y
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_moveCurserBy()
{
    requireParams RR "$@"
    [ "$1" -gt 0 ] && static call moveCurserForward "$1"
    [ "$1" -lt 0 ] && static call moveCurserBackward "${1:1}"
    [ "$2" -gt 0 ] && static call moveCurserDown "$2"
    [ "$2" -lt 0 ] && static call moveCurserUp "${2:1}"
    return 0
}

##
# Move curser reversed by x y
#
# $1    integer x
# $2    integer y
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_moveCurserReversedBy()
{
    requireParams RR "$@"
    [ "$1" -lt 0 ] && static call moveCurserForward "${1:1}"
    [ "$1" -gt 0 ] && static call moveCurserBackward "$1"
    [ "$2" -lt 0 ] && static call moveCurserDown "${2:1}"
    [ "$2" -gt 0 ] && static call moveCurserUp "$2"
    return 0
}

##
# Set curser to x y
#
# $1    integer x
# $2    integer y
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_moveCurserTo()
{
    requireParams RR "$@"
    printf '\033[%s;%sH' "$2" "$1"
    return $?
}

##
# Clear the terminal
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_clear()
{
    printf '\033[H\033[2J'    
    return $?
}

##
# Visual flash.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Terminal_flash()
{
    tput flash
    return $?
}
