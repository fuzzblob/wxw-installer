#!/bin/sh

#!/usr/bin/env bash

set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT

###############################################################################
# Program Functions
###############################################################################

_print_help() {
  cat <<HEREDOC

build script

Run without arguments to build linux make files.

Usage:
  ${_ME} -h | --help

Options:
  -h --help       Show this screen.
  -c --clean      Clean build directory befor generating
  -g --generate   Only generate and don't compile / build the project

HEREDOC
}

_setup_folder() {
  echo "setting up build dir: $BUILD_DIR"
  mkdir "$1" -p
  return 0
}

_generate() {
  echo "CMake generating Release build:"
  cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -S ../.. -B .
  return 0
}

_build() {
  echo "compiling Release build of wxWidgets Installer:"
  make
  return 0
}

###############################################################################
# Main Function
###############################################################################

_main() {
  if [[ "${1:-}" =~ ^-h|--help$  ]]; then
    _print_help
    return 0
  else
    SCRIPT_DIR=$(dirname "$0")
    BUILD_TYPE="build_make"
    BUILD_DIR="$SCRIPT_DIR/$BUILD_TYPE"
    if [[ "${1:-}" =~ ^-c|--clean$  ]]; then
      if [[ -d "$BUILD_DIR" ]]; then
        echo "removing existing build dir: $BUILD_DIR"
        rm -rf "$BUILD_DIR"
      fi
    fi
    _setup_folder "$BUILD_DIR"
    cd "$BUILD_DIR"
    _generate
    if [[ "${1:-}" =~ ^-g|--generate$  ]]; then
      _build
    fi
    cd ..
    return 0
  fi
  return 1
}

###############################################################################
# Main execution
###############################################################################

# Call `_main` after everything has been defined.
_main "$@"

trap - DEBUG
trap - EXIT
