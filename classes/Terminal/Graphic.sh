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
# @version      $Id: escape.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

##
# buffer graphic
#
# &1    string data
function CLASS_Terminal_Graphic__buffer()
{
    local tmp=`cat -`;
    echo -n "$tmp";   
    return "$?";
}

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
function CLASS_Terminal_Graphic_setPixel()
{
    optSetOpts "BU";
    optSetArgs "$@";

    argIsset 1 || error "Param 1 not set";
    argIsset 2 || error "Param 2 not set";
    argIsset 3 || error "Param 3 not set";

    loadClass 'Terminal';

    class Terminal saveCurser;
    class Terminal moveCurserTo "`argValue 1`" "`argValue 2`";
    [ -n "`argValue 4`" ] && class Terminal setBackgroundColor "`argValue 4`";
    [ -n "`argValue 5`" ] && class Terminal setFordergroundColor "`argValue 5`";    
    
    optIsset 'B' && class Terminal setStyleBold 1;
    optIsset 'U' && class Terminal setStyleUnderline 1;
    
    local char="`argValue 3`";
    local char="${char:- }";
    echo -n "${char:0:1}";
    class Terminal resetStyle;
    class Terminal restoreCurser;
    
    return "$?";
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
function CLASS_Terminal_Graphic_printRectangleFilled()
{
    optSetOpts "BU";
    optSetArgs "$@";

    argIsset 1 || error "Param 1 not set";
    argIsset 2 || error "Param 2 not set";
    argIsset 3 || error "Param 3 not set";
    argIsset 4 || error "Param 4 not set";
    argIsset 5 || error "Param 5 not set";

    loadClass 'Terminal';

    (
        local char="${5:- }";
        local char="${char:0:1}";
        local y2=`echo "$2 + $4 - 1" | bc`;
        
        class Terminal saveCurser;
        
        [ -n "$6" ] && class Terminal setBackgroundColor "$6";
        [ -n "$7" ] && class Terminal setFordergroundColor "$7";
        for i in `seq "$2" "$y2"`; do
            class Terminal moveCurserTo "$1" "$i";
            dd if=/dev/zero 2>/dev/null bs="$3" count="1" | tr '\0' "$char";
        done;
        
        class Terminal resetStyle;    
        class Terminal restoreCurser;
    ) | this call _buffer
    
    return "$?";
}
