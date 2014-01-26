#!/bin/bash

DIRNAME=$(dirname $0)
source "$DIRNAME/lib/utils.sh"

#
# Try to find vim
#
debug "[sh]: Looking for package: vim"
execute_nice "command -v vim"
if [ $? -ne 0 ]; then
    debug "VIM is not installed."
    if confirm "Install \"vim\" now?"; then
        execute_nice "sudo apt-get install vim"
        if [[ $? -ne 0 ]]; then
            debug "There was a problem installing \"vim\"."
            exit_clean 1
        fi
    else
        println "You may be able to install it yourself with:"
        println "  sudo apt-get install vim"
        exit_clean 1
    fi
fi


#
# Try to find git
#
debug "[sh]: Looking for package: git"
execute_nice "command -v git"
if [ $? -ne 0 ]; then
    debug "Git is not installed."
    if confirm "Install \"git\" now?"; then
        execute_nice "sudo apt-get install git-core"
        if [[ $? -ne 0 ]]; then
            debug "There was a problem installing \"git\"."
            exit_clean 1
        fi
    else
        println "You may be able to install it yourself with:"
        println "  sudo apt-get install git-core"
        exit_clean 1
    fi
fi


#
# Find out where the repo lives.
#
debug "[GIT]: Looking for the root of the repository."
execute_nice "git rev-parse --show-toplevel"
REPO_HOME=$LAST_RESULT
cd $REPO_HOME


#
# See if .vim already exists in the user's profile.
#
TARGET_FOLDER="$HOME/.vim"
TARGET_OK=0
if [ -e $TARGET_FOLDER ]; then
    debug "Oops! A .vim folder already exists in your profile."
    if [ $TARGET_FOLDER = $REPO_HOME ]; then
        # Nothing to do later.
        TARGET_OK=0
    else
        if confirm "Backup your existing \".vim\" folder?"; then
            execute_nice "mv $TARGET_FOLDER $HOME/.vim.OLD"
        else
            println "You will need to move your \".vim\" folder when installation is complete."
            TARGET_OK=1
        fi
    fi
fi


#
# Initialize all the bundles
#
if confirm "Download all the bundles now?"; then
    debug "[GIT]: Updating submodules"
    execute_nice "git submodule update --init"
    if [ $? -ne 0 ]; then
        println "Oops! We couldn't download all the bundles."
        exit_clean 1
    fi
else
    println "You will need to manually install the required bundles."
    println "You can do this with:"
    println "   git submodule update --init"
fi


#
# Set execute permissions on things in .bin
#
if confirm "Set all \".bin\" scripts to executable?"; then
    debug "[sh]: Setting .bin scripts to executable."
    execute_nice "chmod +x .bin/*"
fi


#
# Link the repository to .vim/
#
debug "[sh]: Looking for $TARGET_FOLDER"
if [ $TARGET_OK -eq 0 ]; then
    if confirm "Symlink the repository to \".vim\"?"; then
        debug "[sh]: Creating symbolic link to .vim profile from repository."
        cd $HOME
        execute_nice "ln -sv $REPO_HOME $TARGET_FOLDER"
    else
        println "You will need to manually link or move the repository to $TARGET_FOLDER"
    fi
fi


#
# As the user if they want to create a .vimrc
#
TARGET_RC="$HOME/.vimrc"
TARGET_RC_OK=0

if confirm "Create a \".vimrc\" now?"; then
    #
    # See if a vimrc already exists in the user's profile.
    #
    debug "[sh]: Looking for a .vimrc configuration"
    if [ -e $TARGET_RC ]; then
        debug "A .vimrc already exists in your profile."
        if confirm "Backup your existing \".vimrc\"?"; then
            execute_nice "mv $TARGET_RC $HOME/.vimrc.OLD"
            println "Moved to $HOME/.vimrc.OLD"
        else
            TARGET_RC_OK=1
        fi
    fi


    #
    # Now copy the vimrc and we're done.
    #
    if [ $TARGET_RC_OK -eq 0 ]; then
        if confirm "Use the default \".vimrc\"?"; then
            debug "[sh]: Creating a .vimrc."
            execute_nice "cp $REPO_HOME/vimrc.dist $TARGET_RC"
        else
            execute_nice "touch $TARGET_RC"
            if [ $? -ne 0 ]; then
                println "Failed to create a \".vimrc\" in \"$HOME\"."
                exit_clean 1
            fi
            echo "pathogen#infect()" >> $TARGET_RC
        fi
    fi


    #
    # Prompt the user to edit their vimrc.
    #
    if confirm "Edit your \".vimrc\" now?"; then
	    # CAREFUL: Dont use execute_nice here.
       	vim $TARGET_RC
    fi
fi

println "Installation complete!"

#
# Return to the folder we started from
#
exit_clean 0
