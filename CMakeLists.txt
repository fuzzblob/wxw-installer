cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# Set your project name and version
set(PROJECT_NAME "wxInstaller" CACHE INTERNAL "Name of ${PROJECT_NAME} project")
set(PROJECT_VERSION 0.0.0 CACHE INTERNAL "Version of ${PROJECT_NAME} project")
project(${PROJECT_NAME} VERSION ${PROJECT_VERSION})

#
# setup code
#
file(GLOB_RECURSE HDRS
	include/*.h
	include/*.hpp
	src/*.h
	src/*.hpp
)
file(GLOB_RECURSE SRCS
	src/*.cpp
	src/*.c
)
# include header files
include_directories(
	src
)
# Add source files to executable
add_executable(${PROJECT_NAME} WIN32 ${SRCS})

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(wxBUILD_SHARED OFF)

# Find wxWidgets package
find_package(wxWidgets OPTIONAL COMPONENTS core base)
# If wxWidgets is found, set the required variables
if(wxWidgets_FOUND)
    # Link wxWidgets libraries to your target
    target_link_libraries(${PROJECT_NAME} PRIVATE ${wxWidgets_LIBRARIES})
    # Set any additional compiler flags
    # target_compile_options(${PROJECT_NAME} PRIVATE ${wxWidgets_CXX_FLAGS})
else()
	# alternatively use CPM to fetch the wxWidgets dependency
	set(CPM_SOURCE_CACHE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/.cpm-cache/")
	include(${CMAKE_SOURCE_DIR}/cmake/CPM.cmake)
	CPMAddPackage("gh:wxWidgets/wxWidgets@3.3.2")
    # Link wxWidgets libraries to your target
    target_link_libraries(${PROJECT_NAME} PRIVATE wx::core wx::base)
endif()

include(${wxWidgets_USE_FILE})  # This includes necessary wxWidgets settings

# Set any additional compiler flags
target_compile_options(${PROJECT_NAME} PRIVATE ${wxWidgets_CXX_FLAGS})
	
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)
# Set output directories for binaries
set_target_properties(${PROJECT_NAME} PROPERTIES
	RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/bin/"
	RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/bin/"
)