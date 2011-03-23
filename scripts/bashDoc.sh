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
# @subpackage   Scripts
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id: functions.sh 56 2010-04-25 22:49:54Z lars $
################################################################################

BASE_DIR=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASE_DIR" =~ ^/ ]]; then
    BASE_DIR=`echo "$PWD/$BASE_DIR" | sed 's#/\.\?$##'`;
fi

function parseFile()
{
    :   ${1:?}   

    local NL=$'\n';

    local content="`cat "$1"`";
    local docBlock=
    local inDocBlock=
    
    local line IFS=$'\n';
    for line in $content; do
        # Doc Block Begins?
        if [[ "$line" =~ ^[[:space:]]*\#\# ]]; then
            inDocBlock=1;
            docBlock=
            continue;
        fi
        
        # Alredy in Doc Block?
        [ -n "$inDocBlock" ] || continue;
        
        if [[ "$line" =~ ^[[:space:]]*\# ]]; then
            line="`echo "$line" | sed 's/^[[:space:]]*\#[[:space:]]*//'`"
            docBlock="${docBlock}\"${line}\"${NL}"
            continue;
        fi
        
        parseDocBlock "$docBlock" "$line"
        inDocBlock=;
        docBlock=;
        
    done;
}

function parseDocBlock()
{
    if [[ "$2" =~ ^[[:space:]]*function[[:space:]]+[[:alnum:]]+ ]]; then
        createFunctionManuel "$1" "$2"
    fi
}

function createFunctionManuel()
{
    local functionName="`echo "$2" | \
        sed -n 's/^[[:space:]]*function[[:space:]]\+\([[:alnum:]]\+\).*$/\1/p'`"
        
    echo '.TP';
    echo '.B '"$functionName";
    echo '.RS'
    
    local regex replace
    local line IFS=$'\n';
    for line in $1; do
        line="`echo "$line" | sed -n 's/^"\(.*\)"$/\1/p'`"
        
        if [[ "$line" =~ ^[[:space:]]*[\$\&][0-9@]+ ]]; then
            echo '.HP'
            regex='^[[:space:]]*\([\$\&][0-9@]\+\)[[:space:]]\+\([[:alpha:]|]\+\)[[:space:]]\+';
            replace='.B \1\n.I \2\n'
            echo "$line" \
                | sed 's/'"$regex"'/'"$replace"'/'
            continue;
        fi        
        if [[ "$line" =~ ^[[:space:]]*\$\? ]]; then
            echo '.HP'
            regex='^[[:space:]]*\(\$?\+\)[[:space:]]\+\([[:digit:]\*]\+\)[[:space:]]\+';
            replace='.B \1\n.I \2\n'
            echo "$line" \
                | sed 's/'"$regex"'/'"$replace"'/'
            continue;
        fi
        if [[ -z "$line" ]]; then
            echo;
            continue;
        fi
        echo "$line";
    done  
    
    echo '.RE'
    echo
}

echo '
.\"
.\" Man page for Bashor
.\"
.TH Bashor 7 "2011-03-20" "Lars Dietrich" "Bashor Coding Commands"
.SH Bashor
.B Bashor
\- an pseudo object extension for bash

.PD 0

.SH GENERAL FUNCTIONS
';

parseFile "$BASE_DIR/../includes/functions.sh"

echo '.SH CLASS / OBJECT FUNCTIONS';

parseFile "$BASE_DIR/../includes/functions/class.sh"
