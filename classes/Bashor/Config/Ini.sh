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
# @subpackage   Classes
# @copyright    Copyright (c) 2012 Lars Dietrich, All rights reserved.
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
    this set 'file' "$1"
    
    [ -n "$1" ] || return 0;
    [ -e "$1" ] || error 'File "'"$1"'" does not exists!'
    
    this call _readFile
    this call _extendsSections
}

##
# Read the ini file content
CLASS_Bashor_Config_Ini__readFile()
{
    requireObject
    
    local keyCache
    new Bashor_List_Data keyCache
    local section line key
    while read line; do
        [[ "$line" =~ ^[[:space:]]*\; ]] && continue
        if [[ "$line" =~ [[:alnum:]\.]+[[:space:]]*= ]]; then
            key="${line%%=*}"
            key="${key%% *}"
            this call _setIniValue "$section.$key" \
                "`printf '%s' "$line" | sed 's/^[[:alnum:]\.]\+[[:space:]]*=[[:space:]]*//;s/^\"\(.*\)\"$/\1/'`" \
                "$keyCache"
        else
            if [[ "$line" =~ ^\[[^\]]+\]\s*$ ]]; then
                section="${line#[}"
                section="${section%]*}"
            fi
        fi
    done < "`this get 'file'`"
    remove keyCache;
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
            object "$ParentList" set "${key%%:*}" "${key#*:}"
        fi
        this call next
    done
    
    # remove parent in section name
    object "$ParentList" rewind
    while object "$ParentList" valid; do
        section="`object "$ParentList" key`"
        parent="`object "$ParentList" current`"
        this call _set "$section" "`this call get "$section:$parent"`"
        this call _unset "$section:$parent"
        object "$ParentList" next
    done
    
    # extend sections
    this call rewind
    while this call valid; do
        key="`this call key`"
        if ! object "$ParentList" isset "$key"; then
            this call _extendsSectionsChild "$key" "$ParentList"
        fi
        this call next
    done
    
    remove ParentList
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
    local section parent
    
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
    local i key parentConfig= cacheKey cacheResult IFS=.
    local config="`this pointer`"
    local -a list=()
    local currentClass="`static call getClass`"
    local keyCache="$3"
    
    cacheKey="${1%.*}"
    for key in $1; do
        list[${#list[@]}]=$key
    done
    
    cacheResult="`object "$keyCache" get "$cacheKey"`"
    if [ -z "$cacheResult" ]; then
        for (( i=0 ; i < $((${#list[@]} - 1)) ; i++ )); do
            parentConfig="$config"
            if object "$config" isset "${list[i]}"; then
                config="`object "$config" get "${list[i]}"`"
                if ! isObject "$config"; then
                    new "$currentClass" config
                    object "$parentConfig" _set "${list[i]}" "$config"
                fi
            else
                new "$currentClass" config
                object "$parentConfig" _set "${list[i]}" "$config"
            fi
        done
        object "$keyCache" set "$cacheKey" "$config"
    else
        config="$cacheResult"
        i=$((${#list[@]} - 1))
    fi
    
    object "$config" _set "${list[i]}" "$2"
}
