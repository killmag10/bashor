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

function CLASS_Include___construct()
{    
    requireObject
    
    this set data "$1"
    
    loadClassOnce Include_Class
    local Include
    new Include_Class Include "$2"
    this set Include "$Include"
    
    return 0
}

function CLASS_Include_get()
{
    requireObject
	
	this get data
    return "$?"
}

function CLASS_Include_getInclude()
{
    requireObject
	
    local Include="`this get Include`";
	object "$Include" get
    return "$?"
}
