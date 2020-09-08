#
# Copyright (c) 2019, New York University and Max Planck Gesellschaft.
# License BSD-3 clause
#

#.rst:
#
# Call macros by default for *all* packages importing mpi_cmake_modules.
# This file includes os-detection to determine the os the code is built on.
# It detects and import xenomai if needed.
# And generate the *doc* target in order to build the documentation.
# 

include(${CMAKE_CURRENT_LIST_DIR}/os_detection.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/xenomai.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/documentation.cmake)

#
# Standard header for all packages
#

# required to link the python bindings of the DG entities properly.
if(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-as-needed")
endif()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")

# ensuring path to libraries are set during install
set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)

# defining -DXENOMAI, -DRT_PREEMPT or -DNON_REAL_TIME
# based on 'uname -a' command
define_os()

# if os is xenomami, setting up Xenomai_LIBS, calling
# xeno-config, and adding correct directory for include
# and linkage
if(CURRENT_OS STREQUAL "xenomai")
  setup_xenomai()
else()
  set(Xenomai_LIBS pthread edit curses nsl glut GL GLU X11 Xmu m)
endif()

# All package have a doc target. This target may do nothing.
create_doc_target()