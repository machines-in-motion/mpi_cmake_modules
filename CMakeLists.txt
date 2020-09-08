#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

#
# set up the project
#
cmake_minimum_required(VERSION 3.10.2)

project(mpi_cmake_modules)

# Using C++17
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

#
# dependencies
#

# CMake ament macros.
find_package(ament_cmake REQUIRED)
find_package(ament_cmake_python REQUIRED)

#
# Define some path variables for this package.
#
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
install(DIRECTORY cmake/python cmake/boost cmake/xenomai
        DESTINATION share/${PROJECT_NAME}/cmake)

#
# Install the executable scripts in bin
#
install(
  FILES ${MPI_CMAKE_MODULES_SCRIPTS_DIR}/mpi_clang_format
  DESTINATION bin
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)
install(FILES ${MPI_CMAKE_MODULES_RESOURCES_DIR}/_clang-format
        DESTINATION ${PYTHON_INSTALL_DIR}/${PROJECT_NAME})

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
