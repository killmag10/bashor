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
# @copyright    Copyright (c) 2010 Lars Dietrich, All rights reserved.
# @license      http://www.gnu.org/licenses/lgpl.html GNU Lesser General Public License
# @autor        Lars Dietrich <lars@dietrich-hosting.de>
# @version      $Id$
################################################################################

BASHOR_DIR=`echo "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASHOR_DIR" =~ ^/ ]]; then
    BASHOR_DIR=`echo "$PWD/$BASHOR_DIR" | sed 's#/\.\?$##'`;
fi

# Set paths
export BASHOR_DIR;
export BASHOR_DIR_FUNCTIONS="${BASHOR_DIR}/functions";
export BASHOR_DIR_INCLUDES="${BASHOR_DIR}/includes";

# Defaults
export BASHOR_CACHE_DIR="./cache";
export BASHOR_LOG_FILE="./error.log";
export BASHOR_REGISTRY_FILE="./registry";

# Load general functions
. "${BASHOR_DIR_INCLUDES}/functions.sh";

# Load Object Support
#. "${BASHOR_DIR_INCLUDES}/object.sh"
