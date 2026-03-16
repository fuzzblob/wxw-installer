# wxw-installer

attempting a new way of installing [Ultraschall](https://ultraschall.fm/) podcasting modifications to the [REAPER](https://reaper.fm) Digital Audio Workstation.

- starting out development following [this guide](https://codezup.com/build-cpp-gui-application-wxwidgets-tutorial/)

# motivation

- unifying the code for Windows, Mac and Linux install experiences
- making the Utraschall install process more accessible to blind users
- making development of features such as support for portable installs easier to manage

# building

The `cmake/CPM.cmake` file should handle the **wxWidgets** dependency if not already installed via the system (install dev packages or use nix shell / flake).

depending on your system you can run `build.sh` or `build.bat` with optional parameters to generate and build the software to your liking.

### Windows specifics

When using the default **Ninja** toolchain on Windows and intending to use the MSBuild system, either run the script in a VS Developer Command Promp environment, or make sure to set the environment variable for `CC` (or the CMake cache entry `CMAKE_C_COMPILER`) as well as `CXX`(`CMAKE_CXX_COMPILER`) or else the project generation will fail.