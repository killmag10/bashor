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
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

##
# Constructor
#
# $1      doc block contend
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Doc_Block_Decorator_Man___construct()
{
    requireObject
    
    isObject "$1" || error 'Pointer "'"$1"'" is not a Object!'    
    object "$1" isA Bashor_Doc_Block_Item || error 'Not a Bashor_Doc_Block_Item' 
    
    this set item "$1"
    
    return 0
}

##
# Get the formated Doc Block
#
# &1    string  block type
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Doc_Block_Decorator_Man_get()
{
    requireObject
    
    local Item
    Item="`this get item`"
    
    case "`object "$Item" getType`" in
        function)
            this call _getFunction
            ;;
    esac
    
    return 0
}

##
# Get the formated Doc Block for a function.
#
# &1    string  block type
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Doc_Block_Decorator_Man__getFunction()
{
    requireObject
    
    local Item
    Item="`this get item`"
    
    echo '.TP';
    echo '.B '"`object "$Item" getName`"'()';
    echo '.RS'
    
    local regex replace
    local line IFS=$'\n';
    for line in `object "$Item" getDoc`; do        
        if [[ "$line" =~ ^[[:space:]]*[\$\&][[:alnum:]_@]+ ]]; then
            echo '.HP'
            regex='^[[:space:]]*\([\$\&][[:alnum:]_@]\+\)[[:space:]]\+\([[:alpha:]|]\+\)[[:space:]]\+';
            replace='.B \1\n.I \2\n'
            echo "$line" \
                | sed 's/'"$regex"'/'"$replace"'/'
            continue;
        fi        
        if [[ "$line" =~ ^[[:space:]]*\$\? ]]; then
            echo '.HP'
            regex='^[[:space:]]*\(\$?\+\)[[:space:]]\+\([[:digit:]\*]\+\)[[:space:]]\+';
            replace='.B \1\n.I \2\n'
            echo "$line" \
                | sed 's/'"$regex"'/'"$replace"'/'
            continue;
        fi
        if [[ -z "$line" ]]; then
            echo;
            continue;
        fi
        echo '.HP'
        echo "$line";
    done  
    
    echo '.RE'
    echo
    
    return 0
}
