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

CLASS_Include_Class___load()
{    
    static set staticData '123abc'
    
    return 0
}

CLASS_Include_Class___construct()
{    
    requireObject
    
    this set objectData "$1"
    
    return 0
}

CLASS_Include_Class___destruct()
{    
    requireObject
    
    return 0
}

CLASS_Include_Class_get()
{
    requireObject
	
	this get objectData
    return "$?"
}
