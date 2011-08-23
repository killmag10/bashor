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
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

loadClassOnce 'Bashor_Registry'
extends Bashor_Session Bashor_Registry

##
# Constructor
#
# $1    string  session dir
function CLASS_Bashor_Session___construct()
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
