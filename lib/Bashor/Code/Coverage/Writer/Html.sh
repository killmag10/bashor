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

##
# Create the decorator object.
#
# $1    string      base path for code coverage
CLASS_Bashor_Code_Coverage_Writer_Html___construct()
{
    requireObject
    requireParams R "$@"
    
    local reportPath
    
    parent call __construct
    
    reportPath="`readlink -f "$1"`"
    [ "$?" != 0 ] && error "Coverage report path not found: \"$BASHOR_CODE_COVERAGE_REPORT_PATH\""
    
    this set 'reportPath' "$reportPath"
}

##
# Write the coverage file.
#
# $1    string                  relative file path
# $2    Bashor_List_Iterable    a list with Bashor_Code_Coverage_File_Line  
CLASS_Bashor_Code_Coverage_Writer_Html_decorate()
{    
    local line iterations
    local converageFile
    local list
    
    list="$2"

    converageFile="`this get 'reportPath'`""$1"'.coverage.html';
    converageDir="`dirname "$converageFile"`"
    mkdir -p "$converageDir";

cat - > "$converageFile" <<EOF
<!doctype html>
<html>
    <head>
        <title>Code Coverage</title>
        <style type="text/css">
            pre {
                margin: 0;
            }
        
            .codeUsed {
                background-color: #bfb
            }
            
            .codeUnused {
                background-color: #ddd
            }
        </style>
    </head>
    <body>
        <p>
EOF

{
    printf '<pre class="codeUnused">%6s|%7s| %s</pre>\n' "line" "calls" "code" 
    object "$list" rewind
    while object "$list" valid; do
        line="`object "$list" current`"
        iterations="`object "$line" getIterationCount`"

        if [ "$iterations" -gt 0 ]; then
            printf '<pre class="codeUsed">%6s|%7s| %s</pre>\n' \
                "`object "$line" getLineNumber`" \
                "$iterations" \
                "`object "$line" getLine | sed 's/</\&lt;/g;s/>/\&gt;/g'`"
            ((i++))
        else
            printf '<pre class="codeUnused">%6s|%7s| %s</pre>\n' \
                "`object "$line" getLineNumber`" \
                '' \
                "`object "$line" getLine | sed 's/</\&lt;/g;s/>/\&gt;/g'`"
        fi

        object "$list" next;
    done
} >> "$converageFile"
    
cat - >> "$converageFile" <<EOF
        </p>
    </body>
</html>
EOF

}
