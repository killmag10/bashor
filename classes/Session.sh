#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: registry.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

extends Session Registry;

##
# Constructor
#
# $1    string  registry dir
function CLASS_Session___construct()
{
    : ${1?};
    : ${OBJECT:?};
    
    optSetOpts 'c';
    optSetArgs "$@";
    
    this set compress "0";
    optIsset 'c' && this set compress "1";
    
    this set file "$1";
}
