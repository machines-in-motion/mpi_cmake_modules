#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

#
# set up the project
#
cmake_minimum_required(VERSION 3.5)

project(mpi_cmake_modules)

# required to use std::shared_ptr in code and to link the python bindings
if(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-as-needed")
endif()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")

# Use C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED on)

# ensuring path to libraries are set during install
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)

#
# depend on ament macros
#
find_package(ament_cmake REQUIRED)
find_package(ament_cmake_python REQUIRED)
find_package(ament_lint_auto REQUIRED)
find_package(ament_lint_common REQUIRED)


# Define some path variables for this package
set(MPI_CMAKE_MODULES_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(MPI_CMAKE_MODULES_CMAKE_DIR ${MPI_CMAKE_MODULES_ROOT_DIR}/cmake)
set(MPI_CMAKE_MODULES_RESOURCES_DIR ${MPI_CMAKE_MODULES_ROOT_DIR}/resources)
set(MPI_CMAKE_MODULES_SCRIPTS_DIR ${MPI_CMAKE_MODULES_ROOT_DIR}/scripts)

#
# Get all the files needed
#
file(
  GLOB cmake_files
  RELATIVE ${PROJECT_SOURCE_DIR}
  cmake/*.cmake)
# Include each files for testing.
foreach(cmake_file ${cmake_files})
  include(${cmake_file})
endforeach()

#
# manage python file install
#
ament_python_install_package(${PROJECT_NAME} PACKAGE_DIR python/${PROJECT_NAME})

#
# install the CMake find modules at the good place
#
install(
  DIRECTORY cmake/python cmake/boost cmake/xenomai
  DESTINATION share/${PROJECT_NAME}/cmake)

#
# Install the executable scripts in bin
#
install(
  FILES ${MPI_CMAKE_MODULES_SCRIPTS_DIR}/mpi_clang_format
  DESTINATION bin
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

#
# building documentation
#
add_documentation()

#
# export the package as a ament package
#
ament_package(
  CONFIG_EXTRAS ${MPI_CMAKE_MODULES_RESOURCES_DIR}/package_paths.cmake.in
  ${cmake_files})
