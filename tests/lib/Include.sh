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
# @version      $Id$
################################################################################

function CLASS_Include___construct()
{    
    : ${OBJECT:?}
    
    this set data "$1"
    
    loadClassOnce Include_Class
    local Include
    new Include_Class Include "$2"
    this set Include "$Include"
    
    return 0
}

function CLASS_Include_get()
{
    : ${OBJECT:?}
	
	this get data
    return "$?"
}

function CLASS_Include_getInclude()
{
    : ${OBJECT:?}
	
    local Include="`this get Include`";
	object "$Include" get
    return "$?"
}
