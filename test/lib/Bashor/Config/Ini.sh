#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3 version 3.
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

loadClass 'Bashor_Config_Ini';
nl=$'\n';

new Bashor_Config_Ini Ini "$TEST_RESOURCE_DIR/test.ini"
checkSimple "new" "$?" "0";

show()
{
    object "$1" rewind
    while object "$1" valid; do
        local value="`object "$1" current`"
        echo "$2 [""`object "$1" key`""] = \"$value\""
        if isObject "$value"; then
            show "$value" "$2+++"
        fi
        object "$1" next
    done
}

testIniNode()
{
    local item="$1"
    local key IFS='.'
    for key in $2; do
        item="`object "$item" get "$key"`"
    done

    checkSimple "Node: $2" "$item" "$3"
}

testIniNode "$Ini" "base1.base.tree.string" 'test= base1'
testIniNode "$Ini" "base1.base.tree.number" '111'
testIniNode "$Ini" "base1.base.comment" ''
testIniNode "$Ini" "base1.;base" ''

testIniNode "$Ini" "base2.base.tree.string" 'test= base2'
testIniNode "$Ini" "base2.base.tree.number" '222'
testIniNode "$Ini" "base2.base.tree.float" '2.2'

testIniNode "$Ini" "extented1.base.tree.string" 'replace1'
testIniNode "$Ini" "extented1.base.next.string" 'extented1'
testIniNode "$Ini" "extented1.base.tree.number" '111'

testIniNode "$Ini" "extented2.base.tree" 'tree2'
testIniNode "$Ini" "extented2.base.next.string" 'extented1'
testIniNode "$Ini" "extented2.base.new.string" 'extented2'

#show "$Ini" "+++"

remove "$Ini"
checkSimple "remove" "$?" "0"
