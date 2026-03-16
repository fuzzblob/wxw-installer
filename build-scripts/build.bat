@echo off

echo Beginning build script...

rem #################################################################

rem set defaults
set BUILD="TRUE"
set CLEAR="FALSE"
goto :parse

rem #################################################################

rem ### help for instructing the user
:show_help
echo.
echo ===== Build Script =============================================
echo.
echo This script creates a build directory, runs CMake
echo and then invokes the appropriate build tool.
echo.
echo Usage:  build.bat [options]
echo.
echo Options:
echo    -n, --ninja          - use Ninja generator (default)
echo    -vs, --msvc          - use Visual Studio 2022 generator
echo    -c, --clear, --clean - Clear the build and bin directories
echo    -g, --generate-only  - Run CMake generation only; skip build
echo    -h, --help           - Show this help message and exit
echo.
echo Examples:
echo    build.bat                   uses Ninja, builds immediately
echo    build.bat --msvc            generate VS Solution
echo    build.bat --generate-only   only run CMake, no build
echo.
echo ================================================================
echo.
exit /b 0

rem #################################################################

rem ### parse flags
:parse
rem ### print help and exit
if /I "%~1"=="--help"		goto :show_help
if /I "%~1"=="-h"			goto :show_help
rem ### Ninja is considered default
if /I "%~1"=="-n"			goto :set_ninja
if /I "%~1"=="--ninja" (
	:set_ninja
    call :set_generator Ninja project_ninja
    shift
    goto :parse
)
rem ### MS Visual Studio
if /I "%~1"=="-vs"			goto :set_msvc
if /I "%~1"=="--msvc" (
	:set_msvc
	call :set_generator MSVC project_MSVC
    shift
    goto :parse
)
rem ### generate only - don't build
if /I "%~1"=="-g"			goto :set_generate
if /I "%~1"=="--no-build"	goto :set_generate
if /I "%~1"=="--generate-only" (
	:set_generate
	echo "generate-only" mode enabled / no building of binary
	set BUILD="FALSE"
    shift
    goto :parse
)
rem ### clear or make bin directory
if /I "%~1"=="-c"			goto :clean
if /I "%~1"=="--clear"		goto :clean
if /I "%~1"=="--clean" (
	:clean
	echo "clean" mode enabled
	set CLEAR="TRUE"
    shift
    goto :parse
)
rem ### empty argument
if  /I "%~1"=="" (
	if not defined GENERATOR (
		rem ### define default generator
		call :set_generator Ninja project_ninja
		echo Had to set "GENERATOR" to default
	)
	goto :run
)
rem ### error exit out
echo Can't handle unknown option: "%~1"
exit /b 1

rem ### setting CMake generator
:set_generator
rem %~1 = generator name
set "GENERATOR=%~1"
rem %~2 = build directory
set "BUILD_DIR=%~2"
echo Set "GENERATOR" to "%GENERATOR%"
exit /b 0

rem #################################################################

:run
rem ### clean or create a build folder
if /I %CLEAR%=="TRUE" (
	echo clearing build and bin diretories
	if exist "%BUILD_DIR%" rmdir /S /Q "%BUILD_DIR%"
	if exist bin rmdir /S /Q ../bin
)
mkdir "%BUILD_DIR%"

rem ### CMake configuration
set CM="C:\Program Files\CMake\bin\cmake.exe"
rem ### enter build dir
pushd "%BUILD_DIR%"
echo entering "%BUILD_DIR%"
echo beginning project generation
echo.
rem ### call generation step
if "%GENERATOR%"=="Ninja" (
    call :generate_ninja
) else if "%GENERATOR%"=="MSVC" (
    call :generate_msvc
) else (
	echo Unknown generator: "%GENERATOR%"
	exit /b 1
)
rem ### exit build dir
popd
exit /b 0

rem #################################################################

:generate_ninja
rem ### call cmake
%CM% -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -Wdev -S ../../
echo.
echo CMake completed generating project
if %BUILD%=="TRUE" (
	rem ### execute build tool
	echo beginning build:
	echo.
	ninja.exe -d stats
)
exit /b 0
:generate_msvc
rem ### set VS tool chain path
set VS150COMNTOOLS = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\"
rem ### call cmake
%CM% -G "Visual Studio 17 2022" -Wdev -S ../../
echo.
echo CMake completed generating project
if %BUILD%=="TRUE" (
	rem ### find the solution file inside %BUILD_DIR%
	for %%S in ("%BUILD_DIR%\*.sln") do set "SLN=%%~nxS"
	rem ### build the solution
	echo beginning build:
	echo.
	MSBuild.exe "%SLN%" -p:Configuration=Debug
	exit /b 0
)
exit /b 0

rem #################################################################
