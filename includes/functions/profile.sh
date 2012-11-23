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
# @subpackage   Includes
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: functions.sh 233 2012-11-21 15:39:21Z lars $
################################################################################

_PROFILE_START_TIMES=()
_PROFILE_CALLER=()
_PROFILE_OUTPUT=()
_PROFILE_OUTPUT_CALLS=()
_PROFILE_TIME=()


# [ -n "$BASHOR_PROFILE" ] && _profileMethodBegin

#echo "$BASHOR_PROFILE"
#exit;

_profileStart()
{
    if [ -z "$BASHOR_PROFILE_FILE" ]; then
        error "\$BASHOR_PROFILE = 1 put \$BASHOR_PROFILE_FILE not set!"
    fi

    _PROFILE_LAST_FN='main'

    {
        printf 'version: %s\n' '0.9.6'
        printf 'cmd: %s\n' "$0"
        printf 'part: %s\n' '1'
        printf '\n'
        printf 'events: %s\n' 'Time'
       # printf 'fn=%s\n' 'main'
       # printf "%s %s\n" "0" "0"
    } > "$BASHOR_PROFILE_FILE"
    
   _PROFILE_TIME[${#_PROFILE_TIME[@]}]=0
   _PROFILE_OUTPUT[${#_PROFILE_OUTPUT[@]}]=''
   _PROFILE_OUTPUT_CALLS[${#_PROFILE_OUTPUT_CALLS[@]}]=''
   _PROFILE_CALLER[${#_PROFILE_CALLER[@]}]="main"
   _PROFILE_START_TIMES[${#_PROFILE_START_TIMES[@]}]="`date +'%s%N'`"
   
   trap '_profileStop' EXIT
}

_profileMethodBegin()
{
   local currentCall="${1}:${2}"
   _PROFILE_TIME[${#_PROFILE_TIME[@]}]=0
   _PROFILE_OUTPUT[${#_PROFILE_OUTPUT[@]}]=''
   _PROFILE_OUTPUT_CALLS[${#_PROFILE_OUTPUT_CALLS[@]}]=''
   _PROFILE_CALLER[${#_PROFILE_CALLER[@]}]="$currentCall"
   _PROFILE_START_TIMES[${#_PROFILE_START_TIMES[@]}]="`date +'%s%N'`"
}

_profileMethodEnd()
{
    local endTime="`date +'%s%N'`"
    local currentCall="${1}::${2}"
    local startTime="${_PROFILE_START_TIMES[${#_PROFILE_START_TIMES[@]}-1]}"
    local usedTime=$(( endTime - startTime ))
    local usedOwnTime=$(( usedTime - _PROFILE_TIME[$((${#_PROFILE_TIME[@]}-1))] ))

    local filename=_BASHOR_LOADED_CLASS_"$1"
    filename="${!filename}"
    filename="`readlink -f "${filename}"`"

    local output=
    output+="fl=$filename"$'\n'
    output+="fn=$currentCall"$'\n'
    output+="${BASH_LINENO[2]} $usedOwnTime"$'\n'
    output+="${_PROFILE_OUTPUT_CALLS[$((${#_PROFILE_OUTPUT_CALLS[@]}-1))]}"$'\n'
    output+="${_PROFILE_OUTPUT[$((${#_PROFILE_OUTPUT[@]}-1))]}"
    _PROFILE_OUTPUT[$((${#_PROFILE_OUTPUT[@]}-2))]+="$output"
    
    local outputParent=
    outputParent+="cfl=$filename"$'\n'
    outputParent+="cfn=$currentCall"$'\n'
    outputParent+="calls=1 ${BASH_LINENO[2]}"$'\n'
    outputParent+="${BASH_LINENO[2]} $usedTime"$'\n'
    _PROFILE_OUTPUT_CALLS[$((${#_PROFILE_OUTPUT_CALLS[@]}-2))]+="$outputParent"
    local parentTime=${_PROFILE_TIME[$((${#_PROFILE_TIME[@]}-2))]}
    _PROFILE_TIME[$((${#_PROFILE_TIME[@]}-2))]=$(($parentTime + $usedTime))

    unset _PROFILE_OUTPUT[$((${#_PROFILE_OUTPUT[@]}-1))]
    unset _PROFILE_OUTPUT_CALLS[$((${#_PROFILE_OUTPUT_CALLS[@]}-1))]
    unset _PROFILE_CALLER[$((${#_PROFILE_CALLER[@]}-1))]
    unset _PROFILE_START_TIMES[$((${#_PROFILE_START_TIMES[@]}-1))]
    unset _PROFILE_TIME[$((${#_PROFILE_TIME[@]}-1))]
}

_profileStop()
{
    local endTime="`date +'%s%N'`"
    local currentCall="main"
    local startTime="${_PROFILE_START_TIMES[${#_PROFILE_START_TIMES[@]}-1]}"
    local usedTime=$(( endTime - startTime ))
    local usedOwnTime=$(( usedTime - _PROFILE_TIME[$((${#_PROFILE_TIME[@]}-1))] ))
    filename="$0"

    local output=
    output+="fl=`readlink -f "${filename}"`"$'\n'
    output+="fn=$currentCall"$'\n'
    output+="0 $usedOwnTime"$'\n'
    output+="${_PROFILE_OUTPUT_CALLS[$((${#_PROFILE_OUTPUT_CALLS[@]}-1))]}"$'\n'
    output+="${_PROFILE_OUTPUT[$((${#_PROFILE_OUTPUT[@]}-1))]}"

    printf '%s\n' "$output" >> "$BASHOR_PROFILE_FILE"

    unset _PROFILE_OUTPUT[$((${#_PROFILE_OUTPUT[@]}-1))]
    unset _PROFILE_OUTPUT_CALLS[$((${#_PROFILE_OUTPUT_CALLS[@]}-1))]
    unset _PROFILE_CALLER[$((${#_PROFILE_CALLER[@]}-1))]
    unset _PROFILE_START_TIMES[$((${#_PROFILE_START_TIMES[@]}-1))]
    unset _PROFILE_TIME[$((${#_PROFILE_TIME[@]}-1))]
}

[ -n "$BASHOR_PROFILE" ] && _profileStart
