#
# @file global_calls.cmake
# @author Vincent Berenz / Maximilien Naveau
# @copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.
# @license License BSD-3 clause
# @date 2020-01-06
# 
# @brief call macros for all catkin packages importing mpi_cmake_modules
# 

include(${CMAKE_CURRENT_LIST_DIR}/os_detection.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/setup_xenomai.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/documentation.cmake)

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