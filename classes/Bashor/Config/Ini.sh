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
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id
################################################################################

loadClassOnce 'Bashor_Config'
extends Bashor_Config_Ini Bashor_Config

##
# Constructor
#
# $1    string  ini file
CLASS_Bashor_Config_Ini___construct()
{
    requireObject
    
    parent call __construct
    local file="$1"
    this set 'file' "$file"
    
    [ -n "$file" ] || return 0;
    [ -e "$file" ] || error 'File "'"$file"'" does not exists!'
    
    this call _readFile
    this call _extendsSections
}

##
# Read the ini file content
CLASS_Bashor_Config_Ini__readFile()
{
    requireObject
    
    local section line key value file
    file="`this get 'file'`"
    while read line; do
        [[ "$line" =~ ^\; ]] && continue
        if [[ "$line" =~ ^\[[^\]]+\]$ ]]; then
            section="`printf '%s' "$line" | sed 's/^[[:space:]]*\[//;s/\][[:space:]]*$//'`"
        fi
        if [[ "$line" =~ [[:alnum:]\.]+[[:space:]]*= ]]; then
            key="`printf '%s' "$line" | sed 's/[[:space:]]*=.*$//'`"
            value="`printf '%s' "$line" | sed 's/[[:alnum:]\.]\+[[:space:]]*=[[:space:]]*//;s/^\"\(.*\)\"$/\1/'`"
            this call _setIniValue "$section.$key" "$value"
        fi
    done < "$file"
}

##
# Extends the sections
CLASS_Bashor_Config_Ini__extendsSections()
{
    requireObject
    local key section parent parentKey item itemParent ParentList

    new Bashor_List_Iterable ParentList

    this call rewind
    while this call valid; do
        key="`this call key`"
        if [[ "$key" =~ : ]]; then
            section="`printf '%s' "$key" | sed -n 's/^\([^:]\+\).*$/\1/p'`"
            parent="`printf '%s' "$key" | sed -n 's/^[^:]\+://p'`"
            object "$ParentList" set "$section" "$parent"
        fi
        this call next
    done
    
    # remove parent in section name
    object "$ParentList" rewind
    while object "$ParentList" valid; do
        section="`object "$ParentList" key`"
        parent="`object "$ParentList" current`"
        this call set "$section" "`this call get "$section:$parent"`"
        this call unset "$section:$parent"
        object "$ParentList" next
    done
    
    # extend sections
    this call rewind
    while this call valid; do
        key="`this call key`"
        object "$ParentList" isset "$key"
        parentKey="`object "$ParentList" get "$key"`"
        if [ -z "$parentKey" ]; then
            this call _extendsSectionsChild "$key" "$ParentList"
        fi
        this call next
    done
}

##
# Extends a child element of a sections
#
# $1    string      key
# $2    Bashor_List_Iterable  parent list
CLASS_Bashor_Config_Ini__extendsSectionsChild()
{
    local parentKey="$1"
    local ParentList="$2"
    local key section parent
    
    object "$ParentList" rewind
    while object "$ParentList" valid; do
        section="`object "$ParentList" key`"
        parent="`object "$ParentList" current`"
        if [ "$parent" = "$parentKey" ]; then
            object "`this call get "$section"`" mergeParent "`this call get "$parent"`"
            this call _extendsSectionsChild "$section" "$ParentList"
        fi
        object "$ParentList" next
    done
}

##
# Set a value from a ini line.
#
# $1    string      key
# $2    string      value
CLASS_Bashor_Config_Ini__setIniValue()
{
    if [[ "$1" =~ \. ]]; then
        local key config
        key="`printf '%s' "$1" | sed -n 's/^\([^.]\+\).*$/\1/p'`"
        if this call isset "$key"; then
            config="`this call get "$key"`"
            if ! isObject "$config"; then
                new "`static call getClass`" config
                this call set "$key" "$config"
            fi
        else
            new "`static call getClass`" config
            this call set "$key" "$config"
        fi
        key="`printf '%s' "$1" | sed -n 's/^[^.]\+[.]//p'`"
        object "$config" _setIniValue "$key" "$2"
    else
        this call set "$1" "$2"
    fi
}
