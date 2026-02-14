# ZSH

ZSH configuration files

## Documentation

Official documentation can be found [here](https://zsh.sourceforge.io/Intro/intro_toc.html)

## Usage

The order of sourced files is the following:

1. `.zshenv`: sourced on every shell invocation, sets important environment variables
2. `.zshrc`: sourced in interactive shells, sets up aliases, functions, options,
etc.
3. `.zlogin`: sourced in login shells, sets the terminal type and runs external
commands
