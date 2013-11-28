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
# Constructor.
CLASS_Bashor_Output___construct()
{
    this set 'prefixes' ''
}

##
# Prepare each line.
#
# $1    string  prefix
CLASS_Bashor_Output_prepare()
{
    local IFS=$'\n'
    local prefixes=(`this get 'prefixes'`)
    local preString="${prefixes[*]}${1}"
    
    local msg IFS=$'\n'
    while read msg; do printf '%s\n' "${preString}${msg}"; done
}

##
# Prepare echo.
#
# @see echo
CLASS_Bashor_Output_echo()
{
    local IFS=$'\n'
    local prefixes=(`this get 'prefixes'`)
    IFS=
    printf '%s' "${prefixes[*]}"
    echo "$@"
}

##
# Prepare printf.
#
# @see printf
CLASS_Bashor_Output_printf()
{
    local IFS=$'\n'
    local prefixes=(`this get 'prefixes'`)
    IFS=
    printf '%s' "${prefixes[*]}"
    printf "$@"
}

##
# Add a prefix.
#
# $1    string  prefix
CLASS_Bashor_Output_addPrefix()
{    
    local IFS=$'\n'    
    local prefixes="`this get 'prefixes'`"
    this set 'prefixes' "${prefixes}${NL}${1:-    }"
}

##
# Remove last prefix.
CLASS_Bashor_Output_removePrefix()
{
    local IFS=$'\n'    
    local prefixes=(`this get 'prefixes'`)
    local level=${#prefixes[*]}
    ((--level))
    unset prefixes[$level]
    this set 'prefixes' "${prefixes[*]}"
}

##
# Remove complete prefix.
CLASS_Bashor_Output_clearPrefix()
{
    this set 'prefixes' ''
}
