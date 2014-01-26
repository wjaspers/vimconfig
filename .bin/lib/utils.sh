#!/bin/bash

#
# Hang on to the folder we started from.
#
EXECUTED_FROM=$(pwd)

#
# Let bash output everything if we're in verbose mode.
# and we're trying to debug the script.
#
if [[ $VERBOSE -ne 0 && $DEBUG -ne 0 ]]; then
    set -x
fi

#
# http://stackoverflow.com/questions/3231804/in-bash-how-to-add-are-you-sure-y-n-to-any-command-or-alias
#
# IMPORTANT: This returns 0 on YES, 1 on NO.
#
confirm() {
    # call with a prompt string or use a default
    if [[ -z $1 ]]; then
        MESSAGE="Are you sure?"
    else
        MESSAGE="$1"
    fi
    read -r -p "${1:-$MESSAGE} [y/N]  " response
    case $response in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}


LAST_RESULT=""
#
# Executes a command and returns its
# exit code. Output is stored in
# LAST_RESULT.
#
execute_nice() {
    #
    # Quote the command
    #
    COMMAND="$1"

    #
    # If VERBOSE is not set, pipe
    # output to /dev/null
    #
    if [[ $VERBOSE -ne 0 ]]; then
        COMMAND="$COMMAND >/dev/null 2>&1"
    fi

    #
    # Execute the command in a subshell.
    #
    LAST_RESULT=$($COMMAND)

    #
    # Make sure the caller can find success/failure.
    #
    return $?
}

#
# A dumb wrapper for echo.
# If "SILENT" is set, we output nothing.
#
println() {
    if [[ $SILENT -le 1 ]]; then
        echo $1
    fi
}

#
# Echoes debug messages if DEBUG is set.
#
debug() {
    if [[ $DEBUG -ne 0 ]]; then
        println "$1"
    fi
}


#
# Restores the user's CWD and
# exits using the provided exit code.
#
exit_clean() {
    cd $EXECUTED_FROM
    exit $1
}

