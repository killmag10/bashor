#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2013 the bashor project authors. All rights reserved.
################################################################################

##
# Create the decorator object.
#
# $1    integer     line number
# $2    integer     iteration count
# $3    string      file line
CLASS_Bashor_Code_Coverage_File_Line___construct()
{
    requireObject
    requireParams RRS "$@"
    
    parent call __construct
    
    this set 'lineNumber' "$1"
    this set 'iterationCount' "$2"
    this set 'line' "$3"
}

##
# Get the line number in the file.
#
# &1    integer     line number
CLASS_Bashor_Code_Coverage_File_Line_getLineNumber()
{
    requireObject
    
    this get 'lineNumber'
    return $?
}

##
# Get the line.
#
# &1    string      file line
CLASS_Bashor_Code_Coverage_File_Line_getLine()
{
    requireObject
    
    this get 'line'
    return $?
}

##
# Get the line number in the file.
#
# &1    integer     iteration count
CLASS_Bashor_Code_Coverage_File_Line_getIterationCount()
{
    requireObject
    
    this get 'iterationCount'
    return $?
}
