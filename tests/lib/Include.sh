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

function CLASS_Include___construct()
{    
    : ${OBJECT:?}
    
    this set data "$1"
    
    loadClassOnce Include_Class
    new local Include_Class Include "$2"
    
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
	
	object local Include get
    return "$?"
}
