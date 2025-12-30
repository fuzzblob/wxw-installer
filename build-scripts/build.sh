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
  -m --make           generate Unix Makefiles (default)
  -n --ninja          generate Ninja project configuration
  -g --generate-only  Only generate and don't invoke the build step
  -c --clean          Clean build directory before generating
                      (must be passed after generator argument)

HEREDOC
}

_generate() {
  echo "CMake generating Release build:"
  # invoke CMake
  cmake -G "$GENERATOR" -DCMAKE_BUILD_TYPE=Release -S ../.. -B .
  # check whether to invoke build tool
  if [ "$1" != "true" ]; then
    echo "compiling Release build of wxWidgets Installer:"
    # parse arguments
    case $2 in
      "Ninja")
        ninja -d stats
        ;;
      "Unix Makefiles")
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
          shift # past argument=value
          ;;
        -m|--make)
          GENERATOR="Unix Makefiles"
          BUILD_TYPE="project_make"
          BUILD_DIR="$(dirname $0)/$BUILD_TYPE"
          shift # past argument=value
          ;;
        -n|--ninja)
          GENERATOR="Ninja"
          BUILD_TYPE="project_ninja"
          BUILD_DIR="$(dirname $0)/$BUILD_TYPE"
          shift # past argument=value
          ;;
        -g|--generate-only)
          GENERATE_ONLY="true"
          shift # past argument=value
          ;;
        -h|--help)
          _print_help
          return 0
          ;;
        -*|--*)
          echo "Unknown option $i"
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
    _generate "$GENERATE_ONLY" "$GENERATOR"
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
