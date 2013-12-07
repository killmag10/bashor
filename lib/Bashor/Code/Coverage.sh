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

loadClassOnce 'Bashor_List_Iterable'
loadClassOnce 'Bashor_Code_Coverage_File_Line'

##
# Init class.
CLASS_Bashor_Code_Coverage___load()
{    
    requireStatic
    
    static set 'verbose' ''
}

##
# Start the code coverage.
#
# $1    string      base path for code coverage
# $2?   string      log file path for code coverage
CLASS_Bashor_Code_Coverage_start()
{    
    requireStatic
    requireParams R "$@"
    
    local basePath
    
    basePath="`readlink -e "$1"`"
    if [ "$?" != 0 ]; then
        error "Coverage base path not found: \"$1\""
    fi
    
    BASHOR_CODE_COVERAGE_LOG_FILE='codeCoverage.log'
    if [ -n "$2" ]; then
        BASHOR_CODE_COVERAGE_LOG_FILE="$2"
    fi
    
    static set 'basePath' "$basePath"

    [ -f "$BASHOR_CODE_COVERAGE_LOG_FILE" ] && rm "$BASHOR_CODE_COVERAGE_LOG_FILE"
    
    set -T
    trap 'printf "%s:%s\n" "$BASH_SOURCE" "$LINENO" >> "$BASHOR_CODE_COVERAGE_LOG_FILE"' DEBUG
}

##
# Start the code coverage.
#
# $1    boolean      verbose output on stderr
CLASS_Bashor_Code_Coverage_setVerbose()
{    
    requireStatic
    requireParams S "$@"
    
    static set 'verbose' "$1"
}

##
# Write the coverage file.
#
# $1                string      file
# $2                string      decorator object
# $lineNumbers      [integer]   the line numbers what was used.
# $lineIterations   [integer]   the line iterations.
CLASS_Bashor_Code_Coverage__writeCoverage()
{
    requireStatic
    
    local -i i=0
    local -i pos=0
    local line IFS=$'\n'
    local basePath=
    local realFilePath
    local relativeFilePath
    local list
    local FileLine

    basePath="`static get 'basePath'`"
    realFilePath="`readlink -e "$1"`"
    
    if ! [[ "$realFilePath" =~ ^"$basePath"/ ]]; then
        return 1
    fi    
    relativeFilePath="${reportPath}/${realFilePath#$basePath/}";

    # Subshell so no list object cleanup (remove) must be done. (performance)
    (
        new Bashor_List_Iterable list
        
        while read -r line; do
            ((pos++))
            if [ "${lineNumbers[$i]}" = "$pos" ]; then
                new Bashor_Code_Coverage_File_Line FileLine "$pos" "${lineIterations[$i]}" "$line"
                ((i++))
            else
                new Bashor_Code_Coverage_File_Line FileLine "$pos" '0' "$line"
            fi
            
            object "$list" add "$FileLine"
        done < "$1"
        
        [ -n "`static get 'verbose'`" ] \
            && printf 'Decorate coverage: %s\n' "$relativeFilePath" >&2
        object "$2" decorate "$relativeFilePath" "$list"
    )
    
    return 0
}

##
# Stop the code coverage.
#
# $1    object      a writer object
CLASS_Bashor_Code_Coverage_stop()
{
    requireStatic
    requireParams R "$@"
    
    trap DEBUG
    
    [ -n "`static get 'verbose'`" ] && printf 'Writing coverages.\n' >&2
    
    sort -t':' -k1,1 -k2,100n "$BASHOR_CODE_COVERAGE_LOG_FILE" \
        | uniq -c \
        | sed 's/^\s*\([0-9]\+\)\s/\1:/' \
        > "$BASHOR_CODE_COVERAGE_LOG_FILE"'.tmp'
    mv "$BASHOR_CODE_COVERAGE_LOG_FILE"'.tmp' "$BASHOR_CODE_COVERAGE_LOG_FILE"
    
    local line IFS=$'\n'
    local -i i=0
    local lineNumbers=()
    local lineIterations=()
    local content
    local lastFile=
    while read -r line; do
        file="`printf '%s' "$line" | cut -d ':' -f 2`"
        
        if [ -n "$lastFile" ]; then
            if [ "$lastFile" != "$file" ]; then
                wait
                static call _writeCoverage "$lastFile"  "$1" &
                i=0
                lineNumbers=()
                lineIterations=()
                [ -n "`static get 'verbose'`" ] \
                    && printf 'Process coverage: %s\n' "$file" >&2
            fi
        else
            [ -n "`static get 'verbose'`" ] \
                && printf 'Process coverage: %s\n' "$file" >&2            
        fi
        
        lineNumbers["$i"]="`printf '%s' "$line" | cut -d ':' -f 3`"
        lineIterations["$i"]="`printf '%s' "$line" | cut -d ':' -f 1`"
        ((i++))
        
        lastFile="$file"
    done < "$BASHOR_CODE_COVERAGE_LOG_FILE"
    wait
    
    if [ -n "$lastFile" ]; then
        static call _writeCoverage "$lastFile" "$1"
    fi
    
    [ -n "`static get 'verbose'`" ] \
        && printf 'Coverages Finished.\n' >&2
    
    return 0
}
