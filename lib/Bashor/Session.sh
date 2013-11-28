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

loadClassOnce 'Bashor_Registry'
extends Bashor_Session Bashor_Registry

##
# Constructor
#
# $1    string  session dir
CLASS_Bashor_Session___construct()
{
    requireObject
    
    local Param
    new Bashor_Param Param 'c'
    object $Param set "$@"
    
    object $Param notEmpty "1" || error "session dir not set"
    local sessionDir="`object $Param get "1"`"

    local optionCompress=''
    object $Param isset '-c' && local optionCompress='-c'
    
    parent call __construct $optionCompress -- "$sessionDir""$$"
}
