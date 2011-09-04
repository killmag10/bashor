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
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Doc_Block___construct()
{
    : ${OBJECT:?}
    
    local items
    new Bashor_List_Iterable items
    this set items "$items"
    
    this set optionShowPrivateFunctions ''
    
    return 0
}

##
# Set a option.
#
# Options:
# showPrivateFunctions: '' (false) / '1' (true)
#
# $1    string  option key
# $2    string  option value
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Doc_Block_setOption()
{
    requireObject
    requireParams RS "$@"
    
    case "$1" in
        showPrivateFunctions)
            this set optionShowPrivateFunctions "$2"
            ;;
    esac
    
    return 0
}

##
# Parse a file.
#
# $1    string  filename
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Doc_Block_parseFile()
{
    requireObject
    requireParams R "$@"
        
    this call parseString "`cat "$1"`";
    return 0
}

##
# Parse a string.
#
# $1    string  contend
# $?    0       OK
# $?    1       ERROR
CLASS_Bashor_Doc_Block_parseString()
{
    requireObject
    requireParams R "$@"
    
    local NL=$'\n';
    local content="$1";
    local docBlock=
    local inDocBlock=
    
    local line IFS=$'\n';
    for line in $content; do        
        # Doc Block Begins?
        if [[ "$line" =~ ^[[:space:]]*\#\# ]]; then
            inDocBlock=1;
            docBlock=
            continue;
        fi
        
        # Not in a Doc Block?
        [ -z "$inDocBlock" ] && continue;
        
        if [[ -z "$line" ]]; then
            continue;
        fi
        
        if [[ "$line" =~ ^[[:space:]]*\# ]]; then
            line="`printf '%s' "$line" | sed 's/^[[:space:]]*\#[[:space:]]*//'`"
            docBlock="${docBlock}${line}${NL}"
            continue;
        fi
                
        this call parseDocBlock "$docBlock" "$line"
        inDocBlock=;
        docBlock=;
        
    done;
    
    return 0
}

CLASS_Bashor_Doc_Block_parseDocBlock()
{
    requireObject
    requireParams SS "$@"
    
    local Item
    new Bashor_Doc_Block_Item Item
    object $Item setDoc "$1"
    object $Item setLineAfter "$2"
    
    if [[ "$2" =~ ^[[:space:]]*(function[[:space:]]+[[:alnum:]]+|[_[:alnum:]]+[[:space:]]*\(\)) ]]; then
        object $Item setType 'function'
        
        if [ -z "`this get optionShowPrivateFunctions`" ]; then
            local name="`object $Item getName`"
            if [[ "$name" =~ ^_[^_] ]]; then
                remove $Item
                return 1
            fi
        fi
    fi
    
    local Items="`this get items`"
    object $Items add "$Item"
    return 0
}


CLASS_Bashor_Doc_Block_getItems()
{
    requireObject
    
    local items="`this get items`"
    object "$items" asLines
}

CLASS_Bashor_Doc_Block_getItemsByType()
{
    requireObject
    requireParams R "$@"
    
    local Current
    for Current in `this call getItems`; do        
        if [ "`object "$Current" getType`" = "$1" ]; then
            printf '%s' "$Current"
        fi
    done
}

CLASS_Bashor_Doc_Block_sortByName()
{
    requireObject
    
    local IFS=$'\n'
    local Items="`this get items`"
    local sortList=
    local Current=
    for Current in `this call getItems`; do   
        sortList="$sortList""`object "$Current" getName`"" $Current"$'\n'
    done
    
    sortList=$(
        printf '%s' "$sortList" | sort | sed 's/^.*[[:space:]]\([^[:space:]]\+\)$/\1/'
    )
    
    object $Items clear
    for Current in $sortList; do   
        object $Items add "$Current"
    done
        
    return 0
}
