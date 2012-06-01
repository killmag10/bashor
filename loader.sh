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
# @copyright    Copyright (c) 2011 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License version 3
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

BASHOR_PATH=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASHOR_PATH" =~ ^/ ]]; then
    BASHOR_PATH=`echo "$PWD/$BASHOR_PATH" | sed 's#/\.\?$##'`;
fi

# Set paths
BASHOR_PATH_INCLUDES="${BASHOR_PATH}/includes";
BASHOR_PATHS_CLASS="${BASHOR_PATH}/classes";

# Add Constants
. "${BASHOR_PATH_INCLUDES}/constants.sh";

# Defaults
NL=$'\n'
[ -z "BASHOR_LOG_FILE" ] && BASHOR_LOG_FILE="./error.log";
BASHOR_BACKTRACE_REMOVE=0;

# Load Config
. "${BASHOR_PATH}/config.sh"
[ -n "$BASHOR_PATH_CONFIG" ] && . "$BASHOR_PATH_CONFIG";

# Add debuging channel
exec 3>&2;

# Load general functions
. "${BASHOR_PATH_INCLUDES}/functions.sh";

[ -n "$BASHOR_ERROR_CLASS" ] && class Bashor_ErrorHandler setHandler;

