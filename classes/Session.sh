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
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

extends Session Registry;

##
# Constructor
#
# $1    string  session dir
function CLASS_Session___construct()
{
    : ${OBJECT:?};
    
    optSetOpts 'c';
    optSetArgs "$@";
    
    argIsset "1" || error "session dir not set";
    local sessionDir=`argValue "1"`;

    local optionCompress='';
    optIsset 'c' && local optionCompress='-c';
    
    parent call __construct $optionCompress -- "$sessionDir/$$";
}
