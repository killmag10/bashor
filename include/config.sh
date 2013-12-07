#!/bin/bash
################################################################################
# Bashor Framework
#
# LICENSE:
# This software is released under the GNU Lesser General Public License version 3
# http://www.gnu.org/licenses/lgpl-3.0.txt
#
# Copyright 2010-2013 the bashor project authors. All rights reserved.
################################################################################

# Directorys
[ -z "$BASHOR_LOG_FILE" ] && BASHOR_LOG_FILE="./error.log";

# Performance
BASHOR_CLASS_AUTOLOAD='1';

# Compatibility
BASHOR_CODEING_METHOD='base64' # base64|hex
BASHOR_BASE64_USE='base64'; # openssl|perl|base64
BASHOR_USE_GETOPT='1'; # 0|1
BASHOR_COMPATIBILITY_THIS='' # ''|1

# Options
BASHOR_INTERACTIVE='';

BASHOR_ERROR_CLASS='1';

BASHOR_ERROR_LOG='';
BASHOR_ERROR_OUTPUT='1';
BASHOR_ERROR_BACKTRACE='1';

BASHOR_WARNING_LOG='';
BASHOR_WARNING_OUTPUT='1';
BASHOR_WARNING_BACKTRACE='1';

BASHOR_DEBUG_LOG='';
BASHOR_DEBUG_OUTPUT='1';
BASHOR_DEBUG_BACKTRACE='1';

# Profiling
[ -z "$BASHOR_PROFILE" ] && BASHOR_PROFILE=
[ -z "$BASHOR_PROFILE_FILE" ] && BASHOR_PROFILE_FILE='profile.log'

# Bash options
set -B # enable brace expansion;
set +a # disable allexport
set +b # disable notify;
set +e # disable errexit;
#set -i # enable interactive;
set +p # disable privileged (suid);
