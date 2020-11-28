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
# Register the mpi_cmake_moudle resource files install location.
#
install(DIRECTORY resources DESTINATION share/${PROJECT_NAME})
ament_index_register_resource(
  resource_files CONTENT
  ${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME}/resources/)

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
# find the folders
macro(SUBDIRLIST result curdir)
  file(
    GLOB children
    RELATIVE ${curdir}
    ${curdir}/*)
  set(dirlist "")
  foreach(child ${children})
    if(IS_DIRECTORY ${curdir}/${child})
      list(APPEND dirlist cmake/${child})
    endif()
  endforeach()
  set(${result} ${dirlist})
endmacro()
subdirlist(cmake_dirs ${PROJECT_SOURCE_DIR}/cmake)
install(DIRECTORY ${cmake_dirs} DESTINATION share/${PROJECT_NAME}/cmake)

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
ament_package(CONFIG_EXTRAS ${cmake_files})
