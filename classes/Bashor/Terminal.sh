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
function CLASS_Bashor_Terminal_setBackgroundColor()
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
function CLASS_Bashor_Terminal_setBackgroundColorAnsi()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 7 ] && return 1
    echo -en '\033[4'"$1"'m'
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
function CLASS_Bashor_Terminal_setFordergroundColor()
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
function CLASS_Bashor_Terminal_setFordergroundColorAnsi()
{
    requireParams R "$@"
    [ "$1" -lt 0 ] && return 1
    [ "$1" -gt 7 ] && return 1
    echo -en '\033[3'"$1"'m'
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
function CLASS_Bashor_Terminal_setStyleBold()
{
    requireParams R "$@"
    [ "$1" == 1 ] && echo -en '\033[1m' || tput dim
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
function CLASS_Bashor_Terminal_setExtendedCharacters()
{
    requireParams R "$@"
    [ "$1" == 1 ] && echo -en '\033(0' || echo -en '\033(B'
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
function CLASS_Bashor_Terminal_setStyleUnderline()
{
    requireParams R "$@"
    [ "$1" == 1 ] && tput smul || tput rmul
    return $?
}

##
# reset style
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_resetStyle()
{    
    echo -en '\033[0m'
    return $?
}

##
# Get the terminal columns
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_getColumns()
{
	if [ -n "$COLUMNS" ]; then
		echo "$COLUMNS"
		return $?
    fi
    
	stty -a | head -n 1 | sed 's/.*columns \([0-9]\+\).*/\1/'
    return $?
}

##
# Get the terminal lines
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_getLines()
{  
	if [ -n "$LINES" ]; then
		echo "$LINES"
		return $?
    fi
	
	stty -a | head -n 1 | sed 's/.*rows \([0-9]\+\).*/\1/'
    return $?
}

##
# Restore curser position
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_restoreCurser()
{
    echo -en '\033[u'
    return $?
}

##
# Save curser position
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_saveCurser()
{
    echo -en '\033[s'
    return $?
}

##
# Move curser up
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_moveCurserUp()
{
    requireParams R "$@"
    echo -en '\033['"$1"'A'
    return $?
}

##
# Move curser down
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_moveCurserDown()
{
    requireParams R "$@"
    echo -en '\033['"$1"'B'
    return $?
}

##
# Move curser forward
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_moveCurserForward()
{
    requireParams R "$@"
    echo -en '\033['"$1"'C'
    return $?
}

##
# Move curser backward
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_moveCurserBackward()
{
    requireParams R "$@"
    echo -en '\033['"$1"'D'
    return $?
}

##
# Move curser by x y
#
# $1    integer x
# $2    integer y
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_moveCurserBy()
{
    requireParams RR "$@"
    [ "$1" -gt 0 ] && this call moveCurserForward "$1"
    [ "$1" -lt 0 ] && this call moveCurserBackward "${1:1}"
    [ "$2" -gt 0 ] && this call moveCurserDown "$2"
    [ "$2" -lt 0 ] && this call moveCurserUp "${2:1}"
    return 0
}

##
# Move curser reversed by x y
#
# $1    integer x
# $2    integer y
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_moveCurserReversedBy()
{
    requireParams RR "$@"
    [ "$1" -lt 0 ] && this call moveCurserForward "${1:1}"
    [ "$1" -gt 0 ] && this call moveCurserBackward "$1"
    [ "$2" -lt 0 ] && this call moveCurserDown "${2:1}"
    [ "$2" -gt 0 ] && this call moveCurserUp "$2"
    return 0
}

##
# Set curser to x y
#
# $1    integer x
# $2    integer y
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_moveCurserTo()
{
    requireParams RR "$@"
    echo -en '\033['"$2"';'"$1"'H'
    return $?
}

##
# Clear the terminal
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_clear()
{
    clear
    return $?
}

##
# Visual flash.
#
# $?    0:OK    1:ERROR
function CLASS_Bashor_Terminal_flash()
{
    tput flash
    return $?
}
