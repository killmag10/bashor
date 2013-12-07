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

_bashor_profile_START_TIMES=()
_bashor_profile_CALLER=()
_bashor_profile_REMATCH_CLASS=()
_bashor_profile_OUTPUT=()
_bashor_profile_OUTPUT_CALLS=()
_bashor_profile_TIME=()
_bashor_profile_LEVEL=0


_bashor_profileStart()
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
    
   _bashor_profile_TIME[$_bashor_profile_LEVEL]=0
   _bashor_profile_OUTPUT[$_bashor_profile_LEVEL]=''
   _bashor_profile_OUTPUT_CALLS[$_bashor_profile_LEVEL]=''
   _bashor_profile_CALLER[$_bashor_profile_LEVEL]="main"
   _bashor_profile_REMATCH_CLASS[$_bashor_profile_LEVEL]=
   _bashor_profile_START_TIMES[$_bashor_profile_LEVEL]="`date +'%s%N'`"
   
   trap '_bashor_profileStop' EXIT
}

_bashor_profileMethodBegin()
{
   ((_bashor_profile_LEVEL++))
   _bashor_profile_START_TIMES[$_bashor_profile_LEVEL]="`date +'%s%N'`"
   _bashor_profile_TIME[$_bashor_profile_LEVEL]=0
   _bashor_profile_OUTPUT[$_bashor_profile_LEVEL]=''
   _bashor_profile_OUTPUT_CALLS[$_bashor_profile_LEVEL]=''
   _bashor_profile_CALLER[$_bashor_profile_LEVEL]="${1}:${2}"
   _bashor_profile_REMATCH_CLASS[$_bashor_profile_LEVEL]=
}

_bashor_profileMethodRematch()
{
    _bashor_profile_REMATCH_CLASS[$_bashor_profile_LEVEL]="$1"
}

_bashor_profileMethodEnd()
{
    if [ -n "$1" ]; then
        local className="${1}"
        [ -n "${_bashor_profile_REMATCH_CLASS[$_bashor_profile_LEVEL]}" ] \
            && className="${_bashor_profile_REMATCH_CLASS[$_bashor_profile_LEVEL]}"
        local currentCall="${className}::${2}"
        local filename=_BASHOR_LOADED_CLASS_"$className"
        filename="${!filename}"
        filename="`readlink -f "${filename}"`"
    else
        local currentCall="$2"
        local filename="${BASH_SOURCE[$3]}"
        filename="`readlink -f "${filename}"`"
    fi

    # FUNCTION
    local output=
    output+="fl=$filename"$'\n'
    output+="fn=$currentCall"$'\n'
    # CALL
    local parentTime=${_bashor_profile_TIME[$((_bashor_profile_LEVEL-1))]}
    local outputParent=
    outputParent+="cfl=$filename"$'\n'
    outputParent+="cfn=$currentCall"$'\n'
    outputParent+="calls=1 ${BASH_LINENO[$3]}"$'\n'

    local startTime endTime usedTime usedOwnTime
    startTime="${_bashor_profile_START_TIMES[$_bashor_profile_LEVEL]}"
    endTime="`date +'%s%N'`"
    usedTime=$(( endTime - startTime ))
    usedOwnTime=$(( usedTime - _bashor_profile_TIME[$_bashor_profile_LEVEL] ))

    # FUNCTION
    output+="${BASH_LINENO[$3]} $usedOwnTime"$'\n'
    output+="${_bashor_profile_OUTPUT_CALLS[$((${#_bashor_profile_OUTPUT_CALLS[@]}-1))]}"$'\n'
    output+="${_bashor_profile_OUTPUT[$((${#_bashor_profile_OUTPUT[@]}-1))]}"
    _bashor_profile_OUTPUT[$((_bashor_profile_LEVEL-1))]+="$output"
    # CALL
    outputParent+="${BASH_LINENO[2]} $usedTime"$'\n'
    _bashor_profile_OUTPUT_CALLS[$((_bashor_profile_LEVEL-1))]+="$outputParent"
    _bashor_profile_TIME[$((_bashor_profile_LEVEL-1))]=$(($parentTime + $usedTime))

    unset _bashor_profile_OUTPUT[$_bashor_profile_LEVEL]
    unset _bashor_profile_OUTPUT_CALLS[$_bashor_profile_LEVEL]
    unset _bashor_profile_CALLER[$_bashor_profile_LEVEL]
    unset _bashor_profile_REMATCH_CLASS[$_bashor_profile_LEVEL]
    unset _bashor_profile_START_TIMES[$_bashor_profile_LEVEL]
    unset _bashor_profile_TIME[$_bashor_profile_LEVEL]
    ((_bashor_profile_LEVEL--))
}

_bashor_profileStop()
{
    local endTime="`date +'%s%N'`"
    local currentCall="main"
    local startTime="${_bashor_profile_START_TIMES[${#_bashor_profile_START_TIMES[@]}-1]}"
    local usedTime=$(( endTime - startTime ))
    local usedOwnTime=$(( usedTime - _bashor_profile_TIME[$((${#_bashor_profile_TIME[@]}-1))] ))
    filename="$0"

    local output=
    output+="fl=`readlink -f "${filename}"`"$'\n'
    output+="fn=$currentCall"$'\n'
    output+="0 $usedOwnTime"$'\n'
    output+="${_bashor_profile_OUTPUT_CALLS[$((${#_bashor_profile_OUTPUT_CALLS[@]}-1))]}"$'\n'
    output+="${_bashor_profile_OUTPUT[$((${#_bashor_profile_OUTPUT[@]}-1))]}"

    printf '%s\n' "$output" >> "$BASHOR_PROFILE_FILE"

    unset _bashor_profile_OUTPUT[$_bashor_profile_LEVEL]
    unset _bashor_profile_OUTPUT_CALLS[$_bashor_profile_LEVEL]
    unset _bashor_profile_CALLER[$_bashor_profile_LEVEL]
    unset _bashor_profile_REMATCH_CLASS[$_bashor_profile_LEVEL]
    unset _bashor_profile_START_TIMES[$_bashor_profile_LEVEL]
    unset _bashor_profile_TIME[$_bashor_profile_LEVEL]
}

##
# Helper for profiling
#
# $1    string  class name
# $2    string  function/method name
# $3    string  levels back to call
# $?    0       OK
# $?    1       ERROR
_bashor_profileMethodHelper()
{
    if [ -z "$BASHOR_PROFILE" ]; then
        shift 3
        "$@"
        return $?
    fi
    
    local _bashor_temp_profile_className="$1"
    local _bashor_temp_profile_functionName="$2"
    local _bashor_temp_profile_levelsToCall="$(($3+1))"
    shift 3
    
    _bashor_profileMethodBegin \
        "$_bashor_temp_profile_className" \
        "$_bashor_temp_profile_functionName" \
        "$_bashor_temp_profile_levelsToCall"
    "$@"
    local _bashor_temp_return=$?
    _bashor_profileMethodEnd \
        "$_bashor_temp_profile_className" \
        "$_bashor_temp_profile_functionName" \
        "$_bashor_temp_profile_levelsToCall"
    return $_bashor_temp_return
}

_bashor_profileStart
