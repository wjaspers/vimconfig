#!/bin/bash

#
# Hang on to the folder we started from.
#
EXECUTED_FROM=$(pwd)
LAST_RESULT=""

#
# Let bash output everything if we're in verbose mode.
# and we're trying to debug the script.
#
if [[ $VERBOSE -ne 0 && $DEBUG -ne 0 ]]; then
    set -x
fi

execute_nice() {
    COMMAND="$1"
    if [[ $VERBOSE -gt 0 ]]; then
        COMMAND="$COMMAND 2>&1"
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

println() {
    if [[ $SILENT -le 1 ]]; then
        echo $1
    fi
}

debug() {
    if [[ $DEBUG -ne 0 ]]; then
        println "$1"
    fi
}

exit_clean() {
    cd $EXECUTED_FROM
    exit $1
}

#
# Try to find vim
#
println "[sh]: Looking for package: vim"
execute_nice "command -v vim"
if [ $? -ne 0 ]; then
    println "Oops! VIM is not installed."
    println "You may be able to install it yourself with:"
    println "  sudo apt-get install vim"
    exit_clean 1
fi

#
# See if .vim already exists in the user's profile.
#
println "[sh]: Looking for a .vim user profile"
if [ -e "$HOME/.vim" ]; then
    println "Oops! A .vim folder already exists in your profile."
    println "  You may want to backup your folder first."
    exit_clean 1
fi

#
# See if a vimrc already exists in the user's profile.
#
println "[sh]: Looking for a .vimrc configuration"
if [ -e "$HOME/.vimrc" ]; then
    println "Oops! A .vimrc already exists in your profile."
    println "  You may want to backup for existing configuration first."
    exit_clean 1
fi

#
# Try to find git
#
println "[sh]: Looking for package: git"
execute_nice "command -v git"
if [ $? -ne 0 ]; then
    println "Oops! Git is not installed."
    println "You may be able to install it yourself with:"
    println "  sudo apt-get install git-core"
    exit_clean 1
fi

#
# Find out where the repo lives.
#
println "[GIT]: Looking for the root of the repository."
execute_nice "git rev-parse --show-toplevel"
REPO_HOME=$LAST_RESULT
cd $REPO_HOME

#
# Initialize all the bundles
#
println "[GIT]: Initializing submodules"
execute_nice "git submodule init"

#
# Synchronize all the bundles we use.
#
println "[GIT]: Updating submodules"
execute_nice "git submodule update"
if [ $? -ne 0 ]; then
    println "Oops! We couldn't download all the bundles."
    exit_clean 1
fi

#
# Set execute permissions on things in .bin
#
println "[sh]: Setting .bin scripts to executable."
execute_nice "chmod +x .bin/*"

#
# Link the repository to .vim/
#
println "[sh]: Creating symbolic link to .vim profile from repository."
cd $HOME
execute_nice "ln -sv $REPO_HOME $HOME/.vim"

#
# Now link the vimrc and we're done.
#
println "[sh]: Creating a .vimrc."
execute_nice "ln -sv $REPO_HOME/vimrc.dist $HOME/.vimrc"

#
# Return to the folder we started from
#
exit_clean 0
