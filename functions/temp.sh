#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License.
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @subpackage   Functions
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

export BASHOR_FUNCTION_TEMP_DIR="$BASHOR_TEMP_DIR";
if [ -n "$1" ]; then
    export BASHOR_FUNCTION_TEMP_DIR="$1";
fi

##
# Get a temp dir path.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &0    string  path
function temp_dir()
{
    : ${1:?};
    
    mkdir -p "$BASHOR_FUNCTION_TEMP_DIR/";
    echo -n "$BASHOR_FUNCTION_TEMP_DIR/"`temp_generateFilename "$1"`;
    return "$?";
}

##
# Get a temp file path.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &0    string  path
function temp_file()
{
    : ${1:?};

    echo "`temp_dir \"$1\"`"'.tmp';
    return "$?";
}

##
# Get a temp file name.
#
# $1    string  Id
# $?    0:OK    1:ERROR
# &0    string  name
function temp_generateFilename()
{
    : ${1?};

    echo 'temp_'`date +'%Y%m%dT%H%M%S'`"_""$$""_""$1""_""$RANDOM";
    return 0;
}

##
# Clear the temp dir.
#
# $?    0:OK    1:ERROR
function temp_clear {
    if [ -n "$BASHOR_FUNCTION_TEMP_DIR" ] && [ -d "$BASHOR_FUNCTION_TEMP_DIR" ]; then
        rm -r "$BASHOR_FUNCTION_TEMP_DIR/"*;
        return "$?";
    fi
}
