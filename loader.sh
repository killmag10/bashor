#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3
# http://www.gnu.org/licenses/lgpl.html
# http://www.gnu.de/documents/lgpl.de.html
#
# @package      Bashor
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

BASHOR_PATH=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASHOR_PATH" =~ ^/ ]]; then
    BASHOR_PATH=`echo "$PWD/$BASHOR_PATH" | sed 's#/\.\?$##'`;
fi

shopt -s expand_aliases;
export NL=$'\n';
export nl="$NL";

# Set paths
export BASHOR_PATH;
export BASHOR_PATH_INCLUDES="${BASHOR_PATH}/includes";

export BASHOR_PATHS_CLASS="${BASHOR_PATH}/classes";
export BASHOR_PATHS_FUNCTIONS="${BASHOR_PATH}/functions";

# Defaults
[ -z "BASHOR_LOG_FILE" ] && export BASHOR_LOG_FILE="./error.log";
export BASHOR_MODE_COMPATIBLE="0";

[ -z "$BASHOR_PATH_CONFIG" ] && export BASHOR_PATH_CONFIG="${BASHOR_PATH}/config.sh";

. "$BASHOR_PATH_CONFIG";

# Add debuging channel
exec 3>&1;

# Load general functions
. "${BASHOR_PATH_INCLUDES}/functions.sh";
