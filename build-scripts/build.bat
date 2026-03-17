@echo off

rem #################################################################
rem #
rem #    (c) 2026 - Maris Tammik
rem #
rem #################################################################

echo.
rem ###### set defaults #############################################
set BUILD="TRUE"
set CLEAR="FALSE"
rem ### reset generator settings
set GENERATOR=
set BUILD_DIR=
rem ### jump to parsing
goto :parse

rem ###### Help Section #############################################
:show_help
rem ### help for instructing the user
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
echo    build.bat --generate-only   only run CMake (Ninja), no build
echo.
echo ================================================================
exit /b 0

rem ###### Argument Parsing #########################################
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
	echo ----- "generate-only" mode enabled / no building of binary
	set BUILD="FALSE"
    shift
    goto :parse
)
rem ### clear or make bin directory
if /I "%~1"=="-c"			goto :clean
if /I "%~1"=="--clear"		goto :clean
if /I "%~1"=="--clean" (
	:clean
	echo ----- "clean" mode enabled
	set CLEAR="TRUE"
    shift
    goto :parse
)
rem ### empty argument
if  /I "%~1"=="" (
	shift
	if not defined GENERATOR (
		:set_default
		rem ### define default generator
		call :set_generator Ninja project_ninja
	) else if "%GENERATOR%"=="" (
		rem ### handle defined but empty generator
		goto :set_default
	) else (
		rem ### empty argument assumed to be the last
		goto :run
	)
) else (
	rem ### error parsing unknown argument
	echo.
	echo ----- Build script error!
	echo ----- Can't handle unknown option: "%~1"
	rem ### exit out
	exit /b 1
)
rem ### all possible arguments handeled
goto :run

rem ### setting CMake generator
:set_generator
rem %~1 = generator name
set "GENERATOR=%~1"
rem %~2 = build directory
set "BUILD_DIR=%~2"
echo ----- Set "GENERATOR" to "%GENERATOR%"
exit /b 0

rem #################################################################

:run
echo.
echo ===== Running Build Script... ==================================
echo.
rem ### clean or create a build folder
call :setup_dir
rem ### enter build dir
pushd "%BUILD_DIR%"
rem ### call generation step
call :generate_step
rem ### call build step
if %ERRORLEVEL% equ 0 (
	if %BUILD%=="TRUE" (
		call :build_step
	)
) else (
	echo ----- CMake task reported a failure. Exit code was: %ERRORLEVEL%
	echo ----- Skipping build step
)
rem ### exit build dir
popd
rem ### printing final message
echo.
echo ===== Exiting Build Script =====================================
echo.
exit /b %ERRORLEVEL%

rem ###### build dir setup ##########################################

:setup_dir
rem ### clean build and bin folder
if /I %CLEAR%=="TRUE" (
	echo ----- clearing build and bin diretories
	if exist "%BUILD_DIR%" rmdir /S /Q "%BUILD_DIR%"
	if exist ../bin rmdir /S /Q ../bin
)
if not exist "%BUILD_DIR%" (
	mkdir "%BUILD_DIR%"
)
exit /b 0

rem ###### CMake project generation #################################

:generate_step
rem ### CMake configuration
set CM="C:\Program Files\CMake\bin\cmake.exe"
echo ----- Beginning CMake project generation with "%GENERATOR%"
echo.
if /I "%GENERATOR%"=="Ninja" (	
	rem ### call cmake
	%CM% -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -Wdev -S ../../
) else if "%GENERATOR%"=="MSVC" (
	rem ### set VS tool chain path
	set VS150COMNTOOLS = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\"
	rem ### call cmake
	%CM% -G "Visual Studio 17 2022" -Wdev -S ../../
	echo.
	echo ----- CMake completed generating project
) else (
	echo ----- Unknown generator: "%GENERATOR%"
	exit /b 1
)
rem ### check CMake status
echo.
if %ERRORLEVEL% equ 0 (
	echo ----- CMake completed generating project
	exit /b 0
)
echo ----- CMake task reported a failure. Exit code was: %ERRORLEVEL%
exit /b %ERRORLEVEL%

rem ###### executing build / toolchain ##############################

:build_step
rem ### execute build tool
echo ----- Beginning build phase
echo.
if /I "%GENERATOR%"=="Ninja" (
	ninja.exe -d stats
) else if "%GENERATOR%"=="MSVC" (
	rem ### find the solution file inside %BUILD_DIR%
	for %%S in ("%BUILD_DIR%\*.sln") do set "SLN=%%~nxS"
	rem ### build the solution
	echo ----- beginning build:
	echo.
	MSBuild.exe "%SLN%" -p:Configuration=Debug
) else (
	echo ----- Unknown generator: "%GENERATOR%"
	exit /b 1
)
rem ### check toolchain status
echo.
if %ERRORLEVEL% equ 0 (
	echo ----- Build completed sucessfully
	exit /b 0
)
echo ----- Build task reported a failure. Exit code was: %ERRORLEVEL%
exit /b %ERRORLEVEL%

rem #################################################################
exit /b 0