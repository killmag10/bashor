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
# @version      $Id: Session.sh 185 2011-08-29 22:09:38Z lars $
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
    file="$1"
    set 'file' "$file"
    
    [ -n "$file" ] || return 0;
    [ -e "$file" ] || error 'File does not exists!'
    
    local section line key value
    while read line; do
        [[ "$line" = ^\; ]] && continue
        if [[ "$line" =~ ^\[[^\]]+\]$ ]]; then
            section="`printf '%s' "$line" | sed 's/^[[:space:]]*\[//;s/\][[:space:]]*$//'`"
        fi
        if [[ "$line" =~ [[:alnum:]\.]+[[:space:]]*= ]]; then
            key="`printf '%s' "$line" | sed 's/[[:space:]]*=.*$//'`"
            value="`printf '%s' "$line" | sed 's/[[:alnum:]\.]\+[[:space:]]*=[[:space:]]*//;s/^\"\(.*\)\"$/\1/'`"
            this call _setIniValue "$section.$key" "$value"
        fi
    done < "$file"
    
    this call _linkSections
}

CLASS_Bashor_Config_Ini__linkSections()
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
            this call _linkSectionsChild "$key" "$ParentList"
        fi
        this call next
    done
}

CLASS_Bashor_Config_Ini__linkSectionsChild()
{
    local parentKey="$1"
    local ParentList="$2"
    local key section parent item itemParent
    
    object "$ParentList" rewind
    while object "$ParentList" valid; do
        section="`object "$ParentList" key`"
        parent="`object "$ParentList" current`"
        if [ "$parent" = "$parentKey" ]; then
            item="`this call get "$section"`"
            itemParent="`this call get "$parent"`"
            object "$item" mergeParent "$itemParent"
            this call _linkSectionsChild "$section" "$ParentList"
        fi
        object "$ParentList" next
    done
}

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
        newKey="`printf '%s' "$1" | sed -n 's/^[^.]\+[.]//p'`"
        object "$config" _setIniValue "$newKey" "$2"
    else
        this call set "$1" "$2"
    fi
}
