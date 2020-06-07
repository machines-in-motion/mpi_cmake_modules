#
# @file CMakeLists.txt
# @author Maximilien Naveau (maximilien.naveau@gmail.com)
# @copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.
# @license License BSD-3 clause
# @date 2019-05-06
#
# @brief This file allow the build of this package using cmake
#

######################
# set up the project #
######################
cmake_minimum_required(VERSION 2.8.3)

project(mpi_cmake_modules)

# required to use std::shared_ptr in code and to link the python bindings
if(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-as-needed")
endif()
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Wextra")

# ensuring path to libraries are set during install
set(CMAKE_SKIP_BUILD_RPATH  FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)

###########################
# depend on catkin macros #
###########################
find_package(catkin REQUIRED)


# Define some path variables for this package
set(MPI_CMAKE_MODULES_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})
set(MPI_CMAKE_MODULES_CMAKE_DIR ${MPI_CMAKE_MODULES_ROOT_DIR}/cmake)
set(MPI_CMAKE_MODULES_RESOURCES_DIR ${MPI_CMAKE_MODULES_ROOT_DIR}/resources)
set(MPI_CMAKE_MODULES_SCRIPTS_DIR ${MPI_CMAKE_MODULES_ROOT_DIR}/scripts)

############################
# Get all the files needed #
############################

file(GLOB cmake_files RELATIVE ${PROJECT_SOURCE_DIR}/cmake cmake/*.cmake)

foreach(cmake_file ${cmake_files})
  include(cmake/${cmake_file})
endforeach()

##############################
# manage python file install #
##############################
catkin_python_setup()

##########################################
# export the package as a catkin package #
##########################################
catkin_package(
  CFG_EXTRAS
    ${MPI_CMAKE_MODULES_RESOURCES_DIR}/package_paths.cmake
    ${cmake_files}
)

##########################################
# Install the interesting resource files #
##########################################
configure_file(
    ${MPI_CMAKE_MODULES_RESOURCES_DIR}/_clang-format
    ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_PYTHON_DESTINATION}/_clang-format
    @ONLY IMMEDIATE
)

##########################################################
# Copy the executable scripts to the corresponding place #
##########################################################

configure_file(${MPI_CMAKE_MODULES_SCRIPTS_DIR}/mpi_clang_format
               ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}/mpi_clang_format
               COPYONLY)

##########################
# building documentation #
##########################
build_documentation()