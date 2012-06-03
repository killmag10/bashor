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
# @version      $Id$
################################################################################

BASE_DIR=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASE_DIR" =~ ^/ ]]; then
    BASE_DIR=`echo "$PWD/$BASE_DIR" | sed 's#/\.\?$##'`;
fi

. "$BASE_DIR/../loader.sh";

parseFile()
{
    local Doc
    new Bashor_Doc_Block Doc
    #object "$Doc" setOption showPrivateFunctions '1'
    
    object "$Doc" parseFile "$1"    
    object "$Doc" sortByName

    local Item
    local IFS=$'\n'
    for Item in `object "$Doc" getItemsByType 'function'`; do
        new Bashor_Doc_Block_Decorator_Man Decorator "$Item"
        object $Decorator get;
        remove $Decorator;
    done
    remove $Doc
}

echo '
.\"
.\" Man page for Bashor
.\"
.TH Bashor 7 "'"$(date +'%Y-%m-%d')"'" "Lars Dietrich" "Bashor Coding Commands"
.SH Bashor
.B Bashor
\- an pseudo object extension for bash

.PD 0

';

echo '.SH GENERAL FUNCTIONS';
parseFile "$BASE_DIR/../includes/functions.sh"

echo '.SH CLASS / OBJECT FUNCTIONS';
parseFile "$BASE_DIR/../includes/functions/class.sh"

echo '.SH BASE CLASS METHODS';
parseFile "$BASE_DIR/../includes/Class.sh"
