cmake_minimum_required(VERSION 3.10)

# Set your project name and version
project(MyApp VERSION 0.0.0)

# Find wxWidgets package
find_package(wxWidgets REQUIRED COMPONENTS core base)

# If wxWidgets is found, set the required variables
if(wxWidgets_FOUND)
    include(${wxWidgets_USE_FILE})  # This includes necessary wxWidgets settings

    # Add your executable target
    add_executable(MyApp src/MyApp.cpp)

    # Link wxWidgets libraries to your target
    target_link_libraries(MyApp ${wxWidgets_LIBRARIES})

    # Set any additional compiler flags
    target_compile_options(MyApp PRIVATE ${wxWidgets_CXX_FLAGS})
endif()
