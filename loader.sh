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

export BASHOR_FILE_LOG="error.log";

# Load general functions
. "${BASHOR_DIR_INCLUDES}/functions.sh";

# Load Object Support
#. "${BASHOR_DIR_INCLUDES}/object.sh"
