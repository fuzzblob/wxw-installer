cmake_minimum_required(VERSION 3.10)

# Set your project name and version
set(PROJECT_NAME "wxInstaller" CACHE INTERNAL "Name of ${PROJECT_NAME} project")
set(PROJECT_VERSION 0.0.0 CACHE INTERNAL "Version of ${PROJECT_NAME} project")
project(${PROJECT_NAME} VERSION ${PROJECT_VERSION})

# Find wxWidgets package
find_package(wxWidgets REQUIRED COMPONENTS core base)

# If wxWidgets is found, set the required variables
if(wxWidgets_FOUND)
    include(${wxWidgets_USE_FILE})  # This includes necessary wxWidgets settings

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
    add_executable(${PROJECT_NAME} ${SRCS})
    # Link wxWidgets libraries to your target
    target_link_libraries(${PROJECT_NAME} ${wxWidgets_LIBRARIES})
    # Set any additional compiler flags
    target_compile_options(${PROJECT_NAME} PRIVATE ${wxWidgets_CXX_FLAGS})
    target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)
    # Set output directories for binaries
    set_target_properties(${PROJECT_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_CURRENT_SOURCE_DIR}/bin/"
        RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/bin/"
    )
endif()
