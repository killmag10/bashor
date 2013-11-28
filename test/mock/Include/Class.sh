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
