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

############################
# Get all the files needed #
############################

file(GLOB cmake_files RELATIVE ${PROJECT_SOURCE_DIR}/cmake cmake/*.cmake)

foreach(cmake_file ${cmake_files})
  include(cmake/${cmake_file})
endforeach()

##########################################
# export the package as a catkin package #
##########################################
catkin_package(
  CFG_EXTRAS ${cmake_files}
)

##########################
# building documentation #
##########################
build_doxygen_documentation()