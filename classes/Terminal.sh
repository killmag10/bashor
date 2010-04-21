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
# @version      $Id: hash.sh 16 2010-03-12 23:35:45Z lars $
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
function CLASS_Terminal_setBackgroundColor()
{
    tput setb "$1";
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
function CLASS_Terminal_setBackgroundColorAnsi()
{
    tput setab "$1";
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
function CLASS_Terminal_setFordergroundColor()
{
    tput setf "$1";
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
function CLASS_Terminal_setFordergroundColorAnsi()
{
    tput setaf "$1";
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
function CLASS_Terminal_setStyleBold()
{
    if [ "$1" == 1 ]; then
        tput bold;
    else
        tput dim;
    fi
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
function CLASS_Terminal_setStyleUnderline()
{
    if [ "$1" == 1 ]; then
        tput smul;
    else
        tput rmul;
    fi
    return $?
}

##
# reset style
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Terminal_resetStyle()
{
    tput sgr0;
    return $?
}

##
# Get the terminal columns
#
# $?    0:OK    1:ERROR
function CLASS_Terminal_getColumns()
{
    tput cols;
    return $?
}

##
# Get the terminal lines
#
# $?    0:OK    1:ERROR
function CLASS_Terminal_getLines()
{
    tput lines;
    return $?
}

##
# Restore curser position
#
# $?    0:OK    1:ERROR
function CLASS_Terminal_restoreCurser()
{
    tput rc;
    return $?
}

##
# Save curser position
#
# $?    0:OK    1:ERROR
function CLASS_Terminal_saveCurser()
{
    tput sc;
    return $?
}

##
# Move curser up
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Terminal_moveCurserUp()
{
    tput cuu "$1";
    return $?
}

##
# Move curser down
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Terminal_moveCurserDown()
{
    tput cud "$1";
    return $?
}

##
# Move curser forward
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Terminal_moveCurserForward()
{
    tput cuf "$1";
    return $?
}

##
# Move curser backward
#
# $1    integer count
# $?    0:OK    1:ERROR
function CLASS_Terminal_moveCurserBackward()
{
    tput cub "$1";
    return $?
}

##
# Set curser to x y
#
# $1    integer x
# $2    integer y
# $?    0:OK    1:ERROR
function CLASS_Terminal_moveCurserTo()
{
    tput cup "$1" "$2";
    return $?
}

##
# Clear the terminal
#
# $?    0:OK    1:ERROR
function CLASS_Terminal_clear()
{
    clear;
    return $?
}

##
# Visual flash.
#
# $?    0:OK    1:ERROR
function CLASS_Terminal_flash()
{
    tput flash;
    return $?
}
