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
# @version      $Id: loader.sh 11 2010-03-11 21:41:42Z lars $
################################################################################

# Directorys
[ -z "$BASHOR_LOG_FILE" ] && export BASHOR_LOG_FILE="./error.log";

# Performance
export BASHOR_CLASS_AUTOLOAD="1";

# Compatibility
export BASHOR_BASE64_USE="base64"; # openssl|perl|base64
export BASHOR_USE_GETOPT="1"; # 0|1
export BASHOR_MODE_COMPATIBLE="0";

# Options
export BASHOR_ERROR_LOG="1";
export BASHOR_ERROR_OUTPUT="1";
export BASHOR_ERROR_BACKTRACE="1";

export BASHOR_WARNING_LOG="1";
export BASHOR_WARNING_OUTPUT="1";
export BASHOR_WARNING_BACKTRACE="1";

export BASHOR_DEBUG_LOG="1";
export BASHOR_DEBUG_OUTPUT="1";
export BASHOR_DEBUG_BACKTRACE="1";

# Bash options
set -B # enable brace expansion;
set +a # disable allexport
set +b # disable notify;
set +e # disable errexit;
set -i # enable interactive;
set +p # disable privileged (suid);
