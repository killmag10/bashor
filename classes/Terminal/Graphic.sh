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
    optSetOpts "BUX";
    optSetArgs "$@";

    argIsNotEmpty 1 || error "Param 1 not set";
    argIsNotEmpty 2 || error "Param 2 not set";

    loadClass 'Terminal';

    class Terminal saveCurser;
    class Terminal moveCurserBy "`argValue 1`" "`argValue 2`";
    [ -n "`argValue 4`" ] && class Terminal setBackgroundColorAnsi "`argValue 4`";
    [ -n "`argValue 5`" ] && class Terminal setFordergroundColorAnsi "`argValue 5`";
    
    optIsset 'B' && class Terminal setStyleBold 1;
    optIsset 'U' && class Terminal setStyleUnderline 1;
    optIsset 'X' && class Terminal setExtendedCharacters 1;
    
    local char="`argValue 3`";
    local char="${char:- }";
    echo -n "${char:0:1}";
    optIsset 'X' && class Terminal setExtendedCharacters 0;
    class Terminal resetStyle;
    class Terminal restoreCurser;
    return "$?";
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
function CLASS_Terminal_Graphic_printText()
{
    optSetOpts "BUX";
    optSetArgs "$@";

    argIsNotEmpty 1 || error "Param 1 not set";
    argIsNotEmpty 2 || error "Param 2 not set";
    argIsNotEmpty 3 || error "Param 3 not set";

    loadClass 'Terminal';

    class Terminal saveCurser;
    class Terminal moveCurserBy "`argValue 1`" "`argValue 2`";
    [ -n "`argValue 4`" ] && class Terminal setBackgroundColorAnsi "`argValue 4`";
    [ -n "`argValue 5`" ] && class Terminal setFordergroundColorAnsi "`argValue 5`";    
    
    optIsset 'B' && class Terminal setStyleBold 1;
    optIsset 'U' && class Terminal setStyleUnderline 1;
    optIsset 'X' && class Terminal setExtendedCharacters 1;
    
    echo -n "`argValue 3`";
    optIsset 'X' && class Terminal setExtendedCharacters 0;
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
    optSetOpts "BUX";
    optSetArgs "$@";

    argIsNotEmpty 1 || error "Param 1 not set";
    argIsNotEmpty 2 || error "Param 2 not set";
    argIsNotEmpty 3 || error "Param 3 not set";
    argIsNotEmpty 4 || error "Param 4 not set";
    argIsset 5 || error "Param 5 not set";

    loadClass 'Terminal';

    (
        local char="`argValue 5`";
        local char="${char:- }";
        local char="${char:0:1}";
        local h="`argValue 4`";        
        class Terminal saveCurser;
        
        argIsNotEmpty 6 && class Terminal setBackgroundColorAnsi "`argValue 6`";
        argIsNotEmpty 7 && class Terminal setFordergroundColorAnsi "`argValue 7`";
        optIsset 'B' && class Terminal setStyleBold 1;
        optIsset 'U' && class Terminal setStyleUnderline 1;
        optIsset 'X' && class Terminal setExtendedCharacters 1;
        
        class Terminal moveCurserBy "`argValue 1`" "`argValue 2`";
        local v3="`argValue 3`";
        local tmp=`
            dd if=/dev/zero 2>/dev/null bs="$v3" count="1" | tr '\0' "$char";
            class Terminal moveCurserBy -"$v3" 1;
        `;
        local out='';
        for i in `seq "$h"`; do local out="${out}${tmp}"; done;
        echo -n "$out";
        optIsset 'X' && class Terminal setExtendedCharacters 0;
        class Terminal resetStyle;    
        class Terminal restoreCurser;
    )
    
    return "$?";
}
