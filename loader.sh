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

BASHOR_PATH=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`
if [[ ! "$BASHOR_PATH" =~ ^/ ]]; then
    BASHOR_PATH=`echo "$PWD/$BASHOR_PATH" | sed 's#/\.\?$##'`
fi

# Set paths
BASHOR_PATH_INCLUDES="${BASHOR_PATH}/include"
BASHOR_PATH_CLASSES="${BASHOR_PATH}/lib"
BASHOR_PATHS_CLASS="${BASHOR_PATH_CLASSES}"

# Add Constants
. "${BASHOR_PATH_INCLUDES}/constant.sh"

# Defaults
NL=$'\n'
[ -z "BASHOR_LOG_FILE" ] && BASHOR_LOG_FILE="./error.log"
BASHOR_BACKTRACE_REMOVE=0;
[ -n "$PS1" ] && BASHOR_INTERACTIVE=1

# Load Config
. "${BASHOR_PATH_INCLUDES}/config.sh"
[ -n "$BASHOR_PATH_CONFIG" ] && . "$BASHOR_PATH_CONFIG"

# Add debuging channel
exec 3>&2

# Load functions
. "${BASHOR_PATH_INCLUDES}/function.sh"

if [ -n "$BASHOR_ERROR_CLASS" ]; then
    loadClassOnce Bashor_ErrorHandler
    class Bashor_ErrorHandler setHandler
fi

