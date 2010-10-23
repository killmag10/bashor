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
# @subpackage   Class
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: escape.sh 16 2010-03-12 23:35:45Z lars $
################################################################################

##
# Loader.
function CLASS_Bashor_Output___load()
{
    this set 'prefixes' '';
}

##
# Constructor.
function CLASS_Bashor_Output___construct()
{
    this set 'prefixes' '';
}

##
# Prepare each line.
#
# $1    string  prefix
function CLASS_Bashor_Output_prepare()
{
    local IFS="$NL";   
    local prefixes=(`this get 'prefixes'`); 
    local IFS="";   
    local preString="${prefixes[*]}${1}";
    
    local IFS="$NL";
    while read msg; do echo "${preString}${msg}"; done
}

##
# Prepare echo.
#
# @see echo
function CLASS_Bashor_Output_echo()
{
    local IFS="$NL";   
    local prefixes=(`this get 'prefixes'`); 
    local IFS="";
    echo -n "${prefixes[*]}";
    echo "$@";
}

##
# Add a prefix.
#
# $1    string  prefix
function CLASS_Bashor_Output_addPrefix()
{    
    local IFS="$NL";
    
    local prefixes="`this get 'prefixes'`";  
    this set 'prefixes' "${prefixes}${NL}${1:-    }";
}

##
# Remove last prefix.
function CLASS_Bashor_Output_removePrefix()
{
    local IFS="$NL";
    
    local prefixes=(`this get 'prefixes'`);  
    local level=${#prefixes[*]};
    ((--level));
    unset prefixes[$level];
    this set 'prefixes' "${prefixes[*]}";
}

##
# Remove complete prefix.
function CLASS_Bashor_Output_clearPrefix()
{
    this set 'prefixes' '';
}
