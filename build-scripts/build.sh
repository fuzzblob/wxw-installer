#!/bin/sh

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

CMake build script

Options:
  -h --help           Show this screen.
  -m --make           Generate Unix Makefiles (default)
  -n --ninja          Generate Ninja project configuration
     --gcc            Compile with GNU Compiler Collection
     --clang          Compile with Clang Compiler
  -g --generate-only  Only generate and don't invoke the build step
  -c --clean          Clean build directory before generating
                      (must be passed after generator argument)

HEREDOC
}

_generate() {
  echo "CMake generating Release build:"
  # invoke CMake

  case $3 in
    clang++)
      echo "invoking CMake for Clang"
      MAKE_RULES_OVERRIDE="$(dirname $0)/ClangOverrides.txt"
      #-D_CMAKE_TOOLCHAIN_PREFIX=llvm-
      TOOLCHAIN_FILE="$(dirname $0)/clang.cmake"
      ;;
    *)
      echo "Unknown COMPILER '$3'"
      ;&
    g++)
      echo "invoking CMake for GCC"
      TOOLCHAIN_FILE="$(dirname $0)/gcc.cmake"
      #cmake -G "$GENERATOR" -DCMAKE_BUILD_TYPE=Release -S ../.. -B .
      ;;
  esac

  cmake -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" -DCMAKE_USER_MAKE_RULES_OVERRIDE="$MAKE_RULES_OVERRIDE" -G "$GENERATOR" -DCMAKE_BUILD_TYPE=Release -S ../.. -B .

  # check whether to invoke build tool
  if [ "$1" != "true" ]; then
    echo "compiling Release build of wxWidgets Installer:"
    # parse arguments
    case $2 in
      "Ninja")
        ninja -j $(nproc) -d stats
        ;;
      "Unix Makefiles")
        MAKEFLAGS=-j$(nproc)
        make
        ;;
      *)
        echo "Unknown GENERATOR $2"
        return 1
        ;;
    esac
  fi
  echo ""
  echo "built sucessfully!"
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
    # parse arguments
    for i in "$@"; do
      case $i in
        -c|--clean)
          if [ -v BUILD_DIR ]; then
            if [[ -d "$BUILD_DIR" ]]; then
              echo "removing existing build dir: $BUILD_DIR"
              rm -rf "$BUILD_DIR"
            fi
          else
            echo "the build type must be passed before the \"-c\" or \"--clean\" option."
            echo "skipped cleaning the build directory."
          fi
          shift
          ;;
        -m|--make)
          GENERATOR="Unix Makefiles"
          BUILD_TYPE="project_make"
          BUILD_DIR="$(dirname $0)/$BUILD_TYPE"
          shift
          ;;
        -n|--ninja)
          GENERATOR="Ninja"
          BUILD_TYPE="project_ninja"
          BUILD_DIR="$(dirname $0)/$BUILD_TYPE"
          shift
          ;;
        -g|--generate-only)
          GENERATE_ONLY="true"
          shift
          ;;
        -h|--help)
          _print_help
          return 0
          ;;
        --gcc)
          COMPILER="g++"
          shift
          ;;
        --clang)
          COMPILER="clang++"
          shift
          ;;
        -*|--*)
          echo "error: Unknown option $i"
          exit 1
          ;;
        *)
          ;;
      esac
    done
    # check parameters
    if [ ! -v GENERATOR ]; then
      echo "no GENERATOR set. setting default options..."
      # set defaults
      GENERATOR="Unix Makefiles"
      BUILD_TYPE="project_make"
      BUILD_DIR="$(dirname $0)/$BUILD_TYPE"
    fi

    if [ -v BUILD_DIR ]; then
      echo "setting up build dir: $BUILD_DIR"
      mkdir "$BUILD_DIR" -p
    else
      echo "the build directory is not specified. aborting..."
      return 1
    fi
    cd "$BUILD_DIR"
    _generate "$GENERATE_ONLY" "$GENERATOR" "$COMPILER"
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
