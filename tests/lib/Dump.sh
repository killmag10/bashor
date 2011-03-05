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
# @subpackage   Tests
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

function CLASS_Dump___construct()
{    
    : ${OBJECT:?}
        
    return 0
}

function CLASS_Dump_save()
{
    : ${OBJECT:?}
    
    this save
    return "$?"
}

function CLASS_Dump_load()
{
    : ${OBJECT:?}
    : ${1:?}
    
    this load "$1"
    return "$?"
}

function CLASS_Dump_set()
{
    : ${OBJECT:?}
    : ${1:?}
    : ${2?}
    
    this set "$1" "$2"
    return "$?"
}

function CLASS_Dump_get()
{
    : ${OBJECT:?}
    : ${1:?}
    
    this get "$1"
    return "$?"
}
