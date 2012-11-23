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
_PROFILE_REMATCH_CLASS=()
_PROFILE_OUTPUT=()
_PROFILE_OUTPUT_CALLS=()
_PROFILE_TIME=()
_PROFILE_LEVEL=0


_profileStart()
{
    if [ -z "$BASHOR_PROFILE_FILE" ]; then
        error "\$BASHOR_PROFILE = 1 put \$BASHOR_PROFILE_FILE not set!"
    fi

    {
        printf 'version: %s\n' '1.0.0'
        printf 'cmd: %s\n' "$0"
        printf 'part: %s\n' '1'
        printf 'events: %s\n' 'Time'
        printf '\n'
    } > "$BASHOR_PROFILE_FILE"
    
   _PROFILE_TIME[$_PROFILE_LEVEL]=0
   _PROFILE_OUTPUT[$_PROFILE_LEVEL]=''
   _PROFILE_OUTPUT_CALLS[$_PROFILE_LEVEL]=''
   _PROFILE_CALLER[$_PROFILE_LEVEL]="main"
   _PROFILE_REMATCH_CLASS[$_PROFILE_LEVEL]=
   _PROFILE_START_TIMES[$_PROFILE_LEVEL]="`date +'%s%N'`"
   
   trap '_profileStop' EXIT
}

_profileMethodBegin()
{
   ((_PROFILE_LEVEL++))
   _PROFILE_START_TIMES[$_PROFILE_LEVEL]="`date +'%s%N'`"
   _PROFILE_TIME[$_PROFILE_LEVEL]=0
   _PROFILE_OUTPUT[$_PROFILE_LEVEL]=''
   _PROFILE_OUTPUT_CALLS[$_PROFILE_LEVEL]=''
   _PROFILE_CALLER[$_PROFILE_LEVEL]="${1}:${2}"
   _PROFILE_REMATCH_CLASS[$_PROFILE_LEVEL]=
}

_profileMethodRematch()
{
    _PROFILE_REMATCH_CLASS[$_PROFILE_LEVEL]="$1"
}

_profileMethodEnd()
{
    local className="${1}"
    [ -n "${_PROFILE_REMATCH_CLASS[$_PROFILE_LEVEL]}" ] \
        && className="${_PROFILE_REMATCH_CLASS[$_PROFILE_LEVEL]}"
    local currentCall="${className}::${2}"
    local filename=_BASHOR_LOADED_CLASS_"$className"
    filename="${!filename}"
    filename="`readlink -f "${filename}"`"

    # FUNCTION
    local output=
    output+="fl=$filename"$'\n'
    output+="fn=$currentCall"$'\n'
    # CALL
    local parentTime=${_PROFILE_TIME[$((_PROFILE_LEVEL-1))]}
    local outputParent=
    outputParent+="cfl=$filename"$'\n'
    outputParent+="cfn=$currentCall"$'\n'
    outputParent+="calls=1 ${BASH_LINENO[2]}"$'\n'

    local startTime endTime usedTime usedOwnTime
    startTime="${_PROFILE_START_TIMES[$_PROFILE_LEVEL]}"
    endTime="`date +'%s%N'`"
    usedTime=$(( endTime - startTime ))
    usedOwnTime=$(( usedTime - _PROFILE_TIME[$_PROFILE_LEVEL] ))

    # FUNCTION
    output+="${BASH_LINENO[2]} $usedOwnTime"$'\n'
    output+="${_PROFILE_OUTPUT_CALLS[$((${#_PROFILE_OUTPUT_CALLS[@]}-1))]}"$'\n'
    output+="${_PROFILE_OUTPUT[$((${#_PROFILE_OUTPUT[@]}-1))]}"
    _PROFILE_OUTPUT[$((_PROFILE_LEVEL-1))]+="$output"
    # CALL
    outputParent+="${BASH_LINENO[2]} $usedTime"$'\n'
    _PROFILE_OUTPUT_CALLS[$((_PROFILE_LEVEL-1))]+="$outputParent"
    _PROFILE_TIME[$((_PROFILE_LEVEL-1))]=$(($parentTime + $usedTime))

    unset _PROFILE_OUTPUT[$_PROFILE_LEVEL]
    unset _PROFILE_OUTPUT_CALLS[$_PROFILE_LEVEL]
    unset _PROFILE_CALLER[$_PROFILE_LEVEL]
    unset _PROFILE_REMATCH_CLASS[$_PROFILE_LEVEL]
    unset _PROFILE_START_TIMES[$_PROFILE_LEVEL]
    unset _PROFILE_TIME[$_PROFILE_LEVEL]
    ((_PROFILE_LEVEL--))
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

    unset _PROFILE_OUTPUT[$_PROFILE_LEVEL]
    unset _PROFILE_OUTPUT_CALLS[$_PROFILE_LEVEL]
    unset _PROFILE_CALLER[$_PROFILE_LEVEL]
    unset _PROFILE_REMATCH_CLASS[$_PROFILE_LEVEL]
    unset _PROFILE_START_TIMES[$_PROFILE_LEVEL]
    unset _PROFILE_TIME[$_PROFILE_LEVEL]
}

[ -n "$BASHOR_PROFILE" ] && _profileStart
