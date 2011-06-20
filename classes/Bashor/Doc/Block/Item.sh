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
# @version      $Id: hash.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

##
# Constructor
#
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item___construct()
{
    : ${OBJECT:?}
    
    return 0
}

##
# Set the doc block contend.
#
# $1    string  doc block contend
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item_setDoc()
{
    : ${OBJECT:?}
    : ${1:?}
    
    this set docBlock "$1";
    return 0
}

##
# Set the line after the Doc Block.
#
# $1    string  doc block contend
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item_setLineAfter()
{
    : ${OBJECT:?}
    : ${1:?}
    
    this set lineAfter "$1";
    return 0
}

##
# Set the doc block type.
#
# $1    string  type of the block (function)
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item_setType()
{
    : ${OBJECT:?}
    : ${1:?}
    
    this set type "$1";
    return 0
}

##
# Get the line after the Doc Block.
#
# &1    string  line after
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item_getLineAfter()
{
    : ${OBJECT:?}
    
    this get lineAfter;
    return 0
}

##
# Get the doc block type.
#
# &1    string  block type
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item_getType()
{
    : ${OBJECT:?}
    
    this get type;
    return 0
}

##
# Get the doc block contend.
#
# &1    string  block doc contend
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item_getDoc()
{
    : ${OBJECT:?}
    
    this get docBlock;
    return 0
}

##
# Get the name of the element.
#
# &1    string  block doc contend
# $?    0       OK
# $?    1       ERROR
function CLASS_Bashor_Doc_Block_Item_getName()
{
    : ${OBJECT:?}
    
    case "`this call getType`" in
        function)
            this call getLineAfter | \
                sed -n 's/^[[:space:]]*\(function[[:space:]]\+\)\?\([_[:alnum:]]\+\).*$/\2/p'
            return 0
            ;;
    esac
    
    return 1
}
