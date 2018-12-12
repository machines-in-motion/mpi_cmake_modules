######################
# set up the project #
######################
cmake_minimum_required(VERSION 2.8.3)

project(cmake_modules)

# required to use std::shared_ptr in code
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wl,--no-as-needed")

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
