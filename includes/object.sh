#!bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Includes
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

function bashor_class {
    local full="$*";
    local name=`echo "$full" | sed -n 's#^\(\S\+\).*$#\1#p'`
    local extends=`echo "$full" | sed -n 's#^.*extends\s\+\(\S\+\).*$#\1#p'`
        
    local objString="class $name"
    if [ -n "$extends" ]; then
        local objString+=" extends $extends"
    fi
    eval "$name='$objString;';";
    eval "alias $name='bashor_class_call \"$1\"'";
}

function bashor_class_call {
    case "$2" in
        function)
            
            ;;
    esac
}

function bashor_class_function {
    eval "$1='class $1;';";
}

alias class='bashor_class';
