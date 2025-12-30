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
    #target_include_directories(${PROJECT_NAME}
    include_directories(
        src
    )

    # Add your executable target
    add_executable(${PROJECT_NAME} src/MyApp.cpp)

    # Link wxWidgets libraries to your target
    target_link_libraries(${PROJECT_NAME} ${wxWidgets_LIBRARIES})

    # Set any additional compiler flags
    target_compile_options(${PROJECT_NAME} PRIVATE ${wxWidgets_CXX_FLAGS})
endif()
