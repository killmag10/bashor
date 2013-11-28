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

##
# Constructor
CLASS_Bashor_Cache___construct()
{
    requireObject
    return 0
}

##
# Save in cache.
#
# $1    string  Id
# $2    string  Cachetime in seconds.
# $3    string  Data
# $?    0:OK    1:ERROR
# &0    string  Data
CLASS_Bashor_Cache_set()
{
    requireObject
    requireParams RR "$@"
    
    return 0
}

##
# Read from cache.
#
# $1    string  Id
# $?    0:CACHED    1:NOT CACHED
# &1    string Data 
CLASS_Bashor_Cache_get()
{
    requireObject
    requireParams R "$@"
    
    return 1
}

##
# Check if data cached.
#
# $1    string  Id
# $?    0:CACHED    1:NOT CACHED
CLASS_Bashor_Cache_check()
{
    requireObject
    requireParams R "$@"
    
    return 1
}

##
# Remove old cache files.
#
# $?    0:OK    1:ERROR
CLASS_Bashor_Cache_removeOutdated()
{
    requireObject
    
    return 1
}

