# Include base functions.
. "${BASHOR_PATH_INCLUDES}/function/base.sh"

# Include getopt function
if [ "$BASHOR_USE_GETOPT" = 1 ]; then
    . "$BASHOR_PATH_INCLUDES/function/getopt.sh"
else
    . "$BASHOR_PATH_INCLUDES/function/getopts.sh"
fi

# Include class functions.
. "$BASHOR_PATH_INCLUDES/function/class.sh"

# Include profiling.
[ -n "$BASHOR_PROFILE" ] && . "$BASHOR_PATH_INCLUDES/function/profile.sh"

# Include array support.
#. "$BASHOR_PATH_INCLUDES/function/class/array.sh"

# Load base class.
. "$BASHOR_PATH_CLASSES/Class.sh"
addClass Class

