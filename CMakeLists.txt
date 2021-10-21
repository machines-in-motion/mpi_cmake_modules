#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
#
# License BSD-3 clause
#

#
# set up the project
#
cmake_minimum_required(VERSION 3.10.2)

project(mpi_cmake_modules VERSION 1.0.0)

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
include(cmake/global_calls.cmake)
include(cmake/get_python_install_dir.cmake)
include(cmake/documentation.cmake)
include(cmake/install_scripts.cmake)
include(cmake/generate_cmake_package.cmake)
include(cmake/find_modules.cmake)

#
# Register the mpi_cmake_module resource files install location.
#
install(DIRECTORY resources DESTINATION share/${PROJECT_NAME})

#
# manage python file install
#
get_python_install_dir(python_install_dir)
install(
  DIRECTORY python/${PROJECT_NAME}
  DESTINATION "${python_install_dir}"
  PATTERN "*.pyc" EXCLUDE
  PATTERN "__pycache__" EXCLUDE)

#
# install the CMake find modules at the good place
#
install(DIRECTORY ${PROJECT_SOURCE_DIR}/cmake/
        DESTINATION share/${PROJECT_NAME}/cmake)

#
# Install the executable scripts in bin
#
# install the scripts.
# cmake-format: off
install(PROGRAMS
  scripts/mpi_cpp_format
  scripts/mpi_python_format
  scripts/mpi_cmake_format
  scripts/mpi_code_format
  scripts/mpi_doc_build
  DESTINATION bin)
# cmake-format: on
# install their configuration files.
install(DIRECTORY resources DESTINATION ${python_install_dir}/${PROJECT_NAME})

#
# building documentation
#
add_documentation()

#
# put the cmake files at the right place
#
generate_cmake_package(SKIP_TARGET_EXPORT)
