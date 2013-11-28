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
    
    printf '.TP\n'
    printf '.B %s\n' "`object "$Item" getName`"'()'
    printf '.RS\n'
    
    local regex replace
    local line IFS=$'\n'
    for line in `object "$Item" getDoc`; do        
        if [[ "$line" =~ ^[[:space:]]*[\$\&][[:alnum:]_@]+ ]]; then
            printf '.HP\n'
            regex='^[[:space:]]*\([\$\&][[:alnum:]_@]\+\)[[:space:]]\+\([[:alpha:]|]\+\)[[:space:]]\+'
            replace='.B \1\n.I \2\n'
            printf '%s\n' "$line" \
                | sed 's/'"$regex"'/'"$replace"'/'
            continue
        fi        
        if [[ "$line" =~ ^[[:space:]]*\$\? ]]; then
            printf '%s\n' '.HP'
            regex='^[[:space:]]*\(\$?\+\)[[:space:]]\+\([[:digit:]\*]\+\)[[:space:]]\+'
            replace='.B \1\n.I \2\n'
            printf '%s\n' \
                | sed 's/'"$regex"'/'"$replace"'/'
            continue
        fi
        if [[ -z "$line" ]]; then
            echo
            continue
        fi
        printf '.HP\n'
        printf '%s\n' "$line"
    done  
    
    printf '%s\n\n' '.RE'
    
    return 0
}
