vimconfig
=========

## Synopsis
A simple repository for cloning my vim configuration across multiple machines. Use as you like.

## Installation

### Manual Installation
1. Clone the repository.
2. Clone the submodules.
   1. `git submodule init`
   2. `git submodule update`
3. Setup your `.vimrc`
   * Use my vimrc: `ln -sv vimrc.dist ~/.vimrc`
   * Use my vimrc, and change it to meet your needs: `cp vimrc.dist ~/.vimrc`

### Scripted Installation
1. Clone the repository to a location of your choosing.
2. Run `./.bin/install.sh`
3. Follow the prompts and enjoy!

### Installation Notes
* Requires `git`
* Requires `vim`
* Requires `npm` + `nodejs`
* Requires the `sh` shell
  * Most `*nix` systems are distributed with `sh` so you should have no problem running this.
* Can prompt to install `git`, `vim`, and `npm`.
* If you have an existing `.vim` profile and `.vimrc`, the installer will help back them up.
