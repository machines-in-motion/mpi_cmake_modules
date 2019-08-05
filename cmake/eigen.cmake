#
# @file eigen.cmake
# @author Maximilien Naveau (maximilien.naveau@gmail.com)
# @copyright Copyright (c) 2019, New York University and Max Planck Gesellschaft.
# @license License BSD-3 clause
# @date 2019-05-06
# 
# @brief This file is copied/inspired from
# https://github.com/jrl-umi3218/jrl-cmakemodules/blob/master/eigen.cmake
# 

# SEARCH_FOR_EIGEN
# -----------------
#
# This macro gets eigen include path from pkg-config file, and adds it include directories.
# If there is no pkg-config for Eigen, we fall back to a manual search.
#
# If no version requirement argument is passed to the macro, it looks for the 
# variable Eigen_REQUIRED. If this variable is not defined before calling
# the method SEARCH_FOR_EIGEN, the minimum version requirement is 3.0.0 by default.
MACRO(SEARCH_FOR_EIGEN)
  SET(_Eigen_FOUND 0)
  IF(${ARGC} GREATER 0)
    SET(Eigen_REQUIRED ${ARGV0})
  ELSEIF(NOT Eigen_REQUIRED)
    SET(Eigen_REQUIRED "eigen3 >= 3.0.0")
  ENDIF()

  # looking for .pc
  PKG_CHECK_MODULES(_Eigen ${Eigen_REQUIRED})

  IF(${_Eigen_FOUND})
    SET(${PROJECT_NAME}_CXX_FLAGS "${${PROJECT_NAME}_CXX_FLAGS} ${_Eigen_CFLAGS_OTHER}")
    SET(${PROJECT_NAME}_LINK_FLAGS "${${PROJECT_NAME}_LINK_FLAGS} ${_Eigen_LDFLAGS_OTHER}")

    INCLUDE_DIRECTORIES(SYSTEM ${_Eigen_INCLUDE_DIRS} )
    _ADD_TO_LIST(_PKG_CONFIG_REQUIRES "${Eigen_REQUIRED}" ",")
  ELSE()
    # fallback: search for the signature_of_eigen3_matrix_library file
    FIND_PATH(Eigen_INCLUDE_DIR NAMES signature_of_eigen3_matrix_library
      PATHS
      ${CMAKE_INSTALL_PREFIX}/include
      PATH_SUFFIXES eigen3 eigen
    )
    INCLUDE_DIRECTORIES(SYSTEM ${Eigen_INCLUDE_DIR})
    PKG_CONFIG_APPEND_CFLAGS(-I"${Eigen_INCLUDE_DIR}")
  ENDIF()
ENDMACRO(SEARCH_FOR_EIGEN)

# _ADD_TO_LIST LIST VALUE
# -------------
#
# Add a value to a comma-separated list.
#
# LIST		: the list.
# VALUE		: the value to be appended.
# SEPARATOR	: the separation symol.
#
MACRO(_ADD_TO_LIST LIST VALUE SEPARATOR)
  IF("${${LIST}}" STREQUAL "")
    SET(${LIST} "${VALUE}")
  ELSE("${${LIST}}" STREQUAL "")
    IF(NOT "${VALUE}" STREQUAL "")
      SET(${LIST} "${${LIST}}${SEPARATOR} ${VALUE}")
    ENDIF(NOT "${VALUE}" STREQUAL "")
  ENDIF("${${LIST}}" STREQUAL "")
ENDMACRO(_ADD_TO_LIST LIST VALUE)
